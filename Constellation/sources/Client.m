(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


qaByteLimit=100000000;

(*
 	Debug time allows the user to set the date to present
	Only Emerald Developers have access to this feature, for the use of debugging
	TODO: Worth adding a productionQ check to prevent it from being used in prod?
*)
debugTime=False;
getDebugTimeRule[]:=Module[{},
	If[DateObjectQ[debugTime] && MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]],
		Return["debug_time" -> DateObjectToRFC3339[debugTime]],
		Return[Nothing]
	];
];

typeDelimiterChar=".";
typeToString[t:typeP]:=Set[
	typeToString[t],
	StringJoin[
		SymbolName[Head[t]],
		typeDelimiterChar,
		StringRiffle[
			Map[
				SymbolName,
				Apply[List, t]
			],
			typeDelimiterChar
		]
	]
];
stringToType[""]:=$Failed;
stringToType[s_String]:=Module[
	{parts, result},

	parts=Map[stringToSymbol, StringSplit[s, "."]];
	type=If[MemberQ[parts, $Failed],
		$Failed,
		Apply[
			parts[[1]],
			parts[[2;;]]
		]
	];

	(* If this is a current type, remember it *)
	(* If there is a parsing failure, remember it *)
	(* If this is not a currenty type, it still might be later *)
	If[TypeQ[type] || FailureQ[type],
		Set[stringToType[s], type],
		type
	]
	(*
		This is sucesptible to type deletion,
		but the speed benefits of Set are apparently worth it
	*)
];

stringToSymbol[str_String]:=Lookup[
	fieldSymbols,
	str,
	$Failed
];

toConstellationID[object:ReferenceWithNameP]:=StringJoin[
	SymbolName[Head[object]],
	"[",
	StringRiffle[
		Replace[
			Apply[List, object],
			{
				sym_Symbol :> SymbolName[sym],
				str_String :> ToString[str, InputForm]
			},
			{1}
		],
		","
	],
	"]"
];
toConstellationID[object:objectP | modelP]:=Last[object];
toConstellationID[type:typeP]:=typeToString[type];

apiUrl["CheckType"]:="obj/type";
apiUrl["Download"]:="obj/download";
apiUrl["EraseLink", linkId_String]:=StringTemplate["obj/deletelink/`1`"][EncodeURIComponent[linkId]];
apiUrl["EraseObject"]:="obj/object";
apiUrl["GetType", type_String]:=StringTemplate["obj/type/`1`"][EncodeURIComponent[type]];
apiUrl["ListTypes"]:="obj/type";
apiUrl["Search"]:="obj/search";
apiUrl["parallelSearch"]:="obj/sci-infra/parallel-search";
apiUrl["Upload"]:="obj/upload?object=true";
apiUrl["RollbackTransaction"]:="obj/rollback";
apiUrl["AssumeIdentity"]:="ise/assume-identity";
apiUrl["ArchiveNotebook"]:="ise/archive-notebook";
apiUrl["GetNumOwnedObjects"]:="obj/get-num-owned-objects";
apiUrl["OnCall"]:="ise/on-call";
apuUrl["NotebookObjects"]="obj/notebook-objects";
apiURL["GetFavoriteFolders"]:="obj/favorite-folders";
apiURL["GetBookmarks"]:="/obj/bookmark-objects";
apiURL["PollObjectChanges"]:="obj/poll-object-change";

