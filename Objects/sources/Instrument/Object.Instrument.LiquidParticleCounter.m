(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, LiquidParticleCounter], {
	Description -> "A high accuracy liquid particle counter.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		(* --- Instrument Specifications ---*)
		LightObscurationSensor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> HIACSensorsP, (*LightObscurationSensorsP:=LightObscurationSensor400Micrometer|LightObscurationSensor100Micrometer*)
			Description -> "The light obscuration sensor that measures the reduction in light intensity and processes the signal to determine particle size and count.",
			Category -> "Instrument Specifications"
		},
		SamplingProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, SamplingProbe][ConnectedInstrument],
			Description -> "The SamplingProbe install on the instrument.",
			Category -> "Instrument Specifications"
		},
		Syringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Syringe],
			Description -> "The syringe installed on the instrument sampler when the instrument is not in use.",
			Category -> "Instrument Specifications"
		},
		ProbeStorageContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container with dionized water to store and protect the probe when experiments are done.",
			Category -> "Instrument Specifications"
		},
		(* --- Operating Limits --- *)
		MinParticleSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinParticleSize]],
			Pattern :> GreaterP[0*Micrometer],
			Description -> "Minimum particle size the instrument can detect. Additional constraints can be placed by the light obscuration sensor.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxParticleSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxParticleSize]],
			Pattern :> GreaterP[0*Micrometer],
			Description -> "Maximum particle size the instrument can detect. Additional constraints can be placed by the light obscuration sensor.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinSampleTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinSampleTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature instrument can incubate sample.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSampleTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxSampleTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature instrument can incubate sample.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinSampleVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinSampleVolume]],
			Pattern :> GreaterP[0*Milliliter],
			Description -> "Minimum sample volume including dead volume of sample required to provide the instrument with enough of volume to measure particle count.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		(*-------------------*)
		MaxSyringeVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxSyringeVolume]],
			Pattern :> GreaterP[0*Milliliter],
			Description -> "Maximum capacity of the syringe pump used to dispense the fluid.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinSyringeFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinSyringeFlowRate]],
			Pattern :> GreaterP[0*Milliliter/ Minute],
			Description -> "The minimum flow rate of syringe when aspirating or dispensing.",
			Category -> "Operating Limits"
		},
		MaxSyringeFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxSyringeFlowRate]],
			Pattern :> GreaterP[0*Milliliter/ Minute],
			Description -> "The maximum flow rate of syringe when aspirating or dispensing.",
			Category -> "Operating Limits"
		},
		MinStirRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinStirRate]],
			Pattern :> GreaterEqualP[0*RPM],
			Description -> "The slowest rotational speed at which the integrated stir plate can operate.",
			Category -> "Operating Limits"
		},
		MaxStirRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxStirRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The fastest rotational speed at which the integrated stir plate can operate.",
			Category -> "Operating Limits"
		},
		RecirculatingPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument,RecirculatingPump],Object[Instrument, RecirculatingPump]],
			Description -> "The pump that chills or heats fluid and flows it through the temperature control column in order to regulate the temperature during the experiment.",
			Category -> "Instrument Specifications"
		},
		ProbeTopPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The distance number reading from the ruler when moving the probe to the topmost position.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		ProbeLowPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The distance number reading from the ruler when moving the probe to the bottommost position.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
