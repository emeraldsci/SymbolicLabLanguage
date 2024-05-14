
(* ::Section::Closed:: *)
(*PlotDataSlice*)

(*
    The purpose of this code is to plot a slice of any multidimensional
    data set that is stored in a BigQuantityArray. Currently, only
    Object[Data, ChromatographyMassSpectra] is known to work, but that may
    change in the future.
*)

(* options *)
DefineOptions[PlotTimeSlice,
    Options :> {
        {ReferenceField -> IonAbundance3D, (IonAbundance3D | Absorbance3D), "The field containing the BigQuantityArray data to be sliced and plotted."},
        {BigQuantityArrayByteLimit -> Quantity[100, "MB"], UnitsP["Bytes"], "The maximum sub-array size used when searching through the BigQuantityArray for the data slice."},
        {TimeSliceSpans -> Null, Alternatives[_Association, Null], "The association of time slice spans generated from TimeSliceSpans. If known this will speed up the plotting function."}
    },
    SharedOptions :> {
        PlotMassSpectrometry
    }
];

(* messages *)
Warning::InexactTime="The input time, `1`, does not match any time in the dataset. The nearest time in the dataset is `2` and will be used.";

(* main code *)
PlotTimeSlice[
    myObjects:ListableP[ObjectP[Object[Data,ChromatographyMassSpectra]]],
    myTimes:ListableP[UnitsP[Minute]],
    myOps:OptionsPattern[]
]:=Module[
    {
        timeSliceData, safeOps, refField
    },

    timeSliceData = TimeSlice[myObjects, myTimes, PassOptions[PlotTimeSlice, TimeSlice, myOps]];

    (* get the safe options, and pull out the reference field *)
    safeOps = SafeOptions[PlotTimeSlice, ToList[myOps]];
    refField = Lookup[safeOps, ReferenceField];

    (* feed this into a plot function *)
    (* if ref field is ion abundance use mass spec, else use plot abs spec *)
    If[MatchQ[refField, IonAbundance3D],
        PlotMassSpectrometry[timeSliceData, PassOptions[PlotTimeSlice, PlotMassSpectrometry, myOps]],
        (* TODO: figure out a way to pass abs spec options without interfering with mass spec options *)
        PlotAbsorbanceSpectroscopy[timeSliceData]
    ]
];


(* ::Subsection::Closed:: *)
(*TimeSliceSpans*)


(*
    Goal of this function is to process BigQuantityArrays, which are stored as
    huge lists of shape (N, 3) where N is all the data points regardless of slice.
    For LCMS data, there are really two important axes that have been squashed into 1.
    TimeSliceSpans will find the indices where individual time slices exist in the
    huge BigQuantityArray list.
*)

(* Options *)
DefineOptions[TimeSliceSpans,
    Options :> {
        {ByteArrayFormat -> Automatic, Alternatives[Automatic, ConstantArray[byteStringP, 3]], "The format of each element in the BigQuantityArray that allows the field to be decoded."}
    },
    SharedOptions :> {{PlotTimeSlice, {BigQuantityArrayByteLimit}}}
];

(* Messages *)


(* Patterns *)
bigQAFieldsP = (IonAbundance3D | Absorbance3D);
byteStringP = Alternatives["Real32", "Real64", "Integer32", "Integer64", "Complex32", "Complex64"];


