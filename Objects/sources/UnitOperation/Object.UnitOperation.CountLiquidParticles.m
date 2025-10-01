(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,CountLiquidParticles],
	{
		Description->"A detailed set of parameters that specifies a single liquid particle counting step a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			(* --- General --- *)
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
				Description -> "The sample to be analyzed during this light obscuration experiment.",
				Category -> "General",
				Migration->SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The sample to be analyzed during this light obscuration experiment.",
				Category -> "General",
				Migration->SplitField
			},
			SampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the source sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			SampleContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the source container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			Method -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> _Link|Custom,
				Relation -> Object[Method],
				Description->"The light obscuration standard procedure method object that describes the conditions for liquid particle counting.",
				Category -> "General",
				Abstract -> True
			},
			SaveCustomMethod -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates whether new or modified the method will be saved.",
				Category -> "General"
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
				Description ->"The size of the syringe installed on the instrument sampler used to draw the liquid through the light obscuration sensor and flush it back out.",
				Category -> "General",
				Abstract -> True
			},
			Instrument -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Instrument,LiquidParticleCounter],Object[Instrument,LiquidParticleCounter]],
				Description -> "The instrument used to detect and count particles in a sample using light obscuration while flowing the sample through a flow cell.",
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

			(* --- Prime --- *)
			PrimeSolutions -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Sample],Model[Sample]],
				Description -> "The solution(s) pumped through the instrument's flow path prior to the loading and measuring samples.",
				Category -> "Priming"
			},
			PrimeSolutionTemperaturesReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 * Kelvin],
				Units -> Celsius,
				Description -> "For each member of PrimeSolutions, the temperature to which the PrimeSolutions is preheated before flowing it through the flow path.",
				Category -> "Priming",
				Migration->SplitField
			},
			PrimeSolutionTemperaturesExpression -> {
				Format -> Multiple,
				Class->Expression,
				Pattern:>Alternatives[Ambient],
				Description -> "For each member of PrimeSolutions, the temperature to which the PrimeSolutions is preheated before flowing it through the flow path.",
				Category -> "Priming",
				Migration->SplitField
			},
			PrimeEquilibrationTime -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Minute],
				Units->Minute,
				Description->"For each member of PrimeSolutions, the length of time for which the prime solution container equilibrate at the requested PrimeSolutionTemperatures in the sample rack before being pumped through the instrument's flow path.",
				Category->"Priming"
			},
			PrimeWaitTime -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Minute],
				Units->Minute,
				Description->"For each member of PrimeSolutions, the amount of time for which the syringe is allowed to soak with each prime solutions before flushing it to the waste.",
				Category->"Priming"
			},
			NumberOfPrimes -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> RangeP[1,10,1],
				Units -> None,
				Description -> "For each member of PrimeSolutions, the number of times each prime solution pumped through the instrument's flow path.",
				Category -> "Priming"
			},

			(* ------Sample Prep------ *)
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
				Pattern :> {GreaterEqualP[0Microliter],GreaterEqualP[0Microliter],GreaterEqualP[1,1]} | {GreaterEqualP[0Microliter], {GreaterEqualP[0, 1],GreaterEqualP[1, 1]}} | {GreaterEqualP[0Microliter], {GreaterEqualP[0, 1]...}},
				Description -> "The collection of dilutions that will be performed on the samples before light obscuration measurements are taken.",
				Category -> "Sample Preparation"
			},
			Diluent->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Sample],Model[Sample]],
				Description->"The sample that is used to dilute the sample.",
				Category->"Sample Preparation"
			},
			DilutionContainer -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>{(ObjectP[{Model[Container],Object[Container]}]|Null)..},
				Description->"The container or containers in which each sample is diluted with the Diluent to make the concentration series.",
				Category->"Sample Preparation"
			},
			DilutionMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume that is pipetted up and down to mix the sample with the corresponding Diluents to make the dilution series.",
				Category -> "Sample Preparation"
			},
			DilutionNumberOfMixes -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> RangeP[0, 20, 1],
				Description -> "The number of pipette up and down cycles that is used to mix the sample with the corresponding Diluents to make the dilution series.",
				Category -> "Sample Preparation"
			},
			DilutionMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern:>RangeP[0.4 Microliter/Second,500 Microliter/Second],
				Units->Microliter/Second,
				Description -> "The speed at which the DilutionMixVolumes is pipetted up and down to mix the sample with the corresponding Diluents to make the dilution series.",
				Category -> "Sample Preparation"
			},
			DilutionStorageCondition->{
				Format->Multiple,
				Class->Expression,
				Pattern:>SampleStorageTypeP|Disposal,
				Description -> "The conditions under which any leftover samples from the DilutionCurve should be stored after the samples are transferred to the measurement plate.",
				Category->"Sample Preparation"
			},
			(* ------Measurement------ *)
			ReadingVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Liter*Micro],
				Units -> Liter Micro,
				Description -> "The volume of sample that is loaded into the instrument and used to determine particle size and count.",
				Category -> "Particle Size Measurements"
			},
			DiscardFirstRun -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the first run will be ignored during data collection.",
				Category -> "Particle Size Measurements"
			},
			SamplingHeight  -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Millimeter],
				Units -> Millimeter,
				Description -> "Indicates if the height of the sensor probe when reading the number of particles during data collection.",
				Category -> "Particle Size Measurements"
			},
			SampleTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Kelvin],
				Units -> Celsius,
				Description -> "The temperature of the instrument's sampler tray where samples are equilibrated just prior to the injection.",
				Category -> "Particle Size Measurements",
				Migration->SplitField
			},
			SampleTemperatureExpression -> {
				Format -> Multiple,
				Class->Expression,
				Pattern:>Alternatives[Ambient],
				Description -> "The temperature of the instrument's sampler tray where samples are equilibrated just prior to the injection.",
				Category -> "Particle Size Measurements",
				Migration->SplitField
			},
			EquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Minute],
				Units -> Minute,
				Description -> "The length of time for which each sample is incubated at the requested SampleTemperature just prior to being read.",
				Category -> "Particle Size Measurements"
			},
			NumberOfReadings -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> RangeP[1,10,1],
				Units -> None,
				Description -> "The number of times the liquid particle count is read by passing ReadingVolume through the light obscuration sensor.",
				Category -> "Particle Size Measurements"
			},
			PreRinseVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Liter*Micro],
				Units -> Liter Micro,
				Description -> "The volume of the sample flown into the syringe tubing to rinse out the lines with each new sample before beginning the reading.",
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
			FlowRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Milliliter/Minute],
				Units -> Milliliter/Minute,
				Description -> "The rate of sample pumped through the instrument by the syringe.",
				Category -> "Particle Size Measurements"
			},

			(* --- Stirring --- *)
			AcquisitionMix -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates whether the samples should be mixed with a stir bar during data acquisition.",
				Category -> "Particle Size Measurements"
			},
			AcquisitionMixType -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[Swirl,Stir],
				Description -> "Indicates the type of the mix, either stir by a stir bar or swirl the container by hands, during the data collection.",
				Category -> "Particle Size Measurements"
			},
			NumberOfMixes -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> RangeP[1,40,1],
				Units -> None,
				Description -> "Indicates the number of swirl (by hands) if the corresponding AcquisitionMixTypes is Swirl, before the particle sizes of the sample is collected.",
				Category -> "Particle Size Measurements"
			},
			WaitTimeBeforeReading -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Minute],
				Units->Minute,
				Description->"Indicates the length of time for which the sample containers are placed standstill before their ParticleSizes are measured.",
				Category -> "Particle Size Measurements"
			},
			StirBar -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Part,StirBar],Object[Part,StirBar]],
				Description -> "Indicates the stir bar used to agitate the sample during acquisition.",
				Category -> "Particle Size Measurements"
			},
			AcquisitionMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 RPM],
				Units -> RPM,
				Description -> "Indicates the rate at which the samples is mixed with a stir bar during data acquisition.",
				Category -> "Particle Size Measurements"
			},
			AdjustMixRate -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if mixing should continue up to MaxStirAttempts in attempts to stir the samples.",
				Category -> "Particle Size Measurements"
			},
			MinAcquisitionMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 RPM],
				Units -> RPM,
				Description -> "Indicates the lower limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar.",
				Category -> "Particle Size Measurements"
			},
			MaxAcquisitionMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 RPM],
				Units -> RPM,
				Description -> "Indicates the upper limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar.",
				Category -> "Particle Size Measurements"
			},
			AcquisitionMixRateIncrement -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 RPM],
				Units -> RPM,
				Description -> "Indicates the upper limit stirring rate to be decreased to for sample mixing while attempting to mix the samples with a stir bar.",
				Category -> "Particle Size Measurements"
			},
			MaxStirAttempts -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> RangeP[1,10,1],
				Units -> None,
				Description -> "Indicates the maximum number of attempts to mix the samples with a stir bar.",
				Category -> "Particle Size Measurements"
			},
			StirringErrors -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if uniform stirring was not achieved within the cuvette after MaxStirAttempts during the setup of the assay.",
				Category -> "Absorbance Measurement"
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
				Category -> "Absorbance Measurement"
			},
			
			(*--- Wash ---*)
			WashSolution -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Sample],Model[Sample]],
				Description -> "The solution pumped through the instrument's flow path to clean it between the loading of each new sample.",
				Category -> "Washing"
			},
			WashSolutionTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 * Kelvin],
				Units -> Celsius,
				Description -> "The temperature to which the WashSolution is preheated before flowing it through the flow path.",
				Category -> "Washing",
				Migration->SplitField
			},
			WashSolutionTemperatureExpression -> {
				Format -> Multiple,
				Class->Expression,
				Pattern:>Alternatives[Ambient],
				Description -> "The temperature to which the WashSolution is preheated before flowing it through the flow path.",
				Category -> "Washing",
				Migration->SplitField
			},
			WashEquilibrationTime -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Minute],
				Units->Minute,
				Description->"The length of time for which the wash solution container equilibrate at the requested WashSolutionTemperature in the sample rack before being pumped through the instrument's flow path.",
				Category->"Washing"
			},
			WashWaitTime -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Minute],
				Units->Minute,
				Description->"The amount of time for which the syringe is allowed to soak with each wash solution before flushing it to the waste.",
				Category->"Washing"
			},
			NumberOfWashes -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0,1],
				Description -> "The number of times that the syringe is washed with WashSolution.",
				Category->"Washing"
			},
			SampleQueueNames-> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The name of the sample in the experiment run.",
				Category -> "Method Information",
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
			
			(*--- Placements and Indexes ---*)
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
			WashIndexes -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {GreaterP[0]..},
				Description -> "The indexes in WorkingContainers of each container in BatchedContainer lengths.",
				Category -> "Washing",
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
			SampleConcentrationRangeFailures -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the data collection failed due to the concentration of the sample is out of the detection limit of the Instrument.",
				Category -> "Data Processing"
			},
			VideoFolderNames->{
				Format->Multiple,
				Class->String,
				Pattern:>FilePathP,
				Description -> "The folder and the final file name that will be generated for the videos to be saved in.",
				Category -> "Data Processing"
			},
			StirBarWashSolutions -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "The solvent used for washing the stir bar.",
				Category -> "Washing"
			},
			WasteBeaker->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Container,Vessel]|Model[Container,Vessel],
				Description->"A vessel that is used to catch any residual water that comes off the stir bar washer when it is washed.",
				Category->"Washing"
			},
			StirBarWasher -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Part],Object[Part]],
				Description -> "The stir bar washer that is used to wash the stir bar after it is taken out of the zip bag and to transfer it to sample container.",
				Category -> "Washing"
			},
			Pipettes -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Item, Consumable],Model[Item, Consumable]],
				IndexMatching->SamplesIn,
				Description -> "The pipette used to wash the stir bar after it is taken out of the zip bag.",
				Category -> "Washing"
			}
		}
	}
];
