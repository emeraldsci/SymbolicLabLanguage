(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Pressure], {
	Description->"Pressure measured as a function of date and time by a pressure sensor.",
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
			Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the pressure sensor using a function called RecordSensor.",
			Category -> "General"
		},
		PressureLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None,PSI}],
			Units -> {None, PSI},
			Description -> "Trace of pressure vs date/time during the course of an experiment or single data point.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
			Relation -> {Object[Calibration, Sensor],Null},
			Units -> {None, None},
			Description -> "Maintenance objects and associated raw pressure vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		PressureStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The calculated standard deviation for this Pressure data.",
			Category -> "Data Processing",
			Abstract -> True
		},
		PressureDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[PSI],
			Description -> "The empirical distribution based on this Pressure data.",
			Category -> "Data Processing"
		},
		Pressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "Trace of Pressure vs date/time during the course of an experiment or single data point.",
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
