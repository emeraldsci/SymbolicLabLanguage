(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, GasChromatography], {
	Description -> "A protocol that verifies the functionality of the gas chromatograph target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SeparationMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,GasChromatography],
			Description -> "For each member of QualificationSamples, the separation method used to separate the samples.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		Blank -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (ObjectP[{Model[Sample],Object[Sample]}]|NoInjection),
			Relation -> Null,
			Description -> "The combination of temperature, pressure, and flow setpoints used to separate the samples in the GC column while testing the signal background of the instrument.",
			Category -> "General"
		},
		BlankFrequency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> None | First | Last | FirstAndLast,
			Relation -> Null,
			Description -> "Indicates the order in which blanks will be collected during the qualification procedure.",
			Category -> "General"
		},
		BlankSeparationMethod -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,GasChromatography],
			Description -> "The combination of temperature, pressure, and flow setpoints used to separate the samples in the GC column while testing the signal background of the instrument.",
			Category -> "General"
		},
		InjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of QualificationSamples, The volume of each sample to inject into the GC for measurement.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		LiquidPreInjectionNumberOfSolventWashes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Relation -> Null,
			Description -> "For each member of QualificationSamples, the number of solvent washes to perform using the syringe wash solvent on the autosampler deck.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		LiquidPreInjectionSyringeWashVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Micro*Liter,
			Relation -> Null,
			Description -> "For each member of QualificationSamples, The combination of sample preparation options that will be used to prepare the sample for injection on the GC autosampler.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		SyringeWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent that will be used to rinse the syringe prior to sample aspiration on the autosampler deck.",
			Category -> "General"
		},
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate the Gas Chromatography samples.",
			Category -> "General"
		},
		PerformanceStandardTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, InjectionVolume -> Real, Data -> Link},
			Pattern :> {Sample -> _Link, InjectionVolume -> GreaterEqualP[0*Liter], Data -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), InjectionVolume -> Null, Data -> Object[Data,Chromatography]},
			Units -> {Sample -> None, InjectionVolume -> Micro*Liter, Data -> None},
			Description -> "The samples, injection volumes, and data used for testing the GC's performance using a mixture of known compounds injected into the instrument.",
			Category -> "General"
		},
		InjectionVolumeLinearityTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, InjectionVolume -> Real, Data -> Link},
			Pattern :> {Sample -> _Link, InjectionVolume -> GreaterEqualP[0*Liter], Data -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), InjectionVolume -> Null, Data -> Object[Data,Chromatography]},
			Units -> {Sample -> None, InjectionVolume -> Micro*Liter, Data -> None},
			Description -> "The samples, injection volumes, and data used for testing the GC's detector linearity for known compounds injected into the instrument.",
			Category -> "General"
		},
		CarryoverTest -> {
			Format -> Multiple,
			Class -> {Sample -> Link, InjectionVolume -> Real, Data -> Link, BlankData -> Link},
			Pattern :> {Sample -> _Link, InjectionVolume -> GreaterEqualP[0*Liter], Data -> _Link, BlankData -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), InjectionVolume -> Null, Data -> Object[Data,Chromatography], BlankData -> Object[Data,Chromatography]},
			Units -> {Sample -> None, InjectionVolume -> Micro*Liter, Data -> None, BlankData -> None},
			Description -> "The sample, injection volume, and data used for testing the GC's lack of carryover of analyte peaks from one injection to the next for known compounds injected into the instrument.",
			Category -> "General"
		},
		FIDBaselineTest -> {
			Format -> Multiple,
			Class -> {Sample -> Expression, BlankData -> Link},
			Pattern :> {Sample -> NoInjection, BlankData -> _Link},
			Relation -> {Sample -> Null, BlankData -> Object[Data,Chromatography]},
			Units -> {Sample -> None, BlankData -> None},
			Description -> "The sample and data used for testing the GC's signal to noise ratio for known compounds injected into the instrument.",
			Category -> "General"
		},
		MassRatioTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, InjectionVolume -> Real, Data -> Link},
			Pattern :> {Sample -> _Link, InjectionVolume -> GreaterEqualP[0*Liter], Data -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), InjectionVolume -> Null, Data -> Object[Data,Chromatography]},
			Units -> {Sample -> None, InjectionVolume -> Micro*Liter, Data -> None},
			Description -> "The samples, injection volumes, and data used for testing the ability of the GC's MS to reproducibly fragment analytes known compounds injected into the instrument.",
			Category -> "General"
		},
		MassesToRatio -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Relation -> Null,
			Units -> None,
			Description -> "The masses that will be compared for reproducble fragmentation of a target analyte during the mass ratio test.",
			Category -> "General"
		},
		ColumnFlush-> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a column flush is run as the first item in the injection table.",
			Category -> "General"
		}
	}
}];
