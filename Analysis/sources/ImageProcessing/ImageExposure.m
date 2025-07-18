(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2024 Emerald Cloud Lab,Inc.*)


DefineOptions[AnalyzeImageExposure,
	Options :> {
		{
			OptionName -> Crop,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "Rectangular coordinates with which input image will be trimmed such that pixels outside the coordinates will be excluded from analysis.",
			ResolutionDescription -> "For input matching Object[Data,Appearance,Colonies], automatically set to {{150,150},{2650,1650}}. For input matching Object[Protocol,PAGE], automatically set to {{50, 150}, {1200, 780}}. Otherwise, is automatically set to None and does not crop.",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Automatic, None, {{_Integer, _Integer}, {_Integer, _Integer}}]
			],
			Category -> "General"
		},
		{
			OptionName -> ImageType,
			Default -> Automatic,
			AllowNull -> False,
			Description -> "Type of images based on light source, e.g. white light or narrow-color-band light.",
			ResolutionDescription -> "Resolves to Gel for data derived from Object[Protocol, PAGE], to Lane for Object[Data, PAGE], and to BrightField for all other input types.",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Gel, Lane, QPixImagingStrategiesP, DarkField]
			],
			Category -> "General"
		},
		{
			OptionName -> UnderExposedPixelThreshold,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The minimum fraction of pixels in the image with gray-values lower than 0.25 to be considered under exposed. Black pixels have a value of 0 and white pixels have a value of 1.",
			ResolutionDescription -> "Automatically resolves to presets determined by the resolved value of ImageType.",
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0, 1]
			],
			Category -> "General"
		},
		{
			OptionName -> OverExposedPixelThreshold,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The minimum fraction of pixels in the image with gray-values greater than 0.95 to be considered over exposed. Black pixels have a value of 0 and white pixels have a value of 1.",
			ResolutionDescription -> "Automatically resolves to presets determined by the resolved value of ImageType.",
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0, 1]
			],
			Category -> "General"
		},
		OutputOption,(* note preview feature function AnalyzeImageExposurePreview is automatically generate in the V1 framework. *)
		UploadOption
	}
];


(* Default crop coordinates for qpix images *)
(* Note:default qpix dimensions are {2819, 1872}, we want to remove the plate edge *)
$qpixCrop = {{150, 150}, {2650, 1650}};

(* warning for PAGE when no properly exposed image is found *)
Warning::ProceedWithLongestExposureImage = "No properly exposed image is found for `1`. Image with the longest exposure will be selected for `1`.";
Error::IncorrectOptimalityCriteria = "Options supplied for optimality criteria are incompatible. Try increase OverExposedPixelThreshold and/or decrease UnderExposedPixelThreshold to shift toward brighter image, and vice versa for darker image.";
Error::InputNotImages = "Input objects are not images. Make sure inputs are image objects and try again.";
Error::EmptyDataField = "There are empty data fields in `1`. Please check to ensure the required fields {ExposureTime, Image, ImageFile} are not empty.";

(* Overload for a single EmeraldCloudFile image: input is a list of {time, image}, where time = input[[1]], image =input[[2]] and use analyzeImageExposureResolveInputCloudFile *)
AnalyzeImageExposure[input: {_?QuantityQ, ObjectP[Object[EmeraldCloudFile]]}, ops: OptionsPattern[]] := AnalyzeImageExposure[{{{input[[1]], Link[input[[2]]]}}}, ops];

(* Overload for single input that does not need to be triple listed and use analyzeImageExposureResolveInputImage *)
AnalyzeImageExposure[input: {_?QuantityQ, _Image|LinkP[]}, ops: OptionsPattern[]] := AnalyzeImageExposure[{{input}}, ops];

