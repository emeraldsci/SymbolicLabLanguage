(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Plumbing, ColumnJoin], {
	Description->"Model information for a short piece of tubing used to connect HPLC Column to an HPLC Guard Column",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		JoinLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The length of this column join model when installed (from the end of one column to the next).",
			Category -> "Dimensions & Positions"
		},
		
		GuardColumns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Column][PreferredColumnJoin],
			Description -> "The guard columns with which this column join can be used.",
			Category -> "Compatibility",
			Abstract -> True
		}
	}
}];
