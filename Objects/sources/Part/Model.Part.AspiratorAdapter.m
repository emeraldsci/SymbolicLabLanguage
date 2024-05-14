(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, AspiratorAdapter], {
	Description->"Model information for an adapter that attaches tips to an aspirator.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TipConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TipConnectionTypeP,
			Description -> "The mechanism by which tips connects to this pipette.",
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
