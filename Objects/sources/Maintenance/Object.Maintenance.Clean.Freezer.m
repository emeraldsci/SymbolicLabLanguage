(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Clean, Freezer], {
	Description->"A protocol that cleans the exterior and interior surface of a freezer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		IceScraper-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part],
				Model[Part],
				Object[Item],
				Model[Item]
			], (*TODO removed after item migration*)
			Description -> "Indicates the ice scraper used to remove frost/ice from a surface.",
			Category -> "Cleaning",
			Developer->True
		},
		RubberMallet-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part],
				Model[Part],
				Object[Item],
				Model[Item]
			],(*TODO removed after item migration*)
			Description -> "Indicates the rubber mallet used to strike a surface.",
			Category -> "Cleaning",
			Developer->True
		}
	}
}];
