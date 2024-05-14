

(* ::Section::Closed:: *)
(*DownloadBigQuantityArraySpan*)


(* DownloadBigQuantityArraySpan: goal is to download a span of bytes from the big quantity array partition *)

DownloadBigQuantityArraySpan[myObject_, myBigQAField_Symbol, myStartPosition_Integer, myStopPosition_Integer, myOps:OptionsPattern[]]:=Module[
	{},

	(* pass to BigQuantityArrayParser with proper options *)
	BigQuantityArraySpan[myObject, myBigQAField, myStartPosition, myStopPosition, FileLocation->Cloud]
];


(* ::Section::Closed:: *)
(*DownloadBigQuantityArraySpan*)


(* Stream parser for big quantity arrays *)
DefineOptions[
	BigQuantityArraySpan,
	Options :> {
		{BigQuantityArrayByteLimit -> Quantity[5, "GiB"], UnitsP["Bytes"], "The memory limit for each chunk in bytes."},
		{FileLocation -> Local, Alternatives[Local, Cloud], "The location of the file that will be parsed to get the span. The Local option will download the file from S3, if not already done so, and the Cloud option will download the span directly from S3."}
	}
];

(* Messages *)
BigQuantityArraySpan::RequestTooLarge = "The number of bytes requested is larger than the maximum memory limit, `1`, which is set by the BigQuantityArrayByteLimit option.";
BigQuantityArraySpan::InvalidField = "The requested field, `1`, is not a BigQuantityArray field.";
BigQuantityArraySpan::HTTPError = "Requesting the input span resulted in an HTTP error, `1`. This is usually because the requested indices are larger than the stored data object.";
BigQuantityArraySpan::InvalidSpan = "The starting element index, `1`, is larger than the total number of elements detected in the file. Choose a smaller starting position and re-run.";
BigQuantityArraySpan::IndexError = "The starting index, `1`, is larger than the ending index, `2`. This cannot be used to request information read binary spans. Make sure the starting index is smaller than the ending index.";
(* TODO: make the rest of the messages *)


