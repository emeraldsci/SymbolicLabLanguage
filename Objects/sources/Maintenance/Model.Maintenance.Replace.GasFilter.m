(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Replace, GasFilter], {
	Description->"Definition of a set of parameters for a maintenance protocol that replaces a filter on a gas line.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		GasFilter-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, Filter],
			Description -> "The model of gas filter to install.",
			Category -> "General"
		}
	}
}];
