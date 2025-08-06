(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, PortableCooler], {
	Description -> "The model for portable cold incubators used for sample storage when samples must be transported or manipulated at a specified temperature outside of a freezer or refrigerator.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0 * Meter], GreaterP[0 * Meter], GreaterP[0 * Meter]},
			Units -> {Meter, Meter, Meter},
			Description -> "The size of the space inside the freezer.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)", "Y Direction (Depth)", "Z Direction (Height)"}
		},
		StoragePhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NitrogenStoragePhaseP,
			Description -> "Indicates whether samples are stored in direct contact (Liquid) or indirect contact (Gas) with liquid nitrogen.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LiquidNitrogenCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Liter],
			Units -> Liter,
			Description -> "The maximum volume of liquid nitrogen that the freezer can be filled with.",
			Category -> "Operating Limits"
		},
		StaticEvaporationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0 * Liter) / Day],
			Units -> Liter / Day,
			Description -> "The rate of liquid nitrogen evaporation from from the freezer when closed.",
			Category -> "Operating Limits"
		}
	}
}];
