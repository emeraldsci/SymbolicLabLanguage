(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadReferenceElectrode*)


DefineTests[UploadReferenceElectrodeModel,
	{
		(* ============ *)
		(* == BASICS == *)
		(* ============ *)

		Example[{Basic, "Create a new reference electrode model from a template model and provide the new information using different options:"},
			Module[{newModel, voqResult},
				newModel = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					MinPotential -> -2 Volt
				];
				voqResult = ValidObjectQ[newModel];
				{newModel, voqResult}
			],
			{ObjectP[Model[Item, Electrode, ReferenceElectrode]], True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Basic, "Create a new Blank reference electrode model with the provided the information provided in options, with Blank set to Null:"},
			Module[{newModel, voqResult},

				newModel = UploadReferenceElectrodeModel[
					Name -> "New Blank Reference Electrode Model",
					Synonyms -> {"New Blank Reference Electrode Model", "This is indeed a new reference electrode model!"},
					ReferenceElectrodeType -> "Bare-Ag",
					Blank -> Null,
					SolutionVolume -> 10 Milliliter,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					DefaultStorageCondition -> AmbientStorage,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					ElectrodePackagingMaterial -> Glass,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					WiringDiameters -> Null,
					WiringLength -> 20 Centimeter,
					MaxNumberOfUses -> 100,
					MaxNumberOfPolishings -> 50,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					WettedMaterials -> {Gold, Glass},
					IncompatibleMaterials -> None
				];
				voqResult = ValidObjectQ[newModel];
				{newModel, voqResult}
			],
			{ObjectP[Model[Item, Electrode, ReferenceElectrode]], True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Basic, "When a model with the same reference electrode parameters is already in the database, the existing model will be returned:"},
			Module[{newModel},
				newModel = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"]
				];
				SameObjectQ[newModel, Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"]]
			],
			True,
			SetUp:>($CreatedObjects={}),
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Basic, "If a Name is specified, a new reference electrode model will be created even if there is already a model existing in the database with the same reference electrode parameters:"},
			Module[{newModel, voqResult},
				newModel = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					Name -> "Duplicate Ag/AgCl Reference Electrode"
				];

				voqResult = ValidObjectQ[newModel];
				{newModel, voqResult}
			],
			{ObjectP[Model[Item, Electrode, ReferenceElectrode]], True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Additional, "When creating a new Blank reference electrode model, set Blank to Null, and ReferenceElectrodeType, SolutionVolume, Dimensions, BulkMaterial, CoatMaterial, ElectrodeShape, WiringConnectors, MaxNumberOfUses, MinPotential, MaxPotential, and SonicationSensitive are required to be explicitly specified. Name, Synonyms, DefaultStorageCondition, ElectrodePackagingMaterial, WiringDiameters, WiringLength, MaxNumberOfPolishings, WettedMaterials, IncompatibleMaterials are optional to be specified:"},
			Module[{newModel, voqResult},

				newModel = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					SolutionVolume -> 10 Milliliter,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False
				];
				voqResult = ValidObjectQ[newModel];
				{newModel, voqResult}
			],
			{ObjectP[Model[Item, Electrode, ReferenceElectrode]], True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],


		(* ============= *)
		(* == OPTIONS == *)
		(* ============= *)

		(* -- Name -- *)
		Example[{Options, Name, "Use the Name option to specify the Name for the newly generated reference electrode model. If a Name is specified, a new reference electrode model will be created even if there is already a model existing in the database with the same reference electrode parameters:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					Name -> "Duplicate Ag/AgCl Reference Electrode",
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, Name], voqResult}
			],
			{"Duplicate Ag/AgCl Reference Electrode", True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Synonyms -- *)
		Example[{Options, Synonyms, "Use the Synonyms option to provide alternative names for the newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					Name -> "Duplicate Ag/AgCl Reference Electrode",
					Synonyms -> {"Duplicate Ag/AgCl Reference Electrode", "This is indeed a new duplicate Ag/AgCl Reference Electrode"},
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, Synonyms], voqResult}
			],
			{{"Duplicate Ag/AgCl Reference Electrode", "This is indeed a new duplicate Ag/AgCl Reference Electrode"}, True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ReferenceElectrodeType -- *)
		Example[{Options, ReferenceElectrodeType, "Use the ReferenceElectrodeType to specify the type of the newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					Name -> "Duplicate Ag/AgCl Reference Electrode",
					ReferenceElectrodeType -> "Ag/AgCl",
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, ReferenceElectrodeType], voqResult}
			],
			{"Ag/AgCl", True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Blank -- *)
		Example[{Options, Blank, "Use the Blank option to specify the blank reference electrode model (this blank model can be used to prepare the new model by filling the blank with the ReferenceSolution defined in the new model) of the newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					Name -> "Duplicate Ag/AgCl Reference Electrode",
					Blank -> Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{SameObjectQ[Lookup[options, Blank], Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]], voqResult}
			],
			{True, True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- RecommendedSolventType -- *)
		Example[{Options, RecommendedSolventType, "Use the RecommendedSolventType option to specify which type of solvent of the experiment solution this newly generated reference electrode model is recommended to work in:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					Name -> "Duplicate Ag/AgCl Reference Electrode",
					RecommendedSolventType -> Aqueous,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, RecommendedSolventType], voqResult}
			],
			{Aqueous, True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ReferenceSolution -- *)
		Example[{Options, ReferenceSolution, "Use the ReferenceSolution option to specify the model of the reference solution filled in the glass tube of the newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					Name -> "Duplicate Ag/AgCl Reference Electrode",
					ReferenceSolution -> Model[Sample, StockSolution, "3M KCl Aqueous Solution, 10 mL"],
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{SameObjectQ[Lookup[options, ReferenceSolution], Model[Sample, StockSolution, "3M KCl Aqueous Solution, 10 mL"]], voqResult}
			],
			{True, True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ReferenceCouplingSample -- *)
		Example[{Options, ReferenceCouplingSample, "Use the ReferenceCouplingSample option to specify the model of the sample that contains a molecule to form a redox coupling pair of the reference electrode's material of the newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					Name -> "Duplicate Ag/AgCl Reference Electrode",
					ReferenceCouplingSample -> Model[Sample, "Potassium Chloride, ACS Reagent Grade"],
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{SameObjectQ[Lookup[options, ReferenceCouplingSample], Model[Sample, "Potassium Chloride, ACS Reagent Grade"]], voqResult}
			],
			{True, True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SolutionVolume -- *)
		Example[{Options, SolutionVolume, "When uploading a new blank reference electrode model, use the SolutionVolume option to specify the volume of reference solution filled in the glass tube of this newly generated reference electrode model for it to properly work:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					SolutionVolume -> 10 Milliliter,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, SolutionVolume], voqResult}
			],
			{10 Milliliter, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- RecommendedRefreshPeriod -- *)
		Example[{Options, RecommendedRefreshPeriod, "Use the RecommendedRefreshPeriod option to specify the time period the reference solution filled in the glass tube of this newly generated reference electrode model should be refreshed:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					Name -> "Duplicate Ag/AgCl Reference Electrode",
					RecommendedRefreshPeriod -> 1 Year,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, RecommendedRefreshPeriod], voqResult}
			],
			{1 Year, True},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Dimensions -- *)
		Example[{Options, Dimensions, "When uploading a new blank reference electrode model, use the Dimensions option to specify the physical dimensions of this newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, Dimensions], voqResult}
			],
			{{2 Centimeter, 2 Centimeter, 20 Centimeter}, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- DefaultStorageCondition -- *)
		Example[{Options, DefaultStorageCondition, "When uploading a new blank reference electrode model, use the DefaultStorageCondition option to specify under which condition this newly generated reference electrode model should be stored:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					DefaultStorageCondition -> AmbientStorage,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{SameObjectQ[Lookup[options, DefaultStorageCondition], Model[StorageCondition, "Ambient Storage"]], voqResult}
			],
			{True, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, DefaultStorageCondition, "When uploading a new blank reference electrode model, use the DefaultStorageCondition option to specify under which condition this newly generated reference electrode model should be stored:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{SameObjectQ[Lookup[options, DefaultStorageCondition], Model[StorageCondition, "Ambient Storage"]], voqResult}
			],
			{True, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- BulkMaterial -- *)
		Example[{Options, BulkMaterial, "When uploading a new blank reference electrode model, use the BulkMaterial option to specify the conductive material (if the electrode is not coated) or the internal material (if the electrode is coated) of this newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					BulkMaterial -> Gold,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, BulkMaterial], voqResult}
			],
			{Gold, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- CoatMaterial -- *)
		Example[{Options, CoatMaterial, "When uploading a new blank reference electrode model, use the CoatMaterial option to specify the conductive material on the surface (if the electrode is coated) of this newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					CoatMaterial -> Silver,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, CoatMaterial], voqResult}
			],
			{Silver, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ElectrodeShape -- *)
		Example[{Options, ElectrodeShape, "When uploading a new blank reference electrode model, use the ElectrodeShape option to specify the physical geometry of this newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					ElectrodeShape -> Rod,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, ElectrodeShape], voqResult}
			],
			{Rod, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ElectrodePackagingMaterial -- *)
		Example[{Options, ElectrodePackagingMaterial, "When uploading a new blank reference electrode model, use the ElectrodePackagingMaterial option to specify the material of the casing outside the conductive material of this newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					ElectrodePackagingMaterial -> Glass,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, ElectrodePackagingMaterial], voqResult}
			],
			{Glass, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- WiringConnectors -- *)
		Example[{Options, WiringConnectors, "When uploading a new blank reference electrode model, use the WiringConnectors option to specify the details of the wiring connectors of this newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, WiringConnectors], voqResult}
			],
			{{{"Test Wiring Connector 1", ElectraSynContactElectrode, None}}, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- WiringDiameters -- *)
		Example[{Options, WiringDiameters, "When uploading a new blank reference electrode model, use the WiringDiameters option to specify diameters of each wiring connector of this newly generated reference electrode model. If WiringDiameters is informed, the ExposedWire wiring connectors should have a non-Null diameter and the non-ExposedWire wiring connectors should have a Null diameter:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}, {"Test Wiring Connector 2", ExposedWire, None}},
					WiringDiameters -> {Null, 10 Millimeter},
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, WiringDiameters], voqResult}
			],
			{{Null, 10 Millimeter}, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- WiringLength -- *)
		Example[{Options, WiringLength, "When uploading a new blank reference electrode model, use the WiringLength option to specify the length of the conductive part of this newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					WiringLength -> 20 Centimeter,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, WiringLength], voqResult}
			],
			{20 Centimeter, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- MaxNumberOfUses -- *)
		Example[{Options, MaxNumberOfUses, "When uploading a new blank reference electrode model, use the MaxNumberOfUses option to specify the number of usages the electrodes of this newly generated reference electrode model can endure before being discarded:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					MaxNumberOfUses -> 100,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, MaxNumberOfUses], voqResult}
			],
			{100, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- MaxNumberOfPolishings -- *)
		Example[{Options, MaxNumberOfPolishings, "When uploading a new blank reference electrode model, use the MaxNumberOfPolishings option to specify the number of polishings can be performed on the non-working part (the part that does not directly contact the experiment solution) of the electrodes of this newly generated reference electrode model before the electrodes should be discarded:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					MaxNumberOfPolishings -> 50,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, MaxNumberOfPolishings], voqResult}
			],
			{50, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- MinPotential -- *)
		Example[{Options, MinPotential, "When uploading a new blank reference electrode model, use the MinPotential option to specify the lowest voltage this newly generated reference electrode model can endure without being damaged during experiments:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					MinPotential -> -2 Volt,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, MinPotential], voqResult}
			],
			{-2 Volt, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- MaxPotential -- *)
		Example[{Options, MaxPotential, "When uploading a new blank reference electrode model, use the MaxPotential option to specify the highest voltage this newly generated reference electrode model can endure without being damaged during experiments:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					MaxPotential -> 2 Volt,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, MaxPotential], voqResult}
			],
			{2 Volt, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SonicationSensitive -- *)
		Example[{Options, SonicationSensitive, "When uploading a new blank reference electrode model, use the SonicationSensitive option to specify if this newly generated reference electrode model can be sonication-cleaned and not being damaged:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					SonicationSensitive -> False,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, SonicationSensitive], voqResult}
			],
			{False, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- WettedMaterials -- *)
		Example[{Options, WettedMaterials, "When uploading a new blank reference electrode model, use the WettedMaterials option to specify the materials of this newly generated reference electrode model that in direct contact with the experiment solution:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					WettedMaterials -> {Gold},
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, WettedMaterials], voqResult}
			],
			{{Gold}, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* -- IncompatibleMaterials -- *)
		Example[{Options, IncompatibleMaterials, "When uploading a new blank reference electrode model, use the IncompatibleMaterials option to specify the materials that will be damaged in contact of this newly generated reference electrode model:"},
			Module[{newModel, options, voqResult},
				{newModel, options} = UploadReferenceElectrodeModel[
					Blank -> Null,
					ReferenceElectrodeType -> "Bare-Ag",
					IncompatibleMaterials -> Steel,
					Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
					SolutionVolume -> 10 Milliliter,
					BulkMaterial -> Gold,
					CoatMaterial -> Null,
					ElectrodeShape -> Rod,
					WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
					MaxNumberOfUses -> 100,
					MinPotential -> -2 Volt,
					MaxPotential -> 2 Volt,
					SonicationSensitive -> False,
					Output -> {Result, Options}
				];
				voqResult = ValidObjectQ[newModel];
				{Lookup[options, IncompatibleMaterials], voqResult}
			],
			{{Steel}, True},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],


		(* ============== *)
		(* == MESSAGES == *)
		(* ============== *)

		(* -- UREDeprecatedTemplateReferenceElectrodeModel -- *)
		Example[{Messages, "Template reference electrode model is deprecated", "If the provided template reference electrode model is deprecated, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UREDeprecatedTemplateReferenceElectrodeModel, Error::InvalidInput},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={};
				Upload[{
					<|
						Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Deprecated -> True
					|>
				}]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[{
					<|
						Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Deprecated -> Null
					|>
				}]
			)
		],

		(* -- UREBlankModelNotBareType -- *)
		Example[{Messages, Blank, "If the provided Blank is not a \"Bare\" type reference electrode model, an error will be thrown:"},
			UploadReferenceElectrodeModel[ReferenceElectrodeType -> "Ag/Ag+",
				Blank -> Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"]
			],
			$Failed,
			Messages :> {Error::UREBlankModelNotBareType, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREReferenceElectrodeTypeUnresolvable -- *)
		Example[{Messages, ReferenceElectrodeType, "If the RecommendedSolventType is not explicity specified when the model being upload is a Blank model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Name -> "New Blank Reference Electrode Model",
				Synonyms -> {"New Blank Reference Electrode Model", "This is indeed a new reference electrode model!"},
				ReferenceElectrodeType -> Automatic,
				Blank -> Null,
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				DefaultStorageCondition -> AmbientStorage,
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				ElectrodePackagingMaterial -> Glass,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				WiringDiameters -> Null,
				WiringLength -> 20 Centimeter,
				MaxNumberOfUses -> 100,
				MaxNumberOfPolishings -> 50,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False,
				WettedMaterials -> {Gold, Glass},
				IncompatibleMaterials -> None
			],
			$Failed,
			Messages :> {Error::UREReferenceElectrodeTypeUnresolvable, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREReferenceElectrodeTypeSameWithBlankModel -- *)
		Example[{Messages, ReferenceElectrodeType, "If the ReferenceElectrodeType is the same with the Blank model's ReferenceElectrodeType, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				Blank -> Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
				ReferenceElectrodeType -> "Bare-Ag"
			],
			$Failed,
			Messages :> {Error::UREReferenceElectrodeTypeSameWithBlankModel, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREReferenceElectrodeTypeInvalidForBlankModel -- *)
		Example[{Messages, ReferenceElectrodeType, "If the ReferenceElectrodeType is not a 'Bare', an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Name -> "New Blank Reference Electrode Model",
				Synonyms -> {"New Blank Reference Electrode Model", "This is indeed a new reference electrode model!"},
				ReferenceElectrodeType -> "Ag/AgCl",
				Blank -> Null,
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				DefaultStorageCondition -> AmbientStorage,
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				ElectrodePackagingMaterial -> Glass,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				WiringDiameters -> Null,
				WiringLength -> 20 Centimeter,
				MaxNumberOfUses -> 100,
				MaxNumberOfPolishings -> 50,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False,
				WettedMaterials -> {Gold, Glass},
				IncompatibleMaterials -> None
			],
			$Failed,
			Messages :> {Error::UREReferenceElectrodeTypeInvalidForBlankModel, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREReferenceElectrodeTypeInvalidForNonBlankModel -- *)
		Example[{Messages, ReferenceElectrodeType, "If the ReferenceElectrodeType is a 'Bare' type when the model being uploaded is a non-Blank model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				ReferenceElectrodeType -> "Bare-Ag"
			],
			$Failed,
			Messages :> {Error::UREBlankModelNotBareType, Error::UREReferenceElectrodeTypeInvalidForNonBlankModel, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URENonNullRecommendedSolventType -- *)
		Example[{Messages, RecommendedSolventType, "If the RecommendedSolventType is specified when the model being upload is a Blank model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
				Blank -> Null,
				RecommendedSolventType -> Organic
			],
			$Failed,
			Messages :> {Error::URENonNullRecommendedSolventType, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMissingRecommendedSolventType -- *)
		Example[{Messages, RecommendedSolventType, "If the RecommendedSolventType is set to Null when the model being upload is not a Blank reference electrode model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				RecommendedSolventType -> Null
			],
			$Failed,
			Messages :> {Error::UREMissingRecommendedSolventType, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREReferenceSolutionLessThanTwoComponents -- *)
		Example[{Messages, ReferenceSolution, "If the provided ReferenceSolution has less than two non-Null entries in its Composition field, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UREReferenceSolutionLessThanTwoComponents, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]}
					}
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
					}
				|>]
			)
		],

		(* -- UREReferenceSolutionMissingSolvent -- *)
		Example[{Messages, ReferenceSolution, "If the provided ReferenceSolution has no entries in its Solvent field, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UREReferenceSolutionMissingSolvent, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Solvent -> Null
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Solvent -> Link[Model[Sample, "Milli-Q water"]]
				|>]
			)
		],

		(* -- UREReferenceSolutionAmbiguousSolvent -- *)

		(* -- UREReferenceSolutionSolventMoleculeMissingDefaultSampleModel -- *)

		(* -- UREReferenceSolutionSolventSampleAmbiguousMolecule -- *)
		Example[{Messages, ReferenceSolution, "If the provided ReferenceSolution's solvent sample has more than one entry in its Composition field, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
				ReferenceCouplingSample -> Model[Sample, "Potassium Chloride"]
			],
			$Failed,
			Messages :> {Error::UREReferenceSolutionSolventSampleAmbiguousMolecule, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={};
				Upload[{
					<|
						Object -> Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Composition] -> {
							{50 VolumePercent, Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]},
							{50 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}
						}
					|>,
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]},
							{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
						},
						Solvent -> Link[Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID]],
						Replace[Analytes] -> {
							Link[Model[Molecule, "Potassium Chloride"]]
						}
					|>
				}]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[{
					<|
						Object -> Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]}}
					|>,
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]]},
							{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
						},
						Solvent -> Link[Model[Sample, "Milli-Q water"]],
						Replace[Analytes] -> {
							Link[Model[Molecule, "Potassium Chloride"]]
						}
					|>
				}]
			)
		],

		(* -- UREReferenceSolutionMissingAnalyte -- *)
		Example[{Messages, ReferenceSolution, "If the provided ReferenceSolution's Analytes field is not populated, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution 2 for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UREReferenceSolutionMissingAnalyte, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={};
				Upload[{
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Analytes] -> Null
					|>
				}]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[{
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Analytes] -> {
							Link[Model[Molecule, "Potassium Chloride"]]
						}
					|>
				}]
			)
		],

		(* -- UREReferenceSolutionAmbiguousAnalyte -- *)
		Example[{Messages, ReferenceSolution, "If the provided ReferenceSolution's Analytes field has more than one entry, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution 3 for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UREReferenceSolutionAmbiguousAnalyte, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={};
				Upload[{
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Analytes] -> {
							Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]],
							Link[Model[Molecule, "Water"]]
						}
					|>
				}]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[{
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Analytes] -> {
							Link[Model[Molecule, "Potassium Chloride"]]
						}
					|>
				}]
			)
		],

		(* -- UREReferenceSolutionAnalyteMoleculeMissingDefaultSampleModel -- *)
		Example[{Messages, ReferenceSolution, "If the provided ReferenceSolution's solvent molecule has no DefaultSampleModel, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				RecommendedSolventType -> Aqueous,
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
				ReferenceCouplingSample -> Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UREReferenceSolutionAnalyteMoleculeMissingDefaultSampleModel, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={};
				Upload[{
					<|
						Object -> Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						DefaultSampleModel -> Null
					|>,
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]]},
							{1 Molar, Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]}
						},
						Solvent -> Link[Model[Sample, "Milli-Q water"]],
						Replace[Analytes] -> {
							Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]
						}
					|>
				}]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[{
					<|
						Object -> Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						DefaultSampleModel -> Link[Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID]]
					|>,
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]]},
							{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
						},
						Solvent -> Link[Model[Sample, "Milli-Q water"]],
						Replace[Analytes] -> {
							Link[Model[Molecule, "Potassium Chloride"]]
						}
					|>
				}]
			)
		],

		(* -- URENonNullReferenceSolution -- *)
		Example[{Messages, ReferenceSolution, "If the ReferenceSolution is specified when the model being upload is a Blank model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
				Blank -> Null,
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::URENonNullReferenceSolution, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMissingReferenceSolution -- *)
		Example[{Messages, ReferenceSolution, "If the ReferenceSolution is set to Null when the model being upload is not a Blank reference electrode model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				ReferenceSolution -> Null
			],
			$Failed,
			Messages :> {Error::UREMissingReferenceSolution, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMismatchingSolventTypeWarning -- *)
		Example[{Messages, "The ReferenceSolution solvent mismatch RecommendedSolventType", "If the ReferenceSolution's solvent does not match with the RecommendedSolventType, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				RecommendedSolventType -> Organic,
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
				ReferenceCouplingSample -> Model[Sample, "Potassium Chloride"]
			],
			ObjectP[Model[Item, Electrode, ReferenceElectrode]],
			Messages :> {Warning::UREMismatchingSolventTypeWarning},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URENullPriceForPublicPreparableModel -- *)
		Example[{Messages, "URENullPriceForPublicPreparableModel", "If the Price option is not explicitly provided for a public and preparable model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				MinPotential -> -2 Volt
			],
			$Failed,
			Messages :> {Error::URENullPriceForPublicPreparableModel, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URENonNullReferenceCouplingSampleForBlankModel -- *)
		Example[{Messages, ReferenceCouplingSample, "If the ReferenceCouplingSample is specified when the model being upload is a Blank model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
				Blank -> Null,
				ReferenceCouplingSample -> Model[Sample, "Example Reference Coupling Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::URENonNullReferenceCouplingSampleForBlankModel, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URENonNullReferenceCouplingSampleForPseudoModel -- *)
		Example[{Messages, ReferenceCouplingSample, "If the ReferenceCouplingSample is specified when the model being upload is a pseudo reference electrode model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				ReferenceCouplingSample -> Model[Sample, "Example Reference Coupling Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::URENonNullReferenceCouplingSampleForPseudoModel, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMissingReferenceCouplingSample -- *)
		Example[{Messages, ReferenceCouplingSample, "If the ReferenceCouplingSample is set to Null when the model being upload is a non-pseudo reference electrode model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				ReferenceCouplingSample -> Null
			],
			$Failed,
			Messages :> {Error::UREMissingReferenceCouplingSample, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREReferenceCouplingSampleAmbiguousAnalyte -- *)
		Example[{Messages, ReferenceCouplingSample, "If the provided ReferenceCouplingSample's Analytes field has more than one entry, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
				ReferenceCouplingSample -> Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UREReferenceCouplingSampleAmbiguousAnalyte, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={};
				Upload[{
					<|
						Object -> Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Analytes] -> {
							Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]],
							Link[Model[Molecule, "Potassium Chloride"]]
						}
					|>,
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]]},
							{1 Molar, Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]}
						},
						Replace[Analytes] -> {
							Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]
						}
					|>
				}]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[{
					<|
						Object -> Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Analytes] -> {
							Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]
						}
					|>,
					<|
						Object -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]]},
							{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
						},
						Replace[Analytes] -> {
							Link[Model[Molecule, "Potassium Chloride"]]
						}
					|>
				}]
			)
		],

		(* -- UREMismatchingReferenceCouplingSampleMolecule -- *)
		Example[{Messages, "The ReferenceCouplingSample has a different redox coupling molecule from the molecule in ReferenceSolution", "If the redox coupling molecule in the ReferenceCouplingSample is different from the molecule in the provided ReferenceSolution, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				ReferenceSolution -> Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
				ReferenceCouplingSample -> Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UREMismatchingReferenceCouplingSampleMolecule, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URENonNullRecommendedRefreshPeriod -- *)
		Example[{Messages, RecommendedRefreshPeriod, "If the RecommendedRefreshPeriod is specified when the model being upload is a Blank model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
				Blank -> Null,
				RecommendedRefreshPeriod -> 2 Month
			],
			$Failed,
			Messages :> {Error::URENonNullRecommendedRefreshPeriod, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMissingRecommendedRefreshPeriod -- *)
		Example[{Messages, RecommendedRefreshPeriod, "If the RecommendedRefreshPeriod is set to Null when the model being upload is not a Blank reference electrode model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				RecommendedRefreshPeriod -> Null
			],
			$Failed,
			Messages :> {Error::UREMissingRecommendedRefreshPeriod, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URENameExisting -- *)
		Example[{Messages, Name, "If the provided Name is identical with the Name of an existing reference electrode model, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				Name -> "0.1M AgNO3 Ag/Ag+ Reference Electrode"
			],
			$Failed,
			Messages :> {Error::URENameExisting, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMismatchingDefaultStorageCondition -- *)
		Example[{Messages, DefaultStorageCondition, "If the provided DefaultStorageCondition is different from the DefaultStorageCondition of the Reference Solution, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				DefaultStorageCondition -> AmbientStorage,
				ReferenceSolution -> Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]
			],
			$Failed,
			Messages :> {Error::UREMismatchingDefaultStorageCondition, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URESolutionVolumeUnResolvable -- *)
		Example[{Messages, SolutionVolume, "When uploading a new Blank model, if the SolutionVolume is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::URESolutionVolumeUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREDimensionsUnResolvable -- *)
		Example[{Messages, Dimensions, "When uploading a new Blank model, if the Dimensions is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				SolutionVolume -> 10 Milliliter,
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREDimensionsUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREBulkMaterialUnResolvable -- *)
		Example[{Messages, BulkMaterial, "When uploading a new Blank model, if the BulkMaterial is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREBulkMaterialUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URECoatMaterialUnResolvable -- *)
		Example[{Messages, CoatMaterial, "When uploading a new Blank model, if the CoatMaterial is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::URECoatMaterialUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREElectrodeShapeUnResolvable -- *)
		Example[{Messages, ElectrodeShape, "When uploading a new Blank model, if the ElectrodeShape is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREElectrodeShapeUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREWiringConnectorsUnResolvable -- *)
		Example[{Messages, WiringConnectors, "When uploading a new Blank model, if the WiringConnectors is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREWiringConnectorsUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMaxNumberOfUsesUnResolvable -- *)
		Example[{Messages, MaxNumberOfUses, "When uploading a new Blank model, if the MaxNumberOfUses is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREMaxNumberOfUsesUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMinPotentialUnResolvable -- *)
		Example[{Messages, MinPotential, "When uploading a new Blank model, if the MinPotential is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREMinPotentialUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMaxPotentialUnResolvable -- *)
		Example[{Messages, MaxPotential, "When uploading a new Blank model, if the MaxPotential is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREMaxPotentialUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URESonicationSensitiveUnResolvable -- *)
		Example[{Messages, SonicationSensitive, "When uploading a new Blank model, if the SonicationSensitive is not explicitly specified, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt
			],
			$Failed,
			Messages :> {Error::URESonicationSensitiveUnResolvable, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingSolutionVolume -- *)
		Example[{Messages, SolutionVolume, "If the SolutionVolume option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				SolutionVolume -> 1000 Milliliter
			],
			$Failed,
			Messages :> {Error::UREConflictingSolutionVolume, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingDimensions -- *)
		Example[{Messages, Dimensions, "If the Dimensions option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				Dimensions -> {10 Meter, 10 Meter, 100 Meter}
			],
			$Failed,
			Messages :> {Error::UREConflictingDimensions, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingBulkMaterial -- *)
		Example[{Messages, BulkMaterial, "If the BulkMaterial option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				BulkMaterial -> Gold
			],
			$Failed,
			Messages :> {Error::UREConflictingBulkMaterial, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingCoatMaterial -- *)
		Example[{Messages, CoatMaterial, "If the CoatMaterial option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				CoatMaterial -> Gold
			],
			$Failed,
			Messages :> {Error::UREConflictingCoatMaterial, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingElectrodeShape -- *)
		Example[{Messages, ElectrodeShape, "If the ElectrodeShape option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				ElectrodeShape -> Disc
			],
			$Failed,
			Messages :> {Error::UREConflictingElectrodeShape, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingElectrodePackagingMaterial -- *)
		Example[{Messages, ElectrodePackagingMaterial, "If the ElectrodePackagingMaterial option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				ElectrodePackagingMaterial -> Gold
			],
			$Failed,
			Messages :> {Error::UREConflictingElectrodePackagingMaterial, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingWiringConnectors -- *)
		Example[{Messages, WiringConnectors, "If the WiringConnectors option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				WiringConnectors -> {{"Another Wiring Connector", ExposedWire, None}}
			],
			$Failed,
			Messages :> {Error::UREConflictingWiringConnectors, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingWiringDiameters -- *)
		Example[{Messages, WiringDiameters, "If the WiringDiameters option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				WiringDiameters -> {1 Millimeter}
			],
			$Failed,
			Messages :> {Error::UREConflictingWiringDiameters, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingWiringLength -- *)
		Example[{Messages, WiringLength, "If the WiringLength option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				WiringLength -> 1000 Meter
			],
			$Failed,
			Messages :> {Error::UREConflictingWiringLength, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingSonicationSensitive -- *)
		Example[{Messages, SonicationSensitive, "If the SonicationSensitive option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREConflictingSonicationSensitive, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingWettedMaterials -- *)
		Example[{Messages, WettedMaterials, "If the WettedMaterials option does not match with the template reference electrode model's blank model, or the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				WettedMaterials -> {Gold, Platinum}
			],
			$Failed,
			Messages :> {Error::UREConflictingWettedMaterials, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingMaxNumberOfUses -- *)
		Example[{Messages, MaxNumberOfUses, "If the MaxNumberOfUses option is not less or equal to the MaxNumberOfUses defined by the template reference electrode model's blank model, or by the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MaxNumberOfUses -> 100000
			],
			$Failed,
			Messages :> {Error::UREConflictingMaxNumberOfUses, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingMaxNumberOfPolishings -- *)
		Example[{Messages, MaxNumberOfPolishings, "If the MaxNumberOfPolishings option is not less or equal to the MaxNumberOfPolishings defined by the template reference electrode model's blank model, or by the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MaxNumberOfPolishings -> 100000
			],
			$Failed,
			Messages :> {Error::UREConflictingMaxNumberOfPolishings, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingMaxPotential -- *)
		Example[{Messages, MaxPotential, "If the MaxPotential option is not less or equal to the MaxPotential defined by the template reference electrode model's blank model, or by the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MaxPotential -> 300 Volt
			],
			$Failed,
			Messages :> {Error::UREConflictingMaxPotential, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREConflictingMinPotential -- *)
		Example[{Messages, MinPotential, "If the MinPotential option is not greater or equal to the MinPotential defined by the template reference electrode model's blank model, or by the blank model specified by the Blank option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MinPotential -> -300 Volt
			],
			$Failed,
			Messages :> {Error::UREConflictingMinPotential, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREWiringParametersMismatchLengths -- *)
		Example[{Messages, "WiringConnectors and WiringDiameters do not have the same lengths", "When upload a new blank model, if the provided WiringConnectors and WiringDiameters do not have the same lengths, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				WiringDiameters -> {10 Millimeter, 20 Millimeter},
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREWiringParametersMismatchLengths, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- URENonNullWiringDiameterForNonExposedWire -- *)
		Example[{Messages, "Wiring diameter not Null for non-ExposedWire wiring connectors", "When upload a new blank model, if the provided WiringDiameters contains a non-Null diameter for a corresponding non-ExposedWire wiring connector, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				WiringConnectors -> {{"Test Wiring Connector 1", ExposedWire, None}, {"Test Wiring Connector 2", ElectraSynContactElectrode, None}},
				WiringDiameters -> {10 Millimeter, 20 Millimeter},
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::URENonNullWiringDiameterForNonExposedWire, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMissingWiringDiameterForExposedWire -- *)
		Example[{Messages, "WiringConnectors and WiringDiameters do not have the same lengths", "When upload a new blank model, if the provided WiringConnectors and WiringDiameters do not have the same lengths, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				WiringConnectors -> {{"Test Wiring Connector 1", ExposedWire, None}, {"Test Wiring Connector 2", ElectraSynContactElectrode, None}},
				WiringDiameters -> {Null, Null},
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				ElectrodeShape -> Rod,
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREMissingWiringDiameterForExposedWire, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREMaxNumberOfPolishingsGreaterThanMaxNumberOfUses -- *)
		Example[{Messages, "MaxNumberOfPolishings greater than MaxNumberOfUses", "If the MaxNumberOfPolishings option is greater than the MaxNumberOfUses option, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MaxNumberOfUses -> 30,
				MaxNumberOfPolishings -> 40
			],
			$Failed,
			Messages :> {Error::UREMaxNumberOfPolishingsGreaterThanMaxNumberOfUses, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREWettedMaterialsNotContainCoatMaterial -- *)
		Example[{Messages, "WettedMaterials does not contain CoatMaterial", "When upload a new blank model, if the provided WettedMaterials does not contain the provided CoatMaterial when CoatMaterial is not set to Null, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				BulkMaterial -> Gold,
				CoatMaterial -> Silver,
				WettedMaterials -> {Gold},
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREWettedMaterialsNotContainCoatMaterial, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREWettedMaterialsNotContainBulkMaterial -- *)
		Example[{Messages, "WettedMaterials does not contain BulkMaterial", "When upload a new blank model, if the provided WettedMaterials does not contain the provided BulkMaterial when CoatMaterial is set to Null, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				BulkMaterial -> Gold,
				CoatMaterial -> Null,
				WettedMaterials -> {Silver},
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREWettedMaterialsNotContainBulkMaterial, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREWettedMaterialsNotContainElectrodePackagingMaterial -- *)
		Example[{Messages, "WettedMaterials does not contain ElectrodePackagingMaterial", "When upload a new blank model, if the provided WettedMaterials does not contain the provided ElectrodePackagingMaterial when ElectrodePackagingMaterial is set to Null, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				BulkMaterial -> Silver,
				CoatMaterial -> Null,
				ElectrodePackagingMaterial -> Platinum,
				WettedMaterials -> {Silver},
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREWettedMaterialsNotContainElectrodePackagingMaterial, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREIncompatibleMaterialsContainCoatMaterial -- *)
		Example[{Messages, "IncompatibleMaterials contains CoatMaterial", "When upload a new blank model, if the provided IncompatibleMaterials contains the provided CoatMaterial when CoatMaterial is not Null, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				BulkMaterial -> Silver,
				CoatMaterial -> Gold,
				ElectrodePackagingMaterial -> Platinum,
				IncompatibleMaterials -> {Gold},
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREIncompatibleMaterialsContainCoatMaterial, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREIncompatibleMaterialsContainBulkMaterial -- *)
		Example[{Messages, "IncompatibleMaterials contains BulkMaterial", "When upload a new blank model, if the provided IncompatibleMaterials contains the provided BulkMaterial, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				BulkMaterial -> Silver,
				CoatMaterial -> Gold,
				ElectrodePackagingMaterial -> Platinum,
				IncompatibleMaterials -> {Silver},
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREIncompatibleMaterialsContainBulkMaterial, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- UREIncompatibleMaterialsContainElectrodePackagingMaterial -- *)
		Example[{Messages, "IncompatibleMaterials contains ElectrodePackagingMaterial", "When upload a new blank model, if the provided IncompatibleMaterials contains the provided ElectrodePackagingMaterial when ElectrodePackagingMaterial is not Null, an error will be thrown:"},
			UploadReferenceElectrodeModel[
				Blank -> Null,
				ReferenceElectrodeType -> "Bare-Ag",
				BulkMaterial -> Silver,
				CoatMaterial -> Gold,
				ElectrodePackagingMaterial -> Platinum,
				IncompatibleMaterials -> {Platinum},
				SolutionVolume -> 10 Milliliter,
				Dimensions -> {2 Centimeter, 2 Centimeter, 20 Centimeter},
				ElectrodeShape -> Rod,
				WiringConnectors -> {{"Test Wiring Connector 1", ElectraSynContactElectrode, None}},
				MaxNumberOfUses -> 100,
				MinPotential -> -2 Volt,
				MaxPotential -> 2 Volt,
				SonicationSensitive -> False
			],
			$Failed,
			Messages :> {Error::UREIncompatibleMaterialsContainElectrodePackagingMaterial, Error::InvalidOption},
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],


		(* ---------------------- *)
		(* -- GENERAL MESSAGES -- *)
		(* ---------------------- *)

		(* -- rounding option precision -- *)
		Example[{Messages, "Options with too high precisions", "If an option is given with higher precision than the experiment setup can achieve, the value is rounded to the experiment precision and a warning is displayed:"},
			Module[{newModel, voqResult},
				newModel = UploadReferenceElectrodeModel[
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
					MinPotential -> -1.1 Millivolt
				];
				voqResult = ValidObjectQ[newModel];
				{newModel, voqResult}
			],
			{ObjectP[Model[Item, Electrode, ReferenceElectrode]], True},
			Messages :> {Warning::InstrumentPrecision},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		]


		(* =========== *)
		(* == TESTS == *)
		(* =========== *)

	},


	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp:>(
		Module[{objects, existingObjects},
			ClearMemoization[];
			objects=Quiet[Cases[
				Flatten[{
					(* Test notebook *)
					Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID],

					(* Test bench *)
					Object[Container, Bench, "Example bench for UploadReferenceElectrodeModel tests" <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution 2 for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution 3 for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for UploadReferenceElectrodeModel tests" <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					fakeBench,

					(* Model Molecules and Samples *)
					solventSampleModelObject, fakeMolecule, fakeSolventSampleModel, referenceSolution, referenceCouplingSample, referenceSolution2, referenceSolution3,

					(* Model Reference Electrodes *)
					referenceElectrodeModel1,

					(* Object Reference Electrodes *)
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6
				},
				(* create the test notebook *)
				Upload[<|
					Type -> Object[LaboratoryNotebook],
					Name -> "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID
				|>];

				(* set up fake bench as a location for the vessel *)
				fakeBench = Upload[
					<|
						Type->Object[Container, Bench],
						Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name->"Example bench for UploadReferenceElectrodeModel tests" <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up test reference electrode model *)
				referenceElectrodeModel1 = Upload[<|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					DeveloperObject -> True,
					Name -> "Example Reference Electrode Model for UploadReferenceElectrodeModel tests" <> $SessionUUID,
					Replace[Synonyms] -> {"Example Reference Electrode Model for UploadReferenceElectrodeModel tests" <> $SessionUUID},
					Dimensions -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					DefaultStorageCondition -> Link[Model[StorageCondition,"Ambient Storage, Flammable"]],
					MaxNumberOfUses -> 200,
					Replace[WettedMaterials] -> {Silver,Glass},
					Replace[WiringConnectors] -> {{"Electrode Wiring Connector", ElectraSynElectrodeThreadedPlug, None}},
					WiringLength -> 64 Millimeter,

					BulkMaterial -> Silver,
					Coated -> False,
					ElectrodeShape -> Rod,
					ElectrodePackagingMaterial -> Glass,
					MinPotential -> -2.5 Volt,
					MaxPotential -> 2.5 Volt,
					MaxNumberOfPolishings -> 50,
					SonicationSensitive -> True,
					Preparable -> True,

					(* ReferenceElectrode Fields *)
					ReferenceElectrodeType-> "Ag/Ag+",
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]],
					RecommendedRefreshPeriod -> 2 Month,
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]],
					SolutionVolume -> 0.5 Milliliter,
					ReferenceCouplingSample -> Link[Model[Sample, "Silver nitrate"]]
				|>];

				(* set up test solvent sample and solvent molecule *)
				solventSampleModelObject = CreateID[Model[Sample]];

				fakeMolecule = Upload[Association[
					Type -> Model[Molecule],
					Name -> "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID,
					DefaultSampleModel -> Link[solventSampleModelObject]
				]];

				fakeSolventSampleModel = Upload[Association[
					Object -> solventSampleModelObject,
					Name -> "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID,
					Replace[Composition] -> {{100 VolumePercent, Link[fakeMolecule]}},
					Replace[Analytes] -> {
						Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]
					}
				]];

				(* set up test reference solution and reference coupling sample models *)
				referenceSolution = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID,

					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
					},

					Solvent -> Link[Model[Sample, "Milli-Q water"]],

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				(* set up test reference solution and reference coupling sample models with empty Analytes and different composition *)
				referenceSolution2 = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example ReferenceSolution 2 for UploadReferenceElectrodeModel tests" <> $SessionUUID,

					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]}
					},

					Solvent -> Link[Model[Sample, "Milli-Q water"]],

					Replace[Analytes] -> {
					}
				]];

				(* set up test reference solution and reference coupling sample models with empty Analytes and different composition *)
				referenceSolution3 = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example ReferenceSolution 3 for UploadReferenceElectrodeModel tests" <> $SessionUUID,

					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID]]}
					},

					Solvent -> Link[Model[Sample, "Milli-Q water"]],

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]],
						Link[Model[Molecule,"Water"]]
					}
				]];

				referenceCouplingSample = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example Reference Coupling Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID,

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				(* set up fake reference electrodes for our tests *)
				{
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6
				}=UploadSample[
					{
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.01M AgNO3 Ag/Ag+ Reference Electrode"],
						referenceElectrodeModel1
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status->
						{
							Available,
							Available,
							Available,
							Available,
							Available,
							Available
						},
					Name->
						{
							"Example bare reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID,
							"Example AgCl reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID,
							"Example Pseudo Ag reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID,
							"Example Ag/Ag+ high concentration reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID,
							"Example Ag/Ag+ low concentration reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID,
							"Example model reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID
						}
				];

				(* upload the test objects *)
				Upload[
					<|
						Object->#,
						AwaitingStorageUpdate->Null
					|> &/@Cases[
						Flatten[
							{
								(* Object Reference Electrodes *)
								referenceElectrode1, referenceElectrode2, referenceElectrode3,
								referenceElectrode4, referenceElectrode5, referenceElectrode6
							}
						],
						ObjectP[]
					]
				];
			]
		]
	),
	SymbolTearDown:>(
		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					(* Test notebook *)
					Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID],

					(* Test bench *)
					Object[Container, Bench, "Example bench for UploadReferenceElectrodeModel tests" <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution 2 for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution 3 for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for UploadReferenceElectrodeModel tests" <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for UploadReferenceElectrodeModel tests" <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for UploadReferenceElectrodeModel tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		]
	)
];




(* ::Subsection:: *)
(*UploadReferenceElectrodeModelOptions*)


(* ------------------------------------------ *)
(* -- UploadReferenceElectrodeModelOptions -- *)
(* ------------------------------------------ *)


DefineTests[UploadReferenceElectrodeModelOptions,
	{
		Example[{Basic, "Display the option values which will be used when creating a new reference electrode model:"},
			UploadReferenceElectrodeModelOptions[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MinPotential -> -2 Volt
			],
			_Grid,
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID]}
		],
		Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
			UploadReferenceElectrodeModelOptions[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MinPotential -> -3 Volt
			],
			_Grid,
			Messages:>{Error::UREConflictingMinPotential, Error::InvalidOption},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID]}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
			UploadReferenceElectrodeModelOptions[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MinPotential -> -2 Volt,
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..},
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID]}
		]
	},


	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp:>(
		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					(* Test notebook *)
					Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],

					Object[Container, Bench, "Example bench for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					fakeBench,

					(* Model Molecules and Samples *)
					solventSampleModelObject, fakeMolecule, fakeSolventSampleModel, referenceSolution, referenceCouplingSample,

					(* Model Reference Electrodes *)
					referenceElectrodeModel1,

					(* Object Reference Electrodes *)
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6
				},
				(* create the test notebook *)
				Upload[<|
					Type -> Object[LaboratoryNotebook],
					Name -> "Test notebook for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID
				|>];

				(* set up fake bench as a location for the vessel *)
				fakeBench = Upload[
					<|
						Type->Object[Container, Bench],
						Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name->"Example bench for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up test reference electrode model *)
				referenceElectrodeModel1 = Upload[<|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					DeveloperObject -> True,
					Name -> "Example Reference Electrode Model for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,
					Replace[Synonyms] -> {"Example Reference Electrode Model for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID},
					Dimensions -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					DefaultStorageCondition -> Link[Model[StorageCondition,"Ambient Storage, Flammable"]],
					MaxNumberOfUses -> 200,
					Replace[WettedMaterials] -> {Silver,Glass},
					Replace[WiringConnectors] -> {{"Electrode Wiring Connector", ElectraSynElectrodeThreadedPlug, None}},
					WiringLength -> 64 Millimeter,

					BulkMaterial -> Silver,
					Coated -> False,
					ElectrodeShape -> Rod,
					ElectrodePackagingMaterial -> Glass,
					MinPotential -> -2.5 Volt,
					MaxPotential -> 2.5 Volt,
					MaxNumberOfPolishings -> 50,
					SonicationSensitive -> True,
					Preparable -> True,

					(* ReferenceElectrode Fields *)
					ReferenceElectrodeType-> "Ag/Ag+",
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]],
					RecommendedRefreshPeriod -> 2 Month,
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]],
					SolutionVolume -> 1 Milliliter,
					ReferenceCouplingSample -> Link[Model[Sample, "Silver nitrate"]]
				|>];

				(* set up test solvent sample and solvent molecule *)
				solventSampleModelObject = CreateID[Model[Sample]];

				fakeMolecule = Upload[Association[
					Type -> Model[Molecule],
					Name -> "Example Molecule for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,
					DefaultSampleModel -> Link[solventSampleModelObject]
				]];

				fakeSolventSampleModel = Upload[Association[
					Object -> solventSampleModelObject,
					Name -> "Example Solvent Sample for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,
					Replace[Composition] -> {{100 VolumePercent, Link[fakeMolecule]}},
					Replace[Analytes] -> {
						Link[Model[Molecule, "Example Molecule for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID]]
					}
				]];

				(* set up test reference solution and reference coupling sample models *)
				referenceSolution = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example ReferenceSolution for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,

					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
					},

					Solvent -> Link[Model[Sample, "Milli-Q water"]],

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				referenceCouplingSample = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example Reference Coupling Sample for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				(* set up fake reference electrodes for our tests *)
				{
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6
				}=UploadSample[
					{
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.01M AgNO3 Ag/Ag+ Reference Electrode"],
						referenceElectrodeModel1
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status->
						{
							Available,
							Available,
							Available,
							Available,
							Available,
							Available
						},
					Name->
						{
							"Example bare reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,
							"Example AgCl reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,
							"Example Pseudo Ag reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,
							"Example Ag/Ag+ high concentration reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,
							"Example Ag/Ag+ low concentration reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID,
							"Example model reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID
						}
				];

				(* upload the test objects *)
				Upload[
					<|
						Object->#,
						AwaitingStorageUpdate->Null
					|> &/@Cases[
						Flatten[
							{
								(* Object Reference Electrodes *)
								referenceElectrode1, referenceElectrode2, referenceElectrode3,
								referenceElectrode4, referenceElectrode5, referenceElectrode6
							}
						],
						ObjectP[]
					]
				];
			]
		]
	),
	SymbolTearDown:>(
		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					(* Test notebook *)
					Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],

					Object[Container, Bench, "Example bench for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for UploadReferenceElectrodeModelOptions tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		]
	)
];


(* ::Subsection:: *)
(*ValidUploadReferenceElectrodeModelQ*)


(* ----------------------------------------- *)
(* -- ValidUploadReferenceElectrodeModelQ -- *)
(* ----------------------------------------- *)


DefineTests[ValidUploadReferenceElectrodeModelQ,
	{
		Example[{Basic, "Verify that the new reference electode can be run without issues:"},
			ValidUploadReferenceElectrodeModelQ[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MinPotential -> -2 Volt
			],
			True,
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]}
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidUploadReferenceElectrodeModelQ[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MinPotential -> -3 Volt
			],
			False,
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]}
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidUploadReferenceElectrodeModelQ[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MinPotential -> -2 Volt,
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary,
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]}
		],
		Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
			ValidUploadReferenceElectrodeModelQ[
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				MinPotential -> -2 Volt,
				Verbose->True
			],
			True,
			Stubs:>{$Notebook = Object[LaboratoryNotebook, "Test notebook for UploadReferenceElectrodeModel tests" <> $SessionUUID]}
		]
	},


	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp:>(
		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					(* Test notebook *)
					Object[LaboratoryNotebook, "Test notebook for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],

					Object[Container, Bench, "Example bench for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					fakeBench,

					(* Model Molecules and Samples *)
					solventSampleModelObject, fakeMolecule, fakeSolventSampleModel, referenceSolution, referenceCouplingSample,

					(* Model Reference Electrodes *)
					referenceElectrodeModel1,

					(* Object Reference Electrodes *)
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6
				},
				(* create the test notebook *)
				Upload[<|
					Type -> Object[LaboratoryNotebook],
					Name -> "Test notebook for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID
				|>];

				(* set up fake bench as a location for the vessel *)
				fakeBench = Upload[
					<|
						Type->Object[Container, Bench],
						Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name->"Example bench for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up test reference electrode model *)
				referenceElectrodeModel1 = Upload[<|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					DeveloperObject -> True,
					Name -> "Example Reference Electrode Model for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,
					Replace[Synonyms] -> {"Example Reference Electrode Model for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID},
					Dimensions -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					DefaultStorageCondition -> Link[Model[StorageCondition,"Ambient Storage, Flammable"]],
					MaxNumberOfUses -> 200,
					Replace[WettedMaterials] -> {Silver,Glass},
					Replace[WiringConnectors] -> {{"Electrode Wiring Connector", ElectraSynElectrodeThreadedPlug, None}},
					WiringLength -> 64 Millimeter,

					BulkMaterial -> Silver,
					Coated -> False,
					ElectrodeShape -> Rod,
					ElectrodePackagingMaterial -> Glass,
					MinPotential -> -2.5 Volt,
					MaxPotential -> 2.5 Volt,
					MaxNumberOfPolishings -> 50,
					SonicationSensitive -> True,
					Preparable -> True,

					(* ReferenceElectrode Fields *)
					ReferenceElectrodeType-> "Ag/Ag+",
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]],
					RecommendedRefreshPeriod -> 2 Month,
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]],
					SolutionVolume -> 1 Milliliter,
					ReferenceCouplingSample -> Link[Model[Sample, "Silver nitrate"]]
				|>];

				(* set up test solvent sample and solvent molecule *)
				solventSampleModelObject = CreateID[Model[Sample]];

				fakeMolecule = Upload[Association[
					Type -> Model[Molecule],
					Name -> "Example Molecule for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,
					DefaultSampleModel -> Link[solventSampleModelObject]
				]];

				fakeSolventSampleModel = Upload[Association[
					Object -> solventSampleModelObject,
					Name -> "Example Solvent Sample for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,
					Replace[Composition] -> {{100 VolumePercent, Link[fakeMolecule]}},
					Replace[Analytes] -> {
						Link[Model[Molecule, "Example Molecule for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID]]
					}
				]];

				(* set up test reference solution and reference coupling sample models *)
				referenceSolution = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example ReferenceSolution for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,

					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
					},

					Solvent -> Link[Model[Sample, "Milli-Q water"]],

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				referenceCouplingSample = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example Reference Coupling Sample for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				(* set up fake reference electrodes for our tests *)
				{
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6
				}=UploadSample[
					{
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.01M AgNO3 Ag/Ag+ Reference Electrode"],
						referenceElectrodeModel1
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status->
						{
							Available,
							Available,
							Available,
							Available,
							Available,
							Available
						},
					Name->
						{
							"Example bare reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,
							"Example AgCl reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,
							"Example Pseudo Ag reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,
							"Example Ag/Ag+ high concentration reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,
							"Example Ag/Ag+ low concentration reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID,
							"Example model reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID
						}
				];

				(* upload the test objects *)
				Upload[
					<|
						Object->#,
						AwaitingStorageUpdate->Null
					|> &/@Cases[
						Flatten[
							{
								(* Object Reference Electrodes *)
								referenceElectrode1, referenceElectrode2, referenceElectrode3,
								referenceElectrode4, referenceElectrode5, referenceElectrode6
							}
						],
						ObjectP[]
					]
				];
			]
		]
	),
	SymbolTearDown:>(
		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					(* Test notebook *)
					Object[LaboratoryNotebook, "Test notebook for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],

					Object[Container, Bench, "Example bench for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for ValidUploadReferenceElectrodeModelQ tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		]
	)
];