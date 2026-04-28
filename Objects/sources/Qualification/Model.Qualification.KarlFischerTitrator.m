(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, KarlFischerTitrator],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a KarlFischerTitrator instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		TitrationTechnique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KarlFischerTechniqueP,
			Description -> "Indicates the way the instruments being qualified by this model introduce Karl Fischer reagent to the sample.  If Volumetric, the Karl Fischer reagent mixture is introduced via buret in small increments. If set to Coulometric, molecular iodine is generated in situ by applying a pulse of electric current on a sample of iodide ions.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SamplingMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KarlFischerSamplingMethodP,
			Description -> "The processes by which samples may be introduced to the Karl Fischer reagent using the instruments being qualified by this model. Liquid indicates that the Karl Fischer reagent can be introduced to the liquid sample directly.  Headspace indicates that the sample can be heated and the released gas bubbled into the Karl Fischer reagent chamber.",
			Category -> "Instrument Specifications"
		},
		Standard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The standard sample used to benchmark an instrument's ability to measure the water content of a sample.  If TitrationTechnique is Volumetric, this standard is used to calculate the titer of the Karl Fischer reagent.",
			Category -> "Standards"
		},
		StandardAmount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Milligram] | GreaterP[0 Milliliter],
			Description -> "The amount of standard to use to measure the water content of the standard (if TitrationTechnique is set to Coulometric), or calculate the titer of Karl Fischer reagent prior to titrating the samples (if TitrationTechnique is set to Volumetric).",
			Category -> "Standards"
		},
		NumberOfStandards -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "Indicates the number of Standard samples whose water content is measured to validate the titration instrument.",
			Category -> "Standards"
		},
		StandardTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature to which the standards are heated in order to release their water in headspace gas that is bubbled into the Karl Fischer reagent.",
			Category -> "Standards"
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> Samples,
			Description -> "For each member of Samples, the temperature to which the samples are heated in order to release their water in headspace gas that is bubbled into the Karl Fischer reagent.",
			Category -> "General"
		},
		Samples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The samples used to measure the instrument's ability to measure the water content of a sample.",
			Category -> "General"
		},
		SampleAmount -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Milligram] | GreaterP[0 Milliliter],
			IndexMatching -> Samples,
			Description -> "For each member of Samples, the amount of sample to use to measure the water content of that sample.",
			Category -> "General"
		},
		NominalStandardWaterContent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 MassPercent],
			Units -> MassPercent,
			Description -> "The mass percent of water expected to be present in the Standard.  Note that the actual water content of each standard is provided in its Certificate of Analysis and thus may not exactly match the values in this field.",
			Category -> "General"
		},
		NominalWaterContent -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 MassPercent],
			Units -> MassPercent,
			IndexMatching -> Samples,
			Description -> "For each member of Samples, the mass percent of water expected to be present.  Note that the actual water content of each standard is provided in its Certificate of Analysis and thus may not exactly match the values in this field.",
			Category -> "General"
		}
	}
}];
