(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, BubbleLog], {
	Description->"Air bubbles measured detected as a function of date and time by a bubble counter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		FirstDataPoint -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date of the first data point in this object.",
			Category -> "General",
			Abstract -> True
		},
		LastDataPoint -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date of the last data point in this object.",
			Category -> "General",
			Abstract -> True
		},
		DailyLog -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the sensor using a function called RecordSensor.",
			Category -> "General"
		},
		BubbleLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> ECL`DateCoordinatesComparisonP[GreaterEqualP[0]],
			Units -> {None, None},
			Description -> "Bubble as they appear vs date/time during the course of an experiment or single data point.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
			Relation -> {Object[Calibration, Sensor],Null},
			Units -> {None, None},
			Description -> "Maintenance objects and associated raw bubble count vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		BubbleCountStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The calculated standard deviation for this data.",
			Category -> "Data Processing",
			Abstract -> True
		},
		BubbleCountDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[],
			Description -> "The empirical distribution based on this data.",
			Category -> "Data Processing"
		},
		TotalBubbleCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Total bubbles detected over the course of an experiment or single data point.",
			Category -> "Data Processing",
			Abstract -> True
		}
	}
}];
