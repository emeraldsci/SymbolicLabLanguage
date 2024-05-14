(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, OverheadStirrer], {
	Description->"Model of a device for stirring a sample from above with a rotating impeller.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		(* --- Instrument Specifications --- *)
		TemperatureControl -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TemperatureControlP,
			Description -> "Type of temperature controller.  Options include: Water (for water bath), Air (for forced air circulation), HotPlate (for a hot plate) or None.",
			Category -> "Instrument Specifications"
		},
		StirBarControl -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the device can rotate magnetic stir bars.",
			Category -> "Instrument Specifications"
		},
		CompatibleImpellers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, StirrerShaft][CompatibleMixers],
			Description -> "The impellers that can be used with this overhead stirrer.",
			Category -> "Model Information"
		},
		
		(* --- Operating Limits --- *)
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
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Minimum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Maximum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MinStirBarRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Minimum speed the instrument can rotate a stir bar.",
			Category -> "Operating Limits"
		},
		MaxStirBarRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Maximum speed the instrument can rotate a stir bar.",
			Category -> "Operating Limits"
		},
		
		(* --- Dimensions and Positions --- *)
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the incubator.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}

	}
}];
