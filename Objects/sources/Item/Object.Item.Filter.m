(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, Filter], {
	Description->"A physical filter used to filter particles above a certain size from a sample.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Occluded -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this filter has become occluded or clogged in the course of running.",
			Category -> "Filtration"
		}
	}
}];
