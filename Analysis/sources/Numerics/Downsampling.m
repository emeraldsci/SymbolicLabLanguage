(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*streamAbsorbance3D*)

(*
	Helper that will slice the Absorbance3D field of an object at the AbsorbanceWavelength
	and return a quantity array. This helper is to be used for situations in which the
	absorbance field was not properly uploaded to the data object in the first place.
*)

streamAbsorbanceSlice[object:ObjectP[]] := Module[
	{
		wavelength, spans, times, sliceSize, maxByteSize, sliceByteSize,
		partitionSize, partitionedSpans, absorbanceSlices, count
	},
	(* get the wavelength of the object *)
	wavelength = Download[object, AbsorbanceWavelength];

	(* get the time slice spans *)
	spans = TimeSliceSpans[object, Absorbance3D];

	(* get the times that correspond to slices *)
	times = Keys[spans];

	(* get a slice length in terms of number of elements *)
	sliceSize = -1*(Subtract @@ Lookup[spans, times[[1]]]);

	(* hard-code a max byte size for now *)
	maxByteSize = 200000000; (* is about 200 MB *)

	(* hard-code slice size for now *)
	sliceByteSize = 6024;

	partitionSize = Floor[N[maxByteSize/sliceByteSize]];

	partitionedSpans = Partition[Normal[spans], UpTo[partitionSize]];

	count = 0;

	absorbanceSlices = Monitor[
		Map[
			(count++; getSpanSlice[object, #, wavelength]) &,
			partitionedSpans
		],
		ProgressIndicator[count, {1, Length[partitionedSpans]}]
	];

	(* join the absorbance slices *)
	Flatten[absorbanceSlices, 1]
];

getSpanSlice[object_, spanSection_List, wavelength_] := Module[
	{
		firstIndex, lastIndex, data, unitlessData, nearestData, times,
		absorbances, timeUnits, absUnits
	},

	(* get first and last indices of the span section *)
	(* hilarious nesting is because spans are {time \[Rule] \
	{firstIndex,lastIndex}, ..}
	so we get the first rule,
	take the value with last (the index pair),
	and get the first index in the pair *)
	(* a similar procedure is used to find the last index in the \
	section *)
	firstIndex = First[Last[First[spanSection]]];
	lastIndex = Last[Last[Last[spanSection]]];

	(* download the full span *)
	data =
	DownloadBigQuantityArraySpan[object, Absorbance3D, firstIndex, lastIndex];

	(* should be of the form {{time, wavelength, value}} *)
	(* strip off time part and clear partial data *)
	unitlessData = Unitless[data];

	(* find the data points that are nearest to the wavelength *)
	nearestData = Nearest[
		unitlessData,
		{0, Unitless[wavelength], 0},
		DistanceFunction -> (Abs[#1[[2]] - #2[[2]]] &)
	];

	(* strip off the first and last components of the nearest data *)
	times = First /@ nearestData;
	absorbances = Last /@ nearestData;

	(* return them in {x,y} pairs and add units *)
	timeUnits = Units[data[[1, 1]]];
	absUnits = Units[data[[1, 3]]];
	QuantityArray[
	Transpose[{times, absorbances}], {timeUnits, absUnits}]
];

(*
	helper that properly converts the input and output of the above helper into
	a packet so that it can be uploaded
*)
prepareAbsorbanceUploadPacket[
	object:ObjectP[],
	spectrum_List
]:=<|
    Object -> object[Object],
    Replace[Absorbance] -> QuantityArray[spectrum]
|>

(* helper that combines the streaming and uploading into one call *)
(* Overload 1 - Data Overload *)
streamAndUploadAbsorbanceSlices[object:ObjectP[Data,ChromatographyMassSpectra]]:=streamAndUploadAbsorbanceSlices[{object}];
streamAndUploadAbsorbanceSlices[objects:{ObjectP[Data,ChromatographyMassSpectra]..}]:=Module[
	{slices, packets},

	(* stream the slices from the cloud file of the object *)
	slices = streamAbsorbanceSlice /@ objects;

	(* create the upload packets *)
	packets = MapThread[
		prepareAbsorbanceUploadPacket,
		{objects, slices}
	];

	(* upload the packets *)
	Upload[packets];
];

(* Overload 2 - Protocol Overload *)
streamAndUploadAbsorbanceSlices[protocol:ObjectP[Object[Protocol,LCMS]]]:=Module[
	{dataObjects, slices, packets},

	dataObjects = Download[protocol,Data[Object]];

	(* stream the slices from the cloud file of the object *)
	slices = streamAbsorbanceSlice /@ dataObjects;

	(* create the upload packets *)
	packets = MapThread[
		prepareAbsorbanceUploadPacket,
		{dataObjects, slices}
	];

	(* upload the packets *)
	Upload[packets];
];


(* ::Section:: *)
(* AnalyzeDownsampling *)


(* ::Subsection:: *)
(* Patterns *)

(* Custom Patterns *)

(* List of Object[Data] types for which downsampling analysis is supported *)
downsampleObjectP=ObjectP[{
	Object[Data,ChromatographyMassSpectra]
}];

(* Loookup mapping Object[Data] types to default fields and their dimensions *)
defaultDownsamplingFields={
	Object[Data,ChromatographyMassSpectra]->{IonAbundance3D,3}
};

(* Lookup table defining types *)
typeToDownsamplingField={
	Object[Data,ChromatographyMassSpectra]->DownsamplingAnalyses
};

(* Lookup table defining log fields *)
typeToLogField={
	Object[Data,ChromatographyMassSpectra]->DownsamplingLogs
};


(* ::Subsection:: *)
(* Options *)


DefineOptions[AnalyzeDownsampling,
	Options:>{
		{
			OptionName->DownsamplingRate,
			Default->Automatic,
			Description->"For each dimension of the input data, data will be downsampled such that the grid spacing in that dimension is as close to the specified downsampling rate as possible without requiring resampling.",
			ResolutionDescription->"Automatic defaults to the grid spacing in each independent variable.",
			AllowNull->False,
			Widget->Adder[
				Alternatives[
					Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
					Widget[Type->Enumeration,Pattern:>Alternatives[None]]
				]
			]
		},
		{
			OptionName->DownsamplingFunction,
			Default->Automatic,
			Description->"For each dimension of the input data, the function used to combine data points during downsampling.",
			ResolutionDescription->"Automatic defaults to {Mean..}, with length equal to the dimensionality of the input data.",
			AllowNull->False,
			Widget->Adder[
				Widget[Type->Enumeration,Pattern:>Alternatives[Total,Min,Max,Mean,First]]
			]
		},
		{
			OptionName->NoiseThreshold,
			Default->Automatic,
			Description->"Data points for which the value in the last dimension (e.g. z, for a list of {x,y,z} data points) is less than this threshold will have that value set to zero in the downsampled data. Set this option to None to disable thresholding.",
			ResolutionDescription->"Automatic will algorithmically set the noise threshold by applying Otsu's algorithm to log-transformed data (to preserve peaks).",
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>Alternatives[UnitsP[]|OtsuThreshold|None],Size->Word]
		},
		{
			OptionName->ReorderDimensions,
			Default->Null,
			Description->"A list of indices indicating how to rearrange the dimensions of the data, e.g. {1,3,2} to swap {x,y,z} to {x,z,y} data points.",
			AllowNull->True,
			Widget->Adder[
				Widget[Type->Number,Pattern:>GreaterP[0,1]]
			]
		},
		{
			OptionName->LoadingBars,
			Default->True,
			Description->"Indicates whether loading bars should be rendered during long downsampling calculations. Note that enabling loading bars may cause calculations to take longer.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]]
		},
		{
			OptionName->UploadErrorLogs,
			Default->False,
			Description->"True indicates that this function call is being run on Manifold, and that error logs should be collected and uploaded to Constellation.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
			Category->"Hidden"
		},
		{
			OptionName->Streaming,
			Default->False,
			Description->"Indicates whether streaming downsampling should be invoked when raw data cannot be downsampled in the conventional way.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]]
		},
		{
			OptionName->Parallel,
			Default->False,
			Description->"Indicates whether streaming downsampling should be carried out in parallel threads on Manifold when raw data file size is too large (> 10GB).",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]]
		},
		{
			OptionName->Threads,
			Default->5,
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[2]],
			Description->"Number of parallel Compute jobs on Manifold when setting Parallel->True."
		},
    OutputOption,
    UploadOption,
    AnalysisTemplateOption
  }
];

(* ::Subsection::Closed:: *)
(*Messages and Errors*)

(* ---------------------------- *)
(* --- MESSAGES AND ERRORS  --- *)
(* ---------------------------- *)
Error::DebugEcho="`1`: `2`.";
Error::FieldNotFound="The requested field `1` of object `2` could not be downloaded. Please verify that the field name is correct, and that the field is not empty.";
Error::InvalidDataFormat="Input data did not resolve to a list of coordinates matching the pattern MatrixP[]. Please verify that the input data has the correct format.";
Error::InvalidDownsamplingSpec="The provided value `1` for option `2` must match the number of independent-variable dimensions in the input data. Please specify a list with length `3`.";
Error::InvalidReordering="The reordering `1` supplied in option ReorderDimensions is invalid for input data with dimension `2`. Please ensure the provided reordering is a list of the indices `3` in the desired order.";
Error::UnevenData3D="The requested 3D data to downsample is unevenly spaced in its first dimension. \
If this is the only dimension that is unevenly sampled, please re-order the data using the option ReorderDimensions. \
Downsampling is currently not supported for data that is unevenly sampled in more than one dimension.";
Error::UnsupportedDimension="Resolved input data has dimension `1`, but only 2D and 3D data are supported. Please verify that input data is either a list of {x,y} or {x,y,z} data points.";
Warning::DownsamplingRateTooLarge="The specified downsampling rate `1` is larger than the half the range of data `2` in dimension `3`. No downsampling will be performed in this dimension.";
Warning::DownsamplingRateTooSmall="The specified downsampling rate `1` is smaller than the spacing `2` in dimension `3`. No downsampling will be performed in this dimension.";
Warning::IncompatibleUnits="The option value `1` for `2` is incompatible with resolved input unit `3` in `4`. Units will be ignored for this dimension.";
Warning::LongComputation="This calculation is estimated to take `1` to complete, with an approximate completion time of (`2`) if started now.";


(* ::Subsection::Closed:: *)
(*Overloads*)

(* --------------------------- *)
(* --- SECONDARY OVERLOADS --- *)
(* --------------------------- *)

(* Listable Overload without field speficied *)
AnalyzeDownsampling[objs:{downsampleObjectP..},myOps:OptionsPattern[AnalyzeDownsampling]]:=AnalyzeDownsampling[objs,IonAbundance3D,myOps];

