(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*UploadCoverModel*)


(* ::Subsubsection::Closed:: *)
(*UploadCoverModel*)

DefineTests[
	UploadCoverModel,
	{
		Example[{Basic, "Function uploads a new cover model using user-friendly string (i.e., typeOfCover input):"},
			UploadCoverModel[
				"Bottle or carboy cap",
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> "Test user defined cap 7 for UploadCoverModel unit tests"<>$SessionUUID
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Example[{Basic, "Function uploads a new cover model when using type as input:"},
			UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> "Test user defined cap 21 for UploadCoverModel unit tests"<>$SessionUUID
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Example[{Basic, "Fully specify all options to upload a new Model[Item, Cap]:"},
			UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> "Test valid cap 2 for UploadCoverModel unit tests"<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				ProductRelation -> Null,
				Reusable -> False,
				Sterile -> False,
				PyrogenFree -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				WettedMaterials -> {{Glass}},
				DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Dimensions -> {4 Millimeter, 4 Millimeter, 2 Millimeter},
				CoverType -> Screw,
				CoverFootprint -> CapScrewTube35x13
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Test["Function can correctly handle list of mixed inputs:",
			UploadCoverModel[
				{
					Model[Item, Cap],
					Model[Item, Cap, "Test invalid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
					Model[Item, Lid],
					Model[Item, PlateSeal],
					Model[Item, Lid]
				},
				{
					Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
					Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
					Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
					Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
					Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID]
				},
				Name -> {
					"Test user defined cap 3 for UploadCoverModel unit tests"<>$SessionUUID,
					"Test invalid cap 1 for UploadCoverModel unit tests"<>$SessionUUID,
					"Test user defined lid 4 for UploadCoverModel unit tests"<>$SessionUUID,
					"Test user defined plate seal 5 for UploadCoverModel unit tests"<>$SessionUUID,
					"Test user defined lid 6 for UploadCoverModel unit tests"<>$SessionUUID
				}
			],
			{
				ObjectP[Model[Item, Cap, "Test user defined cap 3 for UploadCoverModel unit tests"<>$SessionUUID]],
				ObjectP[Model[Item, Cap, "Test invalid cap 1 for UploadCoverModel unit tests"<>$SessionUUID]],
				ObjectP[Model[Item, Lid, "Test user defined lid 4 for UploadCoverModel unit tests"<>$SessionUUID]],
				ObjectP[Model[Item, PlateSeal, "Test user defined plate seal 5 for UploadCoverModel unit tests"<>$SessionUUID]],
				ObjectP[Model[Item, Lid, "Test user defined lid 6 for UploadCoverModel unit tests"<>$SessionUUID]]
			},
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Example[{Basic, "One can create a new cover model which is not commercially available, i.e., Stocked -> False and no product-related options supplied, if the minimum required options are fully specified:"},
			UploadCoverModel[
				Model[Item, Cap],
				Name -> "Test valid cap 2 for UploadCoverModel unit tests"<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Reusable -> False,
				Sterile -> False,
				WettedMaterials -> {{Glass}}
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Example[{Additional, "If user is uncertain what type of cover to create, \"Others\" can be used as the typeOfCover input, and function will attempt to resolve to the correct type:"},
			UploadCoverModel[
				"Others",
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				CondensationRings -> True
			],
			ObjectP[Model[Item, Lid]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Example[{Additional, "User is allowed to supply a Model[Sample] as the ProductInformation input. In that case, ECL personnel will attempt to find the corresponding product in the verification process later:"},
			UploadCoverModel[
				"Tube or vial cap",
				Model[Sample, "Methanol"]
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Example[{Messages, "RequiredOptionsForNoProduct", "When creating a non-commercially-available new cover model without providing ProductInformation, all of these options: {WettedMaterials, Sterile, Reusable, Name} must be provided, otherwise the function will return $Failed:"},
			UploadCoverModel[
				Model[Item, Cap],
				Name -> "Test user defined cap 9 for UploadCoverModel unit tests"<>$SessionUUID
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]},
			Messages :> {Error::RequiredOptionsForNoProduct, Error::InvalidOption}
		],
		Example[{Messages, "InvalidProductDocumentationURL", "If a URL is provided for ProductDocumentation option but the URL can't be recognized as pdf file, the function will return $Failed:"},
			UploadCoverModel[
				Model[Item, Cap],
				ProductDocumentation -> "www.google.com",
				ProductURL -> "www.google.com",
				Name -> "Test user defined cap 10 for UploadCoverModel unit tests"<>$SessionUUID
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]},
			Messages :> {Error::InvalidProductDocumentationURL, Error::InvalidOption}
		],
		Example[{Messages, "InvalidProductDocumentationDirectory", "If a non-existing file path is provided for ProductDocumentation option, the function will return $Failed:"},
			UploadCoverModel[
				Model[Item, Cap],
				FileNameJoin[{$TemporaryDirectory, CreateUUID[]<>$SessionUUID<>"xxx.pdf"}],
				Name -> "Test user defined cap 11 for UploadCoverModel unit tests"<>$SessionUUID
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]},
			Messages :> {Error::InvalidFileDirectory, Error::InvalidOption}
		],
		Example[{Messages, "SameProductAlreadyExist", "If an Object[Product] is provided for Product option, but that product object already has associated model, function will switch to the existing model instead:"},
			UploadCoverModel[
				Model[Item, Cap],
				Object[Product, "50 mL Tube Caps"]
			],
			ObjectP[Model[Item, Cap, "id:54n6evKx0oqq"]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID], $AllowDuplicateProductModel = False},
			Messages :> {Warning::SameProductAlreadyExist}
		],
		Example[{Options, Name, "If a name is not provided, function will generate a name automatically based on CoverFootprint and WettedMaterials options provided, this name is guaranteed to be not duplicated with other cover models in database:"},
			coverModel = UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				CoverFootprint -> CapSnap7x6
			];
			Download[coverModel, Name],
			"CapSnap7x6 Cap 2 created on "<>DateString[Now, {"Month", "Day", "Year"}],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID], $DeveloperSearch = True},
			SetUp :> (
				$CreatedObjects = {};
				Upload[
					<|
						Type -> Model[Item, Cap],
						DeveloperObject -> True,
						Name -> "CapSnap7x6 Cap created on "<>DateString[Now, {"Month", "Day", "Year"}]
					|>
				]
			),
			Variables :> {coverModel}
		],
		Example[{Messages, "RedundantOptions", "If any option that are not relevant to the input type was specified, an error will be thrown and function will return $Failed:"},
			UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> "Test user defined cap 15 for UploadCoverModel unit tests"<>$SessionUUID,
				Rows -> 2
			],
			$Failed,
			Messages :> {Error::RedundantOptions, Error::InvalidOption},
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Example[{Messages, "RedundantOptions", "If any option that are not relevant to the input type was specified as Null, no error will occur, and this irrelevant field will be removed from upload packets:"},
			UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> "Test user defined cap 16 for UploadCoverModel unit tests"<>$SessionUUID,
				Rows -> Null
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Example[{Messages, "SameProductAlreadyExist", "When creating a new model, if there is already an existing cover model in database that has the same ProductInformation, changes based on your option will be applied to that object instead:"},
			UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID]
			],
			ObjectP[Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID]],
			Messages :> {Warning::SameProductAlreadyExist},
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID], $AllowDuplicateProductModel = False}
		],
		Example[{Messages, "PotentialExistingModel", "When creating a new model and set Force -> True, function will bypass the check about whether the new model is too similar to any existing ones:"},
			UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> "Test user defined cap 20 for UploadCoverModel unit tests"<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				ProductRelation -> Null,
				Reusable -> False,
				Sterile -> False,
				PyrogenFree -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				WettedMaterials -> {{Glass}},
				DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Dimensions -> {4 Millimeter, 4 Millimeter, 2 Millimeter},
				CoverType -> Screw,
				CoverFootprint -> CapScrewTube35x13,
				Force -> True
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID], $IgnorePropertyDuplicateModel = False}
		],
		Example[{Options, ProductDocumentation, "User can specify a local file directory in lieu of Object[EmeraldCloudFile] for the ProductDocumentation option:"},
			UploadCoverModel[
				Model[Item, Cap],
				FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}],
				Name -> "Test user defined cap 13 for UploadCoverModel unit tests"<>$SessionUUID
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]},
			SetUp :> ClearMemoization[]
		],
		Example[{Options, ImageFile, "User can specify a local file directory in lieu of Object[EmeraldCloudFile] for the ImageFile option:"},
			UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				ImageFile -> FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}],
				Name -> "Test user defined cap 14 for UploadCoverModel unit tests"<>$SessionUUID
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]},
			SetUp :> ClearMemoization[]
		],
		Test["Ensure that "<>ToString[Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID]]<>" created in SymbolSetUp passes VOQ:",
			ValidObjectQ[Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID]],
			True
		],
		Test["When developer running this function, fully specify all options is necessary to upload a new Model[Item, Cap]:",
			UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> "Test valid cap 2 for UploadCoverModel unit tests"<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				ProductRelation -> Null,
				Reusable -> False,
				Sterile -> False,
				PyrogenFree -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				WettedMaterials -> {{Glass}},
				DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Dimensions -> {4 Millimeter, 4 Millimeter, 2 Millimeter},
				CoverType -> Screw,
				CoverFootprint -> CapScrewTube35x13
			],
			ObjectP[Model[Item, Cap]],
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Example[{Options, ExposedSurfaces, "Indicate that sensitive portions of this cover are open to the external environment and prone to contamination:"},
			cover = UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> Null,
				ExposedSurfaces -> True,
				Reusable -> False,
				Sterile -> False,
				WettedMaterials -> {{Glass}}
			];
			Download[cover, ExposedSurfaces],
			True,
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]},
			Variables :> {cover}
		],
		Example[{Options, DefaultStorageCondition, "If ExposedSurfaces is True, DefaultStorageCondition automatically resolves to Ambient Storage, Lined Enclosed:"},
			cover = UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> Null,
				ExposedSurfaces -> True,
				Reusable -> False,
				Sterile -> False,
				WettedMaterials -> {{Glass}}
			];
			Download[cover, DefaultStorageCondition],
			ObjectP[Model[StorageCondition, "Ambient Storage, Lined Enclosed"]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]},
			Variables :> {cover}
		],
		Example[{Options, DefaultStorageCondition, "If ExposedSurfaces is False, DefaultStorageCondition automatically resolves to Ambient Storage:"},
			cover = UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> Null,
				ExposedSurfaces -> False,
				Reusable -> False,
				Sterile -> False,
				WettedMaterials -> {{Glass}}
			];
			Download[cover, DefaultStorageCondition],
			ObjectP[Model[StorageCondition, "Ambient Storage"]],
			Stubs :> {$PersonID = Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID]},
			Variables :> {cover}
		],
		Test["When developer running this function to create a new Model[Item, Cap], if the final packet does not pass ValidObjectQ, function returns $Failed:",
			Quiet[UploadCoverModel[
				Model[Item, Cap],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Name -> "Test user defined cap 8 for UploadCoverModel unit tests"<>$SessionUUID
			]],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Test["When developer running this function on an existing Model[Item, Cap], it will upload changes to fields according to provided options:",
			UploadCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
				Sterile -> True
			];
			Download[Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID], Sterile],
			True,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID]}
		],
		Test["When running this function to change existing Model[Item, Cap], only fields bearing the same name as specified options will be changed:",
			packets = UploadCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
				Sterile -> False,
				SeptumRequired -> False,
				Upload -> False
			];
			capModelPacket = FirstCase[packets, PacketP[Model[Item, Cap]]];
			KeyExistsQ[capModelPacket, #]& /@ {Name, Append[Products], Sterile, SeptumRequired, InternalDimensions, Reusable},
			{False, False, True, True, False, False},
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID]},
			Variables :> {capModelPacket, packets}
		],
		Test["In the upload packet, most multiple fields will have the Replace[] head, while Products and ProductDocumentations will have Append[] head:",
			packets = UploadCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				WettedMaterials -> {{LDPE, Aluminum}},
				Upload -> False
			];
			capModelPacket = FirstCase[packets, PacketP[Model[Item, Cap]]];
			Lookup[capModelPacket, #, "Missing"]& /@ {Replace[ProductDocumentationFiles], Append[ProductDocumentationFiles], Replace[WettedMaterials], Append[WettedMaterials]},
			{"Missing", ObjectP[Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID]], {LDPE, Aluminum}, "Missing"},
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID]},
			Variables :> {capModelPacket, packets}
		],
		Example["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to certain options are conflicting with the CoverType -> Crimp option, Error::InvalidCrimpCapOption will be thrown once:",
			UploadCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
				CoverType -> Crimp,
				SeptumRequired -> Null,
				CrimpType -> Null,
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID]},
			Messages :> {Error::InvalidCrimpCapOption, Error::InvalidOption}
		],
		Example["When developers are running this function, if resulted model doesn't pass ValidObjectQ due to the CoverType option is conflicting with the Type, Error::InvalidCoverType will be thrown once:",
			UploadCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
				CoverType -> Seal,
				Upload -> False
			],
			$Failed,
			Stubs :> {$PersonID = Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID]},
			Messages :> {Error::InvalidCoverType, Error::InvalidOption}
		]
	},
	Stubs :> {$AllowUserInvalidObjectUploads = True, $AllowDuplicateProductModel = True, $IgnorePropertyDuplicateModel = True},
	SetUp :> {$CreatedObjects = {}},
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID],
				Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test invalid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "CapSnap7x6 Cap created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Item, Cap, "CapSnap7x6 Cap 2 created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Item, Cap, "Test valid cap 2 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 3 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Lid, "Test user defined lid 4 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, PlateSeal, "Test user defined plate seal 5 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Lid, "Test user defined lid 6 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 7 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 8 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 9 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 10 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 11 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 12 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 13 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 14 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 15 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 16 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 17 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 18 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 19 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 20 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 21 for UploadCoverModel unit tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for UploadCoverModel unit tests"<>$SessionUUID],
				Object[Product, "Test product for UploadCoverModel unit tests"<>$SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Verbose -> False, Force -> True]
		];
		Module[{testUser, testDeveloper, testinvalidCap, testDoc, testDocDirectory, testNotebook},
			{testUser, testDeveloper, testinvalidCap, testNotebook} = CreateID[
				{
					Object[User],
					Object[User, Emerald, Developer],
					Model[Item, Cap],
					Object[LaboratoryNotebook]
				}
			];

			Upload[{
				<|
					Object -> testUser,
					DeveloperObject -> True,
					Name -> "Test external user for UploadCoverModel unit tests"<>$SessionUUID
				|>,
				<|
					Object -> testDeveloper,
					DeveloperObject -> True,
					Name -> "Test developer for UploadCoverModel unit tests"<>$SessionUUID
				|>,
				<|
					Object -> testinvalidCap,
					DeveloperObject -> True,
					Name -> "Test invalid cap 1 for UploadCoverModel unit tests"<>$SessionUUID,
					Notebook -> Link[testNotebook]
				|>,
				<|
					Object -> testNotebook,
					DeveloperObject -> True,
					Name -> "Test lab notebook for UploadCoverModel unit tests"<>$SessionUUID
				|>
			}];

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];
			Upload[<|
				Object -> testDoc,
				Name -> "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID,
				DeveloperObject -> True
			|>];

			Block[{$Notebook = testNotebook},
				UploadCoverModel[
					Model[Item, Cap],
					Name -> "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID,
					ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
					ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
					ProductRelation -> Null,
					Reusable -> False,
					Sterile -> False,
					PyrogenFree -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					WettedMaterials -> {{Glass}},
					DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
					Dimensions -> {4 Millimeter, 4 Millimeter, 2 Millimeter},
					CoverType -> Screw,
					CoverFootprint -> CapScrewTube35x13,
					Force -> True
				]
			]

		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Object[User, Emerald, Developer, "Test developer for UploadCoverModel unit tests"<>$SessionUUID],
				Object[User, "Test external user for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test invalid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test valid cap 1 for UploadCoverModel unit tests"<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "CapSnap7x6 Cap created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Item, Cap, "CapSnap7x6 Cap 2 created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Item, Cap, "Test valid cap 2 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 3 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Lid, "Test user defined lid 4 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, PlateSeal, "Test user defined plate seal 5 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Lid, "Test user defined lid 6 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 7 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 8 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 9 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 10 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 11 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 12 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 13 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 14 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 15 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 16 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 17 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 18 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 19 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 20 for UploadCoverModel unit tests"<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 21 for UploadCoverModel unit tests"<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for UploadCoverModel unit tests"<>$SessionUUID],
				Object[Product, "Test product for UploadCoverModel unit tests"<>$SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Verbose -> False, Force -> True]
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*UploadVerifiedCoverModel*)

