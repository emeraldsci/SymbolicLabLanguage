(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: andrey *)
(* :Date: 2023-04-27 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Distance], {
	Description->"Distance measured as a function of date and time by a DistanceGauge.",
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
			Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the distance sensor using a function called RecordSensor.",
			Category -> "General"
		},
		DistanceLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None,Millimeter}],
			Units -> {None, Millimeter},
			Description -> "Trace of distance vs date/time during the course of an experiment or single data point.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
			Relation -> {Object[Calibration, Sensor],Null},
			Units -> {None, None},
			Description -> "Maintenance objects and associated raw distance vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		DistanceStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Millimeter,
			Description -> "The calculated standard deviation for this distance data.",
			Category -> "Data Processing",
			Abstract -> True
		},
		DistanceDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Millimeter],
			Description -> "The empirical distribution based on this distance data.",
			Category -> "Data Processing"
		},
		Distance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Millimeter,
			Description -> "The latest distance measurement data point.",
			Category -> "Data Processing",
			Abstract -> True
		}
	}
}];