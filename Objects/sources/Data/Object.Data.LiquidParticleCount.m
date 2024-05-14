(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, LiquidParticleCount], {
	Description->"Liquid particle count measured by a high accuracy liquid particle counter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(*---Method Information---*)
		DilutionSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][Data],
			Description -> "Diluted samples that were directly assayed to generate this data.",
			Category -> "General"
		},
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LiquidParticleCountDataTypeP,(*Alternatives[Sample,DilutedSample]*)
			Description -> "Whether this mass spectrometry data was performed on a matrix, calibrant or analyte sample.",
			Category -> "Data Processing",
			Abstract -> True
		},
		Syringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Syringe], Model[Part,Syringe]],
			Description -> "The syringe which was used to count liquid particle.",
			Category -> "General",
			Abstract -> True
		},
		ReadingVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "The amount of the sample used to count liquid particle.",
			Category -> "General"
		},
		ParticleSizes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micrometer],
			Units -> Micrometer,
			Description ->"The collection of ranges the different particle sizes that monitored.",
			Category -> "General",
			Abstract -> True
		},
		PreRinseVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "The volume of the sample used to flow into the syringe tubing to rinse out the lines with the sample before beginning the reading.",
			Category -> "General"
		},
		NumberOfReading -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the liquid particle count of the sample ReadingVolume was read by taking another recording.",
			Category -> "General"
		},
		DiscardFirstRun -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the first run will be ignored during data collection.",
			Category -> "Particle Size Measurements"
		},
		SamplingHeight  -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Indicates if the height of the sensor probe when reading the number of particles during data collection.",
			Category -> "Particle Size Measurements"
		},
		FlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "The rate of sample pumped through the instrument by the syringe.",
			Category -> "General"
		},
		(* Dilutions *)
		DilutionFactor -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description -> "The ratios of the volume of input sample to the sum of the input sample volume and diluent volume for each dilution.",
			Category -> "Sample Dilution"
		},
		Diluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"For each member of SamplesIn, the sample that is used to dilute the sample to a concentration series.",
			Category->"Sample Dilution"
		},
		DilutionMixVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description -> "The volume that is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Dilution"
		},
		DilutionNumberOfMix->{
			Format->Single,
			Class->Integer,
			Pattern:>RangeP[0,20,1],
			Description -> "The number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Dilution"
		},
		DilutionMixRate->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0.4 Microliter/Second,500 Microliter/Second],
			Units->Microliter/Second,
			Description -> "The speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Dilution"
		},
		
		(*---Experimental Results---*)
		NormalizedAverageCumulativeCounts -> {
			Format -> Multiple,
			Class -> {Real, Expression},
			Pattern :> {GreaterEqualP[0*Micrometer], QuantityDistributionP[Particle/Milliliter]},
			Units -> {Micrometer, None},
			Headers -> {"Particle Size", "Particle Count"},
			Description -> "The liquid particle count for every unit volume of the solution based on NumberOfReadings and ReadingVolume.",
			Category -> "Experimental Results"
		},
		(*---Experimental Results---*)
		NormalizedAverageDifferentialCounts -> {
			Format -> Multiple,
			Class -> {Real, Expression},
			Pattern :> {GreaterEqualP[0*Micrometer], QuantityDistributionP[Particle/Milliliter]},
			Units -> {Micrometer, None},
			Headers -> {"Particle Size", "Particle Count"},
			Description -> "The liquid particle count for every unit volume of the solution based on NumberOfReadings and ReadingVolume.",
			Category -> "Experimental Results"
		},
		(*
		AverageSummationCounts -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Micrometer], GreaterEqualP[0*Particle]},
			Units -> {Micrometer, Particle},
			Headers -> {"Particle Size", "Average Summation Count"},
			Description -> "The average summation of the liquid particle count for each ParticleSize.",
			Category -> "Experimental Results"
		},
	
		AverageCumulativeCounts -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Micrometer], GreaterEqualP[0*Particle]},
			Units -> {Micrometer, Particle},
			Headers -> {"Particle Size", "Average Cummulative Count Distribution"},
			Description -> "The average cumulative summation of the liquid particle count for each ParticleSize.",
			Category -> "Experimental Results"
		},*)
		AverageCumulativeCounts -> {
			Format -> Multiple,
			Class -> {Real, Expression},
			Pattern :> {GreaterEqualP[0*Micrometer], QuantityDistributionP[Particle]},
			Units -> {Micrometer, None},
			Headers -> {"Particle Size", "Average Cummulative Count Distribution"},
			Description -> "The average cumulative summation of the liquid particle count for each ParticleSize.",
			Category -> "Experimental Results"
		},
		AverageDifferentialCounts -> {
			Format -> Multiple,
			Class -> {Real, Expression},
			Pattern :> {GreaterEqualP[0*Micrometer], QuantityDistributionP[Particle]},
			Units -> {Micrometer, None},
			Headers -> {"Particle Size", "Average Cummulative Summation Count"},
			Description -> "The average cumulative summation of the liquid particle count for each ParticleSize.",
			Category -> "Experimental Results"
		},
		SummationCounts -> {
			Format -> Multiple,
			Class -> {Real, Expression},
			Pattern :> {GreaterEqualP[0*Micrometer], {GreaterEqualP[0*Particle]...}|QuantityDistributionP[Particle]},
			Units -> {Micrometer, None},
			Description -> "The summation of the liquid particle count of every single run for each ParticleSize.",
			Headers -> {"Particle Size", "Summation Count"},
			Category -> "Experimental Results"
		},
		CumulativeCounts -> {
			Format -> Multiple,
			Class -> {Real, Expression},
			Pattern :> {GreaterEqualP[0*Micrometer], {GreaterEqualP[0*Particle]...}|QuantityDistributionP[Particle]},
			Units -> {Micrometer, None},
			Description -> "The cumulative summation of the liquid particle count of every single run for each ParticleSize. The first run will be ignored when DiscardFirstRun is True.",
			Headers -> {"Particle Size", "Cummulative Summation Count"},
			Category -> "Experimental Results"
		},
		DifferentialCounts -> {
			Format -> Multiple,
			Class -> {Real, Expression},
			Pattern :> {GreaterEqualP[0*Micrometer], {GreaterEqualP[0*Particle]...}},
			Units -> {Micrometer, None},
			Description -> "The summation of the liquid particle count of every single run for each ParticleSize.",
			Headers -> {"Particle Size", "Summation Count"},
			Category -> "Experimental Results"
		},
		(*--- Data Errors ---*)
		StirringError -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if uniform stirring was not achieved within the cuvette after MaxStirAttempts during the setup of the assay.",
			Category -> "Absorbance Measurement"
		},
		SampleConcentrationRangeFailure -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the data collection failed due to the concentration of the sample is out of the detection limit of the Instrument.",
			Category -> "Data Processing"
		},
		VideoFolderName->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description -> "For each member of SamplesIn, the folder and the final file name that will be generated for the videos to be saved in.",
			Category -> "Data Processing"
		},
		VideoFilePaths->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file paths of the video files generated from experiment run.",
			Category -> "Data Processing"
		},
		ProcessRecording -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The video recording for each liquid particle reading process.",
			Category -> "Data Processing"
		}
		(*---Data Processing---*)
		(*	Calibration -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration,LightObscurationSensor],
			Description -> "The cell constant calibration fit into calibrations standard conductivity used to calculate the samples conductivity.",
			Category -> "Data Processing"
		}*)

	}
}];