DefineTests[
	UploadVerifiedCoverModel,
	{
		Test["Ensure that "<>ToString[Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]]<>" created in SymbolSetUp passes VOQ:",
			ValidObjectQ[Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]],
			True
		],
		Test["Ensure that "<>ToString[Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]]<>" created in SymbolSetUp passes VOQ:",
			ValidObjectQ[Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]],
			True
		],
		Test["Ensure that "<>ToString[Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]]<>" created in SymbolSetUp passes VOQ:",
			ValidObjectQ[Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]],
			True
		],
		Example[{Basic, "By default Verify -> False, function runs ValidObjectQ on the input object and output the field values as resolved options:"},
			UploadVerifiedCoverModel[Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]],
			{_Rule..},
			Messages :> {Warning::NotYetVerified},
			SetUp :> On[Warning::NotYetVerified],
			TearDown :> Off[Warning::NotYetVerified]
		],
		Example[{Basic, "When Verify -> True, function runs ValidObjectQ on the input object; if it passes, function will upload the changes:"},
			UploadVerifiedCoverModel[Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Verify -> True],
			ObjectP[Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]],
			TearDown :> (Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Verified -> Null |>])
		],
		Example[{Basic, "When Verify -> True, function runs ValidObjectQ on the input object; if it passes, function will set Verified -> True:"},
			UploadVerifiedCoverModel[Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Verify -> True];
			Download[Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Verified],
			True,
			SetUp :> (Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Verified -> Null |>]),
			TearDown :> (Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Verified -> Null |>])
		],
		Example[{Additional, "Strict option will be overridden and always be True:"},
			Quiet[UploadVerifiedCoverModel[Model[Item, Cap, "Test invalid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Verify -> True, Strict -> False]],
			$Failed
		],
		Example[{Options, NewType, "If the original cover model is not in correct Type, developer can use NewType option to create a replacement model in the correct type:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test invalid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Name -> "Test corrected Lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID,
				NewType -> Model[Item, Lid],
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				ProductRelation -> Null,
				Reusable -> False,
				Sterile -> False,
				PyrogenFree -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				WettedMaterials -> {{Glass}},
				DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Dimensions -> {4 Millimeter, 4 Millimeter, 2 Millimeter},
				CoverType -> Place,
				CoverFootprint -> LidPlace8x126,
				CondensationRings -> False,
				RestingOrientation -> FaceUp,
				Verify -> True
			],
			ObjectP[Model[Item, Lid, "Test corrected Lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]]
		],
		Example[{Messages, "InternalOnlyFunction", "This function is meant for ECL internal personnel only. When external user run this function, Error::InternalOnlyFunction will be thrown:"},
			UploadVerifiedCoverModel[Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID]],
			$Failed,
			Messages :> {Error::InternalOnlyFunction},
			Stubs :> {$PersonID = Object[User, "Test external user for UploadVerifiedCoverModel unit tests "<>$SessionUUID]}
		],
		Example[{Messages, "UnableToFindInfo", "If any options are required in order to pass VOQ, but they're missing, Error::UnableToFindInfo will be thrown:"},
			UploadVerifiedCoverModel[Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Verify -> False],
			{_Rule..},
			Messages :> {Error::UnableToFindInfo, Error::InvalidOption},
			SetUp :> Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Null, DefaultStorageCondition -> Null |>],
			TearDown :> Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Screw, DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]] |>]
		],
		Example[{Messages, "RequiredOptions", "If any options are required in order to pass VOQ, but they're set to Null by the user, Error::RequiredOptions will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverType -> Null,
				DefaultStorageCondition -> Null
			],
			{_Rule..},
			Messages :> {Error::RequiredOptions, Error::InvalidOption},
			SetUp :> Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Null, DefaultStorageCondition -> Null |>],
			TearDown :> Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Screw, DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]] |>]
		],
		Example[{Messages, "ConflictingOptionsMagnitude", "If user incorrectly set the MaxTemperature and MinTemperature option such that MaxTemperature is lower than MinTemperature, Error::ConflictingOptionsMagnitude will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				MaxTemperature -> 100 Kelvin,
				MinTemperature -> 200 Kelvin
			],
			{_Rule..},
			Messages :> {Error::ConflictingOptionsMagnitude, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingOptionsMagnitudeFromExistingField", "If user incorrectly set the MaxTemperature and MinTemperature option such that MaxTemperature is lower than MinTemperature, Error::ConflictingOptionsMagnitudeFromExistingField will be thrown:"},
			Upload[<| Object -> Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], MinTemperature -> 200 Kelvin, MaxTemperature -> 100 Kelvin |>];
			UploadVerifiedCoverModel[
				Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::ConflictingOptionsMagnitudeFromExistingField, Error::InvalidOption},
			TearDown :> Upload[<| Object -> Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], MinTemperature -> -80 Celsius, MaxTemperature -> 200 Celsius |>]
		],
		Example[{Messages, "RequiredTogetherOptions", "Certain options must be specified together, e.g., InnerDiameter and OuterDiameter. If the user set one of them to Null but the other to non-Null, Error::RequiredTogetherOptions will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				InnerDiameter -> 4 Millimeter,
				OuterDiameter -> Null
			],
			{_Rule..},
			Messages :> {Error::RequiredTogetherOptions, Error::InvalidOption}
		],
		Example[{Messages, "RequiredTogetherOptions", "Certain options must be specified together, e.g., InnerDiameter and OuterDiameter. If the user set one of them to Null without realizing the other one is not Null in database, Error::RequiredTogetherOptionsFromExternalSource will be thrown:"},
			Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], InnerDiameter -> 4 Millimeter |>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				OuterDiameter -> Null
			],
			{_Rule..},
			Messages :> {Error::RequiredTogetherOptionsFromExternalSource, Error::InvalidOption},
			TearDown :> Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], InnerDiameter -> Null |>]
		],
		Example[{Messages, "RequiredTogetherOptionsConflictFromExternalSource", "Certain options must be specified together, e.g., InnerDiameter and OuterDiameter. If one of the fields is Null but the other one is not Null in database, Error::RequiredTogetherOptionsConflictFromExternalSource will be thrown:"},
			Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], InnerDiameter -> 4 Millimeter |>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Reusable -> True
			],
			{_Rule..},
			Messages :> {Error::RequiredTogetherOptionsConflictFromExternalSource, Error::InvalidOption},
			TearDown :> Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], InnerDiameter -> Null |>]
		],
		Example[{Messages, "StorageOrientationImageRequired", "If StorageOrientation is set to Side or Face, StorageOrientationImage must be provided. If that's not the case, Error::StorageOrientationImageRequired will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				StorageOrientation -> Side
			],
			{_Rule..},
			Messages :> {Error::StorageOrientationImageRequired, Error::InvalidOption}
		],
		Example[{Messages, "StorageOrientationImageRequiredFromExternalField", "If StorageOrientation is set to Side or Face according to Template or database, StorageOrientationImage must be provided. If that's not the case, Error::StorageOrientationImageRequiredFromExternalField will be thrown:"},
			Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], StorageOrientation -> Side |>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::StorageOrientationImageRequiredFromExternalField, Error::InvalidOption},
			TearDown :> Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], StorageOrientation -> Any |>]
		],
		Example[{Messages, "ImageForStorageRequired", "If StorageOrientation is set to Upright, StorageOrientationImage or ImageFile must be provided. If that's not the case, Error::ImageForStorageRequired will be thrown:"},
			Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], ImageFile -> Null |>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				StorageOrientation -> Upright
			],
			{_Rule..},
			Messages :> {Error::ImageForStorageRequired, Error::InvalidOption, Error::UnableToFindInfo},
			TearDown :> Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], StorageOrientation -> Any, ImageFile -> Link[Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID]] |>]
		],
		Example[{Messages, "ImageForStorageRequiredFromExternalField", "If StorageOrientation is set to Side or Face according to Template or database, StorageOrientationImage must be provided. If that's not the case, Error::ImageForStorageRequiredFromExternalField will be thrown:"},
			Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], StorageOrientation -> Upright, ImageFile -> Null |>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::ImageForStorageRequiredFromExternalField, Error::InvalidOption, Error::UnableToFindInfo},
			TearDown :> Upload[<| Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], StorageOrientation -> Any, ImageFile -> Link[Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID]] |>]
		],
		Example[{Messages, "CrimpOnlyOptions", "Some options can be provided only if the CoverType is Crimp, e.g. CrimpingPressure. If user provided CrimpingPressure but set CoverType to something else, Error::CrimpOnlyOptions will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CrimpingPressure -> 30 PSI,
				CoverType -> Screw
			],
			{_Rule..},
			Messages :> {Error::CrimpOnlyOptions, Error::InvalidOption}
		],
		Example[{Messages, "CrimpOnlyOptionsFromExternalField", "Some options can be provided only if the CoverType is Crimp, e.g. CrimpingPressure. If user provided CrimpingPressure without realizing CoverType is set to something other than Crimp according to Template or database, Error::CrimpOnlyOptionsFromExternalField will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CrimpingPressure -> 30 PSI
			],
			{_Rule..},
			Messages :> {Error::CrimpOnlyOptionsFromExternalField, Error::InvalidOption}
		],
		Example[{Messages, "CrimpOnlyOptionsInconsistentFromExternalField", "Some options can be provided only if the CoverType is Crimp, e.g. CrimpingPressure. If user set CoverType to something else but a non-Null value for CrimpingPressure is inherited from Template or database, Error::CrimpOnlyOptionsInconsistentFromExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CrimpingPressure -> 30 PSI|>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverType -> Screw
			],
			{_Rule..},
			Messages :> {Error::CrimpOnlyOptionsInconsistentFromExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CrimpingPressure -> Null|>]
		],
		Example[{Messages, "CrimpOnlyOptionsInconsistentFromExternalField", "Some options can be provided only if the CoverType is Crimp, e.g. CrimpingPressure. If CoverType is set to something else but CrimpingPressure is set to non-Null, both inherited from Template or database, Error::CrimpOnlyOptionsInconsistentFromExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CrimpingPressure -> 30 PSI|>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverType -> Screw
			],
			{_Rule..},
			Messages :> {Error::CrimpOnlyOptionsInconsistentFromExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CrimpingPressure -> Null|>]
		],
		Example[{Messages, "CrimpRequiredOptions", "Some options must be provided if the CoverType is Crimp, e.g. Pierceable. If user set CoverType to Crimp and Pierceable to Null, Error::CrimpRequiredOptions will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Pierceable -> Null,
				CoverType -> Crimp
			],
			{_Rule..},
			Messages :> {Error::CrimpRequiredOptions, Error::InvalidOption, Error::CrimpRequiredOptionsInconsistentFromExternalField}
		],
		Example[{Messages, "CrimpRequiredOptionsFromExternalField", "Some options must be provided if the CoverType is Crimp, e.g. Pierceable. If user set Pierceable to Null without realizing CoverType is set to Crimp according to Template or database, Error::CrimpRequiredOptionsFromExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Crimp|>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Pierceable -> Null
			],
			{_Rule..},
			Messages :> {Error::CrimpRequiredOptionsFromExternalField, Error::InvalidOption, Error::CrimpRequiredOptionsBetweenExternalField},
			TearDown :> Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Screw|>]
		],
		Example[{Messages, "CrimpRequiredOptionsInconsistentFromExternalField", "Some options must be provided if the CoverType is Crimp, e.g. Pierceable. If user set CoverType to Crimp but Pierceable is not specified and cannot be found from Template or database, Error::CrimpRequiredOptionsInconsistentFromExternalField will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverType -> Crimp
			],
			{_Rule..},
			Messages :> {Error::CrimpRequiredOptionsInconsistentFromExternalField, Error::InvalidOption}
		],
		Example[{Messages, "CrimpRequiredOptionsBetweenExternalField", "Some options can be provided only if the CoverType is Crimp, e.g. Pierceable. If CoverType is set to crimp by Template or database, but Pierceable cannot be found from the same source, Error::CrimpRequiredOptionsBetweenExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Crimp|>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::CrimpRequiredOptionsBetweenExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Screw|>]
		],
		Example[{Messages, "CrimpCoverCannotReuse", "Crimp cover cannot be reused. If user set CoverType to Crimp and Reusablility to True, Error::CrimpCoverCannotReuse will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverType -> Crimp,
				Reusable -> True,
				Pierceable -> True,
				SeptumRequired -> False,
				CrimpType -> Aluminum,
				CrimpingPressure -> 30 PSI
			],
			{_Rule..},
			Messages :> {Error::CrimpCoverCannotReuse, Error::InvalidOption}
		],
		Example[{Messages, "CrimpCoverCannotReuseFromExternalField", "Crimp cover cannot be reused. If user set CoverType to Crimp without realizing Reusable is set to True by Template or database, Error::CrimpCoverCannotReuseFromExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Reusable -> True|>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverType -> Crimp,
				Pierceable -> True,
				SeptumRequired -> False,
				CrimpType -> Aluminum,
				CrimpingPressure -> 30 PSI
			],
			{_Rule..},
			Messages :> {Error::CrimpCoverCannotReuseFromExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Reusable -> False |>]
		],
		Example[{Messages, "CrimpCoverCannotReuseBetweenExternalField", "Crimp cover cannot be reused. If the cover model currently have Reusable -> True and CoverType -> Crimp in database, Error::CrimpCoverCannotReuseBetweenExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Reusable -> True, CoverType -> Crimp|>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Pierceable -> True,
				SeptumRequired -> False,
				CrimpType -> Aluminum,
				CrimpingPressure -> 30 PSI
			],
			{_Rule..},
			Messages :> {Error::CrimpCoverCannotReuseBetweenExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Reusable -> False, CoverType -> Screw |>]
		],
		Example[{Messages, "BarcodeForbidden", "Barcode option must be set to False if the cap is too small. If user set Barcode to True for a cap whose width and depth are both below 41 mm, Error::BarcodeForbidden will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Barcode -> True
			],
			{_Rule..},
			Messages :> {Error::BarcodeForbidden, Error::InvalidOption}
		],
		Example[{Messages, "BarcodeForbiddenFromExternalField", "Barcode option must be set to False if the cap is too small. If in database the cap's width and depth are both below 41 mm but Barcode -> True, Error::BarcodeForbiddenFromExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Barcode -> True|>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::BarcodeForbiddenFromExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Barcode -> False|>]
		],
		Example[{Messages, "BarcodeRequired", "Barcode option must be set to True if the cap is large enough. If user set Barcode to False for a cap which either width or depth is above 54 mm, Error::BarcodeRequired will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Barcode -> False,
				Dimensions -> {60 Millimeter, 60 Millimeter, 60 Millimeter}
			],
			{_Rule..},
			Messages :> {Error::BarcodeRequired, Error::InvalidOption}
		],
		Example[{Messages, "BarcodeRequiredFromExternalField", "Barcode option must be set to False if the cap is too small. If in database the cap's width or depth is above 54 mm but Barcode -> False, Error::BarcodeRequiredFromExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Dimensions -> {60 Millimeter, 60 Millimeter, 60 Millimeter}|>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::BarcodeRequiredFromExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Dimensions -> {4 Millimeter, 4 Millimeter, 2 Millimeter}|>]
		],
		Example[{Messages, "CoverTypeMismatch", "Seal is not a supported CoverType for Model[Item, Cap] type input. If user set CoverType to Seal, Error::CoverTypeMismatch will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverType -> Seal
			],
			{_Rule..},
			Messages :> {Error::CoverTypeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "CoverTypeMismatchFromExternalField", "Seal is not a supported CoverType for Model[Item, Cap] type input. If currently the CoverType of the Model[Item, Cap] object is Seal, Error::CoverTypeMismatchFromExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Seal|>];
			UploadVerifiedCoverModel[
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::CoverTypeMismatchFromExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Screw|>]
		],
		Example[{Messages, "CoverTypeMismatch", "Supported CoverType for Model[Item, Lid] type input are Snap and Place. If user set CoverType to Crimp, Seal, Screw, or Pry, Error::CoverTypeMismatch will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverType -> Seal
			],
			{_Rule..},
			Messages :> {Error::CoverTypeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "CoverTypeMismatchFromExternalField", "Supported CoverType for Model[Item, Lid] type input are Snap and Place. If currently the CoverType of the Model[Item, Lid] object is Crimp, Seal, Screw, or Pry, Error::CoverTypeMismatchFromExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Seal|>];
			UploadVerifiedCoverModel[
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::CoverTypeMismatchFromExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Place|>]
		],
		Example[{Messages, "RequiredTogetherOptions", "For Model[Item, Lid] type input, the following 4 options: Columns, Rows, NumberOfRings, AspectRatio must all be Null or all be specified. If user supplied values for some of these options but set others to Null, Error::RequiredTogetherOptions will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Rows -> 1,
				Columns -> Null,
				NumberOfRings -> Null,
				AspectRatio -> Null
			],
			{_Rule..},
			Messages :> {Error::RequiredTogetherOptions, Error::InvalidOption}
		],
		Example[{Messages, "InconsistentPitch", "If HorizontalPitch is not Null, Columns must be greater than 1. If user incorrectly set HorizontalPitch to non-Null but Columns to 1, Error::InconsistentPitch will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Columns -> 1,
				Rows -> 1,
				HorizontalPitch -> 0.1 Millimeter,
				NumberOfRings -> 1,
				AspectRatio -> 1
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitch, Error::InvalidOption}
		],
		Example[{Messages, "InconsistentPitchToExistingField", "If HorizontalPitch is not Null, Columns must be greater than 1. If user incorrectly set Columns to 1 without realizing HorizontalPitch of current model is not Null, Error::InconsistentPitchToExistingField will be thrown:"},
			Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Columns -> 1, HorizontalPitch -> 0.1 Millimeter|>];
			UploadVerifiedCoverModel[
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Columns -> 1,
				Rows -> 1,
				NumberOfRings -> 1,
				AspectRatio -> 1
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitchToExistingField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Columns -> Null, HorizontalPitch -> Null|>]
		],
		Example[{Messages, "InconsistentPitchBetweenExistingField", "If HorizontalPitch is not Null, Columns must be greater than 1. If the current model has HorizontalPitch being not Null while Columns is 1, Error::InconsistentPitchBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Columns -> 1, HorizontalPitch -> 0.1 Millimeter|>];
			UploadVerifiedCoverModel[
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Rows -> 1,
				NumberOfRings -> 1,
				AspectRatio -> 1
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitchBetweenExistingField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Columns -> Null, HorizontalPitch -> Null|>]
		],
		Example[{Messages, "InconsistentPitch", "If VerticalPitch is not Null, Rows must be greater than 1. If user incorrectly set VerticalPitch to non-Null but Rows to 1, Error::InconsistentPitch will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Rows -> 1,
				VerticalPitch -> 0.1 Millimeter,
				Columns -> 1,
				NumberOfRings -> 1,
				AspectRatio -> 1
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitch, Error::InvalidOption}
		],
		Example[{Messages, "InconsistentPitchToExistingField", "If VerticalPitch is not Null, Rows must be greater than 1. If user incorrectly set Rows to 1 without realizing VerticalPitch of current model is not Null, Error::InconsistentPitchToExistingField will be thrown:"},
			Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Rows -> 1, VerticalPitch -> 0.1 Millimeter|>];
			UploadVerifiedCoverModel[
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Rows -> 1,
				Columns -> 1,
				NumberOfRings -> 1,
				AspectRatio -> 1
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitchToExistingField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Rows -> Null, VerticalPitch -> Null|>]
		],
		Example[{Messages, "InconsistentPitchBetweenExistingField", "If VerticalPitch is not Null, Rows must be greater than 1. If the current model has VerticalPitch being not Null while Rows is 1, Error::InconsistentPitchBetweenExistingField will be thrown:"},
			Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Rows -> 1, VerticalPitch -> 0.1 Millimeter|>];
			UploadVerifiedCoverModel[
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				Columns -> 1,
				NumberOfRings -> 1,
				AspectRatio -> 1
			],
			{_Rule..},
			Messages :> {Error::InconsistentPitchBetweenExistingField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], Rows -> Null, VerticalPitch -> Null|>]
		],
		Example[{Messages, "PlateSealCoverTypeMismatch", "The only allowed CoverType for Model[Item, PlateSeal] type input is Seal. If user set CoverType to anything other than Seal, Error::PlateSealCoverTypeMismatch will be thrown:"},
			UploadVerifiedCoverModel[
				Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False,
				CoverType -> Place
			],
			{_Rule..},
			Messages :> {Error::PlateSealCoverTypeMismatch, Error::InvalidOption}
		],
		Example[{Messages, "PlateSealCoverTypeMismatchFromExternalField", "The only allowed CoverType for Model[Item, PlateSeal] type input is Seal. If currently the CoverType of this model is anything other than Seal, Error::PlateSealCoverTypeMismatchFromExternalField will be thrown:"},
			Upload[<|Object -> Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Place |>];
			UploadVerifiedCoverModel[
				Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Verify -> False
			],
			{_Rule..},
			Messages :> {Error::PlateSealCoverTypeMismatchFromExternalField, Error::InvalidOption},
			TearDown :> Upload[<|Object -> Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID], CoverType -> Seal |>]
		]
	},
	Stubs :> {$AllowUserInvalidObjectUploads = True},
	SetUp :> {$CreatedObjects = {}},
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Object[User, Emerald, Developer, "Test developer for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Object[User, "Test external user for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test invalid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test corrected Lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test corrected Lid 2 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "CapSnap7x6 Cap created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Item, Cap, "Test valid cap 2 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 3 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test user defined lid 4 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, PlateSeal, "Test user defined plate seal 5 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test user defined lid 6 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 7 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 8 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 9 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 10 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 11 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 12 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 13 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 14 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 15 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 16 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 17 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 18 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 19 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 20 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for UploadVerifiedCoverModel unit tests "<>$SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Verbose -> False, Force -> True]
		];
		Module[{testUser, testDeveloper, testinvalidCap, testDoc, testDocDirectory, testNotebook},
			{testUser, testDeveloper, testinvalidCap, testNotebook} = CreateID[
				{
					Object[User],
					Object[User, Emerald, Developer],
					Model[Item, Cap],
					Object[LaboratoryNotebook]
				}
			];

			Upload[{
				<|
					Object -> testUser,
					DeveloperObject -> True,
					Name -> "Test external user for UploadVerifiedCoverModel unit tests "<>$SessionUUID
				|>,
				<|
					Object -> testDeveloper,
					DeveloperObject -> True,
					Name -> "Test developer for UploadVerifiedCoverModel unit tests "<>$SessionUUID
				|>,
				<|
					Object -> testinvalidCap,
					DeveloperObject -> True,
					Name -> "Test invalid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID,
					Notebook -> Link[testNotebook]
				|>,
				<|
					Object -> testNotebook,
					DeveloperObject -> True,
					Name -> "Test lab notebook for UploadVerifiedCoverModel unit tests "<>$SessionUUID
				|>
			}];

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];
			Upload[<|
				Object -> testDoc,
				Name -> "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

			UploadCoverModel[
				Model[Item, Cap],
				Name -> "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				ProductRelation -> Null,
				Reusable -> False,
				Sterile -> False,
				PyrogenFree -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				WettedMaterials -> {{Glass}},
				DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Dimensions -> {4 Millimeter, 4 Millimeter, 2 Millimeter},
				CoverType -> Screw,
				CoverFootprint -> CapScrewTube35x13,
				Force -> True
			];

			UploadCoverModel[
				Model[Item, Lid],
				Name -> "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				ProductRelation -> Null,
				Reusable -> False,
				Sterile -> False,
				PyrogenFree -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				WettedMaterials -> {{Glass}},
				DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Dimensions -> {4 Millimeter, 4 Millimeter, 2 Millimeter},
				CoverType -> Place,
				CoverFootprint -> LidPlace8x126,
				CondensationRings -> False,
				RestingOrientation -> FaceUp,
				Force -> True
			];

			UploadCoverModel[
				Model[Item, PlateSeal],
				Name -> "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID,
				ImageFile -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				ProductRelation -> Null,
				Reusable -> False,
				Sterile -> False,
				PyrogenFree -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				WettedMaterials -> {{Glass}},
				DefaultStickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Dimensions -> {4 Millimeter, 4 Millimeter, 2 Millimeter},
				CoverType -> Seal,
				CoverFootprint -> SealSBS,
				SealType -> Adhesive,
				Pierceable -> False,
				MinTemperature -> -80 Celsius,
				MaxTemperature -> 200 Celsius,
				RestingOrientation -> FaceUp,
				Force -> True
			];

		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Object[User, Emerald, Developer, "Test developer for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Object[User, "Test external user for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test invalid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test corrected Lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test corrected Lid 2 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test valid cap 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test valid lid 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, PlateSeal, "Test valid plate seal 1 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "CapSnap7x6 Cap created on "<>DateString[Now, {"Month", "Day", "Year"}]],
				Model[Item, Cap, "Test valid cap 2 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 3 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test user defined lid 4 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, PlateSeal, "Test user defined plate seal 5 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Lid, "Test user defined lid 6 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 7 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 8 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 9 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 10 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 11 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 12 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 13 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 14 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 15 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 16 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 17 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 18 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 19 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Model[Item, Cap, "Test user defined cap 20 for UploadVerifiedCoverModel unit tests "<>$SessionUUID],
				Object[LaboratoryNotebook, "Test lab notebook for UploadVerifiedCoverModel unit tests "<>$SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Verbose -> False, Force -> True];

			On[Warning::NotYetVerified];
		]
	},
	TurnOffMessages :> {Warning::NotYetVerified}
];

