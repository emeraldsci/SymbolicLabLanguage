(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, LiquidLevel], {
	Description->"Volume level measured as a function of date and time by a liquid level sensor.",
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
			Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the liquid level sensor using a function called RecordSensor.",
			Category -> "General"
		},
		LiquidLevelLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{None,Inch}..}],
			Units -> {None, Inch},
			Description -> "Trace of liquid level vs date/time during the course of an experiment or single data point.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
			Relation -> {Object[Calibration, Sensor],Null},
			Units -> {None, None},
			Description -> "Maintenance objects and associated raw liquid level vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		LiquidLevelStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Inch],
			Units -> Inch,
			Description -> "The calculated standard deviation for this LiquidLevel data.",
			Category -> "Data Processing",
			Abstract -> True
		},
		LiquidLevelDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Inch],
			Description -> "The empirical distribution based on this LiquidLevel data.",
			Category -> "Data Processing"
		},
		LiquidLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Inch],
			Units -> Inch,
			Description -> "Trace of LiquidLevel vs date/time during the course of an experiment or single data point.",
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
