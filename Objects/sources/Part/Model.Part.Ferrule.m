(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Ferrule], {
	Description->"Model information for a compressible plumbing component used to form a seal around tubing or pipes while connecting them to a fitting.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Inch],
			Units -> Inch,
			Description -> "The width of tubing that can be threaded through this ferrule, to create a leak free seal in a compression fitting.",
			Category -> "Plumbing Information",
			Abstract -> True
		}
	}
}];