(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Clean, ESISource], {
	Description->"Definition of a set of parameters for a maintenance protocol that cleans mass spectrometry electrospray ionization (ESI) sources.",
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
		}
	}
}];
