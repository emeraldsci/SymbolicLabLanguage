(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*VerifyObjects*)

DefineTests[VerifyObjects,
	{
		Example[{Basic, "If the input object passes ValidObjectQ after being modified by the supplied options, Function will set Verified -> True:"},
			VerifyObjects[Model[Container, Vessel, "Test valid container 1 for VerifyObjects unit tests "<>$SessionUUID], Verify -> True];
			Download[Model[Container, Vessel, "Test valid container 1 for VerifyObjects unit tests "<>$SessionUUID], Verified],
			True,
			SetUp :> {Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for VerifyObjects unit tests "<>$SessionUUID], Verified -> Null |>]}
		],
		Example[{Basic, "If the input object is only missing fields that can be parameterized in lab, Function will set Verified -> False and PendingParameterization -> True:"},
			VerifyObjects[Model[Container, Vessel, "Test require parameterization container 1 for VerifyObjects unit tests "<>$SessionUUID], Verify -> True];
			Download[Model[Container, Vessel, "Test require parameterization container 1 for VerifyObjects unit tests "<>$SessionUUID], {Verified, PendingParameterization}],
			{False, True},
			SetUp :> {Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for VerifyObjects unit tests "<>$SessionUUID], Verified -> Null, PendingParameterization -> Null |>]}
		],
		Example[{Basic, "If the input object is missing fields that cannot be parameterized in lab, function will return $Failed if Verify -> True, and throw errors:"},
			VerifyObjects[Model[Container, Vessel, "Test invalid container 1 for VerifyObjects unit tests "<>$SessionUUID], Verify -> True],
			$Failed,
			Messages :> {Error::UnableToFindInfo, Error::InvalidOption}
		],
		Test["Ensure the Test valid container 1 for VerifyObjects unit tests passes VOQ:",
			ValidObjectQ[Model[Container, Vessel, "Test valid container 1 for VerifyObjects unit tests "<>$SessionUUID]],
			True
		],
		Test["Ensure the Test invalid container 1 for VerifyObjects unit tests fails VOQ:",
			ValidObjectQ[Model[Container, Vessel, "Test invalid container 1 for VerifyObjects unit tests "<>$SessionUUID]],
			False
		],
		Test["Ensure the Test require parameterization container 1 for VerifyObjects unit tests fails VOQ:",
			ValidObjectQ[Model[Container, Vessel, "Test require parameterization container 1 for VerifyObjects unit tests "<>$SessionUUID]],
			False,
			SetUp :> Upload[<| Object -> Model[Container, Vessel, "Test require parameterization container 1 for VerifyObjects unit tests "<>$SessionUUID], PendingParameterization -> Null |>]
		],
		Test["Ensure the Test require parameterization container 1 for VerifyObjects unit tests passes VOQ if we change PendingParameterization -> True:",
			Upload[<| Object -> Model[Container, Vessel, "Test require parameterization container 1 for VerifyObjects unit tests "<>$SessionUUID], PendingParameterization -> True |>];
			ValidObjectQ[Model[Container, Vessel, "Test require parameterization container 1 for VerifyObjects unit tests "<>$SessionUUID]],
			True,
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test require parameterization container 1 for VerifyObjects unit tests "<>$SessionUUID], PendingParameterization -> Null |>]
		]
	},
	Stubs :> {$PersonID = Object[User, Emerald, Developer, "Test Developer for VerifyObjects unit tests "<>$SessionUUID]},
	SymbolSetUp :> {
		Module[{allObj, existingObj},
			allObj = {
				Object[User, Emerald, Developer, "Test Developer for VerifyObjects unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for VerifyObjects unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test valid container 1 for VerifyObjects unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test invalid container 1 for VerifyObjects unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test require parameterization container 1 for VerifyObjects unit tests "<>$SessionUUID]
			};
			existingObj = PickList[allObj, DatabaseMemberQ[allObj]];
			EraseObject[existingObj, Force -> True, Verbose -> False]
		],
		Module[
			{developer, testDocDirectory, testDoc},
			developer = Upload[<|
				Type -> Object[User, Emerald, Developer],
				Name -> "Test Developer for VerifyObjects unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];

			Upload[<|
				Object -> testDoc,
				Name -> "Test documentation file for VerifyObjects unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

			Block[{$PersonID = Object[User, Emerald, Developer, "Test Developer for VerifyObjects unit tests "<>$SessionUUID], $AllowUserInvalidObjectUploads = True},
				UploadContainerModel[
					Model[Container, Vessel],
					Name -> "Test valid container 1 for VerifyObjects unit tests "<>$SessionUUID,
					ImageFile -> Object[EmeraldCloudFile, "Test documentation file for VerifyObjects unit tests "<>$SessionUUID],
					ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for VerifyObjects unit tests "<>$SessionUUID],
					MinVolume -> 1 Milliliter,
					MaxVolume -> 50 Milliliter,
					MinTemperature -> -80 Celsius,
					MaxTemperature -> 200 Celsius,
					Ampoule -> False,
					Reusable -> False,
					Squeezable -> False,
					Opaque -> False,
					Positions -> {{"A1", Open, 30 Millimeter, 30 Millimeter, 120 Millimeter}},
					PositionPlotting -> {{"A1", 15 Millimeter, 15 Millimeter, 60 Millimeter, Circle, 0}},
					SelfStanding -> True,
					PreferredBalance -> Analytical,
					CrossSectionalShape -> Circle,
					InternalBottomShape -> FlatBottom,
					PreferredCamera -> Medium,
					Sterile -> False,
					Stocked -> False,
					Fragile -> False,
					RNaseFree -> False,
					PyrogenFree -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					ContainerMaterials -> {{Glass}},
					DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
					Dimensions -> {40 Millimeter, 40 Millimeter, 150 Millimeter},
					CoverTypes -> {{Screw}},
					CoverFootprints -> {{CapScrewTube35x13}},
					InternalDepth -> 120 Millimeter,
					InternalDiameter -> 30 Millimeter,
					Aperture -> 30 Millimeter,
					Force -> True,
					Strict -> False
				]
			];

			Block[{$PersonID = Object[User, Emerald, Developer, "Test Developer for VerifyObjects unit tests "<>$SessionUUID], $AllowUserInvalidObjectUploads = True},
				UploadContainerModel[
					Model[Container, Vessel],
					Name -> "Test require parameterization container 1 for VerifyObjects unit tests "<>$SessionUUID,
					ImageFile -> Object[EmeraldCloudFile, "Test documentation file for VerifyObjects unit tests "<>$SessionUUID],
					ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for VerifyObjects unit tests "<>$SessionUUID],
					MinVolume -> 1 Milliliter,
					MaxVolume -> 50 Milliliter,
					MinTemperature -> -80 Celsius,
					MaxTemperature -> 200 Celsius,
					Ampoule -> False,
					Reusable -> False,
					Squeezable -> False,
					Opaque -> False,
					Positions -> {{"A1", Open, 30 Millimeter, 30 Millimeter, 120 Millimeter}},
					PositionPlotting -> {{"A1", 15 Millimeter, 15 Millimeter, 60 Millimeter, Circle, 0}},
					SelfStanding -> True,
					PreferredBalance -> Analytical,
					CrossSectionalShape -> Circle,
					InternalBottomShape -> FlatBottom,
					PreferredCamera -> Medium,
					Sterile -> False,
					Stocked -> False,
					Fragile -> False,
					RNaseFree -> False,
					PyrogenFree -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					ContainerMaterials -> {{Glass}},
					DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
					CoverTypes -> {{Screw}},
					CoverFootprints -> {{CapScrewTube35x13}},
					Force -> True,
					Strict -> False
				]
			];

			Block[{$PersonID = Object[User, Emerald, Developer, "Test Developer for VerifyObjects unit tests "<>$SessionUUID], $AllowUserInvalidObjectUploads = True},
				UploadContainerModel[
					Model[Container, Vessel],
					Name -> "Test invalid container 1 for VerifyObjects unit tests "<>$SessionUUID,
					ImageFile -> Object[EmeraldCloudFile, "Test documentation file for VerifyObjects unit tests "<>$SessionUUID],
					ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for VerifyObjects unit tests "<>$SessionUUID],
					MinVolume -> 1 Milliliter,
					MinTemperature -> -80 Celsius,
					MaxTemperature -> 200 Celsius,
					Ampoule -> False,
					Reusable -> False,
					Squeezable -> False,
					Opaque -> False,
					Positions -> {{"A1", Open, 30 Millimeter, 30 Millimeter, 120 Millimeter}},
					PositionPlotting -> {{"A1", 15 Millimeter, 15 Millimeter, 60 Millimeter, Circle, 0}},
					SelfStanding -> True,
					PreferredBalance -> Analytical,
					CrossSectionalShape -> Circle,
					InternalBottomShape -> FlatBottom,
					PreferredCamera -> Medium,
					Sterile -> False,
					Stocked -> False,
					Fragile -> False,
					RNaseFree -> False,
					PyrogenFree -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					ContainerMaterials -> {{Glass}},
					DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
					Dimensions -> {40 Millimeter, 40 Millimeter, 150 Millimeter},
					CoverTypes -> {{Screw}},
					CoverFootprints -> {{CapScrewTube35x13}},
					InternalDepth -> 120 Millimeter,
					InternalDiameter -> 30 Millimeter,
					Aperture -> 30 Millimeter,
					Force -> True,
					Strict -> False
				]
			];

		]
	}
];

(* ::Subsection::Closed:: *)
(*PlotUnverifiedObjects*)

DefineTests[PlotUnverifiedObjects,
	{
		Example[{Basic, "Find and plot objects pending verification:"},
			PlotUnverifiedObjects[],
			_Pane
		],
		Example[{Options, MaxResults, "Use MaxResults to limit the number of results plotted:"},
			table = PlotUnverifiedObjects[MaxResults -> 10];
			Length[First[First[table]]],
			RangeP[0, 11],
			Variables :> {table}
		]
	},
	Stubs :> {$DeveloperSearch = True}
];

(* ::Subsubsection::Closed:: *)
(* VerificationPreCheck *)

DefineTests[VerificationPreCheck,
	{
		Example[{Basic, "Function output a True if all pre-checks passed:"},
			VerificationPreCheck[Model[Container, Vessel, "Test container 6 for VerificationPreCheck unit tests "<>$SessionUUID]],
			True
		],
		Example[{Messages, "UserDidNotSpecifyType", "If a container model is created via UploadContainerModel without specifying the Type (i.e., used Model[Container] or \"Others\" as input), it will pass the pre check but throw a warning:"},
			VerificationPreCheck[Model[Container, "Test container 1 for VerificationPreCheck unit tests "<>$SessionUUID]],
			True,
			Messages :> {Warning::UserDidNotSpecifyType}
		],
		Example[{Messages, "UserDidNotSpecifyType", "If a cover model is created via UploadCoverModel without specifying the Type (i.e., used Model[Item] or \"Others\" as input), it will pass the pre check but throw a warning:"},
			VerificationPreCheck[Model[Item, Cap, "Test cover 1 for VerificationPreCheck unit tests "<>$SessionUUID]],
			True,
			Messages :> {Warning::UserDidNotSpecifyType}
		],
		Example[{Messages, "UserDidNotSpecifyType", "If a container model is created via UploadContainerModel without specifying the Type (i.e., used Model[Container] or \"Others\" as input), even if the UploadContainerModel function was able to resolve a Type for it, a warning will still be thrown during pre check:"},
			VerificationPreCheck[Model[Container, Vessel, "Test container 3 for VerificationPreCheck unit tests "<>$SessionUUID]],
			True,
			Messages :> {Warning::UserDidNotSpecifyType}
		],
		Example[{Messages, "ObjectReplaced", "If a container model has been replaced by a developer during the verification process, running pre-check again on the old model will throw error and the result will be False:"},
			UploadContainerModel[
				Model[Container, "Test container 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Strict -> False,
				NewType -> Model[Container, Vessel]
			];
			VerificationPreCheck[Model[Container, "Test container 2 for VerificationPreCheck unit tests "<>$SessionUUID]],
			False,
			Messages :> {Error::ObjectReplaced, Error::ModelIsDeprecated, Warning::UserDidNotSpecifyType}
		],
		Example[{Messages, "ObjectReplaced", "If a cover model has been replaced by a developer during the verification process, running pre-check again on the old model will throw error and the result will be False:"},
			UploadCoverModel[
				Model[Item, Cap, "Test cover 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Strict -> False,
				NewType -> Model[Item, Lid]
			];
			VerificationPreCheck[Model[Item, Cap, "Test cover 2 for VerificationPreCheck unit tests "<>$SessionUUID]],
			False,
			Messages :> {Error::ObjectReplaced, Error::ModelIsDeprecated, Warning::UserDidNotSpecifyType}
		],
		Example[{Messages, "ProductNotProvided", "If a container model is created via UploadContainerModel without supplying the proper ProductInformation (e.g., used Sample Model), pre-check will fail and error will be thrown:"},
			VerificationPreCheck[Model[Container, Vessel, "Test container 4 for VerificationPreCheck unit tests "<>$SessionUUID]],
			False,
			Messages :> {Error::ProductNotProvided}
		],
		Example[{Messages, "ProductNotProvided", "If a cover model is created via UploadCoverModel without supplying the proper ProductInformation (e.g., used Sample Model), pre-check will fail and error will be thrown:"},
			VerificationPreCheck[Model[Item, Cap, "Test cover 3 for VerificationPreCheck unit tests "<>$SessionUUID]],
			False,
			Messages :> {Error::ProductNotProvided}
		],
		Example[{Messages, "DoubleCheckProduct", "If a container model is created via UploadContainerModel with an Object[Product] as ProductInformation input, pre-check will fail and error will be thrown:"},
			VerificationPreCheck[Model[Container, Vessel, "Test container 5 for VerificationPreCheck unit tests "<>$SessionUUID]],
			False,
			Messages :> {Error::DoubleCheckProduct}
		],
		Example[{Messages, "DoubleCheckProduct", "If a cover model is created via UploadCoverModel with an Object[Product] as ProductInformation input, pre-check will fail and error will be thrown:"},
			VerificationPreCheck[Model[Item, Cap, "Test cover 4 for VerificationPreCheck unit tests "<>$SessionUUID]],
			False,
			Messages :> {Error::DoubleCheckProduct}
		],
		Example[{Messages, "DoubleCheckProduct", "If a container model is created via UploadContainerModel with an Object[Product] as ProductInformation input, once the Product and the container model is linked in any field, Error::DoubleCheckProduct will no longer be triggered:"},
			UploadContainerModel[
				Model[Container, Vessel, "Test container 7 for VerificationPreCheck unit tests "<>$SessionUUID],
				Product -> Object[Product, "Test product 2 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				ProductRelation -> DefaultContainerModel,
				Strict -> False
			];
			VerificationPreCheck[Model[Container, Vessel, "Test container 7 for VerificationPreCheck unit tests "<>$SessionUUID]],
			True
		],
		Example[{Messages, "DoubleCheckProduct", "If a cover model is created via UploadCoverModel with an Object[Product] as ProductInformation input, once the Product and the cover model is linked in any field, Error::DoubleCheckProduct will no longer be triggered:"},
			Upload[<| Object -> Object[Product, "Test product 4 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID], DefaultCoverModel -> Link[Model[Item, Cap, "Test cover 5 for VerificationPreCheck unit tests "<>$SessionUUID]] |>];
			VerificationPreCheck[Model[Item, Cap, "Test cover 5 for VerificationPreCheck unit tests "<>$SessionUUID]],
			True
		]
	},
	Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
	SymbolSetUp :> {
		Module[{allObj, existingObj},
			allObj = {
				Model[Container, "Test container 1 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, "Test container 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 3 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 4 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 5 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 6 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 7 for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[Product, "Test product 1 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[Product, "Test product 2 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[Product, "Test product 3 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[Product, "Test product 4 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Sample, "Test sample 1 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 1 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test cover 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 3 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 4 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 5 for VerificationPreCheck unit tests "<>$SessionUUID]
			};

			existingObj = PickList[allObj, DatabaseMemberQ[allObj]];

			EraseObject[existingObj, Force -> True, Verbose -> False]
		],
		Module[
			{testDocDirectory, testDoc},

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];

			Upload[{
				<|
					Object -> testDoc,
					Name -> "Test documentation file for VerificationPreCheck unit tests "<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Product],
					Name -> "Test product 1 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Product],
					Name -> "Test product 2 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Product],
					Name -> "Test product 3 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Product],
					Name -> "Test product 4 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test sample 1 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID,
					DeveloperObject -> True
				|>
			}];

			(* create test container models *)
			Block[{$PersonID = Object[User, "id:n0k9mG8AXZP6"], $AllowUserInvalidObjectUploads = True, $AllowDuplicateProductModel = True, $IgnorePropertyDuplicateModel = True},
				(* Test container 1: user did not specify what Type to use, and function was unable to resolve the proper container type *)
				(* Test container 2: same as Test container 1. Make a copy for different tests *)
				(* Test container 3: user did not specify what Type to use, but function was auto-resolved the Type based on provided options *)
				(* Test container 5: user specified an Object[Product] as ProductInformation input, which we don't want to upload right away without checked by developer *)
				(* Test container 6: should pass pre-check *)
				(* Test container 7: same as 5 *)
				UploadContainerModel[
					{
						Model[Container],
						Model[Container],
						Model[Container],
						Model[Container, Vessel],
						Model[Container, Vessel],
						Model[Container, Vessel]
					},
					{
						testDoc,
						testDoc,
						testDoc,
						Object[Product, "Test product 1 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
						testDoc,
						Object[Product, "Test product 2 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID]
					},
					Name -> {
						"Test container 1 for VerificationPreCheck unit tests "<>$SessionUUID,
						"Test container 2 for VerificationPreCheck unit tests "<>$SessionUUID,
						"Test container 3 for VerificationPreCheck unit tests "<>$SessionUUID,
						"Test container 5 for VerificationPreCheck unit tests "<>$SessionUUID,
						"Test container 6 for VerificationPreCheck unit tests "<>$SessionUUID,
						"Test container 7 for VerificationPreCheck unit tests "<>$SessionUUID
					},
					Aperture -> {
						Null,
						Null,
						10 Millimeter,
						Null,
						Null,
						Null
					}
				];
				(* Test container 4: user did not specify a proper ProductInformation, instead used a Model[Sample] as input *)
				UploadContainerModel[
					Model[Container, Vessel],
					Model[Sample, "Test sample 1 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
					Name -> "Test container 4 for VerificationPreCheck unit tests "<>$SessionUUID
				];
				(* Test cover 1: user did not specify what Type to use, and function was unable to resolve the proper cover type *)
				(* Test cover 2: same as Test cover 1. Make a copy for different tests *)
				(* Test cover 4: user specified an Object[Product] as ProductInformation input, which we don't want to upload right away without checked by developer *)
				(* Test cover 5: same as 4 *)
				UploadCoverModel[
					{
						Model[Item],
						Model[Item],
						Model[Item, Cap],
						Model[Item, Cap]
					},
					{
						testDoc,
						testDoc,
						Object[Product, "Test product 3 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
						Object[Product, "Test product 4 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID]
					},
					Name -> {
						"Test cover 1 for VerificationPreCheck unit tests "<>$SessionUUID,
						"Test cover 2 for VerificationPreCheck unit tests "<>$SessionUUID,
						"Test cover 4 for VerificationPreCheck unit tests "<>$SessionUUID,
						"Test cover 5 for VerificationPreCheck unit tests "<>$SessionUUID
					}
				];
				(* Test cover 3: user did not specify a proper ProductInformation, instead used a Model[Sample] as input *)
				UploadCoverModel[
					Model[Item, Cap],
					Model[Sample, "Test sample 1 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
					Name -> "Test cover 3 for VerificationPreCheck unit tests "<>$SessionUUID
				];
			]
		]
	},
	SymbolTearDown :> {
		Module[{allObj, existingObj},
			allObj = {
				Model[Container, "Test container 1 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, "Test container 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 3 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 4 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 5 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 6 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test container 7 for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[Product, "Test product 1 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[Product, "Test product 2 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[Product, "Test product 3 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Object[Product, "Test product 4 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Sample, "Test sample 1 as ProductInformation for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 1 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test cover 2 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 3 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 4 for VerificationPreCheck unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test cover 5 for VerificationPreCheck unit tests "<>$SessionUUID]
			};

			existingObj = PickList[allObj, DatabaseMemberQ[allObj]];

			EraseObject[existingObj, Force -> True, Verbose -> False]
		]
	}
]