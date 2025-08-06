(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, KarlFischerTitrator], {
	Description->"A model instrument used for measuring the water content of a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TitrationTechnique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KarlFischerTechniqueP,
			Description -> "Indicates how models of this instrument introduce Karl Fischer reagent to the sample.  If Volumetric, the Karl Fischer reagent mixture is introduced via buret in small increments. If set to Coulometric, molecular iodine is generated in situ by applying a pulse of electric current on a sample of iodide ions.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SamplingMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> KarlFischerSamplingMethodP,
			Description -> "The processes by which sample may be introduced to the Karl Fischer reagent using this instrument. Liquid indicates that the Karl Fischer reagent can be introduced to the liquid sample directly.  Headspace indicates that the sample can be heated and the released gas bubbled into the Karl Fischer reagent chamber.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the lowest temperature that this instrument can heat the sample when using the Headspace sampling method.",
			Category -> "Instrument Specifications"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the highest temperature that this instrument can heat the sample when using the Headspace sampling method.",
			Category -> "Instrument Specifications"
		}
	}
}];