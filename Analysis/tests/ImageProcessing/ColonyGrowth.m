(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*AnalyzeColonyGrowth*)

(* Define Tests *)
DefineTestsWithCompanions[AnalyzeColonyGrowth,
	{
		(*** Basic Usage ***)
		Example[{Basic, "AnalyzeColonyGrowth can take a list of colonies appearance data as input:"},
			AnalyzeColonyGrowth[
				{
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID]
				},
				Output -> Preview
			],
			_TabView
		],
		Example[{Basic, "AnalyzeColonyGrowth can take a list of colonies analysis data as input:"},
			AnalyzeColonyGrowth[
				{
					Object[Analysis, Colonies, "Analysis data time time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Analysis data time time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID]
				}
			],
			ObjectP[Object[Analysis, ColonyGrowth]],
			TimeConstraint -> 3600
		],
		Example[{Basic, "AnalyzeColonyGrowth can take a single colonies appearance data as input:"},
			AnalyzeColonyGrowth[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Output -> Preview
			],
			_TabView
		],
		Example[{Basic, "AnalyzeColonyGrowth can take a single colonies analysis data as input:"},
			AnalyzeColonyGrowth[
				Object[Analysis, Colonies, "Analysis data time time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID]
			],
			ObjectP[Object[Analysis, ColonyGrowth]]
		],
		(* Additional *)
		Example[{Additional, "If input is appearance data and no colony analysis is associated with it, AnalyzeColonies is called to generate colony analysis on the fly:"},
			AnalyzeColonyGrowth[
				Object[Data, Appearance, Colonies, "BrightField appearance data without analysis for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Output -> Options
			];
			Download[Object[Data, Appearance, Colonies, "BrightField appearance data without analysis for AnalyzeColonyGrowth unit test" <> $SessionUUID], ColonyAnalysis],
			{ObjectP[Object[Analysis, Colonies]]}
		],
		Example[{Additional, "If the second input colony analysis data has ReferenceImages with different orientation as the first data, the coordinates of colonies of the second analysis are rotated and shifted:"},
			AnalyzeColonyGrowth[
				{
					Object[Analysis, Colonies, "Analysis data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Analysis data with flipped few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID]
				},
				Output -> Preview
			],
			_
		],
		Example[{Additional, "If not all input appearance data are on the same orientation, the first BrightField image is used as reference to flip and shift later data:"},
			AnalyzeColonyGrowth[
				{
					Object[Data, Appearance, Colonies, "BrightField appearance data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data with flipped few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID]
				},
				Output -> Preview
			],
			_
		],
		(* Options *)
		Example[{Options, MinDiameter, "Set MinDiameter to allow more small colonies through filtering:"},
			AnalyzeColonyGrowth[
				{Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID]},
				MinDiameter -> 0.5 Millimeter,
				Output -> Options
			],
			KeyValuePattern[{
				MinDiameter -> 0.5 Millimeter
			}]
		],
		Example[{Options, MaxDiameter, "Set MaxDiameter to filter out the larger colonies:"},
			AnalyzeColonyGrowth[
				{Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID]},
				MaxDiameter -> 0.9 Millimeter,
				Output -> Options
			],
			KeyValuePattern[{
				MaxDiameter -> 0.9 Millimeter
			}]
		],
		Example[{Options, MinColonySeparation, "Set MinColonySeparation to filter out the colonies that grow close together:"},
			AnalyzeColonyGrowth[
				{Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID]},
				MinColonySeparation -> 1 Millimeter,
				Output -> Options
			],
			KeyValuePattern[{
				MinColonySeparation -> 1 Millimeter
			}]
		],
		Example[{Options, MinRegularityRatio, "Set MinRegularityRatio to filter out the less regular colonies:"},
			AnalyzeColonyGrowth[
				{Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID]},
				MinRegularityRatio -> 0.9,
				Output -> Options
			],
			KeyValuePattern[{
				MinRegularityRatio -> 0.9
			}]
		],
		Example[{Options, MaxRegularityRatio, "Set the MaxRegularityRatio to filter out the more regular colonies:"},
			AnalyzeColonyGrowth[
				{Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID]},
				MaxRegularityRatio -> 0.9,
				Output -> Options
			],
			KeyValuePattern[{
				MaxRegularityRatio -> 0.9
			}]
		],
		Example[{Options, MinCircularityRatio, "Set MinCircularityRatio to filter out the less circular colonies:"},
			AnalyzeColonyGrowth[
				{Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID]},
				MinCircularityRatio -> 0.9,
				Output -> Options
			],
			KeyValuePattern[{
				MinCircularityRatio -> 0.9
			}]
		],
		Example[{Options, MaxCircularityRatio, "Set MaxCircularityRatio to filter out the more circular colonies:"},
			AnalyzeColonyGrowth[
				{Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID]},
				MaxCircularityRatio -> 0.9,
				Output -> Options
			],
			KeyValuePattern[{
				MaxCircularityRatio -> 0.9
			}]
		],
		Example[{Options, ExcludedColonies, "Set ExcludeColonies to filter out the colonies from previous analysis:"},
			packet = AnalyzeColonyGrowth[
				Object[Data, Appearance, Colonies, "BrightField appearance data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				ExcludedColonies -> {{26.5 Millimeter, 54.9 Millimeter}},
				Upload -> False
			];
			Lookup[packet, Replace[TotalColonyCountsLog]],
			{{_, EqualP[3]}},
			Variables :> {packet}
		],
		(** Messages **)
		Example[{Messages, "EmptyAppearanceData", "An error is thrown if no appearance data is present:"},
			AnalyzeColonyGrowth[
				Object[Analysis, Colonies, "Analysis data without appearance for AnalyzeColonyGrowth unit test" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::EmptyAppearanceData}
		],
		Example[{Messages, "EmptyDataField", "An error is thrown if no image data in appearance data:"},
			AnalyzeColonyGrowth[
				Object[Data, Appearance, Colonies, "BrightField Empty appearance data for AnalyzeColonyGrowth unit test" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::EmptyDataField}
		],
		Example[{Messages, "ConflictingImageDimensions", "An error is thrown if appearance data contains different size of images:"},
			AnalyzeColonyGrowth[
				{
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data with different size for AnalyzeColonyGrowth unit test" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {Error::ConflictingImageDimensions}
		],
		Example[{Messages, "MinCannotExceedMax", "An error is thrown if the minimum option exceeds the maximum option for the filtering option Min/Max pairs:"},
			AnalyzeColonyGrowth[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				MinDiameter -> 1 Millimeter,
				MaxDiameter -> 0.5 Millimeter,
				Upload -> False
			],
			$Failed,
			Messages :> {Error::MinCannotExceedMax, Error::InvalidOption}
		],
		(* --- TESTS --- *)
		Test["Tests are returned with Output->Tests:",
			AnalyzeColonyGrowth[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Output -> Tests,
				Upload -> False
			],
			List[_EmeraldTest..]
		],
		Test["Upload Object[Analysis, ColonyGrowth]:",
			AnalyzeColonyGrowth[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID]
			],
			ObjectP[Object[Analysis, ColonyGrowth]]
		]
	},
	SymbolSetUp :> {
		(* create test objects by name in module *)
		Module[
			{
				modelCellObject, cleanBrightFieldImage, brightFieldImage1, brightFieldImage2, brightFieldImage3, brightFieldImage4,
				importedCleanBrightFieldImage, importedBrightFieldImage1, importedBrightFieldImage2, importedBrightFieldImage3,
				importedBrightFieldImage4, importedBrightFieldSizeImage, cleanBrightFieldCloudFile, brightFieldCloudFile1,
				brightFieldCloudFile2, brightFieldCloudFile3, brightFieldCloudFile4, time0AnalysisObject, time1AnalysisObject,
				time2AnalysisObject, fewColonyAnalysisObject, flippedFewColonyAnalysisObject, allObjects, existingObjects
			},

			allObjects = {
				Model[Cell, "Model[Cell] for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[EmeraldCloudFile, "Test Raw empty plate BrightField Image for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[EmeraldCloudFile, "Test Raw simulated BrightField Image with halfcolonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[EmeraldCloudFile, "Test Raw simulated BrightField Image with allcolonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[EmeraldCloudFile, "Test Raw 4 colonies BrightField Image for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[EmeraldCloudFile, "Test Raw flipped 4 colonies BrightField Image for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField Empty appearance data for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data with flipped few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data without analysis for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data with different size for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Analysis data without appearance for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Analysis data time time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Analysis data time time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Analysis data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Analysis data with flipped few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID]
			};

			existingObjects = PickList[Flatten[allObjects], DatabaseMemberQ[Flatten[allObjects]]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];

			$CreatedObjects = {};

			(* create model[Cell] packet *)
			modelCellObject = Upload[<|
				Type -> Model[Cell],
				Name -> "Model[Cell] for AnalyzeColonyGrowth unit test" <> $SessionUUID
			|>];

			cleanBrightFieldImage = Object[EmeraldCloudFile, "Test BrightField Image of agar without any cell sample"];
			brightFieldImage1 = Object[EmeraldCloudFile, "Test simulated BrightField Image 1 with halfcolonies for runExposureFindingRoutines unit tests"];
			brightFieldImage2 = Object[EmeraldCloudFile, "Test BrightField Image 1 for runExposureFindingRoutines unit tests"];
			brightFieldImage3 = Object[EmeraldCloudFile, "Test BrightField Image of agar with cell sample"];
			brightFieldImage4 = Object[EmeraldCloudFile, "Test BrightField Image of agar with 4 colonies-with lid and 180 degree"];
			importedBrightFieldSizeImage = Object[EmeraldCloudFile, "id:54n6evnrr4Z7"];

			importedCleanBrightFieldImage = cleanBrightFieldImage[CloudFile];
			importedBrightFieldImage1 = brightFieldImage1[CloudFile];
			importedBrightFieldImage2 = brightFieldImage2[CloudFile];
			importedBrightFieldImage3 = brightFieldImage3[CloudFile];
			importedBrightFieldImage4 = brightFieldImage4[CloudFile];

			{
				cleanBrightFieldCloudFile,
				brightFieldCloudFile1,
				brightFieldCloudFile2,
				brightFieldCloudFile3,
				brightFieldCloudFile4
			} = MapThread[
				Upload[
					<|
						Type -> Object[EmeraldCloudFile],
						CloudFile -> #1,
						FileType -> "tif",
						Name -> #2
					|>
				]&,
				{
					{
						importedCleanBrightFieldImage,
						importedBrightFieldImage1,
						importedBrightFieldImage2,
						importedBrightFieldImage3,
						importedBrightFieldImage4
					},
					{
						"Test Raw empty plate BrightField Image for AnalyzeColonyGrowth unit test" <> $SessionUUID,
						"Test Raw simulated BrightField Image with halfcolonies for AnalyzeColonyGrowth unit test" <> $SessionUUID,
						"Test Raw simulated BrightField Image with allcolonies for AnalyzeColonyGrowth unit test" <> $SessionUUID,
						"Test Raw 4 colonies BrightField Image for AnalyzeColonyGrowth unit test" <> $SessionUUID,
						"Test Raw flipped 4 colonies BrightField Image for AnalyzeColonyGrowth unit test" <> $SessionUUID
					}
				}
			];

			(* Change DateCreated for cloud files *)
			Upload[{
				<|
					Object -> cleanBrightFieldCloudFile,
					DateCreated -> Now - 1 Day
				|>,
				<|
					Object -> brightFieldCloudFile1,
					DateCreated -> Now - 10 Hour
				|>,
				<|
					Object -> brightFieldCloudFile2,
					DateCreated -> Now - 8 Hour
				|>,
				<|
					Object -> brightFieldCloudFile3,
					DateCreated -> Now - 22 Hour
				|>,
				<|
					Object -> brightFieldCloudFile4,
					DateCreated -> Now - 20 Hour
				|>
			}];

			(* create appearance packets  *)
			Upload[{
				<|
					Type -> Object[Data, Appearance, Colonies],
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom},
					Name -> "BrightField Empty appearance data for AnalyzeColonyGrowth unit test" <> $SessionUUID,
					Replace[CellTypes] -> Link[modelCellObject]
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "BrightField appearance data at time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID,
					Scale -> $QPixImageScale,
					UncroppedImageFile -> Link[cleanBrightFieldCloudFile],
					ImageFile -> Link[cleanBrightFieldCloudFile],
					Replace[CellTypes] -> Link[modelCellObject],
					DateAcquired -> Now - 1 Day
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "BrightField appearance data at time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID,
					Scale -> $QPixImageScale,
					UncroppedImageFile -> Link[brightFieldCloudFile1],
					ImageFile -> Link[brightFieldCloudFile1],
					Replace[CellTypes] -> Link[modelCellObject],
					DateAcquired -> Now - 10 Hour
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "BrightField appearance data at time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID,
					Scale -> $QPixImageScale,
					UncroppedImageFile -> Link[brightFieldCloudFile2],
					ImageFile -> Link[brightFieldCloudFile2],
					Replace[CellTypes] -> Link[modelCellObject],
					DateAcquired -> Now - 8 Hour
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "BrightField appearance data without analysis for AnalyzeColonyGrowth unit test" <> $SessionUUID,
					Scale -> $QPixImageScale,
					UncroppedImageFile -> Link[brightFieldCloudFile2],
					ImageFile -> Link[brightFieldCloudFile2],
					Replace[CellTypes] -> Link[modelCellObject],
					DateAcquired -> Now - 8 Hour
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "BrightField appearance data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID,
					Scale -> $QPixImageScale,
					UncroppedImageFile -> Link[brightFieldCloudFile3],
					ImageFile -> Link[brightFieldCloudFile3],
					Replace[CellTypes] -> Link[modelCellObject],
					DateAcquired -> Now - 22 Hour
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "BrightField appearance data with flipped few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID,
					Scale -> $QPixImageScale,
					UncroppedImageFile -> Link[brightFieldCloudFile4],
					ImageFile -> Link[brightFieldCloudFile4],
					Replace[CellTypes] -> Link[modelCellObject],
					DateAcquired -> Now - 20 Hour
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom},
					Name -> "BrightField appearance data with different size for AnalyzeColonyGrowth unit test" <> $SessionUUID,
					UncroppedImageFile -> Link[importedBrightFieldSizeImage],
					ImageFile -> Link[importedBrightFieldSizeImage],
					Replace[CellTypes] -> Link[modelCellObject]
				|>,
				<|
					Type -> Object[Analysis, Colonies],
					Name -> "Analysis data without appearance for AnalyzeColonyGrowth unit test" <> $SessionUUID
				|>
			}];

			(* Create analysis objects *)
			time0AnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Populations -> {All}
			];
			time1AnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Populations -> {All}
			];
			time2AnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Populations -> {All}
			];
			fewColonyAnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "BrightField appearance data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Populations -> {All}
			];
			flippedFewColonyAnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "BrightField appearance data with flipped few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
				Populations -> {All}
			];

			Upload[<|Object -> time0AnalysisObject, Name -> "Analysis data time time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID|>];
			Upload[<|Object -> time1AnalysisObject, Name -> "Analysis data time time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID|>];
			Upload[<|Object -> time2AnalysisObject, Name -> "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID|>];
			Upload[<|Object -> fewColonyAnalysisObject, Name -> "Analysis data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID|>];
			Upload[<|Object -> flippedFewColonyAnalysisObject, Name -> "Analysis data with flipped few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID|>];
		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			allObjects = Join[
				Flatten[{
					Model[Cell, "Model[Cell] for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[EmeraldCloudFile, "Test Raw empty plate BrightField Image for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[EmeraldCloudFile, "Test Raw simulated BrightField Image with halfcolonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[EmeraldCloudFile, "Test Raw simulated BrightField Image with allcolonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[EmeraldCloudFile, "Test Raw 4 colonies BrightField Image for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[EmeraldCloudFile, "Test Raw flipped 4 colonies BrightField Image for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField Empty appearance data for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data with flipped few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data without analysis for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data with different size for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Analysis data without appearance for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Analysis data time time point 0 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Analysis data time time point 1 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Analysis data time time point 2 for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Analysis data with few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Analysis data with flipped few colonies for AnalyzeColonyGrowth unit test" <> $SessionUUID]
				}],
				$CreatedObjects
			];
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
			Unset[$CreatedObjects];
		]
	}
];
