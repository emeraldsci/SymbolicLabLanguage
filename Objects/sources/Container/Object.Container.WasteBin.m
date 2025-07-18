(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, WasteBin], {
	Description->"A container which stores laboratory waste.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		WasteScale -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Weight sensor used by this waste bin to measure the waste fill level.",
			Category -> "Sensor Information",
			Developer -> True
		},
		WasteType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],WasteType]],
			Pattern :> WasteTypeP,
			Description -> "Type of waste this container holds.",
			Category -> "Container Specifications"
		},
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, FumeHood][LiquidWasteBin],
			Description -> "The fume hood on whose work surface this waste bin is permanently located.",
			Category -> "Container Specifications"
		},
		WasteContainerLabel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WasteContainerLabelP,
			Description -> "The label specifying the intended use of the waste container.",
			Category -> "Container Specifications",
			Developer -> True
		}
	}
}];
