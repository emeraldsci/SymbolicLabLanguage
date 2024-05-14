(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, SampleInspector], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a sample inspector.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		(* Method Information *)
		Standards ->  {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Standard models to be observed and measured during qualification.",
			Category -> "General",
			Abstract -> True
		},
		StandardContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "For each member of Standards, containers in which the standard models will be observed and measured during qualification.",
			Category -> "General",
			IndexMatching -> Standards
		},
		StandardVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of Standards, volume of standards that are used during this qualification.",
			Category -> "General",
			IndexMatching -> Standards
		}
	}
}];
