(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadSampleModel*)

DefineTests[
	UploadSampleModel,
	{
		(* ==BASIC== *)
		Example[{Basic, "Upload a new fulfillment model of 50/50 Water Methanol:"},
			UploadSampleModel[
				"50/50 Water Methanol (Test for UploadSampleModel)",
				Composition -> {
					{50 VolumePercent, Model[Molecule, "Water"]},
					{50 VolumePercent, Model[Molecule, "Methanol"]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage, Flammable"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Upload a new fulfillment model of 50/50 Water Methanol:"},
			UploadSampleModel[
				"50/50 Water Methanol (Test for UploadSampleModel)",
				Composition -> {
					{50 VolumePercent, Model[Molecule, "Water"]},
					{50 VolumePercent, Model[Molecule, "Methanol"]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage, Flammable"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Upload a new fulfillment model of an analyte (oligomer) in water:"},
			myOligomerAnalyte = UploadOligomer["My Oligomer Analyte (Test for UploadSampleModel)", Molecule -> Strand[DNA["AATTGTTCGGACACT"]], PolymerType -> DNA];

			UploadSampleModel[
				"My Oligomer Analyte in Water (Test for UploadSampleModel)",
				Composition -> {
					{10 Micromolar, Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModel)"]},
					{100 VolumePercent, Model[Molecule, "Water"]}
				},
				Solvent -> Model[Sample, "Milli-Q water"],
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Sample]],
			Variables :> {myOligomerAnalyte},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "My Oligomer Analyte in Water (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "My Oligomer Analyte in Water (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModel)"]],
					EraseObject[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "My Oligomer Analyte in Water (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "My Oligomer Analyte in Water (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModel)"]],
					EraseObject[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Upload a new fulfillment model for 99% Pure HPLC Grade Methanol. The {1 VolumePercent, Null} entry in the Composition field indicates that 1 VolumePercent of the sample is an unknown impurity:"},
			UploadSampleModel[
				"99% HPLC Grade Methanol (Test for UploadSampleModel)",
				Composition -> {
					{99 VolumePercent, Model[Molecule, "Methanol"]},
					{1 VolumePercent, Null}
				},
				UsedAsSolvent -> True,
				Grade -> HPLC,
				Expires -> True,
				ShelfLife -> 12 Month,
				UnsealedShelfLife -> 5 Month,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage, Flammable"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "99% HPLC Grade Methanol (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "99% HPLC Grade Methanol (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "99% HPLC Grade Methanol (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "99% HPLC Grade Methanol (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Update an already existing sample fulfillment model:"},
			UploadSampleModel[
				Model[Sample, "Sodium Acetate"],
				Flammable -> False
			],
			ObjectP[Model[Sample]]
		],
		(* ==Additional== *)
		Example[{Additional, "When Updating the composition of a Model[Sample], the updates are propagated to any linked Object[Sample]'s:"},
			UploadSampleModel[
				Model[Sample,"Test Sample Model for UploadSampleModel unit tests" <> $SessionUUID],
				Composition -> {
					{Null, Link[Model[Molecule, "id:6V0npvmOnGKV"]]},
					{Null, Null},
					{100 VolumePercent, Model[Molecule, "Water"]}
				}
			];

			Download[
				{
					Object[Sample, "Test Sample 1 for UploadSampleModel tests " <> $SessionUUID],
					Object[Sample, "Test Sample 2 for UploadSampleModel tests " <> $SessionUUID]
				},
				Composition
			],
			{
				{
					{Null, ObjectP[Model[Molecule, "id:6V0npvmOnGKV"]], _?DateObjectQ},
					{Null, Null, _?DateObjectQ},
					{EqualP[100 VolumePercent], ObjectP[Model[Molecule, "Water"]], _?DateObjectQ}
				},
				{
					{Null, ObjectP[Model[Molecule, "id:6V0npvmOnGKV"]], _?DateObjectQ},
					{Null, Null, _?DateObjectQ},
					{EqualP[100 VolumePercent], ObjectP[Model[Molecule, "Water"]], _?DateObjectQ}
				}
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Additional, "Update an already existing stock solution model:"},
			UploadSampleModel[
				Model[Sample, StockSolution, "Acetonitrile for HPLC Flush"],
				BiosafetyLevel -> "BSL-1"
			],
			ObjectP[Model[Sample]]
		],
		Example[{Additional, "Upload a new Model containing Model[Cell] and automatically determine the CellType from Composition:"},
			newModel = UploadSampleModel["Test living mammalian cells for UploadSampleModel tests",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				Living -> True,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, CellType],
			Mammalian,
			Variables :> {newModel},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Additional, "Upload a new Model containing Model[Cell, Bacterial] and automatically set Sterile and AsepticHandling:"},
			newModel = UploadSampleModel["Test living bacterial cells for UploadSampleModel tests",
				Composition -> {
					{5 VolumePercent, Link[Model[Cell, Bacteria, "E.coli MG1655"]]},
					{95 VolumePercent, Model[Molecule, "Water"]}
				},
				Living -> True,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, {Living, Sterile, AsepticHandling}],
			{True, False, True},
			Variables :> {newModel},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test living bacterial cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living bacterial cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test living bacterial cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living bacterial cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			}
		],
		(* ==OPTIONS== *)
		Example[{Options, "OpticalComposition", "Upload a new (1R)-(-)-10-camphorsulfonic acid sample model with its OpticalComposition field populated."},
			newModel = UploadSampleModel["(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModel 1)",
				Composition -> {{100 VolumePercent, Model[Molecule, "Methanol"]}, {1 Millimolar, Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]}},
				OpticalComposition -> {{100 Percent, Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]}},
				UsedAsSolvent -> False,
				Grade -> ACS,
				Expires -> True,
				ShelfLife -> 24 Month,
				UnsealedShelfLife -> 12 Month,
				DefaultStorageCondition -> Model[StorageCondition, "id:Vrbp1jKDY4bm"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, OpticalComposition],
			{{EqualP[100 Percent], ObjectP[Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]]}},
			Variables :> {newModel},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModel 1)"]],
					EraseObject[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModel 1)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModel 1)"]],
					EraseObject[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModel 1)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Options, Living, "Upload a new Model containing Model[Cell] and specify if the cells are alive or dead."},
			newModel = UploadSampleModel["Test living mammalian cells for UploadSampleModel tests",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				Living -> True,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				CellType -> Mammalian
			];
			Download[newModel, Living],
			True,
			Variables :> {newModel},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Options, CellType, "Upload a new Model containing Model[Cell] and specify that it is a specific type of cell:"},
			newModel = UploadSampleModel["Test living mammalian cells for UploadSampleModel tests",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				Living -> True,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				CellType -> Plant
			];
			Download[newModel, CellType],
			Plant,
			Variables :> {newModel},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Options, AsepticHandling, "Upload a new Model and specify AsepticHandling:"},
			newModel = UploadSampleModel["Test aseptic handling model for UploadSampleModel tests",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "Water"]},
					{5 VolumePercent, Model[Molecule, Protein, "Lysozyme from chicken egg white"]}
				},
				AsepticHandling -> True,
				BiosafetyLevel -> "BSL-1",
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, AsepticHandling],
			True,
			Variables :> {newModel},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test aseptic handling model for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test aseptic handling model for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test aseptic handling model for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test aseptic handling model for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Options, Sterile, "Upload a new Model and specify Sterile:"},
			newModel = UploadSampleModel["Test sterile model for UploadSampleModel tests",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "Water"]},
					{5 VolumePercent, Model[Molecule, Protein, "Lysozyme from chicken egg white"]}
				},
				Sterile -> True,
				BiosafetyLevel -> "BSL-1",
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, Sterile],
			True,
			Variables :> {newModel},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test sterile model for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test sterile model for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test sterile model for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test sterile model for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Options, FixedAmounts, "Upload a new fulfillment model of an analyte that has fixed amounts:"},
			UploadSampleModel[
				"My Analyte with Fixed Amounts (Test for UploadSampleModel)",
				Composition -> {
					{10 Micromolar, Model[Molecule, "Sodium Chloride"]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				FixedAmounts -> {0.5 Milligram, 1 Milligram},
				TransferOutSolventVolumes -> {10 Milliliter, 20 Milliliter},
				SingleUse -> True,
				SampleHandling -> Fixed
			],
			ObjectP[Model[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "My Analyte with Fixed Amounts (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "My Analyte with Fixed Amounts (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "My Analyte with Fixed Amounts (Test for UploadSampleModel)"]],
					EraseObject[Model[Sample, "My Analyte with Fixed Amounts (Test for UploadSampleModel)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Options, AsepticTransportContainerType, "Upload a new Model whose samples are contained in an aseptic barrier with information about whether they will need to be unbagged before use in a protocol, maintenance, or qualification:"},
			newModel = UploadSampleModel["Test inexplicably aseptic glucose solution for UploadSampleModel tests"<>$SessionUUID,
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},(* water *)
					{5 VolumePercent, Model[Molecule, "id:dORYzZJ3l38e"]} (* glucose *)
				},
				AsepticTransportContainerType -> Individual,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, AsepticTransportContainerType],
			Individual,
			Variables :> {newModel},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test inexplicably aseptic glucose solution for UploadSampleModel tests"<>$SessionUUID]],
					EraseObject[Model[Sample, "Test inexplicably aseptic glucose solution for UploadSampleModel tests"<>$SessionUUID], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test inexplicably aseptic glucose solution for UploadSampleModel tests"<>$SessionUUID]],
					EraseObject[Model[Sample, "Test inexplicably aseptic glucose solution for UploadSampleModel tests"<>$SessionUUID], Force -> True, Verbose -> False]
				];
			}
		],
		(* ==Messages== *)
		Example[{Messages, "MissingLivingOption", "If uploading a composition that contains Model[Cell](s), and the Living option is not provided, an error will be thrown and $Failed will be returned."},
			UploadSampleModel["Test living mammalian cells for UploadSampleModel tests",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			Null,
			Messages :> {
				Error::InvalidOption,
				Error::MissingLivingOption
			},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"]],
					EraseObject[Model[Sample, "Test living mammalian cells for UploadSampleModel tests"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Messages, "SampleTypeOptionMismatch", "If uploading a Sachet, the composition has to include a Model[Material] of pouch:"},
			UploadSampleModel["Test sachet 1 for UploadSampleModel tests" <> $SessionUUID,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 MassPercent, Model[Molecule, "Test sachet filler model for UploadSampleModel tests "<> $SessionUUID]}
				},
				Sachet -> True,
				SolidUnitWeight -> 0.5 Gram,
				DefaultSachetPouch -> Model[Material, "Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID],
				Expires -> True,
				ShelfLife -> 1 Year,
				UnsealedShelfLife -> 2 Month,
				DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
				State -> Solid
			],
			Null,
			Messages :> {
				Error::InvalidOption,
				Error::SampleTypeOptionMismatch
			},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test sachet 1 for UploadSampleModel tests" <> $SessionUUID]],
					EraseObject[Model[Sample, "Test sachet 1 for UploadSampleModel tests" <> $SessionUUID], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test sachet 1 for UploadSampleModel tests" <> $SessionUUID]],
					EraseObject[Model[Sample, "Test sachet 1 for UploadSampleModel tests" <> $SessionUUID], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Messages, "SampleTypeOptionMismatch", "If uploading a Sachet, the SolidUnitWeight and DefaultSachetPouch has to be populated:"},
			UploadSampleModel["Test sachet 2 for UploadSampleModel tests" <> $SessionUUID,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 MassPercent, Model[Molecule, "Test sachet filler model for UploadSampleModel tests "<> $SessionUUID]},
					{Null, Model[Material, "Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID]}
				},
				Sachet -> True,
				SolidUnitWeight -> Null,
				DefaultSachetPouch -> Null,
				Expires -> True,
				ShelfLife -> 1 Year,
				UnsealedShelfLife -> 2 Month,
				DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
				State -> Solid
			],
			Null,
			Messages :> {
				Error::InvalidOption,
				Error::SampleTypeOptionMismatch
			},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test sachet 2 for UploadSampleModel tests" <> $SessionUUID]],
					EraseObject[Model[Sample, "Test sachet 2 for UploadSampleModel tests" <> $SessionUUID], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test sachet 2 for UploadSampleModel tests" <> $SessionUUID]],
					EraseObject[Model[Sample, "Test sachet 2 for UploadSampleModel tests" <> $SessionUUID], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Messages, "SampleTypeOptionMismatch", "If uploading a Sachet, State must be Solid:"},
			UploadSampleModel["Test sachet 3 for UploadSampleModel tests" <> $SessionUUID,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 MassPercent, Model[Molecule, "Test sachet filler model for UploadSampleModel tests "<> $SessionUUID]},
					{Null, Model[Material, "Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID]}
				},
				Sachet -> True,
				SolidUnitWeight -> 0.5 Gram,
				DefaultSachetPouch -> Model[Material, "Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID],
				Expires -> True,
				ShelfLife -> 1 Year,
				UnsealedShelfLife -> 2 Month,
				DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
				State -> Liquid
			],
			Null,
			Messages :> {
				Error::InvalidOption,
				Error::SampleTypeOptionMismatch
			},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test sachet 3 for UploadSampleModel tests" <> $SessionUUID]],
					EraseObject[Model[Sample, "Test sachet 3 for UploadSampleModel tests" <> $SessionUUID], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test sachet 3 for UploadSampleModel tests" <> $SessionUUID]],
					EraseObject[Model[Sample, "Test sachet 3 for UploadSampleModel tests" <> $SessionUUID], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Messages, "SampleTypeOptionMismatch", "If SolidUnitWeight is populated in the upload, the sample must have either Sachet or Tablet set to True:"},
			UploadSampleModel["Test sachet 4 for UploadSampleModel tests" <> $SessionUUID,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 MassPercent, Model[Molecule, "Test sachet filler model for UploadSampleModel tests "<> $SessionUUID]}
				},
				Sachet -> False, Tablet -> False,
				SolidUnitWeight -> 0.5 Gram,
				Expires -> True,
				ShelfLife -> 1 Year,
				UnsealedShelfLife -> 2 Month,
				DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
				State -> Solid
			],
			Null,
			Messages :> {
				Error::InvalidOption,
				Error::SampleTypeOptionMismatch
			},
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "Test sachet 4 for UploadSampleModel tests" <> $SessionUUID]],
					EraseObject[Model[Sample, "Test sachet 4 for UploadSampleModel tests" <> $SessionUUID], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "Test sachet 4 for UploadSampleModel tests" <> $SessionUUID]],
					EraseObject[Model[Sample, "Test sachet 4 for UploadSampleModel tests" <> $SessionUUID], Force -> True, Verbose -> False]
				];
			}
		]
	},
	Stubs:>{
		$AllowPublicObjects = True,
		$Notebook=Null
	},
	SymbolSetUp :> (
		Off[Warning::APIConnection];
		Module[{namedObjects,existingObjs},
			namedObjects = Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Test bench for UploadSampleModel tests " <> $SessionUUID],
					Model[Sample,"Test Sample Model for UploadSampleModel unit tests" <> $SessionUUID],
					Object[Container, Plate, "Test DWP for UploadSampleModel tests " <> $SessionUUID],
					Object[Sample,"Test Sample 1 for UploadSampleModel tests " <> $SessionUUID],
					Object[Sample,"Test Sample 2 for UploadSampleModel tests " <> $SessionUUID],
					Model[Molecule, "Test sachet filler model for UploadSampleModel tests "<> $SessionUUID],
					Model[Material, "Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID]
				}],
				ObjectP[]
			]];

			existingObjs=PickList[namedObjects,DatabaseMemberQ[namedObjects]];
			EraseObject[existingObjs,Force->True,Verbose->False];
		];
		Block[{$DeveloperUpload = True},
			Module[
				{testBench},

				(* Create a test bench *)
				testBench = Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Test bench for UploadSampleModel tests " <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				(* Create test sample model *)
				(* NOTE: we are doing this with a raw upload because these are the UploadSampleModel unit tests lol *)
				Upload[
					<|
						Name -> "Test Sample Model for UploadSampleModel unit tests" <> $SessionUUID,
						BiosafetyLevel -> "BSL-1",
						Replace[Composition] -> {{Null, Link[Model[Molecule, "id:6V0npvmOnGKV"]]}, {Null, Null}},
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						Density -> Quantity[1.13`, ("Grams")/("Milliliters")],
						DOTHazardClass -> "Class 8 Division 8 Corrosives Hazard",
						Expires -> True,
						Flammable -> False,
						Fuming -> True,
						Replace[IncompatibleMaterials] -> {None},
						MSDSFile -> Link[Object[EmeraldCloudFile, "id:xRO9n3OPN44O"]],
						MSDSRequired -> True,
						NFPA -> {Health -> 2, Flammability -> 0, Reactivity -> 0, Special -> {Null}},
						pH -> 8.1`,
						ShelfLife -> Quantity[547.5`, "Days"],
						State -> Liquid,
						Type -> Model[Sample],
						UnsealedShelfLife -> Quantity[365.`, "Days"],
						Ventilated -> True,
						Replace[Synonyms] -> {"Test Sample Model for UploadSampleModel unit tests" <> $SessionUUID}
					|>
				];
				UploadMolecule[
					"Test sachet filler model for UploadSampleModel tests "<> $SessionUUID,
					State -> Solid,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					Force -> True
				];
				UploadMaterial[
					"Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					BiosafetyLevel -> "BSL-1"
				];
				(* Create a test container *)
				ECL`InternalUpload`UploadSample[
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					{"Work Surface", testBench},
					Name -> "Test DWP for UploadSampleModel tests " <> $SessionUUID
				];

				(* Create test Object[Sample]'s of the test sample model *)
				ECL`InternalUpload`UploadSample[
					{
						Model[Sample,"Test Sample Model for UploadSampleModel unit tests" <> $SessionUUID],
						Model[Sample,"Test Sample Model for UploadSampleModel unit tests" <> $SessionUUID]
					},
					{
						{"A1", Object[Container, Plate, "Test DWP for UploadSampleModel tests " <> $SessionUUID]},
						{"A2", Object[Container, Plate, "Test DWP for UploadSampleModel tests " <> $SessionUUID]}
					},
					Name -> {
						"Test Sample 1 for UploadSampleModel tests " <> $SessionUUID,
						"Test Sample 2 for UploadSampleModel tests " <> $SessionUUID
					},
					InitialAmount -> {
						1 Milliliter,
						1 Milliliter
					}
				]

	        ];
	    ]
	),
	SymbolTearDown :> (
		On[Warning::APIConnection];
		Module[{namedObjects,allObjects,existingObjs},
			namedObjects = Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Test bench for UploadSampleModel tests " <> $SessionUUID],
					Model[Sample,"Test Sample Model for UploadSampleModel unit tests" <> $SessionUUID],
					Object[Container, Plate, "Test DWP for UploadSampleModel tests " <> $SessionUUID],
					Object[Sample,"Test Sample 1 for UploadSampleModel tests " <> $SessionUUID],
					Object[Sample,"Test Sample 2 for UploadSampleModel tests " <> $SessionUUID],
					Model[Molecule, "Test sachet filler model for UploadSampleModel tests "<> $SessionUUID],
					Model[Material, "Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID]
				}],
				ObjectP[]
			]];

			allObjects = Quiet[Cases[
				Flatten[{
					$CreatedObjects,
					namedObjects
				}],
				ObjectP[]
			]];

			existingObjs=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs,Force->True,Verbose->False];

			Unset[$CreatedObjects];
		];
	)
];

