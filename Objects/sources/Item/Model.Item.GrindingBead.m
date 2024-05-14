(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, GrindingBead], {
	Description->"A model for a grinding bead (grinding ball) which is a hard spherical item used in ball mills for crushing and beating solid particles into fine powder.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The diameter of the griding ball (grinding bead).",
			Units->Millimeter,
			Category -> "Physical Properties",
			Abstract -> True
		},
		Material -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the grinding ball (grinding bead) is made out of.",
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
