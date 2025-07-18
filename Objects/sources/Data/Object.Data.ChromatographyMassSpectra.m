(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, ChromatographyMassSpectra], {
	Description->"Analytical and mass spectrometry data captured during a chromatographic separation technique.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (ChromatographyMassSpectraP|Sample),
			Description -> "Indicates if this data represents a blank, calibrant, standard, sample, column flush, or column prime measurement.",
			Category -> "General",
			Abstract -> True
		},
		InjectionIndex -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The numeric position indicating when this data was measured for the experiment with respect to the other column primes, sample injections, standard injections, blank injections, and column flushes (e.g. 1 is the first measurement run).",
			Category -> "General"
		},
		DateInjected -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date and time the input sample was injected into the Instrument and measured.",
			Category -> "General",
			Abstract -> True
		},
		SamplingMethod->{
			Format->Single,
			Class->Expression,
			Pattern:> GCSamplingMethodP,
			Description -> "The method used to inject the sample in a gas chromatography experiment.",
			Category -> "General"
		},
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume taken from the input sample and injected into the Instrument.",
			Category -> "General"
		},
		SampleTemperature -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "The nominal temperature of autosampler chamber where samples are housed before injection.",
			Category -> "General"
		},
		FluidType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FluidCategoryP,
			Description -> "The physical state of the mobile phase for the measurement.",
			Category -> "General",
			Abstract -> True
		},
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of chromatographic separation that categorizes the mobile (e.g. CosolventA/BufferA) and stationary phase used (e.g. Columns), ideally for optimal sample separation and resolution.",
			Category -> "General"
		},
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Analytical | Preparative,
			Description -> "Indicates if the SFC is intended to separate material (Preparative) and therefore collect fractions and/or analyze properties of the material (Analytical).",
			Category -> "General"
		},
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "Indicates the types of measurements performed for the experiment and available on the Instrument.",
			Category -> "General",
			Abstract -> True
		},
		AcquisitionMode -> { (*This will be removed and replaced with fragmentation*)
			Format -> Single,
			Class -> Expression,
			Pattern :> AcquisitionModeP,
			Description -> "For experiments with MassSpectrometry available, the type of acquisition being performed in this protocol. MS mode measures the masses of the intact analytes, whereas MSMS measures the masses of the analytes fragmented by collision-induced dissociation.",
			Category -> "General"
		},
		MassAnalyzer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassAnalyzerTypeP,
			Description -> "For experiments with MassSpectrometry available, the type of the component of the mass spectrometer that performs ion separation based on m/z (mass-to-charge ratio). SingleQuadrupole selects ions individually for measurement.",
			Category -> "General"
		},
		IonSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (IonSourceP|GCIonSourceP),
			Description -> "For experiments with MassSpectrometry available, the type of ionization used to create gas-phase ions from the molecules in the sample. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas-phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission.",
			Category -> "General"
		},
		Columns -> { (*will be replaced by the fields below*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][Data],
			Description -> "The stationary phase device(s) through which the Buffers or CO2/Cosolvents flow and analyte samples are injected into. It adsorbs and separates the molecules within the sample based on the properties of the Cosolvent, samples, column material, and ColumnTemperature.",
			Category -> "General" (* through which the mobile phase and analyte samples? *)
		},
		Column -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][Data],
			Description -> "The (first) stationary phase device through which the Buffers or CO2/Cosolvents flow and analyte samples are injected into. It adsorbs and separates the molecules within the sample based on the properties of the Cosolvent/Buffer, samples, column material, and ColumnTemperature.",
			Category -> "General"
		},
		SecondaryColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][Data],
			Description -> "The (first) stationary phase device through which the Buffers or CO2/Cosolvents flow and analyte samples are injected into. It adsorbs and separates the molecules within the sample based on the properties of the Cosolvent/Buffer, samples, column material, and ColumnTemperature.",
			Category -> "General"
		},
		TertiaryColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][Data],
			Description -> "The (first) stationary phase device through which the Buffers or CO2/Cosolvents flow and analyte samples are injected into. It adsorbs and separates the molecules within the sample based on the properties of the Cosolvent/Buffer, samples, column material, and ColumnTemperature.",
			Category -> "General"
		},
		ColumnTemperature -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "The specified temperature of the Columns during the measurement.",
			Category -> "General"
		},
		ColumnOrientation -> {
			Format->Single,
			Class->Expression,
			Pattern :>ColumnOrientationP,
			Description->"The direction of the Columns with respect to the flow.",
			Category -> "General"
		},
		GuardColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][Data],
			Description -> "The protective stationary phase device often used to adsorb and sequester fouling contaminants from the Columns.",
			Category -> "General"
		},
		GuardCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][Data],
			Description -> "The consumable replaced within the GuardColumn.",
			Category -> "General"
		},
		GuardColumnOrientation -> {
			Format->Single,
			Class->Expression,
			Pattern :>ColumnOrientationP,
			Description->"The direction of the GuardColumn for the protocol. If a Columns is used and GuardColumnOrientation is ReverseColumn, then the GuardColumn is placed after the column relative to the direction of the flow path.",
			Category -> "General"
		},
		GradientMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "Instructions for the mixing and distribution of the CO2 and Cosolvent/Buffer solutions within the mobile phase over time.",
			Category -> "General"
		},
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position A, the flow of which is directed by GradientA compositions for liquid chromatography.",
			Category -> "General"
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position B, the flow of which is directed by GradientB compositions for liquid chromatography.",
			Category -> "General"
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position C, the flow of which is directed by GradientC compositions for liquid chromatography.",
			Category -> "General"
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position D, the flow of which is directed by GradientD compositions for liquid chromatography.",
			Category -> "General"
		},
		CosolventA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position A, the flow of which is directed by GradientA compositions for SupercriticalFluidChromatography measurement.",
			Category -> "General"
		},
		CosolventB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position B, the flow of which is directed by GradientB compositions for SupercriticalFluidChromatography measurement.",
			Category -> "General"
		},
		CosolventC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position C, the flow of which is directed by GradientC compositions for SupercriticalFluidChromatography measurement.",
			Category -> "General"
		},
		CosolventD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position D, the flow of which is directed by GradientD compositions for SupercriticalFluidChromatography measurement.",
			Category -> "General"
		},
		MakeupSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution pumped and supplementing the column effluent on entry to the mass spectrometer.",
			Category -> "General"
		},
		CO2Gradient -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "The percentage of supercritical CO2 in the composition over time, in the form: {Time, % CO2} or a single % CO2 for the entire run.",
			Category -> "General"
		},
		GradientA -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferA or CosolventA in the composition over time, in the form: {Time, % BufferA|Cosolvent A} or a single % Buffer A|Cosolvent A for the entire run.",
			Category -> "General"
		},
		GradientB -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferB or CosolventB in the composition over time, in the form: {Time, % BufferB|Cosolvent B} or a single % Buffer B|Cosolvent B for the entire run.",
			Category -> "General"
		},
		GradientC -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferC or CosolventC in the composition over time, in the form: {Time, % BufferC|Cosolvent C} or a single % Buffer C|Cosolvent C for the entire run.",
			Category -> "General"
		},
		GradientD -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of Buffer D or CosolventD in the composition over time, in the form: {Time, % BufferD|Cosolvent D} or a single % Buffer D|Cosolvent D for the entire run.",
			Category -> "General"
		},
		BackPressure -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],GreaterP[0 PSI]}...}|GreaterP[0 PSI]),
			Description -> "The applied pressure between the atmosphere and the PhotoDiodeArray detector exit, in the form: {Time, BackPressure} or a single BackPressure for the entire run.",
			Category -> "General"
		},
		FlowRates -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Minute], GreaterEqualP[(0*Liter)/Minute]},
			Units -> {Minute, (Liter Milli)/Minute},
			Description -> "The bulk speed of the mobile phase (Buffers or CO2/Cosolvents) at each time point where the slope changed.",
			Headers -> {"Time", "Flow Rate"},
			Category -> "General"
		},
		SeparationMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "A collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected.",
			Category -> "General",
			Abstract -> False
		},
		SPMESampleExtractionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "The amount of time the injection tool left the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber.",
			Category -> "General",
			Abstract -> False
		},
		SPMESampleDesorptionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "The amount of time the injection tool left the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber.",
			Category -> "General",
			Abstract -> False
		},

		(*--Mass Spectrometry specific options -- *)

		MassSpectrometryMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "A redundant set of operating instructions for the mass analysis device during the generation of this data. Can be used for future experiments.",
			Category -> "Ionization"
		},
		IonMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "Indicates if positively or negatively charged ions are analyzed each run.",
			Category -> "Ionization"
		},
		MakeupFlowRate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "The total rate of MakeupSolvent pumped through the Instrument for each measurement.",
			Category -> "Ionization"
		},
		ProbeTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature of the needle that introduces the column effluent into the spray chamber.",
			Category -> "Ionization"
		},
		DesolvationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray.",
			Category -> "Ionization"
		},
		ESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description -> "The applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules.",
			Category -> "Ionization"
		},
		SourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
			Category -> "Ionization"
		},
		QuadrupoleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature at which the quadrupole (the 4 parallel metal rods between which an oscillating electric field is produced that separates the ions by mass to charge ratio as they fly through the mass spectrometer) is set.",
			Category -> "Ionization"
		},
		SourceVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The applied voltage between the sample inlet on the mass spectrometry and the first stage of the ion filter.",
			Category -> "Ionization"
		},
		DeclusteringVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description -> "The applied voltage between the sample inlet on the mass spectrometry and the first stage of the ion filter.",
			Category -> "Ionization"
		},
		SamplingConeVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone (the metal shield covering the front of the source block), towards the quadrupole mass analyzer.",
			Category -> "Mass Analysis"
		},
		ConeGasFlow -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[(0*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "The rate of nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate on the source block, acting as a first gate between the sprayer and the reduced-pressure ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directs the spray into the ion block while keeping the sample cone clean.",
			Category -> "Ionization"
		},
		DesolvationGasFlow -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[(1*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "The nitrogen gas flow ejected around the ESI (electrospray ionization) capillary, used for solvent evaporation to produce single gas phase ions from the ion spray.",
			Category -> "Ionization"
		},
		StepwaveVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The applied voltage between the two stages of the ion filter.",
			Category -> "Ionization"
		},
		AcquisitionWindows -> {
			Format -> Multiple,
			Class -> {
				StartTime->Real,
				EndTime->Real
			},
			Pattern :> {
				StartTime->GreaterEqualP[0*Second],
				EndTime->GreaterEqualP[0*Second]
			},
			Units -> {
				StartTime->Minute,
				EndTime->Minute
			},
			Description -> "The time blocks to acquire measurement.",
			Category -> "Mass Analysis",
			Abstract -> True
		},
		AcquisitionModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MSAcquisitionModeP|MS1|MS1MS2,
			Description -> "For each member of AcquisitionWindows, the manner of scanning and/or fragmenting intact and resultant ions.",
			Category -> "Mass Analysis",
			IndexMatching -> AcquisitionWindows,
			Abstract -> True
		},
		Fragmentations -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of AcquisitionWindows, indicates whether the intact ions collide with inert gas to dissociate into product ions. Also known as Tandem mass spectrometry or MS/MS.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		MinMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The lowest measured mass-to-charge ratio (m/z) value.",
			Category -> "Mass Analysis"
		},
		MaxMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The highest measured mass-to-charge ratio (m/z) value.",
			Category -> "Mass Analysis"
		},
		MinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of AcquisitionWindows, the lowest measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		MaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of AcquisitionWindows, the highest measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		MassRanges -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0],GreaterP[0]},
			Units -> {None,None},
			Relation -> {Null,Null},
			Description -> "For each member of AcquisitionWindows, the lower and upper bounds of the mass-to-charge ratios (m/z) that were scanned across during measurement.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis",
			Headers -> {"First m/z","Last m/z"},
			Abstract -> False
		},
		MassSelection -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The all of the ions tabulated by mass-to-charge ratio (m/z) measured via mass spectrometry.",
			Category -> "Mass Analysis"
		},
		MassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of AcquisitionWindows, all of the measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		MassSelectionDwellTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*Second]..},
			Description -> "For each member of AcquisitionWindows, the amount of time that was spent counting ions at all of the measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		MassRangeScanSpeeds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of AcquisitionWindows, the speed (in m/z per second) at which the mass spectrometer will collect data.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis",
			Abstract -> False
		},
		MassRangeThresholds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of AcquisitionWindows, the minimum mass abundance above which the mass spectrometer will collect data.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis",
			Abstract -> False
		},
		MassSelectionResolutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Low,High],
			Relation -> Null,
			Description -> "For each member of AcquisitionWindows, the m/z range window that may be transmitted through the quadrupole at the selected mass.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis",
			Abstract -> False
		},
		MassSelectionDetectionGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Relation -> Null,
			Description -> "For each member of AcquisitionWindows, the gain factor that was used during the collection of the corresponding list of selectively monitored m/z in MassSelection.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis",
			Abstract -> False
		},
		ScanTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The duration of time allowed to pass between each spectral acquisition.",
			Category -> "Mass Analysis"
		},
		ScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of AcquisitionWindows, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		ScanSpeeds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of AcquisitionWindows, the rate at which the mass ranges indicated were scanned across.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		FragmentMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of AcquisitionWindows, the lowest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		FragmentMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of AcquisitionWindows, the highest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		FragmentMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of AcquisitionWindows, all of the measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		CollisionEnergies-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[{UnitsP[0*Volt]..},UnitsP[0*Volt]],
			Description -> "For each member of AcquisitionWindows, all of the measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		LowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "For each member of AcquisitionWindows, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		HighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "For each member of AcquisitionWindows, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		FinalLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of AcquisitionWindows, at the end of the spectral scan, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		FinalHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of AcquisitionWindows, at the end of the spectral scan, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		FragmentScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of AcquisitionWindows, the duration of time allowed to pass between each spectral acquisition for the product ions when AcquistionMode -> DataDependent.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		AcquisitionSurveys -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of AcquisitionWindows, indicates the number of intact ions to consider for fragmentation and acquisition in DataDependent acquistion mode.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		MinimumThresholds -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of AcquisitionWindows, the least number of total intact ions needed to be measured to elicit an acquisition program.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		AcquisitionLimits -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of AcquisitionWindows, the maximum number measured ions allowed during a fragmentation measurement of a survey ion. Will proceed to the next intact ion/fragmentation once reached.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		CycleTimeLimits -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of AcquisitionWindows, the maximum duration allowable for a survey. Will proceed to the next cycle once reached.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		ExclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				{UnitsP[Minute],UnitsP[Minute]}..
			},
			Description -> "For each member of AcquisitionWindows, the time blocks within to consider for specific mass exclusion.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		ExclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{ExclusionModeP,GreaterP[(0*Gram)/Mole]}..},
			Description -> "For each member of AcquisitionWindows, indicates the manner of omitting intact ions for acquisition survey.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		ExclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of AcquisitionWindows, the range above and below each ion in ExclusionMassSelection to consider for omission.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		ExclusionRetentionTimeTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of AcquisitionWindows, the range above and below each retention time in ExclusionMassSelection to consider for omission.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		InclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				{UnitsP[Minute],UnitsP[Minute]}..
			},
			Description -> "For each member of AcquisitionWindows, the time blocks within to consider for specific mass inclusion.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		InclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				{
					InclusionModeP,
					GreaterP[(0*Gram)/Mole]
				}..
			},
			Description -> "For each member of AcquisitionWindows, the intact ions to prioritize during survey acquisition.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		InclusionCollisionEnergies-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0*Volt]..
			},
			Description -> "For each member of AcquisitionWindows, the overriding collision energy to use for the corresponding InclusionMass.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		InclusionDeclusteringVoltages-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0*Volt]..
			},
			Description -> "For each member of AcquisitionWindows, the overriding source voltage to use for the corresponding InclusionMass.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		InclusionChargeStates-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0,1]..
			},
			Description -> "For each member of AcquisitionWindows, the charge state isotopes to also consider for inclusion.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		InclusionScanTimes-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0*Second]..
			},
			Description -> "For each member of AcquisitionWindows, the overriding scan time to use for the corresponding InclusionMass.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		InclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of AcquisitionWindows, the range above and below each ion in InclusionMassSelection to consider for omission.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		ChargeStateLimits -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of AcquisitionWindows, the number of ions to survey before excluding for ion state properties.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		ChargeStateSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[1,1]..},
			Description -> "For each member of AcquisitionWindows, the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		ChargeStateMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of AcquisitionWindows, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		IsotopeMassDifferences -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0 Dalton]..},
			Description -> "For each member of AcquisitionWindows, the delta between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		IsotopeRatios -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]..},
			Description -> "For each member of AcquisitionWindows, the minimum relative magnitude between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		IsotopeDetectionMinimums -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*1/Second]..},
			Description -> "For each member of AcquisitionWindows, the acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		IsotopeRatioTolerances-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "For each member of AcquisitionWindows, the range of relative magnitude around IsotopeRatio and SecondaryIsotopeRatio to consider for isotope exclusion.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		IsotopeMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of AcquisitionWindows, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		MassDetectionGain -> {
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0.01,1000.00,0.01],
			Description -> "Indicates the arbitrary-scaled signal amplification of the mass spectrometry measurement.",
			Category -> "Mass Analysis"
		},
		MassDetectionGains -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0.01,1000.00,0.01],
			Description -> "For each member of AcquisitionWindows, indicates the arbitrary-scaled signal amplification of the mass spectrometry measurement.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		TransferLineTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Relation -> Null,
			Description -> "The temperature at which the segment of a gas chromatography column that extends out of the column oven and into the mass spectrometer is held during separation in a gas chromatograhph.",
			Category -> "General",
			Abstract -> False
		},
		SolventDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Relation -> Null,
			Description -> "The amount of time into the separation after which the mass spectrometer will begin collecting mass spectra.",
			Category -> "General",
			Abstract -> False
		},
		TraceIonDetection -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Relation -> Null,
			Description -> "Indicates whether a proprietary set of algorithms to reduce noise in ion abundance measurements during spectral collection, resulting in lower detection limits for trace compounds, will be used.",
			Category -> "General",
			Abstract -> False
		},
		TuneFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw tune data and tune report for a GC/MS experiment.",
			Category -> "General"
		},

		(*-- PhotoDiodeArray Parameters --*)
		AbsorbanceSelection -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "All the measured wavelengths of light absorbed in the detector's flow cell for a PhotoDiodeArray (PDA) detector.",
			Category -> "Absorbance Measurement"
		},
		MinAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength of light detected by the PhotoDiodeArray (PDA) detector during the experiment.",
			Category -> "Absorbance Measurement"
		},
		MaxAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength of light detected by the PDA detector during the experiment.",
			Category -> "Absorbance Measurement"
		},
		AbsorbanceWavelengthResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The increment in wavelengths spanning from MinWavelength to MaxWavelength for PDA detector measurement.",
			Category -> "Absorbance Measurement"
		},
		UVFilter -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates whether or not UV light (less than 210 nm) were transmitted through the sample for PDA detector.",
			Category -> "Absorbance Measurement"
		},
		AbsorbanceSamplingRate -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "Indicates the frequency of measurement for the PDA detectors.",
			Category -> "Absorbance Measurement"
		},

		CalibrantSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample]
			],
			Description -> "The sample with known and formulated analytes used to calibrate the instrument prior to collect this data.",
			Category -> "Data Processing"
		},
		Calibrant -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, ChromatographyMassSpectra][Analytes]
			],
			Description -> "Mass spectrum of the calibrant used to calibrate the instrument prior to collect this data.",
			Category -> "Data Processing"
		},
		CalibrationStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The measured variance between multiple readings of the Calibrant sample.",
			Category -> "Data Processing"
		},
		IonAbundanceMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram/Mole],
			Units -> Gram/Mole,
			Description -> "The selected mass-to-charge ratio used to inform the chromatogram within IonAbundance field. If MassSelection is specified as individual entries, then the first is taken. If MassSelection is a range, then the most abundant m/z from MassSpectrum is chosen.",
			Category -> "Data Processing"
		},
		AbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The primary wavelength of light absorbed in the Instrument's PhotoDiodeArray (PDA) detector used to select the chromatogram for Absorbance. If AbsorbanceSelection is specified as individual entries, then the first is taken. If AbsorbanceSelection is a range, then the most absorbing wavelength is chosen.",
			Category -> "Data Processing"
		},
		MassSpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Gram/Mole,ArbitraryUnit}],
			Units -> {Gram/Mole, ArbitraryUnit},
			Description -> "Spectrum of observed mass-to-charge (m/z) ratio vs peak intensity for this analyte, calibrant, or matrix sample detected by the Instrument. This is the summed signal from all IonAbundance3D acquired by the Instrument over the time course of measurement.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		UnintegratedMassSpectra -> {
			Format -> Multiple,
			Class -> {Real, BigQuantityArray},
			Pattern :> {GreaterEqualP[0*Second], BigQuantityArrayP[{Gram/Mole, ArbitraryUnit}]},
			Units -> {Minute, {Gram/Mole, ArbitraryUnit}},
			Description -> "Mass spectra of observed mass-to-charge ratio (m/z) vs. intensity during the course of the direct injection experiment.",
			Headers -> {"Time", "Mass Spectrum"},
			Category -> "Experimental Results"
		},
		ReactionMonitoringIntensity -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern:>BigQuantityArrayP[{Gram/Mole, Gram/Mole, ArbitraryUnit}],
			Units -> {Gram/Mole, Gram/Mole, ArbitraryUnit},
			Description -> "The total intensity of each ion selection (MS1 only) or reactions (MS1/MS2) monitored over time.",
			Category -> "Experimental Results"
		},
		ReactionMonitoringMassChromatogram->{
			Format ->Multiple,
			Class ->{Real,Real,BigQuantityArray},
			Pattern :>{GreaterEqualP[0*Gram/Mole],GreaterEqualP[0*Gram/Mole],BigQuantityArrayP[{Minute, ArbitraryUnit}]},
			Units -> {Gram/Mole, Gram/Mole, {Minute,ArbitraryUnit}},
			Description -> "The measured counts of intensity changes of different MultipleReactionMonitoring Assays (MS1/MS2 mass pairs) and Mass Selection Values (MS1 value only) during the course of the experiment for the MassSpectrometry detector. Each entry is {MS1 m/z, MS2 m/z, {Time,Intensity}}.",
			Headers -> {"Mass Selection","Fragment Mass Selection", "Mass Chromatogram"},
			Category -> "Experimental Results"
		},
		IonMonitoringIntensity -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern:>BigQuantityArrayP[{Gram/Mole,ArbitraryUnit}],
			Units -> {Gram/Mole, ArbitraryUnit},
			Description -> "The total intensity of each ion selection (MS1 value) in SelectedIonMonitoring mode, monitored over time.",
			Category -> "Experimental Results"
		},
		IonMonitoringMassChromatogram->{
			Format ->Multiple,
			Class ->{Real,BigQuantityArray},
			Pattern :>{GreaterEqualP[0*Gram/Mole],BigQuantityArrayP[{Minute, ArbitraryUnit}]},
			Units -> {Gram/Mole, {Minute,ArbitraryUnit}},
			Description -> "The measured counts of intensity changes of different Mass Selection Values (MS1 value only) during the course of the experiment for the MassSpectrometry detector. Each entry is {MS1 m/z, {Time,Intensity}}.",
			Headers -> {"Mass Selection","Mass Chromatogram"},
			Category -> "Experimental Results"
		},
		IonAbundance -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute, ArbitraryUnit}],
			Units -> {Minute, ArbitraryUnit},
			Description -> "The chromatogram of counts for a singular IonAbundanceMass m/z vs. time during the course of the experiment for the MassSpectrometry detector.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		TotalIonAbundance -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute, ArbitraryUnit}],
			Units -> {Minute, ArbitraryUnit},
			Description -> "The chromatogram of counts for the sum of all m/z measured during a single collection cycle vs. time during the course of the experiment for the MassSpectrometry detector.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		TotalFragragmentationIonAbundance -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute, ArbitraryUnit}],
			Units -> {Minute, ArbitraryUnit},
			Description -> "The chromatogram of counts for the sum of all m/z measured during a single collection cycle vs. time during the course of the experiment for the MassSpectrometry detector from the Scan 2 of DataIndependent acquisition.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		IonAbundance3D -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, Gram/Mole, ArbitraryUnit}],
			Units -> {Minute, Gram/Mole, ArbitraryUnit},
			Description -> "The measured counts of intact ions at each m/z for each retention time point during the course of the experiment for the MassSpectrometry detector. Each entry is {Time, MS1 m/z, IonAbundance}.",
			Category -> "Experimental Results"
		},
		FragmentationIonAbundance3D -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, Gram/Mole, ArbitraryUnit}],
			Units -> {Minute, Gram/Mole, ArbitraryUnit},
			Description -> "The measured counts of dissociated ion for a given spectral scan at time point during the course of the experiment for the MassSpectrometry detector. Each entry is {Time, MS2, IonAbundance}. May be split to LowCollisionEnergyIonAbundance3D and HighCollisionEnergyIonAbundance3D instead.",
			Category -> "Experimental Results"
		},
		LowCollisionEnergyIonAbundance3D-> {
			Format -> Multiple,
			Class -> {Real, Real, BigQuantityArray},
			Pattern :> {GreaterP[0*Second], Gram/Mole, BigQuantityArrayP[{Gram/Mole, ArbitraryUnit}]},
			Units -> {Minute, Gram/Mole, {Gram/Mole, ArbitraryUnit}},
			Description -> "Fragment mass spectra for when collision energy is ramping. Corresponds to the low collision energy.",
			Headers -> {"Time","Parent Mass","Mass Spectrum"},
			Category -> "Experimental Results"
		},
		HighCollisionEnergyIonAbundance3D -> {
			Format -> Multiple,
			Class -> {Real, Real, BigQuantityArray},
			Pattern :> {GreaterP[0*Second], Gram/Mole, BigQuantityArrayP[{Gram/Mole, ArbitraryUnit}]},
			Units -> {Minute, Gram/Mole, {Gram/Mole, ArbitraryUnit}},
			Description -> "Fragment mass spectra for when collision energy is ramping. Corresponds to the high collision energy.",
			Headers -> {"Time","Parent Mass","Mass Spectrum"},
			Category -> "Experimental Results"
		},
		SurveyMassSpectra -> {
			Format -> Multiple,
			Class -> {Real, BigQuantityArray},
			Pattern :> {GreaterP[0*Second], BigQuantityArrayP[{Gram/Mole, ArbitraryUnit}]},
			Units -> {Minute, {Gram/Mole, ArbitraryUnit}},
			Description -> "Mass spectra of observed mass-to-charge ratio (m/z) vs. intensity used to conduct fragmentation analysis when AcquisitionMode includes DataDependent.",
			Headers -> {"Time", "Mass Spectrum"},
			Category -> "Experimental Results"
		},
		SurveyFragmentationMassSpectra -> {
			Format -> Multiple,
			Class -> {Real, Real, BigQuantityArray},
			Pattern :> {GreaterP[0*Second], GreaterEqualP[0 Gram/Mole], BigQuantityArrayP[{Gram/Mole, ArbitraryUnit}]},
			Units -> {Minute, Gram/Mole, {Gram/Mole, ArbitraryUnit}},
			Description -> "Mass spectra of observed mass-to-charge ratio (m/z) vs. intensity used to conduct fragmentation analysis when AcquisitionMode includes DataDependent.",
			Headers -> {"Time","Parent Mass","Mass Spectrum"},
			Category -> "Experimental Results"
		},
		Absorbance -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute, Milli*AbsorbanceUnit}],
			Units -> {Minute, AbsorbanceUnit Milli},
			Description -> "The chromatogram of absorbance at AbsorbanceWavelength vs. time during the course of the experiment for the PDA detector.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		Absorbance3D-> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :>  BigQuantityArrayP[{Minute, Meter Nano, AbsorbanceUnit Milli}],
			Units -> {Minute, Meter Nano, AbsorbanceUnit Milli},
			Description -> "The measured Absorbance at each Wavelength for each retention time point during the course of the experiment for the PhotoDiodeArray (PDA) detector.",
			Category -> "Experimental Results"
		},

		Pressure -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute, PSI}],
			Units -> {Minute, PSI},
			Description -> "The chromatogram of system pressure vs. time during the course of the experiment.",
			Category -> "Experimental Results"
		},
		Temperature -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute, Celsius}],
			Units -> {Minute, Celsius},
			Description -> "The chromatogram of column temperature vs. time during the course of the experiment.",
			Category -> "Experimental Results"
		},
		StandardData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, ChromatographyMassSpectra][Analytes],
			Description -> "The data from the reference sample run before this data was generated.",
			Category -> "General"
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, ChromatographyMassSpectra][StandardData],
				Object[Data, ChromatographyMassSpectra][Calibrant]
			],
			Description -> "All samples associated with this standard.",
			Category -> "General"
		},
		MassSpectrometryFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The files containing the mass spectrometry data.",
			Category -> "Data Processing"
		},
		AbsorbanceFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the absorbance data.",
			Category -> "Data Processing"
		},
		PressureFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw chromatography pressure data.",
			Category -> "Data Processing"
		},
		TemperatureFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw chromatography temperature data.",
			Category -> "Data Processing"
		},
		JCAMPDXFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A JCAMPDX file containing the information present in the raw data, but in an unencrypted, widely recognized file type.",
			Category -> "General"
		},

		ChromatogramCompositionAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Analysis, Composition][StandardData],
				Object[Analysis, Composition][AssayData]
			],
			Description -> "Sample composition analyses performed on the Absorbance.",
			Category -> "Analysis & Reports"
		},

		IonAbundance3DPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analyses performed on the IonAbundance3D data.",
			Category -> "Analysis & Reports"
		},
		IonAbundancePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analyses performed on the IonAbundance data.",
			Category -> "Analysis & Reports"
		},
		MassSpectrumPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analyses performed on the MassSpectrum data.",
			Category -> "Analysis & Reports"
		},
		AbsorbancePeaksAnalyses  -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analyses performed on the Absorbance.",
			Category -> "Analysis & Reports"
		},
		Absorbance3DPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analyses performed on the Absorbance3D.",
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
		AirBubbleLikelihood -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "The probability of air bubble existing in the pressure trace of the chromatograph assigned to this data by a liquid chromatography air bubble anomaly detector machine learning model (unpublished result).",
			Category -> "Analysis & Reports"
		},
		DownsamplingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Downsampling analyses performed on this data.",
			Category -> "Analysis & Reports"
		},
		DownsamplingLogs -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Text logs of any instances of AnalyzeDownsampling run on this data object on Manifold, for debugging purposes.",
			Category->"Analysis & Reports",
			Developer->True
		},
		MethodFiles -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The method files used to conduct this mass spectrometry measurement for this sample zipped into one directory.",
			Category -> "General"
		},
		RawDataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing all raw data pertaining to the mass spectrometry measurement of this sample zipped into one directory.",
			Category -> "Experimental Results"
		},
		MzMLFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The data in mzML format pertaining to the mass spectrometry measurement of this sample.",
			Category -> "Experimental Results"
		}
	}
}];
