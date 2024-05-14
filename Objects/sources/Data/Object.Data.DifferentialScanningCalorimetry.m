
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Data, DifferentialScanningCalorimetry], {
	Description -> "Measurements from a capillary-based differential scanning calorimetery experiment that provide a curve of heat flux as a function of temperature for a sample.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		StartTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the sample is held prior to heating.",
			Category -> "General"
		},
		EndTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The temperature to which the sample is heated in the course of the experiment.",
			Category -> "General"
		},
		TemperatureRampRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Celsius / Hour],
			Units -> Celsius / Hour,
			Description -> "The rate at which the temperature increased in the course of each heating cycle.",
			Category -> "General"
		},
		NumberOfScans -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of heating cycles applied to this data's sample.",
			Category -> "General"
		},
		RescanCoolingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Celsius / Hour],
			Units -> Celsius / Hour,
			Description -> "The rate at which the temperature decreases between cycles if NumberOfScans > 1.",
			Category -> "General"
		},
		HeatingCurves -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius, Kilo * Calorie / Celsius}],
			Units -> {Celsius, Kilo * Calorie / Celsius},
			Description -> "The thermodynamic data readout of heat flux of the sample as a function of temperature.",
			Category -> "Experimental Results"
		},
		MolarHeatingCurves -> {
			Format -> Multiple,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Celsius, Kilo * Calorie / (Mole * Celsius)}],
			Units -> {Celsius, Kilo * Calorie / (Celsius * Mole)},
			Description -> "For each member of HeatingCurves, the thermodynamic data readout of heat flux per mole of sample as a function of temperature.  Heat flux per mole is calculated by dividing the heat flux given in the HeatingCurves field by the sample's concentration.",
			Category -> "Experimental Results",
			IndexMatching -> HeatingCurves
		},
		HeatingCurvePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A list of peak picking analyses conducted on this thermodynamic data.",
			Category -> "Analysis & Reports"
		},
		SmoothingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Smoothing analysis performed on this data.",
			Category -> "Analysis & Reports"
		},
		Analyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Differential scanning calorimetry analysis performed on this data.",
			Category -> "Analysis & Reports"
		}
	}
}];
