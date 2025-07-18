(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Chromatography], {
	Description->"Analytical data captured during a chromatographic separation technique.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DateInjected -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date and time the input sample was injected into the Instrument and measured.",
			Category -> "General",
			Abstract -> True
		},
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographyDataTypeP,
			Description -> "Indicates if this data represents a blank, standard, sample, column flush, or column prime measurement.",
			Category -> "General",
			Abstract -> True
		},
		InjectionIndex -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The sample index in the Injection Table that the current data was measured for (e.g. 1 is the first measurement run).",
			Category -> "General"
		},
		SamplingMethod->{
			Format->Single,
			Class->Expression,
			Pattern:> GCSamplingMethodP,
			Description -> "The method containing detailed instructions used to inject the sample in a gas chromatography experiment.",
			Category -> "Method Information"
		},
		InjectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FPLCInjectionTypeP (*FlowInjection | Autosampler | Superloop*),
			Description -> "Whether the system introduces sample in to the flow path via the automated injection module (Autosampler), directly from an inlet line submerged into the samples (FlowInjection), or with a large, volume-controlled sample loop (Superloop) externally connected on the injection valve. FlowInjection and Superloop are relevent for FPLC.",
			Category -> "Method Information"
		},
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume taken from the SamplesIn and injected into the Instrument at time zero.",
			Category -> "Method Information"
		},
		SPMESampleAdsorptionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The amount of time that a SPME fiber was allowed to adsorb analytes during the injection of this sample in Gas Chromatography.",
			Category -> "Method Information"
		},
		SPMESampleDesorptionTime -> {(* GC QA *)
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The amount of time that a SPME fiber was allowed to desorb its adsorbents during the injection of this sample in Gas Chromatography.",
			Category -> "Method Information"
		},
		SampleFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute],
			Units -> (Milli * Liter) / Minute,
			Description -> "The rate at which the sample is injected onto the Column when InjectionType is FlowInjection or Superloop.",
			Category -> "Method Information"
		},
		SampleTemperature -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "The specified temperature of autosampler chamber where samples are housed before and after injection.",
			Category -> "Method Information"
		},
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP|FlameIonizationDetector|ElectrochemicalDetector,
			Description -> "The types of active detectors in the flow path followed by seperation on the column connected in the order they are listed.",
			Category -> "Method Information"
		},
		ChromatographyType->{
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographyTypeP,
			Description -> "The chromatographic separation technique that was used to generate this data. Options include HPLC, FPLC, Flash, Super Critical Fluid Chromatography, Gas Chromatogrpah, and IonChromatography.",
			Category -> "Model Information",
			Abstract -> True
		},
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of chromatographic separation that categorizes the mobile (e.g. BufferA) and stationary phase used (e.g. Columns), ideally for optimal sample separation and resolution. Separation modes being offered are normal phase, reverse phase, ion exchange, size exclusion, affinity and chiral. Normal phase is a technique that uses polar stationary phase with non polar mobile phases. Reverse phase uses hydrophobic stationary phase along with polar mobile phases. Ion chromatography is a method for separating ions based on their interaction with the charged stationary phase. Size exclusion separates molecules in the mobile phase based on their size by passing it through porous stationary phase. Affinity chromatography separates molecules based on their interaction with the stationary phase. Chiral chromatography relfers to the separation of optical isomers or enantiomers using HPLC or SFC.",
			Category -> "Method Information",
			Abstract -> True
		},
		IonChromatographyAnalysisChannels -> {
			Format -> Single,
			Class -> Expression, 
			Pattern :> AnalysisChannelP,
			Description -> "The channel into which each sample is injected that defines the flow path of the sample through the instrument. Cation channel is used to separate positively charged species whereas anion channel is used to resolve negatively charged species for Ion Exchange Chromatography.",
			Category -> "General",
			Abstract -> True
		},
		Columns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][Data],
			Description -> "The stationary phase device(s) connected in the listed order through which the Buffers and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the Buffers, samples, column material, and ColumnTemperature. For each item in Columns, consecutive objects are connected by the corresponding object in ColumnJoins. For example, the first and second object in Columns is connected by the first object in ColumnJoins.",
			Category -> "Method Information"
		},
		ColumnTemperature -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "The specified temperature of the Columns during the separation and measurement.",
			Category -> "Method Information"
		},
		ColumnTemperatureProfile -> {
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterEqualP[0*Minute],GreaterP[0*Celsius]},
			Units -> {Minute,Celsius},
			Description -> "The set temperature of the colum oven as a function of time of the column(s) during the separation and measurement for Gas Chromatography experiment.",
			Category -> "Method Information",
			Headers -> {"Time", "Temperature"}
		},
		ColumnOrientation -> {
			Format->Single,
			Class->Expression,
			Pattern :>ColumnOrientationP,
			Description->"The direction of the Column with respect to the flow of the mobile phase as determined by the column packing direction. Reverse is typically used to clean the column.",
			Category -> "Method Information"
		},
		GuardColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][Data],
			Description -> "The protective stationary phase device often used to adsorb and sequester fouling contaminants from the Columns.",
			Category -> "Method Information"
		},
		GuardCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][Data],
			Description -> "The module that holds the protective stationary phase material within the GuardColumn.",
			Category -> "Method Information"
		},
		GuardColumnOrientation -> {
			Format->Single,
			Class->Expression,
			Pattern :>ColumnOrientationP,
			Description->"The position of the GuardColumn with respect to the Column, SecondaryColumn and TertiaryColumn. Forward indicates that the GuardColumn will be placed in front of the Column, SecondaryColumn and TertiaryColumn. If a Column is specified and GuardColumnOrientation is Reverse, the GuardColumn will be placed after the Column, SecondaryColumn, and/or TertiaryColumn in the flow path which is typically performed during column cleaning.",
			Category -> "Method Information"
		},
		FlowDirection -> {
			Format->Single,
			Class->Expression,
			Pattern :>ColumnOrientationP,
			Description->"For FPLC, the direction of the flow going through the column, controlled with the instrument software's plumbing settings.",
			Category -> "Method Information"
		},
		FlowRates -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], GreaterEqualP[(0*Liter)/Minute]},
			Units -> {Minute, (Liter Milli)/Minute},
			Description -> "The net speed of the fluid flowing through the pump. This speed is linearly interpolated such that consecutive entries of {Time, Flow Rate} will define the intervening fluid speed. For example, {{0 Minute, 0.3 Millilliter/Minute},{30 Minute, 0.5 Milliliter/Minute}} means flow rate of 0.4 Milliliter/Minute at 15 minutes into the run.",
			Headers -> {"Time", "Flow Rate"},
			Category -> "Method Information"
		},
		ColumnPressures -> { (* GC QA *)
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], GreaterEqualP[0*PSI]},
			Units -> {Minute, PSI},
			Description -> "The profile of the pump head pressure over the course of the separation.",
			Headers -> {"Time", "Pressure"},
			Category -> "Method Information"
		},
		GradientMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The instructions for the mixing and distribution of the Buffer solutions within the mobile phase over time. For GasChromatogrpahy, this refers to GasChromatography Method and for HPLC, it refers to Gradient Method.",
			Category -> "Method Information"
		},
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent pumped through channel A of the flow path as defined by the GradientA.",
			Category -> "Method Information"
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent pumped through channel B of the flow path as defined by GradientB.",
			Category -> "Method Information"
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent pumped through channel C of the flow path as defined by GradientC.",
			Category -> "Method Information"
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent pumped through channel D of the flow path as defined by GradientD.",
			Category -> "Method Information"
		},
		BufferE -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent pumped through channel E of the flow path as defined by GradientE.",
			Category -> "Method Information"
		},
		BufferF -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent pumped through channel F of the flow path as defined by GradientF.",
			Category -> "Method Information"
		},
		BufferG -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent placed pumped through channel G of the flow path as defined by GradientG.",
			Category -> "Method Information"
		},
		BufferH -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent pumped through channel H of the flow path as defined by GradientH.",
			Category -> "Method Information"
		},
		GradientA -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of BufferA in the composition of flow over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run. The percentage is linearly interpolated such that consecutive entries of {Time, Buffer Composition} will define the intervening percentages.",
			Headers -> {"Time", "Buffer Composition"},
			Category -> "Method Information"
		},
		GradientB -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run. The percentage is linearly interpolated such that consecutive entries of {Time, Buffer Composition} will define the intervening percentages.",
			Headers -> {"Time", "Buffer Composition"},
			Category -> "Method Information"

		},
		GradientC -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run. The percentage is linearly interpolated such that consecutive entries of {Time, Buffer Composition} will define the intervening percentages.",
			Headers -> {"Time", "Buffer Composition"},
			Category -> "Method Information"
		},
		GradientD -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run. The percentage is linearly interpolated such that consecutive entries of {Time, Buffer Composition} will define the intervening percentages.",
			Headers -> {"Time", "Buffer Composition"},
			Category -> "Method Information"
		},
		GradientE -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of BufferE in the composition over time, in the form: {Time, % Buffer E} or a single % Buffer E for the entire run. The percentage is linearly interpolated such that consecutive entries of {Time, Buffer Composition} will define the intervening percentages.",
			Headers -> {"Time", "Buffer Composition"},
			Category -> "Method Information"
		},
		GradientF -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of BufferF in the composition over time, in the form: {Time, % Buffer F} or a single % Buffer F for the entire run. The percentage is linearly interpolated such that consecutive entries of {Time, Buffer Composition} will define the intervening percentages.",
			Headers -> {"Time", "Buffer Composition"},
			Category -> "Method Information"

		},
		GradientG -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of BufferG in the composition over time, in the form: {Time, % Buffer G} or a single % Buffer G for the entire run. The percentage is linearly interpolated such that consecutive entries of {Time, Buffer Composition} will define the intervening percentages.",
			Headers -> {"Time", "Buffer Composition"},
			Category -> "Method Information"
		},
		GradientH -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Percent, 100*Percent]},
			Units -> {Minute, Percent},
			Description -> "The percentage of BufferH in the composition over time, in the form: {Time, % Buffer H} or a single % Buffer H for the entire run. The percentage is linearly interpolated such that consecutive entries of {Time, Buffer Composition} will define the intervening percentages.",
			Headers -> {"Time", "Buffer Composition"},
			Category -> "Method Information"
		},
		EluentGeneratorInletSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent pumped through to the eluent generator in the anion channel of the IonChromatography instrument.",
			Category -> "Method Information"
		},
		Eluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The eluent automatically generated via eluent generator in the flow path of anion channel of the IonChromatography instrument.",
			Category -> "Method Information"
		},
		EluentGradient->{
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], RangeP[0*Millimolar, 100*Millimolar]},
			Units -> {Minute, Millimolar},
			Description -> "The concentration of eluent over time, in the form: {Time, eluent concentration (mM)} or a single eluent concentration for the entire run. For variable concentration, the concentration is linearly interpolated such that consecutive entries of {Time, Eluent Concentration} will define the intervening eluent concentration.",
			Headers -> {"Time", "Eluent Concentration"},
			Category -> "Method Information"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The time at which the binary gradient starts.",
			Category -> "Method Information"
		},
		GradientStartTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The time at which the gradient starts.",
			Category -> "Method Information"
		},
		GradientTimeEnd -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The time at which the binary gradient ends.",
			Category -> "Method Information"
		},
		pHCalibration -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if 2-point calibration of the pH probe is performed before the experiment starts.",
			Category -> "Calibration"
		},
		LowpHCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The low pH reference buffer used to calibrate the pH probe in the 2-point calibration.",
			Category -> "Calibration"
		},
		HighpHCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The high pH reference buffer used to calibrate the pH probe in the 2-point calibration.",
			Category -> "Calibration"
		},
		LowpHCalibrationTarget->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,14],
			Description->"The nominal pH of the LowpHCalibrationBuffer's model that used to calibrate the pH probe in the 2-point calibration.",
			Units -> None,
			Category -> "Calibration"
		},
		HighpHCalibrationTarget->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,14],
			Description->"The nominal pH of the HighpHCalibrationBuffer's model that used to calibrate the pH probe in the 2-point calibration.",
			Units -> None,
			Category -> "Calibration"
		},
		pHTemperatureCompensation -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if the measured pH value is automatically corrected according to the temperature value inside the pH flow cell.",
			Category -> "Calibration"
		},
		ConductivityCalibration -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if 1-point calibration of the conductivity probe is performed before the experiment starts.",
			Category -> "Calibration"
		},
		ConductivityCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The buffer that is used to calibrate the conductivity probe in the 1-point calibration.",
			Category -> "Calibration"
		},
		ConductivityCalibrationTarget->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0Micro*Siemens/Centimeter],
			Description->"The nominal conductivity value of the ConductivityCalibrationBuffer's model used to calibrate the conductivity probe in the 1-point calibration.",
			Units -> Micro*Siemens/Centimeter,
			Category -> "Calibration"
		},
		ConductivityTemperatureCompensation -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if the measured conductance value is automatically corrected according to the temperature value inside the conductivity flow cell.",
			Category -> "Calibration"
		},
		FractionCollectionDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "The type of detector that is used as signal to trigger fraction collection.",
			Category -> "Fraction Collection"
		},
		FractionCollectionMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The instructions used to collect column effluent based on fraction collection detector measurement.",
			Category -> "Fraction Collection"
		},
		AbsoluteThreshold -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli] | GreaterEqualP[0 RFU*Milli] | GreaterEqualP[0 Millisiemen/Centimeter] | UnitsP[0 Unit]),
			Description -> "The absorbance, fluorescence, conductivity or pH signal above which fractions will always be collected when in Threshold mode.",
			Category -> "Fraction Collection"
		},
		PeakEndThreshold -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli] | GreaterEqualP[0 RFU*Milli] | GreaterEqualP[0 Millisiemen/Centimeter] | UnitsP[0 Unit]),
			Description -> "The absorbance, fluorescence, conductivity or pH signal signal value below which the end of a peak is marked and fraction collection stops.",
			Category -> "Fraction Collection"
		},
		PeakSlope -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[(0*(AbsorbanceUnit*Milli))/Second]|GreaterEqualP[(0*(RFU*Milli))/Second] | GreaterEqualP[0 Millisiemen/(Centimeter Second)] | UnitsP[0 Unit / Second]),
			Description -> "The minimum slope rate (per second) that must be met before a peak is detected and fraction collection begins.  A new peak (and new fraction) can be registered once the slope drops below this again, and collection ends when the PeakEndThreshold value is reached.",
			Category -> "Fraction Collection"
		},
		PeakSlopeDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The minimum duration that changes in slopes must be maintained before they are registered as peaks.",
			Category -> "Fraction Collection"
		},
		FIDTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature of the Flame Ionization Detector (FID) body during analysis of the samples. This is relevenat for Gas Chromatography.",
			Category -> "Detection"
		},
		FIDAirFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Description -> "The flow rate of air supplied as an oxidant to the Flame Ionization Detector (FID) during sample analysis. This is relevenat for Gas Chromatography.",
			Category -> "Detection"
		},
		FIDDihydrogenFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Description -> "The flow rate of dihydrogen gas supplied as a fuel to the Flame Ionization Detector (FID) during sample analysis. This is relevenat for Gas Chromatography.",
			Category -> "Detection"
		},
		FIDMakeupGasFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milli*Liter/Minute],
			Units -> Milli*Liter/Minute,
			Description -> "The flow rate of the makeup gas added to the fuel flow supplied to the Flame Ionization Detector (FID) during sample analysis. This is relevenat for Gas Chromatography.",
			Category -> "Detection"
		},
		CarrierGasFlowCorrection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (Fuel|Makeup|None),
			Description -> "Specifies which (if any) of the Flame Ionization Detector (FID) gas supply flow rates (Fuel or Makeup) was adjusted as the column flow rate changed to keep the total flow into the FID constant during the separation. This is relevenat for Gas Chromatography.",
			Category -> "Detection"
		},
		FIDDataCollectionFrequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hertz],
			Units -> Hertz,
			Description -> "The number of data points per second that was collected by the instrument. This is relevenat for Gas Chromatography.",
			Category -> "Detection"
		},
		AbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The 1st of upto 4 monochromator or filter wavelength used to filter lamp light before passing through the flow cell.",
			Category -> "Detection"
		},
		SecondaryAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The 2nd of upto 4 monochromator or filter wavelength used to filter lamp light before passing through the flow cell.",
			Category -> "Detection"
		},
		TertiaryAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The 3rd of upto 4 monochromotor or filter wavelength used to filter lamp light before passing through the flow cell.",
			Category -> "Detection"
		},
		QuaternaryAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The 4th or upto 4 monochromotor or filter wavelength used to filter lamp light before passing through the flow cell.",
			Category -> "Detection"
		},
		MinAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength of light detected by the Photo Diode Array (PDA) detector during the experiment.",
			Category -> "Detection"
		},
		MaxAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength of light detected by the Photo Diode Array (PDA) detector during the experiment.",
			Category -> "Detection"
		},
		AbsorbanceWavelengthResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The increment in wavelengths spanning from MinWavelength to MaxWavelength for the Photo Diode Array (PDA) detector measurement.",
			Category -> "Detection"
		},
		UVFilter -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if UV light (less than 210 nm) was transmitted through the sample for the Photo Diode Array (PDA) detector.",
			Category -> "Detection"
		},
		AbsorbanceSamplingRate -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "The frequency of measurement for a UVVis or Photo Diode Array (PDA) detectors.",
			Category -> "Detection"
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "The 1st of upto 4 monochromator/filter wavelength used to filter the lamp light
			before it is passed into the fluorescence flow cell to excite the fluorescent compounds in the sample.",
			Category -> "Detection"
		},
		SecondaryExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "The 2nd of upto 4 monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite the fluorescent compounds in the sample.",
			Category -> "Detection"
		},
		TertiaryExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "The 3rd of upto 4 monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite the fluorescent compounds in the sample.",
			Category -> "Detection"
		},
		QuaternaryExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "The 4th of upto 4 monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite the fluorescent compounds in the sample.",
			Category -> "Detection"
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "The 1st of upto 4 monochromator/filter wavelength used to filter emitted light from the sample before it is measured in the Fluorescence detector.",
			Category -> "Detection"
		},
		SecondaryEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "The 2nd of upto 4 monochromator/filter wavelength used to filter emitted light from the sample before it is measured in the Fluorescence detector.",
			Category -> "Detection"
		},
		TertiaryEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "The 3rd of upto 4 monochromator/filter wavelength used to filter emitted light from the sample before it is measured in the Fluorescence detector.",
			Category -> "Detection"
		},
		QuaternaryEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "The 4th of upto 4 monochromator/filter wavelength used to filter emitted light from the sample before it is measured in the Fluorescence detector.",
			Category -> "Detection"
		},
		EmissionCutOffFilter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Nanometer],
			Units -> Nanometer,
			Description ->"The cut-off wavelength to pre-select the emitted light from the sample and allow only the light with wavelength above the desired value to pass before the light enters emission monochromator for final wavelength selection.",
			Category -> "Detection"
		},
		FluorescenceGain -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The percentage of maximum amplification of PrimaryExcitationWavelength/PrimaryEmissionWavelength channel on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			Category -> "Detection"
		},
		SecondaryFluorescenceGain -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The percentage of maximum amplification of SecondaryExcitationWavelength/SecondaryEmissionWavelength channel on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			Category -> "Detection"
		},
		TertiaryFluorescenceGain -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The percentage of maximum amplification of TertiaryExcitationWavelength/TertiaryEmissionWavelength channel on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			Category -> "Detection"
		},
		QuaternaryFluorescenceGain -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The percentage of maximum amplification of QuarternaryExcitationWavelength/QuaternaryEmissionWavelength channel on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			Category -> "Detection"
		},
		FluorescenceFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The nominal temperature setting inside the flow cell of the fluorescence detector during the fluorescence measurement of the sample.",
			Category -> "Detection"
		},
		LightScatteringLaserPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "The laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector for the measurement of the sample.",
			Category -> "Detection"
		},
		LightScatteringFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The nominal temperature setting inside the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) flow cell of the detector during the MALS and/or DLS measurement of the sample.",
			Category -> "Detection"
		},
		MALSDetectorAngles -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0AngularDegree],
			Units -> AngularDegree,
			Description -> "The angles with regard to the incident light beam at which the MALS detection photodiodes are mounted around the flow cell inside the Multi-Angle static Light Scattering (MALS) detector.",
			Category -> "Detection"
		},
		RefractiveIndexMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[RefractiveIndex,DifferentialRefractiveIndex],
			Description -> "The type of refractive index measurement of the Refractive Index (RI) Detector for the measurement of the sample. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
			Category -> "Detection"
		},
		RefractiveIndexFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The nominal temperature setting inside the refractive index flow cell of the refractive index (RI) detector during the refractive index measurement of the sample.",
			Category -> "Detection"
		},
		DifferentialRefractiveIndexReference -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[Data, Chromatography]],
			Relation -> Object[Data, Chromatography],
			Description -> "The chromatography data of the sample which is used as the reference for differential refractive index measurement.",
			Category -> "Detection"
		},
		DifferentialRefractiveIndexReferenceComposition -> {
			Format -> Multiple,
			Class -> {String,Link,Real},
			Pattern :> {_String,_Link,GreaterEqualP[0Percent]},
			Relation -> {None,Model[Sample]|Object[Sample],None},
			Units -> {None,None,Percent},
			Description -> "The composition of buffer used as reference sample for differential refractive index measurement.",
			Headers -> {"Buffer Name","Buffer","Percent"},
			Category -> "Detection"
		},
		NebulizerGas -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if sheath gas was turned on for the ELSD detector.",
			Category -> "Detection"
		},
		NebulizerGasPressure -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description -> "The applied gas pressure to the sheath gas.",
			Category -> "Detection"
		},
		NebulizerGasHeating -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if sheath gas should be heated or not for the ELSD detector.",
			Category -> "Detection"
		},
		NebulizerHeatingPower -> {
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "The relative magnitude of the heating element setting used to heat the sheath gas where 100% is the maximum heating power.",
			Category -> "Detection"
		},
		DriftTubeTemperature -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "The set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
			Category -> "Detection"
		},
		ELSDGain -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Percent],
			Units -> Percent,
			Description -> "The percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
			Category -> "Detection"
		},
		ELSDSamplingRate -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "The frequency of evaporative light scattering measurement. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurment.",
			Category -> "Detection"
		},
		SuppressorMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SuppressorModeP,
			Description -> "The operation method of the cation suppressor. Under DynamicMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied. This field applies only to IonChromatography.",
			Category -> "Detection"
		},
		SuppressorVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "The electrical potential difference applied to the cation Suppressor. This field applies only to IonChromatography.",
			Category -> "Detection"
		},
		SuppressorCurrent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli Ampere],
			Units -> Milli Ampere,
			Description -> "The rate of electric charge flow between the electrodes in the suppresor. This field applies only to IonChromatography.",
			Category -> "Detection"
		},
		DetectionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "In IonChromatography, the temperature of the cell where conductivity measurement or eletrochemical detection is performed. This field applies only to IonChromatography.",
			Category -> "Detection"
		},
		ElectrochemicalDetectionMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ElectrochemicalDetectionModeP,
			Description -> "The mode of operation for the electrochemical detector, including DC Amperometric Detection, Pulsed Amperometric Detection, and Integrated Pulsed Amperometric Detection. In DC Amperometric Detection, a constant voltage is applied. In contrast, Pulsed Amperometric Detections first apply a working potential followed by higher or lower potentials that are used for cleaning the electrode. Further, Integrated Amperometric Detection integrates current over a single potential whereas Integrated Pulsed Amperometric Detection integrates current over two or more potentials.",
			Category -> "Detection"
		},
		ReferenceElectrode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, ReferenceElectrode],
			Description -> "The electrode used as a reference with constant potential difference throughout the measurement. This field applies only to IonChromatography.",
			Category -> "Detection"
		},
		ReferenceElectrodeMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReferenceElectrodeModeP,
			Description -> "A combination pH-Ag/AgCl reference electrode that can be used to either monitor the buffer pH (\"pH\" reference) or to serve as a cell reference electrode with a constant potential (\"AgCl\" reference). This field applies only to IonChromatography.",
			Category -> "Detection"
		},
		WorkingElectrode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Electrode],
			Description -> "The electrode where the analytes undergo reduction or oxidation recations due to the potential difference applied. This field applies only to IonChromatography.",
			Category -> "Detection"
		},
		ElectrochemicalVoltage ->{
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "A constant voltage setting of the electrochemical detector over the duration of the analysis. This field applies only to IonChromatography.",
			Category -> "Detection"
		},
		ElectrochemicalVoltageProfile ->{
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {TimeP,VoltageP},
			Units -> {Minute, Volt},
			Description -> "A time dependent voltage setting of the electrochemical detector over the duration of the analysis. This field applies only to IonChromatography.",
			Headers -> {"Time","Voltage"},
			Category -> "Detection"
		},
		ElectrochemicalWaveform -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Waveform],
			Description -> "A series of time-dependent voltage setting (waveform) that are be repeated over the duration of the analysis. This field applies only to IonChromatography.",
			Category -> "Detection"
		},
		ElectrochemicalWaveformProfile -> {
			Format -> Multiple,
			Class -> {Real,Link},
			Pattern :> {GreaterEqualP[0 Minute], _Link},
			Relation -> {Null, Object[Method,Waveform]},
			Units -> {Minute, None},
			Description -> "The programmed waveform being run on the detector over time. The specified waveform will start running at the given time with no interpolation in between time points. This field applies only to IonChromatography.",
			Headers -> {"Time","Waveform"},
			Category -> "Detection"
		},
		ElectrochemicalSamplingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "The frequency of measurement for the electrochemical detector.",
			Category -> "Detection"
		},


		Fractions -> {
			Format -> Multiple,
			Class->{
				Sample->Link,
				Container->Link,
				Position->String,
				CollectionStartTime->Real,
				CollectionEndTime->Real,
				CollectionVolume->Real
			},
			Pattern:>{
				Sample->ObjectP[{Object[Sample]}],
				Container->ObjectP[{Object[Container]}],
				Position->SLLWellPositionP,
				CollectionStartTime->GreaterEqualP[-1000*Hour],
				CollectionEndTime->GreaterEqualP[0*Minute],
				CollectionVolume->GreaterEqualP[0*Liter]
			},
			Relation -> {
				Sample->Object[Sample],
				Container->Object[Container],
				Position->Null,
				CollectionStartTime->Null,
				CollectionEndTime->Null,
				CollectionVolume->Null
			},
			Units -> {
				Sample->None,
				Container->None,
				Position->Null,
				CollectionStartTime->Minute,
				CollectionEndTime->Minute,
				CollectionVolume->Milliliter
			},
			Description -> "The summary information of effluent collected by the Instrument in the form {Sample, Container, Position, Collection Start Time, Collection End Time, Collection Volume}.",
			Category -> "Experimental Results"
		},
		InjectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Second,
			Description -> "The time at which the sample was introduced to the flow path, relative to the beginning of the run. Chromatograms are transposed to define injection time as 0.",
			Category -> "Experimental Results"
		},
		Absorbance -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, Milli*AbsorbanceUnit}],
			Units -> {Minute, AbsorbanceUnit Milli},
			Description -> "The chromatogram of absorbance at AbsorbanceWavelength vs. time during the experiment for the UV visible (UVVis) detector.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		SecondaryAbsorbance -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityMatrixP[{Minute,Milli*AbsorbanceUnit}],
			Units -> {Minute, AbsorbanceUnit Milli},
			Description -> "The chromatogram of absorbance at SecondaryAbsorbanceWavelength vs. time during the experiment.",
			Category -> "Experimental Results"
		},
		TertiaryAbsorbance -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityMatrixP[{Minute, MilliAbsorbanceUnit}],
			Units -> {Minute, MilliAbsorbanceUnit},
			Description -> "The chromatogram of absorbance at TertiaryAbsorbanceWavelength vs. time during the experiment.",
			Category -> "Experimental Results"
		},
		QuaternaryAbsorbance ->{
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityMatrixP[{Minute, MilliAbsorbanceUnit}],
			Units -> {Minute, MilliAbsorbanceUnit},
			Description -> "The chromatogram of absorbance at QuaternaryAbsorbanceWavelength vs. time during the experiment.",
			Category -> "Experimental Results"
		},
		Absorbance3D-> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :>  BigQuantityArrayP[{Minute, Meter Nano, AbsorbanceUnit Milli}],
			Units -> {Minute, Meter Nano, AbsorbanceUnit Milli},
			Description -> "The chromatogram of Absorbance at each Wavelength for each retention time point during the experiment for the PhotoDiodeArray (PDA) detector.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		Fluorescence -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,RFU}],
			Units -> {Minute, RFU},
			Description -> "The chromatogram of the measured Fluorescence vs. time using the first excitation/emission wavelength pair during the experiment for the Fluorescence detector.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		SecondaryFluorescence -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,RFU}],
			Units -> {Minute, RFU},
			Description -> "The chromatogram of the measured Fluorescence vs. time using the second excitation/emission wavelength pair during the experiment for the Fluorescence detector.",
			Category -> "Experimental Results"
		},
		TertiaryFluorescence -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,RFU}],
			Units -> {Minute, RFU},
			Description -> "The chromatogram of the measured Fluorescence vs. time using the third excitation/emission wavelength pair during the experiment for the Fluorescence detector.",
			Category -> "Experimental Results"
		},
		QuaternaryFluorescence -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,RFU}],
			Units -> {Minute, RFU},
			Description -> "The chromatogram of the measured Fluorescence vs. time using the fourth excitation/emission wavelength pair during the experiment for the Fluorescence detector.",
			Category -> "Experimental Results"
		},
		Scattering -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,LSU}],
			Units -> {Minute, LSU},
			Description -> "The chromatogram of light scattering vs. time during the experiment for the EvaporativeLightScattering detector (ELSD) detector.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		MultiAngleLightScattering22Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 22.5 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering28Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 28.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering32Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 32.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering38Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 38.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering44Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 44.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering50Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 50.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering57Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 57.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering64Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 64.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering72Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 72.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering81Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 81.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering90Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 90.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering99Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 99.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering108Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 108.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering117Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 117.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering126Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 126.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering134Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 134.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering141Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 141.0 Degree angle.",
			Category -> "Experimental Results"
		},
		MultiAngleLightScattering147Degree -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Volt}],
			Units -> {Minute, Volt},
			Description -> "The chromatogram of multi-angle light scattering vs. time during the experiment for the 1st Multi-Angle static Light Scattering (MALS) detector at 147.0 Degree angle.",
			Category -> "Experimental Results"
		},
		DynamicLightScattering -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Hertz}],
			Units -> {Minute, Hertz},
			Description -> "The chromatogram of dynamic light scattering photon count rate vs. time during the experiment for the Dynamic Light Scattering (DLS) detector.",
			Category -> "Experimental Results"
		},
		DynamicLightScatteringCorrelationFunction -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,Hertz}],
			Units -> {Minute, Hertz},
			Description -> "The chromatogram of dynamic light scattering photon count rate at the correlation function vs. time during the experiment for the Dynamic Light Scattering (DLS) detector.",
			Category -> "Experimental Results"
		},
		RefractiveIndex -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute,RefractiveIndexUnit}],
			Units -> {Minute, RefractiveIndexUnit},
			Description -> "The chromatogram of refractive index vs. time during the experiment for the refractive index (RI) detector. If RefractiveIndexMethod is DifferentialRefractiveIndex, this number indicates the refractive index difference between the sample and the reference.",
			Category -> "Experimental Results"
		},
		Pressure -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, PSI}],
			Units -> {Minute, PSI},
			Description -> "The chromatogram of system pressure vs. time during the experiment.",
			Category -> "Experimental Results"
		},
		SamplePressure -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, PSI}],
			Units -> {Minute, PSI},
			Description -> "The chromatogram of sample pressure vs. time during the experiment. This field is applicable only to FPLC.",
			Category -> "Experimental Results"
		},
		PreColumnPressure -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, PSI}],
			Units -> {Minute, PSI},
			Description -> "The chromatogram of pressure measured before the column vs. time during the experiment. This field is applicable only to FPLC.",
			Category -> "Experimental Results"
		},
		PostColumnPressure -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, PSI}],
			Units -> {Minute, PSI},
			Description -> "The chromatogram of pressure measured after the column vs. time during the experiment. This field is applicable only to FPLC.",
			Category -> "Experimental Results"
		},
		DeltaColumnPressure -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, PSI}],
			Units -> {Minute, PSI},
			Description -> "The chromatogram of the pressure difference across the column vs. time during the experiment. This field is applicable only to FPLC.",
			Category -> "Experimental Results"
		},
		Temperature -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, Celsius}],
			Units -> {Minute, Celsius},
			Description -> "The chromatogram of the set temperature of the chamber in which columns are placed vs. time during the experiment.",
			Category -> "Experimental Results"
		},
		Conductance -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityMatrixP[{Minute,Milli*Siemens / Centimeter}],
			Units -> {Minute, (Milli Siemens)/(Centi Meter)},
			Description -> "The chromatogram of conductance vs. time during the experiment for the conductivity detector.",
			Category -> "Experimental Results"
		},
		ConductivityFlowCellTemperature -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityMatrixP[{Minute, Celsius}],
			Units -> {Minute, Celsius},
			Description -> "The chromatogram of temperature vs. time of the chamber in which the conductivity flow cell is during the experiment. This data is used to calculate temperature compensation for Conductance data.",
			Category -> "Experimental Results"
		},
		pH -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute, None}],
			Units -> {Minute, None},
			Description -> "The chromatogram of pH vs. time during the experiment for the pH detector.",
			Category -> "Experimental Results"
		},
		pHFlowCellTemperature -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityMatrixP[{Minute, Celsius}],
			Units -> {Minute, Celsius},
			Description -> "The chromatogram of temperature vs. time of the chamber in which the pH flow cell is during the experiment. This data is used to calculate temperature compensation for pH data.",
			Category -> "Experimental Results"
		},
		FIDResponse -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, Pico*Ampere}],
			Units -> {Minute, Pico*Ampere},
			Description -> "The chromatogram of Flame Ionization Detector (FID) response vs. time during the experiment for the Flame Ionization Detector in Gas Chromatography.",
			Category -> "Experimental Results"
		},
		Charge -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute, Nano*Coulomb}],
			Units -> {Minute, Nano*Coulomb},
			Description -> "The chromatogram of electric charge vs. time during the experiment for the electrochemical detector.",
			Category -> "Experimental Results"
		},
		AirDetectedAlarms -> {
			Format -> Multiple,
			Class -> {Real, Expression, Real},
			Pattern :> {UnitsP[Minute], A|B|Sample, GreaterEqualP[0 * Minute]},
			Units -> {Minute, None, Minute},
			Headers -> {"Air Detected Time", "Valve", "Time until Resumed"},
			Description -> "The times at which the chromatography instrument raised an air detected alarm, relative to the injection (or if no injection the start of the run), the valve that had air in it, and the amount of time it took for the run to be resumed after the air was removed.  Note that valve A controls buffers A, C, E, and G, valve B controls buffers B, D, F, and H, and Sample controls the flow injection samples.",
			Category -> "Experimental Results"
		},
		StandardData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Chromatography][Analytes],
			Description -> "The data from the most recent reference sample run prior to injection of the current sample.",
			Category -> "Experimental Results"
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Chromatography][StandardData],
			Description -> "The list of all chromatograms associated with this standard.",
			Category -> "Experimental Results"
		},
		RawDataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing all raw data of this sample collected by the instrument zipped into one directory.",
			Category -> "Experimental Results"
		},
		SecondaryDataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw unprocessed data generated by the secondary HPLC detector.",
			Category -> "Experimental Results"
		},
		EventLogFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw chromatography metadata containing the audit tral which includes the parameters set and the step by step record of the commands performed by the instrument during the injection.",
			Category -> "Data Processing"
		},
		PressureFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw chromatography time dependent pump head pressure data.",
			Category -> "Data Processing"
		},
		TemperatureFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw chromatography time dependent temperature data of the chamber in which the column is placed.",
			Category -> "Data Processing"
		},
		ChargeFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw chromatography amperometry data for IonChromatography.",
			Category -> "Data Processing"
		},
		FractionsPicked -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[FractionPickingAnalysis]}, Computables`Private`fractionsPicked[Field[FractionPickingAnalysis]]],
			Pattern :> {{GreaterEqualP[0], GreaterP[0], FractionStorageP}..},
			Description -> "The list of fractions picked by the user during the fraction analysis in the form of {fraction collection start time, fraction collection end time, fraction plate or fraction well index}..",
			Headers ->{"Collection Start Time", "Collection End Time", "Fraction Plate/Well Index"},
			Category -> "Analysis & Reports"
		},
		AirBubbleLikelihood -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "The probability of air bubble existing in the pressure trace of the chromatograph assigned to this data by a liquid chromatography air bubble anomaly detector machine learning model (unpublished result).",
			Category -> "Analysis & Reports"
		},
		FractionPickingAnalysis -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Selects fractions from the given chromatograph to be carried forward for further analysis.",
			Category -> "Analysis & Reports"
		},
		ChromatogramCompositionAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis, Composition][StandardData],
				Object[Analysis, Composition][AssayData]
			],
			Description -> "Performs chemical composition analsyis of the chromatogram peaks by comparing the known concentration of analytes in the standard with the unknown sample.",
			Category -> "Analysis & Reports"
		},
		AbsorbancePeaksAnalyses  -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks found in the 1st of upto 4 wavelength absorbance data collected for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		SecondaryAbsorbancePeaksAnalyses  -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks found in the 2nd of upto 4 wavelength absorbance data collected for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		Absorbance3DPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks found in the 3rd of upto 4 wavelength absorbance data collected for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		FluorescencePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks found in the fluorescence data collected for the 1st of upto 4 excitation wavelength specified for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		SecondaryFluorescencePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks found in the fluorescence data collected for the 2nd of upto 4 excitation wavelength specified for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		TertiaryFluorescencePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks found in the fluorescence data collected for the 3rd of upto 4 excitation wavelength specified for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		QuaternaryFluorescencePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks found in the fluorescence data collected for the 4th of upto 4 excitation wavelength specified for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		ScatteringPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Find and stores peaks in the data collected using Evaporative Light Scattering Detector (ELSD) for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		ConductancePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Find and stores peaks in the data collected using the conductance detector for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		pHPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Find and stores peaks in the data collected using the pH detector for the sample.",
			Category -> "Analysis & Reports"
		},
		FIDResponsePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks in the data collected on the Flame Ionization Detector for the sample in the order of least to most recent. This is relevant for GasChromatography.",
			Category -> "Analysis & Reports"
		},
		ChargePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks found in the electrochemical data collected for the sample in the order of least to most recent. This is relevent for IonChromatography.",
			Category -> "Analysis & Reports"
		},
		RefractiveIndexPeaksAnalysis -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Finds and stores peaks in the RefractiveIndex data collected for the sample in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		MultiAngleLightScatteringAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The analyses performed on the Multi-Angle static Light Scattering (MALS) data to determine the molecular weight and radius of gyration distributions of the sample stored in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		DynamicLightScatteringAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The analyses performed on the Dynamic Light Scattering (DLS) data to determine the hydrodynamic radius of the sample stored in the order of least to most recent.",
			Category -> "Analysis & Reports"
		},
		StandardAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The ladder analyses done on this data.",
			Category -> "Analysis & Reports"
		},
		SmoothingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Smoothing analysis performed on this data.",
			Category -> "Analysis & Reports"
		},
		StandardPeaks -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[StandardAnalyses]}, Computables`Private`standardPeaks[Field[StandardAnalyses]]],
			Pattern :> {(GreaterP[0] -> GreaterEqualP[0])..},
			Description -> "A list of rules linking each fragment length to its temporal appearance, in the form (fragment length -> time of appearance).",
			Category -> "Analysis & Reports"
		}
	}
}];
