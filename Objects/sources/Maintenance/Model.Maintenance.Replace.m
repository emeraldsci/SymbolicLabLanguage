(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Replace], {
	Description->"Definition of a set of parameters for a maintenance protocol that replaces semi-consumables used by the maintenance target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ReplacementParts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Model[Item],
				Model[Part],
				Model[Plumbing],
				Model[Wiring]
			],
			Description -> "The models of semi-consumables to replace.",
			Category -> "General"
		},
		PartsLocations -> {
			Format -> Multiple,
			Class -> String, 
			Pattern :> LocationPositionP,
			Description -> "The location positions where replacement parts are installed on the target.",
			Category -> "General",
			Developer -> True
		},
		RequiredTools -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Screwdriver],
				Model[Item, Wrench],
				Model[Item, Plier]
			],
			Description -> "The tools required for maintenance.",
			Category -> "General"
		},
		DeveloperOnly -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Null, BooleanP],
			Description -> "Indicates if the maintenance should be performed by a developer or a trained engineer.",
			Category -> "General"
		}
	}
}];
