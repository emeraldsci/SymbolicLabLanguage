(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, CountLiquidParticles], {
	Description->"A protocol for measuring the intensity of scattered light from solutions with a nephelometer. This is often used to determine solubility of a compound or cell count of culture samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- General --- *)
		Methods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Link | Custom,
			Relation -> Object[Method],
			Description -> "The light obscuration standard procedure method object that describes the conditions for liquid particle counting.",
			Category -> "General",
			Abstract -> True
		},
		ParticleSizes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 * Micrometer])..},
			Description -> "The collection of ranges the different particle sizes that monitored. Allowed particle sizes are in 5 to 80 Micrometers.",
			Category -> "General",
			Abstract -> True
		},
		SyringeSize -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> HIACSyringeSizeP, (*HIACSyringeSizeP=Alternatives[1 Milliliter, 10 Milliliter]*)
			Description -> "The size of the syringe installed on the instrument sampler used to draw the liquid through the light obscuration sensor and flush it back out.",
			Category -> "General",
			Abstract -> True
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, LiquidParticleCounter], Object[Instrument, LiquidParticleCounter]],
			Description -> "The instrument used to detect and count particles in a sample using light obscuration while flowing the sample through a flow cell.",
			Category -> "General",
			Abstract -> True
		},
		Sensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part, LightObscurationSensor], Object[Part, LightObscurationSensor]],
			Description -> "The light obscuration sensor that measures the reduction in light intensity and processes the signal to determine particle size and count. The sensor sets the range of the particle sizes that can be detected.",
			Category -> "General"
		},
		Syringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part, Syringe], Object[Part, Syringe]],
			Description -> "The syringe installed on the instrument sampler used to draw the liquid through the light obscuration sensor and out of the system.",
			Category -> "General"
		},
		
		(* --- Prime --- *)
		PrimeSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution(s) pumped through the instrument's flow path prior to the loading and measuring samples.",
			Category -> "Priming"
		},
		PrimeSolutionTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "For each member of PrimeSolutions, the temperature to which the PrimeSolutions is preheated before flowing it through the flow path.",
			Category -> "Priming",
			IndexMatching -> PrimeSolutions
		},
		PrimeEquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of PrimeSolutions, the length of time for which the prime solution container equilibrate at the requested PrimeSolutionTemperatures in the sample rack before being pumped through the instrument's flow path.",
			Category -> "Priming",
			IndexMatching -> PrimeSolutions
		},
		PrimeWaitTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "For each member of PrimeSolutions, the amount of time for which the syringe is allowed to soak with each prime solutions before flushing it to the waste.",
			Category -> "Priming",
			IndexMatching -> PrimeSolutions
		},
		NumberOfPrimes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1, 10, 1],
			Units -> None,
			Description -> "For each member of PrimeSolutions, the number of times each prime solution pumped through the instrument's flow path.",
			Category -> "Priming",
			IndexMatching -> PrimeSolutions
		},
		PrimeIndexes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]..},
			Description -> "For each member of PrimeSolutions, the indexes in WorkingContainers of each container in BatchedContainer lengths.",
			Category -> "Priming",
			IndexMatching -> PrimeSolutions,
			Developer -> True
		},
		PrimeSolutionsRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container] | Model[Container], Object[Container] | Object[Instrument], Null},
			Description -> "For each member of PrimeSolutions, list of PrimeSolution rack placements.",
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> PrimeSolutions,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		PrimeSolutionsContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container] | Model[Container], Model[Container]|Object[Container] | Object[Instrument], Null},
			Description -> "For each member of PrimeSolutions, list of PrimeSolution container placements.",
			Category -> "Placements",
			Developer -> True,
			IndexMatching -> PrimeSolutions,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		PrimeSolutionsContainerProbePositions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Inch],
			Units -> Inch,
			Description -> "For each member of PrimeSolutions, position of probe when merge the probe into the PrimeSolutions.",
			Category -> "Placements",
			IndexMatching -> PrimeSolutions,
			Developer -> True
		},
		
		
		(* ------Sample Prep------ *)
		Dilutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterEqualP[0Microliter], GreaterEqualP[0Microliter]}..},
			Description -> "For each member of SamplesIn, the collection of dilutions that performed on the samples before light obscuration measurements are taken.",
			Category -> "Sample Preparation"
		},
		SerialDilutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterEqualP[0 Microliter], GreaterEqualP[0 Microliter]}..},
			Description -> "For each member of SamplesIn, the collection of dilutions that will be performed on the samples before light obscuration measurements are taken.",
			Category -> "Sample Preparation"
		},
		Diluents->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of SamplesIn, the sample that is used to dilute the sample.",
			Category->"Sample Preparation"
		},
		SampleLoadingVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			Units -> Liter Micro,
			Description -> "The volume of sample-diluent mixture loaded into each well.",
			Category -> "Sample Preparation"
		},
		DilutionContainers->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{ObjectP[{Model[Container],Object[Container]}]..},
			Description->"The container or containers in which each sample is diluted with the Diluent to make the concentration series.",
			Category->"Sample Preparation"
		},
		DilutionContainerResouces->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The container or containers in which each sample is diluted with the Diluent to make the concentration series.",
			Category->"Sample Preparation",
			Developer -> True
		},
		SampleDilutionPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SamplePreparationP,
			Description -> "A set of instructions specifying the loading and mixing of each sample and the Diluent in the DilutionContainers.",
			Category -> "Sample Preparation"
		},
		SampleDilutionManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Protocol,ManualSamplePreparation],Object[Protocol,RoboticSamplePreparation]],
			Description->"A sample manipulation protocol used to load the DilutionContainers and mix its contents.",
			Category->"Sample Preparation"
		},
		DilutionMixVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description -> "For each member of SamplesIn, the volume that is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation",
			IndexMatching -> SamplesIn
		},
		DilutionNumberOfMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>RangeP[0,20,1],
			Description -> "For each member of SamplesIn, the number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation",
			IndexMatching -> SamplesIn
		},
		DilutionMixRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0.4 Microliter/Second,500 Microliter/Second],
			Units->Microliter/Second,
			Description -> "For each member of SamplesIn, the speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation",
			IndexMatching -> SamplesIn
		},
		DilutionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description -> "For each member of SamplesIn, the conditions under which any leftover samples from the DilutionCurve should be stored after the samples are transferred to the measurement plate.",
			Category->"Sample Preparation",
			IndexMatching -> SamplesIn
		},
		(* ------Measurement------ *)
		ReadingVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of sample that is loaded into the instrument and used to determine particle size and count.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		SampleTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the temperature of the instrument's sampler tray where samples are equilibrated just prior to the injection.",
			Category -> "Particle Size Measurements"
		},
		FlowRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter/Minute],
			Units -> Milliliter/Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the rate of sample pumped through the instrument by the syringe.",
			Category -> "Particle Size Measurements"
		},
		EquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the length of time for which each sample is incubated at the requested SampleTemperature just prior to being read.",
			Category -> "Particle Size Measurements",
			IndexMatching -> SamplesIn
		},
		NumberOfReadings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1,10,1],
			Units -> None,
			Description -> "For each member of SamplesIn, the number of times the liquid particle count is read by passing ReadingVolume through the light obscuration sensor.",
			Category -> "Particle Size Measurements"
		},
		PreRinseVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of the sample flown into the syringe tubing to rinse out the lines with each new sample before beginning the reading.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		PreRinseVolumeStrings -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The String form of PreRinseVolume that used in the SnapText.",
			Category -> "Particle Size Measurements",
			Developer -> True
		},
		DiscardFirstRuns  -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the first run will be ignored during data collection.",
			Category -> "Particle Size Measurements",
			Category -> "Particle Size Measurements",
			IndexMatching->SamplesIn
		},
		SamplingHeights  -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "For each member of SamplesIn, indicates if the height of the sensor probe when reading the number of particles during data collection.",
			Category -> "Particle Size Measurements",
			IndexMatching->SamplesIn
		},
		(* --- Stirring --- *)
		AcquisitionMixes -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates whether the samples should be mixed with a stir bar during data acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		AcquisitionMixTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Swirl,Stir],
			Description -> "For each member of SamplesIn, indicates the type of the mix, either stir by a stir bar or swirl the container by hands, during the data collection.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		NumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1,40,1],
			Units -> None,
			Description -> "For each member of SamplesIn, indicates the number of swirl (by hands) if the corresponding AcquisitionMixTypes is Swirl, before the particle sizes of the sample is collected.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		WaitTimeBeforeReadings -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, indicates the length of time for which the sample containers are placed standstill before their ParticleSizes are measured.",
			Category->"Washing",
			IndexMatching->SamplesIn
		},
		StirBars -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part,StirBar],Object[Part,StirBar]],
			Description -> "For each member of SamplesIn, indicates the stir bar used to agitate the sample during acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		AcquisitionMixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 RPM, 350 RPM],
			Units -> RPM,
			Description -> "For each member of SamplesIn, indicates the rate at which the samples is mixed with a stir bar during data acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		AdjustMixRates -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if mixing should continue up to MaxStirAttempts in attempts to stir the samples.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		MinAcquisitionMixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 RPM, 350 RPM],
			Units -> RPM,
			Description -> "For each member of SamplesIn, indicates the lower limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		MaxAcquisitionMixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 RPM, 350 RPM],
			Units -> RPM,
			Description -> "For each member of SamplesIn, indicates the upper limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		AcquisitionMixRateIncrements -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[10 RPM, 1400 RPM],
			Units -> RPM,
			Description -> "For each member of SamplesIn, indicates the value to increase or decrease the mixing rate by in a stepwise fashion while attempting to mix the samples with a stir bar.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		MaxStirAttempts -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1,10,1],
			Units -> None,
			Description -> "For each member of SamplesIn, indicates the maximum number of attempts to mix the samples with a stir bar.",
			IndexMatching -> SamplesIn,
			Category -> "Particle Size Measurements"
		},
		StirringErrors -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if uniform stirring was not achieved within the cuvette after MaxStirAttempts during the setup of the assay.",
			Category -> "Particle Size Measurements"
		},
		StirAttemptsCounters -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description ->"The stir attempt number that is currently being tested.",
			Category -> "General",
			Developer -> True
		},
		ActualAcquisitionMixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 RPM],
			Units -> RPM,
			Description ->"Indicates the absolute/exact rate at which the samples within the cuvette attained during data acquisition.",
			Category -> "Particle Size Measurements"
		},
		
		
		(*--- Wash ---*)
		WashSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of SamplesIn, the solution pumped through the instrument's flow path to clean it between the loading of each new sample.",
			Category -> "Washing",
			IndexMatching -> SamplesIn
		},
		WashSolutionTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature to which the WashSolution is preheated before flowing it through the flow path.",
			Category -> "Washing",
			IndexMatching -> SamplesIn
		},
		WashEquilibrationTimes -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the length of time for which the wash solution container equilibrate at the requested WashSolutionTemperature in the sample rack before being pumped through the instrument's flow path.",
			Category->"Washing",
			IndexMatching->SamplesIn
		},
		WashWaitTimes -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the amount of time for which the syringe is allowed to soak with each wash solution before flushing it to the waste.",
			Category->"Washing",
			IndexMatching->SamplesIn
		},
		NumberOfWashes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1,10,1],
			Units -> None,
			Description -> "For each member of SamplesIn, the number of times each wash solution pumped through the instrument's flow path.",
			Category -> "Washing",
			IndexMatching->SamplesIn
		},
		WashIndexes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]..},
			Description -> "For each member of SamplesIn, the indexes in WorkingContainers of each container in BatchedContainer lengths.",
			Category -> "Washing",
			IndexMatching->SamplesIn,
			Developer -> True
		},
		RinsingSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to rinse the system after the wash solution is applied.",
			Category -> "Washing"
		},
		(* --- Prime --- *)
		FillLiquid -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The liquid that is used to fill the ProbeStorageContainer.",
			Category -> "Washing",
			Abstract -> True
		},
		SampleRackPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Container]|Object[Instrument], Null},
			Description -> "List of sample rack placements.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		SampleContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Model[Container]| Object[Container]|Object[Instrument], Null},
			Description -> "List of sample container placements.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		SampleProbePositions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Inch],
			Units -> Inch,
			Description -> "Position of probe when merge the probe into the WorkingSamples.",
			Category -> "Placements",
			Developer -> True
		},
		WashSolutionRackPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Container]|Object[Instrument], Null},
			Description -> "List of WashSolution rack placements.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		WashSolutionContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Model[Container]|Object[Container]|Object[Instrument], Null},
			Description -> "List of WashSolution container placements.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		WashSolutionProbePositions ->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Inch],
			Units -> Inch,
			Description -> "Position of probe when merge the probe into the RinsingSolution.",
			Category -> "Placements",
			Developer -> True
		},
		RinsingSolutionRackPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Container]|Object[Instrument], Null},
			Description -> "List of RisingSolution rack placements.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		RinsingSolutionContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Model[Container]|Object[Container]|Object[Instrument], Null},
			Description -> "List of RisingSolution container placements.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		RinsingSolutionProbePositions ->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Inch],
			Units -> Inch,
			Description -> "Position of probe when merge the probe into the RinsingSolution.",
			Category -> "Placements",
			Developer -> True
		},
		ProbeStorageContainer ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Container from the instrument tHIAC 9703 Plus Lower the Probe For ProbeStorageContainerhat used to stora the probe of the instrument after the experiment.",
			Category -> "Placements",
			Developer -> True
		},
		ProbeStorageContainerPlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container]|Model[Container], Object[Container]|Object[Instrument], Null},
			Description -> "List of ProbeStorage container placements.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		ProbeStorageContainerProbePosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Inch],
			Units -> Inch,
			Description -> "Position of probe when merge the probe into the ProbeStorageContainer.",
			Category -> "Placements",
			Developer -> True
		},
		SyringePlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Part]|Model[Part], Object[Instrument], Null},
			Description -> "List of Syringe placements.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		InstrumentSyringePlacements ->{
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Part]|Model[Part], Object[Instrument], Null},
			Description -> "List of Syringe placements to put the instrument storage syringe back.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		},
		(*Method of the protocol*)
		SampleQueueNames-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, the name of the sample in the experiment run.",
			Category -> "Method Information",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		MethodFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The name(s) of the method file for each sample ran in the PharmSpec.",
			Category -> "General",
			Developer -> True
		},
		ExportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the export script file used to convert and export data gathered by the instrument to the network drive.",
			Category -> "Method Information",
			Developer -> True
		},
		ImportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the import script file used to convert procedure JSON file from the network drive to the method file that can be ran by the Instrument .",
			Category -> "Method Information",
			Developer -> True
		},
		DilutionSampleLabels -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_String...},
			Description -> "For each member of SamplesIn, the output labels for the samples out.",
			Category -> "Method Information",
			Developer -> True,
			IndexMatching->SamplesIn
		},
		InstrumentRecoveryWashIndexes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]..},
			Description -> "For each member of SamplesIn, the indexes in WorkingContainers of each container in BatchedContainer lengths.",
			Category -> "Method Information",
			IndexMatching->SamplesIn,
			Developer -> True
		},
		(* ------Data Processing------- *)
		SampleConcentrationRangeFailures -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the data collection failed due to the concentration of the sample is out of the detection limit of the Instrument.",
			Category -> "Data Processing"
		},
		DataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The file names of the exported raw data files from the light obscuration measurements.",
			Category -> "Data Processing",
			Developer -> True
		},
		StirBarRetriever -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, StirBarRetriever],
				Model[Part, StirBarRetriever]
			],
			Description -> "The magnet and handle used to remove the StirBar from the WorkingContainer.",
			Category -> "Sample Storage",
			Developer -> True
		},
		VideoFolderNames->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description -> "For each member of SamplesIn, the folder and the final file name that will be generated for the videos to be saved in.",
			Category -> "Data Processing",
			IndexMatching -> SamplesIn
		},
		NestedVideoFilePaths->{
			Format->Multiple,
			Class->Expression,
			Pattern:> {FilePathP...},
			Description->"For each member of VideoFolderNames, the full file paths of the video files generated from experiment run.",
			Category -> "Data Processing",
			IndexMatching -> VideoFolderNames
		},
		VideoFilePaths->{
			Format->Multiple,
			Class->String,
			Pattern:> FilePathP,
			Description->"The full file paths of the video files generated from experiment run.",
			Category -> "Data Processing"
		},
		ProcessRecording -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of VideoFilePaths, the video recording for each liquid particle reading process.",
			Category -> "Data Processing",
			IndexMatching -> VideoFilePaths
		}

	}
}];