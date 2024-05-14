(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, Stopper], {
	Description->"A barrier (typically made from a polymer material) that retains a liquid or solid in a container.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		CoveredContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :>  _Link,
			Relation -> Object[Container][Stopper],
			Description -> "The container on which this stopper is currently placed.",
			Category -> "Dimensions & Positions"
		}
	}
}];
