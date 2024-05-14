(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Shaker], {
	Description->"Device for agitating liquids via orbital shaking (often while incubating at set temperatures as well).",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> ShakerModeP,
			Description -> "Type of shaking motion the instrument provides.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TemperatureControl -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TemperatureControl]],
			Pattern :> Water | Air | None,
			Description -> "Type of temperature controller weither by forecd air or using a contact solution.",
			Category -> "Instrument Specifications"
		},
		COMPort -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The serial port number that the instrument is connected to on the Instrument PC.",
			Category -> "Instrument Specifications"
		},
		MinRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "Minimum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "Maximum speed the instrument can shake at.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the shaker can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the shaker can incubate.",
			Category -> "Operating Limits"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the shaker in the X (left-to-right), Y (back-to-front), Z (bottom-to-top)} directions.",
			Category -> "Dimensions & Positions"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedShakers],
			Description -> "The liquid handler that is connected to this shaker such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		IntegratedSampleInspector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, SampleInspector][IntegratedAgitator],
			Description -> "The sample inspector that is contains this shaker such that samples can be agitated using the shaker and imaged by the sample inspector.",
			Category -> "Integrations"
		}
	}
}];