(* ::Subsubsection::Closed:: *)
(*UploadCoverModelOptions*)

DefineTests[UploadCoverModelOptions,
	{
		Example[{Basic, "Function output resolved options for creating new cap model:"},
			UploadCoverModelOptions[
				Model[Item, Cap],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for UploadCoverModelOptions unit tests "<>$SessionUUID],
				Name -> "Test user defined cap 1 for UploadCoverModelOptions unit tests "<>$SessionUUID
			],
			_Grid
		]
	},
	Stubs :> {$AllowUserInvalidObjectUploads = True, $PersonID = Object[User, "Test external user for UploadCoverModelOptions unit tests "<>$SessionUUID]},
	SetUp :> {$CreatedObjects = {}},
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Object[User, "Test external user for UploadCoverModelOptions unit tests "<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for UploadCoverModelOptions unit tests "<>$SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Verbose -> False, Force -> True]
		];
		Module[{testDoc, testDocDirectory},

			Upload[{
				<|
					Type -> Object[User],
					DeveloperObject -> True,
					Name -> "Test external user for UploadCoverModelOptions unit tests "<>$SessionUUID
				|>
			}];

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];
			Upload[<|
				Object -> testDoc,
				Name -> "Test documentation file for UploadCoverModelOptions unit tests "<>$SessionUUID,
				DeveloperObject -> True
			|>];

		]
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidUploadCoverModelQ*)

