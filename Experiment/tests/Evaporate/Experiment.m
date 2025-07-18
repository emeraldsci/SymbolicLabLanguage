(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentEvaporate*)


DefineTests[ExperimentEvaporate,
	{
		(* --- Basic Examples --- *)
		Example[{Basic,"Evaporate a sample:"},
			ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,Evaporate]]
		],

		Example[{Basic,"Evaporate multiple samples:"},
			ExperimentEvaporate[
				{Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID],Object[Sample,"Evaporate Test DCM Sample2" <> $SessionUUID]},
				EvaporationType->SpeedVac,
				Upload->True
			],
			ObjectP[Object[Protocol,Evaporate]]
		],

		Example[{Basic,"Evaporate samples using one of each evaporation technique:"},
			ExperimentEvaporate[
				{Object[Container, Vessel, "Evaporate Test 50mL 1" <> $SessionUUID],Object[Container, Vessel, "Evaporate Test 50mL 2" <> $SessionUUID],Object[Container, Plate, "Evaporate Test Plate" <> $SessionUUID]},
				EvaporationType -> {RotaryEvaporation,SpeedVac,NitrogenBlowDown},
				Upload->True
			],
			ObjectP[Object[Protocol,Evaporate]]
		],

		Test["Evaporate a sample with a severed model:",
			ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample Severed Model" <> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,Evaporate]]
		],

		Example[{Basic,"Measure the volumes of all samples in a container:"},
			ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID]],
			ObjectP[Object[Protocol,Evaporate]]
		],

		(* --- Option Resolution --- *)

		(* BalancingSolution *)
		Example[{Options,BalancingSolution,"BalancingSolution controls model chemical is used to fill balance plates for speedvac evaporation:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], BalancingSolution -> Model[Sample, "Milli-Q water"], Output -> Options], BalancingSolution],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]]
		],
		(* BumpProtection *)
		Example[{Options,BumpProtection,"BumpProtection controls whether the speedvac method chosen will utilized controlled or rapid evacuation:"},
			protObj = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], BumpProtection -> True, EvaporationType -> SpeedVac];
			methodObj = Download[protObj,VacuumEvaporationMethods][[1]];
			Download[methodObj,ControlledChamberEvacuation],
			True,
			TimeConstraint->600
		],
		(* RecoupBumpTrap *)
		Example[{Options,RecoupBumpTrap,"RecoupBumpTrap controls whether any material caught in the rotovap's bump trap will be resuspended and re-collected:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], RecoupBumpTrap -> True, EvaporationType -> RotaryEvaporation, Output -> Options], RecoupBumpTrap],
			True
		],
		Example[{Options,RecoupBumpTrap,"RecoupBumpTrap -> False indicates no material caught by the bump trap will be saved and will instead be rinsed into waste at the end of the protocol:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], RecoupBumpTrap -> False, Output -> Options], RecoupBumpTrap],
			False
		],
		Example[{Options,RecoupBumpTrap,"RecoupBumpTrap is automatically resolved to Null when not using RotaryEvaporation:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2"<>$SessionUUID],EvaporationType->SpeedVac,Output->Options],RecoupBumpTrap],
			Null
		],
		Example[{Options,RecoupBumpTrap,"RecoupBumpTrap is automatically resolved to True when using RotaryEvaporation:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2"<>$SessionUUID],EvaporationType->RotaryEvaporation,Output->Options],RecoupBumpTrap],
			True
		],
		Example[{Additional,"BumpTrapSampleContainer, BumpTrapRinseSolution, BumpTrapRinseVolume are automatically set to Null when not using RotaryEvaporation:"},
			Lookup[
				ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube"<>$SessionUUID],EvaporationType->SpeedVac,Output->Options],
				{BumpTrapSampleContainer,BumpTrapRinseSolution,BumpTrapRinseVolume}
			],
			{Null,Null,Null}
		],
		Example[{Additional,"BumpTrapSampleContainer, BumpTrapRinseSolution, BumpTrapRinseVolume are automatically set when using RotaryEvaporation:"},
			Lookup[
				ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube"<>$SessionUUID],EvaporationType->RotaryEvaporation,Output->Options],
				{BumpTrapSampleContainer,BumpTrapRinseSolution,BumpTrapRinseVolume}
			],
			{Except[Null|Automatic],Except[Null|Automatic],Except[Null|Automatic]}
		],
		Example[{Additional,"BumpTrapRinseSolution, BumpTrapSampleContainer resources are generated when using RotaryEvaporation and RecoupBump->False:"},
			protocol=ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube"<>$SessionUUID],EvaporationType->RotaryEvaporation,RecoupBumpTrap->False];
			And[
				MemberQ[Download[protocol,RequiredResources],{ObjectP[Object[Resource]],BatchedEvaporationParameters,_,BumpTrapSampleContainer}],
				MemberQ[Download[protocol,RequiredResources],{ObjectP[Object[Resource]],BatchedEvaporationParameters,_,BumpTrapRinseSolution}]
			],
			True,
			Variables:>{protocol}
		],
		(* BumpTrapSampleContainer *)
		Example[{Options,BumpTrapSampleContainer,"BumpTrapSampleContainer controls which model of container the rinsed material will be put into:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], BumpTrapSampleContainer -> Model[Container,Vessel,"40mL Glass Scintillation Vial"], Output -> Options], BumpTrapSampleContainer],
			ObjectReferenceP[Model[Container,Vessel,"40mL Glass Scintillation Vial"]]
		],
		Example[{Options,BumpTrapSampleContainer,"BumpTrapSampleContainer controls which model of container the rinsed material will be put into:"},
			Download[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], BumpTrapSampleContainer -> Object[Container,Vessel,"Evaporate Test 50mL 6" <> $SessionUUID]], BumpTrapSampleContainers],
			{LinkP[Object[Container,Vessel,"Evaporate Test 50mL 6" <> $SessionUUID]]}
		],

		(* BumpTrapRinseSolution *)
		Example[{Options,BumpTrapRinseSolution,"BumpTrapRinseSolution controls which chemical or stock solution will be used to rinse out any dried sediment from the bump trap:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], BumpTrapRinseSolution -> Model[Sample,"Acetone, Reagent Grade"], Output -> Options], BumpTrapRinseSolution],
			ObjectReferenceP[Model[Sample,"Acetone, Reagent Grade"]]
		],
		(* BumpTrapRinseVolume *)
		Example[{Options,BumpTrapRinseVolume,"BumpTrapRinseVolume controls how much of the BumpTrapRinseSolution will be used to rinse the bump trap and collect dried materials:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], BumpTrapRinseVolume -> 40 Milliliter, Output -> Options], BumpTrapRinseVolume],
			40 Milliliter
		],
		Test["Both BumpTrapRinseVolume and BumpTrapSampleContainer can be specified:",
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], BumpTrapRinseVolume -> 40 Milliliter, BumpTrapSampleContainer -> Model[Container,Vessel,"40mL Glass Scintillation Vial"], Output -> Options], {BumpTrapRinseVolume, BumpTrapSampleContainer}],
			{40 Milliliter, ObjectReferenceP[Model[Container,Vessel,"40mL Glass Scintillation Vial"]]}
		],
		(* RecoupCondensate*)
		Example[{Options, RecoupCondensate, "RecoupCondensate controls whether the liquid that has been collected in the condensate container should be kept or disposed of:"},
			Lookup[ExperimentEvaporate[Object[Sample, "Evaporate Test DCM Sample2" <> $SessionUUID], RecoupCondensate -> True, Output -> Options], RecoupCondensate],
			True
		],
		(* CondensateSampleContainer *)
		Example[{Options, CondensateSampleContainer, "CondensateSampleContainer indicates the container into which condensate should be transferred if keeping it:"},
			Lookup[ExperimentEvaporate[Object[Sample, "Evaporate Test DCM Sample2" <> $SessionUUID], CondensateSampleContainer -> Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options], CondensateSampleContainer],
			ObjectP[Model[Container, Vessel, "250mL Glass Bottle"]]
		],
		Example[{Options, CondensateSampleContainer, "If not specified but RecoupCondensate is True, then CondensateSampleContainer is automatically set to the PreferredContainer of the input sample's volume:"},
			Lookup[ExperimentEvaporate[Object[Sample, "Evaporate Test DCM Sample2" <> $SessionUUID], RecoupCondensate -> True, Output -> Options], CondensateSampleContainer],
			ObjectP[Model[Container, Vessel, "50mL Tube"]]
		],
		(* CondenserTemperature *)
		Example[{Options,CondenserTemperature,"CondenserTemperature controls the temperature of the cooling fluid that flows through the rotovaps cooling coil:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], CondenserTemperature -> -15 Celsius, Output -> Options], CondenserTemperature],
			-15 Celsius
		],
		(* EvaporateUntilDry *)
		Example[{Options,EvaporateUntilDry,"EvaporateUntilDry indicates the protocol will conduct multiple evaporations until the sample is dry or MaxEvaporationTime is reach, whichever comes first:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], EvaporateUntilDry -> True, Output -> Options], EvaporateUntilDry],
			True
		],
		(* MaxEvaporationTime *)
		Example[{Options,MaxEvaporationTime,"MaxEvaporationTime controls how much time may elapse before the protocol halts trying to dry the samples. The actual evaporation time may be longer if EvaporationTime does not divide evenly into MaxEvaporationTime:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], MaxEvaporationTime -> 24 Hour, Output -> Options], MaxEvaporationTime],
			24 Hour
		],
		Example[{Options,MaxEvaporationTime,"If EvaporateUntilDry -> True and MaxEvaporationTime -> Automatic, it will default to 3x the EvaporationTime:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], MaxEvaporationTime -> Automatic, EvaporateUntilDry -> True, EvaporationTime -> 15Minute, PressureRampTime -> 7*Minute, Output -> Options], MaxEvaporationTime],
			66 Minute
		],
		(* EvaporationFlask *)
		Example[{Options,EvaporationFlask,"EvaporationFlask controls which container will hold material during a rotovap evaporation protocol:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], EvaporationFlask -> Model[Container,Vessel,"1L Pear Shaped Flask with 24/40 Joint"], Output -> Options], EvaporationFlask],
			ObjectP[Model[Container,Vessel,"1L Pear Shaped Flask with 24/40 Joint"]],
			TimeConstraint->600
		],
		(* EvaporationPressure *)
		Example[{Options,EvaporationPressure,"EvaporationPressure controls the vacuum pressure the instrument will hold during the evaporation:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], EvaporationPressure -> 50 Milli Bar, Output -> Options], EvaporationPressure],
			50 Milli Bar,
			EquivalenceFunction->Equal
		],
		Example[{Options,EvaporationPressure,"EvaporationPressure -> MaxVacuum indicates the instrument will attempt to get the pressure as low as possible. The actual vacuum pressure achieved may very depending on the instrument:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], EvaporationPressure -> MaxVacuum, Output -> Options], EvaporationPressure],
			0.` Milli Bar,
			EquivalenceFunction->Equal
		],
		Example[{Options,EvaporationPressure,"EvaporationPressure is automatically set based on the predicted vapor pressure given EvaporationTemperature:"},
			Lookup[
				ExperimentEvaporate[Object[Sample,"Evaporate Test Mixed Water/DCM Sample 1"<>$SessionUUID],EvaporationType->RotaryEvaporation,EvaporationTemperature->30*Celsius,Output->Options],
				EvaporationPressure
			],
			PressureP
		],
		(* EvaporationTemperature *)
		Example[{Options,EvaporationTemperature,"EvaporationTemperature controls the temperature of the evaporation chamber for speedvac:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], EvaporationTemperature -> Ambient, EvaporationType -> SpeedVac, Output -> Options], EvaporationTemperature],
			25.`*Celsius
		],
		(* EvaporationTemperature *)
		Example[{Options,EvaporationTemperature,"EvaporationTemperature controls the temperature of the heatbath for rotovap experiments:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], EvaporationTemperature -> 50 Celsius, EvaporationPressure -> 30 Millibar, EvaporationType -> RotaryEvaporation, Output -> Options], EvaporationTemperature],
			50 Celsius
		],
		Example[{Options,EvaporationTemperature,"If using Rotovap, default to 25 Celsius:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], EvaporationType -> RotaryEvaporation, Output -> Options], EvaporationTemperature],
			EqualP[25 Celsius]
		],
		Example[{Options,EvaporationTemperature,"EvaporationTemperature controls the temperature of the heatbath or chamber of the nitrogen blower, depending on the instrument model:"},
			Lookup[ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], EvaporationTemperature -> 35 Celsius, EvaporationType -> NitrogenBlowDown, Output -> Options], EvaporationTemperature],
			35 Celsius
		],
		(* EvaporationType *)
		Example[{Options,EvaporationType,"EvaporationType controls what evaporation methodology and instrumentation will be used to evaporate the samples:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], EvaporationType -> SpeedVac, Output -> Options], EvaporationType],
			SpeedVac
		],
		Example[{Options,EvaporationType,"For each pool of samples provided, a different evaporation type may be specified:"},
			Lookup[ExperimentEvaporate[{{Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID]},{Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID]}}, EvaporationType -> {SpeedVac,RotaryEvaporation}, Output -> Options], EvaporationType],
			{SpeedVac,RotaryEvaporation}
		],

		(* Instrument *)
		Example[{Options,Instrument,"Instrument controls which evaporation type and instrument will be used during the run:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], Instrument -> Model[Instrument,VacuumCentrifuge,"id:n0k9mGzRal4w"], Output -> Options], {EvaporationType,Instrument}],
			{SpeedVac, Model[Instrument,VacuumCentrifuge,"id:n0k9mGzRal4w"]}
		],
		(* Method *)
		Example[{Options,VacuumEvaporationMethod,"Method which Object[Method,VacuumCentrifuge will be used to provide evaporation parameters for a SpeedVac evaporation protocol:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], VacuumEvaporationMethod -> Object[Method,VacuumEvaporation,"HPLCLyo"], Output -> Options], VacuumEvaporationMethod],
			ObjectReferenceP[Object[Method,VacuumEvaporation,"HPLCLyo"]]
		],
		(* PressureRampTime *)
		Example[{Options,PressureRampTime,"PressureRampTime controls how quickly an instrument attempts to achieve the EvaporationPressure:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], PressureRampTime -> 1 Hour, Output -> Options], PressureRampTime],
			1 Hour
		],
		(* RotationRate *)
		Example[{Options,RotationRate,"RotationRate determines the evaporation flask's revolution speed during a rotovap evaporation protocol:"}    ,
			Lookup[ExperimentEvaporate[
				{Object[Container,Vessel,"Evaporate Test 50mL 1"<>$SessionUUID],Object[Container,Vessel,"Evaporate Test 50mL 2"<>$SessionUUID]},
				EvaporationType->{RotaryEvaporation,RotaryEvaporation},
				EvaporationFlask->{Model[Container,Vessel,"500mL Pear Shaped Flask with 24/40 Joint"],Model[Container,Vessel,"1L Pear Shaped Flask with 24/40 Joint"]},
				Output->Options
			],RotationRate],
			{150*RPM,80*RPM},
			EquivalenceFunction->Equal
		],
		Example[{Options,RotationRate,"RotationRate is automatically set based on the size of the EvaporationFlask option:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], RotationRate -> 10 RPM, Output -> Options], RotationRate],
			10 RPM
		],
		(* SolventBoilingPoints *)
		Example[{Options,SolventBoilingPoints,"SolventBoilingPoints aids the resolution of Method by indicating at what temperatures the samples are likely to evaporate at:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], SolventBoilingPoints -> 40.` Celsius, Output -> Options], SolventBoilingPoints],
			{(40.`Celsius)..}
		],
		Example[{Options,SolventBoilingPoints,"SolventBoilingPoints can also accept High, Medium, and Low for cases where exact boiling point is unknow but can be easily generalized:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], SolventBoilingPoints -> High, Output -> Options], SolventBoilingPoints],
			{High..}(* TODO: Should this not return this? *)
		],
		Example[{Options,SolventBoilingPoints,"SolventBoilingPoints can also accept High, Medium, and Low for cases where exact boiling point is unknow but can be easily generalized:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], SolventBoilingPoints -> {High}, Output -> Options], SolventBoilingPoints],
			{High..}(* TODO: Should this not return this? *)
		],
		(* EquilibrationTime *)
		Example[{Options,EquilibrationTime,"EquilibrationTime controls how long the samples should sit on the instrument to equilibrate to the EvaporationTemperature:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], EquilibrationTime -> 10 Minute, Output -> Options], EquilibrationTime],
			10 Minute
		],
		(* PressureRampTime *)
		Test["Function initializes FullyEvaporated to a list of Nulls equal in length to the length of PooledSamplesIn:",
			Download[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID]], FullyEvaporated],
			{Repeated[Null,6]}(* This number will have to change if we add samples to the Evaporate Test Plate test obj *),
			TimeConstraint->600
		],
		Test["Instrument option controls which evaporation type and instrument will be used during the run:",
			Lookup[
				Quiet[
					ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], Instrument -> Object[Instrument,VacuumCentrifuge,"id:Vrbp1jG80P6O"], Output -> Options],
					Warning::InstrumentUndergoingMaintenance
				],
				{EvaporationType,Instrument}
			],
			{SpeedVac, Object[Instrument,VacuumCentrifuge,"id:Vrbp1jG80P6O"]}
		],
		(* EvaporationTime *)
		Example[{Options,EvaporationTime,"EvaporationTime controls how long the samples undergo Evaporation for:"},
			Lookup[ExperimentEvaporate[Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID], EvaporationTime -> 500 Minute, Output -> Options], EvaporationTime],
			500 Minute
		],
		(* FlowRateProfile *)
		Example[{Options,FlowRateProfile,"FlowRateProfile gives a list of {flow rates, times} for the NitrogenBlowDown instruments:"},
			Lookup[
				Quiet[
					ExperimentEvaporate[Object[Container, Vessel, "Evaporate Test 50mL 2" <> $SessionUUID],
						Instrument->Object[Instrument,Evaporator,"id:kEJ9mqRxKARz"],
						FlowRateProfile -> {{2Liter/Minute,60 Minute},{3 Liter/Minute, 45 Minute}},
						Output -> Options],
					Warning::InstrumentUndergoingMaintenance
				],
				FlowRateProfile
			],
			{{2 Liter/Minute,60 Minute},{3 Liter/Minute, 45 Minute}}
		],

		(* Messages: errors and warnings *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentEvaporate[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentEvaporate[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentEvaporate[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentEvaporate[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "TurboVapFlowRate","The specified Flow Rates must be less than 5.5 Liter/Minute for the TubeDryer:"},
			Quiet[ExperimentEvaporate[Object[Container, Vessel, "Evaporate Test 50mL 1" <> $SessionUUID],
				Instrument->Object[Instrument,Evaporator,"id:kEJ9mqRxKARz"],
				FlowRateProfile -> {{6 Liter/Minute,60 Minute},{2 Liter/Minute, 45 Minute}}
			],Warning::InstrumentUndergoingMaintenance],
			$Failed,
			Messages:>{Error::InvalidOption, Error::TurboVapFlowRate, Warning::HighFlowRate}
		],

		Example[{Messages, "FlowRateProfileLength", "If FlowRateProfile is specified, it's length is less than 3:"},
			Quiet[ExperimentEvaporate[Object[Sample, "Evaporate Test Water Sample 50mL Tube" <> $SessionUUID],
				Instrument -> Object[Instrument, Evaporator, "id:kEJ9mqRxKARz"],
				FlowRateProfile -> {{1 Liter / Minute, 60 Minute}, {2 Liter / Minute, 45 Minute}, {3 Liter / Minute, 30 Minute}, {3.5 Liter / Minute, 30 Minute}}
			], Warning::InstrumentUndergoingMaintenance],
			$Failed,
			Messages :> {Error::InvalidOption, Error::FlowRateProfileLength},
			TimeConstraint -> 600
		],

		Example[{Messages, "HighFlowRate","If the FlowRateProfile is specified, and the sample volume is > 60% of the sample container's maximum volume, then the flow rate is not too high:"},
			Quiet[ExperimentEvaporate[Object[Sample, "Evaporate Test DCM Sample2" <> $SessionUUID],
				Instrument->Object[Instrument,Evaporator,"id:kEJ9mqRxKARz"],
				FlowRateProfile -> {{5 Liter/Minute,60 Minute},{2 Liter/Minute, 45 Minute}}
			],Warning::InstrumentUndergoingMaintenance],
			ObjectP[Object[Protocol,Evaporate]],
			Messages:>{Warning::HighFlowRate}
		],

		Example[{Messages, "EvaporationFlowRateProfileTimeConflict","The sum of the times in FlowRateProfile and EvaporationTime must be equal:"},
			Quiet[ExperimentEvaporate[Object[Sample, "Evaporate Test DCM Sample2" <> $SessionUUID],
				Instrument->Object[Instrument,Evaporator,"id:kEJ9mqRxKARz"],
				FlowRateProfile -> {{2 Liter/Minute,60 Minute},{2 Liter/Minute, 45 Minute}},
				EvaporationTime->60 Minute
			],Warning::InstrumentUndergoingMaintenance],
			$Failed,
			Messages:>{Error::EvaporationFlowRateProfileTimeConflict,Error::InvalidOption}
		],

		Example[{Messages, "EvaporateTemperatureGreaterThanSampleBoilingPoint","The EvaporationTemperature should be less than the resolved solvent boiling point:"},
			Quiet[ExperimentEvaporate[Object[Sample, "Evaporate Test DCM Sample2" <> $SessionUUID],
				Instrument->Object[Instrument,Evaporator,"id:kEJ9mqRxKARz"],
				EvaporationTemperature-> 50 Celsius
			],Warning::InstrumentUndergoingMaintenance],
			ObjectP[Object[Protocol,Evaporate]],
			Messages:>{Warning::EvaporateTemperatureGreaterThanSampleBoilingPoint},
			TimeConstraint->600
		],

		Example[{Messages, "CannotComputeEvaporationPressure", "If rotovapping and EvaporationPressure is not set, throw an error if we can't compute the VaporPressure from the samples' Composition VaporPressures:"},
			ExperimentEvaporate[
				Object[Sample, "Evaporate Test Sample with ambiguous Composition" <> $SessionUUID],
				EvaporationType -> RotaryEvaporation
			],
			$Failed,
			Messages:>{Error::CannotComputeEvaporationPressure, Error::InvalidOption}
		],
		Example[{Messages, "CannotComputeEvaporationPressure", "If rotovapping and boiling point for a certain component is not set, throw an error if we can't compute the VaporPressure from the samples' Composition VaporPressures:"},
			ExperimentEvaporate[
				Object[Sample, "Evaporate Test Mixed Water/DCM Sample 2" <> $SessionUUID],
				EvaporationType -> RotaryEvaporation,
				EvaporationTemperature -> 30 Celsius
			],
			$Failed,
			Messages:>{Error::CannotComputeEvaporationPressure, Error::InvalidOption}
		],
		Example[{Messages, "IncompatibleBumpTrapVolume", "If rotovapping and BumpTrapRinseVolume is higher than the model of BumpTrapSampleContainer's MaxVolume, indicate that there is a conflict with an error:"},
			ExperimentEvaporate[
				Object[Sample, "Evaporate Test Mixed Water/DCM Sample 2" <> $SessionUUID],
				EvaporationType -> RotaryEvaporation,
				BumpTrapRinseVolume -> 10 Milliliter,
				BumpTrapSampleContainer -> Model[Container, Vessel, "id:eGakld01zzpq"] (* "1.5mL Tube with 2mL Tube Skirt" *)
			],
			$Failed,
			Messages:>{Error::IncompatibleBumpTrapVolume, Error::InvalidOption}
		],



		(* TODO: Add a test to make sure BumpTrap resources are shared between BumpTraps and BatchedEvapParams *)
		(* TODO: Add a test to make sure EvaporationFlasks resources are shared between BumpTraps and BatchedEvapParams *)
		(* TODO: Add a test to make sure CondensationFlasks resources are shared between BumpTraps and BatchedEvapParams *)
		(* TODO: Add a test to make sure BumpTrapRinseSolution resources are shared between BumpTraps and BatchedEvapParams *)

		(* TODO: Add a test to make sure EvapFlasks used during SamplePrep can be used as EvaporationFlask *)


		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		(* ------------ FUNTOPIA SHARED OPTION TESTING ------------ *)
		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		Example[{Options,PreparatoryUnitOperations,"Transfer water to a tube and make sure the amount transfer matches what was requested:"},
			ExperimentEvaporate[
				"My 2mL Tube",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 2mL Tube",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My 2mL Tube",
						Amount -> 1.75 Milliliter
					]
				}
			],
			ObjectP[Object[Protocol,Evaporate]],
			TimeConstraint->1000
		],
		Example[
			{Options,PreparatoryUnitOperations,"Add ethanol to a 50 milliliter tube, fill to 45 milliliters with dH2O, and then measure the volume:"},
			ExperimentEvaporate[
				{"My 50mL Tube"},
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 50mL Tube",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> {Model[Sample, "id:Y0lXejGKdEDW"]},
						Destination -> "My 50mL Tube",
						Amount -> 7.5 Milliliter
					],
					FillToVolume[
						Sample -> "My 50mL Tube",
						Solvent -> Model[Sample, "id:8qZ1VWNmdLBD"],
						TotalVolume -> 45 Milliliter
					],
					Mix[
						Sample -> "My 50mL Tube",
						MixType -> Vortex
					]
				}
			],
			TimeConstraint->1000,
			ObjectP[Object[Protocol,Evaporate]]
		],
		Example[
			{Options,PreparatoryUnitOperations,"Add a stocksolution to a bottle for preparation, then aliquot from it and measure the volume on those aliquots:"},
			ExperimentEvaporate[
				{"My 4L Bottle","My 4L Bottle","My 4L Bottle"},
				EvaporationType->RotaryEvaporation,
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 4L Bottle",
						Container -> Model[Container, Vessel, "Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> {Model[Sample, StockSolution, "id:R8e1PjpR1k0n"]},
						Destination -> "My 4L Bottle",
						Amount -> 0.35 Liter
					]
				},
				Aliquot -> True,
				AssayVolume -> {45 Milliliter, 45 Milliliter, 30 Milliliter},
				AliquotContainer -> {
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"]
				}
			],
			ObjectP[Object[Protocol,Evaporate]]
		],
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], EvaporationType->RotaryEvaporation,IncubateAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentEvaporate[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
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
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentEvaporate[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, Evaporate]]
		],
		(* ExperimentCentrifuge *)
		(*Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50 mL"], EvaporationType->RotaryEvaporation,CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], EvaporationType->RotaryEvaporation,CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], EvaporationType->RotaryEvaporation,CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], EvaporationType->RotaryEvaporation,CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], EvaporationType->RotaryEvaporation,CentrifugeAliquot -> 0.1*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			0.1*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID],EvaporationType->RotaryEvaporation, CentrifugeAliquotContainer -> Model[Container, Vessel, "15mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "15mL Tube"]]},
			Variables :> {options}
		],*)

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		(*Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1000 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1000 Syringe Pump"]],
			Variables :> {options}
		],*)
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], Filter -> Model[Container,Vessel, Filter, "BottleTop Filter, PES, 0.22um, 250mL"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Container,Vessel, Filter, "BottleTop Filter, PES, 0.22um, 250mL"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], FilterMaterial->PTFE, PrefilterPoreSize -> 1.*Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		(*Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"],Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],*)
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"],Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(*Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID], EvaporationType->RotaryEvaporation,FiltrationType -> Centrifuge, FilterTemperature -> 30*Celsius, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"], Output -> Options];
			Lookup[options, FilterTemperature],
			30*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],*)
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], FilterAliquot -> 20*Milliliter, Output -> Options];
			Convert[Lookup[options, FilterAliquot],Milliliter],
			20.*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], FilterAliquotDestinationWell->"A1",Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], EvaporationType->SpeedVac,Aliquot -> True, AssayVolume->25 Milliliter, Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(*Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Test Plate Sample 3"], TargetConcentration -> 5*Micromolar, AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Convert[Lookup[options, TargetConcentration],Micromolar],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],*)
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test DCM Sample2" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test DCM Sample2" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test DCM Sample2" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], EvaporationType->SpeedVac,Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], AliquotContainer -> Model[Container,Vessel,"50mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{_Integer, ObjectP[Model[Container, Vessel, "50mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, Name, "Specify the Name of the created Evaporate object:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], Name -> "My special Evaporate object name", Output -> Options];
			Lookup[options, Name],
			"My special Evaporate object name",
			Variables :> {options}
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], EvaporationType->RotaryEvaporation, IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID],  EvaporationType->RotaryEvaporation, CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID],  EvaporationType->RotaryEvaporation, FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell, "Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options, MeasureVolume, "Indicate whether samples should be volume measured afterwards:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], MeasureVolume->False, Output -> Options];
			Lookup[options, MeasureVolume],
			False,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicate whether samples should be weighed afterwards:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID], MeasureWeight->False, Output -> Options];
			Lookup[options, MeasureWeight],
			False,
			Variables :> {options}
		],

		Example[{Options, Template, "Use a previous Evaporate protocol as a template for a new one:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID],
			Template->Object[Protocol, Evaporate,"Parent Protocol for ExperimentEvaporate testing" <> $SessionUUID],
			Output -> Options];
			Lookup[options, Template],
			ObjectP[Object[Protocol,Evaporate]],
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,SamplesOutStorageCondition, "Indicates how the output samples of the experiment should be stored:"},
			options = ExperimentEvaporate[Object[Sample, "Evaporate Test Water Sample" <> $SessionUUID], SamplesOutStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		
		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Messages :> {Error::NoTransferContainerFound,Error::InvalidInput},
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentEvaporate[Object[Sample, "Evaporate Test Water Sample" <> $SessionUUID], CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::TotalAliquotVolumeTooLarge},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentEvaporate[Object[Sample, "Evaporate Test Water Sample" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentEvaporate[Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentEvaporate[Object[Sample, "Evaporate Test Water Sample" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"],Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentEvaporate[Object[Sample, "Evaporate Test Water Sample" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"], Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentEvaporate[Object[Sample,"Test 40mer DNA oligomer for ExperimentEvaporate tests" <> $SessionUUID], AssayVolume -> 30 Milliliter, TargetConcentration -> 2.5*Micromolar, Output -> Options];
			Convert[Lookup[options, TargetConcentration],Micromolar],
			2.5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=ExperimentEvaporate[Object[Sample,"Test 40mer DNA oligomer for ExperimentEvaporate tests" <> $SessionUUID],TargetConcentration->1*Micromolar,TargetConcentrationAnalyte->Model[Molecule,Oligomer,"Test 40mer DNA Model Molecule for ExperimentEvaporate tests" <> $SessionUUID],AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,Oligomer,"Test 40mer DNA Model Molecule for ExperimentEvaporate tests" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Additional, "Make sure clamp resources are populated correctly for RotaryEvaporation:"},
			protocol = ExperimentEvaporate[
				{Object[Container, Vessel, "Evaporate Test 50mL 1"<>$SessionUUID], Object[Container, Vessel, "Evaporate Test 50mL 2"<>$SessionUUID], Object[Container, Plate, "Evaporate Test Plate"<>$SessionUUID]},
				EvaporationType -> {RotaryEvaporation, RotaryEvaporation, NitrogenBlowDown},
				Upload -> True
			];
			clampResource = Cases[Download[protocol, RequiredResources], {resource_, CondensationFlaskClamp|EvaporationFlaskClamp, _, _} :> resource];
			MatchQ[
				Download[clampResource, {Models[[1]], Amount}],
				{OrderlessPatternSequence[
					{ObjectP[Model[Part, Clamp, "Stainless Pinch Locking Clamp for 35/20, 35/25 Ball Joint"]],Null},
					{ObjectP[Model[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint"]],4*Unit}
				]}
			],
			True,
			Variables :> {protocol, clampResource}
		],
		Example[{Additional,"Generate different volumes of BathFluid resources based on different evaporation flask we are using:"},
			protocol=ExperimentEvaporate[
				{
					Object[Container,Vessel,"Evaporate Test 50mL 1"<>$SessionUUID],
					Object[Container,Vessel,"Evaporate Test 50mL 2"<>$SessionUUID]
				},
				EvaporationType->{RotaryEvaporation,RotaryEvaporation},
				EvaporationFlask->{
					Model[Container,Vessel,"500mL Pear Shaped Flask with 24/40 Joint"],
					Object[Container,Vessel,"Evaporate Test 500mL Pear Shaped Flask"<>$SessionUUID]
				}
			];
			Download[Cases[Download[protocol,RequiredResources],{resource_,BatchedEvaporationParameters,_,BathFluid}:>resource],Amount],
			{SafeRound[-1.2214*500 Milliliter+5375 Milliliter,50 Milliliter],SafeRound[-1.2214*500 Milliliter+5375 Milliliter,50 Milliliter]},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Additional,"Always populate EvaporationPressureProfile and EvaporationPressureProfileImage when we are doing RotaryEvaporation:"},
			protocol=ExperimentEvaporate[
				{
					Object[Container,Vessel,"Evaporate Test 50mL 1"<>$SessionUUID],
					Object[Container,Vessel,"Evaporate Test 50mL 2"<>$SessionUUID]
				},
				EvaporationType->{RotaryEvaporation,NitrogenBlowDown},
				EvaporationFlask->{
					Model[Container,Vessel,"500mL Pear Shaped Flask with 24/40 Joint"],
					Automatic
				}
			];
			Lookup[Download[protocol,BatchedEvaporationParameters],{EvaporationType,EvaporationPressureProfile,EvaporationPressureProfileImage}],
			{
				{RotaryEvaporation,{{GreaterEqualP[0 Milli Bar],GreaterEqualP[0*RPM],GreaterEqualP[0 Minute]}..},ObjectP[Object[EmeraldCloudFile]]},
				{NitrogenBlowDown,Null,Null}
			},
			Variables:>{protocol}
		],
		Example[{Additional,"Make sure we return the packet of EmeraldCloudFile object that we are uploading in the output when Upload->False:"},
			protocol=ExperimentEvaporate[
				{
					Object[Container,Vessel,"Evaporate Test 50mL 1"<>$SessionUUID],
					Object[Container,Vessel,"Evaporate Test 50mL 2"<>$SessionUUID]
				},
				EvaporationType->{RotaryEvaporation,RotaryEvaporation},
				EvaporationFlask->{
					Model[Container,Vessel,"500mL Pear Shaped Flask with 24/40 Joint"],
					Automatic
				},
				Upload->False
			];
			Count[protocol,PacketP[Object[EmeraldCloudFile]]],
			2,
			Variables:>{protocol}
		]
	},
	SymbolSetUp:>{
		$CreatedObjects = {};
		ClearMemoization[];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"Evaporate Test Plate" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Immobile Container" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Non Immobile Container" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Non Immobile Container 2" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Immobile Container 2" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Test 50mL 1" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Test 50mL 2" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Test 50mL 3" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Test 50mL 4" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Test 50mL 5" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Test 50mL 6" <> $SessionUUID],
				Object[Container,Vessel,"Evaporate Test 500mL Pear Shaped Flask" <> $SessionUUID],
				Object[Container,Bench, "Testing bench for Evaporate" <> $SessionUUID],
				Object[Sample,"Evaporate Test Water Sample" <> $SessionUUID],
				Object[Sample,"Evaporate Test Water Sample2" <> $SessionUUID],
				Object[Sample,"Evaporate Test Water Sample3" <> $SessionUUID],
				Object[Sample,"Evaporate Test Water Sample4" <> $SessionUUID],
				Object[Sample,"Evaporate Test Water Sample5" <> $SessionUUID],
				Object[Sample,"Evaporate Test DCM Sample2" <> $SessionUUID],
				Object[Sample,"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID],
				Object[Protocol,Evaporate,"Parent Protocol for ExperimentEvaporate testing" <> $SessionUUID],
				Object[Sample,"Evaporate Test Water Sample Severed Model" <> $SessionUUID],
				Model[Sample,"Test 40mer DNA oligomer sample model for ExperimentEvaporate tests" <> $SessionUUID],
				Object[Sample,"Test 40mer DNA oligomer for ExperimentEvaporate tests" <> $SessionUUID],
				Model[Molecule,Oligomer,"Test 40mer DNA Model Molecule for ExperimentEvaporate tests" <> $SessionUUID],
				Model[Molecule, "Test Model Molecule with Unknown BoilingPoint/VaporPressure for ExperimentEvaporate" <> $SessionUUID],
				Object[Sample, "Evaporate Test Sample with ambiguous Composition" <> $SessionUUID],
				Object[Sample, "Evaporate Test Mixed Water/DCM Sample 1" <> $SessionUUID],
				Object[Sample, "Evaporate Test Mixed Water/DCM Sample 2" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Block[
			{
				$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"], (* steven *)
				$Notebook = Object[LaboratoryNotebook, "id:rea9jlRZkrjx"], (*Steven Test*)
				$DeveloperUpload = True
			},
			Module[
				{testBench,testPlate,fiftyMLtube1,fiftyMLtube2,fiftyMLtube3,fiftyMLtube4,fiftyMLtube5,fiftyMLtube6,sampleModel,waterSample,
					waterSample2,waterSample3,waterSample4,waterSample5,waterSample6,dcmSamp2,waterSampleModelSevered,
					dnaSample,myMV2mLSet,myMV2mLTubes,immobileSetUp,immobileSetUp2, ambiguousCompositionSample, evaporationFlask, mixedCompSample1, mixedCompSample2},

				testBench=Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Testing bench for Evaporate" <> $SessionUUID,
					Site -> Link[$Site],
					DeveloperObject -> True
				|>];

				(* Create some containers *)
				{
					testPlate,
					fiftyMLtube1,
					fiftyMLtube2,
					fiftyMLtube3,
					fiftyMLtube4,
					fiftyMLtube5,
					fiftyMLtube6
				}=Upload[{
					<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Evaporate Test Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"Evaporate Test 50mL 1"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"Evaporate Test 50mL 2"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"Evaporate Test 50mL 3"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"Evaporate Test 50mL 4"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"Evaporate Test 50mL 5"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"Evaporate Test 50mL 6"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>
				}];

				(* Create Oligomer Molecule ID Models for the test samples' Composition field *)
				Upload[{
					<|
						Type->Model[Molecule,Oligomer],
						Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A","T","G","C"},10]]]],
						PolymerType->DNA,
						Name->"Test 40mer DNA Model Molecule for ExperimentEvaporate tests"<>$SessionUUID,
						MolecularWeight->12295.9*(Gram/Mole),
						DeveloperObject->True
					|>,
					<|
						Type->Model[Molecule],
						State->Liquid,
						Name->"Test Model Molecule with Unknown BoilingPoint/VaporPressure for ExperimentEvaporate"<>$SessionUUID,
						DeveloperObject->True
					|>
				}];

				sampleModel=UploadSampleModel[
					{"Test 40mer DNA oligomer sample model for ExperimentEvaporate tests"<>$SessionUUID},
					Composition->{{
						{20 * Micromolar,Model[Molecule,Oligomer,"Test 40mer DNA Model Molecule for ExperimentEvaporate tests"<>$SessionUUID]}
					}},
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					Flammable->False,
					Acid->False,
					Base->False,
					Pyrophoric->False,
					Expires->False,
					State->Liquid,
					BiosafetyLevel->"BSL-1",
					MSDSRequired->False,
					IncompatibleMaterials->{None}
				];

				(* Create some samples *)
				{
					waterSample,
					waterSample2,
					waterSample3,
					waterSample4,
					waterSample5,
					waterSample6,
					dcmSamp2,
					waterSampleModelSevered,
					dnaSample,
					ambiguousCompositionSample,
					mixedCompSample1,
					mixedCompSample2,
					evaporationFlask
				}=ECL`InternalUpload`UploadSample[
					{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Dichloromethane, Anhydrous"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Test 40mer DNA oligomer sample model for ExperimentEvaporate tests"<>$SessionUUID],
						{{Null, Null}},
						{{50*VolumePercent,Model[Molecule,"id:9RdZXv1l7lva"]},{50*VolumePercent,Model[Molecule,"id:vXl9j57PmP5D"]}},
						{{50*VolumePercent,Model[Molecule,"Test Model Molecule with Unknown BoilingPoint/VaporPressure for ExperimentEvaporate"<>$SessionUUID]},{50*VolumePercent,Model[Molecule,"id:vXl9j57PmP5D"]}},
						Model[Container, Vessel, "500mL Pear Shaped Flask with 24/40 Joint"]
					},
					{
						{"A1",testPlate},
						{"A2",testPlate},
						{"A3",testPlate},
						{"B1",testPlate},
						{"B2",testPlate},
						{"A1",fiftyMLtube1},
						{"A1",fiftyMLtube2},
						{"B3",testPlate},
						{"A1",fiftyMLtube3},
						{"A1",fiftyMLtube4},
						{"A1",fiftyMLtube5},
						{"A1",fiftyMLtube6},
						{"Bench Top Slot",testBench}
					},
					InitialAmount->{
						10 Microliter,
						100 Microliter,
						1 Milliliter,
						1.9 Milliliter,
						1.5 Milliliter,
						30 Milliliter,
						45 Milliliter,
						1.7 Milliliter,
						30 Milliliter,
						20 Milliliter,
						20 Milliliter,
						20 Milliliter,
						Null
					},
					Name -> {
						"Evaporate Test Water Sample" <> $SessionUUID,
						"Evaporate Test Water Sample2" <> $SessionUUID,
						"Evaporate Test Water Sample3" <> $SessionUUID,
						"Evaporate Test Water Sample4" <> $SessionUUID,
						"Evaporate Test Water Sample5" <> $SessionUUID,
						"Evaporate Test Water Sample 50mL Tube" <> $SessionUUID,
						"Evaporate Test DCM Sample2" <> $SessionUUID,
						"Evaporate Test Water Sample Severed Model" <> $SessionUUID,
						"Test 40mer DNA oligomer for ExperimentEvaporate tests" <> $SessionUUID,
						"Evaporate Test Sample with ambiguous Composition" <> $SessionUUID,
						"Evaporate Test Mixed Water/DCM Sample 1" <> $SessionUUID,
						"Evaporate Test Mixed Water/DCM Sample 2" <> $SessionUUID,
						"Evaporate Test 500mL Pear Shaped Flask" <> $SessionUUID
					},
					StorageCondition->AmbientStorage
				];

				(* Secondary uploads *)
				Upload[{
					<|Object->waterSample,DeveloperObject->True|>,
					<|Object->waterSample2,DeveloperObject->True|>,
					<|Object->waterSample3,DeveloperObject->True|>,
					<|Object->waterSample4,DeveloperObject->True|>,
					<|Object->waterSample5,DeveloperObject->True|>,
					<|Object->waterSample6,DeveloperObject->True|>,
					<|Object->dcmSamp2,DeveloperObject->True|>,
					<|Object->waterSampleModelSevered,DeveloperObject->True,Model->Null|>,
					<|Object->dnaSample,DeveloperObject->True,Model->Null|>,
					<|Object->ambiguousCompositionSample, DeveloperObject -> True|>
				}];

				(* Upload 50 2ml tubes for batching checks *)
				myMV2mLSet=ConstantArray[
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],DeveloperObject->True|>,
					50
				];

				myMV2mLTubes=Upload[myMV2mLSet];

				ECL`InternalUpload`UploadSample[
					ConstantArray[Model[Sample,"Milli-Q water"],Length[myMV2mLTubes]],
					{"A1",#}&/@myMV2mLTubes,
					InitialAmount->ConstantArray[300 * Microliter,Length[myMV2mLTubes]],
					StorageCondition->Refrigerator
				];

				immobileSetUp=Module[{modelVesselID,model,vessel1,vessel2,protocol},

					modelVesselID=CreateID[Model[Container,Vessel]];
					{model,vessel1,vessel2,protocol}=Upload[{
						<|
							Object->modelVesselID,
							Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->.1 Meter,MaxDepth->.1 Meter,MaxHeight->.1 Meter|>},
							Immobile->True
						|>,
						<|
							Type->Object[Container,Vessel],
							Model->Link[modelVesselID,Objects],
							DeveloperObject->True,
							Site->Link[$Site],
							Name->"Evaporate Immobile Container"<>$SessionUUID
						|>,
						<|
							Type->Object[Container,Vessel],
							Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
							DeveloperObject->True,
							Site->Link[$Site],
							Name->"Evaporate Non Immobile Container"<>$SessionUUID
						|>,
						<|
							Type->Object[Protocol,Evaporate],
							Name->"Parent Protocol for ExperimentEvaporate testing"<>$SessionUUID,
							Site->Link[$Site]
						|>
					}];

					UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
				];

				immobileSetUp2=Module[{modelVesselID,model,vessel1,vessel2},

					modelVesselID=CreateID[Model[Container,Vessel]];
					{model,vessel1,vessel2}=Upload[{
						<|
							Object->modelVesselID,
							Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->.1 Meter,MaxDepth->.1 Meter,MaxHeight->.1 Meter|>},
							Immobile->True
						|>,
						<|
							Type->Object[Container,Vessel],
							Model->Link[modelVesselID,Objects],
							DeveloperObject->True,
							Name->"Evaporate Immobile Container 2"<>$SessionUUID,
							Site->Link[$Site],
							TareWeight->10 Gram
						|>,
						<|
							Type->Object[Container,Vessel],
							Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
							DeveloperObject->True,
							Site->Link[$Site],
							Name->"Evaporate Non Immobile Container 2"<>$SessionUUID,
							TareWeight->10 Gram
						|>
					}];

					UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
				];

				Off[Warning::DeprecatedProduct];
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];
			]
		]
	},
	Stubs :> {
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"], (* steven *)
		$Notebook = Object[LaboratoryNotebook, "id:rea9jlRZkrjx"] (*Steven Test*)
	},

	SymbolTearDown :> {
		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];

		On[Warning::DeprecatedProduct];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

	}
];
