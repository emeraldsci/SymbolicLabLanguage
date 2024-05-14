(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Viscometer], {
	Description->"A viscometer instrument that determines the viscosity of liquids by measuring the pressure drop across a flow channel.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		(* --- Instrument specifications --- *)
		ViscometerChip-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, ViscometerChip][Instrument],
			Description -> "The microfluidic rectangular slit chip that is currently installed in the instrument and used for measuring viscosity of samples.",
			Category -> "Instrument Specifications"
		},
		MeasurementChipMinTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MeasurementChipMinTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"Minimum temperature at which the viscometer can hold the samples during viscosity measurements in the measurement chip.",
			Category->"Operating Limits"
		},
		MeasurementChipMaxTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MeasurementChipMaxTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"Maximum temperature at which the viscometer can hold the samples during viscosity measurements in the measurement chip.",
			Category->"Operating Limits"
		},
		MinFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinFlowRate]],
			Pattern:>GreaterP[(0*Micro*Liter)/Minute],
			Description->"The minimum flow rate at which the instrument can inject sample into the measurement channel.",
			Category->"Operating Limits"
		},
		MaxFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxFlowRate]],
			Pattern:>GreaterP[(0*Micro*Liter)/Minute],
			Description->"The maximum flow rate at which the instrument can inject sample into the measurement channel.",
			Category->"Operating Limits"
		},
		AutosamplerSyringeMaxVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],AutosamplerSyringeMaxVolume]],
			Pattern:>GreaterP[0*Microliter],
			Description->"Maximum volume of the autosampler syringe.",
			Category->"Operating Limits"
		},
		ChipSyringeMaxVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ChipSyringeMaxVolume]],
			Pattern:>GreaterP[0*Microliter],
			Description->"Maximum volume of the syringe used to inject sample into the measurement chip.",
			Category->"Operating Limits"
		},
		InjectionVolumes->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],InjectionVolumes]],
			Pattern:>{GreaterP[0*Liter*Micro]..},
			Description->"The possible volumes of sample that can be injected into the measurement chip.",
			Category->"Operating Limits"
		},
		SampleTrayMinTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SampleTrayMinTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"Minimum temperature of the autosampler tray where the samples in the autosampler deck are stored while awaiting measurement.",
			Category->"Operating Limits"
		},
		SampleTrayMaxTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SampleTrayMaxTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"Minimum temperature of the autosampler tray where the samples in the autosampler deck are stored while awaiting measurement.",
			Category->"Operating Limits"
		},
		MinSampleVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinSampleVolume]],
			Pattern :>GreaterP[0*Milli*Liter],
			Description->"The minimum required sample volume needed for instrument measurement.",
			Category->"Instrument Specifications"
		},
		MinViscosity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinViscosity]],
			Pattern :>GreaterP[0*Pascal*Second],
			Description->"The minimum viscosity that can be measured with the instrument.",
			Category->"Instrument Specifications"
		},
		MaxViscosity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxViscosity]],
			Pattern :>GreaterP[0*Pascal*Second],
			Description->"The maximum viscosity that can be measured with the instrument.",
			Category->"Instrument Specifications"
		},
		PrimaryCleaningSolventBottle->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container]|Model[Container],
			Description->"The 500 ml bottle containing a primary cleaning solution that resides on the instrument.",
			Category->"Container Specifications",
			Developer->True
		},
		SecondaryCleaningSolventBottle->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container]|Model[Container],
			Description->"The 250 ml bottle containing a secondary cleaning solution that resides on the instrument.",
			Category->"Container Specifications",
			Developer ->True
		},
		TertiaryCleaningSolventBottle->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container]|Model[Container],
			Description->"The 250 ml bottle containing a tertiary cleaning solution that resides on the instrument.",
			Category->"Container Specifications",
			Developer ->True
		},
		PrimaryCleaningSolventBottleCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate PrimaryBuffer during this protocol.",
			Category -> "Container Specifications",
			Developer->True
		},
		SecondaryCleaningSolventBottleCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate SecondaryCleaningSolvent during this protocol.",
			Category -> "Container Specifications",
			Developer->True
		},
		TertiaryCleaningSolventBottleCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate TertiaryCleaningSolvent during this protocol.",
			Category -> "Container Specifications",
			Developer->True
		},
		TubingOuterDiameter->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],TubingOuterDiameter]],
			Pattern:>GreaterP[0*Meter],
			Description->"Internal diameter of the tubing that connects to the instrument.",
			Category->"Dimensions & Positions"
		},
		ViscometerChipWrench->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Wrench],
			Description->"The wrench used to secure the connections between the sample flow path tubing and the viscometer chip.",
			Category->"Item Specifications"
		},
		ViscometerChipTweezers->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Tweezer],
			Description->"A pair of tweezers dedicated for operations on the viscometer instrument.",
			Category->"Item Specifications"
		}
	}
}];
