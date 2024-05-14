(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeCellCountOld*)

(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

microscopeInputObjectsP = {
	Object[Data, Microscope],
	Object[Data, ImageCells]
};

microscopeInputProtocolsP = {
	Object[Protocol, Microscope],
	Object[Protocol, ImageCells]
};

(* Different image adjustment functions that are supported *)
adjustImagePrimitiveP=Alternatives[HistogramTransform,ImageAdjust,ImageTake,BrightnessEqualize];

(* Different ROI detection functions that are supported *)
detectROIPrimitiveP=Alternatives[ImageLines,EdgeDetect,Erosion,Dilation];

(* Different object detection functions that are supported *)
detectObjectsPrimitiveP=Alternatives[GaussianFilter,GradientFilter,RangeFilter,EdgeDetect,Binarize,
	Closing,Dilation,FillingTransform
];

(* ------------------------------------- *)
(* --- Primitive Options Definitions --- *)
(* ------------------------------------- *)

(* -------------*)
(* Adjust Image *)
(* -------------*)

DefineOptionSet[
	adjustImagePrimitiveOptions:>{

		(* Brightness and contrast adjustment *)
		{
			OptionName->Function,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Single"->Widget[Type->Enumeration,Pattern:>adjustImagePrimitiveP],
				"Multiple"->Adder[
					Widget[Type->Enumeration,Pattern:>adjustImagePrimitiveP]
				]
			],
			Description->"The specific adjustment function to apply on the image. Note that the operations are applied according to the order specified.",
			ResolutionDescription->"If Automatic, a predetermined set of functions will be applied corresponding to the ImageType.",
			Category->"General"
		},
		{
			OptionName->Setting,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Single"->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,{},None]],
					Widget[Type->Number,Pattern:>GreaterEqualP[0]],
					Widget[Type->Expression,Pattern:>{GreaterEqualP[0],GreaterEqualP[0]},Size->Line]
				],
				"Multiple"->Adder[
					Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,{},None]],
						Widget[Type->Number,Pattern:>GreaterEqualP[0]],
						Widget[Type->Expression,Pattern:>{GreaterEqualP[0],GreaterEqualP[0]},Size->Line]
					]
				]
			],
			Description->"The setting according to which the image adjustment operation is performed. Note that the setting",
			ResolutionDescription->"If Automatic, a predetermined set of settings will be used for each of the image adjustment functions.",
			Category->"General"
		}

	}
];

(* Create a list of shared option names WITHOUT required share options *)
acquireImageRequiredSharedOptions={"Mode"};
acquireImageSharedOptions=UnsortedComplement[
	Options[acquireImagePrimitiveOptions][[All,1]],
	acquireImageRequiredSharedOptions
];

cellCountAdjustImagePrimitive=DefinePrimitive[AdjustImage,
	OutputUnitOperationParserFunction->None,
	FastTrack->True,

	SharedOptions:>{adjustImagePrimitiveOptions},

	(* TODO: write primitive resolver, change icon, check category, update description *)
	ExperimentFunction->Analysis`Private`resolveAdjustImagePrimitive,

	Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","AdjustImage.png"}]],

	(*InputOptions->{Mode},*)
	Generative->False,
	Category->"Sample Preparation",
	Description->"Adjust an image.",
	OutputUnitOperationParserFunction->None
];

(* Imaging Primitive Pattern *)
Clear[AdjustImagePrimitiveP];
DefinePrimitiveSet[
	AdjustImagePrimitiveP,
	{cellCountAdjustImagePrimitive}
];

(* -----------*)
(* Detect ROI *)
(* -----------*)
DefineOptionSet[
	detectROIPrimitiveOptions:>{

		{
			OptionName->Function,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Single"->Widget[Type->Enumeration,Pattern:>detectROIPrimitiveP],
				"Multiple"->Adder[
					Widget[Type->Enumeration,Pattern:>detectROIPrimitiveP]
				]
			],
			Description->"The functions to apply on the image to detect the region of interest (ROI). Note that the operations are applied according to the order specified.",
			ResolutionDescription->"If Automatic, a predetermined set of functions will be applied corresponding to the ImageType.",
			Category->"General"
		},
		{
			OptionName->Setting,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Single"->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,{},None]],
					Widget[Type->Number,Pattern:>GreaterEqualP[0]],
					Widget[Type->Expression,Pattern:>{GreaterEqualP[0],GreaterEqualP[0]},Size->Line]
				],
				"Multiple"->Adder[
					Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,{},None]],
						Widget[Type->Number,Pattern:>GreaterEqualP[0]],
						Widget[Type->Expression,Pattern:>{GreaterEqualP[0],GreaterEqualP[0]},Size->Line]
					]
				]
			],
			Description->"The setting according to which the detect objects operations are performed. Note that the setting",
			ResolutionDescription->"If Automatic, a predetermined set of settings will be used for each of the image adjustment functions.",
			Category->"General"
		},
		{
			OptionName -> HemocytometerSquareIndex,
			Default -> Automatic,
			Description -> "Specifies the index of the square in the hemocytometer with 9 squares with counting performed from left to right and top to bottom.",
			AllowNull ->False,
			Widget ->Alternatives[
				"Single Square" -> Widget[Type -> Enumeration, Pattern:>Alternatives@@Range[9]],
				"Multiple Squares" -> Adder[Widget[Type -> Enumeration, Pattern:>Alternatives@@Range[9]]]
			],
			Category -> "Hemocytometer Specifications"
		}

	}
];

(* Define the DetectROI primitive function *)
cellCountDetectROIPrimitive=DefinePrimitive[DetectROI,
	OutputUnitOperationParserFunction->None,
	FastTrack->True,

	SharedOptions:>{detectROIPrimitiveOptions},

	(* TODO: write primitive resolver, change icon, check category, update description *)
	ExperimentFunction->Analysis`Private`resolveDetectROIPrimitive,

	Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","DetectROI.png"}]],

	(*InputOptions->{Mode},*)
	Generative->False,
	Category->"Sample Preparation",
	Description->"Adjust an image.",
	OutputUnitOperationParserFunction->None
];

(* Imaging Primitive Pattern *)
Clear[DetectROIPrimitiveP];
DefinePrimitiveSet[
	DetectROIPrimitiveP,
	{cellCountDetectROIPrimitive}
];


(* ---------------*)
(* Detect Objects *)
(* ---------------*)
DefineOptionSet[
	detectObjectsPrimitiveOptions:>{

		{
			OptionName->Function,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Single"->Widget[Type->Enumeration,Pattern:>detectObjectsPrimitiveP],
				"Multiple"->Adder[
					Widget[Type->Enumeration,Pattern:>detectObjectsPrimitiveP]
				]
			],
			Description->"The functions to apply on the image to detect the objects. Note that the operations are applied according to the order specified.",
			ResolutionDescription->"If Automatic, a predetermined set of functions will be applied corresponding to the ImageType.",
			Category->"General"
		},
		{
			OptionName->Setting,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				"Single"->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,{},None]],
					Widget[Type->Number,Pattern:>GreaterEqualP[0]],
					Widget[Type->Expression,Pattern:>{GreaterEqualP[0],GreaterEqualP[0]},Size->Line]
				],
				"Multiple"->Adder[
					Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,{},None]],
						Widget[Type->Number,Pattern:>GreaterEqualP[0]],
						Widget[Type->Expression,Pattern:>{GreaterEqualP[0],GreaterEqualP[0]},Size->Line]
					]
				]
			],
			Description->"The setting according to which the detect objects operations are performed. Note that the setting",
			ResolutionDescription->"If Automatic, a predetermined set of settings will be used for each of the image adjustment functions.",
			Category->"General"
		}

	}
];


