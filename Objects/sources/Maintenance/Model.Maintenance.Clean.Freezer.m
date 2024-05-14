(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Clean, Freezer], {
	Description->"Definition of a set of parameters for a maintenance protocol that cleans the exterior and interior surfaces of a freezer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FrostRemoval ->{
			Format->Single,
			Class-> Expression,
			Pattern:> BooleanP,
			Description-> "Indicates if frost buildup on door surface and seal should be regularily removed.",
			Category->"Cleaning",
			Developer->True
		},
		IceScraperModel-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part]|Model[Item],
			Description -> "The type of ice scraper used remove frost/ice from a surface.",
			Category -> "Cleaning",
			Developer->True
		},
		RubberMalletModel-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part]|Model[Item],
			Description -> "The type of rubber mallet used to strike a surface.",
			Category -> "Cleaning",
			Developer->True
		}
	}
}];
