(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,FPLC], {
	Description->"A protocol that verifies the functionality of the FPLC target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		PreparedSamples -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined strings to provide as input to the ExperimentFPLC experiment call.",
			Category -> "General",
			Developer -> True
		},
		InjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of PreparedSamples, the volume of sample to inject with the autosampler.",
			IndexMatching -> PreparedSamples,
			Category -> "General"
		},
		GradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "For each member of PreparedSamples, the gradient conditions used to run the sample on the FPLC.",
			IndexMatching -> PreparedSamples,
			Category -> "General"
		},
		FlowInjectionPreparedSamples -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined strings to provide as input to the ExperimentFPLC experiment call when testing flow injection.",
			Category -> "General",
			Developer -> True
		},
		FlowInjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of FlowInjectionPreparedSamples, the volume of sample to inject via flow injection.",
			IndexMatching -> FlowInjectionPreparedSamples,
			Category -> "General"
		},
		FlowInjectionGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "For each member of FlowInjectionPreparedSamples, the gradient conditions used to run the sample on the FPLC.",
			IndexMatching -> FlowInjectionPreparedSamples,
			Category -> "General"
		},
		FractionCollectionMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,FractionCollection],
			Description -> "For each member of FlowInjectionPreparedSamples, the fraction collection parameters used for any samples that require fraction collection.",
			Category -> "General",
			IndexMatching -> FlowInjectionPreparedSamples
		},
		InjectionTable -> {
			Format -> Multiple,
			Headers -> {"Type", "Sample", "InjectionType", "InjectionVolume", "Gradient"},
			Class -> {Expression, Expression, Expression, Real, Expression},
			Pattern :> {InjectionTableP,  ObjectP[{Model[Sample],Object[Sample]}]|_String, FPLCInjectionTypeP, RangeP[1 Microliter, 4 Liter], ObjectP[Object[Method, Gradient]]},
			Relation -> {Null, Null, Null, Null, Null},
			Units -> {None, None, None, Microliter, None},
			Description -> "The order of sample, Standard, and Blank sample loading into the Instrument during measurement and/or collection. Also includes the flushing and priming of the column.",
			Category -> "Method Information"
		},
		InjectionTableFlowInjection -> {
			Format -> Multiple,
			Headers -> {"Type", "Sample", "InjectionType", "InjectionVolume", "Gradient"},
			Class -> {Expression, Expression, Expression, Real, Expression},
			Pattern :> {InjectionTableP,  ObjectP[{Model[Sample],Object[Sample]}]|_String, FPLCInjectionTypeP, RangeP[1 Microliter, 4 Liter], ObjectP[Object[Method, Gradient]]},
			Relation -> {Null, Null, Null, Null, Null},
			Units -> {None, None, None, Microliter, None},
			Description -> "The order of sample, Standard, and Blank sample loading into the Instrument during measurement and/or collection. Also includes the flushing and priming of the column.",
			Category -> "Method Information"
		}
	}
}];