(* Define the DetectObjects primitive function *)
cellCountDetectObjectsPrimitive=DefinePrimitive[DetectObjects,
	OutputUnitOperationParserFunction->None,
	FastTrack->True,

	SharedOptions:>{detectObjectsPrimitiveOptions},

	(* TODO: write primitive resolver, change icon, check category, update description *)
	ExperimentFunction->Analysis`Private`resolveDetectObjectsPrimitive,

	Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","DetectROI.png"}]],

	(*InputOptions->{Mode},*)
	Generative->False,
	Category->"Sample Preparation",
	Description->"Adjust an image.",
	OutputUnitOperationParserFunction->None
];

(* Imaging Primitive Pattern *)
Clear[DetectObjectsPrimitiveP];
DefinePrimitiveSet[
	DetectObjectsPrimitiveP,
	{cellCountDetectObjectsPrimitive}
];


(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[AnalyzeCellCountOld,
	Options :> {

		(** Data Processing **)

		(* {ImageType -> "Automatic", "Automatic" | "Small sparse cells" | "Small dense cells" | "Lawn of cells" | "No cells", "Resolve the options according to the description."}, *)
		{
			OptionName -> CellLine,
			Default -> Automatic,
			Description -> "Indicates the method of data smoothing that is going to be applied to the data sets.",
			AllowNull ->False,
			Widget ->Alternatives[
				"Single Channel" -> Widget[Type -> Enumeration, Pattern:>Alternatives[{}]],
				"Multiple Channels" -> Adder[Widget[Type -> Enumeration, Pattern:>Alternatives[{}]]]
			],
			Category -> "Input Processing"
		},
		{
			OptionName -> ImageSource,
			Default -> Automatic,
			Description -> "Indicates the method of data smoothing that is going to be applied to the data sets.",
			AllowNull ->False,
			Widget ->Alternatives[
				"Single Channel" -> Widget[Type -> Enumeration, Pattern:>MicroscopeImagingChannelP],
				"Multiple Channels" -> Adder[Widget[Type -> Enumeration, Pattern:>MicroscopeImagingChannelP]]
			],
			Category -> "Input Processing"
		},
		{
			OptionName->ImageOverlay,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type -> Enumeration, Pattern:>BooleanP],
			Description->".",
			ResolutionDescription->".",
			Category->"Image Adjustment"
		},

		(** Image Adjustments **)
		(* CLAHE or BrightnessEqualize for uneven illumination *)
		(* {ImageAdjust -> False, True | False, "Normalizes the brightness of the image by scaling all the pixel intensities."}, *)
		{
			OptionName->ImageAdjustment,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Primitive,Pattern:>AdjustImagePrimitiveP],
				Adder[Widget[Type->Primitive,Pattern:>AdjustImagePrimitiveP]]
			],
			Description->"For each sample pool, a list of acquisition parameters used to image a sample. Each list of acquisition parameters corresponds to a single output image acquired from the input sample.",
			ResolutionDescription->"Automatically generates a unique image acquisition for each of the fluorophores present in the DetectionLabels Field of the sample's identity model. The value of acquisition parameters are determined from the Mode and the DetectionLabels of the sample's identity model.",
			Category->"Image Adjustment"
		},


		(** ROI Detection **)
		{
			OptionName->ROIDetection,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Primitive,Pattern:>DetectROIPrimitiveP],
				Adder[Widget[Type->Primitive,Pattern:>DetectROIPrimitiveP]]
			],
			Description->".",
			ResolutionDescription->".",
			Category->"Image Adjustment"
		},

		(** Object Detection **)
		{
			OptionName->ObjectDetection,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Primitive,Pattern:>DetectObjectsPrimitiveP],
				Adder[Widget[Type->Primitive,Pattern:>DetectObjectsPrimitiveP]]
			],
			Description->".",
			ResolutionDescription->".",
			Category->"Image Adjustment"
		},
		(* {GaussianFilter -> False, False | GreaterEqualP[0], "The pixel radius for the GaussianFilter image processing step. If False, GaussianFilter is not applied to the image."},
		{GradientFilter -> False, False | GreaterEqualP[0], "The pixel radius for the GradientFilter image processing step. If False, GradientFilter is not applied to the image."},
		{RangeFilter -> False, False | GreaterEqualP[0], "The pixel radius for the RangeFilter image processing step. If False, RangeFilter is not applied to the image."},
		{EdgeDetect -> 1, False | GreaterEqualP[0], "The pixel radius for the EdgeDetect image processing step. If False, EdgeDetect is not applied to the image."},
		{Binarize -> False, False | GreaterEqualP[0], "The threshold for the Binarize image processing step. If False, Binarize is not applied to the image."},
		{Closing -> 2, False | GreaterEqualP[0], "The pixel radius to be using in the Closing image processing step. If False, Closing is not applied to the image."},
		{Dilation -> False, False | GreaterEqualP[0], "The pixel radius to be using in the Dilation image processing step. If False, Dilation is not applied to the image."},
		{FillingTransform -> True, True | False, "If True, fills in small holes in the morphological components."},
		{ColorNegate -> False, True | False, "If true, negates all the color values in the image. This is equivalent to swapping black and white in a greyscale image."}, *)

		(** Component Detection **)
		{ComponentThreshold -> 0.5, _, "Threshold value for the Morphogolical components image processing step. All pixel values above the threshold are treated as foreground."},
		{MorphologicalComponentsMethod -> "Connected", "Connected" | "Convex" | "ConvexHull", "The method used by MorphologicalComponents to find connected components in the image."},
		{MinComponentArea -> Automatic, Automatic | _, "All conncected components with area below this value are excluded. If Automatic, area is determined based on the dimensions of the image."},
		{MinComponentBrightness -> 0, GreaterEqualP[0], "All conncected components whose maximum intensity is below this value are excluded."},
		{MinCellRadius -> Automatic, Automatic | GreaterEqualP[0], "Minimum radius in pixels of a single cell in the image. Automatic defaults to 1 percentage of image size."},
		{MaxCellRadius -> Automatic, Automatic | GreaterEqualP[0], "Maximum radius in pixels of a single cell in the image. Automatic defaults to 2.5 percentage of image size."},

		(* {ImageSource -> Automatic, ListableP[ImageTypeP] | Automatic, "The image in a microcsope data that this analysis corresponds to."}, *)

		(** Output Processing **)
		{Output -> CellCount, Packet | Object | FieldP[Object[Analysis, CellCount],Output->Short] | {FieldP[Object[Analysis, CellCount],Output->Short]..}, "Determines which field(s) are returned by the function."},
		{Options -> Null, Null | ObjectP[Object[Analysis, CellCount]], "Use ResolvedOptions in given object for default option resolution in current analysis."},
		{Upload->True,BooleanP,"Upload result to database.",Category->Hidden},
		{OutputAll->False,BooleanP,"If True, also returns any other objects that were created or modified.",Category->Hidden},
		{ApplyAll->False,BooleanP,"If True, applies first set of resolved options to all remaining data sets.",Category->Hidden},

		(** App Specifications **)
		{App -> False, BooleanP, "If app is true an interactive app will be launched."},
		{AppTest->False,BooleanP|Null|Cancel|Skip|Return,"If True, bypasses app, used for testing app buttons.",Category->Hidden},
		{Index->{1,1},_,"Current evaluation index, used for monitoring position in list input for app display.",Category->Hidden},
		{Scale -> Null, _, "Scaling factor to be applied to the cell image.", Category->Hidden}
	}
];


(* ------------------------------------- *)
(* --- Warning and Error Definitions --- *)
(* ------------------------------------- *)


