

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, pH], {
	Description->"pH measured as a function of date and time by a pH sensor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Probe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part],
			Description -> "The Probe which was used to measure pH.",
			Category -> "General",
			Abstract -> True
		},
		TemperatureCorrection-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TemperatureCorrectionP,(*TemperatureCorrectionP=Linear|Non-linear|Off*)
			Description -> "Defines the relationship between temperature and pH. Linear: Use for the temperature correction of medium and highly conductive solutions. Non-linear: Use for natural water (only for temperature between 0…36 ºC). Off: The conductivity value at the current temperature is displayed.",
			Category -> "General",
			Abstract -> True
		},
		AlphaCoefficient-> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,10],
			Description -> "Defines the factor for the linear dependency.",
			Category -> "General",
			Abstract -> True
		},
		ReferenceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The pH reading directly corrected to the set ReferenceTemperature.",
			Category -> "General",
			Abstract -> True
		},
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
			Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the pH sensor using a function called RecordSensor.",
			Category -> "General"
		},
		pHLog -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{_?DateObjectQ, _?NumericQ}..},
			Units -> {None, None},
			Description -> "Trace of pH vs date/time during the course of an experiment or single data point.",
			Category -> "Sensor Information",
			Abstract -> True
		},	
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
			Relation -> {Object[Calibration,Sensor],Null},
			Units -> {None, None},
			Description -> "Calibration objects and associated raw pH vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		pHStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The calculated standard deviation for this pH data.",
			Category -> "Data Processing",
			Abstract -> True
		},
		pHDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ,
			Description -> "The empirical distribution based on this pH data.",
			Category -> "Data Processing"
		},
		pH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Trace of pH vs date/time during the course of an experiment or single data point.",
			Category -> "Data Processing",
			Abstract -> True
		},
		CalibrationData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration,pH][AnalyteData],
			Description -> "Any calibration.",
			Category -> "Data Processing"
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
