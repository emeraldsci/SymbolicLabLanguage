(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, AdjustpH], {
	Description -> "A detailed set of parameters that specifies the information of how to adjust the pH of a given sample to a target pH.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The samples that should be adjusted to a specified pH.",
			Category -> "General",
			Migration->SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The samples that should be adjusted to a specified pH.",
			Category -> "General",
			Migration->SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "The samples that should be adjusted to a specified pH.",
			Category -> "General",
			Migration->SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		NominalpH -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Relation -> Null,
			Description -> "For each member of SampleLink, the target pH to which the sample is to be adjusted.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		HistoricalData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, pHAdjustment],
			Description -> "For each member of SampleLink, the pH adjustment data used to determine the fixed additions in this protocol. The fixed additions and the titrant reflected in the data will be added as fixed additions in this protocol.",
			Category->"Pre-Titrated Additions",
			IndexMatching -> SampleLink
		},
		FixedAdditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{MassP|VolumeP|GreaterP[1], ObjectP[{Model[Sample], Object[Sample]}]}..}|None,
			Relation -> Null,
			Description -> "For each member of SampleLink, a list of all samples and amounts to add in the form {amount, sample}.",
			Category->"Pre-Titrated Additions",
			IndexMatching -> SampleLink
		},
		TitrationMethod -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Robotic|Manual,
			Relation -> Null,
			Description -> "For each member of SampleLink, if the transfer for pH adjustment is manual or robotic.",
			Category->"pH Titration",
			IndexMatching -> SampleLink
		},
		TitrationInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link|None,
			Relation -> Object[Instrument, pHTitrator]|Model[Instrument, pHTitrator],
			Description -> "For each member of SampleLink, the instrument for making transfer in pH adjustment.",
			Category->"pH Titration",
			IndexMatching -> SampleLink
		},
		TitrationContainerCap->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Cap],
				Object[Item, Cap]
			],
			Description -> "For each member of SampleLink, the cap that is used to assemble pH probe, overhead stir rod and tube of pHTitrator when TitrationMethod is set to Robotic.",
			Category->"pH Titration",
			IndexMatching -> SampleLink
		},
		pHMeter -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link|None,
			Relation -> Object[Instrument, pHMeter]|Model[Instrument, pHMeter],
			Description -> "For each member of SampleLink, the pH meter to be used for pH measurements.",
			Category->"pH Measurement",
			IndexMatching -> SampleLink
		},
		ProbeType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> pHProbeTypeP,
			Relation -> Null,
			Description -> "For each member of SampleLink, the type of pH meter (Surface or Immersion) to be used for measurement.",
			Category->"pH Measurement",
			IndexMatching -> SampleLink
		},
		Probe -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, pHProbe]|Model[Part, pHProbe],
			Description -> "For each member of SampleLink, the pH probe which is immersed in each sample for conductivity measurement.",
			Category->"pH Measurement",
			IndexMatching -> SampleLink
		},
		AcquisitionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Relation -> Null,
			Units -> Second,
			Description -> "For each member of SampleLink, the amount of time that data from the pH sensor should be acquired. 0 Second indicates that the pH sensor should be pinged instantaneously, collecting only 1 data point. When set, SensorNet pings the instrument in 1 second intervals. This option cannot be set for the non-Sensor Array pH instruments since they only provide a single pH reading.",
			Category->"pH Measurement",
			IndexMatching -> SampleLink
		},
		TemperatureCorrection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Linear,Off],
			Relation -> Null,
			Description -> "For each member of SampleLink, defines the relationship between temperature and pH. Linear: Use for the temperature correction of medium and highly conductive solutions. Off: The pH value at the current temperature is displayed.",
			Category->"pH Measurement",
			IndexMatching -> SampleLink
		},
		pHAliquot -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SampleLink, indicates if an aliquot should be taken from the input sample and used to measure the pH, as opposed to directly immersing the probe in the input sample.",
			Category->"pH Measurement",
			IndexMatching -> SampleLink
		},
		pHAliquotVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the volume to remove from the input sample and measure.",
			Category->"pH Measurement",
			IndexMatching -> SampleLink
		},
		RecoupSample -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SampleLink, indicates if the aliquot used to measure the pH should be returned to source container after each reading.",
			Category->"pH Measurement",
			IndexMatching -> SampleLink
		},
		Titrate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SampleLink, indicates if titrating acid and/or base should be added until the pH is within the bounds specified by MinpH and MaxpH or until MaxNumberOfCycles or MaxAdditionVolume is reached.",
			Category->"pH Titration",
			IndexMatching -> SampleLink
		},
		TitratingAcidLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "For each member of SampleLink, the acid used to adjust the pH of the solution.",
			Category->"pH Titration",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		TitratingAcidString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the acid used to adjust the pH of the solution.",
			Category->"pH Titration",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		TitratingBaseLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "For each member of SampleLink, the base used to adjust the pH of the solution.",
			Category->"pH Titration",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		TitratingBaseString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the base used to adjust the pH of the solution.",
			Category->"pH Titration",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		pHMixType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MixTypeP,
			Relation -> Null,
			Description -> "For each member of SampleLink, indicates the style of motion used to mix the sample.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		pHMixUntilDissolved -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Relation -> Null,
			Description -> "For each member of SampleLink, indicates if the mix should be continued up to the MaxTime or MaxNumberOfpHMixes (chosen according to the mix Type), in an attempt dissolve any solute.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		pHMixInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives@@Join[MixInstrumentModels, MixInstrumentObjects],
			Description -> "For each member of SampleLink, the instrument used to perform the Mix and/or Incubation.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		pHMixImpeller -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part,StirrerShaft],Object[Part,StirrerShaft]],
			Description -> "For each member of SampleLink, the stirring shaft that is compatible with the pHMixInstrument.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		pHMixTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Relation -> Null,
			Units -> Minute,
			Description -> "For each member of SampleLink, duration of time for which the samples will be mixed.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		MaxpHMixTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Relation -> Null,
			Units -> Minute,
			Description -> "For each member of SampleLink, maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the pHMixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		pHMixDutyCycle -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Null|{GreaterP[0 Minute], GreaterP[0 Minute]},
			Relation -> Null,
			Description -> "For each member of SampleLink, specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed. This option can only be set when mixing via homogenization.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		pHMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 RPM],
			Relation -> Null,
			Units -> RPM,
			Description -> "For each member of SampleLink, frequency of rotation the mixing instrument should use to mix the samples.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		NumberOfpHMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Relation -> Null,
			Units -> RPM,
			Description -> "For each member of SampleLink, number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		MaxNumberOfpHMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Relation -> Null,
			Units -> RPM,
			Description -> "For each member of SampleLink, maximum number of times for which the samples will be mixed, in an attempt to dissolve any solute, if the pHMixUntilDissolved option is chosen. Note this option only applies for mix type: Pipette or Invert.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		pHMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[1 Microliter],
			Relation -> Null,
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		pHMixTemperature -> {
			Format -> Multiple,
			Class->Expression,
			Pattern:>Alternatives[Ambient,GreaterP[0*Celsius]],
			Description -> "For each member of SampleLink, the temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		MaxpHMixTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Relation -> Null,
			Units -> Celsius,
			Description -> "For each member of SampleLink, the maximum temperature that the sample should reach during mixing via homogenization. If the measured temperature is above this MaxTemperature, the homogenizer will turn off until the measured temperature is 2C below the MaxTemperature, then it will automatically resume.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},
		pHHomogenizingAmplitude -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Relation -> Null,
			Units -> Percent,
			Description -> "For each member of SampleLink, the amplitude of the sonication horn when mixing via homogenization. When using a microtip horn (ex. for 2mL and 15mL tubes), the maximum amplitude is 70 Percent, as specified by the manufacturer, in order not to damage the instrument.",
			Category->"Mixing",
			IndexMatching -> SampleLink
		},

		(* pHing Limits *)
		MinpH -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Relation -> Null,
			Description -> "For each member of SampleLink, the values used to set the lower end of the nominal pH range. If the measured pH is between this minimum and the MaxpH titrations will stop. If the MaxNumberOfCycles or the MaxAdditionVolume is reached first, than the final pH may not be above this minimum.",
			Category->"pHing Limits",
			IndexMatching -> SampleLink
		},
		MaxpH -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Relation -> Null,
			Description -> "For each member of SampleLink, the values used to set the upper end of the nominal pH range. If the measured pH is above the MinpH and below this maximum pH titrations will stop. If the MaxNumberOfCycles or the MaxAdditionVolume is reached first, than the final pH may not be below this maximum.",
			Category->"pHing Limits",
			IndexMatching -> SampleLink
		},
		MaxAdditionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Relation -> Null,
			Units -> Milliliter,
			Description -> "For each member of SampleLink, indicates the maximum volume of TitratingAcid and TitratingBase that can be added during the course of titration before the experiment will continue, even if the nominalpH is not reached (pHsAchieved->False).",
			Category->"pHing Limits",
			IndexMatching -> SampleLink
		},
		MaxNumberOfCycles -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Relation -> Null,
			Units -> Milliliter,
			Description -> "For each member of SampleLink, indicates the maximum number of additions to make before stopping titrations during the course of titration before the experiment will continue, even if the nominalpH is not reached (pHsAchieved->False).",
			Category->"pHing Limits",
			IndexMatching -> SampleLink
		},
		MaxAcidAmountPerCycle -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 * Milligram] | GreaterP[0 * Milliliter],
			Relation -> Null,
			Description -> "For each member of SampleLink, indicates the maximum amount of TitratingAcid that can be added in a single titration cycle.",
			Category->"pHing Limits",
			IndexMatching -> SampleLink
		},
		MaxBaseAmountPerCycle -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 * Milligram] | GreaterP[0 * Milliliter],
			Relation -> Null,
			Description -> "For each member of SampleLink, indicates the maximum amount of TitratingBase that can be added in a single titration cycle.",
			Category->"pHing Limits",
			IndexMatching -> SampleLink
		},
		ContainerOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Vessel]|Object[Container,Vessel],
			Description -> "For each member of SampleLink, the container model in which the newly pH-adjusted sample should be stored after all adjustment steps have completed. If NumberOfReplicates is not Null, each replicate will be pooled back into the same ContainerOut. Null indicates the pH-adjusted sample remains in it's current container.",
			Category->"Storage Information",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		ContainerOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the container model in which the newly pH-adjusted sample should be stored after all adjustment steps have completed. If NumberOfReplicates is not Null, each replicate will be pooled back into the same ContainerOut. Null indicates the pH-adjusted sample remains in it's current container.",
			Category->"Storage Information",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		pHMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasurepH],
			Description -> "The protocols containing method information for the pH measurements performed on the input samples as their pHs were adjusted.",
			Category -> "Experimental Results"
		},
		pHsAchieved -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the desired pHs were achieved without exceeding the volume or iteration limits.",
			Category -> "Experimental Results",
			IndexMatching -> SampleLink
		},
		WashSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "For each member of SampleLink, the sample that are used to perform the first washing of the probe.",
			Category->"Cleaning",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		WashSolutionString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the sample that are used to perform the first washing of the probe.",
			Category->"Cleaning",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		SecondaryWashSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "For each member of SampleLink, the sample that are used to perform the second washing of the probe.",
			Category->"Cleaning",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		SecondaryWashSolutionString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the sample that are used to perform the second washing of the probe.",
			Category->"Cleaning",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		MaxpHSlope -> {
			Format->Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description-> "The maximum allowed pH slope, expressed as a percentage of the theoretical value. When the temperature is 25 °C, the theoretical value is 59.16 mV per pH unit, as calculated using the Nernst equation.",
			Category->"General"
		},
		MinpHSlope -> {
			Format->Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description-> "The minimum allowed pH slope, expressed as a percentage of the theoretical value. When the temperature is 25 °C, the theoretical value is 59.16 mV per pH unit, as calculated using the Nernst equation.",
			Category->"General"
		},
		MinpHOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> LessP[0 Milli*Volt],
			Units -> Milli*Volt,
			Description -> "The minimum allowed y-intercept of the fitted slope when using SevenExcellence instrument.",
			Category -> "General"
		},
		MaxpHOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli*Volt],
			Units -> Milli*Volt,
			Description -> "The maximum allowed y-intercept of the fitted slope when using SevenExcellence instrument.",
			Category -> "General"
		},
		LowCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The low pH reference buffer used to calibrate the pH instruments.",
			Category->"General"
		},
		MediumCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The medium pH reference buffer used to calibrate the pH instruments.",
			Category->"General"
		},
		HighCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The high pH reference buffer used to calibrate the pH instruments.",
			Category->"General"
		},
		LowCalibrationBufferpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,14],
			Description -> "The pH of the low calibration buffer that should be used to calibrate the pH probe.",
			Category -> "General"
		},
		MediumCalibrationBufferpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,14],
			Description -> "The pH of the medium calibration buffer that should be used to calibrate the pH probe.",
			Category -> "General"
		},
		HighCalibrationBufferpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,14],
			Description -> "The pH of the high calibration buffer that should be used to calibrate the pH probe.",
			Category -> "General"
		}
	}
}];