AnalyzeCellCountOld::ConflictingOptions="Specified MinCellRadius `1` is greater than specified MaxCellRadius `2`. Defaulting the values to 1 percentage and 2.5 percentage ofimage size.";
AnalyzeCellCountOld::IgnoreInvaildImageSource="One or more specified ImageSource is not available in the input object. Analysis will be done on the available ImageSource.";
AnalyzeCellCountOld::NoAvailableImage="There is no available image in the input object";
AnalyzeCellCountOld::NoAvailableImageMatchesImageSource="There is no available image in the input object that matches the specified ImageSource. ImageSource is defaulted to Automatic and analysis will be done on all available images in the input object.";


(* ::Subsubsection::Closed:: *)
(*AnalyzeCellCount*)

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)

(* Single protocol object overload *)
AnalyzeCellCountOld[
	prot: ObjectP[microscopeInputProtocolsP],
	ops: OptionsPattern[AnalyzeCellCountOld]
]:= AnalyzeCellCountOld[Cases[Download[prot, Data], ObjectP[microscopeInputObjectsP]], ops];

(* Multiple data objects overload *)
AnalyzeCellCountOld[
	inList: {(ObjectP[microscopeInputObjectsP])..},
	ops: OptionsPattern[AnalyzeCellCountOld]
]:= Catch[Module[
	{nextOps, wrapper, out},
	nextOps = {ops};
	wrapper[singleton_, index_] := Module[
		{tempOut, preOps},

		(* Checks for XTT ? - sets the Upload->False *)
		(* tempOut = Quiet @ Check[
			analyzeCellCount[singleton, Sequence @@ DeleteDuplicatesBy[Join[{Index -> index, App -> False, Upload -> False}, nextOps], First]],
			"XTT"
		]; *)

		tempOut = If[MatchQ[tempOut, "XTT"],
			analyzeCellCount[singleton, ops, Index -> index],
			If[MatchQ[Lookup[nextOps,{App,Upload}],{False,False}],
				tempOut,
				analyzeCellCount[singleton, Sequence @@ DeleteDuplicatesBy[Join[{Index -> index}, nextOps], First]]
			]
		];

		If[MatchQ[tempOut, $Failed | $Canceled], Throw[tempOut, "ExitFlag"]; Return[tempOut]];
		If[MatchQ[tempOut, Null], Return[tempOut]];
		preOps = Lookup[First[tempOut], ResolvedOptions];
		nextOps = If[MatchQ[Lookup[preOps, ApplyAll], True], preOps, {ops}];
		finalReturnNew[tempOut, {}, {}, Lookup[preOps, Output], False]
	];

	out = Map[
		wrapper[inList[[#]], {#, Length[inList]}]&,
		Range[Length[inList]]
	];

	If[MatchQ[Length[out], 1] && MatchQ[Length[First[out]], 1], First[out], out]
], "ExitFlag"];

(* Single data object overload *)
AnalyzeCellCountOld[
	inList: ObjectP[microscopeInputObjectsP],
	ops: OptionsPattern[AnalyzeCellCountOld]
]:= Catch[
	With[
		{tempOut = AnalyzeCellCountOld[{inList}, ops]},
		If[MatchQ[tempOut, Null | $Failed | $Canceled],
			Throw[tempOut, "ExitFlag"],
			First[tempOut]
		]
	], "ExitFlag"
];

analyzeCellCount[in: (ObjectP[microscopeInputObjectsP]), ops: OptionsPattern[AnalyzeCellCountOld]] := Module[
	{standardFieldsStart, relationFields, imgList, resolvedOpsList, ccList, out},

	standardFieldsStart = analysisPacketStandardFieldsStart[{ops}];

	(*** Input and Option Resolution ***)

	With[{parsedPara = resolveAnalyzeCellCountInputsAndOptions[in, {ops}]},
		If[MatchQ[parsedPara, Null | $Canceled],
			Return[parsedPara],
			{relationFields, imgList, resolvedOpsList} = parsedPara
		]
	];

	(*** Image Adjustment - ROI Detection - Object Detection ***)

	ccList = MapThread[analyzeCellCountCore[#1, #2] &, {imgList, resolvedOpsList}];

	(*** Format Packet ***)

	out = MapThread[formatCellCountPacket[#1, standardFieldsStart, relationFields, #2] &, {ccList, resolvedOpsList}];

	First /@ out
];


(* ::Subsubsection:: *)
(*analyzeCellCountCore*)


analyzeCellCountCore[img_Image, resolvedOps_List] := Module[
	{processedImage, componentsPacket, cellCountPacket, componentsPacketClean, out},

	(** Adjust the image brightness and contrast: **)
	adjustedImage = adjustImage[img, resolvedOps];
	Echo[Image[adjustedImage,ImageSize->300]];
	(** Processing the image: **)
	processedImage = processMicroscopeImage[adjustedImage, resolvedOps];

	(** Finding the components **)
	componentsPacket = morphologicalComponentAnalysis[processedImage, Association[resolvedOps]];

	(** Preparing the cell count packet **)
	cellCountPacket = countCellsFromComponents[Total[Lookup[componentsPacket, ComponentAreas]], Association[resolvedOps]];

	(* turn {} into {Null}, because that's what Upload wants *)
	componentsPacketClean = Replace[
		componentsPacket,
		Rule[ComponentAreas, {}] -> Rule[ComponentAreas, {Null}],
		{1}
	];

	out = Join[componentsPacketClean, cellCountPacket];
	out
];

(* ::Subsubsection:: *)
(*countCellsFromComponents*)

countCellsFromComponents[compArea_,soa_Association]:=Module[{minA,maxA,singleCellArea,statPacket,cellCount,cellCountUncertainty},
	{minA,maxA} = N@Pi*{soa[MinCellRadius],soa[MaxCellRadius]}^2;
	singleCellArea = N@Mean[{minA,maxA}];
	statPacket = PropagateUncertainty[
		TotalArea/SingleCellArea,
		{TotalArea->compArea,SingleCellArea\[Distributed]NormalDistribution[singleCellArea,(maxA-singleCellArea)/3.]},
		Method->Parametric,
		Output->All
	];
	{cellCount,cellCountUncertainty} = Lookup[statPacket,{Mean,StandardDeviation}];
	{
		CellCount->cellCount,
		CellCountStandardDeviation->cellCountUncertainty,
		CellCountDistribution->NormalDistribution[cellCount,cellCountUncertainty],
		AverageSingleCellArea->singleCellArea
	}
];


(* ::Subsubsection::Closed:: *)
(*formatCellCountPacket*)


(* Helper function to format the final cell count packet *)
formatCellCountPacket[cc_, standardFieldsStart_, relationFields_, resolvedOps_] := Module[
	{packet},

	packet = Association[Join[{Type -> Object[Analysis, CellCount]},
			Normal[KeyDrop[cc,ComponentAreas]],
			standardFieldsStart,
			{
				Replace[ComponentAreas]->Lookup[cc,ComponentAreas],
				ResolvedOptions -> resolvedOps,
				Append[Reference] -> Lookup[relationFields, Reference],
				(*Append[CellsCounted] -> (Lookup[relationFields, Sample] /. {Null} -> {}),*)
				ImageSource -> Lookup[resolvedOps, ImageSource]
			}
		]
	];

	insertAndUpdateAnalyzePackets[packet, {}, {}, Lookup[resolvedOps, Upload]]

];


(* ::Subsubsection::Closed:: *)
(*Sample count calculations*)


updateCellSamplesWithTotalCount[sampleCountAssocs:{_Association..},informBool:False]:=Null;
updateCellSamplesWithTotalCount[sampleCountAssocs:{_Association..},informBool:True]:=Module[{informUpdateArg},

	informUpdateArg=Map[
			#[Sample]->{
				CellCount->Round[#[MeanSampleCount]],
				CellCountLog -> {{DateObject[], Round[#[MeanSampleCount]], #[Analysis]}}
			}&,
			sampleCountAssocs
		];

	informUpdateArg = DeleteCases[informUpdateArg,Rule[Null,_]];

	Upload[Association[informUpdateArg]];
];


updateCellCountAnalysesWithTotalCount[countPackets:{{PacketP[Object[Analysis,CellCount]]..}..},sampleCountAssocs_]:=Module[
	{updatedCountPackets,dataCountRules,sampleCountRules},
(*	dataCountRules = sampleCountAssocToDataCountRules[sampleCountAssocs];*)
(*	updatedCountPackets = Map[ReplaceRule[#,SampleCellCount->packetTotalSampleCount[#,dataCountRules]]&,countPackets,{2}];*)
	sampleCountRules=sampleCountAssocToSampleCountRules[sampleCountAssocs];
	updatedCountPackets = Map[ReplaceRule[#,SampleCellCount->packetTotalSampleCount[#,sampleCountRules]]&,countPackets,{2}];
	updatedCountPackets

];

updateCellCountAnalysesWithTotalCount[countObjects:{{ObjectP[Object[Analysis, CellCount]]..}..},sampleCountAssocs_]:=Module[
	{sampleCountRules,informUpdateCalls,updatedCountObjects},
	sampleCountRules=sampleCountAssocToSampleCountRules[sampleCountAssocs];

	informUpdateCalls = Flatten[Map[#->{SampleCellCount->packetTotalSampleCount[Download[#],sampleCountRules]}&,countObjects,{2}]];

	updatedCountObjects = Upload[Association[informUpdateCalls]];

	countObjects

];


	(* get a list of rules that looks like: {data[1,Microscope]\[Rule]123, data[2,Microscope]\[Rule]525, ...}  *)
sampleCountAssocToDataCountRules[sampleCountAssocs:{_Association..}]:=Flatten[Map[Thread[Rule[Data,MeanSampleCount]/.#]&,sampleCountAssocs]];

sampleCountAssocToSampleCountRules[sampleCountAssocs:{_Association..}]:=Rule[Sample,MeanSampleCount]/.sampleCountAssocs;


(* find the total sample count for this analysis packet by looking up the data *)
(*packetTotalSampleCount[packet:PacketP[analysis[CellCount]],countRules_]:=packetTotalSampleCount[Lookup[packet,Reference],countRules];*)
(*packetTotalSampleCount[packet:PacketP[Object[Analysis,CellCount]],countRules_]:=packetTotalSampleCount[Lookup[packet,CellsCounted],countRules];*)
packetTotalSampleCount[{obj:ObjectP[Object[Sample]]},countRules_]:=Lookup[countRules,obj];
(*packetTotalSampleCount[{obj:ObjectP[Object[Data, Microscope]]},countRules_]:=Lookup[countRules,obj];*)
packetTotalSampleCount[{Null},_]:=Null;


(* ------------------------------------- *)
(* --- Inputs and Options Resolution --- *)
(* ------------------------------------- *)


(* ::Subsection::Closed:: *)
(*Resolution*)


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCellCountInputsAndOptions*)

(* For Microscope data object the fields to download are as follows *)
(* resolveAnalyzeCellCountInputsAndOptions[
	obj: Except[PacketP[Object[Data,Microscope]],ObjectP[Object[Data,Microscope]]],
	ops0_List
]:=resolveAnalyzeCellCountInputsAndOptions[Download[obj, Packet[Scale, Objective, SamplesIn, Protocol, PhaseContrastImage, FluorescenceImage, SecondaryFluorescenceImage, TertiaryFluorescenceImage]], ops0]; *)

(* For ImageCells data object the fields to download are as follows *)
resolveAnalyzeCellCountInputsAndOptions[
	obj: Except[PacketP[Object[Data,ImageCells]],ObjectP[Object[Data,ImageCells]]],
	ops0_List
]:=resolveAnalyzeCellCountInputsAndOptions[
	Download[obj, Packet[
		ImageSizeX,ImageSizeY,
		ImageScaleX,ImageScaleY,
		WellCenterOffsetX,WellCenterOffsetY,
		ImagingChannels,ImageFiles,ExposureTimes,TransmittedLightPowers]
	], ops0
];

(* For ImageCells data object the fields to download are as follows *)
resolveAnalyzeCellCountInputsAndOptions[
	obj: Except[PacketP[Object[Data,Microscope]],ObjectP[Object[Data,Microscope]]],
	ops0_List
]:=resolveAnalyzeCellCountInputsAndOptions[
	Download[obj, Packet[
		ImageSizeX,ImageSizeY,
		ImageScaleX,ImageScaleY,
		WellCenterOffsetX,WellCenterOffsetY,
		ImagingChannels,ImageFiles,ExposureTimes,TransmittedLightPowers]
	], ops0
];


resolveAnalyzeCellCountInputsAndOptions[obj: Except[PacketP[microscopeInputObjectsP],ObjectP[microscopeInputObjectsP]], ops0_List] := resolveAnalyzeCellCountInputsAndOptions[Download[obj, Packet[Scale, ObjectiveMagnification, SamplesIn, Protocol, PhaseContrastImage, FluorescenceImage, SecondaryFluorescenceImage, TertiaryFluorescenceImage]], ops0];
resolveAnalyzeCellCountInputsAndOptions[info: PacketP[microscopeInputObjectsP], ops0_List] := Module[
	{
		safeOps, cellSize, availImgList, matchedImgList, relationFields, resolvedOpsList, tempOut, custom

	},

	(** NOTE: first we resolve the ImageType option and pass it to resolveAnalyzeCellCountInput to resolve inputs **)

	(* Resolve ImageType option *)
	{safeOps, custom} = resolveAnalyzeCellCountImageTypeOption[info,ops0];

	(* Call SafeOptions to make sure all options match pattern *)
	safeOps = ReplaceRule[safeOps, {Scale -> Lookup[info, Scale]}];

	(* Resolve the inputs based on safeOps *)
	With[{parsedInput = resolveAnalyzeCellCountInput[info, safeOps]},
		If[MatchQ[parsedInput, Null],
			Return[Null],
			availImgList = parsedInput
		]
	];

	(* Resolve ObjectiveMagnification *)
	cellSize = If[NumericQ[Lookup[info, ObjectiveMagnification]], Lookup[info, ObjectiveMagnification], 10];

	(* Resolve the image channels and associated image files *)
	matchedImgList = resolveAnalyzeCellCountImageType[Lookup[safeOps, ImageSource], availImgList];

	(* Mapping the option list for the list of images *)
	resolvedOpsList = Map[resolveAnalyzeCellCountOneImageOptions[#[[1]], #[[2]], safeOps, custom, cellSize] &, matchedImgList];

	tempOut = Cases[Transpose[{matchedImgList, resolvedOpsList}], {_, _List}];

	If[MatchQ[tempOut, {}], Return[$Canceled]];
	{matchedImgList, resolvedOpsList} = Transpose[tempOut];

	relationFields = resolveAnalyzeCellCountRelationFields[info];

	{relationFields, Map[Last, matchedImgList], resolvedOpsList}
];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCellCountInput*)


resolveAnalyzeCellCountInput[info_, safeOps_] := Module[
	{availableImageList, imgType, imageList},

	(* Taking the image type *)
	(* availableImageList = DeleteCases[Transpose[{{PhaseContrastImage, FluorescenceImage, SecondaryFluorescenceImage, TertiaryFluorescenceImage}, Lookup[info, {PhaseContrastImage, FluorescenceImage, SecondaryFluorescenceImage, TertiaryFluorescenceImage}]}], {_, Null}]; *)

	availableImageList = DeleteCases[Transpose[{Lookup[info, ImagingChannels], ImportCloudFile@Lookup[info, ImageFiles]}], {_, Null}];
	If[MatchQ[availableImageList, {}], Message[AnalyzeCellCountOld::NoAvailableImage]; Return[Null]];

	availableImageList
];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCellCountImageType*)

(* If Automatic, take whatever is given in the ImagingChannels *)
resolveAnalyzeCellCountImageType[Automatic, availImgList_] := availImgList;

(* If a specific channel are selected only include that in the image source *)
resolveAnalyzeCellCountImageType[imgType: MicroscopeImagingChannelP, availImgList_] := resolveAnalyzeCellCountImageType[{imgType}, availImgList];

(* If multiple specific channels are selected only include those in the image source *)
resolveAnalyzeCellCountImageType[imgType: {MicroscopeImagingChannelP..}, availImgList_] := Module[
	{availDict, matchedList},

	availDict = Map[#[[1]] -> #[[2]] &, availImgList];
	matchedList = Cases[Map[{#, Lookup[availDict, #]} &, imgType], {_, _Image}];

	If[MatchQ[matchedList, {}], Message[AnalyzeCellCountOld::NoAvailableImageMatchesImageSource]; Return[availImgList]];
	If[Length[matchedList] < Length[imgType], Message[AnalyzeCellCountOld::IgnoreInvaildImageSource]];
	matchedList
];


(* ::Subsubsection:: *)
(*resolveAnalyzeCellCountRelationFields*)


resolveAnalyzeCellCountRelationFields[info_] := Module[
	{obj, outList},
	obj = Lookup[info ,Object];
	outList = {
		Reference -> {Link[obj, CellCountAnalyses]},
		Sample -> cellSampleFromMicroscopeData[obj],
		Protocol -> microscopeProtocolAnalysisRelationFromMicroscopeData[obj]
	}
];


cellSampleFromMicroscopeData[data: PacketP[Object[Data, Microscope]]]:=Flatten[Map[cellSampleFromMicroscopeData,Cases[Lookup[data, SamplesIn],Link[ObjectP[Object[Sample]], ___]|Null]]];
cellSampleFromMicroscopeData[sample:ObjectReferenceP[Object[Sample]]]:={Link[sample,CellCountAnalyses]};
cellSampleFromMicroscopeData[other_]:={Null};


microscopeProtocolAnalysisRelationFromMicroscopeData[data:PacketP[data[Microscope]]]:=microscopeProtocolAnalysisRelationFromMicroscopeData[Lookup[data,Protocol]];
microscopeProtocolAnalysisRelationFromMicroscopeData[prot:ObjectReferenceP[Object[Protocol, Microscope]]]:={Link[prot,Analysis]};
microscopeProtocolAnalysisRelationFromMicroscopeData[other_]:={Null};


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCellCountOneImageOptions*)


resolveAnalyzeCellCountOneImageOptions[imgType_, img_, safeOps_, custom_, cellSize_] := Module[
	{dims, minRad, maxRad, resolvedOps},

	dims = ImageDimensions[img];

	{minRad, maxRad} = resolveAnalyzeCellCountMinMaxRadius[cellSize, Lookup[safeOps, {MinCellRadius, MaxCellRadius}]];

	resolvedOps = ReplaceRule[safeOps, {
		ImageSource -> imgType,
		MinCellRadius -> minRad,
		MaxCellRadius -> maxRad,
		MinComponentArea -> resolveAnalyzeCellCountMinComponentArea[dims, Lookup[safeOps, MinComponentArea]]
	}];

	If[TrueQ[Lookup[resolvedOps, App]],
		resolvedOps = resolveCellCountOptionsApp[img, custom, Sequence @@ resolvedOps];
	];

	(* Skip or Cancel button *)
	If[MatchQ[resolvedOps, Except[_List]],
		Return[resolvedOps]
	];

	(* clean up ops before they are put into packet *)
	resolvedOps = DeleteDuplicatesBy[resolvedOps, First];

	resolvedOps
];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCellCountMinMaxRadius*)


resolveAnalyzeCellCountMinMaxRadius[cellSize_, {valMin: Automatic, valMax: Automatic}] := cellSize * {0.5, 1.5};
resolveAnalyzeCellCountMinMaxRadius[cellSize_, {valMin_, valMax: Automatic}] := {valMin, cellSize * 1.5};
resolveAnalyzeCellCountMinMaxRadius[cellSize_, {valMin: Automatic, valMax_}] := {cellSize * 0.5, valMax};
resolveAnalyzeCellCountMinMaxRadius[cellSize_, {valMin_, valMax_}] := If[
	valMin>valMax,
	(
		Message[AnalyzeCellCountOld::ConflictingOptions, valMin, valMax];
		cellSize * {0.5, 1.5}
	),
	{valMin,valMax}
];


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCellCountMinComponentArea*)


resolveAnalyzeCellCountMinComponentArea[dims_List, val: Automatic] := Times @@ dims * 0.00001;
resolveAnalyzeCellCountMinComponentArea[dims_List, val_] := val;


(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCellCountImageTypeOption*)



(* Resolving the ImageType option and the options that are dependent on the image type *)
resolveAnalyzeCellCountImageTypeOption[myPacket_,ops0_List] := Module[
	{
		safeOps, userRules, options, beforeUser, afterUser, custom,

		(* *)
		resolvedImageAdjustment
	},


	safeOps = safeAnalyzeOptions[AnalyzeCellCountOld, ops0];

	userRules = ReplaceRule[ops0, safeOps,Append->False];

	options = Lookup[safeOps, ImageType];


	(* Resolving ImageAdjustment primitive *)

	resolvedImageAdjustment=resolveAdjustImagePrimitive[myPacket,safeOps];

	(* Setting the default values for object detection based on the image type option *)
	beforeUser=Switch[options,
		"Automatic", safeOps,
		"Small sparse cells", SafeOptions[AnalyzeCellCountOld, {EdgeDetect->0.5,Dilation->False, GradientFilter -> 1, Closing -> 1, ImageAdjust -> True}],
		"Small dense cells", SafeOptions[AnalyzeCellCountOld, {FillingTransform->False}],
		"Lawn of cells", SafeOptions[AnalyzeCellCountOld, {EdgeDetect->False}],
		"No cells", SafeOptions[AnalyzeCellCountOld, {EdgeDetect->False}]
	];

	(* Replacing the default values if the user has specified any of the options *)
	afterUser = ReplaceRule[beforeUser,
		Join[{ImageAdjustment->resolvedImageAdjustment},userRules],
		Append->False
	];

	custom = If[MatchQ[Sort[beforeUser], Sort[afterUser]], False, True];

	{
		afterUser,
		custom
	}
];









(* ::Subsection::Closed:: *)
(*Image Processing*)



(* ::Subsubsection::Closed:: *)
(*Parameters*)

(** NOTE: looks like this is only used for the app **)
processingStepsWithRanges={
	{{GaussianFilter,{0,6,1}}, "Convolve a Gaussian kernel"},
		 (* these are too slow *)
	(*	{CurvatureFlowFilter,{1,10,1}},*)
	(*	{TotalVariationFilter},*)

	(*	{KuwaharaFilter,{0,10,1}},*)
	{{GradientFilter,{0,6,1}}, "Compute magnitude of gradient to emphasize the boundary"},
	{{RangeFilter,{0,10,1}}, "Replace pixel by difference of max and min in range"},
	{{EdgeDetect,{0,10,.01}}, "Turn image into binary with edges only"},
	{{Closing,{0,10,1}}, "Morphological closing with a square"},
	{{Dilation,{0,10,1}}, "Morphological dilation with a square"},
	{{Binarize,{0,1,.01}}, "Set pixel above threshold to 1 and pixel below threshold to 0"},
	{{FillingTransform}, "Fill in extended minima"},
	{{ColorNegate}, "Negate all colors"},
	{{ImageAdjust}, "Rescale image to cover the range 0 to 1"}
};







(* ::Subsubsection::Closed:: *)
(*Image Adjustment*)


(* ------------------------ *)
(* --- Image Adjustment --- *)
(* ------------------------ *)

(* This helper function applies the image adjustment steps in the order specidied *)
adjustImage[image_Image,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{
		imageAdjustmentOption,functions,settings,imageAdjustmentPrimitives,allPrimitiveFunctionSets
	},

	(* Finding the image adjustment in the resolved option - Convert to association for better handling *)
  imageAdjustmentOption=Lookup[resolvedOptions,ImageAdjustment];

  (* Finding the image adjustment in the resolved option - Convert to association for better handling *)
  imageAdjustmentPrimitives=Map[
    Apply[Association,#]&,
    ToList@imageAdjustmentOption
  ];

	(* First map over multiple primitives and place all of the operations in a list *)
	allPrimitiveFunctionSets=Flatten[
		Map[
			Function[
				imageAdjustmentPrimitive,
				Transpose[{Lookup[imageAdjustmentPrimitive,Function], Lookup[imageAdjustmentPrimitive,Setting]}]
			],
			imageAdjustmentPrimitives
		],1
	];

	(* Perform each adjustment operation according to the setting specified *)
	Fold[runOneAdjustmentStep[#1,#2[[1]],#2[[2]]]&,image,allPrimitiveFunctionSets]

];

(* No setting has been specified *)
runOneAdjustmentStep[img_Image,s_Symbol,{}|None]:= s[img];

(* If any settings has been utilized *)
runOneAdjustmentStep[img_Image,s_Symbol,val_]:= s[img,val];



(* ::Subsubsection::Closed:: *)
(*components*)


morphologicalComponentAnalysis[img_,soa_Association]:=Module[
	{comps,compArea,compAreas,confluency,numComponents},
	(* find components using processed image *)
	comps = MorphologicalComponents[img,soa[ComponentThreshold],Method->soa[MorphologicalComponentsMethod]];

	(* delete small components *)
	(*comps = If[deleteSmallCompsBool,DeleteSmallComponents[comps],comps];*)
	(* filter by area constraint *)
	comps = SelectComponents[comps,"Area",#>soa[MinComponentArea]&];

	(* filter by brightness constraint *)
	comps = selectBrightComponents[img,comps,soa[MinComponentBrightness]];

	(* filter by component circularity *)
	(*	comps = SelectComponents[comps,"Circularity",#>circularity&];*)
	compAreas = ComponentMeasurements[comps,"Area"][[;;,2]];
	compArea = Total[compAreas];
	numComponents = Length[ComponentMeasurements[comps,"Count"]];

	(* compute confluency -- percent of image that is components *)
	confluency = N[compArea/Times@@ImageDimensions[img] * 100] * Percent;
	(* return  *)
	{Components->comps,ComponentAreas->compAreas,Confluency->confluency}
];

selectBrightComponents[img_,comps_,brightnessThreshold_]:=Module[{brightLabels},
	brightLabels=ComponentMeasurements[{comps,img},"MaxIntensity",#>brightnessThreshold&][[;;,1]];
	SelectComponents[comps,"Label",MemberQ[brightLabels,#]&]
];








(* ::Subsubsection::Closed:: *)
(*processMicroscopeImage*)


processMicroscopeImage[image_,opsList_List]:=Module[{steps},

	steps = {GaussianFilter, GradientFilter, RangeFilter, EdgeDetect, Closing, Dilation, Binarize, FillingTransform, ColorNegate, ImageAdjust};

	processMicroscopeImage[image,steps,opsList]

];

processMicroscopeImage[image_,steps_List,opsList_List]:=Module[{},
	Fold[runOneProcessingStep[#1,#2,Lookup[opsList,#2]]&,image,steps]
];


runOneProcessingStep[img_,s_Symbol,False]:= img;
runOneProcessingStep[img_,s_Symbol,True]:= s[img];
runOneProcessingStep[img_,s_Symbol,val_]:= s[img,val];


(* ::Subsection::Closed:: *)
(*Cell Image Plotting*)


(* ::Subsubsection::Closed:: *)
(*plot*)


showCellImage[img0_,img_,comps_,cellSizeGraphic_,componentSizeGraphic_,scale:(Null|UnitsP[Pixel/Micron]),soa_Association]:=Module[{fig,scaleEpilog},

		(* put highlights on original image *)
		fig = Switch[soa[PrimaryImage],
			"Original",img0,
			"Processed",img
		];

		scaleEpilog = imageScaleEpilog[fig,scale];


		(*fig = Show[fig,ImageSize->soa[ImageSize]];*)
		fig=Switch[soa[ImageOverlay],
			"Cell Highlights", HighlightImage[fig,Image[comps]],
			"Components", ImageMultiply[fig,Colorize[comps]],
			"None", fig
		];

		(*fig = Show[fig,cellSizeGraphic,componentSizeGraphic];*)
	(*	fig = DynamicImage[fig,Epilog\[Rule]{First@cellSizeGraphic,First@componentSizeGraphic},ImageSize\[Rule]500,AppearanceElements\[Rule]{"Zoombars","ZoomButtons","BirdseyeView","Pan","Zoom"}];*)

	(* need this 'With' b/c DynamicImage is HoldAllComplete *)
		With[{fig=fig},
			DynamicImage[
				fig,
				Epilog->{First@cellSizeGraphic,First@componentSizeGraphic,scaleEpilog},
				ImageSize->soa[ImageSize],
				AppearanceElements->{"Zoombars","ZoomButtons","BirdseyeView","Pan","Zoom"}
			]
		]
	];


(* ::Subsubsection::Closed:: *)
(*imageScaleEpilog*)


imageScaleEpilog[img_Image,scale:Null]:={};
imageScaleEpilog[img_Image,scale:UnitsP[Pixel/Micron]]:=Module[
	{w,h,imgBarSizePixels,imagBarSizeDistance,imgBarSizeDistance,color,
	imgBarSizeDistanceRounded,imgBarSizePixelsRounded,barHeight,barStartX,barStopX,
	barCoords,leftVertBar,rightVertBar,textCoords},
	{w,h}=ImageDimensions[img];
	imgBarSizePixels = Round[w/5.];
	imgBarSizeDistance = UnitScale[imgBarSizePixels*Pixel /scale];
	imgBarSizeDistanceRounded = Round[imgBarSizeDistance,100*Units[imgBarSizeDistance]];
	imgBarSizePixelsRounded = Unitless[Round[imgBarSizeDistanceRounded*scale],Pixel];
	barHeight = h/8.;
	barStartX=w/8.;
	barStopX=barStartX+imgBarSizePixelsRounded;
	barCoords = {{barStartX,barHeight},{barStopX,barHeight}};
	leftVertBar = {{barStartX,barHeight*0.925},{barStartX,barHeight*1.075}};
	rightVertBar = {{barStopX,barHeight*0.925},{barStopX,barHeight*1.075}};
	textCoords = {Mean[{barStartX,barStopX}],barHeight};
	color = If[Mean[PixelValue[ColorConvert[img,"Grayscale"],Map[{#,barHeight}&,Subdivide[barStartX,barStopX,10]]]]>0.5,
		Black,
		White
	];
	{
		(* lines *)
		{Thickness[0.005],color,Line[barCoords],Line[leftVertBar],Line[rightVertBar]},
		(* text above line *)
		Style[Text[imgBarSizeDistanceRounded,textCoords,{0,-1}],Bold,color,FontSize->Scaled[0.05]]
	}
];


(* ::Subsection::Closed:: *)
(*Option Resolution App*)


(* ::Subsubsection::Closed:: *)
(*resolveCellCountOptionsApp*)


resolveCellCountOptionsApp[img00_,custom_,ops:OptionsPattern[AnalyzeCellCountOld]]:=Module[{
		img0,img,comps,var,steps,updateFinalImage,cellCountPanel,statPacket,
		imgSize,uniformGrid=False,controlWidth=300,
		updateImage,updateComponents,cellTab, componentsTab,
		compMethod,compVal,minCompArea,highlight,minCompBrightness,
		cellSizeCenter,componentSizeCenter,minCellRad,maxCellRad,showComp=True,deleteSmallCompsBool=False,
		cellCountControls,compAreas,minA,maxA,circularity=1,
		edgeDetectBool,processedTab,cellSizeGraphic,componentSizeGraphic,
		cellCount,singleCellArea,finalControls,imageType,
		radMin,radMax,imgDims,cellCountUncertainty,
		whichImage,whichOverlay,imgFinal,showSize,scaleVal,
		primaryControlsBasic,primaryControlsAdvanced,filterControlsBasic,filterControlsAdvanced,allControls,
		opsAssoc,confluency,updateCellCount,displayControlPanel,
		appSize,imagePanelSize,controlPanelSize,outputPanelSize,resuedOps,
		headingItem,update4F,update3F,outputOptions,valFromVar,valFromStep,
		componentsPacket,cellCountPacket,initializeSliders,compAreaManipulator
	},

	{compVal,compMethod,minCompArea} = OptionValue[{ComponentThreshold,MorphologicalComponentsMethod,MinComponentArea}];

	{minCompBrightness,minCellRad,maxCellRad} = OptionValue[{MinComponentBrightness,MinCellRadius,MaxCellRadius}];

	imgSize = ImageDimensions[img00];
	whichImage = "Original";
	whichOverlay = "Cell Highlights";
	scaleVal = OptionValue[Scale];

	(* app sizing *)
	imagePanelSize={575,420};
	controlPanelSize={330,450+50+10};
	outputPanelSize = {First[imagePanelSize]+First[controlPanelSize]+10,50};
	appSize={First[imagePanelSize]+First[controlPanelSize]+40,Last[controlPanelSize]+Last[outputPanelSize]+25};

	imageType=OptionValue[ImageSource];

	steps = processingStepsWithRanges;

	(* shrink image to speed up processing *)
	img0 = ImageResize[img00,imgSize];
	imgDims=ImageDimensions[img0];
	showSize = {525,395};

	(* sizing circles for the image *)
	var["CellSize"]={minCellRad,maxCellRad};
	cellSizeCenter = First[imgDims]/9 * {5,1};
	componentSizeCenter = First[imgDims]/9 * {7,1};
	radMin=1;
	radMax=Min[imgDims]/8.;
	cellSizeGraphic = Graphics[{
		Locator[Dynamic[cellSizeCenter],ImageSize->Small],
		{Thick,Yellow,Tooltip[Circle[Dynamic[cellSizeCenter],Dynamic[minCellRad]],"Min single cell area"]},
		{Thick,Yellow,Tooltip[Circle[Dynamic[cellSizeCenter],Dynamic[maxCellRad]],"Max single cell area"]}
	}];
	componentSizeGraphic = Graphics[{
		Locator[Dynamic[componentSizeCenter],ImageSize->Small],
		{Thick,Green,Tooltip[Circle[Dynamic[componentSizeCenter],Dynamic[N[Sqrt[minCompArea/Pi]]]],"Min component area"]}
	}];

	headingItem[text_]:=Item[Style[text,Bold],Alignment->Center];
	valFromVar[s_]:=Rule[s,If[TrueQ[var[s,Boolean]],var[s],False]];

	update4F = Function[updateImage[];updateComponents[];updateCellCount[]; updateFinalImage[];];
	update3F = Function[updateComponents[];updateCellCount[]; updateFinalImage[];];

	outputOptions[]:= ReplaceRule[{ops}, {
		ComponentThreshold->compVal,
		MorphologicalComponentsMethod->compMethod,
		MinComponentArea->minCompArea,
		MinComponentBrightness->minCompBrightness,
		MinCellRadius->minCellRad,
		MaxCellRadius->maxCellRad,
		Sequence@@Map[valFromVar,steps[[;;,1]][[;;, 1]]],
		(*ImageSize->imgSize,*)
		ImageSource->OptionValue[ImageSource]
	}];

	(* need to initialize before making the controls, so we can pull the default values from var *)
	initializeSliders["Automatic"]:=With[{defaultValues = {ops}},
		Map[initializeProcessingValue[var,#,Lookup[defaultValues,#[[1]]]]&,steps[[;;, 1]]];
		compVal=0.5;
	];
	initializeSliders["Small sparse cells"]:=With[{defaultValues = {EdgeDetect->0.5,Dilation->False, GradientFilter -> 1, Closing -> 1, ImageAdjust -> True,ops}},
		Map[initializeProcessingValue[var,#,Lookup[defaultValues,#[[1]]]]&,steps[[;;, 1]]];
		compVal=0.5;
	];
	initializeSliders["Small dense cells"]:=With[{defaultValues = {FillingTransform->False,ops}},
		Map[initializeProcessingValue[var,#,Lookup[defaultValues,#[[1]]]]&,steps[[;;, 1]]];
		compVal=0.5;
	];
	initializeSliders["Lawn of cells"]:=With[{defaultValues = {EdgeDetect->False,ops}},
		Map[initializeProcessingValue[var,#,Lookup[defaultValues,#[[1]]]]&,steps[[;;, 1]]];
		compVal=0;
	];
	initializeSliders["No cells"]:=With[{defaultValues = {EdgeDetect->False,ops}},
		Map[initializeProcessingValue[var,#,Lookup[defaultValues,#[[1]]]]&,steps[[;;, 1]]];
		compVal=1;
	];
	initializeSliders["Custom"]:=With[{defaultValues = {ops}},
		Map[initializeProcessingValue[var,#,Lookup[defaultValues,#[[1]]]]&,steps[[;;, 1]]];
		compVal=0.5;
	];
	var["DescribeImage"] = If[custom, "Custom", OptionValue[ImageType]];

	initializeSliders[var["DescribeImage"]];

	primaryControlsBasic = Item[Row[{
		PopupMenu[
			Dynamic[var["DescribeImage"],(var["DescribeImage"]=#; initializeSliders[#];update4F[])&],
			{"Automatic","Small sparse cells","Small dense cells","Lawn of cells","No cells","Custom"}
		]
		}],Alignment->Center];

	primaryControlsAdvanced = Grid[
		Map[{makeImageProcessingControl[var,update4F,#]}&,steps],
		Alignment->Left
	];
	(*  *)
	compAreaManipulator = Manipulator[Dynamic[minCompArea,{(minCompArea=#;)&,(minCompArea=#;update3F[])&}],{10,(Times@@imgDims)/50},AppearanceElements->{"StepLeftButton","InputField","StepRightButton"}];
	filterControlsBasic = Item[Row[{"",compAreaManipulator}],Alignment->Center];
	filterControlsAdvanced := Grid[{
			{Row[{
				"Method:",
				PopupMenu[
					Dynamic[compMethod,(compMethod=#;update3F[])&],
					{"Connected","Convex","ConvexHull"}
				]
			}]},
			{Row[{
				"Threshold:",
				Manipulator[
					Dynamic[compVal,{(compVal=#;)&,(compVal=#;update3F[];)&}],
					{0,1},
					ImageSize->{150,Automatic},
					AppearanceElements->{"StepLeftButton","InputField","StepRightButton"}
				]," "
			}]},
			{Row[{"Min area:",Manipulator[Dynamic[minCompArea,{(minCompArea=#;)&,(minCompArea=#;update3F[])&}],{10,(Times@@imgDims)/50},AppearanceElements->{"StepLeftButton","InputField","StepRightButton"}]}]},
			{Row[{"Brightness:",Manipulator[Dynamic[minCompBrightness,{(minCompBrightness=#;)&,(minCompBrightness=#;update3F[])&}],{0,1},AppearanceElements->{"StepLeftButton","InputField","StepRightButton"}]}]}
		(*	{Row[{"Circularity:",Slider[Dynamic[circularity,{(circularity=#;)&,(circularity=#;update3F[])&}],{0,6}]}]}*)
		},Alignment->Left];


	(*  *)
	cellCountControls = Item[
		Column[{
		Row[{
			Column[{"Min ",Dynamic[Round[First[var["CellSize"]],1]]}],
			IntervalSlider[
				Dynamic[
					var["CellSize"],
					{(var["CellSize"]=#;minCellRad=First[#];maxCellRad=Last[#])&,
					(var["CellSize"]=#;minCellRad=First[#];maxCellRad=Last[#];update3F[])&}
				],
				{radMin,radMax},
				Method->"Push"
			],
			Column[{"Max ",Dynamic[Round[Last[var["CellSize"]],1]]}]
		}]
		}],
		Alignment->Center
	];

	allControls = TabView[{
		"Basic" -> Pane[Item[Grid[{
			{Item[Style["Select the description that best matches your image.  This determines the image processing settings."],Alignment->Center]},
			{primaryControlsBasic},
			{Null},
			{Item[Style["Set the minimum cluster size"],Alignment->Center]},
			{filterControlsBasic},
			{Null},
			{Item[Style["Set the size range for individual cells"],Alignment->Center]},
			{cellCountControls},
			{Null}
		},Alignment->Left,Spacings->{Automatic,1.5},Frame->False],Alignment->Center],controlPanelSize-{15,50},Scrollbars->False],
		"Advanced" -> Pane[Grid[{
			{Null},
			{headingItem["Image Processing"]},
			{primaryControlsAdvanced},
			{Null},
			{headingItem["Morphological Components"]},
			{filterControlsAdvanced},
			{Null},
			{headingItem["Cell Radius"]},
			{cellCountControls}
		},Alignment->Left],controlPanelSize-{15,50},Scrollbars->{False,True}]
	},ImageSize->controlPanelSize];


	(* Process Image *)
	updateImage[]:= (img = processMicroscopeImage[img0,steps[[;;,1]][[;;, 1]],outputOptions[]]);

	(* Find components *)
	updateComponents[]:=Module[{},
		componentsPacket = morphologicalComponentAnalysis[img,Association[outputOptions[]]];
		{comps,compAreas,confluency} = Lookup[componentsPacket,{Components,ComponentAreas,Confluency}];
	];

	(* Count cells *)
	updateCellCount[]:=Module[{},
		cellCountPacket = countCellsFromComponents[Total[compAreas],Association[outputOptions[]]];
		{cellCount,cellCountUncertainty} = Lookup[cellCountPacket,{CellCount,CellCountError}];
	];

	(* create final image *)
	updateFinalImage[]:=(
		imgFinal=showCellImage[img0,img,comps,cellSizeGraphic,componentSizeGraphic,scaleVal,
			Association[{PrimaryImage->whichImage,ImageOverlay->whichOverlay,ImageSize->showSize}]
		];
	);

	cellCountPanel = Pane[Grid[{
		{Row[{Style[Replace[imageType,(Null|{Null})->""],Bold]," "}],Row[{"Confluency: ",Dynamic[confluency]}],Row[{"Cell Count: ",Dynamic[cellCount]}]}
	},Alignment->Left]];

	displayControlPanel = Grid[{
		{Style["Image",Bold],Null,Style["Overlays",Bold]},
		{
			PopupMenu[Dynamic[whichImage,(whichImage=#;updateFinalImage[])&],{"Original","Processed"}],
			Null,
			PopupMenu[Dynamic[whichOverlay,(whichOverlay=#;updateFinalImage[])&],{"None","Cell Highlights","Components"}]
		}
	}];

	(*
		INITIALIZATION
	*)
	updateImage[];
	updateComponents[];
	updateCellCount[];
	updateFinalImage[];

	(*
		OUTPUT
	*)
	Analysis`Private`makeAppWindow[
		DisplayPanel -> Panel[Grid[{
				{displayControlPanel},
				{Pane[Item[Dynamic[imgFinal],Alignment->Center],ImageSize->imagePanelSize]},
				{cellCountPanel}
			}]],
		ControlPanel -> allControls,
		Return :> outputOptions[],
		ReturnOptions -> {AverageSingleCellArea, CellCount, CellCountDistribution, ComponentAreas, Confluency},
		Cancel -> $Canceled,
		Skip -> Null,
		WindowSize->{970,650},
		WindowTitle->"Cell Counting App",
		AppTest->OptionValue[AppTest]
	]

];



(* ::Subsubsection::Closed:: *)
(*app helpers*)


(*
	Slider with disabling Checkbox
*)
makeImageProcessingControl[var_Symbol,updateFunction_, {{s_Symbol,span:{s1_?NumericQ,s2_?NumericQ,ds_?NumericQ}}, help_String}]:=
	Row[{
		Tooltip[ToString[s], help],
		": ",
		Checkbox[Dynamic[
			var[s,Boolean],
			(
				var[s,Boolean]=#;
				updateFunction[];
				var["DescribeImage"]="Custom";
			)&
		]],
		Manipulator[
			Dynamic[var[s],{(var[s]=#;)&,(var[s]=#;updateFunction[];var["DescribeImage"]="Custom";)&}],{s1,s2,ds},
			ImageSize->175,AppearanceElements->{"StepLeftButton","InputField","StepRightButton"}
		],
		Dynamic[var[s]]
	}," "];

initializeProcessingValue[var_Symbol,{s_Symbol,span:{s1_?NumericQ,s2_?NumericQ,ds_?NumericQ}},val_]:=(
	var[s]=If[MatchQ[val,False],s1,val];
	var[s,Boolean]=If[MatchQ[val,False],False,True];
);

(*
	Checkbox
*)
makeImageProcessingControl[var_Symbol,updateFunction_,{{s_Symbol}, help_String}]:=
	Row[{
		Tooltip[ToString[s], help],
		": ",
		Checkbox[Dynamic[
			var[s],
			(
				var[s]=#;
				var[s,Boolean]=#;
				updateFunction[];
				var["DescribeImage"]="Custom"
			)&
		]],
		""(*Dynamic[var[s]]*)
	}," "];

initializeProcessingValue[var_Symbol,{s_Symbol},val_]:=(
	var[s]=val;
	var[s,Boolean]=val;
);



uniformCellDistributionGraphic[{m_,n_},cellCount_,cellArea_]:=Module[{boxArea,overlay,side,radius},
	radius = N[Sqrt[cellArea/Pi]];
	boxArea = (m*n)/cellCount;
	side = Sqrt[boxArea];
	overlay = Graphics[{
		Table[{Red,Line[{{0,ix*side},{m,ix*side}}]},{ix,0,Ceiling[n/side]}],
		Table[{Red,Line[{{iy*side,0},{iy*side,n}}]},{iy,0,Ceiling[m/side]}],
		Table[{Green,Opacity[0.2],Disk[{(iy-0.5)*side,(ix-0.5)*side},radius]},{iy,1,Ceiling[m/side]},{ix,1,Ceiling[n/side]}]
	}];
	overlay
];
