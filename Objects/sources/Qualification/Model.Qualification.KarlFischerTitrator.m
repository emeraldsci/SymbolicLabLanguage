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
		SamplingMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> KarlFischerSamplingMethodP,
			Description -> "The processes by which samples may be introduced to the Karl Fischer reagent using the instruments being qualified by this model. Liquid indicates that the Karl Fischer reagent can be introduced to the liquid sample directly.  Headspace indicates that the sample can be heated and the released gas bubbled into the Karl Fischer reagent chamber.",
			Category -> "Instrument Specifications"
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature to which the samples are heated in order to release their water in headspace gas that is bubbled into the Karl Fischer reagent.",
			Category -> "Sampling"
		},
		Standards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The standards used to measure the instrument's ability to measure the water content of a sample.",
			Category -> "Standards"
		},
		StandardAmount -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Milligram] | GreaterP[0 Milliliter],
			IndexMatching -> Standards,
			Description -> "For each member of Standards, the amount of sample to use to measure the water content of that sample.",
			Category -> "Standards"
		},
		NominalWaterContent -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 MassPercent],
			Units -> MassPercent,
			IndexMatching -> Standards,
			Description -> "For each member of Standards, the mass percent of water expected to be present in the Standards.  Note that the actual water content of each standard is provided in its Certificate of Analysis and thus may not exaclty match the values in this field.",
			Category -> "Standards"
		}
	}
}];