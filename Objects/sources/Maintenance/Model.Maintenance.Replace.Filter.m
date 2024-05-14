(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Replace, Filter], {
	Description->"Definition of a set of parameters for a maintenance protocol that replaces filters on the maintenance target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FilterActivationLiquid -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of liquid used to chemically activate filter prior to the replacement.",
			Category -> "General",
			Abstract->True
		},
		ActivationLiquidContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container that holds the FilterActivationLiquid.",
			Category -> "General",
			Developer->True
		},
		ActivationLiquidVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The volume of liquid used to activate filters.",
			Category -> "General",
			Developer -> True
		},
		Preactivation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the replacement filter needs to be chemically activated prior to installation.",
			Category -> "General"
		}
	}
}];
