(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, BiosafetyCabinet], {
	Description->"The model of a Laminar flow cabinet to provide isolation of samples within from free circulating air in the room.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		BiosafetyLevel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],BiosafetyLevel]],
			Pattern :> BiosafetyLevelP,
			Description -> "United States Centers for Disease Control and Prevention classification of containment level of the biosafety cabinet.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LaminarFlow -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],LaminarFlow]],
			Pattern :> GreaterP[0*(Foot/Minute)],
			Description -> "Laminar flow velocity of the cabinet.",
			Category -> "Instrument Specifications"
		},
		Benchtop -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Benchtop]],
			Pattern :> Metal | Epoxy,
			Description -> "Type of material the benchtop is made of.",
			Category -> "Instrument Specifications"
		},
		Plumbing -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Plumbing]],
			Pattern :> {PlumbingP..},
			Description -> "List of items plumbed into the cabinet.",
			Category -> "Instrument Specifications"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter]},
			Description -> "The size of space inside the biosafety cabinet in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category -> "Dimensions & Positions"
		},

		Pipettes->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Pipette],
			Description -> "The pipettes that permanently are kept inside of this glove box.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Aspirator->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Aspirator],
			Description -> "The aspirator that is permanently kept inside of this glove box.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Tips->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Tips],
			Description -> "The tips that permanently are kept inside of this glove box.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IRProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature],
			Description -> "The IR temperature probe that should be used to measure the temperature of any samples transferred in this biosafety cabinet.",
			Category -> "Instrument Specifications"
		},
		ImmersionProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature],
			Description -> "The immersion probe that should be used to measure the temperature of any samples transferred in this biosafety cabinet.",
			Category -> "Instrument Specifications"
		},
		VacuumPump->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,VacuumPump],
			Description -> "The vacuum pump that is connected to this BSC.",
			Category -> "Instrument Specifications"
		}
	}
}];