(* overload for listed objects and listed fields *)
(* map over objects first, and then fields *)
TimeSliceSpans[
    myObjects:{ObjectP[Object[Data,ChromatographyMassSpectra]]..},
    myFields:ListableP[bigQAFieldsP],
    myOps:OptionsPattern[]
]:=Map[TimeSliceSpans[#, myFields, myOps]&, myObjects];

(* overload for listed fields *)
(* map over objects first, and then fields *)
TimeSliceSpans[
    myObject:ObjectP[Object[Data,ChromatographyMassSpectra]],
    myFields:{bigQAFieldsP..},
    myOps:OptionsPattern[]
]:=Map[TimeSliceSpans[myObject, #, myOps]&, myFields];


(* Main code *)
TimeSliceSpans[myObject:ObjectP[Object[Data,ChromatographyMassSpectra]], myField:bigQAFieldsP, myOps:OptionsPattern[]]:=Module[
    {
        safeOps, maxByteLimit, arrayFormat, elementByteCount, maxElementNumber,
        initialStart, rawSpans, spans, unresolvedArrayFormat, fileName, cloudFile
    },

    (* check if the spans have already been found for this object and field *)
    fileName = timeSliceSpanFileName[myObject, myField];
    cloudFile = First[Search[Object[EmeraldCloudFile], FileName==fileName], Null];

    (* if it doesn't exist, continue with the calculation,
    if does exist just return the searched file *)
    If[Not[NullQ[cloudFile]],
        Return[ImportCloudFile[cloudFile]]
    ];

    (* unpack the options *)
    safeOps = SafeOptions[TimeSliceSpans, ToList[myOps]];
    maxByteLimit = Lookup[safeOps, BigQuantityArrayByteLimit];
    unresolvedArrayFormat = Lookup[safeOps, ByteArrayFormat];
    arrayFormat = If[MatchQ[unresolvedArrayFormat, Automatic],
        getBinaryRowFormat[myObject, myField],
        unresolvedArrayFormat
    ];

    (* get the size, in bytes, of each element in the BQArray using the ByteArrayFormat *)
    elementByteCount = byteFormatCount[arrayFormat];

    (* find the maximum number of list elements given the max byte limit *)
    (* Just divide the byte limit by the count and take the floor *)
    maxElementNumber = Floor[maxByteLimit / elementByteCount];

    (* set the global variable called TotalSize *)
    $TotalSize = N[$TotalBytes / Unitless[elementByteCount]];

    (* iteratively go through the possible spans running getSpans on each result
    until we reach the end of the file *)
    initialStart = 1;
    rawSpans = recursivelyFindSpans[myObject, myField, initialStart, maxElementNumber];

    (* add manifold logging after getting raw spans *)
    If[TrueQ[ECL`$ManifoldRuntime],
        Echo["Processed all spans! The size of the raw spans are "<>ToString[N[UnitConvert[Quantity[ByteCount[rawSpans], "Bytes"], "MB"]]]];
        Echo["Memory in use: "<>ToString[N[UnitConvert[Quantity[MemoryInUse[], "Bytes"], "GB"]]]];
        Echo["Available memory: "<>ToString[N[UnitConvert[Quantity[MemoryInUse[], "Bytes"], "GB"]]]];
    ];

    (* combine the raw span results into a list of {time1->{start1, stop1}, time1->{start2, stop2},...} *)
    combineSpans[rawSpans]
];

(* recursive helper function that returns the starting position and value of
LCMS data array spans that have the same time value *)
(* Prep case *)
recursivelyFindSpans[myObject_, myField_, currentStart_Integer, maxSize_Integer]:=Module[
    {},
    recursivelyFindSpans[myObject, myField, currentStart, maxSize, {}]
];

(* Inductive case *)
(* Base case is inside the if statement, so this should never hit a loop *)
(* EDIT: added a base case below to avoid the reduce the possibility of hitting an
http error, which works because the max elements are tracked with the $TotalSize variable *)
recursivelyFindSpans[myObject_, myField_, currentStart_Integer, maxSize_, spanResults_] /; (currentStart <= $TotalSize):=Module[
    {
        currentStop, data, mags, units, timeMagnitudes, splitData, lengths, times,
        currentResults, totalResults, newStart
    },

    (* if on manifold report progress *)
    If[TrueQ[ECL`$ManifoldRuntime],
        Echo[StringJoin[
            "Processed ",
            ToString[(currentStart - 1) * 100. / $TotalSize * Percent],
            " out of ",
            ToString[N[UnitConvert[Quantity[$TotalBytes, "Bytes"], "GB"]]],
            " of data."
        ]];
    ];

    (* get new span chunk of data *)
    currentStop = currentStart + maxSize - 1;
    data = Quiet[
        DownloadBigQuantityArraySpan[myObject, myField, currentStart, currentStop],
        BigQuantityArraySpan::IndexError
    ];

    (* break recursion if data failed to find *)
    If[MatchQ[data, $Failed],
        Return[spanResults]
    ];

    (* break data into magnitude and units *)
    mags = QuantityMagnitude[data];
    units = First[Units[data]];

    (* clear data *)
    Clear[data];

    (* split the chunk into parts *)
    splitData = Split[mags, MatchQ[First[#1], First[#2]]& ];

    (* clear mags *)
    Clear[mags];

    (* map length onto the split chunks *)
    lengths = Length /@ splitData;

    (* get the time values for each element in the list *)
    timeMagnitudes = First[First[#]]& /@ splitData;
    times = Quantity[#, First[units]]& /@ timeMagnitudes;

    (* clear splitData, and units *)
    Clear[splitData, units];

    (* thread rules between the times and the lengths *)
    currentResults = Thread[times->lengths];

    (* append these rules to the results list *)
    totalResults = Join[spanResults, currentResults];

    (* recurse again, clearing the cache before continuing *)
    (* define the newStart *)
    newStart = currentStart + maxSize;
    ClearSystemCache[];
    recursivelyFindSpans[myObject, myField, newStart, maxSize, totalResults]
];

(* base case *)
(* exit the recursion if the current start index is larger than the total number of elements in the array *)
recursivelyFindSpans[myObject_, myField_, currentStart_Integer, maxSize_, spanResults_] /; (currentStart > $TotalSize):=Module[
    {},

    (* just return the results *)
    spanResults
];

(* helper to combine raw spans from the recursive function output *)
(* spans take the form of a list of (time->length) rules, but there can be multiple rules with the same time key, so they must be combined *)
combineSpans[rawSpans_]:=Module[
    {groupedSpans, processedSpans, stopElements, startElements, spanValues},

    (* manifold logging saying we are combining spans *)
    If[TrueQ[ECL`$ManifoldRuntime],
        Echo["Combining raw spans..."]
    ];

    (* group the spans by their keys *)
    groupedSpans = Split[rawSpans, MatchQ[First[#1], First[#2]]&];

    (* logging that spans are now grouped *)
    If[TrueQ[ECL`$ManifoldRuntime],
        Echo["Raw spans are now grouped."]
    ];

    (* create a helper function that will total the values in multi-element groupings *)
    (* single element list just strips off the list *)
    combineGroups[{key_->val_}]:=key->val;
    (* multiple element list returns the key value pair with the sum of the values *)
    combineGroups[rules:{_Rule..}]:=Module[
        {key, totalValue},

        (* all keys should be the same, so just grab one *)
        key = First[Keys[rules]];

        (* find the minimum value *)
        totalValue = Total[Values[rules]];

        (* return the rule *)
        key -> totalValue
    ];

    (* map helper over grouped spans *)
    processedSpans = combineGroups /@ groupedSpans;

    (* log that spans are processed into total lengths *)
    If[TrueQ[ECL`$ManifoldRuntime],
        Echo["Groupings have been processed into total lengths."]
    ];

    (* now processedSpans contains a list of rules that describe time->totalLength,
    but for convenience, we want time->{start, stop} *)
    (* the stop elements are easily found from the accumulation of the values *)
    stopElements = Accumulate[Values[processedSpans]];

    (* the start elements, are similar to the stop elements as they are 1+stopElements,
    but the last element is outside the list, and we are missing the first element, 1 *)
    startElements = Join[{1}, Most[stopElements] + 1];

    (* manifold logging that says elements have been contructed *)
    If[TrueQ[ECL`$ManifoldRuntime],
        Echo["Starting and ending elements have been constructed."]
    ];

    (* get the new span values *)
    spanValues = MapThread[{#1, #2}&, {startElements, stopElements}];

    (* manifold logging that says spans are made *)
    If[TrueQ[ECL`$ManifoldRuntime],
        Echo["Final spans have created, now creating the association of spans and returning."]
    ];

    (* return the information as an association of time -> {start, stop} *)
    Association[Thread[Keys[processedSpans] -> spanValues]]
];

(* helper to get the byte count of the element format in a big q array *)
byteFormatCount[format:ConstantArray[byteStringP, 3]]:=Module[
    {bitNumbers},

    (* use a helper from the constellation package to get the bit count for each element in the format *)
    bitNumbers = Constellation`Private`getBitNumber /@ format;

    (* return the total number of bits divided by 8 b/c 8 bits = 1 byte *)
    (* NOTE: we are returning the value with units to compare against the byte limit which also has units *)
    Quantity[Total[bitNumbers] / 8, "Bytes"]
];


(* ::Section::Closed:: *)
(*TimeSlice*)

(*
    Goal is to get a time slice from an LCMS data object
*)

DefineOptions[TimeSlice,
    SharedOptions :> {
        {PlotTimeSlice, {ReferenceField, BigQuantityArrayByteLimit, TimeSliceSpans}}
    }
];


(* TODO: make it reverse listable for myTimes to avoid multiple unnecessary download calls *)
(* overload for lists of objects and times *)
(* map over objects first, and then fields *)
TimeSlice[
    myObjects:{ObjectP[Object[Data,ChromatographyMassSpectra]]..},
    myTimes:ListableP[UnitsP[Minute]],
    myOps:OptionsPattern[]
]:=Map[TimeSlice[#, myTimes, myOps]&, myObjects];

(* overload for listed fields *)
(* map over objects first, and then fields *)
TimeSlice[
    myObject:ObjectP[Object[Data,ChromatographyMassSpectra]],
    myTimes:{UnitsP[Minute]..},
    myOps:OptionsPattern[]
]:=Map[TimeSlice[myObject, #, myOps]&, myTimes];

(* main code *)
TimeSlice[myObject:ObjectP[Object[Data,ChromatographyMassSpectra]], myTime:UnitsP[Minute], myOps:OptionsPattern[]]:=Module[
    {
        safeOps, refField, maxByteSize, timeSpanAssociation, times, nearestTime,
        startIndex, stopIndex, data, massSpecData, fileName, cloudFile, updatedCloudFile
    },

    (* get the options *)
    safeOps = SafeOptions[TimeSlice, ToList[myOps]];

    (* separate the options into variables for clarity *)
    refField = Lookup[safeOps, ReferenceField];
    maxByteSize = Lookup[safeOps, BigQuantityArrayByteLimit];
    timeSliceOp = Lookup[safeOps, TimeSliceSpans];

    (* start by getting an association of time slice -> index span, where an
    index span is of the form: {startIndex, stopIndex} *)
    timeSpanAssociation = If[NullQ[timeSliceOp],
    (* If time slice option is not provided search for the data on S3 *)
        fileName = timeSliceSpanFileName[myObject, refField];
        cloudFile = First[Search[Object[EmeraldCloudFile], FileName==fileName], Null];

        (* if it doesn't exist, calculate the object
        if does exist just return the searched file *)
        updatedCloudFile = If[NullQ[cloudFile],
            SaveTimeSliceSpans[myObject, refField, BigQuantityArrayByteLimit->maxByteSize],
            cloudFile
        ];

        (* import the file and save to timeSpanAssociation *)
        ImportCloudFile[updatedCloudFile],
    (* ELSE: timeSliceOp is not null, so just use that *)
        timeSliceOp
    ];

    (* get the time slice closest to the input time *)
    times = Keys[timeSpanAssociation];
    nearestTime = First@Nearest[times, myTime];

    (* check for exact match, and throw warning if  they don't match *)
    (*NOTE: using RoundMatchQ here to avoid any bit precision issues, but the magic number 8 is the number of rounding digits *)
    If[Not[RoundMatchQ[8][nearestTime, myTime]],
        Message[Warning::InexactTime, myTime, nearestTime]
    ];

    (* get the time span indices *)
    (* NOTE: the reason we need to do it this way is because BQArrays are stored as flat lists, and there's no way to know the size of the MS data ahead of time *)
    {startIndex, stopIndex} = Lookup[timeSpanAssociation, nearestTime];

    (* get the data from the data object using DownloadBigQuantityArraySpan *)
    data = DownloadBigQuantityArraySpan[myObject, refField, startIndex, stopIndex, BigQuantityArrayByteLimit->maxByteSize];

    (* strip off the time values from the data to get just the mass spec data *)
    QuantityArray[Rest /@ data]
];

(* helper to automatically resolve header information *)
getBinaryRowFormat[myObject:ObjectP[Object[Data,ChromatographyMassSpectra]], myField:bigQAFieldsP]:=Module[
    {response, bucket, hash, constellationResponse, url, headerData, header},

    (* request big qa blob *)
	response = Constellation`Private`requestBigQABlob[myObject, myField];

	(* parse the response for the hash *)
	{bucket, hash} = Constellation`Private`getS3BucketAndKey[response, myField];

	(* request a link from constellation that we can use to download parts of the file *)
	constellationResponse = ConstellationRequest[
		<|
			"Path"->"blobsign/download",
			"Body"->ExportJSON[<|"bucket"->bucket,"key"->hash,"expires"->600|>],
			"Method"->"POST"
		|>
	];

	(* get url needed for download *)
	url = Lookup[constellationResponse, "Url"];

	(* get header data by requesting the first 16 kb of data, and returning the
	header information as a string in which each character maps to 1 byte of info from the response *)
	headerData = Constellation`Private`getHeaderData[url];

	(* attempt to decode the header as JSON *)
	header=ImportString[headerData, "RawJSON"];

    (* set $TotalBytes to be used by counter later *)
    $TotalBytes = Constellation`Private`findS3FileSize[hash, bucket] - StringLength[headerData];

	(* return the binary row format for each data element *)
	header["binaryRowFormat"]
];


(* ::Section::Closed:: *)
(*SaveTimeSliceSpans*)

(*
    Goal is to run time slice spans, and save them to a cloud file in a format that is re-readable
*)

DefineOptions[SaveTimeSliceSpans,
    SharedOptions :> {TimeSliceSpans}
];

(* overload for listed objects and listed fields *)
(* map over objects first, and then fields *)
SaveTimeSliceSpans[
    myObjects:{ObjectP[Object[Data,ChromatographyMassSpectra]]..},
    myFields:ListableP[bigQAFieldsP],
    myOps:OptionsPattern[]
]:=Map[SaveTimeSliceSpans[#, myFields, myOps]&, myObjects];

(* overload for listed fields *)
(* map over objects first, and then fields *)
SaveTimeSliceSpans[
    myObject:ObjectP[Object[Data,ChromatographyMassSpectra]],
    myFields:{bigQAFieldsP..},
    myOps:OptionsPattern[]
]:=Map[SaveTimeSliceSpans[myObject, #, myOps]&, myFields];


(* main code *)
SaveTimeSliceSpans[myObject:ObjectP[Object[Data,ChromatographyMassSpectra]], myField:bigQAFieldsP, myOps:OptionsPattern[]]:=Module[
    {timeSliceSpans, fileName, file},

    (* get the time slice spans *)
    timeSliceSpans = TimeSliceSpans[myObject, myField, myOps];

    (* get the file name *)
    fileName = timeSliceSpanFileName[myObject, myField];

    (* manifold logging says the file is being exported now *)
    If[TrueQ[ECL`$ManifoldRuntime],
        Echo["The file of time slice spans is being exported to disk."]
    ];

    (* export the file to disk *)
    file = Export[fileName, timeSliceSpans, "MX"];

    (* manifold logging says the file is being uploaded now *)
    If[TrueQ[ECL`$ManifoldRuntime],
        Echo["The file of time slice spans is being uploaded."]
    ];

    (* upload cloud file *)
    UploadCloudFile[file]
];

(* helper to generate known file name format *)
timeSliceSpanFileName[
    myObject:ObjectP[Object[Data,ChromatographyMassSpectra]],
    myField:bigQAFieldsP
]:=Download[myObject, ID] <> ToString[myField];
