(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,MassSpectrometryScan],
	{
		Description->"A detailed set of parameters that specifies a single mass spectrometry scan inside a LCMS protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields-> {
			Sample -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Model[Container],
					Object[Container]
				],
				Description -> "The sample that is to be centrifuged during this unit operation.",
				Category -> "General"
			},
			SampleType -> {
				Format -> Single,
				Class -> Expression,
				Pattern:> (Standard | Sample | ColumnPrime | ColumnFlush | Blank ),
				Description->"The type of sample for this unit operation.",
				Category-> "General",
				Abstract->True
			},
			AcquisitionWindow -> {
				Format -> Single,
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
			AcquisitionMode -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> MSAcquisitionModeP,
				Description -> "The manner of scanning and/or fragmenting intact and resultant ions.",
				Category -> "Mass Analysis",
				Abstract -> True
			},
			Fragmentation -> {
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description -> "Indicates whether the intact ions collide with inert gas to dissociate into product ions. Also known as Tandem mass spectrometry or MS/MS.",
				Category -> "Mass Analysis"
			},
			MinMass -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[(0*Gram)/Mole],
				Units -> Gram/Mole,
				Description -> "The lowest measured or selected mass-to-charge ratio (m/z) intact ions.",
				Category -> "Mass Analysis"
			},
			MaxMass -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[(0*Gram)/Mole],
				Units -> Gram/Mole,
				Description -> "The highest measured or selected mass-to-charge ratio (m/z) intact ions.",
				Category -> "Mass Analysis"
			},
			MassSelections -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterP[(0*Gram)/Mole],
				Description -> "All of the measured or selected mass-to-charge ratio (m/z) intact ions.",
				Category -> "Mass Analysis"
			},
			ScanTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Second,
				Description -> "The duration of time allowed to pass between each spectral acquisition.",
				Category -> "Mass Analysis"
			},
			FragmentMinMass -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[(0*Gram)/Mole],
				Units -> Gram/Mole,
				Description -> "The lowest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
				Category -> "Mass Analysis"
			},
			FragmentMaxMass -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[(0*Gram)/Mole],
				Units -> Gram/Mole,
				Description -> "The highest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
				
				Category -> "Mass Analysis"
			},
			FragmentMassSelections -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterP[(0*Gram)/Mole],
				Description -> "All of the measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
				Category -> "Mass Analysis"
			},
			
			(* remove the new field after database refresh*)
			CollisionEnergies -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :>UnitsP[0Volt],
				Description -> "The applied potential that accelerates ions into an inert gas for induced dissociation.",
				Category -> "Mass Analysis"
			},
			LowCollisionEnergy -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0Volt],
				Units -> Volt,
				Description -> "The lowest value of the linear function for applied potential as mapped to the MinMass.",
				Category -> "Mass Analysis"
			},
			HighCollisionEnergy -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0Volt],
				Units -> Volt,
				Description -> "The highest value of the linear function for applied potential as mapped to the MinMass.",
				Category -> "Mass Analysis"
			},
			FinalLowCollisionEnergy -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0Volt],
				Units -> Volt,
				Description -> "At the end of the spectral scan, the lowest value of the linear function for applied potential as mapped to the MinMass.",
				Category -> "Mass Analysis"
			},
			FinalHighCollisionEnergy -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0Volt],
				Units -> Volt,
				Description -> "At the end of the spectral scan, the highest value of the linear function for applied potential as mapped to the MinMass.",
				
				Category -> "Mass Analysis"
			},
			FragmentScanTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Second,
				Description -> "The duration of time allowed to pass between each spectral acquisition for the product ions when AcquistionMode -> DataDependent.",
				Category -> "Mass Analysis"
			},
			AcquisitionSurvey -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterP[0, 1],
				Units -> None,
				Description -> "Indicates the number of intact ions to consider for fragmentation and acquisition in DataDependent acquistion mode.",
				Category -> "Mass Analysis"
			},
			MinimumThreshold -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterP[0, 1],
				Units -> None,
				Description -> "The least number of total intact ions needed to be measured to elicit an acquisition program.",
				Category -> "Mass Analysis"
			},
			AcquisitionLimit -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterP[0, 1],
				Units -> None,
				Description -> "The maximum number measured ions allowed during a fragmentation measurement of a survey ion. Will proceed to the next intact ion/fragmentation once reached.",
				Category -> "Mass Analysis"
			},
			CycleTimeLimit -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Second,
				Description -> "The maximum duration allowable for a survey. Will proceed to the next cycle once reached.",
				Category -> "Mass Analysis"
			},
			ExclusionDomain -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {UnitsP[Minute],UnitsP[Minute]},
				Description -> "The time blocks within to consider for specific mass exclusion.",
				Category -> "Mass Analysis"
			},
			ExclusionMass -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {ExclusionModeP,GreaterP[(0*Gram)/Mole]},
				Description -> "Indicates the manner of omitting intact ions for acquisition survey.",
				Category -> "Mass Analysis"
			},
			ExclusionMassTolerance -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Dalton],
				Units -> Dalton,
				Description -> "The range above and below each ion in ExclusionMassSelection to consider for omission.",
				Category -> "Mass Analysis"
			},
			ExclusionRetentionTimeTolerance -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Second,
				Description -> "The range above and below each retention time in ExclusionMassSelection to consider for omission.",
				Category -> "Mass Analysis"
			},
			InclusionDomain -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {UnitsP[Minute],UnitsP[Minute]},
				Description -> "The time blocks within to consider for specific mass inclusion.",
				Category -> "Mass Analysis"
			},
			InclusionMass -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {InclusionModeP, GreaterP[(0*Gram)/Mole]},
				Description -> "The intact ions to prioritize during survey acquisition.",
				Category -> "Mass Analysis"
			},
			InclusionCollisionEnergies-> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0Volt],
				Description -> "The overriding collision energy to use for the corresponding InclusionMass.",
				Category -> "Mass Analysis"
			},
			InclusionDeclusteringVoltages-> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0Volt],
				Description -> "The overriding source voltage to use for the corresponding InclusionMass.",
				Category -> "Mass Analysis"
			},
			InclusionChargeStates-> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0,1],
				Description -> "The charge state isotopes to also consider for inclusion.",
				Category -> "Mass Analysis"
			},
			InclusionScanTimes-> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0*Second],
				Description -> "The overriding scan time to use for the corresponding InclusionMass.",
				Category -> "Mass Analysis"
			},
			InclusionMassTolerance -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Dalton],
				Units -> Dalton,
				Description -> "The range above and below each ion in InclusionMassSelection to consider for omission.",
				Category -> "Mass Analysis"
			},
			ChargeStateLimit -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0, 1],
				Units -> None,
				Description -> "The number of ions to survey before excluding for ion state properties.",
				Category -> "Mass Analysis"
			},
			ChargeStateSelections -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[1,1],
				Description -> "The specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition.",
				Category -> "Mass Analysis"
			},
			ChargeStateMassTolerance -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Dalton],
				Units -> Dalton,
				Description -> "The range of m/z to consider for exclusion by ionic state property.",
				Category -> "Mass Analysis"
			},
			IsotopeMassDifferences -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterP[0 Dalton],
				Description -> "The delta between monoisotopic ions as a criterion for survey exclusion.",
				Category -> "Mass Analysis"
			},
			IsotopeRatios -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterP[0],
				Description -> "The minimum relative magnitude between monoisotopic ions as a criterion for survey exclusion.",
				Category -> "Mass Analysis"
			},
			IsotopeDetectionMinimums -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterP[0*1/Second],
				Description -> "The acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
				Category -> "Mass Analysis"
			},
			IsotopeRatioTolerance-> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0*Percent],
				Units -> Percent,
				Description -> "The range of relative magnitude around IsotopeRatio and SecondaryIsotopeRatio to consider for isotope exclusion.",
				Category -> "Mass Analysis"
			},
			IsotopeMassTolerance -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Dalton],
				Units -> Dalton,
				Description -> "The range of m/z to consider for exclusion by ionic state property.",
				Category -> "Mass Analysis"
			},
			CollisionCellExitVoltage -> {
				Format -> Single,
				Class -> Real,
				Pattern :> UnitsP[0 Volt],
				Units -> Volt,
				Description ->"If the sample will be scanned in tandem mass spectrometry mode in ESI-QQQ, the value of the potential applied between collision cell and the second Quadrupole mass analyzer (MS2) to guide and focus the ion beam into MS2.",
				Category -> "Mass Analysis"
			},
			MassDetectionStepSize -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[(0*Gram)/Mole],
				Units -> Gram/Mole,
				Description ->"The mass-to-charge value at which the mass spectrometer will record a data of the mass scan.",
				Category -> "Mass Analysis"
			},
			NeutralLoss -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[(0*Gram)/Mole],
				Units -> Gram/Mole,
				Description ->"In ESI-QQQ analysis, if the sample will be scanned in tandem mass spectrometry mode with Neutral Ion Loss mode, the value for the mass offset values between MS1 and MS2 (neutral ion loss value.).",
				Category -> "Mass Analysis"
			},
			DwellTime->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :>GreaterP[0*Millisecond],
				Description->"If the sample will be scan in SelectedIonMonitoring mode or SingleReactionMonitoring mode, the length of time for each mass selection or mass selection pairs.",
				Category -> "Mass Analysis"
			},
			MultipleReactionMonitoringAssays->{
				Format->Multiple,
				Description ->"In ESI-QQQ analysis, that firstly targets the ion corresponding to the compound of interest with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and dwell time (length of time of each scan).",
				Class->{
					MS1Mass->Expression,
					CollisionEnergy->Expression,
					MS2Mass->Expression,
					DwellTime->Expression
				},
				Pattern :> ({
					MS1Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
					CollisionEnergy-> {UnitsP[0Volt]..}|Null,
					MS2Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
					DwellTime->{GreaterP[0*Millisecond]..}|Null
				}),
				Category -> "Mass Analysis"
			}
		}
	}
];
