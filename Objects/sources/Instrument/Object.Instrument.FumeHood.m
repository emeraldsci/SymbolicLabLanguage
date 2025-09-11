(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, FumeHood], {
	Description->"Ventilation device for working with potentially harmful chemical fumes and vapors.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> FumeHoodTypeP,
			Description -> "Type of fume hood it is.  Options include Benchtop for a standard hood, WalkIn for a large walk-in style hood, or Recirculating for a small unvented hood.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		PlumbingAvailable -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlumbingP,
			Description -> "List of items that are currently plumbed into the cabinet.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		FlowMeter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FlowMeter]],
			Pattern :> BooleanP,
			Description -> "Whether or not a flow meter is connected to the hood.",
			Category -> "Instrument Specifications"
		},
		LiquidWasteBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, WasteBin][FumeHood],
			Description -> "The liquid waste bin located on the work surface of this fume hood.",
			Category -> "Instrument Specifications"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the fume hood in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category -> "Dimensions & Positions"
		},
		SchlenkLine -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, SchlenkLine],
			Description -> "The Schlenk line that is contained within this instrument for backfill and vacuum purposes.",
			Category -> "Instrument Specifications"
		},
		IRProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature],
			Description -> "The IR temperature probe used to measure the temperature of samples transferred in this fume hood.",
			Category -> "Instrument Specifications"
		},
		ImmersionProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature],
			Description -> "The immersion probe used to measure the temperature of samples transferred in this fume hood.",
			Category -> "Instrument Specifications"
		}
	}
}];
