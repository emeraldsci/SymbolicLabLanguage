

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, AdjustpH], {
	Description->"A protocol used to modify the pH of the input samples, by making a fixed addition and/or by titrating with acid or base, until the desired nominal pHs or the MaxAdditionVolumes or MaxNumberOfCycles are reached.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		NominalpHs->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the pH values specified as the desired target in the experiment call.",
			Category -> "General"
		},

		pHsAchieved -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the desired pHs were achieved without exceeding the volume or iteration limits.",
			Category -> "Experimental Results"
		},
		(*This may appear unecessary with TemporalLinks, but we need the working sample's volume right after sample preparation, which is a tricky time point to catch. This also reduces the number of downloads one will need running adjustph resolver next time around as we will need to download this time point first.*)
		WorkingSampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of the working sample after sample preparation and before pH adjustment.",
			Category -> "Aliquoting",
			IndexMatching->SamplesIn,
			Developer -> True
		},

		(* --- Pre-Tritrated Additions --- *)
		HistoricalData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,pHAdjustment],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the pH adjustment data used to determine the fixed additions in this protocol. The fixed additions and the titrant reflected in the data are added as fixed additions in this protocol.",
			Category -> "pH Titration",
			Developer -> True
		},
		(* NOTE: Because we don't have multiple multiples we can't have links here *)
		FixedAdditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterP[0 Milliliter] | GreaterP[0 Gram]| GreaterP[0], ObjectP[{Model[Sample], Object[Sample]}]}..},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the corresponding preparatory additions made before titration.",
			Category -> "pH Titration",
			Developer -> True
		},
		FixedAdditionSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Model[Sample],
			Description -> "The set of all samples added directly to any of the input samples during preparatory additions made before titration.",
			Category -> "pH Titration",
			Developer -> True
		},
		FixedAdditionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the transfers of the fixed additions into the input samples.",
			Category -> "pH Titration",
			Developer -> True
		},
		FixedAdditionManipulations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The sample manipulations protocol used to transfer the fixed additions into the input samples.",
			Category -> "pH Titration"
		},

		(* --- pH Measurement --- *)
		(* NOTE: This will just be a flat list so you can't immediately see what measurement protocols go with what sample *)
		pHMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasurepH],
			Description -> "The protocols containing method information for the pH measurements performed on the input samples as their pHs were adjusted.",
			Category -> "Experimental Results"
		},
		pHMeters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, pHMeter],Model[Instrument, pHMeter]],
			Description -> "For each member of SamplesIn, the instrument used to measure the pH of the sample.",
			IndexMatching -> SamplesIn,
			Category -> "pH Measurement"
		},
		ProbeTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> pHProbeTypeP,
			Description -> "For each member of SamplesIn, the type of pH meter (Surface or Immersion) to be used for measurement.",
			IndexMatching->SamplesIn,
			Category -> "pH Measurement"
		},
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, pHProbe],Model[Part, pHProbe]],
			Description -> "For each member of SamplesIn, the probe used to measure the pH of the sample(s).",
			IndexMatching -> SamplesIn,
			Category -> "pH Measurement"
		},
		LowCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The low pH reference buffer (pH 4) used to calibrate the pH instruments.",
			Category->"General"
		},
		MediumCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The medium pH reference buffer (pH 7) used to calibrate the pH instruments.",
			Category->"General"
		},
		HighCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The high pH reference buffer (pH 10) used to calibrate the pH instruments.",
			Category->"General"
		},
		AcquisitionTimes -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0Second],
			Description->"For each member of SamplesIn, the amount of time that data from the pH sensor should be acquired. 0 Second indicates that the pH sensor should be pinged instantaneously, collecting only 1 data point.",
			IndexMatching->SamplesIn,
			Units->Second,
			Category->"pH Measurement"
		},
		TemperatureCorrections-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TemperatureCorrectionP,(*TemperatureCorrectionP=Linear|Non-linear|Off|PureWater*)
			Description -> "For each member of SamplesIn, defines the relationship between temperature and conductivity. Linear: Use for the temperature correction of medium and highly conductive solutions. Non-linear: Use for natural water (only for temperature between 0\[Ellipsis]36 \[Degree]C). Off: The conductivity value at the current temperature is displayed. PureWater: An optimized type of temperature algorithm is used.",
			IndexMatching -> SamplesIn,
			Category -> "pH Measurement"
		},
		pHAliquots->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if an aliquot is taken from the input sample and used to measure the pH.",
			Category -> "pH Measurement"
		},
		pHAliquotVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Liter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the volume to remove from the input sample and measure.",
			Category -> "pH Measurement"
		},
		RecoupSample->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the aliquot used to measure the pH should be returned to source container.",
			Category -> "pH Measurement"
		},
		WashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample that are used to wash the probe(s) by submerging it.",
			Category->"Cleaning"
		},
		WasteBeaker->{ (*NOTE: not in use. We just call the WasteContainer of the pHMeter*)
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Vessel]|Model[Container,Vessel],
			Description->"A vessel that will be used to catch any residual water that comes off the pH instrument as it is washed between measurements.",
			Developer->True,
			Category->"Cleaning"
		},

		(* --- pH Titration --- *)
		Titrates->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if titrating acid and/or base should be added until the pH is within the bounds specified by MinpH and MaxpH or until MaxNumberOfCycles or MaxAdditionVolume is reached.",
			Category -> "pH Titration"
		},
		CurrentTitrationVolume -> { (*TODO: to be replaced by CurrentTitrationAmount *)
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Liter],
			Units -> Microliter,
			Description -> "The most recently updated titration volume.",
			Category -> "pH Titration",
			Developer ->True
		},
		CurrentTitrationAmount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 * Liter],GreaterEqualP[0 * MilliGram]],
			Description -> "The most recently updated titration amount.",
			Category -> "pH Titration",
			Developer ->True
		},
		CurrentTransferTips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item,Tips], Object[Item,Tips]],
			Description -> "The most recently updated tip object or model for the next tranfer.",
			Category -> "pH Titration",
			Developer ->True
		},
		CurrentTransferInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument],Model[Item], Object[Item]], (*May be spatula..*)
			Description -> "The most recently updated pipette object for the next tranfer.",
			Category -> "pH Titration",
			Developer ->True
		},
		KeepCurrentInstruments -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description ->  "Indicates if transfer instruments should be kept till the end of AjustpH, as opposed to being released after the transfer is performed.",
			Category ->  "pH Titration",
			Developer -> True
		},
		TitrationPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "All of the pipettes that have been selected by this protocol and should be returned to its original location once the protocol completes if KeepCurrentInstruments->False.",
			Category -> "pH Titration",
			Developer ->True
		},
		TitratingAcids -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the acid used to adjust the pH of the sample downwards.",
			Category -> "pH Titration"
		},
		TitratingBases -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the base used to adjust the pH of the sample upwards.",
			Category -> "pH Titration"
		},
		CurrentTransferEnvironment -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ObjectP[{Object[Container], Object[Instrument]}],
			Description -> "The location where titrants are transferred to the sample at the current iteration.",
			Category -> "pH Titration",
			Developer ->True
		},
		TransferDestinationRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "For each member of SamplesIn, the rack which is used to hold the container upright (if needed) while titrants are transferred into the sample.",
			IndexMatching -> SamplesIn,
			Category -> "pH Titration",
			Developer ->True
		},
		RequiredObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]| Model[Container] | Object[Sample] | Model[Sample] | Model[Item] | Object[Item] | Model[Part] | Object[Part],
			Description -> "Objects required for the protocol.",
			Category -> "pH Titration",
			Developer -> True
		},
		TitrationPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the series of transfers which add the titrating acid and bases into the input samples as needed. This excludes fixed addition transfers.",
			Category -> "pH Titration",
			Developer -> True
		},
		TitrationManipulations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol,SampleManipulation],
				Object[Protocol,Transfer],
				Object[Protocol, ManualSamplePreparation],
				Object[Protocol, RoboticSamplePreparation]
			],
			Description -> "The protocol used to transfer titrating acid and bases into the input samples as needed. This excludes fixed addition transfers.",
			Category -> "pH Titration"
		},

		(* --- Mixing --- *)
		MixWhileTitrating->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the input sample should be mixed as titrating acid/base additions are made.",
			Category -> "Mixing"
		},
		pHMixTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MixTypeP,
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, indicates the style of motion used to mix the sample.",
			Category -> "Mixing"
		},
		pHMixUntilDissolved -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the mix should be continued until the sample has dissolved or up to the MaxTime or MaxNumberOfMixes (chosen according to the mix type).",
			Category -> "Mixing"
		},
		pHMixInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument]|Model[Instrument],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the instrument used to perform the action specified by the mix type.",
			Category -> "Mixing"
		},
		pHMixImpellers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part,StirrerShaft],Object[Part,StirrerShaft]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the impeller used in the mixer responsible for stirring the solution in between acid/base additions.",
			Category -> "Mixing",
			Developer -> True
		},
		pHMixTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the duration of time for which the samples will be mixed.",
			Category -> "Mixing"
		},
		MaxpHMixTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen.",
			Category -> "Mixing"
		},
		pHMixDutyCycles -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed. This option can only be set when mixing via homogenization.",
			Category -> "Mixing"
		},
		pHMixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the frequency of rotation the mixing instrument should use to mix the samples.",
			Category -> "Mixing"
		},
		NumbersOfpHMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of times the samples should be pipetted up and down (MixType->Pipette) or inverted.",
			Category -> "Mixing"
		},
		MaxNumbersOfpHMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the maximum number of times the samples should be pipetted up and down (MixType->Pipette) or inverted in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen.",
			Category -> "Mixing"
		},
		pHMixVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the volume of the sample that should be pipetted up and down in order to mix the sample.",
			Category -> "Mixing"
		},
		pHMixTemperatures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient,GreaterP[0*Celsius]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the temperature of the device that should be used to mix the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
			Category -> "Mixing"
		},
		MaxpHMixTemperatures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient,GreaterP[0*Celsius]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the temperature of the device that should be used to mix the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
			Category -> "Mixing"
		},
		pHHomogenizingAmplitudes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			IndexMatching -> SamplesIn,

			Description -> "For each member of SamplesIn, the amplitude of the sonication horn used when mixing via homogenization.",
			Category -> "Mixing"
		},

		(* --- pHing Limits --- *)
		MinpHs->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the values used to set the lower end of the nominal pH range. If the measured pH is between this minimum and the MaxpH titrations will stop. If the MaxNumberOfCycles or the MaxAdditionVolume is reached first, than the final pH may not be above this minimum.",
			Category -> "pHing Limits"
		},
		MaxpHs->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the values used to set the upper end of the nominal pH range. If the measured pH is above the MinpH and below this maximum pH titrations will stop. If the MaxNumberOfCycles or the MaxAdditionVolume is reached first, than the final pH may not be below this maximum.",
			Category -> "pHing Limits"
		},
		MaxAdditionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates the maximum volume to add before stopping titrations.",
			Category -> "pHing Limits"
		},
		NonBuffered->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates whether its HistoricalData suggests this sample is not well pH-buffered and therefore should be titrated with less aggressiveness.",
			Category -> "pH Measurement",
			Developer -> True
		},
		MaxNumbersOfCycles -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates the maximum number of additions to make before stopping titrations.",
			Category -> "pHing Limits"
		},
		MaxAcidAmountsPerCycle -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 * Liter],GreaterEqualP[0 * MilliGram]],
			Description -> "The largest amount of TitrationAcid that can be added to in each titration cycle.",
			Category -> "pHing Limits"
		},
		MaxBaseAmountsPerCycle -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 * Liter],GreaterEqualP[0 * MilliGram]],
			Description -> "The largest amount of TitrationBase that can be added to in each titration cycle.",
			Category -> "pHing Limits"
		},

		(* --- Sample Storage --- *)
		StoragePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "For each member of SamplesIn, the set of instructions specifying the transfers used to transfer the pH adjusted sample into its final container.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Storage",
			Developer -> True
		},
		StorageManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The sample manipulation protocol used to transfer the pH adjusted sample into its final container.",
			Category -> "pH Titration"
		},

		ModelsOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the desired model of SamplesOut if pH adjustment is successful.",
			Category -> "General",
			Developer -> True
		},
		pHingDateStarted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which FixedAdditions and Titrations Subprotocols started. This differs from DateStarted in that if aliquot is performed for sample preparation this value is later than the aliquot protocols.",
			Developer -> True,
			Category -> "General"
		},
		KeepInstruments ->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description ->  "Indicates if instruments are released and moved back to the previous location after ExperimentAdjustpH.",
			Category -> "General",
			Developer -> True
		}
	}
}];
