(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Replace, GasFilter], {
	Description->"A protocol that replaces a filter on a gas line.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		GasFilter-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Filter] | Model[Part, Filter],
			Description -> "The new gas filter to install.",
			Category -> "General"
		}
	}
}];
