(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, SmokeGenerator], {
	Description->"Model information for a tool that generates smoke, primarily used to quality test air flow.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		GenerationMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SmokeMethodP,
			Description -> "Indicates the method with which smoke gets generated. Methods include the following
											WickBurning, A solid wick generates smoke through smoldering.
											WaterVapor, A boiler or atomizer turns a water based fuel into a cloud of vapor.
											OilVapor, A boiler or atomizer turns an oil based fuel into a cloud of vapor.
											ChemicalFumes, A chemical reaction is induced to create a steady stream of fumes.",
			Category -> "Model Information"
		},
		FuelType -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item,Consumable,Wick],Model[Sample]],
			Description -> "Types of fuel the generator consumes to create smoke. Cannot use anything other than the fuel sources allowed by the manufacturer.",
			Category -> "Model Information"
		},
		SelfIgniting -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of smoke generator is capable of igniting itself or starting up on its own.",
			Category -> "Model Information"
		},
		SmokeGenerationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> FlowRateP,
			Description -> "Indicates the volume of smoke the generator is rated to output over a period of time.",
			Category -> "Model Information"
		},
		ExposedWickLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter,
			Description -> "Indicates the length of wick that should be exposed in order to meet the expected smoke generation rate.",
			Category -> "Model Information"
		}
	}
}];