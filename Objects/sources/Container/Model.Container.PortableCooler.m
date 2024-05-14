(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, PortableCooler], {
	Description -> "A model of a portable cooler used to transport samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinIncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature the portable cooler can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxIncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature the portable cooler can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},	
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0 Meter],GreaterP[0 Meter],GreaterP[0 Meter]},
			Units -> {Meter,Meter,Meter},
			Headers -> {"Width","Depth","Height"},
			Description -> "The dimensions of the space inside the portable cooler.",
			Category -> "Dimensions & Positions"
		}
	}
}];
