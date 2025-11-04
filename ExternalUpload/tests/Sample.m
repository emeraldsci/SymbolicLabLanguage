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
		Example[{Basic, "Upload a new fulfillment model of 50/50 Water Methanol by specifying the composition:"},
			UploadSampleModel[
				{
					{50 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{50 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]}
				},
				Name -> "50/50 Water Methanol for UploadSampleModel unit tests 1 " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Sample]]
		],
		Example[{Basic, "Upload a new fulfillment model of 50/50 Water Methanol:"},
			UploadSampleModel[
				"50/50 Water Methanol for UploadSampleModel unit tests 2 " <> $SessionUUID,
				Composition -> {
					{50 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{50 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Sample]]
		],
		Example[{Basic, "Upload a new fulfillment model of methanol from a molecule identifier, such as its PubChem identifier:"},
			UploadSampleModel[
				887,
				Name -> "99% Methanol for UploadSampleModel unit tests " <> $SessionUUID,
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Sample]]
		],
		Example[{Basic, "Update an already existing sample fulfillment model:"},
			UploadSampleModel[
				Model[Sample, "id:L8kPEjNLDpvG" (* Sodium Acetate *)],
				Flammable -> False
			],
			ObjectP[Model[Sample]]
		],
		(* ==Additional== *)
		Example[{Additional, "Upload a new fulfillment model for 99% Pure HPLC Grade Methanol. The {1 VolumePercent, Null} entry in the Composition field indicates that 1 VolumePercent of the sample is an unknown impurity:"},
			UploadSampleModel[
				"99% HPLC Grade Methanol for UploadSampleModel unit tests " <> $SessionUUID,
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				UsedAsSolvent -> True,
				Grade -> HPLC,
				Expires -> True,
				ShelfLife -> 12 Month,
				UnsealedShelfLife -> 5 Month,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Sample]]
		],
		Example[{Additional, "Upload a new fulfillment model of an analyte (oligomer) in water:"},
			myOligomerAnalyte = UploadOligomer["My Oligomer Analyte for UploadSampleModel unit tests " <> $SessionUUID, Molecule -> Strand[DNA["AATTGTTCGGACACT"]], PolymerType -> DNA];

			UploadSampleModel[
				"My Oligomer Analyte in Water for UploadSampleModel unit tests " <> $SessionUUID,
				Composition -> {
					{10 Micromolar, Model[Molecule, Oligomer, "My Oligomer Analyte for UploadSampleModel unit tests " <> $SessionUUID]},
					{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]}
				},
				Solvent -> Model[Sample, "id:8qZ1VWNmdLBD" (* Milli-Q water *)],
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			ObjectP[Model[Sample]],
			Variables :> {myOligomerAnalyte}
		],
		Example[{Additional, "When Updating the composition of a Model[Sample], the updates are propagated to any linked Object[Sample]'s:"},
			UploadSampleModel[
				Model[Sample,"Test Sample Model for UploadSampleModel unit tests " <> $SessionUUID],
				Composition -> {
					{Null, Link[Model[Molecule, "id:6V0npvmOnGKV"]]},
					{Null, Null},
					{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]}
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
					{EqualP[100 VolumePercent], ObjectP[Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]], _?DateObjectQ}
				},
				{
					{Null, ObjectP[Model[Molecule, "id:6V0npvmOnGKV"]], _?DateObjectQ},
					{Null, Null, _?DateObjectQ},
					{EqualP[100 VolumePercent], ObjectP[Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]], _?DateObjectQ}
				}
			},
			Stubs :> {
				$DeveloperSearch = True,
				$RequiredSearchName = $SessionUUID
			}
		],
		Example[{Additional, "Update an already existing stock solution model:"},
			UploadSampleModel[
				Model[Sample, StockSolution, "id:3em6ZvLmlJBV" (* Acetonitrile for HPLC Flush *)],
				BiosafetyLevel -> "BSL-1"
			],
			ObjectP[Model[Sample]]
		],
		Example[{Additional, "Upload a new Model containing Model[Cell] and automatically determine the CellType from Composition:"},
			newModel = UploadSampleModel["Test living mammalian cells for UploadSampleModel tests " <> $SessionUUID,
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				Living -> True,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, CellType],
			Mammalian,
			Variables :> {newModel}
		],
		Example[{Additional, "Upload a new Model containing Model[Cell, Bacterial] and automatically set Sterile and AsepticHandling:"},
			newModel = UploadSampleModel["Test living bacterial cells for UploadSampleModel tests " <> $SessionUUID,
				Composition -> {
					{5 VolumePercent, Link[Model[Cell, Bacteria, "id:54n6evLm7m0L" (* E.coli MG1655 *)]]},
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]}
				},
				Living -> True,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, {Living, Sterile, AsepticHandling}],
			{True, False, True},
			Variables :> {newModel}
		],
		(* ==OPTIONS== *)
		Example[{Options, "OpticalComposition", "Upload a new (1R)-(-)-10-camphorsulfonic acid sample model with its OpticalComposition field populated."},
			newModel = UploadSampleModel["(1R)-(-)-10-camphorsulfonic in methanol for UploadSampleModel unit tests 1 " <> $SessionUUID,
				Composition -> {{100 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]}, {1 Millimolar, Model[Molecule, "id:dORYzZJNK955" (* (1R)-(-)-10-camphorsulfonic acid *)]}},
				OpticalComposition -> {{100 Percent, Model[Molecule, "id:dORYzZJNK955" (* (1R)-(-)-10-camphorsulfonic acid *)]}},
				UsedAsSolvent -> False,
				Grade -> ACS,
				Expires -> True,
				ShelfLife -> 24 Month,
				UnsealedShelfLife -> 12 Month,
				DefaultStorageCondition -> Model[StorageCondition, "id:Vrbp1jKDY4bm"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, OpticalComposition],
			{{EqualP[100 Percent], ObjectP[Model[Molecule, "id:dORYzZJNK955" (* (1R)-(-)-10-camphorsulfonic acid *)]]}},
			Variables :> {newModel}
		],
		Example[{Options, Living, "Upload a new Model containing Model[Cell] and specify if the cells are alive or dead."},
			newModel = UploadSampleModel["Test living mammalian cells for UploadSampleModel tests " <> $SessionUUID,
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				Living -> True,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				CellType -> Mammalian
			];
			Download[newModel, Living],
			True,
			Variables :> {newModel}
		],
		Example[{Options, CellType, "Upload a new Model containing Model[Cell] and specify that it is a specific type of cell:"},
			newModel = UploadSampleModel["Test living mammalian cells for UploadSampleModel tests " <> $SessionUUID,
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				Living -> True,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				CellType -> Plant
			];
			Download[newModel, CellType],
			Plant,
			Variables :> {newModel}
		],
		Example[{Options, AsepticHandling, "Upload a new Model and specify AsepticHandling:"},
			newModel = UploadSampleModel["Test aseptic handling model for UploadSampleModel tests " <> $SessionUUID,
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{5 VolumePercent, Model[Molecule, Protein, "id:Z1lqpMzR4E3W" (* Lysozyme from chicken egg white *)]}
				},
				AsepticHandling -> True,
				BiosafetyLevel -> "BSL-1",
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, AsepticHandling],
			True,
			Variables :> {newModel}
		],
		Example[{Options, Sterile, "Upload a new Model and specify Sterile:"},
			newModel = UploadSampleModel["Test sterile model for UploadSampleModel tests " <> $SessionUUID,
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{5 VolumePercent, Model[Molecule, Protein, "id:Z1lqpMzR4E3W" (* Lysozyme from chicken egg white *)]}
				},
				Sterile -> True,
				BiosafetyLevel -> "BSL-1",
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, Sterile],
			True,
			Variables :> {newModel}
		],
		Example[{Options, FixedAmounts, "Upload a new fulfillment model of an analyte that has fixed amounts:"},
			UploadSampleModel[
				"My Analyte with Fixed Amounts for UploadSampleModel unit tests " <> $SessionUUID,
				Composition -> {
					{10 Micromolar, Model[Molecule, "id:BYDOjvG676mq" (* Sodium Chloride *)]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				FixedAmounts -> {0.5 Milligram, 1 Milligram},
				TransferOutSolventVolumes -> {10 Milliliter, 20 Milliliter},
				SingleUse -> True,
				SampleHandling -> Fixed
			],
			ObjectP[Model[Sample]]
		],
		Example[{Options, AsepticTransportContainerType, "Upload a new Model whose samples are contained in an aseptic barrier with information about whether they will need to be unbagged before use in a protocol, maintenance, or qualification:"},
			newModel = UploadSampleModel["Test inexplicably aseptic glucose solution for UploadSampleModel tests "<>$SessionUUID,
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},(* water *)
					{5 VolumePercent, Model[Molecule, "id:dORYzZJ3l38e"]} (* glucose *)
				},
				AsepticTransportContainerType -> Individual,
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			];
			Download[newModel, AsepticTransportContainerType],
			Individual,
			Variables :> {newModel}
		],
		(* ==Messages== *)
		Example[{Messages, "MissingLivingOption", "If uploading a composition that contains Model[Cell](s), and the Living option is not provided, an error will be thrown and $Failed will be returned."},
			UploadSampleModel["Test living mammalian cells for UploadSampleModel tests " <> $SessionUUID,
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE"]}
				},
				UsedAsSolvent -> False,
				Expires -> True,
				ShelfLife -> 1 Week,
				UnsealedShelfLife -> 1 Day,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			$Failed,
			Messages :> {
				Error::InvalidOption,
				Error::MissingLivingOption
			}
		],
		Example[{Messages, "SampleTypeOptionMismatch", "If uploading a Sachet, the composition has to include a Model[Material] of pouch:"},
			UploadSampleModel["Test sachet 1 for UploadSampleModel tests " <> $SessionUUID,
				MSDSFile -> NotApplicable,
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
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW" (* Refrigerator *)],
				State -> Solid
			],
			$Failed,
			Messages :> {
				Error::InvalidOption,
				Error::SampleTypeOptionMismatch
			}
		],
		Example[{Messages, "SampleTypeOptionMismatch", "If uploading a Sachet, the SolidUnitWeight and DefaultSachetPouch has to be populated:"},
			UploadSampleModel["Test sachet 2 for UploadSampleModel tests " <> $SessionUUID,
				MSDSFile -> NotApplicable,
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
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW" (* Refrigerator *)],
				State -> Solid
			],
			$Failed,
			Messages :> {
				Error::InvalidOption,
				Error::SampleTypeOptionMismatch
			}
		],
		Example[{Messages, "SampleTypeOptionMismatch", "If uploading a Sachet, State must be Solid:"},
			UploadSampleModel["Test sachet 3 for UploadSampleModel tests " <> $SessionUUID,
				MSDSFile -> NotApplicable,
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
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW" (* Refrigerator *)],
				State -> Liquid
			],
			$Failed,
			Messages :> {
				Error::InvalidOption,
				Error::SampleTypeOptionMismatch
			}
		],
		Example[{Messages, "SampleTypeOptionMismatch", "If SolidUnitWeight is populated in the upload, the sample must have either Sachet or Tablet set to True:"},
			UploadSampleModel["Test sachet 4 for UploadSampleModel tests " <> $SessionUUID,
				MSDSFile -> NotApplicable,
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
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW" (* Refrigerator *)],
				State -> Solid
			],
			$Failed,
			Messages :> {
				Error::InvalidOption,
				Error::SampleTypeOptionMismatch
			}
		],
		Example[{Options, Name, "Specify the common or proprietary name of the sample, used to identify it in Constellation:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Name -> "Test name"
			];
			Download[sampleModel, Name],
			"Test name",
			Variables :> {sampleModel}
		],
		Example[{Options, Synonyms, "Specify a list of alternative names for this substance:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Synonyms -> {"Alternative name 1", "Alternative name 2"}
			];
			Download[sampleModel, Synonyms],
			{"Alternative name 1", "Alternative name 2", "Test sample model name for UploadSampleModel unit tests " <> $SessionUUID},
			Variables :> {sampleModel}
		],
		Example[{Options, Composition, "Specify the various components that constitute this sample model, along with their respective concentrations. Specifying 'Null' for amount indicates a component of unknown concentration, and specifying 'Null' for the component indicates an unknown or proprietary component:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Composition -> {
					{99 MassPercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{1 MassPercent, Model[Molecule, "id:BYDOjvG676mq" (* Sodium Chloride *)]}
				}
			];
			Download[sampleModel, Composition],
			{
				{EqualP[99 MassPercent], LinkP[Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]]},
				{EqualP[1 MassPercent], LinkP[Model[Molecule, "id:BYDOjvG676mq" (* Sodium Chloride *)]]}
			},
			Variables :> {sampleModel}
		],
		Example[{Options, Composition, "Indicate that a sample is composed of an unknown concentration of an unknown substance:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Composition -> {{Null, Null}}
			];
			Download[sampleModel, Composition],
			{{Null, Null}},
			Variables :> {sampleModel}
		],
		Example[{Options, Media, "Specify the base cell growth solution of this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:zGj91a70m0lv" (* Agar *)]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE" (* HeLa *)]}
				},
				Living -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Media -> Model[Sample, "id:lYq9jRqXoJWV" (* E.coli DH5 Alpha Agar Stab *)]
			];
			Download[sampleModel, Media],
			ObjectP[Model[Sample, "id:lYq9jRqXoJWV" (* E.coli DH5 Alpha Agar Stab *)]],
			Variables :> {sampleModel}
		],
		Example[{Options, UsedAsMedia, "Specify if samples of this model are typically used as a cell growth medium:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				UsedAsMedia -> True
			];
			Download[sampleModel, UsedAsMedia],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Living, "Specify if there is living material in samples of this model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Living -> True
			];
			Download[sampleModel, Living],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, CellType, "Specify the taxon of the organism or cell line from which the cell sample originates:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{95 VolumePercent, Model[Molecule, "id:zGj91a70m0lv" (* Agar *)]},
					{5 VolumePercent, Model[Cell, Mammalian, "id:Vrbp1jK4Z4JE" (* HeLa *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Living -> True,
				CellType -> Mammalian
			];
			Download[sampleModel, CellType],
			Mammalian,
			Variables :> {sampleModel}
		],
		Example[{Options, Solvent, "Specify the base component of this sample model that contains, dissolves and disperses the other components:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{1 MassPercent, Model[Molecule, "id:BYDOjvG676mq" (* Sodium Chloride *)]},
					{99 MassPercent, Model[Molecule, "id:xRO9n3BPmP3q" (* Acetone *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Solvent -> Model[Sample, "id:Vrbp1jG80zno" (* Acetone, Reagent Grade *)]
			];
			Download[sampleModel, Solvent],
			ObjectP[Model[Sample, "id:Vrbp1jG80zno" (* Acetone, Reagent Grade *)]],
			Variables :> {sampleModel}
		],
		Example[{Options, UsedAsSolvent, "Specify if samples of this model are typically used to dissolve other substances:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				UsedAsSolvent -> True
			];
			Download[sampleModel, UsedAsSolvent],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, ConcentratedBufferDiluent, "Specify the solvent required to dilute this sample model to form BaselineStock. The model is diluted by ConcentratedBufferDilutionFactor:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{17.6 Millimolar, Model[Molecule, "id:qdkmxzqaba91" (* Potassium Phosphate (Dibasic) *)]},
					{81 Millimolar, Model[Molecule, "id:XnlV5jKXeX3b" (* Dibasic Sodium Phosphate *)]},
					{27 Millimolar, Model[Molecule, "id:dORYzZJ3l3ap" (* Potassium Chloride *)]},
					{13.7 Millimolar, Model[Molecule, "id:BYDOjvG676mq" (* Sodium Chloride *)]}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ConcentratedBufferDiluent -> Model[Sample, "id:8qZ1VWNmdLBD" (* Milli-Q water *)],
				ConcentratedBufferDilutionFactor -> 10,
				BaselineStock -> Model[Sample, StockSolution, "id:J8AY5jwzPdaB" (* 1x PBS from 10X stock *)]
			];
			Download[sampleModel, ConcentratedBufferDiluent],
			ObjectP[Model[Sample, "id:8qZ1VWNmdLBD" (* Milli-Q water *)]],
			Variables :> {sampleModel}
		],
		Example[{Options, ConcentratedBufferDilutionFactor, "Specify the amount by which the sample must be diluted with its ConcentratedBufferDiluent in order to form standard ratio of Models for 1X buffer, the BaselineStock:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{17.6 Millimolar, Model[Molecule, "id:qdkmxzqaba91" (* Potassium Phosphate (Dibasic) *)]},
					{81 Millimolar, Model[Molecule, "id:XnlV5jKXeX3b" (* Dibasic Sodium Phosphate *)]},
					{27 Millimolar, Model[Molecule, "id:dORYzZJ3l3ap" (* Potassium Chloride *)]},
					{13.7 Millimolar, Model[Molecule, "id:BYDOjvG676mq" (* Sodium Chloride *)]}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ConcentratedBufferDiluent -> Model[Sample, "id:8qZ1VWNmdLBD" (* Milli-Q water *)],
				ConcentratedBufferDilutionFactor -> 10,
				BaselineStock -> Model[Sample, StockSolution, "id:J8AY5jwzPdaB" (* 1x PBS from 10X stock *)]
			];
			Download[sampleModel, ConcentratedBufferDilutionFactor],
			EqualP[10],
			Variables :> {sampleModel}
		],
		Example[{Options, BaselineStock, "Specify the 1X version of buffer that this sample model forms when diluted with ConcentratedBufferDiluent by a factor of ConcentrationBufferDilutionFactor:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{17.6 Millimolar, Model[Molecule, "id:qdkmxzqaba91" (* Potassium Phosphate (Dibasic) *)]},
					{81 Millimolar, Model[Molecule, "id:XnlV5jKXeX3b" (* Dibasic Sodium Phosphate *)]},
					{27 Millimolar, Model[Molecule, "id:dORYzZJ3l3ap" (* Potassium Chloride *)]},
					{13.7 Millimolar, Model[Molecule, "id:BYDOjvG676mq" (* Sodium Chloride *)]}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ConcentratedBufferDiluent -> Model[Sample, "id:8qZ1VWNmdLBD" (* Milli-Q water *)],
				ConcentratedBufferDilutionFactor -> 10,
				BaselineStock -> Model[Sample, StockSolution, "id:J8AY5jwzPdaB" (* 1x PBS from 10X stock *)]
			];
			Download[sampleModel, BaselineStock],
			ObjectP[Model[Sample, StockSolution, "id:J8AY5jwzPdaB" (* 1x PBS from 10X stock *)]],
			Variables :> {sampleModel}
		],
		Example[{Options, AlternativeForms, "Specify other sample models representing variations of the same substance with different grades, hydration states, monobasic/dibasic forms, etc:"},
			sampleModel = UploadSampleModel[
				"Special grade acetone for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				AlternativeForms -> {Model[Sample, "id:Vrbp1jG80zno" (* Acetone, Reagent Grade *)]}
			];
			Download[sampleModel, AlternativeForms],
			{ObjectP[Model[Sample, "id:Vrbp1jG80zno" (* Acetone, Reagent Grade *)]]},
			Variables :> {sampleModel}
		],
		Example[{Options, Grade, "Specify the purity standard of this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Grade -> Anhydrous
			];
			Download[sampleModel, Grade],
			Anhydrous,
			Variables :> {sampleModel}
		],
		Example[{Options, ProductDocumentationFiles, "Specify PDFs of any product documentation provided by the supplier of this model using an existing emerald cloud file:"},
			sampleModel = UploadSampleModel[
				"Test sodium azide for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 MassPercent, Model[Molecule, "id:Y0lXejMq5qAa" (* "Sodium Azide" *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ProductDocumentationFiles -> {
					Object[EmeraldCloudFile, "id:Y0lXejM4r76a"]
				}
			];
			Download[sampleModel, ProductDocumentationFiles],
			{LinkP[Object[EmeraldCloudFile, "id:Y0lXejM4r76a"]]},
			Variables :> {sampleModel}
		],
		Test["Specify PDFs of any product documentation provided by the supplier of this model using an existing emerald cloud file:",
			sampleModel = UploadSampleModel[
				"Test sodium azide for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 MassPercent, Model[Molecule, "id:Y0lXejMq5qAa" (* "Sodium Azide" *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ProductDocumentationFiles -> {
					localFile
				}
			];
			Download[sampleModel, ProductDocumentationFiles],
			{ObjectP[Object[EmeraldCloudFile]]},
			SetUp :> {
				localFile = DownloadCloudFile[Object[EmeraldCloudFile, "id:Y0lXejM4r76a"], FileNameJoin[{$TemporaryDirectory, "documentation.pdf"}]]
			},
			Variables :> {sampleModel, localFile}
		],
		Example[{Options, Density, "Specify the density for samples of this model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Density -> 1.5 Gram / Milliliter
			];
			Download[sampleModel, Density],
			EqualP[1.5 Gram / Milliliter],
			Variables :> {sampleModel}
		],
		Example[{Options, ExtinctionCoefficients, "Specify how strongly samples of this model absorb light at a particular wavelength:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ExtinctionCoefficients -> {
					{290 Nanometer, 50000 Liter / (Centimeter Mole)}
				}
			];
			Download[sampleModel, ExtinctionCoefficients],
			{
				<|Wavelength -> EqualP[290 Nanometer], ExtinctionCoefficient -> EqualP[50000 Liter / (Centimeter Mole)]|>
			},
			Variables :> {sampleModel}
		],
		Example[{Options, MeltingPoint, "Specify the melting temperature for samples of this model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				MeltingPoint -> 99 Celsius
			];
			Download[sampleModel, MeltingPoint],
			EqualP[99 Celsius],
			Variables :> {sampleModel}
		],
		Example[{Options, BoilingPoint, "Specify the boiling temperature for samples of this model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				BoilingPoint -> 199 Celsius
			];
			Download[sampleModel, BoilingPoint],
			EqualP[199 Celsius],
			Variables :> {sampleModel}
		],
		Example[{Options, VaporPressure, "Specify the vapor pressure of samples of this model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				VaporPressure -> 6 Kilopascal
			];
			Download[sampleModel, VaporPressure],
			EqualP[6 Kilopascal],
			Variables :> {sampleModel}
		],
		Example[{Options, Viscosity, "Specify the dynamic viscosity of samples of this model at room temperature and pressure:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Viscosity -> 0.5 Centipoise
			];
			Download[sampleModel, Viscosity],
			EqualP[0.5 Centipoise],
			Variables :> {sampleModel}
		],
		Example[{Options, pKa, "Specify the logarithmic acid dissociation constants of the substance at room temperature in water:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				pKa -> {{1, 2, 3}}
			];
			Download[sampleModel, pKa],
			{EqualP[1], EqualP[2], EqualP[3]},
			Variables :> {sampleModel}
		],
		Example[{Options, FixedAmounts, "If this sample model is purchased and stored in pre-measured amounts, the amounts that samples of this model exist in:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				FixedAmounts -> {0.5 Gram, 1 Gram}
			];
			Download[sampleModel, FixedAmounts],
			{EqualP[0.5 Gram], EqualP[1 Gram]},
			Variables :> {sampleModel}
		],
		Example[{Options, TransferOutSolventVolumes, "If this sample model is purchased and stored in pre-measured amounts, specify the amounts of dissolution solvents required to solvate each of the fixed amounts that this model is handled in:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				FixedAmounts -> {0.5 Milligram, 1 Milligram},
				TransferOutSolventVolumes -> {50 Microliter, 100 Microliter}
			];
			Download[sampleModel, TransferOutSolventVolumes],
			{EqualP[50 Microliter], EqualP[100 Microliter]},
			Variables :> {sampleModel}
		],
		Example[{Options, SingleUse, "Specify if samples of this model must be used only once and then disposed of after use:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				SingleUse -> True
			];
			Download[sampleModel, SingleUse],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Tablet, "Specify if this sample model is composed of small disks of compressed solid substance:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Tablet -> True
			];
			Download[sampleModel, Tablet],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Sachet, "Specify if this sample model is in the form of a small pouch filled with a measured amount of loose solid substance:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{Null, Model[Material, "id:lYq9jROMExMr" (* "Pouch Material" *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				DefaultSachetPouch -> Model[Material, "id:lYq9jROMExMr" (* "Pouch Material" *)],
				SolidUnitWeight -> 500 Milligram,
				Sachet -> True
			];
			Download[sampleModel, Sachet],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, SolidUnitWeight, "If samples of this model come in tablet or sachet form, the average mass of sample in a single tablet or sachet:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{Null, Model[Material, "id:lYq9jROMExMr" (* "Pouch Material" *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Sachet -> True,
				DefaultSachetPouch -> Model[Material, "id:lYq9jROMExMr" (* "Pouch Material" *)],
				SolidUnitWeight -> 500 Milligram
			];
			Download[sampleModel, SolidUnitWeight],
			EqualP[500 Milligram],
			Variables :> {sampleModel}
		],
		Example[{Options, DefaultSachetPouch, "If samples of this model come in sachet form, the material that the enclosing pouch is made from:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{Null, Model[Material, "id:lYq9jROMExMr" (* "Pouch Material" *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Sachet -> True,
				SolidUnitWeight -> 500 Milligram,
				DefaultSachetPouch -> Model[Material, "id:lYq9jROMExMr" (* "Pouch Material" *)]
			];
			Download[sampleModel, DefaultSachetPouch],
			ObjectP[Model[Material, "id:lYq9jROMExMr"]],
			Variables :> {sampleModel}
		],
		Example[{Options, Fiber, "Specify if samples of this model consist of a thin cylindrical string of solid substance:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Fiber -> True
			];
			Download[sampleModel, Fiber],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, FiberCircumference, "If samples of this model come in fiber form, the length of the perimeter of the circular cross-section of the sample:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Fiber -> True,
				FiberCircumference -> 100 Micrometer
			];
			Download[sampleModel, FiberCircumference],
			EqualP[100 Micrometer],
			Variables :> {sampleModel}
		],
		Example[{Options, Products, "Specify products that supply this model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Products -> {Object[Product, "Test Product 1 for UploadSampleModel unit tests " <> $SessionUUID]}
			];
			Download[sampleModel, Products],
			{LinkP[Object[Product, "Test Product 1 for UploadSampleModel unit tests " <> $SessionUUID]]},
			Variables :> {sampleModel}
		],
		Example[{Options, ServiceProviders, "Specify companies that can be contracted to synthesize samples of this model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ServiceProviders -> Object[Company, Service, "Test Service Provider 1 for UploadSampleModel unit tests " <> $SessionUUID]
			];
			Download[sampleModel, ServiceProviders],
			{LinkP[Object[Company, Service, "Test Service Provider 1 for UploadSampleModel unit tests " <> $SessionUUID]]},
			Variables :> {sampleModel}
		],
		Example[{Options, ThawTemperature, "Specify the typical temperature that samples of this model should be defrosted at before using in experimentation:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ThawTemperature -> 4 Celsius
			];
			Download[sampleModel, ThawTemperature],
			EqualP[4 Celsius],
			Variables :> {sampleModel}
		],
		Example[{Options, ThawTime, "Specify the typical time that samples of this model should be defrosted before using in experimentation:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ThawTime -> 8 Hour
			];
			Download[sampleModel, ThawTime],
			EqualP[8 Hour],
			Variables :> {sampleModel}
		],
		Example[{Options, MaxThawTime, "Specify the default maximum time that samples of this model should be defrosted before using in experimentation:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				MaxThawTime -> 8 Hour
			];
			Download[sampleModel, MaxThawTime],
			EqualP[8 Hour],
			Variables :> {sampleModel}
		],
		Example[{Options, PipettingMethod, "Specify the default parameters describing how pure samples of this molecule should be manipulated by pipette:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				PipettingMethod -> Model[Method, Pipetting, "id:qdkmxzqkJlw1" (* "Aqueous" *)]
			];
			Download[sampleModel, PipettingMethod],
			LinkP[Model[Method, Pipetting, "id:qdkmxzqkJlw1" (* "Aqueous" *)]],
			Variables :> {sampleModel}
		],
		Example[{Options, ThawCellsMethod, "Specify the default method object containing the parameters to use to bring cryovials containing this sample model up to ambient temperature:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ThawCellsMethod -> Object[Method, ThawCells, "Test Thaw Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID]
			];
			Download[sampleModel, ThawCellsMethod],
			LinkP[Object[Method, ThawCells, "Test Thaw Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID]],
			Variables :> {sampleModel}
		],
		Example[{Options, AsepticTransportContainerType, "Specify the manner in which samples of this model are contained in an aseptic barrier and if they need to be unbagged before being used in an experiment:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				AsepticTransportContainerType -> Individual
			];
			Download[sampleModel, AsepticTransportContainerType],
			Individual,
			Variables :> {sampleModel}
		],
		Example[{Options, Notebook, "Specify the notebook this sample model will belong to. If set to Null, the sample model will be public and visible to all users:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Notebook -> Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"]
			];
			Download[sampleModel, Notebook],
			LinkP[Object[LaboratoryNotebook, "Test notebook for notebook-less test protocols"]],
			Variables :> {sampleModel}
		],
		Example[{Options, PreferredMALDIMatrix, "Specify the substance best suited to co-crystallize with samples of this model in preparation for mass spectrometry using the matrix-assisted laser desorption/ionization (MALDI) technique:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				PreferredMALDIMatrix -> Model[Sample, Matrix, "id:Z1lqpMGjeeW4" (* "DHAP MALDI matrix" *)]
			];
			Download[sampleModel, PreferredMALDIMatrix],
			{LinkP[Model[Sample, Matrix, "id:Z1lqpMGjeeW4" (* "DHAP MALDI matrix" *)]]},
			Variables :> {sampleModel}
		],
		Example[{Options, AluminumFoil, "Specify if containers that contain this sample model should be wrapped in aluminum foil to protect the container contents from light by default:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				AluminumFoil -> True
			];
			Download[sampleModel, AluminumFoil],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Analytes, "Specify the molecular entities of primary interest in this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{1 Milligram / Liter, Model[Molecule, "id:E8zoYvN6m61A" (* Caffeine *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Analytes -> {Model[Molecule, "id:E8zoYvN6m61A" (* Caffeine *)]}
			];
			Download[sampleModel, Analytes],
			{LinkP[Model[Molecule, "id:E8zoYvN6m61A" (* Caffeine *)]]},
			Variables :> {sampleModel}
		],
		Example[{Options, Aqueous, "Specify if samples of this model are a solution in water:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{1 Milligram / Liter, Model[Molecule, "id:E8zoYvN6m61A" (* Caffeine *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Aqueous -> True
			];
			Download[sampleModel, Aqueous],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, AutoclaveUnsafe, "Specify if samples of this model are unstable and can potentially degrade under extreme heating conditions:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				AutoclaveUnsafe -> True
			];
			Download[sampleModel, AutoclaveUnsafe],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, BarcodeTag, "Specify the secondary tag used to affix a barcode to this object:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				BarcodeTag -> Model[Item, Consumable, "id:Y0lXejMmXOo1" (* "Cabel Label Sticker Tag for stickering small objects" *)]
			];
			Download[sampleModel, BarcodeTag],
			LinkP[Model[Item, Consumable, "id:Y0lXejMmXOo1" (* "Cabel Label Sticker Tag for stickering small objects" *)]],
			Variables :> {sampleModel}
		],
		Example[{Options, ChangeMediaMethod, "Specify the default method object containing the parameters to use to change the base cell growth solution for cultures of this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ChangeMediaMethod -> Object[Method, ChangeMedia, "Test Change Media Method 1 for UploadSampleModel unit tests " <> $SessionUUID]
			];
			Download[sampleModel, ChangeMediaMethod],
			LinkP[Object[Method, ChangeMedia, "Test Change Media Method 1 for UploadSampleModel unit tests " <> $SessionUUID]],
			Variables :> {sampleModel}
		],
		Example[{Options, Conductivity, "Specify the electrical conductivity of samples of this model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Conductivity -> EmpiricalDistribution[{8500 Millisiemen / Centimeter}]
			];
			Download[sampleModel, Conductivity],
			EqualP[8500 Millisiemen / Centimeter],
			Variables :> {sampleModel}
		],
		Test["Specify if samples of this model are required to be continuously available for use in the lab, regardless of if it is InUse by a specific protocol:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ContinuousOperation -> True
			];
			Download[sampleModel, ContinuousOperation],
			True,
			Variables :> {sampleModel}
		],
		Test["Indicates that this model is historical and no longer used in the ECL:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Deprecated -> True
			];
			Download[sampleModel, Deprecated],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, GloveBoxBlowerIncompatible, "Indicates that the glove box blower must be turned off to prevent damage to the catalyst in the glove box that is used to remove traces of water and oxygen when manipulating samples of this model inside of the glove box:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				GloveBoxBlowerIncompatible -> True
			];
			Download[sampleModel, GloveBoxBlowerIncompatible],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, GloveBoxIncompatible, "Specify if samples of this model cannot be used inside of a glove box due high volatility and/or detrimental reactivity with the catalyst in the glove box that is used to remove traces of water and oxygen. Sulfur and sulfur compounds (such as H2S, RSH, COS, SO2, SO3), halides, halogen (Freon), alcohols, hydrazine, phosphene, arsine, arsenate, mercury, and saturation with water may deactivate the catalyst:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				GloveBoxIncompatible -> True
			];
			Download[sampleModel, GloveBoxIncompatible],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, InertHandling, "Specify if samples of this model must be handled in a glove box under an unreactive atmosphere:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				InertHandling -> True
			];
			Download[sampleModel, InertHandling],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, KitProducts, "Specify products, if this model is part of one or more kits:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				KitProducts -> {Object[Product, "Test Kit Product 1 for UploadSampleModel unit tests " <> $SessionUUID]}
			];
			Download[sampleModel, KitProducts],
			{LinkP[Object[Product, "Test Kit Product 1 for UploadSampleModel unit tests " <> $SessionUUID]]},
			Variables :> {sampleModel}
		],
		Example[{Options, LabWasteDisposal, "Specify if samples of this model may be safely disposed into a regular lab waste container:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				LabWasteDisposal -> True
			];
			Download[sampleModel, LabWasteDisposal],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, NominalParticleSize, "Specify the manufacturer stated distribution of particle dimensions in the sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				NominalParticleSize -> EmpiricalDistribution[{1 Micrometer}]
			];
			Download[sampleModel, NominalParticleSize],
			EqualP[1 Micrometer],
			Variables :> {sampleModel}
		],
		Example[{Options, NucleicAcidFree, "Specify if samples of this model are verified to be free from nucleic acids - large biomolecules composed of nucleotides that may encode genetic information, such as DNA and RNA:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				NucleicAcidFree -> True
			];
			Download[sampleModel, NucleicAcidFree],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Parafilm, "Specify if containers that contain this sample model should have their covers sealed with parafilm by default:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Parafilm -> True
			];
			Download[sampleModel, Parafilm],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, ParticleWeight, "If this sample model is a powder, the average weight of a single particle of the sample:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ParticleWeight -> 1 Microgram
			];
			Download[sampleModel, ParticleWeight],
			EqualP[1 Microgram],
			Variables :> {sampleModel}
		],
		Example[{Options, pH, "Specify the logarithmic concentration of hydrogen ions of samples of this model at room temperature:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				pH -> 12
			];
			Download[sampleModel, pH],
			EqualP[12],
			Variables :> {sampleModel}
		],
		Test["Specify the recommended bin for samples of this model prior to dishwashing:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				PreferredWashBin -> Model[Container, WashBin, "id:mnk9jORX16EO" (* "DishwashBin for Sink" *)]
			];
			Download[sampleModel, PreferredWashBin],
			LinkP[Model[Container, WashBin, "id:mnk9jORX16EO" (* "DishwashBin for Sink" *)]],
			Variables :> {sampleModel}
		],
		Test["Specify if samples of this model may be prepared as needed during the course of an experiment:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Preparable -> True
			];
			Download[sampleModel, Preparable],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, PyrogenFree, "Specify if samples of this model are verified to be free from compounds that induce fever when introduced into the bloodstream, such as Endotoxins:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				PyrogenFree -> True
			];
			Download[sampleModel, PyrogenFree],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, RefractiveIndex, "Specify the ratio of the speed of light in a vacuum to the speed of light travelling through samples of this model at 20 degree Celsius:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				RefractiveIndex -> 1.5
			];
			Download[sampleModel, RefractiveIndex],
			EqualP[1.5],
			Variables :> {sampleModel}
		],
		Example[{Options, Resuspension, "Specify if one of the components in this sample model can only be prepared by adding a solution to its original container to dissolve it. The dissolved sample can be optionally removed from the original container for other preparation steps:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Resuspension -> True
			];
			Download[sampleModel, Resuspension],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, ReversePipetting, "Specify if additional source sample should be aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into a destination position. It is recommended to set ReversePipetting->True if this sample model foams or forms bubbles easily:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ReversePipetting -> True
			];
			Download[sampleModel, ReversePipetting],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, RNaseFree, "Specify if samples of this model are verified to be free from enzymes that break down ribonucleic acid (RNA):"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				RNaseFree -> True
			];
			Download[sampleModel, RNaseFree],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, SolidUnitWeightDistribution, "If samples of this model come in tablet or sachet form, the range of masses of sample in a single tablet or sachet:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {
					{Null, Model[Material, "id:lYq9jROMExMr" (* "Pouch Material" *)]}
				},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Sachet -> True,
				DefaultSachetPouch -> Model[Material, "id:lYq9jROMExMr" (* "Pouch Material" *)],
				SolidUnitWeight -> 1 Microgram,
				SolidUnitWeightDistribution -> EmpiricalDistribution[{1 Microgram}]
			];
			Download[sampleModel, SolidUnitWeightDistribution],
			EqualP[1 Microgram],
			Variables :> {sampleModel}
		],
		Test["Specify if a barcode should be attached to this item during Receive Inventory, or if the unpeeled sticker should be stored with the item and affixed during resource picking:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				StickeredUponArrival -> True
			];
			Download[sampleModel, StickeredUponArrival],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, StoragePositions, "Specify the specific containers and positions in which samples of this model should typically be stored, allowing more granular organization within storage locations that satisfy default storage condition:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				StoragePositions -> {{Object[Container, Safe, "id:WNa4ZjKRKnZV" (* "Safey" *)], Null}}
			];
			Download[sampleModel, StoragePositions],
			{{LinkP[Object[Container, Safe, "id:WNa4ZjKRKnZV" (* "Safey" *)]], Null}},
			Variables :> {sampleModel}
		],
		Example[{Options, SurfaceTension, "Specify the surface tension for samples of this model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				SurfaceTension -> 22.5 Millinewton / Meter
			];
			Download[sampleModel, SurfaceTension],
			EqualP[22.5 Millinewton / Meter],
			Variables :> {sampleModel}
		],
		Example[{Options, Tags, "Specify labels that are used for the management and organization of samples. If an aliquot is taken out of this sample, the new sample that is generated will inherit this sample's tags:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Tags -> {"Tag 1", "Tag 2"}
			];
			Download[sampleModel, Tags],
			{"Tag 1", "Tag 2"},
			Variables :> {sampleModel}
		],
		Example[{Options, ThawMixRate, "Specify the default frequency of rotation the default instrument uses to homogenize samples of this model following thawing:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ThawMixRate -> 100 RPM
			];
			Download[sampleModel, ThawMixRate],
			EqualP[100 RPM],
			Variables :> {sampleModel}
		],
		Example[{Options, ThawMixTime, "Specify the default duration for which samples of this model are homogenized following thawing:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ThawMixTime -> 8 Hour
			];
			Download[sampleModel, ThawMixTime],
			EqualP[8 Hour],
			Variables :> {sampleModel}
		],
		Example[{Options, ThawMixType, "Specify the default style of motion used to homogenize samples of this model following defrosting:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ThawMixType -> Swirl
			];
			Download[sampleModel, ThawMixType],
			Swirl,
			Variables :> {sampleModel}
		],
		Example[{Options, ThawNumberOfMixes, "Specify the default number of times samples of this model are homogenized by inversion or pipetting up and down following thawing:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ThawNumberOfMixes -> 10
			];
			Download[sampleModel, ThawNumberOfMixes],
			EqualP[10],
			Variables :> {sampleModel}
		],
		Example[{Options, TransferTemperature, "Specify the temperature at which samples of this model should be heated or cooled to when moved around the lab during experimentation, if different from ambient temperature:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				TransferTemperature -> 4 Celsius
			];
			Download[sampleModel, TransferTemperature],
			EqualP[4 Celsius],
			Variables :> {sampleModel}
		],
		Example[{Options, TransportCondition, "Specify the environment in which samples of this model should be transported when in use by an experiment, if different from ambient conditions:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				TransportCondition -> Model[TransportCondition, "id:BYDOjvGYAvlm" (* Chilled *)]
			];
			Download[sampleModel, TransportCondition],
			LinkP[Model[TransportCondition, "id:BYDOjvGYAvlm" (* Chilled *)]],
			Variables :> {sampleModel}
		],
		Example[{Options, UNII, "Specify the Unique Ingredient Identifier of this substance based on the unified identification scheme of FDA:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				UNII -> "3G6A5W338E"
			];
			Download[sampleModel, UNII],
			"3G6A5W338E",
			Variables :> {sampleModel}
		],
		Test["Specify if the information in this model has been reviewed for accuracy by an ECL employee:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Verified -> True
			];
			Download[sampleModel, Verified],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, WashCellsMethod, "Specify the default method object containing the parameters to use to purify cultures of this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				WashCellsMethod -> Object[Method, WashCells, "Test Wash Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID]
			];
			Download[sampleModel, WashCellsMethod],
			LinkP[Object[Method, WashCells, "Test Wash Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID]],
			Variables :> {sampleModel}
		],
		Test["Specify if samples of this model are a collection of other samples that are to be thrown out:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Waste -> True
			];
			Download[sampleModel, Waste],
			True,
			Variables :> {sampleModel}
		],
		Test[Options, WasteType, "Indicates the type of waste collected in this sample model:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Waste -> True,
				WasteType -> Chemical
			];
			Download[sampleModel, WasteType],
			Chemical,
			Variables :> {sampleModel}
		],
		Example[{Options, WettedMaterials, "Specify the types of matter of which this sample model is made that may come in direct contact with fluids:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				WettedMaterials -> {PVC}
			];
			Download[sampleModel, WettedMaterials],
			{PVC},
			Variables :> {sampleModel}
		],
		Example[{Options, State, "Specify the physical state of samples of this model when well solvated at room temperature and pressure:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				State -> Gas
			];
			Download[sampleModel, State],
			Gas,
			Variables :> {sampleModel}
		],
		Example[{Options, SampleHandling, "Specify the method by which samples of this model should be manipulated in the lab when transfers out of the sample are requested:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				SampleHandling -> Slurry
			];
			Download[sampleModel, SampleHandling],
			Slurry,
			Variables :> {sampleModel}
		],
		Example[{Options, CultureAdhesion, "Specify the default type of cell culture (adherent or suspension) that should be performed when growing any cells in this model. If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				CultureAdhesion -> Adherent
			];
			Download[sampleModel, CultureAdhesion],
			Adherent,
			Variables :> {sampleModel}
		],
		Example[{Options, Sterile, "Indicates that samples of this model arrive free of both microbial contamination and any microbial cell samples from the manufacturer, or is prepared free of both microbial contamination and any microbial cell samples by employing autoclaving, sterile filtration, or mixing exclusively sterile components with aseptic techniques during the course of experiments, as well as during sample storage and handling:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Sterile -> True
			];
			Download[sampleModel, Sterile],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, AsepticHandling, "Specify if special techniques should be used to prevent contamination by microorganisms when handling samples of this model. Aseptic techniques include sanitization, autoclaving, sterile filtration, mixing exclusively sterile components, and transferring in a biosafety cabinet during experimentation and storage:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				AsepticHandling -> True
			];
			Download[sampleModel, AsepticHandling],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, DefaultStorageCondition, "Specify the typical environment in which samples of this model should be stored when not in use by an experiment. Default conditions may be overridden individually for any given sample:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Flammable -> True,
				DefaultStorageCondition -> Model[StorageCondition, "id:n0k9mG8Bv96n" (* "Freezer, Flammable" *)]
			];
			Download[sampleModel, DefaultStorageCondition],
			LinkP[Model[StorageCondition, "id:n0k9mG8Bv96n" (* "Freezer, Flammable" *)]],
			Variables :> {sampleModel}
		],
		Example[{Options, Expires, "Specify if samples of this model have a finite lifespan and become unsuitable for use after a given amount of time:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Expires -> True,
				ShelfLife -> 1 Month,
				UnsealedShelfLife -> 1 Week
			];
			Download[sampleModel, Expires],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, ShelfLife, "Specify the length of time after their creation date (DateCreated) that samples of this model are recommended for use, before being considered expired:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Expires -> True,
				ShelfLife -> 1 Month,
				UnsealedShelfLife -> 1 Week
			];
			Download[sampleModel, ShelfLife],
			EqualP[1 Month],
			Variables :> {sampleModel}
		],
		Example[{Options, UnsealedShelfLife, "Specify the length of time after first being uncovered (DateUnsealed) that samples of this model are recommended for use before being considered expired:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Expires -> True,
				ShelfLife -> 1 Month,
				UnsealedShelfLife -> 1 Week
			];
			Download[sampleModel, UnsealedShelfLife],
			EqualP[1 Week],
			Variables :> {sampleModel}
		],
		Example[{Options, TransportTemperature, "Specify the temperature at which samples of this model should be heated or cooled to when moved around the lab during experimentation, if different from ambient temperature:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				TransportTemperature -> 4 Celsius
			];
			Download[sampleModel, TransportTemperature],
			EqualP[4 Celsius],
			Variables :> {sampleModel}
		],
		Example[{Options, Anhydrous, "Specify if this sample does not contain traces of water:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Anhydrous -> True
			];
			Download[sampleModel, Anhydrous],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Radioactive, "Specify if pure samples of this sample model emit substantial ionizing radiation:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Radioactive -> True
			];
			Download[sampleModel, Radioactive],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Ventilated, "Specify if pure samples of this sample model must be handled in an enclosure where airflow is used to reduce exposure of the user to the substance and contaminated air is exhausted in a safe location. Samples may need to be ventilated if they are, for example, pungent, fuming or hazardous:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Ventilated -> True
			];
			Download[sampleModel, Ventilated],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Pungent, "Specify if pure samples of this sample model have a strong odor:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Ventilated -> True,
				Pungent -> True
			];
			Download[sampleModel, Pungent],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Fuming, "Specify if pure samples of this sample model emit fumes spontaneously when exposed to air:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Fuming -> True
			];
			Download[sampleModel, Fuming],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Flammable, "Specify if pure samples of this sample model are easily set aflame under standard conditions. This corresponds to NFPA rating of 3 or greater:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:n0k9mG8Bv96n" (* "Freezer, Flammable" *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Flammable -> True
			];
			Download[sampleModel, Flammable],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Acid, "Specify if this sample model forms strongly acidic solutions when dissolved in water (typically pKa <= 4) and requires secondary containment during storage:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:qdkmxzqoPakV" (* "Refrigerator, Acid" *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Acid -> True
			];
			Download[sampleModel, Acid],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Base, "Specify if this sample model forms strongly basic solutions when dissolved in water (typically pKaH >= 11) and requires secondary containment during storage:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:XnlV5jKzPXlb" (* "Refrigerator, Base" *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Base -> True
			];
			Download[sampleModel, Base],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, Pyrophoric, "Specify if pure samples of this sample model can ignite spontaneously upon exposure to air:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:O81aEBZ5Gnvx" (* "Freezer, Flammable Pyrophoric" *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Flammable -> True,
				Pyrophoric -> True
			];
			Download[sampleModel, Pyrophoric],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, WaterReactive, "Specify if pure samples of this sample model react spontaneously upon exposure to water:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				WaterReactive -> True
			];
			Download[sampleModel, WaterReactive],
			True,
			Variables :> {sampleModel}
		],
		Test["Specify if pure samples of this sample model are currently banned from usage in the ECL because the facility isn't yet equipped to handle them:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				HazardousBan -> True
			];
			Download[sampleModel, HazardousBan],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, ExpirationHazard, "Specify if pure samples of this sample model become hazardous once they are expired and must be automatically disposed of when they pass their expiration date:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Expires -> True,
				ShelfLife -> 1 Month,
				UnsealedShelfLife -> 1 Week,
				ExpirationHazard -> True
			];
			Download[sampleModel, ExpirationHazard],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, ParticularlyHazardousSubstance, "Specify if exposure to samples of this sample model has the potential to cause serious and lasting harm. A substance is considered particularly harmful if it is categorized by any of the following GHS classifications (as found on a MSDS): Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H371, H372, H373), Carcinogenicity (H350). Note that PHS designation primarily describes toxicity hazard and doesn't include other types of hazard such as water reactivity or being pyrophoric:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ParticularlyHazardousSubstance -> True
			];
			Download[sampleModel, ParticularlyHazardousSubstance],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, DrainDisposal, "Specify if pure samples of this sample model may be safely disposed down a standard drain:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				DrainDisposal -> True
			];
			Download[sampleModel, DrainDisposal],
			True,
			Variables :> {sampleModel}
		],
		Test["Specify if an MSDS is applicable for this sample model. If this option conflicts with the MSDSFile option, the latter will be used:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				IncompatibleMaterials -> {None},
				MSDSRequired -> False
			];
			Download[sampleModel, MSDSRequired],
			False,
			Variables :> {sampleModel}
		],
		Example[{Options, MSDSFile, "Specify a PDF file of the MSDS (Materials Safety Data Sheet) of this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 0",
				Flammable -> False,
				NFPA -> {1,0,0,{}},
				MSDSFile -> "https://cdn.caymanchem.com/cdn/msds/14118m.pdf"
			];
			Download[sampleModel, MSDSFile],
			ObjectP[Object[EmeraldCloudFile]],
			Variables :> {sampleModel}
		],
		Example[{Options, NFPA, "Specify the National Fire Protection Association (NFPA) 704 hazard diamond classification for this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				NFPA -> {3, 0, 0, {Radioactive}}
			];
			Download[sampleModel, NFPA],
			{Health -> 3, Flammability -> 0, Reactivity -> 0, Special -> {Radioactive}},
			Variables :> {sampleModel}
		],
		Example[{Options, DOTHazardClass, "Specify the Department of Transportation hazard classification of this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				DOTHazardClass -> "Class 9 Miscellaneous Dangerous Goods Hazard"
			];
			Download[sampleModel, DOTHazardClass],
			"Class 9 Miscellaneous Dangerous Goods Hazard",
			Variables :> {sampleModel}
		],
		Example[{Options, BiosafetyLevel, "Specify the Biosafety classification of this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				BiosafetyLevel -> "BSL-1"
			];
			Download[sampleModel, BiosafetyLevel],
			"BSL-1",
			Variables :> {sampleModel}
		],
		Example[{Options, DoubleGloveRequired, "Specify if working with samples of this sample model requires wearing two pairs of gloves:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				DoubleGloveRequired -> True
			];
			Download[sampleModel, DoubleGloveRequired],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, LightSensitive, "Specify if the samples of this sample model reacts or degrades in the presence of light and requires storage in the dark:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				LightSensitive -> True
			];
			Download[sampleModel, LightSensitive],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, IncompatibleMaterials, "Specify a list of materials that would be damaged if wetted by samples of this sample model:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {PVC}
			];
			Download[sampleModel, IncompatibleMaterials],
			{PVC},
			Variables :> {sampleModel}
		],
		Example[{Options, LiquidHandlerIncompatible, "Specify if pure samples of this sample model cannot be reliably aspirated or dispensed on an automated liquid handling robot. Substances may be incompatible if they have a low boiling point, readily producing vapor, are highly viscous or are chemically incompatible with all tip types:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				LiquidHandlerIncompatible -> True
			];
			Download[sampleModel, LiquidHandlerIncompatible],
			True,
			Variables :> {sampleModel}
		],
		Example[{Options, UltrasonicIncompatible, "Specify if volume measurements of pure samples of this sample model cannot be performed via the ultrasonic distance method due to vapors interfering with the reading:"},
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				UltrasonicIncompatible -> True
			];
			Download[sampleModel, UltrasonicIncompatible],
			True,
			Variables :> {sampleModel}
		],
		Test["Specify if the database changes resulting from this function should be made immediately or if upload packets should be returned:",
			UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Upload -> False
			],
			_?ValidUploadQ
		],
		Test["Specify what the function should return:",
			UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Output -> {Result, Options, Tests}
			],
			{
				ObjectP[Model[Sample]],
				{_Rule..},
				{_EmeraldTest..}
			}
		],
		Test["Specify if error-checking in ValidObjectQ of the corresponding type that the user is trying to create or modify will be employed to ensure the uploaded object is ready for final verification. If Strict -> True, the Upload function will return $Failed if the final packet fails ValidObjectQ tests:",
			UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				Strict -> True
			],
			ObjectP[Model[Sample]]
		],
		Test["Authors is populated automatically for new sample models:",
			sampleModel = UploadSampleModel[
				"Test sample model name for UploadSampleModel unit tests " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Composition -> {{Null, Null}},
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			];
			Download[sampleModel, Authors],
			{LinkP[$PersonID]},
			Variables :> {sampleModel}
		],
		Test["Composition is correctly populated from the input:",
			sampleModel = UploadSampleModel[
				{
					{50 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{50 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]}
				},
				Name -> "50/50 Water Methanol for UploadSampleModel unit tests 3 " <> $SessionUUID,
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			];
			Download[sampleModel, Composition],
			{
				{EqualP[50 VolumePercent], LinkP[Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]]},
				{EqualP[50 VolumePercent], LinkP[Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]]}
			},
			Variables :> {sampleModel}
		],
		Test["Composition option supersedes the composition input:",
			sampleModel = UploadSampleModel[
				{
					{10 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]}
				},
				Name -> "50/50 Water Methanol for UploadSampleModel unit tests 4 " <> $SessionUUID,
				Composition -> {
					{50 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{50 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			];
			Download[sampleModel, Composition],
			{
				{EqualP[50 VolumePercent], LinkP[Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]]},
				{EqualP[50 VolumePercent], LinkP[Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]]}
			},
			Variables :> {sampleModel}
		],
		Test["Upload a sample model using a CAS number. Name is resolved to the value from PubChem if left Automatic:",
			resolvedOptions = UploadSampleModel[
				"67-56-1",
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				IncompatibleMaterials -> {None},
				Output -> Options
			];
			Lookup[
				resolvedOptions,
				Name
			],
			"Methanol",
			Variables :> {sampleModel},
			Stubs :> {
				(* This prevents the duplicate name check from flagging. Can't avoid in this case as we have to use a known molecule *)
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Upload a sample model using a PubChem identifier specified as integer. Name is resolved to the value from PubChem if left Automatic:",
			resolvedOptions = UploadSampleModel[
				887,
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				IncompatibleMaterials -> {None},
				Output -> Options
			];
			Lookup[
				resolvedOptions,
				Name
			],
			"Methanol",
			Variables :> {sampleModel},
			Stubs :> {
				(* This prevents the duplicate name check from flagging. Can't avoid in this case as we have to use a known molecule *)
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Upload a sample model using a PubChem identifier. Name is resolved to the value from PubChem if left Automatic:",
			resolvedOptions = UploadSampleModel[
				PubChem[887],
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				IncompatibleMaterials -> {None},
				Output -> Options
			];
			Lookup[
				resolvedOptions,
				Name
			],
			"Methanol",
			Variables :> {sampleModel},
			Stubs :> {
				(* This prevents the duplicate name check from flagging. Can't avoid in this case as we have to use a known molecule *)
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Upload a sample model using an InChI. Name is resolved to the value from PubChem if left Automatic:",
			resolvedOptions = UploadSampleModel[
				"InChI=1S/CH4O/c1-2/h2H,1H3",
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				IncompatibleMaterials -> {None},
				Output -> Options
			];
			Lookup[
				resolvedOptions,
				Name
			],
			"Methanol",
			Variables :> {sampleModel},
			Stubs :> {
				(* This prevents the duplicate name check from flagging. Can't avoid in this case as we have to use a known molecule *)
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Upload a sample model using an InChIKey. Name is resolved to the value from PubChem if left Automatic:",
			resolvedOptions = UploadSampleModel[
				"OKKJLVBELUTLKV-UHFFFAOYSA-N",
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				IncompatibleMaterials -> {None},
				Output -> Options
			];
			Lookup[
				resolvedOptions,
				Name
			],
			"Methanol",
			Variables :> {sampleModel},
			Stubs :> {
				(* This prevents the duplicate name check from flagging. Can't avoid in this case as we have to use a known molecule *)
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Upload a sample model using a supplier URL. Name is resolved to the value from PubChem if left Automatic:",
			resolvedOptions = UploadSampleModel[
				"https://www.thermofisher.com/order/catalog/product/039214.36",
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				IncompatibleMaterials -> {None},
				Output -> Options
			];
			Lookup[
				resolvedOptions,
				Name
			],
			"Caffeine",
			Variables :> {sampleModel},
			Stubs :> {
				(* This prevents the duplicate name check from flagging. Can't avoid in this case as we have to use a known molecule *)
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["When uploading a sample model using an identifier, the Name option is used if specified:",
			resolvedOptions = UploadSampleModel[
				"67-56-1",
				Name -> "99% Methanol for UploadSampleModel unit tests 2 " <> $SessionUUID,
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				IncompatibleMaterials -> {None},
				Output -> Options
			];
			Lookup[
				resolvedOptions,
				Name
			],
			"99% Methanol for UploadSampleModel unit tests 2 " <> $SessionUUID,
			Variables :> {sampleModel},
			Stubs :> {
				(* This prevents the duplicate name check from flagging. Can't avoid in this case as we have to use a known molecule *)
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		]
	},
	SetUp :> {
		$CreatedObjects = {}
	},
	TearDown :> {
		EraseObject[
			PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]],
			Force -> True,
			Verbose -> False
		];
		Unset[$CreatedObjects]
	},
	Stubs:>{
		$AllowPublicObjects = True,
		$Notebook=Null,

		(* Turn off duplicate checking for speed *)
		$installDefaultUploadFunctionDuplicateChecking = False
	},
	SymbolSetUp :> (
		Module[{namedObjects,existingObjs},
			namedObjects = Quiet[Cases[
				Flatten[{
					Search[{Model[Sample], Model[Molecule]}, StringContainsQ[Name, "UploadSampleModel"] && StringContainsQ[Name, $SessionUUID] && DeveloperObject == Alternatives[True, False, Null]],
					Object[Container,Bench,"Test bench for UploadSampleModel tests " <> $SessionUUID],
					Model[Sample,"Test Sample Model for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Container, Plate, "Test DWP for UploadSampleModel tests " <> $SessionUUID],
					Object[Sample,"Test Sample 1 for UploadSampleModel tests " <> $SessionUUID],
					Object[Sample,"Test Sample 2 for UploadSampleModel tests " <> $SessionUUID],
					Model[Molecule, "Test sachet filler model for UploadSampleModel tests "<> $SessionUUID],
					Model[Material, "Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID],
					Object[Product, "Test Product 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Product, "Test Kit Product 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Company, Service, "Test Service Provider 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Method, ThawCells, "Test Thaw Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Method, WashCells, "Test Wash Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Method, ChangeMedia, "Test Change Media Method 1 for UploadSampleModel unit tests " <> $SessionUUID]
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
				Upload[{
					<|
						Name -> "Test Sample Model for UploadSampleModel unit tests " <> $SessionUUID,
						BiosafetyLevel -> "BSL-1",
						Replace[Composition] -> {{Null, Link[Model[Molecule, "id:6V0npvmOnGKV"]]}, {Null, Null}},
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						Density -> Quantity[1.13`, ("Grams") / ("Milliliters")],
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
						Replace[Synonyms] -> {"Test Sample Model for UploadSampleModel unit tests " <> $SessionUUID}
					|>,
					<|
						Type -> Object[Product],
						Name -> "Test Product 1 for UploadSampleModel unit tests " <> $SessionUUID
					|>,
					<|
						Type -> Object[Product],
						Name -> "Test Kit Product 1 for UploadSampleModel unit tests " <> $SessionUUID
					|>,
					<|
						Type -> Object[Company, Service],
						Name -> "Test Service Provider 1 for UploadSampleModel unit tests " <> $SessionUUID
					|>,
					<|
						Type -> Object[Method, ThawCells],
						Name -> "Test Thaw Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID
					|>,
					<|
						Type -> Object[Method, WashCells],
						Name -> "Test Wash Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID
					|>,
					<|
						Type -> Object[Method, ChangeMedia],
						Name -> "Test Change Media Method 1 for UploadSampleModel unit tests " <> $SessionUUID
					|>
				}];
				Quiet[UploadMolecule[
					"Test sachet filler model for UploadSampleModel tests "<> $SessionUUID,
					State -> Solid,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					Force -> True
				]];
				UploadMaterial[
					"Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID,
					MSDSFile -> NotApplicable,
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
						Model[Sample,"Test Sample Model for UploadSampleModel unit tests " <> $SessionUUID],
						Model[Sample,"Test Sample Model for UploadSampleModel unit tests " <> $SessionUUID]
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
		Module[{namedObjects,allObjects,existingObjs},
			namedObjects = Quiet[Cases[
				Flatten[{
					Search[{Model[Sample], Model[Molecule]}, StringContainsQ[Name, "UploadSampleModel"] && StringContainsQ[Name, $SessionUUID] && DeveloperObject == Alternatives[True, False, Null]],
					Object[Container,Bench,"Test bench for UploadSampleModel tests " <> $SessionUUID],
					Model[Sample,"Test Sample Model for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Container, Plate, "Test DWP for UploadSampleModel tests " <> $SessionUUID],
					Object[Sample,"Test Sample 1 for UploadSampleModel tests " <> $SessionUUID],
					Object[Sample,"Test Sample 2 for UploadSampleModel tests " <> $SessionUUID],
					Model[Molecule, "Test sachet filler model for UploadSampleModel tests "<> $SessionUUID],
					Model[Material, "Test sachet pouch model for UploadSampleModel tests "<> $SessionUUID],
					Object[Product, "Test Product 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Product, "Test Kit Product 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Company, Service, "Test Service Provider 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Method, ThawCells, "Test Thaw Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Method, WashCells, "Test Wash Cells Method 1 for UploadSampleModel unit tests " <> $SessionUUID],
					Object[Method, ChangeMedia, "Test Change Media Method 1 for UploadSampleModel unit tests " <> $SessionUUID]
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
				"50/50 Water Methanol for UploadSampleModelOptions unit tests " <> $SessionUUID,
				Composition -> {
					{50 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{50 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			_Grid
		],
		Example[{Basic, "Upload a new fulfillment model of an analyte (oligomer) in water:"},
			myOligomerAnalyte=UploadOligomer["My Oligomer Analyte for UploadSampleModelOptions unit tests " <> $SessionUUID, Molecule -> Strand[DNA["AATTGTTCGGACACT"]], PolymerType -> DNA];

			UploadSampleModelOptions[
				"My Oligomer Analyte in Water for UploadSampleModelOptions unit tests " <> $SessionUUID,
				Composition -> {
					{10 Micromolar, Model[Molecule, Oligomer, "My Oligomer Analyte for UploadSampleModelOptions unit tests " <> $SessionUUID]},
					{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]}
				},
				Solvent -> Model[Sample, "id:8qZ1VWNmdLBD" (* Milli-Q water *)],
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			_Grid,
			Variables :> {myOligomerAnalyte}
		],
		Example[{Basic, "Upload a new fulfillment model for 99% Pure HPLC Grade Methanol. The {1 VolumePercent, Null} entry in the Composition field indicates that 1 VolumePercent of the sample is an unknown impurity:"},
			UploadSampleModelOptions[
				"99% HPLC Grade Methanol for UploadSampleModelOptions unit tests " <> $SessionUUID,
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				UsedAsSolvent -> True,
				Grade -> HPLC,
				Expires -> True,
				ShelfLife -> 12 Month,
				UnsealedShelfLife -> 5 Month,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			_Grid
		],
		Example[{Additional, "Upload a new fulfillment model of an analyte that has fixed amounts:"},

			UploadSampleModelOptions[
				"My Analyte with Fixed Amounts for UploadSampleModelOptions unit tests " <> $SessionUUID,
				Composition -> {
					{10 Micromolar, Model[Molecule, "id:BYDOjvG676mq" (* Sodium Chloride *)]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				FixedAmounts -> {0.5 Milligram, 1 Milligram},
				TransferOutSolventVolumes -> {10 Milliliter, 20 Milliliter},
				SingleUse -> True,
				SampleHandling -> Fixed
			],
			_Grid
		],
		Example[{Options, "OpticalComposition", "Upload a new (1R)-(-)-10-camphorsulfonic acid sample model with its OpticalComposition field populated."},
			UploadSampleModelOptions["(1R)-(-)-10-camphorsulfonic in methanol for UploadSampleModelOptions unit tests 1 " <> $SessionUUID,
				Composition -> {{100 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]}, {1 Millimolar, Model[Molecule, "id:dORYzZJNK955" (* (1R)-(-)-10-camphorsulfonic acid *)]}},
				OpticalComposition -> {{100 Percent, Model[Molecule, "id:dORYzZJNK955" (* (1R)-(-)-10-camphorsulfonic acid *)]}},
				UsedAsSolvent -> False,
				Grade -> ACS,
				Expires -> True,
				ShelfLife -> 24 Month,
				UnsealedShelfLife -> 12 Month,
				DefaultStorageCondition -> Model[StorageCondition, "id:Vrbp1jKDY4bm"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}],
			_Grid
		],
		Example[{Basic, "Update an already existing sample fulfillment model:"},
			UploadSampleModelOptions[
				Model[Sample, "id:BYDOjv1VA88z" (* "Sodium Chloride" *)],
				Flammable -> False
			],
			_Grid
		]
	},
	SetUp :> {
		$CreatedObjects = {}
	},
	TearDown :> {
		EraseObject[
			PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]],
			Force -> True,
			Verbose -> False
		];
		Unset[$CreatedObjects]
	},
	Stubs:>{
		$Notebook=Null,

		(* Turn off duplicate checking for speed *)
		$installDefaultUploadFunctionDuplicateChecking = False
	},
	SymbolSetUp :> (
		Module[{namedObjects,allObjects,existingObjs},
			namedObjects = Quiet[Cases[
				Flatten[{
					Search[{Model[Sample], Model[Molecule]}, StringContainsQ[Name, "UploadSampleModelOptions"] && StringContainsQ[Name, $SessionUUID] && DeveloperObject == Alternatives[True, False, Null]]
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
	),
	SymbolTearDown :> (
		Module[{namedObjects,allObjects,existingObjs},
			namedObjects = Quiet[Cases[
				Flatten[{
					Search[{Model[Sample], Model[Molecule]}, StringContainsQ[Name, "UploadSampleModelOptions"] && StringContainsQ[Name, $SessionUUID] && DeveloperObject == Alternatives[True, False, Null]]
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
	ValidUploadSampleModelQ,
	{
		Example[{Basic, "Upload a new fulfillment model of 50/50 Water Methanol:"},
			ValidUploadSampleModelQ[
				"50/50 Water Methanol for ValidUploadSampleModelQ unit tests " <> $SessionUUID,
				Composition -> {
					{50 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]},
					{50 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			BooleanP
		],
		Example[{Basic, "Upload a new fulfillment model of an analyte (oligomer) in water:"},
			myOligomerAnalyte=UploadOligomer["My Oligomer Analyte for ValidUploadSampleModelQ unit tests " <> $SessionUUID, Molecule -> Strand[DNA["AATTGTTCGGACACT"]], PolymerType -> DNA];

			ValidUploadSampleModelQ[
				"My Oligomer Analyte in Water for ValidUploadSampleModelQ unit tests " <> $SessionUUID,
				Composition -> {
					{10 Micromolar, Model[Molecule, Oligomer, "My Oligomer Analyte for ValidUploadSampleModelQ unit tests " <> $SessionUUID]},
					{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D" (* Water *)]}
				},
				Solvent -> Model[Sample, "id:8qZ1VWNmdLBD" (* Milli-Q water *)],
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			BooleanP,
			Variables :> {myOligomerAnalyte}
		],
		Example[{Basic, "Upload a new fulfillment model for 99% Pure HPLC Grade Methanol. The {1 VolumePercent, Null} entry in the Composition field indicates that 1 VolumePercent of the sample is an unknown impurity:"},
			ValidUploadSampleModelQ[
				"99% HPLC Grade Methanol for ValidUploadSampleModelQ unit tests " <> $SessionUUID,
				Composition -> {
					{99 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]},
					{1 VolumePercent, Null}
				},
				UsedAsSolvent -> True,
				Grade -> HPLC,
				Expires -> True,
				ShelfLife -> 12 Month,
				UnsealedShelfLife -> 5 Month,
				DefaultStorageCondition -> Model[StorageCondition, "id:vXl9j57YrPlN" (* Ambient Storage, Flammable *)],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}
			],
			BooleanP
		],
		Example[{Additional, "Upload a new fulfillment model of an analyte that has fixed amounts:"},

			ValidUploadSampleModelQ[
				"My Analyte with Fixed Amounts for ValidUploadSampleModelQ unit tests " <> $SessionUUID,
				Composition -> {
					{10 Micromolar, Model[Molecule, "id:BYDOjvG676mq" (* Sodium Chloride *)]}
				},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:7X104vnR18vX" (* Ambient Storage *)],
				State -> Solid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				FixedAmounts -> {0.5 Milligram, 1 Milligram},
				TransferOutSolventVolumes -> {10 Milliliter, 20 Milliliter},
				SingleUse -> True,
				SampleHandling -> Fixed
			],
			BooleanP
		],
		Example[{Options, "OpticalComposition", "Upload a new (1R)-(-)-10-camphorsulfonic acid sample model with its OpticalComposition field populated."},
			ValidUploadSampleModelQ["(1R)-(-)-10-camphorsulfonic in methanol for ValidUploadSampleModelQ unit tests 1 " <> $SessionUUID,
				Composition -> {{100 VolumePercent, Model[Molecule, "id:M8n3rx0676xR" (* Methanol *)]}, {1 Millimolar, Model[Molecule, "id:dORYzZJNK955" (* (1R)-(-)-10-camphorsulfonic acid *)]}},
				OpticalComposition -> {{100 Percent, Model[Molecule, "id:dORYzZJNK955" (* (1R)-(-)-10-camphorsulfonic acid *)]}},
				UsedAsSolvent -> False,
				Grade -> ACS,
				Expires -> True,
				ShelfLife -> 24 Month,
				UnsealedShelfLife -> 12 Month,
				DefaultStorageCondition -> Model[StorageCondition, "id:Vrbp1jKDY4bm"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Flammable -> True,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None}],
			BooleanP
		],
		Example[{Basic, "Update an already existing sample fulfillment model:"},
			ValidUploadSampleModelQ[
				Model[Sample, "id:BYDOjv1VA88z" (* "Sodium Chloride" *)],
				Flammable -> False
			],
			BooleanP
		]
	},
	SetUp :> {
		$CreatedObjects = {}
	},
	TearDown :> {
		EraseObject[
			PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]],
			Force -> True,
			Verbose -> False
		];
		Unset[$CreatedObjects]
	},
	Stubs:>{
		$Notebook=Null,

		(* Turn off duplicate checking for speed *)
		$installDefaultUploadFunctionDuplicateChecking = False
	},
	SymbolSetUp :> (
		Module[{namedObjects,allObjects,existingObjs},
			namedObjects = Quiet[Cases[
				Flatten[{
					Search[{Model[Sample], Model[Molecule]}, StringContainsQ[Name, "ValidUploadSampleModelQ"] && StringContainsQ[Name, $SessionUUID] && DeveloperObject == Alternatives[True, False, Null]]
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
	),
	SymbolTearDown :> (
		Module[{namedObjects,allObjects,existingObjs},
			namedObjects = Quiet[Cases[
				Flatten[{
					Search[{Model[Sample], Model[Molecule]}, StringContainsQ[Name, "ValidUploadSampleModelQ"] && StringContainsQ[Name, $SessionUUID] && DeveloperObject == Alternatives[True, False, Null]]
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