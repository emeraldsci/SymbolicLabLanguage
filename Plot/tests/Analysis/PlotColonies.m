(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotColonies*)

DefineTests[PlotColonies,
	{
		(* Basic *)
		Example[{Basic, "Plot colonies of over a microscope image when a single population is selected:"},
			PlotColonies[Object[Analysis, Colonies, "Test analysis data with single population and single image for PlotColonies unit test" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic, "Plot colonies of over a microscope image when multiple populations are selected:"},
			PlotColonies[Object[Analysis, Colonies, "Test analysis data with multiple populations and single image for PlotColonies unit test" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic, "Plot colonies of over multiple microscope images when multiple populations are selected:"},
			PlotColonies[Object[Analysis, Colonies, "Test analysis data with multiple populations and multiple images for PlotColonies unit test" <> $SessionUUID]],
			_DynamicModule
		],
		Example[{Basic, "Plot colonies of over multiple microscope images when single population is selected:"},
			PlotColonies[Object[Analysis, Colonies, "Test analysis data with single population and multiple images for PlotColonies unit test" <> $SessionUUID]],
			_DynamicModule
		],
		Example[{Basic, "Plot colonies from a link:"},
			PlotColonies[Link[Object[Analysis, Colonies, "Test analysis data with single population and single image for PlotColonies unit test" <> $SessionUUID], Reference]],
			_Grid
		],
		(* Options *)
		Example[{Options, ImageType, "Use ImageType to indicate whether different images should be displayed:"},
			PlotColonies[Object[Analysis, Colonies, "Test analysis data with multiple populations and multiple images for PlotColonies unit test" <> $SessionUUID],
				ImageType -> BrightField
			],
			_Grid
		],
		(* Messages *)
		Example[{Messages, "NoCounts", "Plot just the microscope image when no colony is detected:"},
			PlotColonies[Object[Analysis, Colonies, "Test analysis data with single population at zero count for PlotColonies unit test" <> $SessionUUID]],
			_Grid,
			Messages :> {PlotColonies::NoCounts}
		],
		Example[{Messages, "ImageNotFound", "No image file is detected:"},
			PlotColonies[Object[Analysis, Colonies, "Test analysis data without image for PlotColonies unit test" <> $SessionUUID]],
			Null,
			Messages :> {PlotColonies::ImageNotFound}
		],
		Test["Given a packet:",
			PlotColonies[Download[Object[Analysis, Colonies, "Test analysis data with single population and single image for PlotColonies unit test" <> $SessionUUID]]],
			_Grid
		]
	},
	SymbolSetUp :> {
		(* create test objects by name in module *)
		Module[
			{
				allObjects, existingObjects, importedBrightFieldImage1, importedFluorescenceImage1, importedBrightFieldImage2,
				importedBlueWhiteScreenImage2, noCountAnalysisObject, singlePopulationAnalysisObject, multiplePopulationsSingleImageAnalysisObject,
				multiplePopulationsMultipleImageAnalysisObject, singlePopulationMultipleImageAnalysisObject
			},

			allObjects = {
				Object[Data, Appearance, Colonies, "Test appearance data with BrightField for Empty Plate for PlotColonies unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "Test appearance data with BrightField of microbial colonies for PlotColonies unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "Test appearance data with BrightField and flipped Absorbance with several colonies for PlotColonies unit test" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "Test appearance data with BrightField and Fluorescence of microbial colonies for PlotColonies unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Test analysis data without image for PlotColonies unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Test analysis data with single population at zero count for PlotColonies unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Test analysis data with single population and single image for PlotColonies unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Test analysis data with multiple populations and single image for PlotColonies unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Test analysis data with multiple populations and multiple images for PlotColonies unit test" <> $SessionUUID],
				Object[Analysis, Colonies, "Test analysis data with single population and multiple images for PlotColonies unit test" <> $SessionUUID]
			};

			existingObjects = PickList[Flatten[allObjects], DatabaseMemberQ[Flatten[allObjects]]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
			$CreatedObjects = {};

			importedBrightFieldImage1 = Object[EmeraldCloudFile, "Test BrightField Image 1 for runExposureFindingRoutines unit tests"];
			importedFluorescenceImage1 = Object[EmeraldCloudFile, "id:mnk9jOkG177Y"];
			importedBrightFieldImage2 = Object[EmeraldCloudFile, "Test BrightField Image of agar with cell sample"];
			importedBlueWhiteScreenImage2 = Object[EmeraldCloudFile, "Test BrightField Image of agar with 4 colonies-with lid and 180 degree"];
			
			(* create appearance packets *)
			Upload[{
				<|
					Type -> Object[Data, Appearance, Colonies],
					ImageFile -> Link[Object[EmeraldCloudFile, "Test BrightField Image of agar without any cell sample"]],
					ExposureTime -> 10 Millisecond,
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom},
					Name -> "Test appearance data with BrightField for Empty Plate for PlotColonies unit test" <> $SessionUUID
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "Test appearance data with BrightField of microbial colonies for PlotColonies unit test" <> $SessionUUID,
					ImageFile -> Link[importedBrightFieldImage1],
					ExposureTime -> 10 Millisecond,
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom}
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "Test appearance data with BrightField and flipped Absorbance with several colonies for PlotColonies unit test" <> $SessionUUID,
					ImageFile -> Link[importedBrightFieldImage2],
					ExposureTime -> 10 Millisecond,
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom},
					BlueWhiteScreenImageFile -> Link[importedBlueWhiteScreenImage2],
					BlueWhiteScreenFilterWavelength -> 400 Nanometer,
					BlueWhiteScreenExposureTime -> 10 Millisecond,
					BlueWhiteScreenImageScale -> $QPixImageScale
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "Test appearance data with BrightField and Fluorescence of microbial colonies for PlotColonies unit test" <> $SessionUUID,
					ImageFile -> Link[importedBrightFieldImage1],
					ExposureTime -> 10 Millisecond,
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom},
					GreenFluorescenceImageFile -> Link[importedFluorescenceImage1],
					GreenFluorescenceExcitationWavelength -> 457 Nanometer,
					GreenFluorescenceEmissionWavelength -> 536 Nanometer,
					GreenFluorescenceExposureTime -> 100 Millisecond,
					GreenFluorescenceImageScale -> $QPixImageScale
				|>
			}];

			(* Create analysis objects *)
			noCountAnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Test appearance data with BrightField for Empty Plate for PlotColonies unit test" <> $SessionUUID],
				Populations -> {All}
			];
			singlePopulationAnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Test appearance data with BrightField of microbial colonies for PlotColonies unit test" <> $SessionUUID],
				Populations -> {All}
			];
			multiplePopulationsSingleImageAnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Test appearance data with BrightField of microbial colonies for PlotColonies unit test" <> $SessionUUID],
				Populations -> {Diameter[], Circularity[]}
			];
			multiplePopulationsMultipleImageAnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Test appearance data with BrightField and flipped Absorbance with several colonies for PlotColonies unit test" <> $SessionUUID],
				Populations -> {Diameter[], BlueWhiteScreen[]}
			];
			singlePopulationMultipleImageAnalysisObject = AnalyzeColonies[
				Object[Data, Appearance, Colonies, "Test appearance data with BrightField and Fluorescence of microbial colonies for PlotColonies unit test" <> $SessionUUID],
				Populations -> {All}
			];
			Upload[{
				<|Type -> Object[Analysis, Colonies], Name -> "Test analysis data without image for PlotColonies unit test" <> $SessionUUID|>,
				<|Object -> noCountAnalysisObject, Name -> "Test analysis data with single population at zero count for PlotColonies unit test" <> $SessionUUID|>,
				<|Object -> singlePopulationAnalysisObject, Name -> "Test analysis data with single population and single image for PlotColonies unit test" <> $SessionUUID|>,
				<|Object -> multiplePopulationsSingleImageAnalysisObject, Name -> "Test analysis data with multiple populations and single image for PlotColonies unit test" <> $SessionUUID|>,
				<|Object -> multiplePopulationsMultipleImageAnalysisObject, Name -> "Test analysis data with multiple populations and multiple images for PlotColonies unit test" <> $SessionUUID|>,
				<|Object -> singlePopulationMultipleImageAnalysisObject, Name -> "Test analysis data with single population and multiple images for PlotColonies unit test" <> $SessionUUID|>
			}]

		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			allObjects = Join[
				Flatten[{
					Object[Data, Appearance, Colonies, "Test appearance data with BrightField for Empty Plate for PlotColonies unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "Test appearance data with BrightField of microbial colonies for PlotColonies unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "Test appearance data with BrightField and flipped Absorbance with several colonies for PlotColonies unit test" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "Test appearance data with BrightField and Fluorescence of microbial colonies for PlotColonies unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Test analysis data without image for PlotColonies unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Test analysis data with single population at zero count for PlotColonies unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Test analysis data with single population and single image for PlotColonies unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Test analysis data with multiple populations and single image for PlotColonies unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Test analysis data with multiple populations and multiple images for PlotColonies unit test" <> $SessionUUID],
					Object[Analysis, Colonies, "Test analysis data with single population and multiple images for PlotColonies unit test" <> $SessionUUID]
				}],
				$CreatedObjects
			];
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
			Unset[$CreatedObjects];
		]
	}
];
