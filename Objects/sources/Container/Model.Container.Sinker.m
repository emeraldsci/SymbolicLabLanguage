(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Sinker], {
	Description->"Model information for a weighted enclosure used to keep the oral solid dosage or suppository below the surface of the medium during the dissolution experiment to facilitate proper mixing.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ApertureSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 * Millimeter],
			Units->Millimeter,
			Description->"The size of the aperture of the weighted enclosure. The diameter of the oral solid dosage or suppository should be less than the aperture size for the sinker to be compatible.",
			Category->"Dimensions & Positions"
		},
		SinkerType->{
			Format->Single,
			Class->Expression,
			Pattern:>SinkerTypeP,
			Description->"The type of the weighted enclosure used to keep the oral solid dosage or suppository below the surface of the medium during the dissolution experiment to facilitate proper mixing.",
			Category->"Physical Properties"
		},
		Weight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 * Gram],
			Units->Gram,
			Description->"The weight of the weighted enclosure used to keep the oral solid dosage or suppository below the surface of the medium during the dissolution experiment to facilitate proper mixing.",
			Category->"Physical Properties"
		},
		DisplacementVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 * Milliliter],
			Units->Milliliter,
			Description->"The volume of the medium displaced by the Sinker.",
			Category->"Physical Properties"
		}
	}
}];