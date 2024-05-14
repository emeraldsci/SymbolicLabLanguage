(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentFreezeCells*)


DefineTests[ExperimentFreezeCells,
	{
		(* ---------- Basic Examples ---------- *)

		(* These tests are commented out because ExperimentFreezeCells is being re-written and these would fail on every automated unit test run in the meantime. *)

		(*

		Example[
			{Basic,"Freeze cells in preparation of long-term cryogenic storage:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]}
			],
			ObjectP[Object[Protocol,FreezeCells]]
		],
		
		Example[
			{Basic,"Containers that hold the samples can be specified instead of explicit sample objects:"},
			ExperimentFreezeCells[
				{Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 2"<>$SessionUUID],Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 3"<>$SessionUUID],Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 4"<>$SessionUUID],Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 5"<>$SessionUUID],Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 6"<>$SessionUUID]}
			],
			ObjectP[Object[Protocol,FreezeCells]]
		]
		
		(* ---------- Tests ---------- *)

		(* ValidInputLengthsQ does not check nested list options so there is extra code to check the lengths of options index-matched to Batches in the experiment *)
		Test[
			"Throws an error if any options index-matched to Batches are not the correct length:",
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]}
				},
				Instruments->{
					Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],
					Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],
					Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]
				}
			],
			$Failed,
			Messages:>{Error::InputLengthMismatch}
		],
		
		Test[
			"Throws an error if any options index-matched to Batches are not the correct length:",
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
				Instruments->{
					Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],
					Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],
					Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]
				},
				FreezingProfiles->{
					{{20 Celsius,1 Minute},{19 Celsius,2 Minute}},
					{{20 Celsius,1 Minute},{19 Celsius,2 Minute}}
				}
			],
			$Failed,
			Messages:>{Error::InputLengthMismatch}
		],
		
		Test[
			"Throws an error if any options index-matched to Batches are not the correct length:",
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]}
				},
				FreezingProfiles->{
					{{20 Celsius,1 Minute},{19 Celsius,2 Minute}},
					{{20 Celsius,1 Minute},{19 Celsius,2 Minute}},
					{{20 Celsius,1 Minute},{19 Celsius,2 Minute}}
				}
			],
			$Failed,
			Messages:>{Error::InputLengthMismatch}
		],
		
		Test[
			"Multiple error messages are shown when Batches are specified incorrectly in multiple ways:",
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]}
				}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidBatches,Error::FreezeCellsInvalidBatches,Error::InvalidOption}
		],
		
		Test[
			"Multiple error messages are shown when Batches are specified incorrectly in multiple ways:",
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidBatches,Error::FreezeCellsInvalidBatches,Error::FreezeCellsInvalidBatches,General::stop,Error::InvalidOption}
		],
		
		Test[
			"Templated Batches option is copied faithfully:",
			template=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID]}
				}
			];
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID]},
				Template->template,
				Output->Options
			];
			Lookup[options,Batches],
			{
				{ObjectP[Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID]]},
				{ObjectP[Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID]]}
			},
			Variables:>{template,options}
		],
		
		(* ---------- Options ---------- *)
		
		Example[
			{Options,Batches,"Specify how the samples will be grouped together for freezing:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]}
				},
				Output->Options
			];
			Lookup[options,Batches],
			{
				{ObjectP[Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]]},
				{ObjectP[Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID]],ObjectP[Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]]}
			},
			Variables:>{options}
		],
		
		Example[
			{Options,FreezingMethods,"Specify which process will be used to freeze each batch:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]}
				},
				FreezingMethods->{ControlledRateFreezer,InsulatedCooler},
				Output->Options
			];
			Lookup[options,FreezingMethods],
			{ControlledRateFreezer,InsulatedCooler},
			Variables:>{options}
		],
		
		Example[
			{Options,Instruments,"Specify which device will be used to freeze each batch:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]}
				},
				Instruments->{Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Model[Instrument,Freezer,"Stirling UltraCold SU780UE"]},
				Output->Options
			];
			Lookup[options,Instruments],
			{ObjectP[Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]],ObjectP[Model[Instrument,Freezer,"Stirling UltraCold SU780UE"]]},
			Variables:>{options}
		],
		
		Example[
			{Options,FreezingProfiles,"Specify the series of steps that will be taken to freeze each batch:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				FreezingProfiles->{{{20 Celsius,0 Minute},{4 Celsius,20 Minute},{4 Celsius,30 Minute},{-60 Celsius,90 Minute}}},
				Output->Options
			];
			Lookup[options,FreezingProfiles],
			{{{20 Celsius,0 Minute},{4 Celsius,20 Minute},{4 Celsius,30 Minute},{-60 Celsius,90 Minute}}},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,FreezingRates,"Specify the speed at which each batch will be frozen:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				FreezingRates->{1.5 Celsius/Minute},
				Output->Options
			];
			Lookup[options,FreezingRates],
			{1.5 Celsius/Minute},
			Variables:>{options}
		],
		
		Example[
			{Options,Durations,"Specify the length of time for which each batch will be cooled:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				Durations->{125 Minute},
				Output->Options
			];
			Lookup[options,Durations],
			{125 Minute},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,ResidualTemperatures,"Specify the final temperature of each batch after they are frozen:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				ResidualTemperatures->{-50 Celsius},
				Output->Options
			];
			Lookup[options,ResidualTemperatures],
			{-50 Celsius},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,FreezingContainers,"Specify the insulated cooler rack that will be used to freeze each batch:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				FreezingContainers->{Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]},
				Output->Options
			];
			Lookup[options,FreezingContainers],
			{ObjectP[Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]]},
			Variables:>{options}
		],
		
		Example[
			{Options,FreezingConditions,"Specify the storage type that will be used to freeze each insulated cooler batch:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				FreezingContainers->{Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]},
				FreezingConditions->{Freezer},
				Output->Options
			];
			Lookup[options,FreezingConditions],
			{Freezer},
			Variables:>{options}
		],
		
		Example[
			{Options,Coolants,"Specify the solution, in which the insulated cooler rack will be placed, for each batch:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				FreezingContainers->{Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]},
				Coolants->{Model[Sample,"Ethanol, Reagent Grade"]},
				Output->Options
			];
			Lookup[options,Coolants],
			{ObjectP[Model[Sample,"Ethanol, Reagent Grade"]]},
			Variables:>{options}
		],
		
		Example[
			{Options,CoolantVolumes,"Specify the amount of coolant solution in the container, in which the insulated cooler rack will be placed:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				FreezingContainers->{Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]},
				CoolantVolumes->{200 Milliliter},
				Output->Options
			];
			Lookup[options,CoolantVolumes],
			{200 Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,TransportConditions,"Specify the type of portable freezer that will be used to move the frozen cells from the instrument to their final storage destination:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID]},
				TransportConditions->{Minus40},
				Output->Options
			];
			Lookup[options,TransportConditions],
			{Minus40},
			Variables:>{options}
		],
		
		Example[
			{Options,StorageConditions,"Specify the type of final storage type for the samples:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				StorageConditions->{CryogenicStorage,DeepFreezer,CryogenicStorage,DeepFreezer},
				Output->Options
			];
			Lookup[options,StorageConditions],
			{CryogenicStorage,DeepFreezer,CryogenicStorage,DeepFreezer},
			Variables:>{options}
		],
		
		Example[
			{Options,Name,"Specify the name of the protocol object that will be created:"},
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Name->"My FreezeCells Protocol",
				Output->Options
			];
			Lookup[options,Name],
			"My FreezeCells Protocol",
			Variables:>{options}
		],
		
		Example[
			{Options,Template,"Specify a protocol object from which the options are copied:"},
			template=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]}
			];
			options=ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID]},
				Template->template,
				Output->Options
			];
			Lookup[options,Template],
			template,
			Variables:>{template,options}
		],
		
		(* ---------- Messages ---------- *)
		
		Example[
			{Messages,"FreezeCellsObjectNotInDatabase","An error will be shown if any specified objects are not in the database:"},
			ExperimentFreezeCells[
				{Object[Sample,"Fake Sample Not In Database"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsObjectNotInDatabase}
		],
		
		Example[
			{Messages,"FreezeCellsObjectNotInDatabase","An error will be shown if any specified objects are not in the database:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID]},
				Instruments->{Object[Instrument,ControlledRateFreezer,"Fake Instrument Not In Database"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsObjectNotInDatabase}
		],
		
		Example[
			{Messages,"FreezeCellsObjectNotInDatabase","An error will be shown if any specified objects are not in the database:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID]},
				FreezingContainers->{Object[Container,Rack,InsulatedCooler,"Fake InsulatedCooler Not In Database"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsObjectNotInDatabase}
		],
		
		Example[
			{Messages,"FreezeCellsRepeatedSamples","An error will be shown if any specified samples are repeated:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsRepeatedSamples,Error::InvalidInput}
		],
		
		Example[
			{Messages,"DiscardedSamples","An error will be shown if any specified samples are discarded:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Discarded Sample"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		
		Example[
			{Messages,"DiscardedSamples","An error will be shown if any specified samples are discarded:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Discarded Sample"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		
		Example[
			{Messages,"FreezeCellsSolidSamples","An error will be shown if any specified samples are in a solid state:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Solid Sample"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsSolidSamples,Error::InvalidInput}
		],
		
		Example[
			{Messages,"FreezeCellsSolidSamples","An error will be shown if any specified samples are in a solid state:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Solid Sample"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsSolidSamples,Error::InvalidInput}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleContainers","An error will be shown if any specified samples are not in compatible cryogenic vials:"},
			ExperimentFreezeCells[
				{
					Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],
					Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],
					Object[Sample,"FreezeCells Test Incompatible Container Sample"<>$SessionUUID]
				}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleContainers,Error::InvalidInput}
		],
		
		Example[
			{Messages,"FreezeCellsInstrumentalPrecision","A warning will be shown if any options are specified beyond the allowed precision of the experiment:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				FreezingRates->{1.001 Celsius/Minute,Automatic},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsInstrumentalPrecision
		],
		
		Example[
			{Messages,"FreezeCellsInstrumentalPrecision","A warning will be shown if any options are specified beyond the allowed precision of the experiment:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				Durations->{1.01 Minute,Automatic},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsInstrumentalPrecision
		],
		
		Example[
			{Messages,"FreezeCellsInstrumentalPrecision","A warning will be shown if any options are specified beyond the allowed precision of the experiment:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				ResidualTemperatures->{-80.001 Celsius,Automatic},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsInstrumentalPrecision
		],
		
		Example[
			{Messages,"FreezeCellsInstrumentalPrecision","A warning will be shown if any options are specified beyond the allowed precision of the experiment:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID]},{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]}},
				CoolantVolumes->{250.1 Milliliter,Automatic},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsInstrumentalPrecision
		],
		
		Example[
			{Messages,"FreezeCellsInstrumentalPrecision","A warning will be shown if any options are specified beyond the specifications of the experiment:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				FreezingProfiles->{{{20 Celsius,0.01 Minute},{-23.257 Celsius,24 Minute}},Automatic},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsInstrumentalPrecision
		],
		
		Example[
			{Messages,"FreezeCellsUnsupportedInstruments","An error will be shown if any specified instruments are retired or deprecated:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				Instruments->{Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Object[Instrument,ControlledRateFreezer,"FreezeCells Test Retired Instrument"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsUnsupportedInstruments,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsUnsupportedFreezingContainers","An error will be shown if any specified freezing containers are discarded or deprecated:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				FreezingContainers->{Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"],Object[Container,Rack,InsulatedCooler,"FreezeCells Test Discarded Insulated Rack"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsUnsupportedFreezingContainers,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsTooManyBatches","An error will be shown if the number of batches exceeds the number of samples:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				FreezingMethods->{InsulatedCooler,InsulatedCooler,InsulatedCooler}
			],
			$Failed,
			Messages:>{Error::FreezeCellsTooManyBatches,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsTooManyBatches","An error will be shown if the number of batches exceeds the number of samples:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				Instruments->{Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsTooManyBatches,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidBatches","An error will be shown if a batch contains duplicate samples:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID]},{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]}}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidBatches,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidBatches","An error will be shown if a batch contains samples that are not specified as input samples:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]}}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidBatches,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidBatches","An error will be shown if there are input samples that are not specified in Batches:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]}}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidBatches,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidBatches","An error will be shown if multiple batches contains the same sample:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]}
				}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidBatches,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIgnoredOptions","A warning will be shown if any specified options are inconsistent with FreezingMethods:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID]},{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]}},
				FreezingMethods->{ControlledRateFreezer,InsulatedCooler},
				Durations->{10 Minute,10 Minute},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsIgnoredOptions
		],
		
		Example[
			{Messages,"FreezeCellsIgnoredOptions","A warning will be shown if any specified options are inconsistent with FreezingMethods:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID]},{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]}},
				FreezingMethods->{ControlledRateFreezer,InsulatedCooler},
				CoolantVolumes->{250 Milliliter,250 Milliliter},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsIgnoredOptions
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleOptions","An error will be shown if a mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified at the same indices:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Instruments->{Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]},
				FreezingProfiles->{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-2 Celsius,40 Minute}},
				Durations->{30 Minute,Null}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleOptions","An error will be shown if a mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified at the same indices:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				Instruments->{Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]},
				Durations->{30 Minute,30 Minute},
				CoolantVolumes->{250 Milliliter,Null}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleOptions","An error will be shown if a mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified at the same indices:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				Instruments->{Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]},
				CoolantVolumes->{250 Milliliter,Null}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleOptions","An error will be shown if a mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified at the same indices:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				Instruments->Model[Instrument,Freezer,"Stirling UltraCold SU780UE"],
				Durations->{Null,30 Minute}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleOptions","An error will be shown if a mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified at the same indices:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				FreezingProfiles->{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-2 Celsius,40 Minute}},
				Durations->{Null,30 Minute}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleOptions","An error will be shown if a mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified at the same indices:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				FreezingProfiles->{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-2 Celsius,40 Minute}},
				CoolantVolumes->{250 Milliliter,Null}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleOptions","An error will be shown if a mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified at the same indices:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				Durations->{30 Minute,Null},
				CoolantVolumes->{250 Milliliter,Null}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleOptions","An error will be shown if a mixture of variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified at the same indices:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				Durations->{30 Minute,30 Minute},
				CoolantVolumes->{250 Milliliter,Null}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidOptions","An error will be shown if one or more required variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified as Null:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Instruments->Object[Instrument,ControlledRateFreezer,"Coldfinger"],
				ResidualTemperatures->{-80 Celsius,Null}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidOptions","An error will be shown if one or more required variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified as Null:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Instruments->Object[Instrument,ControlledRateFreezer,"Coldfinger"],
				FreezingProfiles->{Null,{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-2 Celsius,40 Minute}},Null},
				ResidualTemperatures->{Null,Null,-80 Celsius}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidOptions","An error will be shown if one or more required variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified as Null:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				ResidualTemperatures->{Null,Null,-80 Celsius},
				Durations->{Null,30 Minute,Null}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidOptions","An error will be shown if one or more required variable rate ControlledRateFreezer, constant rate ControlledRateFreezer and InsulatedCooler options were specified as Null:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				Coolants->{Null,Model[Sample,"Isopropanol"]},
				CoolantVolumes->{250 Milliliter,Null}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInconsistentBatchContainers","An error will be shown if specified batches contain a mixture of container that are incompatible with a single instrument rack or insulated cooler:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]}
				}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInconsistentBatchContainers,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsBatchesMethodInconsistent","An error will be shown if specified batches are inconsistent with the explicitly or implicitly specified FreezingMethods:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]}
				},
				FreezingMethods->{InsulatedCooler,ControlledRateFreezer}
			],
			$Failed,
			Messages:>{Error::FreezeCellsBatchesMethodInconsistent,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsBatchesMethodInconsistent","An error will be shown if specified batches are inconsistent with the explicitly or implicitly specified FreezingMethods:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]}
				},
				FreezingMethods->{Automatic,ControlledRateFreezer},
				Instruments->{Automatic,Object[Instrument,ControlledRateFreezer,"Coldfinger"]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsBatchesMethodInconsistent,Error::FreezeCellsBatchesRackInconsistent,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsBatchesMethodInconsistent","An error will be shown if specified batches are inconsistent with the explicitly or implicitly specified freezing methods:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]}
				},
				FreezingProfiles->{
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,64 Minute},{-30 Celsius,84 Minute}},
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,64 Minute},{-30 Celsius,84 Minute}}
				}
			],
			$Failed,
			Messages:>{Error::FreezeCellsBatchesMethodInconsistent,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsBatchesMethodInconsistent","An error will be shown if specified batches are inconsistent with the explicitly or implicitly specified freezing methods:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]}
				},
				Durations->{Automatic,1 Hour}
			],
			$Failed,
			Messages:>{Error::FreezeCellsBatchesMethodInconsistent,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsBatchesRackInconsistent","An error will be shown if specified batches are not inconsistent with the racks on specified Instruments or FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]}},
				Instruments->Object[Instrument,ControlledRateFreezer,"Coldfinger"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsBatchesRackInconsistent,Error::FreezeCellsBatchesMethodInconsistent,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsBatchesRackInconsistent","An error will be shown if specified batches are not inconsistent with the racks on specified Instruments or FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]}},
				Instruments->Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsBatchesRackInconsistent,Error::FreezeCellsBatchesMethodInconsistent,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsBatchesRackInconsistent","An error will be shown if specified batches are not inconsistent with the racks on specified Instruments or FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]}},
				FreezingContainers->Object[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack 1"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsBatchesRackInconsistent,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsBatchesRackInconsistent","An error will be shown if specified batches are not inconsistent with the racks on specified Instruments or FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]}},
				FreezingContainers->Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsBatchesRackInconsistent,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsBatchesRackInconsistent","An error will be shown if specified batches are not inconsistent with the racks on specified Instruments or FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]}},
				FreezingContainers->Model[Container,Rack,InsulatedCooler,"5mL Mr. Frosty Rack"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsBatchesRackInconsistent,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveBatchLengths","An error will be shown if specified batches contain more samples that can be accommodated based on specified or default options:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID]}},
				Instruments->Object[Instrument,ControlledRateFreezer,"Coldfinger"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveBatchLengths,Error::InvalidOption},
			SetUp:>{
				(* Make a 2 mL rack for VIA Freeze -- we have to do this locally because other tests depend on 5 mL tubes not fitting into the VIA Freeze, which is currently the situation in the lab. we are artificially checking this code here because I don't want to make 49 samples to test batch size *)
				Upload[
					<|
						Type->Model[Container,Rack],
						Name->"Test VIA Freeze Rack"<>$SessionUUID,
						Replace[Synonyms]->{"Test VIA Freeze Rack"<>$SessionUUID},
						Replace[Positions]->{
							<|Name->"A1",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A2",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A3",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A4",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A5",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>
						},
						NumberOfPositions->5,
						Footprint->ControlledRateFreezerRack,
						DeveloperObject->True
					|>
				];
			},
			Stubs:>{
				Search[Model[Container,Rack],Footprint==ControlledRateFreezerRack&&Deprecated!=True]={Model[Container,Rack,"Test VIA Freeze Rack"<>$SessionUUID]}
			},
			TearDown:>{
				(* Delete the rack *)
				EraseObject[Model[Container,Rack,"Test VIA Freeze Rack"<>$SessionUUID],Force->True,Verbose->False];
			}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveBatchLengths","An error will be shown if specified batches contain more samples that can be accommodated based on specified or default options:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID]}},
				Instruments->Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveBatchLengths,Error::InvalidOption},
			SetUp:>{
				(* Make a 2 mL rack for VIA Freeze -- we have to do this locally because other tests depend on 5 mL tubes not fitting into the VIA Freeze, which is currently the situation in the lab. we are artificially checking this code here because I don't want to make 49 samples to test batch size *)
				Upload[
					<|
						Type->Model[Container,Rack],
						Name->"Test VIA Freeze Rack"<>$SessionUUID,
						Replace[Synonyms]->{"Test VIA Freeze Rack"<>$SessionUUID},
						Replace[Positions]->{
							<|Name->"A1",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A2",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A3",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A4",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A5",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>
						},
						NumberOfPositions->5,
						Footprint->ControlledRateFreezerRack,
						DeveloperObject->True
					|>
				];
			},
			Stubs:>{
				Search[Model[Container,Rack],Footprint==ControlledRateFreezerRack&&Deprecated!=True]={Model[Container,Rack,"Test VIA Freeze Rack"<>$SessionUUID]}
			},
			TearDown:>{
				(* Delete the rack *)
				EraseObject[Model[Container,Rack,"Test VIA Freeze Rack"<>$SessionUUID],Force->True,Verbose->False];
			}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveBatchLengths","An error will be shown if specified batches contain more samples that can be accommodated based on specified or default options:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 16"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 17"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 18"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 19"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 16"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 17"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 18"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 19"<>$SessionUUID]}},
				FreezingContainers->Object[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack 1"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveBatchLengths,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveBatchLengths","An error will be shown if specified batches contain more samples that can be accommodated based on specified or default options:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 16"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 17"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 18"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 19"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 16"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 17"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 18"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 19"<>$SessionUUID]}},
				FreezingContainers->Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveBatchLengths,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveBatchLengths","An error will be shown if specified batches contain more samples that can be accommodated based on specified or default options:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID]}},
				FreezingMethods->ControlledRateFreezer
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveBatchLengths,Error::InvalidOption},
			SetUp:>{
				(* Make a 2 mL rack for VIA Freeze -- we have to do this locally because other tests depend on 5 mL tubes not fitting into the VIA Freeze, which is currently the situation in the lab. we are artificially checking this code here because I don't want to make 49 samples to test batch size *)
				Upload[
					<|
						Type->Model[Container,Rack],
						Name->"Test VIA Freeze Rack"<>$SessionUUID,
						Replace[Synonyms]->{"Test VIA Freeze Rack"<>$SessionUUID},
						Replace[Positions]->{
							<|Name->"A1",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A2",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A3",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A4",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A5",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>
						},
						NumberOfPositions->5,
						Footprint->ControlledRateFreezerRack,
						DeveloperObject->True
					|>
				];
			},
			Stubs:>{
				Search[Model[Container,Rack],Footprint==ControlledRateFreezerRack&&Deprecated!=True]={Model[Container,Rack,"Test VIA Freeze Rack"<>$SessionUUID]}
			},
			TearDown:>{
				(* Delete the rack *)
				EraseObject[Model[Container,Rack,"Test VIA Freeze Rack"<>$SessionUUID],Force->True,Verbose->False];
			}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveBatchLengths","An error will be shown if specified batches contain more samples that can be accommodated based on specified or default options:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 16"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 17"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 18"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 19"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 16"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 17"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 18"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 19"<>$SessionUUID]}},
				FreezingMethods->InsulatedCooler
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveBatchLengths,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveBatchLengths","An error will be shown if specified batches contain more samples that can be accommodated based on specified or default options:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 27"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 28"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 27"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 28"<>$SessionUUID]}}
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveBatchLengths,Error::InvalidOption},
			SetUp:>{
				(* Make a 2 mL rack for VIA Freeze -- we have to do this locally because other tests depend on 5 mL tubes not fitting into the VIA Freeze, which is currently the situation in the lab. we are artificially checking this code here because I don't want to make 49 samples to test batch size *)
				Upload[
					<|
						Type->Model[Container,Rack],
						Name->"Test VIA Freeze Rack"<>$SessionUUID,
						Replace[Synonyms]->{"Test VIA Freeze Rack"<>$SessionUUID},
						Replace[Positions]->{
							<|Name->"A1",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A2",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A3",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A4",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>,
							<|Name->"A5",Footprint->CryogenicVial,MaxWidth->0.0125 Meter,MaxDepth->0.0125 Meter,MaxHeight->0.09 Meter|>
						},
						NumberOfPositions->5,
						Footprint->ControlledRateFreezerRack,
						DeveloperObject->True
					|>
				];
			},
			Stubs:>{
				Search[Model[Container,Rack],Footprint==ControlledRateFreezerRack&&Deprecated!=True]={Model[Container,Rack,"Test VIA Freeze Rack"<>$SessionUUID]}
			},
			TearDown:>{
				(* Delete the rack *)
				EraseObject[Model[Container,Rack,"Test VIA Freeze Rack"<>$SessionUUID],Force->True,Verbose->False];
			}
		],
		
		Example[
			{Messages,"FreezeCellsMixedMethodTypes","A warning will be shown if mixed FreezingMethods were specified, either explicitly, or implicitly through other options,without Batches:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				FreezingMethods->{ControlledRateFreezer,InsulatedCooler,ControlledRateFreezer},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsMixedMethodTypes
		],
		
		Example[
			{Messages,"FreezeCellsMixedMethodTypes","A warning will be shown if mixed FreezingMethods were specified, either explicitly, or implicitly through other options,without Batches:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				FreezingMethods->{Automatic,InsulatedCooler,Automatic},
				Instruments->{Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Automatic,Object[Instrument,ControlledRateFreezer,"Coldfinger"]},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsMixedMethodTypes
		],
		
		Example[
			{Messages,"FreezeCellsMixedMethodTypes","A warning will be shown if mixed FreezingMethods were specified, either explicitly, or implicitly through other options,without Batches:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				FreezingProfiles->{
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,64 Minute},{-30 Celsius,84 Minute}},
					Null,
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,64 Minute},{-30 Celsius,84 Minute}}
				},
				FreezingContainers->{Null,Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"],Automatic},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsMixedMethodTypes
		],
		
		Example[
			{Messages,"FreezeCellsMixedMethodTypes","A warning will be shown if mixed FreezingMethods were specified, either explicitly, or implicitly through other options,without Batches:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Durations->{1 Hour,Null,Automatic},
				FreezingContainers->{Null,Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"],Automatic},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsMixedMethodTypes
		],
		
		Example[
			{Messages,"FreezeCellsInstrumentIncompatibleWithMethod","An error will be shown if specified instruments are not consistent with specified freezing methods:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]}
				},
				FreezingMethods->{ControlledRateFreezer,InsulatedCooler},
				Instruments->{Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInstrumentIncompatibleWithMethod,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInstrumentIncompatibleWithMethod","An error will be shown if specified instruments are not consistent with specified freezing methods:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]}
				},
				FreezingMethods->{ControlledRateFreezer,InsulatedCooler},
				Instruments->{Model[Instrument,Freezer,"Stirling UltraCold SU780UE"],Model[Instrument,Freezer,"Stirling UltraCold SU780UE"]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInstrumentIncompatibleWithMethod,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIgnoredFreezerObject","A warning will be shown if any Object[Instrument,Freezer] objects are specified as instruments, indicating that they will be ignored:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID]},
				Instruments->Object[Instrument,Freezer,"Test -80C Freezer"<>$SessionUUID],
				Output->Options
			],
			{_Rule..},
			Messages:>{Warning::FreezeCellsIgnoredFreezerObject,Lookup::invrl}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidConstantRateOptions","An error will be shown if specified FreezingRates and Durations produce ResidualTemperatures values that do not match its pattern:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingRates->{1 Celsius/Minute,0.5 Celsius/Minute},
				Durations->{1000 Minute,20 Minute}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidConstantRateOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidConstantRateOptions","An error will be shown if specified FreezingRates and ResidualTemperatures produce Durations values that do not match its pattern:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingRates->{0.01 Celsius/Minute,0.5 Celsius/Minute},
				ResidualTemperatures->{-100 Celsius,-1 Celsius}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidConstantRateOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidConstantRateOptions","An error will be shown if specified ResidualTemperatures and Durations produce FreezingRates values that do not match its pattern:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				Durations->{10 Minute,20 Minute},
				ResidualTemperatures->{-100 Celsius,-1 Celsius}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidConstantRateOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInconsistentConstantRateOptions","An error will be shown if FreezingRates, Durations and ResidualTemperatures are specified but are not mathematically consistent:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingRates->{1 Celsius/Minute,0.5 Celsius/Minute},
				Durations->{10 Minute,20 Minute},
				ResidualTemperatures->{12 Celsius,-1 Celsius}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInconsistentConstantRateOptions,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidTimeSpecification","An error will be shown if specified time steps in a FreezingProfile decreases from one step to the next:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingProfiles->{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-2 Celsius,20 Minute}}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidTimeSpecification,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidTimeSpecification","An error will be shown if specified time steps in a FreezingProfile decreases from one step to the next:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingProfiles->{{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-2 Celsius,20 Minute}}}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidTimeSpecification,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidTimeSpecification","An error will be shown if specified time steps in a FreezingProfile decreases from one step to the next:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingProfiles->{Null,{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-2 Celsius,20 Minute}}}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidTimeSpecification,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsProfileContainsWarmingStep","A warning will be shown if FreezingProfiles contains a warming step:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				FreezingProfiles->{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,64 Minute},{-20 Celsius,84 Minute}},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsProfileContainsWarmingStep
		],
		
		Example[
			{Messages,"FreezeCellsProfileContainsWarmingStep","A warning will be shown if FreezingProfiles contains a warming step:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
				FreezingProfiles->{
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,64 Minute},{-20 Celsius,84 Minute}},
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,64 Minute},{-20 Celsius,84 Minute}}
				},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsProfileContainsWarmingStep
		],
		
		Example[
			{Messages,"FreezeCellsProfileContainsWarmingStep","A warning will be shown if FreezingProfiles contains a warming step:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				FreezingProfiles->{
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,64 Minute},{-20 Celsius,84 Minute}},
					Null,
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,64 Minute},{-20 Celsius,84 Minute}}
				},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsProfileContainsWarmingStep
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveCoolingRate","An error will be shown if a FreezingProfile step specifies a temperature ramp that exceeds the capacity of the instrument:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingProfiles->{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,32 Minute},{-30 Celsius,52 Minute}}
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveCoolingRate,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveCoolingRate","An error will be shown if a FreezingProfile step specifies a temperature ramp that exceeds the capacity of the instrument:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingProfiles->{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-10 Celsius,40 Minute},{-10 Celsius,52 Minute}},
				Instruments->Model[Instrument,ControlledRateFreezer,"FreezeCells Test Instrument Model"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveCoolingRate,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveCoolingRate","An error will be shown if a FreezingProfile step specifies a temperature ramp that exceeds the capacity of the instrument:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingProfiles->{
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-10 Celsius,40 Minute},{-10 Celsius,52 Minute}},
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,32 Minute},{-30 Celsius,52 Minute}}
				},
				Instruments->{
					Model[Instrument,ControlledRateFreezer,"FreezeCells Test Instrument Model"<>$SessionUUID],
					Object[Instrument,ControlledRateFreezer,"Coldfinger"]
				}
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveCoolingRate,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveCoolingRate","An error will be shown if a FreezingProfile step specifies a temperature ramp that exceeds the capacity of the instrument:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingProfiles->{
					Null,
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,32 Minute},{-30 Celsius,52 Minute}}
				}
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveCoolingRate,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsExcessiveCoolingRate","An error will be shown if a FreezingProfile step specifies a temperature ramp that exceeds the capacity of the instrument:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
				FreezingProfiles->{
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-10 Celsius,40 Minute},{-10 Celsius,52 Minute}},
					Null,
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-30 Celsius,32 Minute},{-30 Celsius,52 Minute}}
				},
				Instruments->{
					Model[Instrument,ControlledRateFreezer,"FreezeCells Test Instrument Model"<>$SessionUUID],
					Model[Instrument,Freezer,"Stirling UltraCold SU780UE"],
					Object[Instrument,ControlledRateFreezer,"Coldfinger"]
				}
			],
			$Failed,
			Messages:>{Error::FreezeCellsExcessiveCoolingRate,Warning::FreezeCellsMixedMethodTypes,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleFreezingContainers","An error will be shown if specified FreezingContainers are incompatible with sample containers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]},
				FreezingContainers->Model[Container,Rack,InsulatedCooler,"5mL Mr. Frosty Rack"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleFreezingContainers,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleFreezingContainers","An error will be shown if specified FreezingContainers are incompatible with sample containers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]},
				FreezingContainers->Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleFreezingContainers,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleFreezingContainers","An error will be shown if specified FreezingContainers are incompatible with sample containers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
				FreezingContainers->{Model[Container,Rack,InsulatedCooler,"5mL Mr. Frosty Rack"]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleFreezingContainers,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleFreezingContainers","An error will be shown if specified FreezingContainers are incompatible with sample containers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID]},
				FreezingContainers->{Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleFreezingContainers,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidCoolantVolumeSpecification","An error will be shown if CoolantVolumes are specified without specifying Batches or FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				CoolantVolumes->{250 Milliliter,200 Milliliter}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidCoolantVolumeSpecification,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidCoolantVolumeSpecification","An error will be shown if CoolantVolumes are specified without specifying Batches or FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				CoolantVolumes->{250 Milliliter,300 Milliliter},
				Coolants->Model[Sample,"Isopropanol"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidCoolantVolumeSpecification,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidCoolantState","An error will be shown if any Coolants are in a non-liquid state:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Coolants->{Null,Model[Sample,"Sodium Chloride"]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidCoolantState,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidCoolantState","An error will be shown if any Coolants are in a non-liquid state:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Coolants->{Object[Sample,"FreezeCells Test Solid Coolant"<>$SessionUUID],Automatic}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInvalidCoolantState,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsLowMeltingCoolant","An error will be shown if any Coolants will freeze under the specified or default freezing conditions:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Coolants->{Null,Model[Sample,"Tissue Culture Grade Water"]},
				FreezingConditions->{Null,DeepFreezer},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsLowMeltingCoolant
		],
		
		Example[
			{Messages,"FreezeCellsLowMeltingCoolant","An error will be shown if any Coolants will freeze under the specified or default freezing conditions:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Coolants->{Null,Object[Sample,"FreezeCells Test Low Melting Coolant"<>$SessionUUID]},
				FreezingConditions->{Null,Freezer},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsLowMeltingCoolant
		],
		
		Example[
			{Messages,"FreezeCellsLowMeltingCoolant","An error will be shown if any Coolants will freeze under the specified or default freezing conditions:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Coolants->{Null,Model[Sample,"Tissue Culture Grade Water"]},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsLowMeltingCoolant
		],
		
		Example[
			{Messages,"FreezeCellsCoolantVolumeInvalid","An error will be shown if specified CoolantVolumes exceed the maximum volumes of the specified or default FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				CoolantVolumes->{250 Milliliter,300 Milliliter},
				FreezingContainers->Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsCoolantVolumeInvalid,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsCoolantVolumeInvalid","An error will be shown if specified CoolantVolumes exceed the maximum volumes of the specified or default FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				CoolantVolumes->{250 Milliliter,300 Milliliter},
				FreezingContainers->Object[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack 1"]
			],
			$Failed,
			Messages:>{Error::FreezeCellsCoolantVolumeInvalid,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsCoolantVolumeInvalid","An error will be shown if specified CoolantVolumes exceed the maximum volumes of the specified or default FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				CoolantVolumes->{250 Milliliter,300 Milliliter}
			],
			$Failed,
			Messages:>{Error::FreezeCellsCoolantVolumeInvalid,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleFreezer","An error will be shown if specified FreezingContainers and Instruments have inconsistent temperatures:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				Instruments->{Object[Instrument,ControlledRateFreezer,"Coldfinger"],Model[Instrument,Freezer,"Stirling UltraCold SU780XLE, -20C"]},
				FreezingConditions->{Null,DeepFreezer}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleFreezer,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleFreezer","An error will be shown if specified FreezingContainers and Instruments have inconsistent temperatures:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				Instruments->{Object[Instrument,ControlledRateFreezer,"Coldfinger"],Model[Instrument,Freezer,"Stirling UltraCold SU780UE"]},
				FreezingConditions->{Null,Freezer}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleFreezer,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInvalidTransportConditions","A warning will be shown if specified TransportConditions are not set to Minus40 or Minus80:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				TransportConditions->{Minus40,Chilled},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsInvalidTransportConditions
		],
		
		Example[
			{Messages,"FreezeCellsWarmingDuringTransport","A warning will be shown if specified TransportConditions are warmer than the final temperature of the cells after the freezing process:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				FreezingProfiles->{
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-80 Celsius,114 Minute}},
					{{4 Celsius,18 Minute},{4 Celsius,30 Minute},{-80 Celsius,114 Minute}}
				},
				TransportConditions->{Minus40,Minus40},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsWarmingDuringTransport
		],
		
		Example[
			{Messages,"FreezeCellsWarmingDuringTransport","A warning will be shown if specified TransportConditions are warmer than the final temperature of the cells after the freezing process:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				ResidualTemperatures->-80 Celsius,
				TransportConditions->{Minus40,Minus40},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsWarmingDuringTransport
		],
		
		Example[
			{Messages,"FreezeCellsWarmingDuringTransport","A warning will be shown if specified TransportConditions are warmer than the final temperature of the cells after the freezing process:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				FreezingRates->{1 Celsius/Minute,1.5 Celsius/Minute},
				Durations->72 Minute,
				TransportConditions->{Minus40,Minus40},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsWarmingDuringTransport
		],
		
		Example[
			{Messages,"FreezeCellsWarmingDuringTransport","A warning will be shown if specified TransportConditions are warmer than the final temperature of the cells after the freezing process:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]}
				},
				FreezingConditions->{DeepFreezer,DeepFreezer},
				TransportConditions->{Minus40,Minus40},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsWarmingDuringTransport
		],
		
		Example[
			{Messages,"FreezeCellsWarmingDuringTransport","A warning will be shown if specified TransportConditions are warmer than the final temperature of the cells after the freezing process:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				Instruments->{Model[Instrument,Freezer,"Stirling UltraCold SU780UE"],Model[Instrument,Freezer,"Stirling UltraCold SU780UE"]},
				TransportConditions->{Minus40,Minus40},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsWarmingDuringTransport
		],
		
		Example[
			{Messages,"FreezeCellsWarmingDuringTransport","A warning will be shown if specified TransportConditions are warmer than the final temperature of the cells after the freezing process:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				FreezingMethods->InsulatedCooler,
				TransportConditions->{Minus40,Minus40},
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsWarmingDuringTransport
		],
		
		Example[
			{Messages,"FreezeCellsCannotResolveBatches","An error will be shown if specified samples require a method that was not specified:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID]},
				FreezingMethods->{ControlledRateFreezer}
			],
			$Failed,
			Messages:>{Error::FreezeCellsCannotResolveBatches,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsCannotResolveBatches","An error will be shown if specified samples require a method that was not specified:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 27"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 28"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 29"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 30"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 31"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 32"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 33"<>$SessionUUID]},
				FreezingMethods->{InsulatedCooler}
			],
			$Failed,
			Messages:>{Error::FreezeCellsCannotResolveBatches,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsCannotResolveBatches","An error will be shown if specified samples require a method that was not specified:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 16"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 17"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 18"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 19"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 27"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 28"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 29"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 30"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 31"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 32"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 33"<>$SessionUUID]},
				FreezingMethods->{InsulatedCooler,InsulatedCooler,InsulatedCooler}
			],
			$Failed,
			Messages:>{Error::FreezeCellsCannotResolveBatches,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleCoolants","An error will be shown if specified Coolants are not chemically compatible with the FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID]},{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]}},
				FreezingContainers->{Null,Model[Container,Rack,InsulatedCooler,"5mL Mr. Frosty Rack"]},
				Coolants->{Null,Model[Sample,"Acetone, Reagent Grade"]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleCoolants,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsIncompatibleCoolants","An error will be shown if specified Coolants are not chemically compatible with the FreezingContainers:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]},
				Batches->{{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID]},{Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID]}},
				FreezingContainers->{Null,Model[Container,Rack,InsulatedCooler,"5mL Mr. Frosty Rack"]},
				Coolants->{Null,Object[Sample,"FreezeCells Test Incompatible Coolant"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsIncompatibleCoolants,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInsufficientCoolants","An error will be shown if specified Coolants do not have enough volume for the experiment:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID]}
				},
				Coolants->{Null,Null,Object[Sample,"FreezeCells Test Insufficient Coolant"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInsufficientCoolants,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsInsufficientCoolants","An error will be shown if specified Coolants do not have enough volume for the experiment:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID]},
				Batches->{
					{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID]},
					{Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID]}
				},
				Coolants->{Object[Sample,"FreezeCells Test Insufficient Coolant 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Insufficient Coolant 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Insufficient Coolant 2"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{Error::FreezeCellsInsufficientCoolants,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsWarmingDuringTransport","An error will be shown if specified StorageConditions for any samples are above the final freezing temperature in the experiment:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				StorageConditions->Freezer,
				Output->Options
			],
			{_Rule..},
			Messages:>Warning::FreezeCellsWarmingDuringTransport
		],
		
		Example[
			{Messages,"DuplicateName","An error will be shown if the specified protocol name exists in the database:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID]},
				Name->"FreezeCells Test Protocol"<>$SessionUUID
			],
			$Failed,
			Messages:>{Error::DuplicateName,Error::InvalidOption}
		],
		
		Example[
			{Messages,"FreezeCellsMaxTimeExceeded","An error will be shown if the specified experiment length exceeds maximum allowed experiment duration:"},
			ExperimentFreezeCells[
				{Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID]},
				FreezingMethods->{ControlledRateFreezer,ControlledRateFreezer},
				Durations->{50 Hour,50 Hour}
			],
			$Failed,
			Messages:>Error::FreezeCellsMaxTimeExceeded
		]

		*)
	},
	SetUp:>(ClearMemoization[];),
	SymbolSetUp:>{Block[{$DeveloperUpload = True},
		Module[{namedObjects,existsFilter,testBench,testBenchPacket,cellSampleModel,freezerObjectPacket,numVials2mL,vials2mL,vials2mLModels,vials2mLNames,vials2mLSampleAmounts,numVials5mL,vials5mL,vials5mLModels,vials5mLNames,vials5mLSampleAmounts,vial,tube,vialModel,tubeModel,vialName,tubeName,vialSampleAmount,tubeSampleAmount,allCellSampleContainerModels,allCellSampleContainers,allCellSampleContainerNames,allCellSampleAmounts,numBottles500mL,bottles500mL,bottles500mLModels,bottles500mLNames,bottle,bottleModel,bottleName,allReagentSampleContainerModels,allReagentSampleContainers,allReagentSampleContainerNames,discardedRack,discardedRackModel,discardedRackName,allTestContainers,allTestContainerModels,allTestContainerNames,allTestContainerPackets,numberOfCellSamples,cellSampleNames,cellSampleModels,reagentSampleModels,reagentSampleNames,reagentSampleAmounts,allSampleModels,allSampleNames,allSampleAmounts,allSamples,allSamplePackets,retiredInstrumentPacket,newCoolingRateInstrumentPacket,duplicateNameProtocolPacket,solidSampleUpdatePacket,objectsToBeDiscarded,discardedObjectPackets},
			ClearDownload[];
			
			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			
			(* Test objects we will create *)
			namedObjects={
				Object[Instrument,Freezer,"Test -80C Freezer"<>$SessionUUID],
				Model[Sample,"FreezeCells Test Cell Sample"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 1"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 2"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 3"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 4"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 5"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 6"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 7"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 8"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 9"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 10"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 11"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 12"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 13"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 14"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 15"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 16"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 17"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 18"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 19"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 20"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 21"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 1.2mL Cryo Vial"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 1"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 2"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 3"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 4"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 5"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 6"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 7"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 8"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 9"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 10"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 11"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 12"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 13"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Tube"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 500mL Bottle 1"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 500mL Bottle 2"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 500mL Bottle 3"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 500mL Bottle 4"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 1L Bottle"<>$SessionUUID],
				Object[Instrument,ControlledRateFreezer,"FreezeCells Test Retired Instrument"<>$SessionUUID],
				Object[Container,Rack,InsulatedCooler,"FreezeCells Test Discarded Insulated Rack"<>$SessionUUID],
				Model[Instrument,ControlledRateFreezer,"FreezeCells Test Instrument Model"<>$SessionUUID],
				Object[Protocol,FreezeCells,"FreezeCells Test Protocol"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 16"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 17"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 18"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 19"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 27"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 28"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 29"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 30"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 31"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 32"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 33"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 34"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 35"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Discarded Sample"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Solid Sample"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Incompatible Container Sample"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Incompatible Coolant"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Insufficient Coolant"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Insufficient Coolant 2"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Solid Coolant"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Low Melting Coolant"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for ExperimentFreezeCells"<>$SessionUUID]
			};
			
			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];
			
			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];
			
			testBench = CreateID[Object[Container,Bench]];
			testBenchPacket = UploadSample[
				Model[Container,Bench,"The Bench of Testing"],
				{$Site[AllowedPositions][[1]],$Site},
				Name->"Test Bench for ExperimentFreezeCells"<>$SessionUUID,
				ID->testBench[ID],
				FastTrack->True,
				Upload->False
			];
			
			(* Upload the objects *)
			freezerObjectPacket = <|
				Type->Object[Instrument,Freezer],
				Name->"Test -80C Freezer"<>$SessionUUID
			|>;
			
			(* Sample models *)
			cellSampleModel = UploadSampleModel["FreezeCells Test Cell Sample"<>$SessionUUID,
				Composition->{{100 MassPercent,Link[Model[Cell,Mammalian,"HEK293"]]}},
				IncompatibleMaterials->{None},
				BiosafetyLevel->"BSL-1",
				Living->True,
				State->Liquid,
				DefaultStorageCondition->Model[StorageCondition,"Cryogenic Storage"],
				Expires->False
			];
			
			(* Containers for samples *)
			
			numVials2mL = 21;
			vials2mL = CreateID[ConstantArray[Object[Container,Vessel],numVials2mL]];
			vials2mLModels = ConstantArray[Model[Container,Vessel,"2mL Cryogenic Vial"],numVials2mL];
			vials2mLNames = Map[#<>$SessionUUID&,Join[Map["FreezeCells Test 2mL Cryo Vial "<>ToString[#]&,Range[numVials2mL]]]];
			vials2mLSampleAmounts = ConstantArray[2Milliliter,numVials2mL];
			
			numVials5mL = 13;
			vials5mL = CreateID[ConstantArray[Object[Container,Vessel],numVials5mL]];
			vials5mLModels = ConstantArray[Model[Container,Vessel,"5mL Cryogenic Vial"],numVials5mL];
			vials5mLNames = Map["FreezeCells Test 5mL Cryo Vial "<>ToString[#]<>$SessionUUID&, Range[numVials5mL]];
			vials5mLSampleAmounts = ConstantArray[5Milliliter,numVials5mL];
			
			{vial,tube} = CreateID[{Object[Container,Vessel],Object[Container,Vessel]}];
			{vialModel,tubeModel} = {Model[Container,Vessel,"1.2mL Cryogenic Vial"],Model[Container,Vessel,"2mL Tube"]};
			{vialName,tubeName} = {"FreezeCells Test 1.2mL Cryo Vial"<>$SessionUUID,"FreezeCells Test 2mL Tube"<>$SessionUUID};
			{vialSampleAmount,tubeSampleAmount} = {1.2Milliliter,2Milliliter};
			
			allCellSampleContainerModels = Join[vials2mLModels,{vialModel},vials5mLModels,{tubeModel}];
			allCellSampleContainers = Join[vials2mL,{vial},vials5mL,{tube}];
			allCellSampleContainerNames = Join[vials2mLNames,{vialName},vials5mLNames,{tubeName}];
			allCellSampleAmounts = Join[vials2mLSampleAmounts,{vialSampleAmount},vials5mLSampleAmounts,{tubeSampleAmount}];
			
			(* Containers for freeze cell reagents *)
			
			numBottles500mL = 4;
			bottles500mL = CreateID[ConstantArray[Object[Container,Vessel],numBottles500mL]];
			bottles500mLModels = ConstantArray[Model[Container,Vessel,"500mL Glass Bottle"],numBottles500mL];
			bottles500mLNames = Map["FreezeCells Test 500mL Bottle "<>ToString[#]<>$SessionUUID&, Range[numBottles500mL]];
			
			bottle = CreateID[Object[Container,Vessel]];
			{bottleModel,bottleName} = {Model[Container,Vessel,"1L Glass Bottle"],"FreezeCells Test 1L Bottle"<>$SessionUUID};
			
			allReagentSampleContainerModels = Join[bottles500mLModels,{bottleModel}];
			allReagentSampleContainers = Join[bottles500mL,{bottle}];
			allReagentSampleContainerNames = Join[bottles500mLNames,{bottleName}];
			
			discardedRack = CreateID[Object[Container,Rack,InsulatedCooler]];
			{discardedRackModel,discardedRackName} = {Model[Container,Rack,InsulatedCooler,"2mL Mr. Frosty Rack"],"FreezeCells Test Discarded Insulated Rack"<>$SessionUUID};
			
			allTestContainers = Join[allCellSampleContainers,allReagentSampleContainers,{discardedRack}];
			allTestContainerModels = Join[allCellSampleContainerModels,allReagentSampleContainerModels,{discardedRackModel}];
			allTestContainerNames = Join[allCellSampleContainerNames,allReagentSampleContainerNames,{discardedRackName}];
			
			allTestContainerPackets = UploadSample[allTestContainerModels,
				ConstantArray[{"Bench Top Slot", testBench},Length[allTestContainerModels]],
				Name->allTestContainerNames,
				ID->allTestContainers[ID],
				Cache->testBenchPacket,
				Upload->False
			];
			
			(* Test cell samples *)
			numberOfCellSamples = Length[allCellSampleContainerModels];
			cellSampleNames = Join[
				Map["FreezeCells Test Sample "<>ToString[#]<>$SessionUUID&,Range[numVials2mL-2]],
				{
					"FreezeCells Test Discarded Sample"<>$SessionUUID,
					"FreezeCells Test Solid Sample"<>$SessionUUID,
					"FreezeCells Test Sample "<>ToString[numVials2mL-1]<>$SessionUUID
				},
				Map["FreezeCells Test Sample "<>ToString[#]<>$SessionUUID&,Range[numVials2mL,numVials2mL+numVials5mL-1]],
				{
					"FreezeCells Test Incompatible Container Sample" <> $SessionUUID
				}
			];
			cellSampleModels = ConstantArray[cellSampleModel,Length[cellSampleNames]];
			
			(* Test reagent samples *)
			{reagentSampleModels,reagentSampleNames,reagentSampleAmounts} = Transpose[{
				{Model[Sample,"Acetone, Reagent Grade"],"FreezeCells Test Incompatible Coolant"<>$SessionUUID,500Milliliter},
				{Model[Sample,"Isopropanol"],"FreezeCells Test Insufficient Coolant"<>$SessionUUID,100Milliliter},
				{Model[Sample,"Isopropanol"],"FreezeCells Test Insufficient Coolant 2"<>$SessionUUID,500Milliliter},
				{Model[Sample,"Sodium Chloride"],"FreezeCells Test Solid Coolant"<>$SessionUUID,500Gram},
				{Model[Sample,"Tissue Culture Grade Water"],"FreezeCells Test Low Melting Coolant"<>$SessionUUID,500Milliliter}
			}];
			
			allSampleModels = Join[cellSampleModels,reagentSampleModels];
			allSampleNames = Join[cellSampleNames,reagentSampleNames];
			allSampleAmounts = Join[allCellSampleAmounts,reagentSampleAmounts];
			
			allSamples = CreateID[ConstantArray[Object[Sample],Length[allSampleModels]]];
			allSamplePackets = UploadSample[allSampleModels,
				Map[{"A1",#}&,Join[allCellSampleContainers,allReagentSampleContainers]],
				InitialAmount->allSampleAmounts,
				Name->allSampleNames,
				ID->allSamples[ID],
				Cache->allTestContainerPackets,
				Status->Available,
				Upload->False
			];
			
			retiredInstrumentPacket = <|
				Type->Object[Instrument,ControlledRateFreezer],
				Model->Link[Model[Instrument,ControlledRateFreezer,"VIA Freeze Research"],Objects],
				Name->"FreezeCells Test Retired Instrument"<>$SessionUUID,
				Site->Link[$Site],
				Status->Retired
			|>;
			
			(* Instrument model with a different cooling rate *)
			newCoolingRateInstrumentPacket = <|
				Type->Model[Instrument,ControlledRateFreezer],
				Name->"FreezeCells Test Instrument Model"<>$SessionUUID,
				MaxCoolingRate->1 Celsius/Minute
			|>;
			
			(* Protocol for duplicate name check *)
			duplicateNameProtocolPacket = <|
				Type->Object[Protocol,FreezeCells],
				Name->"FreezeCells Test Protocol"<>$SessionUUID,
				Site->Link[$Site]
			|>;
			
			solidSampleUpdatePacket = <|Object->allSamples[[21]],Mass->2Gram,State->Solid|>;
			
			Upload[Flatten[{allTestContainerPackets,allSamplePackets,retiredInstrumentPacket,freezerObjectPacket,newCoolingRateInstrumentPacket,duplicateNameProtocolPacket,solidSampleUpdatePacket}]];
			
			objectsToBeDiscarded = {discardedRack,Object[Sample,"FreezeCells Test Discarded Sample"<>$SessionUUID]};
			UploadSampleStatus[objectsToBeDiscarded,Discarded];
		]];
	},
	
	SymbolTearDown:>{
		Module[{namedObjects,existsFilter},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			
			(* Erase any objects that still exist in the database *)
			namedObjects={
				Object[Instrument,Freezer,"Test -80C Freezer"<>$SessionUUID],
				Model[Sample,"FreezeCells Test Cell Sample"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 1"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 2"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 3"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 4"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 5"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 6"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 7"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 8"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 9"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 10"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 11"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 12"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 13"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 14"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 15"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 16"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 17"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 18"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 19"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 20"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 21"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 1.2mL Cryo Vial"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 1"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 2"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 3"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 4"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 5"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 6"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 7"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 8"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 9"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 10"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 11"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 12"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 5mL Cryo Vial 13"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Tube"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 500mL Bottle 1"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 500mL Bottle 2"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 500mL Bottle 3"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 500mL Bottle 4"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 1L Bottle"<>$SessionUUID],
				Object[Instrument,ControlledRateFreezer,"FreezeCells Test Retired Instrument"<>$SessionUUID],
				Object[Container,Rack,InsulatedCooler,"FreezeCells Test Discarded Insulated Rack"<>$SessionUUID],
				Model[Instrument,ControlledRateFreezer,"FreezeCells Test Instrument Model"<>$SessionUUID],
				Object[Protocol,FreezeCells,"FreezeCells Test Protocol"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 1"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 2"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 3"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 4"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 5"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 6"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 7"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 8"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 9"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 10"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 11"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 12"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 13"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 14"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 15"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 16"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 17"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 18"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 19"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 20"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 21"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 22"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 23"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 24"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 25"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 26"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 27"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 28"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 29"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 30"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 31"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 32"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 33"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 34"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 35"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Discarded Sample"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Solid Sample"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Incompatible Container Sample"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Incompatible Coolant"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Insufficient Coolant"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Insufficient Coolant 2"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Solid Coolant"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Low Melting Coolant"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for ExperimentFreezeCells"<>$SessionUUID]
			};
			
			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];
			
			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];
			
			(* Unset $CreatedObjects *)
			$CreatedObjects=.;
		]
	},
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];



(* ::Subsection::Closed:: *)
(*ExperimentFreezeCellsOptions*)


DefineTests[ExperimentFreezeCellsOptions,{
	
	Example[
		{Basic,"Return a table with the resolved options of a ExperimentFreezeCells call:"},
		ExperimentFreezeCellsOptions[
			{Object[Sample,"FreezeCells Test Sample 1 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6 Options"<>$SessionUUID]}
		],
		_Grid
	],
	
	Example[
		{Options,OutputFormat,"Indicates if the output is a list or a table:"},
		ExperimentFreezeCellsOptions[
			{Object[Sample,"FreezeCells Test Sample 1 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5 Options"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6 Options"<>$SessionUUID]},
			OutputFormat->List
		],
		{_Rule..}
	]
},
	
	SymbolSetUp:>{
		Module[{namedObjects,existsFilter},
			
			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			
			(* Test objects we will create *)
			namedObjects={
				Model[Sample,"FreezeCells Test Sample Options"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 1 Options"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 2 Options"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 3 Options"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 4 Options"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 5 Options"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 6 Options"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 1 Options"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 2 Options"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 3 Options"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 4 Options"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 5 Options"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 6 Options"<>$SessionUUID]
			};
			
			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];
			
			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];
			
			(* Upload the objects *)
			Upload[{
				<|
					Type->Model[Sample],
					Name->"FreezeCells Test Sample Options"<>$SessionUUID,
					Replace[Composition]->{{100 MassPercent,Link[Model[Cell,Mammalian,"HEK293"]]}},
					Replace[IncompatibleMaterials]->None,
					State->Liquid,
					DefaultStorageCondition->Link[Model[StorageCondition,"Cryogenic Storage"]],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 1 Options"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 2 Options"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 3 Options"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 4 Options"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 5 Options"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 6 Options"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>
			}];
			
			(* Make the samples *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Sample,"FreezeCells Test Sample Options"<>$SessionUUID],6],
				{
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 1 Options"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 2 Options"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 3 Options"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 4 Options"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 5 Options"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 6 Options"<>$SessionUUID]}
				},
				Name->{
					"FreezeCells Test Sample 1 Options"<>$SessionUUID,
					"FreezeCells Test Sample 2 Options"<>$SessionUUID,
					"FreezeCells Test Sample 3 Options"<>$SessionUUID,
					"FreezeCells Test Sample 4 Options"<>$SessionUUID,
					"FreezeCells Test Sample 5 Options"<>$SessionUUID,
					"FreezeCells Test Sample 6 Options"<>$SessionUUID
				},
				InitialAmount->ConstantArray[2 Milliliter,6],
				Status->Available
			];
		]
	},
	
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		
		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	},
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];




(* ::Subsection::Closed:: *)
(*ValidExperimentFreezeCellsQ*)


DefineTests[ValidExperimentFreezeCellsQ,{
	
	Example[
		{Basic,"Check if an ExperimentFreezeCells call is valid:"},
		ValidExperimentFreezeCellsQ[
			{Object[Sample,"FreezeCells Test Sample 1 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6 ValidQ"<>$SessionUUID]}
		],
		True
	],
	
	Example[
		{Options,OutputFormat,"Indicates whether the function returns a boolean or the test summaries:"},
		ValidExperimentFreezeCellsQ[
			{Object[Sample,"FreezeCells Test Sample 1 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5 ValidQ"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6 ValidQ"<>$SessionUUID]},
			OutputFormat->TestSummary
		],
		_EmeraldTestSummary
	]
},
	
	SymbolSetUp:>{
		Module[{namedObjects,existsFilter},
			
			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			
			(* Test objects we will create *)
			namedObjects={
				Model[Sample,"FreezeCells Test Sample ValidQ"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 1 ValidQ"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 2 ValidQ"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 3 ValidQ"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 4 ValidQ"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 5 ValidQ"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 6 ValidQ"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 1 ValidQ"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 2 ValidQ"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 3 ValidQ"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 4 ValidQ"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 5 ValidQ"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 6 ValidQ"<>$SessionUUID]
			};
			
			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];
			
			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];
			
			(* Upload the objects *)
			Upload[{
				<|
					Type->Model[Sample],
					Name->"FreezeCells Test Sample ValidQ"<>$SessionUUID,
					Replace[Composition]->{{100 MassPercent,Link[Model[Cell,Mammalian,"HEK293"]]}},
					Replace[IncompatibleMaterials]->None,
					State->Liquid,
					DefaultStorageCondition->Link[Model[StorageCondition,"Cryogenic Storage"]],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 1 ValidQ"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 2 ValidQ"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 3 ValidQ"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 4 ValidQ"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 5 ValidQ"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 6 ValidQ"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>
			}];
			
			(* Make the samples *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Sample,"FreezeCells Test Sample ValidQ"<>$SessionUUID],6],
				{
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 1 ValidQ"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 2 ValidQ"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 3 ValidQ"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 4 ValidQ"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 5 ValidQ"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 6 ValidQ"<>$SessionUUID]}
				},
				Name->{
					"FreezeCells Test Sample 1 ValidQ"<>$SessionUUID,
					"FreezeCells Test Sample 2 ValidQ"<>$SessionUUID,
					"FreezeCells Test Sample 3 ValidQ"<>$SessionUUID,
					"FreezeCells Test Sample 4 ValidQ"<>$SessionUUID,
					"FreezeCells Test Sample 5 ValidQ"<>$SessionUUID,
					"FreezeCells Test Sample 6 ValidQ"<>$SessionUUID
				},
				InitialAmount->ConstantArray[2 Milliliter,6],
				Status->Available
			];
		]
	},
	
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		
		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	},
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*freezeCellsPreviewGenerator*)


