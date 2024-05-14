(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, DiodeArrayModule], {
	Description->"Model information for a diode array module that can be attached to a dynamic foam analyzer instrument to illuminate the sample column during the course of the experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		IlluminationWavelength->{
			Format->Single,
			Class->Integer,
			Pattern:>Alternatives[469 Nanometer,850 Nanometer],
			Units->Nanometer,
			Description->"The wavelength that can be used to illuminate the sample column during the course of the experiment.",
			Category->"Operating Limits"
		}
	}
}];