(* Overload for multiple inputs and use analyzeImageExposureResolveInputCloudFile *)
AnalyzeImageExposure[input: {{_?QuantityQ, _Image}..}|{{_?QuantityQ, LinkP[]}..}|{{_?QuantityQ, ObjectP[Object[EmeraldCloudFile]]}..}, ops: OptionsPattern[]] := Module[
	{inputDataType, resolvedInput},

	inputDataType = DeleteDuplicates[Head[#[[2]]]& /@ input];
	resolvedInput = Switch[inputDataType,
		{Link}|{Image}, {#[[1]], #[[2]]}& /@ input,
		_, {#[[1]], Link[#[[2]]]}& /@ input
	];
	AnalyzeImageExposure[{resolvedInput}, ops]
];

(* Listable overload for PAGE protocols and use analyzeImageExposureResolveInputPAGE *)
AnalyzeImageExposure[protocolsIn: ListableP[ObjectP[Object[Protocol, PAGE]]], ops:OptionsPattern[AnalyzeImageExposure]] := Module[
	{allData, resolvedData, opsIn, singleInputQ, flattenedData},

	(* Turn options into list *)
	opsIn = ToList[ops];

	(* Download Data and Ladder data from all protocols*)
	{singleInputQ, allData} = If[MatchQ[protocolsIn, ObjectP[Object[Protocol, PAGE]]],
		(* Single protocol input *)
		{True, Flatten[Download[protocolsIn, {Data, LadderData}]]},

		(* Multi-protocols input *)
		{False, Download[#, {Data, LadderData}]& /@ protocolsIn}
	];

	flattenedData = If[singleInputQ, allData, Flatten[#[[1]]]& /@ allData];

	resolvedData = Switch[singleInputQ,
		(* Take the first data object of protocol*)
		True, flattenedData[[1]],
		(* take the first data object from each protocol *)
		False, Flatten[Take[#, 1]& /@ flattenedData]
	];
	AnalyzeImageExposure[resolvedData, ops]
];


(* Main function definition using v1 SciComp Framework *)

(*Overload 1: ObjectP[Object[Data, Appearance, Colonies]]*)
DefineAnalyzeFunction[
	AnalyzeImageExposure,
	<|
		InputData -> ObjectP[Object[Data, Appearance, Colonies]]
	|>,
	(* Break down main function into the following steps/subfunctions *)
	{
		analyzeImageExposureResolveInputColonies,
		analyzeImageExposureResolveOptionsColonies,
		analyzeImageExposureCalculateColonies,
		analyzeImageExposurePreview
	}
];

(*Overload 2: ObjectP[ObjectP[Object[Data, Appearance]]]*)
DefineAnalyzeFunction[
	AnalyzeImageExposure,
	<|
		InputData -> Alternatives[ObjectP[Object[Data, Appearance]], {ObjectP[Object[Data, Appearance]]..}]
	|>,
	(* Break down main function into the following steps/subfunctions *)
	{
		analyzeImageExposureResolveInputAppearance,
		analyzeImageExposureResolveOptionsGeneral,
		analyzeImageExposureCalculateGeneral,
		analyzeImageExposurePreview
	}
];

(*Overload 3: ObjectP[ObjectP[Object[Data, PAGE]]]*)
DefineAnalyzeFunction[
	AnalyzeImageExposure,
	<|
		InputData -> ObjectP[Object[Data, PAGE]]
	|>,
	(* Break down main function into the following steps/subfunctions *)
	{
		analyzeImageExposureResolveInputPAGE,
		analyzeImageExposureResolveOptionsGeneral,
		analyzeImageExposureCalculatePAGE,
		analyzeImageExposurePreview
	}
];

(*Overload 4: {{_?QuantityQ, _Image} ..}*)
DefineAnalyzeFunction[
	AnalyzeImageExposure,
	<|
		InputData -> Alternatives[{_?QuantityQ, _Image}, {{_?QuantityQ, _Image}..}]
	|>,
	(* Break down main function into the following steps/subfunctions *)
	{
		analyzeImageExposureResolveInputImage,
		analyzeImageExposureResolveOptionsGeneral,
		analyzeImageExposureCalculateGeneral,
		analyzeImageExposurePreview
	}
];

(*Overload 5: {{_?QuantityQ, LinkP[Object[EmeraldCloudFile]]} ..}*)
DefineAnalyzeFunction[
	AnalyzeImageExposure,
	<|
		InputData -> Alternatives[{{_?QuantityQ, LinkP[Object[EmeraldCloudFile]]}..}, {_?QuantityQ, LinkP[EmeraldCloudFile]}]
	|>,
	(* Break down main function into the following steps/subfunctions *)
	{
		analyzeImageExposureResolveInputCloudFile,
		analyzeImageExposureResolveOptionsGeneral,
		analyzeImageExposureCalculateGeneral,
		analyzeImageExposurePreview
	}
];


(***********************************************************************************)
(* Resolve input: overload for Object[Data, Appearance, Colonies] *)
analyzeImageExposureResolveInputColonies[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: ObjectP[Object[Data, Appearance, Colonies]]
		}]
	}]
] := Module[{allImageFields, data},

	(* List of all possible image fields *)
	allImageFields = {
		(*1*)ExposureTime,
		(*2*)ImageFile,
		(*3*)DarkfieldExposureTime,
		(*4*)DarkfieldImageFile,
		(*5*)DarkRedFluorescenceExposureTime,
		(*6*)DarkRedFluorescenceImageFile,
		(*7*)BlueWhiteScreenExposureTime,
		(*8*)BlueWhiteScreenImageFile,
		(*9*)GreenFluorescenceExposureTime,
		(*10*)GreenFluorescenceImageFile,
		(*11*)OrangeFluorescenceExposureTime,
		(*12*)OrangeFluorescenceImageFile,
		(*13*)RedFluorescenceExposureTime,
		(*14*)RedFluorescenceImageFile,
		(*15*)VioletFluorescenceExposureTime,
		(*16*)VioletFluorescenceImageFile
	};

	(* Download all fields *)
	data = Download[inputData, allImageFields];

	(* Fail early if there is nothing left *)
	If[MatchQ[data, {}|Null],
		Message[Error::EmptyDataField, inputData];
		Return[$Failed]
	];

	<|
		ResolvedInputs -> <|
			Protocol -> {},
			ExposureTime -> data[[1]],
			ImageFile -> data[[2]],
			DarkfieldExposureTime -> data[[3]],
			DarkfieldImageFile -> data[[4]],
			DarkRedFluorescenceExposureTime -> data[[5]],
			DarkRedFluorescenceImageFile -> data[[6]],
			BlueWhiteScreenExposureTime -> data[[7]],
			BlueWhiteScreenImageFile -> data[[8]],
			GreenFluorescenceExposureTime -> data[[9]],
			GreenFluorescenceImageFile -> data[[10]],
			OrangeFluorescenceExposureTime -> data[[11]],
			OrangeFluorescenceImageFile -> data[[12]],
			RedFluorescenceExposureTime -> data[[13]],
			RedFluorescenceImageFile -> data[[14]],
			VioletFluorescenceExposureTime -> data[[15]],
			VioletFluorescenceImageFile -> data[[16]]
		|>,
		Tests-> <|ResolvedInputTests -> {}|>
	|>

];

(* resolve input: overload for Object[Data,Appearance] *)
analyzeImageExposureResolveInputAppearance[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: ObjectP[Object[Data, Appearance]]
		}]
	}]
] := Module[{referenceImage, exposureTime, imageFile},

	(* Download necessary fields *)
	{exposureTime, referenceImage, imageFile} = Download[inputData, {ExposureTime, Image, UncroppedImageFile}];

	(* check to make sure there are no Nulls in input, otherwise fail early *)
	If[MatchQ[exposureTime, Null]||MatchQ[referenceImage, Null|{}]||MatchQ[imageFile, Null|{}],
		Message[Error::EmptyDataField, inputData];
		Return[$Failed]
	];

	<|
		ResolvedInputs-> <|
			Protocol -> {},
			ReferenceImages -> ToList[referenceImage],
			ExposureTimes -> ToList[exposureTime],
			ImageFiles -> ToList[imageFile]
		|>,
		Tests-> <|ResolvedInputTests->{}|>
	|>
];


(* Resolve input: overload for Object[Data,PAGE] *)
analyzeImageExposureResolveInputPAGE[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: ObjectP[Object[Data, PAGE]]
		}]
	}]
] := Module[
	{
		protocol, gelImages, gelImageFiles, laneImages, laneImageFiles, ladderImages, ladderImageFiles, exposureTimes
	},

	(* batch download all fields *)
	{{protocol}, exposureTimes, gelImages, gelImageFiles, laneImages, laneImageFiles, ladderImages, ladderImageFiles} = downloadPAGEData[inputData];

	(* Note: reference images are set in options resolution  *)
	<|
		ResolvedInputs -> <|
			Protocol -> protocol,
			ReferenceImages -> {},
			GelImages -> gelImages,
			GelImageFiles -> gelImageFiles,
			LaneImages -> laneImages,
			LaneImageFiles -> laneImageFiles,
			LadderImages -> ladderImages,
			LadderImageFiles -> ladderImageFiles,
			ExposureTimes -> exposureTimes,
			ReferenceImages -> {}
		|>,
		Tests -> <|ResolvedInputTests -> {}|>
	|>
];


(* Resolve input: overload for a list of images with exposure times *)
analyzeImageExposureResolveInputImage[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: {{_?QuantityQ, _Image}..}
		}]
	}]
] := Module[{referenceImages, exposureTimes, imageFiles, sortedInputData},

	sortedInputData = SortBy[inputData, Unitless[inputData[[;;1]]]];
	exposureTimes = #[[1]]& /@ sortedInputData;
	referenceImages = #[[2]]& /@ sortedInputData;

	(* Convert images into cloud files *)
	imageFiles = UploadCloudFile[referenceImages];

	<|
		ResolvedInputs -> <|
			Protocol -> {},
			ReferenceImages -> referenceImages,
			ExposureTimes -> exposureTimes,
			ImageFiles -> imageFiles
		|>,
		Tests -> <|ResolvedInputTests -> {}|>
	|>
];

