(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument,CondensateRecirculator], {
	Description->"A model of instrument that supplies water to another instrument and recycles water condensation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Capacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The maximum volume that the reservoir can be filled to.",
			Category -> "General"
		},
		FillLiquidModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of liquid that is used to fill the reservoir.",
			Category -> "General",
			Abstract -> True
		}
	}
}];
