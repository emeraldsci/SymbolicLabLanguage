(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Moisture], {
	Description->"Moisture level measured as a function of date and time by an moisture sensor.",
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
			Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the moisture sensor using a function called RecordSensor.",
			Category -> "General"
		},
		MoistureLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None,PPM}],
			Units -> {None, PPM},
			Description -> "Trace of moisture level vs date/time during the course of an experiment or single data point.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
			Relation -> {Object[Calibration, Sensor],Null},
			Units -> {None, None},
			Description -> "Maintenance objects and associated raw moisture level vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		MoistureStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PPM],
			Units -> PPM,
			Description -> "The calculated standard deviation for this Moisture level data.",
			Category -> "Data Processing",
			Abstract -> True
		},
		MoistureDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[PPM],
			Description -> "The empirical distribution based on this Moisture level data.",
			Category -> "Data Processing"
		},
		Moisture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PPM],
			Units -> PPM,
			Description -> "Trace of Moisture level vs date/time during the course of an experiment or single data point.",
			Category -> "Data Processing",
			Abstract -> True
		}
	}
}];
