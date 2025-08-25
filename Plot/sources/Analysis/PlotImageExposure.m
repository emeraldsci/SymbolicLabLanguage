(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotImageExposure*)


DefineOptions[PlotImageExposure,
	Options :> {
		{
			OptionName -> ImageType,
			Default -> Automatic,
			Description -> "Indicates which type of images we are displaying.",
			ResolutionDescription -> "Automatically set to the value of ImageType field of the input analysis, Otherwise set to BrightField if the input is associated with the Object[Data,Appearance,Colonies], or set to Lane if the input is associated with Object[Data,PAGE].",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[QPixImagingStrategiesP, Lane]
			],
			Category -> "General"
		},
		(* Inherit options without modification *)
		OutputOption
	}
];

PlotImageExposure::ImageNotFound = "No image was found with ImageType `2` for the input data `1`.";
PlotImageExposure::AnalysisNotFound = "No image exposure analysis with ImageType `2` was found for the input data `1`. Please use AnalyzeImageExposure to calculate the gray-values for your images beforehand.";
PlotImageExposure::ConflictingImageTypes = "The ImageType recorded with for the input data `1` is `2` while option ImageType is set to `3`. Please adjust the ImageType option or let it resolve automatically.";

(*Given objects*)
PlotImageExposure[id: objectOrLinkP[Object[Analysis, ImageExposure]], ops: OptionsPattern[]] := PlotImageExposure[Download[id], ops];
(*AppearanceColonies overload*)
PlotImageExposure[myAppearanceData: ObjectP[Object[Data, Appearance, Colonies]], myOptions: OptionsPattern[PlotImageExposure]] := Module[
	{
		safeOps, output, imageType, dataPacket, imagingStrategiesToImageFile, rawFinalImageFile, allImageExposureAnalysisObjects,
		allReferences, resultedExposureAnalysis
	},

	(* Check safe options *)
	safeOps = SafeOptions[PlotImageExposure, ToList[myOptions]];
	output = Lookup[safeOps, Output];

	(* Resolve ImageType *)
	imageType = If[!MatchQ[Lookup[safeOps, ImageType], Automatic],
		Lookup[safeOps, ImageType],
		BrightField
	];

	(* Remove the Replace and Append headers *)
	dataPacket = Analysis`Private`stripAppendReplaceKeyHeads[Download[myAppearanceData]];

	(* Map ImagingStrategies to the field for raw image file in appearance data *)
	imagingStrategiesToImageFile = {
		BrightField -> ImageFile,
		BlueWhiteScreen -> BlueWhiteScreenImageFile,
		VioletFluorescence -> VioletFluorescenceImageFile,
		GreenFluorescence -> GreenFluorescenceImageFile,
		OrangeFluorescence -> OrangeFluorescenceImageFile,
		RedFluorescence -> RedFluorescenceImageFile,
		DarkRedFluorescence -> DarkRedFluorescenceImageFile
	};

	(* Extract ExposureAnalysis Object[Analysis, ImageExposure] from data Object[Data,Appearance,Colonies] *)
	rawFinalImageFile = Lookup[dataPacket, imageType/.imagingStrategiesToImageFile];

	(* Throw an message if no image data is found *)
	If[NullQ[rawFinalImageFile],
		Message[
			PlotImageExposure::ImageNotFound,
			ECL`InternalUpload`ObjectToString[myAppearanceData],
			ToString[imageType]
		];
		Return[$Failed]
	];

	(* Extract all Object[Analysis, ImageExposure] and their references *)
	allImageExposureAnalysisObjects = Download[Analysis`Private`packetLookup[dataPacket, ImageExposureAnalyses], Object];
	allReferences = Download[#, ReferenceImages]& /@ allImageExposureAnalysisObjects;
	(* Select the last image exposure analysis ran on the rawImageFile if there are multiple *)
	resultedExposureAnalysis = LastOrDefault@PickList[allImageExposureAnalysisObjects, allReferences, {___, ObjectP[rawFinalImageFile], ___}];

	If[NullQ[resultedExposureAnalysis],
		Message[
			PlotImageExposure::AnalysisNotFound,
			ECL`InternalUpload`ObjectToString[myAppearanceData],
			ToString[imageType]
		];
		Return[$Failed]
	];

	(* Convert to main overload *)
	PlotImageExposure[Download[resultedExposureAnalysis], ImageType -> imageType, Output -> output]
];

(*Main Overload*)
PlotImageExposure[
	myPacket: PacketP[Object[Analysis, ImageExposure]],
	myOptions: OptionsPattern[PlotImageExposure]
] := Module[
	{
		safeOps, output, packet, ref, refTitle, inheritedImageType, imageType, inputImageFiles, optimalImageFile, inputExposureTimes,
		optimalOrSuggestExposureTime, images, imageSize, optimalExposurePosition, finalPlot
	},

	(* Check safe options *)
	safeOps = SafeOptions[PlotImageExposure, ToList[myOptions]];
	output = Lookup[safeOps, Output];

	(* Remove the Replace and Append headers *)
	packet = Analysis`Private`stripAppendReplaceKeyHeads[myPacket];

	(* Extract ImageType of input *)
	inheritedImageType = Which[
		!MatchQ[Lookup[packet, ImageType], Null],
			Lookup[packet, ImageType],
		MatchQ[Lookup[Lookup[packet, ResolvedOptions], ImageType], QPixImagingStrategiesP|Lane],
			Lookup[Lookup[packet, ResolvedOptions], ImageType],
		MemberQ[Lookup[packet, Reference], ObjectP[Object[Data, PAGE]]],
			Lane,
		True,
			Null
	];

	(* Extract Reference from the data packet *)
	(* Note: not all Object[Analysis, ImageColonies] have reference *)
	(* We want to display a tile with the output image, use the input analysis object if no reference PAGE/Appearance data *)
	ref = Download[Lookup[packet, Reference], Object];
	refTitle = If[MatchQ[ref, {}], Download[myPacket, Object], First[ref]];

	(* Resolve ImageType *)
	imageType = Which[
		!MatchQ[Lookup[safeOps, ImageType], Automatic],
			Lookup[safeOps, ImageType],
		!NullQ[inheritedImageType],
			inheritedImageType,
		True,
			BrightField
	];

	(* Throw an message if no image type is found *)
	If[!NullQ[inheritedImageType] && !MatchQ[imageType, inheritedImageType],
		Message[
			PlotImageExposure::ConflictingImageTypes,
			ECL`InternalUpload`ObjectToString[Download[myPacket, Object]],
			ToString[inheritedImageType],
			ToString[imageType]
		];
		Return[$Failed]
	];

	(* Extract Reference image data Object[Analysis,ImageExposure] *)
	(* Note: there should be only 1 reference image data per analysis, up to 1 optimal image per analysis *)
	inputImageFiles = Download[Analysis`Private`packetLookup[packet, ReferenceImages], Object];
	optimalImageFile = Download[Analysis`Private`packetLookup[packet, OptimalImage], Object];

	(* Throw an message if no image data is found *)
	If[MatchQ[inputImageFiles, Null|{}],
		Message[
			PlotImageExposure::ImageNotFound,
			ECL`InternalUpload`ObjectToString[Download[myPacket, Object]],
			ToString[imageType]
		];
		Return[$Failed]
	];

	inputExposureTimes = Analysis`Private`packetLookup[packet, ExposureTimes];
	images = ImportCloudFile[inputImageFiles];
	optimalOrSuggestExposureTime = If[!NullQ[optimalImageFile],
		Analysis`Private`packetLookup[packet, OptimalExposureTime],
		Analysis`Private`packetLookup[packet, SuggestedExposureTime]
	];
	optimalExposurePosition = If[MemberQ[inputExposureTimes, optimalOrSuggestExposureTime],
		Position[inputExposureTimes, optimalOrSuggestExposureTime][[1, 1]],
		Length[inputExposureTimes] + 1
	];

	imageSize = If[MatchQ[imageType, QPixImagingStrategiesP],
		Floor[400/Max[{1, ImageAspectRatio[First@images]}]],
		Medium
	];

	(* This preview is similar to AnalyzeImageExposure, just without the statistics tab. *)
	(* Image corresponding to optimal exposure time is framed with dark green frame *)
	(* AppHelpers`Private`makeGraphicSizeFull was used to pattern match in command center preview, remember to update the pattern accordingly if any changes made here. *)
	finalPlot = If[MatchQ[imageType, Lane],
		Grid[
			{
				{Style[refTitle, Bold], SpanFromLeft, SpanFromLeft},(*HoldPattern[{Style[___], ___}]*)
				{
					Grid[
						{
							inputExposureTimes,
							Show[#, ImageSize -> imageSize]& /@ images
						},
						Frame -> {None, None, {{1, optimalExposurePosition} -> True, {2, optimalExposurePosition} -> True}},
						FrameStyle -> Directive[Thickness[4], Darker[Green]]
					](*HoldPattern[Grid[{List[_Quantity], {_Graphics ..}}, ___]]*)
				},
				{Style["Optimal/Suggested Exposure Time " <> ToString[optimalOrSuggestExposureTime], Bold], SpanFromLeft, SpanFromLeft}
			}
		],
		Grid[
			{
				{Style[refTitle, Bold], SpanFromLeft, SpanFromLeft},
				{
					Grid[
						Transpose[{
							Flatten[{"Exposure Time", inputExposureTimes}],
							Flatten[{"Image", Show[#, ImageSize -> imageSize]& /@ images}]
						}],
						Frame -> {None, None, {{optimalExposurePosition+1, 1} -> True, {optimalExposurePosition+1, 2} -> True}},
						FrameStyle -> Directive[Thickness[4], Darker[Green]]
					](*HoldPattern[Grid[{{"Exposure Time","Image"}, {_Quantity, _Graphics}..}, ___]]*)
				},
				{Style["Optimal/Suggested Exposure Time " <> ToString[optimalOrSuggestExposureTime], Bold], SpanFromLeft, SpanFromLeft}
			},
			Frame -> {None, None}
		]
	];

	(* Return specified output *)
	output /.{
		Result -> finalPlot,
		Preview -> finalPlot,
		Tests -> {},
		Options -> safeOps
	}
];
