(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, RelativeHumidity], {
	Description->"Relative humidity measured as a function of date and time by a humidity sensor.",
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
			Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the relative humidity sensor using a function called RecordSensor.",
			Category -> "General"
		},
		RelativeHumidityLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> ECL`DateCoordinatesComparisonP[RangeP[0*Percent, 100*Percent]],
			Units -> {None, Percent},
			Description -> "Trace of relative humidity vs date/time during the course of an experiment or single data point.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
			Relation -> {Object[Calibration,Sensor],Null},
			Units -> {None, None},
			Description -> "Calibration objects and associated raw relative humidity vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		RelativeHumidityStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The calculated standard deviation for this RelativeHumidity data.",
			Category -> "Data Processing",
			Abstract -> True
		},
		RelativeHumidityDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Percent],
			Description -> "The empirical distribution based on this temperarure data.",
			Category -> "Data Processing"
		},
		RelativeHumidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "Trace of RelativeHumidity vs date/time during the course of an experiment or single data point.",
			Category -> "Data Processing",
			Abstract -> True
		},
		CorrelatedData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, CarbonDioxide][CorrelatedData],
				Object[Data, Conductivity][CorrelatedData],
				Object[Data, LiquidLevel][CorrelatedData],
				Object[Data, pH][CorrelatedData],
				Object[Data, Pressure][CorrelatedData],
				Object[Data, RelativeHumidity][CorrelatedData],
				Object[Data, Temperature][CorrelatedData],
				Object[Data, Volume][CorrelatedData],
				Object[Data, FlowRate][CorrelatedData]
			],
			Description -> "Other sensor data objects that were created concurrently to this data object in the same function call.",
			Category -> "Experimental Results"
		}
	}
}];
