(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentVisualInspection*)


DefineTests[ExperimentVisualInspection,
	{
		Example[{Options, SampleLabel, "Specify the SampleLabel option:"},
			protocol = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID], SampleLabel->"Test sample"];
			Download[protocol, BatchedUnitOperations[SampleLabel]],
			{{"Test sample"}},
			Variables :> {protocol}
		],

		Example[{Options, SampleContainerLabel, "Specify the SampleContainerLabel options:"},
			protocol = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID], SampleContainerLabel->"Test sample container"];
			Download[protocol, BatchedUnitOperations[SampleContainerLabel]],
			{{"Test sample container"}},
			Variables :> {protocol}
		],

		Example[{Options, Aliquot, "Aliquot for incorrect container:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID], Output->Options];
			Lookup[options, Aliquot],
			True,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],

		Example[{Options, AliquotAmount, "Specify the AliquotAmount option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID], AliquotAmount->2 Milliliter, Output->Options];
			Lookup[options, AliquotAmount],
			2 Milliliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, AssayVolume, "Specify the AssayVolume option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				AssayVolume->2 Milliliter,
				Output->Options];
			Lookup[options, AssayVolume],
			2 Milliliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, TargetConcentration, "Specify the TargetConcentration option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID],
				TargetConcentration->0.1 Molar,
				TargetConcentrationAnalyte->Model[Molecule, "Uracil"],
				AssayVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, TargetConcentration],
			0.1 Molar,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, TargetConcentrationAnalyte, "Specify the TargetConcentrationAnalyte option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID],
				TargetConcentration->0.1 Molar,
				TargetConcentrationAnalyte->Model[Molecule, "Uracil"],
				AssayVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Uracil"]],
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, ConcentratedBuffer, "Specify the ConcentratedBuffer option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID],
				ConcentratedBuffer->Model[Sample,"10x PBS with BSA for ExperimentVisualInspection"<>$SessionUUID],
				BufferDiluent->Model[Sample,"Milli-Q water"],
				BufferDilutionFactor->10,
				AliquotAmount->0.2 Milliliter,
				AssayVolume->1.8 Milliliter,
				Output->Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample,"10x PBS with BSA for ExperimentVisualInspection"<>$SessionUUID]],
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, BufferDilutionFactor, "Specify the BufferDiluentFactor option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID],
				ConcentratedBuffer->Model[Sample,"10x PBS with BSA for ExperimentVisualInspection"<>$SessionUUID],
				BufferDiluent->Model[Sample,"Milli-Q water"],
				BufferDilutionFactor->10,
				AliquotAmount->0.2 Milliliter,
				AssayVolume->1.8 Milliliter,
				Output->Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, BufferDiluent, "Specify the BufferDiluent option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID],
				ConcentratedBuffer->Model[Sample,"10x PBS with BSA for ExperimentVisualInspection"<>$SessionUUID],
				BufferDiluent->Model[Sample,"Milli-Q water"],
				BufferDilutionFactor->10,
				AliquotAmount->0.2 Milliliter,
				AssayVolume->1.8 Milliliter,
				Output->Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, AssayBuffer, "Specify the AssayBuffer option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID],
				AssayBuffer->Model[Sample,"10x PBS with BSA for ExperimentVisualInspection"<>$SessionUUID],
				AliquotAmount->0.2 Milliliter,
				AssayVolume->1.8 Milliliter,
				Output->Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample,"10x PBS with BSA for ExperimentVisualInspection"<>$SessionUUID]],
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, AliquotSampleStorageCondition, "Specify the AliquotSampleStorage Condition option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID], AliquotSampleStorageCondition->Refrigerator, Output->Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, DestinationWell, "Specify the DestinationWell option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID], DestinationWell->"A1", Output->Options];
			Lookup[options, DestinationWell],
			"A1",
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, AliquotContainer, "Specify the AliquotContainer option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID], AliquotContainer->Model[Container, Vessel, "2ml clear glass wide neck bottle"], Output->Options];
			Lookup[options, AliquotContainer][[2]],
			ObjectP[Model[Container, Vessel, "2ml clear glass wide neck bottle"]],
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, AliquotPreparation, "Specify the AliquotPreparation option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID],
				AliquotPreparation->Manual,
				Output->Options
			];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, ConsolidateAliquots, "Specify the ConsolidateAliquot option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<> $SessionUUID],
				ConsolidateAliquots->False,
				Output->Options
			];
			Lookup[options, ConsolidateAliquots],
			False,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved}
		],

		Example[{Options, AliquotSampleLabel, "Specify the AliquotSampleLabel option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				AliquotSampleLabel->"My test sample",
				Output->Options
			];
			Lookup[options, AliquotSampleLabel],
			"My test sample",
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],

		Example[{Options, Instrument, "Use the Instrument option to set the instrument model or object that will be used to run this experiment:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				Instrument->Model[Instrument, SampleInspector,"Cooled Visual Inspector with Vortex"],
				Output->Options
			];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument,SampleInspector,"Cooled Visual Inspector with Vortex"]],
			Variables :> {options}
		],
		
		Example[{Options, Instrument, "If the Instrument option is set to the orbital shaker and the SampleMixingRate option is not specified, the SampleMixingRate option is automatically set to 200 RPM:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (5oz plastic container)"<>$SessionUUID],
				Instrument->Model[Instrument, SampleInspector, "Cooled Visual Inspector with Orbital Shaker"],
				Output->Options
			];
			Lookup[options, SampleMixingRate],
			200 RPM,
			Variables :> {options}
		],

		Example[{Options, InspectionCondition, "Use the InspectionCondition option to specify whether the sample should be inspected under chilled or ambient conditions:"},
			protocol = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, refrigerator storage) 01"<>$SessionUUID], InspectionCondition->Chilled
			];
			Download[protocol, BatchedUnitOperations[InspectionCondition]],
			{{Chilled..}..},
			Variables:>{protocol}
		],

		Example[{Options, TemperatureEquilibrationTime, "Use the TemperatureEquilibrationTime option to set the duration of time for which the chamber temperature equilibration with the sample should occur:"},
			protocol = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				InspectionCondition->Chilled,
				TemperatureEquilibrationTime->30 Minute
			];
			Download[protocol, TemperatureEquilibrationTimes],
			{30 Minute},
			EquivalenceFunction->Equal,
			Variables :> {protocol}
		],

		Example[{Options, IlluminationDirection, "Use the IlluminationDirection option to specify the light sources that will be active during the visual inspection experiment:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				IlluminationDirection->{Top},
				Output->Options
			];
			Lookup[options, IlluminationDirection],
			{Top},
			Variables :> {options}
		],

		Example[{Options, BackgroundColor, "Use the Background option to specify the color of the backdrop for the video recording:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				BackgroundColor->White,
				Output->Options
			];
			Lookup[options, BackgroundColor],
			White,
			Variables :> {options}
		],

		Example[{Options, ColorCorrection, "Use the ColorCorrection option to specify whether the color correction card should be positioned within the video frame:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 02"<>$SessionUUID],
				ColorCorrection->False,
				Output->Options
			];
			Lookup[options, ColorCorrection],
			False,
			Variables :> {options}
		],

		Example[{Options, SampleMixingRate, "Use the SampleMixingRate option to specify the rate at which the sample will be agitated by rotating around the offset central axis to visualize any particulates:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 03"<>$SessionUUID],
				Instrument->Model[Instrument,SampleInspector,"Cooled Visual Inspector with Vortex"],
				SampleMixingRate->1600 RPM,
				Output->Options
			];
			Lookup[options,SampleMixingRate],
			1600 RPM,
			EquivalenceFunction->Equal,
			Variables :> {options}
		],

		Example[{Options, SampleMixingTime, "Use the SampleMixingTime option to specify the duration of time for which the sample will be agitated by rotating around the offset central axis to visualize any particulates:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				Instrument->Model[Instrument,SampleInspector,"Cooled Visual Inspector with Vortex"],
				SampleMixingTime->8 Second,
				Output->Options
			];
			Lookup[options, SampleMixingTime],
			8 Second,
			EquivalenceFunction->Equal,
			Variables :> {options}
		],

		Example[{Options, SampleSettlingTime, "Use the SampleSettlingTime option to specify the duration of time for which the sample will continue to be recorded after pausing its rotation around the offset central axis in order visualize the deceleration of suspended particulates:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				Instrument->Model[Instrument,SampleInspector,"Cooled Visual Inspector with Vortex"],
				SampleSettlingTime->5 Second,
				Output->Options
			];
			Lookup[options, SampleMixingTime],
			5 Second,
			EquivalenceFunction->Equal,
			Variables :> {options}
		],

		(* Shared options *)
		Example[{Options, Name, "Specify the Name option for the protocol:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 01"<>$SessionUUID], Name->"My wonderful test protocol", Output->Options];
			Lookup[options, Name],
			"My wonderful test protocol",
			Variables :> {options}
		],

		Example[{Options, Template, "Specify the Template option for the protocol:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 02"<>$SessionUUID], Template->Object[Protocol, VisualInspection, "Test template protocol"<>$SessionUUID], InspectionCondition ->Ambient, Output->Options];
			Lookup[options, InspectionCondition],
			Ambient,
			Variables :> {options}
		],

		(* Message examples *)
		Example[{Messages, "DiscardedSamples", "Throw an error if the sample is discarded:"},
			ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, discarded)"<>$SessionUUID]],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput}
		],

		Example[{Messages, "InsufficientTemperatureEquilibrationTime", "Throw a warning if the user-specified TemperatureEquilibrationTime is less than 30 Minute for a sample whose storage temperature is not equal to the experiment temperature:"},
			ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 03"<>$SessionUUID],
				InspectionCondition->Chilled,
				TemperatureEquilibrationTime->2 Minute
			],
			ObjectP[Object[Protocol,VisualInspection]],
			Messages :> {Warning::InsufficientTemperatureEquilibrationTime}
		],

		Example[{Messages, "ConflictingSampleContainerAliquotOptions", "Throw an error if a sample cannot be inspected directly in its current container given the user-specified Aliquot option:"},
			ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (2mL Tube, aliquot false)"<>$SessionUUID],
				Aliquot->False
			],
			$Failed,
			Messages :> {Error::ConflictingSampleContainerAliquotOptions, Error::InvalidOption, Error::InvalidInput}
		],

		Example[{Messages, "ConflictingAliquotContainerSampleMixingRates", "Throw an error if the user-specified AliquotContainer cannot be used for the sample inspector instrument necessary for the user-specified SamplemMixingRate:"},
			ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				SampleMixingRate->1000*RPM,
				AliquotContainer->Model[Container, Vessel, "50mL clear glass vial with stopper"]
			],
			$Failed,
			Messages :> {Error::ConflictingAliquotContainerSampleMixingRates, Error::InvalidOption, Error::InvalidInput}
		],

		Example[{Messages, "ConflictingInstrumentAliquotContainers", "Throw an error if the user-specified AliquotContainer cannot be used with the user-specified Instrument:"},
			ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Instrument->Model[Instrument,SampleInspector,"Cooled Visual Inspector with Vortex"],
				AliquotContainer->Model[Container, Vessel, "50mL clear glass vial with stopper"]
			],
			$Failed,
			Messages :> {Error::ConflictingInstrumentAliquotContainers, Error::InvalidOption, Error::InvalidInput}
		],

		Example[{Messages, "NonLiquidSamples", "Throw a warning if the sample is not liquid and recommend that the user prepares this sample as a homogenous solution:"},
			ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (non-liquid, aliquot true)"<>$SessionUUID]],
			ObjectP[Object[Protocol, VisualInspection]],
			Messages :> {Warning::NonLiquidSamples, Warning::AliquotRequired}
		],

		(* VisualInspection primitive example *)
		Example[{Basic, "ExperimentVisualInspection is called properly with the Experiment head and VisualInspection primitive:"},
			Experiment[{
				VisualInspection[
					Sample->Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID]
				]
			}],
		ObjectP[Object[Protocol, ManualSamplePreparation]],
		TimeConstraint->600],

		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Centrifuge->True, Output->Options];
			Lookup[options, Centrifuge],
			True,
			Messages :> {Warning::AliquotRequired,Warning::SampleMustBeMoved},
			Variables :> {options}
		],

		(*		 Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				CentrifugeInstrument ->Model[Instrument, Centrifuge, "Avanti J-15R"], Output->Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Messages :> {Warning::AliquotRequired,Warning::SampleMustBeMoved},
			Variables :> {options}
		],

		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				CentrifugeIntensity->1000*RPM, Output->Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			Messages :> {Warning::AliquotRequired,Warning::SampleMustBeMoved},
			EquivalenceFunction->Equal,
			Variables :> {options}
		],

		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				CentrifugeTime->5*Minute, Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Messages :> {Warning::AliquotRequired,Warning::SampleMustBeMoved},
			Variables:>{options}
		],

		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				CentrifugeTemperature->10*Celsius, Output->Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Messages :> {Warning::AliquotRequired,Warning::SampleMustBeMoved},
			Variables :> {options}
		],

		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				CentrifugeAliquot->1*Milliliter, Output->Options];
			Lookup[options, CentrifugeAliquot],
			1*Milliliter,
			EquivalenceFunction->Equal,
			Messages :> {Warning::AliquotRequired,Warning::SampleMustBeMoved},
			Variables :> {options}
		],

		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				CentrifugeAliquotContainer->Model[Container, Vessel, "2mL Tube"], Output->Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Messages :> {Warning::AliquotRequired,Warning::SampleMustBeMoved},
			Variables :> {options}
		],

		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				CentrifugeAliquotContainer->Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				CentrifugeAliquotDestinationWell->"A2",
				Output->Options
			];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Messages :> {Warning::AliquotRequired,Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Incubate->True, Output->Options];
			Lookup[options, Incubate],
			True,
			Messages :> {Warning::AliquotRequired,Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				IncubationTemperature->40*Celsius, Output->Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			EquivalenceFunction->Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				IncubationTime->40*Minute, Output->Options];
			Lookup[options, IncubationTime],
			40*Minute,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			EquivalenceFunction->Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				MaxIncubationTime->40*Minute, Output->Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			EquivalenceFunction->Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"], Output->Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				AnnealingTime->40*Minute, Output->Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			EquivalenceFunction->Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				IncubateAliquot->0.5*Milliliter, Output->Options];
			Lookup[options, IncubateAliquot],
			0.5*Milliliter,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			EquivalenceFunction->Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"], Output->Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				IncubateAliquotContainer->Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				IncubateAliquotDestinationWell->"A2",
				Output->Options
			];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Mix->True, Output->Options];
			Lookup[options, Mix],
			True,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				MixType->Shake, Output->Options];
			Lookup[options, MixType],
			Shake,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				MixUntilDissolved->True, Output->Options];
			Lookup[options, MixUntilDissolved],
			True,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],

		(* Filter *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Filtration->True, Output->Options];
			Lookup[options, Filtration],
			True,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FiltrationType->Syringe, Output->Options];
			Lookup[options, FiltrationType],
			Syringe,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterInstrument->Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output->Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Filter->Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output->Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterMaterial->PES, Output->Options];
			Lookup[options, FilterMaterial],
			PES,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID], PrefilterMaterial->GxF,FilterMaterial->PTFE, Output->Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterPoreSize->0.22*Micrometer, Output->Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],  PrefilterPoreSize->1.*Micrometer, FilterMaterial->PTFE, Output->Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FiltrationType->Syringe, FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"], Output->Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FiltrationType->PeristalticPump, FilterHousing->Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output->Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterAliquot->1 Milliliter, FiltrationType->Centrifuge, FilterIntensity->1000*RPM, Output->Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterAliquot->1 Milliliter,FiltrationType->Centrifuge, FilterTime->20*Minute, Output->Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterAliquot->1 Milliliter,FiltrationType->Centrifuge, FilterTemperature->22*Celsius, Output->Options];
			Lookup[options, FilterTemperature],
			22*Celsius,
			EquivalenceFunction->Equal,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterSterile->True, Output->Options];
			Lookup[options, FilterSterile],
			True,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterAliquot->0.5*Milliliter, Output->Options];
			Lookup[options, FilterAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterAliquotContainer->Model[Container, Vessel, "2mL Tube"], Output->Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterContainerOut->Model[Container, Vessel, "50mL Tube"], Output->Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				FilterAliquotContainer->Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				FilterAliquotDestinationWell->"A2",
				Output->Options
			];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, ImageSample,"Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID], ImageSample->True, Output->Options];
			Lookup[options, ImageSample],
			True,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {options}
		],
		Example[{Options, MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			protocol = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
					MeasureVolume->True];
			Download[protocol, MeasureVolume],
			True,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {protocol}
		],
		Example[{Options, MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			protocol = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
					MeasureWeight->True];
			Download[protocol, MeasureWeight],
			True,
			Messages :> {Warning::AliquotRequired, Warning::SampleMustBeMoved},
			Variables :> {protocol}
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the protocol:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				SamplesInStorageCondition->AmbientStorage,
				Output->Options
			];
			Lookup[options, SamplesInStorageCondition],
			AmbientStorage,
			Variables :> {options}
		],
		Example[{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			options = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				SamplesOutStorageCondition->AmbientStorage,
				Output->Options
			];
			Lookup[options, SamplesOutStorageCondition],
			AmbientStorage,
			Variables:>{options}
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentVisualInspection[{"test sample"},
				PreparatoryUnitOperations->{
					LabelSample[
						Label->"test sample",
						Sample->Model[Sample,"Milli-Q water"],
						Container->Model[Container, Vessel, "2mL clear fiolax type 1 glass vial (CSL)"],
						Amount->1 Milliliter
					]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{ManualSamplePreparationP..},
			Variables:>{protocol}
		],
		Example[{Options, PreparatoryPrimitives, "Use the PreparatoryPrimitives option to prepare samples from models before the experiment is run:"},
			ExperimentVisualInspection[{"My New Sample"},
				PreparatoryPrimitives->{
					Define[
						Name->"My New Sample",
						Container->Model[Container, Vessel, "2mL clear fiolax type 1 glass vial (CSL)"],
						ModelType->Model[Sample],
						ModelName->"Cocktail House"
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"My New Sample",
						Amount->2 Milliliter
					]
				}
			],
			ObjectP[Object[Protocol, VisualInspection]]
		],
		Example[{Messages, "ConflictingInstrumentSampleMixingRates", "Throw an error if the user-specified Instrument cannot mix the sample at the user-specified SampleMixingRate:"},
			ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Instrument->Model[Instrument,SampleInspector,"Cooled Visual Inspector with Orbital Shaker"],
				SampleMixingRate->2000*RPM
			],
			$Failed,
			Messages :> {Error::ConflictingInstrumentSampleMixingRates, Error::InvalidInput, Error::InvalidOption}
		],
		Example[{Basic, "Do not throw error for SampleMixingRate->540 RPM for the vortex sample inspector now that its minimum rotation rate has been changed from 600 RPM to 540 RPM:"},
			protocol = ExperimentVisualInspection[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				Instrument->Model[Instrument,SampleInspector,"Cooled Visual Inspector with Vortex"],
				SampleMixingRate->540*RPM
			];
			Download[protocol, VortexSampleMixingRates],
			{0.},
			EquivalenceFunction->Equal,
			Variables :> {protocol}
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:> {
		EraseObject[$CreatedObjects, Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>Block[{$DeveloperUpload = True},
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existsFilter,testBench,testBenchPacket,vortexLabels,vortexContainerLabels, vortexContainerModels,vortexSampleLabels,vortexSampleModels,orbitalShakerLabels,orbitalShakerContainerModels,orbitalShakerSampleLabels,orbitalShakerSampleModels,plasticContainerLabels,plasticContainerModels,plasticContainerObjectLabels,plasticContainerSampleLabels,plasticContainerSampleModels,aliquotFalseLabels,aliquotFalseContainerLabels,aliquotFalseContainerModels,aliquotFalseSampleLabels,aliquotFalseSampleModels,aliquotTrueLiquidLabels,aliquotTrueLiquidContainerLabels,aliquotTrueLiquidContainerModels,aliquotTrueLiquidSampleLabels,aliquotTrueLiquidSampleModels,aliquotTrueSolidLabels,aliquotTrueSolidContainerLabels, aliquotTrueSolidContainerModels,aliquotTrueSolidSampleLabels,aliquotTrueSolidSampleModels,allTestContainerLabels, allTestContainerModels,allTestSampleLabels,orbitalShakerContainerLabels, allTestSampleContainers,allTestSampleContainerPackets,allTestSampleModels,allTestSamplePackets,testConcentratedBufferPacket,discardedObjects},

			(* list of test objects *)
			objects = {
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (5oz plastic container)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (2mL Tube, aliquot false)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (5oz plastic container)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (2mL Tube, aliquot false)"<>$SessionUUID],
				Model[Sample,"10x PBS with BSA for ExperimentVisualInspection"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Vortex unit operations"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Orbital shaker unit operations"<>$SessionUUID],
				Object[Protocol,VisualInspection,"Test template protocol"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for ExperimentVisualInspection"<>$SessionUUID],
				Model[Sample,"Test sample model for ExperimentVisualInspection"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
			
			testBench = CreateID[Object[Container,Bench]];
			testBenchPacket = UploadSample[
				Model[Container,Bench,"The Bench of Testing"],
				{$Site[AllowedPositions][[1]],$Site},
				Name->"Test Bench for ExperimentVisualInspection"<>$SessionUUID,
				ID->testBench[ID],
				FastTrack->True,
				Upload->False
			];
			
			UploadSampleModel["Test sample model for ExperimentVisualInspection"<>$SessionUUID,
				Composition->{{100VolumePercent,Model[Molecule,"Water"]},{1 Molar,Model[Molecule,"Uracil"]}},
				State->Liquid,
				Expires->False,
				MSDSRequired->False,
				BiosafetyLevel->"BSL-1",
				IncompatibleMaterials->{None},
				DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]
			];
			
			(* Vortex containers & samples *)
			vortexLabels = {"(vortex, ambient storage) 01", "(vortex, ambient storage) 02", "(vortex, ambient storage) 03", "(vortex, discarded)", "(vortex, refrigerator storage) 01", "(vortex, refrigerator storage) 02", "(vortex, refrigerator storage) 03"};
			vortexContainerLabels = Map["Test container for sample for ExperimentVisualInspection "<> # <>$SessionUUID&,vortexLabels];
			vortexContainerModels = ConstantArray[Model[Container, Vessel, "2ml clear glass wide neck bottle"],Length[vortexLabels]];
			vortexSampleLabels = Map["Test sample for ExperimentVisualInspection "<> # <>$SessionUUID&, vortexLabels];
			vortexSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[vortexLabels]];
			
			(* Orbital shaker containers & samples *)
			orbitalShakerLabels = {"(orbitalShaker, ambient storage) 01", "(orbitalShaker, ambient storage) 02", "(orbitalShaker, ambient storage) 03", "(orbitalShaker, discarded)", "(orbitalShaker, refrigerator storage) 01", "(orbitalShaker, refrigerator storage) 02", "(orbitalShaker, refrigerator storage) 03"};
			orbitalShakerContainerLabels = Map["Test container for sample for ExperimentVisualInspection "<>#<>$SessionUUID&, orbitalShakerLabels];
			orbitalShakerContainerModels = ConstantArray[Model[Container, Vessel, "50mL clear glass vial with stopper"],Length[orbitalShakerLabels]];
			orbitalShakerSampleLabels = Map["Test sample for ExperimentVisualInspection "<> #<>$SessionUUID&, orbitalShakerLabels];
			orbitalShakerSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[orbitalShakerLabels]];
			
			(* 50 mL plastic container sample for orbital shaker *)
			plasticContainerLabels = {"(5oz plastic container)"};
			plasticContainerModels = ConstantArray[Model[Container, Vessel, "5oz clear plastic bottle"],Length[plasticContainerLabels]];
			plasticContainerObjectLabels = Map["Test container for sample for ExperimentVisualInspection "<>#<>$SessionUUID&, plasticContainerLabels];
			plasticContainerSampleLabels = Map["Test sample for ExperimentVisualInspection "<> #<>$SessionUUID&, plasticContainerLabels];
			plasticContainerSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[plasticContainerLabels]];
			
			(* Aliquot False containers & samples *)
			aliquotFalseLabels = {"(2mL Tube, aliquot false)"};
			aliquotFalseContainerLabels =  Map["Test container for sample for ExperimentVisualInspection "<> # <>$SessionUUID&, aliquotFalseLabels];
			aliquotFalseContainerModels = ConstantArray[Model[Container, Vessel, "2mL Tube"],Length[aliquotFalseLabels]];
			aliquotFalseSampleLabels = Map["Test sample for ExperimentVisualInspection "<> #<>$SessionUUID&, aliquotFalseLabels];
			aliquotFalseSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[aliquotFalseLabels]];
			
			aliquotTrueLiquidLabels = {"(aliquot true)"};
			aliquotTrueLiquidContainerLabels =  Map["Test container for sample for ExperimentVisualInspection "<> # <>$SessionUUID&, aliquotTrueLiquidLabels];
			aliquotTrueLiquidContainerModels = ConstantArray[Model[Container, Vessel, "50mL Tube"],Length[aliquotTrueLiquidLabels]];
			aliquotTrueLiquidSampleLabels = Map["Test sample for ExperimentVisualInspection "<> #<>$SessionUUID&, aliquotTrueLiquidLabels];
			aliquotTrueLiquidSampleModels = ConstantArray[Model[Sample,"Test sample model for ExperimentVisualInspection"<>$SessionUUID],Length[aliquotTrueLiquidLabels]];
			
			aliquotTrueSolidLabels = {"(non-liquid, aliquot true)"};
			aliquotTrueSolidContainerLabels =  Map["Test container for sample for ExperimentVisualInspection "<> # <>$SessionUUID&, aliquotTrueSolidLabels];
			aliquotTrueSolidContainerModels = ConstantArray[Model[Container, Vessel, "50mL Tube"],Length[aliquotTrueSolidLabels]];
			aliquotTrueSolidSampleLabels = Map["Test sample for ExperimentVisualInspection "<> #<>$SessionUUID&, aliquotTrueSolidLabels];
			aliquotTrueSolidSampleModels = ConstantArray[Model[Sample,"Uracil"],Length[aliquotTrueSolidLabels]];
			
			allTestContainerLabels = Join[vortexContainerLabels,orbitalShakerContainerLabels,plasticContainerObjectLabels,aliquotFalseContainerLabels,aliquotTrueLiquidContainerLabels,aliquotTrueSolidContainerLabels];
			allTestContainerModels = Join[vortexContainerModels,orbitalShakerContainerModels,plasticContainerModels,aliquotFalseContainerModels,aliquotTrueLiquidContainerModels,aliquotTrueSolidContainerModels];
			allTestSampleLabels = Join[vortexSampleLabels,orbitalShakerSampleLabels,plasticContainerSampleLabels,aliquotFalseSampleLabels,aliquotTrueLiquidSampleLabels,aliquotTrueSolidSampleLabels];
			allTestSampleModels = Join[vortexSampleModels,orbitalShakerSampleModels,plasticContainerSampleModels,aliquotFalseSampleModels,aliquotTrueLiquidSampleModels,aliquotTrueSolidSampleModels];
			
			allTestSampleContainers = CreateID[ConstantArray[Object[Container,Vessel],Length[allTestContainerModels]]];
			allTestSampleContainerPackets = UploadSample[allTestContainerModels,
				ConstantArray[{"Bench Top Slot",testBench},Length[allTestContainerModels]],
				Name->allTestContainerLabels,
				ID->allTestSampleContainers[ID],
				Cache->testBenchPacket,
				Upload->False
			];

			allTestSamplePackets = UploadSample[allTestSampleModels,
				Map[{"A1",#}&, allTestSampleContainers],
				Name->allTestSampleLabels,
				InitialAmount->Join[
					ConstantArray[2 Milliliter, Length[vortexLabels]],
					ConstantArray[50 Milliliter, Length[Join[orbitalShakerLabels,plasticContainerObjectLabels]]],
					{
						1 Milliliter,
						30 Milliliter,
						20 Gram
					}
				],
				StorageCondition->{
					AmbientStorage, AmbientStorage, AmbientStorage, AmbientStorage, Refrigerator, Refrigerator, Refrigerator, AmbientStorage, AmbientStorage, AmbientStorage, AmbientStorage, Refrigerator, Refrigerator, Refrigerator, AmbientStorage, AmbientStorage, AmbientStorage, AmbientStorage
				},
				Status->ConstantArray[Available, Length[allTestSampleContainers]],
				Cache->allTestSampleContainerPackets,
				Upload->False
			];
			
			(* 10x PBS with BSA *)
			testConcentratedBufferPacket = UploadSampleModel["10x PBS with BSA for ExperimentVisualInspection"<>$SessionUUID,
				Composition->{
					{100VolumePercent,Model[Molecule,"Water"]},
					{151.515Micromolar,Model[Molecule,Protein,"Bovine Albumin"]},
					{17.6Millimolar,Model[Molecule,"Potassium Phosphate"]},
					{81Millimolar,Model[Molecule,"Dibasic Sodium Phosphate"]},
					{27 Millimolar,Link[Model[Molecule,"Potassium Chloride"]]},
					{1.37 Molar,Link[Model[Molecule,"Sodium Chloride"]]}
				},
				Upload->False,
				Expires->False,
				DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
				State->Liquid,
				MSDSRequired->False
			];
			
			Upload[Join[testBenchPacket,allTestSampleContainerPackets,allTestSamplePackets,testConcentratedBufferPacket]];
			
			(* Upload test unitOperations *)
			Upload[{
				<|
					Replace[SampleLink]->{
						Link[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID]], Link[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 02"<>$SessionUUID]]
					},
					Replace[Instrument]->{
						Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]],
						Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]]
					},
					Replace[InspectionCondition]->{Ambient, Ambient},
					Replace[TemperatureEquilibrationTime]->{1 Minute, 1 Minute},
					Replace[ColorCorrection]->{True, True},
					Replace[VortexSampleMixingRate]->{3., 3.},
					Replace[OrbitalShakerSampleMixingRate]->{Null, Null},
					Name->"Vortex unit operations"<>$SessionUUID,
					Type->Object[UnitOperation, VisualInspection]
				|>,
				<|
					Replace[SampleLink]->{
						Link[Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 01"<>$SessionUUID]], Link[Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 02"<>$SessionUUID]]
					},
					Replace[Instrument]->{
						Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
						Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]]
					},
					Replace[InspectionCondition]->{Chilled, Chilled},
					Replace[TemperatureEquilibrationTime]->{1 Minute, 1 Minute},
					Replace[ColorCorrection]->{True, True},
					Replace[VortexSampleMixingRate]->{Null, Null},
					Replace[OrbitalShakerSampleMixingRate]->{200 RPM, 200 RPM},
					Name->"Orbital shaker unit operations"<>$SessionUUID,
					Type->Object[UnitOperation, VisualInspection]
				|>
			}];
			
			(* Upload template/test protocol *)
			Upload[<|
				Type->Object[Protocol, VisualInspection],
				Name->"Test template protocol"<>$SessionUUID,
				
				Replace[SamplesIn]->{
					Link[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 02"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 02"<>$SessionUUID], Protocols]
				},
				Replace[ContainersIn]->{
					Link[Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, ambient storage) 02"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 02"<>$SessionUUID], Protocols]
				},
				Replace[BatchedUnitOperations]->{
					Link[Object[UnitOperation,VisualInspection,"Vortex unit operations"<>$SessionUUID], Protocol],
					Link[Object[UnitOperation,VisualInspection,"Orbital shaker unit operations"<>$SessionUUID], Protocol]
				},
				Replace[Instruments]->{
					Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]]
				},
				Replace[InspectionConditions]->{Ambient, Chilled, Ambient, Chilled}
			|>];

			(* Change the status of discarded samples to Discarded *)
			discardedObjects = {
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, discarded)"<>$SessionUUID]
			};
			UploadSampleStatus[discardedObjects, Discarded];
		]
	],
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existsFilter},
			(* list of test objects *)
			objects = {
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (5oz plastic container)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspection (2mL Tube, aliquot false)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (5oz plastic container)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspection (2mL Tube, aliquot false)"<>$SessionUUID],
				Model[Sample,"10x PBS with BSA for ExperimentVisualInspection"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Vortex unit operations"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Orbital shaker unit operations"<>$SessionUUID],
				Object[Protocol,VisualInspection,"Test template protocol"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for ExperimentVisualInspection"<>$SessionUUID],
				Model[Sample,"Test sample model for ExperimentVisualInspection"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
		]
	}
];

