(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Refractometer], {
	Description -> "The model for a refractometer instrument used to measure the refractive index (RI) of a liquid compound using light source, prism and a Charge-coupled Device (CCD) to identify the critical angle where total reflection occurs at the prism-sample interface. Once the critical angle is obtained, RI can be calculated using Snells' law (n1 = n2 * Sin[C] where n1 = refractive index of sample, n2 = refractive index of prism, C = critical angle).",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		MeasuringWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nanometer],
			Units-> Nanometer,
			Description -> "The specific wavelength that the instrument uses to measure the refractive index.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units-> Celsius,
			Description -> "The minimum temperature that the instrument can control.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units-> Celsius,
			Description -> "The maximum temperature that the instrument can control.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TemperatureResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units-> Celsius,
			Description -> "The smallest detectable increment of temperature on the instrument.",
			Category -> "Instrument Specifications"
		},
		TemperatureAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units-> Celsius,
			Description -> "The accuracy of temperature read on the instrument.",
			Category -> "Instrument Specifications"
		},
		TemperatureStability -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units-> Celsius,
			Description -> "The possible error of temperature read on the instrument.",
			Category -> "Instrument Specifications"
		},
		MinRefractiveIndex -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> None,
			Description -> "The smallest possible measurement of the refractive index on the instrument.",
			Category ->  "Operating Limits",
			Abstract -> True
		},
		MaxRefractiveIndex -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> None,
			Description -> "The largest possible measurement of the refractive index on the instrument.",
			Category ->  "Operating Limits",
			Abstract -> True
		},
		RefractiveIndexResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> None,
			Description -> "The smallest detectable increment of the refractive index on the instrument.",
			Category -> "Instrument Specifications"
		},
		RefractiveIndexAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> None,
			Description -> "The accuracy of the refractive index measurement on the instrument.",
			Category -> "Instrument Specifications"
		},
		MinSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units-> Microliter,
			Description -> "The minimum required sample volume to measure the refractive index.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
