(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MeasureConductivity], {
	Description->"A protocol for measuring the conductivity of a liquid sample using an electrical conductivity meter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- General --- *)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,ConductivityMeter],
				Object[Instrument,ConductivityMeter]
			],
			Description -> "The  instrument used in this protocol to measure the conductivity of the sample.",
			Category -> "General",
			Abstract -> True
		},
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, ConductivityProbe],Model[Part, ConductivityProbe]],
			Description -> "The probe(s) used in this protocol to measure the conductivity of the sample(s).",
			Category -> "General",
			Abstract -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the data file generated at the conclusion of the experiment.",
			Category -> "General",
			Developer -> True
		},
		CalibrationFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of Probes, the file path of the calibration file generated at the conclusion of the experiment.",
			Category -> "General",
			Developer -> True
		},
		InitialDataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the data file exported prior to the experiment. This file includes any existing data from the instrument and will be used to verify data export after measurements are taken in this protocol.",
			Category -> "General",
			Developer -> True
		},
		InitialCalibrationFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the calibration file exported prior to the experiment. This file includes any existing calibration data from the instrument and will be used to verify calibration data export after calibration steps are performed in this protocol.",
			Category -> "General",
			Developer -> True
		},
		ProbeStorageContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Part, ConductivityProbe], Null},
			Description -> "List of ProbeStorage container placements for placing the conductivity probe(s) into their permanent storage positions on the instrument bench.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		ProbeInUseContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Part, ConductivityProbe], Null},
			Description -> "List of ProbeInUse container placements for placing the conductivity probe to the instrument Probe InUse Slot for use in the current experiment.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		(* --- TemperatureCompensation --- *)
		TemperatureCorrection-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TemperatureCorrectionP,(*TemperatureCorrectionP=Linear|Non-linear|Off|PureWater*)
			Description -> "For each member of SamplesIn, defines the relationship between temperature and conductivity.  Linear: Use for the temperature correction of medium and highly conductive solutions. Non-linear: Use for natural water (only for temperature between 0…36 ºC). Off: The conductivity value at the current temperature is displayed. PureWater: An optimized type of temperature algorithm is used.",
			Category -> "Temperature Compensation",(*TODO:change description *)
			IndexMatching -> SamplesIn,
			Abstract -> True
		},
		AlphaCoefficient-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,10],
			Description -> "For each member of SamplesIn, defines the factor for the linear dependency if TemperatureCorrection is Linear.", (*TODO:change description *)
			Category -> "Temperature Compensation",
			IndexMatching -> SamplesIn,
			Abstract -> True
		},
		ReferenceTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature to which conductivity reading directly corrected to.", (*change description *)
			Category -> "Temperature Compensation",
			IndexMatching -> SamplesIn,
			Abstract -> True
		},
		(* --- Batching --- *)
		BatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"Parameters describing the length of each batch.",
			Category->"Batching",
			Developer->True
		},
		BatchingParameters->{
			Format->Multiple,
			Class->{
				Container->Link,
				TemperatureCorrection->Expression,
				AlphaCoefficient->Integer,
				RinseContainer->Link,
				SampleRinse->Boolean,
				BatchedIndex-> Integer,
				DataFilePath->String,
				ContainerModel->Link,
				Well->String
			},
			Pattern:>{
				Container->_Link,
				TemperatureCorrection->TemperatureCorrectionP,
				AlphaCoefficient->RangeP[0,10],
				RinseContainer->_Link,
				SampleRinse->BooleanP,
				BatchedIndex-> GreaterP[0,1],
				DataFilePath -> FilePathP,
				ContainerModel->_Link,
				Well->_String
			},
			Relation->{
				Container->Object[Container,Vessel]|Model[Container,Vessel]|Object[Container,Plate]|Model[Container,Plate],
				TemperatureCorrection->Null,
				AlphaCoefficient->Null,
				RinseContainer->Object[Container,Vessel]|Model[Container,Vessel]|Object[Container,Plate]|Model[Container,Plate],
				SampleRinse->Null,
				BatchedIndex-> Null,
				DataFilePath->Null,
				ContainerModel->Model[Container,Vessel]|Model[Container,Plate],
				Well->Null
			},
			Developer->True,
			Description->"The named multiple version of the existing fields, in order to batch over in engine.",
			Category->"Batching"
		},
		SmallVolumeProbeIndices->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample which uses SmallVolumeProbe, as they relate to SamplesIn.",
			Category->"Batching",
			Developer->True
		},
		RegularProbeIndices->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample which uses RegularProbe, as they relate to SamplesIn.",
			Category->"Batching",
			Developer->True
		},
		BatchRinseLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"The indices of each sample which uses SmallVolumeProbe, as they relate to SamplesIn.",
			Category->"Batching",
			Developer->True
		},
		BatchedNumberOfReadings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1,10],
			Description -> "The number of times the conductivity of each aliquot or sample will be read by taking another recording including verification standard.",
			Category -> "Batching",
			Developer->True
		},
		(* --- Calibration --- *)
		CalibrationStandard->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"For each member of Probes, the calibration standard used to adjust the cell constant to mach the standards expected conductivity.",
			IndexMatching -> Probes,
			Category->"Calibration"
		},
		CalibrationConductivity->{
			Format->Multiple,
			Class->Real,
			Pattern:> GreaterEqualP[0*Micro Siemens/Centimeter],
			Units -> Micro Siemens/Centimeter,
			Description->"For each member of Probes, the conductivity of the calibration standard used to adjust the cell constant to mach the standards expected conductivity.",
			IndexMatching -> Probes,
			Category->"Calibration"
		},
		SecondaryCalibrationStandard -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[Sample]|Model[Sample],
			Description -> "For each member of Probes, a secondary calibration standard used to calibrate probes of the conductivity meter that require two-point calibration before we perform the measurements of ConductivityStandards.",
			IndexMatching -> Probes,
			Category -> "Calibration"
		},
		SecondaryCalibrationStandardConductivity->{
			Format->Multiple,
			Class->Real,
			Pattern:> GreaterEqualP[0*Micro Siemens/Centimeter],
			Units -> Micro Siemens/Centimeter,
			Description->"For each member of Probes, the conductivity of the secondary calibration standard used to adjust the cell constant to match the standards expected conductivity.",
			IndexMatching -> Probes,
			Category->"Calibration"
		},
		VerificationStandard->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"For each member of Probes, the verification standard used to make sure that measured conductivity of the standard matches the verification standard models known Conductivity.",
			IndexMatching -> Probes,
			Category->"Calibration"
		},
		VerificationConductivity->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,Conductivity],
			Description->"For each member of Probes, the measured verification standard conductivity data object(s), as read from the sensor of the conductivity standard. If multiple verifications are requered they will be listed in the chronological order.",
			IndexMatching -> Probes,
			Category->"Calibration"
		},
		VerificationResult->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the verification passed. However, procedure will continue in order to record information for the troubleshooting.",
			Category -> "Calibration"
		},
		(* --- Sample Preparation --- *)
		SampleRinse -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the probe should be rinsed with aliquoted input sample (RinseSample) prior the sample measurement.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> True
		},
		SampleRinseVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of rinse sample that should be used to rinse the probe prior to the measurement.",
			Category -> "Sample Preparation",
			IndexMatching->SamplesIn
		},
		RinseContainers -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Vessel]|Model[Container,Vessel],
			Description->"For each member of SamplesIn, the container of the aliquoted input sample that should be used to rinse the probe prior to the measurement.",
			IndexMatching -> SamplesIn,
			Category->"Sample Preparation"
		},
		SampleRinseStorageConditions->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(SampleStorageTypeP|Disposal)..},
			Description -> "For each member of SamplesIn, the storage conditions under which the rinse samples should be stored after the protocol is completed.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		RinsePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SamplePreparationP|SamplePreparationP,
			Relation->None,
			Description->"For each member of RinseSamples, the instructions used to aliquot the requested amount of measured sample into the new container to rinse the probe before the measurement.",
			Developer->True,
			Category->"Sample Preparation"
		},
		RinseManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "The subprotocol used to aliquot the requested amount of measured sample into the new container to rinse the probe before the measurement.",
			Category -> "Sample Preparation"
		},
		(* --- Experimental Results --- *)	
		Conductivity -> {
			Format->Multiple,
			Class->Expression,
			Pattern :> DistributionP[Micro Siemens/Centimeter],
			Description->"For each member of SamplesIn, the measured conductivity of the sample.",
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
		(* --- Cleaning --- *)
		WashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample that are used to wash the probe(s) by submerging it.",
			Category->"Cleaning"
		},
		WasteBeaker->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Vessel]|Model[Container,Vessel],
			Description->"A vessel that will be used to catch any residual water that comes off the probe as it is washed between measurements.",
			Developer->True,
			Category->"Cleaning"
		},
		RecoupSample->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"For each member of SamplesIn, indicates if the sample is transferred back into the sample's original container after the measurement.",
			IndexMatching->SamplesIn,
			Category->"Cleaning"
		},
		RecoupPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SamplePreparationP|SamplePreparationP,
			Relation->None,
			Description->"The instructions used to put the aliquoted sample back into the original container.",
			Developer->True,
			Category->"Cleaning"
		},
		RecoupManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "The subprotocol used to put the aliquoted sample back into the original container.",
			Category -> "Cleaning"
		}
	}
}];