(* Resolve input: overload for a list of cloud file image links together with exposure times *)
analyzeImageExposureResolveInputCloudFile[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: {{_?QuantityQ, LinkP[]}..}|{{_?QuantityQ, ObjectP[Object[EmeraldCloudFile]]}..}
		}]
	}]
] := Module[{input, imageFiles, referenceImages, exposureTimes},

	input = SortBy[inputData, Unitless[inputData[[;;1]]]];
	exposureTimes = #[[1]]& /@ input;
	imageFiles = #[[2]]& /@ input;
	referenceImages = ImportCloudFile[#]& /@ imageFiles;

	(* Check to ensure inputs are images, otherwise fail early *)
	If[!MatchQ[referenceImages, _Image|{_Image..}],
		Message[Error::InputNotImages];
		Return[$Failed]
	];

	<|
		ResolvedInputs -> <|
			Protocol -> {},
			ReferenceImages -> referenceImages,
			ExposureTimes -> exposureTimes,
			ImageFiles -> imageFiles
		|>,
		Tests -> <|ResolvedInputTests -> {}|>
	|>
];


(***********************************************************************************)
(* options resolution for Object[Data, Appearance, Colonies], this needs to be the first ResolveOptions sub-function *)
(* because Object[Data, Appearance, Colonies] is a subtype of Object[Data, Appearance] *)

analyzeImageExposureResolveOptionsColonies[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: ObjectP[Object[Data, Appearance, Colonies]]
		}],
		ResolvedOptions -> KeyValuePattern[{
			Crop -> crop_,
			ImageType -> imageType_,
			UnderExposedPixelThreshold -> underExposedPixelThreshold_,
			OverExposedPixelThreshold -> overExposedPixelThreshold_
		}]
	}]
] := Module[
	{
		resolvedCrop, resolvedImageType, resolvedUnderExposedPixelThreshold, resolvedOverExposedPixelThreshold
	},

	(* Call a helper to get crop mask *)
	resolvedCrop = getCrop[inputData, crop];

	(* Resolve image type  based on option input and input object data type *)
	(* If not specified, resolve to BrightField which every colony appearance data has one *)
	resolvedImageType = If[MatchQ[imageType, Automatic], BrightField, imageType];

	{
		resolvedUnderExposedPixelThreshold,
		resolvedOverExposedPixelThreshold
	} = getExposureCriteria[
		resolvedImageType,
		underExposedPixelThreshold,
		overExposedPixelThreshold
	];

	(* Output packet *)
	<|
		ResolvedOptions ->
			<|
				Crop -> resolvedCrop,
				ImageType -> resolvedImageType,
				UnderExposedPixelThreshold -> resolvedUnderExposedPixelThreshold,
				OverExposedPixelThreshold -> resolvedOverExposedPixelThreshold
			|>
	|>
];


(* options resolution: for inputs other than Object[Data, Appearance, Colonies] *)
analyzeImageExposureResolveOptionsGeneral[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: Alternatives[
				ObjectP[Object[Data, Appearance]],
				ObjectP[Object[Data, PAGE]],
				ListableP[{_?QuantityQ, _?ImageQ}],
				ListableP[{_?QuantityQ, LinkP[]}],
				ListableP[{_?QuantityQ, ObjectP[Object[EmeraldCloudFile]]}]
			]
		}],
		ResolvedOptions -> KeyValuePattern[{
			Crop -> crop_,
			ImageType -> imageType_,
			UnderExposedPixelThreshold -> underExposedPixelThreshold_,
			OverExposedPixelThreshold -> overExposedPixelThreshold_
		}]
	}]
] := Module[
	{
		resolvedCrop, resolvedImageType, resolvedUnderExposedPixelThreshold, resolvedOverExposedPixelThreshold
	},

	(* Call a helper to get crop mask *)
	resolvedCrop = getCrop[inputData, crop];

	(* Resolve image type based on option input and input object data type *)
	resolvedImageType = Which[
		 MatchQ[inputData, ObjectP[Object[Data, PAGE]]], Lane,
		 MatchQ[inputData, ObjectP[Object[Protocol, PAGE]]], Gel,
		 MatchQ[imageType, Automatic], BrightField,
		 True, imageType
	 ];

	(* call a helper to resolve exposure criteria based on image type *)
	{
		resolvedUnderExposedPixelThreshold,
		resolvedOverExposedPixelThreshold
	} = getExposureCriteria[
		resolvedImageType,
		underExposedPixelThreshold,
		overExposedPixelThreshold
	];

	(* output packet *)
	<|
		ResolvedOptions ->
			<|
				Crop -> resolvedCrop,
				ImageType -> resolvedImageType,
				UnderExposedPixelThreshold -> resolvedUnderExposedPixelThreshold,
				OverExposedPixelThreshold -> resolvedOverExposedPixelThreshold
			|>
	|>
];

(* Main code to generate new analysis object *)
(* calculation function for Object[Data, Appearance, Colonies] *)
analyzeImageExposureCalculateColonies[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
				InputData -> inputData: ObjectP[Object[Data, Appearance, Colonies]]
		}],
		ResolvedInputs -> KeyValuePattern[{
			Protocol -> protocol_,
			ExposureTime -> exposureTimeIn_,
			ImageFile -> imageFileIn_,
			DarkfieldExposureTime -> darkfieldExposureTime_,
			DarkfieldImageFile -> darkfieldImageFile_,
			DarkRedFluorescenceExposureTime -> darkRedFluorescenceExposureTime_,
			DarkRedFluorescenceImageFile -> darkRedFluorescenceImageFile_,
			BlueWhiteScreenExposureTime -> blueWhiteScreenExposureTime_,
			BlueWhiteScreenImageFile -> blueWhiteScreenImageFile_,
			GreenFluorescenceExposureTime -> greenFluorescenceExposureTime_,
			GreenFluorescenceImageFile -> greenFluorescenceImageFile_,
			OrangeFluorescenceExposureTime -> orangeFluorescenceExposureTime_,
			OrangeFluorescenceImageFile -> orangeFluorescenceImageFile_,
			RedFluorescenceExposureTime -> redFluorescenceExposureTime_,
			RedFluorescenceImageFile -> redFluorescenceImageFile_,
			VioletFluorescenceExposureTime -> violetFluorescenceExposureTime_,
			VioletFluorescenceImageFile -> violetFluorescenceImageFile_
		}],
		ResolvedOptions -> KeyValuePattern[{
			Crop -> crop_,
			ImageType -> imageType_,
			UnderExposedPixelThreshold -> resolvedUnderExposedPixelThreshold_,
			OverExposedPixelThreshold -> resolvedOverExposedPixelThreshold_
		}]
	}]
] := Module[
	{
		exposureTime, imageFile, image, imgAssos, informationEntropy, overExposedPixelThreshold, underExposedPixelThreshold,
		dynamicRange, optimalImagePosition, acceptableImagesPosition, acceptableImage, optimalImageFileLink, optimalExposureTime,
		optimalImage, referenceImageLink, acceptableImageLink, referenceImage, suggestedExposureTime, optimalImageFile
	},

	(* Get exposure time and  image file link based on image type *)
	{exposureTime, imageFile} = Switch[imageType,
		BlueWhiteScreen, {blueWhiteScreenExposureTime, blueWhiteScreenImageFile},
		BrightField, {exposureTimeIn, imageFileIn},
		DarkField, {darkfieldExposureTime, darkfieldImageFile},
		DarkRedFluorescence, {darkRedFluorescenceExposureTime, darkRedFluorescenceImageFile},
		GreenFluorescence, {greenFluorescenceExposureTime, greenFluorescenceImageFile},
		OrangeFluorescence, {orangeFluorescenceExposureTime, orangeFluorescenceImageFile},
		RedFluorescence, {redFluorescenceExposureTime, redFluorescenceImageFile},
		VioletFluorescence, {violetFluorescenceExposureTime, violetFluorescenceImageFile}
	];

	(* Import image from file link *)
	image = ImportCloudFile[imageFile];

	(* Call helper to analyze the image, need to convert into list *)
	imgAssos = ToList[analyzeSingleImage[image, exposureTime, imageFile, crop, imageType, resolvedUnderExposedPixelThreshold, resolvedOverExposedPixelThreshold]];


	(* Call a helper to get statistical indices for all images *)
	{informationEntropy, overExposedPixelThreshold, underExposedPixelThreshold, dynamicRange} = getStatisticalIndices[imgAssos];

	(* Get positions for optimal and acceptable exposures *)
	{optimalImagePosition, acceptableImagesPosition} = getOptimalImage[imgAssos, imageType];

	(* Extract acceptable images *)
	acceptableImage = If[!MatchQ[acceptableImagesPosition, Null|{}],
		Extract[imageFile, acceptableImagesPosition],
		Null
	];

	(* Current image is optimal if optimalImagePosition is not null *)
	{
		optimalExposureTime,
		optimalImage,
		optimalImageFile
	} = If[!MatchQ[optimalImagePosition, Null|{}],
		{exposureTime, referenceImage, imageFile},
		{Null, Null, Null}
	];

	(* Calculate suggested exposure time if no optimal image is found *)
	suggestedExposureTime = If[MatchQ[optimalImage, Null],
		suggestedExposureTime = predictExposureTime[imgAssos],
		Null
	];

	(* If all calculated results are null, this means the optimality criteria options are incorrectly set. Throw warning and return $Failed *)
	If[optimalExposureTime == Null && Unitless[suggestedExposureTime] == Null,
		Message[Error::IncorrectOptimalityCriteria];
		Return[$Failed]
	];

	(* Create links to images *)
	optimalImageFileLink = Link[optimalImageFile];
	referenceImageLink = Link[imageFile];
	acceptableImageLink = Link[acceptableImage];

	(* Output packet *)
	<|
		Packet ->
			<|
				Type -> Object[Analysis, ImageExposure],
				If[MatchQ[inputData, ObjectP[Object[Data, Appearance, Colonies]]],
					Replace[Reference] -> Link[inputData, ImageExposureAnalyses],
					Nothing (*Do not add an entry to association otherwise*)
				],
				Replace[ReferenceImages] -> referenceImageLink,
				Replace[ExposureTimes] -> exposureTime,
				Replace[InformationEntropies] -> informationEntropy,
				Replace[OverExposedPixelFractions] -> overExposedPixelThreshold,
				Replace[UnderExposedPixelFractions] -> underExposedPixelThreshold,
				Replace[DynamicRanges] -> dynamicRange,
				Replace[AcceptableImages] -> acceptableImageLink,
				OptimalExposureTime -> optimalExposureTime,
				OptimalImage -> optimalImageFileLink,
				SuggestedExposureTime -> suggestedExposureTime,
				ImageType -> imageType
			|>,
		Intermediate ->
			<|
				Data -> inputData,
				ImageType -> imageType,
				ImageAssociations -> imgAssos
			|>
	|>
];


