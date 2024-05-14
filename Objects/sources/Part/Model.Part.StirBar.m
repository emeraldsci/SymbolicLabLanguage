(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, StirBar], {
	Description->"Model information for a coated magnet used to stir liquids on a magnetic stirrer with a rotating magnetic field.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {		
		StirBarLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli Meter],
			Units-> Milli Meter,
			Description -> "The overall length of the stir bar.",
			Category -> "Dimensions & Positions"
		},
		StirBarWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :>GreaterP[0 Milli Meter],
			Units-> Milli Meter,
			Description -> "The outside diameter of the stir bar.",
			Category -> "Dimensions & Positions"
		},
		StirBarShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StirBarShapeP,
			Description -> "The shape of this model of stir bar in the Y-Z plane.",
			Category -> "Dimensions & Positions"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which this bar can handle.",
			Category -> "Compatibility"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which this bar can handle.",
			Category -> "Compatibility"
		},
		MicrowaveSafe -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this part can be safely used in a microwave or microwave reactor.",
			Category -> "Compatibility"
		}
	}
}];
