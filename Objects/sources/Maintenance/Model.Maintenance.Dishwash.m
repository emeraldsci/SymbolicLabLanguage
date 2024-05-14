(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Dishwash], {
	Description->"Definition of a set of parameters for a maintenance protocol that uses a dishwasher to clean and restock dirty labware.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		DishwashMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DishwashMethodP,
			Description -> "The type of dishwasher cycle utilized to clean the labware.",
			Category -> "General"
		},
		FumeHoodModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "Fume hood(s) that are used in emptying chemical waste from containers before dishwashing.",
			Category -> "General"
		},
		MinThreshold->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The minimum number of dirty labware objects required before a dishwash can be enqueued.",
			Category -> "General"
		},
		DishwashPrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD],
			Units -> USD,
			Description -> "The price the ECL charges for dish-washing a labware item owned by the user.",
			Category -> "Pricing Information"
		}
	}
}];
