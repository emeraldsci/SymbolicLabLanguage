(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Spectrophotometer], {
	Description->"UV/Vis Spectrophotometer which generates absorbance spectra of cuvettes.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		LampType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LampType]],
			Pattern :> LampTypeP,
			Description -> "Type of lamp that the instrument uses as a light source.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LightSourceType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LightSourceType]],
			Pattern :> LightSourceTypeP,
			Description -> "Specifies whether the instrument lamp provides continuous light or if it is flashed at time of acquisition.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Stirring -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Stirring]],
			Pattern :> BooleanP,
			Description -> "Whether or not magnetic stirring is available to the unit.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		NumberOfTemperatureProbes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],NumberOfTemperatureProbes]],
			Pattern :> GreaterP[0, 1],
			Description -> "Number of temperature probes available to the unit.",
			Category -> "Instrument Specifications"
		},
		BeamOffset -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],NumberOfTemperatureProbes]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The distance from the bottom of the cuvette holder to the point at which the laser beam hits the cuvette. This should correspond with the window offset (Z-height) on the cuvette in use.",
			Category -> "Container Specifications"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the spectrophotometer can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the spectrophotometer can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperatureRamp -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperatureRamp]],
			Pattern :> GreaterP[(0*Celsius)/Minute],
			Description -> "Maximum rate at which the spectrophotometer can change temperature.",
			Category -> "Operating Limits"
		},
		MinMonochromator -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinMonochromator]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Monochromator minimum wavelength for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxMonochromator -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxMonochromator]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Monochromator maximum wavelength for absorbance filtering.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MonochromatorBandpass -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MonochromatorBandpass]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Monochromator bandpass for absorbance filtering.",
			Category -> "Operating Limits"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Internal diameter of the purge tubing that connects nitrogen to the instrument.",
			Category -> "Dimensions & Positions"
		},
		PurgePressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Pressure sensor used by this instrument to measure the purge pressure.",
			Category -> "Sensor Information"
		},
		SampleModule -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SpectrophotometerModuleP,
			Description -> "Specifies the type of sample module connected to the instrument.",
			Category -> "Instrument Specifications"
		},
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The preferred, proximal device used to weigh the sample.",
			Category -> "Instrument Specifications"
		},
		IntegratedHeatExchanger -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,HeatExchanger][IntegratedInstrument],
			Description -> "The heat exchanger that helps to regulate the temperature of this instrument via circulating chilled or heated fluid.",
			Category -> "Integrations"
		},
		PurgeGasTankPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The sensor reading the pressure of the purge gas supply tank.",
			Category -> "Sensor Information"
		},
		PurgeGasDeliveryPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The sensor reading the delivery pressure of the purge gas.",
			Category -> "Sensor Information"
		}
	}
}];