(* Listable Overload *)
(* This currently INTENTIONALLY maps download, since the fields we work with are large >1GB and may not fit in memory *)
AnalyzeDownsampling[objs:{downsampleObjectP..},field:_Symbol,myOps:OptionsPattern[AnalyzeDownsampling]]:=Module[
	{listedOptions,outputSpecification,output,downsampleResults,groupedOutputRules},

	(* Convert options into a list *)
	listedOptions=ToList[myOps];

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Map AnalyzeDownsampling on the inputs *)
	downsampleResults=Map[
		AnalyzeDownsampling[#,field,
			(* Need to use the listed form of output for combined option rules below (e.g. {Result} instead of Result) *)
			ReplaceRule[listedOptions,Output->output]
		]&,
		objs
	];

	(* Since the AnalyzeDNASequencing call was mapped on lists of data, we must consolidate the options, preview, and tests for builder *)
	groupedOutputRules=MapIndexed[
		Function[{requestedOutput,idx},
			requestedOutput->Switch[requestedOutput,
				(* Extract just the results from each function call *)
				Result,Part[#,First[idx]]&/@downsampleResults,
				(* AnalyzeDNASequencing resolves the same options for each function call, so we can just take the first one *)
				Options,First[Part[#,First[idx]]&/@downsampleResults],
				(* Incorporate all previews into a single slide view *)
				Preview,Null,
				(* Combine the lists of tests for each run *)
				Tests,Flatten[Part[#,First[idx]]&/@downsampleResults]
			]
		],
		output
	];

	(* Return the requested output *)
	outputSpecification/.groupedOutputRules
];


(* Default field is used if not specified *)
AnalyzeDownsampling[obj:downsampleObjectP, myOps:OptionsPattern[AnalyzeDownsampling]]:=AnalyzeDownsampling[obj,
	FirstOrDefault@Lookup[defaultDownsamplingFields, obj[Type]],
	myOps
];


(* ::Subsection::Closed:: *)
(*Main Function Body*)

(* --------------------------------------------------------------------------------------*)
(*   PRIMARY OVERLOAD: single thread, streaming and parallel multi-threads downsampling  *)
(* ------------------------------------------------------------------------------------- *)
AnalyzeDownsampling[obj:downsampleObjectP, field:_Symbol, myOps:OptionsPattern[AnalyzeDownsampling]]:=Module[
	{listedOptions, safeOptions, streaming, parallel, actualOptions, dataSize, dataSizeBytes},

	(* Get all options *)
	listedOptions=ToList[myOps];

	safeOptions=SafeOptions[AnalyzeDownsampling,listedOptions,AutoCorrect->False];

	(* Check if streaming options is invoked *)
	streaming=Lookup[safeOptions,Streaming];

	(* Check if parallel option is invoked *)
	parallel=Lookup[safeOptions,Parallel];

	(* Remove Streaming, Threads and Parallel from option list to pass into analyzeDownsampling *)
	actualOptions=Normal[KeyDrop[listedOptions,{Threads,Streaming,Parallel}]];

	(* Get size of raw data in bytes *)
	dataSizeBytes = getCloudFileSize[obj[Object],field];

	(* if data size failed, that means the field was wrong, so send message and returned failed *)
	If[MatchQ[dataSizeBytes, $Failed],
		Message[Error::FieldNotFound,field,Download[obj,Object]];
		Return[$Failed]
	];

	(* convert to megabytes for simplicity *)
	dataSize = dataSizeBytes/1024.^2;

	(* Invoke the correct downsampling function based on raw data size in MB *)
	Which[
		(* Original single thread downsampling *)
		(dataSize<1000)&&(!streaming&&!parallel),analyzeDownsampling[obj,field,actualOptions],

		(* Single thread streaming downsampling for big data *)
		(dataSize<1000)&&(streaming&&!parallel),downsamplingByParts[obj,field,myOps],

		(* Multi-thread parallel streaming downsampling on Manifold *)
		(dataSize<=1000)&&(streaming&&parallel),downsamplingParallel[obj,field,myOps],

		(* Large data: streaming *)
		(dataSize>1000)&&(dataSize<=5000)&&streaming,downsamplingByParts[obj,field,myOps],

		(* Large data: automatic parallel with default 5 threads *)

		(dataSize>1000)&&(dataSize<=5000),If[TrueQ[ECL`$ManifoldRuntime],Echo["5-thread automatic parallel"]];downsamplingParallel[obj,field,myOps],

		(* Invoke 20-thread parallel option when data is huge *)
		(dataSize>5000),If[TrueQ[ECL`$ManifoldRuntime],Echo["20-thread automatic parallel"]];downsamplingParallel[obj,field,myOps,Threads->20]

	]
];

(* --------------------------------------------------- *)
(* --- Original PRIMARY OVERLOAD for single thread --- *)
(* --------------------------------------------------- *)
analyzeDownsampling[obj:downsampleObjectP, field:_Symbol, myOps:OptionsPattern[AnalyzeDownsampling]]:=Module[
	{
		outputSpecification,output,gatherTests,listedOptions,standardFieldsStart,objRef,objType,objID,
		errorLog,collectMessages,safeOptions,safeOptionsTests,originalDim,templatedOptions,templateTests,combinedOptions,
		originalData,resolvedInputResult,resolvedInput,dataUnits,dim,resampledInput,ranges,
		downsampledInput,resolvedDownsamplingOptions,thresholdedInput,resolvedNoiseThreshold,
		resolvedOptions,uploadPacket,dataCloudFile,tempMessageStream,uploadResult,
		quickResolvedOptions,dataByteCount,showloadingBars,scaledRanges
	},

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

	(* Convert options into a list *)
	listedOptions=ToList[myOps];

	(* Get the object reference and type of the input *)
	{objRef,objType,objID}=Download[obj,{Object,Type,ID}];

	(* Populate the error log with the original function call *)
	errorLog=StringJoin[
		"AnalyzeDownsampling["<>ToString[objRef]<>", "<>ToString[field]<>", ...]\n",
		"Options: "<>ToString[listedOptions]<>"\n",
		"Start Time: "<>DateString[Now]
	];

	(* Check for temporal links *)
	checkTemporalLinks[obj,myOps];

	(* Populate standard fields for constructing analysis object packets later *)
	standardFieldsStart=analysisPacketStandardFieldsStart[listedOptions];

	(* Call safe options to ensure all options are populated and match patterns *)
	{safeOptions,safeOptionsTests}=If[gatherTests,
		SafeOptions[AnalyzeDownsampling,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeDownsampling,listedOptions,AutoCorrect->False],Null}
	];

	(* Remove options for Huge files: Threads, Streaming and Parallel *)
	safeOptions=Select[safeOptions,!MatchQ[#,Threads ->_]&&!MatchQ[#,Streaming->_]&&!MatchQ[#,Parallel->_]&];

	(* Return $Failed (and tests to this point) if specified options do not match patterns *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> safeOptionsTests
		}]
	];

	(* Use template options to get values for options that were not specified in ops *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[AnalyzeDownsampling,{{obj},{field}},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeDownsampling,{{obj},{field}},listedOptions],Null}
	];

	(* Return $Failed (and tests to this point) if template object cannot be found *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests,templateTests]
		}]
	];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

	(* Early option resolution for Command Builder, skipping lengthy calculations *)
	quickResolvedOptions=resolveOptionsFast[objType,field,combinedOptions];

	(* Command Builder - stop early if options are requested but not Result *)
	If[MemberQ[output,Options]&&!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Options -> RemoveHiddenOptions[AnalyzeDownsampling,quickResolvedOptions],
			Preview -> Null,
			Tests -> Join[safeOptionsTests,templateTests]
		}]
	];

	(* True indicates that all messages thrown during the function should be collected for error logging  *)
	collectMessages=OptionValue[UploadErrorLogs];

	If[collectMessages,
		PrintTemporary["Memory available: ",MemoryAvailable[]/(1024.0^2)];
	];

	(* Download the requested dataset *)
	originalData=Download[obj,field,BigQuantityArrayByteLimit->None];

	If[collectMessages,
		PrintTemporary["Memory after download: ",MemoryInUse[]/(1024.0^2)];
	];

	(* Return a fail state if the field could not be found ($Failed) or is empty (Null, {}) *)
	If[MatchQ[originalData,$Failed|Null|{}],
		Message[Error::FieldNotFound,field,Download[obj,Object]];
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests,templateTests]
		}]
	];

	(* Approximate size of the downloaded data, in MB *)
	dataByteCount=ByteCount[originalData]/(1024.0^2);

	(* Warn the user if the computation will be long *)
	If[dataByteCount>250.0,
		Message[Warning::LongComputation,
			(Round[(dataByteCount/100.0),0.1] Minute),
			DateString[Now+((dataByteCount/100.0) Minute)]
		]
	];

	(* True indicates that loading bars should be shown while computation is running *)
	showLoadingBars=OptionValue[LoadingBars];

	(* Use streams to collect error messages if error-logging is requested *)
	tempMessageStream=If[collectMessages,
		With[{newStream=OpenWrite[]},
			Off[General::stop];
			$Messages=Append[$Messages,newStream];
			newStream
		],
		Null
	];

	(* Handle the case where there was an early termination to the upload *)
	If[MemberQ[Unitless[Last[originalData]],EndOfFile],
		originalData=originalData[[;;-2]];
	];

	(* Resolve the input data *)
	resolvedInputResult=resolveDownsamplingInput[originalData,showLoadingBars,combinedOptions];

	If[collectMessages,
		PrintTemporary["Memory after sorting: ",MemoryInUse[]/(1024.0^2)];
	];

	(* Return a fail state if the input did not resolve *)
	If[MatchQ[resolvedInputResult,$Failed],
		(* Upload the error log, if requested, with the Fail state *)
		If[collectMessages,
			uploadErrorLog[objRef,$Failed,tempMessageStream,errorLog,OptionValue[Upload]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests,templateTests]
		}]
	];

	(* If resolution passed, then assign the output *)
	{resolvedInput,dataUnits,dim}=resolvedInputResult;

	(* Ensure that the data is evenly sampled on a grid, resampling if needed *)
	{resampledInput,ranges}=resampleToGrid[resolvedInput,showLoadingBars,dim];

	(* Return a fail state if the input did not resolve *)
	If[MatchQ[resampledInput,$Failed],
		(* Upload the error log, if requested, with the Fail state *)
		If[collectMessages,
			uploadErrorLog[objRef,$Failed,tempMessageStream,errorLog,OptionValue[Upload]]
		];
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests,templateTests]
		}]
	];

	If[collectMessages,
		PrintTemporary["Memory after resampling: ",MemoryInUse[]/(1024.0^2)];
	];

	(* Downsample the data according to the specification *)
	{downsampledInput,resolvedDownsamplingOptions}=downsampleData[
		resampledInput,
		ranges,
		dataUnits,
		combinedOptions,
		dim
	];

	(* Rescale the ranges so that they have the correct spacing *)
	scaledRanges=MapThread[
		{
			#1[[1]],
			#1[[2]],
			#1[[3]]*Length[Range@@#1]/#2
		}&,
		{ranges,Dimensions[downsampledInput]}
	];

	If[collectMessages,
		PrintTemporary["Memory after downsampling: ",MemoryInUse[]/(1024.0^2)];
	];

	(* Apply a noise threshold to the data to take advantage of sparsity *)
	{thresholdedInput,resolvedNoiseThreshold}=(
		If[collectMessages,PrintTemporary["Applying noise threshold ..."]];
		thresholdData[downsampledInput,combinedOptions]
	);

	If[collectMessages,
		PrintTemporary["Memory after thresholding: ",MemoryInUse[]/(1024.0^2)];
	];

	(* Resolved Options *)
	resolvedOptions=ReplaceRule[combinedOptions,
		Join[resolvedDownsamplingOptions,resolvedNoiseThreshold]
	];

	(* If upload was requested, also upload the downsampled data as a cloud file for quick access *)
	dataCloudFile=If[Lookup[combinedOptions,Upload]&&MatchQ[thresholdedInput,_SparseArray],
		Module[{filePath,file,cloudFile},
			(* Indicate that we are uploading to constellation *)
			If[collectMessages,
				PrintTemporary["Uploading results to Constellation ..."];
			];

			(* Unique file path depends on input object ID and current time *)
			filePath=FileNameJoin[{
				$TemporaryDirectory,
				StringJoin["downsampleID",StringTake[objID,4;;],StringDelete[DateString["ISODateTime"],":"]<>".mx"]
			}];

			(* Export as a MX file *)
			file=Export[filePath,thresholdedInput,"MX"];

			(* Upload cloud file *)
			cloudFile=UploadCloudFile[file];

			(* Delete the file *)
			DeleteFile[filePath];

			(* Return the cloudfile *)
			If[MatchQ[cloudFile,$Failed],
				Null,
				Link[cloudFile]
			]
		],
		Null
	];

	(* Construct the upload packet *)
	uploadPacket=Association@@Join[
		standardFieldsStart,
		{
			Type->Object[Analysis,Downsampling],
			Replace[Reference]->Link[objRef,Lookup[typeToDownsamplingField,objType]],
			ReferenceField->field,
			ResolvedOptions->resolvedOptions,
			Replace[OriginalDimension]->Lookup[resolvedOptions,ReorderDimensions]/.{Null->Range[dim]},
			Replace[DataUnits]->dataUnits,
			Replace[SamplingGridPoints]->Append[scaledRanges,Null],
			NoiseThreshold->Lookup[resolvedNoiseThreshold,NoiseThreshold],
			If[Lookup[combinedOptions,Upload],Nothing,DownsampledData->thresholdedInput],
			DownsampledDataFile->dataCloudFile
		}
	];

	If[collectMessages,
		PrintTemporary["Memory after cloudfile: ",MemoryInUse[]/(1024.0^2)];
	];

	(* Attempt to upload the packet if requested *)
	uploadResult=If[Lookup[combinedOptions,Upload],
		Upload[uploadPacket],
		uploadPacket
	];

	If[collectMessages,
		PrintTemporary["Memory after uploading: ",MemoryInUse[]/(1024.0^2)];
	];

	(* Upload the error log, if requested, with the Fail state *)
	If[collectMessages,
		uploadErrorLog[objRef,uploadResult,tempMessageStream,errorLog,Lookup[combinedOptions,Upload]]
	];

	(* Return the requested output, only uploading if requested *)
	outputSpecification/.{
		Result->uploadResult,
		Options->RemoveHiddenOptions[AnalyzeDownsampling,resolvedOptions],
		Preview->Null, (* No preview for this function *)
		Tests->Join[safeOptionsTests,templateTests]
	}
];



