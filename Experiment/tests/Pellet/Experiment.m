(* ::Package:: *)
 
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentPellet*)


DefineTests[ExperimentPellet,
	{
		Example[{Basic, "Precipitate any solids in the solution and aspirate off the supernatant:"},
			ExperimentPellet[
				{Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPellet"<>$SessionUUID]},
				SupernatantVolume->All,
				Preparation->Manual
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint->10000
		],
		Example[{Basic, "Precipitate any solids in the solution, aspirate off the supernatant, then resuspend in 10 mL of Milli-Q water:"},
			ExperimentPellet[
				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
				SupernatantVolume->All,
				SupernatantDestination->Waste,
				ResuspensionSource->Model[Sample, "Milli-Q water"],
				ResuspensionVolume->10 Milliliter
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Specify that vortexing should occur after resuspension:"},
			ExperimentPellet[
				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
				SupernatantVolume->All,
				SupernatantDestination->Waste,
				ResuspensionSource->Model[Sample, "Milli-Q water"],
				ResuspensionVolume->10 Milliliter,
				ResuspensionMixType->Vortex
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Precipitate any solids in the solution, aspirate off the supernatant, then resuspend in 10 mL of Milli-Q water:"},
			ExperimentPellet[
				{"A1", Object[Container,Vessel,"Test container 1 for ExperimentPellet"<>$SessionUUID]},
				SupernatantVolume->All,
				Preparation->Manual
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Precipitate any solids in the solution, aspirate off the supernatant, then resuspend in 10 mL of Milli-Q water:"},
			ExperimentPellet[
				{{"A1", Object[Container,Vessel,"Test container 1 for ExperimentPellet"<>$SessionUUID]},Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPellet"<>$SessionUUID]},
				SupernatantVolume->All,
				SupernatantDestination->Waste,
				ResuspensionSource->Model[Sample, "Milli-Q water"],
				ResuspensionVolume->10 Milliliter
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Additional, "Setting any of the resuspension options to Null will turn off the master switch:"},
			ExperimentPellet[
				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
				SupernatantVolume->All,
				SupernatantDestination->Waste,
				ResuspensionSource->Null,
				Output->Options
			],
			KeyValuePattern[{Resuspension->False}]
		],
		Example[{Additional, "Return the simulation packet when Output->Simulation:"},
			ExperimentPellet[
				{
					Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
					Object[Sample, "Test water sample in 50mL tube (2) for ExperimentPellet"<>$SessionUUID]
				},
				SupernatantVolume -> All,
				SupernatantDestination -> Waste,
				Output -> Simulation
			],
			SimulationP,
			TimeConstraint->1000
		],
		Example[{Additional, "Return the simulation packet for container inputs when Output->Simulation:"},
			ExperimentPellet[
				{
					Object[Container, Vessel, "Test container 1 for ExperimentPellet"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentPellet"<>$SessionUUID]
				},
				SupernatantVolume -> All,
				SupernatantDestination -> Waste,
				Output -> Simulation
			],
			SimulationP,
			TimeConstraint->1000
		],
		Example[{Additional, "Pellet can be used as the primitive head in ExperimentManualSamplePreparation:"},
			ExperimentManualSamplePreparation[
				{
					Pellet[
						Sample -> {
							Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
							Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPellet"<>$SessionUUID]
						},
						Time -> {1 Minute, 2 Minute},
						SampleLabel -> {"Test Label1", "Test Label2"},
						SampleContainerLabel -> {"Test Container Label 1", "Test Container Label 2"},
						ContainerOutLabel -> {"Test ContainerOut Label 1", "Test ContainerOut Label 2"},
						SampleOutLabel -> {"Test Out Label1", "Test Out Label2"},
						SupernatantVolume -> All
					]
				}
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint->1000
		],
		Example[{Additional, "Pellet can be used as the primitive head in ExperimentRoboticSamplePreparation:"},
			ExperimentRoboticSamplePreparation[
				{
					Pellet[
						Sample -> {Object[Container,Plate,"Test container 4 for ExperimentPellet"<>$SessionUUID]}
					]
				}
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			TimeConstraint->1000
		],
		Example[
			{Options,Instrument,"Specify the centrifuge that will be used to spin the provided samples:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Instrument->Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"],
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectP[Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"]],
			Variables:>{options}
		],
		Example[
			{Options,Instrument,"Specify the ultracentrifuge to pellet samples:"},
			protocol=ExperimentPellet[
				{
					Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]
				},
				AliquotAmount -> 8.6 Milliliter,
				AliquotContainer -> Model[Container, Vessel, "id:GmzlKjPen8z4"],
				Instrument -> Model[Instrument, Centrifuge, "id:lYq9jRxY9RzA"]
			];
			Lookup[Download[protocol,Centrifugation],Instrument],
			{ObjectP[Model[Instrument, Centrifuge, "id:lYq9jRxY9RzA"]]},
			Variables:>{protocol}
		],
		Example[
			{Options,SterileTechnique,"Specify whether SterileTechnique is to be employed when transferring the supernatant following pelleting the samples:"},
			protocol=ExperimentPellet[
				{
					Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]
				},
				AliquotAmount -> 8.6 Milliliter,
				AliquotContainer -> Model[Container, Vessel, "id:GmzlKjPen8z4"],
				SterileTechnique -> True
			];
			Download[protocol,SterileTechnique],
			{True},
			Variables:>{protocol}
		],
		Example[
			{Options,SterileTechnique,"If the sample being pelleted has cells in its composition, SterileTechnique is automatically set to True:"},
			protocol=ExperimentPellet[
				{
					Object[Sample,"Test cell sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]
				},
				AliquotAmount -> 8.6 Milliliter,
				AliquotContainer -> Model[Container, Vessel, "id:GmzlKjPen8z4"]
			];
			Download[protocol,SterileTechnique],
			{True},
			Variables:>{protocol}
		],
		Example[
			{Options,Intensity,"Specify the rotational speed or the force that will be applied to the samples by centrifugation in order to create a pellet:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Intensity->1000RPM,
				Output->Options
			];
			Lookup[options,Intensity],
			1000RPM,
			Variables:>{options}
		],
		Example[
			{Options,Intensity,"Specify the rotational speed or the force that will be applied to the samples by centrifugation in order to create a pellet:"},
			protocol=ExperimentPellet[
				{
					Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]
				},
				AliquotAmount -> 8.6 Milliliter,
				AliquotContainer -> Model[Container, Vessel, "id:GmzlKjPen8z4"],
				Intensity -> 50000 RPM
			];
			Lookup[Download[protocol,Centrifugation],{Instrument,Intensity}],
			{{ObjectP[Model[Instrument, Centrifuge, "id:lYq9jRxY9RzA"]],50000RPM}},
			Variables:>{options},
			EquivalenceFunction->RoundMatchQ[8]
		],
		Example[
			{Options,Time,"Specify the amount of time that the samples will be centrifuged:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Time->10Minute,
				Output->Options
			];
			Lookup[options,Time],
			10Minute,
			Variables:>{options}
		],
		Example[
			{Options,Temperature,"Specify the temperature at which the centrifuge chamber will be held while the samples are being centrifuged:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Temperature->20Celsius,
				Output->Options
			];
			Lookup[options,Temperature],
			20Celsius,
			Variables:>{options}
		],
		Example[
			{Options,SupernatantVolume,"Specify the amount of supernatant that will be aspirated from the source sample:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				SupernatantVolume->10Milliliter,
				Output->Options
			];
			Lookup[options,SupernatantVolume],
			10Milliliter,
			Variables:>{options},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SupernatantDestination,"Specify the destination that the supernatant should be dispensed into, after aspirated from the source sample:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				SupernatantDestination->Waste,
				Output->Options
			];
			Lookup[options,SupernatantDestination],
			Waste,
			Variables:>{options}
		],
		Example[
			{Options,Resuspension,"Specify if the pellet should be resuspended after the supernatant is aspirated:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Resuspension->False,
				Output->Options
			];
			Lookup[options,Resuspension],
			False,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionSource,"Specify the sample that should be used to resuspend the pellet from the source sample:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionSource->Model[Sample, "Milli-Q water"],
				Output->Options
			];
			Lookup[options,ResuspensionSource],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionVolume,"Specify the volume of ResuspensionSource that should be used to resuspend the pellet from the source sample:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionVolume->5Milliliter,
				Output->Options
			];
			Lookup[options,ResuspensionVolume],
			5Milliliter,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMix,"Specify if the source sample should be mixed after the pellet is resuspended:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMix->True,
				Output->Options
			];
			Lookup[options,ResuspensionMix],
			True,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixType,"Specify the type of instrument/motion used to mix the pellet after it has been resuspended:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixType->Pipette,
				Output->Options
			];
			Lookup[options,ResuspensionMixType],
			Pipette,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixUntilDissolved,"Specify if mixing should be continued up to the MaxTime/MaxNumberOfMixes, in an attempt dissolve the pellet:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixUntilDissolved->True,
				Output->Options
			];
			Lookup[options,ResuspensionMixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixInstrument,"Specify the instrument used to mix the pellet after resuspension. If mixing by pipette is specified, the same pipette used to resuspend the pellet will be used to mix the sample:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],
				Output->Options
			];
			Lookup[options,ResuspensionMixInstrument],
			Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixTime,"Specify duration of time for which the samples will be mixed:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixTime->10Minute,
				Output->Options
			];
			Lookup[options,ResuspensionMixTime],
			10Minute,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixMaxTime,"Specify Maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixMaxTime->20Minute,
				Output->Options
			];
			Lookup[options,ResuspensionMixMaxTime],
			20Minute,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixDutyCycle,"Specify how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed. This option can only be set when mixing via homogenization:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixDutyCycle->{1Minute,2Minute},
				Output->Options
			];
			Lookup[options,ResuspensionMixDutyCycle],
			{1Minute,2Minute},
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixRate,"Specify Frequency of rotation the mixing instrument should use to mix the samples:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixRate->1000RPM,
				Output->Options
			];
			Lookup[options,ResuspensionMixRate],
			1000RPM,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionNumberOfMixes,"Specify Number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionNumberOfMixes->4,
				Output->Options
			];
			Lookup[options,ResuspensionNumberOfMixes],
			4,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMaxNumberOfMixes,"Specify Maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMaxNumberOfMixes->5,
				Output->Options
			];
			Lookup[options,ResuspensionMaxNumberOfMixes],
			5,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixVolume,"Specify the volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixVolume->10Milliliter,
				Output->Options
			];
			Lookup[options,ResuspensionMixVolume],
			10Milliliter,
			Variables:>{options},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,ResuspensionMixTemperature,"Specify the temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixTemperature->30Celsius,
				Output->Options
			];
			Lookup[options,ResuspensionMixTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixMaxTemperature,"Specify the maximum temperature that the sample should reach during mixing via homogenization. If the measured temperature is above this MaxTemperature, the homogenizer will turn off until the measured temperature is 2C below the MaxTemperature, then it will automatically resume:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixMaxTemperature->40Celsius,
				Output->Options
			];
			Lookup[options,ResuspensionMixMaxTemperature],
			40Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ResuspensionMixAmplitude,"Specify the amplitude of the sonication horn when mixing via homogenization. When using a microtip horn (ex. for 2mL and 15mL tubes), the maximum amplitude is 70 Percent, as specified by the manufacturer, in order not to damage the instrument:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ResuspensionMixAmplitude->20Percent,
				Output->Options
			];
			Lookup[options,ResuspensionMixAmplitude],
			20Percent,
			Variables:>{options}
		],
		Example[
			{Options,Name,"Specify A object name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Name->"Test name",
				Output->Options
			];
			Lookup[options,Name],
			"Test name",
			Variables:>{options}
		],
		Example[
			{Options,PreparatoryPrimitives,"Specify a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSampleManipulation:"},
			ExperimentPellet["My test Sample",
				PreparatoryPrimitives-> {
					Define[
						Name -> "My test Sample",
						Container -> Model[Container, Vessel, "Narrow Mouth Plastic Reservoir Bottle, 30mL, for Xevo G2-XS QTOF"]
					],
					Consolidation[
						Sources -> {
							Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]
						},
						Destination -> "My test Sample",
						Amounts -> {3000 Microliter}
					]
				}
			],
			ObjectP[Object[Protocol,Pellet]],
			Messages:>{Warning::ContainerCentrifugeIncompatible}
		],
		Example[
			{Options,PreparatoryUnitOperations,"Specify a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSampleManipulation:"},
			ExperimentPellet["My test Sample",
				PreparatoryUnitOperations-> {
					LabelContainer[
						Label -> "My test Sample",
						Container -> Model[Container, Vessel, "Narrow Mouth Plastic Reservoir Bottle, 30mL, for Xevo G2-XS QTOF"]
					],
					Transfer[
						Source -> {
							Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]
						},
						Destination -> "My test Sample",
						Amount -> {3000 Microliter}
					]
				}
			],
			ObjectP[Object[Protocol,Pellet]],
			Messages:>{Warning::ContainerCentrifugeIncompatible}
		],
		Example[
			{Options,Incubate,"Specify if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Incubate->False,
				Output->Options
			];
			Lookup[options,Incubate],
			False,
			Variables:>{options}
		],
		Example[
			{Options,IncubationTemperature,"Specify temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				IncubationTemperature->30Celsius,
				Output->Options
			];
			Lookup[options,IncubationTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,IncubationTime,"Specify duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				IncubationTime->11Minute,
				Output->Options
			];
			Lookup[options,IncubationTime],
			11Minute,
			Variables:>{options}
		],
		Example[
			{Options,Mix,"Specify if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Mix->True,
				Output->Options
			];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[
			{Options,MixType,"Specify the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				MixType->Pipette,
				Output->Options
			];
			Lookup[options,MixType],
			Pipette,
			Variables:>{options}
		],
		Example[
			{Options,MixUntilDissolved,"Specify if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute. Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				MixUntilDissolved->True,
				Output->Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[
			{Options,MaxIncubationTime,"Specify Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				MaxIncubationTime->2Hour,
				Output->Options
			];
			Lookup[options,MaxIncubationTime],
			2Hour,
			Variables:>{options}
		],
		Example[
			{Options,IncubationInstrument,"Specify the instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				IncubationInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],
				Output->Options
			];
			Lookup[options,IncubationInstrument],
			Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],
			Variables:>{options}
		],
		Example[
			{Options,AnnealingTime,"Specify Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				AnnealingTime->10Minute,
				Output->Options
			];
			Lookup[options,AnnealingTime],
			10Minute,
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquotContainer,"Specify the desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				IncubateAliquotContainer->Model[Container, Vessel, "50mL Tube"],
				Output->Options
			];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquotDestinationWell,"Specify the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				IncubateAliquotDestinationWell->{"A1"},
				Output->Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				IncubateAliquot->10Milliliter,
				Output->Options
			];
			Lookup[options,IncubateAliquot],
			RangeP[9.9 Milliliter, 10.1 Milliliter],
			Variables:>{options}
		],
		Example[
			{Options,Centrifuge,"Specify if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Centrifuge->False,
				Output->Options
			];
			Lookup[options,Centrifuge],
			False,
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeInstrument,"Specify the centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],
				Output->Options
			];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeIntensity,"Specify the rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				CentrifugeIntensity->1000RPM,
				Output->Options
			];
			Lookup[options,CentrifugeIntensity],
			1000RPM,
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeTime,"Specify the amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				CentrifugeTime->11Minute,
				Output->Options
			];
			Lookup[options,CentrifugeTime],
			11Minute,
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeTemperature,"Specify the temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				CentrifugeTemperature->15Celsius,
				Output->Options
			];
			Lookup[options,CentrifugeTemperature],
			15Celsius,
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeAliquotContainer,"Specify the desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				CentrifugeAliquotContainer->Model[Container, Vessel, "50mL Tube"],
				Output->Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeAliquotDestinationWell,"Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				CentrifugeAliquotDestinationWell->{"A1"},
				Output->Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				CentrifugeAliquot -> 10Milliliter,
				Output->Options
			];
			Lookup[options,CentrifugeAliquot],
			10Milliliter,
			Variables:>{options},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,Filtration,"Specify if the SamplesIn should be filter prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Filtration->True,
				Output->Options
			];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[
			{Options,FiltrationType,"Specify the type of filtration method that should be used to perform the filtration:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Filtration->True,
				FiltrationType->Syringe,
				Output->Options
			];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[
			{Options,FilterInstrument,"Specify the instrument that should be used to perform the filtration:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Filtration->True,
				FilterInstrument->Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],
				Output->Options
			];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables:>{options}
		],
		Example[
			{Options,Filter,"Specify the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Filter->Model[Item, Filter, "id:n0k9mG8A5OJw"],
				Output->Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Item, Filter, "id:n0k9mG8A5OJw"]],
			Variables:>{options}
		],
		Example[
			{Options,FilterMaterial,"Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				Output->Options
			];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		Example[
			{Options,PrefilterMaterial,"Specify the material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				PrefilterMaterial->Null,
				Output->Options
			];
			Lookup[options,PrefilterMaterial],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,FilterPoreSize,"Specify the pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				Output->Options
			];
			Lookup[options,FilterPoreSize],
			0.22Micrometer,
			Variables:>{options}
		],
		Example[
			{Options,PrefilterPoreSize,"Specify the pore size of the filter; all particles larger than this should be removed during the filtration:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				PrefilterPoreSize->Null,
				Output->Options
			];
			Lookup[options,PrefilterPoreSize],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,FilterSyringe,"Specify the syringe used to force that sample through a filter:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],
				Output->Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables:>{options}
		],
		Example[
			{Options,FilterHousing,"Specify the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],
				FilterHousing->Null,
				Output->Options
			];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,FilterIntensity,"Specify the rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterIntensity->1000 RPM,
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				Output->Options
			];
			Lookup[options,FilterIntensity],
			1000 RPM,
			Variables:>{options}
		],
		Example[
			{Options,FilterTime,"Specify the amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterTime->10Minute,
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				Output->Options
			];
			Lookup[options,FilterTime],
			10Minute,
			Variables:>{options}
		],
		Example[
			{Options,FilterTemperature,"Specify the temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterTemperature->10 Celsius,
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				Output->Options
			];
			Lookup[options,FilterTemperature],
			10 Celsius,
			Variables:>{options}
		],
		Example[
			{Options,FilterContainerOut,"Specify the desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				FilterContainerOut->Model[Container, Vessel, "50mL Tube"],
				Output->Options
			];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables:>{options}
		],
		Example[
			{Options,FilterAliquotDestinationWell,"Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterMaterial -> PES, Filtration->True,
				FilterAliquot -> 100*Microliter,
				FilterPoreSize->0.22Micrometer,
				FilterAliquotDestinationWell->{"A1"},
				Output->Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[
			{Options,FilterAliquotContainer,"Specify the desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterAliquotContainer->Model[Container, Vessel, "50mL Tube"],
				Output->Options
			];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables:>{options}
		],
		Example[
			{Options,FilterAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterAliquot->10Milliliter,
				Output->Options
			];
			Lookup[options,FilterAliquot],
			10Milliliter,
			Variables:>{options},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,FilterSterile,"Specify if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				FilterSterile->True,
				Output->Options
			];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options}
		],
		Example[
			{Options,Aliquot,"Specify if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment. Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times. Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				Aliquot->False,
				Output->Options
			];
			Lookup[options,Aliquot],
			False,
			Variables:>{options}
		],
		Example[
			{Options,AliquotAmount,"Specify the amount of a sample that should be transferred from the input samples into aliquots:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				AliquotAmount->1Milliliter,
				Output->Options
			];
			Lookup[options,AliquotAmount],
			RangeP[0.9 Milliliter, 1.1 Milliliter],
			Variables:>{options}
		],
		Example[
			{Options,TargetConcentration,"Specify the desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				TargetConcentration->Null,
				Output->Options
			];
			Lookup[options,TargetConcentration],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,TargetConcentrationAnalyte,"Specify the substance whose final concentration is attained with the TargetConcentration option:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				TargetConcentrationAnalyte->Null,
				Output->Options
			];
			Lookup[options,TargetConcentrationAnalyte],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,AssayVolume,"Specify the desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				AssayVolume->40Milliliter,
				Output->Options
			];
			Lookup[options,AssayVolume],
			40Milliliter,
			Variables:>{options}
		],
		Example[
			{Options,ConcentratedBuffer,"Specify the concentrated buffer which should be diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ConcentratedBuffer->Null,
				Output->Options
			];
			Lookup[options,ConcentratedBuffer],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,BufferDilutionFactor,"Specify the dilution factor by which the concentrated buffer should be diluted in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				BufferDilutionFactor->Null,
				Output->Options
			];
			Lookup[options,BufferDilutionFactor],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,BufferDiluent,"Specify the buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution. The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				BufferDiluent->Null,
				Output->Options
			];
			Lookup[options,BufferDiluent],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,AssayBuffer,"Specify the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				AssayBuffer->Model[Sample, "Milli-Q water"],
				Output->Options
			];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options},
			Messages:>{Warning::BufferWillNotBeUsed}
		],
		Example[
			{Options,AliquotSampleStorageCondition,"Specify the non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				AliquotSampleStorageCondition->AmbientStorage,
				Output->Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			AmbientStorage,
			Variables:>{options}
		],
		Example[
			{Options,DestinationWell,"Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				DestinationWell->{"A1"},
				Output->Options
			];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[
			{Options,AliquotContainer,"Specify the desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.  This option will resolve to be the length of the SamplesIn * NumberOfReplicates:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				AliquotContainer->Model[Container, Vessel, "50mL Tube"],
				Output->Options
			];
			Lookup[options,AliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables:>{options}
		],
		Example[
			{Options,AliquotPreparation,"Specify the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				AliquotPreparation->Manual,
				Output->Options
			];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[
			{Options,ConsolidateAliquots,"Specify if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ConsolidateAliquots->True,
				Output->Options
			];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[
			{Options,MeasureWeight,"Specify if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				MeasureWeight->False,
				Output->Options
			];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[
			{Options,MeasureVolume,"Specify if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				MeasureVolume->False,
				Output->Options
			];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		Example[
			{Options,ImageSample,"Specify if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				ImageSample->False,
				Output->Options
			];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],
		Example[
			{Options,SamplesInStorageCondition,"Specify the non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				SamplesInStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,SamplesOutStorageCondition,"Specify the non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition:"},
			options=ExperimentPellet[{Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]},
				SamplesOutStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentPellet[
				Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentPellet[
				Object[Sample, "Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
				Output -> Result,
				OptionsResolverOnly -> True
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
		],
		Example[{Messages, "ResuspensionMismatch", "The Resuspension options must either all be Null or all be set, there cannot be conflicting options:"},
			ExperimentPellet[
				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
				ResuspensionSource->Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPellet"<>$SessionUUID],
				ResuspensionVolume->Null
			],
			$Failed,
			Messages :> {
				Error::InvalidOption,
				Error::InvalidInput,
				Error::ResuspensionMismatch
			}
		]
	},
	TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),

	SymbolSetUp :> Block[{$DeveloperUpload = True},
		Module[
			{
				objects, existsFilter, testBench, emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4,
				emptyContainer5, waterSample1, waterSample2, waterSample3, waterSample4, cellsample1
			},
			$CreatedObjects={};

			(* Erase any objects that we failed to erase in the last unit test. *)
			objects = {
				Object[Container, Bench,"Test bench for ExperimentPellet" <> $SessionUUID],

				Object[Container,Vessel,"Test container 1 for ExperimentPellet"<>$SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentPellet"<>$SessionUUID],
				Object[Container,Vessel,"Test container 3 for ExperimentPellet"<>$SessionUUID],
				Object[Container,Plate,"Test container 4 for ExperimentPellet"<>$SessionUUID],
				Object[Container,Vessel,"Test container 5 for ExperimentPellet"<>$SessionUUID],

				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
				Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPellet"<>$SessionUUID],
				Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentPellet"<>$SessionUUID],
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentPellet"<>$SessionUUID],
				Object[Sample,"Test cell sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]
			};
			existsFilter = DatabaseMemberQ[objects];
			EraseObject[
				PickList[objects, existsFilter],
				Force->True,
				Verbose->False
			];

			testBench = Upload[
				<|Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentPellet" <> $SessionUUID,
					Site -> Link[$Site]
				|>
			];

			(* Create containers for our test samples. *)
			{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5} = UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"1L Glass Bottle"],
					Model[Container,Plate,"96-well 2mL Deep Well Plate"],
					Model[Container,Vessel,"50mL Tube"]
				},
				{
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				Name -> {
					"Test container 1 for ExperimentPellet"<>$SessionUUID,
					"Test container 2 for ExperimentPellet"<>$SessionUUID,
					"Test container 3 for ExperimentPellet"<>$SessionUUID,
					"Test container 4 for ExperimentPellet"<>$SessionUUID,
					"Test container 5 for ExperimentPellet"<>$SessionUUID
				},
				FastTrack -> True
				];

			(* Create the test samples themselves. *)
			{waterSample1, waterSample2, waterSample3, waterSample4, cellsample1} = UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					{{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}}
				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer5}
				},
				InitialAmount -> {40 Milliliter, 20 Milliliter, 1 Liter, 1 Milliliter, 1 Milliliter},
				Name -> {
					"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID,
					"Test water sample in 50mL tube (2) for ExperimentPellet"<>$SessionUUID,
					"Test water sample in 1L Glass Bottle for ExperimentPellet"<>$SessionUUID,
					"Test water sample 1 in 96 deep-well plate for ExperimentPellet"<>$SessionUUID,
					"Test cell sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID
				},
				Living -> {
					False,
					False,
					False,
					False,
					True
				},
				CellType -> {
					Null,
					Null,
					Null,
					Null,
					Mammalian
				},
				CultureAdhesion -> {
					Null,
					Null,
					Null,
					Null,
					Suspension
				},
				State -> Liquid,
				FastTrack -> True
			];

		]
	],

	SymbolTearDown :> (
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[Flatten[{
				Object[Container, Bench,"Test bench for ExperimentPellet" <> $SessionUUID],

				Object[Container,Vessel,"Test container 1 for ExperimentPellet"<>$SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentPellet"<>$SessionUUID],
				Object[Container,Vessel,"Test container 3 for ExperimentPellet"<>$SessionUUID],
				Object[Container,Plate,"Test container 4 for ExperimentPellet"<>$SessionUUID],
				Object[Container,Vessel,"Test container 5 for ExperimentPellet"<>$SessionUUID],

				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID],
				Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPellet"<>$SessionUUID],
				Object[Sample,"Test water sample in 1L Glass Bottle for ExperimentPellet"<>$SessionUUID],
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentPellet"<>$SessionUUID],
				Object[Sample,"Test cell sample in 50mL tube (1) for ExperimentPellet"<>$SessionUUID]
			}], ObjectP[]];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			]];
		]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	Parallel -> False
];

(* ::Subsection:: *)
(*ExperimentPelletOptions*)


DefineTests[ExperimentPelletOptions,
	{
		Example[{Basic,"Return Options for Experiment Pellet what precipitating any solids in the solution and aspirate off the supernatant:"},
			ExperimentPelletOptions[
				{Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPelletOptions"],Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPelletOptions"]},
				SupernatantVolume->All,
				Preparation->Manual
			],
			_Grid,
			TimeConstraint->10000
		],
		Example[{Basic,"Return Options for Experiment Pellet what precipitating any solids in the solution, aspirate off the supernatant, then resuspend in 10 mL of Milli-Q water:"},
			ExperimentPelletOptions[
				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPelletOptions"],
				SupernatantVolume->All,
				SupernatantDestination->Waste,
				ResuspensionSource->Model[Sample,"Milli-Q water"],
				ResuspensionVolume->10 Milliliter
			],
			_Grid,
			TimeConstraint->10000
		],
		Example[{Basic,"Return Options for Experiment Pellet when vortexing should occur after resuspension:"},
			ExperimentPelletOptions[
				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPelletOptions"],
				SupernatantVolume->All,
				SupernatantDestination->Waste,
				ResuspensionSource->Model[Sample,"Milli-Q water"],
				ResuspensionVolume->10 Milliliter,
				ResuspensionMixType->Vortex
			],
			_Grid,
			TimeConstraint->10000
		]
	},
	SymbolSetUp:>(Module[{existsFilter,emptyContainer1,emptyContainer2, waterSample,waterSample2},
		ClearMemoization[];
		
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		
		$CreatedObjects={};
		
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ExperimentPelletOptions"],
			Object[Container,Vessel,"Test container 2 for ExperimentPelletOptions"],
			
			Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPelletOptions"],
			Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPelletOptions"]
		}];
		
		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ExperimentPelletOptions"],
					Object[Container,Vessel,"Test container 2 for ExperimentPelletOptions"],
					
					Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPelletOptions"],
					Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPelletOptions"]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];
		
		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentPelletOptions",
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentPelletOptions",
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];
		
		(* Create some water samples *)
		{waterSample,waterSample2}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2}
			},
			InitialAmount->{40 Milliliter,20 Milliliter},
			Name->{
				"Test water sample in 50mL tube (1) for ExperimentPelletOptions",
				"Test water sample in 50mL tube (2) for ExperimentPelletOptions"
			}
		];
		
		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>
		}];
	]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection:: *)
