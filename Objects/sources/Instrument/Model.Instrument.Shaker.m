(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Shaker], {
	Description->"Model of a device for agitating liquids via orbital shaking (often while incubating at set temperatures as well).",
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
			Pattern :> TemperatureControlP,
			Description -> "Type of temperature controller.  Options include: Water (for water bath), Air (for forced air circulation) or None.",
			Category -> "Instrument Specifications"
		},
		ProgrammableTemperatureControl -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the mixer supports the specification of a temperature profile.",
			Category -> "Instrument Specifications"
		},
		ProgrammableMixControl -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the mixer supports the specification of a mix rate profile.",
			Category -> "Instrument Specifications"
		},
		OrbitDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of the circular orbit followed by this shaker's platform when it is shaking.",
			Category -> "Instrument Specifications"
		},
		MaxForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The maximum acceleration the instrument can constantly apply to the sample being mixed. Acceleration is normalized to the force of gravity on Earth (10g is 10X the gravitational acceleration on Earth).",
			Category -> "Operating Limits"
		},
		MinForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The minimum acceleration the instrument can constantly apply to the sample being mixed. Acceleration is normalized to the force of gravity on Earth (10g is 10X the gravitational acceleration on Earth).",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The maximum number of shaking revolutions that the instrument can complete in a minute.",
			Category -> "Operating Limits"
		},
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The minimum number of shaking revolutions that the instrument can complete in a minute.",
			Category -> "Operating Limits"
		},
		MaxOscillationAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*AngularDegree],
			Units -> AngularDegree,
			Description -> "Maximum angle (in degrees) of oscillation that can occur when wrist-action shaking.",
			Category -> "Operating Limits"
		},
		MinOscillationAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*AngularDegree],
			Units -> AngularDegree,
			Description -> "Minimum angle (in degrees) of oscillation that can occur when wrist-action shaking.",
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
		GripperDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The maximum diameter of the shaker clamp's mouth, which will fit over the neck of glassware or outer diameter of tubing.",
			Category -> "Dimensions & Positions"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the shaker.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		CompatibleAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, ShakerAdapter][CompatibleMixers],
			Description -> "The shaker adapters that can be used with this shaker.",
			Category -> "Model Information"
		}
	}
}];
