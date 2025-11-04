(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*UploadContainerModel*)


(* ::Subsubsection::Closed:: *)
(*UploadContainerModel*)

(* Note: In this test we need to Stub $PersonID, because UploadContainerModel behaves differently depending on if user or developer is running the function *)
(* Specifically, we enforce that when developer running the function, resulted Model[Container] must pass VOQ, while that's not the case for users *)
(* Therefore, most of the tests we Stub $PersonID to external user, and occasionally we stub to developer to test the functionality on developers *)
DefineTests[
	UploadContainerModel,
	{
		Example[{Basic, "Uploads a new Model[Container] when using type and a CloudFile as input:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test vessel 7 for UploadContainerModel unit tests "<>$SessionUUID
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Basic, "Uploads a new Model[Container] when using container type and a CloudFile as input:"},
			UploadContainerModel[
				"Tube or bottle",
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID]
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Basic, "Provide all options to upload a new Model[Container]:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test valid container 2 for UploadContainerModel unit tests "<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
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
				Aperture -> 30 Millimeter
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]}
		],
		Test["Function can correctly handle list of mixed inputs:",
			UploadContainerModel[
				{
					Model[Container, Vessel],
					Model[Container, Vessel, "Test invalid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
					Model[Container, Plate],
					Model[Container, ExtractionCartridge],
					Model[Container, Plate, Filter]
				},
				{
					Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
					Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
					Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
					Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
					Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID]
				},
				Name -> {
					"Test vessel 3 for UploadContainerModel unit tests "<>$SessionUUID,
					"Test invalid container 1 for UploadContainerModel unit tests "<>$SessionUUID,
					"Test plate 4 for UploadContainerModel unit tests "<>$SessionUUID,
					"Test extraction cartridge 5 for UploadContainerModel unit tests "<>$SessionUUID,
					"Test filter 6 for UploadContainerModel unit tests "<>$SessionUUID
				}
			],
			{
				ObjectP[Model[Container, Vessel, "Test vessel 3 for UploadContainerModel unit tests "<>$SessionUUID]],
				ObjectP[Model[Container, Vessel, "Test invalid container 1 for UploadContainerModel unit tests "<>$SessionUUID]],
				ObjectP[Model[Container, Plate, "Test plate 4 for UploadContainerModel unit tests "<>$SessionUUID]],
				ObjectP[Model[Container, ExtractionCartridge, "Test extraction cartridge 5 for UploadContainerModel unit tests "<>$SessionUUID]],
				ObjectP[Model[Container, Plate, Filter, "Test filter 6 for UploadContainerModel unit tests "<>$SessionUUID]]
			},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Additional, "Create a new Model[Container] which is not commercially available and no product-related options supplied, if the minimal required options are provided:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Name -> "Test vessel 10 for UploadContainerModel unit tests "<>$SessionUUID,
				MaxVolume -> 50 Milliliter,
				Reusable -> False,
				Squeezable -> False,
				Sterile -> False,
				ContainerMaterials -> {{Glass}}
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Additional, "If 'Others' is specified as type of container input, ECL will attempt to identify the correct container type for you based on the supplied options:"},
			UploadContainerModel[
				"Others",
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				Aperture -> 10 Millimeter
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Additional, "If 'Others' is specified as type of container input, ECL will attempt to identify the correct container type for you based on the supplied options:"},
			UploadContainerModel[
				"Others",
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				Rows -> 12
			],
			ObjectP[Model[Container, Plate]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Messages, "RequiredOptionsForNoProduct", "When creating a new Model[Container] which is not commercially available and no product-related options supplied, The minimal required options must be provided, otherwise an error will be thrown:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Name -> Null,
				MaxVolume -> 50 Milliliter,
				Reusable -> False,
				Squeezable -> False,
				Sterile -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Messages :> {Error::RequiredOptionsForNoProduct, Error::InvalidOption}
		],
		Example[{Messages, "InvalidProductDocumentationURL", "If a URL is provided for ProductDocumentation option but the URL can't be recognized as pdf file, and the ProductURL option has already been provided, function will return $Failed:"},
			UploadContainerModel[
				Model[Container, Vessel],
				ProductDocumentation -> "www.google.com",
				ProductURL -> "www.google.com",
				Name -> Null,
				Output -> Options
			],
			{_Rule..},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Messages :> {Error::InvalidProductDocumentationURL, Error::InvalidOption}
		],
		Example[{Messages, "InvalidProductDocumentationDirectory", "If a non-existing file path is provided for ProductDocumentation option, the function will return $Failed:"},
			UploadContainerModel[
				Model[Container, Vessel],
				FileNameJoin[{$TemporaryDirectory, CreateUUID[]<>$SessionUUID<>"xxx.pdf"}],
				Name -> "Test vessel 11 for UploadContainerModel unit tests "<>$SessionUUID
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Messages :> {Error::InvalidFileDirectory, Error::InvalidOption}
		],
		Example[{Options, Name, "If a name is not provided, UploadContainerModel will generate a name automatically based on the container information provided, this name is guaranteed to be not duplicated with other container models in database:"},
			containerModel = UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				ContainerMaterials -> {Glass},
				MaxVolume -> 50 Milliliter
			];
			Download[containerModel, Name],
			"50 mL Glass Vessel 2 created on "<>DateString[Now, {"Month", "Day", "Year"}],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {containerModel},
			SetUp :> (
				$CreatedObjects = {};
				Upload[
					<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> False,
						Name -> "50 mL Glass Vessel created on "<>DateString[Now, {"Month", "Day", "Year"}]
					|>
				]
			)
		],
		Example[{Messages, "RedundantOptions", "If any option that are not relevant to the input type was provided, an error will be thrown and function will return $Failed:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test vessel 15 for UploadContainerModel unit tests "<>$SessionUUID,
				Rows -> 2
			],
			$Failed,
			Messages :> {Error::RedundantOptions, Error::InvalidOption},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Messages, "RedundantOptions", "If any option that are not relevant to the input type was set to Null, no error will occur:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test vessel 16 for UploadContainerModel unit tests "<>$SessionUUID,
				Rows -> Null
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Messages, "ConflictingPositionOptions", "For any input, the Positions and PositionPlotting option must either both be Null, or both be Automatic, or both be manually specified; if not, an error will be thrown:"},
			UploadContainerModel[
				Model[Container, Plate],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test plate 8 for UploadContainerModel unit tests "<>$SessionUUID,
				Positions -> {{"A1", Null, 0.1 Meter, 0.1 Meter, 0.1 Meter}},
				PositionPlotting -> Null
			],
			$Failed,
			Messages :> {Error::ConflictingPositionOptions, Error::InvalidOption},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Messages, "UnableToCalculatePositions", "If Positions and PositionPlotting are set to Automatic, sufficient other options must be provided in order to calculate them:"},
			UploadContainerModel[
				Model[Container, Plate],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test plate 9 for UploadContainerModel unit tests "<>$SessionUUID,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				Dimensions -> {0.1276 Meter, 0.0855 Meter, 0.044 Meter},
				WellDiameter -> 8.23 Millimeter,
				WellDepth -> 41.2 Millimeter,
				HorizontalPitch -> 9 Millimeter,
				VerticalPitch -> 9 Millimeter
			],
			$Failed,
			Messages :> {Error::UnableToCalculatePositions, Error::InvalidOption},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Messages, "PotentialExistingModel", "When creating a new model, if the resulted new model is too similar to an existing one in database, function will throw an error:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				MinVolume -> 1 Milliliter,
				MaxVolume -> 50 Milliliter,
				Reusable -> False,
				Positions -> {{"A1", Open, 30 Millimeter, 30 Millimeter, 120 Millimeter}},
				PositionPlotting -> {{"A1", 15 Millimeter, 15 Millimeter, 60 Millimeter, Circle, 0}},
				Sterile -> False,
				Stocked -> True,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				Dimensions -> {40 Millimeter, 40 Millimeter, 150 Millimeter},
				CoverTypes -> {{Screw}},
				CoverFootprints -> {{CapScrewTube35x13}}
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"], $IgnorePropertyDuplicateModel = False},
			Messages :> {Error::PotentialExistingModel}
		],
		Example[{Messages, "NameAlreadyExist", "If the specified Name option has already been occupied by another private container model, function will redirect to that model and apply changes according to supplied options:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test invalid container 1 for UploadContainerModel unit tests "<>$SessionUUID
			],
			ObjectP[Model[Container, Vessel, "Test invalid container 1 for UploadContainerModel unit tests "<>$SessionUUID]],
			Messages :> {Warning::NameAlreadyExist},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"], $DeveloperSearch = True}
		],
		Example[{Messages, "NameAlreadyExist", "If the specified Name option has already been occupied by another public container model, function will throw an error:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID
			],
			$Failed,
			Messages :> {Error::NameAlreadyExist, Error::InvalidOption},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Example[{Messages, "SameProductAlreadyExist", "When creating a new container model providing ProductInformation input, if there is one and only one existing product in database that belongs to your team which shares the same ProductInformation, function will redirect to that existing model and apply changes according to supplied options:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file 2 for UploadContainerModel unit tests "<>$SessionUUID],
				Fragile -> True
			],
			ObjectP[Model[Container, Vessel, "Test invalid container 2 for UploadContainerModel unit tests "<>$SessionUUID]],
			Messages :> {Warning::SameProductAlreadyExist},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"], $DeveloperSearch = True, $AllowDuplicateProductModel = False}
		],
		Example[{Messages, "SameProductAlreadyExist", "When creating a new container model providing ProductInformation input, if there is one and only one existing product in database that belongs to your team which shares the same ProductInformation, function will redirect to that existing model and apply changes according to supplied options:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file 2 for UploadContainerModel unit tests "<>$SessionUUID],
				Fragile -> True
			],
			ObjectP[Model[Container, Vessel, "Test invalid container 2 for UploadContainerModel unit tests "<>$SessionUUID]],
			Messages :> {Warning::SameProductAlreadyExist},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"], $DeveloperSearch = True, $AllowDuplicateProductModel = False}
		],
		Example[{Messages, "SameProductAlreadyExist", "When creating a new container model providing ProductInformation input, if there is more than one existing product in database that belongs to your team which shares the same ProductInformation, function will throw an error:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Fragile -> True
			],
			$Failed,
			Messages :> {Error::SameProductAlreadyExist, Error::InvalidInput},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"], $DeveloperSearch = True, $AllowDuplicateProductModel = False}
		],
		Test["When creating a new container model providing ProductInformation input, if there is existing public product in database, function will throw an error:",
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Fragile -> True
			],
			$Failed,
			Messages :> {Error::SameProductAlreadyExist, Error::InvalidInput},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"], $AllowDuplicateProductModel = False}
		],
		Test["When creating a new container model providing ProductInformation input, if there is existing public product in database, and user did not intend to make any changes, output that model:",
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file 3 for UploadContainerModel unit tests "<>$SessionUUID],
				Upload -> False
			],
			{},
			Messages :> {Warning::SameProductAlreadyExist},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"], $AllowDuplicateProductModel = False, $DeveloperSearch = True}
		],
		Test["When creating a new model and set Force -> True, function will bypass the check about whether the new model is too similar to any existing ones:",
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				MinVolume -> 1 Milliliter,
				MaxVolume -> 50 Milliliter,
				Reusable -> False,
				Positions -> {{"A1", Open, 30 Millimeter, 30 Millimeter, 120 Millimeter}},
				PositionPlotting -> {{"A1", 15 Millimeter, 15 Millimeter, 60 Millimeter, Circle, 0}},
				Sterile -> False,
				Stocked -> True,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				Dimensions -> {40 Millimeter, 40 Millimeter, 150 Millimeter},
				CoverTypes -> {{Screw}},
				CoverFootprints -> {{CapScrewTube35x13}},
				Force -> True
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"], $IgnorePropertyDuplicateModel = False}
		],
		Example[{Options, ProductDocumentation, "A local file directory can be provided in lieu of Object[EmeraldCloudFile] for the ProductDocumentation option:"},
			UploadContainerModel[
				Model[Container, Vessel],
				ProductDocumentation -> FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}],
				Name -> "Test vessel 13 for UploadContainerModel unit tests "<>$SessionUUID
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			(* validateLocalFile is memoized, clear that in case there were memoized results before *)
			SetUp :> ClearMemoization[]
		],
		Example[{Options, ProductDocumentation, "A web url can be provided in lieu of Object[EmeraldCloudFile] for the ProductDocumentation option:"},
			UploadContainerModel[
				Model[Container, Vessel],
				ProductDocumentation -> "https://www.fishersci.com/store/msds?partNumber=A43420&productDescription=METHANOL+ACS+IN+SPEC+20L+DRUM&vendorId=VN00033897&countryCode=US&language=en",
				Name -> Null
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			(* downloadAndValidateURL is memoized, clear that in case there were memoized results before *)
			SetUp :> ClearMemoization[]
		],
		Example[{Options, ImageFile, "A local file directory can be provided in lieu of Object[EmeraldCloudFile] for the ImageFile option:"},
			UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				ImageFile -> FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}],
				Name -> "Test vessel 14 for UploadContainerModel unit tests "<>$SessionUUID
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			(* validateLocalFile is memoized, clear that in case there were memoized results before *)
			SetUp :> ClearMemoization[]
		],
		Example[{Options, Positions, "When both Positions and PositionPlotting are set to Automatic, function will attempt to calculate them from other options:"},
			container = UploadContainerModel[
				Model[Container, Plate],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test plate 7 for UploadContainerModel unit tests "<>$SessionUUID,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				Dimensions -> {0.1276 Meter, 0.0855 Meter, 0.044 Meter},
				WellDiameter -> 8.23 Millimeter,
				WellDepth -> 41.2 Millimeter,
				HorizontalPitch -> 9 Millimeter,
				VerticalPitch -> 9 Millimeter,
				HorizontalMargin -> 10.19 Millimeter,
				VerticalMargin -> 7.14 Millimeter,
				DepthMargin -> 2.8 Millimeter,
				CavityCrossSectionalShape -> Rectangle,
				Rows -> 8,
				Columns -> 12
			];
			Download[container, Positions],
			{_Association..},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {container}
		],
		Example[{Options, PositionPlotting, "When both Positions and PositionPlotting are set to Automatic, function will attempt to calculate them from other options:"},
			container = UploadContainerModel[
				Model[Container, Plate],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test plate 7 for UploadContainerModel unit tests "<>$SessionUUID,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				Dimensions -> {0.1276 Meter, 0.0855 Meter, 0.044 Meter},
				WellDiameter -> 8.23 Millimeter,
				WellDepth -> 41.2 Millimeter,
				HorizontalPitch -> 9 Millimeter,
				VerticalPitch -> 9 Millimeter,
				HorizontalMargin -> 10.19 Millimeter,
				VerticalMargin -> 7.14 Millimeter,
				DepthMargin -> 2.8 Millimeter,
				CavityCrossSectionalShape -> Rectangle,
				Rows -> 8,
				Columns -> 12
			];
			Download[container, PositionPlotting],
			{_Association..},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {container}
		],
		Example[{Options, NumberOfWells, "When creating a new plate model, if any two of Rows, Columns, NumberOfWells options are provided, the third one will be calculated automatically:"},
			containers = UploadContainerModel[
				{Model[Container, Plate], Model[Container, Plate], Model[Container, Plate]},
				{Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID], Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID], Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID]},
				Name -> Null,
				Rows -> {8, 8, Automatic},
				Columns -> {12, Automatic, 12},
				NumberOfWells -> {Automatic, 96, 96}
			];
			Download[containers, {Rows, Columns, NumberOfWells}],
			{{8, 12, 96}, {8, 12, 96}, {8, 12, 96}},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {containers}
		],
		Example[{Options, AspectRatio, "When creating a new plate model, if any two of Rows, Columns, NumberOfWells options are provided, AspectRatio will be calculated automatically:"},
			containers = UploadContainerModel[
				{Model[Container, Plate], Model[Container, Plate], Model[Container, Plate]},
				{Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID], Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID], Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID]},
				Name -> Null,
				Rows -> {8, 8, Automatic},
				Columns -> {12, Automatic, 12},
				NumberOfWells -> {Automatic, 96, 96},
				AspectRatio -> Automatic
			];
			Download[containers, AspectRatio],
			{EqualP[3/2], EqualP[3/2], EqualP[3/2]},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {containers}
		],
		Example[{Options, Reusable, "If CleaningMethod is provided, Reusable is automatically set to True:"},
			container = UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				CleaningMethod -> DishwashIntensive
			];
			Download[container, Reusable],
			True,
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {container}
		],
		Example[{Options, PreferredWashBin, "If CleaningMethod is provided, PreferredWashBin is automatically set to regular washbin for small containers:"},
			container = UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				CleaningMethod -> DishwashIntensive,
				Dimensions -> {1 Centimeter, 1 Centimeter, 1 Centimeter}
			];
			Download[container, PreferredWashBin],
			ObjectP[Model[Container, WashBin, "id:mnk9jORX16EO"]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {container}
		],
		Example[{Options, PreferredWashBin, "If CleaningMethod is provided, PreferredWashBin is automatically set to carboy washbin for large containers:"},
			container = UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				CleaningMethod -> DishwashIntensive,
				Dimensions -> {30 Centimeter, 30 Centimeter, 30 Centimeter}
			];
			Download[container, PreferredWashBin],
			ObjectP[Model[Container, WashBin, "id:GmzlKjP4398N"]],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {container}
		],
		Example[{Options, Fragile, "If the ContainerMaterials contain fragile material such as Glass, Fragile option will be automatically set to True:"},
			container = UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				ContainerMaterials -> {Glass}
			];
			Download[container, Fragile],
			True,
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {container}
		],
		Example[{Options, MinTemperature, "If the ContainerMaterials option is provided, MinTemperature option will be automatically resolved based on the materials:"},
			container = UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				ContainerMaterials -> {Glass}
			];
			Download[container, MinTemperature],
			EqualP[-30 Celsius],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {container}
		],
		Example[{Options, MaxTemperature, "If the ContainerMaterials option is provided, MaxTempature option will be automatically resolved based on the materials:"},
			container = UploadContainerModel[
				Model[Container, Vessel],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> Null,
				ContainerMaterials -> {Glass}
			];
			Download[container, MaxTemperature],
			EqualP[500 Celsius],
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]},
			Variables :> {container}
		],
		Test["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to certain options missing, Error::RequiredOptions will be thrown once:",
			UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Ampoule -> Null,
				ImageFile -> Null,
				RNaseFree -> Null,
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Messages :> {Error::RequiredOptions, Error::InvalidOption},
			SetUp :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID], Ampoule -> Null, ImageFile -> Null |>],
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID], Ampoule -> False, ImageFile -> Link[Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID]] |>]
		],
		Test["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to some required together fields are missing, Error::RequiredTogetherOptions will be thrown once:",
			UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				CleaningMethod -> DishwashIntensive,
				PreferredWashBin -> Null,
				Reusable -> True,
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Messages :> {Error::RequiredTogetherOptions, Error::InvalidOption, Error::ReusabilityConflict}
		],
		Test["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to some option must be set to Null, Error::RequiredNullOptions will be thrown once:",
			UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				PermanentlySealed -> True,
				CoverTypes -> {Snap},
				BuiltInCover -> True,
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Messages :> {Error::RequiredNullOptions, Error::InvalidOption}
		],
		Test["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to CoverTypes option is missing, Error::CoverTypesRequired will be thrown once:",
			UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				CoverTypes -> Null,
				Ampoule -> False,
				BuiltInCover -> False,
				PermanentlySealed -> False,
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Messages :> {Error::CoverTypesRequired, Error::InvalidOption},
			SetUp :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {}, Replace[CoverFootprints] -> {} |>],
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {Screw}, Replace[CoverFootprints] -> {CapScrewTube35x13} |>]
		],
		Test["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to CoverTypes option is inconsistent with the Type, Error::CoverTypeInconsistency will be thrown once:",
			UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				CoverTypes -> {Seal},
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Messages :> {Error::CoverTypeInconsistency, Error::InvalidOption}
		],
		Test["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to certain options must be set to True, Error::CleaningMethodConflict will be thrown once:",
			UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				CleaningMethod -> DishwashIntensive,
				Reusable -> False,
				PreferredWashBin -> Model[Container, WashBin, "id:GmzlKjP4398N"],
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Messages :> {Error::CleaningMethodConflict, Error::InvalidOption}
		],
		Test["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to conflicts among Ampoule, Hermetic and PermenantlySealed option, Error::PermanentlySealedAmpouleHermeticConflict will be thrown once:",
			UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				PermanentlySealed -> True,
				Ampoule -> True,
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Messages :> {Error::PermanentlySealedAmpouleHermeticConflict, Error::InvalidOption},
			SetUp :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {}, Replace[CoverFootprints] -> {} |>],
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {Screw}, Replace[CoverFootprints] -> {CapScrewTube35x13} |>]
		],
		Test["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to the Positions option not contain one and only one entry with Name being A1, Error::NotAllowedPositionName will be thrown once:",
			UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Positions -> {{"A2", Open, 30 Millimeter, 30 Millimeter, 120 Millimeter}},
				PositionPlotting -> {{"A2", 15 Millimeter, 15 Millimeter, 60 Millimeter, Circle, 0}},
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Messages :> {Error::NotAllowedPositionName, Error::InvalidOption}
		],
		Test["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to relative magnitude of certain options are incorrect, Error::ConflictingOptionsMagnitude will be thrown once:",
			UploadContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadContainerModel unit tests "<>$SessionUUID],
				MinVolume -> 50 Milliliter,
				RecommendedFillVolume -> 100 Milliliter,
				MaxVolume -> 10 Milliliter,
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Messages :> {Error::ConflictingOptionsMagnitude, Error::InvalidOption}
		],
		Test["Ensure that "<>ToString[Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID]]<>" created in SymbolSetUp passes VOQ:",
			ValidObjectQ[Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID]],
			True
		],
		Test["Ensure that "<>ToString[Model[Container, Plate, "Test valid plate 1 for UploadContainerModel unit tests "<>$SessionUUID]]<>" created in SymbolSetUp passes VOQ:",
			ValidObjectQ[Model[Container, Plate, "Test valid plate 1 for UploadContainerModel unit tests "<>$SessionUUID]],
			True
		],
		Test["When developer running this function, fully specify all options is necessary to upload a new Model[Container]:",
			UploadContainerModel[
				Model[Container, Vessel],
				Name -> "Test valid container 2 for UploadContainerModel unit tests "<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
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
				Aperture -> 30 Millimeter
			],
			ObjectP[Model[Container, Vessel]],
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]}
		],
		Test["When developer running this function to create a new Model[Container], if the final packet does not pass ValidObjectQ, function returns $Failed:",
			Quiet[UploadContainerModel[
				Model[Container, Vessel],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Name -> "Test vessel 8 for UploadContainerModel unit tests "<>$SessionUUID
			]],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]}
		],
		Test["When developer running this function on an existing Model[Container], it will upload changes to fields according to provided options:",
			UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Fragile -> True
			];
			Download[Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID], Fragile],
			True,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]}
		],
		Test["When running this function to change existing Model[Container], only fields bearing the same name as provided options will be changed:",
			packets = UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Fragile -> False,
				Stocked -> True,
				Upload -> False
			];
			containerModelPacket = FirstCase[packets, PacketP[Model[Container, Vessel]]];
			KeyExistsQ[containerModelPacket, #]& /@ {Name, Append[Products], Fragile, Stocked, InternalDimensions, Reusable},
			{False, False, True, True, False, False},
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Variables :> {containerModelPacket, packets}
		],
		Test["In the upload packet, most multiple fields will have the Replace[] head, while Products and ProductDocumentations will have Append[] head:",
			packets = UploadContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				ContainerMaterials -> {{LDPE, Aluminum}},
				Upload -> False
			];
			containerModelPacket = FirstCase[packets, PacketP[Model[Container, Vessel]]];
			Lookup[containerModelPacket, #, "Missing"]& /@ {Replace[ProductDocumentationFiles], Append[ProductDocumentationFiles], Replace[ContainerMaterials], Append[ContainerMaterials]},
			{"Missing", ObjectP[Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID]], {LDPE, Aluminum}, "Missing"},
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
			Variables :> {containerModelPacket, packets}
		]
	},
	Stubs :> {$AllowUserInvalidObjectUploads = True, $AllowDuplicateProductModel = True, $IgnorePropertyDuplicateModel = True},
	SetUp :> {$CreatedObjects = {}},
	TearDown :> (
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Module[{allObjects, existingObejcts},
			allObjects = {
				Model[Container, Vessel, "Test invalid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test invalid container 2 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test invalid container 3 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test invalid container 4 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test valid plate 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file 2 for UploadContainerModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file 3 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Unknown Volume Unknown Material Vessel created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Container, Vessel, "Test valid container 2 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 3 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 4 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, ExtractionCartridge, "Test extraction cartridge 5 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, Filter, "Test filter 6 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 7 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 8 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 9 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 10 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 11 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 12 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 13 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 14 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 15 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 16 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 7 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 8 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 9 for UploadContainerModel unit tests "<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Physics, Material, "Test Material property Glass for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "50 mL Glass Vessel created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Container, Vessel, "50 mL Glass Vessel 2 created on "<>DateString[Now, {"Month", "Day", "Year"}]]
			};
			existingObejcts = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObejcts, Verbose -> False, Force -> True]
		];
		Module[
			{testinvalidContainer, testDoc, testDocDirectory, testNotebook, testDoc2, testInvalidContainer2, testInvalidContainer3, testDoc3, testInvalidContainer4},
			{testinvalidContainer, testNotebook, testInvalidContainer2, testInvalidContainer3, testInvalidContainer4} = CreateID[
				{
					Model[Container, Vessel],
					Object[LaboratoryNotebook],
					Model[Container, Vessel],
					Model[Container, Vessel],
					Model[Container, Vessel]
				}
			];

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];
			testDoc2 = UploadCloudFile[testDocDirectory];
			testDoc3 = UploadCloudFile[testDocDirectory];
			Upload[<|
				Object -> testDoc,
				Name -> "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

			Upload[<|
				Object -> testDoc2,
				Name -> "Test documentation file 2 for UploadContainerModel unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

			Upload[<|
				Object -> testDoc3,
				Name -> "Test documentation file 3 for UploadContainerModel unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

			Upload[{
				<|
					Object -> testinvalidContainer,
					DeveloperObject -> True,
					Name -> "Test invalid container 1 for UploadContainerModel unit tests "<>$SessionUUID,
					Notebook -> Link[testNotebook],
					Replace[ProductDocumentationFiles] -> {Link[testDoc]}
				|>,
				<|
					Object -> testInvalidContainer2,
					DeveloperObject -> True,
					Name -> "Test invalid container 2 for UploadContainerModel unit tests "<>$SessionUUID,
					Notebook -> Link[testNotebook],
					Replace[ProductDocumentationFiles] -> {Link[testDoc2]}
				|>,
				<|
					Object -> testInvalidContainer3,
					DeveloperObject -> True,
					Name -> "Test invalid container 3 for UploadContainerModel unit tests "<>$SessionUUID,
					Notebook -> Link[testNotebook],
					Replace[ProductDocumentationFiles] -> {Link[testDoc]}
				|>,
				<|
					Object -> testInvalidContainer4,
					DeveloperObject -> True,
					Name -> "Test invalid container 4 for UploadContainerModel unit tests "<>$SessionUUID,
					Replace[ProductDocumentationFiles] -> {Link[testDoc3]}
				|>,
				<|
					Object -> testNotebook,
					DeveloperObject -> True,
					Name -> "Test lab notebook for UploadContainerModel unit tests "<>$SessionUUID
				|>
			}];

			UploadContainerModel[
				Model[Container, Vessel],
				Name -> "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
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
				Force -> True
			];

			UploadContainerModel[
				Model[Container, Plate],
				Name -> "Test valid plate 1 for UploadContainerModel unit tests "<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				MinVolume -> 1 Milliliter,
				MaxVolume -> 50 Milliliter,
				MinTemperature -> -80 Celsius,
				MaxTemperature -> 200 Celsius,
				Ampoule -> False,
				Reusable -> False,
				Squeezable -> False,
				Opaque -> False,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				SelfStanding -> True,
				PreferredBalance -> Analytical,
				CrossSectionalShape -> Circle,
				PreferredCamera -> Medium,
				Sterile -> False,
				Fragile -> False,
				RNaseFree -> False,
				PyrogenFree -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				ContainerMaterials -> {{Glass}},
				DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Dimensions -> {40 Millimeter, 40 Millimeter, 150 Millimeter},
				CoverTypes -> {{Place}},
				CoverFootprints -> {{LidPlace8x126}},
				PlateColor -> Clear,
				WellColor -> Clear,
				Columns -> 12,
				Rows -> 8,
				NumberOfWells -> 96,
				WellDiameter -> 5 Millimeter,
				Treatment -> NonTreated,
				HorizontalMargin -> 1 Millimeter,
				VerticalMargin -> 1 Millimeter,
				DepthMargin -> 1 Millimeter,
				WellDepth -> 2 Millimeter,
				WellBottom -> FlatBottom,
				HorizontalOffset -> 1 Millimeter,
				VerticalOffset -> 1 Millimeter,
				Skirted -> False,
				StorageOrientation -> Upright,
				Footprint -> Plate,
				TransportStable -> True,
				HorizontalPitch -> 1 Millimeter,
				VerticalPitch -> 1 Millimeter,
				AspectRatio -> 1.5,
				CavityCrossSectionalShape -> Circle,
				Force -> True
			];

			Upload[{
				<|
					Type -> Model[Physics, Material],
					Name -> "Test Material property Glass for UploadContainerModel unit tests "<>$SessionUUID,
					Material -> Glass,
					Fragile -> True,
					MinTemperature -> -30 Celsius,
					MaxTemperature -> 500 Celsius
				|>
			}];
			(* Clear the current materialInformation *)
			ClearMemoization[];
			materialInformation["Memoization"] = Download[{Model[Physics, Material, "Test Material property Glass for UploadContainerModel unit tests "<>$SessionUUID]}, Packet[All]]

		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObejcts},
			allObjects = {
				Model[Container, Vessel, "Test invalid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test invalid container 2 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test invalid container 3 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test invalid container 4 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test valid container 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test valid plate 1 for UploadContainerModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file 2 for UploadContainerModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file 3 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Unknown Volume Unknown Material Vessel created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Container, Vessel, "Test valid container 2 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 3 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 4 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, ExtractionCartridge, "Test extraction cartridge 5 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, Filter, "Test filter 6 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 7 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 8 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 9 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 10 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 11 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 12 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 13 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 14 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 15 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 16 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 7 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 8 for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 9 for UploadContainerModel unit tests "<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Physics, Material, "Test Material property Glass for UploadContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "50 mL Glass Vessel created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Container, Vessel, "50 mL Glass Vessel 2 created on "<>DateString[Now, {"Month", "Day", "Year"}]]
			};
			existingObejcts = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObejcts, Verbose -> False, Force -> True]
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*UploadVerifiedContainerModel*)

DefineTests[UploadVerifiedContainerModel,
	{
		Example[{Basic, "By default Verify -> False, function runs ValidObjectQ on the input object and output the field values as resolved options:"},
			UploadVerifiedContainerModel[Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID]],
			{_Rule..},
			Messages :> {Warning::NotYetVerified}
		],
		Example[{Basic, "When Verify -> True, function runs ValidObjectQ on the input object; if it passes, function will upload the changes:"},
			UploadVerifiedContainerModel[Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Verify -> True],
			ObjectP[Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID]],
			TearDown :> (Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Verified -> Null |>])
		],
		Example[{Basic, "When Verify -> True, function runs ValidObjectQ on the input object; if it passes, function will set Verified -> True:"},
			UploadVerifiedContainerModel[Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Verify -> True];
			Download[Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Verified],
			True,
			SetUp :> (Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Verified -> Null |>]),
			TearDown :> (Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Verified -> Null |>])
		],
		Example[{Additional, "Strict option will be overridden and always be True:"},
			Quiet[UploadVerifiedContainerModel[Model[Container, Vessel, "Test invalid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Verify -> True, Strict -> False]],
			$Failed
		],
		Example[{Messages, "InteralOnlyFunction", "This function is meant for ECL internal personnel only. When external user run this function, Error::InteralOnlyFunction will be thrown:"},
			UploadVerifiedContainerModel[Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID]],
			$Failed,
			Messages :> {Error::InteralOnlyFunction},
			Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"]}
		],
		Test["Assert the vessel model created in SymbolSetUp passes VOQ:",
			ValidObjectQ[Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID]],
			True
		],
		Test["Assert the plate model created in SymbolSetUp passes VOQ:",
			ValidObjectQ[Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID]],
			True
		],
		Example[{Messages, "UnableToFindInfo", "If any options are required in order to pass VOQ, but it's missing, Error::UnableToFindInfo will be thrown:"},
			UploadVerifiedContainerModel[Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Verify -> False],
			{_Rule..},
			Messages :> {Error::UnableToFindInfo, Error::InvalidOption, Warning::NotYetVerified},
			SetUp :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Fragile -> Null, Squeezable -> Null |>],
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Fragile -> False, Squeezable -> False |>]
		],
		Example[{Messages, "RequiredOptions", "If any options are required in order to pass VOQ, but it's set to Null, Error::RequiredOptions will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Fragile -> Null,
				Squeezable -> Null
			],
			{_Rule..},
			Messages :> {Error::RequiredOptions, Error::InvalidOption, Warning::NotYetVerified},
			SetUp :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Fragile -> Null, Squeezable -> Null |>],
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Fragile -> False, Squeezable -> False |>]
		],
		Example[{Messages, "ConflictingOptionsMagnitude", "If the MaxTemperature and MinTemperature option are incorrectly set such that MaxTemperature is lower than MinTemperature, Error::ConflictingOptionsMagnitude will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				MaxTemperature -> 100 Kelvin,
				MinTemperature -> 200 Kelvin
			],
			{_Rule..},
			Messages :> {Error::ConflictingOptionsMagnitude, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "ConflictingOptionsMagnitudeFromExistingField", "If the field value of MaxTemperature is lower than MinTemperature for the input container model, Error::ConflictingOptionsMagnitudeFromExistingField will be thrown:"},
			Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], MinTemperature -> 200 Kelvin, MaxTemperature -> 100 Kelvin |>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::ConflictingOptionsMagnitudeFromExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], MinTemperature -> -80 Celsius, MaxTemperature -> 200 Celsius |>]
		],
		Example[{Messages, "RequiredNullOptions", "If PermanentlySealed is set to True for a model that already has CoverTypes and CoverFootprints, Error::RequiredNullOptions will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				PermanentlySealed -> True
			],
			{_Rule..},
			Messages :> {Error::RequiredNullOptions, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "RequiredNullOptionsFromExistingField", "If the container model has PermanentlySealed -> True but CoverTypes and CoverFootprints are not empty, Error::RequiredNullOptionsFromExistingField will be thrown:"},
			Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], PermanentlySealed -> True |>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				PermanentlySealed -> True
			],
			{_Rule..},
			Messages :> {Error::RequiredNullOptions, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], PermanentlySealed -> False |>]
		],
		Example[{Messages, "CoverTypesRequired", "If the CoverTypes is set to Null for a model that is not PermanentlySealed, Ampoule or BuiltInCover, Error::CoverTypesRequired will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverTypes -> Null
			],
			{_Rule..},
			Messages :> {Error::CoverTypesRequired, Error::InvalidOption, Warning::NotYetVerified},
			SetUp :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {} |>],
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {Screw} |>]
		],
		Example[{Messages, "RequiredNullOptionsFromExistingField", "If the container model has PermanentlySealed -> True but CoverTypes and CoverFootprints are not empty, Error::RequiredNullOptionsFromExistingField will be thrown:"},
			Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {} |>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::UnableToDetermineCoverTypes, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {Screw} |>]
		],
		Example[{Messages, "CoverTypeInconsistency", "If Seal is incorrectly included for the CoverType option for a vessel, Error::CoverTypeInconsistency will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverTypes -> {Seal}
			],
			{_Rule..},
			Messages :> {Error::CoverTypeInconsistency, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "CoverTypeInconsistencyFromExistingField", "If the container model is not a plate but its CoverTypes include Seal, Error::CoverTypeInconsistencyFromExistingField will be thrown:"},
			Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {Seal} |>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::CoverTypeInconsistencyFromExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {Screw} |>]
		],
		Example[{Messages, "CoverTypeInconsistency", "If Screw is incorrectly included for the CoverType option for a plate, Error::CoverTypeInconsistency will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverTypes -> {Screw}
			],
			{_Rule..},
			Messages :> {Error::CoverTypeInconsistency, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "CoverTypeInconsistencyFromExistingField", "If the container model is a plate but its CoverTypes include Screw, Error::CoverTypeInconsistencyFromExistingField will be thrown:"},
			Upload[<| Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {Screw} |>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::CoverTypeInconsistencyFromExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<| Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[CoverTypes] -> {Place} |>]
		],
		Example[{Messages, "RequiredTogetherOptions", "Certain options must be provided together, e.g., CleaningMethod and PreferredWashbin. If the one of them is provided but the other one is set to Null, Error::RequiredTogetherOptions will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				CleaningMethod -> DishwashIntensive,
				PreferredWashBin -> Null,
				Reusable -> True
			],
			{_Rule..},
			Messages :> {Error::RequiredTogetherOptions, Error::InvalidOption, Error::ReusabilityConflict, Warning::NotYetVerified}
		],
		Example[{Messages, "RequiredTogetherOptionsCannotFindFromExternalSource", "Certain options must be provided together, e.g., CleaningMethod and PreferredWashbin. If one of them is set to Null while the other one is not Null in database, Error::RequiredTogetherOptionsCannotFindFromExternalSource will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				PreferredWashBin -> Model[Container, WashBin, "id:GmzlKjP4398N"],
				Reusable -> True
			],
			{_Rule..},
			Messages :> {Error::RequiredTogetherOptionsCannotFindFromExternalSource, Error::InvalidOption, Error::ReusabilityConflictWithExistingField, Warning::NotYetVerified}
		],
		Example[{Messages, "RequiredTogetherOptionsConflictFromExternalSource", "Certain options must be provided together, e.g., CleaningMethod and PreferredWashbin. If one of the fields is Null but the other one is not Null in database, Error::RequiredTogetherOptionsConflictFromExternalSource will be thrown:"},
			Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], PreferredWashBin -> Link[Model[Container, WashBin, "id:GmzlKjP4398N"]] |>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Reusable -> True
			],
			{_Rule..},
			Messages :> {Error::RequiredTogetherOptionsConflictFromExternalSource, Error::InvalidOption, Error::ReusabilityConflictWithExistingField, Warning::NotYetVerified},
			TearDown :> Upload[<| Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], PreferredWashBin -> Null |>]
		],
		Example[{Messages, "SterilizationConflict", "If Sterilized is set to True but Sterile is set to False, Error::SterilizationConflict will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Sterile -> False,
				Sterilized -> True
			],
			{_Rule..},
			Messages :> {Error::SterilizationConflict, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "SterilizationConflictFromExistingField", "If Sterilized is set to True while Sterile is False in database, Error::SterilizationConflictFromExistingField will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Sterilized -> True
			],
			{_Rule..},
			Messages :> {Error::SterilizationConflictFromExistingField, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "PositionInconsistencyBetweenExistingSource", "If the Positions and PositionPlotting field do not share the same set of position names, Error::PositionInconsistencyBetweenExistingSource will be thrown:"},
			{oldPositions, oldPositionPlotting} = Download[Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], {Positions, PositionPlotting}];
			Upload[<|
				Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> 10 Millimeter, MaxDepth -> 10 Millimeter, MaxHeight -> 10 Millimeter|>},
				Replace[PositionPlotting] -> {<|Name->"A1",XOffset->3.5 Millimeter,YOffset->36.5 Millimeter,ZOffset->1 Millimeter,CrossSectionalShape->Circle,Rotation->0|>,<|Name->"A2",XOffset->4.5 Millimeter,YOffset->36.5 Millimeter,ZOffset->1 Millimeter,CrossSectionalShape->Circle,Rotation->0|>}
			|>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::PositionInconsistencyBetweenExistingSource, Error::InvalidOption, Error::InconsistentPositionAndNumberOfWells, Error::ValidObjectQFailing, Warning::NotYetVerified},
			TearDown :> Upload[<| Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[Positions] -> oldPositions, Replace[PositionPlotting] -> oldPositionPlotting |>],
			Variables :> {oldPositions, oldPositionPlotting}
		],
		Example[{Messages, "PositionInconsistency", "If the supplied Positions and PositionPlotting option values do not share the same set of position names, Error::PositionInconsistency will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Positions -> {{"A1", Null, 10 Millimeter, 10 Millimeter, 10 Millimeter}},
				PositionPlotting -> {{"A2", 10 Millimeter, 10 Millimeter, 10 Millimeter, Circle, 0}}
			],
			{_Rule..},
			Messages :> {Error::PositionInconsistency, Error::InvalidOption, Error::IncorrectPositionLength, Warning::NotYetVerified}
		],
		Example[{Messages, "PositionInconsistencyFromExistingSource", "If the supplied Positions option value do not share the same set of position names compared to the existing PositionPlotting field in database, Error::PositionInconsistencyFromExistingSource will be thrown:"},
			oldPositionPlotting = Download[Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], PositionPlotting];
			Upload[<|
				Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Replace[PositionPlotting] -> {<|Name->"A1",XOffset->3.5 Millimeter,YOffset->36.5 Millimeter,ZOffset->1 Millimeter,CrossSectionalShape->Circle,Rotation->0|>,<|Name->"A2",XOffset->4.5 Millimeter,YOffset->36.5 Millimeter,ZOffset->1 Millimeter,CrossSectionalShape->Circle,Rotation->0|>}
			|>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Positions -> {{"A1", Null, 10 Millimeter, 10 Millimeter, 10 Millimeter}}
			],
			{_Rule..},
			Messages :> {Error::PositionInconsistencyFromExistingSource, Error::InvalidOption, Error::IncorrectPositionLength, Error::ValidObjectQFailing, Error::InconsistentPositionAndNumberOfWells, Warning::NotYetVerified},
			TearDown :> Upload[<| Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Replace[PositionPlotting] -> oldPositionPlotting |>],
			Variables :> {oldPositionPlotting}
		],
		Example[{Messages, "PermanentlySealedAmpouleHermeticConflict", "PermanentlySealed, Ampoule and Hermetic options are mutually exclusive. If both PermanentlySealed and Ampoule are set to True, Error::PermanentlySealedAmpouleHermeticConflict will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				PermanentlySealed -> True,
				Ampoule -> True
			],
			{_Rule..},
			Messages :> {Error::PermanentlySealedAmpouleHermeticConflict, Error::InvalidOption, Error::RequiredNullOptions, Warning::NotYetVerified}
		],
		Example[{Messages, "PermanentlySealedAmpouleHermeticConflictFromExistingField", "PermanentlySealed, Ampoule and Hermetic options are mutually exclusive. If PermanentlySealed is set to True while Ampoule is True in database, Error::PermanentlySealedAmpouleHermeticConflictFromExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Ampoule -> True, Replace[CoverTypes] -> {}, Replace[CoverFootprints] -> {}|>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				PermanentlySealed -> True
			],
			{_Rule..},
			Messages :> {Error::PermanentlySealedAmpouleHermeticConflictFromExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Ampoule -> False, Replace[CoverTypes] -> {Place}, Replace[CoverFootprints] -> {LidPlace8x126}|>]
		],
		Example[{Messages, "PermanentlySealedAmpouleHermeticConflictBetweenExistingField", "PermanentlySealed, Ampoule and Hermetic options are mutually exclusive. If the container model has Ampoule is True in database, Error::PermanentlySealedAmpouleHermeticConflictBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], PermanentlySealed -> True, Ampoule -> True, Replace[CoverTypes] -> {}, Replace[CoverFootprints] -> {}|>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::PermanentlySealedAmpouleHermeticConflictBetweenExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], PermanentlySealed -> False, Ampoule -> False, Replace[CoverTypes] -> {Place}, Replace[CoverFootprints] -> {LidPlace8x126}|>]
		],
		Example[{Messages, "ReusabilityConflict", "If Reusable is True, CleaningMethod must be set. If Reusable is set to True but CleaningMethod is set to Null, Error::ReusabilityConflict will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Reusable -> True,
				CleaningMethod -> Null
			],
			{_Rule..},
			Messages :> {Error::ReusabilityConflict, Error::InvalidOption, Error::ReusabilityConflictWithExistingField, Warning::NotYetVerified}
		],
		Example[{Messages, "ReusabilityConflictWithExistingField", "If Reusable is True, CleaningMethod must be set. If Reusable is set to True while CleaningMethod is Null in database, Error::ReusabilityConflictWithExistingField will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Reusable -> True
			],
			{_Rule..},
			Messages :> {Error::ReusabilityConflictWithExistingField, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "ReusabilityConflictBetweenExistingField", "If Reusable is True, CleaningMethod must be set. If the container model has Reusable -> True and CleaningMethod -> Null in database, Error::ReusabilityConflictBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Reusable -> True|>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::ReusabilityConflictBetweenExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Reusable -> False|>]
		],
		Example[{Messages, "ReusabilityConflict", "If Reusable is True, PreferredWashBin and CleaningMethod must be set. If Reusable is set to True but PreferredWashBin is set to Null, Error::ReusabilityConflict will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Reusable -> True,
				PreferredWashBin -> Null,
				CleaningMethod -> Null
			],
			{_Rule..},
			Messages :> {Error::ReusabilityConflict, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "ReusabilityConflictWithExistingField", "If Reusable is True, PreferredWashBin must be set. If Reusable is set to True while PreferredWashBin is Null in database, Error::ReusabilityConflictWithExistingField will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Reusable -> True
			],
			{_Rule..},
			Messages :> {Error::ReusabilityConflictWithExistingField, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "ReusabilityConflictBetweenExistingField", "If Reusable is True, PreferredWashBin must be set. If the container model has Reusable -> True and PreferredWashBin -> Null in database, Error::ReusabilityConflictBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Reusable -> True|>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::ReusabilityConflictBetweenExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Reusable -> False|>]
		],
		Example[{Messages, "InternalConicalDepthNotAllowed", "InternalConicalDepth should be informed for vessel only if InternalBottomShape is RoundBottom or VBottom. If the InternalBottomShape and InternalConicalDepth option values are incompatible, Error::InternalConicalDepthNotAllowed will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				InternalBottomShape -> FlatBottom,
				InternalConicalDepth -> 1 Millimeter
			],
			{_Rule..},
			Messages :> {Error::InternalConicalDepthNotAllowed, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "InternalConicalDepthNotAllowedWithExistingField", "InternalConicalDepth should be informed for vessel only if InternalBottomShape is RoundBottom or VBottom. If the InternalBoInternalConicalDepth option is provided without realizing the current InternalConicalDepth is not RoundBottom or VBottom, Error::InternalConicalDepthNotAllowedWithExistingField will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				InternalConicalDepth -> 1 Millimeter
			],
			{_Rule..},
			Messages :> {Error::InternalConicalDepthNotAllowedWithExistingField, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "InternalConicalDepthNotAllowedBetweenExistingField", "InternalConicalDepth should be informed for vessel only if InternalBottomShape is RoundBottom or VBottom. If the current field value of InternalBottomShape and InternalConicalDepth are conflicting because of this reason, Error::InternalConicalDepthNotAllowedBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], InternalConicalDepth -> 1 Millimeter|>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::InternalConicalDepthNotAllowedBetweenExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], InternalConicalDepth -> Null|>]
		],
		Example[{Messages, "MultiplePositions", "Vessels cannot have more than 1 entry for Positions and PositionsPlottings field. If more than 1 entry for these options are provided, Error::MultiplePositions will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Positions -> {
					{"A1", Open, 30 Millimeter, 30 Millimeter, 120 Millimeter},
					{"A2", Open, 3 Millimeter, 3 Millimeter, 12 Millimeter}
				},
				PositionPlotting -> {
					{"A1", 15 Millimeter, 15 Millimeter, 60 Millimeter, Circle, 0},
					{"A2", 3 Millimeter, 3 Millimeter, 6 Millimeter, Circle, 0}
				}
			],
			{_Rule..},
			Messages :> {Error::MultiplePositions, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "MultiplePositionsFromExistingObject", "Vessels cannot have more than 1 entry for Positions and PositionsPlottings field. If the existing model contains more than 1 entry for these options, Error::MultiplePositionsFromExistingObject will be thrown:"},
			Upload[<|
				Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Replace[Positions] -> {
					<|Name -> "A1", Footprint -> Open, MaxWidth -> 30 Millimeter, MaxDepth -> 30 Millimeter, MaxHeight -> 120 Millimeter|>,
					<|Name -> "A2", Footprint -> Open, MaxWidth -> 3 Millimeter, MaxDepth -> 3 Millimeter, MaxHeight -> 12 Millimeter|>
				},
				Replace[PositionPlotting] -> {
					<|Name -> "A1", XOffset -> 15 Millimeter, YOffset -> 15 Millimeter, ZOffset -> 60 Millimeter, CrossSectionalShape -> Circle, Rotation -> 0|>,
					<|Name -> "A2", XOffset -> 3 Millimeter, YOffset -> 3 Millimeter, ZOffset -> 6 Millimeter, CrossSectionalShape -> Circle, Rotation -> 0|>
				}
			|>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::MultiplePositionsFromExistingObject, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|
				Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Replace[Positions] -> {
					<|Name -> "A1", Footprint -> Open, MaxWidth -> 30 Millimeter, MaxDepth -> 30 Millimeter, MaxHeight -> 120 Millimeter|>
				},
				Replace[PositionPlotting] -> {
					<|Name -> "A1", XOffset -> 15 Millimeter, YOffset -> 15 Millimeter, ZOffset -> 60 Millimeter, CrossSectionalShape -> Circle, Rotation -> 0|>
				}
			|>]
		],
		Example[{Messages, "NotAllowedPositionName", "For vessels the position name of Positions and PositionsPlottings field must be \"A1\". If the provided position name is not A1, Error::NotAllowedPositionName will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Positions -> {
					{"A2", Open, 30 Millimeter, 30 Millimeter, 120 Millimeter}
				},
				PositionPlotting -> {
					{"A2", 15 Millimeter, 15 Millimeter, 60 Millimeter, Circle, 0}
				}
			],
			{_Rule..},
			Messages :> {Error::NotAllowedPositionName, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "NotAllowedPositionNameFromExistingObject", "For vessels the position name of Positions and PositionsPlottings field must be \"A1\". If currently the container model's position name is not A1, Error::NotAllowedPositionNameFromExistingObject will be thrown:"},
			Upload[<|
				Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Replace[Positions] -> {
					<|Name -> "A2", Footprint -> Open, MaxWidth -> 30 Millimeter, MaxDepth -> 30 Millimeter, MaxHeight -> 120 Millimeter|>
				},
				Replace[PositionPlotting] -> {
					<|Name -> "A2", XOffset -> 15 Millimeter, YOffset -> 15 Millimeter, ZOffset -> 60 Millimeter, CrossSectionalShape -> Circle, Rotation -> 0|>
				}
			|>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::NotAllowedPositionNameFromExistingObject, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|
				Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Replace[Positions] -> {
					<|Name -> "A1", Footprint -> Open, MaxWidth -> 30 Millimeter, MaxDepth -> 30 Millimeter, MaxHeight -> 120 Millimeter|>
				},
				Replace[PositionPlotting] -> {
					<|Name -> "A1", XOffset -> 15 Millimeter, YOffset -> 15 Millimeter, ZOffset -> 60 Millimeter, CrossSectionalShape -> Circle, Rotation -> 0|>
				}
			|>]
		],
		Example[{Messages, "ConflictingDimensionsEntry", "If the container has CrossSectionalShape -> Circle, the first two entries of Dimensions option (i.e., X and Y dimensions) are expected to be the same. If CrossSectionalShape is set to Circle but unequal x and y dimensions are specified, Error::ConflictingDimensionsEntry will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				CrossSectionalShape -> Circle,
				Dimensions -> {40 Millimeter, 41 Millimeter, 150 Millimeter}
			],
			{_Rule..},
			Messages :> {Error::ConflictingDimensionsEntry, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "ConflictingDimensionsEntryWithExistingField", "If the container has CrossSectionalShape -> Circle, the first two entries of Dimensions option (i.e., X and Y dimensions) are expected to be the same. If CrossSectionalShape is set to Circle while the current x and y dimensions are unequal in database, Error::ConflictingDimensionsEntryWithExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],Dimensions -> {40 Millimeter, 41 Millimeter, 150 Millimeter} |>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				CrossSectionalShape -> Circle
			],
			{_Rule..},
			Messages :> {Error::ConflictingDimensionsEntryWithExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],Dimensions -> {40 Millimeter, 40 Millimeter, 150 Millimeter} |>];
		],
		Example[{Messages, "ConflictingDimensionsEntryFromExistingField", "If the container has CrossSectionalShape -> Circle, the first two entries of Dimensions option (i.e., X and Y dimensions) are expected to be the same. If unequal x and y dimensions are provided for Dimensions option, but the CrossSectionalShape field is Circle for current model, Error::ConflictingDimensionsEntryFromExistingField will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Dimensions -> {40 Millimeter, 41 Millimeter, 150 Millimeter}
			],
			{_Rule..},
			Messages :> {Error::ConflictingDimensionsEntryFromExistingField, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "ConflictingDimensionsEntryBetweenExistingField", "If the container has CrossSectionalShape -> Circle, the first two entries of Dimensions option (i.e., X and Y dimensions) are expected to be the same. If the container has CrossSectionalShape -> Circle and unequal x nad y dimensions in database, Error::ConflictingDimensionsEntryBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],Dimensions -> {40 Millimeter, 41 Millimeter, 150 Millimeter} |>];
			UploadVerifiedContainerModel[
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::ConflictingDimensionsEntryBetweenExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],Dimensions -> {40 Millimeter, 40 Millimeter, 150 Millimeter} |>];
		],
		Example[{Messages, "InconsistentPitch", "If HorizontalPitch is not Null, Columns must be greater than 1. If HorizontalPitch provided but Columns is set to 1 at the same time, Error::InconsistentPitch will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Columns -> 1,
				HorizontalPitch -> 0.1 Millimeter,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				CavityCrossSectionalShape -> Circle,
				NumberOfWells -> Automatic,
				AspectRatio -> Automatic
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitch, Error::InvalidOption, Error::ColumnRowInconsistencyWithExistingField, Warning::NotYetVerified}
		],
		Example[{Messages, "InconsistentPitchToExistingField", "If HorizontalPitch is not Null, Columns must be greater than 1. If Columns is set to 1 but the HorizontalPitch field of current model is not Null, Error::InconsistentPitchToExistingField will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Columns -> 1,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				CavityCrossSectionalShape -> Circle,
				NumberOfWells -> Automatic,
				AspectRatio -> Automatic
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitchToExistingField, Error::InvalidOption, Error::ColumnRowInconsistencyWithExistingField, Warning::NotYetVerified}
		],
		Example[{Messages, "InconsistentPitchBetweenExistingField", "If HorizontalPitch is not Null, Columns must be greater than 1. If the current model has HorizontalPitch being not Null while Columns is 1, Error::InconsistentPitchBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Columns -> 1|>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				CavityCrossSectionalShape -> Circle,
				NumberOfWells -> Automatic,
				AspectRatio -> Automatic
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitchBetweenExistingField, Error::InvalidOption, Error::ColumnRowInconsistencyWithExistingField, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Columns -> 12|>]
		],
		Example[{Messages, "InconsistentPitch", "If VerticalPitch is not Null, Rows must be greater than 1. If the VerticalPitch option is provided but Rows is set to 1 at the same time, Error::InconsistentPitch will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Rows -> 1,
				VerticalPitch -> 0.1 Millimeter,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				CavityCrossSectionalShape -> Circle,
				NumberOfWells -> Automatic,
				AspectRatio -> Automatic
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitch, Error::InvalidOption, Error::ColumnRowInconsistencyWithExistingField, Warning::NotYetVerified}
		],
		Example[{Messages, "InconsistentPitchToExistingField", "If VerticalPitch is not Null, Rows must be greater than 1. If Rows is set to 1 but the VerticalPitch field of current model is not Null, Error::InconsistentPitchToExistingField will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Rows -> 1,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				CavityCrossSectionalShape -> Circle,
				NumberOfWells -> Automatic,
				AspectRatio -> Automatic
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitchToExistingField, Error::InvalidOption, Error::ColumnRowInconsistencyWithExistingField, Warning::NotYetVerified}
		],
		Example[{Messages, "InconsistentPitchBetweenExistingField", "If VerticalPitch is not Null, Rows must be greater than 1. If the current model has VerticalPitch being not Null while Rows is 1, Error::InconsistentPitchBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Rows -> 1|>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				CavityCrossSectionalShape -> Circle,
				NumberOfWells -> Automatic,
				AspectRatio -> Automatic
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitchBetweenExistingField, Error::InvalidOption, Error::ColumnRowInconsistencyWithExistingField, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Rows -> 8|>]
		],
		Example[{Messages, "InternalConicalDepthNotAllowed", "ConicalWellDepth is only valid for plate if WellBottom is VBottom or RoundBottom. If ConicalWellDepth is provided but also the WellBottom is not set to VBottom or RoundBottom, Error::InternalConicalDepthNotAllowed will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				ConicalWellDepth -> 1 Millimeter,
				WellBottom -> FlatBottom
			],
			{_Rule..},
			Messages :> {Error::InternalConicalDepthNotAllowed, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "InternalConicalDepthNotAllowedDueToExistingField", "ConicalWellDepth is only valid for plate if WellBottom is VBottom or RoundBottom. If WellBottom is set to something other than VBottom or RoundBottom while the ConicalWellDepth is not Null in database, Error::InternalConicalDepthNotAllowedDueToExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], ConicalWellDepth -> 1 Millimeter|>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				WellBottom -> FlatBottom
			],
			{_Rule..},
			Messages :> {Error::InternalConicalDepthNotAllowedDueToExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], ConicalWellDepth -> Null|>]
		],
		Example[{Messages, "InternalConicalDepthNotAllowedWithExistingField", "ConicalWellDepth is only valid for plate if WellBottom is VBottom or RoundBottom. If ConicalWellDepth is provided while the WellBottom field is not VBottom or RoundBottom in database, Error::InternalConicalDepthNotAllowedWithExistingField will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				ConicalWellDepth -> 1 Millimeter
			],
			{_Rule..},
			Messages :> {Error::InternalConicalDepthNotAllowedWithExistingField, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "InternalConicalDepthNotAllowedBetweenExistingField", "ConicalWellDepth is only valid for plate if WellBottom is VBottom or RoundBottom. If currently the container model's WellBottom is not VBottom or RoundBottom and ConicalWellDepth is not Null in database, Error::InternalConicalDepthNotAllowedBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], ConicalWellDepth -> 1 Millimeter|>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::InternalConicalDepthNotAllowedBetweenExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], ConicalWellDepth -> Null|>]
		],
		Example[{Messages, "ColumnRowInconsistency", "NumberOfWells must equal to the product of columns and rows. If all 3 options are specified but the NumberOfWells does not equal to Rows * Columns, Error::ColumnRowInconsistency will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Rows -> 9,
				Columns -> 12,
				NumberOfWells -> 96,
				AspectRatio -> 4/3
			],
			{_Rule..},
			Messages :> {Error::ColumnRowInconsistency, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "ColumnRowInconsistencyWithExistingField", "NumberOfWells must equal to the product of columns and rows. If currently in the database the NumberOfWells does not equal to Rows * Columns, Error::ColumnRowInconsistencyWithExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Rows -> 9 |>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::ColumnRowInconsistencyWithExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], Rows -> 8 |>]
		],
		Example[{Messages, "ColumnRowInconsistency", "AspectRatio must equal to the ratio between columns and rows. If all 3 options are specified but the AspectRatio does not equal to Columns/Rows, Error::ColumnRowInconsistency will be thrown:"},
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False,
				Rows -> 8,
				Columns -> 12,
				AspectRatio -> 2
			],
			{_Rule..},
			Messages :> {Error::ColumnRowInconsistency, Error::InvalidOption, Warning::NotYetVerified}
		],
		Example[{Messages, "ColumnRowInconsistencyWithExistingField", "AspectRatio must equal to the ratio between columns and rows. If currently in the database the AspectRatio does not equal to Columns/Rows, Error::ColumnRowInconsistencyWithExistingField will be thrown:"},
			Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], AspectRatio -> 2 |>];
			UploadVerifiedContainerModel[
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::ColumnRowInconsistencyWithExistingField, Error::InvalidOption, Warning::NotYetVerified},
			TearDown :> Upload[<|Object -> Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID], AspectRatio -> 1.5 |>]
		]
	},
	Stubs :> {$PersonID = Object[User, Emerald, Developer, "id:xRO9n3BleWNZ"]},
	SetUp :> {$CreatedObjects = {}},
	TearDown :> (
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Module[{allObjects, existingObejcts},
			allObjects = {
				Model[Container, Vessel, "Test invalid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Unknown Volume Unknown Material Vessel created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Container, Vessel, "Test valid container 2 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 3 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 4 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, ExtractionCartridge, "Test extraction cartridge 5 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, Filter, "Test filter 6 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 7 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 8 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 9 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 10 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 11 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 12 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 13 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 14 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 15 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 16 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 7 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 8 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 9 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for UploadVerifiedContainerModel unit tests "<>$SessionUUID]
			};
			existingObejcts = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObejcts, Verbose -> False, Force -> True]
		];
		Module[{testUser, testDeveloper, testinvalidContainer, testDoc, testDocDirectory, testNotebook},
			{testinvalidContainer, testNotebook} = CreateID[
				{
					Model[Container, Vessel],
					Object[LaboratoryNotebook]
				}
			];

			Upload[{
				<|
					Object -> testinvalidContainer,
					DeveloperObject -> True,
					Name -> "Test invalid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID,
					Notebook -> Link[testNotebook]
				|>,
				<|
					Object -> testNotebook,
					DeveloperObject -> True,
					Name -> "Test lab notebook for UploadVerifiedContainerModel unit tests "<>$SessionUUID
				|>
			}];

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];
			Upload[<|
				Object -> testDoc,
				Name -> "Test documentation file for UploadVerifiedContainerModel unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

			UploadContainerModel[
				Model[Container, Vessel],
				Name -> "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
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
				Force -> True
			];

			UploadContainerModel[
				Model[Container, Plate],
				Name -> "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				MinVolume -> 1 Milliliter,
				MaxVolume -> 50 Milliliter,
				MinTemperature -> -80 Celsius,
				MaxTemperature -> 200 Celsius,
				Ampoule -> False,
				Reusable -> False,
				Squeezable -> False,
				Opaque -> False,
				Positions -> Automatic,
				PositionPlotting -> Automatic,
				SelfStanding -> True,
				PreferredBalance -> Analytical,
				CrossSectionalShape -> Circle,
				PreferredCamera -> Medium,
				Sterile -> False,
				Fragile -> False,
				RNaseFree -> False,
				PyrogenFree -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				ContainerMaterials -> {{Glass}},
				DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Dimensions -> {40 Millimeter, 40 Millimeter, 150 Millimeter},
				CoverTypes -> {{Place}},
				CoverFootprints -> {{LidPlace8x126}},
				PlateColor -> Clear,
				WellColor -> Clear,
				Columns -> 12,
				Rows -> 8,
				NumberOfWells -> 96,
				WellDiameter -> 5 Millimeter,
				Treatment -> NonTreated,
				HorizontalMargin -> 1 Millimeter,
				VerticalMargin -> 1 Millimeter,
				DepthMargin -> 1 Millimeter,
				WellDepth -> 2 Millimeter,
				WellBottom -> FlatBottom,
				HorizontalOffset -> 1 Millimeter,
				VerticalOffset -> 1 Millimeter,
				Skirted -> False,
				StorageOrientation -> Upright,
				Footprint -> Plate,
				TransportStable -> True,
				HorizontalPitch -> 1 Millimeter,
				VerticalPitch -> 1 Millimeter,
				AspectRatio -> 1.5,
				CavityCrossSectionalShape -> Circle,
				Force -> True
			];

		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObejcts},
			allObjects = {
				Model[Container, Vessel, "Test invalid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test valid container 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test valid plate 1 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Unknown Volume Unknown Material Vessel created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Container, Vessel, "Test valid container 2 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 3 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 4 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, ExtractionCartridge, "Test extraction cartridge 5 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, Filter, "Test filter 6 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 7 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 8 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 9 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 10 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 11 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 12 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 13 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 14 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 15 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Vessel, "Test vessel 16 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 7 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 8 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Model[Container, Plate, "Test plate 9 for UploadVerifiedContainerModel unit tests "<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for UploadVerifiedContainerModel unit tests "<>$SessionUUID]
			};
			existingObejcts = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObejcts, Verbose -> False, Force -> True];
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*UploadContainerModelOptions*)

