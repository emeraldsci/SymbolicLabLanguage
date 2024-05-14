(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Bag, Dishwasher], {
	Description->"Model information for a bag used to hold small, loose items in a dishwasher.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Dimensions & Positions *)
		MeshSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Millimeter,
			Description -> "The size of the openings in the walls of this model of bag.",
			Category -> "Dimensions & Positions"
		}
	}
}];