(* ::Subsection::Closed:: *)
(*VisualInspection*)


DefineTests[VisualInspection,
	{
		Example[{Basic, "Specify a unit operation to visually inspect a specific sample while being chilled and mixed at 30 RPM:"},
			VisualInspection[
				Sample->Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID],
				InspectionCondition->Chilled,
				SampleMixingRate->30 RPM
			],
			_VisualInspection
		],
		Example[{Basic, "Specify that illumination should occur from the front and back:"},
			VisualInspection[
				Sample->Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID],
				IlluminationDirection->{Front, Back}
			],
			_VisualInspection
		],
		Example[{Basic, "Specify that the sample should be inspected against a black background with full illumination:"},
			VisualInspection[
				Sample->Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID],
				BackgroundColor->Black,
				IlluminationDirection->All
			],
			_VisualInspection
		],
		Example[{Additional, "Specify that the sample should be inspected against a black background with full illumination:"},
			ExperimentSamplePreparation[{
				VisualInspection[
					Sample->Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID],
					BackgroundColor->Black,
					IlluminationDirection->All
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:> {
		EraseObject[$CreatedObjects, Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, testBench,vortexLabels,vortexContainerLabels,vortexContainerModels,vortexSampleLabels,vortexSampleModels,orbitalShakerLabels,orbitalShakerContainerLabels,orbitalShakerContainerModels,orbitalShakerSampleLabels,orbitalShakerSampleModels,aliquotFalseLabels,aliquotFalseContainerLabels,aliquotFalseContainerModels,aliquotFalseSampleLabels,aliquotFalseSampleModels,aliquotTrueLiquidLabels,aliquotTrueLiquidContainerLabels,aliquotTrueLiquidContainerModels,aliquotTrueLiquidSampleLabels,aliquotTrueLiquidSampleModels,aliquotTrueSolidLabels,aliquotTrueSolidContainerLabels,aliquotTrueSolidContainerModels,aliquotTrueSolidSampleLabels,aliquotTrueSolidSampleModels,allTestContainerLabels,allTestContainerModels,allTestSampleLabels,allTestSampleModels,allTestSampleContainers, allTestSamples, discardedObjects,transferPrimitiveDestinationContainer, existsFilter},

			(* list of test objects *)
			objects = {
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (2mL Tube, aliquot false)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (2mL Tube, aliquot false)"<>$SessionUUID],
				Model[Sample,"Test sample model for VisualInspection Primitive"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Vortex unit operations for VisualInspection Primitive"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Orbital shaker unit operations for VisualInspection Primitive"<>$SessionUUID],
				Object[Protocol,VisualInspection,"Test template protocol for VisualInspection Primitive"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (transfer primitive)"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for VisualInspection Primitive"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
			
			testBench = UploadSample[
				Model[Container,Bench,"The Bench of Testing"],
				{"First Floor Slot",Object[Container,Building,"15500 Wells Port Drive"]},
				Name->"Test Bench for VisualInspection Primitive"<>$SessionUUID,
				FastTrack->True
			];
			
			UploadSampleModel["Test sample model for VisualInspection Primitive"<>$SessionUUID,
				Composition->{{100VolumePercent,Model[Molecule,"Water"]},{1 Molar,Model[Molecule,"Uracil"]}},
				State->Liquid,
				Expires->False,
				MSDSRequired->False,
				BiosafetyLevel->"BSL-1",
				IncompatibleMaterials->{None},
				DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]
			];
			
			(* Vortex containers & samples *)
			vortexLabels = {"(vortex, ambient storage) 01", "(vortex, ambient storage) 02", "(vortex, ambient storage) 03", "(vortex, discarded)", "(vortex, refrigerator storage) 01", "(vortex, refrigerator storage) 02", "(vortex, refrigerator storage) 03"};
			vortexContainerLabels = Map["Test container for sample for VisualInspection Primitive "<> # <>$SessionUUID&,vortexLabels];
			vortexContainerModels = ConstantArray[Model[Container, Vessel, "2ml clear glass wide neck bottle"],Length[vortexLabels]];
			vortexSampleLabels = Map["Test sample for VisualInspection Primitive "<> # <>$SessionUUID&, vortexLabels];
			vortexSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[vortexLabels]];
			
			(* Orbital shaker containers & samples *)
			orbitalShakerLabels = {"(orbitalShaker, ambient storage) 01", "(orbitalShaker, ambient storage) 02", "(orbitalShaker, ambient storage) 03", "(orbitalShaker, discarded)", "(orbitalShaker, refrigerator storage) 01", "(orbitalShaker, refrigerator storage) 02", "(orbitalShaker, refrigerator storage) 03"};
			orbitalShakerContainerLabels = Map["Test container for sample for VisualInspection Primitive "<>#<>$SessionUUID&, orbitalShakerLabels];
			orbitalShakerContainerModels = ConstantArray[Model[Container, Vessel, "50mL clear glass vial with stopper"],Length[orbitalShakerLabels]];
			orbitalShakerSampleLabels = Map["Test sample for VisualInspection Primitive "<> #<>$SessionUUID&, orbitalShakerLabels];
			orbitalShakerSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[orbitalShakerLabels]];
			
			(* Aliquot False containers & samples *)
			aliquotFalseLabels = {"(2mL Tube, aliquot false)"};
			aliquotFalseContainerLabels =  Map["Test container for sample for VisualInspection Primitive "<> # <>$SessionUUID&, aliquotFalseLabels];
			aliquotFalseContainerModels = ConstantArray[Model[Container, Vessel, "2mL Tube"],Length[aliquotFalseLabels]];
			aliquotFalseSampleLabels = Map["Test sample for VisualInspection Primitive "<> #<>$SessionUUID&, aliquotFalseLabels];
			aliquotFalseSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[aliquotFalseLabels]];
			
			aliquotTrueLiquidLabels = {"(aliquot true)"};
			aliquotTrueLiquidContainerLabels =  Map["Test container for sample for VisualInspection Primitive "<> # <>$SessionUUID&, aliquotTrueLiquidLabels];
			aliquotTrueLiquidContainerModels = ConstantArray[Model[Container, Vessel, "50mL Tube"],Length[aliquotTrueLiquidLabels]];
			aliquotTrueLiquidSampleLabels = Map["Test sample for VisualInspection Primitive "<> #<>$SessionUUID&, aliquotTrueLiquidLabels];
			aliquotTrueLiquidSampleModels = ConstantArray[Model[Sample,"Test sample model for VisualInspection Primitive"<>$SessionUUID],Length[aliquotTrueLiquidLabels]];
			
			aliquotTrueSolidLabels = {"(non-liquid, aliquot true)"};
			aliquotTrueSolidContainerLabels =  Map["Test container for sample for VisualInspection Primitive "<> # <>$SessionUUID&, aliquotTrueSolidLabels];
			aliquotTrueSolidContainerModels = ConstantArray[Model[Container, Vessel, "50mL Tube"],Length[aliquotTrueSolidLabels]];
			aliquotTrueSolidSampleLabels = Map["Test sample for VisualInspection Primitive "<> #<>$SessionUUID&, aliquotTrueSolidLabels];
			aliquotTrueSolidSampleModels = ConstantArray[Model[Sample,"Uracil"],Length[aliquotTrueSolidLabels]];
			
			allTestContainerLabels = Join[vortexContainerLabels,orbitalShakerContainerLabels,aliquotFalseContainerLabels,aliquotTrueLiquidContainerLabels,aliquotTrueSolidContainerLabels];
			allTestContainerModels = Join[vortexContainerModels,orbitalShakerContainerModels,aliquotFalseContainerModels,aliquotTrueLiquidContainerModels,aliquotTrueSolidContainerModels];
			allTestSampleLabels = Join[vortexSampleLabels,orbitalShakerSampleLabels,aliquotFalseSampleLabels,aliquotTrueLiquidSampleLabels,aliquotTrueSolidSampleLabels];
			allTestSampleModels = Join[vortexSampleModels,orbitalShakerSampleModels,aliquotFalseSampleModels,aliquotTrueLiquidSampleModels,aliquotTrueSolidSampleModels];
			
			allTestSampleContainers = UploadSample[allTestContainerModels,
				ConstantArray[{"Bench Top Slot",testBench},Length[allTestContainerModels]],
				Name->allTestContainerLabels
			];
			
			allTestSamples = UploadSample[allTestSampleModels,
				Map[{"A1",#}&, allTestSampleContainers],
				Name->allTestSampleLabels,
				InitialAmount->Join[
					ConstantArray[2 Milliliter, Length[vortexLabels]],
					ConstantArray[50 Milliliter, Length[orbitalShakerLabels]],
					{
						1 Milliliter,
						30 Milliliter,
						20 Gram
					}
				],
				StorageCondition->{
					AmbientStorage, AmbientStorage, AmbientStorage, AmbientStorage, Refrigerator, Refrigerator, Refrigerator, AmbientStorage, AmbientStorage, AmbientStorage, AmbientStorage, Refrigerator, Refrigerator, Refrigerator, AmbientStorage, AmbientStorage, AmbientStorage
				},
				Status->ConstantArray[Available, Length[allTestSampleContainers]]
			];
			
			(* Change the status of discarded samples to Discarded *)
			discardedObjects = {
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, discarded)"<>$SessionUUID]
			};
			UploadSampleStatus[discardedObjects, Discarded];

			transferPrimitiveDestinationContainer = Upload[
				<|
					Type->Object[Container, Vessel],
					Model->Link[Model[Container, Vessel, "2ml clear glass wide neck bottle"], Objects],
					Name->"Test container for sample for VisualInspection Primitive (transfer primitive)"<>$SessionUUID,
					DeveloperObject->True
				|>
			];

			(* Upload test unitOperations *)
			Upload[{
				<|
					Replace[SampleLink]->{
						Link[Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID]], Link[Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 02"<>$SessionUUID]]
					},
					Replace[Instrument]->{
						Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]],
						Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]]
					},
					Replace[InspectionCondition]->{Ambient, Ambient},
					Replace[TemperatureEquilibrationTime]->{1 Minute, 1 Minute},
					Replace[ColorCorrection]->{True, True},
					Replace[VortexSampleMixingRate]->{3., 3.},
					Replace[OrbitalShakerSampleMixingRate]->{Null, Null},
					Name->"Vortex unit operations for VisualInspection Primitive"<>$SessionUUID,
					Type->Object[UnitOperation, VisualInspection]
				|>,
				<|
					Replace[SampleLink]->{
						Link[Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 01"<>$SessionUUID]], Link[Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 02"<>$SessionUUID]]
					},
					Replace[Instrument]->{
						Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
						Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]]
					},
					Replace[InspectionCondition]->{Chilled, Chilled},
					Replace[TemperatureEquilibrationTime]->{1 Minute, 1 Minute},
					Replace[ColorCorrection]->{True, True},
					Replace[VortexSampleMixingRate]->{Null, Null},
					Replace[OrbitalShakerSampleMixingRate]->{200 RPM, 200 RPM},
					Name->"Orbital shaker unit operations for VisualInspection Primitive"<>$SessionUUID,
					Type->Object[UnitOperation, VisualInspection]
				|>
			}];

			(* Upload template/test protocol *)
			Upload[<|
				Type->Object[Protocol, VisualInspection],
				Name->"Test template protocol for VisualInspection Primitive"<>$SessionUUID,

				Replace[SamplesIn]->{
					Link[Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 02"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 02"<>$SessionUUID], Protocols]
				},
				Replace[ContainersIn]->{
					Link[Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, ambient storage) 02"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, ambient storage) 02"<>$SessionUUID], Protocols]
				},
				Replace[BatchedUnitOperations]->{
					Link[Object[UnitOperation,VisualInspection,"Vortex unit operations for VisualInspection Primitive"<>$SessionUUID], Protocol],
					Link[Object[UnitOperation,VisualInspection,"Orbital shaker unit operations for VisualInspection Primitive"<>$SessionUUID], Protocol]
				},
				Replace[Instruments]->{
					Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]]
				},
				Replace[InspectionConditions]->{Ambient, Chilled, Ambient, Chilled}
			|>];
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existsFilter},
			(* list of test objects *)
			objects = {
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (2mL Tube, aliquot false)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for VisualInspection Primitive (2mL Tube, aliquot false)"<>$SessionUUID],
				Model[Sample,"Test sample model for VisualInspection Primitive"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Vortex unit operations for VisualInspection Primitive"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Orbital shaker unit operations for VisualInspection Primitive"<>$SessionUUID],
				Object[Protocol,VisualInspection,"Test template protocol for VisualInspection Primitive"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for VisualInspection Primitive (transfer primitive)"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for VisualInspection Primitive"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
		]
	}
];