getNotebookObjects[nbID_String (*id:123456789123*)] :=
	Module[{response},
		response =
			ConstellationRequest[<|"Path" -> "obj/notebook-objects",
				"Method" -> "POST",
				"Body" ->
					ExportString[<|"notebook_ids" -> {nbID}, "summary" -> False|>, "JSON"]
				|>
			];

		Replace[Lookup[response, "results"],

			{
				(*Expect a List of length 1, Constellation's id should match the input notebook id*)
				{KeyValuePattern[{"id" -> nbID, "objects" -> objects_}]} :> Constellation`Private`objectReferenceToObject /@ objects,
				(*If the request failed, return $Failed*)
				$Failed -> $Failed,
				(*Any thing else, just return empty list.*)
				_ -> {}
			}
		]
	];
getNotebookObjects[$Failed]:=$Failed;

listObjectTypes[]:=Module[{response},
	response=ConstellationRequest[<|"Path" -> apiUrl["ListTypes"], "Method" -> "GET"|>];
	If[response === $Failed, Return[$Failed]];
	Map[Association, response]
];

getObjectType[type:typeP]:=Module[{response},
	response=ConstellationRequest[<|"Path" -> apiUrl["GetType", typeToString[type]], "Method" -> "GET"|>];
	If[response === $Failed, Return[$Failed]];
	(* Comes out of JSON decoding as a nested list of Rules, so convert it to Assocations *)
	Replace[
		response,
		x:{__Rule} :> Association[x],
		{0, Infinity}
	]
];

(* sends a dryrun sync request *)
checkObjectType[type:typeP]:=Module[
	{jsonDataDef, jsonDataStr, response},
	jsonDataDef=ObjectSync`Private`typeDefinitionToJSON[type, True];
	If[jsonDataDef === $Failed,
		Message[SyncType::JSONDataError, ToString[t]];
		Return[$Failed];
	];

	jsonDataStr=ExportJSON[jsonDataDef];
	If[jsonDataStr === $Failed,
		Message[SyncType::JSONDataError, "[JSON Encoding] "<>ToString[t]];
		Return[$Failed];
	];

	response=ConstellationRequest[<|
		"Path" -> apiUrl["CheckType"],
		"Body" -> jsonDataStr,
		"Method" -> "PUT"
	|>];
	If[response === $Failed, Return[$Failed]];
	Association[response]
];



isoTimeString[date_DateObject]:=With[
	{realTimeZone=Lookup[Cases[date, _Rule], TimeZone, $TimeZone]},
	Block[{$TimeZone=realTimeZone},
		DateString[date, {"ISODateTime", "ISOTimeZone"}]
	]
];


(* stuff ExportJSON will deal with *)
(* Type + ID. Possibly name. Callers want type + ID currently always. *)
firstValueFromValidKey[assoc_Association, keys_List]:=Scan[
	With[{val=Lookup[assoc, #, ""]}, If[val != "", Return[val]]] &,
	keys];
objectReferenceToObject[ref_Association]:=With[{
	type=stringToType[Lookup[ref, "type", ""]],
	idString=firstValueFromValidKey[ref, {"id"}]
},
	If[type === $Failed || !TypeQ[type] || idString === Null, Return[$Failed]];
	Append[type, idString]
];
(* Type + ideally one of ID, Name, or ClientID. May have none if this was an object creation. *)
objectReferenceUnresolvedToObject[ref_Association]:=With[{
	type=stringToType[Lookup[ref, "type", ""]],
	idString=firstValueFromValidKey[ref, {"name", "id", "client_id"}]
},
	If[type === $Failed || !TypeQ[type] || idString === Null, Return[$Failed]];
	Append[type, idString]
];

ConstellationObjectReferenceAssoc[obj:(objectP | modelP)]:=<|
	If[MatchQ[obj, ReferenceWithNameP],
		"name" -> Last[obj],
		"id" -> Last[obj]
	],
	"type" -> typeToString[objectToType[obj]]
|>;

ConstellationObjectReferenceAssocWithOptionalType[obj:(objectP | modelP | linkP)]:=Module[{objectNotLink},
	objectNotLink=If[MatchQ[obj, linkP], linkToObject[obj], obj];
	<|
		If[MatchQ[objectNotLink, ReferenceWithNameP],
			"name" -> Last[objectNotLink],
			"id" -> Last[objectNotLink]
		],
		If[MatchQ[objectNotLink, ReferenceWithNameP], "type" -> typeToString[objectToType[objectNotLink]], Nothing]
	|>
];

jsonValueData[class:Compressed, v_, unit_]:=Compress[unitConvert[class, v, unit]];
jsonValueData[Integer, v_Integer, unit:None]:=v;
jsonValueData[Real, v:(_Real | _Integer | _Rational), unit:None]:=N[v];
jsonValueData[class:Real | Integer, v:(_Real | _Integer | _Rational | _?QuantityQ), unit_]:=
	ToString[unitConvert[class, v, unit], InputForm];

jsonValueData[String, v_String, unit_]:=v;
jsonValueData[class:Expression, v_, unit_]:=ToString[unitConvert[class, v, unit], InputForm];
jsonValueData[class:Boolean, v_, unit_]:=unitConvert[class, v, unit]; (* let JSON deal with it, should not choke on True|False *)

(* SLL and Mathematica types we need to treat special-like *)
jsonValueData[class:QuantityArray | Compressed, v_, unit_]:=Compress[unitConvert[class, v, unit]];
jsonValueData[Date, v_DateObject, unit_]:=isoTimeString[v];
jsonValueData[EmeraldCloudFile, cloudFile:EmeraldCloudFile["AmazonS3", bucket_String, key_String, cloudFileId:(_String | None):None], unit:None]:=With[
	{
		simpleCloudFile=<|
			"$Type" -> "__JsonEmeraldCloudFile__",
			"Bucket" -> bucket,
			"Key" -> key
		|>
	},

	If[cloudFileId === None,
		simpleCloudFile,
		Append[simpleCloudFile, "CloudFileId" -> cloudFileId]
	]
];

jsonValueData[VariableUnit, value_?QuantityQ, fieldUnit:None]:=Module[
	{},
	Join[<|
		"$Type" -> "__JsonVariableUnit__",
		"mathematica_value" -> ToString[FullForm[value]]
	|>,
		searchableValueData[value]
	]
];

jsonValueData[Distribution, distribution_, fieldUnit:None]:=With[{mean=Mean[distribution]},
	<|
		"$Type" -> "__JsonVariableUnit__",
		"mathematica_value" -> ToString[FullForm[distribution]],
		"search_dimension" -> SortBy[Map[dimensionToObject, UnitDimensions[mean]], #[Name]&],
		"search_value" -> StringReplace[ToString[N[mean], InputForm], "*^" -> "e"]
	|>
];

jsonValueData[Distribution, distribution_, fieldUnit_]:=With[{mean=Mean[distribution]},
	<|
		"$Type" -> "__JsonVariableUnit__",
		"mathematica_value" -> ToString[FullForm[distribution]],
		"search_dimension" -> SortBy[Map[dimensionToObject, UnitDimensions[mean]], #[Name]&],
		"search_value" -> StringReplace[ToString[N[QuantityMagnitude[UnitConvert[mean, fieldUnit]]], InputForm], "*^" -> "e"]
	|>
];

(* given a mathematica quantity, compute mathematica JSON-able pairs for search_dimension and search_value *)
searchableValueData[value_?QuantityQ]:=With[
	(* IndependentUnits have no CanonicalUnit. *)
	{normalizedValue=If[MatchQ[value, Quantity[_, IndependentUnit[_]]],
		QuantityMagnitude[value],
		N[QuantityMagnitude[UnitConvert[value, CanonicalUnit[value]]]]
	]},
	<|
		"search_dimension" -> SortBy[Map[dimensionToObject, UnitDimensions[value]], #[Name]&],
		"search_value" -> StringReplace[ToString[normalizedValue, InputForm], "*^" -> "e"]
	|>
];

dimensionToObject[{name_String, exponent_?NumericQ}]:=<|
	"Name" -> name,
	"Exponent" -> exponent
|>;

dimensionToObject[{IndependentUnitDimension[name_String], exponent_?NumericQ}]:=<|
	"Name" -> name,
	"Exponent" -> exponent
|>;

jsonBase64[value_]:=With[
	{encoded=ExportString[value, {"Base64", "RawJSON"}]},
	"\"base64:"<>StringReplace[encoded, WhitespaceCharacter -> ""]<>"\""
];

jsonValueData[Link | TemporalLink, link:linkP, unit:None]:=Module[
	{
		obj=linkToObject[link],
		fieldName=If[Length[link] === 1,
			$Failed,
			link[[2]]
		],
		subField=linkToSubField[link],
		linkId=getLinkId[link],
		linkDate=getLinkDate[link]
	},
	<|
		"$Type" -> "__JsonLink__",
		"object" -> ConstellationObjectReferenceAssoc[obj],
		If[MatchQ[fieldName, Except[$Failed, _Symbol]],
			"field" -> <|
				"name" -> SymbolName[fieldName],
				Switch[subField,
					Except[$Failed, _Symbol],
					"sub_field_name" -> SymbolName[subField],
					_Integer,
					"sub_field_index" -> subField,
					_,
					Nothing
				]
			|>,
			Nothing
		],
		If[MatchQ[linkId, _String],
			"id" -> linkId,
			Nothing
		],
		If[MatchQ[linkDate, _DateObject],
			"date" -> DateObjectToRFC3339[linkDate],
			Nothing
		]
	|>
];

linkToSubField[Link[objectP | modelP, _Symbol, subField:_Integer | _Symbol, Repeated[_String, {0, 1}]]]:=subField;
linkToSubField[_]:=$Failed;


(*
	BlobReference Conversion

	The idea here is that, when seeing one of the "big data" fields, we want to
	create a tempfile for each of these values, and rewrite the value to be a blob reference with
	an extra metadata field to hold the "local path", where this file was saved by the
	jsonValueData function. We then in the upload bits (see uploadBlobReferences)
	will extract out these paths and upload with a telescope UploadCloudFile call.

	We do all this side-effecty stuff, which in general is pretty horrible, as a bit of a band-aid
	right now because these big data values consume so much memory that we don't want
	to make to many in-memory copies. there is probably some deeper thinking to do on a solution
	here but this is what we're rolling with for now.
*)

blobReferenceAssociation[md5hash_String, path_String, localPath_String]:=<|
	"$Type" -> "__JsonBlobReference__",
	"bucket" -> "", (* this empty string must remain to get KeyValuePatterns that recongnice this to work *)
	"hash" -> md5hash,
	"path" -> path,
	"localPath" -> localPath
|>;

jsonBlobReferenceP=KeyValuePattern[{
	"$Type" -> "__JsonBlobReference__",
	"bucket" -> _String,
	"hash" -> _String,
	"path" -> _String
}];

convertCloudFileToBlob[
	cloudFile:EmeraldCloudFile["AmazonS3", bucket_String, key_String, cloudFileId:(_String | None):None]
]:=<|
	"$Type" -> "__JsonBlobReference__",
	"bucket" -> bucket,
	"hash" -> hashFromShardedPath[key],
	"path" -> pathFromShardedPath[key]
|>;
(* some weird pattern shenanigans here; need to use objectP/modelP instead of ObjectP[Object[EmeraldCloudFile]] here *)
convertCloudFileToBlob[myCloudFileObj:linkP | objectP]:=Module[
	{cloudFileBlob, bucket, key},

	(* need to Download the actual blob from the cloud file object *)
	cloudFileBlob=Download[myCloudFileObj, CloudFile];

	(* pull out the important values from the cloud file blob *)
	{bucket, key}={cloudFileBlob[[2]], cloudFileBlob[[3]]};

	<|
		"$Type" -> "__JsonBlobReference__",
		"bucket" -> bucket,
		"hash" -> hashFromShardedPath[key],
		"path" -> pathFromShardedPath[key]
	|>
];

convertBlobToCloudFile[blob:jsonBlobReferenceP]:=EmeraldCloudFile[
	"AmazonS3",
	Lookup[blob, "bucket"],
	Lookup[blob, "path"] <> Lookup[blob, "hash"]
];

hashFromShardedPath[shardedPath_String]:=Last[StringSplit[shardedPath, "/"]];
pathFromShardedPath[shardedPath_String]:=StringDrop[shardedPath, -StringLength[hashFromShardedPath[shardedPath]]];

(* empty params implies writing a temporary temp file with a UUID. the idea is that this will then be moved once the file is writen
   completely, and we can hash it. *)
$blobRefTempDirRoot="eclblobref";
makeBlobRefTempFilePath[fileHash_String?(StringLength[#] >= 3&), function:(Upload | Download)]:=Module[
	{tempDirectory},
	(* make sure the temp directory holding this is different depending on whether it's Uploading or Downloading *)
	(* Doing this because if you Upload something to a big field, the Upload silently fails, and then I try to Download it again, it will wrongly seem like Upload succeeded because Download would return the same thing *)
	tempDirectory=If[MatchQ[function, Upload],
		FileNameJoin[{$TemporaryDirectory, $blobRefTempDirRoot, StringJoin["Upload", StringTake[fileHash, 3]]}],
		FileNameJoin[{$TemporaryDirectory, $blobRefTempDirRoot, StringJoin["Download", StringTake[fileHash, 3]]}]
	];
	(* try creating this directory with intermediate creations. silence if we've already created this directory  *)
	Quiet[
		CreateDirectory[tempDirectory, CreateIntermediateDirectories -> True],
		{CreateDirectory::filex, CreateDirectory::eexist}
	];
	FileNameJoin[{tempDirectory, fileHash}]
];

jsonValueData[class:BigCompressed, v_, unit_]:=jsonValueDataNonQuantityMatrix[unitConvert[class, v, unit]];
jsonValueDataNonQuantityMatrix[v_]:=Module[
	{compressedData, md5hash, tempFile, exportResult},

	compressedData=Compress[v];
	(* can this $Failed? I imagine it can, but not sure how / how to make it for test... *)
	If[Not@MatchQ[compressedData, _String],
		Sow[<|"message" -> "compressing data."|>, "big-data-encoding"];
		Return[$Failed]
	];

	md5hash=Hash[compressedData, "MD5"];
	(* Again, given this is a string, hard to know how this can fail... *)
	If[Not@MatchQ[md5hash, _Integer],
		Sow[<|"message" -> "md5 hashing data."|>, "big-data-encoding"];
		Return[$Failed]
	];


	(* this should be a safe operation to rewrite the integer as a hex value *)
	(* need to make sure this is a length 32 string because IntegerString will chop off leading zeroes otherwise and this doesn't play nicely with AWS *)
	md5hash=IntegerString[md5hash, 16, 32];

	tempFile=makeBlobRefTempFilePath[md5hash, Upload];
	exportResult=Export[tempFile, compressedData, "Text"];
	If[exportResult =!= tempFile,
		Sow[<|"message" -> "exporting temp file"|>, "big-data-encoding"];
		Return[$Failed]
	];

	blobReferenceAssociation[md5hash, "", tempFile]
];


$bigQuantityArrayBinaryEncodeVersion=1; (* the binary encoding have a verison, this is the current version *)
$bigQuantityArrayBinaryEncodeMaxHeaderSize=16 * 1024; (* 16 KB *)

encodeExpressionB64[expr_]:=ExportString[ExportString[expr, "ExpressionJSON", Compact -> True], "Base64"];
decodeExpressionB64[encoding_String]:=ImportString[ImportString[encoding, "Base64"], "ExpressionJSON"];

bigQuantityArrayFormats=<|
	Real -> "Real64",
	Rational -> "Real64",
	Integer -> "Integer64",
	Complex -> "Complex64"
|>;

bigQuantityArrayTypeFormatP=Apply[Alternatives, Values[bigQuantityArrayFormats]];

toBigQuantityArrayFormats[firstRow_List]:=Map[
	Lookup[bigQuantityArrayFormats, Head[#], Null]&,
	firstRow
];
toBigQuantityArrayFormats[Null]:={};

jsonValueData[BigQuantityArray, cloudfile:EmeraldCloudFileP | linkP | objectP, unit_]:=
	convertCloudFileToBlob[cloudfile];

jsonValueData[BigQuantityArray, quantityArray:QuantityArrayP[], unit_]:=Module[
	{
		convertedQuantityArray,
		rawData, rawDataUnits, outputFormat,
		headerData,
		outStream,
		blockSpans,
		writeResult,
		uuidTempFileName,
		uuidTempFileMD5,
		hashFileName,
		renameResult
	},

	(* first, convert our quantity array to the correct units. *)
	convertedQuantityArray=unitConvert[BigQuantityArray, quantityArray, unit];

	rawData=QuantityMagnitude[convertedQuantityArray];

	(* If it's not a QuantityMatrix, we cannot do this optimized encoding.
	   Luckily we're currently at a state where most (if not all) things are NxM
	*)
	If[Length[Dimensions[rawData]] =!= 2,
		Return[jsonValueDataNonQuantityMatrix[convertedQuantityArray]]
	];

	(*
	   UnitBlock is a secret key in quantity arrays that, when the QA is a a matrix,
	   can very quickly extract the units for the QA. Only work reliably with matrices,
	   but since we only do this optimized encoding for QuantityMatrixP this should be safe.
	*)
	rawDataUnits=convertedQuantityArray["UnitBlock"];

	uuidTempFileName=makeBlobRefTempFilePath[CreateUUID[], Upload];

	(* open the output stream *)
	outStream=OpenWrite[uuidTempFileName, BinaryFormat -> True];
	If[Not@MatchQ[outStream, _OutputStream],
		Sow[<|"message" -> "opening output stream."|>, "big-data-encoding"];
		Return[$Failed]
	];

	(* write the header line *)
	outputFormat=toBigQuantityArrayFormats[N[First[rawData]]];
	headerData=ExportJSON[<|
		"version" -> $bigQuantityArrayBinaryEncodeVersion,
		"encoder" -> "binary",
		"binaryRowFormat" -> outputFormat,
		"mathematicaUnits" -> encodeExpressionB64[rawDataUnits],
		"dimensions" -> Dimensions[rawData]
	|>];
	(* since the header row is terminated by \n we need remove it anywhere that might have
		somehow gotten into the headerData
	*)
	headerData=StringReplace[headerData, "\n" -> ""];
	If[Not@MatchQ[headerData, _String],
		Sow[<|"message" -> "encoding header JSON."|>, "big-data-encoding"];
		Return[$Failed]
	];

	If[StringLength[headerData] > $bigQuantityArrayBinaryEncodeMaxHeaderSize,
		Sow[<|"message" -> "encoding header JSON larger then max header size."|>, "big-data-encoding"];
		Return[$Failed]
	];

	(* Scan over blocks of the data, binary writting the correct format, then close the stream *)
	blockSpans=generateBlockSpans[Dimensions[rawData]];
	If[Not@MatchQ[blockSpans, {_Span...}],
		Sow[<|"message" -> "generating block spans."|>, "big-data-encoding"];
		Return[$Failed]
	];

	writeResult=BinaryWrite[outStream, headerData<>"\n"];
	If[Not@MatchQ[writeResult, _OutputStream],
		Sow[<|"message" -> "write header line."|>, "big-data-encoding"];
		Return[$Failed]
	];

	writeResult=binaryWriteAllBlocks[outStream, blockSpans, outputFormat, rawData];
	Close[outStream];
	If[writeResult === $Failed,
		Sow[<|"message" -> "writing binary blocks"|>, "big-data-encoding"];
		Return[$Failed]
	];

	(* once the file has been succesfully written too, has the file, and rename it to the hash value *)
	uuidTempFileMD5=FileHash[uuidTempFileName, "MD5", All, "HexString"];
	If[Not@MatchQ[uuidTempFileMD5, _String],
		Sow[<|
			"message" -> ("md5 file "<>uuidTempFileName<>" hashed. result: "<>ToString[Head@uuidTempFileMD5])
		|>,
			"big-data-encoding"
		];
		Return[$Failed]
	];

	(* rename the file to have the name of the hash, but only if it does not already exist *)
	hashFileName=makeBlobRefTempFilePath[uuidTempFileMD5, Upload];
	If[Not@FileExistsQ[hashFileName],
		renameResult=RenameFile[uuidTempFileName, hashFileName];
		If[Not@MatchQ[renameResult, _String],
			Sow[<|"message" -> "renaming temp file"|>, "big-data-encoding"];
			Return[$Failed]
		]
	];

	blobReferenceAssociation[uuidTempFileMD5, "", hashFileName]
];

blockChunkSize=128000; (* On NxM matric, where M = 3 64-bit numbers, this makes ~24MB blocks *)
generateBlockSpans[{dataLength_Integer, rowLength_Integer}]:=Module[
	{blockSpans, chunkSize},
	chunkSize=Min[dataLength, blockChunkSize];
	blockSpans=ReplacePart[
		Table[i + 1 ;; i + chunkSize, {i, 0, dataLength - 1, chunkSize}],
		{-1, -1} -> dataLength
	];
	blockSpans
];

binaryWriteBlock[outStream_OutputStream, span_Span, blockRowFormat:{bigQuantityArrayTypeFormatP..}, rawData_]:=Module[
	{block, flattendBlock, expandedRowFormat, writeResult},

	(* this has the possibility to allocate a bunch of memory, but should be significantly less
	   as the blocks should be around 24MB   *)
	block=Part[rawData, span];
	flattendBlock=N[Apply[Join, block]];
	expandedRowFormat=Apply[Join, Table[
		blockRowFormat,
		{Length[block]}
	]];
	If[Length[flattendBlock] =!= Length[expandedRowFormat],
		Sow[<|"message" -> "block and row format length mismatch"|>, "big-data-encoding"];
		Return[$Failed]
	];
	BinaryWrite[outStream, flattendBlock, expandedRowFormat]
];

binaryWriteAllBlocks[outStream_OutputStream, spans:{_Span...}, blockRowFormat:{bigQuantityArrayTypeFormatP..}, rawData_]:=Scan[
	Function[{blockSpan},
		With[
			{stream=binaryWriteBlock[outStream, blockSpan, blockRowFormat, rawData]},
			If[Not@MatchQ[stream, _OutputStream],
				Return[$Failed]
			]
		]
	],
	spans
];

jsonValueData[FieldClassP, Null, unit_]:=Null;
(* catch all -- THIS NEEDS TO BE DEFINED LAST *)
jsonValueData[t:FieldClassP, v_, unit_]:=Module[{},
	Message[jsonValueData::FailedToMatch, ToString[t], ToString[v], ToString[unit]];
	$Failed
];
jsonValueData::FailedToMatch="Failed to match FieldType `1`, Value `2`, and Unit `3` for JSONification of the Packet";


(*
	keyValue takes the objects type and the rules and either compresses it if
	the fields is a Compressed field, or calls jsonValueData on the value.

	It handles a few different forms of values:
		single value: just calls the jsonValueData on it.
		list: maps jsonValueData over it.
		list of list (index multiple):
*)
symbolHeadP=None | Append | Replace | Erase | EraseCases | Transfer | Prepend;

uploadFieldValue[_, _, _, _, Null]:=
	Null;

uploadFieldValue[EraseCases, Single | Multiple, class:_, units:_, value_]:=With[
	{convertedValue=uploadFieldValue[Replace, Single, class, units, value]},

	<|
		"$Type" -> "__JsonDeleteField__",
		"value" -> convertedValue
	|>
];

uploadFieldValue[Erase, Single | Multiple, (*class*)_, (*units*)_, All]:=
	<|"$Type" -> "__JsonDeleteField__"|>;

(* indexed or named single *)
uploadFieldValue[Erase, Single, _List, (*units*)_, indices:_Integer | _Span | {{_Integer | All}..}]:=
	<|
		"$Type" -> "__JsonDeleteField__",
		"columns" -> partAssociation[indices]
	|>;

(* multiple *)
uploadFieldValue[Erase, Multiple, _, (*units*)_, indices:_Integer | _Span | {{_Integer | All}..}]:=
	<|
		"$Type" -> "__JsonDeleteField__",
		"rows" -> partAssociation[indices]
	|>;

(* indexed or named multiple field *)
uploadFieldValue[Erase, Multiple, _List, (*units*)_, {All, columns:_Integer | _Span}]:=
	<|
		"$Type" -> "__JsonDeleteField__",
		"columns" -> partAssociation[columns]
	|>;

(* indexed or named multiple field *)
uploadFieldValue[Erase, Multiple, _List, (*units*)_, {rows:_Integer | _Span, All}]:=
	<|
		"$Type" -> "__JsonDeleteField__",
		"rows" -> partAssociation[rows]
	|>;

(* indexed or named multiple field *)
uploadFieldValue[Erase, Multiple, _List, (*units*)_, {rows:_Integer | _Span, columns:_Integer | _Span}]:=
	<|
		"$Type" -> "__JsonDeleteField__",
		"rows" -> partAssociation[rows],
		"columns" -> partAssociation[columns]
	|>;

uploadFieldValue[Erase, Single, {_Rule..}, (*units*)_, columns:{_Symbol...} | _Symbol]:=
	<|
		"$Type" -> "__JsonDeleteField__",
		"names" -> Map[SymbolName, ToList[columns]]
	|>;

uploadFieldValue[Erase, Multiple, {_Rule..}, (*units*)_, {All, columns:{_Symbol...} | _Symbol}]:=
	<|
		"$Type" -> "__JsonDeleteField__",
		"names" -> Map[SymbolName, ToList[columns]]
	|>;

uploadFieldValue[Erase, Multiple, {_Rule..}, (*units*)_, {rows:_Integer | _Span, columns:{_Symbol...} | _Symbol}]:=
	<|
		"$Type" -> "__JsonDeleteField__",
		"rows" -> partAssociation[rows],
		"names" -> Map[SymbolName, ToList[columns]]
	|>;

uploadFieldValue[operation:Append | Prepend | Replace | None, Multiple, class:_, units:_, values:_]:=
	Map[uploadFieldValue[operation, Single, class, units, #] &, values];

(* Indexed field *)
uploadFieldValue[Append | Prepend | Replace | None, Single, class:{Except[_Rule]...}, units:_, valueList:_List]:=
	MapIndexed[
		If[#1 === Null,
			Null,
			jsonValueData[Part[class, First[#2]], #1, Part[units, First[#2]]]
		]&,
		valueList
	];
(* that's essentially this, but with support for Nulls:
	MapThread[
		jsonValueData[#1, #2, #3] &,
		{class,valueList,units}
	];
*)

uploadFieldValue[Append | Prepend| Replace | None, Single, class:Except[_List], units:_, value:_]:=
	jsonValueData[class, value, units];

(* Named field *)
uploadFieldValue[Append | Prepend | Replace | None, Single, class:{_Rule...}, units:_, values:_]:=With[
	{
		stringClass=KeyMap[ToString, <|class|>],
		stringValues=KeyMap[ToString, values],
		stringUnits=KeyMap[ToString, <|units|>]
	},

	Merge[
		{stringClass, stringValues, stringUnits},
		Apply[jsonValueData[#1, #2, #3]&]
	]
];

(* Non indexed, non named field *)
uploadFieldValue[Except[Erase | EraseCases], Single, class:Except[_List], units:_, value:_]:=
	jsonValueData[class, value, units];

fieldOperation[field:_Symbol]:={None, field};
fieldOperation[(operation:_)[field:_Symbol]]:={operation, field};

uploadFieldFilter[_RuleDelayed]:=Nothing;
uploadFieldFilter[headerFieldsP -> _]:=Nothing;
uploadFieldFilter[x:_]:=x;

Authors[packetToJSONData]:={"platform"};

packetToJSONData[packet_Association]:=Block[{$NumberMarks=False},
	Module[{uploadFields, operations, fields, formats, classes, units, result, bigDataEncodingErrors},

		uploadFields=DeleteCases[Normal[packet], _RuleDelayed | (headerFieldsP[] -> _)];
		If[Length[uploadFields] == 0,
			Return[<||>]
		];

		{operations, fields}=Transpose[Map[fieldOperation, Keys[uploadFields]]];
		{formats, classes, units}=Transpose[
			Map[
				Lookup[{Format, Class, Units}],
				LookupTypeDefinition[packetToType[packet], fields]
			]
		];

		<|
			MapThread[
				Function[{uploadField, operation, format, class, unit, value},
					{result, bigDataEncodingErrors}=Reap[

						uploadFieldKey[uploadField] -> uploadFieldValue[
							operation,
							format,
							class,
							unit,
							value
						],
						"big-data-encoding"];
					If[Length[bigDataEncodingErrors] > 0,
						Message[Upload::BigDataField,
							uploadField,
							StringRiffle[Lookup[bigDataEncodingErrors[[1]], "message"], "\n"]
						]
					];
					result
				],
				{Keys[uploadFields], operations, formats, classes, units, Values[uploadFields]}
			]
		|>
	]
];

uploadFieldKey[symbol_Symbol]:=SymbolName[symbol];
uploadFieldKey[EraseCases[symbol_Symbol]]:=
	StringJoin["Erase[", SymbolName[symbol], "]"];
uploadFieldKey[(head:symbolHeadP)[symbol_Symbol]]:=StringJoin[
	ToString[head],
	"[",
	SymbolName[symbol],
	"]"
];

(* unit conversions going into the database *)
(* no-op Convert helper *)
unitConvert[_, v_, None]:=v;
unitConvert[_, Null, _]:=Null;
unitConvert[Real, from_?QuantityQ, to_?QuantityQ]:=N[Convert[from, to]];
(*TODO: (pavan) unitConvert[Integer, ] doesn't make sense to me. Unit Conversion has the potential to create non-integer values *)
unitConvert[Integer, from_?QuantityQ, to_?QuantityQ]:=Convert[from, to];
unitConvert[_, from_?QuantityQ, to_?QuantityQ]:=N[Convert[from, to]];
unitConvert[Real, from_?NumericQ, to_?QuantityQ]:= N[Quantity[from, Last[to]]];
unitConvert[_, from_?NumericQ, to_?QuantityQ]:= Quantity[from, Last[to]];
unitConvert[_, from:QuantityArrayP[], to_Quantity]:=Convert[from, Last[to]];
unitConvert[_, from:QuantityArrayP[], to:{(_Quantity | None)..}]:=Convert[from, Replace[to, None -> "DimensionlessUnit", {1}]];


(*catch-all no-op*)
unitConvert[_, v_, _]:=v;



(* ::Subsubsection:: *)
(*sendEraseLink*)


sendEraseLink[link:linkP]:=Module[
	{linkId, response},

	If[!linkHasIdQ[link],
		Message[EraseLink::AmbiguousLinkError];
		Return[$Failed]
	];

	linkId=unmissing[getLinkId[link]];
	response=ConstellationRequest[<|
		"Path" -> apiUrl["EraseLink", linkId],
		"Method" -> "DELETE"
	|>];

	If[MatchQ[response, _HTTPError],
		Return[$Failed]
	];

	ClearDownload[objectReferenceUnresolvedToObject /@ Lookup[response, "ModifiedReferences", {}]];

	True
];

unmissing[s_String]:=StringReplace[s, "Missing["~~x__~~"]" :> x];



(* ::Subsubsection:: *)
(*sendGetObjects*)


sendGetObjectsChunkSize=20000;

sendGetObjects[objectRequests:{({objectP | modelP, optionalDateP} -> _String)..}, limit_Integer, ignoreTimeOption:BooleanP, squashResponses:BooleanP]:=Module[
	{duplicateFree, requests, response, url},
	duplicateFree=DeleteDuplicates[objectRequests];
	requests=makeDownloadRequest[#, limit, ignoreTimeOption, squashResponses]& /@ duplicateFree;
	url=apiUrl["Download"];
	response=fetchInGroups[url, requests, sendGetObjectsChunkSize];

	If[MatchQ[response, _HTTPError],
		Message[Download::NetworkError, Last[response]];
		Return[{}]
	];

	If[Not[MatchQ[response, _Association]],
		Message[General::UnexpectedError, "Found an empty HTTP response body, instead of an association with results."];
		Return[{}]
	];
	response
];

objectToId[object:ReferenceWithNameP]:=ToString[object, InputForm];

objectToId[object:objectP | modelP]:=Last[object];


(*valid Part specification*)
partP=All | Span[_Integer, _Integer] | _Integer | Key[_Symbol] | {___Key} | {__Integer};

(*Download the entire object*)

makeDownloadRequest[Rule[{object:objectP | modelP, date:optionalDateP}, cas_String], limit_Integer, ignoreTimeOption:BooleanP, squashResponses:BooleanP]:=<|
	"object" -> ConstellationObjectReferenceAssoc[object],
	"cas" -> cas,
	"limit" -> limit,
	"encoding_options" -> <|
		"FullCloudFiles" -> True,
		"cloud_file_blobs" -> $CloudFileBlobs
	|>,
	If[MatchQ[date, None], Nothing,
		"date" -> DateObjectToRFC3339[date]],
	getDebugTimeRule[],
	"ignore_time" -> ignoreTimeOption,
	"squash_responses" -> squashResponses
|>;

(*Download specific fields from the object*)
makeDownloadRequest[object:objectP | modelP, date_, fields:{___Traversal}, limit_Integer, inclusiveSearch:True | False, ignoreTimeOption:BooleanP, squashResponses:BooleanP]:=<|
	"object" -> ConstellationObjectReferenceAssoc[object],
	"fields" -> {"Name"},
	"limit" -> limit,
	"encoding_options" -> <|
		"FullCloudFiles" -> True,
		"cloud_file_blobs" -> $CloudFileBlobs
	|>,
	"traversals" -> Flatten[Values[fieldSequenceToTraversal[#, inclusiveSearch]& /@ fields]],
	If[MatchQ[date, None], Nothing,
		"date" -> DateObjectToRFC3339[date]],
	getDebugTimeRule[],
	"ignore_time" -> ignoreTimeOption,
	"squash_responses" -> squashResponses
|>;

(** Converts a Query traversal step into row, column and name fields **)
queryToRequestTraversal[Query[Key[sym:_Symbol], row:partP]]:=
	<|
		"name" -> SymbolName[sym],
		rowAssociation[row]
	|>;

queryToRequestTraversal[Query[Key[sym:_Symbol], row:partP, column:partP]]:=
	<|
		"name" -> SymbolName[sym],
		rowAssociation[row],
		columnAssociation[column]
	|>;

(*Converts a Field expression to a nested set of associations to generate the traversal
JSON objects for the Download request.*)

(*Length is a special field that means the count of the field before it*)
Authors[fieldSequenceToTraversal]:={"platform"};

fieldSequenceToTraversal[
	Verbatim[Traversal][
		Verbatim[Length][lengthTraversal:Except[_Repeated]],
		___
	],
	True | False
]:=With[
	{lengthSymbol=SymbolName[First[Traversal[lengthTraversal]]]},

	"next" -> {
		<|
			"name" -> lengthSymbol,
			"summary_only" -> True
		|>
	}
];

fieldSequenceToTraversal[
	Verbatim[Traversal][Verbatim[Length][repeated:_Repeated], rest:___],
	inclusiveSearch:True | False
]:=With[
	{repeatedTraversal=MapAt[Traversal, repeated, 1]},

	fieldSequenceToTraversal[Traversal[repeatedTraversal, rest], inclusiveSearch]
];

fieldSequenceToTraversal[
	Verbatim[Traversal][PacketTarget[sym:_Symbol | {___Symbol}]],
	inclusiveSearch:True | False
]:=
	fieldSequenceToTraversal[Traversal[sym], inclusiveSearch];

fieldSequenceToTraversal[
	Verbatim[Traversal][sym_Symbol, rest___],
	inclusiveSearch:True | False
]:=
	"next" -> {
		<|
			"name" -> SymbolName[sym],
			fieldSequenceToTraversal[Traversal[rest], inclusiveSearch]
		|>
	};

fieldSequenceToTraversal[
	Verbatim[Traversal][fields:{___Symbol}, rest___],
	inclusiveSearch:True | False
]:=
	"next" -> Map[
		<|
			"name" -> #,
			fieldSequenceToTraversal[Traversal[rest], inclusiveSearch]
		|> &,
		Map[SymbolName, fields]
	];

fieldSequenceToTraversal[
	Verbatim[Traversal][
		Verbatim[Repeated][
			Verbatim[Traversal][query:_Query, repeatedRest___],
			repeatedArgs___,
			tag_String],
		rest___
	],
	inclusiveSearch:True | False
]:=
	"next" -> {
		<|
			queryToRequestTraversal[query],
			"tag" -> tag,
			repetitionAssociation[Traversal[repeatedRest], repeatedArgs, inclusiveSearch],
			fieldSequenceToTraversal[Traversal[rest], inclusiveSearch]
		|>
	};

fieldSequenceToTraversal[
	Verbatim[Traversal][
		Verbatim[Repeated][
			Verbatim[Traversal][sym_Symbol, repeatedRest___],
			repeatedArgs___,
			tag_String
		],
		rest___
	],
	inclusiveSearch:True | False
]:=
	"next" -> {
		<|
			"name" -> SymbolName[sym],
			"tag" -> tag,
			repetitionAssociation[Traversal[repeatedRest], repeatedArgs, inclusiveSearch],
			fieldSequenceToTraversal[Traversal[rest], inclusiveSearch]
		|>
	};

(** field has Part (row/column) components *)
fieldSequenceToTraversal[
	Verbatim[Traversal][query:_Query, rest___],
	inclusiveSearch:True | False
]:=
	"next" -> {
		<|
			queryToRequestTraversal[query],
			fieldSequenceToTraversal[Traversal[rest], inclusiveSearch]
		|>
	};

(* No traversal left, do not provide a "next" value *)
fieldSequenceToTraversal[Traversal[], True | False]:=Nothing;


rowAssociation[part:_Span | _Integer | {__Integer}]:="rows" -> partAssociation[part];
rowAssociation[Key[field:_Symbol]]:="sub_field_names" -> {SymbolName[field]};
rowAssociation[fields:{___Key}]:="sub_field_names" -> Map[SymbolName, fields[[All, 1]]];
rowAssociation[All]:=Nothing;


columnAssociation[part:_Span | _Integer | {__Integer}]:="columns" -> partAssociation[part];
columnAssociation[Key[field:_Symbol]]:="sub_field_names" -> {SymbolName[field]};
columnAssociation[fields:{___Key}]:="sub_field_names" -> Map[SymbolName, fields[[All, 1]]];
columnAssociation[All]:=Nothing;


partAssociation[Span[start_Integer, end_Integer]]:=<|
	"start" -> start,
	"end" -> end
|>;

partAssociation[index_Integer]:=<|
	"start" -> index,
	"end" -> index
|>;

partAssociation[indices:{__Integer}]:=<|
	"indices" -> indices
|>;

partAssociation[indices:{{_Integer}..}]:=
	partAssociation[Flatten[indices]];


repetitionAssociation[next:_Traversal, max:_Integer:-1, where:_:"", inclusiveSearch:True | False]:=
	"repeat" -> <|
		"max" -> maxInt[max],
		"next" -> First[Values[fieldSequenceToTraversal[next, inclusiveSearch]]],
		"where" -> whereString[where],
		"inclusive_search" -> inclusiveSearch
	|>;

repetitionAssociation[Traversal[], max:_Integer:-1, where:_:"", inclusiveSearch:True | False]:=
	"repeat" -> <|
		"max" -> maxInt[max],
		"where" -> whereString[where],
		"inclusive_search" -> inclusiveSearch
	|>;


maxInt[max:_Integer]:=max;

maxInt[Infinity]:=-1;


whereString[where_String]:=where;

whereString[Except[_String]]:="";

(*Fetches the objects from the server and saves them to the cache.
Returns the objects that were successfully fetched.*)
fetchAndCacheObjects[objects:{}, limit_Integer, ignoreTimeOption:BooleanP, squashResponses:BooleanP]:={};
fetchAndCacheObjects[objects:{(objectP | modelP -> _String)..}, limit_Integer, ignoreTimeOption:BooleanP, squashResponses:BooleanP]:=Module[
	{duplicateFree, responses, bigDataReferences},
	responses=sendGetObjects[objects, limit, ignoreTimeOption, squashResponses];

	(*Flatten out the tree of traversed_objects in the responses
	so that any duplicate traversals can be removed before adding them to the cache*)
	duplicateFree=DeleteDuplicates[
		Apply[
			Join,
			Append[
				traversalResponses /@ responses,
				responses
			]
		]
	];

	TraceExpression["cacheDownloadResponse",
		cacheDownloadResponse /@ duplicateFree
	]
];

fetchAndCacheObjects[objectRequests:{({objectP | modelP, optionalDateP} -> _String)..}, limit_Integer, ignoreTimeOption:BooleanP, squashResponses:BooleanP]:=Module[
	{duplicateFree, responses, bigDataReferences},
	responses=sendGetObjects[objectRequests, limit, ignoreTimeOption, squashResponses];

	(*Flatten out the tree of traversed_objects in the responses
	so that any duplicate traversals can be removed before adding them to the cache*)
	duplicateFree=DeleteDuplicates[
		Apply[
			Join,
			Append[
				traversalResponses /@ responses,
				responses
			]
		]
	];
	TraceExpression["cacheDownloadResponse",
		cacheDownloadResponse /@ duplicateFree
	]
];


(*Status Codes*)
$StatusOK=0;
$StatusNotFound=1;
$StatusUnchanged=2;
$StatusTypeMismatch=3;
$StatusRepeatCycle=4;
$StatusTraversalFailure=5;

traversalResponses[response_Association]:=With[
	{traversals=Lookup[response, "traversed_objects", {}]},

	Apply[
		Join,
		Append[
			traversalResponses /@ traversals,
			traversals
		]
	]
];


cacheDownloadResponse[response_Association]:=Module[
	{requestObject, resolvedObject, type, id, fields, limit, packet, summaries, name, nonzeroLength},
	requestObject=objectReferenceUnresolvedToObject[Lookup[response, "object", <||>]];
	(* If unable to parse the type we sent in the request from the response, do not cache the packet and fail*)
	If[requestObject === $Failed, Return[$Failed]];

	Switch[Lookup[response, "status_code", -1],
		$StatusUnchanged,
		Return[requestObject],

		$StatusNotFound,
		Return[Missing[requestObject, "NotFound"]],

		$StatusTypeMismatch,
		(* TODO(cmaloney): use resolvedObject to show the expected type vs. given type. *)
		Return[Missing[requestObject, "TypeMismatch"]]
	];

	(* If unable to parse the resolved object but no error response occurred error hard. *)
	resolvedObject=objectReferenceToObject[Lookup[response, "resolved_object", <||>]];
	If[resolvedObject === $Failed, Return[$Failed]];
	{packet, summaries}=parseDownloadResponse[response, resolvedObject];

	(*Merge new packet with any existing cache entries and update the global objectCache
	to the new value.*)
	objectCache=newCacheAssociation[packet, summaries, objectCache, downloadCounter];

	(*If this object has a name, create an entry in the name -> object lookup table*)
	name=Lookup[packet, Name, Null];
	type=Lookup[packet, Type];
	id=Lookup[packet, ID];

	If[!MatchQ[name, Null],
		AppendTo[nameCache, Append[type, name] -> resolvedObject]
	];

	(*Add raw ID object to cache*)
	AppendTo[idCache, id -> resolvedObject];

	resolvedObject
];

parseDownloadResponse[response_Association, resolvedObject_]:=TraceExpression["parseDownloadResponse", Module[
	{type, id, summaries, fields, limit, packet, nonzeroLength, timeString, timeObject},
	type=Most[resolvedObject];
	id=Last[resolvedObject];

	summaries=KeyMap[stringToSymbol, Lookup[response, "summaries", <||>]];
	fields=KeyMap[stringToSymbol, Lookup[response, "fields", <||>]];
	limit=Lookup[response, "limit", -1];
	timeString=Lookup[response, "date", None];

	timeObject=If[!MatchQ[timeString, None], TimeZoneConvert[DateObject[timeString, TimeZone -> 0]], None];

	packet=<|
		AssociationMap[objValueToField[type, #]&, fields],
		ID -> id,
		Object -> resolvedObject,
		Type -> type,
		"CAS" -> Lookup[response, "cas", ""],
		"Limit" -> If[limit <= 0, None, limit],
		"Tags" -> Lookup[response, "tags", {}],
		"date" -> Lookup[response, "date", ""]
	|>;

	nonzeroLength=Keys[Select[
		summaries,
		MatchQ[KeyValuePattern["Count" -> Except[0]]]
	]];

	packet=addDefaultValues[
		addLazyFields[
			resolvedObject,
			addComputableFields[packet, timeObject],
			Complement[nonzeroLength, Keys[fields]]
		],
		Keys[fields]
	];

	{packet, summaries}
]];

addLazyFields[object:objectP | modelP, packet_Association, fields:{}]:=packet;
addLazyFields[object:objectP | modelP, packet_Association, fields:{__Symbol}]:=Join[
	packet,
	Association[
		Map[
			RuleDelayed[#, object[#]]&,
			fields
		]
	]
];

newCacheAssociation[
	packet_Association,
	summaries_Association,
	cache_Association,
	downloadCount:_:downloadCounter
]:=Module[
	{cached, oldTags, oldToken, oldPacket, oldSummaries, oldSession,
		withFieldPart, limit, casToken, name, tags, timestamp, oldFields, sameCASQ, key, timeObject},
	limit=Lookup[packet, "Limit", None];
	casToken=Lookup[packet, "CAS", ""];
	timestamp=Lookup[packet, "date", ""];
	tags=Lookup[packet, "Tags", {}];
	name=Lookup[packet, Name, Null];

	timeObject=If[MatchQ[timestamp, ""], None, Rfc3339ToDateObject[timestamp]];
	key=getObjectCacheKey[Lookup[packet, Object], timeObject];
	cached=Lookup[cache, Key[key], <||>];

	oldTags=Lookup[cached, "Tags", {}];
	oldToken=Lookup[cached, "CAS"];
	oldFields=Lookup[cached, "Fields", <||>];
	oldPacket=Lookup[cached, "Packet", <||>];
	oldSummaries=Lookup[cached, "FieldSummaries", <||>];
	oldSession=Lookup[cached, "Session"];

	sameCASQ=SameQ[oldToken, casToken];

	withFieldPart=Association[
		Map[
			Rule[
				Traversal[Evaluate[First[#]]],
				Association[
					"Rule" -> #,
					"Limit" -> limit,
					"DownloadCount" -> downloadCount
				]
			]&,
			Normal[KeyDrop[packet, {"CAS", "Limit", "Tags"}]]
		]
	];

	Append[
		cache,
		key -> <|
			"CAS" -> casToken,
			"Name" -> name,
			(*Stores the fields and the limit each field was fetched at*)
			"Fields" -> Merge[
				{
					If[sameCASQ,
						oldFields,
						<||>
					],
					withFieldPart
				},
				mergeFieldsWithLimit
			],
			If[Not[sameCASQ] || MissingQ[oldSession],
				Nothing,
				"Session" -> oldSession
			],
			"FieldSummaries" -> If[Not[sameCASQ],
				summaries,
				Append[oldSummaries, summaries]
			],
			"Tags" -> If[sameCASQ,
				Join[oldTags, tags],
				tags
			]
		|>
	]
];

(* each of these args is something like <| "Rule"->_Rule|_RuleDelayed, "Limit"->_Integer|None, ... |> *)
mergeFieldsWithLimit[{assoc_Association}]:=assoc;
mergeFieldsWithLimit[{old_Association, new_Association}]:=With[
	{
		oldLimit=Replace[Lookup[old, "Limit"], None -> Infinity, {0}],
		newLimit=Replace[Lookup[new, "Limit"], None -> Infinity, {0}],
		wasRuleDelayed=Head[Lookup[old, "Rule"]] === RuleDelayed
	},

	If[oldLimit >= newLimit && Not[wasRuleDelayed],
		old,
		new
	]
];

addComputableFields[packet_Association, date:_?DateObjectQ | None]:=With[
	{
		fieldDefinitions=Lookup[LookupTypeDefinition[packetToType[packet]], Fields],
		object=Lookup[packet, Object]
	},

	Append[
		packet,
		Map[
			generateComputable[object, #, date] &,
			fieldDefinitions
		]
	]
];
generateComputable[object:objectP | modelP, fieldSymbol_Symbol -> rules_List, date:_?DateObjectQ | None]:=With[
	{
		expressionRule=SelectFirst[rules, First[#] === Expression&],
		format=Lookup[rules, Format]
	},

	If[MatchQ[format, Computable],
		ReplacePart[
			ReplaceAll[
				expressionRule,
				(*This should remain Field and not Traversal since it's in the Type defition*)
				Field[sym_Symbol] :> Download[object, sym, Date -> date, Verbose -> False]
			],
			{1} -> fieldSymbol
		],
		Nothing
	]
];
computeFieldValue[object:objectP, field_Symbol]:=With[
	{definition=LookupTypeDefinition[objectToType[object], field]},

	Last[generateComputable[object, field -> definition, None]]
];


(* ::Subsubsection:: *)
(* Add "id: if missing to prevent bad strings from resulting in even worse results. *)


peekToRef[id_String?(StringStartsQ[#, "id:"]&)]:=<|"id" -> id|>;
peekToRef[id_String]:=<|"id" -> "id:"<>id|>;
peekToRef[object:(objectP | modelP)]:=ConstellationObjectReferenceAssoc[object];

enableIdCasAssoc=True;
idCasAssociation=<||>;
idCasAssociationDownloadCounter=0;

getIdCASKey[id:_String]:=
	If[MatchQ[$DownloadTime, _?DateObjectQ],
		{id, $DownloadTime},
		id
	];

getCASHitsMisses[objects:{(objectP | modelP | _String)..}]:=Module[
	{ids, CASAssociationChecks, CASAssociationMissesPos, missingObjects, hitValues, retRules},

	retRules=If[TrueQ[enableIdCasAssoc] && !MatchQ[idCasAssociationDownloadCounter, 0],
		ids=If[StringQ[#], #, Lookup[ConstellationObjectReferenceAssoc[#], "id"]]& /@ objects;
		CASAssociationChecks=Lookup[idCasAssociation, Key[getIdCASKey[#]]] & /@ ids ;
		hitValues=Cases[CASAssociationChecks, Except[_Missing], {1}];
		CASAssociationMissesPos=Position[CASAssociationChecks, _Missing, {1}];
		missingObjects=Extract[objects, CASAssociationMissesPos];
		{"missingObjects" -> missingObjects, "hitValues" -> hitValues},
		{"missingObjects" -> objects, "hitValues" -> {}}
	];
	retRules
];

sendPeekObjects[objects:{(objectP | modelP | _String)..}]:=Module[
	{request, response, missingObjects, hitValues, idCasRet, nonEmptyIdEntries},

	idCasRet=getCASHitsMisses[objects];

	missingObjects="missingObjects" /. idCasRet;
	hitValues="hitValues" /. idCasRet;

	If[Length[missingObjects] == 0,
		Return[hitValues]
	];

	request=exportUnicodeJSON[<|
		"requests" -> Map[<|"object" -> peekToRef[#], "fields" -> {"ID"}, "limit" -> 0|>&, missingObjects],

		(* Also send the time at which to download the object, if $DownloadTime is set. *)
		If[MatchQ[$DownloadTime, _?DateObjectQ],
			"date" -> DateString[$DownloadTime, {"ISODateTime", "ISOTimeZone"}],
			Nothing
		]
	|>];
	If[request === $Failed, Return[$Failed]];

	response=ConstellationRequest[<|
		"Path" -> apiUrl["Download"],
		"Body" -> request,
		"Method" -> "POST",
		"Timeout" -> 360000
	|>,
		Retries -> 4,
		RetryMode -> Read
	];

	ret=If[MatchQ[response, _HTTPError],
		$Failed,
		Lookup[response, "responses", $Failed]
	];

	(*
		Additionally verify that we are actually inside a download call. DatabaseMemberQ independently
		also does a peek check but we do not want to store Cache in that case.
	*)

	If[ret =!= $Failed && TrueQ[enableIdCasAssoc] && !MatchQ[idCasAssociationDownloadCounter, 0],
		nonEmptyIdEntries=Select[ret, Lookup[#, "id", ""] != "" &];
		idCasAssociation=Join[idCasAssociation, Association[Map[getIdCASKey[Lookup[#, "id"]] -> # &, nonEmptyIdEntries]]];
		ret=Join[ret, hitValues];
	];
	ret
];

(*Returns an associations of objects to responses (may be an Association, Null, or $Failed).
$Failed means there was an error with the request, Null means the object does not exist.
Adds keys for both the Name/ID versions of the objects which returned successfully*)
peekObjects[{}]:=Association[];
peekObjects[objects:{(objectP | modelP | _String)..}]:=Module[
	{uniqueObjects, responses},

	uniqueObjects=DeleteDuplicates[objects];
	responses=sendPeekObjects[uniqueObjects];
	If[responses === $Failed, Return[Association[Map[# -> $Failed &, uniqueObjects]]]];

	Association[
		MapThread[
			Function[{obj, response},
				If[KeyExistsQ[response, "resolved_object"],
					obj -> response,
					obj -> Null
				]
			],
			{uniqueObjects, responses}
		]
	]
];

peekResultToObject[assoc_Association]:=Lookup[assoc, Object];
peekResultToObject[_]:=$Failed;



(* ::Subsubsection:: *)
(*fetchAndCacheFields*)


lastRequests=None;
lastResponse=None;

(*Downloads the specific fields specified for each object in the association.
Returns an association of objects to associations with the field/value pairs
which were downloaded.*)
fetchAndCacheFields[Association[], limit_Integer, True | False, ignoreTimeOption:BooleanP, squashResponses:BooleanP]:=Association[];
fetchAndCacheFields[association_Association, limit_Integer, inclusiveSearch:True | False, ignoreTimeOption:BooleanP, squashResponses:BooleanP]:=Module[
	{requests, response, nestedResponses, url, downloadedObjects, missingObjects, dates, downloadObjectsWithDates},

	(* this seems to be deliberately not-protected *)
	lastRequests=requests=KeyValueMap[
		makeDownloadRequest[First[#1], Last[#1], Lookup[#2, "Fields"], limit, inclusiveSearch, ignoreTimeOption, squashResponses]&,
		association
	];

	url=apiUrl["Download"];

	(* this also seems to be deliberately not-protected *)
	lastResponse=response=fetchInGroups[url, requests, 20000];

	(*Return if there was an error making the request*)
	If[MatchQ[response, _HTTPError],
		Return[response]
	];

	TraceExpression["cacheDownloadResponse",
		downloadedObjects=Map[cacheDownloadResponse, Lookup[response, "responses", {}]];
		dates=Rfc3339ToDateObject /@ Map[Lookup[#, "date", ""] &, Lookup[response, "responses", {}]];
		(*Find all the nested traversal responses and remove any duplicates before
		adding to the cache. Converting the associations to the correct expressions
		and adding them to the cache can be expensive work. Also, if traversals are flattened
		by setting squashResponses, skip these operations.*)
		If[squashResponses == False,
			nestedResponses=DeleteDuplicates[
				Apply[
					Join,
					traversalResponses /@ Lookup[response, "responses", {}]
				]
			];

			(* Add all the nested responses to the cache*)
			Scan[cacheDownloadResponse, nestedResponses];
		];
	];

	downloadObjectsWithDates=Transpose[{downloadedObjects, dates}];

	Replace[
		downloadObjectsWithDates,
		{
			RuleDelayed[
				{obj:(objectP | modelP), date_}?(Not[KeyExistsQ[objectCache, getObjectCacheKey[cacheObjectID[First[#1]], Last[#1]]]]&),
				Missing[object, "NotFound"]
			],
			{missingHead_Missing, _} :> missingHead
		},
		{1}
	]
];

downloadChunk[errorResponse:_HTTPError, {_Association...}, _String]:=
	errorResponse;

downloadChunk[previousResponses:{_Association...}, chunk:{_Association...}, fetchUrl:_String]:=Module[
	{body, response},

	body=Check[
		exportUnicodeJSON[<|"requests" -> chunk|>],
		$Failed
	];

	If[body === $Failed,
		With[
			{errorPath=FileNameJoin[{$TemporaryDirectory, ToString[UnixTime[]]<>"_download_failure.mx"}]},

			Export[errorPath, {chunk, body}, "MX"];
			Return[HTTPError[None, "Unable to generate JSON request body. See "<>errorPath]]
		]
	];

	response=ConstellationRequest[
		Association[
			"Path" -> fetchUrl,
			"Body" -> body,
			"Method" -> "POST",
			"Timeout" -> 360000
		],
		Retries -> 4,
		RetryMode -> Read
	];

	(*If there was an error, return that and ignore previous responses*)
	If[MatchQ[response, _HTTPError],
		response,
		Append[previousResponses, response]
	]
];

(*Fetch the list of encodedObjects in groups of chunkSize. If any single request fails,
return the HTTPError and do not make any more requests. If all requests are successful,
returns the requests joined together as if a single call had been made with all the objects.*)
fetchInGroups[fetchUrl_String, requests:{___Association}, chunkSize_Integer]:=Module[
	{responses, bigDataReferences},

	responses=Fold[
		downloadChunk[#1, #2, fetchUrl]&,
		{},
		Partition[requests, UpTo[chunkSize]]
	];

	If[MatchQ[responses, _HTTPError],
		Return[responses]
	];

	(*If there are traversal objects, responses will be associations, otherwise they will be
	lists of packet responses.*)
	responses=If[MatchQ[responses, {__Association}],
		Merge[responses, Apply[Join, #]&],
		Apply[Join, responses]
	];

	responses
];

downloadBlobReferences::downloadError="There was an error detected while downloading the big data field: `1`";
downloadBlobReferences[{}]:=None;
downloadBlobReferences[bigDataReferences:{{_String, _String}..}, byteLimit_]:=Module[
	{toDownload, headResults, downloadResults, downloadErrors, bigDataReferencesFiltered, filesAreDownloaded},
	headResults=LessThan[byteLimit] /@ ToExpression /@ Lookup[Map[
		Function[{downloadInfo},
			GoCall["HeadCloudFile", <|
				"Bucket" -> downloadInfo[[1]],
				"Key" -> downloadInfo[[2]],
				"Retries" -> 4
			|>]
		],
		bigDataReferences
	], "ContentSize", {}];
	bigDataReferencesFiltered=Pick[bigDataReferences, headResults];

	(* If we've reached here, we've either commited to downloading the file or have already downloaded the file *)
	filesAreDownloaded=If[Length[bigDataReferencesFiltered] > 0, True, False];
	(* construct a list of localPaths that do not exist in the temp directory.
		we must also save the key and bucket values in order to download them.
	*)

	toDownload=Select[
		Map[
			Function[{blobRef},
				With[{localFilePath=makeBlobRefTempFilePath[blobRef[[2]], Download]},
					<|
						"key" -> blobRef[[2]],
						"bucket" -> blobRef[[1]],
						"localFile" -> localFilePath
					|>
				]
			],
			bigDataReferencesFiltered
		],
		Not@FileExistsQ[#["localFile"]]&
	];

	downloadResults=Map[
		Function[{downloadInfo},
			GoCall["DownloadCloudFile", <|
				"Path" -> downloadInfo["localFile"],
				"Bucket" -> downloadInfo["bucket"],
				"Key" -> downloadInfo["key"],
				"Retries" -> 4
			|>]
		],
		toDownload
	];

	downloadErrors=Lookup[downloadResults, "Error", Nothing];
	If[Length[downloadErrors] > 0,
		Scan[Message[downloadBlobReferences::downloadError, #]&, downloadErrors];
		Return[$Failed];
	];
	filesAreDownloaded
];



(* Convert JSON values to final Mathematica expressions based on the field Class/Units/Relations.
Each overload if of the form [Class,Units,Relation,Value].*)
objValueToFieldValue[_, _, _, Null]:=Null;
objValueToFieldValue[Expression, _, _, str_String]:=ToExpression[str];
objValueToFieldValue[String, _, _, str_String]:=str;
objValueToFieldValue[Boolean, _, _, bool:(True | False)]:=bool;
objValueToFieldValue[Date, _, _, dateString_String]:=utcISODateStringToLocalDateObject[dateString, $TimeZone];
objValueToFieldValue[Integer, units_, _, value_Integer]:=wrapAsQuantity[
	value,
	units
];
objValueToFieldValue[Real, units_, _, value:(_Integer | _Real)]:=wrapAsQuantity[
	N[value],
	units
];
objValueToFieldValue[Compressed, units_, _, compressed_String]:=With[
	{value=Uncompress[compressed]},
	If[ListQ[value],
		Map[
			wrapAsQuantity[#, units]&,
			value
		],
		wrapAsQuantity[value, units]
	]
];

(* TODO: maybe the same logic that applies to big quantity arrays should apply to BigCompressedFields? *)
objValueToFieldValue[BigCompressed, units_, _, blobRef:jsonBlobReferenceP]:=Module[
	{tempFile, importResult, bucket, hash},
	{bucket, hash}=Lookup[blobRef, {"bucket", "hash"}];
	downloadBlobReferences[{{bucket, hash}}, Infinity];
	tempFile=makeBlobRefTempFilePath[blobRef["hash"], Download];
	importResult=Import[tempFile, "Text"];
	If[Not@MatchQ[importResult, _String],
		Sow[<|"message" -> "importing data."|>, "big-data-decoding"];
		Return[$Failed]
	];

	Uncompress[importResult]
];

objValueToFieldValue[Distribution, _, _, assoc_Association]:=ToExpression[Lookup[assoc, "mathematica_value"]];


objValueToFieldValue[QuantityArray, units_, _, compressed_String]:=With[
	{value=Uncompress[compressed]},
	If[And[!MatchQ[value, QuantityArrayP[]], value =!= Null],
		QuantityArray[value, units],
		wrapAsQuantity[value, units]
	]
];

binaryReadBigQAHeader[inStream_InputStream, atMost_Integer]:=Module[
	{c, buf},
	c="";
	buf="";
	Do[
		c=BinaryRead[inStream, "Character8"];
		If[MatchQ[c, "\n" | EndOfFile], Break[]];
		If[Not@MatchQ[c, _String],
			Return[$Failed];
		];

		buf=StringJoin[buf, c],
		{atMost}
	];
	buf
];

bigQABinaryHeaderP=KeyValuePattern[{
	"version" -> _Integer,
	"encoder" -> _String,
	"binaryRowFormat" -> _List,
	"mathematicaUnits" -> _String,
	"dimensions" -> _List
}];

bigQAValidVersionP=1; (* make this alternatives as we add more version. 1 | 2 | 3 ...*)

objValueToFieldValue[BigQuantityArray, units_, _, blobRef:jsonBlobReferenceP]:=convertBlobToCloudFile[blobRef];

(* Used from fast download. Which already handles bigQAByteLimit as well as downloading the blob reference *)
downloadBigQAArrayFromFilePath[$Failed] := $Failed;
downloadBigQAArrayFromFilePath[filepath_String] := Module[{inStream, header, headerData,
	encodingVersion, binaryRowFormat, rawData},
	inStream=OpenRead[filepath, BinaryFormat -> True];
	If[Not@MatchQ[inStream, _InputStream],
		Sow[<|"message" -> "opening input stream"|>, "big-data-decoding"];
		Return[$Failed]
	];

	(* reader the header, which should be JSON *)
	headerData=binaryReadBigQAHeader[inStream, $bigQuantityArrayBinaryEncodeMaxHeaderSize];
	If[Not@MatchQ[headerData, _String],
		Sow[<|"message" -> "reading header from in stream"|>, "big-data-decoding"];
		Return[$Failed]
	];

	(* attempt to decode the header as JSON *)
	header=ImportString[headerData, "RawJSON"];
	If[Not@MatchQ[header, bigQABinaryHeaderP],
		Sow[<|"message" -> "header not correctly formated: "<>ToString[header, InputForm]|>, "big-data-decoding"];
		Return[$Failed]
	];

	encodingVersion=header["version"];
	If[Not@MatchQ[encodingVersion, bigQAValidVersionP],
		Sow[<|"message" -> "header version not supported: "<>ToString[header, InputForm]|>, "big-data-decoding"];
		Return[$Failed]
	];

	(* read rest of the file in with BinaryReadList *)
	binaryRowFormat=header["binaryRowFormat"];
	rawData=BinaryReadList[inStream, binaryRowFormat];
	Close[inStream];

	(* decode the units, and construct the quantity array from this *)
	(* convert the quantity array to the defined units of the type. *)
	wrapAsQuantity[
		QuantityArray[rawData, decodeExpressionB64[header["mathematicaUnits"]]],
		units
	]
];


downloadBigQAArray[cloudFile_EmeraldCloudFile]:=Module[{tempFile,
	inStream,
	headerData,
	header,
	encodingVersion,
	binaryRowFormat,
	rawData,
	hash,
	bucket,
	blob
},
	If[MatchQ[cloudFile, Null], Return[Null]];

	blob=convertCloudFileToBlob[cloudFile];
	{bucket, hash}=Lookup[blob, {"bucket", "hash"}];

	If[!TrueQ[downloadBlobReferences[{{bucket, hash}}, qaByteLimit]], Return[BigQuantityArrayByteLimit]];

	tempFile=makeBlobRefTempFilePath[hash, Download];
	inStream=OpenRead[tempFile, BinaryFormat -> True];
	If[Not@MatchQ[inStream, _InputStream],
		Sow[<|"message" -> "opening input stream"|>, "big-data-decoding"];
		Return[$Failed]
	];

	(* reader the header, which should be JSON *)
	headerData=binaryReadBigQAHeader[inStream, $bigQuantityArrayBinaryEncodeMaxHeaderSize];
	If[Not@MatchQ[headerData, _String],
		Sow[<|"message" -> "reading header from in stream"|>, "big-data-decoding"];
		Return[$Failed]
	];

	(* attempt to decode the header as JSON *)
	header=ImportString[headerData, "RawJSON"];
	If[Not@MatchQ[header, bigQABinaryHeaderP],
		Sow[<|"message" -> "header not correctly formated: "<>ToString[header, InputForm]|>, "big-data-decoding"];
		Return[$Failed]
	];

	encodingVersion=header["version"];
	If[Not@MatchQ[encodingVersion, bigQAValidVersionP],
		Sow[<|"message" -> "header version not supported: "<>ToString[header, InputForm]|>, "big-data-decoding"];
		Return[$Failed]
	];

	(* read rest of the file in with BinaryReadList *)
	binaryRowFormat=header["binaryRowFormat"];
	rawData=BinaryReadList[inStream, binaryRowFormat];
	Close[inStream];

	(* decode the units, and construct the quantity array from this *)
	(* convert the quantity array to the defined units of the type. *)
	wrapAsQuantity[
		QuantityArray[rawData, decodeExpressionB64[header["mathematicaUnits"]]],
		units
	]
];

downloadBigQAArray[obj_]:=obj;


jsonEmeraldCloudFileP=KeyValuePattern[{
	"$Type" -> "__JsonEmeraldCloudFile__",
	"Bucket" -> _String,
	"Key" -> _String,
	"CloudFileId" -> _String
}];

objValueToFieldValue[EmeraldCloudFile, _, _, str_String]:=ToExpression[str];
objValueToFieldValue[EmeraldCloudFile, _, _, ecf:jsonEmeraldCloudFileP]:=With[
	{
		bucket=Lookup[ecf, "Bucket"],
		key=Lookup[ecf, "Key"],
		cloudFileId=Lookup[ecf, "CloudFileId"]
	},
	EmeraldCloudFile["AmazonS3", bucket, key, cloudFileId]
];

jsonVariableUnitP=KeyValuePattern[{
	"$Type" -> "__JsonVariableUnit__",
	"mathematica_value" -> _String
}];
objValueToFieldValue[VariableUnit, units_, _, vu:jsonVariableUnitP]:=ToExpression[Lookup[vu, "mathematica_value"]];

objValueToFieldValue[Link, _, _, id_String]:=Link[Object[id]];

(*
	TODO: Note that oneWayJsonLinkP is a subset of twoWayJsonLinkP. So Json that matches twoWayJsonLinkP, also matches onewayJsonLink. But not vice versa
	TODO: We currently use the order of function definitions to make sure the overloads work properly
	TODO: fix oneWayJsonLinkP to not match twoWayLinks
*)

oneWayJsonLinkP=KeyValuePattern[{
	"$Type" -> "__JsonLink__",
	"id" -> _String,
	"object" -> KeyValuePattern[{
		"id" -> _String,
		"type" -> _String
	}]
}];

twoWayJsonLinkP=KeyValuePattern[{
	"$Type" -> "__JsonLink__",
	"id" -> _String,
	"object" -> KeyValuePattern[{
		"id" -> _String,
		"type" -> _String
	}],
	"field" -> KeyValuePattern[{
		"name" -> _String,
		"sub_field_index" -> _Integer,
		"sub_field_name" -> _String
	}]
}];

JsonLinkP=oneWayJsonLinkP | twoWayJsonLinkP;


objValueToFieldValue[Link | TemporalLink, _, relation_, assoc:JsonLinkP]:=Module[
	{objectId, linkId, type, dateString, dateObject, validRelations, finishedLink},

	objectId=assoc[["object", "id"]];
	type=stringToType[assoc[["object", "type"]]];
	linkId=assoc[["id"]];
	dateString=assoc[["date"]];

	dateObject=If[MatchQ[dateString, _Missing], Nothing, Rfc3339ToDateObject[dateString]];

	(* if type is unknown to the client return UnsupportedLink so we can filter it out *)
	If[type === $Failed || !TypeQ[type],
		Return[UnsupportedLink]
	];

	validRelations=Flatten[
		ReplaceAll[
			{relation},
			Alternatives -> List
		]
	];

	finishedLink=finishObjValueToFieldValue[objectId, type, linkId, validRelations, assoc];
	(* Nothings delete themselves from lists *)
	If[MatchQ[finishedLink, UnsupportedLink], finishedLink, Link @@ Append[List @@ finishedLink, dateObject]]
];

(* *)

(*Two way links*)
finishObjValueToFieldValue[objectId_, type_, linkId_, validRelations_, assoc:twoWayJsonLinkP]:=Module[
	{toField, fieldName, subFieldIndex, subFieldName},

	fieldName=stringToSymbol[assoc[["field", "name"]]];
	subFieldIndex=assoc[["field", "sub_field_index"]];
	subFieldName=assoc[["field", "sub_field_name"]];
	toField=Which[
		subFieldName =!= "",
		type[fieldName, stringToSymbol[subFieldName]],

		subFieldIndex > 0,
		type[fieldName, subFieldIndex],

		True,
		type[fieldName]
	];

	If[AnyTrue[validRelations, MatchQ[toField, subFieldP[#]]&],
		(* it matches so return the Link *)
		Link[Append[type, objectId], Sequence @@ toField, linkId],

		(* it doesn't match the relations *)
		If[AnyTrue[validRelations, MatchQ[type, TypeP[#]]&],
			(* for an old two-way link, convert to one-way *)
			Link[Append[type, objectId], linkId],

			(* otherwise return UnsupportedLink so we can filter it *)
			UnsupportedLink
		]
	]
];

(*One way links*)
finishObjValueToFieldValue[objectId_, type_, linkId_, validRelations_, assoc:oneWayJsonLinkP]:=Module[
	{},
	If[AnyTrue[validRelations, MatchQ[type, TypeP[#]]&],
		(* it matches so return the Link *)
		Link[Append[type, objectId], linkId],

		(* otherwise return UnsupportedLink so we can filter it *)
		UnsupportedLink
	]
];

(*Match an sub-fields of the given field*)
subFieldP[(head:(Object | Model))[symbols___Symbol][field_Symbol, index:Repeated[(_Integer | _Symbol), {0, 1}]]]:=head[
	symbols,
	___Symbol
][field, index];

(* if $TimeZone is anything wacky, like a TimeZoneEntity, let mathematica handle it *)
utcISODateStringToLocalDateObject[dateString_, timeZone_]:=Module[
	{format},
	If[StringContainsQ[dateString, "."],
		format={"Year", "-", "Month", "-", "Day", "T", "Hour24", ":", "Minute", ":", "Second", ".", "Millisecond", "Z"},
		format={"Year", "-", "Month", "-", "Day", "T", "Hour24", ":", "Minute", ":", "Second", "Z"}
	];

	TimeZoneConvert[
		DateObject[DateList[{dateString, format}], TimeZone -> 0],
		timeZone
	]
];

objValueToField[type:typeP, Rule[$Failed, value:_]]:=Nothing;
objValueToField[type:typeP, Rule[key:_String, value:_]]:=With[
	{symbol=stringToSymbol[key]},

	objValueToField[type, symbol -> value]
];

objValueToField[type:typeP, Rule[symbol:_Symbol, value:_]]:=Module[
	{definition, result, bigDataDecodingErrors},

	definition=Quiet[
		LookupTypeDefinition[type, symbol, {Format, Class, Units, Relation}],
		{LookupTypeDefinition::NoFieldDefError, LookupTypeDefinition::NoFieldComponentDefError}
	];

	If[FailureQ[definition],
		Return[Nothing]
	];

	{result, bigDataDecodingErrors}=Reap[
		If[And[FieldQ[type[symbol]], Not[ComputableFieldQ[type[symbol]]]],
			symbol -> objValueToField[Sequence @@ definition, value],
			Nothing
		],
		"big-data-decoding"
	];
	If[Length[bigDataDecodingErrors] > 0,
		Message[Download::BigDataField,
			symbol,
			StringRiffle[Lookup[bigDataDecodingErrors[[1]], "message"], "\n"]
		]
	];
	result
];

(* Named Multiple Field *)
objValueToField[Multiple, class:{_Rule..}, units:_, relation:_, values:{<|(_String -> _) ..|>...}]:=
	Map[objValueToField[Single, class, units, relation, #]&, values];

(* Indexed Multiple Field *)
objValueToField[Multiple, class:{Except[_Rule]..}, units:_, relation:_, values:{_List ..}]:=
	Map[objValueToField[Single, class, units, relation, #]&, values];

(* Multiple non indexed, non named *)
objValueToField[Multiple, class:Except[_List], units:_, relation:_, values:_List]:=
	(* filter out UnsupportedLink sentinels for links to unsupported types/fields *)
	DeleteCases[
		Map[objValueToFieldValue[class, units, relation, #]&, values],
		UnsupportedLink,
		{1}
	];

(* Named Single Field *)
objValueToField[Single, class:{_Rule..}, units:_, relation:_, values:<|(_String -> _) ..|>]:=
	(* Null out UnsupportedLink sentinels for links to unsupported types/fields *)
	Replace[
		Merge[{class, units, relation, KeyMap[Symbol, values]}, Apply[objValueToFieldValue]],
		UnsupportedLink -> Null,
		{1}
	];

(* Indexed Single Field *)
objValueToField[Single, class:{Except[_Rule]..}, units:_, relation:_, values:_List]:=
	(* Null out UnsupportedLink sentinels for links to unsupported types/fields *)
	Replace[
		MapThread[objValueToFieldValue, {class, units, relation, values}],
		UnsupportedLink -> Null,
		{1}
	];

(* Single field *)
objValueToField[Single, class:Except[_List], units:_, relation:_, value_]:=
	(* Null out UnsupportedLink sentinels for links to unsupported types/fields *)
	Replace[
		objValueToFieldValue[class, units, relation, value],
		UnsupportedLink -> Null,
		{0}
	];

(* turn values into quantities coming out of the database.  NO UNIT CONVERSION should be happening here *)
(* no op*)
wrapAsQuantity[v_, None]:=v;
wrapAsQuantity[v_, {None..}]:=v;
wrapAsQuantity[Null, _]:=Null;

wrapAsQuantity[v_?NumericQ, quant_Quantity]:=Quantity[v, Last[quant]];
wrapAsQuantity[q1_Quantity, q2_Quantity]:=q1;
wrapAsQuantity[l_List, quants:{(_Quantity | None)..}]:=MapThread[wrapAsQuantity[#1, #2]&, {l, quants}];
wrapAsQuantity[v:QuantityArrayP[], quant_]:=v;

getCasToken[packet_Association]:=Lookup[
	Lookup[
		objectCache,
		Lookup[packet, Object],
		<||>
	],
	"CheckAndSetToken",
	""
];

(* place these outside module scope so we can patterm match on them in sub functions *)
placeholderSymbols={
	equalsSym,
	notEqualsSym,
	andSym,
	orSym,
	greaterSym,
	greaterEqualsSym,
	lessSym,
	lessEqualsSym,
	partSym,
	lengthSym,
	altsSym,
	stringExpressionSym,
	maxSym,
	minSym,
	linkSym,
	allSym,
	exactlySym,
	anySym,
	stringContainsQSym
};

comparatorP=Alternatives[
	equalsSym,
	notEqualsSym,
	greaterSym,
	greaterEqualsSym,
	lessSym,
	lessEqualsSym,
	stringContainsQSym
];

comparatorConditionP=Alternatives[
	allSym,
	exactlySym,
	anySym
];

superlativeP=Alternatives[
	maxSym,
	minSym
];

(* Given f and {Hold[a[x]], Hold[b[x]]..}, returns Hold[f[a[x],b[x]..]]. *)
holdCompositionList[f_,{helds___Hold}]:=Module[{joinedHelds},
	(* Join the held heads. *)
	joinedHelds=Join[helds];

	(* Swap the outter most hold with f. Then hold the result. *)
	With[{insertMe=joinedHelds},holdComposition[f,insertMe]]
];
SetAttributes[holdCompositionList,HoldAll];

(* Given f and Hold[g[x]], return Hold[f[g[x]]] without evaluating anything. *)
holdComposition[f_,Hold[expr__]]:=Hold[f[expr]];
holdComposition[List,{}]:=Hold[{}];
SetAttributes[holdComposition,HoldAll];

Authors[searchClauseString]:={"platform"};

DefineOptions[
	searchClauseString,
	Options :> {
		{Type -> None, TypeP[] | None, "The type this search clause is for. Extra validation will be done when specified."},
		{DeveloperObject -> False, True | False, "When False, automatically adds DeveloperObject!=True if DeveloperObject is not in the query."}
	}
];

SetAttributes[transformHeldExpressionToStandardizedTreeForm, HoldFirst];


(* Authors definition for Constellation`Private`transformHeldExpressionToStandardizedTreeForm *)
Authors[Constellation`Private`transformHeldExpressionToStandardizedTreeForm]:={"melanie.reschke"};

transformHeldExpressionToStandardizedTreeForm[heldExpr_, ops:OptionsPattern[]] := Module[{placeholderRules, replacedExpression, releasedExpr},
	(* Convert MM symbol (ex. Max) into our custom symbols (ex. maxSym) so that we don't have to worry about holding to prevent evaluation. *)
	placeholderRules={
		HoldPattern[Part[xs_, i_]] :> partSym[xs, i],
		Length -> lengthSym,
		Equal | SameQ | Set -> equalsSym,
		Any -> anySym,
		All -> allSym,
		Exactly -> exactlySym,
		Unequal | UnsameQ -> notEqualsSym,
		Greater -> greaterSym,
		GreaterEqual -> greaterEqualsSym,
		Less -> lessSym,
		LessEqual -> lessEqualsSym,
		Alternatives -> altsSym,
		StringExpression -> stringExpressionSym,
		Max -> maxSym,
		Min -> minSym,
		HoldPattern[StringContainsQ[left_, middle_, right___]] :> stringContainsQSym[left, regexSym[middle], right] (* Note: stringExpressionSym is the old way of doing things and is going to be deprecated. *)
	};

	(* Because Length and Part can evaluate, we have to do the replace of these symbols before
		we try to convert the expression to a sum of products DNF form.
		The goal here is to release the expression into a form that we can then generate
		and search query string we can send to the Constellation.

		We release the hold on the expression in a couple of stages:
			1. replaces the Heads for various boolean logic operations with placeholders.
			2. Replaces lower-level heads, things that are identifiers (leaft hand side of things)
				 like Part, and values (right hand side of things) we want ot change, like Object.
			3. replace equalities and inequalities with string versions of themselves. This includes
				 some type identification to do things like correctly generate object store valid date string,
				 or quantity conversion. This is encapsulated in the searchQueryStringForm function below.
						 * Note this function with Sow the field names so that we can Reap them in this function,
							allowing us to check that the field is valid for this object.
			4. & 5. turn And into a riffled AND objstore clause. Then does it again for OR. They are different
				 stages because AND has precidence over OR.
		*)

	(* Helper function to preserve adding links to the most right hand side of the expression. *)
	appendLinkSym[link_linkSym, toAppend_]:=linkSym[link[[1]], appendLinkSym[link[[2]], toAppend]];
	appendLinkSym[notLink_, toAppend_]:=linkSym[notLink, toAppend];

	(* First remove the Field head, which is safe because everything is held now *)
	(* Then we do two rounds of replacing symbols that can evaluate with our own placeholder symbols. *)
	replacedExpression= ReplaceAll[
		ReleaseHold[
			ReplaceRepeated[
				ReplaceAll[
					heldExpr,
					Verbatim[Field][cond_] :> cond
				],
				placeholderRules
			]
		],
		placeholderRules
	];

	convertToTraversal[lhsQuery_] :=  ReplaceRepeated[lhsQuery,
		{
			(* We want to build up our link traversal in the order linkSym[singleSymbol,linkSym[singleSymbol2,linkSym[...]]] *)
			(* This is so that when we have to walk the tree in MM, it's easier to pierce down (rather than the nesting happening on the left. *)
			linkSym[a_, b_][c_] :> linkSym[a, appendLinkSym[b, c]],
			(* Initial rule to start the linkSym[...] wrapping. *)
			(sym1 : Except[Alternatives @@ placeholderSymbols | (sym1a_[sym2a_]) | List])[sym2_Symbol] :> linkSym[sym1, sym2]
		}
	];

	(* Traversals can exist within the other structures, so will need to deal with that *)
	replacedExpression = ReplaceAll[replacedExpression,
		{
			(head: comparatorP)[a_, b_, c___] :> head[convertToTraversal[a], b, c],
			(head: superlativeP)[a_] :> head[convertToTraversal[a]]
		}
	];

	replacedExpression = ReplaceRepeated[replacedExpression,
		{
			(partSym[syms___][externalSym_]) :> convertToTraversal[partSym[syms][externalSym]],
			(partSym[syms___]) :> convertToTraversal[partSym[syms]]
		}
	];


	If[Greater[Count[replacedExpression, Nothing, Infinity], 0],
		Message[Search::InvalidSearchQuery];
		Return[$Failed];
	];

	(* Convert to DNF form. At this point, our evaluatable symbols are all gone and we are fully released. *)
	releasedExpr=ReplaceAll[
		convertToDNF[replacedExpression],
		{
			And -> andSym,
			Or -> orSym,
			Unevaluated -> Identity
		}
	];

	(*
		At this point, the expression must have one of the placeholders as its heads, otherwise it
		was not a valid expression
	*)
	With[
		{
			placeholderPattern=Apply[
				Alternatives,
				Map[Blank, placeholderSymbols]
			],
			nonBooleanPattern=Apply[
				Alternatives,
				Map[Blank, Complement[placeholderSymbols, {andSym, orSym}]]
			]
		},
		If[Not[MatchQ[releasedExpr, nonBooleanPattern | (andSym | orSym)[placeholderPattern..]]],
			Message[Search::InvalidSearchQuery];
			Return[$Failed];
		]
	];

	getLastElement[element_Symbol] := element;
	getLastElement[number: _?NumberQ] := Null;
	getLastElement[{}] := Null;
	getLastElement[list_] := Check[getLastElement[(list)[[-1]]], Null];

	toTypeId[exprWithType_] := ReplaceAll[exprWithType,
		{
			x: typeP :> toConstellationID[x]
		}
	];

	(* the more I interact with this, the more I think the conversion to constellationID needs to happen on the server side *)
	(* convert objects models and types from Object[x] to Object.x form *)
	releasedExpr=ReplaceAll[
		releasedExpr,
		{
			x: objectP :> toConstellationID[x],
			x: modelP :> toConstellationID[x],
			(* only convert types that are being compared to the special Type field *)
			(comp: comparatorP)[field_, x_] :> comp[field, toTypeId[x]] /; MatchQ[getLastElement[field], Type]
		}
	];

	Return[releasedExpr];
];

SetAttributes[searchClauseString, HoldFirst];
searchClauseString[Hold[expr_], ops:OptionsPattern[]]:=searchClauseString[expr, ops];
searchClauseString[expr_, ops:OptionsPattern[]]:=Module[
	{releasedExpr, invalidFields, type, developerObject, nameHeldExp, dateCreatedHeldExp, heldExpr},

	developerObject=OptionDefault[OptionValue[DeveloperObject]];
	type=OptionDefault[OptionValue[Type]];

	(* add the Name search condition if $RequiredSearchName is specified and Name is not already being set somehow *)
	(* if Name is already set then don't worry about it *)
	nameHeldExp = With[{requiredSearchName = $RequiredSearchName},
		Which[
			MemberQ[Hold[expr], Name, Infinity],
				Hold[expr],
			Hold[expr] === Hold[None] && StringQ[requiredSearchName],
				Hold[StringContainsQ[Name, requiredSearchName, IgnoreCase -> False]],
			StringQ[requiredSearchName],
				Hold[And[StringContainsQ[Name, requiredSearchName, IgnoreCase -> False], expr]],
			True,
				Hold[expr]
		]
	];

	(* add the Name search condition if $SearchMaxDateCreated is specified and Name is not already being set somehow *)
	(* if Name is already set then don't worry about it *)
	dateCreatedHeldExp = With[{maxDateCreated = $SearchMaxDateCreated, insertNameHeldExpr=nameHeldExp},
		Which[
			MemberQ[insertNameHeldExpr, DateCreated, Infinity],
				insertNameHeldExpr,
			insertNameHeldExpr === Hold[None] && MatchQ[maxDateCreated, _?DateObjectQ],
				Hold[(DateCreated <= maxDateCreated || DateCreated == Null)],
			MatchQ[maxDateCreated, _?DateObjectQ],
				(* NOTE: This returns Hold[And[clause1, clause2]]. *)
				holdCompositionList[And,{Hold[(DateCreated <= maxDateCreated || DateCreated == Null)], insertNameHeldExpr}],
			True,
				insertNameHeldExpr
		]
	];


	(* $DeveloperSearch is a trump setting that will FORCE returning of DeveloperObject->True only *)
	heldExpr=With[{preprocessedHeldExp = dateCreatedHeldExp},
		If[preprocessedHeldExp === Hold[None],
			Which[
				TrueQ[$DeveloperSearch], Hold[DeveloperObject == True],
				developerObject, Return[""],
				True, Hold[DeveloperObject != True]
			],
			(*If DeveloperObject is not specified as a search term,
			search for only things which are not developer objects.*)
			(* need to do some goofiness to remove the Hold around preprocessedHeldExp without removing the Hold around the overall expression *)
			Which[
				MemberQ[preprocessedHeldExp, DeveloperObject, Infinity], preprocessedHeldExp,
				TrueQ[$DeveloperSearch],
					Replace[
						Hold[And[DeveloperObject == True, preprocessedHeldExp]],
						Hold[valueInExpr__] :> valueInExpr,
						{2}
					],
				developerObject, preprocessedHeldExp,
				True,
					Replace[
						Hold[And[DeveloperObject != True, preprocessedHeldExp]],
						Hold[valueInExpr__] :> valueInExpr,
						{2}
					]
			]
		]
	];

	(* If we see Max[...] or Min[...] in and And/Or, it has to be the last condition. This is due to a limitation on the backend. *)
	heldExpr=ReplaceAll[
		heldExpr,
		{
			RuleDelayed[
				And[
					left___,
					superlative:(_Max | _Min),
					right___
				],
				And[
					left,
					right,
					superlative
				]
			],
			RuleDelayed[
				Or[
					left___,
					superlative:(_Max | _Min),
					right___
				],
				Or[
					left,
					right,
					superlative
				]
			]
		}
	];

	releasedExpr = transformHeldExpressionToStandardizedTreeForm[heldExpr];
	If[MatchQ[releasedExpr, $Failed],
		Return[$Failed]
	];

	CheckAbort[
		{releasedExpr, invalidFields}=Reap[
			ReplaceAll[
				releasedExpr,
				{
					x:(comparatorP[_, _, ___]) :> searchQueryStringForm[x, ops], (* stringContainsQSym can have three arguments (IgnoreCase option). *)
					x:(superlativeP[_]) :> searchQueryStringForm[x, ops]
				}
			],
			"search-field"
		],

		(* We aborted somewhere in the value conversion because we caught some value that is invalid.*)
		Return[$Failed];
	];

	If[Length[invalidFields] > 0,
		With[
			{
				errors=GroupBy[
					invalidFields[[1]],
					First,
					#[[All, 2;;-1]]&
				]
			},

			KeyValueMap[
				searchMessage[#1, #2]&,
				errors
			];
			Return[$Failed];
		]
	];

	(* Replace all AND, OR, and comparator condition symbols with their string forms. *)
	(* Note: We can have comparator conditions outside of AND/OR heads or AND/OR heads outside comparator conditions. *)
	(* Ex. any[blah and blah] *)
	(* Ex. and[any[blah], all[blah]] *)
	(* Therefore, we must make sure that the arguments inside of a head are all strings before trying to translate the greater head into a final string. *)
	ReplaceRepeated[
		releasedExpr,
		{
			x:andSym[(_String)..] :> StringRiffle[Apply[List, x], " AND "],
			x:orSym[(_String)..] :> StringRiffle[Apply[List, x], " OR "],
			x:(comparatorConditionP[_String]) :> searchQueryStringForm[x, ops]
		}
	]
];

searchMessage[messageName_String, arguments:{{_Symbol, typeP}..}]:=With[
	{
		typesToFields=GroupBy[
			arguments,
			Last,
			#[[All, 1]]&
		]
	},

	Message[
		MessageName[Search, messageName],
		Values[typesToFields],
		Keys[typesToFields]
	]
];

(*Convert search query to sum of products (DNF) form fomr nested boolean expression*)
convertToDNF[expr:Except[_Or | _And]]:=expr;
convertToDNF[expr:(Verbatim[Or] | Verbatim[And])[Except[_Or | _And]...]]:=expr;
convertToDNF[Verbatim[And][args___]]:=With[
	{
		replaced=Replace[
			{args},
			{
				and_And :> Apply[List, convertToDNF[and]],
				or_Or :> Apply[List, convertToDNF[or]],
				item_ :> {item}
			},
			{1}
		]
	},

	Apply[
		Or,
		Map[
			Apply[And, #] &,
			Tuples[replaced]
		]
	]
];
convertToDNF[Verbatim[Or][args___]]:=Apply[
	Or,
	Apply[
		Join,
		Replace[
			{args},
			{
				and_And :> With[{converted=convertToDNF[and]},
					If[Head[converted] === And,
						{converted},
						Apply[List, converted]
					]
				],
				or_Or :> Apply[List, convertToDNF[or]],
				item_ :> {item}
			},
			{1}
		]
	]
];

DefineOptions[
	searchQueryStringForm,
	SharedOptions :> {
		searchClauseString
	}
];

searchQueryStringForm[query:(head:superlativeP)[fieldName_], ops:OptionsPattern[]]:=With[
	{
		type=OptionValue[Type]
	},

	If[type =!= None,
		With[
			{error=validateQueryField[type, fieldName, Null]},

			If[error =!= Null,
				Sow[error, "search-field"]
			]
		]
	];

	fieldString[query]
];

searchQueryStringForm[query:(head:comparatorP)[left_, value_, options___], ops:OptionsPattern[]]:=With[
	{
		field=fieldSymbol[left],
		subField=If[MatchQ[left, _partSym],
			left[[2]],
			0
		],
		newValue=If[MatchQ[value, _partSym],
			Apply[Part,value],
			value
		],
		operator=queryOperator[query],
		type=OptionValue[Type]
	},
	If[type =!= None,
		With[
			{error=validateQueryField[type, left, value]},

			If[error =!= Null,
				Sow[error, "search-field"]
			]
		]
	];


	With[
		{
			valueOfSearchQuery=searchQueryValue[field, subField, newValue, ops]
		},

		If[Not[MatchQ[valueOfSearchQuery, _String]],
			Message[Search::InvalidSearchQuery];
			Abort[]
		];

		StringJoin[
			fieldString[left],
			operator,
			valueOfSearchQuery
		]
	]
];

(* This overload is called after the first two overloads of searchQueryStringForm are called. Therefore, the argument inside of the comparator condition head should already be a string. *)
searchQueryStringForm[query:(head:comparatorConditionP)[inside_], ops:OptionsPattern[]]:=Switch[head,
	allSym,
	"All{"<>inside<>"}",
	anySym,
	"Any{"<>inside<>"}",
	exactlySym,
	"Exactly{"<>inside<>"}",
	_, (* Default to Any *)
	"Any{"<>inside<>"}"
];



fieldSymbol[lengthSym[field_]]:=fieldSymbol[field];
fieldSymbol[field_Symbol]:=field;
fieldSymbol[partSym[field_, _Integer | _Symbol]]:=field;
fieldSymbol[linkSym[left_, right_]]:=linkSym[left, right];
fieldSymbol[Field[inside_]]:=fieldSymbol[inside];


fieldString[maxSym[field_]]:=fieldString[field]<>".max=0";
fieldString[minSym[field_]]:=fieldString[field]<>".min=0";

fieldString[Field[inside_]]:=fieldString[inside];
fieldString[lengthSym[field_]]:=fieldString[field]<>".length";
fieldString[field_Symbol]:=SymbolName[field];
fieldString[partSym[field_, subField:_Integer | _Symbol]]:=StringJoin[
	fieldString[field],
	"[[",
	If[IntegerQ[subField],
		ToString[subField],
		SymbolName[subField]
	],
	"]]"
];

(* Overload to convert a search throuhg links dereference into the correct left\[Rule]right form. *)
(* Note that if we have multiple link dereferences (ex. A[B][C]) there will be linkSym[...] wrapper inside of our linkSym[...] outer wrapper. *)
(* This is why we can recursively call the fieldString[...] function. *)
fieldString[linkSym[left_, right_]]:=StringJoin[
	If[MatchQ[left, _Symbol],
		SymbolName[left],
		fieldString[left]
	],
	"->",
	If[MatchQ[right, _Symbol],
		SymbolName[right],
		fieldString[right]
	]
];

(*Search operators*)
queryOperator[stringContainsQSym[_, _, IgnoreCase -> False]]:="~~"; (* ~~ corresponds to LIKE which is case sensitive. *)
queryOperator[stringContainsQSym[_, _, IgnoreCase -> True]]:="~~*"; (* ~~* corresponds to ILIKE which is case insensitive. *)
queryOperator[stringContainsQSym[_, _]]:="~~"; (* By default, use a case sensitive search. *)
queryOperator[equalsSym[_, _stringExpressionSym]]:="~~"; (* ~~ corresponds to LIKE which is case sensitive. *)
queryOperator[_equalsSym]:="=";
queryOperator[_notEqualsSym]:="!=";
queryOperator[_greaterSym]:=">";
queryOperator[_greaterEqualsSym]:=">=";
queryOperator[_lessSym]:="<";
queryOperator[_lessEqualsSym]:="<=";

DefineOptions[
	searchQueryValue,
	SharedOptions :> {
		searchClauseString
	}
];

searchQueryValue[field:(_Symbol | _linkSym), _Integer | _Symbol, value:(_Link), OptionsPattern[]]:=ToString[value[[1]], InputForm];
searchQueryValue[field:(_Symbol | _linkSym), _Integer | _Symbol, value:(_Integer | _Real), OptionsPattern[]]:=TextString[value];
searchQueryValue[field:(_Symbol | _linkSym), _Integer | _Symbol, Null, OptionsPattern[]]:="null";
searchQueryValue[field:(_Symbol | _linkSym), _Integer | _Symbol, value_String, OptionsPattern[]]:=ToString[value, InputForm];
searchQueryValue[field:(_Symbol | _linkSym), subField:_Integer | _Symbol, value_altsSym, ops:OptionsPattern[]]:=If[Length[value] === 0,
	Message[Search::InvalidSearchValues, "Empty Alternatives in field "<>SymbolName[field]];
	Abort[],
	StringRiffle[
		Map[
			searchQueryValue[field, subField, #, ops]&,
			Apply[List, value]
		],
		" | "
	]
];

(* Note: Regexes aren't actually supported now but will be. *)
(* All regexes are assumed to simply be substrings. *)
searchQueryValue[field:(_Symbol | _linkSym), _Integer | _Symbol, regexSym[regex_], OptionsPattern[]]:=StringJoin[{"\"", "%", StringReplace[regex, "%" -> "\\%"], "%", "\""}];

searchQueryValue[field:(_Symbol | _linkSym), _Integer | _Symbol, stringExpressionSym[value:((Verbatim[BlankNullSequence[]] | _String)..)], OptionsPattern[]]:= Apply[
		StringJoin,
		Replace[{"\"", value, "\""},
			{
				_BlankNullSequence -> "%",
				str_String :> StringReplace[str, "%" -> "\\%"]
			},
			{1}
		]
];

(*
	This overload is here to catch Boolean values and either:
	1) convert them to `true` or `false` if the subfield is a Boolean class, or
	2) just fall through to how searchQueryValue was handling them before.
*)
searchQueryValue[field:(_Symbol | _linkSym), subField:_Integer | _Symbol, value:(True | False), ops:OptionsPattern[]]:=With[
	{fieldClass=lookupFieldClass[OptionValue[Type], field, subField]},

	If[MatchQ[fieldClass, Boolean],
		ToLowerCase[ToString[value, InputForm]],
		searchQueryValue[
			field,
			subField,
			ToString[value],
			ops
		]
	]
];

searchQueryValue[field:(_Symbol | _linkSym), subField:_Integer | _Symbol, value_Symbol, ops:OptionsPattern[]]:=searchQueryValue[
	field,
	subField,
	ToString[value],
	ops
];
searchQueryValue[field:(_Symbol | _linkSym), _Integer | _Symbol, value_DateObject, OptionsPattern[]]:="\""<>jsonValueData[Date, value, None]<>"\"";
(* note: jsonValueData of cloud files works, but don't expand them here until adding cloud file support to Search *)
searchQueryValue[field:(_Symbol | _linkSym), _Integer | _Symbol, value_EmeraldCloudFile, OptionsPattern[]]:="\"unsupported _EmeraldCloudFile\"";
searchQueryValue[field:(_Symbol | _linkSym), subField:_Integer | _Symbol, value_?QuantityQ, OptionsPattern[]]:=Module[
	{units, type, class},

	type=OptionValue[Type];
	If[type === None,
		Message[Search::InvalidSearchValues, ToString[value]];
		Abort[];
	];

	(* for VariableUnit, search using the normalized value *)
	(* TODO: There could be ambiguity about the class of the field when doing link traversal. What do we do here? *)
	class=lookupFieldClass[type, field, subField];

	(* If there is an ambiguity about the class of a field, throw an error and abort. *)
	If[MatchQ[class, $Failed],
		Message[Search::AmbiguousType, ToString[value]];
		Abort[];
	];

	(* We have to convert for variable units. *)
	If[MatchQ[class, VariableUnit],
		Return[jsonBase64[searchableValueData[value]]]
	];

	(* for Distribution, do the same as VariableUnit but use the specified unit instead of CanonicalUnit. *)
	(* TODO: There could be ambiguity about the class of the field when doing link traversal. What do we do here? *)
	units=fieldUnits[type, field, subField];
	If[MatchQ[class, Distribution],
		Return[jsonBase64[<|
			"search_dimension" -> SortBy[Map[dimensionToObject, UnitDimensions[value]], #[Name]&],
			"search_value" -> StringReplace[ToString[N[QuantityMagnitude[UnitConvert[value, units]]], InputForm], "*^" -> "e"]
		|>]]
	];

	(* otherwise proceed the fixed-unit way *)
	StringReplace[
		ToString[
			Unitless[If[MatchQ[units, None],
				value,
				unitConvert[class, value, units]
			]],
			InputForm
		],
		"*^" -> "e"
	]
];

searchQueryValue[field:(_Symbol | _linkSym), subField:_Integer | _Symbol, value_, OptionsPattern[]]:=Module[
	{type, fieldClass},

	type=OptionValue[Type];
	fieldClass=lookupFieldClass[type, field, subField];

	(* Can only search on expression fields or multiple fields. *)
	If[!MatchQ[fieldClass, Expression] && !MatchQ[LookupTypeDefinition[type, field, Format], Multiple],
		Message[Search::InvalidSearchValues, ToString[value]];
		Abort[]
	];

	(* Format our query value differently if searching for an expression or a multiple field. *)
	If[MatchQ[fieldClass, Expression] && !MatchQ[value, _List],
		StringJoin[
			"\"",
			StringReplace[jsonValueData[Expression, value, None], "\"" -> "\\\""],
			"\""
		],
		(* Are we dealing with a multiple field? *)
		If[MatchQ[value, _List] && !MatchQ[fieldClass, Expression],
			(* Yes. *)
			If[MatchQ[subField, Null],
				(* Entire multiple *)
				ToString[
					Function[{valueEntry},
						MapThread[
							Function[{index, valueEntryEntry},
								searchQueryValue[field, index, valueEntryEntry, Type -> type]
							],
							{Range[Length[fieldClass]], valueEntry}
						]
					] /@ value
				],
				(* Index of a multiple *)
				ToString[searchQueryValue[field, subField, #, Type -> type]& /@ value]
			],
			(* No. *)
			(* Just convert it to a list. *)
			jsonValueData[Expression, value, None]
		]
	]
];


fieldUnits[type:typeP, link_linkSym, subField: _Integer | _Symbol] := Module[
	{objectTypes, units},
	objectTypes = getLinkedObjectTypes[type, link];

	(* If we got back $Failed, we didn't encounter a link field. *)
	If[MatchQ[objectTypes, $Failed],
		Return[$Failed];
	];

	units=Quiet[Flatten[fieldUnits[#, link[[2]], subField]& /@ objectTypes] /. {$Failed -> Nothing}];

	(* If there is an ambiguity of what unit our field is, return $Failed. *)
	(* This will either get filtered out if we were recursively called or if it is the parent call, it will return $Failed. *)
	If[Length[DeleteDuplicates[units]] > 1,
		$Failed,
		First[DeleteDuplicates[units]]
	]
];



fieldUnits[type:typeP, field_Symbol, subField:_Integer | _Symbol]:=Module[
	{units=LookupTypeDefinition[type, field, Units]},

	Which[
		(*$Failed*)
		MatchQ[units, $Failed],
		$Failed,

		(*Named Field*)
		MatchQ[subField, _Symbol],
		Lookup[units, subField],

		(*Index for Named Field*)
		Positive[subField] && MatchQ[units, {__Rule}],
		Part[units, subField, 2],

		(*Indexed Field*)
		Positive[subField],
		Part[units, subField],

		(*All other fields*)
		True,
		units
	]
];

validQueryFieldP:=Integer | Real | String | Date | Link | Boolean | Expression | EmeraldCloudFile | VariableUnit | Distribution | _List; (* _List corresponds to indexed/named multiple fields. *)

(* Strip off any Field heads. *)
validateQueryField[type:typeP, Field[field_], value_]:=validateQueryField[type, field, value];

(*Specific validation for Length Queries*)
validateQueryField[type:typeP, lengthSym[field_Symbol], value_]:=validateQueryField[type, field, Null];

(*Given a Part pull out the sub-field*)
validateQueryField[type:typeP, partSym[field_Symbol, subField:_Integer | _Symbol], value_]:=validateQueryField[
	type,
	field,
	value,
	subField
];

(* Don't validate searching through links. This is done on the backend. *)
validateQueryField[type:typeP, linkSym[___] | lengthSym[linkSym[___]] | partSym[linkSym[___], ___], value_]:=Null;

(*Core definition*)
validateQueryField[type:typeP, field_Symbol, value_, subField:_Integer | _Symbol:0]:=Module[
	{definition, format, fieldClass},

	definition=Quiet[
		LookupTypeDefinition[type[field]],
		{LookupTypeDefinition::NoFieldDefError}
	];

	If[FailureQ[definition],
		Return[{"MissingField", field, type}]
	];

	format=Lookup[definition, Format];
	If[format === Computable,
		Return[{"ComputableField", field, type}]
	];

	fieldClass=lookupFieldClass[type, field, subField];

	If[fieldClass === EmeraldCloudFile,
		Return[{"CloudFileField", field, type}]
	];

	If[value === Null || MatchQ[fieldClass, validQueryFieldP],
		Null,
		{"InvalidField", field, type}
	]
];

Authors[lookupFieldClass]:={"platform"};

lookupFieldClass[None, _Symbol, _Integer | _Symbol]:=Expression;
lookupFieldClass[type:typeP, field_Symbol, subField:_Integer | _Symbol]:=With[
	{class=LookupTypeDefinition[type, field, Class]},

	Quiet[
		Check[
			Which[
				(*Named Field*)
				MatchQ[subField, _Symbol],
				Lookup[class, subField],

				(*Index for Named Field*)
				Positive[subField] && MatchQ[class, {__Rule}],
				Part[class, subField, 2],

				(*Indexed Field*)
				Positive[subField],
				Part[class, subField],

				(*All other fields*)
				True,
				class
			],
			$Failed
		]
	]
];
(* Overload for search through links. The subfield (if not 0) is the last operator to apply to lookup the class type. *)
(* This overload is only used to distinguish Real fields from VariableUnit fields since unit conversion is needed based on the field type (definition for Real and CanonicalUnit for VariableUnit). *)
(* If we end up with an ambiguity as to what class a field is, return $Failed. The parent function that calls this (in the case of VariableUnit vs Real) throw an error to the user and aborts the search. *)
lookupFieldClass[type:typeP, link_linkSym, subField:_Integer | _Symbol]:=Module[{objectTypes, fieldTypes},
	objectTypes = getLinkedObjectTypes[type, link];
	(* If we got back $Failed, we didn't encounter a link field. *)
	If[MatchQ[objectTypes, $Failed],
		Return[$Failed];
	];

	(* Recursively get the types via link traversal, filtering out any $Failed results. *)
	(* At the base case of our recursion, we will no longer have a linkSym[...] for our second argument and our base definition gets triggered to get the type of field. *)
	fieldTypes=Quiet[Flatten[lookupFieldClass[#, link[[2]], subField]& /@ objectTypes] /. {$Failed -> Nothing}];
	If[Length[DeleteDuplicates[fieldTypes]] == 0,
		Message[Search::InvalidField, ToString[link[[2]]], ToString[objectTypes]];
		Return[$Failed];
	];

	(* If there is an ambiguity of what type our field is, return $Failed. *)
	(* This will either get filtered out if we were recursively called or if it is the parent call, it will return $Failed. *)
	If[Length[DeleteDuplicates[fieldTypes]] > 1,
		$Failed,
		First[DeleteDuplicates[fieldTypes]]
	]
];


getLinkedObjectTypes[type:typeP, link_linkSym] := Module[{fieldToTraverse, objectTypesRaw, objectTypes},
	(* Get the field to traverse. *)
	fieldToTraverse=First[link];

	(* Get the link relation from the traversal. If we didn't encounter a link field, return $Failed. *)
	objectTypesRaw=Quiet[
		Check[
			Which[
				(* Named Field *)
				MatchQ[fieldToTraverse, partSym[_, _Symbol]],
				ToList[Last[fieldToTraverse] /. LookupTypeDefinition[type, First[fieldToTraverse], Relation] /. Alternatives -> List],
				(* Indexed Field *)
				MatchQ[fieldToTraverse, _partSym],
				ToList[LookupTypeDefinition[type, First[fieldToTraverse], Relation][[Last[fieldToTraverse]]] /. Alternatives -> List],
				(* Regular field traversal. *)
				MatchQ[fieldToTraverse, _Symbol],
				ToList[LookupTypeDefinition[type, fieldToTraverse, Relation] /. Alternatives -> List],
				(* Catch All *)
				True,
				$Failed
			],
			$Failed
		]
	];

	(* If we got back $Failed, we didn't encounter a link field. *)
	If[MatchQ[objectTypesRaw, $Failed],
		Return[$Failed];
	];

	(* Strip off the backlink if we find it. *)
	objectTypes=DeleteDuplicates[Flatten[(If[!MatchQ[#, TypeP[]], Types[Head[#]], Types[#]]&) /@ objectTypesRaw]];
	objectTypes
];

uploadTimeout=720000;
uploadRetries=4;

(*Replace this with ExportJSON once ExportJSON has been updated
to behave the same way for handling Unicode strings.*)
exportUnicodeJSON[expr_]:=With[
	{json=ExportString[expr, "RawJSON", "Compact" -> True]},
	If[StringQ[json],
		ImportString[json, "Text"],
		$Failed
	]
];

(* Run function without ignoring transactions by default *)
sendUploadObjects[
	packets:{__Association},
	emptyObjects:BooleanP,
	casTokens:{___String},
	allowPublicObjects:BooleanP
]:=sendUploadObjects[packets, emptyObjects, casTokens, None, allowPublicObjects];

sendUploadObjects[packets:{__Association},
	emptyObjects:BooleanP,
	casTokens:{___String},
	transaction:(Automatic | None | _String),
	allowPublicObjects:BooleanP
]:=Module[
	{requests, shardedRequests, url, body, bigDataUploadResult, sllTransactions, validateLinks},

	If[!MatchQ[casTokens, {}] && !SameQ[Length[packets], Length[casTokens]],
		Message[Warning::CasLengthMismatch];
		Return[HTTPError[None, "Error uploading packets with provided CAS tokens"]]
	];

	(* Create the upload requests from the packets provided *)
	If[MatchQ[casTokens, {}],
		requests=<|"requests" -> Map[
			makeUploadRequest[#, emptyObjects, Null]&,
			packets
		]|>,
		requests=<|"requests" -> MapThread[
			makeUploadRequest[#1, emptyObjects, #2]&,
			{packets, casTokens}
		]|>
	];

	(* Next, upload the blob references in the request, if any *)
	bigDataUploadResult=uploadBlobReferences[Cases[requests, jsonBlobReferenceP, Infinity]];
	If[bigDataUploadResult === $Failed,
		Return[HTTPError[None, "Error uploading BigCompressed or BigQuantityArray field(s)"]]
	];

	(* Fix the pathing information for blob references in the main upload request to match what the server returned *)
	shardedRequests = If[Length[bigDataUploadResult] == 0,
		requests,
		Append[requests, <|"requests"->updateBlobReferenceShardInfo[Lookup[requests, "requests", {}], bigDataUploadResult]|>]
	];

	(* Now, include the transaction information, if supplied, in the request *)
	Which[MatchQ[transaction, _String],
		sllTransactions=<|"sll_txs" -> {transaction}|>,
		Length[$CurrentUploadTransactions] > 0 && Not[MatchQ[transaction, None]],
		sllTransactions=<|"sll_txs" -> $CurrentUploadTransactions|>,
		True,
		sllTransactions=<||>
	];

	(* Determine the correct url to use *)
	url=apiUrl["Upload"];

	(* Only validate links on stage and in Engine *)
	validateLinks = <|"validate_links"->
	If[
			 MatchQ[$ECLApplication, Engine] || !ProductionQ[],
			 True,
			 False
		 ]
	|>;

	(* Convert the request body into unicode JSON *)
	body=Check[
		exportUnicodeJSON[Join[shardedRequests, sllTransactions, validateLinks]],
		$Failed
	];

	(* If the conversion failed, record the failure somewhere so we can debug *)
	If[body === $Failed,
		With[
			{errorPath=FileNameJoin[{$TemporaryDirectory, ToString[UnixTime[]]<>"_upload_failure.mx"}]},

			Export[errorPath, {packets, shardedRequests}, "MX"];
			Return[HTTPError[None, "Unable to generate JSON request body. See "<>errorPath]]
		]
	];

	(* Send the main upload request! *)
	ConstellationRequest[<|
		"Path" -> url,
		"Body" -> body,
		"Method" -> "PUT",
		(*Increase timeout for upload beyond 120000 default as some large uploads make take a long time.*)
		"Timeout" -> uploadTimeout,
		"Headers" -> notebookHeaders[allowPublicObjects]
	|>,
		Retries -> uploadRetries,
		RetryMode -> Write
	]
];

maximumInvalidHashRetryCount=3;
uploadBlobReferences::fileUploadLengthMismatch="There was a length mismatch in the cloud files uploaded and what would be written to object store";
uploadBlobReferences::fileUploadHashMismatch="The contents of your file locally and on the remote server after the upload do not match. This typically indicates a momentary network issue - please upload your file again. (remote:`1`, local: `2`)";
uploadBlobReferences::fileUploadError="There were errors uploading big data files: `1`";

uploadBlobReferences[{}]:=None;
uploadBlobReferences[localBlobReferences:{jsonBlobReferenceP..}]:=uploadBlobReferences[localBlobReferences,0];
uploadBlobReferences[localBlobReferences:{jsonBlobReferenceP..}, retryCount:_Integer]:=Module[
	{localPaths, localBlobReferencesWithLocalPaths, fileUploadResults, resultsErrors, resultsMatch,
		invalidHashPositions, invalidBlobReferences, retryResult},

	(* Find out if there are any local paths to upload *)
	localPaths=Lookup[localBlobReferences, "localPath", Nothing];
	localBlobReferencesWithLocalPaths=Cases[localBlobReferences, KeyValuePattern[{"localPath"->_String}]];

	(* If you've found some, prepare to upload! *)
	If[Length[localPaths] > 0,
		(* Upload all the files in the request *)
		fileUploadResults=GoCall["UploadCloudFile",
			<|
				"Paths" -> localPaths,
				"Retries" -> 8,
				"Concurrency" -> 5
			|>
		];

		(* These results are for uploading cloud files--but we've replicated this
		   this already in our encoding of the big data file. so we just want to make
		   sure the stuff that was uploaded matches what we've constructed in the
		   blob references in terms of keys and buckets.
		*)
		If[Length[fileUploadResults] =!= Length[localPaths],
			Message[uploadBlobReferences::fileUploadLengthMismatch];
			Return[$Failed];
		];

		(* If any errors were returned by the server, return them here *)
		resultsErrors=Lookup[fileUploadResults, "Error", Nothing];
		If[Length[resultsErrors] > 0,
			Scan[Message[uploadBlobReferences::fileUploadError, #]&, resultsErrors];
			Return[$Failed];
		];

		(* "hash" is what we called it on our side, and "Key" is what it's called on the server *)
		(* also we are fine with the results matching if we have a "/" or "\\" because that is what happens when we have a cloud file (as opposed to a direct upload of something) *)
		(* I am pretty sure that is okay but we should probably watch out for this going forward *)
		(* Note with s3 sharding, its a bit more complex, as the hash is actually everything after the final / in the key *)
		(* on the other hand this error message was totally broken before I added this in so the worst that happens is that we don't catch errors that we were not catching before anyway *)
		resultsMatch=MapThread[
			MatchQ[#3, "/" | "\\"] || MatchQ[#1, hashFromShardedPath[#2]] &,
			{Lookup[localBlobReferencesWithLocalPaths, "hash"], Lookup[fileUploadResults, "Key", ""], localPaths}
		];

		(* Issue an error if the client and server didn't get the same hash *)
		If[Not@AllTrue[resultsMatch, TrueQ],
			invalidHashPositions=Flatten@Position[resultsMatch, False];
			If[retryCount>maximumInvalidHashRetryCount,
				Message[uploadBlobReferences::fileUploadHashMismatch, Lookup[fileUploadResults[[invalidHashPositions]], "Key", ""], localPaths[[invalidHashPositions]]];
				Return[$Failed];,

				(* Only retry the files whose hash mismatch *)
				invalidBlobReferences=localBlobReferencesWithLocalPaths[[invalidHashPositions]];
				retryResult=uploadBlobReferences[invalidBlobReferences, retryCount+1];

				If[MatchQ[retryResult,$Failed],
					Return[$Failed];,
					(* Replace the upload results for the original mismatching files *)
					MapIndexed[(fileUploadResults[[#1]] = retryResult[[#2]][[1]]) &, invalidHashPositions];
				]
			];
		];

		(* Format the results as an association with the key being the local path for easy look up *)
		Join @@ Map[Association[Lookup[#, "Path"] -> #] &, fileUploadResults],

		(* If we didn't have any local paths, just return an empty associatioon *)
		Association[]
	]
];

(* Update blob references in the request to refer to the shard info returned by the server.  A cleaner way
   to do this is to refactor the code so the requests are built after uploading the blob refs are built,
	 but that is a little complex to do now *)
updateBlobReferenceShardInfo[requests_List, bigDataUploadResult_Association] := Map[updateBlobReferenceShardInfoForRequest[#, bigDataUploadResult] &, requests];
updateBlobReferenceShardInfoForRequest[request_Association, bigDataUploadResult_Association] := Module[
	{fields},

	(* pull the fields from the request *)
	fields = Lookup[request, "fields", {}];

	(* update all the fields, if required *)
	Append[request, <|"fields" -> Join @@ MapThread[updateBlobReferenceShardInfoForField[#1, #2, bigDataUploadResult] &, {Keys[fields], Values[fields]}]|>]
];

updateBlobReferenceShardInfoForField[fieldName_String, fieldDefinition_, bigDataUploadResults_Association] := Module[
	{updatedFieldDefinition},

	(* Update jsonBlobRefs in the field definition with shard information  *)
	updatedFieldDefinition = fieldDefinition /. (x:jsonBlobReferenceP :> RuleCondition[updateBlobReferenceShardInfoForFieldDefinition[x, bigDataUploadResults]]);

	(* Return the updated value *)
	Association[fieldName -> updatedFieldDefinition]
];

updateBlobReferenceShardInfoForFieldDefinition[fieldDefinition_Association, bigDataUploadResults_Association] := Module[
	{serverReturnedPath},

	(* find the server returned path, if it exists *)
	serverReturnedPath = Lookup[Lookup[bigDataUploadResults, Lookup[fieldDefinition, "localPath", ""], <||>], "Key", ""];

	(* update the field definition, if we got it back from the server.  This is important for backwards compatibility, as we will not always get it back *)
	If[StringContainsQ[serverReturnedPath, "/"],
		Append[fieldDefinition, <|"path" ->  StringJoin[Most[StringSplit[serverReturnedPath, "/"]], "/"]|>],
		fieldDefinition
	]
];

makeUploadRequest[packet_Association, emptyObject:(True | False), casToken:(Null | _String)]:=With[
	{object=Lookup[packet, Object]},

	<|
		"object" -> If[MissingQ[object],
			<|"type" -> typeToString[Lookup[packet, Type]]|>,
			ConstellationObjectReferenceAssoc[object]
		],
		If[!emptyObject,
			Nothing,
			"flag_empty" -> True
		],
		"fields" -> packetToJSONData[packet],
		If[MatchQ[casToken, Null],
			Nothing,
			"cas" -> casToken
		]
	|>
];

uploadStatus=<|
	2 -> "Error",
	3 -> "PartDoesntExist",
	4 -> "NonUniqueName",
	5 -> "MissingObject",
	6 -> "NonUniqueLinkID",
	7 -> "RepeatLinkID",
	8 -> "RepeatLinkID",
	9 -> "MissingObject",
	10 -> "NotAllowed",
	11 -> "CasChanged",
	12 -> "SizeEstimationError",
	13 -> "MoreThan1Gb",
	14 -> "RequiresAdditionalAdmins",
	15 -> "ConflictingLinksWithBackLinks",
	16 -> "PublicObjectCreationDenied"
|>;

notebookHeaders[allowPublicObjects:BooleanP]:=Module[
	{notebook, notebookId},

	notebook=$Notebook;
	notebookId=If[notebook =!= Null,
		Last[notebook],
		Null
	];

	<|
		(* The global $AllowPublicObjects takes precedence when set to True *)
		If[TrueQ[$AllowPublicObjects  || allowPublicObjects], "X-ECL-AllowPublicObjects" -> "true", Nothing],
		If[StringQ[notebookId], "X-ECL-NotebookId" -> notebookId, Nothing]
	|>
];

checkUploadError[HTTPError[__, message_String]]:=(
	Message[Upload::Error, message];
	True
);

checkUploadError[
	KeyValuePattern[{"status_code" -> status:Except[1, _Integer], "message" -> message_String}]
]:=With[
	{error=Lookup[uploadStatus, status]},
	Message[MessageName[Upload, error], message];
	True
];

checkUploadError[_]:=False;

parseUploadResponse[response_Association]:=objectReferenceToObject[Lookup[response, "resolved_object"]];
parseUploadResponse[{$Failed, False}]:={$Failed, False};

System`TimeZonesDump`setupICUFunctions[DateObject, Null, Null];

DateObjectToRFC3339[date:_?DateObjectQ]:=Module[{iSOTimeStamp, milliSecondFraction, formattedTimeStamp},
	iSOTimeStamp=DateString[date, "ISODateTime", TimeZone -> 0];
	milliSecondFraction=Quiet[Check[StringPart[DateString[date, {"SecondFraction"}], 2;;], {}]];
	(* If the there are no milliseconds don't this partition to the timestamp *)
	formattedTimeStamp=If[Length[milliSecondFraction] > 2, iSOTimeStamp<>milliSecondFraction, iSOTimeStamp];
	formattedTimeStamp<>"Z"
];

Rfc3339ToDateObject[dateString_String]:=If[MatchQ[dateString, ""], None, TimeZoneConvert[DateObject[dateString, TimeZone -> 0]]];

standardizeDateObj[date_DateObject]:=If[MatchQ[date, None],
	None,
	Rfc3339ToDateObject[DateObjectToRFC3339[DateObject[AbsoluteTime[date]]]]];

(* create a temporary cache that only holds values for a single response *)
responseToSeparateCacheAssociations[response_Association]:=TraceExpression["parseObjectLogResponse", Module[{nestedResponses, resolvedObject, resolvedObjects, packetSummaryPairs,
	miniCaches, tempCache},
	(* If unable to parse the resolved object but no error response occurred error hard. *)
	resolvedObject=objectReferenceToObject[Lookup[response, "resolved_object", <||>]];
	If[resolvedObject === $Failed, Return[$Failed]];

	nestedResponses=Append[traversalResponses[response], response];
	resolvedObjects=objectReferenceToObject[Lookup[#, "resolved_object", <||>]] & /@ nestedResponses;

	packetSummaryPairs=Transpose[MapThread[parseDownloadResponse[#1, #2] &, {nestedResponses, resolvedObjects}]];

	miniCaches=MapThread[newCacheAssociation[#1, #2, Association[]] &, packetSummaryPairs];
	tempCache=Join @@ miniCaches;
	tempCache
]];

OnCall[]:=ECL`Web`ConstellationRequest[<|
	"Path" -> apiUrl["OnCall"],
	"Method" -> "GET"
|>];

OnCall[teamName_String]:=Module[
	{onCallResponse, message, teams, onCallUser},
	onCallResponse=OnCall[];
	teams=Lookup[onCallResponse, "teams", Null];
	If[NullQ[teams],
		message=Lookup[onCallResponse, "message", StringJoin[teamName, " does not have anyone on call!"]];
		Return[Association["error"->message]];
	];

	onCallUser=Lookup[teams, teamName, Null];
	If[NullQ[onCallUser],
		Return[Association[]];
	];

	onCallUser
];