(*ExperimentPelletPreview*)


DefineTests[ExperimentPelletPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentPellet:"},
			ExperimentPelletPreview[
				Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPelletPreview "<>$SessionUUID],
				SupernatantVolume->All,
				Preparation->Manual
			],
			Null
		],
		Example[{Basic,"If you wish to understand how the experiment will be performed, try using ExperimentPelletOptions"},
			ExperimentPelletOptions[
				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPelletPreview "<>$SessionUUID],
				SupernatantVolume->All,
				SupernatantDestination->Waste,
				ResuspensionSource->Model[Sample,"Milli-Q water"],
				ResuspensionVolume->10 Milliliter
			],
			_Grid,
			TimeConstraint->10000
		],
		Example[{Basic,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentPelletQ:"},
			ValidExperimentPelletQ[
				Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPelletPreview "<>$SessionUUID],
				SupernatantVolume->All,
				SupernatantDestination->Waste,
				ResuspensionSource->Model[Sample,"Milli-Q water"],
				ResuspensionVolume->10 Milliliter
			],
			BooleanP,
			TimeConstraint->10000
		]
	},
	SymbolSetUp:>(Module[{existsFilter,emptyContainer1,emptyContainer2, waterSample,waterSample2},
		ClearMemoization[];
		
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		
		$CreatedObjects={};
		
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ExperimentPelletPreview "<>$SessionUUID],
			Object[Container,Vessel,"Test container 2 for ExperimentPelletPreview "<>$SessionUUID],
			
			Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPelletPreview "<>$SessionUUID],
			Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPelletPreview "<>$SessionUUID]
		}];
		
		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ExperimentPelletPreview "<>$SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentPelletPreview "<>$SessionUUID],
					
					Object[Sample,"Test water sample in 50mL tube (1) for ExperimentPelletPreview "<>$SessionUUID],
					Object[Sample,"Test water sample in 50mL tube (2) for ExperimentPelletPreview "<>$SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];
		
		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentPelletPreview "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentPelletPreview "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];
		
		(* Create some water samples *)
		{waterSample,waterSample2}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2}
			},
			InitialAmount->{40 Milliliter,20 Milliliter},
			Name->{
				"Test water sample in 50mL tube (1) for ExperimentPelletPreview "<>$SessionUUID,
				"Test water sample in 50mL tube (2) for ExperimentPelletPreview "<>$SessionUUID
			}
		];
		
		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>
		}];
	]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsection:: *)
