(* ::Package:: *)

DefineObjectType[Model[Qualification, FPLC], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of an FPLC.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		(* Method Information *)
		Column ->  {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The column employed in this FPLC qualification.",
			Category -> "General",
			Abstract -> True
		},
		ColumnPrimeGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used for column primes.",
			Category -> "General"
		},
		ColumnFlushGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used for column flushes.",
			Category -> "General"
		},
		Blank -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the blank that will be injected.",
			Category -> "Blank"
		},
		BlankGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used during the blank injection at the beginning of the qualification.",
			Category -> "Blank"
		},
		BlankInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of blank to inject when testing the FPLC's pumps.",
			Category -> "Blank"
		},
		FlowLinearityTestSamples -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined strings pointing to the sample that will be injected when testing the FPLC's pumps.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "For each member of FlowLinearityTestSamples, the gradients to run when testing the FPLC's pumps.",
			Category -> "Flow Linearity Test",
			IndexMatching -> FlowLinearityTestSamples
		},
		FlowLinearityInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the FPLC's pumps.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityBlankA -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the blank that will be injected prior to the flow linearity test with pump A.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityBlankGradientA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used during the blank injection prior to the flow linearity test with pump A.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityBlankInjectionVolumeA -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of blank to inject prior to the flow linearity test with pump A.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityBlankB -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the blank that will be injected prior to the flow linearity test with pump B.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityBlankGradientB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used during the blank injection prior to the flow linearity test with pump B.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityBlankInjectionVolumeB -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of blank to inject prior to the flow linearity test with pump B.",
			Category -> "Flow Linearity Test"
		},
		AutosamplerTestSamples -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the samples that will be injected when testing the FPLC's autosampler.",
			Category -> "Autosampler Test"
		},
		AutosamplerPlateTestSamples -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the samples in a deep well plate that will be injected when testing the FPLC's autosampler.",
			Category -> "Autosampler Test"
		},
		AutosamplerGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the FPLC's autosampler.",
			Category -> "Autosampler Test"
		},
		AutosamplerInjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of AutosamplerTestSamples, the volumes of sample to inject when testing the FPLC's autosampler.",
			Category -> "Autosampler Test",
			IndexMatching -> AutosamplerTestSamples
		},
		AutosamplerPlateInjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of AutosamplerPlateTestSamples, the volumes of sample to inject when testing the FPLC's autosampler.",
			Category -> "Autosampler Test",
			IndexMatching -> AutosamplerPlateTestSamples
		},
		AutosamplerBlank -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the blank that will be injected prior to the autosampler test.",
			Category -> "Autosampler Test"
		},
		AutosamplerBlankGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used during the blank injection prior to the autosampler test.",
			Category -> "Autosampler Test"
		},
		AutosamplerBlankInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of blank to inject prior to the autosampler test.",
			Category -> "Autosampler Test"
		},
		FlowInjectionTestSamples -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the sample that will be injected when testing the FPLC's sample pump.",
			Category -> "Flow Injection Test"
		},
		FlowInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volumes of sample to inject when testing the FPLC's sample pump.",
			Category -> "Flow Injection Test"
		},
		FlowInjectionGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the FPLC's sample pump.",
			Category -> "Flow Injection Test"
		},
		FlowInjectionPreparatoryUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A list of transfers, consolidations, aliquiots, mixes and diutions that will be performed in the order listed to prepare samples for the flow injection tests.",
			Category -> "Sample Preparation"
		},
		FlowInjectionBlank -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the blank that will be injected prior to the flow injection test.",
			Category -> "Flow Injection Test"
		},
		FlowInjectionBlankGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used during the blank injection prior to the flow injection test.",
			Category -> "Flow Injection Test"
		},
		FlowInjectionBlankInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of blank to inject prior to the flow injection test.",
			Category -> "Flow Injection Test"
		},
		(* Fraction Collection *)
		FractionCollectionTestSample -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the sample that will be injected when testing the FPLC's fraction collector.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the FPLC's fraction collector.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the FPLC's fraction collector.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, FractionCollection],
			Description -> "The fraction collection method to use when testing the FPLC's fraction collector.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionBlank -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory primitive-defined string pointing to the blank that will be injected prior to the fraction collection test.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionBlankGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used during the blank injection prior to the fraction collection test.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionBlankInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of blank to inject prior to the fraction collection test.",
			Category -> "Fraction Collection Test"
		},
		AllBufferGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "A gradient that runs every buffer to test the system pump valves.",
			Category -> "General"
		}
	}
}];
