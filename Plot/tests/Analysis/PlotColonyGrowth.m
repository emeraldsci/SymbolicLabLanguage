(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*PlotColonyGrowth*)

(* Define Tests *)
DefineTests[PlotColonyGrowth,
	{
		(*** Basic Usage ***)
		Example[{Basic, "PlotColonyGrowth shows morphological changes of colonies over time if multiple references exist:"},
			PlotColonyGrowth[
				Object[Analysis, ColonyGrowth, "ColonyGrowthAnalysis with multiple counts for PlotColonyGrowth unit test" <> $SessionUUID]
			],
			_TabView
		],
		Example[{Basic, "PlotColonyGrowth shows morphological distribution of colonies if a single reference exists:"},
			PlotColonyGrowth[
				Object[Analysis, ColonyGrowth, "ColonyGrowthAnalysis with single count for PlotColonyGrowth unit test" <> $SessionUUID]
			],
			_TabView
		],
		Example[{Basic, "PlotColonyGrowth can take colony analysis performed on an appearance data without any colonies:"},
			PlotColonyGrowth[
				Object[Analysis, ColonyGrowth, "ColonyGrowthAnalysis with zero count for PlotColonyGrowth unit test" <> $SessionUUID]
			],
			_TabView
		]
	},
	SymbolSetUp :> {
		(* create test objects by name in module *)
		Module[
			{
				modelCellObject, cleanBrightFieldImage, brightFieldImage1, brightFieldImage2, importedCleanBrightFieldImage,
				importedBrightFieldImage1, importedBrightFieldImage2, cleanBrightFieldCloudFile, brightFieldCloudFile1,
				brightFieldCloudFile2, time0AnalysisObject, time1AnalysisObject, time2AnalysisObject, zeroCountInputAnalysis, 
				singleInputAnalysis, multipleInputAnalysis, allObjects, existingObjects
			},

			allObjects = {
				Model[Cell, "Model[Cell] for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[EmeraldCloudFile, "Test Raw empty plate BrightField Image for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[EmeraldCloudFile, "Test Raw simulated BrightField Image with halfcolonies for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[EmeraldCloudFile, "Test Raw simulated BrightField Image with allcolonies for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 0 for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 2 for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "ColonyAnalysis at time point 0 for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "ColonyAnalysis at time point 1 for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "ColonyAnalysis at time point 2 for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, ColonyGrowth, "ColonyGrowthAnalysis with zero count for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, ColonyGrowth, "ColonyGrowthAnalysis with single count for PlotColonyGrowth unit test" <> $SessionUUID],
				Object[Analysis, ColonyGrowth, "ColonyGrowthAnalysis with multiple counts for PlotColonyGrowth unit test" <> $SessionUUID]
			};

			existingObjects = PickList[Flatten[allObjects], DatabaseMemberQ[Flatten[allObjects]]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];

			$CreatedObjects = {};

			(* create model[Cell] packet *)
			modelCellObject = Upload[<|
				Type -> Model[Cell],
				Name -> "Model[Cell] for PlotColonyGrowth unit test" <> $SessionUUID
			|>];

			cleanBrightFieldImage = Object[EmeraldCloudFile, "Test BrightField Image of agar without any cell sample"];
			brightFieldImage1 = Object[EmeraldCloudFile, "Test simulated BrightField Image 1 with halfcolonies for runExposureFindingRoutines unit tests"];
			brightFieldImage2 = Object[EmeraldCloudFile, "Test BrightField Image 1 for runExposureFindingRoutines unit tests"];

			importedCleanBrightFieldImage = cleanBrightFieldImage[CloudFile];
			importedBrightFieldImage1 = brightFieldImage1[CloudFile];
			importedBrightFieldImage2 = brightFieldImage2[CloudFile];

			{
				cleanBrightFieldCloudFile,
				brightFieldCloudFile1,
				brightFieldCloudFile2
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
						importedBrightFieldImage2
					},
					{
						"Test Raw empty plate BrightField Image for PlotColonyGrowth unit test" <> $SessionUUID,
						"Test Raw simulated BrightField Image with halfcolonies for PlotColonyGrowth unit test" <> $SessionUUID,
						"Test Raw simulated BrightField Image with allcolonies for PlotColonyGrowth unit test" <> $SessionUUID
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
				|>
			}];

			(* create appearance packets  *)
			Upload[{
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "BrightField appearance data at time point 0 for PlotColonyGrowth unit test" <> $SessionUUID,
					Scale -> $QPixImageScale,
					UncroppedImageFile -> Link[cleanBrightFieldCloudFile],
					ImageFile -> Link[cleanBrightFieldCloudFile],
					Replace[CellTypes] -> Link[modelCellObject]
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "BrightField appearance data at time point 1 for PlotColonyGrowth unit test" <> $SessionUUID,
					Scale -> $QPixImageScale,
					UncroppedImageFile -> Link[brightFieldCloudFile1],
					ImageFile -> Link[brightFieldCloudFile1],
					Replace[CellTypes] -> Link[modelCellObject]
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "BrightField appearance data at time point 2 for PlotColonyGrowth unit test" <> $SessionUUID,
					Scale -> $QPixImageScale,
					UncroppedImageFile -> Link[brightFieldCloudFile2],
					ImageFile -> Link[brightFieldCloudFile2],
					Replace[CellTypes] -> Link[modelCellObject]
				|>
			}];

			(* Create analysis objects *)
			time0AnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 0 for PlotColonyGrowth unit test" <> $SessionUUID],
				Populations -> {All}
			];
			time1AnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for PlotColonyGrowth unit test" <> $SessionUUID],
				Populations -> {All}
			];
			time2AnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "BrightField appearance data at time point 2 for PlotColonyGrowth unit test" <> $SessionUUID],
				Populations -> {All}
			];

			Upload[<|Object -> time0AnalysisObject, Name -> "ColonyAnalysis at time point 0 for PlotColonyGrowth unit test" <> $SessionUUID|>];
			Upload[<|Object -> time1AnalysisObject, Name -> "ColonyAnalysis at time point 1 for PlotColonyGrowth unit test" <> $SessionUUID|>];
			Upload[<|Object -> time2AnalysisObject, Name -> "ColonyAnalysis at time point 2 for PlotColonyGrowth unit test" <> $SessionUUID|>];

			(* Generate Object[Analysis, ColonyGrowth] *)
			zeroCountInputAnalysis = AnalyzeColonyGrowth[
				time0AnalysisObject
			];
			singleInputAnalysis = AnalyzeColonyGrowth[
				time1AnalysisObject
			];
			multipleInputAnalysis = AnalyzeColonyGrowth[
				{
					time0AnalysisObject,
					time1AnalysisObject,
					time2AnalysisObject
				}
			];

			(* Update name *)
			Upload[{
				<|
					Object -> zeroCountInputAnalysis,
					Name -> "ColonyGrowthAnalysis with zero count for PlotColonyGrowth unit test" <> $SessionUUID
				|>,
				<|
					Object -> singleInputAnalysis,
					Name -> "ColonyGrowthAnalysis with single count for PlotColonyGrowth unit test" <> $SessionUUID
				|>,
				<|
					Object -> multipleInputAnalysis,
					Name -> "ColonyGrowthAnalysis with multiple counts for PlotColonyGrowth unit test" <> $SessionUUID
				|>
			}];
			
		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			allObjects = Join[
				Flatten[{
					Model[Cell, "Model[Cell] for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[EmeraldCloudFile, "Test Raw empty plate BrightField Image for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[EmeraldCloudFile, "Test Raw simulated BrightField Image with halfcolonies for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[EmeraldCloudFile, "Test Raw simulated BrightField Image with allcolonies for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 0 for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 1 for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "BrightField appearance data at time point 2 for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "ColonyAnalysis at time point 0 for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "ColonyAnalysis at time point 1 for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "ColonyAnalysis at time point 2 for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, ColonyGrowth, "ColonyGrowthAnalysis with zero count for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, ColonyGrowth, "ColonyGrowthAnalysis with single count for PlotColonyGrowth unit test" <> $SessionUUID],
					Object[Analysis, ColonyGrowth, "ColonyGrowthAnalysis with multiple counts for PlotColonyGrowth unit test" <> $SessionUUID]
				}],
				$CreatedObjects
			];
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
			Unset[$CreatedObjects];
		]
	}
];
