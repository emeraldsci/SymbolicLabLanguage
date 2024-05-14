(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Calibration, Bufferbot], {
	Description->"A calibration that relates physical quantities to machine axis units on a liquid handler of bufferbot type.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Target -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][CalibrationLog,2],
			Description -> "The designated object that this bufferbot calibration is intended to service.",
			Category -> "General"
		},
		
		SmallCylinderCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts volumes to cylinder positions for the 10ml cylinder.",
			Category -> "Experimental Results"
		},
		MediumCylinderCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts volumes to cylinder positions for the 100ml cylinder.",
			Category -> "Experimental Results"
		},
		LargeCylinderCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts volumes to cylinder positions for the 1000ml cylinder.",
			Category -> "Experimental Results"
		},
		MediumCylinderPressureCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts pressures to raw pressure sensor/regulator settings for the 100ml cylinder.",
			Category -> "Experimental Results"
		},
		LargeCylinderPressureCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts pressures to raw pressure sensor/regulator settings for the 1000ml cylinder.",
			Category -> "Experimental Results"
		},
		MediumPlungerVelocityCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts velocity settings to raw plunger movement velocity signal values for the 100ml cylinder.",
			Category -> "Experimental Results"
		},
		LargePlungerVelocityCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts velocity settings to raw plunger movement velocity signal values for the 1000ml cylinder.",
			Category -> "Experimental Results"
		},		
		SmallVesselpHProbeCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts raw sensor output to pH value for the small vessel's pH probe (15ml and 50ml tubes).",
			Category -> "Experimental Results"
		},		
		MediumVesselpHProbeCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts raw sensor output to pH value for the medium vessel's pH probe (0.25L to 5L).",
			Category -> "Experimental Results"
		},
		LargeVesselpHProbeCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that converts raw sensor output to pH value for the large vessel's pH probe (10L and 20L).",
			Category -> "Experimental Results"
		},		
		MediumCylinderLowPosition -> {
			Format -> Single,
			Class -> Integer,
			Pattern :>  GreaterP[0],
			Units -> None,
			Description -> "The raw value of the plunger position when at the bottom of the 100ml cylinder.",
			Category -> "Experimental Results"
		},
		LargeCylinderLowPosition -> {
			Format -> Single,
			Class -> Integer,
			Pattern :>  GreaterP[0],
			Units -> None,
			Description -> "The raw value of the plunger position when at the bottom of the 1000ml cylinder.",
			Category -> "Experimental Results"
		},
		MediumCylinderWashPosition -> {
			Format -> Single,
			Class -> Integer,
			Pattern :>  GreaterP[0],
			Units -> None,
			Description -> "The raw value of the 100ml plunger position when ready for washing.",
			Category -> "Experimental Results"
		},
		LargeCylinderWashPosition -> {
			Format -> Single,
			Class -> Integer,
			Pattern :>  GreaterP[0],
			Units -> None,
			Description -> "The raw value of the 1000ml plunger position when ready for washing.",
			Category -> "Experimental Results"
		},
		OverheadStirCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that relates a desired rotational frequency for the overhead stirrer to a raw sensor array signal for the stirrer motor.",
			Category -> "Experimental Results"
		},
		HeaterCalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :>  _Function|_QuantityFunction,
			Description -> "The pure function that represents the raw calibration fit between the reference and response data points for the heating plate used in a Liquid Handler of Bufferbot type.",
			Category -> "Experimental Results"
		}
	}
}];
