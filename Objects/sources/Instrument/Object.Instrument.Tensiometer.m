(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Tensiometer], {
	Description -> "A tensiometer instrument that determines the surface tension of liquids by measuring the forces required to pull rods out of them.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		(* --- Instrument specifications --- *)
		ManufacturerResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerResolution]],
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Description -> "The smallest magnitude between values of surface tension the instrument is capable of reporting as described by the instrument manufacturer in its product documentation.",
			Category -> "Instrument Specifications"
		},
		ManufacturerPrecision -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerPrecision]],
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Description -> "The amount a set of surface tension measurements deviates from the mean when measured by the instrument as described by the instrument manufacturer in its product documentation.",
			Category -> "Instrument Specifications"
		},
		ManufacturerBalanceResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerBalanceResolution]],
			Pattern :> GreaterP[0*Micro Gram],
			Description -> "The smallest magnitude between values of weight the instrument is capable of reporting as described by the instrument manufacturer in its product documentation.",
			Category -> "Instrument Specifications"
		},
		RecommendedVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RecommendedVolume]],
			Pattern :> GreaterP[0*Micro Liter],
			Description -> "The volume of the sample in each well needed to perform the experiment.",
			Category -> "Instrument Specifications"
		},
		MeasurementTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MeasurementTime]],
			Pattern :> GreaterP[0*Minute],
			Description -> "The amount of time it takes the instrument to measure a 96-well plate as described by the instrument manufacturer in its product documentation.",
			Category -> "Instrument Specifications"
		},
		TopDownCamera -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Camera],
			Description -> "The top camera monitoring the assay plate slot of this instrument.",
			Category -> "Instrument Specifications"
		},
		SideViewCamera -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Camera],
			Description -> "The side camera monitoring the assay plate slot of this instrument.",
			Category -> "Instrument Specifications"
		},
		(* --- Operating Limits --- *)
		MinSurfaceTensionMeasurement -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinSurfaceTensionMeasurement]],
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Description -> "The smallest surface tension value the instrument is able to detect as described by the instrument manufacturer in its product documentation.",
			Category -> "Operating Limits"
		},
		MaxSurfaceTensionMeasurement -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSurfaceTensionMeasurement]],
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Description -> "The largest surface tension value the instrument is able to detect as described by the instrument manufacturer in its product documentation.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Celsius],
			Description -> "The smallest temperature value the thermometer inside the instrument is able to detect as described by the instrument manufacturer in its product documentation. The temperature measurements are taken at the same time as surface tension measurements.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Celsius],
			Description -> "The largest temperature value the thermometer inside the instrument is able to detect as described by the instrument manufacturer in its product documentation. The temperature measurements are taken at the same time as surface tension measurements.",
			Category -> "Operating Limits"
		}
	}
}];
