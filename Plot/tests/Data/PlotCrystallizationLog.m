(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCrystallizationImagingLog*)

DefineTests[PlotCrystallizationImagingLog,
	{
		Example[{Basic, "Given an Object[Sample] with CrystallizationImagingLog, PlotCrystallizationImagingLog returns a plot:"},
			PlotCrystallizationImagingLog[Object[Sample, "PlotCrystallizationImagingLog test drop sample 1 " <> $SessionUUID]],
			_Pane
		],
		Example[{Basic, "Given multiple Object[Sample]s with CrystallizationImagingLog, PlotCrystallizationImagingLog returns a plot:"},
			PlotCrystallizationImagingLog[
				{
					Object[Sample, "PlotCrystallizationImagingLog test drop sample 1 " <> $SessionUUID],
					Object[Sample, "PlotCrystallizationImagingLog test drop sample 2 " <> $SessionUUID]
				}
			],
			_Pane
		],
		Example[{Options, ImageSize, "Specify ImageSize of each crystallization image:"},
			PlotCrystallizationImagingLog[
				Object[Sample, "PlotCrystallizationImagingLog test drop sample 1 " <> $SessionUUID],
				ImageSize -> 300
			],
			_Pane
		],
		Example[{Additional, "Given an Object[Sample] without CrystallizationImagingLog, PlotCrystallizationImagingLog returns Null:"},
			PlotCrystallizationImagingLog[Object[Sample, "PlotCrystallizationImagingLog test reservoir sample 1 " <> $SessionUUID]],
			Null
		]
	},
	SymbolSetUp :> {
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{existingObjects, allObjects},
			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				Object[Container, Bench, "Bench for PlotCrystallizationImagingLog tests " <> $SessionUUID],
				Object[Container, Plate, Irregular, Crystallization, "PlotCrystallizationImagingLog test Plate 1 " <> $SessionUUID],
				Object[Sample, "PlotCrystallizationImagingLog test drop sample 1 " <> $SessionUUID],
				Object[Sample, "PlotCrystallizationImagingLog test drop sample 2 " <> $SessionUUID],
				Object[Sample, "PlotCrystallizationImagingLog test reservoir sample 1 " <> $SessionUUID],
				Object[Sample, "PlotCrystallizationImagingLog test reservoir sample 2 " <> $SessionUUID],
				Object[Data, Appearance, Crystals, "Test ImageData for PlotCrystallizationImagingLog test drop sample 1 " <> $SessionUUID],
				Object[Data, Appearance, Crystals, "Test ImageData for PlotCrystallizationImagingLog test drop sample 2 " <> $SessionUUID]
			}], ObjectP[]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		Module[
			{
				bench, now, plate1, allSamples, rawCloudfiles, dataDirectories, allImages, names, testVisibleLightImages,
				testCrossPolarizedImages, testUVImages, testData
			},

			(* Create test bench *)
			bench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Bench for PlotCrystallizationImagingLog tests " <> $SessionUUID,
				Site-> Link[$Site],
				DeveloperObject -> True,
				Notebook -> Null
			|>];

			(* Grab a timepoint *)
			now = Now;

			(* Create crystallization plate and samples with notebook *)
			Block[{$Notebook = Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], $DeveloperUpload = True},
				(* Create Containers *)
				plate1 = ECL`InternalUpload`UploadSample[
					Model[Container, Plate, Irregular, Crystallization, "MRC Maxi 48 Well Plate"],
					{"Work Surface", bench},
					Name -> "PlotCrystallizationImagingLog test Plate 1 " <> $SessionUUID
				];

				(* Create Samples *)
				allSamples = ECL`InternalUpload`UploadSample[
					{
						Model[Sample, StockSolution, "20 mg/ml Lysozyme crystallization stock"],
						Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
						Model[Sample, "0.02 M Sodium Acetate Trihydrate pH 4.6"],
						Model[Sample, "0.02 M Sodium Acetate Trihydrate pH 4.6"]
					},
					{
						{"A1Drop1", plate1},
						{"B1Drop1", plate1},
						{"A1Reservoir", plate1},
						{"B1Reservoir", plate1}
					},
					InitialAmount -> {4 Microliter, 4 Microliter, 100 Microliter, 100 Microliter},
					StorageCondition -> ConstantArray[Model[StorageCondition, "Refrigerator"], 4],
					Name -> {
						"PlotCrystallizationImagingLog test drop sample 1 " <> $SessionUUID,
						"PlotCrystallizationImagingLog test drop sample 2 " <> $SessionUUID,
						"PlotCrystallizationImagingLog test reservoir sample 1 " <> $SessionUUID,
						"PlotCrystallizationImagingLog test reservoir sample 2 " <> $SessionUUID
					}
				];

				(* Populate CrystallizationImage and CrystallizationImagingLog for drop samples *)
				rawCloudfiles = {
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard14/c1b4cd5b5eff004d18d46111809c40f5.jpg"],(*VisibleLightImage*)
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard4/d649a304dad4d6bdbc65f68ae3c207ef.jpg"],(*CrossPolarizedLightImage*)
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard15/8893f96fd5263833fa8863ae971b984e.jpg"],(*UVImage*)
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/ff7505443c379d95c4d9c406344d23d8.jpg"],(*VisibleLightImage*)
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard0/4536df7c3db1f1c23fd1a971de81f35c.jpg"],(*CrossPolarizedLightImage*)
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard4/4c756ac3a43105a67bce2173b7ffeac9.jpg"](*UVImage*)
				};
				(* Create directories on $TemporaryDirectory for plate 1 & 5 *)
				(* VisibleLightImaging -> "1", CrossPolarizedImaging -> "11" and "UVImaging" -> "8" *)
				dataDirectories = {
					FileNameJoin[Flatten[{$TemporaryDirectory, "Data", "CrystalIncubator", $SessionUUID, "123", "plateID_123", "batchID_001", "wellNum_1", "profileID_1"}]],(*"SyncCrystallizationData test drop sample 1 " <> $SessionUUID*)
					FileNameJoin[Flatten[{$TemporaryDirectory, "Data", "CrystalIncubator", $SessionUUID, "123", "plateID_123", "batchID_001", "wellNum_1", "profileID_11"}]],
					FileNameJoin[Flatten[{$TemporaryDirectory, "Data", "CrystalIncubator", $SessionUUID, "123", "plateID_123", "batchID_001", "wellNum_1", "profileID_8"}]],
					FileNameJoin[Flatten[{$TemporaryDirectory, "Data", "CrystalIncubator", $SessionUUID, "123", "plateID_123", "batchID_001", "wellNum_7", "profileID_1"}]],(*"SyncCrystallizationData test drop sample 2 " <> $SessionUUID*)
					FileNameJoin[Flatten[{$TemporaryDirectory, "Data", "CrystalIncubator", $SessionUUID, "123", "plateID_123", "batchID_001", "wellNum_7", "profileID_11"}]],
					FileNameJoin[Flatten[{$TemporaryDirectory, "Data", "CrystalIncubator", $SessionUUID, "123", "plateID_123", "batchID_001", "wellNum_7", "profileID_8"}]]
				};
				Quiet[CreateDirectory[dataDirectories], {CreateDirectory::filex, CreateDirectory::eexist}];
				(* Download image files to local directories *)
				allImages = MapThread[DownloadCloudFile[#1, #2]&, {rawCloudfiles, FileNameJoin[Append[FileNameSplit[#], "d1_r0000_ef.jpg"]]& /@ dataDirectories}];

				testVisibleLightImages = UploadCloudFile[allImages[[1;;;;3]]];
				testCrossPolarizedImages = UploadCloudFile[allImages[[2;;;;3]]];
				testUVImages = UploadCloudFile[allImages[[3;;;;3]]];
				names = {
					"Test ImageData for PlotCrystallizationImagingLog test drop sample 1 " <> $SessionUUID,
					"Test ImageData for PlotCrystallizationImagingLog test drop sample 2 " <> $SessionUUID
				};
				testData = MapThread[
					Upload[<|
						Type -> Object[Data, Appearance, Crystals],
						Name -> #1,
						VisibleLightImageFile -> Link[#2],
						VisibleLightObjectiveMagnification -> 1.2,
						VisibleLightImageScale -> 200 Pixel/Millimeter,
						CrossPolarizedImageFile -> Link[#3],
						CrossPolarizationObjectiveMagnification -> 1.2,
						CrossPolarizedImageScale -> 200 Pixel/Millimeter,
						UVImageFile -> Link[#4],
						UVObjectiveMagnification -> 3.3,
						UVImageScale -> 456.6 Pixel/Millimeter,
						Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"], Objects]
					|>]&,
					{names, testVisibleLightImages, testCrossPolarizedImages, testUVImages}
				];

				MapThread[
					Upload[<|
						Object -> #1,
						Replace[CrystallizationImagingLog] -> {now, Link[#2]}
					|>]&,
					{allSamples[[1;;2]], testData}
				]
			]
		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			ClearMemoization[];
			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Bench for PlotCrystallizationImagingLog tests " <> $SessionUUID],
					Object[Container, Plate, Irregular, Crystallization, "PlotCrystallizationImagingLog test Plate 1 " <> $SessionUUID],
					Object[Sample, "PlotCrystallizationImagingLog test drop sample 1 " <> $SessionUUID],
					Object[Sample, "PlotCrystallizationImagingLog test drop sample 2 " <> $SessionUUID],
					Object[Sample, "PlotCrystallizationImagingLog test reservoir sample 1 " <> $SessionUUID],
					Object[Sample, "PlotCrystallizationImagingLog test reservoir sample 2 " <> $SessionUUID],
					Object[Data, Appearance, Crystals, "Test ImageData for PlotCrystallizationImagingLog test drop sample 1 " <> $SessionUUID],
					Object[Data, Appearance, Crystals, "Test ImageData for PlotCrystallizationImagingLog test drop sample 2 " <> $SessionUUID]
				}
			}], ObjectP[]];

			(* Check whether the created objects and models exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase all the created objects and models *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	}
];

