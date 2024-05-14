

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, MassAcquisition], {
	Description->"A set of parameters used to conduct acquisition on a mass spectrometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MassAnalyzer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassAnalyzerTypeP,
			Description -> "The type of the component of the mass spectrometer that performs ion separation based on m/z (mass-to-charge ratio). QTOF accelerates ions through a flight tube and resolves by their flight time.",
			Category -> "General",
			Abstract -> True
		},
		IonSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonSourceP,
			Description -> "The type of ionization used to create gas phase ions from the molecules in the sample. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission.",
			Category -> "Ionization",
			Abstract -> True
		},
		ESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description -> "The applied voltage differential between the injector and the inlet for the mass spectrometry in order to ionize analyte molecules.",
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
		SourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
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
		IonMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "The polarity of the charged analyte.",
			Category -> "Ionization",
			Abstract -> True
		},
		Calibrant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample with known mass-to-charge ratios used to calibrate the mass spectrometer.",
			Category -> "Sample Preparation"
		},
		SecondCalibrant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The second sample with known mass-to-charge ratios used to calibrate the mass spectrometer.",
			Category -> "Sample Preparation"
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
			Pattern :> MSAcquisitionModeP,
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
		MassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of AcquisitionWindows, all of the measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> AcquisitionWindows,
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
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of AcquisitionWindows, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		HighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
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
			Pattern :> GreaterEqualP[0, 1],
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
		CollisionCellExitVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Volt],
			Units -> Volt,
			Description ->"For each member of AcquisitionWindows, if the sample will be scanned in tandem mass spectrometry mode in ESI-QQQ, the value of the potential applied between collision cell and the second Quadrupole mass analyzer (MS2) to guide and focus the ion beam into MS2.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		MassDetectionStepSizes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"For each member of AcquisitionWindows, the mass-to-charge value at which the mass spectrometer will record a data of the mass scan.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		NeutralLosses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"In ESI-QQQ analysis, if the sample will be scanned in tandem mass spectrometry mode with Neutral Ion Loss mode, the value for the mass offset values between MS1 and MS2 (neutral ion loss value.).",
			Category -> "Mass Analysis"
		},
		DwellTimes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*Millisecond]..}|GreaterP[0*Millisecond]|Null)..},
			Description->"For each member of AcquisitionWindows, if the sample will be scan in SelectedIonMonitoring mode or MultipleReactionMonitoring mode, the length of time for each mass selection or mass selection pairs.",
			IndexMatching -> AcquisitionWindows,
			Category -> "Mass Analysis"
		},
		MultipleReactionMonitoringAssays->{
			Format->Multiple,
			Description ->"For each member of AcquisitionWindows, in ESI-QQQ, that firstly targets the ion corresponding to the compound of interest with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and dwell time (length of time of each scan).",
			IndexMatching -> AcquisitionWindows,
			Class->{
				MS1Mass->Expression,
				CollisionEnergy->Expression,
				MS2Mass->Expression,
				DwellTime->Expression
			},
			Pattern :> ({
				MS1Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				CollisionEnergy-> {UnitsP[0*Volt]..}|Null,
				MS2Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				DwellTime->{GreaterP[0*Millisecond]..}|Null
			}),
			Category -> "Mass Analysis"
		},
		
		(* New fields *)
		IonGuideVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "The absolute voltage applied to the tip of the stainless steel ESI (electrospray ionization) capillary tubing in order to produce charged droplets. This is an unique option for ESI-QQQ, and also referred as IonSprayVoltages.",
			Category -> "Ionization"
		}
	}
}];