(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Volume], {
	Description->"A measurement of liquid volume inside a container.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of measurement readings taken together and averaged by the liquid level detector.",
			Category -> "General"
		},
		MeasurementMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> VolumeMeasurementMethodP,
			Description -> "The method used to determine volume for this piece of data.",
			Category -> "General"
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
			Description -> "Boolean describing whether or not the data object is a daily log. If it is, it will be parsed to create new data objects with the data measured from the sensor using a function called RecordSensor.",
			Category -> "General"
		},
		SingleDataPoint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Boolean describing whether or not the data object is a single datapoint.",
			Category -> "General"
		},
		Well -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellP,
			Description -> "Well in the plate that the data was taken from.",
			Category -> "General"
		},
		SampleContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, Plate],
				Object[Container, Vessel]
			],
			Description -> "The container that housed the sample for which this volume measurement was taken.",
			Category -> "General"
		},
		ContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Model[Container, Vessel]
			],
			Description -> "The model of the container for which this volume measurement was made.",
			Category -> "General"
		},
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample]
			],
			Description -> "The type of buffer the sample was in.",
			Category -> "General"
		},
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> VolumeMeasurementTypeP,
			Description -> "Whether this data represents a blank volume measurement or an analyte volume measurement.",
			Category -> "General",
			Abstract -> True
		},
		LiquidLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Milli,
			Description -> "The distance recorded from the sensor to the surface of the liquid.",
			Category -> "Experimental Results"
		},
		LiquidLevelStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Milli,
			Description -> "Standard deviation in distances recorded from the sensor to the surface of the liquid.",
			Category -> "Experimental Results"
		},
		LiquidLevelDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ|DistributionP[Millimeter],
			Description -> "The distribution of the measured distance value.",
			Category -> "Experimental Results"
		},
		LiquidLevelLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> ECL`DateCoordinatesComparisonP[GreaterEqualP[0*Meter]],
			Units -> {None, Meter Milli},
			Description -> "Trace of Liquid Level vs date/time during the course of an experiment or single data point.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, _?NumericQ}..}},
			Relation -> {Object[Calibration,Sensor, LiquidLevel],Null},
			Units -> {None, None},
			Description -> "Maintenance objects and associated raw temperature vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		Weight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The net weight of the sample (not including the weight of its container).",
			Category -> "Experimental Results",
			Abstract -> True
		},
		WeightStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The calculated standard deviation of the sample weight measurements.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		WeightDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "The empirical statistical distribution of the sample weight measurements.",
			Category -> "Experimental Results"
		},
		WeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,Weight],
			Description -> "The weight data used to calculate volume data based on sample density.",
			Category -> "Experimental Results"
		},
		Volume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?VolumeQ,
			Units -> Liter Micro,
			Description -> "The volume of the sample, computed either from a calibration fit of raw distances to known volumes or from measured weight via known density.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		VolumeStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?VolumeQ,
			Units -> Liter Micro,
			Description -> "The standard deviation in calculated sample volume.",
			Category -> "Experimental Results"
		},
		VolumeDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ|DistributionP[Microliter],
			Description -> "The distribution of the calculated volume value.",
			Category -> "Experimental Results"
		},
		Blank -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Volume][Analytes],
			Description -> "Any direct blank volume measurements of the empty well or vessel that was measured for this data.",
			Category -> "Experimental Results"
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Volume][Blank],
			Description -> "Any direct analyte volume measurements of a well or vessel for which this data served as a blank.",
			Category -> "Experimental Results"
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
		},
		VolumeCalibration -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration],
			Description -> "The pathlength-to-volume calibration fit used to convert the measured distance into reported volume.",
			Category -> "Analysis & Reports"
		},
		QuantificationAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Quantification analyses conducted on the distance measurement data.",
			Category -> "Analysis & Reports"
		}
	}
}];