(* Main calculation function *)
analyzeImageExposureCalculateGeneral[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: Alternatives[
				ObjectP[Object[Data, Appearance]],
				{{_?QuantityQ, _?ImageQ}..},
				{{_?QuantityQ, LinkP[]}..},
				{{_?QuantityQ, ObjectP[Object[EmeraldCloudFile]]}..}
			]
		}],
		ResolvedInputs -> KeyValuePattern[{
			Protocol -> protocol_,
			ReferenceImages -> referenceImages_,
			ExposureTimes -> exposureTimes_,
			ImageFiles -> imageFiles_
		}],
		ResolvedOptions -> KeyValuePattern[{
			Crop -> crop_,
			ImageType -> imageType_,
			UnderExposedPixelThreshold -> resolvedUnderExposedPixelThreshold_,
			OverExposedPixelThreshold -> resolvedOverExposedPixelThreshold_
		}]
	}]
] := Module[
	{
		numberOfImages, imageIndex, imgAssos, optimalImage, optimalExposureTime, suggestedExposureTime, dynamicRange,
		informationEntropy, acceptableImages, overExposedPixelThreshold, referenceImageLinks, acceptableImageLinks,
		optimalImageFileLink, underExposedPixelThreshold, optimalImagePosition, acceptableImagesPositions, optimalImageFile
	},

	numberOfImages = Length[referenceImages];
	imageIndex = Range[numberOfImages];

	(* call a helper to analyze each image to build a image association that contains all info *)
	imgAssos = analyzeSingleImage[
		referenceImages[[#]],
		exposureTimes[[#]],
		imageFiles[[#]],
		crop,
		imageType,
		resolvedUnderExposedPixelThreshold,
		resolvedOverExposedPixelThreshold
	]& /@ imageIndex;

	(* Call a helper to get statistical indices for all images *)
	{informationEntropy, overExposedPixelThreshold, underExposedPixelThreshold, dynamicRange} = getStatisticalIndices[imgAssos];

	(* Get positions for optimal and acceptable exposures *)
	{optimalImagePosition, acceptableImagesPositions} = getOptimalImage[imgAssos, imageType];

	(* Extract acceptable images *)
	acceptableImages = If[!MatchQ[acceptableImagesPositions, Null|{}],
		Extract[imageFiles, acceptableImagesPositions],
		Null
	];

	(* Get optimal image info *)
	{
		optimalExposureTime,
		optimalImage,
		optimalImageFile
	} = If[!MatchQ[optimalImagePosition, Null|{}],
		{
			exposureTimes[[optimalImagePosition[[1]]]],
			referenceImages[[optimalImagePosition[[1]]]],
			imageFiles[[optimalImagePosition[[1]]]]
		},
		{Null, Null, Null}
	];

	(* Calculate suggested exposure time if no optimal image is found *)
	suggestedExposureTime = If[MatchQ[optimalImage, Null],
		suggestedExposureTime = predictExposureTime[imgAssos],
		Null
	];

	(* If all calculated results are null, this means the optimality criteria options are incorrectly set. Throw warning and return $Failed *)
	If[optimalExposureTime == Null && Unitless[suggestedExposureTime] == Null,
		Message[Error::IncorrectOptimalityCriteria];
		Return[$Failed]
	];

	(* Create links to images *)
	optimalImageFileLink = Link[optimalImageFile];
	referenceImageLinks = Link[#]& /@ imageFiles;
	acceptableImageLinks = Link[#]& /@ acceptableImages;

	(* Output packet *)
	<|
		Packet ->
			<|
				Type -> Object[Analysis, ImageExposure],
				If[MatchQ[inputData, ObjectP[Object[Data, Appearance, Colonies]]],
					Replace[Reference] -> Link[inputData, ImageExposureAnalyses],
					Nothing (*Do not add an entry to association otherwise*)
				],
				Replace[ReferenceImages] -> referenceImageLinks,
				Replace[ExposureTimes] -> exposureTimes,
				Replace[InformationEntropies] -> informationEntropy,
				Replace[OverExposedPixelFractions] -> overExposedPixelThreshold,
				Replace[UnderExposedPixelFractions] -> underExposedPixelThreshold,
				Replace[DynamicRanges] -> dynamicRange,
				Replace[AcceptableImages] -> acceptableImageLinks,
				OptimalExposureTime -> optimalExposureTime,
				OptimalImage -> optimalImageFileLink,
				SuggestedExposureTime -> suggestedExposureTime,
				ImageType -> imageType
			|>,
		Intermediate ->
				<|
				Data -> inputData,
				ImageType -> imageType,
				ImageAssociations -> imgAssos
			|>
	|>
];


(* Main calculate overload for PAGE data *)
analyzeImageExposureCalculatePAGE[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: ObjectP[Object[Data, PAGE]]
		}],
		ResolvedInputs -> KeyValuePattern[{
			Protocol -> protocol_,
			GelImages -> gelImages_,
			GelImageFiles -> gelImageFiles_,
			LaneImages -> laneImages_,
			LaneImageFiles -> laneImageFiles_,
			LadderImages -> ladderImages_,
			LadderImageFiles -> ladderImageFiles_,
			ExposureTimes -> exposureTimes_
		}],
		ResolvedOptions -> KeyValuePattern[{
			Crop -> Crop_,
			ImageType -> imageType_,
			UnderExposedPixelThreshold -> resolvedUnderExposedPixelThreshold_,
			OverExposedPixelThreshold -> resolvedOverExposedPixelThreshold_
		}]
	}]
] := Module[
	{
		numberOfImages, imageIndex, finalImages, imgAssos, optimalImage, optimalImageFile, optimalExposureTime,
		optimalImageFileLink, informationEntropy, referenceImages, referenceImageFiles, overExposedPixelThreshold,
		underExposedPixelThreshold, dynamicRange, referenceImageLinks, suggestedExposureTime, finalIndex, acceptableImages,
		optimalImagePosition, acceptableImagesPositions, acceptableImageLinks, index, resolvedCrop
	},

	(* Set exposure reference images and links based on image type *)
	{referenceImages, referenceImageFiles} = Switch[imageType,
		Gel, {gelImages, gelImageFiles},
		Lane, {laneImages, laneImageFiles}
	];

	(* Convert images to gray scale, and reverse color *)
	finalImages = Function[{image}, ColorNegate[ColorConvert[image, "GrayScale"]]][referenceImages];

	(* Resolve crop if provided, or if image is gel *)
	resolvedCrop = Which[
		(* Crop option *)
		!MatchQ[Crop, None|Null], Crop,
		(* Automatically trim gel images *)
		MatchQ[imageType, Gel], {{50, 150}, {1200, 780}},
		True, None
	];

	numberOfImages = Length[referenceImages];
	imageIndex = Range[numberOfImages];

	(* Call a helper to analyze each image and build a image association that contains all info *)
	imgAssos = analyzeSingleImage[
		finalImages[[#]],
		exposureTimes[[#]],
		referenceImageFiles[[#]],
		resolvedCrop,
		imageType,
		resolvedUnderExposedPixelThreshold,
		resolvedOverExposedPixelThreshold
	]& /@ imageIndex;

	(* Get statistical indices for all images *)
	informationEntropy = Lookup[imgAssos, "Entropy"];
	overExposedPixelThreshold = Lookup[imgAssos, "OverExposedPixelThreshold"];
	underExposedPixelThreshold = Lookup[imgAssos, "UnderExposedPixelThreshold"];
	dynamicRange = Lookup[imgAssos, "DynamicRange"];

	(* Get positions for optimal and acceptable exposures *)
	{index, acceptableImagesPositions} = getOptimalImage[imgAssos, imageType];

	(* Extract acceptable images *)
	acceptableImages = If[!MatchQ[acceptableImagesPositions, Null|{}],
		Extract[referenceImageFiles, acceptableImagesPositions],
		Null
	];

	{optimalImagePosition, suggestedExposureTime} = If[!MatchQ[index, Null],
		{
			(*position index of optimal image *)
			index,
			(* estimated exposure time,quiet the message for GoodExposure *)
			Null
		},

		(* If no image is properly exposed,throw a message *)
		Message[Warning::ProceedWithLongestExposureImage, inputData];
		(* proceed to pick the longest exposure image,double the exposure time *)
		{
			{4},
			2*Max[Max[Lookup[imgAssos, "ExposureTime"]]]
		}
	];

	finalIndex = optimalImagePosition[[1]];

	(* Use finalIndex to identify optimal image info *)
	{
		optimalExposureTime,
		optimalImage,
		optimalImageFile
	} = If[!MatchQ[optimalImagePosition, Null|{}],
		{
			exposureTimes[[finalIndex]],
			referenceImages[[finalIndex]],
			referenceImageFiles[[finalIndex]]
		},
		{Null, Null, Null}
	];

	(* Create links to images *)
	optimalImageFileLink = Link[optimalImageFile];
	referenceImageLinks = Link[#]& /@ referenceImageFiles;
	acceptableImageLinks=  Link[#]& /@ acceptableImages;

	(* Construct upload packet *)
	<|
		Packet ->
      <|
				Type -> Object[Analysis,ImageExposure],
				Replace[Reference] -> Link[inputData, ImageExposureAnalyses],
				Replace[ReferenceImages] -> referenceImageLinks,
				Replace[ExposureTimes] -> exposureTimes,
				Replace[InformationEntropies] -> informationEntropy,
				Replace[OverExposedPixelFractions] -> overExposedPixelThreshold,
				Replace[UnderExposedPixelFractions] -> underExposedPixelThreshold,
				Replace[DynamicRanges] -> dynamicRange,
				Replace[AcceptableImages] -> acceptableImageLinks,
				OptimalExposureTime -> optimalExposureTime,
				OptimalImage -> optimalImageFileLink,
				SuggestedExposureTime -> suggestedExposureTime,
				ImageType -> imageType
			|>,
		Intermediate ->
				<|
					Data -> inputData,
					ImageType -> imageType,
					ImageAssociations -> imgAssos
			|>
	|>
];


analyzeImageExposurePreview[
	KeyValuePattern[{
		Intermediate -> KeyValuePattern[{
			Data -> inputData_,
			ImageAssociations -> imgAssos_,
			ImageType -> imageType_
		}],
		Packet -> KeyValuePattern[{
			OptimalExposureTime -> optimalExposureTime_,
			OptimalImage -> optimalImageLink_,
			SuggestedExposureTime -> suggestedExposureTime_
		}]
	}]
]:= Module[
	{
		fig, optimalImage, imgDimensions, showOptimalImage, exposureTimes, images, position, aspectRatio,
		suggestion, imagesAndPrediction, allImagesAndTimes, showSuggestedTime, imageSize, numberOfImages
	},

	(* Download optimal image from its link *)
	optimalImage = If[!MatchQ[optimalImageLink, Null], ImportCloudFile[optimalImageLink], Null];

	(* Get all exposure times and images from images associations *)
	{exposureTimes, images} = Which[
		MatchQ[imageType, Lane|Gel]||MatchQ[inputData, ObjectP[Object[Data, Appearance]]],
			Transpose[Lookup[imgAssos, {"ExposureTime", "OriginalImage"}]],
		True,
			Transpose[Lookup[imgAssos, {"ExposureTime", "Image"}]]
	];

	aspectRatio = ImageAspectRatio[images[[1]]];

	numberOfImages = Length[images];

	(* Generate preview fig for optimalImage,else generate graphic depiction of predicted exposure time *)
	fig = Which[
		(* Output optimal image *)
		MatchQ[optimalImage, _Image],
			position = Position[exposureTimes, optimalExposureTime][[1, 1]];
			(* Get image dimensions *)
			imgDimensions = ImageDimensions[optimalImage];
			Which[
				MatchQ[inputData, ObjectP[Object[Data, Appearance]]],
					imageSize = 400;
					showOptimalImage = Grid[
						Transpose[{
							Flatten[{"Exposure Time", exposureTimes}],
							Flatten[{"Image", Show[#, ImageSize -> imageSize]& /@ images}]
						}],
						Frame -> {None, None, {{position+1, 1} -> True, {position+1, 2} -> True}},
						FrameStyle -> Directive[Thickness[4], Darker[Green]]],
				(* When input data is not PAGE *)
				!MatchQ[imageType, Gel|Lane],
					imageSize = Floor[{1, aspectRatio}*800/numberOfImages];
					showOptimalImage = Grid[
						Transpose[{
							Flatten[{"Exposure Time", exposureTimes}],
							Flatten[{"Image", Show[#, ImageSize -> imageSize]& /@ images}]
						}],
						Frame -> {None, None, {{position+1, 1} -> True, {position+1, 2} -> True}},
						FrameStyle -> Directive[Thickness[4], Darker[Green]]],
				(* When input data is PAGE data or PAGE protocol *)
				MatchQ[inputData, ObjectP[]],
					imageSize = Which[
						MatchQ[imageType, Lane], Medium,
						MatchQ[imageType, Gel], 275
					];
					showOptimalImage = Which[
						MatchQ[imageType, Lane],
						Grid[{
							{
								Style[Download[inputData, Object], Bold], SpanFromLeft, SpanFromLeft},
								exposureTimes,
								Show[#, ImageSize -> imageSize]& /@ images
							},
							Frame -> {None, None, {{2, position} -> True, {3, position} -> True}},
							FrameStyle -> Directive[Thickness[4], Darker[Green]]],
					MatchQ[imageType, Gel],
						Grid[
							Transpose[{
								Flatten[{"Exposure Time", exposureTimes}],
								Flatten[{"Image", Show[#, ImageSize -> imageSize]& /@ images}]
							}],
							Frame -> {None ,None, {{position+1, 1} -> True, {position+1, 2} -> True}},
							FrameStyle -> Directive[Thickness[4], Darker[Green]]]
					]
			];
			(* Call a helper to generate preview tabs *)
			generatePreviewTabs[showOptimalImage, imgAssos, optimalExposureTime, "Optimal Image"],
		(* Output suggested exposure time *)
		MatchQ[optimalExposureTime, Null] && MatchQ[Unitless[suggestedExposureTime], _?NumericQ],
			imageSize = If[MatchQ[inputData, ObjectP[Object[Data, Appearance]]],
				400,
				Floor[{1, aspectRatio}*800/numberOfImages]
			];
			suggestion = {suggestedExposureTime,Show[Graphics[Text[Style["Suggested exposure time", Medium, Bold]], ImageSize -> {150, 30}]]};
			imagesAndPrediction = SortBy[Append[Transpose[{exposureTimes, Show[#, ImageSize -> imageSize]& /@ images}], suggestion], #[[1]]&];
			allImagesAndTimes = {#[[1]], #[[2]]} & /@ imagesAndPrediction;
			position = Position[allImagesAndTimes, suggestedExposureTime][[1, 1]];
			showSuggestedTime = Grid[{#[[1]], #[[2]]}& /@ imagesAndPrediction,
				Frame -> {None,None,{{position, 1} -> True, {position, 2} -> True}},
				FrameStyle -> Directive[Thickness[4], Darker[Red]]
			];
			generatePreviewTabs[showSuggestedTime, imgAssos, suggestedExposureTime, "Suggested Exposure Time"]

	];

	<|Preview -> fig|>
];


(* misc. helper functions *)

(* analyze a single image: create an association to hold all data *)
analyzeSingleImage[
	image_,
	exposureTime_,
	imageFileLink_,
	crop_,
	imageType_,
	resolvedUnderExposedPixelThreshold_,
	resolvedOverExposedPixelThreshold_
]:=
	Module[
		{
			trimmedImage, finalImage, levels, normalizedCounts, accumulatedCounts, normalizedLevelsAndCounts,
			accumulatedLevelsAndCounts, entropy, underExposedPixelThreshold, overExposedPixelThreshold,
			dynamicRange, min, max, criteria, underExposureQ, overExposureQ
		},

		(* Crop image if crop coordinates are provided *)
		trimmedImage = If[!MatchQ[crop, None|Null], ImageTrim[image, crop], image];

		(* Convert image to gray scale *)
		finalImage = ColorConvert[trimmedImage, "GrayScale"];

		(* Calculate normalized image levels (pixel values and counts for each channel) *)
		{levels, normalizedCounts} = getImageLevelsAndCounts[finalImage];

		normalizedLevelsAndCounts = Transpose[{levels, normalizedCounts}];

		(* Integrate over normalized counts *)
		accumulatedCounts = Accumulate[normalizedCounts];

		accumulatedLevelsAndCounts = Transpose[{levels, accumulatedCounts}];

		(* Get image entropy *)
		entropy = ImageMeasurements[finalImage, "Entropy"];

		(* Calculate under-exposure index: portion of signal levels in the lower quantile channels *)
		underExposedPixelThreshold = N[Total[Select[normalizedLevelsAndCounts, #[[1]]<0.25&][[All, 2]]]];

		(* Calculate over-exposure index: portion of the signal levels in the top 5% channels *)
		overExposedPixelThreshold = N[Total[Select[normalizedLevelsAndCounts, #[[1]]>0.95&][[All, 2]]]];

		(* Calculate image dynamic range using 5%-95% normalized counts *)
		min = SelectFirst[accumulatedLevelsAndCounts, #[[2]] > 0.05&][[1]];
		max = SelectFirst[accumulatedLevelsAndCounts, #[[2]] > 0.95&][[1]];
		dynamicRange = 20*Log10[max/(1+min)];

		(* Get image quality criteria values *)
		criteria = {resolvedUnderExposedPixelThreshold, resolvedOverExposedPixelThreshold};

		(* Compare indices with image quality criteria to check if image is under/over-exposed *)
		underExposureQ = underExposedPixelThreshold > resolvedUnderExposedPixelThreshold;
		overExposureQ = overExposedPixelThreshold > resolvedOverExposedPixelThreshold;

		(* Output imageAssociation which contains all data *)
		<|
			"ExposureTime" -> exposureTime,
			"Image" -> finalImage,
			(* PAGE images need to be reversed *)
			"OriginalImage" -> If[MatchQ[imageType, Gel|Lane], ColorNegate[image], image],
			"ImageFileLink" -> imageFileLink,
			"NormalizedCounts" -> Transpose[{levels, normalizedCounts}],
			"AccumulatedCounts" -> Transpose[{levels, accumulatedCounts}],
			"Entropy" -> entropy,
			"UnderExposedPixelThreshold" -> underExposedPixelThreshold,
			"OverExposedPixelThreshold" -> overExposedPixelThreshold,
			"DynamicRange" -> dynamicRange,
			"UnderExposureQ" -> underExposureQ,
			"OverExposureQ" -> overExposureQ
		|>
	];


(* helper to get image pixel value levels and normalized total counts *)
getImageLevelsAndCounts[image_] := Module[
	{levelsAndCounts, totalCounts, v1, v2},

	(* Get image pixel levels and counts for each channel *)
	levelsAndCounts = ImageLevels[image, Automatic];

	(* Calculate total counts in image *)
	totalCounts = Total[levelsAndCounts[[All, 2]]];

	(* Build vectors for channels and corresponding counts *)
	v1 = levelsAndCounts[[All, 1]];
	v2 = levelsAndCounts[[All, 2]]/totalCounts;

	(* Output normalized levels and counts *)
	{v1, v2}
];


(* helper to pick the optimal image and its exposure time from a list of image associations *)
getOptimalImage[imgAssos: {_?AssociationQ..}, imageType_] := Module[
	{
		underExposureQ, overExposureQ, properExposedQ, optimalImagePosition, entropy, acceptableImagesPositions
	},

	(* Get exposure info *)
	underExposureQ = Lookup[imgAssos, "UnderExposureQ"];
	overExposureQ = Lookup[imgAssos, "OverExposureQ"];

	(* Identify properly exposed images *)
	properExposedQ = Array[Not[underExposureQ[[#]]]&&Not[overExposureQ[[#]]]&, Length[underExposureQ]];

	(* Get positions of properly exposed images *)
	acceptableImagesPositions = Position[properExposedQ, True];

	(* If no properly exposed images are found,return Null *)
	If[MatchQ[acceptableImagesPositions, {}|Null],
		Return[{Null, Null}]
	];

	(* Get entropy of properly exposed images *)
	entropy = Extract[Lookup[imgAssos, "Entropy"], acceptableImagesPositions];

	(* Pick the image with the highest/lowest entropy among properly exposed images based on imageType*)
	optimalImagePosition = Switch[imageType,
		BrightField|BlueWhiteScreen|Lane|Gel, First[Sort[Transpose[{entropy, acceptableImagesPositions}], #2[[1]]<#1[[1]]&]][[2]],
		_, Last[Sort[Transpose[{entropy, acceptableImagesPositions}], #2[[1]]<#1[[1]]&]][[2]]
	];

	{optimalImagePosition, acceptableImagesPositions}
];


(* helper to predict next exposure time based on 1 or more input images *)
predictExposureTime[imgAsso: {_?AssociationQ..}|{{_?AssociationQ..}}] := Module[
	{
		numberOfImages, exposureTime, newExposureTime, underExposureQ, overExposureQ, maxUnderT, minOverT, notUnderExposed,
		notOverExposed, properExposureQ, goodPicPosition, goodExposureTime, unit
	},

	(* Lookup exposure time unit *)
	unit = Lookup[imgAsso[[1]], "ExposureTime"][[2]];

	(* Get exposure time from input image association *)
	exposureTime = Unitless[Lookup[imgAsso, "ExposureTime"]];

	(* Number of input images based on number of exposure time *)
	numberOfImages = Length[exposureTime];

	(* Get all imageQ indicators from input *)
	{underExposureQ, overExposureQ} = Transpose[Lookup[imgAsso, {"UnderExposureQ", "OverExposureQ"}]];

	(* Identify properly exposed images *)
	{notUnderExposed, notOverExposed}= Map[Not, #]& /@ {underExposureQ, overExposureQ};
	properExposureQ = MapThread[And, {notUnderExposed, notOverExposed}];

	(* Get position of properly exposed images *)
	goodPicPosition = Position[properExposureQ, True];

	(* Exit early if one or more images are already properly exposed *)
	If[goodPicPosition != {},
		(* Extract good exposure time *)
		goodExposureTime = If[numberOfImages === 1, exposureTime, Extract[exposureTime, goodPicPosition]];
		Return[Quantity[Min[goodExposureTime], unit]]
	];

	(* Estimate next exposure time based image indices and exposure times *)
	newExposureTime = Which[

		(* If all images are under-exposed but not over-exposed,double the max exposure time *)
		And@@underExposureQ && Not[And@@overExposureQ],
			2*Max[exposureTime],

		(* if all images are over-exposed but not under-exposed,halve the min exposure time *)
		Not[And@@underExposureQ] && And@@overExposureQ,
			Min[exposureTime]/2,

		(* if mixed under- and over-exposed images *)
		Not[And@@underExposureQ] && Not[And@@overExposureQ],

			(* first, get the longest under-exposed time *)
			maxUnderT = Max[Extract[exposureTime, Position[underExposureQ, True]]];

			(* also get the smallest over-exposed time *)
			minOverT = Min[Extract[exposureTime, Position[overExposureQ, True]]];

			(* take the mean of the two as new exposureTime *)
			Mean[{maxUnderT, minOverT}]

	];

	Quantity[N[newExposureTime, 3], unit]
];


(* helper to determine crop mask if called/needed *)
getCrop[inputData_, cropIn_] := Which[
	(* Crop mask for QPIX images hardcoded unless specified. other images type default to None *)
	(* automatic crop mask for QPIX images currently hardcoded *)
	MatchQ[inputData, ObjectP[Object[Data, Appearance, Colonies]]] && MatchQ[cropIn, Automatic], $qpixCrop,

	(* user supplied crop mask regardless of image data type *)
	MatchQ[cropIn, {{_Integer, _Integer}, {_Integer, _Integer}}], cropIn,

	(* all other cases Automatic default to None *)
	True, None
];


(* helper to generate symbols used in PAGE data *)
dataSymbols[symbol_String] := Module[{exposures},
	exposures = If[MatchQ[symbol, "Time"],
		{"LowExposure", "MediumLowExposure", "MediumHighExposure", "HighExposure"},
		{"LowExposure", "MediumLowExposure", "MediumHighExposure", "HighExposure"}
	];
	ToExpression[StringJoin[#<>symbol]]& /@ exposures
];


(* helper to download data from a PAGE data object *)
downloadPAGEData[inputData_] := Module[{dataToGet, fields},

	(* map the helper over all symbols to set up batch download *)
	dataToGet = Map[dataSymbols[#]&,
		{"Time", "GelImage", "GelImageFile", "LaneImage", "LaneImageFile", "LadderImage", "LadderImageFile"}
	];

	(* Include protocol in the download fields*)
	fields = Join[{{Protocol}}, dataToGet];

	(* Batch download all fields *)
	Download[inputData, fields]
];


(* helper to generate preview tabs *)
generatePreviewTabs[imageToShow_, imageAssosIn_, exposureTimeIn_, outputType_] := Module[
	{
		normalizeCounts, accumulatedCounts, exposureTimes, entropies, dynamicRanges, underExposureIndices, overExposureIndices,
		optimalPosition, pixelValuePlot, accumulatedPixelValuePlot, entropyPlot, optimalEntropyPoint, finalEntropyPlot,
		underExposureIndexPlot, optimalUnderExposurePoint, finalUnderExposurePlot, overExposureIndexPlot ,optimalOverExposurePoint,
		finalOverExposurePlot, dynamicRangePlot, optimalDynamicRangePoint, finalDynamicRangePlot, leftGrid, rightGrid, showStats,
		lineWidths, numberOfImages
	},

	exposureTimes = Lookup[imageAssosIn, "ExposureTime"];

	(* Determine position of optimal exposure *)
	optimalPosition = If[MatchQ[outputType, "Optimal Image"], FirstPosition[exposureTimes, exposureTimeIn][[1]], Null];

	(* get all stats from image associations *)
	normalizeCounts = Lookup[imageAssosIn, "NormalizedCounts"];
	accumulatedCounts = Lookup[imageAssosIn, "AccumulatedCounts"];
	entropies = Lookup[imageAssosIn, "Entropy"];
	dynamicRanges = Lookup[imageAssosIn, "DynamicRange"];
	underExposureIndices = Lookup[imageAssosIn, "UnderExposedPixelThreshold"];
	overExposureIndices = Lookup[imageAssosIn, "OverExposedPixelThreshold"];

	(* Number of images analyzed *)
	numberOfImages = Length[exposureTimes];

	(* Generate stat plots *)

	(* Highlight the optimal stat with thicker line width *)
	lineWidths = Switch[outputType,
		"Optimal Image", ReplacePart[Table[Thickness[0.003] ,numberOfImages], optimalPosition -> Thickness[0.01]],
		"Suggested Exposure Time", Table[Thickness[0.003], numberOfImages]
	];

	pixelValuePlot = EmeraldListLinePlot[normalizeCounts,
		Frame -> True,
		PlotRange -> All,
		PlotStyle -> lineWidths,
		FrameLabel -> {"Channel", "Pixel Value" },
		ImageSize -> Medium
	];

	accumulatedPixelValuePlot = EmeraldListLinePlot[accumulatedCounts,
		Frame -> True,
		PlotRange -> All,
		PlotStyle -> lineWidths,
		FrameLabel -> {"Channel", "Accumulated Pixel Value" },
		ImageSize -> Medium
	];

	entropyPlot = EmeraldListLinePlot[Transpose[{exposureTimes, entropies}],
		PlotMarkers -> {Automatic, Medium},
		PlotRange -> All,
		Frame -> True,
		FrameLabel -> {None, Style["Entropy", Black, 11]},
		FrameTicksStyle -> Directive[Black, 10],
		ImageSize -> Small
	];

	underExposureIndexPlot = EmeraldListLinePlot[Transpose[{exposureTimes, underExposureIndices}],
		PlotMarkers -> {Automatic, Medium},
		PlotRange -> All,
		Frame -> True,
		FrameLabel -> {None, Style["UnderExpo. Frac", Black, 11]},
		FrameTicksStyle -> Directive[Black, 10],
		ImageSize -> Small
	];

	overExposureIndexPlot = EmeraldListLinePlot[Transpose[{exposureTimes, overExposureIndices}],
		PlotMarkers -> {Automatic, Medium},
		PlotRange -> All,
		Frame -> True,
		FrameLabel -> {None, Style["OverExpo. Frac", Black, 11]},
		FrameTicksStyle -> Directive[Black, 10],
		ImageSize -> Small
	];

	dynamicRangePlot = EmeraldListLinePlot[Transpose[{exposureTimes, dynamicRanges}],
		PlotMarkers -> {Automatic, Medium},
		PlotRange -> All,
		Frame -> True,
		FrameLabel -> {Style["Exposure Time(ms)", Black, 11], Style["Dynamic Range", Black, 11]},
		FrameTicksStyle -> Directive[Black, 10],
		ImageSize -> Small
	];

	{
		finalEntropyPlot,
		finalUnderExposurePlot,
		finalOverExposurePlot,
		finalDynamicRangePlot
	} = Switch[outputType,
		"Optimal Image",
			optimalPosition = FirstPosition[exposureTimes, exposureTimeIn][[1]];
			optimalEntropyPoint = Graphics[{PointSize[Large], Red, Point[{Unitless[exposureTimes[[optimalPosition]]], entropies[[optimalPosition]]}]}];
			optimalUnderExposurePoint = Graphics[{PointSize[Large], Red, Point[{Unitless[exposureTimes[[optimalPosition]]], underExposureIndices[[optimalPosition]]}]}];
			optimalOverExposurePoint = Graphics[{PointSize[Large], Red, Point[{Unitless[exposureTimes[[optimalPosition]]], overExposureIndices[[optimalPosition]]}]}];
			optimalDynamicRangePoint = Graphics[{PointSize[Large], Red, Point[{Unitless[exposureTimes[[optimalPosition]]], dynamicRanges[[optimalPosition]]}]}];

			{
				Show[entropyPlot, optimalEntropyPoint],
				Show[underExposureIndexPlot, optimalUnderExposurePoint],
				Show[overExposureIndexPlot, optimalOverExposurePoint],
				Show[dynamicRangePlot, optimalDynamicRangePoint]
			},
		"Suggested Exposure Time",
			{
				Show[entropyPlot],
				Show[underExposureIndexPlot],
				Show[overExposureIndexPlot],
				Show[dynamicRangePlot]
			}
	];

	(* combine plots into grids *)
	leftGrid = Grid[{{pixelValuePlot}, {accumulatedPixelValuePlot}}, Frame -> All];
	rightGrid = Grid[{{finalEntropyPlot}, {finalUnderExposurePlot}, {finalOverExposurePlot}, {finalDynamicRangePlot}}, Frame -> All];

	(* combine grids *)
	showStats = Grid[{{leftGrid, rightGrid}}, Frame -> All];

	(* show both image and stats *)
	(* AppHelpers`Private`makeGraphicSizeFull was used to pattern match in command center preview, remember to update the pattern accordingly if any changes made here. *)
	TabView[{outputType -> imageToShow, "Analyses" -> showStats}, Alignment -> Center, ImageMargins -> 0]
];

(* Predefined criteria for acceptable exposure. Update these numbers if necessary *)
$ExposureCriteria = <|
	(*For colonies and other data*)
	BrightField -> {UnderExposedPixelThreshold -> 0.5, OverExposedPixelThreshold -> 0.05},
	Fluorescence -> {UnderExposedPixelThreshold -> 0.98, OverExposedPixelThreshold -> 0.01},

	(*These are duplicated from Fluorescence and should be updated once better default settings have been found.*)
	BlueWhiteScreen -> {UnderExposedPixelThreshold -> 0.98, OverExposedPixelThreshold -> 0.01},
	DarkField -> {UnderExposedPixelThreshold -> 0.98, OverExposedPixelThreshold -> 0.01},
	DarkRedFluorescence -> {UnderExposedPixelThreshold -> 0.98, OverExposedPixelThreshold -> 0.01},
	GreenFluorescence -> {UnderExposedPixelThreshold -> 0.98, OverExposedPixelThreshold -> 0.01},
	OrangeFluorescence -> {UnderExposedPixelThreshold -> 0.98, OverExposedPixelThreshold -> 0.01},
	RedFluorescence -> {UnderExposedPixelThreshold -> 0.98, OverExposedPixelThreshold -> 0.01},
	VioletFluorescence -> {UnderExposedPixelThreshold -> 0.98, OverExposedPixelThreshold -> 0.01},

	(*For PAGE data*)
	Lane -> {UnderExposedPixelThreshold -> 0.8, OverExposedPixelThreshold -> 0.09},
	Gel -> {UnderExposedPixelThreshold -> 0.6, OverExposedPixelThreshold -> 0.05}
|>;

(* helper to extract exposure criteria based on image type *)
getExposureCriteria[imageType_, underExposedPixelThreshold_, overExposedPixelThreshold_] := Module[
	{defaultCriteria, inputDefaultPairs, resolvedUnderExposedPixelThreshold, resolvedOverExposedPixelThreshold},

	(* Get default criteria from the global variable based on image type *)
	defaultCriteria = Values[Lookup[$ExposureCriteria, imageType]];

	(* Resolve image quality criteria based on resolved image type *)
	(* first create a list: {{input_UnderExposedPixelThreshold, default_UnderExposedPixelThreshold},{input_OverExposedPixelThreshold, default_OverExposedPixelThreshold}} *)
	inputDefaultPairs = Transpose[{{underExposedPixelThreshold, overExposedPixelThreshold}, defaultCriteria}];

	(* Pick from each inputDefaultPair, if input(#[[1]]) is Automatic, pick the default value(#[[2]]), else pick input *)
	{resolvedUnderExposedPixelThreshold, resolvedOverExposedPixelThreshold} = Apply[
		Function[{input, default}, If[MatchQ[input, Automatic], default, input]],
		inputDefaultPairs,
		{1}
	];

	{resolvedUnderExposedPixelThreshold, resolvedOverExposedPixelThreshold}
];

(* helper to extract statistical indices from image associations *)
getStatisticalIndices[imgAssociationsIn_] := Module[
	{informationEntropy, overExposedPixelThreshold, underExposedPixelThreshold, dynamicRange},

	informationEntropy = Lookup[imgAssociationsIn, "Entropy"];
	overExposedPixelThreshold = Lookup[imgAssociationsIn, "OverExposedPixelThreshold"];
	underExposedPixelThreshold = Lookup[imgAssociationsIn, "UnderExposedPixelThreshold"];
	dynamicRange = Lookup[imgAssociationsIn, "DynamicRange"];

	{informationEntropy, overExposedPixelThreshold, underExposedPixelThreshold ,dynamicRange}
];
