(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Roller], {
	Description->"Model of a device for agitating liquids via rolling (often while being incubated at set temperatures as well).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TemperatureControl -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Water | Air | None,
			Description -> "Type of temperature controller. Options include: Water (for water bath), Air (for forced air circulation) or None.",
			Category -> "Instrument Specifications"
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Maximum speed the instrument can rotate at.",
			Category -> "Operating Limits"
		},
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Minimum speed the instrument can rotate at.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the roller can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the roller can incubate.",
			Category -> "Operating Limits"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the roller.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		CompatibleRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack][CompatibleMixers],
			Description -> "The racks that can be used with this roller.",
			Category -> "Model Information"
		}
	}
}];
