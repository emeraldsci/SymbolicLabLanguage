(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Sinker], {
	Description->"Information for a pill holder that prevents it from floating during the dissolution experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CleanRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The rack used to store this sinker when it is clean.",
			Category -> "Placements"
		},
		DirtyRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The rack used to store this sinker when it is dirty and will be cleaned.",
			Category -> "Placements"
		}
	}
}];