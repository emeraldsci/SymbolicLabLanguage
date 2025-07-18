(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2024 Emerald Cloud Lab,Inc.*)


DefineOptions[AnalyzeColonyGrowth,
	Options :> {
		{
			OptionName -> ExcludedColonies,
			Default -> Null,
			Description -> "Explicitly selected center points of colonies to exclude in the analysis. The center points are relative to the first analysis colony data object.",
			AllowNull -> True,
			Widget -> Adder[
				{
					"X" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Millimeter], Units -> Millimeter],
					"Y" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Millimeter], Units -> Millimeter]
				}
			],
			Category -> "Filtering"
		},
		ModifyOptions[AnalyzeColoniesSharedOptions,
			OptionName -> MinDiameter,
			Default -> Automatic,
			Description -> "The smallest diameter value from which colonies are included in TotalColonyCounts in the data and analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
			ResolutionDescription -> "If reference analysis objects have multiple MinDiameters, the MinDiameter from the first analysis object is used.",
			IndexMatching -> None
		],
		ModifyOptions[AnalyzeColoniesSharedOptions,
			OptionName -> MaxDiameter,
			Default -> Automatic,
			Description -> "The largest diameter value from which colonies are included in TotalColonyCounts in the data and analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
			ResolutionDescription -> "If reference analysis objects have multiple MaxDiameters, the MaxDiameter from the first analysis object is used.",
			IndexMatching -> None
		],
		ModifyOptions[AnalyzeColoniesSharedOptions,
			OptionName -> MinColonySeparation,
			Default -> Automatic,
			Description -> "The closest distance included colonies can be from each other from which colonies are included in the data and analysis. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony.",
			ResolutionDescription -> "If reference analysis objects have multiple MinColonySeparations, the MinColonySeparations from the first analysis object is used.",
			IndexMatching -> None
		],
		ModifyOptions[AnalyzeColoniesSharedOptions,
			OptionName -> MinRegularityRatio,
			Default -> Automatic,
			Description -> "The smallest regularity ratio from which colonies are included in the data and analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
			ResolutionDescription -> "If reference analysis objects have multiple MinRegularityRatios, the MinRegularityRatio from the first analysis object is used.",
			IndexMatching -> None
		],
		ModifyOptions[AnalyzeColoniesSharedOptions,
			OptionName -> MaxRegularityRatio,
			Default -> Automatic,
			Description -> "The largest regularity ratio from which colonies are included in the data and analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
			ResolutionDescription -> "If reference analysis objects have multiple MaxRegularityRatios, the MaxRegularityRatio from the first analysis object is used.",
			IndexMatching -> None
		],
		ModifyOptions[AnalyzeColoniesSharedOptions,
			OptionName -> MinCircularityRatio,
			Default -> Automatic,
			Description -> "The smallest circularity ratio from which colonies are included in the data and analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
			ResolutionDescription -> "If reference analysis objects have multiple MinCircularityRatios, the MinCircularityRatio from the first analysis object is used.",
			IndexMatching -> None
		],
		ModifyOptions[AnalyzeColoniesSharedOptions,
			OptionName -> MaxCircularityRatio,
			Default -> Automatic,
			Description -> "The largest circularity ratio from which colonies are included in the data and analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
			ResolutionDescription -> "If reference analysis objects have multiple MaxCircularityRatios, the MaxCircularityRatio from the first analysis object is used.",
			IndexMatching -> None
		],
		{
			OptionName -> TargetPatchSize,
			Default -> 1000,
			AllowNull -> False,
			Description -> "The largest dimension from which input data are partitioning into. For example, for qpix dimensions {2819, 1872}, if TargetPatchSize is set to 1000, the image is partitioned to 3X2 patches.",
			Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[400, 100]],
			Category -> "Hidden"
		},
		OutputOption,
		UploadOption
	}
];


(* Warning and errors *)
Error::EmptyAppearanceData = "There are no appearance data in the Reference field of `1`. Please check to ensure the input has appearance data.";
Error::ConflictingImageDimensions = "There are multiple image dimensions for appearance data in `1`. Please check to ensure the required ReferenceImages are the same size.";

(* Overload for a single appearance data or colonies analysis data *)
AnalyzeColonyGrowth[input: ObjectP[{Object[Data, Appearance, Colonies], Object[Analysis, Colonies]}], ops: OptionsPattern[]] := AnalyzeColonyGrowth[{input}, ops];

(* Main function definition using v1 SciComp Framework *)

(*Overload 1: ObjectP[Object[Data, Appearance, Colonies]]*)
DefineAnalyzeFunction[
	AnalyzeColonyGrowth,
	<|
		InputData -> {ObjectP[Object[Data, Appearance, Colonies]]..}
	|>,
	(* Break down main function into the following steps/subfunctions *)
	{
		analyzeColonyGrowthResolveInputAppearance,
		analyzeColonyGrowthResolveOptionsGeneral,
		analyzeColonyGrowthCalculateGeneral,
		analyzeColonyGrowthPreview
	}
];

(*Overload 2: ObjectP[Object[Analysis, Colonies]]*)
DefineAnalyzeFunction[
	AnalyzeColonyGrowth,
	<|
		InputData -> {ObjectP[Object[Analysis, Colonies]]..}
	|>,
	(* Break down main function into the following steps/subfunctions *)
	{
		analyzeColonyGrowthResolveInputAnalysis,
		analyzeColonyGrowthResolveOptionsGeneral,
		analyzeColonyGrowthCalculateGeneral,
		analyzeColonyGrowthPreview
	}
];


