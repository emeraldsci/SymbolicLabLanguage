(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, PortableHeater], {
	Description -> "A portable heater used to transport heated samples.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature the portable heater defaults to when it is turned on.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinIncubationTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperature]],
			Pattern :> GreaterP[0 Kelvin],
			Description -> "The minimum temperature the portable heater can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxIncubationTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
			Pattern :> GreaterP[0 Kelvin],
			Description -> "The maximum temperature the portable heater can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
			Pattern :>  {GreaterP[0 Meter],GreaterP[0 Meter],GreaterP[0 Meter]},
			Description ->  "The size of the space inside the portable heater in {X (left-to-right), Y (back-to-front), Z (bottom-to-top)} directions.",
			Category -> "Dimensions & Positions"
		},
		Inverter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,Inverter]],
			Description -> "The inverter that is currently installed on this portable heater.",
			Category -> "Instrument Specifications",
			Abstract -> True
		}
	}
}];
