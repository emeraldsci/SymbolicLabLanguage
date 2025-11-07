(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(* ExperimentAdjustpH *)

DefineTests[
	ExperimentAdjustpH,
	{
		(*Positive cases and examples*)
		Example[{Basic,"Adjust the pH of a single sample:"},
			ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8],
			ObjectP[Object[Protocol,AdjustpH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Basic,"Adjust the pH of multiple sample(s):"},
			ExperimentAdjustpH[
				{Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],Object[Sample,"Large test water sample for ExperimentAdjustpH" <> $SessionUUID]},
				{8,5}
			],
			ObjectP[Object[Protocol,AdjustpH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Basic,"Adjust the pH of multiple samples to a same pH:"},
			ExperimentAdjustpH[
				{Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Large test water sample for ExperimentAdjustpH" <> $SessionUUID]}
				,8],
			ObjectP[Object[Protocol,AdjustpH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Basic,"Input a container:"},
			ExperimentAdjustpH[Object[Container,Vessel,"Test container 2 for ExperimentAdjustpH" <> $SessionUUID],5.5,Aliquot->True,AliquotAmount->25Milliliter],
			ObjectP[Object[Protocol,AdjustpH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Basic,"Input a position of a container:"},
			ExperimentAdjustpH[{"A1",Object[Container, Vessel, "Test container 2 for ExperimentAdjustpH" <> $SessionUUID]},5.5,Aliquot->True,AliquotAmount->25Milliliter],
			ObjectP[Object[Protocol,AdjustpH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Additional,"Input a mixture of inputs:"},
			ExperimentAdjustpH[
				{Object[Sample,"Large test water sample for ExperimentAdjustpH" <> $SessionUUID]},
				{5.5},
				Aliquot->True,
				AliquotAmount->25Milliliter,
				AliquotContainer -> {Model[Container, Vessel, "50mL Tube"]}
			],
			ObjectP[Object[Protocol,AdjustpH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Additional,"Output an updated simulation packet when Output->Simulation:"},
			output=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID], 8,
				FixedAdditions->{{{10 Microliter,Model[Sample, StockSolution, "1.85 M NaOH"]}}},
				ModelOut->Model[Sample, StockSolution, "id:J8AY5jwzPdaB"],
				SampleLabel->"test adjph water sample 1",
				TitrationMethod -> Manual,
				Output->Simulation
			];
				{
					Lookup[FirstCase[output[[1]][Packets],KeyValuePattern[Object->ObjectP[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID]]]], {Volume, pH}],
					output[[1]][Labels]
				},
			{{EqualP[35010Microliter],8}, {"test adjph water sample 1"->ObjectP[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID]]}},
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Basic,"Output a Script notebook with a set of primitives:"},
			Experiment[{AdjustpH[Sample->Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],NominalpH->8, TitrationMethod -> Manual,SampleLabel->"Test Sample"]}],
			ObjectP[{Object[Protocol,ManualSamplePreparation], Object[Notebook, Script]}],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],



		(*Additional Unit Tests*)

		Example[{Additional,"Adjust the pH of a single sample when the Object[Sample] does not have a Model:"},
			ExperimentAdjustpH[Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentAdjustpH" <> $SessionUUID],8, SecondaryWashSolution -> Null],
			ObjectP[Object[Protocol,AdjustpH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Additional,"Specify the length of time that the pH should be read for each sample. Sensornet performs pH readings in 1 second heartbeats so the number of data points gathered will be the number of seconds specifed as this option. This option only applies to samples measured via an Immersion probe since droplet probes can only perform a single point reading:"},
			ExperimentAdjustpH[
				Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				AcquisitionTime->10 Second,
				TitrationMethod -> Manual
			],
			ObjectP[Object[Protocol,AdjustpH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Additional,"Adjust the pH of a very large sample when Aliquot->True:"},
			ExperimentAdjustpH[Object[Sample, "Extra large test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Aliquot->True],
			ObjectP[Object[Protocol,AdjustpH]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000
		],
		Example[{Additional,"Measure 1L of a solution in a 1L bottle:"},
			protocol=ExperimentAdjustpH[Object[Sample, "Stock test pH 10 calibration solution for ExperimentAdjustpH" <> $SessionUUID],8];
			Download[protocol,{pHMeters, Probes}],
			{
				List[ObjectP[]],
				List[ObjectP[]|Null]
			},
			Variables:>{protocol},
			TimeConstraint->1000
		],
		Example[{Additional,"To adjust pH for sample with volume smaller than 40% of the container max volume, we need to aliquot:"},
			options = ExperimentAdjustpH[
				Object[Sample,"Large test water sample for ExperimentAdjustpH" <> $SessionUUID],
				8,
				TitrationMethod -> Manual,
				Output -> Options
			];
			Lookup[options,Aliquot],
			True,
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->1000,
			Variables:>{options}
		],


		(*Experiment options unit test*)
		Example[{Options,HistoricalData,"Resolve FixedAdditions based on specified or resolved HistoricalData--ModelOut not specified:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,ParentProtocol->Object[Protocol,StockSolution,"AdjustpH Parent "<>$SessionUUID],Output->Options];
			Lookup[options, {HistoricalData,FixedAdditions}],
			{ObjectP[Object[Data,pHAdjustment]],{_List..}},
			Variables :> {options},
			TimeConstraint->1000
		],
		Test["Does not use historical data if this is occurring outside of a stock solution:",
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Output->Options];
			Lookup[options, {HistoricalData,FixedAdditions}],
			{Null,None},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FixedAdditions,"Resolve the fixed additions based on existing Object[Data,pHAdjustment]--ModelOut specified:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				ParentProtocol->Object[Protocol,StockSolution,"AdjustpH Parent "<>$SessionUUID],
				ModelOut->Model[Sample, StockSolution, "id:1ZA60vLrOJl8"],
				Output->Options
			];
			Lookup[options, {HistoricalData,FixedAdditions}],
			{ObjectP[Object[Data,pHAdjustment]],{_List..}}, (*the resolved option somehow strips the first level of list but seems ok.*)
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,ModelOut,"Resolve pHing limit options based on ModelOut fields:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				ModelOut->Model[Sample,StockSolution,"Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
				Output->Options
			];
			Lookup[options, {MinpH,MaxpH,MaxNumberOfCycles,MaxAcidAmountPerCycle,MaxBaseAmountPerCycle,MaxAdditionVolume}],
			{7.80,8.20,15, 0.035Milliliter,0.035Milliliter,0.0035Liter},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,NonBuffered,"Resolve NonBuffered based on HistoricalData, and resolve, MaxNumbersOfCycles,MaxAcidAmountsPerCycle,MaxBaseAmountsPerCycle accordingly:"},
			protocol=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				ParentProtocol->Object[Protocol,StockSolution,"AdjustpH Parent "<>$SessionUUID],
				HistoricalData->Object[Data,pHAdjustment,"Test data object 3 for ExperimentAdjustpH" <> $SessionUUID]
			];
			Download[protocol, {NonBuffered,MaxNumbersOfCycles,MaxAcidAmountsPerCycle,MaxBaseAmountsPerCycle}],
			{{True},{20},{RangeP[388 Microliter, 398 Microliter]},{RangeP[388 Microliter, 398 Microliter]}},
			Variables :> {protocol},
			TimeConstraint->1000
		],
		Example[{Options,FixedAdditions,"Transfer a specified FixedAdditions to resolved options:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,FixedAdditions->{{{0.5Milliliter,Model[Sample, StockSolution, "id:BYDOjv1VA86X"]}}},Output->Options];
			Lookup[options, FixedAdditions],
			{{{0.5Milliliter,ObjectP[Model[Sample, StockSolution, "id:BYDOjv1VA86X"]]}}},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHMeter,"Specify a specific pHMeter for measurement and resolve the probe:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHMeter->Model[Instrument, pHMeter, "SevenExcellence (for pH)"], TitrationMethod -> Manual,Output->Options];
			Lookup[options, {Probe,pHMeter}],
			{
				ObjectP[Model[Part, pHProbe]],
				ObjectP[Model[Instrument, pHMeter, "SevenExcellence (for pH)"]]
			},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,Probe,"Specify a probe on the pHMeter for measurement and resolve the pHMeter:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Probe->Model[Part, pHProbe, "InLab Reach Pro-225"], TitrationMethod -> Manual,Output->Options];
			Lookup[options, {Probe,pHMeter}],
			{
				ObjectP[Model[Part, pHProbe, "InLab Reach Pro-225"]],
				ObjectP[{Model[Instrument, pHMeter, "SevenExcellence (for pH)"], Model[Instrument, pHMeter, "Mettler Toledo InLab Reach 225"]}]
			},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,ProbeType,"Specify a ProbeType and resolve the pHMeter and Probe:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,ProbeType->Surface,Output->Options];
			Lookup[options, {ProbeType,Probe,pHMeter}],
			{
				Surface,
				ObjectP[Model[Part, pHProbe]],
				ObjectP[Model[Instrument, pHMeter]]
			},
			Variables :> {options},
			TimeConstraint->1000
		],

		Example[{Options,TitrationMethod,"Specify TitrationMethod and resolve the corresponding options:"},
			options=ExperimentAdjustpH[Object[Sample, "Test sample in a beaker for ExperimentAdjustpH" <> $SessionUUID],8,TitrationMethod->Robotic,Output->Options];
			Lookup[options, {pHMeter,ProbeType, Probe, pHAliquot, Titrate, pHMixType, pHMixUntilDissolved, pHMixInstrument, MaxNumberOfCycles, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle}],
			{
				ObjectP[Model[Instrument, pHMeter, "id:R8e1PjeAn4B4"]],
				Immersion,
				ObjectP[Model[Part, pHProbe]], (* we allow both probe types to be used *)
				False,
				True,
				Stir,
				False,
				ObjectP[Model[Instrument, OverheadStirrer]],
				50,
				EqualP[0.9 Milliliter],
				EqualP[0.9 Milliliter]
			},
			Variables :> {options},
			TimeConstraint->1000
		],

		Example[{Options,TitrationInstrument,"If we have multiple samples to do robotic titration and at least one of them has TitrationInstrument specified, the rest robotic titration will use the same pHTitrator:"},
			protocol = ExperimentAdjustpH[
				{
					Object[Sample, "Test sample in a beaker for ExperimentAdjustpH" <> $SessionUUID],
					Object[Sample, "Test sample 28 in Volumetric Flask ExperimentAdjustpH" <> $SessionUUID]
				},
				{2, 5},
				TitrationMethod -> Robotic,
				TitrationInstrument -> {Automatic, Object[Instrument, pHTitrator, "TitrationInstrument for ExperimentAdjustpH robotic titration testing " <> $SessionUUID]}];
			Download[protocol, TitrationInstruments],
			{
				LinkP[Object[Instrument, pHTitrator, "TitrationInstrument for ExperimentAdjustpH robotic titration testing " <> $SessionUUID]],
				LinkP[Object[Instrument, pHTitrator, "TitrationInstrument for ExperimentAdjustpH robotic titration testing " <> $SessionUUID]]
			},
			Variables :> {protocol},
			TimeConstraint->1000
		],

		Example[{Options, MaxNumberOfCycles, "If MaxAcidAmountPerCycle or MaxBaseAmountPerCycle is specified, the resolution of MaxNumberOfCycles will be 10 even if TitrationMethod is Robotic:"},
			options = ExperimentAdjustpH[Object[Sample, "Test sample in a beaker for ExperimentAdjustpH" <> $SessionUUID], 8, MaxAcidAmountPerCycle -> 1 Milliliter, TitrationMethod -> Robotic, Output -> Options];
			Lookup[options, {MaxNumberOfCycles, MaxAcidAmountPerCycle, MaxBaseAmountPerCycle}],
			{10, EqualP[1 Milliliter], EqualP[4.5 Milliliter]},
			Variables :> {options},
			TimeConstraint -> 1000
		],
		(* Commenting out TemperatureCorrection as the option needs reworked. *)
		Example[{Options,AcquisitionTime,"Adjust the pH of a single liquid sample with a custom acquisition time (time over which to read pH):"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,AcquisitionTime->1 Minute, TitrationMethod -> Manual,Output->Options];
			Lookup[options, {AcquisitionTime,pHMeter, Probe(*, TemperatureCorrection*)}],
			{
				1 Minute,
				Except[ObjectP[Model[Instrument, pHMeter, "SevenExcellence (for pH)"]]],
				ObjectP[Model[Part, pHProbe]](*,
				Null*)
			},
			Variables :> {options},
			TimeConstraint->1000
		],
		(* Commenting out TemperatureCorrection as the option needs reworked. *)
		(*{Options,TemperatureCorrection,"Adjust the pH of a single sample with correction for the sample temperature:"}*)
		Test["Adjust the pH of a single sample with correction for the sample temperature:",
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,TemperatureCorrection->Linear, TitrationMethod -> Manual,Output->Options];
			Lookup[options, {AcquisitionTime, (*TemperatureCorrection,*) pHMeter, Probe}],
			{
				Null,
				(* Hidden options are not returned for Output -> Options. *)
				(*Linear,*)
				ObjectP[Model[Instrument, pHMeter, "SevenExcellence (for pH)"]],
				ObjectP[]
			},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHAliquot,"Returns the specified pHAliquot and resolve pHAliquotVolume:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHAliquot->True,Output->Options];
			Lookup[options,pHAliquot],
			True,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHAliquotVolume,"Returns the specified pHAliquotVolume and resolve pHAliquot:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHAliquotVolume->25Milliliter,Output->Options];
			Lookup[options,{pHAliquot,pHAliquotVolume}],
			{True,VolumeP},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,RecoupSample,"Returns the specified RecoupSample and resolve pHAliquot:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,RecoupSample->True,Output->Options];
			Lookup[options,{pHAliquot,RecoupSample}],
			{True,True},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,Titrate,"Returns the specified Titrate and resolve TitratingAcid and TitratingBase:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Titrate->False,Output->Options];
			Lookup[options,{Titrate,TitratingAcid,TitratingBase}],
			{False,Null,Null},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,TitratingAcid,"Returns the specified TitratingAcid and resolve Titrate and TitratingBase:"},
			options=ExperimentAdjustpH[
				Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				TitratingAcid->Object[Sample,"Test 2 M HCl sample for ExperimentAdjustpH" <> $SessionUUID],Output->Options
			];
			Lookup[options,{Titrate,TitratingAcid,TitratingBase}],
			{True,ObjectP[Object[Sample,"Test 2 M HCl sample for ExperimentAdjustpH" <> $SessionUUID]],ObjectP[]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,TitratingBase,"Returns the specified TitratingBase and resolve Titrate and TitratingAcid:"},
			options=ExperimentAdjustpH[
				Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				TitratingBase->Object[Sample,"Test 5 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID],Output->Options
			];
			Lookup[options,{Titrate,TitratingAcid,TitratingBase}],
			{True,ObjectP[],ObjectP[Object[Sample,"Test 5 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHMixType,"Resolve options for mixing during pH adjustment-- Invert for closed small container:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,NumberOfReplicates->3,Output->Options];
			Lookup[options, {pHMixType,NumberOfpHMixes}],
			{Invert,NumberP},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHMixType,"Resolve options for mixing during pH adjustment-- Stir for large container:"},
			options=ExperimentAdjustpH[Object[Sample,"Test sample 29 in 10L Carboy with enough liquid for ExperimentAdjustpH" <> $SessionUUID],8,Output->Options];
			Lookup[options, {pHMixType,pHMixInstrument,pHMixTime,pHMixRate}],
			{Stir,ObjectP[Model[Instrument,OverheadStirrer]],TimeP,GreaterP[0*RPM]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHMixInstrument,"Resolve options for mixing during pH adjustment-- Stir for open container and resolve to an overheadStirrer:"},
			options=ExperimentAdjustpH[Object[Sample,"Test sample in a beaker for ExperimentAdjustpH" <> $SessionUUID],8,
				NumberOfReplicates->3,
				Output->Options
			];
			Lookup[options, {pHMixType,pHMixInstrument,pHMixTime,pHMixRate}],
			{Stir,ObjectP[Model[Instrument,OverheadStirrer]],TimeP,GreaterP[0*RPM]},
			Variables :> {options},
			TimeConstraint->1000
		],

		Example[{Options,pHMixTime,"Resolve to an appropriate mix time based on pHMixType and the state of sample to mix:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHMixType->Roll,Output->Options];
			Lookup[options, {pHMixType,pHMixInstrument,pHMixTime,pHMixRate}],
			{Roll,ObjectP[Model[Instrument,Roller]],TimeP,GreaterP[0*RPM]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHMixUntilDissolved,"Resolve options for mixing during pH adjustment-- Mix until dissolved for solid additions:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, TitrationMethod-> Manual,
				FixedAdditions->{{1 Gram, Model[Sample, "id:XnlV5jmbZLLZ"]}},
				Output->Options
			];
			Lookup[options, {pHMixType,pHMixUntilDissolved,pHMixInstrument,pHMixTime,MaxpHMixTime,pHMixRate}],
			{Roll,True,ObjectP[Model[Instrument,Roller]],TimeP,TimeP,GreaterP[0*RPM]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxpHMixTime,"Resolve options for MaxpHMixTime based on the state of the sample to mix:"},
			options=Quiet[ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, TitrationMethod -> Manual, FixedAdditions->{{1 Milligram,Object[Sample,"Test sample 27 for solid NaOH ExperimentAdjustpH" <> $SessionUUID]}},
				Output->Options
			],Warning::SampleMustBeMoved];
			Lookup[options, {pHMixType,pHMixUntilDissolved,pHMixInstrument,pHMixTime,MaxpHMixTime,pHMixRate}],
			{Roll,True,ObjectP[Model[Instrument,Roller]],TimeP,TimeP,GreaterP[0*RPM]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHMixDutyCycle,"Resolve to an appropriate homogenizing duty cycle when pHMixType is Homogenize:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHMixType->Homogenize,Output->Options];
			Lookup[options, {pHMixType,pHMixInstrument,pHMixTime,pHMixRate,pHMixDutyCycle}],
			{Homogenize,ObjectP[Model[Instrument,Homogenizer]],GreaterP[0Second],Null,Null},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHMixRate,"Resolve to an appropriate type of impeller when pHMixType is compatible:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHMixType->Shake,Output->Options];
			Lookup[options, {pHMixType,pHMixInstrument,pHMixTime,pHMixRate,pHMixDutyCycle}],
			{Shake,ObjectP[Model[Instrument,Shaker]],GreaterP[0Second],GreaterP[0*RPM],NullP},
			Variables :> {options},
			TimeConstraint->1000
		],



		Example[{Options,NumberOfpHMixes,"Resolve to an appropriate number of mixes when MixType is Pipette or Invert:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHMixType->Pipette,Output->Options];
			Lookup[options, {pHMixType,pHMixTime,pHMixRate,NumberOfpHMixes}],
			{Pipette,Null,Null,GreaterP[0]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxNumberOfpHMixes,"Resolve to an appropriate number of mixes when MixType is Pipette or Invert:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHMixType->Invert,Output->Options];
			Lookup[options, {pHMixType,pHMixTime,pHMixRate,NumberOfpHMixes}],
			{Invert,Null,Null,GreaterP[0]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHMixVolume,"Resolve to an appropriate pHMixVolume when MixType is Pipette:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHMixType->Pipette,Output->Options];
			Lookup[options, pHMixVolume],
			GreaterP[0Liter],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHMixTemperature,"Returns the specified pHMixTemperature:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHMixTemperature->37Celsius,Output->Options];
			Lookup[options, pHMixTemperature],
			TemperatureP,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxpHMixTemperature,"Returns specified MaxpHMixTemperature:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,MaxpHMixTemperature->50Celsius,Output->Options];
			Lookup[options, MaxpHMixTemperature],
			TemperatureP,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,pHHomogenizingAmplitude,"Returned specified pHHomogenizingAmplitude:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,pHHomogenizingAmplitude->20Percent,Output->Options];
			Lookup[options, pHHomogenizingAmplitude],
			PercentP,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MinpH,"Returns the specified MinpH:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,MinpH->7.8,Output->Options];
			Lookup[options, MinpH],
			7.8,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxpH,"Returns the specified MaxpH:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,MaxpH->8.2,Output->Options];
			Lookup[options, MaxpH],
			8.2,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],

		Example[{Options,MaxAdditionVolume,"Resolve the maximum volume that can be added to the SamplesIn based on the samplesIn volume, container MaxVolume and NumberOfReplication:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Output->Options];
			Lookup[options, MaxAdditionVolume],
			VolumeP,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxAdditionVolume,"Resolve the maximum volume that can be added to the SamplesIn based on the samplesIn volume, container MaxVolume and NumberOfReplicates:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,NumberOfReplicates->3,Output->Options];
			Lookup[options, MaxAdditionVolume],
			VolumeP,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxNumberOfCycles,"Resolve the maximum volume that can be added to the SamplesIn based on the samplesIn volume, container MaxVolume and NumberOfReplicates:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,MaxNumberOfCycles->15,Output->Options];
			Lookup[options, MaxNumberOfCycles],
			15,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxAcidAmountPerCycle,"Automtaically resolve MaxAcidAmountPerCycle and MaxBaseAmountPerCycle:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Output->Options];
			Lookup[options, {MaxAcidAmountPerCycle,MaxBaseAmountPerCycle}],
			{VolumeP,VolumeP},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxBaseAmountPerCycle,"Return specified MaxAcidAmountPerCycle and MaxBaseAmountPerCycle:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,MaxAcidAmountPerCycle->1Milliliter,MaxBaseAmountPerCycle->1Milliliter,Output->Options];
			Lookup[options, {MaxAcidAmountPerCycle,MaxBaseAmountPerCycle}],
			{1Milliliter,1Milliliter},
			Variables :> {options},
			TimeConstraint->1000
		],

		Example[{Options,NumberOfReplicates,"Adjust the pH of a single liquid sample by specifying a NumberOfReplicates, in this case, samples are aliquoted into NumberOfReplicates containers:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,NumberOfReplicates->2,Output->Options];
			Lookup[options, {NumberOfReplicates,Aliquot,AliquotAmount, AliquotContainer,ContainerOut}],
			{2,True,LessP[35Milliliter],{{1,ObjectP[]},{2,ObjectP[]}},ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,ContainerOut,"Returns specified ContainerOut:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,ContainerOut->Model[Container, Vessel, "id:jLq9jXvA8ewR"],Output->Options];
			Lookup[options, ContainerOut],
			ObjectP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,ContainerOut,"Returns sample container if no Aliquot is needed:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Aliquot->False,Output->Options];
			Lookup[options, ContainerOut],
			ObjectP[Object[Container, Vessel, "Test container 2 for ExperimentAdjustpH" <> $SessionUUID]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,ContainerOut,"Returns ContainerOut as PreferredContainer of the largest possible total volume if Aliquot is required:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,NumberOfReplicates->3,MaxAdditionVolume->10Milliliter,Output->Options];
			Lookup[options, ContainerOut],
			ObjectP[PreferredContainer[65Milliliter]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,SamplesOutStorageCondition, "Specify SamplesOutStorageCondition:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, SamplesOutStorageCondition->Refrigerator, Output->Options];
			Lookup[options, SamplesOutStorageCondition],
			Refrigerator,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxpHSlope, "Specify MaxpHSlope and MinpHSlope:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, MaxpHSlope-> 102*Percent, MinpHSlope -> 98*Percent, Output->Options];
			Lookup[options, {MinpHSlope, MaxpHSlope}],
			{EqualP[98*Percent], EqualP[102*Percent]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MaxpHOffset, "Specify MaxpHOffset and MinpHOffset:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, MaxpHOffset-> 50*Milli*Volt, MinpHOffset -> -50*Milli*Volt, Output->Options];
			Lookup[options, {MinpHOffset, MaxpHOffset}],
			{EqualP[-50*Milli*Volt], EqualP[50*Milli*Volt]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MinpHSlope, "Specify MaxpHSlope and MinpHSlope:"},
			protocol = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, MaxpHSlope-> 102*Percent, MinpHSlope -> 98*Percent];
			Download[protocol, {MinpHSlope, MaxpHSlope}],
			{EqualP[98*Percent], EqualP[102*Percent]},
			Variables :> {protocol},
			TimeConstraint->1000
		],
		Example[{Options,MinpHOffset, "Specify MaxpHOffset and MinpHOffset:"},
			protocol = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, MaxpHOffset-> 50*Milli*Volt, MinpHOffset -> -50*Milli*Volt];
			Download[protocol, {MinpHOffset, MaxpHOffset}],
			{EqualP[-50*Milli*Volt], EqualP[50*Milli*Volt]},
			Variables :> {protocol},
			TimeConstraint->1000
		],
		Example[{Options,WashSolution,"Adjust the pH of a single liquid sample while specifying a wash solution to wash the pH probe with:"},
			protocol=ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID], 8,
				WashSolution->Model[Sample,StockSolution,"Red Food Dye Test Solution"]
			];
			Lookup[Download[protocol,BatchingParameters], WashSolution],
			{ObjectP[Model[Sample,StockSolution,"Red Food Dye Test Solution"]]},
			Variables:>{protocol}
		],
		Example[{Options,SecondaryWashSolution,"Adjust the pH of a single liquid sample while specifying a secondary wash solution to wash the pH probe with:"},
			protocol=ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID], 8,
				SecondaryWashSolution->Model[Sample,"Milli-Q water"]
			];
			Lookup[Download[protocol,BatchingParameters], SecondaryWashSolution],
			{ObjectP[Model[Sample,"Milli-Q water"]]},
			Variables:>{protocol}
		],
		Example[{Options,SecondaryWashSolution,"Adjust the pH of a single liquid sample while specifying no secondary wash solution to wash the pH probe with:"},
			protocol=ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID], 8,
				SecondaryWashSolution->Null
			];
			Lookup[Download[protocol,BatchingParameters], SecondaryWashSolution],
			{Null},
			Variables :> {protocol}
		],
		(*Shared options*)
		Example[{Options,Name,"Adjust the pH of a single liquid sample with a Name specified for the protocol:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Name->"Measure pH with 1 min acquisition.",AcquisitionTime->1 Minute,TitrationMethod -> Manual,Output->Options];
			Lookup[options,Name],
			"Measure pH with 1 min acquisition.",
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,Template,"A template protocol whose methodology should be reproduced in running this experiment. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this Experiment function:"},
			options=ExperimentAdjustpH[
				Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				Template->Object[Protocol,AdjustpH, "Test Template Protocol for ExperimentAdjustpH" <> $SessionUUID],
				TitrationMethod -> Manual,
				Probe->Model[Part,pHProbe,"InLab Reach Pro-225"],
				Output->Options
			];
			Lookup[options,Probe],
			ObjectP[Model[Part,pHProbe,"InLab Reach Pro-225"]],
			Variables:>{options},
			TimeConstraint->1000
		],

		(*post processing options*)
		Example[{Options,ImageSample,"Adjust the pH of a single liquid sample and do not take an image afterwards:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentAdjustpH[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				{8, 8},
				PreparedModelContainer -> Model[Container, Vessel, "2mL Tube"],
				PreparedModelAmount -> 1 Milliliter,
				SecondaryWashSolution -> Null,
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
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for pH measurement:"},
			packet=First@ExperimentAdjustpH[
				{"WaterSample Container 1", "WaterSample Container 2", "WaterSample Container 3","WaterSample Container 4"},
				{8,8,8,8},
				PreparatoryUnitOperations->{
					LabelContainer[Label->"WaterSample Container 1",Container->Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label->"WaterSample Container 2",Container->Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label->"WaterSample Container 3",Container->Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label->"WaterSample Container 4",Container->Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source->Model[Sample, "Milli-Q water"],Amount->1 Milliliter, Destination->"WaterSample Container 1"],
					Transfer[Source->Model[Sample, "Milli-Q water"],Amount->1 Milliliter, Destination->"WaterSample Container 2"],
					Transfer[Source->Model[Sample, "Milli-Q water"],Amount->1 Milliliter, Destination->"WaterSample Container 3"],
					Transfer[Source->Model[Sample, "Milli-Q water"],Amount->1 Milliliter,Destination->"WaterSample Container 4"]
				},
				ImageSample->False, MeasureVolume->False, Upload->False, SecondaryWashSolution -> Null
			];
			Length[Lookup[packet,Replace[SamplesIn]]],
			4,
			Variables :> {packet},
			TimeConstraint->1000
		],

		(*incubate options*)
		Example[{Options,Incubate,"Adjust the pH of a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,IncubationTime,"Adjust the pH of a single liquid sample with Incubation before measurement for 10 minutes:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Incubate->True,IncubationTime->10 Minute,Output->Options];
			Lookup[options,IncubationTime],
			10 Minute,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,MaxIncubationTime,"Adjust the pH of a single liquid sample with MaxIncubation before measurement for 1 hour:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Incubate->True,MaxIncubationTime->1 Hour,Output->Options];
			Lookup[options,MaxIncubationTime],
			1 Hour,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,IncubationTemperature,"Adjust the pH of a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Incubate->True,IncubationTime->10 Minute,IncubationTemperature->30 Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			30 Celsius,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,IncubationInstrument,"Adjust the pH of a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Incubate->True,IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,IncubateAliquot->1 Milliliter,IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],TitrationMethod -> Manual, Output->Options];
			Lookup[options,IncubateAliquot],
			1 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,IncubateAliquot->1 Milliliter,IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],TitrationMethod -> Manual, Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options},
			TimeConstraint->1000
		],

		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Mix->True,MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,MixUntilDissolved->True,MixType->Vortex,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,AnnealingTime->40 Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options},
			TimeConstraint->1000
		],

		(*centrifuge options*)
		Example[{Options,Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, Centrifuge->True, Output->Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, CentrifugeInstrument->Model[Instrument, Centrifuge, "Avanti J-15R"], Output->Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, CentrifugeIntensity->1000*RPM, Output->Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, CentrifugeTime->5*Minute, Output->Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, CentrifugeTemperature->10*Celsius, Output->Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, CentrifugeAliquot->10*Milliliter,CentrifugeAliquotContainer->Model[Container, Vessel, "50mL Tube"], TitrationMethod -> Manual, Output->Options];
			Lookup[options, CentrifugeAliquot],
			10*Milliliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, CentrifugeAliquot->10*Milliliter,CentrifugeAliquotContainer->Model[Container, Vessel, "50mL Tube"], TitrationMethod -> Manual, Output->Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options},
			TimeConstraint->1000
		],
		(* filter options *)
		Example[{Options,Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, Filtration->True, Output->Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FiltrationType->Syringe, Output->Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FilterInstrument->Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output->Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, Filter->Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"], Output->Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FilterMaterial->PES, Output->Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,PrefilterMaterial->GxF,FilterMaterial->PTFE, Output->Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FilterPoreSize->0.22*Micrometer, Output->Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, PrefilterPoreSize->1.*Micrometer, FilterMaterial->PTFE, Output->Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FiltrationType->Syringe, FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"], Output->Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentAdjustpH[Object[Sample,"Large test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FiltrationType->PeristalticPump, FilterHousing->Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output->Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, FilterAliquot -> 25 Milliliter, Output->Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,FiltrationType->PeristalticPump, FilterTime->20*Minute, Output->Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FilterAliquot->25 Milliliter,FiltrationType->Centrifuge, FilterTemperature->22*Celsius, Output->Options];
			Lookup[options, FilterTemperature],
			22*Celsius,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		], (* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options,FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FilterSterile->True, Output->Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			TimeConstraint->1000
		],*)
		Example[{Options,FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FilterAliquot->10*Milliliter, Output->Options];
			Lookup[options, FilterAliquot],
			10*Milliliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FilterAliquotContainer->Model[Container, Vessel, "50mL Tube"], Output->Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FilterContainerOut->Model[Container, Vessel, "50mL Tube"], Output->Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options},
			TimeConstraint->1000
		],

		(*Aliquot options*)
		Example[{Options,Aliquot,"Adjust the pH of a single liquid sample by first aliquotting the sample:"},
			options=ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,Aliquot->True,Output->Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, AliquotAmount->15*Milliliter,AliquotContainer->Model[Container, Vessel, "50mL Tube"], Output->Options];
			Lookup[options, AliquotAmount],
			15*Milliliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, AssayVolume->45*Milliliter, TitrationMethod -> Manual, Output->Options];
			Lookup[options, AssayVolume],
			45*Milliliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, TargetConcentration->5*Micromolar, Output->Options];
			Lookup[options, TargetConcentration],
			5*Micromolar,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, TargetConcentration->5 Micromolar, TargetConcentrationAnalyte->Model[Molecule, "Uracil"], Output->Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Uracil"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, ConcentratedBuffer->Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer->Model[Container, Vessel, "50mL Tube"], Output->Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, BufferDilutionFactor->10, ConcentratedBuffer->Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer->Model[Container, Vessel, "50mL Tube"], Output->Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, BufferDiluent->Model[Sample, "Milli-Q water"], BufferDilutionFactor->10, ConcentratedBuffer->Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"], Output->Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, AssayBuffer->Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->20*Milliliter, AliquotContainer->Model[Container, Vessel, "50mL Tube"], Output->Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, AliquotSampleStorageCondition->Refrigerator, Output->Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, ConsolidateAliquots->True, Output->Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, Aliquot->True, AliquotPreparation->Manual, Output->Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, AliquotContainer->Model[Container,Vessel,"50mL Tube"], Output->Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}},
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, IncubateAliquotDestinationWell->"A1", Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, CentrifugeAliquotDestinationWell->"A1", Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, FilterAliquotDestinationWell->"A1", Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,DestinationWell, "Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8, DestinationWell->"A1", Output->Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options},
			TimeConstraint->1000
		],

		(* - Input errors and warnings - *)

		Example[{Messages, "ObjectDoesNotExist", "Throw an error and return early if an input object doesn't exist:"},
			ExperimentAdjustpH[Object[Sample, "Nonexistent sample"], 2],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentAdjustpH[Object[Container, Vessel, "Nonexistent container"],5],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentAdjustpH[Object[Sample, "id:12345678"],7],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentAdjustpH[Object[Container, Vessel, "id:12345678"],6],
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
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentAdjustpH[sampleID, 2, Simulation -> simulationToPassIn, Output -> Options]
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
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentAdjustpH[containerID, 9, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		(*AdjustpH specific errors*)
		Example[{Messages,"FixedAdditionsConflict","Return an error for HistoricalData and FixedAdditions that do not agree:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				HistoricalData->Object[Data,pHAdjustment,"Test data object 1 for ExperimentAdjustpH" <> $SessionUUID],
				FixedAdditions->{{{2Milliliter,Model[Sample, StockSolution, "2 M HCl"]}}}
			],
			$Failed,
			Messages:>{
				Error::FixedAdditionsConflict,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"NoAdditions","Return an error if specifying both no FixedAdditions and Titrate:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				FixedAdditions->None,
				Titrate->False,
				TitratingAcid->Null,
				TitratingBase->Null
			],
			$Failed,
			Messages:>{
				Error::NoAdditions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidTitrateCombo","Return an error If Titrate switch conflicting with specified TitratingAcid and TitratingBase:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				Titrate->True,
				TitratingAcid->Null
			],
			$Failed,
			Messages:>{
				Error::InvalidTitrateCombo,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidTitrateCombo","Return an error If Titrate switch conflicting with specified TitratingAcid and TitratingBase:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				Titrate->False,
				TitratingBase->Model[Sample, StockSolution, "5.0 M NaOH"]
			],
			$Failed,
			Messages:>{
				Error::InvalidTitrateCombo,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"OverheadMixingRequired","Return an error if MixWhileTitrating is True but pHMixType is not Stir:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				MixWhileTitrating->True,
				pHMixType->Invert
			],
			$Failed,
			Messages:>{
				Error::OverheadMixingRequired,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"MaxVolumeExceeded","Return an error for if MaxAdditionVolume exceeds the volume still available in the container:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				MaxAdditionVolume->20Milliliter,
				pHMixType -> Roll
			],
			(* mix type stir will give other message *)
			$Failed,
			Messages:>{
				Error::MaxVolumeExceeded,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingpHRange","Return an error for if specified MinpH is not smaller than NominalpH, or MaxpH is not larger than NominalpH:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				MinpH->8.2,
				MaxpH->7.8
			],
			$Failed,
			Messages:>{
				Error::ConflictingpHRange,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Test["Allows either MinpH or MaxpH to be the same as NominalpH:",
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				MinpH->8,
				MaxpH->8.2
			],
			ObjectP[Object[Protocol,AdjustpH]],
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingTitratingAcidAndAmount","Return an error for TitratingAcids and MaxAcidAmountPerCycle that do not agree:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				TitratingAcid->Model[Sample, StockSolution, "2 M HCl"],
				MaxAcidAmountPerCycle->Null
			],
			$Failed,
			Messages:>{
				Error::InvalidTitrateCombo,
				Error::ConflictingTitratingAcidAndAmount,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingTitratingBaseAndAmount","Return an error for TitragingBases and MaxBaseAmountPerCycle that do not agree:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				TitratingBase->Model[Sample, "id:XnlV5jmbZLLZ"],
				MaxBaseAmountPerCycle->1Milliliter
			],
			$Failed,
			Messages:>{
				Error::ConflictingTitratingBaseAndAmount,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingTitrationMethod","Return an error for TitrationMethod and incompatible options:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				TitrationMethod -> Robotic,
				pHMixType -> Roll
			],
			$Failed,
			Messages:>{
				Error::ConflictingTitrationMethod,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingTitrationInstrument","Return an error for TitrationMethod and TitrationInstrument conflicts:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				TitrationMethod -> Manual,
				TitrationInstrument ->Object[Instrument, pHTitrator, "TitrationInstrument for ExperimentAdjustpH robotic titration testing " <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::ConflictingTitrationInstrument,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages, "SafeMixRateMismatch", "Throw an error message if the specified mix rate is over the safe mix rate of the sample container and we do not want to use StirBar:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample in container with no MaxOverheadMixRate populated for ExperimentAdjustpH" <> $SessionUUID],
				6,
				(* This will be aliquoted to a 1 L preferred container, whose safe mix rate < 750 RPM *)
				pHMixType -> Stir,
				pHMixRate -> 750 RPM
			],
			$Failed,
			Messages :> {Error::SafeMixRateMismatch,Error::InvalidOption}
		],
		Example[{Messages, "SafeMixRateNotFound", "Throw an error message if field MaxOverheadMixRate is not populated for the sample container and we do not want ot use StirBar:"},
			ExperimentAdjustpH[
				Object[Sample, "Test water sample in container with no MaxOverheadMixRate populated for ExperimentAdjustpH" <> $SessionUUID],
				6,
				pHMixType -> Stir,
				pHMixRate -> 750 RPM,
				AliquotContainer -> Model[Container, Vessel, "Test 1 L container model with no MaxOverheadMixRate populated for ExperimentAdjustpH"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::SafeMixRateNotFound, Error::InvalidInput}
		],



		(*MeasurepH error checks*)

		Example[{Messages,"DiscardedSamples","Return an error for a discarded sample:"},
			ExperimentAdjustpH[Object[Sample, "Test discarded sample for ExperimentAdjustpH" <> $SessionUUID],8],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			},
			TimeConstraint->1000
		],

		Example[{Messages,"EmptyContainers","Return an error for a container without a sample:"},
			ExperimentAdjustpH[Object[Container, Vessel, "Test container 5 with no sample for ExperimentAdjustpH" <> $SessionUUID],8],
			$Failed,
			Messages:>{
				Error::EmptyContainers
			},
			TimeConstraint->1000
		],
		Example[{Messages,"IncompatibleSample","Return an error for a sample incapable of measurement:"},
			ExperimentAdjustpH[Object[Sample,"Test incompatible sample for ExperimentAdjustpH" <> $SessionUUID],8,TitrationMethod -> Manual, SecondaryWashSolution -> Null],
			$Failed,
			Messages:>{
				Error::IncompatibleSample,
				Error::InvalidInput
			},
			TimeConstraint->1000
		],
		Example[{Messages,"IncompatibleSample","Return an error for a sample too acidic for measurement:"},
			ExperimentAdjustpH[Object[Sample,"Test too acidic sample for ExperimentAdjustpH" <> $SessionUUID],8,TitrationMethod -> Manual, SecondaryWashSolution -> Null],
			$Failed,
			Messages:>{
				Error::IncompatibleSample,
				Error::InvalidInput
			},
			TimeConstraint->1000
		],
		Example[{Messages,"IncompatibleSampleInstrument","Return an error for a sample incapable of measurement for a specified instrument:"},
			ExperimentAdjustpH[Object[Sample,"Test anti-glass chemical for ExperimentAdjustpH" <> $SessionUUID],8,
				pHMeter->Object[Instrument, pHMeter, "Alsace"], SecondaryWashSolution -> Null],
			$Failed,
			Messages:>{
				Error::IncompatibleSample,
				Error::IncompatibleSampleInstrument,
				Error::InvalidInput,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InsufficientVolume","Return an error for too low sample volume, thereby incapable of measurement:"},

			ExperimentAdjustpH[Object[Sample, "Test sample with volume too low for measurement ExperimentAdjustpH" <> $SessionUUID],8, SecondaryWashSolution -> Null],
			$Failed,
			Messages:>{
				Error::InsufficientVolume,
				Error::InvalidInput
			},
			TimeConstraint->1000
		],
		Example[{Messages,"AdjustpHContainerTooSmall","Return an error if container is too small for FixedAddition volume:"},

			ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,
				Aliquot->False,
				ParentProtocol->Object[Protocol,StockSolution,"AdjustpH Parent "<>$SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::AdjustpHContainerTooSmall,
				Error::InvalidOption
			},
			SetUp:>{Upload[<|Object->Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],Volume->49Milliliter|>]},
			TearDown:>{Upload[<|Object->Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],Volume->35Milliliter|>]},
			TimeConstraint->1000
		],
		(*Conflicting inputs*)
		Example[{Messages,"IncompatibleInstrument","Return an error when the Instrument is specified, Aliquot is false, and the Container is too big:"},
			(*mix type stir will introduce other messages--we cannot find suitable impeller for this sample*)
			ExperimentAdjustpH[Object[Sample,"Test water sample for too large container for lil stick for ExperimentAdjustpH" <> $SessionUUID],8,Aliquot->False,pHMixType -> Roll, pHMeter->Model[Instrument, pHMeter, "Mettler Toledo InLab Micro"]],
			$Failed,
			Messages:>{
				Error::IncompatibleInstrument,
				Error::InvalidOption,
				Error::InvalidInput
			},
			TimeConstraint->1000
		],
		Test["Resolve calibration buffer rack and calibration wash solution rack:",
			protocol = ExperimentAdjustpH[Object[Sample,"Test water sample for ExperimentAdjustpH" <> $SessionUUID],8,SecondaryWashSolution -> Null];
			Download[protocol, {CalibrationBufferRack, CalibrationWashSolutionRack}],
			{LinkP[Model[Container, Rack, "id:dORYzZda6Yrb"]], LinkP[Model[Container, Rack, "id:dORYzZda6Yrb"]]},
			Variables:>{protocol}
		]
	},
	SetUp :> (
		$CreatedObjects = {};
		(* clearing memoization here because we otherwise were getting crosstalk with other functions' unit tests*)
		ClearMemoization[]
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	TurnOffMessages :> {
		Warning::SampleMustBeMoved
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		ClearMemoization[];
		Module[{testObjList,existsFilter},
			testObjList = {
				Object[Container, Vessel, "Test container 1 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,ReactionVessel,SolidPhaseSynthesis, "Test container 4 invalid for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 with no sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 that is too big for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 that is too large for lil stick for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 with incompatible sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 9 with too acidic sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 10 with anti-glass sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for No Volume sample for ExperimentAdjustpH" <> $SessionUUID],
				Model[Container, Vessel, "Test container model with no calibration data for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for no calibration for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for large sample volume for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for MilliQ water for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for medium calibration solution with no pH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 16 for another calibration solution with no pH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for solution without a model for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 18 Stock pH 10 calibration solution for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 19 for extra large sample volume for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 20 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 21 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel,"Test container 25 for sample in beaker for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel,"Test container 26 for sample in 15ml tube for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Plate, "Test plate container for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test discarded sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample in a plate for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for invalid container for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for too large container for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for too large container for lil stick for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample with Volume=Null for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for container sans calibration data for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Large test water sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test incompatible sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test too acidic sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test anti-glass chemical for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test Medium calibration solution with no pH value for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Another test calibration solution with no pH Value for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Stock test pH 10 calibration solution for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Extra large test water sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test sample in tube for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, StockSolution,"Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, "Test chemical model incompatible for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, "Test chemical model too acidic for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, "Test chemical model incompatible with water for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, "Test medium calibration solution model with no pH for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, "Another test calibration solution model with no pH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Protocol, AdjustpH, "Test Template Protocol for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Surface probe test sample in tube for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,Vessel,"Test container 22 for 1.85 M NaOH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,Vessel,"Test container 23 for 5 M NaOH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,Vessel,"Test container 24 for 2 M HCl for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test 5 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test 2 M HCl sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test sample in a beaker for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test sample in a 15ml tube for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object for red dye for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object 0 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object 1 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object 2 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object 3 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 27 for solid NaOH ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test sample 27 for solid NaOH ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,Vessel,VolumetricFlask, "Test container 28 Volumetric Flask for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 29 10L Carboy with enough liquid for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test sample 28 in Volumetric Flask ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test sample 29 in 10L Carboy with enough liquid for ExperimentAdjustpH" <> $SessionUUID],
				Object[Protocol,StockSolution,"AdjustpH Parent "<>$SessionUUID],
				Object[Container, Bench, "Test bench for ExperimentAdjustpH tests"<> $SessionUUID],
				Object[Instrument, pHTitrator, "TitrationInstrument for ExperimentAdjustpH robotic titration testing " <> $SessionUUID],
				Object[Instrument, pHMeter, "pH meter for ExperimentAdjustpH testing" <> $SessionUUID],
				Object[Instrument, OverheadStirrer, "overhead stirrer for ExperimentAdjustpH testing" <> $SessionUUID],
				Object[Part, pHProbe, "pH probe for ExperimentAdjustpH testing" <> $SessionUUID],
				Object[Part, pHProbe, "pH secondary probe for ExperimentAdjustpH testing" <> $SessionUUID],
				Model[Container, Vessel, "Test 1 L container model with no MaxOverheadMixRate populated for ExperimentAdjustpH"<>$SessionUUID],
				Object[Container, Vessel, "Test 1 L container object with no MaxOverheadMixRate populated for ExperimentAdjustpH"<>$SessionUUID],
				Object[Sample,"Test water sample in container with no MaxOverheadMixRate populated for ExperimentAdjustpH"<>$SessionUUID]
			};
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			existsFilter = DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList, existsFilter], Force->True, Verbose->False];

		];
		Module[{stockSolutionID, modelCompat, modelIncompat, tooAcidicModel, medCalNopHModel, anotherCalNopHModel, containerNoCalModel, historicAdjustpHProtocol, historicStockSolutionProtocol,
			stockSolutionParent, emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, plateSample,
			emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11, emptyContainer12,dropletModel,
			emptyContainer13, emptyContainer14, emptyContainer15, emptyContainer16,emptyContainer22,emptyContainer23,emptyContainer24,discardedChemical, waterSample, lowVolSample,
			invConSample, tooBigConSample, tooBigLilStickSample,incompatSample, tooAcidicSample, noSappSample, noVolumeSample, noCalSample,
			largeSample, milliQSample, mediumCalNopH, anotherCalNopH,modelLessSample,emptyContainer17,emptyContainer18,pH10Stock,emptyPlate,
			emptyContainer19, sample19, emptyContainer20,emptyContainer21,sample20,sample21,sample22,sample23,sample24,emptyContainer25,sample25,emptyContainer26,sample26,sample27,emptyContainer27,
			emptyContainer28,emptyContainer29,sample28,sample29, testBench,sample30,emptyContainer30},

			ClearDownload[];
			ClearMemoization[];

			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
				Name -> "Test bench for ExperimentAdjustpH tests"<> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>];

			Upload[{
				<|
					Type -> Object[Part, pHProbe],
					Model -> Link[Model[Part, pHProbe, "id:jLq9jXvP7jLx"], Objects],
					Site -> Link[$Site],
					Name -> "pH probe for ExperimentAdjustpH testing" <> $SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Part, pHProbe],
					Model -> Link[Model[Part, pHProbe, "id:J8AY5jDmW5BZ"], Objects],
					Site -> Link[$Site],
					Name -> "pH secondary probe for ExperimentAdjustpH testing" <> $SessionUUID,
					DeveloperObject -> True
				|>
			}];

			Upload[{
				<|
					Type -> Object[Instrument, pHMeter],
					Model -> Link[Model[Instrument, pHMeter, "id:R8e1PjeAn4B4"], Objects], (*Model[Instrument, pHMeter, "SevenExcellence (for pH) for Robotic Titration"]*)
					Name -> "pH meter for ExperimentAdjustpH testing" <> $SessionUUID,
					Probe -> Link[Object[Part, pHProbe, "pH probe for ExperimentAdjustpH testing" <> $SessionUUID], pHMeter],
					SecondaryProbe -> Link[Object[Part, pHProbe, "pH secondary probe for ExperimentAdjustpH testing" <> $SessionUUID], pHMeter],
					Site -> Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Instrument, OverheadStirrer],
					Model -> Link[Model[Instrument, OverheadStirrer, "id:qdkmxzqNkVB1"], Objects],
					Name -> "overhead stirrer for ExperimentAdjustpH testing" <> $SessionUUID,
					Site -> Link[$Site],
					DeveloperObject -> True
				|>
			}];

			Upload[
				{
					<|
						Name -> "TitrationInstrument for ExperimentAdjustpH robotic titration testing " <> $SessionUUID,
						Type -> Object[Instrument, pHTitrator],
						pHMeter -> Link[Object[Instrument, pHMeter, "pH meter for ExperimentAdjustpH testing" <> $SessionUUID]],
						MixInstrument -> Link[Object[Instrument, OverheadStirrer, "overhead stirrer for ExperimentAdjustpH testing" <> $SessionUUID]],
						Model -> Link[Model[Instrument, pHTitrator, "id:WNa4Zjap6PRE"], Objects],
						Site -> Link[$Site],
						DeveloperObject -> True
					|>
				}
			];

			Upload[<|
				Type -> Model[Container, Vessel],
				Name -> "Test 1 L container model with no MaxOverheadMixRate populated for ExperimentAdjustpH"<>$SessionUUID,
				DeveloperObject -> True,
				MaxOverheadMixRate -> Null,
				SelfStanding -> True,
				Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
					MaxWidth -> Quantity[0.09525, "Meters"],
					MaxDepth -> Quantity[0.09525, "Meters"],
					MaxHeight -> Quantity[0.23495, "Meters"]|>},
				Replace[PositionPlotting] -> {<|Name -> "A1",
					XOffset -> Quantity[0.047625, "Meters"],
					YOffset -> Quantity[0.047625, "Meters"],
					ZOffset -> Quantity[0.003175, "Meters"],
					CrossSectionalShape -> Circle, Rotation -> 0.|>},
				InternalBottomShape -> FlatBottom,
				Aperture -> Quantity[29., "Millimeters"],
				InternalDepth -> Quantity[234.95, "Millimeters"],
				InternalDiameter -> Quantity[95.25, "Millimeters"],
				MaxTemperature -> Quantity[140., "DegreesCelsius"],
				MaxVolume -> Quantity[1000., "Milliliters"],
				MinTemperature -> Quantity[0., "DegreesCelsius"],
				MinVolume -> Quantity[10., "Milliliters"],
				Dimensions -> {Quantity[0.1, "Meters"], Quantity[0.1, "Meters"], Quantity[0.235, "Meters"]},
				Opaque -> False,
				Replace[ContainerMaterials] -> {Glass},
				DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
				MaxVolume -> 1 Liter
			|>];

			stockSolutionID = CreateID[Object[Protocol, StockSolution]];

			(*Create some chemicals too corrosive for measurement as well as instrument models*)
			{modelCompat, modelIncompat, tooAcidicModel, medCalNopHModel, anotherCalNopHModel, containerNoCalModel, historicAdjustpHProtocol, historicStockSolutionProtocol, stockSolutionParent} = Upload[{
				<|
					Type->Model[Sample,StockSolution],
					Name->"Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID,
					State->Liquid,
					Replace[Composition]->{{96VolumePercent,Link[Model[Molecule,"id:vXl9j57PmP5D"]]},{4VolumePercent,Link[Model[Molecule,"id:L8kPEjn6vbwA"]]}},
					DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
					pH->8.01,
					MinpH->7.80,
					MaxpH->8.20,
					NominalpH->8.0,
					TotalVolume->1Liter,
					MaxNumberOfpHingCycles->15,
					MaxAcidAmountPerCycle->1Milliliter,
					MaxBaseAmountPerCycle->1Milliliter,
					MaxpHingAdditionVolume->100Milliliter
				|>,
				<|
					Type->Model[Sample],
					Name->"Test chemical model incompatible for ExperimentAdjustpH" <> $SessionUUID,
					State->Liquid,
					Replace[Composition]->{{Null,Null}},
					DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
					Append[IncompatibleMaterials]->Glass,
					DeveloperObject->True
				|>,
				<|
					Type->Model[Sample],
					Name->"Test chemical model too acidic for ExperimentAdjustpH" <> $SessionUUID,
					State->Liquid,
					Replace[Composition]->{{Null,Null}},
					DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
					DeveloperObject->True
				|>,
				(*Create a calibration solution model for medium with no pH value*)
				<|
					Type->Model[Sample],
					Name->"Test medium calibration solution model with no pH for ExperimentAdjustpH" <> $SessionUUID,
					State->Liquid,
					Replace[Composition]->{{Null,Null}},
					DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
					pH->Null,
					DeveloperObject->True
				|>,
				<|
					Type->Model[Sample],
					Name->"Another test calibration solution model with no pH for ExperimentAdjustpH" <> $SessionUUID,
					State->Liquid,
					Replace[Composition]->{{Null,Null}},
					DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
					pH->Null,
					DeveloperObject->True
				|>,
				(*Create container model with no calibration data*)
				<|Type->Model[Container, Vessel],
					Name->"Test container model with no calibration data for ExperimentAdjustpH" <> $SessionUUID,
					Deprecated->False,
					Dimensions->{
						Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.1143`, "Meters"]
					},
					Replace[Positions]->{<|
						Name->"A1", Footprint->Null,
						MaxWidth->Quantity[0.028575`, "Meters"],
						MaxDepth->Quantity[0.028575`, "Meters"],
						MaxHeight->Quantity[0.1143`, "Meters"]
					|>},
					DefaultStorageCondition->Link[Model[StorageCondition, "Ambient Storage"]],
					DeveloperObject->True
				|>,
				<|Type->Object[Protocol,AdjustpH],ParentProtocol -> Link[stockSolutionID, Subprotocols]|>,
				<|Object -> stockSolutionID|>,
				<|Type -> Object[Protocol,StockSolution],Name->"AdjustpH Parent "<>$SessionUUID|>
			}];

			(* Create some empty containers *)
			Block[{$DeveloperUpload = True},
				{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,emptyContainer12,emptyContainer13,emptyContainer14,emptyContainer15,emptyContainer16,emptyContainer17,emptyContainer18,emptyPlate,emptyContainer19, emptyContainer20,emptyContainer21,emptyContainer22,emptyContainer23,emptyContainer24,emptyContainer25,emptyContainer26,emptyContainer27,emptyContainer28,emptyContainer29, emptyContainer30} = UploadSample[{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,ReactionVessel,SolidPhaseSynthesis,"NAP 10 Gravity Cartridge"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"10L Polypropylene Carboy"],
					Model[Container,Vessel,"500mL Glass Bottle"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					containerNoCalModel,
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Vessel, "id:Vrbp1jG800Zm"],
					Model[Container,Vessel,"2mL Tube"],
					Model[Container,Vessel,"2mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container, Vessel, "250mL Kimax Beaker"],
					Model[Container, Vessel, "15mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, VolumetricFlask, "1 L Glass Volumetric Flask"],
					Model[Container,Vessel,"10L Polypropylene Carboy"],
					Model[Container, Vessel, "Test 1 L container model with no MaxOverheadMixRate populated for ExperimentAdjustpH" <> $SessionUUID]
				},
					ConstantArray[{"Work Surface", testBench}, 31],
					Name -> {
						"Test container 1 for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 2 for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 3 for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 4 invalid for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 5 with no sample for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 6 that is too big for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 7 that is too large for lil stick for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 8 with incompatible sample for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 9 with too acidic sample for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 10 with anti-glass sample for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 11 for No Volume sample for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 12 for no calibration for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 13 for large sample volume for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 14 for MilliQ water for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 15 for medium calibration solution with no pH for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 16 for another calibration solution with no pH for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 17 for solution without a model for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 18 Stock pH 10 calibration solution for ExperimentAdjustpH" <> $SessionUUID,
						"Test plate container for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 19 for extra large sample volume for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 20 for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 21 for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 22 for 1.85 M NaOH for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 23 for 5 M NaOH for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 24 for 2 M HCl for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 25 for sample in beaker for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 26 for sample in 15ml tube for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 27 for solid NaOH ExperimentAdjustpH" <> $SessionUUID,
						"Test container 28 Volumetric Flask for ExperimentAdjustpH" <> $SessionUUID,
						"Test container 29 10L Carboy with enough liquid for ExperimentAdjustpH" <> $SessionUUID,
						"Test 1 L container object with no MaxOverheadMixRate populated for ExperimentAdjustpH" <> $SessionUUID
					}
				]
			];

			(* Create some samples *)
			{discardedChemical,waterSample,lowVolSample,invConSample,tooBigConSample,tooBigLilStickSample,
				incompatSample,tooAcidicSample,noSappSample,noVolumeSample,noCalSample,largeSample,milliQSample,
				mediumCalNopH,anotherCalNopH,modelLessSample,pH10Stock,plateSample,sample19,sample20,sample21,sample22,
				sample23,sample24,sample25,sample26,sample27,sample28,sample29,sample30}=UploadSample[
				{
					(*1*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*2*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*3*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*4*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*5*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*6*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*7*)modelIncompat,
					(*8*)tooAcidicModel,
					(*9*)Model[Sample, "id:XnlV5jK6jbk3"],
					(*10*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*11*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*12*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*13*)Model[Sample, "Milli-Q water"],
					(*14*)medCalNopHModel,
					(*15*)anotherCalNopHModel,
					(*16*){{100 VolumePercent, Model[Molecule, "Water"]}},
					(*17*)Model[Sample, "Reference buffer, pH 10"],
					(*18*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*19*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*20*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*21*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*22*)Model[Sample, StockSolution, "1.85 M NaOH"],
					(*23*)Model[Sample, StockSolution, "5.0 M NaOH"],
					(*24*)Model[Sample, StockSolution, "2 M HCl"],
					(*25*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*26*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*27*)Model[Sample, "id:XnlV5jmbZLLZ"],
					(*28*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*29*)Model[Sample, StockSolution, "Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
					(*30*)Model[Sample, "Milli-Q water"]
				},
				{
					(*1*){"A1",emptyContainer1},
					(*2*){"A1",emptyContainer2},
					(*3*){"A1",emptyContainer3},
					(*4*){"A1",emptyContainer4},
					(*5*){"A1",emptyContainer6},
					(*6*){"A1",emptyContainer7},
					(*7*){"A1",emptyContainer8},
					(*8*){"A1",emptyContainer9},
					(*9*){"A1",emptyContainer10},
					(*10*){"A1",emptyContainer11},
					(*11*){"A1",emptyContainer12},
					(*12*){"A1",emptyContainer13},
					(*13*){"A1",emptyContainer14},
					(*14*){"A1",emptyContainer15},
					(*15*){"A1",emptyContainer16},
					(*16*){"A1",emptyContainer17},
					(*17*){"A1",emptyContainer18},
					(*18*){"A1",emptyPlate},
					(*19*){"A1",emptyContainer19},
					(*20*){"A1",emptyContainer20},
					(*21*){"A1",emptyContainer21},
					(*22*){"A1",emptyContainer22},
					(*23*){"A1",emptyContainer23},
					(*24*){"A1",emptyContainer24},
					(*25*){"A1",emptyContainer25},
					(*26*){"A1",emptyContainer26},
					(*27*){"A1",emptyContainer27},
					(*28*){"A1",emptyContainer28},
					(*29*){"A1",emptyContainer29},
					(*30*){"A1",emptyContainer30}
				},
				InitialAmount->{
					(*1*)35 Milliliter,
					(*2*)35 Milliliter,
					(*3*)0.009 Milliliter,
					(*4*)1 Milliliter,
					(*5*)1Milliliter,
					(*6*)102 Milliliter,
					(*7*)35 Milliliter,
					(*8*)35 Milliliter,
					(*9*)35 Milliliter,
					(*10*)Null,
					(*11*)35 Milliliter,
					(*12*)250 Milliliter,
					(*13*)35 Milliliter,
					(*14*)35 Milliliter,
					(*15*)35 Milliliter,
					(*16*)20 Milliliter,
					(*17*)0.75 Liter,
					(*18*)1 Milliliter,
					(*19*)3 Liter,
					(*20*)1 Milliliter,
					(*21*)200 Microliter,
					(*22*)40 Milliliter,
					(*23*)40 Milliliter,
					(*24*)40 Milliliter,
					(*25*)180 Milliliter,
					(*26*)10 Milliliter,
					(*27*)5 Gram,
					(*28*)0.95Liter,
					(*29*)9Liter,
					(*30*)0.8Liter
				},
				Name->{
					(*1*)"Test discarded sample for ExperimentAdjustpH" <> $SessionUUID,
					(*2*)"Test water sample for ExperimentAdjustpH" <> $SessionUUID,
					(*3*)"Test sample with volume too low for measurement ExperimentAdjustpH" <> $SessionUUID,
					(*4*)"Test water sample for invalid container for ExperimentAdjustpH" <> $SessionUUID,
					(*5*)"Test water sample for too large container for ExperimentAdjustpH" <> $SessionUUID,
					(*6*)"Test water sample for too large container for lil stick for ExperimentAdjustpH" <> $SessionUUID,
					(*7*)"Test incompatible sample for ExperimentAdjustpH" <> $SessionUUID,
					(*8*)"Test too acidic sample for ExperimentAdjustpH" <> $SessionUUID,
					(*9*)"Test anti-glass chemical for ExperimentAdjustpH" <> $SessionUUID,
					(*10*)"Test water sample with Volume=Null for ExperimentAdjustpH" <> $SessionUUID,
					(*11*)"Test water sample for container sans calibration data for ExperimentAdjustpH" <> $SessionUUID,
					(*12*)"Large test water sample for ExperimentAdjustpH" <> $SessionUUID,
					(*13*)"Test MilliQ water sample for ExperimentAdjustpH" <> $SessionUUID,
					(*14*)"Test Medium calibration solution with no pH value for ExperimentAdjustpH" <> $SessionUUID,
					(*15*)"Another test calibration solution with no pH Value for ExperimentAdjustpH" <> $SessionUUID,
					(*16*)"Test MilliQ water sample for sample without a model for ExperimentAdjustpH" <> $SessionUUID,
					(*17*)"Stock test pH 10 calibration solution for ExperimentAdjustpH" <> $SessionUUID,
					(*18*)"Test water sample in a plate for ExperimentAdjustpH" <> $SessionUUID,
					(*19*)"Extra large test water sample for ExperimentAdjustpH" <> $SessionUUID,
					(*20*)"Test sample in tube for ExperimentAdjustpH" <> $SessionUUID,
					(*21*)"Surface probe test sample in tube for ExperimentAdjustpH" <> $SessionUUID,
					(*22*)"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID,
					(*23*)"Test 5 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID,
					(*24*)"Test 2 M HCl sample for ExperimentAdjustpH" <> $SessionUUID,
					(*25*)"Test sample in a beaker for ExperimentAdjustpH" <> $SessionUUID,
					(*26*)"Test sample in a 15ml tube for ExperimentAdjustpH" <> $SessionUUID,
					(*27*)"Test sample 27 for solid NaOH ExperimentAdjustpH" <> $SessionUUID,
					(*28*)"Test sample 28 in Volumetric Flask ExperimentAdjustpH" <> $SessionUUID,
					(*29*)"Test sample 29 in 10L Carboy with enough liquid for ExperimentAdjustpH" <> $SessionUUID,
					(*30*)"Test water sample in container with no MaxOverheadMixRate populated for ExperimentAdjustpH" <> $SessionUUID
				},
				StorageCondition->AmbientStorage
			];

			(*Make a template protocol*)

			ExperimentAdjustpH[Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID], 8, TitrationMethod -> Manual, Name->"Test Template Protocol for ExperimentAdjustpH" <> $SessionUUID];

			(*Upload Object[Data,pHAdjustment] as HistoricalData. Don't set DeveloperObject->True as we find this in a Search *)
			Upload[{
				<|
					Name->"Test data object for red dye for ExperimentAdjustpH" <> $SessionUUID,
					Type->Object[Data,pHAdjustment],
					Replace[SamplesIn]->{Link[Object[Sample, "Large test water sample for ExperimentAdjustpH" <> $SessionUUID],Data]},
					NominalpH->8,
					pHAchieved->True,
					Overshot->False,
					Replace[FixedAdditions]->{},
					pH->8.02,
					Protocol->Link[historicAdjustpHProtocol,Data],
					SampleModel->Link[Model[Sample, StockSolution, "id:1ZA60vLrOJl8"]],
					SampleVolume->45Milliliter,
					TitratingBaseModel->Link[Model[Sample,StockSolution,"1.85 M NaOH"]],
					TitratingAcidModel->Link[Model[Sample, StockSolution, "2 M HCl"]],
					Replace[pHLog]->{

						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1Milliliter,
							6.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1Milliliter,
							7.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1Milliliter,
							8.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						}
					}
				|>,
				<|
					Name->"Test data object 0 for ExperimentAdjustpH" <> $SessionUUID,
					Type->Object[Data,pHAdjustment],
					Replace[SamplesIn]->{Link[Object[Sample, "Large test water sample for ExperimentAdjustpH" <> $SessionUUID],Data]},
					NominalpH->8,
					pHAchieved->True,
					Overshot->False,
					Replace[FixedAdditions]->{},
					pH->8.02,
					Protocol->Link[historicAdjustpHProtocol,Data],
					SampleModel->Link[Model[Sample, StockSolution,"Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID]],
					SampleVolume->45Milliliter,
					TitratingBaseModel->Link[Model[Sample,StockSolution,"1.85 M NaOH"]],
					TitratingAcidModel->Link[Model[Sample, StockSolution, "2 M HCl"]],
					Replace[pHLog]->{

						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1Milliliter,
							6.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1Milliliter,
							7.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1Milliliter,
							8.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						}
					}
				|>,
				(*Data without overshot but FixedAdditions uses a different model as Titrants*)
				<|
					Name->"Test data object 1 for ExperimentAdjustpH" <> $SessionUUID,
					Type->Object[Data,pHAdjustment],
					Replace[SamplesIn]->{Link[Object[Sample, "Large test water sample for ExperimentAdjustpH" <> $SessionUUID],Data]},
					NominalpH->8,
					pHAchieved->True,
					Overshot->False,
					Replace[FixedAdditions]->{
						{10Microliter,Link[Model[Sample, StockSolution, "5.0 M NaOH"]],Link[Object[Sample,"Test 5 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]]},
						{15Microliter,Link[Model[Sample, StockSolution, "5.0 M NaOH"]],Link[Object[Sample,"Test 5 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]]}
					},
					pH->8.02,
					Protocol->Link[historicAdjustpHProtocol,Data],
					SampleModel->Link[Model[Sample, StockSolution,"Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID]],
					SampleVolume->45Milliliter,
					TitratingBaseModel->Link[Model[Sample,StockSolution,"1.85 M NaOH"]],
					TitratingAcidModel->Link[Model[Sample, StockSolution, "2 M HCl"]],
					Replace[pHLog]->{
						{
							Link[Model[Sample, StockSolution, "5.0 M NaOH"]],
							Link[Object[Sample,"Test 5 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							100Microliter,
							Null,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "5.0 M NaOH"]],
							Link[Object[Sample,"Test 5 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							150Microliter,
							Null,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1000Microliter,
							6.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1000Microliter,
							7.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1000Microliter,
							8.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						}
					}
				|>,
				(*Data with overshot*)
				<|
					Name->"Test data object 2 for ExperimentAdjustpH" <> $SessionUUID,
					Type->Object[Data,pHAdjustment],
					Replace[SamplesIn]->{Link[Object[Sample, "Large test water sample for ExperimentAdjustpH" <> $SessionUUID],Data]},
					NominalpH->8,
					pHAchieved->True,
					Overshot->True,
					Replace[FixedAdditions]->{},
					pH->8.02,
					Protocol->Link[historicAdjustpHProtocol,Data],
					SampleModel->Link[Model[Sample, StockSolution,"Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID]],
					SampleVolume->45Milliliter,
					TitratingBaseModel->Link[Model[Sample,StockSolution,"1.85 M NaOH"]],
					TitratingAcidModel->Link[Model[Sample, StockSolution, "2 M HCl"]],
					Replace[pHLog]->{

						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1000Microliter,
							6.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1000Microliter,
							9.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "2 M HCl"]],
							Link[Object[Sample,"Test 2 M HCl sample for ExperimentAdjustpH" <> $SessionUUID]],
							1000Microliter,
							8.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						}
					}
				|>,
				(* Data with failed and spike *)
				<|
					Name->"Test data object 3 for ExperimentAdjustpH" <> $SessionUUID,
					Type->Object[Data,pHAdjustment],
					Replace[SamplesIn]->{Link[Object[Sample, "Large test water sample for ExperimentAdjustpH" <> $SessionUUID],Data]},
					NominalpH->8,
					pHAchieved->False,
					Overshot->True,
					Replace[FixedAdditions]->{},
					pH->6,
					Protocol->Link[historicAdjustpHProtocol,Data],
					SampleModel->Link[Model[Sample, StockSolution,"Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID]],
					SampleVolume->45Milliliter,
					TitratingBaseModel->Link[Model[Sample,StockSolution,"1.85 M NaOH"]],
					TitratingAcidModel->Link[Model[Sample, StockSolution, "2 M HCl"]],
					Replace[pHLog]->{
						{
							Null,
							Null,
							Null,
							6.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1000Microliter,
							6.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "1.85 M NaOH"]],
							Link[Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID]],
							1000Microliter,
							10.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						},
						{
							Link[Model[Sample, StockSolution, "2 M HCl"]],
							Link[Object[Sample,"Test 2 M HCl sample for ExperimentAdjustpH" <> $SessionUUID]],
							1000Microliter,
							6.0,
							Link[Object[Data, pH, "Test pH data for ExperimentAdjustpH"]]
						}
					}
				|>

			}
			];

			(* Make some changes to our samples to make them invalid. *)

			Upload[{
				<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
				<|
					Object->waterSample,
					Replace[Composition]->{{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}}
				|>,
				<|Object->lowVolSample,DeveloperObject->True|>,
				<|Object->invConSample,DeveloperObject->True|>,
				<|Object->tooBigConSample,DeveloperObject->True|>,
				<|Object->tooBigLilStickSample,DeveloperObject->True|>,
				<|Object->incompatSample,DeveloperObject->True|>,
				<|Object->tooAcidicSample,pH->-0.0001,DeveloperObject->True|>,
				<|Object->noSappSample,DeveloperObject->True|>,
				<|Object->noVolumeSample,DeveloperObject->True|>,
				<|Object->noCalSample,DeveloperObject->True|>,
				<|Object->milliQSample,DeveloperObject->True|>,
				<|Object->mediumCalNopH,DeveloperObject->True|>,
				<|Object->anotherCalNopH,DeveloperObject->True|>,
				<|Object->plateSample,DeveloperObject->True|>,
				<|Object->sample19,DeveloperObject->True|>,
				<|Object->sample20,DeveloperObject->True|>,
				<|Object->modelLessSample,Model->Null,DeveloperObject->True|>
			}];


		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects,existingObjects},
			allObjects= {
				Object[Container, Vessel, "Test container 1 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,ReactionVessel,SolidPhaseSynthesis, "Test container 4 invalid for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 with no sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 that is too big for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 that is too large for lil stick for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 with incompatible sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 9 with too acidic sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 10 with anti-glass sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for No Volume sample for ExperimentAdjustpH" <> $SessionUUID],
				Model[Container, Vessel, "Test container model with no calibration data for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for no calibration for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for large sample volume for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for MilliQ water for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for medium calibration solution with no pH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 16 for another calibration solution with no pH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for solution without a model for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 18 Stock pH 10 calibration solution for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 19 for extra large sample volume for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 20 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 21 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel,"Test container 25 for sample in beaker for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel,"Test container 26 for sample in 15ml tube for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Plate, "Test plate container for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test discarded sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample in a plate for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for invalid container for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for too large container for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for too large container for lil stick for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample with Volume=Null for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test water sample for container sans calibration data for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Large test water sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test incompatible sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test too acidic sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test anti-glass chemical for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test Medium calibration solution with no pH value for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Another test calibration solution with no pH Value for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Stock test pH 10 calibration solution for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Extra large test water sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test sample in tube for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, StockSolution,"Test chemical model Compatible for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, "Test chemical model incompatible for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, "Test chemical model too acidic for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, "Test medium calibration solution model with no pH for ExperimentAdjustpH" <> $SessionUUID],
				Model[Sample, "Another test calibration solution model with no pH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Instrument, pHMeter, "Test pHmeter droplet type for ExperimentAdjustpH" <> $SessionUUID],
				Object[Protocol, AdjustpH, "Test Template Protocol for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Surface probe test sample in tube for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,Vessel,"Test container 22 for 1.85 M NaOH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,Vessel,"Test container 23 for 5 M NaOH for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,Vessel,"Test container 24 for 2 M HCl for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test 1.85 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test 5 M NaOH sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test 2 M HCl sample for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test sample in a beaker for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test sample in a 15ml tube for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object for red dye for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object 0 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object 1 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object 2 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Data,pHAdjustment,"Test data object 3 for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 27 for solid NaOH ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample, "Test sample 27 for solid NaOH ExperimentAdjustpH" <> $SessionUUID],
				Object[Container,Vessel,VolumetricFlask, "Test container 28 Volumetric Flask for ExperimentAdjustpH" <> $SessionUUID],
				Object[Container, Vessel, "Test container 29 10L Carboy with enough liquid for ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test sample 28 in Volumetric Flask ExperimentAdjustpH" <> $SessionUUID],
				Object[Sample,"Test sample 29 in 10L Carboy with enough liquid for ExperimentAdjustpH" <> $SessionUUID],
				Object[Protocol,StockSolution,"AdjustpH Parent "<>$SessionUUID],
				Object[Instrument, pHTitrator, "TitrationInstrument for ExperimentAdjustpH robotic titration testing " <> $SessionUUID],
				Object[Instrument, pHMeter, "pH meter for ExperimentAdjustpH testing" <> $SessionUUID],
				Object[Instrument, OverheadStirrer, "overhead stirrer for ExperimentAdjustpH testing" <> $SessionUUID],
				Object[Part, pHProbe, "pH probe for ExperimentAdjustpH testing" <> $SessionUUID],
				Object[Part, pHProbe, "pH secondary probe for ExperimentAdjustpH testing" <> $SessionUUID],
				Model[Container, Vessel, "Test 1 L container model with no MaxOverheadMixRate populated for ExperimentAdjustpH"<>$SessionUUID],
				Object[Container, Vessel, "Test 1 L container object with no MaxOverheadMixRate populated for ExperimentAdjustpH"<>$SessionUUID],
				Object[Sample,"Test water sample in container with no MaxOverheadMixRate populated for ExperimentAdjustpH"<>$SessionUUID]

			};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];
		]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
