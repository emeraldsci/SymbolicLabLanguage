(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, ConductivityMeter], {
	Description->"A device for high precision measurement of electrical conductivity of solutions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Instrument Specifications ---*)
		NumberOfChannels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of channels available for simultaneous measurements on the instrument.",
			Category -> "Instrument Specifications"
		},
		MeterModule -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, MeterModule][Instrument],
			Description -> "The model of module part which can be installed on this meter to expand its capability.",
			Category -> "Instrument Specifications"
		},
		ManufacturerConductivityResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> Micro Siemens/Centimeter,
			Description -> "The smallest change in conductivity that corresponds to a change in displayed value.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ManufacturerConductivityAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent ,
			Description -> "The expected standard deviation of a calibrated temperature measurement result under ideal conditions.", (*TODO:finde the descroption*)
			Category -> "Instrument Specifications",
			Abstract-> True
		},
		ManufacturerTemperatureResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The smallest change in temperature that corresponds to a change in displayed value.",
			Category -> "Instrument Specifications"
		},
		ManufacturerTemperatureAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The accuracy of a calibrated temperature measurement result under ideal conditions.", (*fine definition*)
			Category -> "Instrument Specifications"
		},
		(* --- Operating Limits ---*)
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the instrument can perform a measurement at.This can be further limited by the conductivity probe MinTemperature.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the instrument can perform a measurement at. This can be further limited by the conductivity probe MaxTemperature.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinConductivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Siemens /(Centimeter)],
			Description -> "Minimum conductivity this meter can measure. This can be further limited by the conductivity probe MinConductivity.",
			Units -> Milli Siemens /(Centimeter),
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxConductivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Siemens /(Centimeter)],
			Description -> "Maximum conductivity this meter can measure. This can be further limited by the conductivity probe MaxConductivity.",
			Units -> Milli Siemens /(Centimeter),
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
