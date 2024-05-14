(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Refractometer], {
	Description->"The refractometer instrument used to measure the refractive index (RI) of a liquid compound using light source, prism and a Charge-coupled Device (CCD) to identify the critical angle where total reflection occurs at the prism-sample interface. Once the critical angle is obtained, RI can be calculated using Snells' law (n1 = n2 * Sin[C] where n1 = refractive index of sample, n2 = refractive index of prism, C = critical angle).",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MeasuringWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MeasuringWavelength]],
			Pattern :> GreaterP[0 Nanometer],
			Description -> "The specific wavelength that the instrument uses to measure the refractive index.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperature]],
			Pattern :> GreaterP[0 Celsius],
			Description -> "The minimum temperature that the instrument can control.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
			Pattern :> GreaterP[0 Celsius],
			Description -> "The maximum temperature that the instrument can control.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TemperatureResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], TemperatureResolution]],
			Pattern :> GreaterP[0 Celsius],
			Description -> "The smallest detectable increment of temperature on the instrument.",
			Category -> "Instrument Specifications"
		},
		TemperatureAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], TemperatureAccuracy]],
			Pattern :> GreaterP[0 Celsius],
			Description -> "The accuracy of temperature read on the instrument.",
			Category -> "Instrument Specifications"
		},
		TemperatureStability -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], TemperatureStability]],
			Pattern :> GreaterP[0 Celsius],
			Description -> "The possible error of temperature read on the instrument.",
			Category -> "Instrument Specifications"
		},
		MinRefractiveIndex -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinRefractiveIndex]],
			Pattern :> GreaterP[0],
			Description -> "The smallest possible measurement of the refractive index on the instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxRefractiveIndex -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxRefractiveIndex]],
			Pattern :> GreaterP[0],
			Description -> "The largest possible measurement of the refractive index on the instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		RefractiveIndexResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], RefractiveIndexResolution]],
			Pattern :> GreaterP[0],
			Description -> "The smallest possible measurement of the refractive index on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		RefractiveIndexAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], RefractiveIndexAccuracy]],
			Pattern :> GreaterP[0],
			Description -> "The smallest possible measurement of the refractive index on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinSampleVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinSampleVolume]],
			Pattern :> GreaterP[0],
			Description -> "The smallest possible measurement of the refractive index on the instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
