(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, GasChromatography], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a gas chromatograph.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* experiment options *)
		Column->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Column], Object[Item,Column]
			],
			Description -> "The flow path containing a known stationary phase used to assess the ability of the instrument to perform chromatographic separation.",
			Category -> "General"
		},
		Detector->{
			Format -> Single,
			Class -> Expression,
			Pattern :> GCDetectorP,
			Relation -> Null,
			Description -> "The instrument component responsible for measuring the separated analytes at the outlet of the chromatographic column used to assess the ability of the instrument to perform chromatographic separation.",
			Category -> "General"
		},
		Inlet->{
			Format -> Single,
			Class -> Expression,
			Pattern :> GCInletP,
			Relation -> Null,
			Description -> "The heated zone in which the injected samples are vaporized used to assess the ability of the instrument to perform chromatographic separation.",
			Category -> "General"
		},
		IonSource->{
			Format -> Single,
			Class -> Expression,
			Pattern :> GCIonSourceP,
			Relation -> Null,
			Description -> "The mechanism by which the separated analytes are ionized for analysis in the instrument's integrated mass spectrometer after chromatographic separation.",
			Category -> "General"
		},
		IonMode->{
			Format -> Single,
			Class -> Expression,
			Pattern :> IonModeP,
			Relation -> Null,
			Description -> "The polarity of ions that will be analyzed by the instrument's integrated mass spectrometer after chromatographic separation.",
			Category -> "General"
		},
		SeparationMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,GasChromatography],
			Description -> "The combination of temperature, pressure, and flow setpoints used to separate the samples in the GC column.",
			Category -> "General"
		},
		BlankSeparationMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,GasChromatography],
			Description -> "The combination of temperature, pressure, and flow setpoints used to separate the samples in the GC column while testing the signal background of the instrument.",
			Category -> "General"
		},
		SyringeWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent to use to wash the GC injection syringe prior to aspiration of a sample.",
			Category -> "General"
		},
		InjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Relation -> Null,
			Units -> Micro*Liter,
			Description -> "The volume of a test sample to inject during each qualification injection.",
			Category -> "General"
		},
		FlushMethod-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,GasChromatography],
			Description -> "The combination of temperature, pressure, and flow setpoints used to flush the GC column prior to running the blanks, standards and samples.",
			Category -> "General"
		},
		(* detector samples *)
		PerformanceStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the GC's ability to measure a peak with a threshold signal to baseline noise ratio.",
			Category -> "Fraction Collection Test"
		},
		InjectionVolumeStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the GC's detector linearity.",
			Category -> "Fraction Collection Test"
		},
		CarryoverStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the GC's analyte carryover between injections.",
			Category -> "Fraction Collection Test"
		},
		FIDBaselineStandard -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (_Link|NoInjection),
			Relation -> Null,
			Description -> "The sample that will be injected when testing the GC's Flame Ionization Detector baseline (usually nothing).",
			Category -> "Fraction Collection Test"
		},
		MassesToRatio -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Relation -> Null,
			Units -> None,
			Description -> "The masses that will be compared for reproducble fragmentation of a target analyte during the mass ratio test.",
			Category -> "General"
		}


	}
}];
