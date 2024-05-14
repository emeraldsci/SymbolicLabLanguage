(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, PortableHeater], {
	Description->"The model for portable heated incubators used for sample storage when samples must be transported or manipulated at a specified temperature outside of an oven.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :>  {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the freezer.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
