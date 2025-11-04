

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, LiquidParticleCounting], {
	Description->"A method containing parameters specifying a solvent gradient utilized by an count liquid particle experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SyringeSize -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> HIACSyringeSizeP, (*HIACSyringeSizeP=Alternatives[1 Milliliter, 10 Milliliter]*)
			Description ->"The size of the syringe installed on the instrument sampler used to draw the liquid through the light obscuration sensor and flush it back out.",
			Category -> "General",
			Abstract -> True
		},
		Sensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part,LightObscurationSensor],Object[Part,LightObscurationSensor]],
			Description -> "The light obscuration sensor that measures the reduction in light intensity and processes the signal to determine particle size and count. The sensor sets the range of the particle sizes that can be detected.",
			Category -> "General"
		},
		Syringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part,Syringe],Object[Part,Syringe]],
			Description -> "The syringe installed on the instrument sampler used to draw the liquid through the light obscuration sensor and out of the system.",
			Category -> "General"
		},
		ParticleSizes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micrometer],
			Units -> Micrometer,
			Description ->"The collection of ranges the different particle sizes that monitored.",(*TODO explain ranges and Max number*)
			Category -> "General",
			Abstract -> True
		},
		ReadingVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The volume of sample that is loaded into the instrument and used to determine particle size and count.",
			Category -> "Particle Size Measurements"
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,10,1],
			Units -> None,
			Description -> "The number of times the liquid particle count is read by passing ReadingVolume through the light obscuration sensor.",
			Category -> "Particle Size Measurements"
		},
		PreRinseVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The volume of the sample flown into the syringe tubing to rinse out the lines with each new sample before beginning the reading.",
			Category -> "Particle Size Measurements"
		},
		SampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature of the instrument's sampler tray where samples are equilibrated just prior to the injection.",
			Category -> "Particle Size Measurements"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time for which each sample is incubated at the requested SampleTemperature just prior to being read.",
			Category -> "Particle Size Measurements"
		},
		DiscardFirstRun -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the first run will be ignored during data collection.",
			Category -> "Particle Size Measurements"
		},
		SamplingHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Indicates if the height of the sensor probe when reading the number of particles during data collection.",
			Category -> "Particle Size Measurements"
		},
		(*--- Dilutions ---*)
		DilutionCurve -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0Microliter],GreaterEqualP[0Microliter]} | {GreaterEqualP[0Microliter],GreaterEqualP[0,1]},
			Description -> "The collection of dilutions that performed on the samples before light obscuration measurements are taken.",
			Category -> "Sample Preparation"
		},
		SerialDilutionCurve -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0Microliter],GreaterEqualP[0Microliter],GreaterEqualP[1,1]} | {GreaterEqualP[0Microliter], {GreaterEqualP[0],GreaterEqualP[1, 1]}} | {GreaterEqualP[0Microliter], {GreaterEqualP[0]...}},
			Description -> "The collection of dilutions that will be performed on the samples before light obscuration measurements are taken.",
			Category -> "Sample Preparation"
		},
		Diluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of SamplesIn, the sample that is used to dilute the sample.",
			Category->"Sample Preparation"
		},
		DilutionContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The container or containers in which each sample is diluted with the Diluent to make the concentration series.",
			Category->"Sample Preparation"
		},
		DilutionMixVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description -> "The volume that is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation"
		},
		DilutionNumberOfMixes->{
			Format->Single,
			Class->Integer,
			Pattern:>RangeP[0,20,1],
			Description -> "The number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation"
		},
		DilutionMixRate->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0.4 Microliter/Second,500 Microliter/Second],
			Units->Microliter/Second,
			Description -> "The speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation"
		},
		DilutionStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description -> "The conditions under which any leftover samples from the DilutionCurve should be stored after the samples are transferred to the measurement plate.",
			Category->"Sample Preparation"
		},
		(* --- Stirring --- *)
		AcquisitionMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the samples should be mixed with a stir bar during data acquisition.",
			Category -> "Particle Size Measurements"
		},
		AcquisitionMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MixTypeP,
			Description -> "Indicates the type of the mix, either stir by a stir bar or swirl the container by hands during the data collection; or other mix type before the data collection.",
			Category -> "Particle Size Measurements"
		},
		NumberOfMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,40,1],
			Units -> None,
			Description -> "Indicates the number of swirl or pipette (by hands) if the corresponding MixTypes is Swirl or Pipette, before the particle sizes of the sample is collected.",
			Category -> "Particle Size Measurements"
		},
		WaitTimeBeforeReading -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Category -> "Particle Size Measurements",
			Description->"Indicates the length of time for which the sample containers are placed standstill before their ParticleSizes are measured."
		},
		StirBar -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part,StirBar],Object[Part,StirBar]],
			Description -> "Indicates the stir bar used to agitate the sample during acquisition.",
			Category -> "Particle Size Measurements"
		},
		AcquisitionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "Indicates the rate at which the samples is mixed with a stir bar during data acquisition.",
			Category -> "Particle Size Measurements"
		},
		AdjustMixRate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing should continue up to MaxStirAttempts in attempts to stir the samples.",
			Category -> "Particle Size Measurements"
		},
		MinAcquisitionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[50 RPM,350 RPM],
			Units -> RPM,
			Description -> "Indicates the lower limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar.",
			Category -> "Particle Size Measurements"
		},
		MaxAcquisitionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[50 RPM,350 RPM],
			Units -> RPM,
			Description -> "Indicates the upper limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar.",
			Category -> "Particle Size Measurements"
		},
		AcquisitionMixRateIncrement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[10 RPM, 1400 RPM],
			Units -> RPM,
			Description -> "Indicates the value to increase or decrease the mixing rate by in a stepwise fashion while attempting to mix the samples with a stir bar.",
			Category -> "Particle Size Measurements"
		},
		MaxStirAttempt -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,10,1],
			Units -> None,
			Description -> "Indicates the maximum number of attempts to mix the samples with a stir bar.",
			Category -> "Particle Size Measurements"
		},
		
		(*--- Wash ---*)
		WashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of SamplesIn, the solution pumped through the instrument's flow path to clean it between the loading of each new sample.",
			Category -> "Washing"
		},
		WashSolutionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature to which the WashSolution is preheated before flowing it through the flow path.",
			Category -> "Washing"
		},
		WashEquilibrationTime -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the length of time for which the wash solution container equilibrate at the requested WashSolutionTemperature in the sample rack before being pumped through the instrument's flow path.",
			Category->"Washing"
		},
		WashWaitTime -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the amount of time for which the syringe is allowed to soak with each wash solution before flushing it to the waste.",
			Category->"Washing"
		},
		NumberOfWash -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,10,1],
			Units -> None,
			Description -> "The number of times each wash solution pumped through the instrument's flow path.",
			Category -> "Priming"
		},
		AcquisitionMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "Indicates the duration of time for which the samples will be mixed before acquisition.",
			Category -> "Particle Size Measurements"
		},
		AcquisitionMixInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives@@Join[MixInstrumentModels, MixInstrumentObjects],
			Description -> "Indicates the instrument used to perform the Mix and/or Incubation before acquisition.",
			Category -> "Particle Size Measurements"
		}
	}
}];
