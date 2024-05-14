(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, CableTieGun], {
	Description->"Model information for a tool used to tighten and cut a cable tie to a consistent level of tension.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinTension->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Pound],
			Units -> Pound,
			Description -> "The minimum tensile strength that this model of cable tie gun can be set to output.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MaxTension->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Pound],
			Units -> Pound,
			Description -> "The maximum tensile strength that this model of cable tie gun can be set to output.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MaxTieWidth->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Meter],
			Units -> Milli Meter,
			Description -> "The maximum width of cable tie that this model of cable tie gun can accommodate.",
			Category -> "Part Specifications",
			Abstract -> True
		}
	}
}];