(***********************************************************************************)
(* Resolve input: overload for Object[Data, Appearance, Colonies] *)
analyzeColonyGrowthResolveInputAppearance[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: {ObjectP[Object[Data, Appearance, Colonies]]..}
		}],
		ResolvedOptions -> KeyValuePattern[{
			MinRegularityRatio -> minRegularity_,
			MaxRegularityRatio -> maxRegularity_,
			MinCircularityRatio -> minCircularity_,
			MaxCircularityRatio -> maxCircularity_,
			MinDiameter -> minDiameter_,
			MaxDiameter -> maxDiameter_,
			MinColonySeparation -> minColonySeparation_
		}]
	}]
] := Module[
	{
		allDownloadedStuff, analysisPackets, appearanceDataPackets, allBrightFieldImages, importedBrightFieldImages, imageSameSizeQ,
		sameRotationBrightFieldImages, imageRotationQs, scale, coarseCorrelationFittings, coarseAlignedImages, colonyAnalysisData,
		newColonyAnalysisData
	},

	(* Download all the relevant fields together *)
	allDownloadedStuff = Flatten@Quiet[
		Download[
			inputData,
			{
				Packet[ImageFile, Scale, ColonyAnalysis],
				Packet[ColonyAnalysis[{MinRegularityRatio, MaxRegularityRatio, MinCircularityRatio, MaxCircularityRatio, MinDiameter, MaxDiameter, MinColonySeparation}]]
			}
		],
		Download::MissingField
	];

	appearanceDataPackets = Cases[allDownloadedStuff, PacketP[Object[Data, Appearance, Colonies]]];
	analysisPackets = Cases[allDownloadedStuff, PacketP[Object[Analysis, Colonies]]];

	(* Extract BrightField images from appearanceDataPackets *)
	allBrightFieldImages = Lookup[appearanceDataPackets, ImageFile];

	(* Fail early if there is no ImageFile(BrightField) in the appearance data *)
	If[MemberQ[allBrightFieldImages, Null],
		Message[Error::EmptyDataField, PickList[inputData, allBrightFieldImages, Null]];
		Return[$Failed]
	];

	importedBrightFieldImages = ImportCloudFile[allBrightFieldImages];

	(* Check image dimensions *)
	imageSameSizeQ = Module[{imageDimensions, scales},
		imageDimensions = ImageDimensions[#]& /@ importedBrightFieldImages;
		scales = Convert[Lookup[appearanceDataPackets, Scale]/. Null|$Failed -> $QPixImageScale, Pixel/Millimeter];
		SameQ@@imageDimensions[[All, 1]] && SameQ@@imageDimensions[[All, 2]] && SameQ[scales]
	];

	If[!TrueQ[imageSameSizeQ],
		Message[Error::ConflictingImageDimensions, inputData];
		Return[$Failed]
	];

	(* Check if the image needs to be rotated compared with the first appearance data *)
	{sameRotationBrightFieldImages, imageRotationQs} = Transpose@Join[
		{{First[importedBrightFieldImages], False}},
		Map[
			rotateBrightFieldImageQ[First[importedBrightFieldImages], #]&,
			Rest[importedBrightFieldImages]
		]
	];

	scale = First@Convert[Lookup[appearanceDataPackets, Scale]/. Null|$Failed -> $QPixImageScale, Pixel/Millimeter];

	(* Check translational shifts across appearance data *)
	{coarseAlignedImages, coarseCorrelationFittings} = Transpose@Join[
		{{First[sameRotationBrightFieldImages], {0 Millimeter, 0 Millimeter}}},
		Map[
			correlateBrightFieldImages[First[sameRotationBrightFieldImages], #, scale]&,
			Rest[sameRotationBrightFieldImages]
		]
	];

	(* Extract colony analysis objects from appearanceDataPackets *)
	(* If there are multiple ColonyAnalysis associated with the appearance data, use the last one *)
	colonyAnalysisData = LastOrDefault /@ Lookup[appearanceDataPackets, ColonyAnalysis];

	(* If there is no colony analysis data, generate right now *)
	newColonyAnalysisData = If[MemberQ[colonyAnalysisData, Null],
		Module[{exampleAnalysisPacket, resolvedAnalysisCriteria},
			(* Take the first colony analysis packet from analysisPackets *)
			exampleAnalysisPacket = FirstOrDefault[analysisPackets];
			(* Generate a list of resolved analysis options *)
			resolvedAnalysisCriteria = MapThread[
				Which[
					(* If there is no user-specified value, lookup what previous analysis use *)
					MatchQ[#2, Automatic] && !NullQ[exampleAnalysisPacket] && NullQ[Lookup[exampleAnalysisPacket, #1]], #1 -> Lookup[exampleAnalysisPacket, #1],
					(* Otherwise, use let AnalyzeColonies auto resolve *)
					MatchQ[#2, Automatic], Nothing,
					(* If there is user-specified value, use it *)
					True, #1 -> #2
				]&,
				{
					{
						MinRegularityRatio,
						MaxRegularityRatio,
						MinCircularityRatio,
						MaxCircularityRatio,
						MinDiameter,
						MaxDiameter,
						MinColonySeparation
					},
					{
						minRegularity,
						maxRegularity,
						minCircularity,
						maxCircularity,
						minDiameter,
						maxDiameter,
						minColonySeparation
					}
				}
			];
			(* Call AnalyzeColonies to generate colony analysis *)
			MapThread[
				If[NullQ[#1],
					AnalyzeColonies[
						#2,
						Populations -> All,
						Sequence@@resolvedAnalysisCriteria
					],
					#1
				]&,
				{colonyAnalysisData, inputData}
			]
		],
		colonyAnalysisData
	];

	<|
		ResolvedInputs -> <|
			ReferenceImages -> allBrightFieldImages,
			AlignedImages -> coarseAlignedImages,
			Reference -> newColonyAnalysisData,
			ImageRotationQs -> imageRotationQs,
			CoarseCorrelation -> coarseCorrelationFittings,
			Scale -> scale
		|>,
		Tests -> <|ResolvedInputTests -> {}|>
	|>
];


(* Resolve input: overload for Object[Analysis, Colonies] *)
analyzeColonyGrowthResolveInputAnalysis[
	KeyValuePattern[{
		UnresolvedInputs -> KeyValuePattern[{
			InputData -> inputData: {ObjectP[Object[Analysis, Colonies]]..}
		}]
	}]
] := Module[
	{
		allDownloadedStuff, analysisPackets, appearanceDataPackets, inputAppearanceReference, allBrightFieldImages, importedBrightFieldImages,
		imageSameSizeQ, sameRotationBrightFieldImages, imageRotationQs, scale, coarseCorrelationFittings, coarseAlignedImages
	},

	(* Download all the relevant fields together *)
	allDownloadedStuff = Flatten@Quiet[
		Download[
			inputData,
			{
				Packet[Reference],
				Packet[Reference[{ImageFile, Scale}]]
			}
		],
		Download::MissingField
	];

	analysisPackets = Cases[allDownloadedStuff, PacketP[Object[Analysis, Colonies]]];
	appearanceDataPackets = Cases[allDownloadedStuff, PacketP[Object[Data, Appearance, Colonies]]];

	(* Extract Reference image data Object[Data,Appearance,Colonies] from the analysisPackets *)
	(* Note: there should be only 1 reference image data per analysis *)
	inputAppearanceReference = Download[Lookup[analysisPackets, Reference], Object];

	(* Fail early if there is no ImageFile(BrightField) in the appearance data *)
	If[MemberQ[inputAppearanceReference, {}],
		Message[Error::EmptyAppearanceData, PickList[inputData, inputAppearanceReference, {}]];
		Return[$Failed]
	];

	(* Extract BrightField images from Reference image data *)
	allBrightFieldImages = Download[Lookup[appearanceDataPackets, ImageFile], Object];

	(* Fail early if there is no ImageFile(BrightField) in the appearance data *)
	If[MemberQ[allBrightFieldImages, Null],
		Message[Error::EmptyDataField, PickList[inputAppearanceReference, allBrightFieldImages, Null]];
		Return[$Failed]
	];

	importedBrightFieldImages = ImportCloudFile[allBrightFieldImages];

	(* Check image dimensions *)
	imageSameSizeQ = Module[{imageDimensions, scales},
		imageDimensions = ImageDimensions[#]& /@ importedBrightFieldImages;
		scales = Convert[Lookup[appearanceDataPackets, Scale]/. Null|$Failed -> $QPixImageScale, Pixel/Millimeter];
		SameQ@@imageDimensions[[All, 1]] && SameQ@@imageDimensions[[All, 2]] && SameQ[scales]
	];

	If[!TrueQ[imageSameSizeQ],
		Message[Error::ConflictingImageDimensions, inputAppearanceReference];
		Return[$Failed]
	];

	(* Check if the image needs to be rotated compared with the first appearance data *)
	{sameRotationBrightFieldImages, imageRotationQs} = Transpose@Join[
		{{First[importedBrightFieldImages], False}},
		Map[
			rotateBrightFieldImageQ[First[importedBrightFieldImages], #]&,
			Rest[importedBrightFieldImages]
		]
	];

	scale = First@Convert[Lookup[appearanceDataPackets, Scale]/. Null|$Failed -> $QPixImageScale, Pixel/Millimeter];

	(* Coarse Correlation: translational shifts across appearance data *)
	{coarseAlignedImages, coarseCorrelationFittings} = Transpose@Join[
		{{First[sameRotationBrightFieldImages], {0 Millimeter, 0 Millimeter}}},
		Map[
			correlateBrightFieldImages[First[sameRotationBrightFieldImages], #, scale]&,
			Rest[sameRotationBrightFieldImages]
		]
	];

	(* Note: reference images are set in options resolution  *)
	<|
		ResolvedInputs -> <|
			ReferenceImages -> allBrightFieldImages,
			AlignedImages -> coarseAlignedImages,
			Reference -> inputData,
			ImageRotationQs -> imageRotationQs,
			CoarseCorrelation -> coarseCorrelationFittings,
			Scale -> scale
		|>,
		Tests -> <|ResolvedInputTests -> {}|>
	|>
];


(***********************************************************************************)
(* options resolution: for all inputs *)
analyzeColonyGrowthResolveOptionsGeneral[
	KeyValuePattern[{
		ResolvedInputs -> KeyValuePattern[{
			Reference -> colonyAnalysisData_
		}],
		ResolvedOptions -> KeyValuePattern[{
			MinRegularityRatio -> minRegularity_,
			MaxRegularityRatio -> maxRegularity_,
			MinCircularityRatio -> minCircularity_,
			MaxCircularityRatio -> maxCircularity_,
			MinDiameter -> minDiameter_,
			MaxDiameter -> maxDiameter_,
			MinColonySeparation -> minColonySeparation_,
			ExcludedColonies -> excludedColonies_,
			TargetPatchSize -> targetPatchSize_,
			Output -> output_
		}]
	}]
] := Module[
	{
		gatherTests, dataPackets, resolvedMinRegularity, resolvedMaxRegularity, resolvedMinCircularity, resolvedMaxCircularity,
		resolvedMinDiameter, resolvedMaxDiameter, resolvedMinColonySeparation, regularityBool, circularityBool, diameterBool,
		minMaxBooleans, minMaxTests, overallResolutionFailure, invalidOptions
	},

	(* Check if output contains test *)
	gatherTests = MemberQ[ToList@output, Tests];

	(* Download all the relevant fields together *)
	dataPackets = Download[
		colonyAnalysisData,
		Packet[MinRegularityRatio, MaxRegularityRatio, MinCircularityRatio, MaxCircularityRatio, MinDiameter, MaxDiameter, MinColonySeparation]
	];

	{
		resolvedMinRegularity,
		resolvedMaxRegularity,
		resolvedMinCircularity,
		resolvedMaxCircularity,
		resolvedMinDiameter,
		resolvedMaxDiameter,
		resolvedMinColonySeparation
	} = MapThread[
		Function[{filteringSymbol, specifiedValue},
			Module[{allValues},
				allValues = Lookup[dataPackets, filteringSymbol];
				If[!MatchQ[specifiedValue, Automatic],
					specifiedValue,
					FirstOrDefault@Cases[allValues, Except[Null]]
				]
			]
		],
		{
			{
				MinRegularityRatio,
				MaxRegularityRatio,
				MinCircularityRatio,
				MaxCircularityRatio,
				MinDiameter,
				MaxDiameter,
				MinColonySeparation
			},
			{
				minRegularity,
				maxRegularity,
				minCircularity,
				maxCircularity,
				minDiameter,
				maxDiameter,
				minColonySeparation
			}
		}
	];

	(* ==Conflicting option checking== *)
	(* Note: the helper functions for Min/Max tests are in AnalyzeColonies *)

	(* Check if min < max for diameter, regularity, circularity *)
	(* True means the min/max pair is valid *)
	regularityBool =  Less[resolvedMinRegularity, resolvedMaxRegularity];
	circularityBool = Less[resolvedMinCircularity, resolvedMaxCircularity];
	diameterBool = Less[resolvedMinDiameter, resolvedMaxDiameter];

	(* List of booleans for bounds if errors occurred *)
	minMaxBooleans = {
		regularityBool,
		circularityBool,
		diameterBool
	};

	(* Create message if we are not gathering tests *)
	If[Not[gatherTests] && MemberQ[minMaxBooleans, False],
		(* write the error messages for the booleans *)
		MapThread[
			Function[{bool, failingSymbol},
				If[MatchQ[bool, False],
					minMaxMessage[
						colonyAnalysisData,
						ConstantArray[False, Length[colonyAnalysisData]],
						failingSymbol
					]
				]
			],
			{minMaxBooleans, {"Regularity", "Circularity", "Diameter"}}
		]
	];

	(* MinMaxTests *)
	minMaxTests = If[gatherTests,
		Module[{testStrings, goodObjects, badObjects, passingTests, failingTests, allTests},
			(* test strings *)
			testStrings = {
				"the minimum regularity value cannot exceed the maximum regularity value:",
				"the minimum circularity value cannot exceed the maximum circularity value:",
				"the minimum diameter value cannot exceed the maximum diameter value:"
			};

			(* Pull out the passing objects *)
			goodObjects =  Map[
				If[TrueQ[#], colonyAnalysisData, {}]&,
				minMaxBooleans
			];

			(* Pull out the failing objects *)
			badObjects = Map[
				If[TrueQ[#], {}, colonyAnalysisData]&,
				minMaxBooleans
			];

			(* Create the passing and failing tests *)
			passingTests = MapThread[
				minMaxTestCreator[#1, True, #2]&,
				{goodObjects, testStrings}
			];

			failingTests = MapThread[
				minMaxTestCreator[#1, True, #2]&,
				{badObjects, testStrings}
			];

			allTests = Flatten[{passingTests, failingTests}];

			(* Return all tests *)
			allTests
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Look at the max booleans and combine them together *)
	overallResolutionFailure = MemberQ[minMaxBooleans, False];

	(* Find the invalid options to write failures *)
	invalidOptions = PickList[{{MinRegularityRatio, MaxRegularityRatio}, {MinCircularityRatio, MaxCircularityRatio}, {MinDiameter, MaxDiameter}}, minMaxBooleans, False];

	(* Write the messages for invalid options *)
	If[Length[invalidOptions] > 0,
		Message[Error::InvalidOption, Flatten[invalidOptions]]
	];


	(* output packet *)
	<|
		ResolvedOptions ->
			<|
				MinRegularityRatio -> resolvedMinRegularity,
				MaxRegularityRatio -> resolvedMaxRegularity,
				MinCircularityRatio -> resolvedMinCircularity,
				MaxCircularityRatio -> resolvedMaxCircularity,
				MinDiameter -> resolvedMinDiameter,
				MaxDiameter -> resolvedMaxDiameter,
				MinColonySeparation -> resolvedMinColonySeparation,
				ExcludedColonies -> excludedColonies,
				TargetPatchSize -> targetPatchSize
			|>,
		Tests ->
      <|
				ResolvedOptionTests -> {
					(* Combine all tests and only keep the EmeraldTests and get rid of Nulls *)
						Cases[minMaxTests, _EmeraldTest]
				}
			|>
	|>
];


(***********************************************************************************)
(* Main calculation function *)
analyzeColonyGrowthCalculateGeneral[
	KeyValuePattern[{
		ResolvedInputs -> KeyValuePattern[{
			ReferenceImages -> brightFieldImageFiles_,
			AlignedImages -> coarseAlignedImages_,
			Reference -> colonyAnalysisData_,
			ImageRotationQs -> imageRotationQs_,
			CoarseCorrelation -> coarseCorrelationFittings_,
			Scale -> scale_
		}],
		ResolvedOptions -> KeyValuePattern[{
			MinRegularityRatio -> minRegularity_,
			MaxRegularityRatio -> maxRegularity_,
			MinCircularityRatio -> minCircularity_,
			MaxCircularityRatio -> maxCircularity_,
			MinDiameter -> minDiameter_,
			MaxDiameter -> maxDiameter_,
			MinColonySeparation -> minColonySeparation_,
			ExcludedColonies -> excludedColonies_,
			TargetPatchSize -> targetPatchSize_,
			Output -> output_
		}]
	}]
] := Module[
	{
		allDownloadedStuff, analysisPackets, appearanceAcquiredDates, datesAcquired, imageFileCreatedDates, imageSize, imageSizeInMillimeter,
		numberOfPatches, colMax, rowMax, patchSizeInMillimeter, allDataColonyLocations, allDataColonyBoundaries, allDataColonyDiameters,
		allDataColonySeparations, allDataColonyRegularityRatios, allDataColonyCircularityRatio, totalColonyPropertiesWithPatchTag,
		updatedColonyCountsLog, averageColonyDiameters, averageColonySeparations, averageColonyRegularityRatios, averageColonyCircularityRatios,
		alignedImagesWithColonies, alignedImagesWithColoniesFiles, newColonyNumberList, totalColonyProperties, correlations,
		calculatedStableIntervals
	},

	(* Download all the relevant fields together *)
	allDownloadedStuff = Flatten@Quiet[
		Download[
			colonyAnalysisData,
			{
				Packet[
					(*1*)ColonyLocations,
					(*2*)ColonyBoundaries,
					(*3*)ColonyDiameters,
					(*4*)ColonySeparations,
					(*5*)ColonyRegularityRatios,
					(*6*)ColonyCircularityRatio
				],
				Packet[Reference[DateAcquired]],
				Packet[Reference[ImageFile][DateCreated]]
			}
		],
		Download::MissingField
	];

	(* Extract all the colony properties data from allDownloadedStuff *)
	analysisPackets = Cases[allDownloadedStuff, PacketP[Object[Analysis, Colonies]]];

	(* Determine when the appearance data was acquired. If it does not exist, use raw image upload time *)
	appearanceAcquiredDates = Lookup[Cases[allDownloadedStuff, PacketP[Object[Data, Appearance, Colonies]]], DateAcquired];
	imageFileCreatedDates = Lookup[Cases[allDownloadedStuff, PacketP[Object[EmeraldCloudFile]]], DateCreated];
	datesAcquired = MapThread[If[NullQ[#1], #2, #1]&, {appearanceAcquiredDates, imageFileCreatedDates}];

	(* TRACKING ALGORITHM START *)
	(* OUTLINE *)
	(*
		1) Clean up colonies from all Object[Analysis,Colonies]
			a) Filter colonies with new set of global analysis options:Min/MaxDiameter,Regularity,Circularity,Separation
			b) Update colonies coordinates if the linked BrightField image is rotated or shifted compared with reference
			b) Exclude colonies specified with option ExcludedColonies
		2) Calculate all properties of all remaining colonies
			a) superimpose colonies on aligned BrightField images,
			b) sort colony to different patches
			c) calculate morphological averages and total counts for remaining colonies
		3) If more than 1 Object[Analysis,Colonies] as input, track if the colonies from the later Object[Analysis,Colonies]
				were identified in the previous Object[Analysis,Colonies] or not. If not, append the colony list. Then calculate
				theNumberOfStableIntervals based on if new colonies are added or not.
	*)

	(* Determine the image dimensions *)
	imageSize = ImageDimensions[First@coarseAlignedImages];
	imageSizeInMillimeter = imageSize/Unitless[scale] Millimeter;

	(* Determine the number of patches *)
	(* With patches, we can track agar gel distortion as fine correlation eventually if there are enough colonies *)
	(* Compare colonies across images in only patch zone also speeds up the calculation *)
	(* For example, if image dimensions are {2819, 1872} and TargetPatchSize 1000, the image is partitioned to 3(column)X2(row) patches *)
	(*
    ============================================
    ===    4      -      5        -      6   ===
    ===           -               -     {3,2}===
    ===--------------------------------------===
    ===           -               -          ===
    ===     1     -       2       -      3   ===
    ===  {1,1}    -               -          ===
    ============================================
  *)
	patchSizeInMillimeter = targetPatchSize/Unitless[scale] Millimeter;
	colMax = Ceiling[imageSize[[1]]/targetPatchSize];
	rowMax = Ceiling[imageSize[[2]]/targetPatchSize];
	numberOfPatches = colMax*rowMax;

	(* Lookup morphological Properties from analysisPackets *)
	(* Note: since we are tracking total colonies, we do not care about BlueWhiteScreen or Fluorescence properties *)
	{
		(*1*)allDataColonyLocations,
		(*2*)allDataColonyBoundaries,
		(*3*)allDataColonyDiameters,
		(*4*)allDataColonySeparations,
		(*5*)allDataColonyRegularityRatios,
		(*6*)allDataColonyCircularityRatio
	} = Transpose@Lookup[
		analysisPackets,
		{
			(*1*)ColonyLocations,
			(*2*)ColonyBoundaries,
			(*3*)ColonyDiameters,
			(*4*)ColonySeparations,
			(*5*)ColonyRegularityRatios,
			(*6*)ColonyCircularityRatio
		}
	];

	(* Filter previous colonies with new global analysis options and update total colony counts and colony distributions *)
	{
		totalColonyPropertiesWithPatchTag,
		totalColonyProperties,
		updatedColonyCountsLog,
		averageColonyDiameters,
		averageColonySeparations,
		averageColonyRegularityRatios,
		averageColonyCircularityRatios,
		alignedImagesWithColonies
	} = Transpose@MapThread[
		Function[{
			(*1*)colonyLocations,
			(*2*)colonyBoundaries,
			(*3*)colonyDiameters,
			(*4*)colonySeparations,
			(*5*)colonyRegularityRatios,
			(*6*)colonyCircularityRatio,
			(*7*)imageRotationQ,
			(*8*)coarseFittingsInMillimeter,
			(*9*)coarseAlignedImage,
			(*10*)dateAcquired
		},
			Module[
				{
					colonyBoundaryList,colonyProperties, filteredColoniesIndex, filteredColonyLocations, filteredColonyBoundaries, 
					filteredColonyDiameters, filteredColonySeparations, filteredColonyRegularityRatios, filteredColonyCircularityRatios,
					sameRotationLocations, sameRotationBoundaries, shiftedLocations, shiftedBoundaries, excludeIndices,
					filteredExcludedColonyLocations, filteredExcludedColonyBoundaries, filteredExcludedColonyDiameters,
					filteredExcludedColonySeparations, filteredExcludedRegularityRatios, filteredExcludedCircularityRatios,
					averageColonyDiameter, averageColonySeparation, averageColonyRegularityRatio, averageColonyCircularityRatio,
					filteredExcludedColonyPatches, alignedImageWithColonies, labels, updatedProperties, indexedUpdatedProperties
				},
				(* Convert ColonyBoundaries from QuantityArray to a list of values *)
				colonyBoundaryList = Map[Quantity[#, Millimeter]&, QuantityMagnitude[colonyBoundaries], {3}];

				(* Combine all property rules *)
				colonyProperties = Association@@MapIndexed[
					First[#2] -> #1&,
					Transpose[
					{
						(*1*)colonyLocations,
						(*2*)colonyBoundaryList,
						(*3*)colonyDiameters,
						(*4*)colonySeparations,
						(*5*)colonyRegularityRatios,
						(*6*)colonyCircularityRatio
					}]
				];

				(* Select components based on global analysis criteria *)
				filteredColoniesIndex = Keys@Select[
					colonyProperties,
					And[
						minDiameter <= #[[3]] <= maxDiameter,
						minRegularity <= #[[5]] <= maxRegularity,
						minCircularity <= #[[6]] <= maxCircularity,
						minColonySeparation <= #[[4]]
					]&
				];

				(* If there are some colonies, break them up by property, otherwise set calculated values to empty list *)
				{
					(*1*)filteredColonyLocations,
					(*2*)filteredColonyBoundaries,
					(*3*)filteredColonyDiameters,
					(*4*)filteredColonySeparations,
					(*5*)filteredColonyRegularityRatios,
					(*6*)filteredColonyCircularityRatios
				} = If[Length[filteredColoniesIndex] > 0,
					Transpose[Lookup[colonyProperties, filteredColoniesIndex]],
					ConstantArray[{}, 6]
				];

				(* Convert the centerpoints and boundaries of filtered Colonies to the same rotation *)
				sameRotationLocations = If[TrueQ[imageRotationQ] && !MatchQ[filteredColonyLocations, {}],
					rotateCoordinates[filteredColonyLocations, imageSizeInMillimeter],
					filteredColonyLocations
				];
				sameRotationBoundaries = If[TrueQ[imageRotationQ] && !MatchQ[filteredColonyBoundaries, {}],
					Map[rotateCoordinates[#, imageSizeInMillimeter]&, filteredColonyBoundaries],
					filteredColonyBoundaries
				];

				(* Shift the centerpoints and boundaries of filtered Colonies *)
				shiftedLocations = If[!MatchQ[coarseFittingsInMillimeter, {0 Millimeter, 0 Millimeter}] && !MatchQ[filteredColonyLocations, {}],
					shiftCoordinates[sameRotationLocations, coarseFittingsInMillimeter],
					sameRotationLocations
				];
				shiftedBoundaries = If[!MatchQ[coarseFittingsInMillimeter, {0 Millimeter, 0 Millimeter}] && !MatchQ[filteredColonyBoundaries, {}],
					Map[shiftCoordinates[#, coarseFittingsInMillimeter]&, sameRotationBoundaries],
					sameRotationBoundaries
				];

				(* Check if user-specified Exclude is in this list *)
				excludeIndices = If[MatchQ[excludedColonies, {}|Null],
					{},
					(* Convert to pixels and pull off units for InPolygonQ *)
					overlappingManualSelection[
						QuantityMagnitude[excludedColonies],
						QuantityMagnitude[shiftedBoundaries],
						QuantityMagnitude[shiftedLocations],
						1(*roundingTolerance*)
					]
				];

				(* Remove the excluded index from properties *)
				{
					(*1*)filteredExcludedColonyLocations,
					(*2*)filteredExcludedColonyBoundaries,
					(*3*)filteredExcludedColonyDiameters,
					(*4*)filteredExcludedColonySeparations,
					(*5*)filteredExcludedRegularityRatios,
					(*6*)filteredExcludedCircularityRatios
				} = Map[
					ReplacePart[#, Thread[excludeIndices -> Nothing]]&,
					{
						(*1*)shiftedLocations,
						(*2*)shiftedBoundaries,
						(*3*)filteredColonyDiameters,
						(*4*)filteredColonySeparations,
						(*5*)filteredColonyRegularityRatios,
						(*6*)filteredColonyCircularityRatios
					}
				];

				(* Sort the remaining colonies to different patches *)
				(* Note: the colonies near the bottom left corner will be sorted in patch1, *)
				(* near the top right corner will be sorted in patch(numberOfTotalPatches) *)
				filteredExcludedColonyPatches = Map[
					getPatchIndex[#, patchSizeInMillimeter, colMax]&,
					filteredExcludedColonyLocations
				];

				(* Calculate morphological properties for remaining colonies *)
				{
					averageColonyDiameter,
					averageColonySeparation,
					averageColonyRegularityRatio,
					averageColonyCircularityRatio
				} = Map[
					(* If colonies are selected calculate the distribution, otherwise return null *)
					safeEmpiricalDistributionList,
					{
						(*3*)filteredExcludedColonyDiameters,
						(*4*)filteredExcludedColonySeparations,
						(*5*)filteredExcludedRegularityRatios,
						(*6*)filteredExcludedCircularityRatios
					}
				];

				(* Generate an image with colony boundaries *)
				alignedImageWithColonies = If[!MatchQ[filteredExcludedColonyLocations, {}],
					hightLightColonies[coarseAlignedImage, filteredExcludedColonyBoundaries, scale],
					coarseAlignedImage
				];

				(* Form named list of rules *)
				labels = {
					(*1*)"Location",
					(*2*)"Boundary",
					(*3*)"Diameter",
					(*4*)"Separation",
					(*5*)"Regularity",
					(*6*)"Circularity"
				};

				(* Combine the updated properties *)
				updatedProperties = If[MatchQ[filteredExcludedColonyLocations, {}|Null],
					Null,
					MapThread[
						Rule,
						{
							labels,
							{
								(*1*)filteredExcludedColonyLocations,
								(*2*)filteredExcludedColonyBoundaries,
								(*3*)filteredExcludedColonyDiameters,
								(*4*)filteredExcludedColonySeparations,
								(*5*)filteredExcludedRegularityRatios,
								(*6*)filteredExcludedCircularityRatios
							}
						}
					]
				];

				indexedUpdatedProperties = Association@@MapIndexed[
					First[#2] -> #1&,
					Transpose[{
						(*1*)filteredExcludedColonyLocations,
						(*2*)filteredExcludedColonyBoundaries,
						(*3*)filteredExcludedColonyDiameters,
						(*4*)filteredExcludedColonySeparations,
						(*5*)filteredExcludedRegularityRatios,
						(*6*)filteredExcludedCircularityRatios,
						(*7*)filteredExcludedColonyPatches
					}]
				];

				(* Return properties and counts *)
				{
					indexedUpdatedProperties,
					updatedProperties,
					{dateAcquired, Length[filteredExcludedColonyLocations]},
					averageColonyDiameter,
					averageColonySeparation,
					averageColonyRegularityRatio,
					averageColonyCircularityRatio,
					alignedImageWithColonies
				}
			]
		],
		{
			(*1*)allDataColonyLocations,
			(*2*)allDataColonyBoundaries,
			(*3*)allDataColonyDiameters,
			(*4*)allDataColonySeparations,
			(*5*)allDataColonyRegularityRatios,
			(*6*)allDataColonyCircularityRatio,
			(*7*)imageRotationQs,
			(*8*)coarseCorrelationFittings,
			(*9*)coarseAlignedImages,
			(*10*)datesAcquired
		}
	];

	(* Generate a list to track if a colony exists before or not *)
	(* The list is index-matched to analysis object. For example, {50, 2, 0} means there are 50 colonies *)
	(* first seen on the first analysis object, 2 new colonies on the 2nd analysis, and none new colonies on 3rd. *)
	newColonyNumberList = If[Length[brightFieldImageFiles] == 1,
		{Length[totalColonyProperties]},
		Total@Map[
			Function[{patchIndex},
				Module[{patchedColoniesIndex, trimmedColonySets , refColonySet, newColonySets, uniqueColonyNumbers},
					(* Select colonies only sorted into current patch *)
					patchedColoniesIndex = Map[
						Function[{colonyProperties},
							Keys@Select[
								colonyProperties,
								#[[7]] == patchIndex&
							]
						],
						totalColonyPropertiesWithPatchTag
					];
					(* Extract locations and boundaries with PatchTag the same as patchIndex *)
					trimmedColonySets = MapThread[
						Function[{colonyProperties, trimmedIndex},
							Module[{trimmedColonyProperties, trimmedColonyLocations, trimmedColonyBoundaries},
								(* Extract properties from only colonies in the current patch *)
								trimmedColonyProperties = Lookup[colonyProperties, trimmedIndex];
								trimmedColonyLocations = trimmedColonyProperties[[All, 1]];
								trimmedColonyBoundaries = trimmedColonyProperties[[All, 2]];
								(* Return both locations, boundaries as well as initialize unique number of colonies *)
								{trimmedColonyLocations, trimmedColonyBoundaries, {Length[trimmedColonyLocations]}}
							]
						],
						{totalColonyPropertiesWithPatchTag, patchedColoniesIndex}
					];
					(* Use the first set of colonies as reference *)
					refColonySet = First[trimmedColonySets];
					newColonySets = Rest[trimmedColonySets];
					(* We start with the first set of colonies, compare with the second set of colonies, generate a new set of colonies. *)
					(* This newly combined set is then compared with the third set of colonies, and the process continues iteratively. *)
					(* Fold[f, x, {a, b, c}] -> f[f[f[x,a],b],c] *)
					uniqueColonyNumbers = Fold[trackNewColonies, refColonySet, newColonySets][[3]]
				]
			],
			Range[numberOfPatches]
		]
	];

	(* Check how many consecutive 0s in the newColonyNumberList *)
	calculatedStableIntervals = If[!EqualQ[Last@newColonyNumberList, 0],
		0,
		Module[{revList},
			revList = Reverse[Most[newColonyNumberList]];
			Length[TakeWhile[revList, # == 0&]]
		]
	];

	(* Generate correlation in QuantityArray form *)
	(* Note:we are not performing fine correlation for agar distortion currently *)
	(* If in the future we do, the fine correlation can be added here using the patch tracking above *)
	correlations = QuantityArray[QuantityMagnitude[coarseCorrelationFittings], {Millimeter, Millimeter}];

	(* Note:We are not generating cloud files when Output is preview or options *)
	alignedImagesWithColoniesFiles = If[!MemberQ[ToList[output], Result],
		Null,
		UploadCloudFile[#]& /@ alignedImagesWithColonies
	];

	(* Output packet *)
	<|
		Packet ->
			<|
				Type -> Object[Analysis, ColonyGrowth],
				Replace[Reference] -> (Link[#, ColonyGrowthAnalysis]& /@ colonyAnalysisData),
				Replace[ReferenceImages] -> (Link /@ brightFieldImageFiles),
				Replace[ImageRotationQs] -> imageRotationQs,
				Replace[BestFitParameters] -> correlations,
				Replace[ExcludedColonies] -> excludedColonies,
				Replace[HighlightedColonies] -> Link /@ alignedImagesWithColoniesFiles,
				MinRegularityRatio -> minRegularity,
				MaxRegularityRatio -> maxRegularity,
				MinCircularityRatio -> minCircularity,
				MaxCircularityRatio -> maxCircularity,
				MinDiameter -> minDiameter,
				MaxDiameter -> maxDiameter,
				MinColonySeparation -> minColonySeparation,
				TargetPatchSize -> targetPatchSize,
				Replace[TotalColonyProperties] -> totalColonyProperties,
				Replace[AverageDiameters] -> averageColonyDiameters,
				Replace[AverageSeparations] -> averageColonySeparations,
				Replace[AverageRegularityRatios] -> averageColonyRegularityRatios,
				Replace[AverageCircularityRatios] -> averageColonyCircularityRatios,
				Replace[TotalColonyCountsLog] -> updatedColonyCountsLog,
				NumberOfStableIntervals -> calculatedStableIntervals
			|>,
		Intermediate -> <|
			Data -> colonyAnalysisData,
			Images -> alignedImagesWithColonies
		|>
	|>
];

(***********************************************************************************)
(* If no preview matches return Null *)
analyzeColonyGrowthPreview[___] := <|Preview -> Null|>;
(* Main preview overload *)
analyzeColonyGrowthPreview[
	KeyValuePattern[{
		Intermediate -> KeyValuePattern[{
			Data -> inputData_,
			Images -> alignedImagesWithColonies_
		}],
		Packet -> KeyValuePattern[{
			Replace[TotalColonyProperties] -> totalColonyProperties_,
			Replace[AverageDiameters] -> averageColonyDiameters_,
			Replace[AverageSeparations] -> averageColonySeparations_,
			Replace[AverageRegularityRatios] -> averageColonyRegularityRatios_,
			Replace[AverageCircularityRatios] -> averageColonyCircularityRatios_,
			Replace[TotalColonyCountsLog] -> updatedColonyCountsLog_
		}]
	}]
]:= Module[
	{
		numberOfImages, images, imageLabels, aspectRatio, fig
	},

	(* Get all exposure times and images from images associations *)
	numberOfImages = Length[inputData];
	images = alignedImagesWithColonies;
	imageLabels = Map[
		Graphics[
			{
				Text[Style[DateString[#[[1]]], Medium], {0, 0}],
				Text[Style["NumberOfCounts: " <> ToString[#[[2]]], Medium], {0, -0.5}]
			},
			PlotRange -> {{-2, 2}, {-2, 2}}
		]&,
		updatedColonyCountsLog
	];
	aspectRatio = ImageAspectRatio[images[[1]]];

	(* Generate preview fig for highlighted colonies on BrightFieldImages, else generate graphic depiction of morphological properties *)
	fig = Module[
		{
			imageSize, showImage, finalDiameterPlot, finalSeparationPlot, finalRegularityPlot, finalCircularityPlot,
			leftGrid, rightGrid, showStats, timeStrings
		},
		(* Get image dimensions *)
		imageSize = Floor[{1, aspectRatio}*600/numberOfImages];
		showImage = Grid[
			Transpose[{
				Flatten[{"TotalColonyCountsLog", Show[#, ImageSize -> {300, 200}]& /@imageLabels}],
				Flatten[{"HighlightedColonies", Show[#, ImageSize -> imageSize]& /@ images}]
			}],
			Frame -> {None, None}
		];

		timeStrings = DateString[#[[1]]]& /@ updatedColonyCountsLog;

		{
			finalDiameterPlot,
			finalSeparationPlot,
			finalRegularityPlot,
			finalCircularityPlot
		} = MapThread[
			plotDistributions[#1, #2, timeStrings]&,
			{
				{
					averageColonyDiameters,
					averageColonySeparations,
					averageColonyRegularityRatios,
					averageColonyCircularityRatios
				},
				{
					"Diameter",
					"ColonySeparation",
					"RegularityRatio",
					"CircularityRatio"
				}
			}
		];

		(* Combine plots into grids *)
		leftGrid = Grid[
			{
				{finalDiameterPlot},
				{finalSeparationPlot}
			},
			Frame -> All
		];
		rightGrid = Grid[
			{
				{finalRegularityPlot},
				{finalCircularityPlot}
			},
			Frame -> All
		];

		(* Combine grids *)
		showStats = Grid[{{leftGrid, rightGrid}}, Frame -> None];

		(* Show both image and stats *)
		(* AppHelpers`Private`makeGraphicSizeFull was used to pattern match in command center preview, remember to update the pattern accordingly if any changes made here. *)
		TabView[{"Highlighted Colonies" -> showImage, "Analyses" -> showStats}, Alignment -> Center, ImageMargins -> 0]
	];

	<|Preview -> fig|>
];


(* misc. helper functions *)
(* Helper function to align BrightField images *)
rotateBrightFieldImageQ[refBrightField_, newBrightField_] := Module[
	{
		rotatedNewImage, alignedRotatedImage, alignedUnrotatedImage, croppedRef, croppedRotated, croppedUnrotated,
		rotatedAlignmentScore, unrotatedAlignmentScore
	},
	(* Rotate the raw new BrightField image 180 degree *)
	rotatedNewImage = ImageRotate[newBrightField, Pi];
	(* Align both raw and rotated new BrightField images with reference BrightField image *)
	(* Since images are gray scale, we only extract imagechannel 1 *)
	alignedRotatedImage = ColorSeparate[ImageAlign[refBrightField, rotatedNewImage]][[1]];
	alignedUnrotatedImage = ColorSeparate[ImageAlign[refBrightField, newBrightField]][[1]];
	(* Crop the top left corner of both alignment, check which one has bigger correlation *)
	croppedRef = ImageTake[refBrightField, {1, 200}, {1, 200}];
	croppedRotated = ImageTake[alignedRotatedImage, {1, 200}, {1, 200}];
	croppedUnrotated = ImageTake[alignedUnrotatedImage, {1, 200}, {1, 200}];
	(* Correlate aligned images with ref on ImageChannel 1 (GrayScale) *)
	rotatedAlignmentScore = Correlation[Flatten@ImageData[croppedRotated], Flatten@ImageData[croppedRef]];
	unrotatedAlignmentScore = Correlation[Flatten@ImageData[croppedUnrotated], Flatten@ImageData[croppedRef]];
	(* Returns the image which ever has the largest alignment score *)
	(* Note: we return only the image before alignment since we will fit alignment in downstream analysis *)
	If[rotatedAlignmentScore < unrotatedAlignmentScore,
		{newBrightField, False},
		{rotatedNewImage, True}
	]
];

(* Helper function to correlate BrightField images *)
(* Use the shift values to align the new image *)
(* When shift value is negative, we pad black value. Note it is faster than ImageData *)
translateImage[image_, shift_, imageSize_] := ImageTrim[image, {shift, imageSize + shift - 1}, Padding -> Black];
(* Correlate BrightField images *)
correlateBrightFieldImages[refBrightField_, newBrightField_, scale_] := Module[
	{
		imageSize, pixelWidth, maskWidth, plateEdgesRows, plateEdgesColumns, croppedRefImages, croppedNewImages,
		correspondingPointsRef, correspondingPointsNew, shiftX, shiftY, alignedNewImage
	},
	(* Extract image dimensions *)
	imageSize = ImageDimensions[refBrightField];

	(* Find the pixel width by inverting the scale and stripping units *)
	pixelWidth = QuantityMagnitude[1 / scale];

	(* Define the edge region width where we check for image correlation *)
	maskWidth = Min[Round[0.1*imageSize[[1]], 10], 200];

	(* There is no straightforward way to calculate x/y shift in MM *)
	(* To reduce calculation, crop the images to the 4 plate edges *)
	plateEdgesRows = {{0, imageSize[[2]]}, {0, imageSize[[2]]}, {0, maskWidth}, {imageSize[[2]] - maskWidth, imageSize[[2]]}};
	plateEdgesColumns = {{0, maskWidth}, {imageSize[[1]] - maskWidth, imageSize[[1]]}, {0, imageSize[[1]]}, {0, imageSize[[1]]}};
	croppedRefImages = MapThread[
		ImageTake[refBrightField, #1, #2]&,
		{
			plateEdgesRows,
			plateEdgesColumns
		}
	];

	croppedNewImages = MapThread[
		ImageTake[newBrightField, #1, #2]&,
		{
			plateEdgesRows,
			plateEdgesColumns
		}
	];

	(* Extract corresponding points *)
	(* ImageCorrespondingPoints is a built-in function finds set of matching features on both images and return coordinates *)
	(* Examples of key features are the indentation label on plate edge, plate edge itself, or notches *)
	{correspondingPointsRef, correspondingPointsNew} = Transpose@MapThread[
		ImageCorrespondingPoints[#1, #2]&,
		{croppedRefImages, croppedNewImages}
	];

	(* Calculate the Shifts *)
	{shiftX, shiftY} = If[MatchQ[correspondingPointsRef, {{}..}],
		(* If no key features are found, we assume no shift between 2 images *)
		{0, 0},
		(* If there are any key features, we check the coordinate pairs *)
		Module[{shiftsOutput, averageXShift, averageYShift},
			shiftsOutput = MapThread[
				Function[{listOfRefPoints, listOfNewPoints},
					If[MatchQ[listOfRefPoints, {}],
						Nothing,
						Flatten[MapThread[
							(* If the difference on the same key feature pair is more than half image size, we do not trust it, return Nothing *)
							If[RangeQ[#2[[1]]-#1[[1]], {-0.5*maskWidth, 0.5*maskWidth}] && RangeQ[#2[[2]]-#1[[2]], {-0.5*maskWidth, 0.5*maskWidth}],
								{#2[[1]]-#1[[1]], #2[[2]]-#1[[2]]},
								Nothing
							]&,
							{listOfRefPoints, listOfNewPoints}
						]
					], 1]
				],
				{correspondingPointsRef, correspondingPointsNew}
			];
			averageXShift = If[MatchQ[shiftsOutput, {{}..}], 0, Mean[Cases[shiftsOutput, Except[{}]][[All, 1]]]];
			averageYShift = If[MatchQ[shiftsOutput, {{}..}], 0, Mean[Cases[shiftsOutput, Except[{}]][[All, 2]]]];
			(* Return the shift in pixel unit *)
			{averageXShift, averageYShift}
		]
	];

	alignedNewImage = translateImage[newBrightField, {shiftX, shiftY}, imageSize];

	(* Output the Shifts *)
	{alignedNewImage, {Round[shiftX*pixelWidth, 0.01] Millimeter, Round[shiftY*pixelWidth, 0.01] Millimeter}}

];

(* Rotate coordinate 180 degree *)
rotateCoordinates[coordinatesList_, imageSize_] := Module[{},
	Map[
		{imageSize[[1]] - #[[1]], imageSize[[2]] - #[[2]]}&,
		coordinatesList
	]
];

(* Shift coordinates horizontally or vertically *)
shiftCoordinates[coordinatesList_, shifts_] := Module[{},
	Map[
		{#[[1]] - shifts[[1]], #[[2]] - shifts[[2]]}&,
		coordinatesList
	]
];

(*Helper function to draw superimpose colonies boundaries on a single image *)
hightLightColonies[image_, colonyBoundaries_, scale_] := Module[{boundariesInPixel, imageSize, coloniesLayer},
	imageSize = ImageDimensions[image];
	(* Convert the boundaries from millimeter back to pixels *)
	boundariesInPixel = QuantityMagnitude[colonyBoundaries]*Unitless[scale];
	(* Build the graphics containing all the polygons *)
	coloniesLayer = Graphics[
		{
			FaceForm[{Opacity[0.0]}],
			EdgeForm[{polygonColor[{1}], Dashing[{}], AbsoluteThickness[0.75]}],(*Yellow*)
			Polygon[boundariesInPixel]
		},
		PlotRange -> {{0, imageSize[[1]]}, {0, imageSize[[2]]}},
		ImagePadding -> None,
		PlotRangePadding -> None
	];
	(* Combine the colonies boundaries (yellow) with adjusted image *)
	ImageCompose[image, ImageResize[coloniesLayer, imageSize]]
];

(* Function to determine the patch index for a given coordinate *)
getPatchIndex[{x_, y_}, patchSize_, colMax_] := Module[
	{column, row},
	{column, row} = {
		Ceiling[x/patchSize],
		Ceiling[y/patchSize]
	};
	(*
=============================================
===           -               -            ===
===    4      -      5        -      6     ===
===           -               -     {3,2}  ===
===----------------------------------------===
===           -               -            ===
===     1     -       2       -      3     ===
===  {1,1}    -               -            ===
=============================================
*)
	(* Convert from matrix form to number form *)
	(* E.g. {1,1} -> 1, {2,1} -> 2*)
	(row - 1)*colMax + column
];

(* Function to determine there are new colonies *)
(* Every colony in newColonySet is compared with boundaries in refColonySet *)
(* If it is new, the centers and boundaries will be appended to refColonySet *)
trackNewColonies[refColonySet_, newColonySet_] := Module[
	{refBoundaries, refCenters, newCenters, newBoundaries,refColonyNumber, existingColonyPositions, nonExistingColonyCenters, nonExistingColonyBoundaries},

	refBoundaries = refColonySet[[2]];
	refCenters = refColonySet[[1]];
	newCenters = newColonySet[[1]];
	newBoundaries = newColonySet[[2]];
	refColonyNumber = refColonySet[[3]];

	(* Convert to pixels and pull off units for InPolygonQ *)
	existingColonyPositions = overlappingManualSelection[
		QuantityMagnitude[newCenters],
		QuantityMagnitude[refBoundaries],
		QuantityMagnitude[refCenters],
		1(*roundingTolerance*)
	];

	nonExistingColonyCenters = ReplacePart[newCenters, Thread[existingColonyPositions -> Nothing]];
	nonExistingColonyBoundaries = ReplacePart[newBoundaries, Thread[existingColonyPositions -> Nothing]];

	(* Return new set *)
	{Join[refCenters, nonExistingColonyCenters], Join[refBoundaries, nonExistingColonyBoundaries], Append[refColonyNumber, Length[nonExistingColonyCenters]]}
];

(* Generate a graphics of list of distributions *)
plotDistributions[listOfDistribution_, label_, timeString_] := Module[{cleanedDistributions, legend},

	(* If any element in the input list is not distribution, remove it *)
	cleanedDistributions = Cases[listOfDistribution, _DataDistribution];
	legend = PickList[timeString, listOfDistribution, _DataDistribution];

	(* Output bar chart if more than 1 distributions and LinePlot for 1 distribution *)
	Which[
		Length[cleanedDistributions] > 1,
			EmeraldBarChart[
				{cleanedDistributions},
				ErrorBars -> True,
				Legend -> legend,
				FrameLabel -> {None, label},
				ImageSize -> {250, 200}
			],
		Length[cleanedDistributions] == 1,
			Module[{newLabel},
				newLabel = label/.{"Diameter" -> "Diameter (mm)", "ColonySeparation" -> "ColonySeparation (mm)"};
				PlotDistribution[
					cleanedDistributions[[1]],
					FrameLabel -> {newLabel <> " on " <> legend[[1]], "Frequency"},
					ImageSize -> {450, 300}
				]
			],
		True,
			Show[
				Graphics[
					{Text[Style[label <> " Info is not available due to no counts", Medium], {0, 0}]}
				],
				ImageSize -> {450, 300}
			]
	]
];