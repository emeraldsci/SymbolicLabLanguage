(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, Conductivity], {
	Description->"Conductivity measured by a conductivity sensor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(*---Method Information---*)
		Probe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,ConductivityProbe],
			Description -> "The Probe which was used to measure conductivity.",
			Category -> "General",
			Abstract -> True
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the conductivity of the sample was read by taking another recording.",
			Category -> "General",
			Abstract -> True
		},
		TemperatureCorrection-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TemperatureCorrectionP,
			Description -> "The temperature correction algorithm which defines the relationship between temperature and conductivity. Linear: Use for the temperature correction of medium and highly conductive solutions. Non-linear: Use for natural water (only for temperature between 0…36 ºC). Off: The conductivity value at the current temperature is displayed. PureWater: An optimized type of temperature algorithm is used.",
			Category -> "General",
			Abstract -> True
		},
		AlphaCoefficient-> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,10],
			Description -> "Defines the factor for the linear dependency for Linear type of TemperatureCorrection.", (*findout dbout logic behaid of it and add to the description*)
			Category -> "General",
			Abstract -> True
		},
		ReferenceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature to which conductivity reading directly corrected to.",
			Category -> "General",
			Abstract -> True
		},
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "The amount of the sample used for conductivity measurement.",
			Category -> "General"
		},
		(*---Data Processing---*)
		Calibration -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration,Conductivity],
			Description -> "The cell constant calibration fit into calibrations standard conductivity used to calculate the samples conductivity.",
			Category -> "Data Processing"
		},
		(*---Experimental Results---*)
		Conductivity -> {
			Format -> Single,
			Class ->  Expression,
			Pattern :> DistributionP[Micro Siemens/Centimeter],
			Description -> "The empirical distribution of the conductivity data based on NumberOfReadings.",
			Category -> "Experimental Results"
		},
		Temperature -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Celsius],
			Description -> "The empirical distribution of the sample temperature data based on NumberOfReadings.",
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
		}
	}
}];
