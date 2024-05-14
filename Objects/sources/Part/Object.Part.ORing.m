(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part,ORing], {
	Description->"An O-ring used to form a leak-tight seal between two components via compression.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Contaminated -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature that this O-ring can withstand before it loses its sealing properties.",
			Units->Celsius,
			Category -> "Physical Properties"
		},
		Reusable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether this O-ring can be re-used if the part is removed from its installed location.",
			Category -> "Physical Properties"
		}
	}
}];