(* ::Subsection::Closed:: *)
(*ExperimentVisualInspectionOptions*)

DefineTests[ExperimentVisualInspectionOptions,
	{
		Example[{Basic, "Specify a unit operation to visually inspect a specific sample while being chilled and mixed at 30 RPM:"},
			ExperimentVisualInspectionOptions[
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID],
				InspectionCondition->Chilled,
				SampleMixingRate->30 RPM
			],
			_Grid
		],
		Example[{Basic, "Specify that illumination should occur from the front and back:"},
			ExperimentVisualInspectionOptions[
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID],
				IlluminationDirection->{Front, Back}
			],
			_Grid
		],
		Example[{Basic, "Specify that the sample should be inspected against a black background with full illumination:"},
			ExperimentVisualInspectionOptions[
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID],
				BackgroundColor->Black,
				IlluminationDirection->All
			],
			_Grid
		],
		Example[{Options, OutputFormat, "Generate a resolved list of options for an ExperimentVisualInspection call:"},
			ExperimentVisualInspectionOptions[
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID],
				InspectionCondition->Chilled,
				SampleMixingRate->30 RPM,
				OutputFormat->List
			],
			_?(MatchQ[
				Check[SafeOptions[ExperimentVisualInspection, #], $Failed, {Error::Pattern}],
				{(_Rule|_RuleDelayed)..}
			]&)

		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:> {
		EraseObject[$CreatedObjects, Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		
		Module[{objects,  existsFilter, testBench,vortexLabels,vortexContainerLabels, vortexContainerModels,vortexSampleLabels,vortexSampleModels,orbitalShakerLabels,orbitalShakerContainerModels,orbitalShakerSampleLabels,orbitalShakerSampleModels,aliquotFalseLabels,aliquotFalseContainerLabels,aliquotFalseContainerModels,aliquotFalseSampleLabels,aliquotFalseSampleModels,aliquotTrueLiquidLabels,aliquotTrueLiquidContainerLabels,aliquotTrueLiquidContainerModels,aliquotTrueLiquidSampleLabels,aliquotTrueLiquidSampleModels,aliquotTrueSolidLabels,aliquotTrueSolidContainerLabels, aliquotTrueSolidContainerModels,aliquotTrueSolidSampleLabels,aliquotTrueSolidSampleModels,allTestContainerLabels, allTestContainerModels,allTestSampleLabels,orbitalShakerContainerLabels, allTestSampleContainers,allTestSampleModels,allTestSamples, discardedObjects,transferPrimitiveDestinationContainer},
			
			(* list of test objects *)
			objects = {
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (2mL Tube, aliquot false)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (2mL Tube, aliquot false)"<>$SessionUUID],
				Model[Sample,StockSolution,"10x PBS with BSA for ExperimentVisualInspectionOptions"<>$SessionUUID],
				Model[Sample,"Test sample model for ExperimentVisualInspectionOptions"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Vortex unit operations"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Orbital shaker unit operations"<>$SessionUUID],
				Object[Protocol,VisualInspection,"Test template protocol"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (transfer primitive)"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for ExperimentVisualInspectionOptions"<>$SessionUUID]
			};
			
			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
			
			testBench = UploadSample[
				Model[Container,Bench,"The Bench of Testing"],
				{"First Floor Slot",Object[Container,Building,"15500 Wells Port Drive"]},
				Name->"Test Bench for ExperimentVisualInspectionOptions"<>$SessionUUID,
				FastTrack->True
			];
			
			UploadSampleModel["Test sample model for ExperimentVisualInspectionOptions"<>$SessionUUID,
				Composition->{{100VolumePercent,Model[Molecule,"Water"]},{1 Molar,Model[Molecule,"Uracil"]}},
				State->Liquid,
				Expires->False,
				MSDSRequired->False,
				BiosafetyLevel->"BSL-1",
				IncompatibleMaterials->{None},
				DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]
			];
			
			(* Vortex containers & samples *)
			vortexLabels = {"(vortex, ambient storage) 01", "(vortex, ambient storage) 02", "(vortex, ambient storage) 03", "(vortex, discarded)", "(vortex, refrigerator storage) 01", "(vortex, refrigerator storage) 02", "(vortex, refrigerator storage) 03"};
			vortexContainerLabels = Map["Test container for sample for ExperimentVisualInspectionOptions "<> # <>$SessionUUID&,vortexLabels];
			vortexContainerModels = ConstantArray[Model[Container, Vessel, "2ml clear glass wide neck bottle"],Length[vortexLabels]];
			vortexSampleLabels = Map["Test sample for ExperimentVisualInspectionOptions "<> # <>$SessionUUID&, vortexLabels];
			vortexSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[vortexLabels]];
			
			(* Orbital shaker containers & samples *)
			orbitalShakerLabels = {"(orbitalShaker, ambient storage) 01", "(orbitalShaker, ambient storage) 02", "(orbitalShaker, ambient storage) 03", "(orbitalShaker, discarded)", "(orbitalShaker, refrigerator storage) 01", "(orbitalShaker, refrigerator storage) 02", "(orbitalShaker, refrigerator storage) 03"};
			orbitalShakerContainerLabels = Map["Test container for sample for ExperimentVisualInspectionOptions "<>#<>$SessionUUID&, orbitalShakerLabels];
			orbitalShakerContainerModels = ConstantArray[Model[Container, Vessel, "50mL clear glass vial with stopper"],Length[orbitalShakerLabels]];
			orbitalShakerSampleLabels = Map["Test sample for ExperimentVisualInspectionOptions "<> #<>$SessionUUID&, orbitalShakerLabels];
			orbitalShakerSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[orbitalShakerLabels]];
			
			(* Aliquot False containers & samples *)
			aliquotFalseLabels = {"(2mL Tube, aliquot false)"};
			aliquotFalseContainerLabels =  Map["Test container for sample for ExperimentVisualInspectionOptions "<> # <>$SessionUUID&, aliquotFalseLabels];
			aliquotFalseContainerModels = ConstantArray[Model[Container, Vessel, "2mL Tube"],Length[aliquotFalseLabels]];
			aliquotFalseSampleLabels = Map["Test sample for ExperimentVisualInspectionOptions "<> #<>$SessionUUID&, aliquotFalseLabels];
			aliquotFalseSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[aliquotFalseLabels]];
			
			aliquotTrueLiquidLabels = {"(aliquot true)"};
			aliquotTrueLiquidContainerLabels =  Map["Test container for sample for ExperimentVisualInspectionOptions "<> # <>$SessionUUID&, aliquotTrueLiquidLabels];
			aliquotTrueLiquidContainerModels = ConstantArray[Model[Container, Vessel, "50mL Tube"],Length[aliquotTrueLiquidLabels]];
			aliquotTrueLiquidSampleLabels = Map["Test sample for ExperimentVisualInspectionOptions "<> #<>$SessionUUID&, aliquotTrueLiquidLabels];
			aliquotTrueLiquidSampleModels = ConstantArray[Model[Sample,"Test sample model for ExperimentVisualInspectionOptions"<>$SessionUUID],Length[aliquotTrueLiquidLabels]];
			
			aliquotTrueSolidLabels = {"(non-liquid, aliquot true)"};
			aliquotTrueSolidContainerLabels =  Map["Test container for sample for ExperimentVisualInspectionOptions "<> # <>$SessionUUID&, aliquotTrueSolidLabels];
			aliquotTrueSolidContainerModels = ConstantArray[Model[Container, Vessel, "50mL Tube"],Length[aliquotTrueSolidLabels]];
			aliquotTrueSolidSampleLabels = Map["Test sample for ExperimentVisualInspectionOptions "<> #<>$SessionUUID&, aliquotTrueSolidLabels];
			aliquotTrueSolidSampleModels = ConstantArray[Model[Sample,"Uracil"],Length[aliquotTrueSolidLabels]];
			
			allTestContainerLabels = Join[vortexContainerLabels,orbitalShakerContainerLabels,aliquotFalseContainerLabels,aliquotTrueLiquidContainerLabels,aliquotTrueSolidContainerLabels];
			allTestContainerModels = Join[vortexContainerModels,orbitalShakerContainerModels,aliquotFalseContainerModels,aliquotTrueLiquidContainerModels,aliquotTrueSolidContainerModels];
			allTestSampleLabels = Join[vortexSampleLabels,orbitalShakerSampleLabels,aliquotFalseSampleLabels,aliquotTrueLiquidSampleLabels,aliquotTrueSolidSampleLabels];
			allTestSampleModels = Join[vortexSampleModels,orbitalShakerSampleModels,aliquotFalseSampleModels,aliquotTrueLiquidSampleModels,aliquotTrueSolidSampleModels];
			
			allTestSampleContainers = UploadSample[allTestContainerModels,
				ConstantArray[{"Bench Top Slot",testBench},Length[allTestContainerModels]],
				Name->allTestContainerLabels
			];
			
			allTestSamples = UploadSample[allTestSampleModels,
				Map[{"A1",#}&, allTestSampleContainers],
				Name->allTestSampleLabels,
				InitialAmount->Join[
					ConstantArray[2 Milliliter, Length[vortexLabels]],
					ConstantArray[50 Milliliter, Length[orbitalShakerLabels]],
					{
						1 Milliliter,
						30 Milliliter,
						20 Gram
					}
				],
				StorageCondition->{
					AmbientStorage, AmbientStorage, AmbientStorage, AmbientStorage, Refrigerator, Refrigerator, Refrigerator, AmbientStorage, AmbientStorage, AmbientStorage, AmbientStorage, Refrigerator, Refrigerator, Refrigerator, AmbientStorage, AmbientStorage, AmbientStorage
				},
				Status->ConstantArray[Available, Length[allTestSampleContainers]]
			];
			
			(* Change the status of discarded samples to Discarded *)
			discardedObjects = {
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, discarded)"<>$SessionUUID]
			};
			UploadSampleStatus[discardedObjects, Discarded];
			
			transferPrimitiveDestinationContainer = Upload[
				<|
					Type->Object[Container, Vessel],
					Model->Link[Model[Container, Vessel, "2ml clear glass wide neck bottle"], Objects],
					Name->"Test container for sample for ExperimentVisualInspectionOptions (transfer primitive)"<>$SessionUUID,
					DeveloperObject->True
				|>
			];
			
			(* 10x OBS with BSA *)
			Upload[
				<|
					Type->Model[Sample, StockSolution],
					State->Liquid,
					Replace[Composition]->{
						{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "Water"]]},
						{151.515 Micromolar, Link[Model[Molecule, Protein, "Bovine Albumin"]]},
						{17.6 Millimolar, Link[Model[Molecule, "Potassium Phosphate"]]},
						{81 Millimolar, Link[Model[Molecule, "Dibasic Sodium Phosphate"]]},
						{27 Millimolar, Link[Model[Molecule, "Potassium Chloride"]]},
						{1.37 Molar, Link[Model[Molecule, "Sodium Chloride"]]}
					},
					Name->"10x PBS with BSA for ExperimentVisualInspectionOptions"<>$SessionUUID
				|>
			];
			
			(* Upload test unitOperations *)
			Upload[{
				<|
					Replace[SampleLink]->{
						Link[Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID]], Link[Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 02"<>$SessionUUID]]
					},
					Replace[Instrument]->{
						Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]],
						Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]]
					},
					Replace[InspectionCondition]->{Ambient, Ambient},
					Replace[TemperatureEquilibrationTime]->{1 Minute, 1 Minute},
					Replace[ColorCorrection]->{True, True},
					Replace[VortexSampleMixingRate]->{3., 3.},
					Replace[OrbitalShakerSampleMixingRate]->{Null, Null},
					Name->"Vortex unit operations"<>$SessionUUID,
					Type->Object[UnitOperation, VisualInspection]
				|>,
				<|
					Replace[SampleLink]->{
						Link[Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 01"<>$SessionUUID]], Link[Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 02"<>$SessionUUID]]
					},
					Replace[Instrument]->{
						Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
						Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]]
					},
					Replace[InspectionCondition]->{Chilled, Chilled},
					Replace[TemperatureEquilibrationTime]->{1 Minute, 1 Minute},
					Replace[ColorCorrection]->{True, True},
					Replace[VortexSampleMixingRate]->{Null, Null},
					Replace[OrbitalShakerSampleMixingRate]->{200 RPM, 200 RPM},
					Name->"Orbital shaker unit operations"<>$SessionUUID,
					Type->Object[UnitOperation, VisualInspection]
				|>
			}];
			
			(* Upload template/test protocol *)
			Upload[<|
				Type->Object[Protocol, VisualInspection],
				Name->"Test template protocol"<>$SessionUUID,
				
				Replace[SamplesIn]->{
					Link[Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 02"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 02"<>$SessionUUID], Protocols]
				},
				Replace[ContainersIn]->{
					Link[Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 02"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 02"<>$SessionUUID], Protocols]
				},
				Replace[BatchedUnitOperations]->{
					Link[Object[UnitOperation,VisualInspection,"Vortex unit operations"<>$SessionUUID], Protocol],
					Link[Object[UnitOperation,VisualInspection,"Orbital shaker unit operations"<>$SessionUUID], Protocol]
				},
				Replace[Instruments]->{
					Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]]
				},
				Replace[InspectionConditions]->{Ambient, Chilled, Ambient, Chilled}
			|>];
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existsFilter},
			(* list of test objects *)
			objects = {
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (2mL Tube, aliquot false)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ExperimentVisualInspectionOptions (2mL Tube, aliquot false)"<>$SessionUUID],
				Model[Sample,StockSolution,"10x PBS with BSA for ExperimentVisualInspectionOptions"<>$SessionUUID],
				Model[Sample,"Test sample model for ExperimentVisualInspectionOptions"<>$SessionUUID];
				Object[UnitOperation,VisualInspection,"Vortex unit operations"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Orbital shaker unit operations"<>$SessionUUID],
				Object[Protocol,VisualInspection,"Test template protocol"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ExperimentVisualInspectionOptions (transfer primitive)"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for ExperimentVisualInspectionOptions"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
		]
	}
];


