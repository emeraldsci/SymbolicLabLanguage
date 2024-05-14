(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Replace, Seals], {
	Description->"Definition of a set of parameters for a maintenance protocol that replaces seals on an LC instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CleaningSolventModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of liquid used to clean the pump heads and wash the seals.",
			Category -> "General",
			Abstract->True
		},
		RinseContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container that holds the CleaningSolvent.",
			Category -> "General",
			Developer->True
		},
		FillVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The amount of liquid to use in the beaker.",
			Category -> "General",
			Developer -> True
		},
		TargetPumps -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LCPumpP,
			IndexMatching->ReplacementParts,
			Description -> "For each member of ReplacementParts, the specific pumps to replace on the LC instruments.",
			Category -> "General"
		},
		BufferModel -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			IndexMatching->ReplacementParts,
			Description -> "For each member of ReplacementParts, the model of liquid used to break in the pump seals after the installation is complete for the respective pump.",
			Category -> "General",
			Abstract->True
		},
		ContainerModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			IndexMatching->ReplacementParts,
			Description -> "For each member of ReplacementParts, the model of container used to liquid used to break in the pump seals after the installation is complete for the respective pump.",
			Category -> "General"
		}
	}
}];
