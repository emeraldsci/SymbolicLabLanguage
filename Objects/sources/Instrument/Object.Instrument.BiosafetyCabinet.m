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
		DefaultBiosafetyWasteBinModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,WasteBin],
			Description -> "The model of the container that holds the BiosafetyWasteBag in order to collect biohazardous waste generated while working in this biosafety cabinet model.",
			Category -> "Instrument Specifications"
		},
		Pipettes->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Pipette],
			Description -> "The pipettes that permanently are kept inside of this biosafety cabinet.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Aspirator->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Aspirator],
			Description -> "The aspirator that is permanently kept inside of this biosafety cabinet.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Tips->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Tips],
			Description -> "The tips that permanently are kept inside of this biosafety cabinet.",
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
			Description -> "The vacuum pump that is connected to this biosafety cabinet.",
			Category -> "Instrument Specifications"
		},
		UVLamp -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Lamp],
			Description -> "The UV lamp(s) that are connected to this hood such that the work surfaces can be illuminated to excite the staining dye.",
			Category -> "Instrument Specifications"
		},
		BiosafetyWasteBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,WasteBin],
			Description -> "The waste bin that is kept under this biosafety cabinet for exclusive use while working in this BSC.",
			Category -> "General"
		}
	}
}];