DefineTests[freezeCellsPreviewGenerator,{
	
	Example[
		{Basic,"Generate plots of how the temperature will decrease over time for each batch in an ExperimentFreezeCells call:"},
		freezeCellsPreviewGenerator[
			{
				FreezingMethods->{ControlledRateFreezer,InsulatedCooler,ControlledRateFreezer},
				FreezingProfiles->{
					{{20 Celsius,0 Minute},{-2 Celsius,24 Minute},{-2 Celsius,34 Minute},{-30 Celsius,62 Minute},{-30 Celsius,92 Minute},{-80 Celsius,159 Minute}},
					Null,
					Null
				},
				Durations->{Null,Null,1 Hour},
				ResidualTemperatures->{Null,Null,-50 Celsius},
				FreezingConditions->{Null,DeepFreezer,Null}
			}
		],
		{_Graphics..}
	]
},
	
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	),
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];



(* ::Subsection::Closed:: *)
(*ExperimentFreezeCellsPreview*)


DefineTests[ExperimentFreezeCellsPreview,{
	
	Example[
		{Basic,"Preview how the temperature will decrease over time for each batch in an ExperimentFreezeCells call:"},
		ExperimentFreezeCellsPreview[
			{Object[Sample,"FreezeCells Test Sample 1 Preview"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2 Preview"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 3 Preview"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4 Preview"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 5 Preview"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6 Preview"<>$SessionUUID]},
			Batches->{
				{Object[Sample,"FreezeCells Test Sample 1 Preview"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 2 Preview"<>$SessionUUID]},
				{Object[Sample,"FreezeCells Test Sample 3 Preview"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 4 Preview"<>$SessionUUID]},
				{Object[Sample,"FreezeCells Test Sample 5 Preview"<>$SessionUUID],Object[Sample,"FreezeCells Test Sample 6 Preview"<>$SessionUUID]}
			},
			FreezingMethods->{ControlledRateFreezer,InsulatedCooler,ControlledRateFreezer},
			Durations->{Null,Null,1 Hour},
			ResidualTemperatures->{Null,Null,-50 Celsius}
		],
		{_Graphics..}
	]
},
	
	SymbolSetUp:>{
		Module[{namedObjects,existsFilter},
			
			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			
			(* Test objects we will create *)
			namedObjects={
				Model[Sample,"FreezeCells Test Sample Preview"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 1 Preview"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 2 Preview"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 3 Preview"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 4 Preview"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 5 Preview"<>$SessionUUID],
				Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 6 Preview"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 1 Preview"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 2 Preview"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 3 Preview"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 4 Preview"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 5 Preview"<>$SessionUUID],
				Object[Sample,"FreezeCells Test Sample 6 Preview"<>$SessionUUID]
			};
			
			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];
			
			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];
			
			(* Upload the objects *)
			Upload[{
				<|
					Type->Model[Sample],
					Name->"FreezeCells Test Sample Preview"<>$SessionUUID,
					Replace[Composition]->{{100 MassPercent,Link[Model[Cell,Mammalian,"HEK293"]]}},
					Replace[IncompatibleMaterials]->None,
					State->Liquid,
					DefaultStorageCondition->Link[Model[StorageCondition,"Cryogenic Storage"]],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 1 Preview"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 2 Preview"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 3 Preview"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 4 Preview"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 5 Preview"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>,
				
				<|
					Type->Object[Container,Vessel],
					Name->"FreezeCells Test 2mL Cryo Vial 6 Preview"<>$SessionUUID,
					Model->Link[Model[Container,Vessel,"2mL Cryogenic Vial"],Objects],
					DeveloperObject->True
				|>
			}];
			
			(* Make the samples *)
			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Sample,"FreezeCells Test Sample Preview"<>$SessionUUID],6],
				{
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 1 Preview"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 2 Preview"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 3 Preview"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 4 Preview"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 5 Preview"<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"FreezeCells Test 2mL Cryo Vial 6 Preview"<>$SessionUUID]}
				},
				Name->{
					"FreezeCells Test Sample 1 Preview"<>$SessionUUID,
					"FreezeCells Test Sample 2 Preview"<>$SessionUUID,
					"FreezeCells Test Sample 3 Preview"<>$SessionUUID,
					"FreezeCells Test Sample 4 Preview"<>$SessionUUID,
					"FreezeCells Test Sample 5 Preview"<>$SessionUUID,
					"FreezeCells Test Sample 6 Preview"<>$SessionUUID
				},
				InitialAmount->ConstantArray[2 Milliliter,6],
				Status->Available
			];
		]
	},
	
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		
		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	},
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Section:: *)
(*End Private*)