(* main overload *)
BigQuantityArraySpan[myObject_, myBigQAField_Symbol, myStartPosition_Integer, myStopPosition_Integer, myOps:OptionsPattern[]]:=Module[
	{
		type, fieldDef, key, bucket, response,
		locationOption, byteLimit, unitlessByteLimit, typeDef
	},

	(* check if start is larger than stop and return error if true *)
	If[TrueQ[myStartPosition>myStopPosition],
		Message[BigQuantityArraySpan::IndexError, myStartPosition, myStopPosition];
		Return[$Failed]
	];

	(* first check if the field is in fact a big quantity array *)
	type = Download[myObject, Type];
	typeDef = LookupTypeDefinition[type];
	fieldDef = Lookup[Lookup[typeDef, ECL`Fields], myBigQAField];

	(* if it's not, then throw an error and exit *)
	If[Not[MatchQ[Lookup[fieldDef, Class], BigQuantityArray]],
		Message[BigQuantityArraySpan::InvalidField, myBigQAField];
		Return[$Failed]
	];

	(* make the constellation request to get the s3 blob for the bigqa *)
	response = requestBigQABlob[myObject, myBigQAField];

	(* parse the response for the key *)
	{bucket, key} = getS3BucketAndKey[response, myBigQAField];

	(* extract options *)
	locationOption = OptionDefault[OptionValue[FileLocation]];
	byteLimit = OptionDefault[OptionValue[BigQuantityArrayByteLimit]];

	(* check if total request length is smaller than byte limit *)
	unitlessByteLimit = Unitless@Convert[byteLimit, "Bytes"];
	If[TrueQ[(myStopPosition - myStartPosition + 1) >= unitlessByteLimit],
		(* send message and return failed *)
		Message[BigQuantityArraySpan::RequestTooLarge, byteLimit];
		Return[$Failed]
	];

	(* switch function behavior based on mode *)
	(* Parse mode will download the file to disk, if not already there, and take the span from the binary file *)
	(* Span mode will request the span from AWS S3 without downloading the entire file *)
	(* for algorithms requiring a large number of span calls, parse mode is best. for a small number of span calls, the span mode is best *)
	Switch[locationOption,
		Local, downloadAndParseFile[bucket, key, myStartPosition, myStopPosition, byteLimit],
		Cloud, downloadSpan[bucket, key, myStartPosition, myStopPosition, byteLimit]
	]
];


(* helper to download a span from S3 *)
downloadSpan[bucket_, key_, start_, stop_, byteLimit_]:=Module[
	{
		url, response, headerData, headerLength, dataStart, dataStop, dataResponse,
		dataStream, header, encodingVersion, binaryRowFormat, rawData, statusCode, data,
		updatedStatus, updatedData, fullHeaders, contentLength, updatedResponse, output
	},

	(* request a link from constellation that we can use to download parts of the file *)
	response = ConstellationRequest[
		<|
			"Path"->"blobsign/download",
			"Body"->ExportJSON[<|"bucket"->bucket,"key"->key,"expires"->600|>],
			"Method"->"POST"
		|>
	];

	(* get url needed for download *)
	url = Lookup[response, "Url"];

	(* get header data by requesting the first 16 kb of data, and returning the
	header information as a string in which each character maps to 1 byte of info from the response *)
	headerData = getHeaderData[url];

	(* if header failed return $Failed *)
	If[MatchQ[headerData, $Failed], Return[$Failed]];

	(* attempt to decode the header as JSON *)
	header=ImportString[headerData, "RawJSON"];

	(* record the length of the header for a future request *)
	headerLength = StringLength[headerData];

	(* get the binary row format for each data element *)
	binaryRowFormat=header["binaryRowFormat"];

	(* create new indices that account for the size of the header *)
	{dataStart, dataStop} = createDataIndices[start, stop, headerLength, binaryRowFormat];

	(* make new request to get span of s3 bucket without querying the header part *)
	dataResponse = getS3Span[url, dataStart, dataStop];

	(* unpack response *)
	{statusCode, data} = dataResponse;

	(* if status code indicates a 416 error resend requests *)
	updatedResponse = If[MatchQ[statusCode, 416],
		(* this is an error state that means the stop index was beyond the size of the file *)
		(* make another request to read in the full headers to get the length of the data *)
		fullHeaders = URLRead[HTTPRequest[url],"Headers"];
		(* get the actual content size *)
		contentLength = ToExpression[Lookup[fullHeaders, "content-length"]];
		(* find the maximum index from the total content size number *)
		(* quiet the possible IndexError which will message that the indices are reversed which is confusing *)
		(* if that error gets hit it will return failed, which will get caught below and a more appropriate message will be sent *)
		Quiet[getS3Span[url, dataStart, contentLength], {BigQuantityArraySpan::IndexError}],
	(* else return the original data and status *)
		dataResponse
	];
	(* if response failed, return failed *)
	If[MatchQ[updatedResponse, $Failed],
		Message[BigQuantityArraySpan::InvalidSpan, start];
		Return[$Failed]
	];

	(* clear any unnecessary variables *)
	Clear[dataResponse, data];

	(* unpack the updated response *)
	{updatedStatus, updatedData} = updatedResponse;
	Clear[updatedResponse];

	(* if new response is still an error, return $Failed and send message *)
	If[StringStartsQ[ToString[updatedStatus], "3"|"4"|"5"],
		Message[BigQuantityArraySpan::HTTPError, updatedStatus];
		Return[$Failed]
	];

	(* turn the response into a binary stream *)
	dataStream = StringToStream[updatedData];

	(* get the encoding version for unclear reasons *)
	(* TODO: figure out if this is necessary *)
	encodingVersion=header["version"];

	(* read rest of the file in with BinaryReadList *)
	rawData=BinaryReadList[dataStream, binaryRowFormat];
	Close[dataStream];
	Clear[updatedData];

	(* decode the units, and construct the quantity array from this *)
	(* convert the quantity array to the defined units of the type. *)
	output = QuantityArray[rawData, decodeExpressionB64[header["mathematicaUnits"]]];

	(* clear memory for rawdata and return output *)
	Clear[rawData];
	output
];

(* define helper that will convert string to bit number *)
(* NOTE: this relies on the greediness of StringCases which matches on the longest possible substring first *)
getBitNumber[input_String]:=ToExpression[First[StringCases[input, NumberString], $Failed]];

(* helper to find the new data indices in byte count based on the specified starting and ending elements *)
createDataIndices[start_, stop_, headerLength_Integer, dataFormat_]:=Module[
	{bitNumbers, totalBytes, dataStart, dataStop},

	(* data format should be something of the form, {x,y,z},
	where x, y, or z can be anything amongst Real32, Real64, Integer32, Integer 64, Complex32/64 *)
	(* map the helper over the input data format *)
	bitNumbers = getBitNumber /@ dataFormat;

	(* check if there are any failed bit numbers, if so return $Failed *)
	If[MemberQ[bitNumbers, $Failed],
		Return[$Failed]
	];

	(* else there are no fails, calc the sum of the bits divided by 8 to get the total bytes *)
	totalBytes = Total[bitNumbers] / 8;

	(* calculate the starting and ending data indices by multiplying the
	start/stop by totalBytes and adding the header length + 1 *)
	(* NOTE: there's a counting index problem here where mathematica starts on
		index 1, but we need to start on 0 *)
	dataStart = headerLength + 1 + (start - 1) * totalBytes;
	dataStop = headerLength + 1 + (stop * totalBytes);

	(* return the tuple of start and stop *)
	{dataStart, dataStop}
];

(* helper to get the header info from a cloud file url *)
getHeaderData[url_]:=Module[
	{headerResponse, inStream, headerStream, headerString, headerStatus, headerData},

	(* get s3 span of header information *)
	headerResponse = getS3Span[url, 0, $bigQuantityArrayBinaryEncodeMaxHeaderSize];

	(* unpack the response *)
	{headerStatus, headerString} = headerResponse;

	(* if new response is an error, return $Failed and send message *)
	If[StringStartsQ[ToString[headerStatus], "3"|"4"|"5"],
		Message[BigQuantityArraySpan::HTTPError, headerStatus];
		Return[$Failed]
	];

	(* turn data into a stream *)
	headerStream = StringToStream[headerString];

	(* get header data from the stream *)
	headerData = binaryReadBigQAHeader[headerStream, $bigQuantityArrayBinaryEncodeMaxHeaderSize];

	(* close the stream *)
	Close[headerStream];

	(* return data *)
	headerData
];

(* helper to get a partial span of bytes in an S3 data object *)
getS3Span[url_, start_, stop_]:=Module[
	{spanHeader, response, headerResponse, bodyResponse, payload, statusCode},

	(* check if start is larger than stop and return error if true *)
	(* NOTE: this is not redundant because there is some retry logic in downloadSpan *)
	If[TrueQ[start>stop],
		Message[BigQuantityArraySpan::IndexError, start, stop];
		Return[$Failed]
	];

	(* create header for span *)
	spanHeader = <|
		"Range" -> "bytes="<>ToString[start]<>"-"<>ToString[stop]
	|>;

	(* get the http response *)
	response = HTTPRequest[url, <|"Headers"->spanHeader|>];

	(* download the result from S3 and return *)
	payload = URLRead[response, {"Headers", "Body", "StatusCode", "StatusCodeDescription"}];
	{headerResponse, bodyResponse, statusCode} = Lookup[payload, {"Headers", "Body", "StatusCode"}];

	(* return the desired results *)
	{statusCode, bodyResponse}
];

(* helper to download large file and parse *)
downloadAndParseFile[bucket_, key_, myStartPosition_, myStopPosition_, byteLimit_]:=Module[
	{
		filePath, inStream, header, headerData, downloadedFileQ, encodingVersion,
        binaryRowFormat, rawData, headerLength, dataStart, dataStop, listLength,
		checkResult, fileName
	},

	(* create a temporary file name given by the s3 key *)
	(* TODO: make a better file name or ask Ben if using the key as a file name is a security risk *)
	fileName = Last[FileNameSplit[key]];
	filePath = FileNameJoin[{$TemporaryDirectory, fileName}];

	(* check if the S3 file has been downloaded yet *)
    downloadedFileQ = FileExistsQ[filePath];

	(* if it hasn't then download it *)
	If[Not[downloadedFileQ], downloadBigQAFile[bucket, key, filePath]];

	(* open up an input byte stream on the downloaded S3 file *)
	inStream=OpenRead[filePath, BinaryFormat -> True];

	(* get the header information *)
	(* reader the header, which should be JSON *)
	headerData=binaryReadBigQAHeader[inStream, $bigQuantityArrayBinaryEncodeMaxHeaderSize];

	(* attempt to decode the header as JSON *)
	header=ImportString[headerData, "RawJSON"];

	encodingVersion=header["version"];

	(* read rest of the file in with BinaryReadList *)
	binaryRowFormat=header["binaryRowFormat"];

    (* find the length of the header needed for proper indexing *)
    headerLength = StringLength[headerData];

	(* create new indices that account for the size of the header and convert to byte position instead of list position *)
	{dataStart, dataStop} = createDataIndices[myStartPosition, myStopPosition, headerLength, binaryRowFormat];

	(* change this to read in a chunk *)
	(* set stream position to specified starting byte position *)
	Quiet[
		Check[SetStreamPosition[inStream, dataStart],
			Message[BigQuantityArraySpan::InvalidSpan, myStartPosition];
			Return[$Failed],
			{SetStreamPosition::stmrng}
		],
		{SetStreamPosition::stmrng}
	];

	(* map the read function over the range of bytes *)
	listLength = myStopPosition - myStartPosition + 1;
	rawData=Table[
		BinaryRead[inStream, binaryRowFormat],
		(* this range is a dummy index, we just need to repeat the BinaryRepeat
		command many times *)
		{dummy, listLength}
	];
	Close[inStream];

	(* decode the units, and construct the quantity array from this *)
	(* convert the quantity array to the defined units of the type. *)
	QuantityArray[rawData, decodeExpressionB64[header["mathematicaUnits"]]]
];

(* helper to download big qu array file *)
(* TODO: finish this helper *)
downloadBigQAFile[bucket_String, key_String, filePath_String]:=Module[
	{},

	(* download the blob *)
	signAndDownloadS3[
		EmeraldCloudFile["AmazonS3", bucket, key, None],
		filePath
	]
];

(* get s3 key from constellation response *)
getS3BucketAndKey[response_Association, field_Symbol]:=Module[
	{fieldName, blob, path, bucket, hash},

	(* convert the field to a string *)
	fieldName = ToString[field];

	(* get the blob association from the response *)
	blob = response["responses"][[1]]["fields"][fieldName];

	(* lookup the path, bucket, and hash from the blob and return *)
	{path, bucket, hash} = Lookup[blob, {"path", "bucket", "hash"}];

	(* return the bucket and key, which is the combination of path and hash *)
	{bucket, path<>hash}
];

(* helper to get the blob response from Constellation *)
requestBigQABlob[myObject:ObjectP[], field_Symbol]:=Module[
	{fieldName, objID, body},

	(* generate constellation request *)
	fieldName=ToString[field];

	(* extract the object ID string from the reference *)
	objID = Download[myObject, ID];

	(* generate the request body *)
	body = ExportJSON[
		<|"Requests"->{
			<|
				"id"->objID,
				"fields"->{fieldName}
			|>}
		|>
	];

	(* make the constellation request for the blob file *)
	ConstellationRequest[
		<|
			"Path"->"obj/download",
			"Body"->body,
			"Method"->"POST"
		|>
	]
];


(* helper to find the content size of big quantity array file *)
findS3FileSize[key_, bucket_]:=Module[
	{response},

	(* request the head information of the S3 file *)
	response = GoCall["HeadCloudFile", <|
		"Key" -> key,
		"Bucket" -> bucket,
		"Retries" -> 5
	|>];

	(* lookup and return the content size *)
    ToExpression[Lookup[response, "ContentSize"]]
];