DefineTests[UploadContainerModelOptions,
	{
		Example[{Basic, "Function outputs resolved options for creating new container model in a table:"},
			UploadContainerModelOptions[
				Model[Container, Vessel],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModelOptions unit tests "<>$SessionUUID],
				Name -> "Test vessel 1 for UploadContainerModelOptions unit tests "<>$SessionUUID
			],
			_Grid
		],
		Example[{Basic, "Function outputs resolved options for creating new container model into a list if OutputFormat -> List:"},
			UploadContainerModelOptions[
				Model[Container, Vessel],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadContainerModelOptions unit tests "<>$SessionUUID],
				Name -> "Test vessel 1 for UploadContainerModelOptions unit tests "<>$SessionUUID,
				OutputFormat -> List
			],
			{(_Rule | _RuleDelayed)..}
		]
	},
	(* Note: In this test we need to Stub $PersonID, because UploadContainerModel behaves differently depending on if user or developer is running the function *)
	(* Specifically, we enforce that when developer running the function, resulted Model[Container] must pass VOQ, while that's not the case for users *)
	Stubs :> {$AllowUserInvalidObjectUploads = True, $PersonID = Object[User, "id:n0k9mG8AXZP6"]},
	SetUp :> {$CreatedObjects = {}},
	TearDown :> (
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Module[{allObjects, existingObejcts},
			allObjects = {
				Object[EmeraldCloudFile, "Test documentation file for UploadContainerModelOptions unit tests "<>$SessionUUID]
			};
			existingObejcts = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObejcts, Verbose -> False, Force -> True]
		];
		Module[{testDoc, testDocDirectory},

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];
			Upload[<|
				Object -> testDoc,
				Name -> "Test documentation file for UploadContainerModelOptions unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

		]
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidUploadContainerModelQ*)

DefineTests[ValidUploadContainerModelQ,
	{
		Example[{Basic, "Function checks if the supplied options are valid for creating a new Model[Container]:"},
			ValidUploadContainerModelQ[
				Model[Container, Vessel],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for ValidUploadContainerModelQ unit tests "<>$SessionUUID],
				Name -> "Test vessel 1 for ValidUploadContainerModelQ unit tests "<>$SessionUUID
			],
			True
		]
	},
	(* Note: In this test we need to Stub $PersonID, because UploadContainerModel behaves differently depending on if user or developer is running the function *)
	(* Specifically, we enforce that when developer running the function, resulted Model[Container] must pass VOQ, while that's not the case for users *)
	Stubs :> {$AllowUserInvalidObjectUploads = True, $PersonID = Object[User, "id:n0k9mG8AXZP6"]},
	SetUp :> {$CreatedObjects = {}},
	TearDown :> (
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Module[{allObjects, existingObejcts},
			allObjects = {
				Object[EmeraldCloudFile, "Test documentation file for ValidUploadContainerModelQ unit tests "<>$SessionUUID]
			};
			existingObejcts = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObejcts, Verbose -> False, Force -> True]
		];
		Module[{testDoc, testDocDirectory},

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];
			Upload[<|
				Object -> testDoc,
				Name -> "Test documentation file for ValidUploadContainerModelQ unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

		]
	}
];