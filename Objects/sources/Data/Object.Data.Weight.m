(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Weight], {
	Description->"Measured weight of a sample using a balance.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BalanceType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BalanceModeP,
			Description -> "Type of instrument balance that was used in making this weight measurement.",
			Category -> "General"
		},
		SampleContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, Plate],
				Object[Container, Vessel],
				Object[Container, ReactionVessel],
				Object[Container, Cuvette]
			],
			Description -> "The container that holds the sample (if any) after the weight measurement is complete.",
			Category -> "General"
		},
		ContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Model[Container, Plate],
				Model[Container, ReactionVessel],
				Model[Container, Cuvette]
			],
			Description -> "The model of container that holds the sample after the weight measurement is complete.",
			Category -> "General"
		},
		WeighBoat -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][Data]|Object[Item][Data], (* TODO: Remove Sample after migration *)
			Description -> "A container designed to mitigate static electricity effects when weighing the sample on the microbalance.",
			Category -> "General"
		},
		FirstDataPoint -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date of the first data point in this object.",
			Category -> "General",
			Developer -> True
		},
		LastDataPoint -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date of the last data point in this object.",
			Category -> "General",
			Developer -> True
		},
		DailyLog -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the data was parsed from a continous daily log of the sensor as opposed to generated on demand.",
			Category -> "General",
			Developer -> True
		},
		Weight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The weight of the sample (or container if no sample present) after the weight measurement. If the DataType is Analyte, then it is equal to the GrossWeight minus the TareWeight (or ResidueWeight, if available).",
			Category -> "Experimental Results",
			Abstract -> True
		},
		WeightStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The calculated standard deviation of this weight measurement.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		WeightDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "The empirical statistical distribution of this weight measurement.",
			Category -> "Experimental Results"
		},
		WeightAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance],
			Description -> "The side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement by the integrated camera.",
			Category -> "Experimental Results"
		},
		WeightStability -> {
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> {_?DateObjectQ, UnitsP[Gram]},
			Description -> "Trace of weight vs date/time from -60 to +60 seconds relative to the weight measurement timepoint.",
			Category -> "Experimental Results"
		},
		TareData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight][Analytes],
			Description -> "The weight measurement of the container when empty and before any incoming sample transfer has commenced, that was measured for this data.",
			Category -> "Experimental Results"
		},
		ResidueWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight][Analytes],
			Description -> "The weight measurement data of the weigh container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container. Note that this includes the weight of the container.",
			Category -> "Experimental Results"
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, Weight][TareData],
				Object[Data, Weight][ResidueWeightData]
			],
			Description -> "Any direct analyte weight measurements for which this data served as the TareData or ResidueWeightData.",
			Category -> "Experimental Results"
		},
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WeightMeasurementTypeP,
			Description -> "Indicates the type of weight measurement this data represents.",
			Category -> "Data Processing",
			Abstract -> True
		},
		TareWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The weight of the weigh container when empty and before any incoming sample transfer has commenced.",
			Category -> "Data Processing",
			Abstract -> True
		},
		SampleWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The, a priori, known weight of the sample. This is used when calibrating the tare weight of a container holding that sample.",
			Category -> "Data Processing",
			Abstract -> True
		},
		GrossWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The weight of the weigh container including any sample inside.",
			Category -> "Data Processing",
			Abstract -> True
		},
		ResidueWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The weight of the weigh container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container. Note that this includes the weight of the container.",
			Category -> "Data Processing",
			Abstract -> True
		},
		WeightLog -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None,Gram}],
			Units -> {None, Gram},
			Description -> "Trace of weight vs date/time during the course of an experiment or single data point.",
			Category -> "Data Processing",
			Abstract -> True
		},
		RawData -> {
			Format-> Multiple,
			Class-> {Link,Compressed},
			Pattern :> {_Link,{{_?DateObjectQ, Alternatives[_?NumericQ,_String]}..}},
			Relation -> {Object[Calibration,Sensor],Null},
			Units -> {None, None},
			Description -> "Calibration objects and associated raw output of the sensor vs date/time data for each datapoint in the data object.",
			Headers -> {"Calibration","Time-Series Data"},
			Category -> "Data Processing"
		},
		ProtocolWaste -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Qualification],
				Object[Maintenance]
			],
			Description -> "The protocol that generated this waste weight data.",
			Category -> "Cleaning"
		}
	}
}];
