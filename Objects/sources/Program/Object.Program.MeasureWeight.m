(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Program, MeasureWeight], {
	Description->"The program describing a single weight measurement of a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		SampleIn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample whose weight is being measured.",
			Category -> "General",
			Abstract -> True
		},
		ContainerIn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The container whose weight is being measured.",
			Category -> "General",
			Abstract -> True
		},
		TareData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight measurement data of the weigh container when empty and before any incoming sample transfer has commenced.",
			Category -> "Tare"
		},
		ResidueWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight measurement data of the weigh container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container. Note that this includes the weight of the container.",
			Category -> "Tare"
		},
		Pipette -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument used to transfer liquid into the tare container.",
			Category -> "Transfer"
		},
		PipetteTips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample], (* TODO: Remove after item migration *)
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "Pipette tips used to transfer liquid into the tare container.",
			Category -> "Transfer"
		},
		WeighPaper -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample], (* TODO: Remove after item migration *)
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The weigh paper used in transferring sample to the WeightBoat and/or TransferContainer.",
			Category -> "Transfer"
		},
		NumberOfWeighings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the weigh container will be weighed in replicate.",
			Category -> "Weighing"
		},
		TransferContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The empty container used to weigh the sample if the Tare weight of the analyte container is unknown.",
			Category -> "Weighing"
		},
		WeighBoat -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample], (* TODO: Remove after item migration *)
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "A container designed to mitigate static electricity effects when weighing the sample on the microbalance.",
			Category -> "Weighing"
		},
		BalanceType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BalanceModeP,
			Description -> "The type of instrument balance that was used in making this weight measurement.",
			Category -> "Weighing"
		},
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to measure the weight of the sample.",
			Category -> "Weighing",
			Abstract -> True
		},
		ScoutBalance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to get an initial weight estimate of the sample, based on which a final Balance is chosen to get an accurate weight measurement of the sample.",
			Category -> "Weighing"
		},
		ScoutData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The initial weight estimate of the sample, based on which a final Balance is chosen to get an accurate weight measurement of the sample.",
			Category -> "Weighing"
		},
		Weight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The weight of the sample (or container if no sample present) taking into account replicate weight measurements according to NumberOfWeighings. If the DataType is Analyte, then it is equal to the GrossWeight minus the TareWeight (or ResidueWeight, if available), taking into account replicate weight measurements.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		WeightStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "The calculated standard deviation of the weight from replicate weight measurements according to NumberOfWeighings.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		WeightDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "The calculated statistical distribution of the weight from replicate weight measurements according to NumberOfWeighings.",
			Category -> "Experimental Results"
		},
		WeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Weight measurements of SampleIn.",
			Category -> "Experimental Results"
		},
		CalibrateContainer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the TareWeight of the container is being measured.",
			Category -> "Experimental Results",
			Abstract -> True
		}
	}
}];
