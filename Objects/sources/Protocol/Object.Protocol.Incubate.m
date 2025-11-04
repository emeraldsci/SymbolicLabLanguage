(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,Incubate],{
	Description->"A protocol to perform thermal incubation (with optional mixing) of a sample using a heating or cooling device.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*-- OPTION FIELDS --*)
		Thaw->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates if SamplesIn should be incubated until visibly liquid, before they are mixed and/or incubated.",
			Category->"Incubation"
		},
		ThawTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterEqualP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the length of time that samples should be thawed.",
			Category->"Incubation"
		},
		MaxThawTimes->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterEqualP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate.",
			Category->"Incubation"
		},
		ThawTemperatures->{
			Format->Multiple,
			Class->Real,
			Units->Celsius,
			Pattern:>GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature at which the samples should be thawed.",
			Category->"Incubation"
		},
		ThawInstrument->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,HeatBlock],
				Object[Instrument,HeatBlock]
			],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the instrument that will be used to thaw the sample.",
			Category->"Incubation"
		},
		Mix->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates the style of motion used to mix the sample.",
			Category->"Incubation"
		},
		MixTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,(* Null indicates incubation *)
			Description->"For each member of SamplesIn, indicates the style of motion used to mix the sample.",
			IndexMatching->SamplesIn,
			Category->"Incubation"
		},
		MixUntilDissolved->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates if the mix should be continued up to the MaxTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute.",
			Category->"Incubation"
		},
		Instruments->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives@@Join[MixInstrumentModels,MixInstrumentObjects],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the instrument used to perform the Mix and/or Incubation.",
			Category->"Incubation"
		},
		HandlingEnvironment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, HandlingStation],
				Object[Instrument, HandlingStation]
			],
			Description -> "The environment in which any Invert/Swirl operation happens.",
			Category -> "General"
		},
		AlternateInstruments -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:> _List,
			Description -> "For each member of SamplesIn, the alternative instruments can be used to perform the Mix and/or Incubation. Currently, this field is only used when mixing with Sonicator.",
			Category -> "Incubation",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		StirBars->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Part,StirBar],
				Object[Part,StirBar]
			],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the stir bar that should be used to stir the sample.",
			Category->"Incubation"
		},
		Times->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterEqualP[0 Minute],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration of time for which the samples will be mixed.",
			Category->"Incubation"
		},
		DutyCycles->{
			Format->Multiple,
			Class->{
				On -> Real,
				Off -> Real
			},
			Units->{
				On -> Second,
				Off -> Second
			},
			Pattern:>{
				On -> TimeP,
				Off -> TimeP
			},
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed. This option can only be set when mixing via homogenization.",
			Category->"Incubation"
		},
		MixRates->{
			Format->Multiple,
			Class->VariableUnit,
			Pattern:>GreaterEqualP[0 RPM]|GreaterEqualP[0 GravitationalAcceleration],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the frequency of rotation the mixing instrument should use to mix the samples.",
			Category->"Incubation"
		},
		MixRateProfiles->{
			Format->Multiple,
			Class->Expression,
			Pattern:>_List,
			Description->"For each member of SamplesIn, the frequency of rotation the mixing instrument should use to mix the samples, over the course of time.",
			IndexMatching->SamplesIn,
			Category->"Incubation"
		},
		NumberOfMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Description->"For each member of SamplesIn, the number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
			IndexMatching->SamplesIn,
			Category->"Incubation"
		},
		MaxNumberOfMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Description->"For each member of SamplesIn, the number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
			IndexMatching->SamplesIn,
			Category->"Incubation"
		},
		MixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
			IndexMatching->SamplesIn,
			Category->"Incubation"
		},
		Temperatures->{
			Format->Multiple,
			Class->Real,
			Units->Celsius,
			Pattern:>GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
			Category->"Incubation"
		},
		TemperatureProfiles->{
			Format->Multiple,
			Class->Expression,
			Pattern:>_List,
			Description->"For each member of SamplesIn, the temperature of the device, over the course of time, that should be used to mix/incubate the sample.",
			IndexMatching->SamplesIn,
			Category->"Incubation"
		},
		MaxTemperatures->{
			Format->Multiple,
			Class->Real,
			Units->Celsius,
			Pattern:>GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the maximum temperature that the sample should reach during mixing via homogenization or sonication. If the measured temperature is above this MaxTemperature, the homogenizer/sonicator will turn off until the measured temperature is 2C below the MaxTemperature, then it will automatically resume.",
			Category->"Incubation"
		},
		RelativeHumidities->{
			Format->Multiple,
			Class->Real,
			Units->Percent,
			Pattern:>GreaterEqualP[0 Percent],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the amount of water vapor present in air that the samples will be exposed to during incubation, relative to the amount needed for saturation.",
			Category->"Incubation"
		},
		LightExposures->{
			Format->Multiple,
			Class->Expression,
			Pattern:>EnvironmentalChamberLightTypeP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the range of wavelengths of light that the incubated samples will be exposed to. Only available when incubating the samples in an environmental chamber with UVLight and VisibleLight control.",
			Category->"Incubation"
		},
		LightExposureIntensities->{
			Format->Multiple,
			Class->VariableUnit,
			Pattern :> GreaterEqualP[0 (Watt/(Meter^2))] | GreaterEqualP[0 (Lumen/(Meter^2))],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the intensity of light that the incubated samples will be exposed to during the course of the incubation. UVLight exposure is measured in Watt/Meter^2 and Visible Light Intensity is measured in Lumen/Meter^2.",
			Category->"Incubation"
		},
		LightExposureStandards->{
			Format->Multiple,
			Class->Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Object[Container],
			Description->"During light exposure experiments, a set of samples that are placed in an opaque box to receive identical incubation conditions without exposure to light. This option can only be set if incubating other samples in an environmental stability chamber with light exposure.",
			Category->"Incubation"
		},
		LightExposureStandardBox->{
			Format->Single,
			Class->Link,
			Pattern :> _Link,
			Relation -> Model[Container]|Object[Container],
			Description->"The opaque box used to protect the LightExposureStandards during light exposure experiments.",
			Category->"Incubation"
		},
		OscillationAngles->{
			Format->Multiple,
			Class->Real,
			Units->AngularDegree,
			Pattern:>GreaterEqualP[0 AngularDegree],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the angle of oscillation of the mixing motion when a wrist action shaker is used.",
			Category->"Incubation"
		},
		Amplitudes->{
			Format->Multiple,
			Class->Real,
			Units->Percent,
			Pattern:>PercentP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the amplitude of the sonication horn when mixing via homogenization. When using a microtip horn (ex. for 2mL and 15mL tubes), the maximum amplitude is 70 Percent, as specified by the manufacturer, in order not to damage the instrument.",
			Category->"Incubation"
		},
		AnnealingTime->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>TimeP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the Time has passed.",
			Category->"Incubation"
		},
		ResidualIncubation->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates if the incubation and/or mixing should continue after Time/MaxTime has finished while waiting to progress to the next step in the protocol.",
			Category->"Incubation"
		},
		ResidualTemperatures->{
			Format->Multiple,
			Class->Real,
			Units->Celsius,
			Pattern:>GreaterEqualP[0 Kelvin],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature at which the sample(s) should remain incubating after Time has elapsed. This option can only be set if Preparation->Robotic.",
			Category->"Incubation"
		},
		ResidualMix->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates that the sample(s) should remain shaking at the ResidualMixRate after Time has elapsed. This option can only be set if Preparation->Robotic.",
			Category->"Incubation"
		},
		ResidualMixRates->{
			Format->Multiple,
			Class->Real,
			Units->RPM,
			Pattern:>GreaterEqualP[0 RPM],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates the rate at which the sample(s) should remain shaking after Time has elapsed, when mixing by shaking. This option can only be set if Preparation->Robotic.",
			Category->"Incubation"
		},
		Preheat->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates if the incubation position should be brought to Temperature before exposing the Sample to it. This option can only be set if Preparation->Robotic.",
			Category->"Incubation"
		},

		(*-- THAWING FIELDS --*)
		(* Batch Looping Fields *)
		ThawIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in ThawParameters, as they relate to SamplesIn. Used to update the ThawParameters fields with our now WorkingSamples. We need this field because samples can show up multiple times in SamplesIn and we need an index to disambiguate multiple occurrences of the same sample in the WorkingSamples field.",
			Category->"Incubation",
			Developer->True
		},
		ThawBatchLength->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The batch lengths that correspond to the sample groupings of ThawParameters.",
			Category->"Incubation",
			Developer->True
		},
		(* Thawing Parameter Fields *)
		ThawParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Instrument->Link,
				Time->Real,
				MaxTime->Real,
				Temperature->Real
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				Instrument->ObjectP[{Model[Instrument],Object[Instrument]}],
				Time->TimeP,
				MaxTime->TimeP,
				Temperature->TemperatureP
			},
			Relation->{
				Sample->Object[Sample],
				Instrument->Model[Instrument]|Object[Instrument],
				Time->Null,
				MaxTime->Null,
				Temperature->Null
			},
			Units->{
				Sample->None,
				Instrument->None,
				Time->Minute,
				MaxTime->Minute,
				Temperature->Celsius
			},
			Description->"Specifies how samples should be thawed in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		ThawInstruments->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,HeatBlock],
				Object[Instrument,HeatBlock]
			],
			IndexMatching->ThawBatchLength,
			Description->"For each member of ThawBatchLength, the heat block instruments that should be used to thaw each sample grouping.",
			Category->"Incubation",
			Developer->True
		},
		ThawTime->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterEqualP[0 Minute],
			IndexMatching->ThawInstruments,
			Description->"For each member of ThawInstruments, the length of time that samples should be thawed.",
			Category->"Incubation",
			Developer->True
		},
		ThawAdditionalTime->{
			Format->Multiple,
			Class->Real,
			Units->Minute,
			Pattern:>GreaterEqualP[0 Minute],
			IndexMatching->ThawInstruments,
			Description->"For each member of ThawInstruments, the length of time that samples should be thawed, after the ThawTime has passed, until the samples are fully thawed.",
			Category->"Incubation",
			Developer->True
		},
		ThawTemperature->{
			Format->Multiple,
			Class->Real,
			Units->Celsius,
			Pattern:>GreaterEqualP[0 Kelvin],
			IndexMatching->ThawInstruments,
			Description->"For each member of ThawInstruments, the temperature at which the samples should be thawed.",
			Category->"Incubation",
			Developer->True
		},
		ThawSelect->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->ThawInstruments,
			Description->"For each member of ThawInstruments, a boolean that indicates if the ThawInstruments should be picked. Instruments should be picked if we are processing the first sample grouping that will use said instrument.",
			Category->"Incubation",
			Developer->True
		},
		ThawRelease->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->ThawInstruments,
			Description->"For each member of ThawInstruments, a boolean that indicates if the ThawInstruments should be released. Instruments should be released if we are processing the last sample grouping that will use said instrument.",
			Category->"Incubation",
			Developer->True
		},
		FullyThawed->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Boolean that indicate if our samples are fully thawed.",
			Category->"Incubation"
		},
		ThawActualTemperature->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"A field used to record the actual temperature of the heat block while the instrument is incubating the sample.",
			Category->"Incubation",
			Developer->True
		},
		ThawStartTime->{
			Format->Single,
			Class->Expression,
			Pattern:>_?DateObjectQ,
			Description->"The date we started to thaw the sample. Used to detect when the thawing processing stage has timed out.",
			Category->"Incubation",
			Developer->True
		},
		(*-- INCUBATION FIELDS --*)
		IncubateParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Instrument->Link,
				Time->Real,
				Temperature->Real,
				AnnealingTime->Real,
				TemperatureProfile->Expression,
				PlateSeal->Link,
				RelativeHumidity->Real,
				LightExposure->Expression,
				LightExposureIntensity->VariableUnit,
				TotalLightExposure->VariableUnit,
				Transform->Boolean,
				TransformHeatShockTemperature->Real,
				TransformHeatShockTime->Real,
				TransformPreHeatCoolingTime->Real,
				TransformPostHeatCoolingTime->Real
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				Instrument->ObjectP[{Object[Instrument],Model[Instrument]}],
				Time->TimeP,
				Temperature->TemperatureP,
				AnnealingTime->TimeP,
				TemperatureProfile->{{TimeP,TemperatureP}..},
				PlateSeal->ObjectP[{Model[Item],Object[Item]}],
				RelativeHumidity->GreaterP[0 Percent],
				LightExposure->EnvironmentalChamberLightTypeP,
				LightExposureIntensity->GreaterEqualP[0 (Watt/(Meter^2))] | GreaterEqualP[0 (Lumen/(Meter^2))],
				TotalLightExposure->GreaterEqualP[0 (Watt*Hour/(Meter^2))] | GreaterEqualP[0 (Lumen*Hour/(Meter^2))],
				Transform->BooleanP,
				TransformHeatShockTemperature->GreaterEqualP[0*Kelvin],
				TransformHeatShockTime->GreaterEqualP[0*Minute],
				TransformPreHeatCoolingTime->GreaterEqualP[0*Second],
				TransformPostHeatCoolingTime->GreaterEqualP[0*Minute]
			},
			Relation->{
				Sample->Object[Sample],
				Instrument->Object[Instrument]|Model[Instrument],
				Time->Null,
				Temperature->Null,
				AnnealingTime->Null,
				TemperatureProfile->Null,
				PlateSeal->Alternatives[Model[Item],Object[Item]],
				RelativeHumidity->Null,
				LightExposure->Null,
				LightExposureIntensity->Null,
				TotalLightExposure->Null,
				Transform->Null,
				TransformHeatShockTemperature->Null,
				TransformHeatShockTime->Null,
				TransformPreHeatCoolingTime->Null,
				TransformPostHeatCoolingTime->Null
			},
			Units->{
				Sample->None,
				Instrument->None,
				Time->Minute,
				Temperature->Celsius,
				AnnealingTime->Minute,
				TemperatureProfile->None,
				PlateSeal->None,
				RelativeHumidity->Percent,
				LightExposure->None,
				LightExposureIntensity->None,
				TotalLightExposure->None,
				Transform->None,
				TransformHeatShockTemperature->Celsius,
				TransformHeatShockTime->Second,
				TransformPreHeatCoolingTime->Minute,
				TransformPostHeatCoolingTime->Minute
			},
			Description->"Specifies how samples should be incubated (without mixing) in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		IncubateIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in IncubateParameters, as they relate to SamplesIn. We need this field because samples can show up multiple times in SamplesIn and we need an index to disambiguate multiple occurrences of the same sample in the WorkingSamples field.",
			Category->"Incubation",
			Developer->True
		},
		IncubateBatchLength->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The batch lengths that correspond to the sample groupings of IncubateParameters.",
			Category->"Incubation",
			Developer->True
		},

		(*-- INVERT FIELDS --*)
		InvertParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				NumberOfMixes->Integer,
				MaxNumberOfMixes->Integer,
				AdditionalNumberOfMixes->Integer,
				MixUntilDissolved->Boolean
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				NumberOfMixes->GreaterEqualP[0],
				MaxNumberOfMixes->GreaterEqualP[0],
				AdditionalNumberOfMixes->GreaterEqualP[0],
				MixUntilDissolved->BooleanP
			},
			Relation->{
				Sample->Object[Sample],
				NumberOfMixes->Null,
				MaxNumberOfMixes->Null,
				AdditionalNumberOfMixes->Null,
				MixUntilDissolved->Null
			},
			Units->{
				Sample->None,
				NumberOfMixes->None,
				MaxNumberOfMixes->None,
				AdditionalNumberOfMixes->None,
				MixUntilDissolved->None
			},
			Description->"Specifies how samples should be inverted in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		InvertFullyDissolved->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For the samples that are to be mixed via inversion until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},
		InvertIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in InvertParameters, as they relate to SamplesIn. We need this field because samples can show up multiple times in SamplesIn and we need an index to disambiguate multiple occurrences of the same sample in the WorkingSamples field.",
			Category->"Incubation",
			Developer->True
		},

		(*-- PIPETTE FIELDS --*)
		PipetteParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Primitive->Expression,
				AdditionalPrimitive->Expression,
				NumberOfMixes->Integer,
				MaxNumberOfMixes->Integer,
				MixUntilDissolved->Boolean,
				Volume->Real,
				Tips->Link
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				Primitive->SampleManipulationP|SamplePreparationP|Null,
				AdditionalPrimitive->SampleManipulationP|SamplePreparationP|Null,
				NumberOfMixes->GreaterEqualP[0],
				MaxNumberOfMixes->GreaterEqualP[0],
				MixUntilDissolved->BooleanP,
				Volume->VolumeP,
				Tips->_Link
			},
			Relation->{
				Sample->Object[Sample],
				Primitive->Null,
				AdditionalPrimitive->Null,
				NumberOfMixes->Null,
				MaxNumberOfMixes->Null,
				MixUntilDissolved->Null,
				Volume->Null,
				Tips->Alternatives[
					Model[Item, Tips],
					Object[Item, Tips]
				]
			},
			Units->{
				Sample->None,
				Primitive->None,
				AdditionalPrimitive->None,
				NumberOfMixes->None,
				MaxNumberOfMixes->None,
				MixUntilDissolved->None,
				Volume->Liter,
				Tips->None
			},
			Description->"Specifies how samples should be mixed via pipette in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		PipetteFullyDissolved->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For the samples that are to be mixed via pipette until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},
		PipetteIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in PipetteParameters, as they relate to SamplesIn. We need this field because samples can show up multiple times in SamplesIn and we need an index to disambiguate multiple occurrences of the same sample in the WorkingSamples field.",
			Category->"Incubation",
			Developer->True
		},

		(*-- VORTEX FIELDS --*)
		VortexParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Instrument->Link,
				Location->Expression,
				Rate->Real,
				InstrumentRate->Real,
				Time->Real,
				MaxTime->Real,
				MixUntilDissolved->Boolean,
				Temperature->Real,
				AnnealingTime->Real,
				ResidualIncubation->Boolean
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				Instrument->ObjectP[{Model[Instrument],Object[Instrument]}],
				Location->_List|_String,
				Rate->RPMP,
				InstrumentRate->GreaterEqualP[0],
				Time->TimeP,
				MaxTime->TimeP,
				MixUntilDissolved->BooleanP,
				Temperature->TemperatureP,
				AnnealingTime->TimeP,
				ResidualIncubation->BooleanP
			},
			Relation->{
				Sample->Object[Sample],
				Instrument->Model[Instrument]|Object[Instrument],
				Location->Null,
				Rate->Null,
				InstrumentRate->Null,
				Time->Null,
				MaxTime->Null,
				MixUntilDissolved->Null,
				Temperature->Null,
				AnnealingTime->Null,
				ResidualIncubation->Null
			},
			Units->{
				Sample->None,
				Instrument->None,
				Location->None,
				Rate->RPM,
				InstrumentRate->None,
				Time->Minute,
				MaxTime->Minute,
				MixUntilDissolved->None,
				Temperature->Celsius,
				AnnealingTime->Minute,
				ResidualIncubation->None
			},
			Description->"Specifies how samples should be pipetted in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		VortexIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in VortexParametersTest, as they relate to SamplesIn. We need this field because samples can show up multiple times in SamplesIn and we need an index to disambiguate multiple occurrences of the same sample in the WorkingSamples field.",
			Category->"Incubation",
			Developer->True
		},
		VortexBatchLength->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The batch lengths that correspond to the sample groupings of VortexParametersTest.",
			Category->"Incubation",
			Developer->True
		},
		VortexFullyDissolved->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MultipleChoiceAnswerP,
			Description->"For the samples that are to be mixed via vortexing until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},

		(*-- DISRUPT FIELDS --*)
		DisruptParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Instrument->Link,
				Location->Expression,
				Rate->Real,
				Time->Real,
				MaxTime->Real,
				MixUntilDissolved->Boolean,
				Temperature->Real,
				AnnealingTime->Real,
				ResidualIncubation->Boolean
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				Instrument->ObjectP[{Model[Instrument],Object[Instrument]}],
				Location->_List|_String,
				Rate->RPMP,
				Time->TimeP,
				MaxTime->TimeP,
				MixUntilDissolved->BooleanP,
				Temperature->TemperatureP,
				AnnealingTime->TimeP,
				ResidualIncubation->BooleanP
			},
			Relation->{
				Sample->Object[Sample],
				Instrument->Model[Instrument]|Object[Instrument],
				Location->Null,
				Rate->Null,
				Time->Null,
				MaxTime->Null,
				MixUntilDissolved->Null,
				Temperature->Null,
				AnnealingTime->Null,
				ResidualIncubation->Null
			},
			Units->{
				Sample->None,
				Instrument->None,
				Location->None,
				Rate->RPM,
				Time->Minute,
				MaxTime->Minute,
				MixUntilDissolved->None,
				Temperature->Celsius,
				AnnealingTime->Minute,
				ResidualIncubation->None
			},
			Description->"Specifies how samples should be mixed via disruption in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		DisruptIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in DisruptParameters, as they relate to SamplesIn. We need this field because samples can show up multiple times in SamplesIn and we need an index to disambiguate multiple occurrences of the same sample in the WorkingSamples field.",
			Category->"Incubation",
			Developer->True
		},
		DisruptBatchLength->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The batch lengths that correspond to the sample groupings of DisruptParameters.",
			Category->"Incubation",
			Developer->True
		},
		DisruptFullyDissolved->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MultipleChoiceAnswerP,
			Description->"For the samples that are to be mixed via disruption until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},

		(*-- NUTATE FIELDS --*)
		NutateIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in NutateParameters, as they relate to SamplesIn.",
			Category->"Incubation",
			Developer->True
		},
		NutateParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Instrument->Link,
				Rate->Real,
				Time->Real,
				MaxTime->Real,
				Temperature->Real,
				AnnealingTime->Real,
				MixUntilDissolved->Boolean,
				ResidualIncubation->Boolean
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				Instrument->ObjectP[{Model[Instrument],Object[Instrument]}],
				Rate->RPMP,
				Time->TimeP,
				MaxTime->TimeP,
				Temperature->TemperatureP,
				AnnealingTime->TimeP,
				MixUntilDissolved->BooleanP,
				ResidualIncubation->BooleanP
			},
			Relation->{
				Sample->Object[Sample],
				Instrument->Model[Instrument]|Object[Instrument],
				Rate->Null,
				Time->Null,
				MaxTime->Null,
				Temperature->Null,
				AnnealingTime->Null,
				MixUntilDissolved->Null,
				ResidualIncubation->Null
			},
			Units->{
				Sample->None,
				Instrument->None,
				Rate->RPM,
				Time->Minute,
				MaxTime->Minute,
				Temperature->Celsius,
				AnnealingTime->Minute,
				MixUntilDissolved->None,
				ResidualIncubation->None
			},
			Description->"Specifies how samples should be nutated in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		NutateBatchLength->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The batch lengths that correspond to the sample groupings of NutateParameters.",
			Category->"Incubation",
			Developer->True
		},
		NutateFullyDissolved->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MultipleChoiceAnswerP,
			Description->"For the samples that are to be mixed via nutation until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},

		(*-- SHAKE FIELDS --*)
		ShakeIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in ShakeParameters, as they relate to SamplesIn.",
			Category->"Incubation",
			Developer->True
		},
		ShakeParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Instrument->Link,
				Location->Expression,
				Rate->VariableUnit,
				Time->Real,
				MaxTime->Real,
				Temperature->Real,
				AnnealingTime->Real,
				MixUntilDissolved->Boolean,
				ResidualIncubation->Boolean,
				MixRateProfile->Expression,
				TemperatureProfile->Expression,
				OscillationAngle->Real,
				ShakerAdapter->Link
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				Instrument->ObjectP[{Model[Instrument],Object[Instrument]}],
				Location->_List|_String,
				Rate->RPMP|GreaterP[0 GravitationalAcceleration],
				Time->TimeP,
				MaxTime->TimeP,
				Temperature->TemperatureP,
				AnnealingTime->TimeP,
				MixUntilDissolved->BooleanP,
				ResidualIncubation->BooleanP,
				MixRateProfile->_List,
				TemperatureProfile->_List,
				OscillationAngle->GreaterEqualP[0 AngularDegree],
				ShakerAdapter->_Link
			},
			Relation->{
				Sample->Object[Sample],
				Instrument->Model[Instrument]|Object[Instrument],
				Location->Null,
				Rate->Null,
				Time->Null,
				MaxTime->Null,
				Temperature->Null,
				AnnealingTime->Null,
				MixUntilDissolved->Null,
				ResidualIncubation->Null,
				MixRateProfile->Null,
				TemperatureProfile->Null,
				OscillationAngle->Null,
				ShakerAdapter->Model[Part]|Object[Part]|Model[Container,Rack]|Object[Container,Rack]
			},
			Units->{
				Sample->None,
				Instrument->None,
				Location->None,
				Rate->None,
				Time->Minute,
				MaxTime->Minute,
				Temperature->Celsius,
				AnnealingTime->Minute,
				MixUntilDissolved->None,
				ResidualIncubation->None,
				MixRateProfile->None,
				TemperatureProfile->None,
				OscillationAngle->AngularDegree,
				ShakerAdapter->None
			},
			Description->"Specifies how samples should be shaked in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		ShakeBatchLength->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The batch lengths that correspond to the sample groupings of ShakeParameters.",
			Category->"Incubation",
			Developer->True
		},
		ShakeFullyDissolved->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MultipleChoiceAnswerP,
			Description->"For the samples that are to be mixed via shaking until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},
		ShakerAdapterPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container, Rack]|Model[Container, Rack]|Model[Part, ShakerAdapter]|Object[Part, ShakerAdapter], Object[Instrument, Shaker]|Model[Instrument, Shaker], Null},
			Description -> "List of placements for placing adapters onto the Shaker instrument. Currently, this field is only populated when shaker is Incu-Shaker.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		ShakerSamplePlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Container, Rack]|Model[Container, Rack]|Model[Part, ShakerAdapter]|Object[Part, ShakerAdapter], Null},
			Description -> "List of sample placements for placing sample containers onto shake adapters. Currently, this field is only populated when shaker is Genie Temp-Shaker.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},

		(*-- ROLL FIELDS --*)
		RollIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"For Roll mixing with BottleRoller, indicates the indices of each sample in RollParameters, as they relate to SamplesIn; for Roll mixing with Roller, indicates the indices of each rack in RollParameters.",
			Category->"Incubation",
			Developer->True
		},
		RollParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Instrument->Link,
				Location->Expression,
				Rate->Real,
				Time->Real,
				MaxTime->Real,
				Temperature->Real,
				AnnealingTime->Real,
				MixUntilDissolved->Boolean,
				ResidualIncubation->Boolean,
				BatchedSampleIndices -> Expression,
				RollerRack -> Link,
				SamplePlacements -> Expression
			},
			Pattern:>{
				Sample->ObjectP[{Object[Sample], Object[Container, Rack]}],
				Instrument->ObjectP[{Model[Instrument],Object[Instrument]}],
				Location->_List|_String,
				Rate->RPMP,
				Time->TimeP,
				MaxTime->TimeP,
				Temperature->TemperatureP,
				AnnealingTime->TimeP,
				MixUntilDissolved->BooleanP,
				ResidualIncubation->BooleanP,
				BatchedSampleIndices -> (_List|Null),
				RollerRack -> _Link,
				SamplePlacements -> (_List|Null)
			},
			Relation->{
				Sample->Object[Sample]|Object[Container, Rack],
				Instrument->Model[Instrument]|Object[Instrument],
				Location->Null,
				Rate->Null,
				Time->Null,
				MaxTime->Null,
				Temperature->Null,
				AnnealingTime->Null,
				MixUntilDissolved->Null,
				ResidualIncubation->Null,
				BatchedSampleIndices -> Null,
				RollerRack -> Object[Container, Rack]|Model[Container, Rack],
				SamplePlacements -> Null
			},
			Units->{
				Sample->None,
				Instrument->None,
				Location->None,
				Rate->RPM,
				Time->Minute,
				MaxTime->Minute,
				Temperature->Celsius,
				AnnealingTime->Minute,
				MixUntilDissolved->None,
				ResidualIncubation->None,
				BatchedSampleIndices -> None,
				RollerRack -> None,
				SamplePlacements -> None
			},
			Description->"Specifies how samples should be rolled in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		RollBatchLength->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The batch lengths that correspond to the sample or rack groupings of RollParameters.",
			Category->"Incubation",
			Developer->True
		},
		RollFullyDissolved->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MultipleChoiceAnswerP,
			Description->"For the samples that are to be mixed via rolling until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},
		RollerRackPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container, Rack]|Model[Container, Rack], Object[Instrument, Roller]|Model[Instrument, Roller], Null},
			Description -> "List of roller rack placements for placing tube racks onto the rolling deck of Roller instrument. This field is Null if the instrument is not Roller.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		RollerSamplePlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Container, Rack]|Model[Container, Rack], Null},
			Description -> "List of roller sample placements for placing roller sample containers onto tube racks. This filed is Null if the instrument is not Roller.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},

		(*-- STIR FIELDS --*)
		StirIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in StirParameters, as they relate to SamplesIn.",
			Category->"Incubation",
			Developer->True
		},
		StirParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Impeller->Link,
				Instrument->Link,
				Rate->Real,
				Time->Real,
				MaxTime->Real,
				Temperature->Real,
				AnnealingTime->Real,
				MixUntilDissolved->Boolean,
				ResidualIncubation->Boolean,
				StirBar->Link,
				StirBarRetriever->Link
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				Impeller->ObjectP[{Model[Part,StirrerShaft],Object[Part,StirrerShaft]}],
				Instrument->ObjectP[{Model[Instrument],Object[Instrument]}],
				Rate->RPMP,
				Time->TimeP,
				MaxTime->TimeP,
				Temperature->TemperatureP,
				AnnealingTime->TimeP,
				MixUntilDissolved->BooleanP,
				ResidualIncubation->BooleanP,
				StirBar->_Link,
				StirBarRetriever->_Link
			},
			Relation->{
				Sample->Object[Sample],
				Impeller->Model[Part,StirrerShaft]|Object[Part,StirrerShaft],
				Instrument->Model[Instrument]|Object[Instrument],
				Rate->Null,
				Time->Null,
				MaxTime->Null,
				Temperature->Null,
				AnnealingTime->Null,
				MixUntilDissolved->Null,
				ResidualIncubation->Null,
				StirBar->Model[Part,StirBar]|Object[Part,StirBar],
				StirBarRetriever->Model[Part,StirBarRetriever]|Object[Part,StirBarRetriever]
			},
			Units->{
				Sample->None,
				Impeller->None,
				Instrument->None,
				Rate->RPM,
				Time->Minute,
				MaxTime->Minute,
				Temperature->Celsius,
				AnnealingTime->Minute,
				MixUntilDissolved->None,
				ResidualIncubation->None,
				StirBar->None,
				StirBarRetriever->None
			},
			Description->"Specifies how samples should be stirred in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		StirFullyDissolved->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MultipleChoiceAnswerP,
			Description->"For the samples that are to be mixed via stirring until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},

		(*-- SONICATE FIELDS --*)
		SonicateParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Instrument->Link,
				Time->Real,
				MaxTime->Real,
				MixUntilDissolved->Boolean,
				Temperature->Real,
				ResidualIncubation->Boolean,
				DutyCycleOnTime->Real,
				DutyCycleOffTime->Real,
				Amplitude->Real,
				MaxTemperature->Real,
				PreSonicationTime -> Real,
				SonicationAdapter -> Link,
				AlternateInstruments -> Expression
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				Instrument->ObjectP[{Model[Instrument],Object[Instrument]}],
				Time->TimeP,
				MaxTime->TimeP,
				MixUntilDissolved->BooleanP,
				Temperature->TemperatureP,
				ResidualIncubation->BooleanP,
				DutyCycleOnTime->TimeP,
				DutyCycleOffTime->TimeP,
				Amplitude->PercentP,
				MaxTemperature->TemperatureP,
				PreSonicationTime -> TimeP,
				SonicationAdapter -> ObjectP[{Model[Part,FlaskRing],Object[Part, FlaskRing],Model[Container,Rack],Object[Container,Rack]}],
				AlternateInstruments -> (_List|Null)
			},
			Relation->{
				Sample->Object[Sample],
				Instrument->Model[Instrument]|Object[Instrument],
				Time->Null,
				MaxTime->Null,
				MixUntilDissolved->Null,
				Temperature->Null,
				ResidualIncubation->Null,
				DutyCycleOnTime->Null,
				DutyCycleOffTime->Null,
				Amplitude->Null,
				MaxTemperature->Null,
				PreSonicationTime -> Null,
				SonicationAdapter -> Model[Part,FlaskRing]|Object[Part, FlaskRing]|Model[Container,Rack]|Object[Container,Rack],
				AlternateInstruments -> Null
			},
			Units->{
				Sample->None,
				Instrument->None,
				Time->Minute,
				MaxTime->Minute,
				MixUntilDissolved->None,
				Temperature->Celsius,
				ResidualIncubation->None,
				DutyCycleOnTime->Second,
				DutyCycleOffTime->Second,
				Amplitude->Percent,
				MaxTemperature->Celsius,
				PreSonicationTime -> Minute,
				SonicationAdapter -> None,
				AlternateInstruments -> None
			},
			Description->"Specifies how samples should be sonicated in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		SonicateIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in SonicateParameters, as they relate to SamplesIn.",
			Category->"Incubation",
			Developer->True
		},
		SonicateBatchLength->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The batch lengths that correspond to the sample groupings of SonicateParameters.",
			Category->"Incubation",
			Developer->True
		},
		SonicateFullyDissolved->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MultipleChoiceAnswerP,
			Description->"For the samples that are to be mixed via sonication until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},
		(* Note: The homogenizer is the only heating instrument (other than the incubators) that has a temperature probe on it. *)
		SonicationTemperatureData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"A field used to record the current temperature of the sonication bath when the samples are placed in the water bath for sonication (for samples that are to be heated while sonicated).",
			Category->"Incubation"
		},
		SonicatorSamplePlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Container, Rack]|Model[Container, Rack], Null},
			Description -> "List of sonicator sample placements for placing sonicator sample containers onto tube racks. This field is Null if the sonicator adapter is not rack.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		SonicationTemperatures -> {
			Format -> Multiple,
			Class -> {Sample->Link, Time->Date, Temperature ->Real},
			Pattern :> {Sample->_Link, Time->_?DateObjectQ, Temperature->TemperatureP},
			Relation -> {Sample->Object[Sample],Time->Null, Temperature -> Null},
			Units->{Sample -> None, Time -> None, Temperature->Celsius},
			Description -> "The measured temperature of sonicator water bath that the sample is incubated in at this time point.",
			Category -> "Incubation",
			Headers -> {Sample->"Sample", Time->"Time of Temperature Measurement", Temperature -> "Temperature of Sample"},
			Developer->True
		},
		SonicateSampleTemperatures -> {
			Format -> Multiple,
			Class -> {Sample->Link, Time->Expression, Temperature ->Expression},
			Pattern :> {Sample->ObjectP[Object[Sample]], Time->(_List|Null), Temperature -> (_List|Null)},
			Relation->{Sample->Object[Sample], Time-> Null, Temperature -> Null},
			Description -> "The measured temperature of sonicator water bath during sonication for each sample in SonicateParameters.",
			Category -> "Incubation",
			Headers -> {Sample->"Sample", Time->"Time of Temperature Measurement", Temperature -> "Temperature of Sample"}
		},
		CurrentSonicationTime -> {
			Format->Single,
			Class->Real,
			Pattern:>TimeP,
			Units->Minute,
			Description->"The time that the current sonicator will mix sample before the next check in stage.",
			Category->"Incubation",
			Developer->True
		},
		SonicatorRemainingTimes -> {
			Format -> Multiple,
			Class -> {Instrument->Link, RemainingSonicationTime->Real},
			Pattern :> {Instrument->_Link, RemainingSonicationTime->TimeP},
			Relation -> {Instrument->Object[Instrument, Sonicator],RemainingSonicationTime->Null},
			Units->{Instrument -> None, RemainingSonicationTime -> Minute},
			Description -> "The remaining sonication time of sonicators that will enter the next check in stage.",
			Category -> "Incubation",
			Headers -> {Instrument->"Sample", RemainingSonicationTime->"Remaining Sonication Time"},
			Developer->True
		},
		ProbeStorageContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Sensor, Temperature]|Object[Item, Lid], Null},
			Description -> "List of container placements for placing the temperature probe and the reservoir lid into their storage positions on the sonicator.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		ProbeInUseContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Sensor, Temperature], Null},
			Description -> "List of container placements for placing the temperature probe to the sonicator Probe InUse Slot for temperature measurement in the current incubation.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},

		(*-- HOMOGENIZE FIELDS --*)
		HomogenizeIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in HomogenizeParameters, as they relate to SamplesIn.",
			Category->"Incubation",
			Developer->True
		},
		HomogenizeParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				Horn->Link,
				Instrument->Link,
				Time->Real,
				MaxTime->Real,
				DutyCycleOnTime->Real,
				DutyCycleOffTime->Real,
				Amplitude->Real,
				Temperature->Real,
				MaxTemperature->Real,
				AnnealingTime->Real,
				MixUntilDissolved->Boolean,
				ResidualIncubation->Boolean
			},
			Pattern:>{
				Sample->_Link,
				Horn->_Link,
				Instrument->_Link,
				Time->TimeP,
				MaxTime->TimeP,
				DutyCycleOnTime->TimeP,
				DutyCycleOffTime->TimeP,
				Amplitude->PercentP,
				Temperature->TemperatureP,
				MaxTemperature->TemperatureP,
				AnnealingTime->TimeP,
				MixUntilDissolved->BooleanP,
				ResidualIncubation->BooleanP
			},
			Relation->{
				Sample->Object[Sample],
				Horn->Model[Part,SonicationHorn]|Object[Part,SonicationHorn],
				Instrument->Model[Instrument]|Object[Instrument],
				Time->Null,
				MaxTime->Null,
				DutyCycleOnTime->Null,
				DutyCycleOffTime->Null,
				Amplitude->Null,
				Temperature->Null,
				MaxTemperature->Null,
				AnnealingTime->Null,
				MixUntilDissolved->Null,
				ResidualIncubation->Null
			},
			Units->{
				Sample->None,
				Horn->None,
				Instrument->None,
				Time->Minute,
				MaxTime->Minute,
				DutyCycleOnTime->Second,
				DutyCycleOffTime->Second,
				Amplitude->Percent,
				Temperature->Celsius,
				MaxTemperature->Celsius,
				AnnealingTime->Minute,
				MixUntilDissolved->None,
				ResidualIncubation->None
			},
			Description->"Specifies how samples should be homogenized in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		HomogenizeFullyDissolved->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MultipleChoiceAnswerP,
			Description->"For the samples that are to be mixed via homogenization until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},

		(*-- SWIRL FIELDS --*)
		SwirlParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				NumberOfMixes->Integer,
				MaxNumberOfMixes->Integer,
				AdditionalNumberOfMixes->Integer,
				MixUntilDissolved->Boolean
			},
			Pattern:>{
				Sample->ObjectP[Object[Sample]],
				NumberOfMixes->GreaterEqualP[0],
				MaxNumberOfMixes->GreaterEqualP[0],
				AdditionalNumberOfMixes->GreaterEqualP[0],
				MixUntilDissolved->BooleanP
			},
			Relation->{
				Sample->Object[Sample],
				NumberOfMixes->Null,
				MaxNumberOfMixes->Null,
				AdditionalNumberOfMixes->Null,
				MixUntilDissolved->Null
			},
			Units->{
				Sample->None,
				NumberOfMixes->None,
				MaxNumberOfMixes->None,
				AdditionalNumberOfMixes->None,
				MixUntilDissolved->None
			},
			Description->"Specifies how samples should be swirled in this procedure.",
			Category->"Incubation",
			Developer->True
		},
		SwirlFullyDissolved->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For the samples that are to be mixed via swirling until they are fully dissolved (MixUntilDissolved is True), indicates if the samples were determined to have been fully dissolved by visual inspection after mixing.",
			Category->"Incubation"
		},
		SwirlIndices->{
			Format->Multiple,
			Class->Real,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in SwirlParameters, as they relate to SamplesIn. We need this field because samples can show up multiple times in SamplesIn and we need an index to disambiguate multiple occurrences of the same sample in the WorkingSamples field.",
			Category->"Incubation",
			Developer->True
		},

		(*-- TRANSFORM FIELDS --*)
		(* Options *)
		Transform->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates if SamplesIn are heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
			Category->"Incubation"
		},
		TransformHeatShockTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature at which the cells are heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
			Category->"Incubation"
		},
		TransformHeatShockTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the length of time for which the cells are heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
			Category->"Incubation"
		},
		TransformPreHeatCoolingTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Minute,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the length of time for which the cells are cooled prior to heat shocking.",
			Category->"Incubation"
		},
		TransformPostHeatCoolingTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the length of time for which the cells are cooled after heat shocking.",
			Category->"Incubation"
		},
		TransformRecoveryMedia -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the nutrient-rich growth medium used to support the recovery of heat shocked cells. The sample objects are used in full in their current containers and should be prepared prior to the experiment.",
			Category -> "Incubation"
		},

		(* Fixed options *)
		TransformRecoveryTransferVolumes -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0 Microliter], GreaterP[0 Microliter]},
			Units -> {Microliter, Microliter},
			Headers -> {"Initial transfer volume", "Secondary transfer volume"},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the volume of TransformRecoveryMedia added to the heat shocked cells, and the volume of the resulting mixture which is immediately transferred back into the container of TransformRecoveryMedia for incubation.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformRecoveryIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The duration for which the mixtures of heat shocked cells and TransformRecoveryMedia are housed in TransformIncubator for recovery.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformIncubator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, Incubator],
				Model[Instrument, Incubator]
			],
			Description -> "The incubator used to house the mixtures of heat shocked cells and TransformRecoveryMedia for recovery. The field is populated by a model object prior to run time, and updated to an object during the course of the experiment.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformIncubatorTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the mixtures of heat shocked cells and TransformRecoveryMedia are housed in for recovery. The relevant parameter of TransformIncubator is set to this value; currently limited to 37 Degrees Celsius for incubation of bacterial cells.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformIncubatorShakingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The frequency at which the mixtures of heat shocked cells and TransformRecoveryMedia are agitated by movement in a circular motion for recovery. The relevant parameter of TransformIncubator is set to this value; currently limited to 200 RPM for incubation of bacterial cells.",
			Category -> "Incubation",
			Developer -> True
		},

		(* Developer fields *)
		TransformCooler->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Instrument, PortableCooler],
				Object[Container, PortableCooler],
				Model[Instrument, PortableCooler],
				Model[Container, PortableCooler]
			],
			Description->"The cooler used to cool the cells before and after heat shocking.",
			Category->"Incubation",
			Developer->True
		},
		TransformRemainingPreHeatCoolingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Minute,
			Description->"The length of time still required to cool the current sample before heat shocking after all incubation devices are set up.",
			Category->"Incubation",
			Developer->True
		},
		TransformCurrentHeatShockTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For the current batch of samples, the length of time for which the cells are heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
			Category->"Incubation",
			Developer->True
		},
		TransformCurrentPostHeatCoolingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"For the current batch of samples, the length of time for which the cells are cooled after heat shocking.",
			Category->"Incubation",
			Developer->True
		},
		TransformActualHeatShockTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Minute,
			Description->"For the current batch of samples, the total duration of the task during which the cells were heat-shocked in order to disrupt the cell membrane and allow the plasmid to be taken up and incorporated into the cell.",
			Category->"Incubation",
			Developer->True
		},
		TransformActualPostHeatCoolingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Minute,
			Description->"For the current batch of samples, the total duration of the task during which the cells were cooled after heat shocking.",
			Category->"Incubation",
			Developer->True
		},
		TransformCoolerTemperatures->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"A field used to record the actual temperature of the cooler immediately prior to heat shocking the cells.",
			Category->"Incubation",
			Developer->True
		},
		TransformCoolerPowerCable -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Wiring, Cable],
			Description -> "The power cable zip tied to the transform deck, designated for TransformCooler.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformCoolerConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, WiringConnectorNameP, _Link, WiringConnectorNameP},
			Relation -> {Object[Wiring, Cable], Null, Object[Instrument, PortableCooler], Null},
			Description -> "The connection information for charging TransformBiosafetyCabinet on the transform deck using TransformCoolerPowerCable.",
			Headers -> {"Charging cable", "Charging cable plug", "Portable cooler", "Portable cooler inlet"},
			Category -> "Incubation",
			Developer -> True
		},
		TransformHeatBlockTemperature -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "A field used to record the actual temperature of the heat block when warming TransformRecoveryMedia.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformBiosafetyCabinet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, HandlingStation, BiosafetyCabinet],
				Model[Instrument, HandlingStation, BiosafetyCabinet]
			],
			Description -> "The biosafety cabinet where TransformRecoveryMedia are added to the heat shocked cells.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformBiosafetyWasteBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, WasteBin],
				Model[Container, WasteBin]
			],
			Description -> "The waste bin brought into TransformBiosafetyCabinet to hold TransformBiosafetyWasteBag.",
			Category -> "General",
			Developer -> True
		},
		TransformBiosafetyWasteBag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Consumable],
				Model[Item, Consumable]
			],
			Description -> "The waste bag brought into TransformBiosafetyCabinet and placed in TransformBiosafetyWasteBin to collect biohazardous waste generated while working in the BSC.",
			Category -> "General",
			Developer -> True
		},
		TransformBiosafetyCabinetPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {
				Alternatives[
					Object[Container],
					Object[Item],
					Object[Sample],
					Object[Instrument],
					Object[Part]
				],
				Alternatives[
					Object[Instrument, HandlingStation, BiosafetyCabinet],
					Model[Instrument, HandlingStation, BiosafetyCabinet]
				],
				Null
			},
			Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
			Description -> "The specific positions in TransformBiosafetyCabinet that objects should be moved into.",
			Category -> "General",
			Developer -> True
		},
		TransformBiosafetyWasteBinPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {
				Alternatives[
					Object[Container, WasteBin],
					Model[Container, WasteBin]
				],
				Alternatives[
					Object[Instrument, HandlingStation, BiosafetyCabinet],
					Model[Instrument, HandlingStation, BiosafetyCabinet]
				],
				Null
			},
			Headers -> {"Waste bin to move", "BSC to move to", "Position to move to"},
			Description -> "The specific position in TransformBiosafetyCabinet that TransformBiosafetyWasteBin should be moved into.",
			Category -> "General",
			Developer -> True
		},
		TransformBiosafetyWasteBagPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {
				Alternatives[
					Object[Item, Consumable],
					Model[Item, Consumable]
				],
				Alternatives[
					Object[Container, WasteBin],
					Model[Container, WasteBin]
				],
				Null
			},
			Headers -> {"Waste Bag to move", "Waste Bin to move to", "Position to move to"},
			Description -> "The specific position in TransformBiosafetyWasteBin that TransformBiosafetyWasteBag should be moved into.",
			Category -> "General",
			Developer -> True
		},
		TransformRecoveryPipette -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, Pipette],
				Model[Instrument, Pipette]
			],
			Description -> "The pipette used to transfer TransformRecoveryMedia to the heat shocked cells.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformRecoveryTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Tips],
				Model[Item, Tips]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the pipette tip used when transferring TransformRecoveryMedia to the heat shocked cells.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformRecoveryTransferIndex -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The index of WorkingSamples and TransformRecoveryMedia used to identify the sample of heat shocked cells and recovery medium in the looping procedure of recovery transfer.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformRecoveryTransferPipetteDialImages -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {Object[EmeraldCloudFile], Object[EmeraldCloudFile]},
			Headers -> {"Initial transfer volume", "Secondary transfer volume"},
			IndexMatching -> TransformRecoveryTransferVolumes,
			Description -> "For each member of TransformRecoveryTransferVolumes, images that imitate what the dials of TransformRecoveryPipette should be set to for the initial and secondary recovery transfers.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformIncubatorStorageAvailabilities -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[StorageAvailability],
			Description -> "For each member of SamplesIn, the storage availability object that corresponds to a position in TransformIncubator.",
			Category -> "Incubation",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		TransformRecoveryIncubationStartTime -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The time when the mixtures of heat shocked cells and TransformRecoveryMedia are stored in TransformIncubator for recovery.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformRecoveryIncubationRemainingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The remaining TransformRecoveryIncubationTime after tearing down TransformBiosafetyCabinet. Calculated using TransformRecoveryIncubationStartTime to ensure that the mixtures of heat shocked cells and TransformRecoveryMedia are incubated for at least TransformRecoveryIncubationTime.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformIncubatorSensors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sensor, Temperature], Object[Sensor, CarbonDioxide], Object[Sensor, RelativeHumidity]],
			Description -> "The sensor objects inside TransformIncubator whose data need to be recorded during the processing stage of the experiment.",
			Category -> "Incubation",
			Developer -> True
		},
		TransformIncubatorEnvironmentalData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Data, Temperature], Object[Data, CarbonDioxide], Object[Data, RelativeHumidity]],
			Description -> "For each member of TransformIncubatorSensors, the data recorded from the sensor during the incubation.",
			Category -> "Incubation",
			IndexMatching -> TransformIncubatorSensors,
			Developer -> True
		},


		(*-- MULTI-INSTRUMENT FIELDS --*)
		(* Note that from here on down, all of the fields are DEVELOPER fields. The user cannot see them. The following fields deal with keeping track of where we are in our multi-instrument incubation. *)
		(* We keep track of a queue of incubation batches that still need to be processed. At procedure time, we intelligently search the lab for instrument availability and optimize for the best way to enqueue batches. *)
		(* We then take batches out of the queue and line them up for current incubation. We then go through the process of incubating the samples and potentially mixing them until they are dissolved. *)
		(* Note that all of the samples in a multi-instrument batch must be finished before we can request more instruments. It is for this reason that our optimizer tries to batch together runs of similar time length. *)
		(* For more information, see the incubation compiler. *)

		(* Keep track of the queue of incubation types and batches that we will have to process. *)
		(* In the resource packets function, this queue is populated. To start off, all batches are in the queue. *)
		QueuedIncubationTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,(* Null indicates incubation *)
			Description->"The incubation types of the batches that we still need to process.",
			Category->"Incubation",
			Developer->True
		},
		QueuedIncubationBatches->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_Integer,
			Description->"For each member of QueuedIncubationTypes, the index of the batch we need to incubate, in relation to its incubation type parameters field.",
			Category->"Incubation",
			IndexMatching->QueuedIncubationTypes,
			Developer->True
		},

		(* Indicates if all of the instruments are currently available or if the operator should exit the procedure and wait for ready check to indicate when the multi-instrument batch is ready to be submitted. *)
		(* Our multi-instrument compiler populates this field. Our optimizer looks into the future to see if it would be more efficient to wait up to 30 minutes before starting our batch because instruments are about to free up. *)
		(* If so, it will set InstrumentsAvailable\[Rule]False and we will start later. *)
		(* This field is not to be confused with the InstrumentsAvailable index in ReadyCheckResult. *)
		(* NOTE: If you change this you must update incubateInstrumentCheckText or instructions will get stuck *)
		InstrumentsAvailable->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the instruments for the current incubation batch are available for use.",
			Category->"Incubation",
			Developer->True
		},

		(* The following fields are used to keep track of the stack of incubation batches that we are CURRENTLY processing. *)
		CurrentIncubationTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MixTypeP,(* Null indicates incubation *)
			Description->"The incubation types of the batches we are currently incubating.",
			Category->"Incubation",
			Developer->True
		},
		CurrentIncubationBatches->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_Integer,
			Description->"For each member of CurrentIncubationTypes, the index of the batch we are currently incubating, in relation to its incubation type parameters field.",
			Category->"Incubation",
			IndexMatching->CurrentIncubationTypes,
			Developer->True
		},
		CurrentIncubationBatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_Integer,
			Description->"For each member of CurrentIncubationTypes, corresponding batch length for that batch (not the index of the batch but the batch length).",
			Category->"Incubation",
			IndexMatching->CurrentIncubationTypes,
			Developer->True
		},
		CurrentIncubationSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Object[Container, Rack],
			Description->"The samples that are going to be incubated during this round of multi-instrument incubation. Batched by the CurrentIncubationBatchLengths field.",
			Category->"Incubation",
			Developer->True
		},
		CurrentIncubationRackSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"If incubation is performed with Roller, indicates the samples on the current rack that finished incubation. Otherwise, this field is not used.",
			Category->"Incubation",
			Developer->True
		},
		CurrentIncubationParameters->{
			Format->Multiple,
			Class->{
				Instrument->Link,
				Time->Real,
				MaxTime->Real,
				Rate->VariableUnit,
				InstrumentRate->Real,
				MixUntilDissolved->Boolean,
				Temperature->Real,
				ResidualIncubation->Boolean,
				AnnealingTime->Real,
				Impeller->Link,
				Horn->Link,
				Amplitude->Real,
				DutyCycleOnTime->Real,
				DutyCycleOffTime->Real,
				MaxTemperature->Real,
				OscillationAngle->Real,
				TemperatureProfile->Expression,
				MixRateProfile->Expression,
				PlateSeal->Link,
				ShakerAdapter->Link,
				StirBarRetriever->Link,
				MethodFile->String,
				StirBar->Link,
				RelativeHumidity->Real,
				LightExposure->Expression,
				LightExposureIntensity->VariableUnit,
				TotalLightExposure->VariableUnit,
				Transform->Boolean,
				TransformHeatShockTemperature->Real,
				TransformHeatShockTime->Real,
				TransformPreHeatCoolingTime->Real,
				TransformPostHeatCoolingTime->Real,
				BatchedSampleIndices -> Expression,
				RollerRacks -> Expression,
				SamplePlacements -> Expression,
				SecondaryShakerAdapter -> Link,
				TertiaryShakerAdapter -> Link,
				QuaternaryShakerAdapter -> Link,
				SonicationAdapter -> Link,
				PreSonicationTime->Real
			},
			Pattern:>{
				Instrument->_Link,
				Time->TimeP,
				MaxTime->TimeP,
				Rate->RPMP|GreaterP[0 GravitationalAcceleration],
				InstrumentRate->_?NumericQ,
				MixUntilDissolved->BooleanP,
				Temperature->TemperatureP,
				ResidualIncubation->BooleanP,
				AnnealingTime->TimeP,
				Impeller->_Link,
				Horn->_Link,
				Amplitude->PercentP,
				DutyCycleOnTime->TimeP,
				DutyCycleOffTime->TimeP,
				MaxTemperature->TemperatureP,
				OscillationAngle->GreaterEqualP[0 AngularDegree],
				TemperatureProfile->(_List|Null),
				MixRateProfile->(_List|Null),
				PlateSeal->_Link,
				ShakerAdapter->_Link,
				StirBarRetriever->_Link,
				MethodFile->_String,
				StirBar->_Link,
				RelativeHumidity->GreaterP[0 Percent],
				LightExposure->EnvironmentalChamberLightTypeP,
				LightExposureIntensity->GreaterEqualP[0 (Watt/(Meter^2))] | GreaterEqualP[0 (Lumen/(Meter^2))],
				TotalLightExposure->GreaterEqualP[0 (Watt*Hour/(Meter^2))] | GreaterEqualP[0 (Lumen*Hour/(Meter^2))],
				Transform->BooleanP,
				TransformHeatShockTemperature->GreaterEqualP[0*Kelvin],
				TransformHeatShockTime->GreaterEqualP[0*Minute],
				TransformPreHeatCoolingTime->GreaterEqualP[0*Second],
				TransformPostHeatCoolingTime->GreaterEqualP[0*Minute],
				BatchedSampleIndices -> (_List|Null),
				RollerRacks -> (_List|Null),
				SamplePlacements -> (_List|Null),
				SecondaryShakerAdapter -> _Link,
				TertiaryShakerAdapter -> _Link,
				QuaternaryShakerAdapter -> _Link,
				SonicationAdapter -> _Link,
				PreSonicationTime -> TimeP
			},
			Relation->{
				Instrument->Model[Instrument]|Object[Instrument],
				Time->Null,
				MaxTime->Null,
				Rate->Null,
				InstrumentRate->Null,
				MixUntilDissolved->Null,
				Temperature->Null,
				ResidualIncubation->Null,
				AnnealingTime->Null,
				Impeller->Model[Part,StirrerShaft]|Object[Part,StirrerShaft],
				Horn->Model[Part,SonicationHorn]|Object[Part,SonicationHorn],
				Amplitude->Null,
				DutyCycleOnTime->Null,
				DutyCycleOffTime->Null,
				MaxTemperature->Null,
				OscillationAngle->Null,
				TemperatureProfile->Null,
				MixRateProfile->Null,
				PlateSeal->Alternatives[Model[Item],Object[Item]],
				ShakerAdapter->Model[Part]|Object[Part]|Model[Container,Rack]|Object[Container,Rack],
				StirBarRetriever->Alternatives[Model[Part],Object[Part]],
				MethodFile->Null,
				StirBar->Alternatives[Model[Part],Object[Part]],
				RelativeHumidity->Null,
				LightExposure->Null,
				LightExposureIntensity->Null,
				TotalLightExposure->Null,
				Transform->Null,
				TransformHeatShockTemperature->Null,
				TransformHeatShockTime->Null,
				TransformPreHeatCoolingTime->Null,
				TransformPostHeatCoolingTime->Null,
				BatchedSampleIndices -> Null,
				RollerRacks -> Null,
				SamplePlacements -> Null,
				SecondaryShakerAdapter -> Model[Part]|Object[Part]|Model[Container,Rack]|Object[Container,Rack],
				TertiaryShakerAdapter -> Model[Part]|Object[Part]|Model[Container,Rack]|Object[Container,Rack],
				QuaternaryShakerAdapter -> Model[Part]|Object[Part]|Model[Container,Rack]|Object[Container,Rack],
				SonicationAdapter -> Model[Part]|Object[Part]|Model[Container,Rack]|Object[Container,Rack],
				PreSonicationTime -> Null
			},
			Units->{
				Instrument->None,
				Time->Minute,
				MaxTime->Minute,
				Rate->None,
				InstrumentRate->None,
				MixUntilDissolved->None,
				Temperature->Celsius,
				ResidualIncubation->None,
				AnnealingTime->Minute,
				Impeller->None,
				Horn->None,
				Amplitude->Percent,
				DutyCycleOnTime->Second,
				DutyCycleOffTime->Second,
				MaxTemperature->Celsius,
				OscillationAngle->AngularDegree,
				TemperatureProfile->None,
				MixRateProfile->None,
				PlateSeal->None,
				ShakerAdapter->None,
				StirBarRetriever->None,
				MethodFile->None,
				StirBar->None,
				RelativeHumidity->Percent,
				LightExposure->None,
				LightExposureIntensity->None,
				TotalLightExposure->None,
				Transform->None,
				TransformHeatShockTemperature->Celsius,
				TransformHeatShockTime->Second,
				TransformPreHeatCoolingTime->Minute,
				TransformPostHeatCoolingTime->Minute,
				BatchedSampleIndices -> None,
				RollerRacks -> None,
				SamplePlacements -> None,
				SecondaryShakerAdapter -> None,
				TertiaryShakerAdapter -> None,
				QuaternaryShakerAdapter -> None,
				SonicationAdapter -> None,
				PreSonicationTime -> Minute
			},
			Description->"For each member of CurrentIncubationTypes, specifies how samples should be incubated (ex. temperatures, times, etc.) in this procedure.",
			IndexMatching->CurrentIncubationTypes,
			Category->"Incubation",
			Developer->True
		},
		CurrentProcessingTime->{
			Format->Single,
			Class->Real,
			Pattern:>TimeP,
			Units->Minute,
			Description->"The time that the current batch will take to finish (including the annealing time).",
			Category->"Incubation",
			Developer->True
		},
		CurrentStartDate->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"The time that the current round of incubation batches started.",
			Category->"Incubation",
			Developer->True
		},

		(* The following fields keep track of how we are mixing until dissolved while using multiple instruments. *)
		(* The IncubationStartTime field is used to detect time-outs when mixing until dissolved. *)
		(* We then have the operator check-in to see if all of the samples on all of the instruments are fully dissolved every 30 minutes. The ones that are fully dissolved are taken down and the instrument is released. We will continue mixing until we hit a time-out. *)
		(* Instruments are scheduled individually via PDU so we are guarenteed to not over mix. *)
		IncubationStartTime->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"The date we started to operate on our current sample.",
			Category->"Incubation",
			Developer->True
		},

		(* NOTE: These two fields are indexed to the current incubation batches that are running. False means that the batch is fully dissolved and don't continue mixing, True means that the batch is not fully dissolved and we keep mixing. *)
		CurrentMixUntilDissolved->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of CurrentIncubationTypes, indicates if we are currently mixing the given sample until it is dissolved. This field keeps updating as we release samples that have been dissolved.",
			Category->"Incubation",
			IndexMatching->CurrentIncubationTypes,
			Developer->True
		},
		TemporaryMixUntilDissolved->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each batch that is currently not dissolved, indicates if in this round of operator check-in, the batch is all dissolved. During each check-in while mixing until dissolved, we upload our instrument status to this field, then use this field to update CurrentMixUntilDissolved.",
			Category->"Incubation",
			Developer->True
		},

		(* NOTE: These fields have sample specific information -- that's why the third index of FullyDissolved is a list for the batch. *)
		FullyDissolved->{
			Format->Multiple,
			Class->{Expression,Integer,Expression},
			Pattern:>{_Symbol,_Integer,_List|BooleanP},
			Description->"Stores information about the completed batches of incubation and whether they were fully dissolved.",
			Category->"Incubation",
			Headers->{"Mix Type","Batch","Fully Dissolved List"},
			Developer->True
		},
		TemporaryFullyDissolved->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"A field that is used to store the fully dissolved information for a temporary batch. Information uploaded to this field from engine is stored in the FullyDissolved field.",
			Category->"Incubation",
			Developer->True
		},

		CurrentSampleHandling->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleHandlingP,
			Description->"Used as a temporary storage field to ask the operator what the sample handling of the current sample looks like, then we run an execute to update it in the sample.",
			Category->"Incubation",
			Developer->True
		},
		TemporaryMethodFileName->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The temporary method file that has been generated for the thermocycler run that is currently being loaded.",
			Category->"Incubation",
			Developer->True
		},

		(* This field is necessary because we keep overwritting the individual instrument field while swapping out our incubation batches -- so pricing would get messed up. *)
		InstrumentResources->{
			Format->Multiple,
			Class->{Expression,Integer,Link},
			Pattern:>{_Symbol,_Integer,_Link},
			Relation->{Null,Null,Object[Instrument]|Model[Instrument]},
			Description->"Stores information about all of the instruments used in the experiment, with their corresponding mix type and batch number.",
			Category->"Incubation",
			Headers->{"Mix Type","Batch","Instrument"},
			Developer->True
		},

		ProtocolKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The result of the ObjectToFileName call when run on this protocol object.",
			Category -> "General",
			Developer -> True
		}
	}
}];
