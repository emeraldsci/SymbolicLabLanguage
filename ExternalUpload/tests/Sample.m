(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadSampleModel*)

DefineTests[
	UploadSampleModel,
	{
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
			myOligomerAnalyte=UploadOligomer["My Oligomer Analyte (Test for UploadSampleModel)", Molecule -> Strand[DNA["AATTGTTCGGACACT"]], PolymerType -> DNA];

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
		Example[{Additional, "Upload a new fulfillment model of an analyte that has fixed amounts:"},

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
		Example[{Options, "OpticalComposition", "Upload a new (1R)-(-)-10-camphorsulfonic acid sample model with its OpticalComposition field populated."},
			UploadSampleModel["(1R)-(-)-10-camphorsulfonic in methanol (Test for UploadSampleModel 1)",
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
			ObjectP[Model[Sample]],
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
		Example[{Basic, "Update an already existing sample fulfillment model:"},
			UploadSampleModel[
				Model[Sample, "Sodium Chloride"],
				Flammable -> False
			],
			ObjectP[Model[Sample]]
		],
		Example[{Options,"Living", "Upload a new Model containing Model[Cell] and specify if the cells are alive or dead."},
			newModel = UploadSampleModel["Test living mammalian cells for UploadSampleModel tests",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				Living->True,
				UsedAsSolvent->False,
				Expires->True,
				ShelfLife->1 Week,
				UnsealedShelfLife->1 Day,
				DefaultStorageCondition->Model[StorageCondition, "Ambient Storage"],
				State->Liquid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None}
			];
			Download[newModel,Living],
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
		Example[{Messages,"MissingLivingOption", "If uploading a composition that contains Model[Cell](s), and the Living option is not provided, an error will be thrown and $Failed will be returned."},
			UploadSampleModel["Test living mammalian cells for UploadSampleModel tests",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				UsedAsSolvent->False,
				Expires->True,
				ShelfLife->1 Week,
				UnsealedShelfLife->1 Day,
				DefaultStorageCondition->Model[StorageCondition, "Ambient Storage"],
				State->Liquid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None}
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
		]
	},
	Stubs:>{
		$AllowPublicObjects = True,
		$Notebook=Null
	}
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