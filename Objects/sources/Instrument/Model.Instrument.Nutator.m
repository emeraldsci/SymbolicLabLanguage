(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Nutator], {
	Description->"Model for a device that gently agitates liquids via cyclical change in inclination around a vertical axis.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Mode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ShakerModeP,
			Description -> "Type of shaking the instrument provides.  Options include Swirling, Rocking, Rotating, or Orbital.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TemperatureControl -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Water | Air | None,
			Description -> "Type of temperature controller.  Options include: Water (for water bath), Air (for forced air circulation) or None.",
			Category -> "Instrument Specifications"
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Maximum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Minimum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the shaker can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the shaker can incubate.",
			Category -> "Operating Limits"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the shaker.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
