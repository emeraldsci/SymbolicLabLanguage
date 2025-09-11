(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentCyclicVoltammetry*)


DefineTests[ExperimentCyclicVoltammetry,
	{
		Example[{Basic, "Perform cyclic voltammetry measurements on a single sample:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "Input as {Position,Container}"},
			ExperimentCyclicVoltammetry[
				{"A1", Object[Container, Vessel,"Example sample container 15 for CyclicVoltammetry tests" <> $SessionUUID]}
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== Additional ==== *)
		Test["A test to see WorkingElectrodePolishWashingSolutions and WorkingElectrodeWashingSolutions fields can be successfully uploaded into the protocol:",
			ExperimentCyclicVoltammetry[{
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]
			},
				PreparedSample -> {False, True, False},
				PolishWorkingElectrode -> {True, False, False},
				PretreatElectrodes-> {False, True, True},
				Solvent-> {Model[Sample, "Milli-Q water"], Automatic, Automatic},
				WorkingElectrodeWashing -> {True, False, True},
				ElectrolyteSolution -> {
					Null,
					Object[Sample,"Example 0.1M [NBu4][PF6] in acetonitrile electrolyte solution for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example 0.1M [NBu4][PF6] in acetonitrile electrolyte solution for CyclicVoltammetry tests" <> $SessionUUID]
				},
				PretreatmentSparging -> {Null, True, False},
				Sparging -> {False, False, True},
				SpargingPreBubbler -> {Null, Null, True},
				NumberOfReplicates-> 2,
				InternalStandard -> {None, None, Model[Sample, "Ferrocene"]}
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ============= *)
		(* == OPTIONS == *)
		(* ============= *)

		(* -- Instrument -- *)
		Example[{Options, Instrument, "Specify the measurement device on which the protocol is to be run:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Instrument -> Model[Instrument, Reactor, Electrochemical, "IKA ElectraSyn 2.0"],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, Reactor, Electrochemical, "IKA ElectraSyn 2.0"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SampleLabel -- *)
		Example[{Options, SampleLabel, "Specify the measurement device on which the protocol is to be run:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				SampleLabel -> "Nick said he has a fancy sample",
				Output -> Options
			];
			Lookup[options, SampleLabel],
			"Nick said he has a fancy sample",
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SampleContainerLabel -- *)
		Example[{Options, SampleContainerLabel, "Specify the measurement device on which the protocol is to be run:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				SampleContainerLabel -> "This is where Nick stores his fancy sample",
				Output -> Options
			];
			Lookup[options, SampleContainerLabel],
			"This is where Nick stores his fancy sample",
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== LoadingSample volume options ==== *)
		(* -- PreparedSample -- *)
		Example[{Options, PreparedSample, "Set PreparedSample to True to indicate the input sample is a fully prepared solution that includes the target analyte, an electrolyte chemical, and an optional internal standard dissolved in a solvent. A fully prepared solution is ready for cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Output -> Options
			];
			Lookup[options, PreparedSample],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- NumberOfReplicates -- *)
		Example[{Options, NumberOfReplicates, "Use NumberOfReplicates to specify the number of time to repeat cyclic voltammetry measurement on each provided sample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfReplicates -> 3,
				Output -> Options
			];
			Lookup[options, NumberOfReplicates],
			3,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ReactionVessel -- *)
		Example[{Options, ReactionVessel, "Set ReactionVessel to a container model or object to be used to hold the prepared sample solution for cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ReactionVessel],
			ObjectReferenceP[Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleVolume -- *)
		Example[{Options, LoadingSampleVolume, "Set LoadingSampleVolume to a volume by which the prepared sample solution is added into the ReactionVessel before cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleVolume -> 15 Milliliter,
				Output -> Options
			];
			Lookup[options, LoadingSampleVolume],
			15 Milliliter,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleVolume, "Set LoadingSampleVolume -> Automatic to use 60% of the ReactionVessel MaxVolume as the loading volume for the prepared sample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleVolume -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleVolume],
			12.0 Milliliter,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SolventVolume -- *)
		Example[{Options, SolventVolume, "Set SolventVolume to a volume by which the solvent solution is used prepare the loading sample solution before cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleVolume -> 15 Milliliter,
				SolventVolume -> 15 Milliliter,
				Output -> Options
			];
			Lookup[options, SolventVolume],
			15 Milliliter,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, SolventVolume, "Set SolventVolume -> Automatic to use 60% of the ReactionVessel MaxVolume as the solvent volume to prepare the loading sample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				SolventVolume -> Automatic,
				Output -> Options
			];
			Lookup[options, SolventVolume],
			12.0 Milliliter,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, SolventVolume, "Set SolventVolume -> Automatic to use the provided LoadingSampleVolume as the solvent volume to prepare the loading sample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleVolume -> 15 Milliliter,
				SolventVolume -> Automatic,
				Output -> Options
			];
			Lookup[options, SolventVolume],
			15 Milliliter,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== Working, Counter Electrode and ElectrodeCap ==== *)
		(* -- WorkingElectrode -- *)
		Example[{Options, WorkingElectrode, "Set WorkingElectrode to an electrode model or object to be used in the cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrode -> Model[Item, Electrode, "IKA Glassy Carbon 3 mm Disc Working Electrode"],
				Output -> Options
			];
			Lookup[options, WorkingElectrode],
			ObjectReferenceP[Model[Item, Electrode, "IKA Glassy Carbon 3 mm Disc Working Electrode"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- CounterElectrode -- *)
		Example[{Options, CounterElectrode, "Set CounterElectrode to an electrode model or object to be used in the cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				CounterElectrode -> Model[Item, Electrode, "IKA Platinum Coated Copper Plate Electrode"],
				Output -> Options
			];
			Lookup[options, CounterElectrode],
			ObjectReferenceP[Model[Item, Electrode, "IKA Platinum Coated Copper Plate Electrode"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ElectrodeCap -- *)
		Example[{Options, ElectrodeCap, "Set ElectrodeCap to an electrode cap model or object to be used in the cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrodeCap -> Object[Item, Cap, ElectrodeCap, "Example electrode cap for CyclicVoltammetry tests" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ElectrodeCap],
			ObjectReferenceP[Object[Item, Cap, ElectrodeCap, "Example electrode cap for CyclicVoltammetry tests" <> $SessionUUID]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== Polishing parameter options ==== *)
		(* -- PolishWorkingElectrode -- *)
		Example[{Options, PolishWorkingElectrode, "Set PolishWorkingElectrode to True to polish the working electrode prior to use:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				Output -> Options
			];
			Lookup[options, PolishWorkingElectrode],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PolishingPads -- *)
		Example[{Options, PolishingPads, "Set the series of polishing pads to use for the working electrode polishing process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingPads -> {Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]},
				Output -> Options
			];
			Lookup[options, PolishingPads],
			ObjectReferenceP/@{Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, PolishingPads, "Set PolishingPads -> Automatic to use the default series of polishing pads for the working electrode polishing process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingPads -> Automatic,
				Output -> Options
			];
			Lookup[options, PolishingPads],
			ObjectReferenceP/@{Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PolishingSolutions -- *)
		Example[{Options, PolishingSolutions, "Set the series of polishing solutions to use with the PolishingPads for the working electrode polishing process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingPads -> {Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]},
				PolishingSolutions -> {Model[Sample, "1 um diamond polish, KitComponent"], Model[Sample, "0.05 um Polishing alumina, KitComponent"]},
				Output -> Options
			];
			Lookup[options, PolishingSolutions],
			ObjectReferenceP/@{Model[Sample, "1 um diamond polish, KitComponent"], Model[Sample, "0.05 um Polishing alumina, KitComponent"]},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, PolishingSolutions, "Set PolishingSolutions -> Automatic to use the default polishing solutions specified in the PolishingPads:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingPads -> {Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]},
				PolishingSolutions -> Automatic,
				Output -> Options
			];
			Lookup[options, PolishingSolutions],
			ObjectReferenceP/@{Model[Sample, "1 um diamond polish, KitComponent"], Model[Sample, "0.05 um Polishing alumina, KitComponent"]},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- NumberOfPolishingSolutionDroplets -- *)
		Example[{Options, NumberOfPolishingSolutionDroplets, "Set the number of polishing solution droplets put on the corresponding polishing pad for the working electrode polishing process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingPads -> {Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]},
				PolishingSolutions -> {Model[Sample, "1 um diamond polish, KitComponent"], Model[Sample, "0.05 um Polishing alumina, KitComponent"]},
				NumberOfPolishingSolutionDroplets -> {3, 3},
				Output -> Options
			];
			Lookup[options, NumberOfPolishingSolutionDroplets],
			{3, 3},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, NumberOfPolishingSolutionDroplets, "Set the NumberOfPolishingSolutionDroplets -> Automatic, 2 droplets of polishing solutions will be put on the corresponding polishing pad for the working electrode polishing process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingPads -> {Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]},
				PolishingSolutions -> {Model[Sample, "1 um diamond polish, KitComponent"], Model[Sample, "0.05 um Polishing alumina, KitComponent"]},
				NumberOfPolishingSolutionDroplets -> Automatic,
				Output -> Options
			];
			Lookup[options, NumberOfPolishingSolutionDroplets],
			{2, 2},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- NumberOfPolishings -- *)
		Example[{Options, NumberOfPolishings, "Set the number of polishing cycles will be performed for each polishing pad during the working electrode polishing process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingPads -> {Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]},
				PolishingSolutions -> {Model[Sample, "1 um diamond polish, KitComponent"], Model[Sample, "0.05 um Polishing alumina, KitComponent"]},
				NumberOfPolishings -> {2, 1},
				Output -> Options
			];
			Lookup[options, NumberOfPolishings],
			{2, 1},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, NumberOfPolishings, "Set the NumberOfPolishings -> Automatic, 1 polishing cycle will be performed for each polishing pad during the working electrode polishing process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingPads -> {Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]},
				PolishingSolutions -> {Model[Sample, "1 um diamond polish, KitComponent"], Model[Sample, "0.05 um Polishing alumina, KitComponent"]},
				NumberOfPolishings -> Automatic,
				Output -> Options
			];
			Lookup[options, NumberOfPolishings],
			{1, 1},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== Sonication parameter options ==== *)
		(* -- WorkingElectrodeSonication -- *)
		Example[{Options, WorkingElectrodeSonication, "Set WorkingElectrodeSonication to True to sonicate the working electrode in \"Milli-Q water\" to remove any minor deposits prior to use:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeSonication -> True,
				Output -> Options
			];
			Lookup[options, WorkingElectrodeSonication],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- WorkingElectrodeSonicationTime -- *)
		Example[{Options, WorkingElectrodeSonicationTime, "Set the duration for the working electrode sonication process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeSonication -> True,
				WorkingElectrodeSonicationTime -> 25 Second,
				Output -> Options
			];
			Lookup[options, WorkingElectrodeSonicationTime],
			25 Second,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, WorkingElectrodeSonicationTime, "Set WorkingElectrodeSonicationTime -> Automatic to set a duration of 30 seconds for the working electrode sonication process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeSonication -> True,
				WorkingElectrodeSonicationTime -> Automatic,
				Output -> Options
			];
			Lookup[options, WorkingElectrodeSonicationTime],
			30 Second,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- WorkingElectrodeSonicationTemperature -- *)
		Example[{Options, WorkingElectrodeSonicationTemperature, "Set the temperature for the working electrode sonication process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeSonication -> True,
				WorkingElectrodeSonicationTemperature -> 45 Celsius,
				Output -> Options
			];
			Lookup[options, WorkingElectrodeSonicationTemperature],
			45 Celsius,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, WorkingElectrodeSonicationTemperature, "Set WorkingElectrodeSonicationTemperature -> Automatic to set a temperature of 25 degree Celsius for the working electrode sonication process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeSonication -> True,
				WorkingElectrodeSonicationTemperature -> Automatic,
				Output -> Options
			];
			Lookup[options, WorkingElectrodeSonicationTemperature],
			25 Celsius,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== Electrode washing options ==== *)
		(* -- WorkingElectrodeWashing -- *)
		Example[{Options, WorkingElectrodeWashing, "Set WorkingElectrodeWashing to True to washing the working electrode with \"Milli-Q water\" and methanol to remove any minor deposits prior to use. The WorkingElectrodeWashing is defaulted to True:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeWashing -> True,
				Output -> Options
			];
			Lookup[options, WorkingElectrodeWashing],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- WorkingElectrodeWashingCycles -- *)
		Example[{Options, WorkingElectrodeWashingCycles, "Set the number of cycles of \"Milli-Q water\" and methanol washings for the working electrode washing process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeWashing -> True,
				WorkingElectrodeWashingCycles -> 2,
				Output -> Options
			];
			Lookup[options, WorkingElectrodeWashingCycles],
			2,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, WorkingElectrodeWashingCycles, "Set WorkingElectrodeWashingCycles -> Automatic to set a single washing cycle for the working electrode washing process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeWashing -> True,
				WorkingElectrodeWashingCycles -> Automatic,
				Output -> Options
			];
			Lookup[options, WorkingElectrodeWashingCycles],
			1,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- CounterElectrodeWashing -- *)
		Example[{Options, CounterElectrodeWashing, "Set CounterElectrodeWashing to True (default value) to washing the counter electrode with \"Milli-Q water\" and methanol to remove any minor deposits prior to use. The CounterElectrodeWashing is defaulted to True:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				CounterElectrodeWashing -> True,
				Output -> Options
			];
			Lookup[options, CounterElectrodeWashing],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== Analyte related options ==== *)

		(* -- Analyte Option -- *)
		Example[{Options, Analyte, "Use the Analyte option to specify the molecule of interest in the input sample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Analyte -> Model[Molecule, "Ferrocene"],
				Output -> Options
			];
			Lookup[options, Analyte],
			ObjectReferenceP[Model[Molecule, "Ferrocene"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, Analyte, "Set Analyte -> Automatic to automatically identify the molecule of interest in the input sample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Analyte -> Automatic,
				Output -> Options
			];
			Lookup[options, Analyte],
			ObjectReferenceP[Model[Molecule, "Ferrocene"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SampleAmount Option -- *)
		Example[{Options, SampleAmount, "Use the SampleAmount option to specify the mass amount of the input solid sample to use for the preparation of the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				SampleAmount -> 5.7 Milligram,
				Output -> Options
			];
			Lookup[options, SampleAmount],
			5.7 Milligram,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, SampleAmount, "Set SampleAmount -> Automatic to use a sample mass amount that leads to an analyte concentration of 5 Millimolar in the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				SampleAmount -> Automatic,
				Output -> Options
			];
			Lookup[options, SampleAmount],
			5.7 Milligram,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleTargetConcentration Option -- *)
		Example[{Options, LoadingSampleTargetConcentration, "Use the LoadingSampleTargetConcentration option to specify the analyte concentration to user for the preparation of the LoadingSample for cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleTargetConcentration -> 10 Millimolar,
				Output -> Options
			];
			Lookup[options, LoadingSampleTargetConcentration],
			10 Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleTargetConcentration, "Set LoadingSampleTargetConcentration -> Automatic to set the analyte concentration of 10 Millimolar in the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleTargetConcentration -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleTargetConcentration],
			10 Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== Solvent, Electrolyte, and ElectrolyteSolution related options ==== *)

		(* -- Solvent Option -- *)
		Example[{Options, Solvent, "Use the Solvent option to specify the solvent chemical to use for the preparation of the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, Solvent],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, Solvent, "Set Solvent -> Automatic to use electronic grade acetonitrile for the preparation of the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Automatic,
				Output -> Options
			];
			Lookup[options, Solvent],
			ObjectReferenceP[Model[Sample, "Acetonitrile, Electronic Grade"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Electrolyte Option -- *)
		Example[{Options, Electrolyte, "Use the Electrolyte option to specify the electrolyte chemical to use for the preparation of the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Milli-Q water"],
				Electrolyte -> Model[Sample, "Potassium Chloride"],
				Output -> Options
			];
			Lookup[options, Electrolyte],
			ObjectReferenceP[Model[Sample, "Potassium Chloride"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, Electrolyte, "Set Electrolyte -> Automatic to use Tetrabutylammonium hexafluorophosphate ([NBu4][PF6]) as the electrolyte chemical for the preparation of the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Automatic,
				Output -> Options
			];
			Lookup[options, Electrolyte],
			ObjectReferenceP[Model[Sample, "Tetrabutylammonium hexafluorophosphate"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PretreatElectrodes Option -- *)
		Example[{Options, PretreatElectrodes, "Set PretreatElectrode -> True to pre-treat the working and counter electrodes by cycling the voltage applied between them inside an electrolyte solution. The electrode pre-treating process is before the working and counter electrodes are used to perform the cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				Output -> Options
			];
			Lookup[options, PretreatElectrodes],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, PretreatElectrodes, "Set PretreatElectrode -> False to skip the electrodes pre-treating process before the cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> False,
				Output -> Options
			];
			Lookup[options, PretreatElectrodes],
			False,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ElectrolyteSolution Option -- *)
		Example[{Options, ElectrolyteSolution, "Use the ElectrolyteSolution option to specify the electrolyte solution to use for the electrode pre-treating process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				Output -> Options
			];
			Lookup[options, ElectrolyteSolution],
			ObjectReferenceP[Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ElectrolyteSolutionLoadingVolume Option -- *)
		Example[{Options, ElectrolyteSolutionLoadingVolume, "Use the ElectrolyteSolutionLoadingVolume option to specify the volume of ElectrolyteSolution to put in the reaction vessel for the electrode pre-treating process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				ElectrolyteSolutionLoadingVolume -> 4 Milliliter,
				Output -> Options
			];
			Lookup[options, ElectrolyteSolutionLoadingVolume],
			4 Milliliter,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, ElectrolyteSolutionLoadingVolume, "Set ElectrolyteSolutionLoadingVolume -> Automatic to set a ElectrolyteSolutionLoadingVolume volume equals to 60% of the ReactionVessel's MaxVolume:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				ElectrolyteSolutionLoadingVolume -> Automatic,
				Output -> Options
			];
			Lookup[options, ElectrolyteSolutionLoadingVolume],
			3.0 Milliliter,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleElectrolyteAmount Option -- *)
		Example[{Options, LoadingSampleElectrolyteAmount, "Use the LoadingSampleElectrolyteAmount option to specify the mass amount of Electrolyte chemical used to prepare the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				LoadingSampleElectrolyteAmount -> 117.4 Milligram,
				Output -> Options
			];
			Lookup[options, LoadingSampleElectrolyteAmount],
			117.4 Milligram,
			EquivalenceFunction->Equal,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleElectrolyteAmount, "Set LoadingSampleElectrolyteAmount -> Automatic to use a sample mass amount that corresponds to the specified ElectrolyteTargetConcentration:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				LoadingSampleElectrolyteAmount -> Automatic,
				ElectrolyteTargetConcentration -> 100 Millimolar,
				Output -> Options
			];
			Lookup[options, LoadingSampleElectrolyteAmount],
			117.4 Milligram,
			EquivalenceFunction->Equal,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ElectrolyteTargetConcentration Option -- *)
		Example[{Options, ElectrolyteTargetConcentration, "Use the ElectrolyteTargetConcentration option to specify the concentration of the Electrolyte chemical in the preparation of the LoadingSample. The sample concentration is also used to prepare the ElectrolyteSolution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				ElectrolyteTargetConcentration -> 100 Millimolar,
				Output -> Options
			];
			Lookup[options, ElectrolyteTargetConcentration],
			100 Millimolar,
			EquivalenceFunction->Equal,
			Variables :> {options},SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, ElectrolyteTargetConcentration, "Set the ElectrolyteTargetConcentration -> Automatic to automatically generate a concentration from the specified LoadingSampleElectrolyteAmount:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				LoadingSampleElectrolyteAmount -> 117.4 Milligram,
				ElectrolyteTargetConcentration -> Automatic,
				Output -> Options
			];
			Lookup[options, ElectrolyteTargetConcentration],
			100 Millimolar,
			EquivalenceFunction->Equal,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== ReferenceElectrode related options ==== *)

		(* -- ReferenceElectrode Option -- *)
		Example[{Options, ReferenceElectrode, "Set ReferenceElectrode to a reference electrode model or object to be used in the cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				Output -> Options
			];
			Lookup[options, ReferenceElectrode], ObjectReferenceP[Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, ReferenceElectrode, "Set ReferenceElectrode -> Automatic to use the \"3 Molar KCl Ag/AgCl Reference Electrode\" when the Solvent is aqueous:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Milli-Q water"],
				ReferenceElectrode -> Automatic,
				Output -> Options
			];
			Lookup[options, ReferenceElectrode],
			ObjectReferenceP[Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, ReferenceElectrode, "Set ReferenceElectrode -> Automatic to use the \"0.1M AgNO3 Ag/Ag+ Reference Electrode\" when the Solvent is organic:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				ReferenceElectrode -> Automatic,
				Output -> Options
			];
			Lookup[options, ReferenceElectrode],
			ObjectReferenceP[Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- RefreshReferenceElectrode Option -- *)

		Example[{Options, RefreshReferenceElectrode, "Set RefreshReferenceElectrode -> True to flush and refill the current reference electrode with the solution defined by the ReferenceSolution of the ReferenceElectrode:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				RefreshReferenceElectrode -> True,
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				Output -> Options
			];
			Lookup[options, RefreshReferenceElectrode],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ReferenceElectrodeSoakTime Option -- *)
		Example[{Options, ReferenceElectrodeSoakTime, "Use the ReferenceElectrodeSoakTime option to specify the duration of the ReferenceElectrode is soaked with ReferenceSolution inside its glass tube and ElectrolyteSolution outside its glass tube, before the cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				ReferenceElectrodeSoakTime -> 5 Minute,
				Output -> Options
			];
			Lookup[options, ReferenceElectrodeSoakTime],
			5 Minute,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== InternalStandard related options ==== *)

		(* -- InternalStandard Option -- *)
		Example[{Options, InternalStandard, "Use the InternalStandard option to specify the chemical to be included in the LoadingSample for the cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				Output -> Options
			];
			Lookup[options, InternalStandard],
			ObjectReferenceP[Model[Sample, "Ferrocene"]],
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- InternalStandardAdditionOrder Option -- *)
		Example[{Options, InternalStandardAdditionOrder, "Use the InternalStandardAdditionOrder option to specify when the InternalStandard should be added into the LoadingSample. If the InternalStandardAdditionOrder is Before for an unprepared solid sample, the InternalStandard will be dissolved into the Solvent chemical along with the input sample, Electrolyte chemical to prepare the LoadingSample. If the InternalStandardAdditionOrder is After, the InternalStandard will be dissolved into the LoadingSample after the cyclic voltammetry measurements. The solution added with InternalStandard will be measured again with the same cyclic voltammetry measurement parameters:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				Output -> Options
			];
			Lookup[options, InternalStandardAdditionOrder],
			Before,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, InternalStandardAdditionOrder, "Use the InternalStandardAdditionOrder option to specify when the InternalStandard should be added into the LoadingSample. If the InternalStandardAdditionOrder is Before for an unprepared solid sample, the InternalStandard will be dissolved into the Solvent chemical along with the input sample, Electrolyte chemical to prepare the LoadingSample. If the InternalStandardAdditionOrder is After, the InternalStandard will be dissolved into the LoadingSample after the cyclic voltammetry measurements. The solution added with InternalStandard will be measured again with the same cyclic voltammetry measurement parameters:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> After,
				Output -> Options
			];
			Lookup[options, InternalStandardAdditionOrder],
			After,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- InternalStandardAmount Option -- *)
		Example[{Options, InternalStandardAmount, "Use the InternalStandardAmount option to specify the mass amount of InternalStandard chemical added into the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardAmount -> 5.7 Milligram,
				Output -> Options
			];
			Lookup[options, InternalStandardAmount],
			5.7 Milligram,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, InternalStandardAmount, "Set InternalStandardAmount -> Automatic to use a sample mass amount that corresponds to the specified InternalStandardTargetConcentration:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardAmount -> Automatic,
				InternalStandardTargetConcentration -> 10 Millimolar,
				Output -> Options
			];
			Lookup[options, InternalStandardAmount],
			5.7 Milligram,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- InternalStandardTargetConcentration Option -- *)
		Example[{Options, InternalStandardTargetConcentration, "Use the InternalStandardTargetConcentration option to specify the concentration of InternalStandard chemical after it's added into the LoadingSample:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardTargetConcentration -> 10 Millimolar,
				Output -> Options
			];
			Lookup[options, InternalStandardTargetConcentration],
			10 Millimolar,
			EquivalenceFunction->Equal,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, InternalStandardTargetConcentration, "Set InternalStandardTargetConcentration -> Automatic to use a concentration that corresponds to the specified InternalStandardAmount:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardAmount -> 5.7 Milligram,
				InternalStandardTargetConcentration -> Automatic,
				Output -> Options
			];
			Lookup[options, InternalStandardTargetConcentration],
			10 Millimolar,
			EquivalenceFunction->Equal,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== PretreatElectrodes related options ==== *)

		(* -- PretreatmentSparging Option -- *)
		Example[{Options, PretreatmentSparging, "Set PretreatmentSparging -> True to sparge the electrode pre-treating ElectrolyteSolution with an inert gas to remove the dissolved oxygen or carbon dioxide:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentSparging -> True,
				Output -> Options
			];
			Lookup[options, PretreatmentSparging],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PretreatmentSpargingPreBubbler Option -- *)
		Example[{Options, PretreatmentSpargingPreBubbler, "Set PretreatmentSpargingPreBubbler -> True to use a gas washing bottle filled with the Solvent chemical to pre-saturate the inert gas before the gas goes into the ElectrolyteSolution during the pretreatment sparging process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentSparging -> True,
				PretreatmentSpargingPreBubbler -> True,
				Output -> Options
			];
			Lookup[options, PretreatmentSpargingPreBubbler],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PretreatmentInitialPotential Option -- *)
		Example[{Options, PretreatmentInitialPotential, "Use the PretreatmentInitialPotential option to specify the potential applied between the WorkingElectrode and CounterElectrode when an electrode pre-treating cycle starts:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentInitialPotential -> 0.2 Volt,
				Output -> Options
			];
			Lookup[options, PretreatmentInitialPotential],
			0.2 Volt,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PretreatmentFirstPotential Option -- *)
		Example[{Options, PretreatmentFirstPotential, "Use the PretreatmentFirstPotential option to specify the first target potential applied between the WorkingElectrode and CounterElectrode after the PretreatmentInitialPotential during an electrode pre-treating cycle:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentFirstPotential -> 1.1 Volt,
				Output -> Options
			];
			Lookup[options, PretreatmentFirstPotential],
			1.1 Volt,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PretreatmentSecondPotential Option -- *)
		Example[{Options, PretreatmentSecondPotential, "Use the PretreatmentSecondPotential option to specify the second target potential applied between the WorkingElectrode and CounterElectrode after the PretreatmentFirstPotential during an electrode pre-treating cycle:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentSecondPotential -> -1.1 Volt,
				Output -> Options
			];
			Lookup[options, PretreatmentSecondPotential],
			-1.1 Volt,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PretreatmentFinalPotential Option -- *)
		Example[{Options, PretreatmentFinalPotential, "Use the PretreatmentFinalPotential option to specify the final target potential applied between the WorkingElectrode and CounterElectrode after the PretreatmentSecondPotential during an electrode pre-treating cycle:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentFinalPotential -> -0.2 Volt,
				Output -> Options
			];
			Lookup[options, PretreatmentFinalPotential],
			-0.2 Volt,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PretreatmentPotentialSweepRate Option -- *)
		Example[{Options, PretreatmentPotentialSweepRate, "Use the PretreatmentPotentialSweepRate option to specify the scanning speed of the potential between the WorkingElectrode and CounterElectrode during an electrode pre-treating cycle:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentPotentialSweepRate -> 200 Millivolt/Second,
				Output -> Options
			];
			Lookup[options, PretreatmentPotentialSweepRate],
			200 Millivolt/Second,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PretreatmentNumberOfCycles Option -- *)
		Example[{Options, PretreatmentNumberOfCycles, "Use the PretreatmentNumberOfCycles option to specify the number of cycles to be performed to pre-treat the electrodes. The same PretreatmentInitialPotential, PretreatmentFirstPotential, PretreatmentSecondPotential, PretreatmentFinalPotential, and PretreatmentPotentialSweepRate are used for each cycle:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentNumberOfCycles -> 3,
				Output -> Options
			];
			Lookup[options, PretreatmentNumberOfCycles],
			3,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== LoadingSampleMix related options ==== *)

		(* -- LoadingSampleMix Option -- *)
		Example[{Options, LoadingSampleMix, "Set LoadingSampleMix -> True to indicate the solid input sample needs to be dissolved into the Solvent chemical to prepare the LoadingSample solution for the cyclic voltammetry measurements:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				Output -> Options
			];
			Lookup[options, LoadingSampleMix],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleMix, "Set LoadingSampleMix -> Automatic to automatically identify if the input sample is an unprepared solid sample or a prepared liquid sample and set LoadingSampleMix accordingly:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleMix],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleMixType Option -- *)
		Example[{Options, LoadingSampleMixType, "Use the LoadingSampleMixType option to specify the mixing method to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Invert,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixType],
			Invert,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleMixType, "Set the LoadingSampleMixType -> Automatic to use the Shake mixing method:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixType],
			Invert,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleMixTemperature Option -- *)
		Example[{Options, LoadingSampleMixTemperature, "Use the LoadingSampleMixTemperature option to specify the mixing temperature to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Shake,
				LoadingSampleMixTemperature -> 35 Celsius,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixTemperature],
			35 Celsius,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleMixTemperature, "Set LoadingSampleMixTemperature -> Ambient to use a mixing temperature of 25 Celsius to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Shake,
				LoadingSampleMixTemperature -> Ambient,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixTemperature],
			25 Celsius,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleMixTime Option -- *)
		Example[{Options, LoadingSampleMixTime, "When the LoadingSampleMixType is Shake, use the LoadingSampleMixTime option to specify the mixing duration to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Shake,
				LoadingSampleMixTime -> 20 Minute,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixTime],
			20 Minute,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleMixTime, "Set LoadingSampleMixTime -> Automatic to use a mixing duration of 5 Minute to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Shake,
				LoadingSampleMixTime -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixTime],
			5 Minute,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleNumberOfMixes Option -- *)
		Example[{Options, LoadingSampleNumberOfMixes, "When the LoadingSampleMixType is Pipette or Invert, use the LoadingSampleNumberOfMixes option to specify the number of mixes to be performed to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Invert,
				LoadingSampleNumberOfMixes -> 8,
				Output -> Options
			];
			Lookup[options, LoadingSampleNumberOfMixes],
			8,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleNumberOfMixes, "Set LoadingSampleNumberOfMixes -> Automatic to use a number of mixes of 10 to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Invert,
				LoadingSampleNumberOfMixes -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleNumberOfMixes],
			10,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleMixVolume Option -- *)
		Example[{Options, LoadingSampleMixVolume, "When the LoadingSampleMixType is Pipette, use the LoadingSampleMixVolume option to specify the solution volume to be pipetted each time for the mixing process to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Pipette,
				LoadingSampleMixVolume -> 2 Milliliter,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixVolume],
			2 Milliliter,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleNumberOfMixes, "Set LoadingSampleMixVolume -> Automatic to use a mixing volume of 50% of the SolventVolume:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Pipette,
				LoadingSampleNumberOfMixes -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixVolume],
			1.5 Milliliter,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleMixUntilDissolved Option -- *)
		Example[{Options, LoadingSampleMixUntilDissolved, "Use the LoadingSampleMixUntilDissolved option to indicate the mixing process will continue in attempt to dissolved any solid substance during the LoadingSample solution preparation:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixUntilDissolved -> True,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixUntilDissolved],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleMixUntilDissolved, "Set LoadingSampleMixUntilDissolved -> Automatic sets LoadingSampleMixUntilDissolved to True:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixUntilDissolved -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleMixUntilDissolved],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleMaxMixTime Option -- *)
		Example[{Options, LoadingSampleMaxMixTime, "When the LoadingSampleMixType is Shake and LoadingSampleMixUntilDissolved is True, use the LoadingSampleMaxMixTime option to specify the maximum amount of mixing time in attempt to dissolve any solid substance during the LoadingSample solution preparation:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Shake,
				LoadingSampleMixUntilDissolved -> True,
				LoadingSampleMaxMixTime -> 30 Minute,
				Output -> Options
			];
			Lookup[options, LoadingSampleMaxMixTime],
			30 Minute,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleMaxMixTime, "Set LoadingSampleMaxMixTime -> Automatic to use a maximum mixing duration of 20 Minute to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Shake,
				LoadingSampleMixUntilDissolved -> True,
				LoadingSampleMaxMixTime -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleMaxMixTime],
			20 Minute,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- LoadingSampleMaxNumberOfMixes Option -- *)
		Example[{Options, LoadingSampleMaxNumberOfMixes, "When the LoadingSampleMixType is Pipette or Invert, and LoadingSampleMixUntilDissolved is True, use the LoadingSampleMaxNumberOfMixes option to specify the maximum number of mixes in attempt to dissolve any solid substance during the LoadingSample solution preparation:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Invert,
				LoadingSampleMixUntilDissolved -> True,
				LoadingSampleMaxNumberOfMixes -> 45,
				Output -> Options
			];
			Lookup[options, LoadingSampleMaxNumberOfMixes],
			45,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, LoadingSampleMaxNumberOfMixes, "Set LoadingSampleMaxNumberOfMixes -> Automatic to use a maximum number of mixes of 30 to prepare the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Invert,
				LoadingSampleMixUntilDissolved -> True,
				LoadingSampleMaxNumberOfMixes -> Automatic,
				Output -> Options
			];
			Lookup[options, LoadingSampleMaxNumberOfMixes],
			30,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== Sparging related options ==== *)

		(* -- Sparging Option -- *)
		Example[{Options, Sparging, "Set Sparging -> True to sparge the LoadingSample solution with an inert gas to remove the dissolved oxygen or carbon dioxide:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				Output -> Options
			];
			Lookup[options, Sparging],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, Sparging, "Set Sparging -> False to skip the sparging process for the LoadingSample solution:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> False,
				Output -> Options
			];
			Lookup[options, Sparging],
			False,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SpargingGas Option -- *)
		Example[{Options, SpargingGas, "Use the SpargingGas option to specify which inert gas to use for the LoadingSample sparging process. The same inert gas will be used for the electrode pre-treating sparging process, if PretreatmentSparging is True:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				SpargingGas -> Argon,
				Output -> Options
			];
			Lookup[options, SpargingGas],
			Argon,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, SpargingGas, "Set the SpargingGas -> Automatic to use Nitrogen as the sparging gas:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				SpargingGas -> Automatic,
				Output -> Options
			];
			Lookup[options, SpargingGas],
			Nitrogen,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SpargingTime Option -- *)
		Example[{Options, SpargingTime, "Use the SpargingTime option to specify duration for the LoadingSample sparging process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				SpargingTime -> 10 Minute,
				Output -> Options
			];
			Lookup[options, SpargingTime],
			10 Minute,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, SpargingTime, "Set the SpargingTime -> Automatic to a duration of 3 Minute for the LoadingSample sparging process. The same duration will be used for the electrode pre-treating sparging process, if PretreatmentSparging is True:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				SpargingTime -> Automatic,
				Output -> Options
			];
			Lookup[options, SpargingTime],
			3 Minute,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SpargingPreBubbler Option -- *)
		Example[{Options, SpargingPreBubbler, "Set SpargingPreBubbler -> True to use a gas washing bottle filled with the Solvent chemical to pre-saturate the inert gas before the gas goes into the LoadingSample solution during the sparging process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				SpargingPreBubbler -> True,
				Output -> Options
			];
			Lookup[options, SpargingPreBubbler],
			True,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, SpargingPreBubbler, "Set SpargingPreBubbler -> False to avoid the using of a gas washing bottle to pre-saturate the inert gas before the gas goes into the LoadingSample solution during the sparging process:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				SpargingPreBubbler -> False,
				Output -> Options
			];
			Lookup[options, SpargingPreBubbler],
			False,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ==== Cyclic voltammetry measurement related options ==== *)

		(* -- NumberOfCycles Option -- *)
		Example[{Options, NumberOfCycles, "Use the NumberOfCycles option to specify the number of cyclic voltammetry cycles to be performed on the LoadingSample solution. A cyclic voltammetry cycle starts at InitialPotential, then to FirstPotential, then to SecondPotential, and stops at FinalPotential, with a potential scanning speed of PotentialSweepRate:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				Output -> Options
			];
			Lookup[options, NumberOfCycles],
			3,
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- InitialPotentials Option -- *)
		Example[{Options, InitialPotentials, "Use the InitialPotentials option to specify the potential applied between the WorkingElectrode and CounterElectrode when a cyclic voltammetry measurement cycle starts:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				InitialPotentials -> {0.1 Volt, 0.1 Volt, 0.1 Volt},
				Output -> Options
			];
			Lookup[options, InitialPotentials],
			{100.0 Millivolt, 100.0 Millivolt, 100.0 Millivolt},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- FirstPotentials Option -- *)
		Example[{Options, FirstPotentials, "Use the FirstPotentials option to specify the first target potential applied between the WorkingElectrode and CounterElectrode after the InitialPotential during a cyclic voltammetry measurement cycle:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				FirstPotentials -> {2.1 Volt, 2.1 Volt, 2.1 Volt},
				Output -> Options
			];
			Lookup[options, FirstPotentials],
			{2100.0 Millivolt, 2100.0 Millivolt, 2100.0 Millivolt},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- SecondPotentials Option -- *)
		Example[{Options, SecondPotentials, "Use the SecondPotentials option to specify the second target potential applied between the WorkingElectrode and CounterElectrode after the FirstPotential during a cyclic voltammetry measurement cycle:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				SecondPotentials -> {-2.1 Volt, -2.1 Volt, -2.1 Volt},
				Output -> Options
			];
			Lookup[options, SecondPotentials],
			{-2100.0 Millivolt, -2100.0 Millivolt, -2100.0 Millivolt},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- FinalPotentials Option -- *)
		Example[{Options, FinalPotentials, "Use the FinalPotentials option to specify the final target potential applied between the WorkingElectrode and CounterElectrode after the SecondPotential during a cyclic voltammetry measurement cycle:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				FinalPotentials -> {0.0 Volt, 0.0 Volt, 0.0 Volt},
				Output -> Options
			];
			Lookup[options, FinalPotentials],
			{0.0 Millivolt, 0.0 Millivolt, 0.0 Millivolt},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PotentialSweepRates Option -- *)
		Example[{Options, PotentialSweepRates, "Use the PotentialSweepRates option to specify the scanning speed of the potential between the WorkingElectrode and CounterElectrode during a cyclic voltammetry measurement cycle:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				PotentialSweepRates -> {200 Millivolt/Second, 200 Millivolt/Second, 200 Millivolt/Second},
				Output -> Options
			];
			Lookup[options, PotentialSweepRates],
			{200 Millivolt/Second, 200 Millivolt/Second, 200 Millivolt/Second},
			Variables :> {options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* == Shared Options == *)
		(* == ExperimentIncubate tests == *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquotting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquotting (if specified):"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Incubate -> True,
				Output -> Options
			];
			Lookup[options,Incubate],
			True,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquotting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				IncubationTemperature -> 40*Celsius,
				Output -> Options
			];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquotting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				IncubationTime -> 40*Minute,
				Output -> Options
			];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				MaxIncubationTime -> 40*Minute,
				Output -> Options
			];
			Lookup[options,MaxIncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquotting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				IncubationInstrument->Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"],
				Output -> Options
			];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquotting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				AnnealingTime->40*Minute,
				Output -> Options
			];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				IncubateAliquot -> 3 Milliliter,
				Output -> Options
			];
			Lookup[options,IncubateAliquot],
			3 Milliliter,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"],
				Output -> Options
			];
			Lookup[options,IncubateAliquotContainer],
			{1, ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquotting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Mix->True,
				Output -> Options
			];
			Lookup[options,Mix],
			True,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				MixType->Shake,
				Output -> Options
			];
			Lookup[options,MixType],
			Shake,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				MixUntilDissolved->True,
				Output -> Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, IncubateAliquotDestinationWell, "Specify the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				IncubateAliquotDestinationWell->Null,
				Output -> Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* == ExperimentCentrifuge == *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Centrifuge->True,
				Output -> Options
			];
			Lookup[options,Centrifuge],
			True,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],
				Output -> Options
			];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				CentrifugeIntensity->1000*RPM,
				Output -> Options
			];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				CentrifugeTime->5*Minute,
				Output -> Options
			];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				CentrifugeTemperature->20*Celsius,
				Output -> Options
			];
			Lookup[options,CentrifugeTemperature],
			20*Celsius,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				CentrifugeAliquot->3*Milliliter,
				Output -> Options
			];
			Lookup[options,CentrifugeAliquot],
			3*Milliliter,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],
				Output -> Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, CentrifugeAliquotDestinationWell, "Specify The desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],
				CentrifugeAliquotDestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* == ExperimentFilter == *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Filtration->False,
				Output -> Options
			];
			Lookup[options,Filtration],
			False,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FiltrationType->Null,
				Output -> Options
			];
			Lookup[options,FiltrationType],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterInstrument->Null,
				Output -> Options
			];
			Lookup[options,FilterInstrument],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterAliquot->3 Milliliter,
				Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],
				Output -> Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterMaterial->Null,
				Output -> Options
			];
			Lookup[options,FilterMaterial],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, PrefilterMaterial, "The membrane material of the pre-filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				PrefilterMaterial->Null,
				Output -> Options
			];
			Lookup[options,PrefilterMaterial],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterPoreSize->Null,
				Output -> Options
			];
			Lookup[options,FilterPoreSize],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, PrefilterPoreSize, "The pore size of the pre-filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				PrefilterPoreSize->Null,
				Output -> Options
			];
			Lookup[options,PrefilterPoreSize],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterAliquot->3 Milliliter,
				FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output -> Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterHousing->Null,
				Output -> Options
			];
			Lookup[options,FilterHousing],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterIntensity->Null,
				Output -> Options
			];
			Lookup[options,FilterIntensity],
			Null,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterTime->Null,
				Output -> Options
			];
			Lookup[options,FilterTime],
			Null,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterTemperature->Null,
				Output -> Options
			];
			Lookup[options,FilterTemperature],
			Null,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterSterile->False,
				Output -> Options
			];
			Lookup[options,FilterSterile],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterAliquot, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterAliquot->3 Milliliter,
				Output -> Options
			];
			Lookup[options,FilterAliquot],
			3 Milliliter,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],
				Output -> Options
			];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterAliquot->3 Milliliter,
				FilterContainerOut->Model[Container,Vessel,"50mL Tube"],
				Output -> Options
			];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, FilterAliquotDestinationWell, "Specify The desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				FilterAliquotDestinationWell->Null,
				Output -> Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* == ExperimentAliquot == *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				AliquotAmount->3 Milliliter,
				Output -> Options
			];
			Lookup[options,{Aliquot,AliquotAmount}],
			{True,3 Milliliter},
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"mySample1",
				PreparedSample -> True,
				AliquotAmount->3 Milliliter,
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"mySample1"},
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				AliquotAmount->3 Milliliter,
				Output -> Options
			];
			Lookup[options,AliquotAmount],
			3 Milliliter,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				AssayVolume->3 Milliliter,
				Output -> Options
			];
			Lookup[options,AssayVolume],
			3 Milliliter,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				TargetConcentration->4 Millimolar,
				Output -> Options
			];
			Lookup[options,TargetConcentration],
			4 Millimolar,
			EquivalenceFunction->Equal,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				TargetConcentrationAnalyte->Model[Molecule,"Ferrocene"],
				TargetConcentration->4 Millimolar,
				Output -> Options
			];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Ferrocene"]],
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				ConcentratedBuffer->Null,
				Output -> Options
			];
			Lookup[options,ConcentratedBuffer],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				BufferDilutionFactor->Null,
				Output -> Options
			];
			Lookup[options,BufferDilutionFactor],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				BufferDiluent->Null,
				Output -> Options
			];
			Lookup[options,BufferDiluent],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				AssayBuffer->Null,
				Output -> Options
			];
			Lookup[options,AssayBuffer],
			Null,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				AliquotSampleStorageCondition->AmbientStorage,
				Output -> Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			AmbientStorage,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				ConsolidateAliquots->True,
				Output -> Options
			];
			Lookup[options,ConsolidateAliquots],
			True,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				AliquotPreparation->Manual,
				Output -> Options
			];
			Lookup[options,AliquotPreparation],
			Manual,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				AliquotContainer->Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}},
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, DestinationWell, "Specify The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				DestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,DestinationWell],
			{"A1"},
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				ImageSample->True,
				Output -> Options
			];
			Lookup[options,ImageSample],
			True,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, MeasureVolume, "Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				MeasureVolume->True,
				Output -> Options
			];
			Lookup[options,MeasureVolume],
			True,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, MeasureWeight, "Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				MeasureWeight->True,
				Output -> Options
			];
			Lookup[options,MeasureWeight],
			True,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* == Other shared options == *)
		Example[{Options, Name, "Name the protocol for ExperimentCyclicVoltammetry:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Name->"Test CV Protocol with 1==2",
				Output -> Options
			];
			Lookup[options,Name],
			"Test CV Protocol with 1==2",
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, Template, "Inherit options from a previously run protocol:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Template -> Object[Protocol, CyclicVoltammetry,"Example CyclicVoltammetry Protocol for CyclicVoltammetry tests" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options,Template],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry,"Example CyclicVoltammetry Protocol for CyclicVoltammetry tests" <> $SessionUUID]],
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, SamplesInStorageCondition, "Specify The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				SamplesInStorageCondition->AmbientStorage,
				Output -> Options
			];
			Lookup[options,SamplesInStorageCondition],
			AmbientStorage,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, SamplesOutStorageCondition, "Specify The non-default conditions under which the SamplesOut of this experiment should be stored after the protocol is completed. If left unset, SamplesOut will be stored according to their current StorageCondition:"},
			options = ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				SamplesOutStorageCondition->AmbientStorage,
				Output -> Options
			];
			Lookup[options,SamplesOutStorageCondition],
			AmbientStorage,
			TimeConstraint->240,
			Variables:>{options},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentCyclicVoltammetry[
				{Model[Sample, "Ferrocene"], Model[Sample, "Ferrocene"]},
				PreparedModelContainer -> Model[Container, Vessel, "50mL Tube"],
				PreparedModelAmount -> 10 Milligram,
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				{ObjectP[Model[Sample, "Ferrocene"]]..},
				{ObjectP[Model[Container, Vessel, "50mL Tube"]]..},
				{EqualP[10 Milligram]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparatoryUnitOperations, "Specify a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSamplePreparation:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparatoryUnitOperations->{
					LabelContainer[
						Label -> "My ferrocene sample",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Ferrocene"],
						Destination -> "My ferrocene sample",
						Amount -> 10 Milligram
					]
				}
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			TimeConstraint->240,
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ============== *)
		(* == MESSAGES == *)
		(* ============== *)

		(* ---------------------- *)
		(* -- ObjectDoesNotExist -- *)
		(* ---------------------- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentCyclicVoltammetry[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentCyclicVoltammetry[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentCyclicVoltammetry[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentCyclicVoltammetry[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentCyclicVoltammetry[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentCyclicVoltammetry[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],

		(* ---------------------- *)
		(* -- Precision Checks -- *)
		(* ---------------------- *)

		(* -- rounding option precision -- *)
		Example[{Messages, "TargetConcentrationPrecision", "The user will be warned the chemical concentrations (ElectrolyteTargetConcentration, LoadingSampleTargetConcentration, InternalStandardTargetConcentration) are rounded if they have precisions higher than 0.1 Millimolar:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID], Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				LoadingSampleTargetConcentration -> 1.2345 Millimolar
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::TargetConcentrationPrecision},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TargetConcentrationPrecision", "The user will be warned the chemical concentrations (ElectrolyteTargetConcentration, LoadingSampleTargetConcentration, InternalStandardTargetConcentration) are rounded if they have precisions higher than 0.1 Microgram/Liter:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID], Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				LoadingSampleTargetConcentration -> 800.30123 Milligram/Liter
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::TargetConcentrationPrecision},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "PotentialsPrecision", "The user will be warned the cyclic voltammetry potentials (InitialPotentials, FirstPotentials, SecondPotentials, FinalPotentials) are rounded if they have precisions higher than 1 Millivolt:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID], Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				NumberOfCycles -> 2,
				InitialPotentials -> {{0.1 Millivolt, 0.0 Volt},{0.1 Millivolt, 0.0002 Volt}}
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::PotentialsPrecision},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "PotentialSweepRatePrecision", "The user will be warned the PotentialSweepRates is rounded if it has a precision higher than 10 Millivolt/Second:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID], Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				NumberOfCycles -> 2,
				PotentialSweepRates -> {{15 Millivolt/Second, 12 Millivolt/Second},{233 Millivolt/Second, 456 Millivolt/Second}}
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::PotentialSweepRatePrecision},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Too many input samples *)
		Example[{Messages, "TooManyInputSamples", "If the number of provided input samples exceeds the allowed maximum number of input samples, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				ConstantArray[Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID], 25]
			],
			$Failed,
			Messages :> {Error::TooManyInputSamples, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* --------------------- *)
		(* -- Option Messages -- *)
		(* --------------------- *)

		(* Too large NumberOfReplicates *)
		Example[{Messages, "TooLargeNumberOfReplicates", "If the NumberOfReplicates exceeds the allowed maximum number of replicates, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfReplicates -> 20
			],
			$Failed,
			Messages :> {Error::TooLargeNumberOfReplicates, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ---------------- *)
		(* -- Electrodes -- *)
		(* ---------------- *)

		(* -- CVDeprecatedWorkingElectrodeModel -- *)
		Example[{Messages, "DeprecatedElectrodeModel", "If the given WorkingElectrode model is deprecated, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrode -> Model[Item, Electrode, "Example deprecated working electrode model for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::DeprecatedElectrodeModel, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- CVDeprecatedCounterElectrodeModel -- *)
		Example[{Messages, "DeprecatedElectrodeModel", "If the given CounterElectrode model is deprecated, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				CounterElectrode -> Model[Item, Electrode, "Example deprecated counter electrode model for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::DeprecatedElectrodeModel, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- CVDeprecatedReferenceElectrodeModels -- *)
		Example[{Messages, "DeprecatedElectrodeModel", "If the given ReferenceElectrode model(s) is/are deprecated, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Example deprecated reference electrode model for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::DeprecatedElectrodeModel, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -------------------------- *)
		(* -- Polishing Parameters -- *)
		(* -------------------------- *)

		(* CVCoatedWorkingElectrode *)
		Example[{Messages, "CoatedWorkingElectrode", "If WorkingElectrode is coated, but PolishWorkingElectrode is set to True, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrode -> Model[Item, Electrode, "IKA Platinum Coated Copper Plate Electrode"],
				PolishWorkingElectrode -> True
			],
			$Failed,
			Messages :> {Error::CoatedWorkingElectrode, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* CVNonNullPolishingPads *)
		Example[{Messages, "NonNullOption", "If PolishWorkingElectrode is set to False, but PolishingPads is specified, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> {False, False},
				PolishingPads -> {Object[Item, ElectrodePolishingPad, "Example polishing pad 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, ElectrodePolishingPad, "Example polishing pad 2 for CyclicVoltammetry tests" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* CVMissingPolishingPads *)
		Example[{Messages, "MissingOption", "If PolishWorkingElectrode is set to True, but PolishingPads is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> {True, True},
				PolishingPads -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* CVNonNullPolishingSolutions *)
		Example[{Messages, "NonNullOption", "If PolishWorkingElectrode is set to False, but PolishingSolutions is specified, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> {False, False},
				PolishingSolutions -> {Object[Sample, "Example polishing solution 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example polishing solution 2 for CyclicVoltammetry tests" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PolishWorkingElectrode is set to True, but PolishingSolutions is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> {True, True},
				PolishingSolutions -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "OptionsMismatchingLength", "If the provided PolishingSolutions list has a different length from the PolishingPad list, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> True,
				PolishingPads -> {Object[Item, ElectrodePolishingPad, "Example polishing pad 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, ElectrodePolishingPad, "Example polishing pad 2 for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishingSolutions -> {Object[Sample, "Example polishing solution 1 for CyclicVoltammetry tests" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {Error::OptionsMismatchingLength, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonPolishingSolutions", "If the provided PolishingSolutions list has entries that are not polishing solutions, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingSolutions -> {Object[Sample, "Example polishing solution 1 for CyclicVoltammetry tests" <> $SessionUUID], Object[Sample, "Example water for CyclicVoltammetry tests" <> $SessionUUID]}
			],
			$Failed,
			Messages :> {Error::NonPolishingSolutions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonDefaultPolishingSolutions", "If the provided PolishingSolutions list has entries that are not default polishing solutions specified in the corresponding polishing pad, a warning will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PolishWorkingElectrode -> True,
				PolishingPads -> {Object[Item, ElectrodePolishingPad, "Example polishing pad 1 for CyclicVoltammetry tests" <> $SessionUUID], Object[Item, ElectrodePolishingPad, "Example polishing pad 2 for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishingSolutions -> {Object[Sample, "Example polishing solution 2 for CyclicVoltammetry tests" <> $SessionUUID], Object[Sample, "Example polishing solution 1 for CyclicVoltammetry tests" <> $SessionUUID]}
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::NonDefaultPolishingSolutions},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* CVNonNullNumberOfPolishingSolutionDroplets *)
		Example[{Messages, "NonNullOption", "If PolishWorkingElectrode is set to False, but NumberOfPolishingSolutionDroplets is specified, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> {False, False},
				NumberOfPolishingSolutionDroplets -> {2, 2}
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PolishWorkingElectrode is set to True, but NumberOfPolishingSolutionDroplets is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> {True, True},
				NumberOfPolishingSolutionDroplets -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "OptionsMismatchingLength", "If the provided NumberOfPolishingSolutionDroplets list has a different length from the PolishingPad list, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> True,
				PolishingPads -> {Object[Item, ElectrodePolishingPad, "Example polishing pad 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, ElectrodePolishingPad, "Example polishing pad 2 for CyclicVoltammetry tests" <> $SessionUUID]},
				NumberOfPolishingSolutionDroplets -> {2}
			],
			$Failed,
			Messages :> {Error::OptionsMismatchingLength, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* NumberOfPolishings *)
		Example[{Messages, "NonNullOption", "If PolishWorkingElectrode is set to False, but NumberOfPolishings is specified, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> {False, False},
				NumberOfPolishings -> {1, 1}
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PolishWorkingElectrode is set to True, but NumberOfPolishings is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> {True, True},
				NumberOfPolishings -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "OptionsMismatchingLength", "If the provided NumberOfPolishings list has a different length from the PolishingPad list, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				{Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID]},
				PolishWorkingElectrode -> True,
				PolishingPads -> {Object[Item, ElectrodePolishingPad, "Example polishing pad 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, ElectrodePolishingPad, "Example polishing pad 2 for CyclicVoltammetry tests" <> $SessionUUID]},
				NumberOfPolishings -> {1}
			],
			$Failed,
			Messages :> {Error::OptionsMismatchingLength, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* --------------------------- *)
		(* -- Sonication Parameters -- *)
		(* --------------------------- *)

		(* WorkingElectrodeSonication *)
		Example[{Messages, "SonicationSensitiveWorkingElectrode", "If WorkingElectrode is sonication sensitive, but WorkingElectrodeSonication is set to True, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrode -> Model[Item, Electrode, "IKA Platinum Coated Copper Plate Electrode"],
				WorkingElectrodeSonication -> True
			],
			$Failed,
			Messages :> {Error::SonicationSensitiveWorkingElectrode, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* WorkingElectrodeSonicationTime *)
		Example[{Messages, "NonNullOption", "If WorkingElectrodeSonication is set to False, but WorkingElectrodeSonicationTime is specified, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeSonication -> False,
				WorkingElectrodeSonicationTime -> 45 Second
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If WorkingElectrodeSonication is set to True, but WorkingElectrodeSonicationTime is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeSonication -> True,
				WorkingElectrodeSonicationTime -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* CVNonNullWorkingElectrodeSonicationTemperature *)
		Example[{Messages, "NonNullOption", "If WorkingElectrodeSonication is set to False, but WorkingElectrodeSonicationTemperature is specified, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeSonication -> False,
				WorkingElectrodeSonicationTemperature -> 45 Celsius
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If WorkingElectrodeSonication is set to True, but WorkingElectrodeSonicationTemperature is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeSonication -> True,
				WorkingElectrodeSonicationTemperature -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ------------------------ *)
		(* -- Washing Parameters -- *)
		(* ------------------------ *)

		(* WorkingElectrodeWashingCycles *)
		Example[{Messages, "NonNullOption", "If WorkingElectrodeWashing is set to False, but WorkingElectrodeWashingCycles is specified, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeWashing -> False,
				WorkingElectrodeWashingCycles -> 1
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If WorkingElectrodeWashing is set to True, but WorkingElectrodeWashingCycles is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				WorkingElectrodeWashing -> True,
				WorkingElectrodeWashingCycles -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ------------------------------------- *)
		(* -- LoadingSample Volume Parameters -- *)
		(* ------------------------------------- *)

		(* PreparedSample *)
		Example[{Messages, "MismatchingSampleState", "If PreparedSample is set to False, but input sample is a solution, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> False
			],
			$Failed,
			Messages :> {Error::MismatchingSampleState, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MismatchingSampleState", "If PreparedSample is set to True, but input sample is a solid, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True
			],
			$Failed,
			Messages :> {Error::MismatchingSampleState, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If the specified reaction vessel is not compatible with the electrode cap, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReactionVessel -> Model[Container, ReactionVessel, ElectrochemicalSynthesis, "Electrochemical Reaction Vessel, 20 mL"],
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Electrode Cap"]
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* SolventVolume *)
		Example[{Messages, "NonNullOption", "If PreparedSample is set to True, but SolventVolume is specified, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				SolventVolume -> 12 Milliliter
			],
			$Failed,
			Messages :> {Error::NonNullOption, Warning::ExcessiveSolventVolume,Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PreparedSample is set to False, but SolventVolume is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> False,
				SolventVolume -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TooSmallSolventVolume", "If PreparedSample is set to False, but SolventVolume is smaller than the LoadingSampleVolume or 30% of the ReactionVessel MaxVolume, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> False,
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleVolume -> 12 Milliliter,
				SolventVolume -> 3 Milliliter
			],
			$Failed,
			Messages :> {Error::TooSmallSolventVolume, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "ExcessiveSolventVolume", "If SolventVolume is larger than LoadingSampleVolume, a warning will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> False,
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleVolume -> 12 Milliliter,
				SolventVolume -> 14 Milliliter
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::ExcessiveSolventVolume},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* LoadingSampleVolume *)
		Example[{Messages, "TooSmallVolume", "If LoadingSampleVolume is smaller than 30% of the ReactionVessel MaxVolume, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleVolume -> 5 Milliliter
			],
			$Failed,
			Messages :> {Error::TooSmallVolume, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TooLargeVolume", "If LoadingSampleVolume is greater than 90% of the ReactionVessel MaxVolume, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleVolume -> 20 Milliliter
			],
			$Failed,
			Messages :> {Error::TooLargeVolume, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ----------------------------- *)
		(* -- Analyte related options -- *)
		(* ----------------------------- *)

		(* Invalid inputs with respect to Analyte related options *)
		Example[{Messages, "MissingInformation", "If the input sample does not have its Composition field informed, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example solid sample object with no Composition for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingInformation", "If the input sample is a prepared liquid sample and it does not have at least 3 entries in its Composition field, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example liquid sample object with only one Composition entry for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingInformation", "If the input sample does not have its Analytes field informed, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example solid sample object with no Analytes for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "AmbiguousComposition", "If the input sample have more than one entry in its Analytes field, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example solid sample object with more than one Analytes for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::AmbiguousComposition, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "UnresolvableUnit", "If the analyte molecule in the input sample has a composition unit that is not in molar units or mass concentration units, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example liquid sample object with invalid analyte composition unit in Composition for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True
			],
			$Failed,
			Messages :> {Error::UnresolvableUnit, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Analyte Option *)
		Example[{Messages, "IncompatibleOptions", "If the Analyte option does not match the analyte specified by the input sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Analyte -> Model[Molecule, "Potassium Chloride"]
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* SampleAmount Option *)
		Example[{Messages, "MissingOptionUnpreparedSample", "If the SampleAmount is set to Null for an unprepared solid sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				SampleAmount -> Null
			],
			$Failed,
			Messages :> {Error::MissingOptionUnpreparedSample, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "SpecifiedOptionPreparedSample", "If the SampleAmount is not set to Null or Automatic for a prepared liquid sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				SampleAmount -> 0.5 Gram
			],
			$Failed,
			Messages :> {Error::SpecifiedOptionPreparedSample, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* LoadingSampleTargetConcentration Option *)
		Example[{Messages, "MissingOptionUnpreparedSample", "If the LoadingSampleTargetConcentration is set to Null for an unprepared solid sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleTargetConcentration -> Null
			],
			$Failed,
			Messages :> {Error::MissingOptionUnpreparedSample, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "SpecifiedOptionPreparedSample", "If the LoadingSampleTargetConcentration is not set to Null or Automatic for a prepared liquid sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleTargetConcentration -> 0.5 Molar
			],
			$Failed,
			Messages :> {Error::SpecifiedOptionPreparedSample, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* SampleAmount and LoadingSampleTargetConcentration Options *)
		Example[{Messages, "TooLowConcentration", "If the LoadingSampleTargetConcentration is less than 1 Millimolar, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleTargetConcentration -> 0.2 Millimolar
			],
			$Failed,
			Messages :> {Error::TooLowConcentration, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TooHighConcentration", "If the LoadingSampleTargetConcentration is greater than 15 Millimolar, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleTargetConcentration -> 26 Millimolar
			],
			$Failed,
			Messages :> {Error::TooHighConcentration, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If the LoadingSampleTargetConcentration and SampleAmount do not agree with each other, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				SampleAmount -> 50 Milligram,
				LoadingSampleTargetConcentration -> 10 Millimolar
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ------------------------------------------------------- *)
		(* -- Solvent, Electrolyte, ElectrolyteSolution options -- *)
		(* ------------------------------------------------------- *)

		(* Invalid inputs with respect to Solvent and Electrolyte related options *)
		(* Input sample missing Solvent field *)

		Example[{Messages, "MissingInformation", "If the prepared liquid input sample does not have its Solvent field informed, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example liquid sample object with no Solvent for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Input sample solvent chemical has more than one entry in its Composition field *)
		Example[{Messages, "AmbiguousComposition", "If the solvent chemical used to prepare the liquid input sample has more than one entry in its Composition field, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example liquid sample object with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True
			],
			$Failed,
			Messages :> {Error::AmbiguousComposition, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Input sample electrolyte molecule has an unresolvable composition unit *)
		Example[{Messages, "UnresolvableUnit", "If the electrolyte molecule in the prepared liquid input sample has a composition unit that is not in molar units or mass concentration units, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example liquid sample object with electrolyte molecule invalid composition unit for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True
			],
			$Failed,
			Messages :> {Error::UnresolvableUnit, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Input sample electrolyte molecule has does not have MolecularWeight *)
		Example[{Messages, "MissingInformation", "If the electrolyte molecule in the prepared liquid input sample does not have its MolecularWeight defined, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example liquid sample object with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::MismatchingMolecules, Error::InvalidInput, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Input sample electrolyte molecule has does not have DefaultSampleModel *)
		Example[{Messages, "MissingInformation", "If the electrolyte molecule in the prepared liquid input sample does not have its DefaultSampleModel defined, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example liquid sample object with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Input sample does not have resolved electrolyte molecule *)
		Example[{Messages, "MissingInformation", "If the electrolyte molecule specified by the Electrolyte chemical or the ElectrolyteSolution was not found in the input sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example liquid sample object with electrolyte molecule not Found for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PreparedSample->True,
				InternalStandard -> Model[Sample, "Silver nitrate"]
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Input sample has duplicated resolved electrolyte molecule *)
		Example[{Messages, "AmbiguousComposition", "If the electrolyte molecule specified by the Electrolyte chemical or the ElectrolyteSolution has more than one composition entry in the input sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example liquid sample object with electrolyte molecule duplicated for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				InternalStandard -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"]
			],
			$Failed,
			Messages :> {Error::AmbiguousComposition, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Solvent Option *)
		(* Solvent is not a liquid *)
		Example[{Messages, "ChemicalNotLiquid", "If the Solvent is not a liquid, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Potassium Chloride"]
			],
			$Failed,
			Messages :> {Error::ChemicalNotLiquid, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Solvent has more than one entry in its Composition field *)
		Example[{Messages, "AmbiguousComposition", "If the Solvent has more than one non-Null entry in its Composition field, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Example solvent with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::AmbiguousComposition, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Solvent molecule does not match with the prepared liquid input sample *)
		Example[{Messages, "MismatchingMolecules", "If the solvent molecule specified by the Solvent is not the same with the solvent molecule specified by the sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Solvent -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::MismatchingMolecules, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Solvent sample different from the solvent sample used to prepare the liquid sample *)
		Example[{Messages, "MismatchingOptionsWarning", "The user will be warned if the Solvent sample is different from the solvent sample used to prepare the liquid prepared input sample:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Solvent -> Model[Sample, "Acetonitrile, HPLC Grade"]
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::MismatchingOptionsWarning},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Electrolyte Option *)
		(* Electrolyte has more than one non-Null entry in its Composition field *)
		Example[{Messages, "AmbiguousComposition", "If the Electrolyte has more than one entry in its Composition field, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Example electrolyte with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::AmbiguousComposition, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Electrolyte is not a solid *)
		Example[{Messages, "ChemicalNotSolid", "If the Electrolyte is not a solid, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::ChemicalNotSolid, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Electrolyte molecule does not match the electrolyte molecule specified by the sample *)
		Example[{Messages, "MismatchingMolecules", "If the electrolyte molecule specified by the Electrolyte chemical is not the same with the electrolyte molecule specified by the sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Electrolyte -> Model[Sample, "Potassium Chloride"]
			],
			$Failed,
			Messages :> {Error::MismatchingMolecules, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Electrolyte molecule cannot be automatically resolved *)
		Example[{Messages, "CannotResolveElectrolyte", "If the electrolyte molecule specified by the Electrolyte chemical is not the same with the electrolyte molecule specified by the sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				InternalStandard -> Model[Sample, "Ferrocene"]
			],
			$Failed,
			Messages :> {Error::CannotResolveElectrolyte, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution Option *)
		(* ElectrolyteSolution is not a liquid *)
		Example[{Messages, "ChemicalNotLiquid", "If the ElectrolyteSolution is not a liquid, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Potassium Chloride"]
			],
			$Failed,
			Messages :> {Error::ChemicalNotLiquid, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution does not have Solvent field informed *)
		Example[{Messages, "MissingInformation", "If the ElectrolyteSolution does not have its Solvent field informed, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with missing Solvent field for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution does not have Analytes field informed *)
		Example[{Messages, "MissingInformation", "If the ElectrolyteSolution does not have its Analytes field informed, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with missing Analytes field for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution has more than one entry in its Analytes field *)
		Example[{Messages, "AmbiguousComposition", "If the ElectrolyteSolution has more than one entry in its Analytes field, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with ambiguous Analytes field for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::AmbiguousComposition, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution's solvent chemical has more than one entry in its Composition field *)
		Example[{Messages, "AmbiguousComposition", "If the solvent chemical used to prepare the ElectrolyteSolution has more than one entry in its Composition field, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::AmbiguousComposition, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution's solvent molecule does not match with the prepared liquid input sample *)
		Example[{Messages, "MismatchingMolecules", "If the solvent molecule specified by the ElectrolyteSolution is not the same with the solvent molecule specified by the sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MismatchingMolecules, Error::MismatchingMolecules, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution's solvent molecule does not match with the Solvent *)
		Example[{Messages, "MismatchingMolecules", "If the solvent molecule specified by the ElectrolyteSolution is not the same with the solvent molecule specified by the Solvent, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MismatchingMolecules, Error::MismatchingMolecules, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution's electrolyte molecule missing DefaultSampleModel*)
		Example[{Messages, "MissingInformation", "If the electrolyte molecule specified by the ElectrolyteSolution does not have its DefaultSampleModel defined, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::MismatchingMolecules, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution's electrolyte molecule missing MolecularWeight *)
		Example[{Messages, "MissingInformation", "If the electrolyte molecule specified by the ElectrolyteSolution does not have its MolecularWeight defined, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MissingInformation, Error::MismatchingMolecules, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution's electrolyte molecule mismatch the prepared sample *)
		Example[{Messages, "MismatchingMolecules", "If the electrolyte molecule specified by the ElectrolyteSolution option is not the same with the electrolyte molecule specified by the sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MismatchingMolecules, Error::MismatchingMolecules, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Resolved electrolyte molecule has more than one Composition entry in the ElectrolyteSolution *)
		Example[{Messages, "AmbiguousComposition", "If the electrolyte molecule specified by the Electrolyte chemical has more than one Composition entry in ElectrolyteSolution, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with two electrolyte molecule in Composition field for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::AmbiguousComposition, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution electrolyte molecule has unresolvable composition unit *)
		Example[{Messages, "UnresolvableUnit", "If the electrolyte molecule has a concentration unit that is not of molar units or mass concentration units in the Composition field of the ElectrolyteSolution, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with invalid electrolyte molecule composition unit for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::UnresolvableUnit, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution electrolyte molecule mismatch with the Electrolyte *)
		Example[{Messages, "MismatchingMolecules", "If the electrolyte molecule specified by the ElectrolyteSolution is not the same with the electrolyte molecule specified by the Electrolyte chemical, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::MismatchingMolecules, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution is not resolved to Null *)
		Example[{Messages, "NonNullOption", "If the ElectrolyteSolution option is specified to a solution or to New while PretreatElectrodes is False, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> False,
				ElectrolyteSolution -> Object[Sample, "Example 3M KCl aqueous electrolyte solution for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution electrolyte concentration mismatch with prepared sample *)
		Example[{Messages, "IncompatibleOptions", "If the ElectrolyteSolution's electrolyte concentration does not match with the input sample's electrolyte concentration, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution electrolyte concentration mismatch with ElectrolyteTargetConcentration *)
		Example[{Messages, "IncompatibleOptions", "If the ElectrolyteSolution's electrolyte concentration does not match with the concentration specified by the ElectrolyteTargetConcentration option, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrolyteTargetConcentration -> 100 Millimolar,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, "Example electrolyte solution with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* Solvent sample used to prepare electrolyte solution different from the Solvent sample *)
		Example[{Messages, "MismatchingOptionsWarning", "The user will be warned if the ElectrolyteSolution solvent sample is different from the Solvent sample:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				Solvent -> Model[Sample, "Acetonitrile, HPLC Grade"]
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::MismatchingOptionsWarning},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolutionLoadingVolume Option *)
		(* ElectrolyteSolutionLoadingVolume is not resolved to Null *)
		Example[{Messages, "NonNullOption", "If the ElectrolyteSolutionLoadingVolume option is specified while PretreatElectrodes is False, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> False,
				ElectrolyteSolutionLoadingVolume -> 10 Milliliter
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolutionLoadingVolume is missing *)
		Example[{Messages, "MissingOption", "The ElectrolyteSolutionLoadingVolume option is set to Null while PretreatElectrodes is True, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				ElectrolyteSolutionLoadingVolume -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteTargetConcentration is missing *)
		Example[{Messages, "MissingOptionUnpreparedSample", "The ElectrolyteTargetConcentration option is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrolyteTargetConcentration -> Null
			],
			$Failed,
			Messages :> {Error::MissingOptionUnpreparedSample, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolutionLoadingVolume is to small *)
		Example[{Messages, "TooSmallVolume", "If the ElectrolyteSolutionLoadingVolume is less than 30% of the ReactionVessel's MaxVolume, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrodeCap -> Model[Item, Cap, ElectrodeCap, "IKA Regular Large Electrode Cap"],
				ReactionVessel -> Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				ElectrolyteSolutionLoadingVolume -> 3 Milliliter
			],
			$Failed,
			Messages :> {Error::TooSmallVolume, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolutionLoadingVolume is to large *)
		Example[{Messages, "TooLargeVolume", "If the ElectrolyteSolutionLoadingVolume is greater than 90% of the ReactionVessel's MaxVolume, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				ElectrolyteSolutionLoadingVolume -> 19 Milliliter
			],
			$Failed,
			Messages :> {Error::TooLargeVolume, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* LoadingSampleElectrolyteAmount Option *)
		(* LoadingSampleElectrolyteAmount is not resolved to Null *)
		Example[{Messages, "SpecifiedOptionPreparedSample", "If the LoadingSampleElectrolyteAmount option is specified for prepared liquid input sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleElectrolyteAmount -> 1 Gram
			],
			$Failed,
			Messages :> {Error::SpecifiedOptionPreparedSample, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* LoadingSampleElectrolyteAmount is missing *)
		Example[{Messages, "MissingOptionUnpreparedSample", "If the LoadingSampleElectrolyteAmount option is set to Null for a unprepared solid sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleElectrolyteAmount -> Null
			],
			$Failed,
			Messages :> {Error::MissingOptionUnpreparedSample, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteSolution is missing *)
		Example[{Messages, "MissingOption", "If the ElectrolyteSolution option is set to Null when PretreatElectrodes option is set to True, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* LoadingSampleElectrolyteAmount mismatch ElectrolyteTargetConcentration *)
		Example[{Messages, "IncompatibleOptions", "If the electrolyte concentration specified by LoadingSampleElectrolyteAmount option does not match with the concentration specified by the ElectrolyteTargetConcentration option, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleElectrolyteAmount -> 0.5 Gram,
				ElectrolyteTargetConcentration -> 100 Millimolar
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteTargetConcentration Option *)
		(* ElectrolyteTargetConcentration is too low *)
		Example[{Messages, "TooLowConcentration", "If the specified ElectrolyteTargetConcentration (or the concentration determined by LoadingSampleElectrolyteAmount and SolventVolume) leads to an electrolyte concentration lower than 0.05 Molar (for organic solvent) or 0.1 Molar (for aqueous solvent), an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrolyteTargetConcentration -> 0.01 Molar
			],
			$Failed,
			Messages :> {Error::TooLowConcentration, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TooLowConcentration", "If the specified ElectrolyteTargetConcentration (or the concentration determined by LoadingSampleElectrolyteAmount and SolventVolume) leads to an electrolyte concentration lower than 0.05 Molar (for organic solvent) or 0.1 Molar (for aqueous solvent), an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrolyteTargetConcentration -> 0.05 Molar,
				Solvent -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::TooLowConcentration, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteTargetConcentration is to high *)
		Example[{Messages, "TooHighConcentration", "If the specified ElectrolyteTargetConcentration (or the concentration determined by LoadingSampleElectrolyteAmount and SolventVolume) leads to an electrolyte concentration higher than 0.5 Molar (for organic solvent) or 3 Molar (for aqueous solvent), an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrolyteTargetConcentration -> 0.55 Molar
			],
			$Failed,
			Messages :> {Error::TooHighConcentration, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TooHighConcentration", "If the specified ElectrolyteTargetConcentration (or the concentration determined by LoadingSampleElectrolyteAmount and SolventVolume) leads to an electrolyte concentration higher than 0.5 Molar (for organic solvent) or 3 Molar (for aqueous solvent), an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrolyteTargetConcentration -> 3.05 Molar,
				Solvent -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::TooHighConcentration, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ElectrolyteTargetConcentration electrolyte concentration mismatch with prepared sample *)
		Example[{Messages, "IncompatibleOptions", "If the ElectrolyteTargetConcentration's electrolyte concentration does not match with the concentration specified by the prepared liquid sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				ElectrolyteTargetConcentration -> 0.3 Molar
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions,Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If the electrolyte concentration specified by LoadingSampleElectrolyteAmount option does not match with the concentration specified by the ElectrolyteTargetConcentration option, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleElectrolyteAmount -> 200 Milligram,
				ElectrolyteTargetConcentration -> 100 Millimolar
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* --------------------------------------------------- *)
		(* -- ReferenceElectrode, ReferenceSolution options -- *)
		(* --------------------------------------------------- *)
		(* -- Unprepared Reference Electrode -- *)
		Example[{Messages, "ReferenceElectrode", "If the specified reference electrode is an unprepared model, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]
			],
			$Failed,
			Messages :> {Error::ReferenceElectrode, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- RefreshReferenceElectrode Option -- *)
		Example[{Messages, "ReferenceElectrode", "If the RefreshReferenceElectrode option is set to False when the ReferenceElectrode needs a reference solution refresh, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Milli-Q water"],
				RefreshReferenceElectrode -> False,
				ReferenceElectrode -> Object[Item, Electrode, ReferenceElectrode, "Example reference electrode 2 for CyclicVoltammetry tests" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::ReferenceElectrode, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ReferenceElectrode Option -- *)

		Example[{Messages, "ReferenceElectrode", "If errors were encountered when the information is fetched for the ReferenceSolution of the ReferenceElectrode, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution error for CyclicVoltammetry tests" <> $SessionUUID],
				RefreshReferenceElectrode -> True
			],
			$Failed,
			Messages :> {Error::ReferenceElectrode, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MismatchingOptionsWarning", "The user will be warned if the RecommendedSolventType of the ReferenceElectrode does not match with the Solvent option:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				ReferenceElectrode -> Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution mismatching solvent type for CyclicVoltammetry tests" <> $SessionUUID]
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::MismatchingOptionsWarning},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MismatchingOptionsWarning", "The user will be warned if the solvent molecule used to prepare the ReferenceSolution in the ReferenceElectrode does not match with the solvent molecule specified by the Solvent option:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Solvent -> Model[Sample, "Acetonitrile, Electronic Grade"],
				ReferenceElectrode -> Model[Item,Electrode,ReferenceElectrode, "Example reference electrode model with default solution mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID],
				RefreshReferenceElectrode -> True
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::MismatchingOptionsWarning},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MismatchingOptionsWarning", "The user will be warned if the electrolyte molecule used to prepare the ReferenceSolution in the ReferenceElectrode does not match with the electrolyte molecule specified by the Electrolyte option:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				ReferenceElectrode -> Model[Item,Electrode,ReferenceElectrode, "Example reference electrode model with default solution mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID],
				RefreshReferenceElectrode -> True
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::MismatchingOptionsWarning},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MismatchingOptionsWarning", "The user will be warned if the electrolyte molecule concentration used to prepare the ReferenceSolution in the ReferenceElectrode does not match with the electrolyte molecule concentration specified by the ElectrolyteTargetConcentration option:"},
			ExperimentCyclicVoltammetry[
				Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ElectrolyteTargetConcentration -> 100 Millimolar,
				ReferenceElectrode -> Model[Item,Electrode,ReferenceElectrode, "Example reference electrode model with default solution mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID],
				RefreshReferenceElectrode -> True
			],
			ObjectReferenceP[Object[Protocol, CyclicVoltammetry]],
			Messages :> {Warning::MismatchingOptionsWarning},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- ReferenceElectrodeSoakTime Option -- *)
		Example[{Messages, "TooLongSoakTime", "If the specified ReferenceElectrodeSoakTime is longer than 1 hour, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				ReferenceElectrodeSoakTime -> 61 Minute
			],
			$Failed,
			Messages :> {Error::TooLongSoakTime, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -------------------------------------- *)
		(* -- InternalStandard related options -- *)
		(* -------------------------------------- *)
		(* -- InvalidInput -- *)
		Example[{Messages, "InternalStandard", "If the input prepared liquid sample does not have 3 non-Null entries in its Composition field when InternalStandard is set to None, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PreparedSample -> True,
				InternalStandard -> None
			],
			$Failed,
			Messages :> {Error::InternalStandard, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "InternalStandard", "If the input prepared liquid sample does not have 3 non-Null entries in its Composition field when InternalStandardAdditionOrder is set to After, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PreparedSample -> True,
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> After
			],
			$Failed,
			Messages :> {Error::InternalStandard, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "InternalStandard", "If the input prepared liquid sample does not have 3 non-Null entries in its Composition field when InternalStandardAdditionOrder is set to After, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before
			],
			$Failed,
			Messages :> {Error::InternalStandard, Error::InvalidInput},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- InternalStandard Option -- *)
		Example[{Messages, "ChemicalNotSolid", "If the provided InternalStandard is not a solid, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::ChemicalNotSolid, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "AmbiguousComposition", "If the provided InternalStandard chemical has no entry or more than one non-Null entry in its Composition field, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> Model[Sample, "Example internal standard with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandardAdditionOrder -> After,
				InternalStandardAmount -> 100 Milligram
			],
			$Failed,
			Messages :> {Error::AmbiguousComposition, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "InternalStandard", "If the molecule of the provided InternalStandard is not a member of the Composition field of the prepared liquid sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PreparedSample -> True,
				InternalStandard -> Model[Sample, "Potassium Chloride"],
				InternalStandardAdditionOrder -> Before
			],
			$Failed,
			Messages :> {Error::InternalStandard, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- InternalStandardAdditionOrder Option -- *)
		Example[{Messages, "NonNullOption", "If the InternalStandardAdditionOrder is not Null when InternalStandard is set to None, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> None,
				InternalStandardAdditionOrder -> Before
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If the InternalStandardAdditionOrder is set to Null when InternalStandard is provided, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "InternalStandard", "If the molecule of the provided InternalStandard is already a member of the Composition field of the prepared liquid sample while the InternalStandardAdditionOrder is set to After, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> After
			],
			$Failed,
			Messages :> {Error::InternalStandard, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- InternalStandardTargetConcentration Option -- *)
		Example[{Messages, "NonNullOption", "If the InternalStandardTargetConcentration is not Null when InternalStandard is set to None, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> None,
				InternalStandardTargetConcentration -> 10 Millimolar
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "ConditionalSpecifiedOptionPreparedSample", "If the InternalStandardTargetConcentration is not Null when InternalStandardAdditionOrder is set to Before, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PreparedSample -> True,
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardTargetConcentration -> 10 Millimolar
			],
			$Failed,
			Messages :> {Error::ConditionalSpecifiedOptionPreparedSample, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If the InternalStandardTargetConcentration is set to Null when InternalStandardAdditionOrder is set to After, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> After,
				InternalStandardTargetConcentration -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If the InternalStandardTargetConcentration is set to Null when InternalStandardAdditionOrder is set to Before for unprepared solid sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardTargetConcentration -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TooLowConcentration", "If the InternalStandardTargetConcentration is less than 1 Millimolar, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardTargetConcentration -> 0.5 Millimolar
			],
			$Failed,
			Messages :> {Error::TooLowConcentration, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TooHighConcentration", "If the InternalStandardTargetConcentration is greater than 15 Millimolar, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardTargetConcentration -> 15.5 Millimolar
			],
			$Failed,
			Messages :> {Error::TooHighConcentration, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If the provided InternalStandardTargetConcentration and InternalStandardAmount do not agree with each other, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardAmount -> 100 Milligram,
				InternalStandardTargetConcentration -> 10 Millimolar
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- InternalStandardAmount Option -- *)
		Example[{Messages, "NonNullOption", "If the InternalStandardAmount is not Null when InternalStandard is set to None, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> None,
				InternalStandardAmount -> 100 Milligram
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "ConditionalSpecifiedOptionPreparedSample", "If the InternalStandardAmount is not Null when InternalStandardAdditionOrder is set to Before, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Electrolyte -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				PreparedSample -> True,
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardAmount -> 100 Milligram
			],
			$Failed,
			Messages :> {Error::ConditionalSpecifiedOptionPreparedSample, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If the InternalStandardAmount is set to Null when InternalStandardAdditionOrder is set to After, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> After,
				InternalStandardAmount -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If the InternalStandardAmount is set to Null when InternalStandardAdditionOrder is set to Before for unprepared solid sample, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardAmount -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If the provided InternalStandardTargetConcentration and InternalStandardAmount do not agree with each other, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				InternalStandard -> Model[Sample, "Ferrocene"],
				InternalStandardAdditionOrder -> Before,
				InternalStandardAmount -> 100 Milligram,
				InternalStandardTargetConcentration -> 10 Millimolar
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ---------------------------------------- *)
		(* -- PretreatElectrodes related options -- *)
		(* ---------------------------------------- *)
		Example[{Messages, "NonNullOption", "If PretreatmentSparging is not Null or Automatic when PretreatElectrodes is False, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> False,
				PretreatmentSparging -> True
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PretreatmentSparging is Null when PretreatElectrodes is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentSparging -> Null,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"]
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If PretreatmentSpargingPreBubbler is specified and PretreatElectrodes is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentSpargingPreBubbler -> True,
				PretreatElectrodes -> False
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PretreatmentSpargingPreBubbler is Null when PretreatElectrodes is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentSpargingPreBubbler -> Null,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"]
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If PretreatmentSpargingPreBubbler is True when PretreatmentSparging is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentSparging -> False,
				PretreatmentSpargingPreBubbler -> True
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If PretreatmentInitialPotential is specified when PretreatElectrodes is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentInitialPotential -> 0.5 Volt,
				PretreatElectrodes -> False
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PretreatmentInitialPotential is Null when PretreatElectrodes is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentInitialPotential -> Null,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"]
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If PretreatmentFirstPotential is specified and PretreatElectrodes is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentFirstPotential -> 0.5 Volt,
				PretreatElectrodes -> False
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PretreatmentFirstPotential is Null and PretreatElectrodes is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentFirstPotential -> Null,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"]
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If PretreatmentSecondPotential is specified when PretreatElectrodes is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentSecondPotential -> 0.1 Volt,
				PretreatElectrodes -> False
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PretreatmentSecondPotential is Null when PretreatElectrodes is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentSecondPotential -> Null,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"]
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If PretreatmentFinalPotential is specified when PretreatElectrodes is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentFinalPotential -> 0.1 Volt,
				PretreatElectrodes -> False
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PretreatmentFinalPotential is Null when PretreatElectrodes is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentFinalPotential -> Null,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"]
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatiblePotentials", "If PretreatmentInitialPotential is not between PretreatmentFirstPotential and PretreatmentSecondPotential, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentInitialPotential -> -0.3 Volt,
				PretreatmentFirstPotential -> 0.3 Volt,
				PretreatmentSecondPotential -> -0.2 Volt
			],
			$Failed,
			Messages :> {Error::IncompatiblePotentials, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatiblePotentials", "If PretreatmentFinalPotential is not between PretreatmentFirstPotential and PretreatmentSecondPotential, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentFinalPotential -> -0.3 Volt,
				PretreatmentFirstPotential -> 0.3 Volt,
				PretreatmentSecondPotential -> -0.2 Volt
			],
			$Failed,
			Messages :> {Error::IncompatiblePotentials, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TooDifferentPotentials", "The voltage difference between PretreatmentInitialPotential and PretreatmentFinalPotential is greater than 0.5 Volt, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
				PretreatmentInitialPotential -> 0.1 Volt,
				PretreatmentFinalPotential -> 0.7 Volt
			],
			$Failed,
			Messages :> {Error::TooDifferentPotentials, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If PretreatmentPotentialSweepRate is specified when PretreatElectrodes is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentPotentialSweepRate -> 0.01 Volt/Second,
				PretreatElectrodes -> False
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PretreatmentPotentialSweepRate is Null when PretreatElectrodes is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentPotentialSweepRate -> Null,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"]
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If PretreatmentNumberOfCycles is specified when PretreatElectrodes is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentNumberOfCycles -> 2,
				PretreatElectrodes -> False
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If PretreatmentNumberOfCycles is Null when PretreatElectrodes is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PretreatmentNumberOfCycles -> Null,
				PretreatElectrodes -> True,
				ElectrolyteSolution -> Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"]
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],


		(* ---------------------------------------- *)
		(* -- Loading Sample Mix related options -- *)
		(* ---------------------------------------- *)
		Example[{Messages, "IncompatibleOptions", "If LoadingSampleMix is False when the input sample is an unprepared solid, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> False
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMixType is specified, but LoadingSampleMix is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleMix -> False,
				LoadingSampleMixType -> Shake
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If LoadingSampleMixType is Null when LoadingSampleMix is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMixTemperature is specified, but LoadingSampleMix is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleMix -> False,
				LoadingSampleMixTemperature -> 30 Celsius
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If LoadingSampleMixTemperature is Null when LoadingSampleMix is True, and error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixTemperature -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If LoadingSampleMixType is Invert or Pipette and the LoadingSampleMixTemperature is not Ambient, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Pipette,
				LoadingSampleMixTemperature -> 50 Celsius
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMixUntilDissolved is specified when LoadingSampleMix is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleMix -> False,
				LoadingSampleMixUntilDissolved -> True
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If LoadingSampleMixUntilDissolved is Null when LoadingSampleMix is True, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixUntilDissolved -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMaxNumberOfMixes is specified when LoadingSampleMix is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleMix -> False,
				LoadingSampleMaxNumberOfMixes -> 20
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMaxNumberOfMixes is specified when LoadingSampleMixUntilDissolved is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Invert,
				LoadingSampleMixUntilDissolved -> False,
				LoadingSampleMaxNumberOfMixes -> 20
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMaxNumberOfMixes is specified when LoadingSampleMixType is Shake, and error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Shake,
				LoadingSampleMaxNumberOfMixes -> 10
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If LoadingSampleMaxNumberOfMixes is Null when the LoadingSampleMixType is Pipette or Invert and LoadingSampleMixUntilDissolved is Ture, adn error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Pipette,
				LoadingSampleMixUntilDissolved -> True,
				LoadingSampleMaxNumberOfMixes -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If the LoadingSampleMaxMixTime is specified when LoadingSampleMix is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleMix -> False,
				LoadingSampleMaxMixTime -> 10 Minute
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMaxMixTime is specified when LoadingSampleMixUntilDissolved is False, and error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Shake,
				LoadingSampleMixUntilDissolved -> False,
				LoadingSampleMaxMixTime -> 10 Minute
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If the LoadingSampleMaxMixTime is specified when the LoadingSampleMixType is set to Pipette or Invert, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Pipette,
				LoadingSampleMaxMixTime -> 1 Minute
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If the LoadingSampleMaxMixTime is Null when LoadingSampleMix is True, LoadingSampleMixType is Shake, and LoadingSampleMixUntilDissolved is True, and error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Shake,
				LoadingSampleMixUntilDissolved -> True,
				LoadingSampleMaxMixTime -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMixTime is specified when LoadingSampleMix is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleMix -> False,
				LoadingSampleMixTime -> 1 Minute
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMixTime is specified when LoadingSampleMixType is Pipette or Invert, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Pipette,
				LoadingSampleMixTime -> 1 Minute
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If LoadingSampleMixTime is Null when LoadingSampleMix is True, LoadingSampleMixType is Shake, and LoadingSampleUntilDissolved is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Shake,
				LoadingSampleMixUntilDissolved -> False,
				LoadingSampleMixTime -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If LoadingSampleMixTime is greater than LoadingSampleMaxMixTime, and error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Shake,
				LoadingSampleMixTime -> 10 Minute,
				LoadingSampleMaxMixTime -> 1 Minute
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleNumberOfMixes is specified when LoadingSampleMix is False, and error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleMix -> False,
				LoadingSampleNumberOfMixes -> 20
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleNumberOfMixes is specified when LoadingSampleMixType is Shake, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Shake,
				LoadingSampleNumberOfMixes -> 20
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If LoadingSampleNumberOfMixes is Null when LoadingSampleMix is True, LoadingSampleMixType is Pipette or Invert, and LoadingSampleMixUntilDissolved is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMix -> True,
				LoadingSampleMixType -> Invert,
				LoadingSampleMixUntilDissolved -> False,
				LoadingSampleNumberOfMixes -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If the LoadingSampleNumberOfMixes is greater than LoadingSampleMaxNumberOfMixes, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Invert,
				LoadingSampleMaxNumberOfMixes -> 10,
				LoadingSampleNumberOfMixes -> 20
			],
			$Failed,
			Messages :> {Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMixVolume is specified when LoadingSampleMix is False, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
				PreparedSample -> True,
				LoadingSampleMix -> False,
				LoadingSampleMixVolume -> 3 Milliliter
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If LoadingSampleMixVolume is specified when LoadingSampleMixType is not Pipette, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Shake,
				LoadingSampleMixVolume -> 3 Milliliter
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If LoadingSampleMixVolume is Null when LoadingSampleMixType is Pipette, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				LoadingSampleMixType -> Pipette,
				LoadingSampleMixVolume -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatibleOptions", "If LoadingSampleMixVolume is greater than SolventVolume, an error is thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				SolventVolume -> 12 Milliliter,
				LoadingSampleMixType -> Pipette,
				LoadingSampleMixVolume -> 15 Milliliter
			],
			$Failed,
			Messages :> {Warning::ExcessiveSolventVolume,Error::IncompatibleOptions, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],


		(* ------------------------------ *)
		(* -- Sparging related options -- *)
		(* ------------------------------ *)

		Example[{Messages, "NonNullOption", "If SpargingGas is specified while Sparging is False, and error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> False,
				SpargingGas -> Nitrogen
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If Sparging is True, but SpargingGas is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				SpargingGas -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If SpargingTime is specified while Sparging is False, and error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> False,
				SpargingTime -> 5 Minute
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If Sparging is True, but SpargingTime is set to Null, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				SpargingTime -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "TooLongSpargingTime", "If the SpargingTime exceeds 1 Hour, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				SpargingTime -> 2 Hour
			],
			$Failed,
			Messages :> {Error::TooLongSpargingTime, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "NonNullOption", "If SpargingPreBubbler is specified when Sparging is False, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> False,
				SpargingPreBubbler -> True
			],
			$Failed,
			Messages :> {Error::NonNullOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MissingOption", "If SpargingPreBubbler is Null when Sparging is True, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				Sparging -> True,
				SpargingPreBubbler -> Null
			],
			$Failed,
			Messages :> {Error::MissingOption, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* --------------------------------------------------- *)
		(* -- CyclicVoltammetry Measurement related options -- *)
		(* --------------------------------------------------- *)

		Example[{Messages, "MismatchNumberOfCycles", "If length of InitialPotentials does not match with the NumberOfCycles, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				InitialPotentials -> {0.0 Volt, 0.0 Volt}
			],
			$Failed,
			Messages :> {Error::MismatchNumberOfCycles, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MismatchNumberOfCycles", "If the length of FirstPotentials does not match with NumberOfCycles, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				FirstPotentials -> {2.0 Volt, 2.0 Volt}
			],
			$Failed,
			Messages :> {Error::MismatchNumberOfCycles, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MismatchNumberOfCycles", "If the length of SecondPotentials does not match NumberOfCycles, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				SecondPotentials -> {-2.0 Volt, -2.0 Volt}
			],
			$Failed,
			Messages :> {Error::MismatchNumberOfCycles, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MismatchNumberOfCycles", "If the length of FinalPotentials does not match NumberOfCycles, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				FinalPotentials -> {0.0 Volt, 0.0 Volt}
			],
			$Failed,
			Messages :> {Error::MismatchNumberOfCycles, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "MismatchNumberOfCycles", "If the length of PotentialSweepRates does not match NumberOfCycles, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 3,
				PotentialSweepRates -> {100 Millivolt/Second, 100 Millivolt/Second}
			],
			$Failed,
			Messages :> {Error::MismatchNumberOfCycles, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatiblePotentialLists", "If an element of InitialPotentials does not fall between the corresponding elements of FirstPotentials and SecondPotentials, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 2,
				InitialPotentials -> {0.0 Volt, 0.5 Volt},
				FirstPotentials -> {1.0 Volt, 0.3 Volt},
				SecondPotentials -> {-1.0 Volt, -1.0 Volt}
			],
			$Failed,
			Messages :> {Error::IncompatiblePotentialLists, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "IncompatiblePotentialLists", "If an element of FinalPotentials does not fall between the corresponding elements of FirstPotentials and SecondPotentials, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 2,
				FinalPotentials -> {0.0 Volt, 0.5 Volt},
				FirstPotentials -> {1.0 Volt, 0.3 Volt},
				SecondPotentials -> {-1.0 Volt, -1.0 Volt}
			],
			$Failed,
			Messages :> {Error::IncompatiblePotentialLists, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages, "PotentialsTooDifferent", "If difference between corresponding elements of InitialPotentials and FinalPotentials exceeds 0.5 V, an error will be thrown:"},
			ExperimentCyclicVoltammetry[
				Object[Sample, "Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
				NumberOfCycles -> 2,
				InitialPotentials -> {0.0 Volt, 0.6 Volt},
				FinalPotentials -> {0.0 Volt, 0.0 Volt}
			],
			$Failed,
			Messages :> {Error::PotentialsTooDifferent, Error::InvalidOption},
			SetUp :> (Off[Warning::SamplesOutOfStock];$CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		]

		(* =========== *)
		(* == TESTS == *)
		(* =========== *)

	},
	Parallel -> True,

	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False,
		$AllowPublicObjects = True
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			ClearMemoization[];
			objects = Quiet[Cases[
				Flatten[{

					(* Bench and Instrument *)
					Object[Container, Bench, "Example bench for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Instrument, Reactor, Electrochemical, "Example instrument for CyclicVoltammetry tests" <> $SessionUUID],

					(* Molecule Models *)
					Model[Molecule, "Example electrolyte molecule without DefaultSampleModel" <> $SessionUUID],
					Model[Molecule, "Example electrolyte molecule without MolecularWeight" <> $SessionUUID],
					Model[Molecule, "Example reference coupling sample molecule without MolecularWeight" <> $SessionUUID],

					(* Sample Models *)
					Model[Sample, "Example solid sample model with no Composition for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example solid sample model with no Analytes for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example solid sample model with more than one Analytes for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example solid sample model with invalid Analyte composition unit for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with no Solvent for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with only one Composition entry for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with invalid analyte composition unit in Composition for CyclicVoltammetry tests" <> $SessionUUID],

					(* Specialized Solvent, Electrolyte, ElectrolyteSolution, ReferenceCouplingSample, ReferenceSolution, InternalStandard Models *)
					Model[Sample, "Example solvent with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference coupling sample with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference coupling sample with missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example internal standard with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],

					(* Electrolyte solutions *)
					Model[Sample, "Example electrolyte solution with missing Solvent field for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with missing Analytes field for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with ambiguous Analytes field for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with two electrolyte molecule in Composition field for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with invalid electrolyte molecule composition unit for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with HPLC acetonitrile sample for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID],

					Model[Sample, "Example electrolyte solution with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID],

					(* reference solutions *)
					Model[Sample, "Example reference solution model with information fetching error for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference solution model with mismatching solvent sample for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference solution model with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference solution model with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference solution model with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample, "Example reference solution object with information fetching error for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example reference solution object with mismatching solvent sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example reference solution object with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example reference solution object with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example reference solution object with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID],

					(* Specialized Sample Models *)
					Model[Sample, "Example liquid sample model with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule invalid composition unit for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule not Found for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule duplicated for CyclicVoltammetry tests" <> $SessionUUID],

					(* Sample Objects *)
					Object[Sample, "Example 3M KCl aqueous reference solution for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile reference solution for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile reference solution for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 0.1M [NBu4][PF6] in acetonitrile reference solution for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample, "Example 3M KCl aqueous electrolyte solution for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 0.1M [NBu4][PF6] in acetonitrile electrolyte solution for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample, "Example water for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example acetonitrile for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example HPLC acetonitrile for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample, "Example polishing solution 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example polishing solution 2 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Containers for the above samples *)
					Object[Container, Vessel, "Example chemical container 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 2 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 3 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 4 for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Container, Vessel, "Example chemical container 5 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 6 for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Container, Vessel, "Example chemical container 7 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 8 for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Container, Vessel, "Example chemical container 9 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 10 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 11 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Electrode models *)
					Model[Item, Electrode, "Example deprecated working electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, "Example normal working electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, "Example deprecated counter electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, "Example normal counter electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example deprecated reference electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example normal reference electrode model for CyclicVoltammetry tests" <> $SessionUUID],

					(* Specialized ReferenceElectrode Models *)
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution error for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution mismatching solvent type for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID],

					(* Electrode Objects *)
					Object[Item, Electrode, "Example working electrode 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, Electrode, "Example working electrode 2 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, Electrode, "Example counter electrode for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example reference electrode 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example reference electrode 2 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Misc. *)
					Object[Item, Cap, ElectrodeCap, "Example electrode cap for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 2 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, ElectrodePolishingPad, "Example polishing pad 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, ElectrodePolishingPad, "Example polishing pad 2 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example sample container 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 2 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 3 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 4 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 5 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 6 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 7 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 8 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 9 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 10 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 11 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 12 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 13 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 14 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 15 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 16 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 17 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 18 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 19 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Input Sample Objects *)
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example liquid sample object with no Solvent for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example liquid sample object with only one Composition entry for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example liquid sample object with invalid analyte composition unit in Composition for CyclicVoltammetry tests" <> $SessionUUID],

					(* Specialized sample objects *)
					Object[Sample, "Example liquid sample object with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule invalid composition unit for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule not Found for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule duplicated for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example Bis(pentamethylcyclopentadienyl)iron(II) solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example solid sample object with no Composition for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example solid sample object with no Analytes for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example solid sample object with more than one Analytes for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example solid sample object with invalid Analyte composition unit for CyclicVoltammetry tests" <> $SessionUUID],

					(* Test protocol *)
					Object[Protocol, CyclicVoltammetry,"Example CyclicVoltammetry Protocol for CyclicVoltammetry tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					(* Bench and Instrument *)
					testBench, testBenchPacket, instrument, instrumentPacket,

					(* Molecule Models *)
					testMoleculeModel1, testMoleculeModel2, testMoleculeModel3,
					testMoleculeModel1Packet, testMoleculeModel2Packet, testMoleculeModel3Packet,

					(* Sample Models *)
					testSolidSampleModel1, testSolidSampleModel2, testSolidSampleModel3, testSolidSampleModel4,
					testSolidSampleModel1Packet, testSolidSampleModel2Packet, testSolidSampleModel3Packet, testSolidSampleModel4Packet,

					testLiquidSampleModel1, testLiquidSampleModel2, testLiquidSampleModel3,
					testLiquidSampleModel1Packet, testLiquidSampleModel2Packet, testLiquidSampleModel3Packet,

					(* Specialized Solvent, Electrolyte, ElectrolyteSolution, ReferenceCouplingSample, ReferenceSolution, InternalStandard Models *)
					testSolvent1, testSolvent1Packet,

					testElectrolyte1,
					testElectrolyte1Packet,

					testReferenceCouplingSample1, testReferenceCouplingSample2,
					testReferenceCouplingSample1Packet, testReferenceCouplingSample2Packet,

					testInternalStandard1,
					testInternalStandard1Packet,

					testElectrolyteSolution1, testElectrolyteSolution2, testElectrolyteSolution3, testElectrolyteSolution4, testElectrolyteSolution5, testElectrolyteSolution6, testElectrolyteSolution7, testElectrolyteSolution8, testElectrolyteSolution9, testElectrolyteSolution10, testElectrolyteSolution11, testElectrolyteSolution12,

					testElectrolyteSolution1Packet, testElectrolyteSolution2Packet, testElectrolyteSolution3Packet, testElectrolyteSolution4Packet, testElectrolyteSolution5Packet, testElectrolyteSolution6Packet, testElectrolyteSolution7Packet, testElectrolyteSolution8Packet, testElectrolyteSolution9Packet, testElectrolyteSolution10Packet, testElectrolyteSolution11Packet, testElectrolyteSolution12Packet,

					testReferenceSolutionModel1, testReferenceSolutionModel2, testReferenceSolutionModel3, testReferenceSolutionModel4, testReferenceSolutionModel5,
					testReferenceSolutionModel1Packet, testReferenceSolutionModel2Packet, testReferenceSolutionModel3Packet, testReferenceSolutionModel4Packet, testReferenceSolutionModel5Packet,

					testReferenceSolutionObject1, testReferenceSolutionObject2, testReferenceSolutionObject3, testReferenceSolutionObject4, testReferenceSolutionObject5,
					testReferenceSolutionObject1Packet, testReferenceSolutionObject2Packet, testReferenceSolutionObject3Packet, testReferenceSolutionObject4Packet, testReferenceSolutionObject5Packet,

					(* Specialized sample models *)
					specialSampleModel1, specialSampleModel2, specialSampleModel3, specialSampleModel4, specialSampleModel5, specialSampleModel6,

					specialSampleModel1Packet, specialSampleModel2Packet, specialSampleModel3Packet, specialSampleModel4Packet, specialSampleModel5Packet, specialSampleModel6Packet,

					(* Chemical Objects *)
					referenceSolution1, referenceSolution2, referenceSolution3, referenceSolution4,

					electrolyteSolution1, electrolyteSolution2,

					testWaterSample, testAcetonitrileSample, testHPLCAcetonitrileSample,

					polishingSolution1, polishingSolution2,

					(* Chemical containers *)
					chemicalContainer1, chemicalContainer2, chemicalContainer3, chemicalContainer4, chemicalContainer5, chemicalContainer6, chemicalContainer7, chemicalContainer8, chemicalContainer9, chemicalContainer10, chemicalContainer11,

					(* Electrode models *)
					deprecatedWorkingElectrodeModel, normalWorkingElectrodeModel,
					deprecatedWorkingElectrodeModelPacket, normalWorkingElectrodeModelPacket,
					deprecatedCounterElectrodeModel, normalCounterElectrodeModel,
					deprecatedCounterElectrodeModelPacket, normalCounterElectrodeModelPacket,
					deprecatedReferenceElectrodeModel, normalReferenceElectrodeModel,
					deprecatedReferenceElectrodeModelPacket, normalReferenceElectrodeModelPacket,

					(* Specialized ReferenceElectrode Models *)
					testReferenceElectrodeModel1, testReferenceElectrodeModel2, testReferenceElectrodeModel3, testReferenceElectrodeModel4, testReferenceElectrodeModel5,

					testReferenceElectrodeModel1Packet, testReferenceElectrodeModel2Packet, testReferenceElectrodeModel3Packet, testReferenceElectrodeModel4Packet, testReferenceElectrodeModel5Packet,

					(* Electrode Objects *)
					workingElectrode1, workingElectrode2,
					workingElectrode1Packet, workingElectrode2Packet,
					counterElectrode, counterElectrodePacket,
					referenceElectrode1, referenceElectrode2,
					referenceElectrode1Packet, referenceElectrode2Packet,

					(* Containers *)
					container1, container2, container3, container4, container5, container6, container7,
					container8, container9, container10, container11, container12, container13, container14,
					container15, container16, container17, container18, container19,

					(* Input Sample Objects *)
					liquidSample1, liquidSample2, liquidSample3, liquidSample4, liquidSample5, liquidSample6, liquidSample7,

					liquidSample8, liquidSample9, liquidSample10, liquidSample11, liquidSample12,

					solidSample1, solidSample2, solidSample3, solidSample4, solidSample5, solidSample6, solidSample7,

					(* Misc. *)
					electrodeCap, electrodeCapPacket,
					reactionVessel1, reactionVessel2,
					reactionVessel1Packet, reactionVessel2Packet,
					electrodePolishingPad1, electrodePolishingPad2,
					electrodePolishingPad1Packet, electrodePolishingPad2Packet
				},

				(* set up test bench as a location for the vessel *)
				testBenchPacket = <|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Example bench for CyclicVoltammetry tests" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>;

				(* set up instrument *)
				instrumentPacket = <|
					Type -> Object[Instrument, Reactor, Electrochemical],
					Model -> Link[Model[Instrument, Reactor, Electrochemical, "IKA ElectraSyn 2.0"], Objects],
					Name -> "Example instrument for CyclicVoltammetry tests" <> $SessionUUID,
					Status -> Available,
					DeveloperObject -> True
				|>;

				(* Bench and Instrument upload *)
				{
					testBench,
					instrument
				} = Upload[{
					testBenchPacket,
					instrumentPacket
				}];

				testMoleculeModel1Packet = <|
					Type -> Model[Molecule],
					Name -> "Example electrolyte molecule without DefaultSampleModel" <> $SessionUUID,
					MolecularWeight -> 100 Gram / Mole
				|>;

				testMoleculeModel2Packet = <|
					Type -> Model[Molecule],
					Name -> "Example electrolyte molecule without MolecularWeight" <> $SessionUUID,
					DefaultSampleModel -> Link[Model[Sample, "Tetrabutylammonium hexafluorophosphate"]]
				|>;

				testMoleculeModel3Packet = <|
					Type -> Model[Molecule],
					Name -> "Example reference coupling sample molecule without MolecularWeight" <> $SessionUUID,
					DefaultSampleModel -> Link[Model[Sample, "Silver nitrate"]]
				|>;

				(* Molecule Models upload *)
				{
					testMoleculeModel1,
					testMoleculeModel2,
					testMoleculeModel3
				} = Upload[{
					testMoleculeModel1Packet,
					testMoleculeModel2Packet,
					testMoleculeModel3Packet
				}];

				(* Sample Models *)
				testSolidSampleModel1Packet = <|
					Type -> Model[Sample],
					Name -> "Example solid sample model with no Composition for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Composition] -> {},
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Solid
				|>;

				testSolidSampleModel2Packet = <|
					Type -> Model[Sample],
					Name -> "Example solid sample model with no Analytes for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[Model[Molecule, "Ferrocene"]]}},
					Replace[Analytes] -> {},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Solid
				|>;

				testSolidSampleModel3Packet = <|
					Type -> Model[Sample],
					Name -> "Example solid sample model with more than one Analytes for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Composition] -> {{50 MassPercent, Link[Model[Molecule, "Ferrocene"]]}, {50 MassPercent, Link[Model[Molecule, "Potassium Chloride"]]}},
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]], Link[Model[Molecule, "Potassium Chloride"]]},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Solid
				|>;

				testSolidSampleModel4Packet = <|
					Type -> Model[Sample],
					Name -> "Example solid sample model with invalid Analyte composition unit for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Composition] -> {{100 MassPercent, Link[Model[Molecule, "Ferrocene"]]}},
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Solid
				|>;

				testLiquidSampleModel1Packet = <|
					Type -> Model[Sample],
					Name -> "Example liquid sample model with no Solvent for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					Replace[Composition] -> {{10 Millimolar, Link[Model[Molecule, "Ferrocene"]]}, {100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}, {100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}},
					Solvent -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testLiquidSampleModel2Packet = <|
					Type -> Model[Sample],
					Name -> "Example liquid sample model with only one Composition entry for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Ferrocene"]]}},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testLiquidSampleModel3Packet = <|
					Type -> Model[Sample],
					Name -> "Example liquid sample model with invalid analyte composition unit in Composition for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					Replace[Composition] -> {{10 VolumePercent, Link[Model[Molecule, "Ferrocene"]]}, {100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}, {100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				(* Sample Models upload *)
				{
					testSolidSampleModel1,
					testSolidSampleModel2,
					testSolidSampleModel3,
					testSolidSampleModel4,
					testLiquidSampleModel1,
					testLiquidSampleModel2,
					testLiquidSampleModel3
				} = Upload[{
					testSolidSampleModel1Packet,
					testSolidSampleModel2Packet,
					testSolidSampleModel3Packet,
					testSolidSampleModel4Packet,
					testLiquidSampleModel1Packet,
					testLiquidSampleModel2Packet,
					testLiquidSampleModel3Packet
				}];

				(* Specialized sample models *)
				testSolvent1Packet = <|
					Type -> Model[Sample],
					Name -> "Example solvent with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Composition] -> {{50 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}, {50 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyte1Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
					Replace[Composition] -> {{50 MassPercent, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}, {50 MassPercent, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Solid
				|>;

				testReferenceCouplingSample1Packet = <|
					Type -> Model[Sample],
					Name -> "Example reference coupling sample with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {},
					Replace[Composition] -> {
						{50 MassPercent, Link[Model[Molecule, "Silver nitrate"]]},
						{50 MassPercent, Link[Model[Molecule, "Silver nitrate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Solid
				|>;

				testReferenceCouplingSample2Packet = <|
					Type -> Model[Sample],
					Name -> "Example reference coupling sample with missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Example reference coupling sample molecule without MolecularWeight" <> $SessionUUID]]},
					Replace[Composition] -> {{100 MassPercent, Link[Model[Molecule, "Example reference coupling sample molecule without MolecularWeight" <> $SessionUUID]]}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Solid
				|>;

				testInternalStandard1Packet = <|
					Type -> Model[Sample],
					Name -> "Example internal standard with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {},
					Replace[Composition] -> {
						{50 MassPercent, Link[Model[Molecule, "Ferrocene"]]},
						{50 MassPercent, Link[Model[Molecule, "Ferrocene"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Solid
				|>;

				{
					testSolvent1,
					testElectrolyte1,
					testReferenceCouplingSample1,
					testReferenceCouplingSample2,
					testInternalStandard1
				} = Upload[{
					testSolvent1Packet,
					testElectrolyte1Packet,
					testReferenceCouplingSample1Packet,
					testReferenceCouplingSample2Packet,
					testInternalStandard1Packet
				}];

				(* Example electrolyte solutions *)
				testElectrolyteSolution1Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with missing Solvent field for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
					Solvent -> Null,
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution2Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with missing Analytes field for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution3Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with ambiguous Analytes field for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]], Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution4Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
					Solvent -> Link[Model[Sample, "Example solvent with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution5Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with two electrolyte molecule in Composition field for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution6Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with invalid electrolyte molecule composition unit for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{10 MassPercent, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution7Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with HPLC acetonitrile sample for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
					Solvent -> Link[Model[Sample, "Milli-Q water"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution8Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
					Solvent -> Link[Model[Sample, "Milli-Q water"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution9Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Example electrolyte molecule without DefaultSampleModel" <> $SessionUUID]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Example electrolyte molecule without DefaultSampleModel" <> $SessionUUID]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution10Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Example electrolyte molecule without MolecularWeight" <> $SessionUUID]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Example electrolyte molecule without MolecularWeight" <> $SessionUUID]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution11Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Potassium Chloride"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Potassium Chloride"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testElectrolyteSolution12Packet = <|
					Type -> Model[Sample],
					Name -> "Example electrolyte solution with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{50 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				{
					testElectrolyteSolution1,
					testElectrolyteSolution2,
					testElectrolyteSolution3,
					testElectrolyteSolution4,
					testElectrolyteSolution5,
					testElectrolyteSolution6,
					testElectrolyteSolution7,
					testElectrolyteSolution8,
					testElectrolyteSolution9,
					testElectrolyteSolution10,
					testElectrolyteSolution11,
					testElectrolyteSolution12
				} = Upload[{
					testElectrolyteSolution1Packet,
					testElectrolyteSolution2Packet,
					testElectrolyteSolution3Packet,
					testElectrolyteSolution4Packet,
					testElectrolyteSolution5Packet,
					testElectrolyteSolution6Packet,
					testElectrolyteSolution7Packet,
					testElectrolyteSolution8Packet,
					testElectrolyteSolution9Packet,
					testElectrolyteSolution10Packet,
					testElectrolyteSolution11Packet,
					testElectrolyteSolution12Packet
				}];

				(* reference solutions *)
				testReferenceSolutionModel1Packet = <|
					Type -> Model[Sample],
					Name -> "Example reference solution model with information fetching error for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testReferenceSolutionModel2Packet = <|
					Type -> Model[Sample],
					Name -> "Example reference solution model with mismatching solvent sample for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Silver nitrate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, HPLC Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testReferenceSolutionModel3Packet = <|
					Type -> Model[Sample],
					Name -> "Example reference solution model with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Silver nitrate"]]},
					Solvent -> Link[Model[Sample, "Milli-Q water"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testReferenceSolutionModel4Packet = <|
					Type -> Model[Sample],
					Name -> "Example reference solution model with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Silver nitrate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]]},
						{100 Millimolar, Link[Model[Molecule, "Potassium Chloride"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testReferenceSolutionModel5Packet = <|
					Type -> Model[Sample],
					Name -> "Example reference solution model with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Silver nitrate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]]},
						{50 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]}
					},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				testReferenceSolutionObject1Packet = <|
					Type -> Object[Sample],
					Name -> "Example reference solution object with information fetching error for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]], Now},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]], Now},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]], Now}
					},
					State -> Liquid
				|>;

				testReferenceSolutionObject2Packet = <|
					Type -> Object[Sample],
					Name -> "Example reference solution object with mismatching solvent sample for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Silver nitrate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, HPLC Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]], Now},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]], Now},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]], Now}
					},
					State -> Liquid
				|>;

				testReferenceSolutionObject3Packet = <|
					Type -> Object[Sample],
					Name -> "Example reference solution object with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Silver nitrate"]]},
					Solvent -> Link[Model[Sample, "Milli-Q water"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]], Now},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]], Now}
					},
					State -> Liquid
				|>;

				testReferenceSolutionObject4Packet = <|
					Type -> Object[Sample],
					Name -> "Example reference solution object with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Silver nitrate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]], Now},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]], Now},
						{100 Millimolar, Link[Model[Molecule, "Potassium Chloride"]], Now}
					},
					State -> Liquid
				|>;

				testReferenceSolutionObject5Packet = <|
					Type -> Object[Sample],
					Name -> "Example reference solution object with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Silver nitrate"]]},
					Solvent -> Link[Model[Sample, "Acetonitrile, Electronic Grade"]],
					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]], Now},
						{100 Millimolar, Link[Model[Molecule, "Silver nitrate"]], Now},
						{50 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]], Now}
					},
					State -> Liquid
				|>;

				{
					testReferenceSolutionModel1,
					testReferenceSolutionModel2,
					testReferenceSolutionModel3,
					testReferenceSolutionModel4,
					testReferenceSolutionModel5,
					testReferenceSolutionObject1,
					testReferenceSolutionObject2,
					testReferenceSolutionObject3,
					testReferenceSolutionObject4,
					testReferenceSolutionObject5
				} = Upload[{
					testReferenceSolutionModel1Packet,
					testReferenceSolutionModel2Packet,
					testReferenceSolutionModel3Packet,
					testReferenceSolutionModel4Packet,
					testReferenceSolutionModel5Packet,
					testReferenceSolutionObject1Packet,
					testReferenceSolutionObject2Packet,
					testReferenceSolutionObject3Packet,
					testReferenceSolutionObject4Packet,
					testReferenceSolutionObject5Packet
				}];

				(* Specialized sample objects *)
				specialSampleModel1Packet = <|
					Type -> Model[Sample],
					Name -> "Example liquid sample model with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					Replace[Composition] -> {
						{5 Millimolar, Link[Model[Molecule, "Ferrocene"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}
					},
					Solvent -> Link[Model[Sample, "Example solvent with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID]],
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				specialSampleModel2Packet = <|
					Type -> Model[Sample],
					Name -> "Example liquid sample model with electrolyte molecule invalid composition unit for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					Replace[Composition] -> {
						{5 Millimolar, Link[Model[Molecule, "Ferrocene"]]},
						{50 MassPercent, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}
					},
					Solvent -> Link[Model[Sample, "Acetonitrile, HPLC Grade"]],
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				specialSampleModel3Packet = <|
					Type -> Model[Sample],
					Name -> "Example liquid sample model with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					Replace[Composition] -> {
						{5 Millimolar, Link[Model[Molecule, "Ferrocene"]]},
						{100 Millimolar, Link[Model[Molecule, "Example electrolyte molecule without MolecularWeight" <> $SessionUUID]]},
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}
					},
					Solvent -> Link[Model[Sample, "Acetonitrile, HPLC Grade"]],
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				specialSampleModel4Packet = <|
					Type -> Model[Sample],
					Name -> "Example liquid sample model with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					Replace[Composition] -> {
						{5 Millimolar, Link[Model[Molecule, "Ferrocene"]]},
						{100 Millimolar, Link[Model[Molecule, "Example electrolyte molecule without DefaultSampleModel" <> $SessionUUID]]},
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}
					},
					Solvent -> Link[Model[Sample, "Acetonitrile, HPLC Grade"]],
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				specialSampleModel5Packet = <|
					Type -> Model[Sample],
					Name -> "Example liquid sample model with electrolyte molecule not Found for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					Replace[Composition] -> {
						{5 Millimolar, Link[Model[Molecule, "Ferrocene"]]},
						{5 Millimolar, Link[Model[Molecule, "Silver nitrate"]]},
						{100 Millimolar, Link[Model[Molecule, "Sodium Chloride"]]},
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}
					},
					Solvent -> Link[Model[Sample, "Acetonitrile, HPLC Grade"]],
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				specialSampleModel6Packet = <|
					Type -> Model[Sample],
					Name -> "Example liquid sample model with electrolyte molecule duplicated for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[Analytes] -> {Link[Model[Molecule, "Ferrocene"]]},
					Replace[Composition] -> {
						{5 Millimolar, Link[Model[Molecule, "Ferrocene"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
						{100 Millimolar, Link[Model[Molecule, "Tetrabutylammonium hexafluorophosphate"]]},
						{100 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}
					},
					Solvent -> Link[Model[Sample, "Acetonitrile, HPLC Grade"]],
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid
				|>;

				{
					specialSampleModel1,
					specialSampleModel2,
					specialSampleModel3,
					specialSampleModel4,
					specialSampleModel5,
					specialSampleModel6
				} = Upload[{
					specialSampleModel1Packet,
					specialSampleModel2Packet,
					specialSampleModel3Packet,
					specialSampleModel4Packet,
					specialSampleModel5Packet,
					specialSampleModel6Packet
				}];

				(* Upload chemical containers *)
				{
					chemicalContainer1,
					chemicalContainer2,
					chemicalContainer3,
					chemicalContainer4,

					chemicalContainer5,
					chemicalContainer6,

					chemicalContainer7,
					chemicalContainer8,

					chemicalContainer9,
					chemicalContainer10,

					chemicalContainer11
				} = UploadSample[
					{
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],

						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],

						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],

						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],

						Model[Container, Vessel, "id:bq9LA0dBGGR6"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench}
					},
					Status ->
						{
							Available,
							Available,
							Available,
							Available,

							Available,
							Available,

							Available,
							Available,

							Available,
							Available,

							Available
						},
					Name ->
						{
							"Example chemical container 1 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example chemical container 2 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example chemical container 3 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example chemical container 4 for CyclicVoltammetry tests" <> $SessionUUID,

							"Example chemical container 5 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example chemical container 6 for CyclicVoltammetry tests" <> $SessionUUID,

							"Example chemical container 7 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example chemical container 8 for CyclicVoltammetry tests" <> $SessionUUID,

							"Example chemical container 9 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example chemical container 10 for CyclicVoltammetry tests" <> $SessionUUID,

							"Example chemical container 11 for CyclicVoltammetry tests" <> $SessionUUID
						}
				];

				(* Chemical Sample Objects *)
				{
					referenceSolution1,
					referenceSolution2,
					referenceSolution3,
					referenceSolution4,

					electrolyteSolution1,
					electrolyteSolution2,

					testWaterSample,
					testAcetonitrileSample,

					polishingSolution1,
					polishingSolution2,

					testHPLCAcetonitrileSample
				} = UploadSample[
					{
						(* Models *)
						Model[Sample, StockSolution, "3M KCl Aqueous Solution, 10 mL"],
						Model[Sample, StockSolution, "0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"],
						Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"],
						Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 10 mL"],

						Model[Sample, StockSolution, "3M KCl Aqueous Solution, 20 mL"],
						Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 20 mL"],

						Model[Sample, "Milli-Q water"],
						Model[Sample, "Acetonitrile, Electronic Grade"],

						Model[Sample, "1 um diamond polish, KitComponent"],
						Model[Sample, "0.05 um Polishing alumina, KitComponent"],

						Model[Sample, "Example electrolyte solution with HPLC acetonitrile sample for CyclicVoltammetry tests" <> $SessionUUID]
					},
					{
						{"A1", chemicalContainer1},
						{"A1", chemicalContainer2},
						{"A1", chemicalContainer3},
						{"A1", chemicalContainer4},

						{"A1", chemicalContainer5},
						{"A1", chemicalContainer6},

						{"A1", chemicalContainer7},
						{"A1", chemicalContainer8},

						{"A1", chemicalContainer9},
						{"A1", chemicalContainer10},

						{"A1", chemicalContainer11}
					},
					InitialAmount ->
						{
							100*Milliliter,
							100*Milliliter,
							100*Milliliter,
							100*Milliliter,

							100*Milliliter,
							100*Milliliter,

							100*Milliliter,
							100*Milliliter,

							100*Milliliter,
							100*Milliliter,

							100*Milliliter
						},
					Name ->
						{
							"Example 3M KCl aqueous reference solution for CyclicVoltammetry tests" <> $SessionUUID,
							"Example 0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile reference solution for CyclicVoltammetry tests" <> $SessionUUID,
							"Example 0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile reference solution for CyclicVoltammetry tests" <> $SessionUUID,
							"Example 0.1M [NBu4][PF6] in acetonitrile reference solution for CyclicVoltammetry tests" <> $SessionUUID,

							"Example 3M KCl aqueous electrolyte solution for CyclicVoltammetry tests" <> $SessionUUID,
							"Example 0.1M [NBu4][PF6] in acetonitrile electrolyte solution for CyclicVoltammetry tests" <> $SessionUUID,

							"Example water for CyclicVoltammetry tests" <> $SessionUUID,
							"Example acetonitrile for CyclicVoltammetry tests" <> $SessionUUID,

							"Example polishing solution 1 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example polishing solution 2 for CyclicVoltammetry tests" <> $SessionUUID,

							"Example HPLC acetonitrile for CyclicVoltammetry tests" <> $SessionUUID
						},
					State ->
						{
							Liquid,
							Liquid,
							Liquid,
							Liquid,

							Liquid,
							Liquid,

							Liquid,
							Liquid,

							Liquid,
							Liquid,

							Liquid
						}
				];

				(* Electrode Models *)
				(* set up working, counter, and reference electrodes models *)
				deprecatedWorkingElectrodeModelPacket = <|
					Type -> Model[Item, Electrode],
					Name -> "Example deprecated working electrode model for CyclicVoltammetry tests" <> $SessionUUID,
					Deprecated -> True
				|>;

				normalWorkingElectrodeModelPacket = <|
					Type -> Model[Item, Electrode],
					Name -> "Example normal working electrode model for CyclicVoltammetry tests" <> $SessionUUID,
					MaxNumberOfPolishings -> 10,
					SonicationSensitive -> True
				|>;

				deprecatedCounterElectrodeModelPacket = <|
					Type -> Model[Item, Electrode],
					Name -> "Example deprecated counter electrode model for CyclicVoltammetry tests" <> $SessionUUID,
					Deprecated -> True
				|>;

				normalCounterElectrodeModelPacket = <|
					Type -> Model[Item, Electrode],
					Name -> "Example normal counter electrode model for CyclicVoltammetry tests" <> $SessionUUID,
					Coated -> True,
					SonicationSensitive -> True
				|>;

				deprecatedReferenceElectrodeModelPacket = <|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					Name -> "Example deprecated reference electrode model for CyclicVoltammetry tests" <> $SessionUUID,
					Deprecated -> True
				|>;

				normalReferenceElectrodeModelPacket = <|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					Name -> "Example normal reference electrode model for CyclicVoltammetry tests" <> $SessionUUID
				|>;

				(* Electrode models upload *)
				{
					deprecatedWorkingElectrodeModel,
					normalWorkingElectrodeModel,
					deprecatedCounterElectrodeModel,
					normalCounterElectrodeModel,
					deprecatedReferenceElectrodeModel,
					normalReferenceElectrodeModel
				} = Upload[{
					deprecatedWorkingElectrodeModelPacket,
					normalWorkingElectrodeModelPacket,
					deprecatedCounterElectrodeModelPacket,
					normalCounterElectrodeModelPacket,
					deprecatedReferenceElectrodeModelPacket,
					normalReferenceElectrodeModelPacket
				}];

				(* Specialized ReferenceElectrode Models *)
				testReferenceElectrodeModel1Packet = <|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					Name -> "Example reference electrode model with default solution error for CyclicVoltammetry tests" <> $SessionUUID,
					Coated -> False,
					Replace[Dimensions] -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					ReferenceElectrodeType -> "Ag/Ag+",
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, "Example reference solution model with information fetching error for CyclicVoltammetry tests" <> $SessionUUID]],
					RecommendedRefreshPeriod -> 1 Year
				|>;

				testReferenceElectrodeModel2Packet = <|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					Name -> "Example reference electrode model with default solution mismatching solvent type for CyclicVoltammetry tests" <> $SessionUUID,
					Coated -> False,
					Replace[Dimensions] -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					ReferenceElectrodeType -> "Ag/Ag+",
					RecommendedSolventType -> Aqueous,
					ReferenceSolution -> Link[Model[Sample, StockSolution, "0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]],
					RecommendedRefreshPeriod -> 1 Year
				|>;

				testReferenceElectrodeModel3Packet = <|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					Name -> "Example reference electrode model with default solution mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Coated -> False,
					Replace[Dimensions] -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					ReferenceElectrodeType -> "Ag/Ag+",
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, "Example reference solution model with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID]],
					RecommendedRefreshPeriod -> 1 Year
				|>;

				testReferenceElectrodeModel4Packet = <|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					Name -> "Example reference electrode model with default solution mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID,
					Coated -> False,
					Replace[Dimensions] -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					ReferenceElectrodeType -> "Ag/Ag+",
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, "Example reference solution model with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID]],
					RecommendedRefreshPeriod -> 1 Year
				|>;

				testReferenceElectrodeModel5Packet = <|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					Name -> "Example reference electrode model with default solution mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID,
					Coated -> False,
					Replace[Dimensions] -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					ReferenceElectrodeType -> "Ag/Ag+",
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, "Example reference solution model with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID]],
					RecommendedRefreshPeriod -> 1 Year
				|>;

				(* Specialized ReferenceElectrode Models upload *)
				{
					testReferenceElectrodeModel1,
					testReferenceElectrodeModel2,
					testReferenceElectrodeModel3,
					testReferenceElectrodeModel4,
					testReferenceElectrodeModel5
				} = Upload[{
					testReferenceElectrodeModel1Packet,
					testReferenceElectrodeModel2Packet,
					testReferenceElectrodeModel3Packet,
					testReferenceElectrodeModel4Packet,
					testReferenceElectrodeModel5Packet
				}];

				(* Electrode Objects *)
				workingElectrode1Packet = <|
					Type -> Object[Item, Electrode],
					Model -> Link[Model[Item, Electrode, "Example normal working electrode model for CyclicVoltammetry tests" <> $SessionUUID], Objects],
					Site -> Link[$Site],
					Name -> "Example working electrode 1 for CyclicVoltammetry tests" <> $SessionUUID,
					NumberOfPolishings -> 0,
					AwaitingStorageUpdate -> Null
				|>;

				workingElectrode2Packet = <|
					Type -> Object[Item, Electrode],
					Model -> Link[Model[Item, Electrode, "Example normal working electrode model for CyclicVoltammetry tests" <> $SessionUUID], Objects],
					Site -> Link[$Site],
					Name -> "Example working electrode 2 for CyclicVoltammetry tests" <> $SessionUUID,
					NumberOfPolishings -> 15,
					AwaitingStorageUpdate -> Null
				|>;

				counterElectrodePacket = <|
					Type -> Object[Item, Electrode],
					Model -> Link[Model[Item, Electrode, "Example normal counter electrode model for CyclicVoltammetry tests" <> $SessionUUID], Objects],
					Site -> Link[$Site],
					Name -> "Example counter electrode for CyclicVoltammetry tests" <> $SessionUUID
				|>;

				(* set up reference electrodes *)
				referenceElectrode1Packet = <|
					Type -> Object[Item, Electrode, ReferenceElectrode],
					Model -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"], Objects],
					Site -> Link[$Site],
					Name -> "Example reference electrode 1 for CyclicVoltammetry tests" <> $SessionUUID
				|>;

				referenceElectrode2Packet = <|
					Type -> Object[Item, Electrode, ReferenceElectrode],
					Model -> Link[Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"], Objects],
					Site -> Link[$Site],
					Name -> "Example reference electrode 2 for CyclicVoltammetry tests" <> $SessionUUID,
					Replace[RefreshLog] -> {{DateObject["2020-01-01"], Link[Model[Sample, StockSolution, "3M KCl Aqueous Solution, 10 mL"]], Null}}
				|>;

				(* Electrode Objects upload *)
				{
					workingElectrode1,
					workingElectrode2,
					counterElectrode,
					referenceElectrode1,
					referenceElectrode2
				} = Upload[{
					workingElectrode1Packet,
					workingElectrode2Packet,
					counterElectrodePacket,
					referenceElectrode1Packet,
					referenceElectrode2Packet
				}];

				(* set up electrode cap *)
				electrodeCapPacket = <|
					Type -> Object[Item, Cap, ElectrodeCap],
					Model -> Link[Model[Item, Cap, ElectrodeCap, "IKA Regular Electrode Cap"], Objects],
					Replace[Connectors] -> Download[Model[Item, Cap, ElectrodeCap, "IKA Regular Electrode Cap"], Connectors],
					Site -> Link[$Site],
					Name -> "Example electrode cap for CyclicVoltammetry tests" <> $SessionUUID
				|>;

				(* set up reaction vessels *)
				reactionVessel1Packet = <|
					Type -> Object[Container, ReactionVessel, ElectrochemicalSynthesis],
					Model -> Link[Model[Container, ReactionVessel, ElectrochemicalSynthesis, "Electrochemical Reaction Vessel, 20 mL"], Objects],
					Replace[Connectors] -> Download[Model[Container, ReactionVessel, ElectrochemicalSynthesis, "Electrochemical Reaction Vessel, 20 mL"], Connectors],
					Site -> Link[$Site],
					Name -> "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID
				|>;

				reactionVessel2Packet = <|
					Type -> Object[Container, ReactionVessel, ElectrochemicalSynthesis],
					Model -> Link[Model[Container, ReactionVessel, ElectrochemicalSynthesis, "Electrochemical Reaction Vessel, 10 mL"], Objects],
					Replace[Connectors] -> Download[Model[Container, ReactionVessel, ElectrochemicalSynthesis, "Electrochemical Reaction Vessel, 10 mL"], Connectors],
					Site -> Link[$Site],
					Name -> "Example reaction vessel 2 for CyclicVoltammetry tests" <> $SessionUUID
				|>;

				(* set up polishing items *)
				electrodePolishingPad1Packet = <|
					Type -> Object[Item, ElectrodePolishingPad],
					Model -> Link[Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Objects],
					Site -> Link[$Site],
					Name -> "Example polishing pad 1 for CyclicVoltammetry tests" <> $SessionUUID
				|>;

				electrodePolishingPad2Packet = <|
					Type -> Object[Item, ElectrodePolishingPad],
					Model -> Link[Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"], Objects],
					Site -> Link[$Site],
					Name -> "Example polishing pad 2 for CyclicVoltammetry tests" <> $SessionUUID
				|>;

				(* upload everything above *)
				{
					electrodeCap,
					reactionVessel1,
					reactionVessel2,
					electrodePolishingPad1,
					electrodePolishingPad2
				} = Upload[{
					electrodeCapPacket,
					reactionVessel1Packet,
					reactionVessel2Packet,
					electrodePolishingPad1Packet,
					electrodePolishingPad2Packet
				}];

				(* set up test containers for our samples *)
				{
					container1,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					container9,
					container10,
					container11,
					container12,
					container13,
					container14,
					container15,
					container16,
					container17,
					container18,
					container19
				} = UploadSample[
					{
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status ->
						{
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available
						},
					Name ->
						{
							"Example sample container 1 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 2 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 3 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 4 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 5 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 6 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 7 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 8 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 9 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 10 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 11 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 12 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 13 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 14 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 15 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 16 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 17 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 18 for CyclicVoltammetry tests" <> $SessionUUID,
							"Example sample container 19 for CyclicVoltammetry tests" <> $SessionUUID
						}
				];

				(* set up test samples to test *)
				{
					liquidSample1,
					liquidSample2,
					liquidSample3,
					liquidSample4,
					liquidSample5,
					liquidSample6,
					liquidSample7,
					liquidSample8,
					liquidSample9,
					liquidSample10,
					liquidSample11,
					liquidSample12,
					solidSample1,
					solidSample2,
					solidSample3,
					solidSample4,
					solidSample5,
					solidSample6,
					solidSample7
				} = UploadSample[
					{
						Model[Sample, StockSolution, "5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
						Model[Sample, StockSolution, "5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
						Model[Sample, StockSolution, "5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile, 20 mL"],
						Model[Sample, "Example liquid sample model with no Solvent for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example liquid sample model with only one Composition entry for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example liquid sample model with invalid analyte composition unit in Composition for CyclicVoltammetry tests" <> $SessionUUID],

						Model[Sample, "Example liquid sample model with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example liquid sample model with electrolyte molecule invalid composition unit for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example liquid sample model with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example liquid sample model with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example liquid sample model with electrolyte molecule not Found for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example liquid sample model with electrolyte molecule duplicated for CyclicVoltammetry tests" <> $SessionUUID],

						Model[Sample, "Ferrocene"],
						Model[Sample, "1,1\[Prime]-Dimethylferrocene"],
						Model[Sample, "Bis(pentamethylcyclopentadienyl)iron(II)"],
						Model[Sample, "Example solid sample model with no Composition for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example solid sample model with no Analytes for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example solid sample model with more than one Analytes for CyclicVoltammetry tests" <> $SessionUUID],
						Model[Sample, "Example solid sample model with invalid Analyte composition unit for CyclicVoltammetry tests" <> $SessionUUID]
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8},
						{"A1", container9},
						{"A1", container10},
						{"A1", container11},
						{"A1", container12},
						{"A1", container13},
						{"A1", container14},
						{"A1", container15},
						{"A1", container16},
						{"A1", container17},
						{"A1", container18},
						{"A1", container19}
					},
					InitialAmount ->
						{
							100*Milliliter,
							100*Milliliter,
							100*Milliliter,
							100*Milliliter,
							100*Milliliter,
							100*Milliliter,
							100*Milliliter,

							100*Milliliter,
							100*Milliliter,
							100*Milliliter,
							100*Milliliter,
							100*Milliliter,

							100*Gram,
							100*Gram,
							100*Gram,
							100*Gram,
							100*Gram,
							100*Gram,
							100*Gram
						},
					Name ->
						{
							"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID,
							"Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID,
							"Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID,
							"Example liquid sample object with no Solvent for CyclicVoltammetry tests" <> $SessionUUID,
							"Example liquid sample object with only one Composition entry for CyclicVoltammetry tests" <> $SessionUUID,
							"Example liquid sample object with invalid analyte composition unit in Composition for CyclicVoltammetry tests" <> $SessionUUID,

							"Example liquid sample object with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID,
							"Example liquid sample object with electrolyte molecule invalid composition unit for CyclicVoltammetry tests" <> $SessionUUID,
							"Example liquid sample object with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID,
							"Example liquid sample object with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID,
							"Example liquid sample object with electrolyte molecule not Found for CyclicVoltammetry tests" <> $SessionUUID,
							"Example liquid sample object with electrolyte molecule duplicated for CyclicVoltammetry tests" <> $SessionUUID,

							"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID,
							"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID,
							"Example Bis(pentamethylcyclopentadienyl)iron(II) solid sample for CyclicVoltammetry tests" <> $SessionUUID,
							"Example solid sample object with no Composition for CyclicVoltammetry tests" <> $SessionUUID,
							"Example solid sample object with no Analytes for CyclicVoltammetry tests" <> $SessionUUID,
							"Example solid sample object with more than one Analytes for CyclicVoltammetry tests" <> $SessionUUID,
							"Example solid sample object with invalid Analyte composition unit for CyclicVoltammetry tests" <> $SessionUUID
						},
					State ->
						{
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,

							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,

							Solid,
							Solid,
							Solid,
							Solid,
							Solid,
							Solid,
							Solid
						}
				];

				(* upload the test objects *)
				Upload[
					<|
						Object -> #,
						AwaitingStorageUpdate -> Null
					|> & /@ Cases[
						Flatten[
							{
								container1, container2, container3, container4, container5, container6, container7,
								container8, container9, container10, container11, container12, container13, container14,
								container15, container16, container17, container18, container19,
								liquidSample1, liquidSample2, liquidSample3, liquidSample4, liquidSample5, liquidSample6, liquidSample7,
								liquidSample8, liquidSample9, liquidSample10, liquidSample11, liquidSample12,
								solidSample1, solidSample2, solidSample3, solidSample4, solidSample5, solidSample6, solidSample7
							}
						],
						ObjectP[]
					]
				];

				(* sever model link because it cant be relied on *)
				Upload[
					Cases[
						Flatten[
							{
								<|Object -> liquidSample1, Model -> Null|>,
								<|Object -> liquidSample2, Model -> Null|>,
								<|Object -> liquidSample3, Model -> Null|>,
								<|Object -> liquidSample4, Model -> Null|>,
								<|Object -> liquidSample5, Model -> Null|>,
								<|Object -> liquidSample6, Model -> Null|>,
								<|Object -> liquidSample7, Model -> Null|>,
								<|Object -> liquidSample8, Model -> Null|>,
								<|Object -> liquidSample9, Model -> Null|>,
								<|Object -> liquidSample10, Model -> Null|>,
								<|Object -> liquidSample11, Model -> Null|>,
								<|Object -> liquidSample12, Model -> Null|>,
								<|Object -> solidSample1, Model -> Null|>,
								<|Object -> solidSample2, Model -> Null|>,
								<|Object -> solidSample3, Model -> Null|>,
								<|Object -> solidSample4, Model -> Null|>,
								<|Object -> solidSample5, Model -> Null|>,
								<|Object -> solidSample6, Model -> Null|>,
								<|Object -> solidSample7, Model -> Null|>
							}
						],
						PacketP[]
					]
				];

				(* --------------------- *)
				(* --- TEST PROTOCOL --- *)
				(* --------------------- *)

				(* Set $CreatedObjects to {} to catch all of the resources and other objects created by the Experiment function calls *)
				$CreatedObjects={};

				Quiet[
					ExperimentCyclicVoltammetry[
						Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
						Name-> "Example CyclicVoltammetry Protocol for CyclicVoltammetry tests" <> $SessionUUID
					]
				];

				(* Make all of the objects created during the protocol developer objects *)
				Upload[<|Object->#, DeveloperObject->True|> &/@Cases[Flatten[$CreatedObjects], ObjectP[]]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects = Quiet[Cases[
				Flatten[{

					(* Bench and Instrument *)
					Object[Container, Bench, "Example bench for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Instrument, Reactor, Electrochemical, "Example instrument for CyclicVoltammetry tests" <> $SessionUUID],

					(* Molecule Models *)
					Model[Molecule, "Example electrolyte molecule without DefaultSampleModel" <> $SessionUUID],
					Model[Molecule, "Example electrolyte molecule without MolecularWeight" <> $SessionUUID],
					Model[Molecule, "Example reference coupling sample molecule without MolecularWeight" <> $SessionUUID],

					(* Sample Models *)
					Model[Sample, "Example solid sample model with no Composition for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example solid sample model with no Analytes for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example solid sample model with more than one Analytes for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example solid sample model with invalid Analyte composition unit for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with no Solvent for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with only one Composition entry for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with invalid analyte composition unit in Composition for CyclicVoltammetry tests" <> $SessionUUID],

					(* Specialized Solvent, Electrolyte, ElectrolyteSolution, ReferenceCouplingSample, ReferenceSolution, InternalStandard Models *)
					Model[Sample, "Example solvent with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference coupling sample with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference coupling sample with missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example internal standard with ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],

					(* Electrolyte solutions *)
					Model[Sample, "Example electrolyte solution with missing Solvent field for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with missing Analytes field for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with ambiguous Analytes field for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with two electrolyte molecule in Composition field for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with invalid electrolyte molecule composition unit for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with HPLC acetonitrile sample for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID],

					Model[Sample, "Example electrolyte solution with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example electrolyte solution with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID],

					(* reference solutions *)
					Model[Sample, "Example reference solution model with information fetching error for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference solution model with mismatching solvent sample for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference solution model with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference solution model with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example reference solution model with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample, "Example reference solution object with information fetching error for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example reference solution object with mismatching solvent sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example reference solution object with mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example reference solution object with mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example reference solution object with mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID],

					(* Specialized Sample Models *)
					Model[Sample, "Example liquid sample model with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule invalid composition unit for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule not Found for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Sample, "Example liquid sample model with electrolyte molecule duplicated for CyclicVoltammetry tests" <> $SessionUUID],

					(* Sample Objects *)
					Object[Sample, "Example 3M KCl aqueous reference solution for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile reference solution for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile reference solution for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 0.1M [NBu4][PF6] in acetonitrile reference solution for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample, "Example 3M KCl aqueous electrolyte solution for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example 0.1M [NBu4][PF6] in acetonitrile electrolyte solution for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample, "Example water for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example acetonitrile for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example HPLC acetonitrile for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample, "Example polishing solution 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example polishing solution 2 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Containers for the above samples *)
					Object[Container, Vessel, "Example chemical container 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 2 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 3 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 4 for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Container, Vessel, "Example chemical container 5 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 6 for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Container, Vessel, "Example chemical container 7 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 8 for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Container, Vessel, "Example chemical container 9 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 10 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example chemical container 11 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Electrode models *)
					Model[Item, Electrode, "Example deprecated working electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, "Example normal working electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, "Example deprecated counter electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, "Example normal counter electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example deprecated reference electrode model for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example normal reference electrode model for CyclicVoltammetry tests" <> $SessionUUID],

					(* Specialized ReferenceElectrode Models *)
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution error for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution mismatching solvent type for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution mismatching solvent molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution mismatching electrolyte molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example reference electrode model with default solution mismatching electrolyte molecule concentration for CyclicVoltammetry tests" <> $SessionUUID],

					(* Electrode Objects *)
					Object[Item, Electrode, "Example working electrode 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, Electrode, "Example working electrode 2 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, Electrode, "Example counter electrode for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example reference electrode 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example reference electrode 2 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Misc. *)
					Object[Item, Cap, ElectrodeCap, "Example electrode cap for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, ReactionVessel, ElectrochemicalSynthesis, "Example reaction vessel 2 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, ElectrodePolishingPad, "Example polishing pad 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Item, ElectrodePolishingPad, "Example polishing pad 2 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example sample container 1 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 2 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 3 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 4 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 5 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 6 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 7 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 8 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 9 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 10 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 11 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 12 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 13 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 14 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 15 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 16 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 17 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 18 for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 19 for CyclicVoltammetry tests" <> $SessionUUID],

					(* Input Sample Objects *)
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example liquid sample object with no Solvent for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example liquid sample object with only one Composition entry for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example liquid sample object with invalid analyte composition unit in Composition for CyclicVoltammetry tests" <> $SessionUUID],

					(* Specialized sample objects *)
					Object[Sample, "Example liquid sample object with solvent sample ambiguous molecule for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule invalid composition unit for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule missing MolecularWeight for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule missing DefaultSampleModel for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule not Found for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample, "Example liquid sample object with electrolyte molecule duplicated for CyclicVoltammetry tests" <> $SessionUUID],

					Object[Sample,"Example Ferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example 1,1\[Prime]-Dimethylferrocene solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example Bis(pentamethylcyclopentadienyl)iron(II) solid sample for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example solid sample object with no Composition for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example solid sample object with no Analytes for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example solid sample object with more than one Analytes for CyclicVoltammetry tests" <> $SessionUUID],
					Object[Sample,"Example solid sample object with invalid Analyte composition unit for CyclicVoltammetry tests" <> $SessionUUID],

					(* Test protocol *)
					Object[Protocol, CyclicVoltammetry,"Example CyclicVoltammetry Protocol for CyclicVoltammetry tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	)
];




(* ::Subsection:: *)
(*ExperimentCyclicVoltammetryOptions*)
DefineTests[ExperimentCyclicVoltammetryOptions,
	{
		Example[{Basic, "Display the option values which will be used in the experiment:"},
			ExperimentCyclicVoltammetryOptions[
				{
					Object[Sample,"Example Ferrocene solid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID]
				},
				PreparedSample -> {False, True}
			],
			_Grid
		],
		Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
			ExperimentCyclicVoltammetryOptions[
				{
					Object[Sample,"Example Ferrocene solid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID]
				},
				PreparedSample -> {False, False}
			],
			_Grid,
			Messages :> {Error::MismatchingSampleState, Error::InvalidOption}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
			ExperimentCyclicVoltammetryOptions[
				{
					Object[Sample,"Example Ferrocene solid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID]
				},
				PreparedSample -> {False, True},
				OutputFormat -> List
			],
			{(_Rule|_RuleDelayed)..}
		]
	},


	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			ClearMemoization[];
			objects = Quiet[Cases[
				Flatten[{

					(* Bench and Instrument *)
					Object[Container, Bench, "Example bench for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example sample container 1 for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 2 for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID],

					(* Input Sample Objects *)
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID],

					Object[Sample,"Example Ferrocene solid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					(* Bench and Instrument *)
					testBench, testBenchPacket,

					(* Containers *)
					container1, container2,

					(* Input Sample Objects *)
					liquidSample1, solidSample1
				},

				(* set up test bench as a location for the vessel *)
				testBenchPacket = <|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Example bench for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>;

				(* Bench upload *)
				{
					testBench
				} = Upload[{
					testBenchPacket
				}];

				(* set up test containers for our samples *)
				{
					container1,
					container2
				} = UploadSample[
					{
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status ->
						{
							Available,
							Available
						},
					Name ->
						{
							"Example sample container 1 for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID,
							"Example sample container 2 for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID
						}
				];

				(* set up test samples to test *)
				{
					liquidSample1,
					solidSample1
				} = UploadSample[
					{
						Model[Sample, StockSolution, "5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile, 20 mL"],

						Model[Sample, "Ferrocene"]
					},
					{
						{"A1", container1},
						{"A1", container2}
					},
					InitialAmount ->
						{
							100*Milliliter,
							100*Gram
						},
					Name ->
						{
							"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID,
							"Example Ferrocene solid sample for ExperimentCyclicVoltammetryOptions tests" <> $SessionUUID
						},
					State ->
						{
							Liquid,
							Solid
						}
				];

				(* upload the test objects *)
				Upload[
					<|
						Object -> #,
						AwaitingStorageUpdate -> Null
					|> & /@ Cases[
						Flatten[
							{
								container1, container2,
								liquidSample1, solidSample1
							}
						],
						ObjectP[]
					]
				];

				(* sever model link because it cant be relied on *)
				Upload[
					Cases[
						Flatten[
							{
								<|Object -> liquidSample1, Model -> Null|>,
								<|Object -> solidSample1, Model -> Null|>
							}
						],
						PacketP[]
					]
				]
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects = Quiet[Cases[
				Flatten[{

				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection:: *)
(*ValidExperimentCyclicVoltammetryQ*)
DefineTests[ValidExperimentCyclicVoltammetryQ,
	{
		Example[{Basic, "Verify that the experiment can be run without issues:"},
			ValidExperimentCyclicVoltammetryQ[
				{
					Object[Sample,"Example Ferrocene solid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID]
				},
				PreparedSample -> {False, True}
			],
			True
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentCyclicVoltammetryQ[
				{
					Object[Sample,"Example Ferrocene solid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID]
				},
				PreparedSample -> {False, False}
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidExperimentCyclicVoltammetryQ[
				{
					Object[Sample,"Example Ferrocene solid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID]
				},
				PreparedSample -> {False, True},
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
			ValidExperimentCyclicVoltammetryQ[
				{
					Object[Sample,"Example Ferrocene solid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID]
				},
				PreparedSample -> {False, True},
				Verbose -> True
			],
			True
		]
	},


	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			ClearMemoization[];
			objects = Quiet[Cases[
				Flatten[{

					(* Bench and Instrument *)
					Object[Container, Bench, "Example bench for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example sample container 1 for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 2 for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID],

					(* Input Sample Objects *)
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID],

					Object[Sample,"Example Ferrocene solid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					(* Bench and Instrument *)
					testBench, testBenchPacket,

					(* Containers *)
					container1, container2,

					(* Input Sample Objects *)
					liquidSample1, solidSample1
				},

				(* set up test bench as a location for the vessel *)
				testBenchPacket = <|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Example bench for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>;

				(* Bench upload *)
				{
					testBench
				} = Upload[{
					testBenchPacket
				}];

				(* set up test containers for our samples *)
				{
					container1,
					container2
				} = UploadSample[
					{
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status ->
						{
							Available,
							Available
						},
					Name ->
						{
							"Example sample container 1 for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID,
							"Example sample container 2 for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID
						}
				];

				(* set up test samples to test *)
				{
					liquidSample1,
					solidSample1
				} = UploadSample[
					{
						Model[Sample, StockSolution, "5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile, 20 mL"],

						Model[Sample, "Ferrocene"]
					},
					{
						{"A1", container1},
						{"A1", container2}
					},
					InitialAmount ->
						{
							100*Milliliter,
							100*Gram
						},
					Name ->
						{
							"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID,
							"Example Ferrocene solid sample for ValidExperimentCyclicVoltammetryQ tests" <> $SessionUUID
						},
					State ->
						{
							Liquid,
							Solid
						}
				];

				(* upload the test objects *)
				Upload[
					<|
						Object -> #,
						AwaitingStorageUpdate -> Null
					|> & /@ Cases[
						Flatten[
							{
								container1, container2,
								liquidSample1, solidSample1
							}
						],
						ObjectP[]
					]
				];

				(* sever model link because it cant be relied on *)
				Upload[
					Cases[
						Flatten[
							{
								<|Object -> liquidSample1, Model -> Null|>,
								<|Object -> solidSample1, Model -> Null|>
							}
						],
						PacketP[]
					]
				]
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects = Quiet[Cases[
				Flatten[{

				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection:: *)
(*ExperimentCyclicVoltammetryPreview*)
DefineTests[ExperimentCyclicVoltammetryPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentCyclicVoltammetry:"},
			ExperimentCyclicVoltammetryPreview[
				{
					Object[Sample,"Example Ferrocene solid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID]
				},
				PreparedSample -> {False, True}
			],
			Null
		],
		Example[{Additional, "If you wish to understand how the experiment will be performed, try using ExperimentCyclicVoltammetryOptions:"},
			ExperimentCyclicVoltammetryOptions[
				{
					Object[Sample,"Example Ferrocene solid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID]
				},
				PreparedSample -> {False, True}
			],
			_Grid
		],
		Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentCyclicVoltammetryQ:"},
			ValidExperimentCyclicVoltammetryQ[
				{
					Object[Sample,"Example Ferrocene solid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID],
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID]
				},
				PreparedSample -> {False, True}
			],
			True
		]
	},


	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			ClearMemoization[];
			objects = Quiet[Cases[
				Flatten[{

					(* Bench and Instrument *)
					Object[Container, Bench, "Example bench for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example sample container 1 for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID],
					Object[Container, Vessel, "Example sample container 2 for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID],

					(* Input Sample Objects *)
					Object[Sample,"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID],

					Object[Sample,"Example Ferrocene solid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					(* Bench and Instrument *)
					testBench, testBenchPacket,

					(* Containers *)
					container1, container2,

					(* Input Sample Objects *)
					liquidSample1, solidSample1
				},

				(* set up test bench as a location for the vessel *)
				testBenchPacket = <|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Example bench for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>;

				(* Bench upload *)
				{
					testBench
				} = Upload[{
					testBenchPacket
				}];

				(* set up test containers for our samples *)
				{
					container1,
					container2
				} = UploadSample[
					{
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status ->
						{
							Available,
							Available
						},
					Name ->
						{
							"Example sample container 1 for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID,
							"Example sample container 2 for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID
						}
				];

				(* set up test samples to test *)
				{
					liquidSample1,
					solidSample1
				} = UploadSample[
					{
						Model[Sample, StockSolution, "5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile, 20 mL"],

						Model[Sample, "Ferrocene"]
					},
					{
						{"A1", container1},
						{"A1", container2}
					},
					InitialAmount ->
						{
							100*Milliliter,
							100*Gram
						},
					Name ->
						{
							"Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID,
							"Example Ferrocene solid sample for ExperimentCyclicVoltammetryPreview tests" <> $SessionUUID
						},
					State ->
						{
							Liquid,
							Solid
						}
				];

				(* upload the test objects *)
				Upload[
					<|
						Object -> #,
						AwaitingStorageUpdate -> Null
					|> & /@ Cases[
						Flatten[
							{
								container1, container2,
								liquidSample1, solidSample1
							}
						],
						ObjectP[]
					]
				];

				(* sever model link because it cant be relied on *)
				Upload[
					Cases[
						Flatten[
							{
								<|Object -> liquidSample1, Model -> Null|>,
								<|Object -> solidSample1, Model -> Null|>
							}
						],
						PacketP[]
					]
				]
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects = Quiet[Cases[
				Flatten[{

				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	)
];
