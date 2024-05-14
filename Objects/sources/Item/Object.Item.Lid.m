(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, Lid], {
	Description->"Information for a lid that can be placed on top of a container to non-hermetically cover it.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		CoveredContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :>  _Link,
			Relation -> Object[Container][Cover],
			Description -> "The plate on which this lid is currently placed.",
			Category -> "Dimensions & Positions"
		},
		Reusable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this cover can be taken off and replaced multiple times without issue.",
			Category -> "Item Specifications"
		}
	}
}];