(* ::Subsection::Closed:: *)
(*resolveDownsamplingInput*)

(* Check that numerical data is suitable for downsampling, and reorder dimensions as requested *)
resolveDownsamplingInput[data_,loadBars:True|False,safeOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{
		firstPoint,ndim,originalUnits,downsampleRate,downsampleFunc,
		unitlessData,reorderIndices,reorderedData,sortedData
	},

	(* Pull out the first data point *)
	firstPoint=FirstOrDefault[data,$Failed];

	(* Early fail if the data does not match MatrixP[] *)
	If[!MatchQ[data,MatrixP[]]||MatchQ[firstPoint,$Failed|{}],
		Message[Error::InvalidDataFormat];
		Return[$Failed]
	];

	(* Get the dimensionality and original units of the data *)
	ndim=Length[firstPoint];
	originalUnits=Units[firstPoint];

	(* Early fail if the data is not either 2D or 3D *)
	If[ndim<2||ndim>3,
		Message[Error::UnsupportedDimension,Length[firstPoint]];
		Return[$Failed]
	];

	(* Look up downsampling options *)
	downsampleRate=Lookup[safeOps,DownsamplingRate];
	downsampleFunc=Lookup[safeOps,DownsamplingFunction];

	(* Early fail if any of the downsampling options have the wrong length *)
	If[!MatchQ[downsampleRate,Automatic]&&Length[downsampleRate]!=(ndim-1),
		Message[Error::InvalidDownsamplingSpec,downsampleRate,DownsamplingRate,ndim-1];
		Return[$Failed]
	];
	If[!MatchQ[downsampleFunc,Automatic]&&Length[downsampleFunc]!=(ndim-1),
		Message[Error::InvalidDownsamplingSpec,downsampleFunc,DownsamplingFunction,ndim-1];
		Return[$Failed]
	];

	(* Strip units from the data so it is faster to work with *)
	unitlessData=Unitless[data];

	(* Re-order the dimensions of the input data according to options *)
	reorderIndices=Lookup[safeOps,ReorderDimensions];

	(* Check the provided index reordering for validity *)
	If[!(MatchQ[reorderIndices,Null]||MatchQ[Sort[reorderIndices],Range[ndim]]),
		Message[Error::InvalidReordering,reorderIndices,ndim,Range[ndim]];
		Return[$Failed];
	];

	(* Reorder the data *)
	reorderedData=If[MatchQ[reorderIndices,Null|Range[ndim]],
		unitlessData,
		unitlessData[[All,reorderIndices]]
	];

	(* Check if data is sorted by axis, and sort if it isn't *)
	sortedData=Switch[ndim,
		2,sort2DCoordinates[reorderedData],
		3,sort3DCoordinates[reorderedData,loadBars]
	];

	(* Return the sorted data along with its units *)
	{sortedData,originalUnits,ndim}
];

(* Sort data by the first dimension if it is not sorted already *)
sort2DCoordinates[data_]:=Module[
	{sortedQ},

	(* True if 2D data is already sorted on its first dimension *)
	sortedQ=OrderedQ[Part[data,All,1]];

	(* Only sort if the data is not already sorted *)
	If[sortedQ,
		data,
		SortBy[data,First]
	]
];

(* Sort and group data by the first dimension, then sort the second dimension *)
sort3DCoordinates[data_,loadBars:True|False]:=Module[
	{firstSortedQ,sortedByFirst,splitByFirst,monitorIndex=1,sortResult},

	(* True if 3D data is sroted on its first dimension *)
	firstSortedQ=OrderedQ[Part[data,All,1]];

	(* Sort by first point *)
	sortedByFirst=If[firstSortedQ,
		data,
		SortBy[data,First]
	];

	(* Split data by the first point *)
	splitByFirst=fastSplitByPart[sortedByFirst,1];

	(* Sort and return the resolved input *)
	If[loadBars,
		Monitor[
			MapIndexed[
				(
					monitorIndex=First[#2];
					If[OrderedQ[Part[#1,All,2]],
						#1,
						SortBy[#1,Function[{xyz},Part[xyz,2]]]
					]
				)&,
				splitByFirst
			],
			Refresh[
				Row[{
					"Sorting Data: ",
						ProgressIndicator[monitorIndex/Length[splitByFirst]],
						" "<>ToString[monitorIndex]<>"/"<>ToString[Length[splitByFirst]]
				}],
				TrackedSymbols:>{},
				UpdateInterval->5
			]
		],
		MapIndexed[
			(
				monitorIndex=First[#2];
				If[OrderedQ[Part[#1,All,2]],
					#1,
					SortBy[#1,Function[{xyz},Part[xyz,2]]]
				]
			)&,
			splitByFirst
		]
	]
];



(* ::Subsection::Closed:: *)
(*resampleToGrid*)

(* Check if 2D data is evenly sampled, and resample onto a constant grid if it is not *)
resampleToGrid[sortedData_,loadBars:True|False,2]:=Module[
	{gridPoints, gridTable, evenData},

	(* The x values of the {x,y} data points *)
	gridPoints=Part[sortedData,All,1];

	(* The min, max, and spacing of an evenly spaced grid with this min, max, and number of points *)
	gridTable={Min[gridPoints],Quantile[gridPoints,0.999],Median[DeleteCases[Differences[gridPoints],0|0.0]]};

	(* Resample the data onto a grid if it is not evenly spaced already *)
	evenData=If[evenlySpacedQ[Part[sortedData,All,1]],
		sortedData,
		SparseArray[fastResample2D[sortedData,gridTable]]
	];

	(* Return the re-sampled data and grid table *)
	{evenData,{gridTable}}
];


(* Check if 3D data is evenly sampled, and resample onto a constant grid if it is not *)
resampleToGrid[sortedData_,loadBars:True|False,3]:=Module[
	{gridPointsX,gridTableX,gridPointsY,minDiff,minY,maxY,diffY,gridTableY,monitorIndex=1,evenData},

	(* First, check if the X-value grid points are valid *)
	gridPointsX=Part[sortedData,All,1,1];

	(* Return a fail state if the 3D data is not evenly spaced in the X-direction *)
	If[!evenlySpacedQ[gridPointsX],
		Message[Error::UnevenData3D];
		Return[{$Failed,$Failed}]
	];

	(* Find the min, max, and spacing of the spacing in the X-direction *)
	gridTableX={
		Min[gridPointsX],
		Max[gridPointsX],
		((Max[gridPointsX]-Min[gridPointsX])/N@Length[gridPointsX])
	};

	(* Get all the grid points in the Y-direction *)
	gridPointsY=Part[sortedData,All,All,2];

	(* Minimum y-value across all data *)
	minY=Min[Flatten[gridPointsY]];

	(* Maximum y-value across data, accounting for outliers/weird LCMS sampling *)
	maxY=Quantile[Flatten[gridPointsY],0.995]*(1/0.995);

	(* The smallest difference which results in less than a 500x upsampling to force a grid *)
	minDiff=(maxY-minY)/(Mean[Length/@sortedData]*500);

	(* Difference is smallest of the spacing medians across slices, to preserve narrow peaks *)
	diffY=Min@Map[
		Median[DeleteCases[Differences[#],0|0.0]/.{{}->{100.0}}]&,
		gridPointsY
	];

	(* Find the min, max, and minimum spacing in the Y-direction *)
	gridTableY={minY,maxY,Max[diffY,minDiff]};

	(* Sort and return the resolved input *)
	evenData=If[loadBars,
		Monitor[
			SparseArray@MapIndexed[
				(
					monitorIndex=First[#2];
					SparseArray@fastResample2D[Part[#1,All,-2;;],Sequence@@gridTableY]
				)&,
				sortedData
			],
			Refresh[
				Row[{
					"Resampling uneven slices: ",
					ProgressIndicator[monitorIndex/Length[sortedData]],
					" "<>ToString[monitorIndex]<>"/"<>ToString[Length[sortedData]]
				}],
				TrackedSymbols:>{},
				UpdateInterval->5
			]
		],
		SparseArray@MapIndexed[
			(
				monitorIndex=First[#2];
				SparseArray@fastResample2D[Part[#1,All,-2;;],Sequence@@gridTableY]
			)&,
			sortedData
		]
	];

	(* Return the data and ranges *)
	{evenData,{gridTableX,gridTableY}}
];

(* LG: Overload resampleToGrid to use existing gridTableY *)
resampleToGrid[sortedData_,loadBars:True|False,3,inGridTableY_]:=Module[
	{gridPointsX,gridTableX,gridTableY,currentGridTableY,gridPointsY,minDiff,minY,maxY,diffY,monitorIndex=1,evenData},

	(* First, check if the X-value grid points are valid *)
	gridPointsX=Part[sortedData,All,1,1];

	(* Return a fail state if the 3D data is not evenly spaced in the X-direction *)
	If[!evenlySpacedQ[gridPointsX],
		Message[Error::UnevenData3D];
		Return[{$Failed,$Failed}]
	];

	(* Find the min, max, and spacing of the spacing in the X-direction *)
	gridTableX={
		Min[gridPointsX],
		Max[gridPointsX],
		((Max[gridPointsX]-Min[gridPointsX])/N@Length[gridPointsX])
	};

	(* Get all the grid points in the Y-direction *)
	gridPointsY=Part[sortedData,All,All,2];

	(* Maximum y-value across data, accounting for outliers/weird LCMS sampling *)
	maxY=Quantile[Flatten[gridPointsY],0.995]*(1/0.995);

	(* Final Y grid  *)
	gridTableY={inGridTableY[[1]],Min[maxY,inGridTableY[[2]]],inGridTableY[[3]]};

	(* Sort and return the resolved input *)
	evenData=If[loadBars,
		Monitor[
			SparseArray@MapIndexed[
				(
					monitorIndex=First[#2];
					SparseArray@fastResample2D[Part[#1,All,-2;;],Sequence@@gridTableY]
				)&,
				sortedData
			],
			Refresh[
				Row[{
					"Resampling uneven slices: ",
					ProgressIndicator[monitorIndex/Length[sortedData]],
					" "<>ToString[monitorIndex]<>"/"<>ToString[Length[sortedData]]
				}],
				TrackedSymbols:>{},
				UpdateInterval->5
			]
		],
		SparseArray@MapIndexed[
			(
				monitorIndex=First[#2];
				SparseArray@fastResample2D[Part[#1,All,-2;;],Sequence@@gridTableY]
			)&,
			sortedData
		]
	];

	(* Return the data and ranges *)
	{evenData,{gridTableX,gridTableY}}
];

(* ::Subsection::Closed:: *)
(*downsampleData*)

(* Downsample 3D data according to specification in the options *)
downsampleData[gridData_, ranges_, units_, combinedOps:{(_Rule|_RuleDelayed)..}, 3]:=Module[
	{
		xSampleRate,ySampleRate,xUnits,yUnits,resolvedRates,resolvedFunc,resolvedOps,
		xRateConverted,yRateConverted,xfreq,yfreq,resolvedFreqs,downsampledX,downsampledData,
		partitionedXIndices,partitionedYIndices,monitorIndex1=1,monitorIndex2=1,loadBars
	},

	(* Rate at which the input data was sampled *)
	xSampleRate=ranges[[1,-1]];
	ySampleRate=ranges[[2,-1]];

	(* Data associated with the x and y units *)
	(* Need to do this due to difference in ECL unit definition and MM definition *)
	xUnits=Quantity[1,units[[1]]];
	yUnits=Quantity[1,units[[2]]];

	(* Determine whether or not to show loading bars *)
	loadBars=Lookup[combinedOps,LoadingBars];

	(* Automatic rate defaults to the grid spacing in the x- and y- directions (no downsampling) *)
	resolvedRates=Switch[Lookup[combinedOps,DownsamplingRate],
		Automatic,{xSampleRate*xUnits,ySampleRate*yUnits},
		{Automatic|None,Automatic|None},{xSampleRate*xUnits,ySampleRate*yUnits},
		{_,Automatic|None},{First[Lookup[combinedOps,DownsamplingRate]],ySampleRate*yUnits},
		{Automatic|None,_},{xSampleRate*xUnits,Last[Lookup[combinedOps,DownsamplingRate]]},
		_,Lookup[combinedOps,DownsamplingRate]
	];

	(* Automatic downsampling function will default to Mean in both x and y directions *)
	resolvedFunc=Lookup[combinedOps,DownsamplingFunction]/.{
		Automatic->{Mean,Mean}
	};

	(* Resolved options *)
	resolvedOps={
		DownsamplingRate->resolvedRates,
		DownsamplingFunction->resolvedFunc
	};

	(* Convert rates to desired units, ignore units if they are incompatible *)
	{xRateConverted,yRateConverted}=Quiet[
		MapThread[
			Check[N@Unitless[#1,#2],
				Message[Warning::IncompatibleUnits,#1,DownsamplingRate,#2,units];
				N@Unitless[#1]
			]&,
			{resolvedRates,Most@units}
		],
		{Quantity::compat}
	];

	(* Raw frequency of resampling *)
	xfreq=xRateConverted/xSampleRate;
	yfreq=yRateConverted/ySampleRate;

	(* Error check that the resolved frequencies are reasonable *)
	Which[
		xfreq>First@Dimensions[gridData]/2,
			Message[Warning::DownsamplingRateTooLarge,First[resolvedRates],RoundReals[Most@ranges[[1]],3]*xUnits,1],
		xfreq<1,
			Message[Warning::DownsamplingRateTooSmall,First[resolvedRates],RoundReals[Last@ranges[[1]],3]*xUnits,1]
	];
	Which[
		yfreq>Last@Dimensions[gridData]/2,
			Message[Warning::DownsamplingRateTooLarge,Last[resolvedRates],RoundReals[Most@ranges[[2]],3]*yUnits,1],
		yfreq<1,
			Message[Warning::DownsamplingRateTooSmall,Last[resolvedRates],RoundReals[Last@ranges[[2]],3]*yUnits,1]
	];

	(* Resolved frequencies to downsample at *)
	resolvedFreqs=MapIndexed[
		If[#1>Dimensions[gridData][[First@#2]]||#1<1,
			1,
			Round[#1]
		]&,
		{xfreq,yfreq}
	];

	(* Partition the data for downsampling in the X coordinate *)
	partitionedXIndices=Partition[Range@First[Dimensions[gridData]],UpTo[First[resolvedFreqs]]];

	(* Downsample in the x-direction first *)
	downsampledX=If[First[resolvedFreqs]==1,
		gridData,
		If[loadBars,
			Monitor[
				MapIndexed[
					(
						monitorIndex1=First[#2];
						SparseArray@(First[resolvedFunc]/@(Transpose@Part[gridData,#1]))
					)&,
					partitionedXIndices
				],
				Refresh[
					Row[{
						"Downsampling x-coordinate: ",
						ProgressIndicator[monitorIndex1/Length[partitionedXIndices]],
						" "<>ToString[monitorIndex1]<>"/"<>ToString[Length[partitionedXIndices]]
					}],
					TrackedSymbols:>{},
					UpdateInterval->5
				]
			],
			Map[
				(
					SparseArray@(First[resolvedFunc]/@(Transpose@Part[gridData,#]))
				)&,
				partitionedXIndices
			]
		]
	];

	(* Convert the result into a sparse array to save memory *)
	sparseDownsampledX=SparseArray[downsampledX];

	(* Partition the data for downsampling in the Y coordinate *)
	partitionedYIndices=Partition[Range@Last[Dimensions[sparseDownsampledX]],UpTo[Last[resolvedFreqs]]];

	(* Downsample in the y-direction next *)
	downsampledData=If[Last[resolvedFreqs]==1,
		sparseDownsampledX,
		If[loadBars,
			Monitor[
				MapIndexed[
					(
						monitorIndex2=First[#2];
						SparseArray@(Last[resolvedFunc]/@(Transpose@Part[Transpose@sparseDownsampledX,#1]))
					)&,
					partitionedYIndices
				],
				Refresh[
					Row[{
						"Downsampling y-coordinate: ",
						ProgressIndicator[monitorIndex2/Length[partitionedYIndices]],
						" "<>ToString[monitorIndex2]<>"/"<>ToString[Length[partitionedYIndices]]
					}],
					TrackedSymbols:>{},
					UpdateInterval->5
				]
			],
			Map[
				(
					SparseArray@(Last[resolvedFunc]/@(Transpose@Part[Transpose@sparseDownsampledX,#]))
				)&,
				partitionedYIndices
			]
		]
	];

	(* Convert the result into a sparse array and restore original dimensions *)
	sparseDownsampledData=If[Last[resolvedFreqs]==1,
		downsampledData,
		Transpose@SparseArray[downsampledData]
	];

	(* Return downsampled data and resolved options *)
	{sparseDownsampledData,resolvedOps}
];


(* Downsample 2D data according to specification in the options *)
downsampleData[gridData_, ranges_, units_, combinedOps:{(_Rule|_RuleDelayed)..}, 2]:=Module[
	{
		downsampleSpec,downsampleFunc,dataSampleRate,resolvedRate,resolvedFunc,
		resolvedOps,downsampleRateConverted,partitionFrequency,resolvedFreq,downsampledData
	},

	(* Extract downsampling specifications from options*)
	downsampleSpec=Lookup[combinedOps,DownsamplingRate];
	downsampleFunc=Lookup[combinedOps,DownsamplingFunction];

	(* Rate at which input data is sampled *)
	dataSampleRate=ranges[[1,-1]];

	(* If not specified, the resolve downsampling rate is the spacing in the x-dimension of the data *)
	resolvedRate=If[MatchQ[downsampleSpec,Automatic|None],
		dataSampleRate*First[units],
		First[downsampleSpec]
	];

	(* Resolve the function to apply during downsampling *)
	resolvedFunc=If[MatchQ[downsampleFunc,Automatic],
		Mean,
		First[downsampleFunc]
	];

	(* Resolved options *)
	resolvedOps={
		DownsamplingRate->{resolvedRate},
		DownsamplingFunction->{resolvedFunc}
	};

	(* Convert the input rate to the desired units, ignoring the units if they are incompatible *)
	downsampleRateConverted=Quiet[
		Check[
			Unitless[resolvedRate,First[units]],
			Message[Warning::IncompatibleUnits,resolvedRate,DownsamplingRate,units,{units}];
			Unitless[resolvedRate]
		],
		{Quantity::compat}
	];

	(* Figure out how many evenly spaced points to collapse for each downsample *)
	partitionFrequency=downsampleRateConverted/dataSampleRate;

	(* Error if the partition frequency exceeds the number of data points, or is smaller than minimum spacing *)
	If[partitionFrequency>Length[gridData]/2,
		Message[Warning::DownsamplingRateTooLarge,resolvedRate,RoundReals[Most@First[ranges],3]*First[units],1];
	];
	If[partitionFrequency<1,
		Message[Warning::DownsamplingRateTooSmall,resolvedRate,RoundReals[Last@First[ranges],3]*First[units],1];
	];

	(* Make sure the partition rate is reasonable *)
	resolvedFreq=If[(partitionFrequency>Length[gridData]/2)||(partitionFrequency<1),
		1,
		Round[partitionFrequency]
	];

	(* Downsample if the frequency exceeds 1 *)
	downsampledData=If[resolvedFreq==1,
		gridData,
		Map[
			resolvedFunc,
			Partition[gridData,UpTo[resolvedFreq]]
		]
	];

	(* Return downsampled data and resolved options *)
	{downsampledData,resolvedOps}
];



(* ::Subsection::Closed:: *)
(*thresholdData*)

(* Threshold the data according to options and then convert to a sparse array to save data *)
thresholdData[data_SparseArray,combinedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{intensitiesOnly,resolvedNoiseThreshold,thresholdedData,sparseData},

	(* Extract only the nonzero values from the internal representation of the sparse matrix *)
	intensitiesOnly=If[$VersionNumber>=13.0,
		data["ExplicitValues"],
		data/.{
			HoldPattern[SparseArray[x___]]:>Part[{x},-1,-1]
		}
	];

	(* Resolve the noise threshold option *)
	resolvedNoiseThreshold=Lookup[combinedOptions,NoiseThreshold]/.{
		(* Automatic will calculate a threshold algorithmically by 1D clustering Log intensities into two groups with minimal variance *)
		(Automatic|OtsuThreshold)->automaticThresholdNarrowPeaks[intensitiesOnly]
	};

	(* Threshold the data *)
	thresholdedData=Threshold[data,{"Hard",resolvedNoiseThreshold}];

	(* Throw it into a sparse array to save data *)
	sparseData=SparseArray[thresholdedData];

	(* Return the sparse data and resolved threshold *)
	{sparseData,{NoiseThreshold->resolvedNoiseThreshold}}
];

(* Empirical algorithm from KHou for thresholding data characterized by a noisy baseline with narrow, sharp peaks *)
automaticThresholdNarrowPeaks[intensities_]:=Module[
	{median,logIntensities,logThreshold},

	(* In data characterized by a few sharp peaks, the median is an estimate of the baseline noise *)
	median=Median[intensities];

	(* We want to threshold noise from peaks; however, peaks can vary in height greatly, so log-scale the data so large intensities are "closer" *)
	logIntensities=Log[N[intensities+median]];

	(* Use a 1D k-means with 2 clusters to split up noise from peaks *)
	logThreshold=FindThreshold[logIntensities,Method->"Cluster"];

	(* Transform back to original units *)
	Exp[logThreshold]-median
];

(* ::Subsection::Closed:: *)
(*Helper Functions*)

(* Utility for fast indexing of the sparse array, using binary search to exploit sortedness *)
fastSelect[{},___]:={};
fastSelect[data_,{min_,max_},idx_]:=With[
	{
		minpos=bsearchMax[data[[All,idx]],min],
		maxpos=bsearchMin[data[[All,idx]],max]
	},
	Take[data,{minpos,maxpos}]/;!MemberQ[{minpos,maxpos},-1]
];

(* Utility for quickly partitioning a list of tuples *)
fastSplitByPart[data_,idx_]:=Module[
	{splitIdxs,paddedSplitIdxs,splitSizes},

	(* Use compiled function to get split indices in O(N) time *)
	splitIdxs=fastSplitIndices[data[[All,idx]]];

	(* Pd the split indices *)
	paddedSplitIdxs=Join[{0},splitIdxs,{Length[data]}];

	(* Convert to a list of spans *)
	splitSizes=Map[
		Last[#]-First[#]&,
		Partition[paddedSplitIdxs,2,1]
	];

	(* Partition the data according to these lengths *)
	Internal`PartitionRagged[data,splitSizes]
];

(* Resample unevenly spaced xy data onto a constant grid defined by xmin, xmax, and dx using linear interpolation *)
(*** KH - Note; Interpolation currently has a memory leak, so use fastResample2D instead ***)
resample2D[xyData_,{xmin_,xmax_,dx_}]:=Module[
	{noDupes,intFunc,gridRange},

	(* Remove duplicate data points *)
	noDupes=DeleteDuplicatesBy[xyData,First];

	(* Interpolate, forcing extrapolated points to zero *)
	intFunc=Interpolation[
		noDupes,
		InterpolationOrder->1,
		"ExtrapolationHandler"->{0.0&,"WarningMessage"->False}
	];

	(* Explicit range *)
	gridRange=Range[xmin,xmax,dx];

	(* Interpolated values *)
	intFunc[gridRange]
];

(* True if the input list of numbers is evenly spaced, False otherwise. Tol sets a relative tolerance for numerical precision *)
evenlySpacedQ[nums_]:=evenlySpacedQ[nums,0.2];
evenlySpacedQ[nums_,tol_]:=Module[
	{diffs,threshold,diffSpacings},

	(* Differences between adjacent points *)
	diffs=Differences[Rest@nums];

	(* Threshold value to round to *)
	threshold=tol*Mean[diffs];

	(* List of different spacings after rounding to the threshold *)
	diffSpacings=DeleteDuplicates[Round[diffs,threshold]];

	(* This list has one element if evenly spaced *)
	Length[diffSpacings]==1
];



(* ::Subsection::Closed:: *)
(*Fast option resolution for command builder*)

(* Resolve options with symbolic values, instead of doing the full computation *)
resolveOptionsFast[type:TypeP[],field_,safeOps:{(_Rule|_RuleDelayed)..}]:=Module[
	{dim,resolvedRate,resolvedFunc,resolvedThreshold,resolvedReorder},

	(* Resolved dimension *)
	dim=LastOrDefault[Lookup[defaultDownsamplingFields,type],3];

	(* Populate options with defaults *)
	resolvedRate=Lookup[safeOps,DownsamplingRate]/.{Automatic->Repeat[None,dim-1]};
	resolvedFunc=Lookup[safeOps,DownsamplingFunction]/.{Automatic->Repeat[Mean,dim-1]};
	resolvedThreshold=Lookup[safeOps,NoiseThreshold]/.{Automatic->OtsuThreshold};
	resolvedReorder=Lookup[safeOps,ReorderDimensions];

	(* Return fast-resolved options *)
	ReplaceRule[safeOps,
		{
			DownsamplingRate->resolvedRate,
			DownsamplingFunction->resolvedFunc,
			NoiseThreshold->resolvedThreshold,
			ReorderDimensions->resolvedReorder
		}
	]
];



(* ::Subsection::Closed:: *)
(*Helper functions for Manifold error tracking*)

(* Helper function uploads the finished error log *)
uploadErrorLog[objref:downsampleObjectP, result_, tempStream_, errLog_String, uploadBoolean:True|False]:=Module[
	{myMessages,formattedMessages,updatedLog,logField,updatePacket},

	(* Set the Messages stream back to the default *)
	$Messages=DeleteCases[$Messages,tempStream];

	(* Read errors from the current stream, then close the stream *)
	myMessages=ReadString[tempStream[[1]]];
	Close[tempStream];

	(* Turn suppression of repeated messages back on *)
	On[General::stop];

	(* Convert messages to a string and format accordingly *)
	formattedMessages=StringReplace[ToString@myMessages,{"\r\n\r\n" -> "\n", "\r\n" -> ""}]/.{
		(* If there are no messages set to Null *)
		"EndOfFile"->""
	};

	(* Update the log with results and messages  *)
	updatedLog=StringJoin[errLog<>"\n",
		"End Time: "<>DateString[Now]<>"\n",
		"Result: "<>ToString[result]<>"\n",
		"Messages:\n"<>formattedMessages
	];

	(* The field in which to store logs *)
	logField=Lookup[typeToLogField,Most[objref],Null];

	(* Update the logs of the object downsampling is being run on *)
	updatePacket=If[MatchQ[logField,Except[Null]],
		<|
				Object->objref,
				Append[logField]->updatedLog
		|>,
		{}
	];

	(* Create an Asana task on failure *)
	If[MatchQ[result,$Failed],
		(* TEMPORARY: Assign Asana failures to K. Hou for debugging *)
		CreateAsanaTask[<|
			Name->("AnalyzeDownsampling[] Manifold Error ("<>ToString[objref]<>")"),
			Notes->updatedLog,
			Assignee->Object[User,Emerald,Developer,"id:qdkmxzq7M3xx"]
		|>]
	];

	(* Upload logs if Uploading is enabled *)
	If[uploadBoolean,
		Upload[updatePacket]
	];
];



(* ::Subsection::Closed:: *)
(*Compiled Utility Functions*)

(* Compiled binary for O(N) resampling of two sorted lists via linear interpolation *)
fastResample2D=Core`Private`SafeCompile[
	{
		{list, _Real, 2},
		{xmin, _Real},
		{xmax, _Real},
		{dx, _Real}
	},

	(* Block for loop variables *)
	Block[
		{
			(* Loop index for range *)
			j=1,jmax=Floor[(xmax-xmin)/dx]+1,
			(* Loop index for input list *)
			i=1,imax=Length[list],
			(* Preallocate the result array *)
			res=ConstantArray[0.0,Floor[(xmax-xmin)/dx]+1],
			rangeX,currX=list[[1,1]],currY=list[[1,2]],
			nextX=list[[2,1]],nextY=list[[2,2]]
		},

		(* Populate the result in a for loop*)
		While[j<=jmax,
			(* Name some variables for convenience *)
			rangeX=xmin+dx*(j-1);
			currX=list[[Min[i,imax],1]];
			currY=list[[Min[i,imax],2]];
			nextX=list[[Min[i+1,imax],1]];
			nextY=list[[Min[i+1,imax],2]];

			(* At each step: *)
			Which[
				(* Extrapolation in the positive x direction *)
				i>imax,
					res[[j]]=0.0;
					j=j+1,
				(* Extrapolation in negative x direction*)
				rangeX<currX,
					res[[j]]=0.0;
					j=j+1,
				(* Interpolate between two points *)
				rangeX>=currX&&rangeX<=nextX,
					res[[j]]=currY+(nextY-currY)*(rangeX-currX)/(nextX-currX);
					j=j+1,
				rangeX>nextX,
					i=i+1
			];
		];

		(* Return the result *)
		res
	]
];

(* Compiled binary for O(N) partitioning of a sorted list *)
fastSplitIndices=Core`Private`SafeCompile[
	{
		{list, _Real, 1}
	},

	Block[{i=1, imax=Length[list],inds={}},
		For[i=1,i<imax,i++,
			If[list[[i]]!=list[[i+1]],inds=Append[inds,i]]
		];
		Round[inds]
	]
];

(* Compiled binary search code taken from Leonid on StackExchange *)
bsearchMax=Core`Private`SafeCompile[
	{
		{list, _Real, 1},
		{elem, _Real}
	},

	(* Binary search *)
	Block[{n0=1, n1=Length[list], m=0},
		While[n0<=n1,
			m=Floor[(n0+n1)/2];
			If[list[[m]] == elem,
				While[m >= n0 && list[[m]] == elem, m--];
				Return[m+1]
			];
			If[list[[m]] < elem, n0 = m + 1, n1 = m - 1];
		];
		If[list[[m]]>elem, m, m+1]
	],
	RuntimeAttributes -> {Listable}
];

(* Compiled binary search code taken from Leonid on StackExchange *)
bsearchMin=Core`Private`SafeCompile[
	{
		{list, _Real, 1},
		{elem, _Real}
	},
	Block[{n0=1, n1=Length[list], m=0},
		While[n0<=n1,
			m=Floor[(n0+n1)/2];
			If[list[[m]]==elem,
				While[m<=n1&&list[[m]]==elem, m++];
				Return[m-1]
			];
			If[list[[m]]<elem, n0=m+1, n1=m-1]
		];
		If[list[[m]]<elem,m,m-1]
	],
	RuntimeAttributes -> {Listable}
];



(* ---------------------------------------------------------------------------*)
(*             Codes below are for downsampling HUGE files                    *)
(* ---------------------------------------------------------------------------*)

(* ---------------------------------------------------------------------------*)
(*         Multi-thread parallel streaming downsampling of huge data          *)
(* ---------------------------------------------------------------------------*)
DefineOptions[downsamplingParallel,
	SharedOptions:>{AnalyzeDownsampling}
];

Error::ComputationError="Manifold computation error occured.";

downsamplingParallel[obj:ObjectP[Object[Data,ChromatographyMassSpectra]],field:_Symbol,myOps:OptionsPattern[downsamplingParallel]]:=Module[
	{
		outputSpecification,output,gatherTests,listedOptions,safeOptions,
		dataRange,safeOptionsTests,templatedOptions,combinedOptions,
		standardFieldsStart,totalDataCount,objID,threads,chunkSize,ranges,
		downSampleOptions,lastDS,lastRanges,finalNoiseThreshold,
		cloudFileLink,downsamplePacket,resolvedDownsamplingOptions,finalDSObj,
		parallelComputations,computationStatus,resolvedDownsamplingRate,
		parallelDSAObjs,haveDSAs,allClear,currentComputation,currentComputationStatus,
		replacementComputation,numDataToGet,parallelJobs,n,currentRange,
		dividedRanges,currentJob,numSubmit,rateLimit,jobVsRange,replacementJob,
		fixedYGrid,initData,waitTime,elapsedTime
	},

	(* Options resolution ============================================================*)

	(* Determine the requested function return value*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

    (* Determine if a list of tests should be maintained*)
	gatherTests=MemberQ[output,Tests];

	(* Convert options into a list *)
	listedOptions=ToList[myOps];

	(* Get safeOptions *)
	safeOptions=SafeOptions[downsamplingParallel,listedOptions,AutoCorrect->False];

	(* Get current downsampling options *)
	resolvedDownsamplingRate=Lookup[safeOptions,DownsamplingRate];

	(* Get the number of threads from input *)
	threads=Lookup[safeOptions,Threads];

	(* Return $Failed if spec'ed options do not match required patterns *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> safeOptionsTests
		}]
	];

	(* Use template options to get values for options not specified in ops *)
	templatedOptions=ApplyTemplateOptions[AnalyzeDownsampling,{{obj},{field}},listedOptions];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

    (* Get downsampling options *)
	downSampleOptions=Select[combinedOptions,Not[MatchQ[#,Threads->_ ]]&&Not[MatchQ[#,Range->_ ]]&];

	(* Populate standard fields for constructing analysis object packets later *)
	standardFieldsStart=analysisPacketStandardFieldsStart[listedOptions];

	(* End of options resolution =====================================================*)

	(* Check if partial downsampling analysis objects already exist, taking *)
	(* into consideration that there may be pre-existing objects *)
	{haveDSAs, parallelDSAObjs}=DSAsExistQ[obj,threads];

	While[!haveDSAs,

		(* Need to spawn Manifold jobs to carry out parellel downsampling *)
		(* Get cloud file data count, since the dataDimensions in its header may be incorrect *)
		objID=obj[ID];
		totalDataCount=getCloudFileDataCount[objID,field];

		(* Set time interval between status checks *)
		waitTime=Which[
			totalDataCount<=2000000,60,
			totalDataCount<10000000,120,
			totalDataCount>10000000,600
		];

		(* To ensure all parallel downsampling jobs use the same m/z grid, need to get Y grid table first *)
		(* Get N(=numDataToGet) data points *)
		numDataToGet=Min[totalDataCount,5000000];
		initData=downloadDataSlices[obj,IonAbundance3D,1,numDataToGet];

		(* Find fixed Y grid *)
		fixedYGrid=getFixedYGrid[initData,3];

		(* Divide totaDataCount into threads to get equal chunk sizes *)
		chunkSize=Floor[totalDataCount/threads];

		(* Get ranges based on chunkSize with 5% overlap at both ends *)
		ranges=Floor[chunkSize*{(#-1)-0.05, #+0.05}]&/@Range[threads];

		(* Need to modify start point and include any left over data at the end *)
		ranges[[1]][[1]]=1;
		ranges[[-1]][[2]]=totalDataCount;

		Print["Parallel downsampling started on Manifold."];

		(* Spawn HighRAM manifold Compute jobs, pause to avoid hitting Manifold rate limit  *)
		(* Rate limit concurrent submission to 4 on Manifold *)
		rateLimit=5;

		(* Partition ranges *)
		dividedRanges=Partition[ranges,UpTo[rateLimit]];

		(* Number of submissions required *)
		numSubmit=Length[dividedRanges];

		(* Initialize job list *)
		parallelJobs={};
		jobVsRange=<||>;

		n=1;
		While[n<=threads,
			currentRange=ranges[[n]];
			currentJob=ECL`Compute[Analysis`Private`downsamplingByParts[obj,field,
					DownsamplingRate->#[[1]],
					Range->#[[2]],
					FixedYGrid->#[[3]],
					LoadingBars->False],
					HardwareConfiguration->HighRAM,
					MaximumRunTime->3 Day
					]&/@{{resolvedDownsamplingRate,currentRange,fixedYGrid}};

			(* Update job list *)
			AppendTo[parallelJobs,#]&/@currentJob;

			(*	Update job-range association *)
			AppendTo[jobVsRange,n->{currentRange,TimeObject[]}];

			(* This is conservative. Manifold requires 30 seconds wait for next token with a rate limit of 5 *)
			If[Mod[n,rateLimit-1]==0,Pause[30]];
			n++
		];

		Print["Manifold jobs started:\n",parallelJobs];

		(* Get parallel computations *)
		parallelComputations=getComputations[parallelJobs];
		Print["Computations started:\n",parallelComputations];

		(* Periodically check status until all jobs are completed, handle Manifold staging and runtime errors *)
		allClear=False;
		While[Not[allClear],

			n=1;
			While[n<=threads,
				(* Get parameters for current computation *)
				currentJob=parallelJobs[[n]];

				currentComputation=parallelComputations[[n]];

				currentComputationStatus=currentComputation[Status];

				elapsedTime=UnitConvert[TimeObject-Lookup[jobVsRange,n][[2]],"Days"];

				(* Handler for possible manifold staging and runtime error *)
				If[(MatchQ[currentComputationStatus,Error])||(elapsedTime>Quantity[2,"Days"]),

					Message[Error::ComputationError];

					(* Get range of errored job *)
					currentRange=Lookup[jobVsRange,n][[1]];

					(* Submit replacement job *)
					replacementJob=ECL`Compute[Analysis`Private`downsamplingByParts[obj,field,
						DownsamplingRate->#[[1]],
						Range->#[[2]],
						FixedYGrid->#[[3]],
						LoadingBars->False],
						HardwareConfiguration->HighRAM,
						MaximumRunTime->3 Day
						]&/@{{resolvedDownsamplingRate,currentRange,fixedYGrid}};

						Print["Replaced errored job  ", parallelJobs[[n]], "  with new job  ",replacementJob[[1]]];

					(* Update jobs list *)
					parallelJobs[[n]]=replacementJob[[1]];

					(* Get replacement computation *)
					replacementComputation=getComputations[parallelJobs[[n]]];

					(* Update parallelComputations *)
					parallelComputations[[n]]=replacementComputation;

					(* Reset time stamp for replaced job *)
					jobVsRange[[n]][[2]]=TimeObject[];
				];

				n++
			];

			(* Get status of all computations *)
			computationStatus=#[Status]&/@parallelComputations;

			(* Everything is ok when all threads are completed *)
			allClear=MatchQ[Sort[DeleteDuplicates[computationStatus]],{Completed}];

			If[!allClear,Pause[waitTime]]
		];

		Print["Final parallel jobs:\n",parallelJobs];
		Print["Finished parallel computations:\n",parallelComputations];

		(* Recheck to make sure partial downsampling analysis objects are created *)
		{haveDSAs,parallelDSAObjs}=DSAsExistQ[obj,threads]

	]; (* End of allClear loop *)

	(* Combine partial downsampling analysis objects *)
	If[haveDSAs,

		Print["Combining partial downsampling objects..."];

		(* Combine all parallel downsampled parts *)
		{lastDS,resolvedDownsamplingOptions,lastRanges,finalNoiseThreshold,cloudFileLink}=combineParallelParts[obj,parallelDSAObjs,threads];

		(* Create data packet for upload *)
		downsamplePacket=Association@@Join[
			standardFieldsStart,
			{
				Type->Object[Analysis,Downsampling],
				Replace[Reference]->Link[obj,DownsamplingAnalyses],
				ReferenceField->field,
				ResolvedOptions->resolvedDownsamplingOptions,
				Replace[OriginalDimension]->{1,2,3},
				Replace[DataUnits]->{Quantity[1, "Minutes"], Quantity[1, "Grams"/"Moles"], Quantity[1, IndependentUnit["ArbitraryUnits"]]},
				Replace[SamplingGridPoints]->Append[lastRanges,Null],
				NoiseThreshold->finalNoiseThreshold,
				DownsampledData->Null,
				DownsampledDataFile->cloudFileLink
			}
		];

		Print["Combination complete. Upload final downsampling object."];

		(* Remove partial downsampling objects *)
		EraseObject[parallelDSAObjs,Force->True,Verbose->False];

		finalDSObj=Upload[downsamplePacket]

	]
];


(*           Helper functions for down sampling huge file                      *)
(* ============================================================================*)

(*               Core function for handling large data                         *)
(* Given a data range, function generates a partial Downsampling Analysis object *)
DefineOptions[downsamplingByParts,
	Options:>{
		{
			OptionName->Range,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]],
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]]],
			Description->"Starting and stopping data points for the current parallel processing."
		},
		{
			OptionName->DataSize,
			Default->{},
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterP[1]],
			Description->"Number of data points for streaming processing."
		},
		{
			OptionName->FixedYGrid,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]],
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]]],
			Description->"Optional fixed sampling grid table for parallel downsampling."
		}
	},
	SharedOptions:>{AnalyzeDownsampling}
];

downsamplingByParts[obj:ObjectP[Object[Data,ChromatographyMassSpectra]],field:_Symbol,myOps:OptionsPattern[downsamplingByParts]]:=Module[
	{
		outputSpecification,gatherTests,listedOptions,output,url,objID,
		headersBytes,wordBytes,binaryRowFormat,dataUnits,dataDimensions,
		numDataToGet,dataIn,startPoint,stopPoint,resolvedDataIn,splitData,
		numTimeSlices,dataCount,standardFieldsStart,safeOptions,safeOptionsTests,
		dataMByteCount,showLoadingBars,dim,resampledInput,currentRanges,currentDS,
		resolvedDownsamplingOptions,combinedOptions,templatedOptions,dims,
		currentThreshDS,lastDS,	lastNoiseThreshold,currentNoiseThreshold,
		newNoiseThreshold,lastRanges,eofMarker,eofFlag,rlastDS,rcurrentDS,
		joinedDS,rawData,joinedRanges,ranges,totalDataCount,cloudFileLink,
		downsamplePacket,finalNoiseThreshold,flastDS,fcurrentDS,processDataCount,
		dataRange,joinedDSDims,finalJoinedRanges,startFlag,currentStartPoint,
		outObj,span,collectMessages,dataSize,dataRangeIn,gridTableY,dataToUpload
	},

	Share[];

	(* Options resolution ============================================================*)

	(* Determine the requested function return value*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

    (* Determine if a list of tests should be maintained*)
	gatherTests=MemberQ[output,Tests];

	(* Convert options into a list *)
	listedOptions=ToList[myOps];

	(* Get safeOptions *)
	safeOptions=SafeOptions[downsamplingByParts,listedOptions,AutoCorrect->False];

	(* Resolve process data range *)
	dataRangeIn=Lookup[safeOptions,Range];

	(* Resolve Y grid if provided *)
	gridTableY=Lookup[safeOptions,FixedYGrid];

	(* Resolve dataSize process data range *)
	dataSize=Lookup[safeOptions,DataSize];

	(* Return $Failed if spec'ed options do not match required patterns *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> safeOptionsTests
		}]
	];


	(* Use template options to get values for options not specified in ops *)
	templatedOptions=ApplyTemplateOptions[AnalyzeDownsampling,{{obj},{field}},listedOptions];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

	(* Populate standard fields for constructing analysis object packets later *)
	standardFieldsStart=analysisPacketStandardFieldsStart[listedOptions];

	(* Set UploadErrorLogs to True to print messages *)
	collectMessages=OptionValue[UploadErrorLogs];

	(* End of options resolution =====================================================*)

	(* Data streaming + downsampling =================================================*)

	(* Get data cloudfile url *)
	objID=obj[ID];
	url=getCloudFileURL[objID,field];

	(* Decode file headers *)
	{headersBytes,wordBytes,binaryRowFormat,dataUnits,dataDimensions}=decodeHeaders[url];

	(* Get cloud file data count, since the dataDimensions in its header is incorrect *)
	totalDataCount=getCloudFileDataCount[objID,field];

	(* Get dimensionality of data *)
	dim=dataDimensions[[2]];

	(* Populate dataRange if not provided. Defaults to all data *)
	dataRange=If[MatchQ[dataRangeIn,{}],
		{1,totalDataCount},
		dataRangeIn
	];

	(* Initialize streaming loop *)

	(* For parallel processing, take start point and total point from input data range *)
	span=dataRange[[2]]-dataRange[[1]];
	startPoint=If[dataRange[[1]]==1,0,dataRange[[1]]];

	processDataCount=dataRange[[2]];

	(* Set data count limit *)
	numDataToGet=If[Not[MatchQ[dataSize,{}]],
		Floor[dataSize],
		Which[
			span<=5000000,span,
			span>5000000,5000000
		]
	];

	(* no need to show loadingbar *)
	showLoadingBars=False;

	(* Initialize main loop *)
	startFlag=True;
	eofFlag=False;
	lastDS={};
	dataCount=0;
	currentStartPoint=startPoint;

	(* =================Main data streaming and downsampling loop ======================================*)
	 While[Not[eofFlag]&&currentStartPoint<processDataCount,

		(* Start from last stopPoint, except for the first chunk *)
		currentStartPoint=If[!startFlag,stopPoint,startPoint];

		(* Only need to get to the end of current input Range, also consider when stopPoint is close to end of data range *)
		stopPoint=If[processDataCount-(currentStartPoint+numDataToGet)>0.7*numDataToGet,
			currentStartPoint+numDataToGet,
			processDataCount
		];

		(* Set EOF flag value *)
		eofFlag=If[stopPoint==processDataCount,True,False];

		(* Download data *)
		dataIn=getPartialRawData[url,headersBytes,wordBytes,binaryRowFormat,currentStartPoint,stopPoint];

		(* Locate all EOFs *)
		eofMarker=FirstPosition[dataIn,{EndOfFile,EndOfFile,EndOfFile}][[1]];

		rawData=If[eofMarker==Length[dataIn],
			(* EOF of current data stream, drop the last row only *)
			Drop[dataIn,-1]
		];

		(* Split data by time dimensions *)
		splitData=fastSplitByPart[rawData,1];

		(* Get the number of time slices *)
		numTimeSlices=Dimensions[splitData][[1]];

		(* Drop the last row since it is not a complete time slice, except for the last chunk *)
		resolvedDataIn=If[(startPoint==0||(startPoint!=0&&!eofFlag))&&(stopPoint!=processDataCount),
			splitData[[1;;numTimeSlices-1]],
			splitData[[1;;numTimeSlices]]
		];

		(* Get number of xyz data points, needed when importing data for the next stream *)
		dims=Dimensions[#]&/@resolvedDataIn;
		dataCount=Total[#[[1]]&/@dims];

		(* Update actual stop point *)
		stopPoint=currentStartPoint+dataCount;

		If[collectMessages,
			Print["Processing data from "<>ToString[currentStartPoint]<>" to "<>ToString[stopPoint]<>" ......"];
		];

		(* Get data byte count in MB *)
		dataMByteCount=ByteCount[resolvedDataIn]/1024.^2;

		(* Warn the user if the computation will be long *)
		If[dataMByteCount>250.0,
			Message[Warning::LongComputation,
				(Round[(dataMByteCount/100.0),0.1] Minute),
				DateString[Now+((dataMByteCount/100.0) Minute)]]
		];

		(* No need to show this when running on manifold *)
		showLoadingBars=False;

		(* Ensure data is evenly sampled on a grid, resampling if needed *)
		{resampledInput,ranges}=If[startFlag&&MatchQ[gridTableY,{}],

			(* Start *)
			resampleToGrid[resolvedDataIn,showLoadingBars,dim],

			(* Use the overload to resample based on existing grid *)
			resampleToGrid[resolvedDataIn,showLoadingBars,dim,gridTableY]
		];

		(* Get grid table for m/z if not provided as option input *)
		If[startFlag&&MatchQ[gridTableY,{}],gridTableY=ranges[[2]]];

		(* Downsample using resolvedDownsamplingOptions and CombinedOptions *)
		{currentDS,resolvedDownsamplingOptions}=downsampleData[resampledInput,ranges,dataUnits,combinedOptions,dim];

		(* Pass downsampled data through an automatic noise threshold filter *)
		{currentThreshDS, currentNoiseThreshold}=thresholdData[currentDS,combinedOptions];

		(* Get ranges for the dowmsampled data *)
		currentRanges=getRanges[Dimensions[currentThreshDS],ranges];

		(* Reset flag *)
		startFlag=False;

		(* Update lastDS *)
		{lastDS,lastNoiseThreshold,lastRanges}=If[lastDS=={},

			(* ===== 1st chunk, place current downsample data into the last bucket ====== *)
			{lastDS,lastNoiseThreshold,lastRanges}={currentThreshDS,currentNoiseThreshold,currentRanges},

			(* ====== Subsequent chunks. Join currentThreshDS with lastDS ================ *)
			(* Compare NoiseThreshold to see if lastDS needs to be re-filtered *)
			newNoiseThreshold={NoiseThreshold->Min[Values[currentNoiseThreshold],Values[lastNoiseThreshold]]};

			(* Re-threshold both matrices using the new noise threshold *)
			{rlastDS,rcurrentDS}=If[Values[currentNoiseThreshold][[1]]==Values[newNoiseThreshold][[1]],
				(* Re-threshold lastDS *)
				{Threshold[lastDS,{"Hard",Values[newNoiseThreshold][[1]]}],currentDS},

				(* Else re-threshold currentDS *)
				{lastDS, Threshold[currentDS,{"Hard",Values[newNoiseThreshold][[1]]}]}
			];

			(* Check dimensions of current and last DS arrays before joining, trim if necessary *)
			{flastDS,fcurrentDS}=If[!MatchQ[Dimensions[rlastDS][[2]],Dimensions[rcurrentDS][[2]]],
				justTrim[rlastDS,rcurrentDS],
				{rlastDS,rcurrentDS}
			];

			(* Join the current sparse array with last one *)
			joinedDS=Join[flastDS,fcurrentDS];

			(* Update ranges, i.e. SamplingGridPoints *)
			joinedRanges={
				{lastRanges[[1, 1]], currentRanges[[1, 2]], lastRanges[[1, 3]]},
				{lastRanges[[2, 1]], currentRanges[[2, 2]], currentRanges[[2, 3]]}
			};

			joinedDSDims=Dimensions[joinedDS];

			(* Final check of ranges and rescale if necessary *)
			finalJoinedRanges=If[!MatchQ[joinedDSDims, rangesToDims@joinedRanges],
				getRanges[joinedDSDims,joinedRanges],
				joinedRanges];

			(* Update lastDS parameters *)
			{joinedDS,newNoiseThreshold,finalJoinedRanges}
		];

		ClearSystemCache[];

	]; (* End of Main streaming loop *)

	finalNoiseThreshold=Values[lastNoiseThreshold][[1]];

	(* Upload downsampled data cloud file in "MX" format *)
	cloudFileLink=If[Lookup[combinedOptions,Upload]@@MatchQ[lastDS,_SparseArray],uploadDataCloudFile[lastDS,objID]];

	(* Don't upload DownsampledData as it may cause Telescope error with large data *)
	dataToUpload=Null;

	(* Create a datapacket for upload *)
	downsamplePacket=Association@@Join[
		standardFieldsStart,
		{
		Type->Object[Analysis,Downsampling],
		Replace[Reference]->Link[obj,DownsamplingAnalyses],
		ReferenceField->field,ResolvedOptions->resolvedDownsamplingOptions,
		Replace[OriginalDimension]->{1,2,3},
		Replace[DataUnits]->{Quantity[1, "Minutes"], Quantity[1, "Grams"/"Moles"], Quantity[1, IndependentUnit["ArbitraryUnits"]]},
		Replace[SamplingGridPoints]->Append[lastRanges,Null],
		NoiseThreshold->finalNoiseThreshold,
		DownsampledData->dataToUpload,
		DownsampledDataFile->cloudFileLink
		}
	];

	(* Upload downsamplePacket and output generated Downsampling object *)
	outObj=If[Lookup[combinedOptions,Upload],
		Upload[downsamplePacket],
		Association@@Join[
			standardFieldsStart,
			{
			Type->Object[Analysis,Downsampling],
			Replace[Reference]->Link[obj,DownsamplingAnalyses],
			ReferenceField->field,ResolvedOptions->resolvedDownsamplingOptions,
			Replace[OriginalDimension]->{1,2,3},
			Replace[DataUnits]->{Quantity[1, "Minutes"], Quantity[1, "Grams"/"Moles"], Quantity[1, IndependentUnit["ArbitraryUnits"]]},
			Replace[SamplingGridPoints]->Append[lastRanges,Null],
			NoiseThreshold->finalNoiseThreshold,
			DownsampledData->dataToUpload,
			DownsampledDataFile->cloudFileLink
			}
		]
	]
];


(* Function to resample data using a fixed grid *)
resampleToFixedGrid[inData_,inRanges_,fixedYGrid_]:=Module[
	{xGrid,yGrid,func,newGrid,n,fixedY,resampledData},

	(* Get X-grid points from ranges of inData *)
	xGrid=Range[inRanges[[1]]/.List->Sequence];

	(* Get length of xGrid *)
	n=Length[xGrid];

	(* Use fixeYGrid *)
	yGrid=Range[inRanges[[2]]/.List->Sequence];

	(* Combine X, Y and Z to form a new 3D grid *)
	newGrid=MapThread[Append[#1,#2]&,{Tuples[{xGrid,yGrid}],Flatten[inData]}];

	(* Build an interpolation function for inData *)
	func=Interpolation[newGrid,InterpolationOrder->1,"ExtrapolationHandler" -> {Indeterminate &, "WarningMessage" -> False}];

	(* Resample over the fixed Y grid *)
	fixedY=Range[fixedYGrid/.List->Sequence];

	(* Map over time slices to get resampled data *)
	resampledData=SparseArray[func[xGrid[[#]],fixedY]&/@Range[n]];

	(* Output result*)
	resampledData
];


(* Function merge partial DownsamplingAnalyses objects created by downsamplingParallel into final Downsampling oject *)
combineParallelParts[obj_,dsaObjs_List,threads_Integer]:=Module[
	{resolvedDownsamplingOptions,gridPts,noiseThresh,dsTimeDim,dsData,rowsToSkip,skippedData,
	originalRanges,lastDS,lastRanges,k,currentDS,currentRanges,lastPadDS,currentPadDS,joinedDS,joinedRanges,
	joinedDSDims,finalJoinedRanges,finalNoiseThreshold,finalJoinedDS,finalSamplingGridPoints,cloudFileLink,objID,orderedDS,
	downsamplePacket,dsDataFileLinks},

	objID=obj[ID];

	(* Get SamplingGridPoints from DSA Objects *)
	gridPts=dsaObjs[SamplingGridPoints];

	(* DSA objects need to be sorted according to their time spans *)
	orderedDS=#[[2]]&/@SortBy[Transpose[{#[[1]][[1]]&/@gridPts,dsaObjs}],First];

	(* Get ordered samplingGridPoints*)
	gridPts=orderedDS[SamplingGridPoints];

	(* Get resolvedOptions from the 1st object *)
	resolvedDownsamplingOptions=orderedDS[[1]][ResolvedOptions];

	(* Get NoiseThreshold for each DSA Obj*)
	noiseThresh=orderedDS[NoiseThreshold];

	(* Get downsampledDataFile link for each partial DSA object *)
	dsDataFileLinks=orderedDS[DownsampledDataFile];

	(* Import partial DownsampledData *)
	dsData=ImportCloudFile[#]&/@dsDataFileLinks;

	(* Get time dimension of each DSA Obj *)
	dsTimeDim=Dimensions[#][[1]]&/@dsData;

	(* Determin the number of rows to skip from each dsData, except the last chunk *)
	rowsToSkip=Floor[(gridPts[[#-1,1,2]]-gridPts[[#,1,1]])/gridPts[[#,1,3]]]&/@Range[2,threads];

	(* Trim dsData by skipping the last few rows according to rowsToSkip *)
	skippedData=Append[dsData[[#]][[1;;dsTimeDim[[#]]-(rowsToSkip[[#]]+1),All]]&/@Range[threads-1],dsData[[-1]]];

	(* Get the original data ranges based on their SamplingGridPoints *)
	originalRanges={gridPts[[#]][[1]],gridPts[[#]][[2]]}&/@Range[threads];

	(* Initialize loop over the number of partial downsampling analysis objects *)
	lastDS=skippedData[[1]];
	lastRanges=originalRanges[[1]];
	k=2;

	While[k<=threads,

		(* Assign current slice of downsampled *)
		currentDS=skippedData[[k]];
		currentRanges=originalRanges[[k]];

		(* Pad matrices to ensure their dimensions match*)
		{lastPadDS,currentPadDS}=padMatrices[lastDS,lastRanges,currentDS,currentRanges];

		(* Add current to last DS *)
		joinedDS=Join[lastPadDS,currentPadDS];

		(* Get ranges and dimensions of the newly formed joint *)
		joinedRanges={{Min[{#[[1]][[1]]}&/@{lastRanges,currentRanges}],Max[{#[[1]][[2]]}&/@{lastRanges,currentRanges}], lastRanges[[1]][[3]]},
				{Min[{#[[2]][[1]]}&/@{lastRanges,currentRanges}],Max[{#[[2]][[2]]}&/@{lastRanges,currentRanges}], currentRanges[[2]][[3]]}};

		joinedDSDims=Dimensions[joinedDS];

		(* Final check on ranges and rescale if necessary *)
		finalJoinedRanges=If[!MatchQ[joinedDSDims, Analysis`Private`rangesToDims@joinedRanges],getRanges[joinedDSDims,joinedRanges],joinedRanges];

		(* Update results *)
		{lastDS,lastRanges}={joinedDS,finalJoinedRanges};
		k++;
	];

	(* Re-threshold filter of downsampled data using max NoiseThreshold *)
	finalNoiseThreshold=Max[noiseThresh];
	finalJoinedDS=Threshold[lastDS,finalNoiseThreshold];

	(* Generate SamplingGridPoints *)
	finalSamplingGridPoints=Append[lastRanges,Null];

	(* Upload cloud file*)
	cloudFileLink=If[True@@MatchQ[lastDS,_SparseArray],Analysis`Private`uploadDataCloudFile[finalJoinedDS,objID]];

	ClearSystemCache[];

	(* Output result *)
	{lastDS,resolvedDownsamplingOptions,lastRanges,finalNoiseThreshold,cloudFileLink}
];


(* Get url of cloudfile *)
getCloudFileURL[objID_String,dataField_Symbol]:=Module[{bucket,path,blob,response,fieldName,hash,url},
	fieldName=ToString[dataField];

	(* Get bucket, hash and path of couldfile *)
(*	response=ConstellationRequest[
		Association[
			"Path"->"obj/download",
			"Body"->ExportJSON[Association["Requests"->{Association["id"->objID,"fields"->{fieldName}]}]],
			"Method"->"POST"]
	];

	blob=response["responses"][[1]]["fields"][fieldName];

	{path,bucket,hash}=Lookup[blob,{"path", "bucket", "hash"}];

	key=path<>hash;
*)

(* Get file info from S3 *)
response=Constellation`Private`requestBigQABlob[Object[objID], dataField];

(* Get file bucket and key *)
{bucket,key}=Constellation`Private`getS3BucketAndKey[response, dataField];

	(* Get url, specify expiration suficciently long to cover downsampling run time *)
	ConstellationRequest[Association
		["Path"->"blobsign/download",
		"Body"->ExportJSON[Association["bucket"->bucket,"key"->key,"expires"->300000]],
		"Method"->"POST"]
	]["Url"]

];


(* Function used to get desired number of bytes from cloudfile *)
fetchNBytes[url_,bytes_,start_]:=URLRead[HTTPRequest[url,Association["Headers"->Association["Range"->"bytes="<>ToString[start]<>"-"~~ToString[bytes-1]]]],"Body"];


(* Get and decode cloudfile headers *)
decodeHeaders[myurl_]:=Module[{data,headers,headersBytes,units,binaryRowFormat,dataDimensions,wordBytes},

	(* Fetch sufficently long data from start of file *)
	data=fetchNBytes[myurl,500,0];

	(* Need to locate end of JSON headers first in some cases *)
	headersBytes=StringPosition[data,"}"][[1]][[1]];

	(* Only fecth headers *)
	data=fetchNBytes[myurl,headersBytes,0];
	headers=ImportString[data,"RawJSON"];
	headersBytes=StringPosition[data,"}"][[1]][[1]];
	units=ImportString[ByteArrayToString[BaseDecode[headers["mathematicaUnits"]]],"ExpressionJSON"];
	binaryRowFormat=headers["binaryRowFormat"];
	wordBytes=Total[Switch[#,"Real64",8,"Real32",4,"Integer32",4]&/@binaryRowFormat];
	dataDimensions=headers["dimensions"];
	{headersBytes,wordBytes,binaryRowFormat,units,dataDimensions}
];



(* Get the total number of data in a cloudfile, for large data files with incorrect data dimensions info in its header *)
getCloudFileDataCount[objID_String,dataField_Symbol]:=Module[{bucket,key,url,headersBytes,wordBytes,binaryRowFormat,units,dataDimensions,contentSize},

	(* Get file info from S3 *)
	response=Constellation`Private`requestBigQABlob[Object[objID], dataField];

	(* Get file bucket and key *)
	{bucket,key}=Constellation`Private`getS3BucketAndKey[response, dataField];

	(* Get file content size *)
	contentSize=ToExpression[GoCall["HeadCloudFile",Association["Key"->key,"Bucket"->bucket,"Retries"->5]]["ContentSize"]];

	(* need file url to decode header *)
	url=getCloudFileURL[objID,dataField];

	(* decode header info *)
	{headersBytes,wordBytes,binaryRowFormat,units,dataDimensions}=decodeHeaders[url];

	(* get data count *)
	Floor[(contentSize-headersBytes)/wordBytes]
];


(* Get cloud file size in Bytes *)
getCloudFileSize[obj_,dataField_Symbol]:=Module[
	{bucket,key,response, fieldDefs, requestedFieldDef},

	(* type check the field from the object type definitions *)
	fieldDefs = Lookup[LookupTypeDefinition[obj[Type]], ECL`Fields];

	(* if requested field is not found in type def, return error *)
	requestedFieldDef = Lookup[fieldDefs, dataField, $Failed];
	If[MatchQ[requestedFieldDef, $Failed],
		Message[Error::FieldNotFound,field,Download[obj,Object]];
		Return[$Failed]
	];

	(* if requested field is not a BigQuantityArray or BigCompressed, return 0 for file size *)
	(* TODO: a little inelegant, may miss some fields that are supposed to be cloud files *)
	If[Not[MatchQ[Lookup[requestedFieldDef, Class], (BigQuantityArray | BigCompressed)]],
		Return[0];
	];

	(* Get file info from S3 *)
	response=Constellation`Private`requestBigQABlob[obj, dataField];

	(* If field is empty return failed *)
	If[MatchQ[Lookup[Lookup[response, "responses"], "fields"], {<||>}],
		Return[$Failed]
	];

	(* Get file bucket and key *)
	{bucket,key}=Constellation`Private`getS3BucketAndKey[response, dataField];

	Constellation`Private`findS3FileSize[key, bucket]
];


(* Given file url, get and decode a chunk of binary data at arbitrary positions using Stream BinaryRead *)
getPartialRawData[myurl_,headersBytes_,wordBytes_,binaryRowFormat_,start_,stop_]:=Module[
	{binaryChunk,stream,dataOut,typeList},

	(* Get a chunk of binary data from start;;stop *)
	binaryChunk=fetchNBytes[myurl,headersBytes+1+stop*wordBytes,headersBytes+1+start*wordBytes];

	(* Create a binary string stream *)
	stream=StringToStream[binaryChunk];

	typeList=Table[binaryRowFormat,{i,start,stop}];

	(* Get all data at once *)
	dataOut=BinaryRead[stream,typeList];

	Close[stream];
	dataOut
];

(* Given object, get and decode a chunk of binary data at arbitrary positions using Stream BinaryRead *)
getPartialRawDataFromID[obj_,field_,start_,stop_]:=Module[
	{objID,url,headersBytes,wordBytes,binaryRowFormat,dataUnits,dataDimensions,binaryChunk,stream,dataOut,typeList,
	totalDataCount
	},

	objID=obj[ID];

	url=getCloudFileURL[objID,field];

	(* Decode file headers *)
	{headersBytes,wordBytes,binaryRowFormat,dataUnits,dataDimensions}=Analysis`Private`decodeHeaders[url];

	totalDataCount=Analysis`Private`getCloudFileDataCount[objID,field];

	If[stop>totalDataCount,
		Return["Stop point geater than total number of points",$Failed]
	];

	(* Get a chunk of binary data from start;;stop *)
	binaryChunk=Analysis`Private`fetchNBytes[url,headersBytes+1+stop*wordBytes,headersBytes+1+start*wordBytes];

	(* Create a binary string stream *)
	stream=StringToStream[binaryChunk];

	typeList=Table[binaryRowFormat,{i,start,stop}];

	(* Get all data at once *)
	dataOut=BinaryRead[stream,typeList];

	Close[stream];
	dataOut
];

(* Helper to pad left or right of a matrix with given number of columns *)
padColumns[myArray_,side_:Left|Right,n_:Integer]:=Module[{height,width},

	{height,width}=Dimensions[myArray];
	Switch[side,
		Left,PadLeft[myArray,{height,width+n}],
		Right,PadRight[myArray,{height,width+n}]
	]
];


(* Helper used to rescale data ranges *)
getRanges[inDataDims_,inRanges_]:=Module[{},
	MapThread[
	{
		#1[[1]],
		#1[[2]],
		#1[[3]]*Length[Range@@#1]/#2
	}&,
	{inRanges,inDataDims}
	]
];


(* Create cloudfile and return its link *)
uploadDataCloudFile[inData_SparseArray,objID_String]:=Module[{filePath,file,cloudFile},
	(* Create file path *)
	filePath=FileNameJoin[{$TemporaryDirectory,StringJoin["downsampleID",StringTake[objID,4;;],StringDelete[DateString["ISODateTime"],":"]<>".mx"]}];

	(* Export downsampled data as MX file*)
	file=Export[filePath,inData,"MX"];

	(* Upload file to cloud *)
	cloudFile=UploadCloudFile[file];
	DeleteFile[filePath];

	(* Return link to the cloudfile *)
	Link[cloudFile]
];

(* Helper to pad two matrices so their 2nd dimensions are matched *)
padMatrices[ds1_,ranges1_,ds2_,ranges2_]:=Module[
	{padds1,padds2,numberColsToPad,width1,width2, finalds1,finalds2,ds1Dims,ds2Dims},

	ds1Dims=Dimensions[ds1];
	ds2Dims=Dimensions[ds2];

	(* Calcuate the number of columns for left padding to match beginning values *)
	numberColsToPad=Floor[(getRanges[ds1Dims,ranges1][[2]][[1]]-getRanges[ds2Dims,ranges2][[2]][[1]])/getRanges[ds2Dims,ranges2][[2]][[3]]];

	(* Left pad the matrices *)
	{padds1,padds2}=If[numberColsToPad>0,
		{padColumns[ds1,Left,numberColsToPad],ds2},
		{ds1,padColumns[ds2,Left,-numberColsToPad]}
	];

	(* Get dimensions of padded matrices *)
	{width1,width2}={Dimensions[padds1][[2]],Dimensions[padds2][[2]]};

	(* Further padding on the right to match m/z dimesions so they can be joined *)
	finalds1=If[width2>width1,padColumns[padds1,Right,(width2-width1)],padds1];
	finalds2=If[width1>width2,padColumns[padds2,Right,(width1-width2)],padds2];

	(* Output padded matrices with matched 2nd dimensions *)
	{finalds1,finalds2}
];


(* Trim two matrices to match widths *)
justTrim[ds1_,ds2_]:=Module[{width1,width2,trimDS1,trimDS2},
	(* Get dimensions of both matrices *)
	{width1,width2}={Dimensions[ds1][[2]],Dimensions[ds2][[2]]};

	trimDS1=If[width1>width2,Drop[ds1,{},{width2+1,width1}],ds1];
	trimDS2=If[width2>width1,Drop[ds2,{},{width1+1,width2}],ds2];

	{trimDS1,trimDS2}
];


(* Convert data ranges to matrix dimensions *)
rangesToDims[inRanges_]:=Length[Range[#/.List->Sequence]]&/@inRanges;

(* Get time sliced data in a given range *)
downloadDataSlices[obj_,field_,startPoint_,stopPoint_]:=Module[
	{dataIn,eofMarker,rawData,splitData,numTimeSlices,resolvedData,totalDataCount},

	totalDataCount=getCloudFileDataCount[obj[ID],field];
	If[stopPoint>totalDataCount,
		Print["Invalid stop point: greater than the total number of points."];
		Return[$Failed]
	];

	dataIn=getPartialRawDataFromID[obj,field,startPoint,stopPoint];
	eofMarker=FirstPosition[dataIn,{EndOfFile,EndOfFile,EndOfFile}][[1]];

	(* EOF data stream,  drop the last row only *)
	rawData=If[eofMarker==Length[dataIn],Drop[dataIn,-1]];

	(* Split data by time dimensions *)
	splitData=fastSplitByPart[rawData,1];

	(* Get the number of time slices *)
	numTimeSlices=Dimensions[splitData][[1]];

	(* Drop the last row as it is not a complete slice *)
	resolvedData=splitData[[1;;numTimeSlices-1]];

	resolvedData
];

(* Get inital fixed Y grid table used in downsamplingByParts and downsamplingParallel *)
getFixedYGrid[inData_,dim_]:=Module[{resampledInput,ranges,gridTableY},
	(* Use resampleToGrid to get ranges *)
	{resampledInput,ranges}=resampleToGrid[inData,False,dim];

	(* Get Y grid as fixed grid for subsequent resampleToGrid *)
	gridTableY=ranges[[2]];
	gridTableY
];

(* Helper to check if partial DownsamplingAnalyses exist *)
DSAsExistQ[obj_,threads_]:=Module[{tmpObjs,tmpObjsAsso, parallelDSAs,haveDSAs},

	tmpObjs=#[[1]]&/@obj[DownsamplingAnalyses];

	(* Tie objects with UnresolvedOptions *)
	tmpObjsAsso=Association@@Join[#->#[UnresolvedOptions]&/@tmpObjs];

	(* Only take objects with Range in UnresolvedOptions *)
	parallelDSAs=Keys[Select[tmpObjsAsso,MatchQ[Lookup[#,Range],{_Integer, _Integer}]&]];

	haveDSAs=If[Length[parallelDSAs]==threads,True,False];

	{haveDSAs,parallelDSAs}
];

(* Get computations from a Manifold job *)
getComputations[job_]:=Module[{computations},
	computations={};
	While[MatchQ[computations,{}],
		Pause[20];
		computations=If[MatchQ[job[Computations],{}],{},job[Computations][[1,1]]]
	];
	computations
];

(* Get computations from a list of Manifold jobs *)
getComputations[jobs_List]:=getComputations[#]&/@jobs
