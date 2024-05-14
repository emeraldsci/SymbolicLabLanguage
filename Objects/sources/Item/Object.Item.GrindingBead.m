(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, GrindingBead], {
	Description->"A grinding bead (grinding ball) that is a hard spherical item used in ball mills for crushing and beating solid particles into fine powder.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Diameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Diameter]],
			Pattern :> GreaterP[0 Millimeter],
			Description -> "The diameter of the griding ball (grinding bead).",
			Category -> "Physical Properties"
		},
		Material -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Material]],
			Pattern :> MaterialP,
			Description -> "The material that the grinding ball (grinding bead) is made out of.",
			Category -> "Physical Properties"
		}
	}
}];