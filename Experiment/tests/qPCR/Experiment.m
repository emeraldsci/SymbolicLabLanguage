(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentqPCR*)


(* ::Section::Closed:: *)
(*ExperimentqPCR*)


DefineTests[
	ExperimentqPCR,
	{
		
		(* === Basic examples === *)
		Example[
			{Basic, "Run qPCR on a single sample with a single primer pair:"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}
			],
			ObjectP[Object[Protocol, qPCR]]
		],
		Example[
			{Basic, "Run qPCR on two samples with different primer pairs:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{
					{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}}
				}
			],
			ObjectP[Object[Protocol, qPCR]]
		],
		Example[
			{Basic, "Detect amplification using target-specific fluorophore/quencher-labeled probes:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				Probe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]},
				ProbeFluorophore->{Model[Molecule,"6-FAM"]}
			],
			ObjectP[Object[Protocol, qPCR]]
		],
		Example[
			{Basic, "Run a multiplexed qPCR with two different primer pairs and probes used to amplify and detect (respectively) a single sample:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
						{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				Probe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
				ProbeFluorophore->{Model[Molecule,"6-FAM"],Model[Molecule,"VIC Dye"]},
				ProbeExcitationWavelength -> {{470 Nanometer, 520 Nanometer}},
				ProbeEmissionWavelength -> {{520 Nanometer, 558 Nanometer}},
				DuplexStainingDye->Null
			],
			ObjectP[Object[Protocol, qPCR]]
		],
		Example[
			{Basic,"Run qPCR using an array card:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,qPCR]]
		],


		(* === Additional examples === *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options = ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, 
				Incubate->True, 
				Centrifuge->True, 
				Filtration->True, 
				Aliquot->True,
				Output->Options
			];
			{Lookup[options, Incubate], Lookup[options, Centrifuge], Lookup[options, Filtration], Lookup[options, Aliquot]},
			{True,True,True,True},
			(* All qPCR test samples are in plates so just allow this warning to be thrown *)
			Messages :> {Warning::SampleStowaways},
			Variables :> {options},
			TimeConstraint->240
		],
		Example[
			{Additional, "Model Input", "Models can be supplied for primer input and primer/probe options:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Model[Sample, "Test Primer Model 1 Forward for ExperimentqPCR"<>$SessionUUID], Model[Sample, "Test Primer Model 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				Probe -> {Model[Sample, "Test Probe Model 1 for ExperimentqPCR"<>$SessionUUID]},
				ProbeFluorophore->{Model[Molecule,"6-FAM"]}
			],
			ObjectP[Object[Protocol, qPCR]],
			Stubs :> {$DeveloperSearch=True,$RequiredSearchName=$SessionUUID}
		],
		
		(* === Options examples === *)
		Example[
			{Options, Instrument, "Specify the thermal cycler that will be used:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Instrument -> Object[Instrument, Thermocycler, "Test ViiA7 Instrument for ExperimentqPCR"<>$SessionUUID]
				],
				Instrument
			],
			Object[Instrument, Thermocycler, "Test ViiA7 Instrument for ExperimentqPCR"<>$SessionUUID],
			EquivalenceFunction->SameObjectQ
		],
		Example[
			{Messages, "InvalidThermocycler", "If a non-qPCR-compatible thermocycler is specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Instrument -> Model[Instrument, Thermocycler, "id:R8e1PjpZ9VNp"] (* ThermoFisher ATC *)
			],
			$Failed,
			Messages :> {Error::InvalidThermocycler, Error::InvalidOption}
		],
		Example[
			{Options, ReactionVolume, "Specify the total reaction volume per well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ReactionVolume->19 Microliter
				],
				ReactionVolume
			],
			19. Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options, MasterMix, "Specify the Master Mix to be used to supply buffer, dNTPs, polymerase, and duplex-staining dye (if applicable):"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MasterMix->Model[Sample,"id:aXRlGn6YABEp"]
				],
				MasterMix
			],
			Model[Sample,"id:aXRlGn6YABEp"],
			EquivalenceFunction->SameObjectQ
		],
		Example[
			{Options, MasterMix, "MasterMix option resolves to a SYBR-containing mix if DuplexStainingDye->SYBR Green / no probes are being used:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}
				],
				MasterMix
			],
			Model[Sample, "Power SYBR Green PCR Master Mix"],
			EquivalenceFunction->SameObjectQ
		],
		Example[
			{Options, MasterMix, "MasterMix option resolves to a SYBR-free mix if DuplexStainingDye->Null / probes are being used:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"]
				],
				MasterMix
			],
			Model[Sample, "iTaq Universal Probes Supermix"],
			EquivalenceFunction->SameObjectQ
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentqPCR[
				{Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR" <> $SessionUUID],
					Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR" <> $SessionUUID]}},
					{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR" <> $SessionUUID],
						Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR" <> $SessionUUID]}}},
				PreparedModelContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				PreparedModelAmount -> 1 Milliliter,
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
				{ObjectP[Model[Sample, "Milli-Q water"]]..},
				{ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			ExperimentqPCR[
				{Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR" <> $SessionUUID],
					Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR" <> $SessionUUID]}},
					{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR" <> $SessionUUID],
						Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR" <> $SessionUUID]}}},
				PreparedModelContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				PreparedModelAmount -> 1 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, qPCR]]
		],
		Example[
			{Messages, "UnknownMasterMix", "If the specified MasterMix is not a model pre-evaluated for use in ExperimentqPCR, a warning is thrown to notify the user that default values will be used for fold concentration, dye content, and reverse transcriptase content:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MasterMix->Model[Sample,"Milli-Q water"]
				],
				MasterMix
			],
			Model[Sample, "Milli-Q water"],
			Messages :> {Warning::UnknownMasterMix},
			EquivalenceFunction->SameObjectQ
		],
		Test[
			"If an Object[Sample] is specified for MasterMix, its Model is extracted and duplex/reference dye information is still resolved as expected:",
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MasterMix->Object[Sample, "Test MasterMix sample for ExperimentqPCR"<>$SessionUUID]
				],
				{
					DuplexStainingDye, DuplexStainingDyeExcitationWavelength, DuplexStainingDyeEmissionWavelength,
					ReferenceDye, ReferenceDyeExcitationWavelength, ReferenceDyeEmissionWavelength
				}
			],
			{
				ObjectP[Model[Molecule]], DistanceP, DistanceP,
				ObjectP[Model[Molecule]], DistanceP, DistanceP
			},
			Messages:>{Warning::SampleMustBeMoved}
		],
		
		Example[
			{Options, MasterMixVolume, "Specify the volume of master mix to be used per well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MasterMixVolume->3 Microliter
				],
				MasterMixVolume
			],
			3. Microliter,
			EquivalenceFunction->Equal
		],
		Example[
			{Options, MasterMixStorageCondition, "Specify the storage condition of master mix used in this protocol should be stored after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MasterMixStorageCondition->Freezer
				],
				MasterMixStorageCondition
			],
			Freezer
		],

		Example[
			{Options, StandardVolume, "Specify the volume of standard sample to be used per well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					StandardVolume->3 Microliter
				],
				StandardVolume
			],
			3. Microliter,
			EquivalenceFunction->Equal
		],

		Example[
			{Options, Buffer, "Specify the buffer to be used to bring each well up to the final reaction volume:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Buffer->Model[Sample, StockSolution, "1x PBS from 10X stock"]
				],
				Buffer
			],
			Model[Sample, StockSolution, "1x PBS from 10X stock"],
			EquivalenceFunction->SameObjectQ
		],
		
		(* Reverse transcription options *)
		Example[
			{Options, ReverseTranscription, "Specify whether one-step reverse transcription should be done on the thermal cycler just prior to amplification:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ReverseTranscription->True
				],
				ReverseTranscription
			],
			True
		],
		Example[
			{Options, ReverseTranscription, "If ReverseTranscription->True and MasterMix->Automatic, an RT-containing master mix is selected:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ReverseTranscription->True
				],
				MasterMix
			],
			Model[Sample, "id:aXRlGn6YABEp"],
			EquivalenceFunction -> SameObjectQ
		],
		Example[
			{Options, ReverseTranscriptionTime, "Specify the amount of time for which the reverse transcription reaction should proceed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ReverseTranscriptionTime->123 Second
				],
				ReverseTranscriptionTime
			],
			123. Second
		],
		Example[
			{Options, ReverseTranscriptionTemperature, "Specify the temperature at which the reverse transcription reaction should be performed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ReverseTranscriptionTemperature->54 Celsius
				],
				ReverseTranscriptionTemperature
			],
			54. Celsius
		],
		Example[
			{Options, ReverseTranscriptionRampRate, "Specify the rate at which thermal cycler block temperature should be changed when moving to the reverse transcription step:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ReverseTranscriptionRampRate->1.23 Celsius/Second
				],
				ReverseTranscriptionRampRate
			],
			1.23 Celsius/Second
		],
		
		(* Polymerase activation options *)
		Example[
			{Options, Activation, "Specify whether hot-start enzyme activation should be performed prior to amplification:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Activation->False
				],
				Activation
			],
			False
		],
		Example[
			{Options, ActivationTime, "Specify the amount of time for which hot-start enzyme activation should proceed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ActivationTime->123 Second
				],
				ActivationTime
			],
			123. Second
		],
		Example[
			{Options, ActivationTemperature, "Specify the temperature at which the hot-start enzyme activation should be performed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ActivationTemperature->90 Celsius
				],
				ActivationTemperature
			],
			90. Celsius
		],
		Example[
			{Options, ActivationRampRate, "Specify the rate at which thermal cycler block temperature should be changed when moving to the activation temperature:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ActivationRampRate->1.23 Celsius/Second
				],
				ActivationRampRate
			],
			1.23 Celsius/Second
		],
		
		(* Denaturation options *)
		Example[
			{Options, DenaturationTime, "Specify the amount of time for which the denaturation (duplex melting) step should proceed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					DenaturationTime->123 Second
				],
				DenaturationTime
			],
			123. Second
		],
		Example[
			{Options, DenaturationTemperature, "Specify the temperature at which the denaturation step should be performed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					DenaturationTemperature->90 Celsius
				],
				DenaturationTemperature
			],
			90. Celsius
		],
		Example[
			{Options, DenaturationRampRate, "Specify the rate at which thermal cycler block temperature should be changed when moving to the denaturation temperature:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					DenaturationRampRate->1.23 Celsius/Second
				],
				DenaturationRampRate
			],
			1.23 Celsius/Second
		],
		
		(* Primer annealing options *)
		Example[
			{Options, PrimerAnnealing, "Specify whether a separate primer annealing step should be performed during each cycle of amplification:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					PrimerAnnealing->True
				],
				PrimerAnnealing
			],
			True
		],
		Example[
			{Options, PrimerAnnealingTime, "Specify the amount of time for which each primer annealing step should proceed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					PrimerAnnealingTime->35 Second
				],
				PrimerAnnealingTime
			],
			35. Second
		],
		Example[
			{Options, PrimerAnnealingTemperature, "Specify the temperature at which each primer annealing step should be performed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					PrimerAnnealingTemperature->63 Celsius
				],
				PrimerAnnealingTemperature
			],
			63. Celsius
		],
		Example[
			{Options, PrimerAnnealingRampRate, "Specify the rate at which thermal cycler block temperature should be changed when moving to the primer annealing temperature:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					PrimerAnnealingRampRate->1.23 Celsius/Second
				],
				PrimerAnnealingRampRate
			],
			1.23 Celsius/Second
		],
		
		(* Extension options *)
		Example[
			{Options, ExtensionTime, "Specify the amount of time for which the extension step should proceed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ExtensionTime->123 Second
				],
				ExtensionTime
			],
			123. Second
		],
		Example[
			{Options, ExtensionTemperature, "Specify the temperature at which the extension step should be performed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ExtensionTemperature->90 Celsius
				],
				ExtensionTemperature
			],
			90. Celsius
		],
		Example[
			{Options, ExtensionRampRate, "Specify the rate at which thermal cycler block temperature should be changed when moving to the extension temperature:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ExtensionRampRate->1.23 Celsius/Second
				],
				ExtensionRampRate
			],
			1.23 Celsius/Second
		],
		Example[
			{Options, NumberOfCycles, "Specify the number of cycles of amplification that should be performed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					NumberOfCycles->33
				],
				NumberOfCycles
			],
			33
		],
		
		(* Melting curve options *)
		Example[
			{Options, MeltingCurve, "Specify whether a melting curve should be performed following amplification:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MeltingCurve->False
				],
				MeltingCurve
			],
			False
		],
		Example[
			{Options, MeltingCurveStartTemperature, "Specify the temperature at which the melting curve should begin:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MeltingCurveStartTemperature->30 Celsius
				],
				MeltingCurveStartTemperature
			],
			30. Celsius
		],
		Example[
			{Options, MeltingCurveEndTemperature, "Specify the temperature at which the melting curve should end:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MeltingCurveEndTemperature->91 Celsius
				],
				MeltingCurveEndTemperature
			],
			91. Celsius
		],
		Example[
			{Messages, "InvalidMeltEndpoints", "If MeltingCurveStartTemperature is greater than or equal to MeltingCurveEndTemperature, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				MeltingCurveStartTemperature -> 70 Celsius,
				MeltingCurveEndTemperature -> 65 Celsius
			],
			$Failed,
			Messages :> {Error::InvalidMeltEndpoints, Error::InvalidOption}
		],
		Example[
			{Options, PreMeltingCurveRampRate, "Specify the rate at which thermal cycler block temperature should be changed when moving to the melting curve start temperature:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					PreMeltingCurveRampRate->1.23 Celsius/Second
				],
				PreMeltingCurveRampRate
			],
			1.23 Celsius/Second
		],
		Example[
			{Options, MeltingCurveRampRate, "Specify the rate at which thermal cycler block temperature should be changed when moving from the melting curve start temperature to the melting curve end temperature:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MeltingCurveRampRate->1.23 Celsius/Second
				],
				MeltingCurveRampRate
			],
			1.23 Celsius/Second
		],
		Example[
			{Options, MeltingCurveTime, "Specify the amount of time over which the melting curve should be performed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MeltingCurveTime->10 Minute
				],
				MeltingCurveTime
			],
			10. Minute
		],
		
		(* Dye and wavelength options *)
		Example[
			{Options, ProbeExcitationWavelength, "Specify the wavelength at which the probe's fluorescent dye should be excited:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ProbeExcitationWavelength->470 Nanometer,
					ProbeEmissionWavelength->520 Nanometer
				],
				ProbeExcitationWavelengths
			],
			{{470. Nanometer}},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, ProbeEmissionWavelength, "Specify the wavelength at which the probe's fluorescent dye emission should be measured:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ProbeExcitationWavelength->470 Nanometer,
					ProbeEmissionWavelength->520 Nanometer
				],
				ProbeEmissionWavelengths
			],
			{{520. Nanometer}},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, DuplexStainingDye, "Specify the intercalating dye contained in the master mix to be used to stain DNA duplexes:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					DuplexStainingDye->Model[Molecule, "SYBR Green"]
				],
				DuplexStainingDye
			],
			Model[Molecule, "SYBR Green"],
			EquivalenceFunction->SameObjectQ
		],
		Example[
			{Options, DuplexStainingDye, "Duplex staining dye and Ex/Em wavelengths resolve automatically based on specified Master Mix:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MasterMix -> Model[Sample, "Power SYBR Green PCR Master Mix"]
				],
				{DuplexStainingDye, DuplexStainingDyeExcitationWavelength, DuplexStainingDyeEmissionWavelength}
			],
			{
				_?(SameObjectQ[#, Model[Molecule, "SYBR Green"]]&),
				470. Nanometer,
				520. Nanometer
			}
		],
		Example[
			{Options, DuplexStainingDye, "If the specified master mix does not have a Model specifically known to ExperimentqPCR, DuplexStainingDye resolves to SYBR Green:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MasterMix -> Model[Sample, "Milli-Q water"]
				],
				{DuplexStainingDye, DuplexStainingDyeExcitationWavelength, DuplexStainingDyeEmissionWavelength}
			],
			{
				_?(SameObjectQ[#, Model[Molecule, "SYBR Green"]]&),
				470. Nanometer,
				520. Nanometer
			},
			Messages :> {Warning::UnknownMasterMix}
		],
		Example[
			{Messages, "SeparateDyesNotSupported", "If options are specified that direct addition of separate duplex or reference dyes, a feature flag error message is thrown:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					DuplexStainingDye->Model[Sample, StockSolution, "10X SYBR Gold in 1X TBE"]
				],
				DuplexStainingDye
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::SeparateDyesNotSupported}
		],
		Example[
			{Options, DuplexStainingDyeVolume, "Specifying addition of separate duplex staining dye is not currently supported, so an error message is thrown if DuplexStainingDyeVolume is specified:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					DuplexStainingDyeVolume->3 Microliter
				],
				DuplexStainingDyeVolume
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::SeparateDyesNotSupported}
		],
		Example[
			{Options, DuplexStainingDyeExcitationWavelength, "Specify the wavelength at which the duplex staining dye should be excited:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					DuplexStainingDyeExcitationWavelength->520 Nanometer,
					DuplexStainingDyeEmissionWavelength->558 Nanometer
				],
				DuplexStainingDyeExcitationWavelength
			],
			520. Nanometer,
			EquivalenceFunction->Equal
		],
		Example[
			{Options, DuplexStainingDyeEmissionWavelength, "Specify the wavelength at which the duplex staining dye emission should be measured:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					DuplexStainingDyeExcitationWavelength->520 Nanometer,
					DuplexStainingDyeEmissionWavelength->558 Nanometer
				],
				DuplexStainingDyeEmissionWavelength
			],
			558. Nanometer,
			EquivalenceFunction->Equal
		],
		Example[
			{Options, ReferenceDye, "Specify the reference dye contained in the master mix to be used to normalize amplification signal:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ReferenceDye->Model[Molecule, "5(6)-Carboxy-X-Rhodamine"]
				],
				ReferenceDye
			],
			Model[Molecule, "5(6)-Carboxy-X-Rhodamine"],
			EquivalenceFunction->SameObjectQ
		],
		Example[
			{Options, ReferenceDye, "Passive reference dye and Ex/Em wavelengths resolve automatically based on specified Master Mix:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MasterMix -> Model[Sample, "Power SYBR Green PCR Master Mix"]
				],
				{ReferenceDye, ReferenceDyeExcitationWavelength, ReferenceDyeEmissionWavelength}
			],
			{
				_?(SameObjectQ[#, Model[Molecule, "5(6)-Carboxy-X-Rhodamine"]]&),
				580. Nanometer,
				623. Nanometer
			}
		],
		Example[
			{Options, ReferenceDye, "If the specified master mix does not have a Model specifically known to ExperimentqPCR, ReferenceDye resolves to ROX:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MasterMix -> Model[Sample, "Milli-Q water"]
				],
				{ReferenceDye, ReferenceDyeExcitationWavelength, ReferenceDyeEmissionWavelength}
			],
			{
				_?(SameObjectQ[#, Model[Molecule, "5(6)-Carboxy-X-Rhodamine"]]&),
				580. Nanometer,
				623. Nanometer
			},
			Messages :> {Warning::UnknownMasterMix}
		],
		Example[
			{Options, ReferenceDyeVolume, "Specifying addition of separate duplex staining dye is not currently supported, so an error message is thrown if DuplexStainingDyeVolume is specified:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ReferenceDyeVolume->3 Microliter
				],
				ReferenceDyeVolume
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::SeparateDyesNotSupported}
		],
		Example[
			{Options, ReferenceDyeExcitationWavelength, "Specify the wavelength at which the reference dye should be excited:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ReferenceDyeExcitationWavelength->520 Nanometer,
					ReferenceDyeEmissionWavelength->558 Nanometer
				],
				ReferenceDyeExcitationWavelength
			],
			520. Nanometer,
			EquivalenceFunction->Equal
		],
		Example[
			{Options, ReferenceDyeEmissionWavelength, "Specify the wavelength at which the reference dye emission should be measured:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ReferenceDyeExcitationWavelength->520 Nanometer,
					ReferenceDyeEmissionWavelength->558 Nanometer
				],
				ReferenceDyeEmissionWavelength
			],
			558. Nanometer,
			EquivalenceFunction->Equal
		],
		
		(* Standard options *)
		Example[
			{Options, Standard, "Specify sample(s) to be used to generate standard curves:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}
				],
				Standards
			],
			{_?(SameObjectQ[#, Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID]]&)}
		],
		Example[
			{Options, StandardStorageCondition, "Specify the storage condition of standard used in this protocol should be stored after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template in non-automation container for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardStorageCondition->AmbientStorage
				],
				StandardStorageConditions
			],
			{AmbientStorage}
		],
		Example[
			{Options, StandardPrimerPair, "Specify primer pair to be used for each standard:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}
				],
				{StandardForwardPrimers, StandardReversePrimers}
			],
			{{ObjectP[Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID]]}, {ObjectP[Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]]}}
		],
		Example[
			{Options, SerialDilutionFactor, "Specify the factor by which each standard should be diluted at each point in the curve:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					SerialDilutionFactor->4
				],
				SerialDilutionFactors
			],
			{4},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, NumberOfDilutions, "Specify the number of points in each standard curve:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					NumberOfDilutions->6
				],
				NumberOfDilutions
			],
			{6}
		],
		Example[
			{Options, NumberOfStandardReplicates, "Specify the number of replicates to be run for each standard curve:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					NumberOfStandardReplicates->3
				],
				NumberOfStandardReplicates
			],
			{3}
		],
		Example[
			{Options, StandardForwardPrimerVolume, "Specify desired volume of each standard forward primer to be added to each corresponding standard well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardForwardPrimerVolume->3 Microliter
				],
				StandardForwardPrimerVolumes
			],
			{3 Microliter},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, StandardReversePrimerVolume, "Specify desired volume of each standard reverse primer to be added to each corresponding standard well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardReversePrimerVolume->3 Microliter
				],
				StandardReversePrimerVolumes
			],
			{3 Microliter},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, StandardForwardPrimerStorageCondition, "Specify the storage condition of the forward primers of the standards used in this protocol should be stored after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardForwardPrimerStorageCondition->AmbientStorage
				],
				StandardForwardPrimerStorageConditions
			],
			{AmbientStorage}
		],
		Example[
			{Options, StandardReversePrimerStorageCondition, "Specify the storage condition of the reverse primers of the standards used in this protocol should be stored after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardReversePrimerStorageCondition->AmbientStorage
				],
				StandardReversePrimerStorageConditions
			],
			{AmbientStorage}
		],
		Example[
			{Options, StandardProbe, "Specify a fluorophore/quencher labeled probe to be used for each standard curve to measure amplification:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]
				],
				StandardProbes
			],
			{_?(SameObjectQ[#, Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]]&)}
		],
		Example[
			{Options, StandardProbeVolume, "Specify desired volume of each standard's fluorescent probe to be added to each corresponding standard well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					StandardProbeVolume->3.4 Microliter
				],
				StandardProbeVolumes
			],
			{3.4 Microliter}
		],
		Example[
			{Options, StandardProbeStorageCondition, "Specify the storage condition of the probes of the standards used in this protocol should be stored after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					StandardProbeStorageCondition->AmbientStorage
				],
				StandardProbeStorageConditions
			],
			{AmbientStorage}
		],
		Example[
			{Options, StandardProbeFluorophore, "Specify the fluorophore label on each standard probe:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					StandardProbeFluorophore->Model[Molecule,"6-FAM"]
				],
				StandardProbeFluorophores
			],
			{ObjectP[Model[Molecule,"6-FAM"]]}
		],
		Example[
			{Options, StandardProbeExcitationWavelength, "Specify the wavelength at which each standard probe should be excited:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					StandardProbeExcitationWavelength->580 Nanometer,
					StandardProbeEmissionWavelength->623 Nanometer
				],
				StandardProbeExcitationWavelengths
			],
			{580. Nanometer},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, StandardProbeEmissionWavelength, "Specify the wavelength at which each standard probe's emission should be measured:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					StandardProbeExcitationWavelength->580 Nanometer,
					StandardProbeEmissionWavelength->623 Nanometer
				],
				StandardProbeEmissionWavelengths
			],
			{623. Nanometer},
			EquivalenceFunction->Equal
		],
		
		(* Omitting this for the time being because there isn't even a field to store this information in the object.
		 	The option is currently commented out and will be uncommented when that functionality is brought online. *)
		(* Example[
			{Options, NumberOfNegativeControls, "Specify the number of replicates to be run for each standard curve:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					NumberOfNegativeControls->3 
				],
				NumberOfNegativeControls
			],
			{3}
		], *)
		
		(* Sample-index-matched options *)
		Example[
			{Options, SampleVolume, "Specify the volume of template to be included in each sample well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					SampleVolume->2.5 Microliter
				],
				SampleVolumes
			],
			{2.5 Microliter},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, BufferVolume, "Specify the volume of buffer to be included in each sample well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					BufferVolume->6 Microliter
				],
				BufferVolumes
			],
			{6 Microliter},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, ForwardPrimerVolume, "Specify the volume of each forward primer to be included in each sample well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ForwardPrimerVolume->2.1 Microliter
				],
				ForwardPrimerVolumes
			],
			{{2.1 Microliter}},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, ReversePrimerVolume, "Specify the volume of each reverse primer to be included in each sample well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ReversePrimerVolume->2.1 Microliter
				],
				ReversePrimerVolumes
			],
			{{2.1 Microliter}},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, ForwardPrimerStorageCondition, "Specify the storage conditions of the forward primers of this experiment after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ForwardPrimerStorageCondition->AmbientStorage
				],
				ForwardPrimerStorageConditions
			],
			{{AmbientStorage}}
		],
		Example[
			{Options, ReversePrimerStorageCondition, "Specify the storage conditions of the reverse primers of this experiment after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ReversePrimerStorageCondition->AmbientStorage
				],
				ReversePrimerStorageConditions
			],
			{{AmbientStorage}}
		],
		Example[
			{Options, Probe, "Specify a fluorophore/quencher labeled probe to be used for each sample to measure amplification:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"]
				],
				Probes
			],
			{{_?(SameObjectQ[#, Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]]&)}}
		],
		Example[
			{Options, ProbeVolume, "Specify the volume of each probe to be included in each sample well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ProbeVolume->2.1 Microliter
				],
				ProbeVolumes
			],
			{{2.1 Microliter}},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, ProbeStorageCondition, "Specify the storage conditions of the probes of this experiment after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ProbeStorageCondition->AmbientStorage
				],
				ProbeStorageConditions
			],
			{{AmbientStorage}}
		],
		Example[
			{Options, ProbeFluorophore, "Specify the fluorophore label on each probe:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"]
				],
				ProbeFluorophores
			],
			{{ObjectP[Model[Molecule,"6-FAM"]]}}
		],
		Example[
			{Options, EndogenousPrimerPair, "Specify a primer pair to be used for each sample to measure amplification of an endogenous control region:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe -> {{Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]}},
					ProbeFluorophore -> {{Model[Molecule, "5-FAM"]}},
					ProbeExcitationWavelength -> {{470 Nanometer}},
					ProbeEmissionWavelength -> {{520 Nanometer}},
					EndogenousPrimerPair->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					EndogenousProbe -> {Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
					EndogenousProbeFluorophore -> {Model[Molecule, "5(6)-Carboxy-X-Rhodamine"]},
					EndogenousProbeExcitationWavelength -> {520 Nanometer},
					EndogenousProbeEmissionWavelength -> {558 Nanometer}
				],
				{EndogenousForwardPrimers, EndogenousReversePrimers}
			],
			{{_?(SameObjectQ[#, Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID]]&)}, {_?(SameObjectQ[#, Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]]&)}}
		],
		Example[
			{Options, EndogenousForwardPrimerVolume, "Specify the volume of each endogenous control forward primer to be included in each sample well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					EndogenousForwardPrimerVolume->2.1 Microliter
				],
				EndogenousForwardPrimerVolumes
			],
			{2.1 Microliter},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, EndogenousReversePrimerVolume, "Specify the volume of each endogenous control reverse primer to be included in each sample well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					EndogenousReversePrimerVolume->2.1 Microliter
				],
				EndogenousReversePrimerVolumes
			],
			{2.1 Microliter},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, EndogenousForwardPrimerStorageCondition, "Specify the storage condition under which the endogenous forward primer should be stored after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					EndogenousPrimerPair->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					EndogenousProbe -> {Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
					EndogenousProbeFluorophore -> {Model[Molecule, "5(6)-Carboxy-X-Rhodamine"]},
					EndogenousProbeExcitationWavelength -> {520 Nanometer},
					EndogenousProbeEmissionWavelength -> {558 Nanometer},
					EndogenousForwardPrimerStorageCondition->Freezer
				],
				EndogenousForwardPrimerStorageConditions
			],
			{Freezer}
		],
		Example[
			{Options, EndogenousReversePrimerStorageCondition, "Specify the storage condition under which the endogenous forward primer should be stored after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					EndogenousPrimerPair->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					EndogenousProbe -> {Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
					EndogenousProbeFluorophore -> {Model[Molecule, "5(6)-Carboxy-X-Rhodamine"]},
					EndogenousProbeExcitationWavelength -> {520 Nanometer},
					EndogenousProbeEmissionWavelength -> {558 Nanometer},
					EndogenousReversePrimerStorageCondition->Freezer
				],
				EndogenousReversePrimerStorageConditions
			],
			{Freezer}
		],
		Example[
			{Options, EndogenousProbe, "Specify a fluorophore/quencher labeled probe to be used for each endogenous control to measure amplification:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					EndogenousPrimerPair->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					EndogenousProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					EndogenousProbeFluorophore->Model[Molecule,"VIC Dye"],
					EndogenousProbeExcitationWavelength -> {520 Nanometer},
					EndogenousProbeEmissionWavelength -> {558 Nanometer}
				],
				EndogenousProbes
			],
			{_?(SameObjectQ[#, Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]]&)}
		],
		Example[
			{Options, EndogenousProbeVolume, "Specify the volume of the endogenous control probe to be included in each sample well:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					EndogenousProbeVolume->2.1 Microliter
				],
				EndogenousProbeVolumes
			],
			{2.1 Microliter},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, EndogenousProbeStorageCondition, "Specify the storage condition under which the endogenous forward primer should be stored after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					EndogenousPrimerPair->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					EndogenousProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					EndogenousProbeFluorophore->Model[Molecule,"VIC Dye"],
					EndogenousProbeExcitationWavelength -> {520 Nanometer},
					EndogenousProbeEmissionWavelength -> {558 Nanometer},
					EndogenousProbeStorageCondition -> AmbientStorage
				],
				EndogenousProbeStorageConditions
			],
			{AmbientStorage}
		],
		Example[
			{Options, EndogenousProbeFluorophore, "Specify the fluorophore label on each endogenous probe:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					EndogenousPrimerPair->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					EndogenousProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					EndogenousProbeFluorophore->Model[Molecule, "VIC Dye"],
					EndogenousProbeExcitationWavelength->520 Nanometer,
					EndogenousProbeEmissionWavelength->558 Nanometer
				],
				EndogenousProbeFluorophores
			],
			{ObjectP[Model[Molecule,"VIC Dye"]]}
		],
		Example[
			{Options, EndogenousProbeExcitationWavelength, "Specify the wavelength at which each endogenous control probe should be excited:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					EndogenousProbeExcitationWavelength->580 Nanometer,
					EndogenousProbeEmissionWavelength->623 Nanometer
				],
				EndogenousProbeExcitationWavelengths
			],
			{580. Nanometer},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, EndogenousProbeEmissionWavelength, "Specify the wavelength at which each endogenous control probe's emission should be measured:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					EndogenousProbeExcitationWavelength->580 Nanometer,
					EndogenousProbeEmissionWavelength->623 Nanometer
				],
				EndogenousProbeEmissionWavelengths
			],
			{623. Nanometer},
			EquivalenceFunction->Equal
		],
		Example[
			{Options, Name, "Specify the name that will be given to the resultant protocol object:"},
			name = "qPCR Test Protocol " <> CreateUUID[];
			Download[
				ExperimentqPCR[
					Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Name->name
				],
				Name
			],
			name,
			Variables :> {name}
		],
		Example[
			{Options, NumberOfReplicates, "Specify how many times each input sample / primer set combination should be repeated in the qPCR assay plate:"},
			Download[
				ExperimentqPCR[
					Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					NumberOfReplicates->3
				],
				{NumberOfReplicates, Length[SamplesIn], Length[ForwardPrimers], Length[ReversePrimers]}
			],
			{3, 3, 3, 3}
		],
		Example[
			{Options, SamplesInStorageCondition, "Specify the storage condition of the input samples after the protocol is completed:"},
			Download[
				ExperimentqPCR[
					Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					SamplesInStorageCondition->AmbientStorage
				],
				SamplesInStorage
			],
			{AmbientStorage}
		],
				
		(* --- Sample prep option tests --- *)
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentqPCR[
				{"10-fold diluted sample", "100-fold diluted sample"},
				{
					{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}, 
					{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}
				},
 				PreparatoryUnitOperations -> {
   				LabelContainer[Label -> "10-fold diluted sample", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "100-fold diluted sample", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "10-fold diluted sample", Amount -> 900 Microliter],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "100-fold diluted sample", Amount -> 990 Microliter], 
  				Transfer[Source -> Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID], Destination -> "10-fold diluted sample", Amount -> 100*Microliter], 
  				Transfer[Source -> Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID], Destination -> "100-fold diluted sample", Amount -> 10*Microliter]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],

		Example[{Options, Incubate, "Set the Incubate option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, IncubateAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options},
			Messages :> {Warning::SampleStowaways}
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options},
			Messages :> {Warning::SampleStowaways}
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::SampleStowaways}
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::SampleStowaways}
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options = ExperimentqPCR[{Object[Sample,"Test Template in 50mL Tube for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, CentrifugeTemperature -> 10*Celsius, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, CentrifugeAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Set the Filtration option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options = ExperimentqPCR[{Object[Sample,"Test Template in 50mL Tube for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterMaterial -> PTFE, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PTFE,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options = ExperimentqPCR[{Object[Sample,"Test Template in 50mL Tube for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterMaterial -> PTFE, PrefilterMaterial -> GxF, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options = ExperimentqPCR[{Object[Sample,"Test Template in 50mL Tube for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "Set the FilterPoreSize option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentqPCR[{Object[Sample,"Test Template in 50mL Tube for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],*)
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], FilterAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Set the Aliquot option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentqPCR[{Object[Sample,"Test Template (5 mM) for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, TargetConcentration -> 1*Millimolar, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=ExperimentqPCR[{Object[Sample,"Test Template (5 mM) for ExperimentqPCR"<>$SessionUUID]},{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},TargetConcentration->1*Millimolar,TargetConcentrationAnalyte->Model[Molecule,Oligomer,"Test Template Molecule for ExperimentqPCR"<>$SessionUUID],AssayVolume->100*Microliter,Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,Oligomer,"Test Template Molecule for ExperimentqPCR"<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Set the ImageSample option to True will trigger a warning because we expect the samples for post processing will be Sterile->True:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Messages:> {Warning::PostProcessingSterileSamples},
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option to True will trigger a warning because we expect the samples for post processing will be Sterile->True:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Messages:> {Warning::PostProcessingSterileSamples},
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option to True will trigger a warning because we expect the samples for post processing will be Sterile->True:"},
			options = ExperimentqPCR[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, {{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}, MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Messages:> {Warning::PostProcessingSterileSamples},
			Variables :> {options}
		],
		
		Example[
			{Options, Template, "Provide an existing protocol object whose options should be used for a new protocol:"},
			Download[
				ExperimentqPCR[
					Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Template->templateProtocol
				],
				{Activation, MeltingCurve}
			],
			{False, False},
			Variables:>{templateProtocol},
			SetUp:> (
				Off[Warning::SamplesOutOfStock];
				(* Ensure template options are being applied by specifying a couple that default to the opposite boolean value *)
				templateProtocol = ExperimentqPCR[
					Object[Sample, "Test Template 1 for ExperimentqPCR" <> $SessionUUID],
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR" <> $SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR" <> $SessionUUID]}}},
					MeltingCurve -> False,
					Activation -> False
				];
			)
		],
		
		Example[{Options, AssayPlateStorageCondition, "Set the AssayPlateStorageCondition option:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, 
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					AssayPlateStorageCondition -> Refrigerator
				],
				AssayPlateStorageCondition
			],
			Refrigerator
		],
		Test["If not set explicitly, AssayPlateStorageCondition defaults to Disposal and is correctly reflected in the uploaded protocol object:",
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, 
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}
				],
				AssayPlateStorageCondition
			],
			Disposal
		],
		Example[{Options,ArrayCardStorageCondition,"Set the ArrayCardStorageCondition option:"},
			Download[
				ExperimentqPCR[
					{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
					Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID],
					ArrayCardStorageCondition->Refrigerator
				],
				ArrayCardStorageCondition
			],
			Refrigerator
		],
		Test["If not set explicitly,ArrayCardStorageCondition defaults to Disposal and is correctly reflected in the uploaded protocol object:",
			Download[
				ExperimentqPCR[
					{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
					Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID]
				],
				ArrayCardStorageCondition
			],
			Disposal
		],

		Example[{Options, MoatSize, "Set the MoatSize option:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, 
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MoatSize->1
				],
				{MoatSize, MoatBuffer, MoatVolume}
			],
			{1, _?(SameObjectQ[#, Model[Sample, "Milli-Q water"]]&), 5. Microliter}
		],
		Example[{Options, MoatBuffer, "Set the MoatBuffer option:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, 
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MoatBuffer->Model[Sample, StockSolution, "1x PBS from 10X stock"]
				],
				{MoatSize, MoatBuffer, MoatVolume}
			],
			{1, _?(SameObjectQ[#, Model[Sample, StockSolution, "1x PBS from 10X stock"]]&), 5. Microliter}
		],
		Example[{Options, MoatBuffer, "If MoatBuffer is the same as Buffer, combine the two into a single resource:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, 
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Buffer->Model[Sample, StockSolution, "1x PBS from 10X stock"],
					MoatBuffer->Model[Sample, StockSolution, "1x PBS from 10X stock"]
				],
				{Buffer, MoatBuffer}
			],
			_?(SameObjectQ@@#&)
		],
		Example[{Options, MoatBuffer, "If MoatBuffer is not the same as Buffer, separate resources are generated:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, 
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Buffer->Model[Sample, "Milli-Q water"],
					MoatBuffer->Model[Sample, StockSolution, "1x PBS from 10X stock"]
				],
				{Buffer, MoatBuffer}
			],
			_?(!SameObjectQ@@#&)
		],
		Example[{Options, MoatVolume, "Set the MoatVolume option:"},
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, 
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					MoatVolume->20 Microliter
				],
				{MoatSize, MoatBuffer, MoatVolume}
			],
			{1, _?(SameObjectQ[#, Model[Sample, "Milli-Q water"]]&), 20. Microliter}
		],
		Example[{Options, AliquotSampleLabel, "Set the MoatVolume option:"},
			Lookup[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					AliquotSampleLabel->Null,
					Output->Options
				],
				AliquotSampleLabel
			],
			{Null}
		],
		
		
		(* === Invalid Input Examples === *)
		(* 384-well plate overloads ObjectDoesNotExist *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentqPCR[
				Object[Sample, "Nonexistent sample"],
				{
					{
						{Model[Sample, "Test Primer Model 1 Forward for ExperimentqPCR"<>$SessionUUID], Model[Sample, "Test Primer Model 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentqPCR[
				Object[Container, Vessel, "Nonexistent container"],
				{
					{
						{Model[Sample, "Test Primer Model 1 Forward for ExperimentqPCR"<>$SessionUUID], Model[Sample, "Test Primer Model 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentqPCR[
				Object[Sample, "id:12345678"],
				{
					{
						{Model[Sample, "Test Primer Model 1 Forward for ExperimentqPCR"<>$SessionUUID], Model[Sample, "Test Primer Model 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentqPCR[
				Object[Container, Vessel, "id:12345678"],
				{
					{
						{Model[Sample, "Test Primer Model 1 Forward for ExperimentqPCR"<>$SessionUUID], Model[Sample, "Test Primer Model 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a primer sample model that does not exist (name form):"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Model[Sample, "Nonexistent model sample"]}
					}
				}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a primer container that does not exist (name form):"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Container, Vessel, "Nonexistent container"]}
					}
				}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a primer sample that does not exist (ID form):"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Model[Sample, "id:12345678"]}
					}
				}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Container, Vessel, "id:12345678"]}
					}
				}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],

		(* Array card overloads ObjectDoesNotExist *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist for an array card qPCR (name form):"},
			ExperimentqPCR[
				Object[Sample, "Nonexistent sample"],
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist for an array card qPCR (name form):"},
			ExperimentqPCR[
				Object[Container, Vessel, "Nonexistent container"],
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist for an array card qPCR (ID form):"},
			ExperimentqPCR[
				Object[Sample, "id:12345678"],
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist for an array card qPCR (ID form):"},
			ExperimentqPCR[
				Object[Container, Vessel, "id:12345678"],
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have an array card that does not exist (name form):"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				Object[Container,Plate,Irregular,ArrayCard,"Nonexistent array card"]
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have an array card that does not exist (ID form):"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				Object[Container,Plate,Irregular,ArrayCard,"id:12345678"]
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],

		Example[
			{Messages, "DiscardedSamples", "If samples are discarded, an error is displayed:"},
			ExperimentqPCR[
				{Object[Sample, "Test discarded sample for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}
			],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[
			{Messages, "DuplicateName", "If the specified value of the Name option is already in use by another qPCR protocol, an error is thrown:"},
			ExperimentqPCR[
 				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Name -> "LegacyID:3"
 			],
			$Failed,
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"DiscardedArrayCard","If using an array card, the array card cannot be discarded:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card 2 for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::DiscardedArrayCard,
				Error::InvalidInput
			}
		],
		Example[
			{Messages,"ArrayCardTooManySamples","If using an array card, the number of samples cannot exceed 8:"},
			ExperimentqPCR[
				Table[Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],9],
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::ArrayCardTooManySamples,
				Error::InvalidInput
			}
		],
		Example[
			{Messages,"ArrayCardContentsMismatch","If using an array card, the number of samples on the input array card must match the number of ForwardPrimers, ReversePrimers, and Probes from the array card model:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card 3 for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::ArrayCardContentsMismatch,
				Error::InvalidInput
			}
		],


		(* === Conflicting Options Tests === *)
		Example[
			{Messages, "DuplexStainingDyeSpecifiedWithMultiplex", "If DuplexStainingDye is specified and there's multiplexing in any sample, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
						{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				DuplexStainingDye->Model[Molecule,"SYBR Green"]
			],
			$Failed,
			Messages:>{
				Error::DuplexStainingDyeSpecifiedWithMultiplex,
				Error::MultiplexingWithoutProbe,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "ProbeDuplexStainingDyeConflict", "If Probe is specified for any sample and DuplexStainingDye is specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
				ProbeFluorophore->Model[Molecule,"6-FAM"],
				DuplexStainingDye->Model[Molecule,"SYBR Green"]
			],
			$Failed,
			Messages:>{
				Error::ProbeDuplexStainingDyeConflict,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "IncompleteDuplexStainingDyeExcitationEmissionPair", "If either DuplexStainingDyeExcitationWavelength or DuplexStainingDyeEmissionWavelength is specified and the other is not specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				DuplexStainingDyeExcitationWavelength->Null,
				DuplexStainingDyeEmissionWavelength->520 Nanometer
			],
			$Failed,
			Messages:>{
				Error::IncompleteDuplexStainingDyeExcitationEmissionPair,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "IncompleteReferenceDyeExcitationEmissionPair", "If either ReferenceDyeExcitationWavelength or ReferenceDyeEmissionWavelength is specified and the other is not specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				ReferenceDyeExcitationWavelength->Null,
				ReferenceDyeEmissionWavelength->520 Nanometer
			],
			$Failed,
			Messages:>{
				Error::IncompleteReferenceDyeExcitationEmissionPair,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "IncompleteProbeExcitationEmissionPair", "For each sample, if either ProbeExcitationWavelength or ProbeEmissionWavelength is specified and the other is not specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Probe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
				ProbeFluorophore->Model[Molecule,"6-FAM"],
				ProbeExcitationWavelength->Null,
				ProbeEmissionWavelength->520 Nanometer
			],
			$Failed,
			Messages:>{
				Error::IncompleteProbeExcitationEmissionPair,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "IncompleteStandardProbeExcitationEmissionPair", "For each sample, if either StandardProbeExcitationWavelength or StandardProbeEmissionWavelength is specified and the other is not specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
				StandardPrimerPair->{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
				StandardProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
				StandardProbeExcitationWavelength->Null,
				StandardProbeEmissionWavelength->520 Nanometer
			],
			$Failed,
			Messages:>{
				Error::IncompleteStandardProbeExcitationEmissionPair,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "IncompleteEndogenousProbeExcitationEmissionPair", "For each sample, if either EndogenousProbeExcitationWavelength or EndogenousProbeEmissionWavelength is specified and the other is not specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				EndogenousProbeExcitationWavelength->Null,
				EndogenousProbeEmissionWavelength->520 Nanometer
			],
			$Failed,
			Messages:>{
				Error::IncompleteEndogenousProbeExcitationEmissionPair,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "StandardPrimerPairNotAmongInputs", "If the specified standard primer pair does not appear in the set of input primer pairs, a warning is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
				StandardPrimerPair->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}}
			],
			ObjectP[Object[Protocol,qPCR]],
			Messages:>{
				Warning::StandardPrimerPairNotAmongInputs
			}
		],
		Example[
			{Messages, "StandardPrimerPairNotAmongInputs", "Standard primers among input primers check passes correctly when given a list of standard primers:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->{Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				StandardPrimerPair->{
					{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
					{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
				}
			],
			ObjectP[Object[Protocol,qPCR]]
		],
		Example[
			{Messages, "StandardPrimerPairNotAmongInputs", "Standard primers among input primers check fails correctly when given a list of standard primers:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->{Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				StandardPrimerPair->{
					{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
					{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
				}
			],
			ObjectP[Object[Protocol,qPCR]],
			Messages:>{
				Warning::StandardPrimerPairNotAmongInputs
			}
		],
		Example[
			{Messages, "CalculatedRampRateOutOfRange", "If the melting curve ramp rate is calculated based on ramp time and start/end temperature and is out of range, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				MeltingCurveTime->10 Second
			], 
			$Failed,
			Messages :> {
				Error::CalculatedRampRateOutOfRange,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "StandardPrimersRequired", "If Standard is specified but StandardPrimerPair is not specified, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard -> Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID]
			], 
			$Failed,
			Messages :> {
				Error::StandardPrimersRequired,
				Error::InvalidOption
			}
		],
		
		(* === Unresolvable options examples === *)
		Example[
			{Messages, "ProbeLengthError", "If Probe is specified for a sample but does not match the length of that sample's primer pair input, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Probe -> {{Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]}},
				ProbeFluorophore->Model[Molecule,"6-FAM"]
			],
			$Failed,
			Messages :> {
				Error::ProbeLengthError,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "ProbeVolumeLengthError", "If ProbeVolume and Probe do not match in length for any given sample, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Probe -> {{Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]}},
				ProbeVolume -> {{1 Microliter, 2 Microliter}},
				ProbeFluorophore->Model[Molecule,"6-FAM"]
			], 
			$Failed,
			Messages :> {
				Error::ProbeVolumeLengthError,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "ProbeFluorophoreLengthError", "If ProbeFluorophore and Probe do not match in length for any given sample, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Probe -> {{Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]}},
				ProbeFluorophore -> {{Model[Molecule, "6-FAM"], Model[Molecule, "VIC Dye"]}}
			], 
			$Failed,
			Messages :> {
				Error::ProbeFluorophoreLengthError,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "MultiplexingWithoutProbe", "If multiple primer pairs are supplied for a given sample but Probe is not specified to allow for multiplexing, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
						{Object[Sample,"Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				}
			], 
			$Failed,
			Messages :> {
				Error::MultiplexingWithoutProbe,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "ExcessiveVolume", "If total volume of all components does not exceed reaction volume for any of the input samples, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				SampleVolume -> 10 Microliter,
				ReactionVolume -> 20 Microliter
			],
			$Failed,
			Messages :> {
				Error::ExcessiveVolume, 
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "BufferVolumeMismatch", "If calculated buffer volume required (reaction volume minus total of all component volumes) does not match specified BufferVolume, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				BufferVolume -> 1 Microliter
			],
			$Failed,
			Messages :> {
				Error::qPCRBufferVolumeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DependentSampleOptionMissing", "If a probe-related option is specified without Probe being specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					},
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				ProbeVolume -> 1.5 Microliter
			],
			$Failed,
			Messages :> {Error::DependentSampleOptionMissing, Error::InvalidOption}
		],
		Test["If ProbeVolume is specified without Probe being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					},
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				ProbeVolume -> 1.5 Microliter
			],
			$Failed,
			Messages :> {Error::DependentSampleOptionMissing, Error::InvalidOption}
		],
		Test["If ProbeExcitationWavelength is specified without Probe being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					},
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				ProbeExcitationWavelength -> 470 Nanometer
			],
			$Failed,
			Messages :> {Error::IncompleteProbeExcitationEmissionPair, Error::DependentSampleOptionMissing, Error::InvalidOption}
		],
		Test["If ProbeEmissionWavelength is specified without Probe being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					},
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				ProbeEmissionWavelength -> 520 Nanometer
			],
			$Failed,
			Messages :> {Error::IncompleteProbeExcitationEmissionPair, Error::DependentSampleOptionMissing, Error::InvalidOption}
		],
		Test["If ProbeFluorophore is specified without Probe being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					},
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				ProbeFluorophore -> Model[Molecule, "VIC Dye"]
			],
			$Failed,
			Messages :> {Error::DependentSampleOptionMissing, Error::InvalidOption}
		],
		Test["If EndogenousProbeFluorophore is specified without EndogenousProbe being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					},
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				EndogenousProbeFluorophore -> Model[Molecule, "VIC Dye"]
			],
			$Failed,
			Messages :> {Error::DependentSampleOptionMissing, Error::InvalidOption}
		],
		Test["If Probe is specified without ProbeFluorophore being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					},
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				Probe -> Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::DependentSampleOptionMissing, Error::InvalidOption}
		],
		Test["If EndogenousProbe is specified without EndogenousProbeFluorophore being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					},
					{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				EndogenousProbe -> Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::DependentSampleOptionMissing, Error::InvalidOption}
		],
		Example[{Messages, "DependentOptionMissing", "If a standards-related option is specified without Standard being specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				StandardPrimerPair->{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		Test[
			"If StandardPrimerPair is specified without Standard being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				StandardPrimerPair->{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		Test[
			"If StandardForwardPrimerVolume is specified without Standard being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				StandardForwardPrimerVolume -> 1.5 Microliter
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		Test[
			"If StandardReversePrimerVolume is specified without Standard being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				StandardReversePrimerVolume -> 1.5 Microliter
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		Test[
			"If StandardProbe is specified without Standard being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				StandardProbe -> Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		Test[
			"If NumberOfStandardReplicates is specified without Standard being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				NumberOfStandardReplicates -> 2
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		Test[
			"If NumberOfDilutions is specified without Standard being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				NumberOfDilutions -> 4
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		Test[
			"If SerialDilutionFactor is specified without Standard being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				SerialDilutionFactor -> 4.2
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		Test[
			"If StandardProbeVolume is specified without StandardProbe being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				StandardProbeVolume -> 1.2 Microliter
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		Test[
			"If StandardProbeExcitationWavelength is specified without StandardProbe being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
				StandardPrimerPair->{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
				StandardProbeExcitationWavelength -> 470 Nanometer
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::IncompleteStandardProbeExcitationEmissionPair, Error::InvalidOption}
		],
		Test[
			"If StandardProbeEmissionWavelength is specified without StandardProbe being specified, an error is thrown:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
				StandardPrimerPair->{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
				StandardProbeEmissionWavelength -> 520 Nanometer
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::IncompleteStandardProbeExcitationEmissionPair, Error::InvalidOption}
		],
		Test[
			"Detection of options whose parent options are unspecified works with listed option values as well:",
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}
			],
			$Failed,
			Messages :> {Error::DependentOptionMissing, Error::InvalidOption}
		],
		(* Primer volume error examples *)
		Example[
			{Messages, "PrimerVolumeLengthError", "If ForwardPrimerVolume and primer input do not match in length for any given sample, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				ForwardPrimerVolume -> {{1 Microliter, 1.4 Microliter}}
			], 
			$Failed,
			Messages :> {
				Error::PrimerVolumeLengthError,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "PrimerVolumeLengthError", "If ReversePrimerVolume and primer input do not match in length for any given sample, an error is thrown:"},
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				ReversePrimerVolume -> {{1 Microliter, 1.4 Microliter}}
			], 
			$Failed,
			Messages :> {
				Error::PrimerVolumeLengthError,
				Error::InvalidOption
			}
		],
		Test[
			"For expansion purposes, flat lists of primer volumes are treated as singletons (as opposed to assuming they're intended to index match) and are expanded for multiple inputs with associated errors as necessary:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}
				},
				ForwardPrimerVolume -> {0.8 Microliter, 1.1 Microliter},
				ReversePrimerVolume -> {1 Microliter, 1.4 Microliter}
			], 
			$Failed,
			Messages :> {
				Error::PrimerVolumeLengthError,
				Error::InvalidOption
			}
		],
		Test[
			"Primer volume options work properly and without error if both are specified in a form that requires expansion:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}
				},
				ForwardPrimerVolume -> 0.8 Microliter,
				ReversePrimerVolume ->  1.1 Microliter
			], 
			ObjectP[Object[Protocol, qPCR]]
		],
		Test[
			"Primer volume options work properly and without error if both are specified but only one requires expansion:",
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				{
					{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}
				},
				ForwardPrimerVolume -> {{0.8 Microliter}, {0.9 Microliter}},
				ReversePrimerVolume ->  1.1 Microliter
			], 
			ObjectP[Object[Protocol, qPCR]]
		],
		
		(* This error message is not currently active. We will source a master mix variant to accommodate RT+SYBR. *)
		(* Example[
			{Messages, "NoCompatibleMasterMix", "If the specified options require a master mix combination not currently stocked, an error is thrown:"},
			(* By not using probes, this experiment function call effectively requests an RT master mix containing a duplex-staining dye *)
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				ReverseTranscription->True
			], 
			$Failed,
			Messages :> {
				Error::NoCompatibleMasterMix,
				Error::InvalidOption
			}
		], *)
		
		Example[
			{Messages, "DisabledFeatureOptionSpecified", "If ReverseTranscription->False and related options are specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				ReverseTranscription -> False,
				ReverseTranscriptionTemperature -> 40 Celsius
			],
			$Failed,
			Messages :> {Error::DisabledFeatureOptionSpecified, Error::InvalidOption}
		],
		Example[
			{Messages, "DisabledFeatureOptionSpecified", "If Activation->False and related options are specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Activation -> False,
				ActivationTemperature -> 84 Celsius
			],
			$Failed,
			Messages :> {Error::DisabledFeatureOptionSpecified, Error::InvalidOption}
		],
		Example[
			{Messages, "DisabledFeatureOptionSpecified", "If PrimerAnnealing->False and related options are specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				PrimerAnnealing -> False,
				PrimerAnnealingTemperature -> 61 Celsius
			],
			$Failed,
			Messages :> {Error::DisabledFeatureOptionSpecified, Error::InvalidOption}
		],
		Example[
			{Messages, "DisabledFeatureOptionSpecified", "If MeltingCurve->False and related options are specified, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				MeltingCurve -> False,
				MeltingCurveStartTemperature -> 60 Celsius,
				MeltingCurveEndTemperature -> 90 Celsius
			],
			$Failed,
			Messages :> {Error::DisabledFeatureOptionSpecified, Error::InvalidOption}
		],
		Example[
			{Messages, "EndogenousPrimersWithoutProbe", "If EndogenousPrimerPair is specified without EndogenousProbe, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				EndogenousPrimerPair ->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}}
			],
			$Failed,
			Messages :> {Error::EndogenousPrimersWithoutProbe, Error::InvalidOption}
		],
		
		Example[
			{Messages, "NullSampleVolume", "If ProbeVolume is Null while Probe is non-Null, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Probe -> {{Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]}},
				ProbeFluorophore -> Model[Molecule, "5-FAM"],
				ProbeVolume -> Null
			],
			$Failed,
			Messages :> {Error::NullSampleVolume, Error::InvalidOption}
		],
		Example[
			{Messages, "NullSampleVolume", "If EndogenousForwardPrimerVolume is Null while EndogenousPrimerPair is non-Null, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				EndogenousPrimerPair ->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
				EndogenousProbe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]},
				EndogenousProbeFluorophore -> Model[Molecule, "5-FAM"],
				EndogenousForwardPrimerVolume -> Null
			],
			$Failed,
			Messages :> {Error::NullSampleVolume, Error::InvalidOption}
		],
		Example[
			{Messages, "NullSampleVolume", "If EndogenousReversePrimerVolume is Null while EndogenousPrimerPair is non-Null, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				EndogenousPrimerPair ->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
				EndogenousProbe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]},
				EndogenousProbeFluorophore -> Model[Molecule, "5-FAM"],
				EndogenousReversePrimerVolume -> Null
			],
			$Failed,
			Messages :> {Error::NullSampleVolume, Error::InvalidOption}
		],
		Example[
			{Messages, "NullSampleVolume", "If EndogenousProbeVolume is Null while EndogenousProbe is non-Null, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				EndogenousPrimerPair ->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
				EndogenousProbe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]},
				EndogenousProbeFluorophore -> Model[Molecule, "5-FAM"],
				EndogenousProbeVolume -> Null
			],
			$Failed,
			Messages :> {Error::NullSampleVolume, Error::InvalidOption}
		],
		Example[
			{Messages, "NullVolume", "If StandardForwardPrimerVolume is Null while StandardPrimerPair is non-Null, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard -> {Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				StandardPrimerPair ->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
				StandardForwardPrimerVolume->Null
			],
			$Failed,
			Messages :> {Error::NullVolume, Error::InvalidOption}
		],
		Example[
			{Messages, "NullVolume", "If StandardReversePrimerVolume is Null while StandardPrimerPair is non-Null, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard -> {Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				StandardPrimerPair ->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
				StandardReversePrimerVolume->Null
			],
			$Failed,
			Messages :> {Error::NullVolume, Error::InvalidOption}
		],
		Example[
			{Messages, "NullVolume", "If StandardProbeVolume is Null while StandardProbe is non-Null, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard -> {Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				StandardPrimerPair ->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
				StandardProbe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]},
				StandardProbeVolume -> {Null}
			],
			$Failed,
			Messages :> {Error::NullVolume, Error::InvalidOption}
		],
		Example[
			{Messages, "DuplicateProbeWavelength", "If duplicate Ex/Em pairs exist between the probes and endogenous probe for a given sample well, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Probe -> {{Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]}},
				ProbeFluorophore -> Model[Molecule, "5-FAM"],
				ProbeExcitationWavelength -> 470 Nanometer,
				ProbeEmissionWavelength -> 520 Nanometer,
				EndogenousPrimerPair ->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
				EndogenousProbe -> {Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
				EndogenousProbeFluorophore -> Model[Molecule, "5-FAM"],
				EndogenousProbeExcitationWavelength -> 470 Nanometer,
				EndogenousProbeEmissionWavelength -> 520 Nanometer
			],
			$Failed,
			Messages :> {Error::DuplicateProbeWavelength, Error::InvalidOption}
		],
		Example[
			{Messages, "DuplicateProbeWavelength", "If duplicate Ex/Em pairs exist within the probes for given sample well, an error is thrown:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
						{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				Probe -> {{Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]}},
				ProbeFluorophore -> {{Model[Molecule, "5-FAM"], Model[Molecule, "5-FAM"]}},
				ProbeExcitationWavelength -> {{470 Nanometer, 470 Nanometer}},
				ProbeEmissionWavelength -> {{520 Nanometer, 520 Nanometer}}
			],
			$Failed,
			Messages :> {Error::DuplicateProbeWavelength, Error::InvalidOption}
		],
		Example[
			{Messages,"ForwardPrimerStorageConditionnMismatch","The specified forward primer storage conditions should be the same length as the number of forward primers:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
						{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				Probe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
				ProbeFluorophore->{Model[Molecule,"6-FAM"],Model[Molecule,"VIC Dye"]},
				ProbeExcitationWavelength -> {{470 Nanometer, 520 Nanometer}},
				ProbeEmissionWavelength -> {{520 Nanometer, 558 Nanometer}},
				DuplexStainingDye->Null,
				ForwardPrimerStorageCondition->{{AmbientStorage}}
			],
			$Failed,
			Messages :> {Error::ForwardPrimerStorageConditionnMismatch, Error::InvalidOption}
		],
		Example[
			{Messages,"ReversePrimerStorageConditionnMismatch","The specified reverse primer storage conditions should be the same length as the number of reverse primers:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
						{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				Probe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
				ProbeFluorophore->{Model[Molecule,"6-FAM"],Model[Molecule,"VIC Dye"]},
				ProbeExcitationWavelength -> {{470 Nanometer, 520 Nanometer}},
				ProbeEmissionWavelength -> {{520 Nanometer, 558 Nanometer}},
				DuplexStainingDye->Null,
				ReversePrimerStorageCondition->{{AmbientStorage}}
			],
			$Failed,
			Messages :> {Error::ReversePrimerStorageConditionnMismatch, Error::InvalidOption}
		],
		Example[
			{Messages,"ProbeStorageConditionMismatch","The specified probe storage conditions should be the same length as the number of probes:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{
					{
						{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
						{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}
				},
				Probe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
				ProbeFluorophore->{Model[Molecule,"6-FAM"],Model[Molecule,"VIC Dye"]},
				ProbeExcitationWavelength -> {{470 Nanometer, 520 Nanometer}},
				ProbeEmissionWavelength -> {{520 Nanometer, 558 Nanometer}},
				DuplexStainingDye->Null,
				ProbeStorageCondition->{Freezer,Freezer,Freezer}
			],
			$Failed,
			Messages :> {Error::ProbeStorageConditionMismatch, Error::InvalidOption}
		],
		Example[
			{Messages,"StandardStorageConditionMismatch","When Standard is Null, StandardStorageCondition should also be Null:"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->Null,
				StandardStorageCondition->Freezer
			],
			$Failed,
			Messages :> {Error::StandardStorageConditionMismatch, Error::InvalidOption}
		],
		Example[
			{Messages,"StandardForwardPrimerStorageConditionMismatch","When Standard and StandardPrimerPair are Null, StandardForwardPrimerStorageCondition should also be Null:"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->Null,
				StandardPrimerPair->Null,
				StandardForwardPrimerStorageCondition->Freezer
			],
			$Failed,
			Messages :> {Error::StandardForwardPrimerStorageConditionMismatch, Error::InvalidOption}
		],
		Example[
			{Messages,"StandardReversePrimerStorageConditionMismatch","When Standard and StandardPrimerPair are Null, StandardReversePrimerStorageCondition should also be Null:"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->Null,
				StandardPrimerPair->Null,
				StandardReversePrimerStorageCondition->Freezer
			],
			$Failed,
			Messages :> {Error::StandardReversePrimerStorageConditionMismatch, Error::InvalidOption}
		],
		Example[
			{Messages, "StandardProbeStorageConditionMismatch", "StandardProbeStorageCondition cannot be specified when Standard is Null:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
				StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
				StandardProbe->Null,
				StandardProbeStorageCondition->Freezer
			],
			$Failed,
			Messages :> {Error::StandardProbeStorageConditionMismatch,Error::InvalidOption}
		],
		Example[
			{Messages,"EndogenousForwardPrimerStorageConditionMismatch","The endogenous forward primer storage condition cannot be specified when EndogenousPrimerPair is Null:"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				EndogenousPrimerPair->Null,
				EndogenousForwardPrimerStorageCondition->Freezer
			],
			$Failed,
			Messages :> {Error::EndogenousForwardPrimerStorageConditionMismatch, Error::InvalidOption}
		],
		Example[
			{Messages,"EndogenousReversePrimerStorageConditionMismatch","The endogenous reverse primer storage condition cannot be specified when EndogenousPrimerPair is Null:"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				EndogenousPrimerPair->Null,
				EndogenousReversePrimerStorageCondition->Freezer
			],
			$Failed,
			Messages :> {Error::EndogenousReversePrimerStorageConditionMismatch, Error::InvalidOption}
		],
		Example[
			{Messages,"EndogenousProbeStorageConditionMismatch","The endogenous probe storage condition cannot be specified when EndogenousProbe is Null:"},
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				EndogenousPrimerPair->Null,
				EndogenousProbe->Null,
				EndogenousProbeStorageCondition->Freezer
			],
			$Failed,
			Messages :> {Error::EndogenousProbeStorageConditionMismatch, Error::InvalidOption}
		],
		Example[
			{Messages,"QPCRConflictingStorageConditions","If one sample is used multiple times in one experiment, the same storage condition must be given:"},
			ExperimentqPCR[
				{Object[Sample, "Test Template in non-automation container for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Template in non-automation container for ExperimentqPCR"<>$SessionUUID]},
				{
					{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}}
				},
				SamplesInStorageCondition->{AmbientStorage,Freezer}
			],
			$Failed,
			Messages :> {Error::QPCRConflictingStorageConditions, Error::InvalidOption}
		],
		Example[
			{Messages,"InvalidArrayCardReagentOptions","If using an array card, the ForwardPrimer, ReversePrimer, and Probe volume and storage condition options cannot be specified:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID],
				ForwardPrimerVolume->1 Microliter
			],
			$Failed,
			Messages:>{
				Error::InvalidArrayCardReagentOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InvalidArrayCardEndogenousOptions","If using an array card, the Endogenous options cannot be specified:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID],
				EndogenousPrimerPair->{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{
				Error::InvalidArrayCardEndogenousOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InvalidArrayCardStandardOptions","If using an array card, the Standard options cannot be specified:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID],
				Standard->Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::InvalidArrayCardStandardOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InvalidArrayCardDuplexStainingDyeOptions","If using an array card, the DuplexStainingDye options cannot be specified:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID],
				DuplexStainingDye->Model[Molecule,"SYBR Green"]
			],
			$Failed,
			Messages:>{
				Error::InvalidArrayCardDuplexStainingDyeOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InvalidArrayCardMeltingCurveOptions","If using an array card, the MeltingCurve options cannot be specified:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID],
				MeltingCurve->True
			],
			$Failed,
			Messages:>{
				Error::InvalidArrayCardMeltingCurveOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InvalidArrayCardMoatOptions","If using an array card, the Moat options cannot be specified:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID],
				MoatSize->1
			],
			$Failed,
			Messages:>{
				Error::InvalidArrayCardMoatOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InvalidArrayCardReplicateOption","If using an array card, the NumberOfReplicates option cannot be specified:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID],
				NumberOfReplicates->2
			],
			$Failed,
			Messages:>{
				Error::InvalidArrayCardReplicateOption,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"ArrayCardExcessiveVolume","If using an array card, the total volume of all components (sample, master mix, buffer) cannot exceed ReactionVolume*48:"},
			ExperimentqPCR[
				{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCR"<>$SessionUUID],
				SampleVolume->50 Microliter
			],
			$Failed,
			Messages:>{
				Error::ArrayCardExcessiveVolume,
				Error::InvalidOption
			}
		],


		(* === Tests === *)
		Test[
			"Single bare sample and list of primer pairs input runs without error:",
			ExperimentqPCR[
				Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}
			],
			ObjectP[Object[Protocol, qPCR]]
		],
		Test[
			"Samples and primer pairs are populated correctly when specifying multiple samples with one primer pair each:",
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{
						{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
						{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}}
					}
				],
				{SamplesIn, ForwardPrimers, ReversePrimers}
			],
			{
				LinkP /@ Download[{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]}, Object],
				Map[LinkP, Download[{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID]}, {Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID]}}, Object], {2}],
				Map[LinkP, Download[{{Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}, {Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}}, Object], {2}]
			}
		],
		Test[
			"StandardPrimerPair option works properly when both it and the Standard option are specified as singletons:",
			Download[
				ExperimentqPCR[
					{Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID]},
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
				],
				{StandardForwardPrimers, StandardReversePrimers}
			],
			{{ObjectP[Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID]]}, {ObjectP[Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]]}}
		],
		Test[
			"Evaluates successfully on modelless, typeless input samples:",
			ExperimentqPCR[
				Object[Sample, "Test modelless sample for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}
			],
			ObjectP[Object[Protocol, qPCR]]
		],
		Test[
			"Melting curve time is rounded appropriately if it must be calculated:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Output -> Options
				], 
				MeltingCurveTime
			],
			2333 Second,
			EquivalenceFunction -> Equal
		],
		Test[
			"Melting curve ramp rate is rounded appropriately if it must be calculated:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Output -> Options
				], 
				MeltingCurveTime
			],
			2333 Second,
			EquivalenceFunction -> Equal
		],
		
		(* === Examples and tests for qPCR QA changes === *)
		Test[
			"If any primer annealing related options are set, the PrimerAnnealing master switch resolves to True:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					PrimerAnnealingTime -> 15 Second,
					Output -> Options
				],
				PrimerAnnealing
			],
			True			
		],
		Test[
			"If no primer annealing related options are set, the PrimerAnnealing master switch resolves to False:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Output -> Options
				],
				PrimerAnnealing
			],
			False			
		],
		
		Test[
			"If any reverse transcription related options are set, the ReverseTranscription master switch resolves to True:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe->Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ReverseTranscriptionTime -> 10 Minute,
					Output -> Options
				],
				ReverseTranscription
			],
			True			
		],
		Test[
			"If no reverse transcription related options are set, the ReverseTranscription master switch resolves to False:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Output -> Options
				],
				ReverseTranscription
			],
			False			
		],
		
		Test[
			"StandardForwardPrimerVolume resolves to match StandardReversePrimerVolume if only the latter is specified:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard -> Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair -> {{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardForwardPrimerVolume -> 3 Microliter,
					Output -> Options
				],
				{StandardForwardPrimerVolume, StandardReversePrimerVolume}
			],
			{3 Microliter, 3 Microliter},
			EquivalenceFunction -> Equal			
		],
		Test[
			"StandardReversePrimerVolume resolves to match StandardForwardPrimerVolume if only the latter is specified:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardReversePrimerVolume->3 Microliter,
					Output -> Options
				],
				{StandardForwardPrimerVolume, StandardReversePrimerVolume}
			],
			{3 Microliter, 3 Microliter},
			EquivalenceFunction -> Equal	
		],
		Test[
			"StandardForwardPrimer and StandardReversePrimer both resolve to 1 uL if neither is specified:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					Output -> Options
				],
				{StandardForwardPrimerVolume, StandardReversePrimerVolume}
			],
			{1 Microliter, 1 Microliter},
			EquivalenceFunction -> Equal	
		],
		Test[
			"Specified values are used for both StandardForwardPrimerVolume and StandardReversePrimerVolume if applicable:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardForwardPrimerVolume->2 Microliter,
					StandardReversePrimerVolume->3 Microliter,
					Output -> Options
				],
				{StandardForwardPrimerVolume, StandardReversePrimerVolume}
			],
			{2 Microliter, 3 Microliter},
			EquivalenceFunction -> Equal	
		],
		
		Test[
			"Volume-related options are rounded to the nearest 0.1 Microliter:",
			Lookup[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Probe -> {Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID]},
					ProbeFluorophore->Model[Molecule,"6-FAM"],
					ProbeExcitationWavelength -> {{470 Nanometer}},
					ProbeEmissionWavelength -> {{520 Nanometer}},
					Standard->Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair->{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					StandardProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					EndogenousPrimerPair->{{Object[Sample, "Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					EndogenousProbe->Object[Sample, "Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					EndogenousProbeFluorophore->Model[Molecule,"VIC Dye"],
					EndogenousProbeExcitationWavelength -> {520 Nanometer},
					EndogenousProbeEmissionWavelength -> {558 Nanometer},
					ReactionVolume -> 19.01 Microliter,
					MasterMixVolume -> 8.67 Microliter,
					StandardVolume -> 1.74 Microliter,
					SampleVolume -> 1.53 Microliter,
					(* Omit buffer volume to avoid over-constraining *)
					ForwardPrimerVolume -> 1.21 Microliter,
					ReversePrimerVolume -> 1.29 Microliter,
					ProbeVolume -> 0.55 Microliter,
					EndogenousForwardPrimerVolume -> 1.21 Microliter,
					EndogenousReversePrimerVolume -> 1.29 Microliter,
					EndogenousProbeVolume -> 0.55 Microliter,
					StandardForwardPrimerVolume -> 1.21 Microliter,
					StandardReversePrimerVolume -> 2.19 Microliter,
					StandardProbeVolume -> 0.55 Microliter,
					Output -> Options
				],
				{
					ReactionVolume, 
					MasterMixVolume, 
					StandardVolume, 
					SampleVolume,
					ForwardPrimerVolume,
					ReversePrimerVolume,
					ProbeVolume,
					EndogenousForwardPrimerVolume,
					EndogenousReversePrimerVolume,
					EndogenousProbeVolume,
					StandardForwardPrimerVolume,
					StandardReversePrimerVolume,
					StandardProbeVolume
				}
			],
			(* Test that the list of all option values is equal to the list rounded to the nearest 0.1 uL *)
			_?(Equal[#, Round[#, 0.1 Microliter]]&),
			(* Since each of the rounded options will display a precision warning, we'll hit a General::stop as well *)
			Messages :> {Warning::InstrumentPrecision, General::stop}
		],
		Test[
			"If BufferVolume is specified and EXACTLY matches calculated buffer volume required (reaction volume minus total of all component volumes), no error is thrown:",
			ExperimentqPCR[
				Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
				{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
				BufferVolume -> 6 Microliter
			],
			ObjectP[Object[Protocol, qPCR]]
		],
		
		(* Tests for wonky primer-pair-indexed options that aren't handled properly by ExpandIndexMatchedInputs *)
		Test[
			"ForwardPrimerVolume expands correctly and without error if specified as a singleton (one sample, one primer pair):",
			Download[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					ForwardPrimerVolume -> 0.5 Microliter
				],
				ForwardPrimerVolumes
			],
			{{0.5 Microliter}},
			EquivalenceFunction -> Equal
		],
		Test[
			"ForwardPrimerVolume expands correctly and without error if specified as a singleton (one sample, multiple primer pairs):",
			Download[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{
						{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
						{Object[Sample,"Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
					}},
					Probe -> {Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
					ProbeFluorophore->{Model[Molecule,"6-FAM"],Model[Molecule,"VIC Dye"]},
					ProbeExcitationWavelength -> {{470 Nanometer, 520 Nanometer}},
					ProbeEmissionWavelength -> {{520 Nanometer, 558 Nanometer}},
					ForwardPrimerVolume -> 0.5 Microliter					
				],
				ForwardPrimerVolumes
			],
			{{0.5 Microliter, 0.5 Microliter}},
			EquivalenceFunction -> Equal
		],
		Test[
			"ForwardPrimerVolume expands correctly and without error if specified as a singleton (two samples, one primer pair each):",
			Download[
				ExperimentqPCR[
					{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
					{
						{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
						{{Object[Sample,"Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}}
					},
					ForwardPrimerVolume -> 0.5 Microliter
				],
				ForwardPrimerVolumes
			],
			{{0.5 Microliter}, {0.5 Microliter}},
			EquivalenceFunction -> Equal
		],
		Test[
			"ForwardPrimerVolume expands correctly and without error if specified as a singleton (two samples, two primer pairs each):",
			Download[
				ExperimentqPCR[
					{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
					{
						{
							{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
							{Object[Sample,"Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
						},
						{
							{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]},
							{Object[Sample,"Test Primer 2 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 2 Reverse for ExperimentqPCR"<>$SessionUUID]}
						}
					},
					Probe -> {Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Probe 2 for ExperimentqPCR"<>$SessionUUID]},
					ProbeFluorophore->{Model[Molecule,"6-FAM"],Model[Molecule,"VIC Dye"]},
					ProbeExcitationWavelength -> {{470 Nanometer, 520 Nanometer},{470 Nanometer, 520 Nanometer}},
					ProbeEmissionWavelength -> {{520 Nanometer, 558 Nanometer},{520 Nanometer, 558 Nanometer}},
					ForwardPrimerVolume -> 0.5 Microliter
				],
				ForwardPrimerVolumes
			],
			{{0.5 Microliter, 0.5 Microliter}, {0.5 Microliter, 0.5 Microliter}},
			EquivalenceFunction -> Equal
		],
		
		(* Test to ensure that other primer-pair-index-matched options get expanded correctly in spite of ExpandIndexMatchedInputs *)
		Test[
			"Probe, ProbeVolume, ProbeExcitationWavelength, and ProbeEmissionWavelength expand correctly and without error if specified as singletons:",
			Download[
				ExperimentqPCR[
					{Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID], Object[Sample,"Test Template 2 for ExperimentqPCR"<>$SessionUUID]},
					{
						{
							{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
						},
						{
							{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}
						}
					},
					Probe -> Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID],
					ProbeFluorophore->{Model[Molecule,"6-FAM"]},
					ProbeVolume -> 1.5 Microliter,
					ProbeExcitationWavelength -> 470 Nanometer,
					ProbeEmissionWavelength -> 520 Nanometer
				],
				{Probes, ProbeVolumes, ProbeExcitationWavelengths, ProbeEmissionWavelengths}
			],
			{
				{Repeated[{_?(SameObjectQ[#, Object[Sample,"Test Probe 1 for ExperimentqPCR"<>$SessionUUID]]&)}, {2}]},
				{Repeated[{1.5 Microliter}, {2}]},
				{Repeated[{470 Nanometer}, {2}]},
				{Repeated[{520 Nanometer}, {2}]}
			}
		],
		
		Test[
			"Executes without error and generates no buffer resource if no buffer is needed:",
			Download[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					(* 20 uL reaction - 10 uL master mix - 8 uL sample - 1 uL of each primer = 0 uL *)
					ReactionVolume -> 20 Microliter, 
					SampleVolume -> 8 Microliter
				],
				Buffer
			],
			Null
		],
		Test[
			"Buffer resource is still generated if needed for standard dilutions, even if not needed for SamplesIn:",
			Download[
				ExperimentqPCR[
					Object[Sample,"Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}},
					Standard -> Object[Sample, "Test Template 2 for ExperimentqPCR"<>$SessionUUID],
					StandardPrimerPair -> {{Object[Sample,"Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID],Object[Sample,"Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}},
					(* 20 uL reaction - 10 uL master mix - 8 uL sample - 1 uL of each primer = 0 uL *)
					ReactionVolume -> 20 Microliter, 
					SampleVolume -> 8 Microliter
				],
				Buffer
			],
			_?(SameObjectQ[#, Model[Sample, "Milli-Q water"]]&)
		],
		Test[
			"Master mix resource is requested in a liquid handler compatible container:",
			(
				prot = ExperimentqPCR[
					Object[Sample, "Test Template 1 for ExperimentqPCR"<>$SessionUUID],
					{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCR"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCR"<>$SessionUUID]}}}
				];
				rr = Download[prot, RequiredResources];
				mmResource = FirstCase[rr, {resObj_, MasterMix, _, _}:>Download[resObj, Object]];
				mmContainers = Download[mmResource, ContainerModels[Object]];
				(* Test that both specific container models have been requested and that those container models are LH-compatible *)
				{
					ContainsAll[
						Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling], 
						mmContainers
					],
					Length[mmContainers] > 0
				}
			),
			{True, True},
			Variables :> {prot, rr, mmResource, mmContainers}
		]
		
	},
	Parallel -> True,
	HardwareConfiguration -> HighRAM,
	SetUp :> (
		Off[Warning::SamplesOutOfStock];
	),
	TearDown :> (
		On[Warning::SamplesOutOfStock];
	),
	SymbolSetUp:>(
		Off[Warning::DeprecatedProduct];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		InternalExperiment`Private`qPCRTestSampleSetup["ExperimentqPCR"<>$SessionUUID];
	),
	SymbolTearDown:>(
		On[Warning::DeprecatedProduct];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
		EraseObject[DeleteCases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		Upload[<|Object -> #, Name -> Null|>& /@ Cases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]]];
		Unset[$CreatedObjects]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Section::Closed:: *)
(*ExperimentqPCROptions*)


DefineTests[
	ExperimentqPCROptions,
	{
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentqPCROptions[
				Object[Sample, "Test Template 1 for ExperimentqPCROptions"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCROptions"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCROptions"<>$SessionUUID]}}}
			],
      _Grid
    ],
		Example[{Basic,"Display the option values which will be used in the array card experiment:"},
			ExperimentqPCROptions[
				{Object[Sample,"Test Template 1 for ExperimentqPCROptions"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCROptions"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCROptions"<>$SessionUUID]
			],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
      ExperimentqPCROptions[
				Object[Sample, "Test discarded sample for ExperimentqPCROptions"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCROptions"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCROptions"<>$SessionUUID]}}}
			],
      _Grid,
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentqPCROptions[
				Object[Sample, "Test Template 1 for ExperimentqPCROptions"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCROptions"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCROptions"<>$SessionUUID]}}},
				OutputFormat->List
			],
      {(_Rule|_RuleDelayed)..}
    ]
  },
	SymbolSetUp:>(
		Off[Warning::DeprecatedProduct];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		InternalExperiment`Private`qPCRTestSampleSetup["ExperimentqPCROptions"<>$SessionUUID];
	),
	SymbolTearDown:>(
		On[Warning::DeprecatedProduct];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
		EraseObject[DeleteCases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		Upload[<|Object -> #, Name -> Null|>& /@ Cases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]]];
		Unset[$CreatedObjects]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Section::Closed:: *)
(*ExperimentqPCRPreview*)


DefineTests[
	ExperimentqPCRPreview,
	{
    Example[{Basic,"No preview is currently available for the experiment:"},
      ExperimentqPCRPreview[
				Object[Sample, "Test Template 1 for ExperimentqPCRPreview"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCRPreview"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCRPreview"<>$SessionUUID]}}}
			],
      Null
    ],
		Example[{Basic,"No preview is currently available for the array card experiment:"},
			ExperimentqPCRPreview[
				{Object[Sample,"Test Template 1 for ExperimentqPCRPreview"<>$SessionUUID],Object[Sample,"Test Template 2 for ExperimentqPCRPreview"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ExperimentqPCRPreview"<>$SessionUUID]
			],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentqPCROptions:"},
      ExperimentqPCROptions[
				Object[Sample, "Test Template 1 for ExperimentqPCRPreview"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCRPreview"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCRPreview"<>$SessionUUID]}}}
			],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentqPCRQ:"},
      ValidExperimentqPCRQ[
				Object[Sample, "Test Template 1 for ExperimentqPCRPreview"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ExperimentqPCRPreview"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ExperimentqPCRPreview"<>$SessionUUID]}}}
			],
      True
    ]
  },
	SymbolSetUp:>(
		Off[Warning::DeprecatedProduct];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		InternalExperiment`Private`qPCRTestSampleSetup["ExperimentqPCRPreview"<>$SessionUUID];
	),
	SymbolTearDown:>(
		On[Warning::DeprecatedProduct];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
		EraseObject[DeleteCases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		Upload[<|Object -> #, Name -> Null|>& /@ Cases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]]];
		Unset[$CreatedObjects]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Section::Closed:: *)
(*ValidExperimentqPCRQ*)


DefineTests[
	ValidExperimentqPCRQ,
	{
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentqPCRQ[
				Object[Sample, "Test Template 1 for ValidExperimentqPCRQ"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ValidExperimentqPCRQ"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ValidExperimentqPCRQ"<>$SessionUUID]}}}
			],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentqPCRQ[
				Object[Sample, "Test discarded sample for ValidExperimentqPCRQ"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ValidExperimentqPCRQ"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ValidExperimentqPCRQ"<>$SessionUUID]}}}
			],
      False
    ],
		Example[{Basic,"Verify that the array card experiment can be run without issues:"},
			ValidExperimentqPCRQ[
				{Object[Sample,"Test Template 1 for ValidExperimentqPCRQ"<>$SessionUUID],Object[Sample,"Test Template 2 for ValidExperimentqPCRQ"<>$SessionUUID]},
				Object[Container,Plate,Irregular,ArrayCard,"Test Array Card for ValidExperimentqPCRQ"<>$SessionUUID]
			],
			True
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentqPCRQ[
				Object[Sample, "Test Template 1 for ValidExperimentqPCRQ"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ValidExperimentqPCRQ"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ValidExperimentqPCRQ"<>$SessionUUID]}}},
				OutputFormat->TestSummary
			],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentqPCRQ[
				Object[Sample, "Test Template 1 for ValidExperimentqPCRQ"<>$SessionUUID],
				{{{Object[Sample, "Test Primer 1 Forward for ValidExperimentqPCRQ"<>$SessionUUID], Object[Sample, "Test Primer 1 Reverse for ValidExperimentqPCRQ"<>$SessionUUID]}}},
				Verbose->True
			],
      True
    ]
  },
	SymbolSetUp:>(
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		InternalExperiment`Private`qPCRTestSampleSetup["ValidExperimentqPCRQ"<>$SessionUUID];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
		EraseObject[DeleteCases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		Upload[<|Object -> #, Name -> Null|>& /@ Cases[$CreatedObjects, ObjectP[Model[Container, Plate, Irregular]]]];
		Unset[$CreatedObjects]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];