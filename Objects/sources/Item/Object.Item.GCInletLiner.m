(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item,GCInletLiner], {
	Description->"A model of an inlet liner used to protect analytes injected into the inlet of a gas chromatograph from active surface inside the inlet.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Reusable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether this inlet liner can be re-used if the item is removed from its installed location.",
			Category -> "Physical Properties"
		}
	}
}];
