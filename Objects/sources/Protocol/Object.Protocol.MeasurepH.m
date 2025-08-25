(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MeasurepH], {
	Description->"A protocol for measuring the pH of a sample by means of a probe based meter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ProbeSamples -> {
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The samples that should have their pH measured using an probe instrument.",
			Category -> "General"
		},
		ProbeIndices->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample in ProbeSamples, as they relate to SamplesIn.",
			Category -> "General",
			Developer->True
		},
		ProbeBatchLength->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The batch lengths that correspond to the sample groupings of ProbeSamples.",
			Category -> "General",
			Developer->True
		},
		ProbeInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,pHMeter],
				Object[Instrument,pHMeter]
			],
			Description -> "The probe instruments that should be used to measure the pH of the ProbeSamples.",
			Category -> "General"
		},
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, pHProbe],Model[Part, pHProbe]],
			Description -> "For each member of ProbeInstruments, the probe(s) used in this protocol to measure the conductivity of the sample(s).",
			IndexMatching -> ProbeInstruments,
			Category -> "General",
			Abstract -> True
		},
		TemperatureCorrection-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TemperatureCorrectionP,(*TemperatureCorrectionP=Linear|Non-linear|Off|PureWater*)
			Description -> "For each member of ProbeSamples, defines the relationship between temperature and conductivity. Linear: Use for the temperature correction of medium and highly conductive solutions. Non-linear: Use for natural water (only for temperature between 0 - 36 \[Degree]C). Off: The conductivity value at the current temperature is displayed. PureWater: An optimized type of temperature algorithm is used.",
			IndexMatching -> ProbeSamples,
			Category -> "General",
			Abstract -> True
		},
		AlphaCoefficient-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,10],
			Description -> "For each member of ProbeSamples, defines the factor for the linear dependency.",
			IndexMatching -> ProbeSamples,
			Category -> "General",
			Abstract -> True
		},
		ReferenceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The conductivity reading directly corrected to the ReferenceTemperature.",
			Category -> "General",
			Abstract -> True
		},
		ProbeInstrumentsSelect -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of ProbeInstruments, indicates if this is the first instance of us using the instrument in our procedure.",
			Developer->True,
			Category -> "General"
		},
		ProbePorts -> {
			Format -> Multiple,
			Class->Integer,
			Pattern:>RangeP[1,3,1],
			Description -> "For each member of ProbeInstruments, indicates the position of the probe being used.",
			Developer->True,
			Category -> "General"
		},
		ProbeBatchName -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String?(StringMatchQ[#1, ("S" ~~ ___) ] &),
			Description -> "For each member of ProbeInstruments, indicates the input value for the Series.",
			Developer->True,
			Category -> "General"
		},
		ProbeInstrumentsRelease -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of ProbeInstruments, indicates if this is the last instance of us using the instrument in our procedure.",
			Developer->True,
			Category -> "General"
		},
		ProbeLowCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The low pH reference buffer used to calibrate the pH probe instruments used.",
			Category -> "General"
		},
		ProbeMediumCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The medium pH reference buffer used to calibrate the pH probe instruments used.",
			Category -> "General"
		},
		ProbeHighCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The high pH reference buffer used to calibrate the pH probe instruments used.",
			Category -> "General"
		},
		ProbeLowCalibrationWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The low pH reference buffer used to wash the probe before calibrating the pH probe instruments used.",
			Developer->True,
			Category -> "Cleaning"
		},
		ProbeMediumCalibrationWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The medium pH reference buffer used to wash the probe before calibrating the pH probe instruments used.",
			Developer->True,
			Category -> "Cleaning"
		},
		ProbeHighCalibrationWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The high pH reference buffer used to wash the probe before calibrating the pH probe instruments used.",
			Developer->True,
			Category -> "Cleaning"
		},
		ProbeLowCalibrationBufferpH->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,pH],
			Description->"The calibration pH data object, as read using the last calibration object from the sensor of the acidic reference buffer.",
			Developer->True,
			Category -> "General"
		},
		ProbeMediumCalibrationBufferpH->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,pH],
			Description->"The calibration pH data object, as read using the last calibration object from the sensor of the neutral reference buffer.",
			Developer->True,
			Category -> "General"
		},
		ProbeHighCalibrationBufferpH->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,pH],
			Description->"The calibration pH data object, as read using the last calibration object from the sensor of the basic reference buffer.",
			Developer->True,
			Category -> "General"
		},
		ProbeRecoupSample->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"Indicates if we should recoup the sample after measuring it with the probe instrument (into the sample's original container, if the Aliquot->True option was specified).",
			Category -> "General"
		},
		ProbeSampleRawpH->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,pH],
			Description->"For each member of ProbeSamples, the pH data object that was measured from the droplet instrument.",
			Developer->True,
			Category -> "General"
		},
		ProbeRecoupManipulations->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description->"For each member of ProbeSamples, the subprotocols used to put the loaded amount of ProbeSample back into the original container.",
			Category -> "General"
		},
		SurfaceDropletSampleManipulations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "The subprotocols used to make droplets which can then be read by the surface probe.",
			Category -> "General"
		},
		ProbeAcquisitionTimes -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0Second],
			Description->"For each member of ProbeSamples, the amount of time that data from the pH sensor should be acquired. 0 Second indicates that the pH sensor should be pinged instantaneously, collecting only 1 data point.",
			IndexMatching->ProbeSamples,
			Units->Second,
			Category -> "General"
		},
		ProbeNumberOfAcquisitions -> {
			Format->Multiple,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"For each member of ProbeSamples, the number of readings that should be taken (at 1 second intervals) to fullfill ProbeAcquisitionTimes.",
			IndexMatching->ProbeSamples,
			Developer->True,
			Category -> "General"
		},
		SecondaryWashSolutions->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample that are used to perform the second washing of the probe.",
			Category->"Cleaning"
		},
		WashSolutions->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample that are used to perform the first washing of the probe.",
			Category->"Cleaning"
		},
		PostStorageWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Developer->True,
			Description->"The sample used to wash the probe after the probe is taken out of the storage cap.",
			Category->"General"
		},
		PreStorageWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Developer->True,
			Description->"The sample used to wash the probe before the probe is stored in the storage cap.",
			Category->"General"
		},
		ProbeParameters->{
			Format->Multiple,
			Class->{
				Sample->Link,
				NumberOfAcquisitions->Integer,
				RecoupPrimitive->Expression,
				RecoupSample->Boolean,
				SampleName -> String,
				DropletContainer->Link,
				DropletPrimitive->Expression,
				WashSolution -> Link,
				SecondaryWashSolution -> Link
			},
			Pattern:>{
				Sample->_Link,
				NumberOfAcquisitions->_?NumericQ,
				RecoupPrimitive->SampleManipulationP|SamplePreparationP,
				RecoupSample->BooleanP,
				SampleName -> _String,
				DropletContainer->ObjectP[{Model[Container],Object[Container]}],
				DropletPrimitive->SampleManipulationP|SamplePreparationP,
				WashSolution -> _Link,
				SecondaryWashSolution -> _Link
			},
			Relation->{
				Sample->Object[Sample]|Model[Sample],
				NumberOfAcquisitions->Null,
				RecoupPrimitive->Null,
				RecoupSample->Null,
				SampleName -> Null,
				DropletContainer->Model[Container]|Object[Container],
				DropletPrimitive->Null,
				WashSolution -> Object[Sample]|Model[Sample],
				SecondaryWashSolution -> Object[Sample]|Model[Sample]
			},
			Developer->True,
			Description->"The named multiple version of the existing fields, in order to batch over in engine.",
			Category -> "General"
		},
		ProbeStorageContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Part, pHProbe], Null},
			Description -> "List of ProbeStorage container placements for placing the pH probe(s) into their permanent storage positions on the instrument bench.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		ProbeInUseContainerPlacements ->{
			Format -> Single,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Part, pHProbe], Null},
			Description -> "List of ProbeInUse container placements for placing the pH probe to the instrument Probe InUse Slot for use in the current experiment.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		DataFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the data file generated at the conclusion of the experiment for each batch of Probe samples.",
			Category -> "General",
			Developer -> True
		},
		CalibrationFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the calibration file generated at the conclusion of the experiment for each batch of Probe samples.",
			Category -> "General",
			Developer -> True
		},
		InitialDataFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each probe instrument, the file path of the data file exported prior to the experiment. This file includes any existing data from the instrument and will be used to verify data export after measurements are taken in this protocol.",
			Category -> "General",
			Developer -> True
		},
		InitialCalibrationFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each probe instrument, the file path of the calibration file exported prior to the experiment. This file includes any existing calibration data from the instrument and will be used to verify calibration data export after calibration steps are performed in this protocol.",
			Category -> "General",
			Developer -> True
		},
		WasteBeaker->{ (*NOTE: not in use. We just call the WasteContainer of the pHMeter*)
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"A vessel that contains water to dilute base and acid and will be used to catch any residual water that comes off the pH instrument as it is washed between measurements.",
			Developer->True,
			Category->"Cleaning"
		},
		CalibrationData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration,pH][Protocol],
			Description -> "Any primary data generated by this protocol.",
			Category -> "Experimental Results"
		},
		pH -> {
			Format->Multiple,
			Class->Real,
			Pattern:>pHP,
			Description->"For each member of SamplesIn, the measured pH of the sample.",
			IndexMatching->SamplesIn,
			Category->"Experimental Results"
		},
		Temperature -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DistributionP[Celsius],
			Description -> "For each member of SamplesIn, the measured temperature of the sample.",
			IndexMatching->SamplesIn,
			Category -> "Experimental Results"
		},
		pHStandardDeviation -> {
			Format->Multiple,
			Class->Real,
			Pattern:>pHP,
			Description->"For each member of SamplesIn, the spread of the different pH measurements of the sample.",
			IndexMatching->SamplesIn,
			Category->"Experimental Results"
		},
		TemporarypH->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,pH],
			Description->"A temporary junk field to store the result of monitor sensor using a 1 second heartbeat. This is to prevent engine sluggishness when multiple readings are requested by the user.",
			Category->"Experimental Results",
			Developer->True
		},
		MaxpHSlope -> {
			Format->Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description-> "The maximum allowed pH slope, expressed as a percentage of the theoretical value. When the temperature is 25 \[Degree]C, the theoretical value is 59.16 mV per pH unit, as calculated using the Nernst equation.",
			Category->"General"
		},
		MinpHSlope -> {
			Format->Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description-> "The minimum allowed pH slope, expressed as a percentage of the theoretical value. When the temperature is 25 \[Degree]C, the theoretical value is 59.16 mV per pH unit, as calculated using the Nernst equation.",
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
		InitialProbeStorageAppearance -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Photographs of the pH meter probes in their storage location at the beginning of MeasurepH Immersion Loop subprocedure.",
			Category -> "General",
			Developer -> True
		},
		FinalProbeStorageAppearance -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Photographs of the pH meter probes in their storage location at the end of the MeasurepH Immersion Loop subprocedure.",
			Category -> "General",
			Developer -> True
		},
		WashProbe -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the probe will be washed before pH measurement. This field is set to False during pH Adjustment if the probe has been stored in SecondaryWashSolutions, as washing is not necessary in that case.",
			Category -> "General",
			Developer -> True
		},
		VerificationStandardWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "A sample used to clean and acclimate the probe prior to measuring the pH of the VerificationStandard.",
			Category -> "General"
		},
		VerificationStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "A sample of known pH used to confirm that calibration is suitable prior to measurement of samples.",
			Category -> "General"
		},
		MinVerificationStandardpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[-0.1, 14.1],
			Description -> "The lower bound for the measured VerificationStandardpH of the VerificationStandard. If the measured pH of the verification sample is below this value then the calibration should be repeated.",
			Category -> "General"
		},
		MaxVerificationStandardpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[-0.1, 14.1],
			Description -> "The upper bound for the measured VerificationStandardpH of the VerificationStandard. If the measured pH of the verification sample is above this value then the calibration should be repeated.",
			Category -> "General"
		},
		VerificationStandardpH -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> pHP,
			Description -> "For each member of Probes, the measured pH of the VerificationStandard following calibration.",
			Category -> "General"
		},
		VerificationStandardFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The path to the verification standard data file.",
			Category -> "General",
			Developer -> True
		},
		VerificationStandardData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Data, pH]],
			Description -> "For each member of Probes, data from pH measurements on the VerificationStandard confirming the validity of a probe's calibration.",
			Category -> "General"
		}
	}
}];