(*ValidExperimentPelletQ*)


DefineTests[ValidExperimentPelletQ,
	{
		Example[
			{Basic,"Return a boolean indicating whether the call is valid:"},
			ValidExperimentPelletQ[
				Object[Sample,"Test water sample in 50mL tube (1) for ValidExperimentPelletQ "<>$SessionUUID],
				SupernatantVolume->All,
				Preparation->Manual
			],
			True
		],
		Example[
			{Basic,"If an option is invalid, returns False:"},
			ValidExperimentPelletQ[
				Object[Sample,"Test water sample in 50mL tube (1) for ValidExperimentPelletQ "<>$SessionUUID],
				ResuspensionSource->Object[Sample,"Test water sample in 50mL tube (2) for ValidExperimentPelletQ "<>$SessionUUID],
				ResuspensionVolume->Null
			],
			False,
			Messages :> {
				Error::ResuspensionMismatch
			}
		
		],
		Example[{Options, OutputFormat,"Return a test summary of the tests run to validate the call:"},
			ValidExperimentPelletQ[{
				Object[Sample,"Test water sample in 50mL tube (1) for ValidExperimentPelletQ "<>$SessionUUID]
			},
				Name->"Existing ValidExperimentPelletQ protocol",
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose,"Print the test results in addition to returning a boolean indicating the validity of the call:"},
			ValidExperimentPelletQ[{
				Object[Sample,"Test water sample in 50mL tube (1) for ValidExperimentPelletQ "<>$SessionUUID]
			},
				Name->"Existing ValidExperimentPelletQ protocol",
				Verbose->True
			],
			BooleanP
		]
	},
	SymbolSetUp:>(Module[{existsFilter,emptyContainer1,emptyContainer2, waterSample,waterSample2},
		ClearMemoization[];
		
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		
		$CreatedObjects={};
		
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ValidExperimentPelletQ "<>$SessionUUID],
			Object[Container,Vessel,"Test container 2 for ValidExperimentPelletQ "<>$SessionUUID],
			
			Object[Sample,"Test water sample in 50mL tube (1) for ValidExperimentPelletQ "<>$SessionUUID],
			Object[Sample,"Test water sample in 50mL tube (2) for ValidExperimentPelletQ "<>$SessionUUID]
		}];
		
		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ValidExperimentPelletQ "<>$SessionUUID],
					Object[Container,Vessel,"Test container 2 for ValidExperimentPelletQ "<>$SessionUUID],
					
					Object[Sample,"Test water sample in 50mL tube (1) for ValidExperimentPelletQ "<>$SessionUUID],
					Object[Sample,"Test water sample in 50mL tube (2) for ValidExperimentPelletQ "<>$SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];
		
		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ValidExperimentPelletQ "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ValidExperimentPelletQ "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];
		
		(* Create some water samples *)
		{waterSample,waterSample2}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2}
			},
			InitialAmount->{40 Milliliter,20 Milliliter},
			Name->{
				"Test water sample in 50mL tube (1) for ValidExperimentPelletQ "<>$SessionUUID,
				"Test water sample in 50mL tube (2) for ValidExperimentPelletQ "<>$SessionUUID
			}
		];
		
		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>
		}];
	]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsection:: *)
