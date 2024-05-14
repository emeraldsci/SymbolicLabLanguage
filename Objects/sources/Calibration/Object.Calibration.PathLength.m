

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Calibration, PathLength], {
	Description->"A calibration that relates measured absorbance of a sample to its vertical path length in a microtiter plate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		LiquidLevelDetector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidLevelDetector],
			Description -> "The liquid level detector instrument that generated the distance data used in this calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		PlateReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, PlateReader],
			Description -> "The plate reader that generated the absorbance data used in this calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		PlateModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Plate],
			Description -> "The model of plate used during this absorbance-to-path length calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample]
			],
			Description -> "The model of buffer used during this path length calibration.",
			Category -> "Calibration Parameters",
			Abstract -> True
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler],
			Description -> "The liquid handler instrument that pipetted the standard volumes for calibration.",
			Category -> "Calibration Parameters"
		}
	}
}];
