(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, Liner], {
	Description -> "Information for a liner that can be placed inside a container or underneath an object to protect that object from contamination and/or damage.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SourceLiner -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Liner][DerivedLiners],
			Description -> "The original liner from which this liner was cut.",
			Category -> "Organizational Information"
		},
		DerivedLiners -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Liner][SourceLiner],
			Description -> "Liners that were cut from this liner.",
			Category -> "Organizational Information"
		},
		LinedContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][Liners, 2],
				Object[Instrument][Liners, 2]
			],
			Description -> "The container or instrument within or on top of which this liner is currently positioned and actively providing protection.",
			Category -> "Item Specifications"
		},
		LinedPosition -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The name of the position in this item's lined container where this liner is physically positioned and actively providing protection.",
			Category -> "Item Specifications"
		},
		Roll -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this liner is wound around a central spool.",
			Category -> "Physical Properties"
		}
	}
}];