(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, HandlingStation, BiosafetyCabinet], {
	Description->"A laminar flow cabinet to provide isolation of samples within from free circulating air in the room while recording useful metadata (e.g. videos and photographs) that contextualizes the events associated with transfers between samples.",
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
		DefaultBiosafetyWasteBinModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,WasteBin],
			Description -> "The model of the container that holds the BiosafetyWasteBag in order to collect biohazardous waste generated while working in this biosafety cabinet model.",
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