DefineTests[ValidUploadCoverModelQ,
	{
		Example[{Basic, "Function checks if the supplied options are valid for creating a new Model[Item, Cap]:"},
			ValidUploadCoverModelQ[
				Model[Item, Cap],
				ProductDocumentation -> Object[EmeraldCloudFile, "Test documentation file for ValidUploadCoverModelQ unit tests"<>$SessionUUID],
				Name -> "Test user defined cap 1 for ValidUploadCoverModelQ unit tests"<>$SessionUUID
			],
			True
		]
	},
	Stubs :> {$AllowUserInvalidObjectUploads = True, $PersonID = Object[User, "Test external user for ValidUploadCoverModelQ unit tests"<>$SessionUUID]},
	SetUp :> {$CreatedObjects = {}},
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Module[{allObjects, existingObjects},
			allObjects = {
				Object[User, "Test external user for ValidUploadCoverModelQ unit tests"<>$SessionUUID],
				Object[EmeraldCloudFile, "Test documentation file for ValidUploadCoverModelQ unit tests"<>$SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Verbose -> False, Force -> True]
		];
		Module[{testDoc, testDocDirectory},

			Upload[{
				<|
					Type -> Object[User],
					DeveloperObject -> True,
					Name -> "Test external user for ValidUploadCoverModelQ unit tests"<>$SessionUUID
				|>
			}];

			testDocDirectory = FileNameJoin[{$TemporaryDirectory, $SessionUUID<>"test doc.pdf"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard9/8a76493ec38d774af97581d3904e3dae.pdf"],testDocDirectory];
			testDoc = UploadCloudFile[testDocDirectory];
			Upload[<|
				Object -> testDoc,
				Name -> "Test documentation file for ValidUploadCoverModelQ unit tests"<>$SessionUUID,
				DeveloperObject -> True
			|>];

		]
	}
];