DefineTests[
	UploadSampleModelOptions,
	{
		Example[{Basic, "Upload a new fulfillment model of 50/50 Water Methanol:"},
			UploadSampleModelOptions[
				"50/50 Water Methanol (Test for UploadSampleModelOptions)",
				Composition -> {
					{50 VolumePercent, Model[Molecule, "Water"]},
					{50 VolumePercent, Model[Molecule, "Methanol"]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage, Flammable"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Upload a new fulfillment model of 50/50 Water Methanol:"},
			UploadSampleModelOptions[
				"50/50 Water Methanol (Test for UploadSampleModelOptions)",
				Composition -> {
					{50 VolumePercent, Model[Molecule, "Water"]},
					{50 VolumePercent, Model[Molecule, "Methanol"]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage, Flammable"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Upload a new fulfillment model of an analyte (oligomer) in water:"},
			myOligomerAnalyte=UploadOligomer["My Oligomer Analyte (Test for UploadSampleModelOptions)", Molecule -> Strand[DNA["AATTGTTCGGACACT"]], PolymerType -> DNA];

			UploadSampleModelOptions[
				"My Oligomer Analyte in Water (Test for UploadSampleModelOptions)",
				Composition -> {
					{10 Micromolar, Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModelOptions)"]},
					{100 VolumePercent, Model[Molecule, "Water"]}
				},
				Solvent -> Model[Sample, "Milli-Q water"],
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "My Oligomer Analyte in Water (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "My Oligomer Analyte in Water (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "My Oligomer Analyte in Water (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "My Oligomer Analyte in Water (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Upload a new fulfillment model for 99% Pure HPLC Grade Methanol. The {1 VolumePercent, Null} entry in the Composition field indicates that 1 VolumePercent of the sample is an unknown impurity:"},
			UploadSampleModelOptions[
				"99% HPLC Grade Methanol (Test for UploadSampleModelOptions)",
				Composition -> {
					{99 VolumePercent, Model[Molecule, "Methanol"]},
					{1 VolumePercent, Null}
				},
				UsedAsSolvent -> True,
				Grade -> HPLC,
				Expires -> True,
				ShelfLife -> 12 Month,
				UnsealedShelfLife -> 5 Month,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage, Flammable"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "99% HPLC Grade Methanol (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "99% HPLC Grade Methanol (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "99% HPLC Grade Methanol (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "99% HPLC Grade Methanol (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Additional, "Upload a new fulfillment model of an analyte that has fixed amounts:"},

			UploadSampleModelOptions[
				"My Analyte with Fixed Amounts (Test for UploadSampleModelOptions)",
				Composition -> {
					{10 Micromolar, Model[Molecule, "Sodium Chloride"]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				FixedAmounts -> {0.5 Milligram, 1 Milligram},
				TransferOutSolventVolumes -> {10 Milliliter, 20 Milliliter},
				SingleUse -> True,
				SampleHandling -> Fixed
			],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "My Analyte with Fixed Amounts (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "My Analyte with Fixed Amounts (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "My Analyte with Fixed Amounts (Test for UploadSampleModelOptions)"]],
					EraseObject[Model[Sample, "My Analyte with Fixed Amounts (Test for UploadSampleModelOptions)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Options, "OpticalComposition", "Upload a new (1R)-(-)-10-camphorsulfonic acid sample model with its OpticalComposition field populated."},
			UploadSampleModelOptions["(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModelOptions 1)",
				Composition -> {{100 VolumePercent, Model[Molecule, "Methanol"]}, {1 Millimolar, Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]}},
				OpticalComposition -> {{100 Percent, Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]}},
				UsedAsSolvent -> False,
				Grade -> ACS,
				Expires -> True,
				ShelfLife -> 24 Month,
				UnsealedShelfLife -> 12 Month,
				DefaultStorageCondition -> Model[StorageCondition, "id:Vrbp1jKDY4bm"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}],
			_Grid,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModelOptions 1)"]],
					EraseObject[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModelOptions 1)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModelOptions 1)"]],
					EraseObject[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModelOptions 1)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Update an already existing sample fulfillment model:"},
			UploadSampleModelOptions[
				Model[Sample, "Sodium Chloride"],
				Flammable -> False
			],
			_Grid
		]
	},
	Stubs:>{
		$Notebook=Null
	}
];

DefineTests[
	ValidUploadSampleModelQ,
	{
		Example[{Basic, "Upload a new fulfillment model of 50/50 Water Methanol:"},
			ValidUploadSampleModelQ[
				"50/50 Water Methanol (Test for ValidUploadSampleModelQ)",
				Composition -> {
					{50 VolumePercent, Model[Molecule, "Water"]},
					{50 VolumePercent, Model[Molecule, "Methanol"]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage, Flammable"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Upload a new fulfillment model of 50/50 Water Methanol:"},
			ValidUploadSampleModelQ[
				"50/50 Water Methanol (Test for ValidUploadSampleModelQ)",
				Composition -> {
					{50 VolumePercent, Model[Molecule, "Water"]},
					{50 VolumePercent, Model[Molecule, "Methanol"]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage, Flammable"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "50/50 Water Methanol (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "50/50 Water Methanol (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Upload a new fulfillment model of an analyte (oligomer) in water:"},
			myOligomerAnalyte=UploadOligomer["My Oligomer Analyte (Test for ValidUploadSampleModelQ)", Molecule -> Strand[DNA["AATTGTTCGGACACT"]], PolymerType -> DNA];

			ValidUploadSampleModelQ[
				"My Oligomer Analyte in Water (Test for ValidUploadSampleModelQ)",
				Composition -> {
					{10 Micromolar, Model[Molecule, Oligomer, "My Oligomer Analyte (Test for ValidUploadSampleModelQ)"]},
					{100 VolumePercent, Model[Molecule, "Water"]}
				},
				Solvent -> Model[Sample, "Milli-Q water"],
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "My Oligomer Analyte in Water (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "My Oligomer Analyte in Water (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "My Oligomer Analyte in Water (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "My Oligomer Analyte in Water (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Molecule, Oligomer, "My Oligomer Analyte (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Upload a new fulfillment model for 99% Pure HPLC Grade Methanol. The {1 VolumePercent, Null} entry in the Composition field indicates that 1 VolumePercent of the sample is an unknown impurity:"},
			ValidUploadSampleModelQ[
				"99% HPLC Grade Methanol (Test for ValidUploadSampleModelQ)",
				Composition -> {
					{99 VolumePercent, Model[Molecule, "Methanol"]},
					{1 VolumePercent, Null}
				},
				UsedAsSolvent -> True,
				Grade -> HPLC,
				Expires -> True,
				ShelfLife -> 12 Month,
				UnsealedShelfLife -> 5 Month,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage, Flammable"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "99% HPLC Grade Methanol (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "99% HPLC Grade Methanol (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "99% HPLC Grade Methanol (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "99% HPLC Grade Methanol (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Additional, "Upload a new fulfillment model of an analyte that has fixed amounts:"},

			ValidUploadSampleModelQ[
				"My Analyte with Fixed Amounts (Test for ValidUploadSampleModelQ)",
				Composition -> {
					{10 Micromolar, Model[Molecule, "Sodium Chloride"]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				FixedAmounts -> {0.5 Milligram, 1 Milligram},
				TransferOutSolventVolumes -> {10 Milliliter, 20 Milliliter},
				SingleUse -> True,
				SampleHandling -> Fixed
			],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "My Analyte with Fixed Amounts (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "My Analyte with Fixed Amounts (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "My Analyte with Fixed Amounts (Test for ValidUploadSampleModelQ)"]],
					EraseObject[Model[Sample, "My Analyte with Fixed Amounts (Test for ValidUploadSampleModelQ)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Options, "OpticalComposition", "Upload a new (1R)-(-)-10-camphorsulfonic acid sample model with its OpticalComposition field populated."},
			ValidUploadSampleModelQ["(1R)-(-)-10-camphorsulfonic in methanol (Test for ValidUploadSampleModelQ 1)",
				Composition -> {{100 VolumePercent, Model[Molecule, "Methanol"]}, {1 Millimolar, Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]}},
				OpticalComposition -> {{100 Percent, Model[Molecule, "(1R)-(-)-10-camphorsulfonic acid"]}},
				UsedAsSolvent -> False,
				Grade -> ACS,
				Expires -> True,
				ShelfLife -> 24 Month,
				UnsealedShelfLife -> 12 Month,
				DefaultStorageCondition -> Model[StorageCondition, "id:Vrbp1jKDY4bm"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}],
			BooleanP,
			SetUp :> {
				If[DatabaseMemberQ[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for ValidUploadSampleModelQ 1)"]],
					EraseObject[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for ValidUploadSampleModelQ 1)"], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for ValidUploadSampleModelQ 1)"]],
					EraseObject[Model[Sample, "(1R)-(-)-10-camphorsulfonic in methanol (Test for ValidUploadSampleModelQ 1)"], Force -> True, Verbose -> False]
				];
			}
		],
		Example[{Basic, "Update an already existing sample fulfillment model:"},
			ValidUploadSampleModelQ[
				Model[Sample, "Sodium Chloride"],
				Flammable -> False
			],
			BooleanP
		]
	},
	Stubs:>{
		$Notebook=Null
	}
];