(* ::Subsection::Closed:: *)
(*ValidExperimentVisualInspectionQ*)

DefineTests[ValidExperimentVisualInspectionQ,
	{
		Example[{Basic, "Specify a unit operation to visually inspect a specific sample while being chilled and mixed at 30 RPM:"},
			ValidExperimentVisualInspectionQ[
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID],
				InspectionCondition->Chilled,
				SampleMixingRate->30 RPM
			],
			True
		],
		Example[{Basic, "Specify that illumination should occur from the front and back:"},
			ValidExperimentVisualInspectionQ[
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID],
				IlluminationDirection->{Front, Back}
			],
			True
		],
		Example[{Basic, "Return False if a test fails"},
			ValidExperimentVisualInspectionQ[
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, discarded)"<>$SessionUUID],
				BackgroundColor->Black,
				IlluminationDirection->All
			],
			False
		],
		Example[{Options, OutputFormat, "Validate an ExperimentVisualInspection call, returning an ECL Test Summary:"},
			ValidExperimentVisualInspectionQ[
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID],
				InspectionCondition->Chilled,
				SampleMixingRate->30 RPM,
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, OutputFormat, "Validate an ExperimentVisualInspection call, printing a verbose summary of tests as they are run:"},
			ValidExperimentVisualInspectionQ[
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 03"<>$SessionUUID],
				InspectionCondition->Chilled,
				TemperatureEquilibrationTime->2 Minute,
				Verbose->Failures
			],
			True
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:> {
		EraseObject[$CreatedObjects, Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,  existsFilter, testBench,vortexLabels,vortexContainerLabels, vortexContainerModels,vortexSampleLabels,vortexSampleModels,orbitalShakerLabels,orbitalShakerContainerModels,orbitalShakerSampleLabels,orbitalShakerSampleModels,aliquotFalseLabels,aliquotFalseContainerLabels,aliquotFalseContainerModels,aliquotFalseSampleLabels,aliquotFalseSampleModels,aliquotTrueLiquidLabels,aliquotTrueLiquidContainerLabels,aliquotTrueLiquidContainerModels,aliquotTrueLiquidSampleLabels,aliquotTrueLiquidSampleModels,aliquotTrueSolidLabels,aliquotTrueSolidContainerLabels, aliquotTrueSolidContainerModels,aliquotTrueSolidSampleLabels,aliquotTrueSolidSampleModels,allTestContainerLabels, allTestContainerModels,allTestSampleLabels,orbitalShakerContainerLabels, allTestSampleContainers,allTestSampleModels,allTestSamples, discardedObjects,transferPrimitiveDestinationContainer},

			(* list of test objects *)
			objects = {
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (2mL Tube, aliquot false)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (2mL Tube, aliquot false)"<>$SessionUUID],
				Model[Sample,StockSolution,"10x PBS with BSA for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Model[Sample,"Test sample model for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Vortex unit operations for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Orbital shaker unit operations for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Object[Protocol,VisualInspection,"Test template protocol for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (transfer primitive)"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for ValidExperimentVisualInspectionQ"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
			
			testBench = UploadSample[
				Model[Container,Bench,"The Bench of Testing"],
				{"First Floor Slot",Object[Container,Building,"15500 Wells Port Drive"]},
				Name->"Test Bench for ValidExperimentVisualInspectionQ"<>$SessionUUID,
				FastTrack->True
			];
			UploadSampleModel["Test sample model for ValidExperimentVisualInspectionQ"<>$SessionUUID,
				Composition->{{100VolumePercent,Model[Molecule,"Water"]},{1 Molar,Model[Molecule,"Uracil"]}},
				State->Liquid,
				Expires->False,
				MSDSRequired->False,
				BiosafetyLevel->"BSL-1",
				IncompatibleMaterials->{None},
				DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]
			];
			
			(* Vortex containers & samples *)
			vortexLabels = {"(vortex, ambient storage) 01", "(vortex, ambient storage) 02", "(vortex, ambient storage) 03", "(vortex, discarded)", "(vortex, refrigerator storage) 01", "(vortex, refrigerator storage) 02", "(vortex, refrigerator storage) 03"};
			vortexContainerLabels = Map["Test container for sample for ValidExperimentVisualInspectionQ "<> # <>$SessionUUID&,vortexLabels];
			vortexContainerModels = ConstantArray[Model[Container, Vessel, "2ml clear glass wide neck bottle"],Length[vortexLabels]];
			vortexSampleLabels = Map["Test sample for ValidExperimentVisualInspectionQ "<> # <>$SessionUUID&, vortexLabels];
			vortexSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[vortexLabels]];
			
			(* Orbital shaker containers & samples *)
			orbitalShakerLabels = {"(orbitalShaker, ambient storage) 01", "(orbitalShaker, ambient storage) 02", "(orbitalShaker, ambient storage) 03", "(orbitalShaker, discarded)", "(orbitalShaker, refrigerator storage) 01", "(orbitalShaker, refrigerator storage) 02", "(orbitalShaker, refrigerator storage) 03"};
			orbitalShakerContainerLabels = Map["Test container for sample for ValidExperimentVisualInspectionQ "<>#<>$SessionUUID&, orbitalShakerLabels];
			orbitalShakerContainerModels = ConstantArray[Model[Container, Vessel, "50mL clear glass vial with stopper"],Length[orbitalShakerLabels]];
			orbitalShakerSampleLabels = Map["Test sample for ValidExperimentVisualInspectionQ "<> #<>$SessionUUID&, orbitalShakerLabels];
			orbitalShakerSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[orbitalShakerLabels]];
			
			(* Aliquot False containers & samples *)
			aliquotFalseLabels = {"(2mL Tube, aliquot false)"};
			aliquotFalseContainerLabels =  Map["Test container for sample for ValidExperimentVisualInspectionQ "<> # <>$SessionUUID&, aliquotFalseLabels];
			aliquotFalseContainerModels = ConstantArray[Model[Container, Vessel, "2mL Tube"],Length[aliquotFalseLabels]];
			aliquotFalseSampleLabels = Map["Test sample for ValidExperimentVisualInspectionQ "<> #<>$SessionUUID&, aliquotFalseLabels];
			aliquotFalseSampleModels = ConstantArray[Model[Sample,"Milli-Q water"],Length[aliquotFalseLabels]];
			
			aliquotTrueLiquidLabels = {"(aliquot true)"};
			aliquotTrueLiquidContainerLabels =  Map["Test container for sample for ValidExperimentVisualInspectionQ "<> # <>$SessionUUID&, aliquotTrueLiquidLabels];
			aliquotTrueLiquidContainerModels = ConstantArray[Model[Container, Vessel, "50mL Tube"],Length[aliquotTrueLiquidLabels]];
			aliquotTrueLiquidSampleLabels = Map["Test sample for ValidExperimentVisualInspectionQ "<> #<>$SessionUUID&, aliquotTrueLiquidLabels];
			aliquotTrueLiquidSampleModels = ConstantArray[Model[Sample,"Test sample model for ValidExperimentVisualInspectionQ"<>$SessionUUID],Length[aliquotTrueLiquidLabels]];
			
			aliquotTrueSolidLabels = {"(non-liquid, aliquot true)"};
			aliquotTrueSolidContainerLabels =  Map["Test container for sample for ValidExperimentVisualInspectionQ "<> # <>$SessionUUID&, aliquotTrueSolidLabels];
			aliquotTrueSolidContainerModels = ConstantArray[Model[Container, Vessel, "50mL Tube"],Length[aliquotTrueSolidLabels]];
			aliquotTrueSolidSampleLabels = Map["Test sample for ValidExperimentVisualInspectionQ "<> #<>$SessionUUID&, aliquotTrueSolidLabels];
			aliquotTrueSolidSampleModels = ConstantArray[Model[Sample,"Uracil"],Length[aliquotTrueSolidLabels]];
			
			allTestContainerLabels = Join[vortexContainerLabels,orbitalShakerContainerLabels,aliquotFalseContainerLabels,aliquotTrueLiquidContainerLabels,aliquotTrueSolidContainerLabels];
			allTestContainerModels = Join[vortexContainerModels,orbitalShakerContainerModels,aliquotFalseContainerModels,aliquotTrueLiquidContainerModels,aliquotTrueSolidContainerModels];
			allTestSampleLabels = Join[vortexSampleLabels,orbitalShakerSampleLabels,aliquotFalseSampleLabels,aliquotTrueLiquidSampleLabels,aliquotTrueSolidSampleLabels];
			allTestSampleModels = Join[vortexSampleModels,orbitalShakerSampleModels,aliquotFalseSampleModels,aliquotTrueLiquidSampleModels,aliquotTrueSolidSampleModels];
			
			allTestSampleContainers = UploadSample[allTestContainerModels,
				ConstantArray[{"Bench Top Slot",testBench},Length[allTestContainerModels]],
				Name->allTestContainerLabels
			];
			
			allTestSamples = UploadSample[allTestSampleModels,
				Map[{"A1",#}&, allTestSampleContainers],
				Name->allTestSampleLabels,
				InitialAmount->Join[
					ConstantArray[2 Milliliter, Length[vortexLabels]],
					ConstantArray[50 Milliliter, Length[orbitalShakerLabels]],
					{
						1 Milliliter,
						30 Milliliter,
						20 Gram
					}
				],
				StorageCondition->{
					AmbientStorage, AmbientStorage, AmbientStorage, AmbientStorage, Refrigerator, Refrigerator, Refrigerator, AmbientStorage, AmbientStorage, AmbientStorage, AmbientStorage, Refrigerator, Refrigerator, Refrigerator, AmbientStorage, AmbientStorage, AmbientStorage
				},
				Status->ConstantArray[Available, Length[allTestSampleContainers]]
			];
			
			(* Change the status of discarded samples to Discarded *)
			discardedObjects = {
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, discarded)"<>$SessionUUID]
			};
			UploadSampleStatus[discardedObjects, Discarded];

			transferPrimitiveDestinationContainer = Upload[
				<|
					Type->Object[Container, Vessel],
					Model->Link[Model[Container, Vessel, "2ml clear glass wide neck bottle"], Objects],
					Name->"Test container for sample for ValidExperimentVisualInspectionQ (transfer primitive)"<>$SessionUUID,
					DeveloperObject->True
				|>
			];

			(* 10x OBS with BSA *)
			Upload[
				<|
					Type->Model[Sample, StockSolution],
					State->Liquid,
					Replace[Composition]->{
						{151.515 Micromolar, Link[Model[Molecule, Protein, "Bovine Albumin"]]},
						{Quantity[100, IndependentUnit["VolumePercent"]], Link[Model[Molecule, "Water"]]},
						{17.6 Millimolar, Link[Model[Molecule, "Potassium Phosphate"]]},
						{81 Millimolar, Link[Model[Molecule, "Dibasic Sodium Phosphate"]]},
						{27 Millimolar, Link[Model[Molecule, "Potassium Chloride"]]},
						{1.37 Molar, Link[Model[Molecule, "Sodium Chloride"]]}
					},
					Name->"10x PBS with BSA for ValidExperimentVisualInspectionQ"<>$SessionUUID
				|>
			];

			(* Upload test unitOperations *)
			Upload[{
				<|
					Replace[SampleLink]->{
						Link[Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID]], Link[Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 02"<>$SessionUUID]]
					},
					Replace[Instrument]->{
						Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]],
						Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]]
					},
					Replace[InspectionCondition]->{Ambient, Ambient},
					Replace[TemperatureEquilibrationTime]->{1 Minute, 1 Minute},
					Replace[ColorCorrection]->{True, True},
					Replace[VortexSampleMixingRate]->{3., 3.},
					Replace[OrbitalShakerSampleMixingRate]->{Null, Null},
					Name->"Vortex unit operations for ValidExperimentVisualInspectionQ"<>$SessionUUID,
					Type->Object[UnitOperation, VisualInspection]
				|>,
				<|
					Replace[SampleLink]->{
						Link[Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 01"<>$SessionUUID]], Link[Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 02"<>$SessionUUID]]
					},
					Replace[Instrument]->{
						Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
						Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]]
					},
					Replace[InspectionCondition]->{Chilled, Chilled},
					Replace[TemperatureEquilibrationTime]->{1 Minute, 1 Minute},
					Replace[ColorCorrection]->{True, True},
					Replace[VortexSampleMixingRate]->{Null, Null},
					Replace[OrbitalShakerSampleMixingRate]->{200 RPM, 200 RPM},
					Name->"Orbital shaker unit operations for ValidExperimentVisualInspectionQ"<>$SessionUUID,
					Type->Object[UnitOperation, VisualInspection]
				|>
			}];

			(* Upload template/test protocol *)
			Upload[<|
				Type->Object[Protocol, VisualInspection],
				Name->"Test template protocol for ValidExperimentVisualInspectionQ"<>$SessionUUID,

				Replace[SamplesIn]->{
					Link[Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 02"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 02"<>$SessionUUID], Protocols]
				},
				Replace[ContainersIn]->{
					Link[Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 02"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 01"<>$SessionUUID], Protocols],
					Link[Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 02"<>$SessionUUID], Protocols]
				},
				Replace[BatchedUnitOperations]->{
					Link[Object[UnitOperation,VisualInspection,"Vortex unit operations for ValidExperimentVisualInspectionQ"<>$SessionUUID], Protocol],
					Link[Object[UnitOperation,VisualInspection,"Orbital shaker unit operations for ValidExperimentVisualInspectionQ"<>$SessionUUID], Protocol]
				},
				Replace[Instruments]->{
					Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 2"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]],
					Link[Object[Instrument,SampleInspector,"Visual Inspector 1"]]
				},
				Replace[InspectionConditions]->{Ambient, Chilled, Ambient, Chilled}
			|>];
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existsFilter},
			(* list of test objects *)
			objects = {
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (2mL Tube, aliquot false)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (vortex, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, ambient storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, discarded)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 01"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 02"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (orbitalShaker, refrigerator storage) 03"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (non-liquid, aliquot true)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidExperimentVisualInspectionQ (2mL Tube, aliquot false)"<>$SessionUUID],
				Model[Sample,StockSolution,"10x PBS with BSA for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Model[Sample,"Test sample model for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Vortex unit operations for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Object[UnitOperation,VisualInspection,"Orbital shaker unit operations for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Object[Protocol,VisualInspection,"Test template protocol for ValidExperimentVisualInspectionQ"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidExperimentVisualInspectionQ (transfer primitive)"<>$SessionUUID],
				Object[Container,Bench,"Test Bench for ValidExperimentVisualInspectionQ"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
		]
	}
];