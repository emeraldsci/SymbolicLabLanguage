(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Tensiometer], {
	Description -> "Model of a tensiometer instrument that determines the surface tension of liquids by measuring the forces required to pull rods out of them.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* --- Instrument specifications --- *)
		ManufacturerResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Units -> Milli Newton/Meter,
			Description -> "The smallest magnitude between values of surface tension the instrument is capable of reporting as described by the instrument manufacturer in its product documentation.",
			Category -> "Instrument Specifications"
		},
		ManufacturerPrecision -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Units -> Milli Newton/Meter,
			Description -> "The amount a set of surface tension measurements deviates from the mean when measured by the instrument as described by the instrument manufacturer in its product documentation.",
			Category -> "Instrument Specifications"
		},
		ManufacturerBalanceResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro Gram],
			Units -> Micro Gram,
			Description -> "The smallest magnitude between values of weight the instrument is capable of reporting as described by the instrument manufacturer in its product documentation.",
			Category -> "Instrument Specifications"
		},
		RecommendedVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro Liter],
			Units -> Micro Liter,
			Description -> "The volume of the sample in each well needed to perform the experiment.",
			Category -> "Instrument Specifications"
		},
		MeasurementTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The amount of time it takes the instrument to measure a 96-well plate as described by the instrument manufacturer in its product documentation.",
			Category -> "Instrument Specifications"
		},
		(* --- Operating Limits --- *)
		MinSurfaceTensionMeasurement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Units -> Milli Newton/Meter,
			Description -> "The smallest surface tension value the instrument is able to detect as described by the instrument manufacturer in its product documentation.",
			Category -> "Operating Limits"
		},
		MaxSurfaceTensionMeasurement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Units -> Milli Newton/Meter,
			Description -> "The largest surface tension value the instrument is able to detect as described by the instrument manufacturer in its product documentation.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The smallest temperature value the thermometer inside the instrument is able to detect as described by the instrument manufacturer in its product documentation. The temperature measurements are taken at the same time as surface tension measurements.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The largest temperature value the thermometer inside the instrument is able to detect as described by the instrument manufacturer in its product documentation. The temperature measurements are taken at the same time as surface tension measurements.",
			Category -> "Operating Limits"
		}
	}
}];
