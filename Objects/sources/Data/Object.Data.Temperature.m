(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Temperature], {
	Description->"Temperature measured as a function of date and time by a temperature sensor.",
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
			Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the temperature sensor using a function called RecordSensor.",
			Category -> "General"
		},
		TemperatureLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> ECL`DateCoordinatesComparisonP[GreaterEqualP[0*Kelvin]],
			Units -> {None, Celsius},
			Description -> "Trace of temperature vs date/time during the course of an experiment or single data point.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
			Relation -> {Object[Calibration,Sensor],Null},
			Units -> {None, None},
			Description -> "Maintenance objects and associated raw temperature vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		TemperatureStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The calculated standard deviation for this temperature data.",
			Category -> "Data Processing",
			Abstract -> True
		},
		TemperatureDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Celsius],
			Description -> "The empirical distribution based on this temperarure data.",
			Category -> "Data Processing"
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "Trace of temperature vs date/time during the course of an experiment or single data point.",
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
