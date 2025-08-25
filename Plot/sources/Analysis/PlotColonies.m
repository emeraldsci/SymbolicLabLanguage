(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotColonies*)


DefineOptions[PlotColonies,
	Options :> {
		{
			OptionName -> ImageType,
			Default -> Automatic,
			Description -> "Indicates if the function is only displaying the BrightField image or all images associated with the analysis.",
			ResolutionDescription -> "Automatically set to BrightField if there is only BrightField associated with the analysis.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[BrightField, All]
			],
			Category -> "General"
		},
		(* Inherit options without modification *)
		OutputOption,
		FastTrackOption
	}
];

PlotColonies::ImageNotFound = "No image was found in this packet.";
PlotColonies::NoCounts = "One or more of your populations does not have detected colony counts. Please use AnalyzeColonies to count the colonies for your image with desired features.";

(*Given objects*)
PlotColonies[id: objectOrLinkP[Object[Analysis, Colonies]], ops: OptionsPattern[]]:= PlotColonies[Download[id], ops];
(*Main Overload*)
PlotColonies[
	myPacket: PacketP[Object[Analysis, Colonies]],
	myOptions: OptionsPattern[PlotColonies]
] := Module[
	{
		safeOps, output, packet, inputAppearanceReference, brightFieldImage, scale, violetFluorescenceImageFile,
		greenFluorescenceImageFile, orangeFluorescenceImageFile, redFluorescenceImageFile, darkRedFluorescenceImageFile,
		blueWhiteScreenImageFile, imageType, importedBrightFieldImage, importedFluorescentImageFiles, importedBlueWhiteScreenImage,
		adjustedBlueWhiteScreenImage, resolvedInputAssoc, resolvedOptionsAssoc, resolvedPopulationAssoc, finalPlot
	},

	(* Check safe options *)
	safeOps = SafeOptions[PlotColonies, ToList[myOptions]];
	output = Lookup[safeOps, Output];

	(* Remove the Replace and Append headers *)
	packet = Analysis`Private`stripAppendReplaceKeyHeads[myPacket];

	(* Extract Reference image data Object[Data,Appearance,Colonies] *)
	(* Note: there should be only 1 reference image data per analysis*)
	inputAppearanceReference = FirstOrDefault@Download[Analysis`Private`packetLookup[packet, Reference], Object];

	(* Throw an message if no image data is found *)
	If[MatchQ[inputAppearanceReference,  Null],
		Message[PlotColonies::ImageNotFound]; Return[Null]
	];

	If[MemberQ[Analysis`Private`packetLookup[packet, PopulationTotalColonyCount],  EqualP[0]],
		Message[PlotColonies::NoCounts]
	];

	(* Download info from image data *)
	{
		brightFieldImage,
		scale,
		violetFluorescenceImageFile,
		greenFluorescenceImageFile,
		orangeFluorescenceImageFile,
		redFluorescenceImageFile,
		darkRedFluorescenceImageFile,
		blueWhiteScreenImageFile
	} = Quiet[
		Download[
			inputAppearanceReference,
			{
				ImageFile,
				Scale,
				VioletFluorescenceImageFile,
				GreenFluorescenceImageFile,
				OrangeFluorescenceImageFile,
				RedFluorescenceImageFile,
				DarkRedFluorescenceImageFile,
				BlueWhiteScreenImageFile
			}
		],
		{Download::MissingField}
	];

	(* Import cloud files for all raw image files *)
	importedBrightFieldImage = ImportCloudFile[Download[brightFieldImage, Object]];
	(* replace failed values with Null so ImportCloudFile works *)
	importedFluorescentImageFiles = Map[
		ImportCloudFile[#]&,
		Download[
			{
				violetFluorescenceImageFile,
				greenFluorescenceImageFile,
				orangeFluorescenceImageFile,
				redFluorescenceImageFile,
				darkRedFluorescenceImageFile
			},
			Object
		]/. $Failed -> Null
	];
	importedBlueWhiteScreenImage = ImportCloudFile[Download[blueWhiteScreenImageFile, Object]/. $Failed -> Null];

	(* Note:BlueWhiteScreen image might be 180 degree rotated from BrightField image *)
	(* Say BrightField image has notches of plate on the bottom, while BlueWhiteScreen image has them up *)
	(* Then we need to rotate the bluewhitescreen image and align it with brightfield image *)
	adjustedBlueWhiteScreenImage = If[NullQ[importedBlueWhiteScreenImage],
		Null,
		Analysis`Private`alightBlueWhiteScreenImage[importedBrightFieldImage, importedBlueWhiteScreenImage]
	];

	(* Resolve ImageType *)
	imageType = Which[
		!MatchQ[Lookup[safeOps, ImageType], Automatic], Lookup[safeOps, ImageType],
		MemberQ[importedFluorescentImageFiles, Except[Null]] || MatchQ[importedBlueWhiteScreenImage, Except[Null]], All,
		True, BrightField
	];

	(* create an association of inputs *)
	resolvedInputAssoc = <|
		ImageData -> importedBrightFieldImage,
		InputData -> inputAppearanceReference,
		InputObject -> inputAppearanceReference,
		Scale -> Convert[scale/. Null|$Failed -> $QPixImageScale, Pixel/Millimeter],
		FluorescenceWavelengthImages -> Association@MapThread[
			(#1 -> #2)&,
			{List @@ QPixFluorescenceWavelengthsP, importedFluorescentImageFiles}
		],
		BlueWhiteScreenImages -> adjustedBlueWhiteScreenImage
	|>;

	(* Pull out resolved options(such as Populations, MinDiameter) from analysis Object *)
	resolvedOptionsAssoc = Association[
		AnalysisType -> If[MatchQ[imageType, BrightField], Count, Plot],
		Margin -> (Analysis`Private`packetLookup[packet, Margin]/.Null -> None),
		Output -> Preview
	];

	resolvedPopulationAssoc = <|
		(* All Components *)
		Replace[ComponentBoundaries] -> Analysis`Private`packetLookup[packet, ComponentBoundaries],
		(* All Colonies *)
		Replace[ColonyBoundaries] -> Analysis`Private`packetLookup[packet, ColonyBoundaries],
		TotalColonyCount -> Analysis`Private`packetLookup[packet, TotalColonyCount],
		(* Population colonies *)
		Replace[PopulationNames] -> Analysis`Private`packetLookup[packet, PopulationNames],
		Replace[PopulationProperties] -> Analysis`Private`packetLookup[packet, PopulationProperties],
		Replace[PopulationTotalColonyCount] -> Analysis`Private`packetLookup[packet, PopulationTotalColonyCount]
	|>;

	(* The core of analyzePreviewColonies located in Analysis/ImageProcessing/Colonies. *)
	finalPlot = Lookup[
		Analysis`Private`analyzePreviewColonies[{
			ResolvedInputs -> resolvedInputAssoc,
			ResolvedOptions -> resolvedOptionsAssoc,
			Packet -> resolvedPopulationAssoc
		}],
		Preview
	];

	(* Return specified output *)
	output /.{
		Result -> finalPlot,
		Preview -> finalPlot,
		Tests -> {},
		Options -> safeOps
	}
];
