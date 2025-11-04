(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MeasureCount], {
	Description->"A protocol for determining the tablet or sachet count for a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SolidUnitWeightParameterizations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "Samples for which the individual tablet or sachet weight will be parameterized before weighing the overall sample to estimate a total count.",
			Category -> "Weighing"
		},
		SolidUnitParameterizationReplicates -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1, 20, 1],
			Units -> None,
			Description -> "For each member of SolidUnitWeightParameterizations, the number of tablets or sachets that should be weighed (if available) to determine the mean SolidUnitWeight.",
			Category -> "Weighing",
			IndexMatching -> SolidUnitWeightParameterizations
		},
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The balance used to measure the weight of the tablets or tablets.",
			Category -> "Weighing",
			Abstract -> True
		},
		Reservoirs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of SolidUnitWeightParameterizations, the container used to hold tablets or sachets for counting, designed to minimize static electricity effects.",
			IndexMatching -> SolidUnitWeightParameterizations,
			Category -> "Weighing"
		},
		WeighBoats -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of SolidUnitWeightParameterizations, the container used to hold tablets or sachets for weighing, designed to minimize static electricity effects.",
			IndexMatching -> SolidUnitWeightParameterizations,
			Category -> "Weighing"
		},
		Tweezer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Object[Part],(* TODO: Remove Object[Sample] here after item migration *)
				Model[Item],
				Object[Item]
			],
			Description -> "The metal tweezer used to transfer individual tablets or sachets from the original container to the weigh boat (for counting), from the weigh boat onto the balance (for weighing), and back into the original container.",
			Category -> "Weighing"
		},
		TotalWeightMeasurement -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureWeight],
			Description -> "Protocol executed to measure the weight of any samples in order to back-calculate the count of the sample from the recorded weight and known (or determined) tablet or sachet weight.",
			Category -> "Weighing"
		},
		TotalWeightMeasurementSamples-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "Any samples for which Mass is not informed and total weight measurement needs to be performed.",
			Category -> "Weighing"
		},
		BalanceLog -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The trace of balance reading vs date recorded from the beginning of first weight measurement to the very last weight measurement, whenever a new tablet/sachet unit is measured.",
			Category -> "General"
		},
		SolidUnitWeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "For each member of SolidUnitWeightParameterizations, the mean weight of its tablets or sachets taking into account replicate tablets or sachets and their replicate weight measurements.",
			Category -> "Experimental Results",
			Abstract -> True,
			IndexMatching -> SolidUnitWeightParameterizations
		},
		SolidUnitWeightStandardDeviations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "For each member of SolidUnitWeightParameterizations, the calculated standard deviation of the weight from replicate weight measurements according to replicate tablets or sachets and their replicate weight measurements.",
			Category -> "Experimental Results",
			Abstract -> True,
			IndexMatching -> SolidUnitWeightParameterizations
		},
		SolidUnitWeightDistributions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "For each member of SolidUnitWeightParameterizations, the measured statistical distribution of the weight from replicate tablets or sachets and their replicate weight measurements.",
			Category -> "Experimental Results",
			IndexMatching -> SolidUnitWeightParameterizations
		},
		SolidUnitWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight measurement datasets of all tablets or sachets measured in this experiment.",
			Category -> "Experimental Results"
		},
		TareData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight measurement data of the weigh paper or weigh boat when empty and before any incoming tables or sachets transfer has commenced.",
			Category -> "Experimental Results"
		},
		TotalSampleWeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "For each member of TotalWeightMeasurementSamples, the weight of the sample (gross weight minus the weight of the container).",
			Category -> "Experimental Results",
			Abstract -> True,
			IndexMatching -> TotalWeightMeasurementSamples
		},
		WeightStabilityDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration for which the balance reading needs to stay within a range defined by MaxWeightVariation before being considered stable and measured.",
			Category -> "General"
		},
		MaxWeightVariation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milligram],
			Units -> Milligram,
			Description -> "The max allowed amplitude the balance readings can fluctuate with for a duration defined by WeightStabilityDuration before being considered stable and measured.",
			Category -> "General"
		}
	}
}];
