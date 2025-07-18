(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* AnalyzeBubbleRadius *)


(* ::Subsection:: *)
(* Patterns *)

(* Input patterns *)
analyzeBubbleRadiusInputP=Alternatives[
	ObjectP[Object[Protocol,DynamicFoamAnalysis]],
	ListableP[EmeraldCloudFileP],
	ListableP[ObjectP[Object[Data,DynamicFoamAnalysis]]]
];

(* Explicit color definitions *)
grayBubbleCenterColor=RGBColor[0.4226138704509041`,0.4227054245822843`,0.4225986114290074`];
grayBubbleEdgeColor=RGBColor[0.16617074845502403`,0.16620126649881742`,0.16617074845502403`];
greenBubbleCenterColor=RGBColor[0.6724956130312048`,0.9222552834363318`,0.46379797055008776`];
quantizedGreen=RGBColor[0.21992828259708552`,1.`,0.03430228122377356`];
quantizedYellow=RGBColor[0.9193560692759594`,0.9268940260929275`,0.5758907454032196`];
quantizedGray=RGBColor[0.4146486610208286`,0.4147249561303121`,0.4146334019989319`];

(* Custom color function for coloring differently sized bubbles *)
bubbleGradientColorFunction[x_]:=Module[{smallColor,bigColor},
	(* Gradient between two colors *)
	smallColor={0.9980315861753262`,0.9255115587090867`,0.040619516289005876`};{1.00,1.00,0.00};
	bigColor={0.207,0.591,0.951};
	(* Gradient smoothly blends the two colors *)
	Which[
		x<0.0,grayBubbleCenterColor,
		x<=1.0,RGBColor[x*bigColor+(1.0-x)*smallColor],
		x>1.0,grayBubbleCenterColor
	]
];



(* ::Subsection:: *)
(* Options *)


DefineOptions[AnalyzeBubbleRadius,
	Options:>{
		IndexMatching[
			{
				OptionName->MinimumBubbleRadius,
				Default->None,
				Description->"Bubbles with radii smaller than this threshold will be excluded from the analysis.",
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[None]],
					Widget[Type->Quantity,Pattern:>GreaterEqualP[0.0 Micrometer],Units->Alternatives[Micrometer]]
				],
				Category->"General"
			},
			{
				OptionName->MaximumBubbleRadius,
				Default->None,
				Description->"Bubbles with radii larger than this threshold will be excluded from the analysis.",
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[None]],
					Widget[Type->Quantity,Pattern:>GreaterEqualP[0.0 Micrometer],Units->Alternatives[Micrometer]]
				],
				Category->"General"
			},
			{
				OptionName->HistogramType,
				Default->Radius,
				Description->"Indicate whether the histogram of bubble sizes in the processed output video should show bubble radii or areas.",
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Radius,Area]],
				Category->"General"
			},
			{
				OptionName->HistogramResizeFrequency,
				Default->5,
				Description->"Indicate how frequently, in number of frames, the histogram in the processed output video should have its y-axis rescaled to accomodate changes in the bubble size distribution.",
				AllowNull->False,
				Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
				Category->"General"
			},
			IndexMatchingInput->"Foaming Data"
		],
		{
			OptionName->ProgressBars,
			Default->True,
			Description->"Indicates whether loading bars should be rendered during long downsampling calculations. Note that enabling loading bars may cause calculations to take longer.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]]
		},
		{
			OptionName->ReduceMemoryUsage,
			Default->False,
			Description->"Set to True to reduce the total memory usage of the analysis, at the expense of longer computation time.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
			Category->"Hidden"
		},
		{
			OptionName->UploadErrorLogs,
			Default->True,
			Description->"True indicates that error/debugging messages encountered during evaluation should be collected and uploaded to Constellation.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
			Category->"Hidden"
		},
    AnalysisTemplateOption,
    UploadOption,
    OutputOption
  }
];



(* ::Subsection::Closed:: *)
(*Messages and Errors*)

(* ---------------------------- *)
(* --- MESSAGES AND ERRORS  --- *)
(* ---------------------------- *)
Error::InvalidFoamingVideoFormat="Linked EmeraldCloudFile in field ConvertedVideoFile of input `1` did not import as a list of images, and analysis cannot proceed. Please verify that this is either a ZIP file or multi-page TIFF file containing the frames of a foam-structure analysis video.";
Error::NoFoamStructureAnalysis="Input object `1` has empty field RawVideoFile. Analysis cannot proceed without video data. Please verify that foam-structure analysis is associated with this data object by checking that its DetectionMethod field includes ImagingMethod.";
Error::VideoNotConverted="Input object `1` has a RawVideoFile but no ConvertedVideoFile. Please convert the raw video file to a ZIP file with JPG images of each frame, or a multi-frame TIFF, and upload the converted file to ConvertedVideoFile. Analysis cannot proceed until the conversion is done.";
Warning::NoBubblesFound="No bubbles could be identified in the video data associated with input `1`. Please ensure the video is in the correct format, and that the MaximumBubbleRadius and MinimumBubbleRadius options are set to reasonable values.";
Warning::LongComputation="This computation is estimated to take `1` to complete, with an estimated completion time of `2`.";


(* ::Subsection::Closed:: *)
(*Overloads*)

(* --------------------------- *)
(* --- SECONDARY OVERLOADS --- *)
(* --------------------------- *)

(* Protocol overload - download all data objects and pass to primary overload *)
AnalyzeBubbleRadius[protocol:ObjectP[Object[Protocol,DynamicFoamAnalysis]],myOps:OptionsPattern[AnalyzeBubbleRadius]]:=Module[
	{dataPackets},

	(* Download all required information through protocols as data object packets *)
	dataPackets=Download[protocol,
		Packet[Data[{
			DetectionMethod,
			SampleVolume,
			AgitationTime,
			DecayTime,
			Wavelength,
			FieldOfView,
			CameraHeight,
			ConvertedVideoFile,
			RawVideoFile,
			MeanBubbleArea
		}]]
	];

	(* Pass on the packets to the primary overload *)
	AnalyzeBubbleRadius[dataPackets,myOps]
];


(* Cloudfile overload - wrap the cloud file in a fake packet and pass on to the primary overload *)
AnalyzeBubbleRadius[cloudFile:ListableP[EmeraldCloudFileP],myOps:OptionsPattern[AnalyzeBubbleRadius]]:=Module[
	{listedInputs,fakePackets},

	(* Convert the inputs to a list if they are not already *)
	listedInputs=ToList[cloudFile];

	(* Construct dummy packets containing the appropriate files *)
	fakePackets=Map[
		<|
			Type->Object[Data,DynamicFoamAnalysis],
			ConvertedVideoFile->Link[cloudFile],
			RawVideoFile->Null,
			MeanBubbleArea->Null,
			DetectionMethod->Null,
			SampleVolume->Null,
			AgitationTime->Null,
			DecayTime->Null,
			Wavelength->Null,
			FieldOfView->Null,
			CameraHeight->Null
		|>&,
		listedInputs
	];

	(* Pass to the primary overload *)
	AnalyzeBubbleRadius[fakePackets,myOps]
];



(* ::Subsection::Closed:: *)
(*Main Function Body*)

(* ------------------------ *)
(* --- PRIMARY OVERLOAD --- *)
(* ------------------------ *)
AnalyzeBubbleRadius[myPackets:ListableP[ObjectP[Object[Data,DynamicFoamAnalysis]]],myOps:OptionsPattern[AnalyzeBubbleRadius]]:=Block[{$HistoryLength=0},Module[
	{
		outputSpecification,output,gatherTests,listedInputs,listedOptions,
		collectMessages,tempMessageStream,inputObjectRefs,outputObjectRefs,loggingInfo,
		safeOptions,safeOptionsTests,templatedOptions,templateTests,combinedOptions,
		expandedInputs,expandedOptions,listedInputPackets,resolvedVideoFrames,resolutionTests,
		totalFrameCount,estimatedRunTime,previewFrames,resolvedOptions,optionsPerInput,collapsedOptions,
		resultPackets,uploadResult,resultRule,previewFunc,finalPreviewFrames,previewRule
	},

	(* Determine the requested function return value *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if a list of tests should be maintained *)
	gatherTests=MemberQ[output,Tests];

	(* Determine if debugging messages should be collected and uploaded to Constellation *)
	collectMessages=OptionValue[UploadErrorLogs]&&OptionValue[Upload]&&MemberQ[output,Result];

	(* Ensure that inputs and options are in a list *)
	listedInputs=ToList[myPackets];
	listedOptions=ToList[myOps];

	(* Get object references for input objects that are objects *)
	inputObjectRefs=Map[
		(Quiet[Download[#,Object],Download::MissingField]/.{$Failed->Null})&,
		listedInputs
	];

	(* Create an ID for each output analysis object ahead of time, for logging *)
	outputObjectRefs=Map[
		CreateID[Object[Analysis,BubbleRadius]]&,
		listedInputs
	];

	(* Use streams to collect error messages if error-logging is requested *)
	tempMessageStream=If[collectMessages,
		openMessageStream[],
		Null
	];

	(* Create an association for logging information *)
	loggingInfo={
		CollectMessages->collectMessages,
		InputObjects->inputObjectRefs,
		OutputObjects->outputObjectRefs,
		MessageStream->tempMessageStream
	};

	(* Populate standard fields for constructing analysis object packets later *)
	standardFieldsStart=analysisPacketStandardFieldsStart[listedOptions];

	(* Call safe options to ensure all options are populated and match patterns *)
	{safeOptions,safeOptionsTests}=If[gatherTests,
		SafeOptions[AnalyzeBubbleRadius,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[AnalyzeBubbleRadius,listedOptions,AutoCorrect->False],Null}
	];

	(* Return $Failed (and tests to this point) if specified options do not match patterns *)
	If[MatchQ[safeOptions,$Failed],
		closeMessageStream[tempMessageStream];
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> safeOptionsTests
		}]
	];

	(* Use template options to get values for options that were not specified in ops *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[AnalyzeBubbleRadius,listedInputs,listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeBubbleRadius,listedInputs,listedOptions],Null}
	];

	(* Return $Failed if the template object does not exist *)
	If[MatchQ[templatedOptions,$Failed],
		closeMessageStream[tempMessageStream];
		Return[outputSpecification/.{
			Result -> $Failed,
			Options -> $Failed,
			Preview -> Null,
			Tests -> Join[safeOptionsTests, templateTests]
		}]
	];

	(* Replace any unspecified safe options with inherited options from the template *)
	combinedOptions=ReplaceRule[safeOptions,templatedOptions];

	(* Expand index matched options *)
	{expandedInputs,expandedOptions}=ExpandIndexMatchedInputs[AnalyzeBubbleRadius,
		{listedInputs},
		combinedOptions
	];

	(* Call option resolver *)
	resolvedOptions=resolveAnalyzeBubbleRadiusOptions[listedInputs,expandedOptions];

	(* Further expand the expanded options to a per-input form *)
	optionsPerInput=MapIndexed[
		Function[{x,idx},
			resolvedOptions/.{
				Rule[x:(MinimumBubbleRadius|MaximumBubbleRadius|HistogramType|HistogramResizeFrequency),y:_List]:>Rule[x,Part[y,First[idx]]]
			}
		],
		listedInputs
	];

	(* Update status for Manifold runs *)
	uploadErrorLog[loggingInfo,	"Option resolution completed: "<>ToString[optionsPerInput]];

	(* Download all the inputs into packet form, if they are not already *)
	listedInputPackets=Download[listedInputs,
		Packet[
			DetectionMethod,
			SampleVolume,
			AgitationTime,
			DecayTime,
			Wavelength,
			FieldOfView,
			CameraHeight,
			ConvertedVideoFile,
			RawVideoFile,
			MeanBubbleArea
		]
	];

	(* Update status for Manifold runs *)
	uploadErrorLog[loggingInfo,"Input resolution, temp directory is: "<>$TemporaryDirectory];

	(* Resolve the frames of video data from the input data packet *)
	{resolvedVideoFrames,resolutionTests}=If[gatherTests||MemberQ[output,Result|Preview],
		If[gatherTests,
			Quiet@Transpose[resolveBubbleVideo[#,gatherTests,loggingInfo]&/@listedInputPackets],
			Transpose[resolveBubbleVideo[#,gatherTests,loggingInfo]&/@listedInputPackets]
		],
		{Repeat[Null,Length[listedInputPackets]],{}}
	];

	(* Update status for Manifold runs *)
	uploadErrorLog[loggingInfo,"Input resolution completed"];

	(* Count of the total number of frames to process *)
	totalFrameCount=Total[Length/@Cases[resolvedVideoFrames,{_Image..}]];

	(* About 10 seconds per frame with no compression, 30 seconds per frame with compression *)
	estimatedRunTime=If[Lookup[resolvedOptions,ReduceMemoryUsage],
		totalFrameCount*(12.0 Second),
		totalFrameCount*(6.0 Second)
	];

	(* Show a warning message if the computation is expected to take a long time *)
	If[estimatedRunTime>(1000.0 Second)&&MemberQ[output,Result],
		Message[Warning::LongComputation,
			RoundReals[UnitConvert[estimatedRunTime,Minute],3],
			DateString[Now+estimatedRunTime]
		]
	];

	(* Now we need to loop over each input for processing. Each processing step is memory intensive, so we do these one at a time. *)
	{resultPackets,previewFrames}=If[MemberQ[output,Result],
		Transpose@MapThread[
			analyzeBubbleRadiusPacket[#1,#2,standardFieldsStart,#3,#4]&,
			{resolvedVideoFrames,listedInputPackets,optionsPerInput,outputObjectRefs}
		],
		{Null,Null}
	];

	(* Update status for Manifold runs *)
	uploadErrorLog[loggingInfo,"Core computation completed: "<>$TemporaryDirectory];

	(* Collapse any index matched options there might be *)
	collapsedOptions=CollapseIndexMatchedOptions[AnalyzeBubbleRadius,
		resolvedOptions,
		Messages->False
	];

	(* Return some of the frames of the analysis as a preview *)
	finalPreviewFrames=Which[
		MatchQ[previewFrames,{{_Image..}..}],
			previewFrames,
		MemberQ[output,Preview],
			MapThread[
				generatePreviewOnly[#1,#2,#3]&,
				{listedInputPackets,resolvedVideoFrames,optionsPerInput}
			],
		True,
			Null
	];

	(* Check the Upload option to see if we should upload or not *)
	uploadResult=If[Lookup[resolvedOptions,Upload]&&MemberQ[output,Result],
		With[{uploads=Upload[DeleteCases[resultPackets,$Failed]]},
			Fold[
				Insert[#1,$Failed,#2]&,
				uploads,
				Position[resultPackets,$Failed]
			]
		],
		resultPackets
	];

	(* Upload the packets if requested, otherwise return packets *)
	resultRule=Result->If[MemberQ[output,Result],
		If[Length[listedInputs]===1,
			First[uploadResult],
			uploadResult
		],
		Null
	];

	(* Preview function turns list of frames into a TabView *)
	previewFunc[x:{__}]:=TabView[x,
		ControlPlacement->Left,
		Alignment -> Center
	];

	(* Prepare the preview rule; return plot if single input, otherwise throw multiple plots into a slide view *)
	previewRule=Preview->If[MemberQ[output,Preview],
		If[Length[listedInputs]==1,
			First[previewFunc/@finalPreviewFrames],
			TabView@Thread[
				("Input "<>ToString[#]&/@Range[Length[listedInputs]])->(previewFunc/@finalPreviewFrames)
			]
		],
		Null
	];

	(* On successful exit, clear the system cache since the image operations can be cache hungry *)
	ClearSystemCache[];

	(* For cleanup, also close any temporary streams we opened for error logging *)
	closeMessageStream[tempMessageStream];

	(* Return the requested outputst *)
	outputSpecification/.{
		resultRule,
		previewRule,
		Options->RemoveHiddenOptions[AnalyzeBubbleRadius,collapsedOptions],
		Tests->Join[safeOptionsTests,templateTests,Flatten[resolutionTests]]
	}
]];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeBubbleRadiusOptions*)

(* Resolve the reduce memory usage option *)
resolveAnalyzeBubbleRadiusOptions[input_,ops_]:=ops/.{
	Rule[ReduceMemoryUsage,Automatic]->Rule[ReduceMemoryUsage,
		(* Default is False *)
		False
	]
};



(* ::Subsubsection::Closed:: *)
(*resolveSingleBubbleInput*)

(* All options for this function have default values/there are no automatics to resolve *)
resolveBubbleVideo[
	dataPacket:PacketP[Object[Data, DynamicFoamAnalysis]],
	tests:True|False,
	loggingInfo_
]:=Module[
	{dataObj,rawVideoFile,videoFile,videoFrames,resolvedFrames,inputTests},

	(* Get the object reference for the data being resolved *)
	dataObj=Lookup[dataPacket,Object];

	(* Check for the presence of a raw video file. Note this will not be used *)
	rawVideoFile=VideoFile/.(Lookup[dataPacket,RawVideoFile]/.{Null->(VideoFile->Null)});

	(* Get the cloud file for the converted video file *)
	videoFile=Lookup[dataPacket,ConvertedVideoFile,Null];

	(* Update status for Manifold runs *)
	uploadErrorLog[loggingInfo,"video file is: "<>ToString[videoFile]];

	(* Get the video frames *)
	videoFrames=framesFromCloudFile[videoFile];
    
	(* Update status for Manifold runs *)
	uploadErrorLog[loggingInfo,"Length of imported frames: "<>ToString[Length[videoFrames]]];

	(* Return the frames if they resolved to a list of images, otherwise return $Failed *)
	resolvedFrames=If[MatchQ[videoFrames,{_Image..}],
		videoFrames,
		(* Error message conditional on fields present *)
		Which[
			(* No foam structure analysis was done *)
			!MatchQ[videoFile,EmeraldCloudFileP]&&!MatchQ[rawVideoFile,EmeraldCloudFileP],
				Message[Error::NoFoamStructureAnalysis,dataObj],
			(* Converted video file did not resolve to a list of images *)
			MatchQ[videoFile,EmeraldCloudFileP],
				Message[Error::InvalidFoamingVideoFormat,dataObj],
			(* Video has not been converted yet *)
			MatchQ[rawVideoFile,EmeraldCloudFileP],
				Message[Error::VideoNotConverted,dataObj],
			(* Default *)
			True,
				Message[Error::InvalidFoamingVideoFormat,dataObj]
		];
		$Failed
	];

	(* Construct tests if requested *)
	inputTests=If[tests,
		{
			If[MatchQ[rawVideoFile,EmeraldCloudFileP],
				Test["RawVideoFile for input "<>ToString[dataObj]<>" has been converted to ConvertedVideoFile:",MatchQ[videoFile,EmeraldCloudFileP],True],
				Nothing
			],
			Test["ConvertedVideoFile for input "<>ToString[dataObj]<>" is present:",MatchQ[videoFile,EmeraldCloudFileP],True],
			Test["Input "<>ToString[dataObj]<>" resolved to a list of images:",MatchQ[videoFrames,{_Image..}],True]
		},
		{}
	];

	(* Return resolved inputs and tests *)
	{resolvedFrames,inputTests}
];

(* Helper function for determining how to import frames from different file format *)
framesFromCloudFile[cloudFile:EmeraldCloudFileP]:=Module[
	{path},

	(* Download the cloud file to the temporary directory with a unique ID *)
	path=DownloadCloudFile[cloudFile,FileNameJoin[{$TemporaryDirectory,CreateUUID[]}]];

	(* Call a different import function depending on the file type *)
	Which[
		(* DownloadCloudFile failed *)
		MatchQ[path,Except[_String]],
			$Failed,
		(* multi-image file; import directly returns a list of images *)
		StringMatchQ[path,__~~(".tiff"|".tif"|"gif"),IgnoreCase->True],
			Import[path],
		(* zip file; import all elements in standard form in sorted name order *)
		StringMatchQ[path,__~~(".zip"|".7z"),IgnoreCase->True],
			safeImportZip[path,$VersionNumber],
		(* Unsupported file format *)
		True,$Failed
	]
];

(* Return $Failed if the input is not a cloud file *)
framesFromCloudFile[_]:=$Failed;


(* Workaround for import bug in Mathematica 12.2 *)
safeImportZip[path_String,Alternatives[12.2,12.3]]:=Module[
	{frameFilePaths,sortedFilePaths},

	(* There is a bug with Importing ZIP files in 12.2, so use ExtractArchive[] to unzip *)
	frameFilePaths=ExtractArchive[path,FileNameJoin[{$TemporaryDirectory, CreateUUID[]}]];

	(* Sort frames by ascending numerical order, handling string ordering and leading zeros *)
	sortedFilePaths=SortBy[
		Select[frameFilePaths,StringMatchQ[#,__~~(".jpg"|".tif"|".tiff"|".jpeg"|".png")]&],
		(* This pattern extracts just the number from file paths of the form frame003.jpeg -> 3 *)
		StringCases[#,__~~LetterCharacter~~num:NumberString~~(".jpg"|".tif"|".tiff"|".jpeg"|".png"):>ToExpression[num]]&
	];

	(* Map import on the sorted file paths *)
	Import/@sortedFilePaths
];

(* Import both filenames and images from ZIP file, then sort by frame number *)
safeImportZip[path_String,___]:=Module[{},
	
	Last/@SortBy[
		(* {filename, frame} pairs *)
		Select[
			Transpose@{Import[path,"FileNames"],Import[path,"*"]},
			StringMatchQ[First[#],__~~(".jpg"|".tif"|".tiff"|".jpeg"|".png")]&
		],
		(* If file format is frame001, frame002 vs frame1, frame2, extract number to sort by *)
		FirstOrDefault[
			StringCases[First[#],
				__~~LetterCharacter~~num:NumberString~~(".jpg"|".tif"|".tiff"|".jpeg"|".png"):>ToExpression[num]
			],
			First[#]
		]&
	]
];



(* ::Subsubsection::Closed:: *)
(*generatePreviewOnly*)

(* Generate a preview, only processing the subset of frames used in the preview *)
generatePreviewOnly[pack_,frames_,ops_]:=Module[
	{sliceIdxs,meanBubbleArea,rate,slicedFrames,slicedRate,modOps,pFrames},

	(* Fail if the frames are invalid *)
	If[MatchQ[frames,$Failed],
		Return[{$Failed}]
	];

	(* Instrument generated mean bubble area, for calibration and frame rate determination *)
	meanBubbleArea=Lookup[pack,MeanBubbleArea,Null];

	(* TODO: Is this right? Resolve the frame rate. Default is 4.0 frames per second *)
	rate=If[MatchQ[meanBubbleArea,QuantityCoordinatesP[{Second,Micrometer^2}]],
		1.0/UnitConvert[Min@Differences[meanBubbleArea[[All,1]]],Second],
		4.0
	];

	(* Indices of frames to slice for the preview *)
	sliceIdxs=DeleteDuplicates@Round[
		Range[1,Length[frames],(Length[frames]-1)/4]
	];

	(* Take 5 evenly spaced frames from the span of the video *)
	slicedFrames=Part[frames,sliceIdxs];

	(* Frame rate of slice spacing *)
	slicedRate=If[Length[sliceIdxs]>1,
		RoundReals[rate/(sliceIdxs[[2]]-sliceIdxs[[1]]),2],
		rate
	];

	(* Resize every frame of the preview *)
	modOps=ReplaceRule[ops,{HistogramResizeFrequency->1},Append->True];

	(* Preview frames *)
	pFrames=First[processVideoFrames[Lookup[pack,Object],slicedFrames,slicedRate,modOps]];

	(* Return the preview rule *)
	Thread[("Frame "<>ToString[#]&/@sliceIdxs)->pFrames]
];



(* ------------------------- *)
(* --- CORE COMPUTATION  --- *)
(* ------------------------- *)

(* ::Subsection::Closed:: *)
(*analyzeBubbleRadiusPacket*)

(* Given a single input and resolved options, process the video and store the results in an analysis packet *)
analyzeBubbleRadiusPacket[
	videoFrames_,
	dataPacket:PacketP[Object[Data,DynamicFoamAnalysis]],
	standardFields:{_Rule..},
	resolvedOps:{_Rule..},
	objRef:ObjectReferenceP[Object[Analysis,BubbleRadius]]
]:=Module[
	{
		dataObj,dataID,meanBubbleArea,dataFields,partialPacketFields,resolvedFrameRate,
		newFrames,previewFrames,radiiPerFrame,radiiFields,graphicsFields,outPacket
	},

	(* Early stop if input data resolution failed *)
	If[!MatchQ[videoFrames,{_Image..}],
		Return[{$Failed,$Failed}]
	];

	(* Object reference of the data packet *)
	{dataObj,dataID}=Lookup[dataPacket,{Object,ID},Null]/.{
		(* For $FastDownload, make sure we null out the packet placeholder *)
    Object[Data, DynamicFoamAnalysis, "id:packetplaceholder"] -> $Failed
	};

	(* Instrument generated mean bubble area, for calibration and frame rate determination *)
	meanBubbleArea=Lookup[dataPacket,MeanBubbleArea,Null];

	(* Fields which should be propagated from the data packet *)
	dataFields=Map[
		(#->Lookup[dataPacket,#,Null])&,
		{
			DetectionMethod,
			SampleVolume,
			AgitationTime,
			DecayTime,
			Wavelength,
			FieldOfView,
			CameraHeight
		}
	];

	(* Packet containing standard fields, shared fields with data object, and link to data object *)
	partialPacketFields=Join[
		standardFields,
		dataFields,
		{Replace[Reference]->If[MatchQ[dataObj,ObjectP[]],Link[dataObj,BubbleRadiusAnalyses],Null]}
	];

	(* TODO: Is this right? Resolve the frame rate. Default is 4.0 frames per second *)
	resolvedFrameRate=If[MatchQ[meanBubbleArea,QuantityCoordinatesP[{Second,Micrometer^2}]],
		1.0/UnitConvert[Min@Differences[meanBubbleArea[[All,1]]],Second],
		4.0
	];

	(* Conduct image analysis to recolor frames and extract radius distributions *)
	{newFrames,radiiPerFrame}=processVideoFrames[dataObj,videoFrames,resolvedFrameRate,resolvedOps];

	(* Sample 3-5 frames to use for a preview *)
	previewFrames=With[{idxs=Range[1,Length[newFrames],Ceiling[(Length[newFrames]-1)/4]]},
		Thread[("Frame "<>ToString[#]&/@idxs)->Part[newFrames,idxs]]
	];

	(* Compute quantities which depend on the radii *)
	radiiFields=computeBubbleStatistics[radiiPerFrame,resolvedFrameRate];

	(* Assemble the Animate[] preview and output TIFF *)
	graphicsFields=assembleGraphics[newFrames,dataID,resolvedFrameRate,resolvedOps];

	(* Assemble the output packet *)
	outPacket=<|
		Type->Object[Analysis,BubbleRadius],
		Object->objRef,
		ResolvedOptions->resolvedOps,
		Sequence@@partialPacketFields,
		Sequence@@radiiFields,
		Sequence@@graphicsFields
	|>;

	(* Return the packet and resolved frames *)
	{outPacket,previewFrames}
];


(* ::Subsubsection::Closed:: *)
(* computeBubbleStatistics *)

(* Compute all area and radius distribution statistics *)
computeBubbleStatistics[radii_,frameRate_]:=Module[
	{
		timePoints,unitlessRadii,unitlessAreas,radiusDists,areaDists,bubbleCounts,
		relativeBubbleCounts,meanSquaredRadii,sauterMeanRadii
	},

	(* Time points, assuming frames are evenly spaced at the frame rate *)
	timePoints=RoundReals[
		Accumulate[Repeat[1/frameRate,Length[radii]]],
		3
	];

	(* Convert to micrometers *)
	unitlessRadii=Unitless[radii,Micrometer];

	(* Areas in square micrometers *)
	unitlessAreas=Map[
		(3.14159*#^2)&,
		unitlessRadii
	];

	(* Convert radii to empirical distributions *)
	radiusDists=Map[
		QuantityDistribution[EmpiricalDistribution[#/.{{}->{0.0}}],Micrometer]&,
		unitlessRadii
	];

	(* Convert areas to empirical distributions *)
	areaDists=Map[
		QuantityDistribution[EmpiricalDistribution[#/.{{}->{0.0}}],Micrometer^2]&,
		unitlessAreas
	];

	(* Number of bubbles in frame *)
	bubbleCounts=Length/@unitlessRadii;

	(* Number of bubbles divided by total area of bubbles in mm^2 *)
	relativeBubbleCounts=MapThread[
		If[MatchQ[#2,{}],
			0.0,
			(#1/(Total[#2]/(1000.0*1000.0)))
		]&,
		{bubbleCounts,unitlessAreas}
	];

	(* Mean squared bubble radii *)
	meanSquaredRadii=Map[
		Sqrt[meanOrDefault[#^2]]&,
		unitlessRadii
	];

	(* Sauter mean radii *)
	sauterMeanRadii=Map[
		If[MatchQ[#,{}],
			0.0,
			(Total[#^3]/Total[#^2])
		]&,
		unitlessRadii
	];

	(* Return radius fields *)
	{
		Replace[VideoTimePoints]->timePoints*(Second),
		Replace[RadiusDistribution]->radiusDists,
		Replace[AreaDistribution]->areaDists,
		Replace[AbsoluteBubbleCount]->bubbleCounts,
		Replace[BubbleCount]->QuantityArray[Transpose@{timePoints,relativeBubbleCounts},{Second,Millimeter^-2}],
		Replace[MeanBubbleArea]->QuantityArray[Transpose@{timePoints,meanOrDefault/@unitlessAreas},{Second,Micrometer^2}],
		Replace[StandardDeviationBubbleArea]->QuantityArray[Transpose@{timePoints,standardDeviationOrDefault/@unitlessAreas},{Second,Micrometer^2}],
		Replace[AverageBubbleRadius]->QuantityArray[Transpose@{timePoints,meanOrDefault/@unitlessRadii},{Second,Micrometer}],
		Replace[StandardDeviationBubbleRadius]->QuantityArray[Transpose@{timePoints,standardDeviationOrDefault/@unitlessRadii},{Second,Micrometer}],
		Replace[MeanSquareBubbleRadius]->QuantityArray[Transpose@{timePoints,meanSquaredRadii},{Second,Micrometer}],
		Replace[BubbleSauterMeanRadius]->QuantityArray[Transpose@{timePoints,sauterMeanRadii},{Second,Micrometer}]
	}
];

(* Helper functions *)
meanOrDefault[x:{__}]=Mean[x];
meanOrDefault[{}]=0.0;
standardDeviationOrDefault[{}|{_}]:=0.0;
standardDeviationOrDefault[x:{__}]=StandardDeviation[x];



(* ::Subsubsection::Closed:: *)
(* assembleGraphics *)

(* Assemble the preview animation and graphic *)
assembleGraphics[newFrames_,objID_String,frameRate_,resolvedOps:{_Rule..}]:=Module[
	{
		showProgressBars,upload,timeString,tempNamePng,tempNameMX,tempNameAvi,
		animation,pngFile,animateFile,aviFile,cfUpload,tmp,animateLink,
		pngLink,aviLink,tmp2
	},

	(* Determine if we should show loading bars *)
	showProgressBars=Lookup[resolvedOps,ProgressBars,True];
	upload=Lookup[resolvedOps,Upload,False];

	(* Current time as a string *)
	timeString=StringTake[DateString[Now,"ISODateTime"],-9;;];

	(* Temporary file name for TIFF output *)
	tempNamePng=$TemporaryDirectory<>"/"<>StringReplace[
		objID<>timeString<>".zip",
		":"->""
	];

	(* Temporary file name for MX output *)
	tempNameMX=$TemporaryDirectory<>"/"<>StringReplace[
		objID<>timeString<>".mx",
		":"->""
	];

	(* Temporary file name for AVI output *)
	tempNameAvi=$TemporaryDirectory<>"/"<>StringReplace[
		objID<>timeString<>".avi",
		":"->""
	];

	(* First print temporary *)
	tmp=If[showProgressBars,
		PrintTemporary[
			Row[{
				"(Step 3/4) Exporting recolored video files: ",
				ProgressIndicator[0.98],
				" 1/1"
			}]
		],
		Null
	];

	(* Animation file *)
	animation=ListAnimate[newFrames,
		frameRate,
		Deployed->True,
		AnimationRunning->False,
		DisplayAllSteps->True,
		ImageSize->800
	];

	(* Export stack of frames to a zip file full of PNGs *)
	pngFile=Export[tempNamePng,
		MapIndexed[
			Rule["frame"<>ToString[First@#2]<>".png",#1]&,
			newFrames
		],
		"ZIP"
	];

	(* Export the animation to a MX file *)
	animateFile=Export[tempNameMX,
		animation,
		"MX"
	];

	(* Export frames as a video*)
	aviFile=Quiet[
		If[$VersionNumber>=12.2,
			Export[tempNameAvi,
				newFrames,
				"MP4",
				FrameRate->Max[1,Floor[frameRate]]
			],
			Export[tempNameAvi,
				newFrames,
				"AVI",
				FrameRate->Max[1,Floor[frameRate]]
			]
		],
		{General::sysffmpeg, FFmpegTools`Common`Private`x$::shdw}
	];

	(* Clear the first print temporary *)
	If[showProgressBars,NotebookDelete[tmp]];

	(* First print temporary *)
	tmp2=If[showProgressBars,
		PrintTemporary[
			Row[{
				"(Step 4/4) Uploading cloud files: ",
				ProgressIndicator[0.98],
				" 1/1"
			}]
		],
		Null
	];

	(* If requested, upload files to the cloud *)
 	animateLink=safeUploadCloudFile[tempNameMX,upload];
	pngLink=safeUploadCloudFile[tempNamePng,upload];
	aviLink=safeUploadCloudFile[tempNameAvi,upload];

	If[showProgressBars,NotebookDelete[tmp2]];

	(* Return the requested fields *)
	{
		AnalysisVideoPreview->animateLink,
		AnalysisVideoFrames->pngLink,
		AnalysisVideoFile->aviLink
	}
];

