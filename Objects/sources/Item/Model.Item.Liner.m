(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Liner], {
	Description -> "Model information for a liner that can be placed inside a container or underneath an object to protect that object from contamination and/or damage.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SourceLiner -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Liner][DerivedLiners],
			Description -> "The liner model from which this liner is cut when CustomCut is True.",
			Category -> "Organizational Information"
		},
		DerivedLiners -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Liner][SourceLiner],
			Description -> "Liner models that are custom cut from this liner.",
			Category -> "Organizational Information"
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
			Description -> "Indicates if this liner model is formed from a larger liner in-house, such as from a continuous roll, rather than received with the stated dimensions from the supplier.",
			Category -> "Physical Properties"
		},
		Roll -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this liner model is supplied wound around a central spool.",
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