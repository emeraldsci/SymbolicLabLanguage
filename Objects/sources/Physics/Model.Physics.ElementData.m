(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Physics, ElementData],{
	Description -> "Element and isotope data and properties for all elements.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Element -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ElementP,
			Description -> "The element symbol.",
			Category -> "General",
			Abstract -> True
		},
		Abbreviation -> {
			Format -> Single,
			Class -> String,
			Pattern :> ElementAbbreviationP,
			Description -> "The standard abbreviation of the element.",
			Category -> "General",
			Abstract -> True
		},
		MolarMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Gram/Mole],
			Units -> Gram/Mole,
			Description -> "The atomic mass of this element, averaged across all isotopes, weighted by their natural abundance.",
			Category -> "Physical Properties"
		},
		Isotopes -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> IsotopeP,
			Description -> "A list of all possible isotopes of this element.",
			Category -> "Isotope Properties"
		},
		IsotopeAbundance -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			IndexMatching -> Isotopes,
			Description -> "For each member of Isotopes, indicate the natural abundance of that isotope.",
			Category -> "Isotope Properties"
		},
		IsotopeMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Gram/Mole],
			Units -> Gram/Mole,
			IndexMatching -> Isotopes,
			Description -> "For each member of Isotopes, indicate the atomic mass of that isotope.",
			Category -> "Isotope Properties"
		},
		Period -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "Period of this element.",
			Category -> "Physical Properties"
		},
		Group -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[GreaterP[0, 1], "Lanthanide", "Actinide"],
			Description -> "Group of this element.",
			Category -> "Physical Properties"
		},
		Radioactive -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate if all natural isotopes of this element is radioactive.",
			Category -> "Physical Properties"
		},
		IsotopeRadioactivity -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Isotopes, indicate whether it is radioactive.",
			Category -> "Isotope Properties",
			IndexMatching -> Isotopes
		},
		Index -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate whether this object is an index linking to other Model.Physics Object, or it's a real object.",
			Category -> "General"
		},
		Data -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {ElementP, _Link},
			Relation -> {Null, Model[Physics, ElementData]},
			Description -> "If this object is an index object, this field provides link to the real objects.",
			Category -> "General",
			Headers -> {"Element Symbol", "ElementData Object"}
		},
		AbbreviationIndex -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {ElementAbbreviationP, _Link},
			Relation -> {Null, Model[Physics, ElementData]},
			Description -> "If this object is an index object, this field provides link to the real objects.",
			Category -> "General",
			Headers -> {"Element Abbreviation", "ElementData Object"}
		}
	}
}];