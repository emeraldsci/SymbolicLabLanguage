

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, HeatExchanger], {
	Description->"Model information for a heat exchanging pump used to help control the temperature of a sample-holding chamber.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		FluidVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "Amount of heat transfer fluid needed to fill the pump.",
			Category -> "Instrument Specifications"
		},
		FillFluid -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The chemical used by the heat exchanger as heat transfer fluid.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the heat exchanger can provide to its connected instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the heat exchanger can provide to its connected instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperatureRamp -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Celsius)/Minute],
			Units -> Celsius/Minute,
			Description -> "Maximum rate at which the heat exchanger can change temperature.",
			Category -> "Operating Limits"
		}
	}
}];