(* Wrapper for upload cloud file which returns the temp file path if unused *)
safeUploadCloudFile[fpath_,False]:=fpath;
safeUploadCloudFile[fpath_,True]:=Module[
	{cloudFile},

	(* Upload the cloud file *)
	cloudFile=UploadCloudFile[fpath];

	(* Return a link to the cloudfile *)
	If[MatchQ[cloudfile,$Failed],
		Null,
		DeleteFile[fpath];
		Link[cloudFile]
	]
];


(* ------------------------------- *)
(* --- IMAGE HELPER FUNCTIONS  --- *)
(* ------------------------------- *)

(* ::Section:: *)
(* Image Helper Functions *)


(* ::Subsubsection:: *)
(*processVideoFrames*)

(* Core calculation - for each video frame, locate bubbles, obtain radii, and recolor frames with accompanying histogram *)
processVideoFrames[obj:$Failed|ObjectP[],frames:{_Image..},frameRate:NumericP,ops:{(_Rule|_RuleDelayed)...}]:=Module[
	{
		totalFrames,showProgressBars,reduceMemory,histType,bubblesPerFrame,rawRadiiPerFrame,
		convertedRadiiPerFrame,minRadius,maxRadius,radiiPerFrame,smallestRadius,largestRadius,
		automaticHistogramBinsPerFrame,automaticBinWidthPerFrame,commonBinWidth,
		maxCountPerFrame,roundedMaxCounts,smoothedMaxCounts,currHist,currRecolor,
		newFrames,finalRadiiPerFrame,pixelsPerMicrometer
	},

	(* Total number of frames to process *)
	totalFrames=Length[frames];

	(* Boolean indicating if progress bars should be shown during computation *)
	showProgressBars=Lookup[ops,ProgressBars,True];

	(* Boolean indicated if we should compress image component arrays *)
	reduceMemory=Lookup[ops,ReduceMemoryUsage,False]/.{Automatic->False};

	(* Type of histogram to show *)
	histType=Lookup[ops,HistogramType,Radius];

	(* Identify bubbles in each frame of the video, with a loading bar *)
	{bubblesPerFrame,rawRadiiPerFrame}=Transpose@mapWithProgressBars[
		findBubbles[#,reduceMemory]&,
		frames,
		"(Step 1/4) Detecting bubbles",
		showProgressBars
	];

	(* Given a pixel to distance mapping, give radii units of micrometers *)
	pixelsPerMicrometer=0.122;
	convertedRadiiPerFrame=rawRadiiPerFrame/.{Rule[x_,y_]:>Rule[x,y/pixelsPerMicrometer]};

	(* Get the minimum and maximum requested radii *)
	minRadius=Unitless[Lookup[ops,MinimumBubbleRadius,None],Micrometer]/.{None->0.0};
	maxRadius=Unitless[Lookup[ops,MaximumBubbleRadius,None],Micrometer]/.{None->Infinity};

	(* Trim radii outside of the requested minimum and maximum *)
	radiiPerFrame=Map[
		Function[{radii},
			Select[radii,(minRadius<=Last[#]<=maxRadius)&]
		],
		convertedRadiiPerFrame
	];

	(* Warn the user if no bubbles were detected in the entire video*)
	If[MatchQ[Flatten[radiiPerFrame],{}],
		Message[Warning::NoBubblesFound,obj]
	];

	(* The largest radius across all frames of the video *)
	largestRadius=Max[Last/@Flatten[radiiPerFrame]]/.{(-Infinity)->100.0};
	smallestRadius=Min[Last/@Flatten[radiiPerFrame]]/.{Infinity->0.0};

	(* Automatic histogram binning of radii per frame of the video *)
	automaticHistogramBinsPerFrame=Map[
		If[MatchQ[histType,Area],
			HistogramList[3.14159*(Last/@#)^2,"Sturges"],
			HistogramList[Last/@#,"Sturges"]
		]&,
		radiiPerFrame
	];

	(* The automatically determined bin width of the bubble radii identified in each frame of the video *)
	automaticBinWidthPerFrame=Map[
		If[Length[Differences[First[#]]]>1,
			First[Differences[First[#]]],
			10.0
		]&,
		automaticHistogramBinsPerFrame
	];

	(* The largest bin width across all frames *)
	commonBinWidth=Round[Max[automaticBinWidthPerFrame]/2.0];

	(* The largest count of bubbles using a fixed bin width of commonBinWidth at each frame *)
	maxCountPerFrame=Map[
		Max[If[MatchQ[histType,Area],
			Last[HistogramList[3.14159*(Last/@#)^2,{commonBinWidth}]],
			Last[HistogramList[Last/@#,{commonBinWidth}]]
		]]/.{(-Infinity)->0.0}&,
		radiiPerFrame
	];

	(* Round each value to the closest multiple of the nearest 10 *)
	roundedMaxCounts=Map[
		Ceiling[#+5,10]&,
		maxCountPerFrame
	];

	(* Smooth out the max counts so that the axes don't resize more than once per second *)
	smoothedMaxCounts=Join@@Map[
		Repeat[Max[#],Length[#]]&,
		Partition[roundedMaxCounts,UpTo[Lookup[ops,HistogramResizeFrequency,10]]]
	];

	(* For each frame, generate a histogram, recolor bubbles, and join them to create a new frame *)
	newFrames=mapThreadWithProgressBars[
		Function[{radii,maxCount,idx,frm,bubbles,convertedRads},
			Module[{hist,colored,combined},
				(* Need to define these explicitly as module vars so memory gets freed on each iteration *)
				hist=generateHistogram[radii,histType,smallestRadius,largestRadius,commonBinWidth,maxCount,idx,Length[videoFrames],frameRate];
				colored=colorImage[frm,bubbles,convertedRads,radii,smallestRadius,largestRadius];
				combineHistWithFrame[hist,colored]
			]
		],
		{radiiPerFrame,smoothedMaxCounts,Range[totalFrames],frames,bubblesPerFrame,convertedRadiiPerFrame},
		"(Step 2/4) Generating analysis video",
		showProgressBars
	];

	(* List of bubble radii identified in each frame, with appropriate units *)
	finalRadiiPerFrame=Map[
		QuantityArray[Last/@#,Micrometer]&,
		radiiPerFrame
	];

	(* Return the new frames for video assembly, as well as radius and other computation results *)
	{newFrames,finalRadiiPerFrame}
];


(* ::Subsubsection:: *)
(*findBubbles*)

(* Given a video frame of bubbles from the Kruss DFA100, find bubbles and their radii *)
findBubbles[frame_Image]:=findBubbles[frame,False];
findBubbles[frame_Image,compressComponents:True|False]:=Module[
	{quantizedFrame,noGrayBubbles,imgArr,croppedImg,imgMask,imgComponents,bubbleRadii},

	(* Increase contrast and round all colors to either black, gray, green/yellow *)
	quantizedFrame=ColorQuantize[
		ImageAdjust[frame,4],
		{Black,quantizedGray,quantizedGreen,quantizedYellow},
		Dithering->False
	];

	(* Remove the gray/incomplete bubbles and readjust all colors *)
	noGrayBubbles=ColorReplace[quantizedFrame,{
		quantizedGray->Black,
		quantizedGreen->greenBubbleCenterColor,
		quantizedYellow->greenBubbleCenterColor
	}];

	(* Convert the image (stripped of gray bubbles) to a numerical array *)
	imgArr=ImageData[noGrayBubbles];

	(* Manually crop the scale bar and info box out of the video generated by the Kruss DFA100 *)
	imgArr[[1;;55,1;;265,;;3]]=ConstantArray[List@@greenBubbleCenterColor,{55,265}];
	imgArr[[-145;;,1;;320,;;3]]=ConstantArray[List@@greenBubbleCenterColor,{145,320}];
	croppedImg=Image[imgArr];

	(* Create a mask for accepted bubbles, excluding edges and cropped regions *)
	imgMask=DeleteBorderComponents[Binarize[croppedImg]];

	(* Assign an integer to each image component *)
	imgComponents=MorphologicalComponents[imgMask];

	(* Compress the image component array if we are running in memory saver mode *)
	finalComponents=If[compressComponents,
		Compress[imgComponents],
		imgComponents
	];

	(* Compute the centroid and radius of each bubble *)
	bubbleRadii=ComponentMeasurements[imgComponents,"EquivalentDiskRadius"];

	(* Return the image components and radii mapping *)
	{finalComponents,bubbleRadii}
];


(* ::Subsubsection:: *)
(*colorImage*)

(* Given a frame of the video, its components, and radii, color the image in *)
colorImage[frame_Image,components_,radii_,trimmedRadii_,minRadius_,maxRadius_]:=Module[
	{colorRules,resolvedComponents,coloredComponents,desaturatedFrame},

	(* Create coloring rules for each component, based on the ratio of radius to max radius *)
	colorRules=Map[
		Rule[
			First[#],
			If[MatchQ[trimmedRadii,{}],
				grayBubbleCenterColor,
				bubbleGradientColorFunction[(Last[#]-minRadius)/(maxRadius-minRadius)]
			]
		]&,
		radii
	];

	(* Set original bubbles to gray *)
	desaturatedFrame=ColorReplace[frame,greenBubbleCenterColor->grayBubbleCenterColor];

	(* Handle case where frame was compressed *)
	resolvedComponents=If[MatchQ[components,_String],
		Uncompress[components],
		components
	];

	(* Colorize identified bubbles according to their radii, and make background transparent *)
	coloredComponents=ColorReplace[
		Colorize[resolvedComponents,ColorRules->colorRules],
		Black
	];

	(* Overlay the new coloring on the original frame *)
	ImageCompose[desaturatedFrame,coloredComponents]
];


(* ::Subsubsection:: *)
(*generateHistogram*)

(* Given a list of component\[Rule]radius, generate a color-matched histogram of radii *)
generateHistogram[radii_,type_,minRadius_,maxRadius_,binWidth_,maxCount_,frame_,maxFrames_,frameRate_]:=Module[
	{dataNumerical,xMin,xMax,labelStyle,chartLabel,frameLabel,elementFunc},

	(* Numerical list of the radii of identified bubbles *)
	dataNumerical=If[type===Area,
		3.14159*(Last/@radii)^2,
		Last/@radii
	]/.{{}->{Null}};

	(* Append a fake value to please the histogram function if there is only one data point *)
	If[!MatchQ[dataNumerical,{Null}]&&Length[dataNumerical]==1,
		dataNumerical=Append[dataNumerical,-10]
	];

	(* Plot ranges *)
	xMin=If[type===Area,3.14159*minRadius^2,minRadius];
	xMax=If[type===Area,3.14159*maxRadius^2,maxRadius];

	(* Set a custom label style *)
	labelStyle={14,Bold,Darker@White,FontFamily->"Arial"};

	(* Resolve the label based on current frame *)
	chartLabel="Time: "<>ToString[NumberForm[(frame-1)/frameRate,{\[Infinity],2}]]<>" s";

	(* Style the frame label *)
	frameLabel={
		{Style["Count",labelStyle],None},
		If[type===Area,
			{Style["Bubble Area (\[Mu]m^2)",labelStyle],None},
			{Style["Bubble Radius (\[Mu]m)",labelStyle],None}
		]
	};

	(* Use a custom ChartElementFunction to color bars *)
	elementFunc[{{xmin_,xmax_},{ymin_,ymax_}},___]:={
		If[type===Area,
			bubbleGradientColorFunction[
				Max[
					Min[
						(Mean[{Sqrt[xmin/Pi],Sqrt[xmax/Pi]}]-minRadius)/(maxRadius-minRadius),
						1.0
					],
					0.0
				]
			],
			bubbleGradientColorFunction[
				Max[
					Min[
						(Mean[{xmin,xmax}]-minRadius)/(maxRadius-minRadius),
						1.0
					],
					0.0
				]
			]
		],
		EdgeForm[{Thin,Black}],
		Rectangle[{xmin,ymin},{xmax,ymax}]
	};

	(* Create a histogram with the desired formatting *)
	Quiet[
		EmeraldHistogram[dataNumerical,{binWidth},
			PlotRange->{{0.95*xMin,1.05*xMax},{0,maxCount}},
			Frame->True,
			FrameStyle->Darker@White,
			ChartBaseStyle->Opacity[1],
			Background->Black,
			LabelStyle->labelStyle,
			ChartElementFunction->elementFunc,
			FrameLabel->frameLabel,
			PlotLabel->chartLabel
		],
		{Warning::UnresolvedPlotOptions,GeometricFunctions`BinarySearch::invarray}
	]
];


(* ::Subsubsection:: *)
(*combineHistWithFrame*)

(* Combine a histogram and colored frame to create a new graphic for the updated video *)
(* Histogram sits to the right of the bubble image, and should have the same height. *)
combineHistWithFrame[hist_,frameImage_]:= Module[
	{
		frameResized, histResized
	},

	(*
	  ImageSize option for image seems to only affect the hist image, not the frame image.
	  However, the Grid displayed image is impacted regardless. Note that ImagePad must be inside Image for this to work.
	*)
	frameResized = Image[ImagePad[frameImage, 20], ImageSize->{325,Automatic}];
	histResized = Image[ImagePad[hist, 20], ImageSize->{325,Automatic}];

	If[$VersionNumber>=12.2,
		Grid[
			Zoomable[{{frameResized, histResized}}],
			Spacings->{2, 2},
			Background->Black
		],
		(* Graphics in 12.0 must be deployed or rasterized, or the individual components can be moved around.
		Use deploy to retain vector graphics.
		Similarly, spacing and raw images must be different. *)
		Deploy[
			GraphicsRow[
				{frameImage,hist},
				Spacings->{{-50,-80,-50},70},
				Background->Black
			]
		]
	]

];



(* -------------------------- *)
(* --- UTILITY FUNCTIONS  --- *)
(* -------------------------- *)

(* ::Subsubsection:: *)
(*mapWithProgressBars*)

(* Wrapper function to display progress bars over a long computation done through a Map over a list *)
mapWithProgressBars[func_,list_,text_String,False]:=func/@list;
mapWithProgressBars[func_,list_,text_String,True]:=Module[{monitorExpression=Null},
	(* Use Monitor to monitor progress through the map *)
	Monitor[
		MapIndexed[
			(
				monitorExpression=Row[{
					text<>": ",
					ProgressIndicator[First[#2]/Length[list]],
					" "<>ToString[First[#2]]<>"/"<>ToString[Length[list]]
				}];
				func[#1]
			)&,
			list
		],
		Refresh[monitorExpression,TrackedSymbols:>{monitorExpression}]
	]
];



(* ::Subsubsection:: *)
(*mapThreadWithProgressBars*)

(* Wrapper function to display progress bars over a long computation done through a Map over a list *)
mapThreadWithProgressBars[func_,lists_,text_String,False]:=MapThread[func,lists];
mapThreadWithProgressBars[func_,lists_,text_String,True]:=Module[{monitorExpression=Null},
	(* Use Monitor to monitor progress through the map *)
	Monitor[
		MapThread[
			(
				monitorExpression=Row[{
					text<>": ",
					ProgressIndicator[Last[{##}]/Length[First@lists]],
					" "<>ToString[Last[{##}]]<>"/"<>ToString[Length[First@lists]]
				}];
				func[Sequence@@Most[{##}]]
			)&,
			Append[lists,Range[Length[First@lists]]]
		],
		Refresh[monitorExpression,TrackedSymbols:>{monitorExpression}]
	]
];


(* ::Subsubsection:: *)
(*Manifold error logging*)

(* Create a new stream to collect error messages if requested *)
openMessageStream[]:=With[{newStream=OpenWrite[]},
	Off[General::stop];
	$Messages=Append[$Messages,newStream];
	newStream
];

(* Close a temporary message stream for collecting errors *)
closeMessageStream[Null]:=Null;
closeMessageStream[s_OutputStream]:=Check[
	(
		(* Remove stream from $Messages list, close it, then enable suppresion of repeated messages *)
		$Messages=DeleteCases[$Messages,s];
		Close[s];
		On[General::stop];
	),
	$Failed
];

(* Upload error logs to the analysis object *)
uploadErrorLog[False,___]:=Null;
uploadErrorLog[info:{_Rule..},entry_String]:=uploadErrorLog[CollectMessages/.info,InputObjects/.info,OutputObjects/.info,entry,MessageStream/.info];
uploadErrorLog[
	uploadBoolean:True,
	inputRefs:{(Null|ObjectReferenceP[]..)},
	outputRefs:{ObjectReferenceP[Object[Analysis,BubbleRadius]]..},
	entry:_String,
	messageStream:(_OutputStream|Null)
]:=Module[{myMessages,formattedMessages,logEntry,updatePackets},
	(* Read any messages thrown in the current stream as a string *)
	myMessages=If[MatchQ[messageString,_OutputStream],
		ReadString[messageStream[[1]]],
		Null
	];

	(* Convert messages to a string and format accordingly *)
	formattedMessages=If[MatchQ[messageString,_OutputStream],
		StringReplace[ToString@myMessages,{"\r\n\r\n" -> "\n", "\r\n" -> ""}]/.{
			(* If there are no messages set to Null *)
			"EndOfFile"->""
		},
		Null
	];

	(* Update the log*)
	logEntry=StringJoin[
		DateString[Now]<>":\n\n",
		entry<>"\n",
		If[MatchQ[formattedMessages,_String],
			"Messages:\n"<>formattedMessages,
			""
		]
	];

	(* Update packet *)
	updatePackets=MapThread[
		<|
			Object->#2,
			Replace[Reference]->If[MatchQ[#1,ObjectP[]],Link[#1,BubbleRadiusAnalyses],Null],
			Append[ManifoldLogs]->logEntry
		|>&,
		{inputRefs,outputRefs}
	];

	Upload[updatePackets]
];



(* ------------------------- *)
(* --- SISTER FUNCTIONS  --- *)
(* ------------------------- *)

(* ::Section:: *)
(*AnalyzeBubbleRadiusOptions*)

(* Options shared with parent function, with additional OutputFormat option *)
DefineOptions[AnalyzeBubbleRadiusOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the resolved options."
		}
	},
	SharedOptions:>{
		AnalyzeBubbleRadius
	}
];

(* Call parent function with Output->Options and format output *)
AnalyzeBubbleRadiusOptions[
	myInputs:analyzeBubbleRadiusInputP,
	myOptions:OptionsPattern[AnalyzeBubbleRadiusOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove the OutputFormat option *)
	preparedOptions=Normal@KeyDrop[
		ReplaceRule[listedOptions,Output->Options],
		{OutputFormat}
	];

	(* Get the resolved options from AnalyzeBubbleRadius *)
	resolvedOptions=DeleteCases[AnalyzeBubbleRadius[myInputs,preparedOptions],(Output->_)];

	(* Return the options as a list or table, depending on the option format *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,AnalyzeBubbleRadius],
		resolvedOptions
	]
];



(* ::Section:: *)
(*AnalyzeBubbleRadiusPreview*)

(* Options shared with parent function *)
DefineOptions[AnalyzeBubbleRadiusPreview,
	SharedOptions:>{
		AnalyzeBubbleRadius
	}
];

(* Call parent function with Output->Preview *)
AnalyzeBubbleRadiusPreview[
	myInputs:analyzeBubbleRadiusInputP,
	myOptions:OptionsPattern[AnalyzeBubbleRadiusPreview]
]:=Module[{listedOptions},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Call the parent function with Output->Preview *)
	AnalyzeBubbleRadius[myInputs,ReplaceRule[listedOptions,Output->Preview]]
];



(* ::Section:: *)
(*ValidAnalyzeBubbleRadiusQ*)

(* Options shared with parent function, plus additional Verbose and OutputFormat options *)
DefineOptions[ValidAnalyzeBubbleRadiusQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{
		AnalyzeBubbleRadius
	}
];

(* Use OutputFormat->Tests to determine if parent function call is valid, +format the output *)
ValidAnalyzeBubbleRadiusQ[
	myInputs:analyzeBubbleRadiusInputP,
	myOptions:OptionsPattern[ValidAnalyzeBubbleRadiusQ]
]:=Module[
	{
		listedOptions,preparedOptions,analyzeBubbleRadiusTests,
		initialTestDescription,allTests,verbose,outputFormat
	},

	(* Ensure that options are provided as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output, Verbose, and OutputFormat options from provided options *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Call AnalyzeBubbleRadius with Output->Tests to get a list of EmeraldTest objects *)
	analyzeBubbleRadiusTests=AnalyzeBubbleRadius[myInputs,Append[preparedOptions,Output->Tests]];

	(* Define general test description *)
	initialTestDescription="All provided inputs and options match their provided patterns (no further testing is possible if this test fails):";

	(* Make a list of all tests, including the blanket correctness check *)
	allTests=If[MatchQ[analyzeBubbleRadiusTests,$Failed],
		(* Generic test that always fails if the Output->Tests output failed *)
		{Test[initialTestDescription,False,True]},
		(* Generate a list of tests, including valid object and VOQ checks *)
		Module[{validObjectBooleans,voqWarnings},
			(* Check for invalid objects *)
			validObjectBooleans=ValidObjectQ[
				DeleteCases[Cases[Flatten[{myInputs}],ObjectP[]],EmeraldCloudFileP],
				OutputFormat->Boolean
			];

			(* Return warnings for any invalid objects *)
			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[Cases[Flatten[{myInputs}],ObjectP[]],EmeraldCloudFileP],validObjectBooleans}
			];

			(* Gather all tests and warnings *)
			Cases[Flatten[{analyzeBubbleRadiusTests,voqWarnings}],_EmeraldTest]
		]
	];

	(* Look up options exclusive to running tests in the validQ function *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[
		RunUnitTest[<|"ValidAnalyzeBubbleRadiusQ"->allTests|>,Verbose->verbose,OutputFormat->outputFormat],
		"ValidAnalyzeBubbleRadiusQ"
	]
];
