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
		},
		Reusable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this liner can be removed and replaced multiple times.",
			Category -> "Item Specifications"
		},
		Materials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The types of matter from which this liner is composed.",
			Category -> "Physical Properties"
		},
		CustomCut -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this liner was formed from a larger liner in-house, rather than received with the stated dimensions from the supplier.",
			Category -> "Physical Properties"
		},
		Absorbency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter / Meter ^ 2],
			Units -> Milliliter / Meter ^ 2,
			Description -> "The volume of liquid per unit area that can be retained within this liner.",
			Category -> "Physical Properties"
		},
		Cushioned -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this liner provides shock absorption.",
			Category -> "Physical Properties"
		},
		Waterproof -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this liner prevents liquid from penetrating through its material.",
			Category -> "Physical Properties"
		},

		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The lowest temperature to which this liner can be exposed and maintain integrity.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The highest temperature to which this liner can be exposed and maintain integrity.",
			Category -> "Operating Limits"
		}
	}
}];