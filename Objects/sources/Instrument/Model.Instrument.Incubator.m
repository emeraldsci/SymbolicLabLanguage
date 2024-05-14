(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Incubator], {
	Description -> "Model of a device for culturing cells under specific environmental conditions.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		CellTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellTypeP,
			Description -> "The cell type that this model of incubators is designed to incubate.",
			Category -> "Instrument Specifications"
		},
		Mode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Manual | Robotic,
			Description -> "Indicates if this incubator is robotically integrated with a cell culture workcell.",
			Category -> "Instrument Specifications"
		},
		DefaultShakingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * RPM],
			Units -> RPM,
			Description -> "The default shaking speed the incubator is set to maintain.",
			Category -> "Instrument Specifications"
		},
		DefaultTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The default temperature the incubator is set to maintain.",
			Category -> "Instrument Specifications"
		},
		DefaultCarbonDioxide -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 * Percent, 100 * Percent],
			Units -> Percent,
			Description -> "The default carbon dioxide percentage the incubator is set to maintain.",
			Category -> "Instrument Specifications"
		},
		DefaultRelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 * Percent, 100 * Percent],
			Units -> Percent,
			Description -> "The default relative humidity the incubator is set to maintain.",
			Category -> "Instrument Specifications"
		},
		ShakingRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Meter],
			Units -> Millimeter,
			Description -> "The radius of the circle traced by each shaker unit during orbital shaking.",
			Category -> "Instrument Specifications"
		},
		MinShakingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * RPM],
			Units -> RPM,
			Description -> "Minimum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MaxShakingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * RPM],
			Units -> RPM,
			Description -> "Maximum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MinCarbonDioxide -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 * Percent, 100 * Percent],
			Units -> Percent,
			Description -> "Minimum Carbon dioxide percentage the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MaxCarbonDioxide -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 * Percent, 100 * Percent],
			Units -> Percent,
			Description -> "Maximum Carbon dioxide percentage the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MinRelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 * Percent, 100 * Percent],
			Units -> Percent,
			Description -> "Minimum relative humidity the incubator can maintain.",
			Category -> "Operating Limits"
		},
		MaxRelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 * Percent, 100 * Percent],
			Units -> Percent,
			Description -> "Maximum relative humidity the incubator can maintain.",
			Category -> "Operating Limits"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0 * Meter], GreaterP[0 * Meter], GreaterP[0 * Meter]},
			Units -> {Meter, Meter, Meter},
			Description -> "The size of the space inside the incubator.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)", "Y Direction (Depth)", "Z Direction (Height)"}
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the tubing connecting the CarbonDioxide in millimeters.",
			Category -> "Dimensions & Positions"
		}
	}
}];