(*Pellet*)
(* Unit tests for the primitives *)

DefineTests[Pellet,
	{
		Example[{Basic, "Generate a manual protocol that precipitate any solids in the solution:"},
			ExperimentManualSamplePreparation[
				Pellet[
					Sample -> {
						Object[Sample,"Test water sample in 50mL tube (1) for Pellet Primitives"<>$SessionUUID],
						Object[Sample,"Test water sample in 50mL tube (2) for Pellet Primitives"<>$SessionUUID]
					},
					Time -> {1 Minute, 2 Minute},
					SampleLabel -> {"Test Label1", "Test Label2"},
					SampleContainerLabel -> {"Test Container Label 1", "Test Container Label 2"},
					ContainerOutLabel -> {"Test ContainerOut Label 1", "Test ContainerOut Label 2"},
					SampleOutLabel -> {"Test Out Label1", "Test Out Label2"},
					SupernatantVolume -> All
				]
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		
		Example[{Basic, "Generate a manual protocol that precipitate any solids in the solution by calling ExperimentSamplePreparation:"},
			ExperimentManualSamplePreparation[
				Pellet[
					Sample -> {
						Object[Sample,"Test water sample in 50mL tube (1) for Pellet Primitives"<>$SessionUUID],
						Object[Sample,"Test water sample in 50mL tube (2) for Pellet Primitives"<>$SessionUUID]
					},
					Time -> {1 Minute, 2 Minute},
					SampleLabel -> {"Test Label1", "Test Label2"},
					SampleContainerLabel -> {"Test Container Label 1", "Test Container Label 2"},
					ContainerOutLabel -> {"Test ContainerOut Label 1", "Test ContainerOut Label 2"},
					SampleOutLabel -> {"Test Out Label1", "Test Out Label2"},
					SupernatantVolume -> All
				]
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Generate a robotic protocol that precipitate any solids in the solution by calling ExperimentRoboticSamplePreparation:"},
			ExperimentPellet[
				{
					Object[Container, Plate, "Test container 4 for Pellet Primitives" <> $SessionUUID]
				},
				Preparation -> Robotic
			],
			ObjectP[{Object[Protocol, RoboticSamplePreparation]}],
			TimeConstraint->1000
		],
		Test["Generate a pellet protocol using HiG4 on bioSTAR:",
			ExperimentPellet[
				{
					Object[Container, Plate, "Test container 4 for Pellet Primitives" <> $SessionUUID]
				},
				Preparation -> Robotic,
				WorkCell->bioSTAR
			],
			ObjectP[{Object[Protocol, RoboticCellPreparation]}],
			Messages->{Warning::CentrifugePrecision}
		],
		Example[{Additional, "Generate a manual protocol that precipitate any solids in the solution with a series of Primitives:"},
			Experiment[
				{
					Pellet[
						Sample -> {
							Object[Sample,"Test water sample in 50mL tube (1) for Pellet Primitives"<>$SessionUUID],
							Object[Sample,"Test water sample in 50mL tube (2) for Pellet Primitives"<>$SessionUUID]
						},
						Time -> {1 Minute, 2 Minute},
						SampleLabel -> {"Test Label1", "Test Label2"},
						SampleContainerLabel -> {"Test Container Label 1", "Test Container Label 2"},
						ContainerOutLabel -> {"Test ContainerOut Label 1", "Test ContainerOut Label 2"},
						SampleOutLabel -> {"Test Out Label1", "Test Out Label2"},
						SupernatantVolume -> All
					],
					Mix[
						Sample -> {
							Object[Sample,"Test water sample in 50mL tube (1) for Pellet Primitives"<>$SessionUUID],
							Object[Sample,"Test water sample in 50mL tube (2) for Pellet Primitives"<>$SessionUUID]
						}
					]
				}
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		
		Example[{Additional, "Generate a robotic protocol that precipitate any solids in the solution:"},
			ExperimentSamplePreparation[
				Pellet[
					Sample -> Object[Container,Plate,"Test container 4 for Pellet Primitives"<>$SessionUUID]
				]
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		]
		
	},
	SymbolSetUp:>Module[
		{
			existsFilter,emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,waterSample,waterSample2,waterSample3,waterSample4,waterSample5
		},
		ClearMemoization[];
		
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		
		$CreatedObjects={};
		
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for Pellet Primitives"<>$SessionUUID],
			Object[Container,Vessel,"Test container 2 for Pellet Primitives"<>$SessionUUID],
			Object[Container,Vessel,"Test container 3 for Pellet Primitives"<>$SessionUUID],
			Object[Container,Plate,"Test container 4 for Pellet Primitives"<>$SessionUUID],
			
			Object[Sample,"Test water sample in 50mL tube (1) for Pellet Primitives"<>$SessionUUID],
			Object[Sample,"Test water sample in 50mL tube (2) for Pellet Primitives"<>$SessionUUID],
			Object[Sample,"Test water sample in 1L Glass Bottle for Pellet Primitives"<>$SessionUUID],
			Object[Sample,"Test water sample 1 in 96 deep-well plate for Pellet Primitives"<>$SessionUUID],
			Object[Sample,"Test water sample 2 in 96 deep-well plate for Pellet Primitives"<>$SessionUUID]
		}];
		
		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for Pellet Primitives"<>$SessionUUID],
					Object[Container,Vessel,"Test container 2 for Pellet Primitives"<>$SessionUUID],
					Object[Container,Vessel,"Test container 3 for Pellet Primitives"<>$SessionUUID],
					Object[Container,Plate,"Test container 4 for Pellet Primitives"<>$SessionUUID],
					
					Object[Sample,"Test water sample in 50mL tube (1) for Pellet Primitives"<>$SessionUUID],
					Object[Sample,"Test water sample in 50mL tube (2) for Pellet Primitives"<>$SessionUUID],
					Object[Sample,"Test water sample in 1L Glass Bottle for Pellet Primitives"<>$SessionUUID],
					Object[Sample,"Test water sample 1 in 96 deep-well plate for Pellet Primitives"<>$SessionUUID],
					Object[Sample,"Test water sample 2 in 96 deep-well plate for Pellet Primitives"<>$SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];
		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for Pellet Primitives"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for Pellet Primitives"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
				Name->"Test container 3 for Pellet Primitives"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"Test container 4 for Pellet Primitives"<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject->True
			|>
		}];
		
		(* Create some water samples *)
		{waterSample,waterSample2,waterSample3,waterSample4,waterSample5}=UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A2",emptyContainer4},
				{"A1",emptyContainer4}
			},
			InitialAmount->{40 Milliliter,20 Milliliter,1 Liter,1 Milliliter,1 Milliliter},
			Name->{
				"Test water sample in 50mL tube (1) for Pellet Primitives"<>$SessionUUID,
				"Test water sample in 50mL tube (2) for Pellet Primitives"<>$SessionUUID,
				"Test water sample in 1L Glass Bottle for Pellet Primitives"<>$SessionUUID,
				"Test water sample 1 in 96 deep-well plate for Pellet Primitives"<>$SessionUUID,
				"Test water sample 2 in 96 deep-well plate for Pellet Primitives"<>$SessionUUID
			}
		];
		
		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>,
			<|Object->waterSample3,DeveloperObject->True|>,
			<|Object->waterSample4,DeveloperObject->True|>,
			<|Object->waterSample5,DeveloperObject->True|>
		}];
	],
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
