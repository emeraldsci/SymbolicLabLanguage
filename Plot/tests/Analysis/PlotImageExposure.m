(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotImageExposure*)

DefineTests[PlotImageExposure,
	{
		(* Basic *)
		Example[{Basic, "Plot lane images when the reference is PAGE data:"},
			PlotImageExposure[Object[Analysis, ImageExposure, "Test ImageExposure Analysis PAGE for PlotImageExposure tests" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic, "Plot image when a single exposure time is recorded from analysis object:"},
			PlotImageExposure[Object[Analysis, ImageExposure, "Test ImageExposure Analysis 6 for PlotImageExposure tests" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic, "Plot images over exposure times when multiple exposure times are recorded from analysis object:"},
			PlotImageExposure[Object[Analysis, ImageExposure, "Test ImageExposure Analysis 10 for PlotImageExposure tests" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic, "Plot image when a single exposure time is recorded from appearance object:"},
			PlotImageExposure[Object[Data, Appearance, Colonies, "Test appearance data with Brightfield with 1 exposure for PlotImageExposure tests" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic, "Plot images over exposure times when multiple exposure times are recorded from appearance object:"},
			PlotImageExposure[Object[Data, Appearance, Colonies, "Test appearance data with Brightfield with 2 exposures for PlotImageExposure tests" <> $SessionUUID]],
			_Grid
		],
		(* Options *)
		Example[{Options, ImageType, "Use ImageType to indicate whether different images should be displayed:"},
			PlotImageExposure[
				Object[Data, Appearance, Colonies, "Test appearance data with Brightfield and Fluorescence for PlotImageExposure tests" <> $SessionUUID],
				ImageType -> GreenFluorescence
			],
			_Grid
		],
		(* Messages *)
		Example[{Messages, "AnalysisNotFound", "No analysis is detected:"},
			PlotImageExposure[Object[Data, Appearance, Colonies, "Test appearance data without analysis for PlotImageExposure tests" <> $SessionUUID]],
			$Failed,
			Messages :> {PlotImageExposure::AnalysisNotFound}
		],
		Example[{Messages, "ImageNotFound", "No image file is detected:"},
			PlotImageExposure[Object[Data, Appearance, Colonies, "Test appearance data without image for PlotImageExposure tests" <> $SessionUUID]],
			$Failed,
			Messages :> {PlotImageExposure::ImageNotFound}
		],
		Example[{Messages, "ConflictingImageTypes", "Throws an error if image file type detected is conflicting with ImageType option:"},
			PlotImageExposure[Object[Analysis, ImageExposure, "Test ImageExposure Analysis 1 for PlotImageExposure tests" <> $SessionUUID], ImageType -> VioletFluorescence],
			$Failed,
			Messages :> {PlotImageExposure::ConflictingImageTypes}
		],
		Test["Given a packet:",
			PlotImageExposure[Download[Object[Analysis, ImageExposure, "Test ImageExposure Analysis 1 for PlotImageExposure tests" <> $SessionUUID]]],
			_Grid
		]
	},
	SymbolSetUp :> {
		(* create test objects by name in module *)
		Module[
			{
				allObjects, existingObjects, importedOptimalBrightFieldImage, importedBlueWhiteScreenImage, importedFluorescenceImage2,
				importedUnderBrightFieldImage, importedFluorescenceImage1, importedFluorescenceImage3, testData1, testData2,
				testData3, testData4, testData5, testData6, testImageExposureAnalysis1, testImageExposureAnalysis2,
				testImageExposureAnalysis3, testImageExposureAnalysis4, testImageExposureAnalysis5, testImageExposureAnalysis6,
				testImageExposureAnalysis7, testImageExposureAnalysis8, testImageExposureAnalysis9, testImageExposureAnalysis10,
				testImageExposureAnalysisPAGE
			},

			allObjects = {
				Object[Data, Appearance, Colonies, "Test appearance data without image for PlotImageExposure tests" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "Test appearance data without analysis for PlotImageExposure tests" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "Test appearance data with Brightfield with 1 exposure for PlotImageExposure tests" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "Test appearance data with Brightfield with 2 exposures for PlotImageExposure tests" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "Test appearance data with Brightfield and BlueWhiteScreen for PlotImageExposure tests" <> $SessionUUID],
				Object[Data, Appearance, Colonies, "Test appearance data with Brightfield and Fluorescence for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis PAGE for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 1 for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 2 for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 3 for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 4 for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 5 for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 6 for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 7 for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 8 for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 9 for PlotImageExposure tests" <> $SessionUUID],
				Object[Analysis, ImageExposure, "Test ImageExposure Analysis 10 for PlotImageExposure tests" <> $SessionUUID]
			};

			existingObjects = PickList[Flatten[allObjects], DatabaseMemberQ[Flatten[allObjects]]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
			$CreatedObjects = {};

			(* Import images *)
			importedUnderBrightFieldImage = Object[EmeraldCloudFile, "Test BrightField Image UnderExposure for runExposureFindingRoutines unit tests"];
			importedOptimalBrightFieldImage = Object[EmeraldCloudFile, "Test BrightField Image 1 for runExposureFindingRoutines unit tests"];
			importedBlueWhiteScreenImage = Object[EmeraldCloudFile, "Test Absorbance Image 1 for runAbsorbanceExposureFindingRoutines unit tests"];
			importedFluorescenceImage1 = Object[EmeraldCloudFile, "id:jLq9jXqVzzva"];
			importedFluorescenceImage2 = Object[EmeraldCloudFile, "id:9RdZXvdm441x"];
			importedFluorescenceImage3 = Object[EmeraldCloudFile, "id:Z1lqpMl0nnlz"];

			(* create appearance packets *)
			{testData1, testData2, testData3, testData4, testData5, testData6} = Upload[{
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "Test appearance data without image for PlotImageExposure tests" <> $SessionUUID
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					ImageFile -> Link[importedOptimalBrightFieldImage],
					ExposureTime -> 10 Millisecond,
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom},
					Name -> "Test appearance data without analysis for PlotImageExposure tests" <> $SessionUUID
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					ImageFile -> Link[importedOptimalBrightFieldImage],
					ExposureTime -> 10 Millisecond,
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom},
					Name -> "Test appearance data with Brightfield with 1 exposure for PlotImageExposure tests" <> $SessionUUID
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "Test appearance data with Brightfield with 2 exposures for PlotImageExposure tests" <> $SessionUUID,
					ImageFile -> Link[importedOptimalBrightFieldImage],
					ExposureTime -> 20 Millisecond,
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom}
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "Test appearance data with Brightfield and BlueWhiteScreen for PlotImageExposure tests" <> $SessionUUID,
					ImageFile -> Link[importedOptimalBrightFieldImage],
					ExposureTime -> 20 Millisecond,
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom},
					BlueWhiteScreenImageFile -> Link[importedBlueWhiteScreenImage],
					BlueWhiteScreenFilterWavelength -> 400 Nanometer,
					BlueWhiteScreenExposureTime -> 10 Millisecond,
					BlueWhiteScreenImageScale -> $QPixImageScale
				|>,
				<|
					Type -> Object[Data, Appearance, Colonies],
					Name -> "Test appearance data with Brightfield and Fluorescence for PlotImageExposure tests" <> $SessionUUID,
					ImageFile -> Link[importedOptimalBrightFieldImage],
					ExposureTime -> 10 Millisecond,
					Scale -> $QPixImageScale,
					ImagingDirection -> Top,
					Replace[IlluminationDirection] -> {Bottom},
					GreenFluorescenceImageFile -> Link[importedFluorescenceImage1],
					GreenFluorescenceExcitationWavelength -> 457 Nanometer,
					GreenFluorescenceEmissionWavelength -> 536 Nanometer,
					GreenFluorescenceExposureTime -> 75 Millisecond,
					GreenFluorescenceImageScale -> $QPixImageScale
				|>
			}];

			(* Create analysis objects *)
			testImageExposureAnalysis1 = AnalyzeImageExposure[
				testData3
			];
			{testImageExposureAnalysis2} = AnalyzeImageExposure[
				{10 Millisecond, Link[importedUnderBrightFieldImage]},
				ImageType -> BrightField
			];
			{testImageExposureAnalysis3} = AnalyzeImageExposure[
				{{10 Millisecond, Link[importedUnderBrightFieldImage]}, {20 Millisecond, Link[importedOptimalBrightFieldImage]}},
				ImageType -> BrightField
			];
			Upload[<|
				Object -> testData4,
				Replace[ImageExposureAnalyses] -> {
					Link[testImageExposureAnalysis2, Reference],
					Link[testImageExposureAnalysis3, Reference]
				}
			|>];
			{testImageExposureAnalysis4} = AnalyzeImageExposure[
				{10 Millisecond, Link[importedUnderBrightFieldImage]},
				ImageType -> BrightField
			];
			{testImageExposureAnalysis5} = AnalyzeImageExposure[
				{{10 Millisecond, Link[importedUnderBrightFieldImage]}, {20 Millisecond, Link[importedOptimalBrightFieldImage]}},
				ImageType -> BrightField
			];
			{testImageExposureAnalysis6} = AnalyzeImageExposure[
				{10 Millisecond, Link[importedBlueWhiteScreenImage]},
				ImageType -> BlueWhiteScreen
			];
			Upload[<|
				Object -> testData5,
				Replace[ImageExposureAnalyses] -> {
					Link[testImageExposureAnalysis4, Reference],
					Link[testImageExposureAnalysis5, Reference],
					Link[testImageExposureAnalysis6, Reference]
				}
			|>];
			{testImageExposureAnalysis7} = AnalyzeImageExposure[
				{10 Millisecond, Link[importedUnderBrightFieldImage]},
				ImageType -> BrightField
			];
			{testImageExposureAnalysis8} = AnalyzeImageExposure[
				{100 Millisecond, Link[importedFluorescenceImage3]},
				ImageType -> GreenFluorescence
			];
			{testImageExposureAnalysis9} = AnalyzeImageExposure[
				{{100 Millisecond, Link[importedFluorescenceImage3]}, {75 Millisecond, Link[importedFluorescenceImage2]}},
				ImageType -> GreenFluorescence
			];
			{testImageExposureAnalysis10} = AnalyzeImageExposure[
				{{100 Millisecond, Link[importedFluorescenceImage3]}, {75 Millisecond, Link[importedFluorescenceImage2]}, {50 Millisecond, Link[importedFluorescenceImage1]}},
				ImageType -> GreenFluorescence
			];
			Upload[<|
				Object -> testData6,
				Replace[ImageExposureAnalyses] -> {
					Link[testImageExposureAnalysis7, Reference],
					Link[testImageExposureAnalysis8, Reference],
					Link[testImageExposureAnalysis9, Reference],
					Link[testImageExposureAnalysis10, Reference]
				}
			|>];
			MapThread[
			Upload[<|Object -> #1, Name -> "Test ImageExposure Analysis " <> ToString[#2] <> " for PlotImageExposure tests" <> $SessionUUID |>]&,
				{
					{
						testImageExposureAnalysis1,
						testImageExposureAnalysis2,
						testImageExposureAnalysis3,
						testImageExposureAnalysis4,
						testImageExposureAnalysis5,
						testImageExposureAnalysis6,
						testImageExposureAnalysis7,
						testImageExposureAnalysis8,
						testImageExposureAnalysis9,
						testImageExposureAnalysis10
					},
					Range[10]
				}
			];

			testImageExposureAnalysisPAGE = AnalyzeImageExposure[Object[Protocol, PAGE, "id:wqW9BPWWYed9"]];
			Upload[<|Object -> testImageExposureAnalysisPAGE, Name -> "Test ImageExposure Analysis PAGE for PlotImageExposure tests" <> $SessionUUID|>]
		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			allObjects = Join[
				Flatten[{
					Object[Data, Appearance, Colonies, "Test appearance data without image for PlotImageExposure tests" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "Test appearance data without analysis for PlotImageExposure tests" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "Test appearance data with Brightfield with 1 exposure for PlotImageExposure tests" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "Test appearance data with Brightfield with 2 exposures for PlotImageExposure tests" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "Test appearance data with Brightfield and BlueWhiteScreen for PlotImageExposure tests" <> $SessionUUID],
					Object[Data, Appearance, Colonies, "Test appearance data with Brightfield and Fluorescence for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis PAGE for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 1 for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 2 for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 3 for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 4 for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 5 for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 6 for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 7 for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 8 for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 9 for PlotImageExposure tests" <> $SessionUUID],
					Object[Analysis, ImageExposure, "Test ImageExposure Analysis 10 for PlotImageExposure tests" <> $SessionUUID]
				}],
				$CreatedObjects
			];
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False];
			Unset[$CreatedObjects];
		]
	}
];
