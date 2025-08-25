(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, HandlingStation, BiosafetyCabinet], {
	Description->"The model of a Laminar flow cabinet to provide isolation of samples within from free circulating air in the room while recording useful metadata (e.g. videos and photographs) that contextualizes the events associated with transfers between samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BiosafetyLevel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BiosafetyLevelP,
			Description -> "United States Centers for Disease Control and Prevention classification of containment level of the biosafety cabinet.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Benchtop -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Metal | Epoxy,
			Description -> "Type of material the benchtop is made of.",
			Category -> "Instrument Specifications"
		},
		DefaultBiosafetyWasteBinModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, WasteBin],
			Description -> "The model of the biosafety waste bin that holds the BiosafetyWasteBag in order to collect biohazardous waste generated while working in this biosafety cabinet model.",
			Category -> "Instrument Specifications"
		}
	}
}];
