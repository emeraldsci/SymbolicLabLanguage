(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, FilterHousing], {
	Description->"A Model of a part that holds a disk membrane during filtration of solution in order to remove particles above a certain size from the sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MembraneDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of the filter membrane compatible with this type housing.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		DeadVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "Dead volume needed to fill the filter housing lines.",
			Category -> "Part Specifications"
		}
	}
}];
