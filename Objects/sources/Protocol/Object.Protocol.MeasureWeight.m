(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MeasureWeight], {
	Description->"A protocol for measuring the weight of a sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Balance -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "For each member of ContainersInExpanded, the instrument used to measure the weight of the container.",
			Category -> "Weighing",
			IndexMatching -> ContainersInExpanded,
			Abstract -> True
		},


  (* TODO delete these 5 field post funtopia *)
    NumberOfWeighings -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[0, 1],
      Units -> None,
      Description -> "For each member of ContainersIn, the number of times the container will be weighed in replicate.",
      Category -> "Weighing",
      IndexMatching -> ContainersIn
    },
    MeasureWeightPrograms -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "For each member of ContainersIn, the parameters used during weighing.",
			Category -> "Weighing",
			IndexMatching -> ContainersIn
		},
		Weight -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "For each member of ContainersIn, the weight of the sample (or container if no sample present) taking into account replicate weight measurements according to NumberOfWeighings. If the DataType is Analyte, then it is equal to the GrossWeight minus the TareWeight (or ResidueWeight, if available), taking into account the replicate weight measurements.",
			Category -> "Experimental Results",
			Abstract -> True,
			IndexMatching -> ContainersIn
		},
		WeightStandardDeviation -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?MassQ,
			Units -> Gram,
			Description -> "For each member of ContainersIn, the calculated standard deviation of the weight from replicate weight measurements according to NumberOfWeighings.",
			Category -> "Experimental Results",
			Abstract -> True,
			IndexMatching -> ContainersIn
		},
		WeightDistribution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "For each member of ContainersIn, the calculated statistical distribution of the weight from replicate weight measurements according to NumberOfWeighings.",
			Category -> "Experimental Results",
			IndexMatching -> ContainersIn
		},


		(* --- Batching Information --- *)

    ContainersInExpanded -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description -> "The containers containing this protocols' SamplesIn, expanded according to NumberOfReplicates.",
      Category -> "Organizational Information"
    },
		
		Batching -> {
			Format -> Multiple,
			Class -> {
				WorkingContainerIn -> Link,
				ContainerIn -> Link,
				ScoutBalance -> Link,
				Balance -> Link,
				Pipette -> Link,
				PipetteTips -> Link,
				WeighPaper -> Link,
				WeighBoat -> Link,
				TransferContainer -> Link,
				Holder -> Link,
				CalibrateContainer -> Expression,
				SortingIndex -> Expression,
				Index -> Expression
			},
			Pattern :> {
				WorkingContainerIn -> _Link,
				ContainerIn -> _Link,
				ScoutBalance -> _Link,
				Balance -> _Link,
				Pipette -> _Link,
				PipetteTips -> _Link,
				WeighPaper -> _Link,
				WeighBoat -> _Link,
				TransferContainer -> _Link,
				Holder -> _Link,
				CalibrateContainer -> BooleanP,
				SortingIndex -> _Integer,
				Index -> _Integer
			},
			Relation -> {
				WorkingContainerIn -> Alternatives[
					Object[Container],
					Model[Container]
				],
				ContainerIn -> Alternatives[
					Object[Container],
					Model[Container]
				],
				ScoutBalance -> Alternatives[
					Object[Instrument],
					Model[Instrument]
				],
				Balance -> Alternatives[
					Object[Instrument],
					Model[Instrument]
				],
				Pipette -> Alternatives[
					Object[Instrument],
					Model[Instrument]
				],
				PipetteTips -> Alternatives[
					Model[Sample], (* TODO: Remove Object[Sample] here after item migration *)
					Object[Sample],
					Model[Item],
					Object[Item]
				],
				WeighPaper -> Alternatives[
					Model[Sample], (* TODO: Remove Object[Sample] here after item migration *)
					Object[Sample],
					Model[Item],
					Object[Item]
				],
				WeighBoat -> Alternatives[
					Model[Sample], (* TODO: Remove Object[Sample] here after item migration *)
					Object[Sample],
					Model[Item],
					Object[Item]
				],
				TransferContainer -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Holder -> Alternatives[
					Model[Container],
					Object[Container]
				],
				CalibrateContainer -> None,
				SortingIndex -> None,
				Index -> None
			},
			Units -> {
				WorkingContainerIn -> None,
				ContainerIn -> None,
				ScoutBalance -> None,
				Balance -> None,
				Pipette -> None,
				PipetteTips -> None,
				WeighPaper -> None,
				WeighBoat -> None,
				TransferContainer -> None,
				Holder -> None,
				CalibrateContainer -> None,
				SortingIndex -> None,
				Index -> None
			},
			Headers -> {
				WorkingContainerIn -> "WorkingContainerIn",
				ContainerIn -> "ContainerIn",
				ScoutBalance -> "ScoutBalance",
				Balance -> "Balance",
				Pipette -> "Pipette",
				PipetteTips -> "PipetteTips",
				WeighPaper -> "WeighPaper",
				WeighBoat -> "WeighBoat",
				TransferContainer->"TransferContainer",
				Holder->"Holder",
				CalibrateContainer->"CalibrateContainer",
				SortingIndex -> "SortingIndex",
				Index -> "Index"

			},
			Description -> "The list of containers, sorted by batch, and their corresponding resources needed for weighing and/or transferring.",
			Category -> "Batching",
			Developer -> True
		},


		BatchingLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The list of batch sizes corresponding to number of containers per batch.",
			Category -> "Batching",
			Developer -> True
		},


  (* --- Data acquisition --- *)

		(* in addition to Data (shared field), we have the following data sets. The parser makes sure these are indexmatched with ContainersInExpanded *)

		ScoutData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of ContainersInExpanded, the initial weight estimate of the container (and sample if present), based on which a final Balance is chosen to get an accurate weight measurement of the sample.",
			Category -> "Weighing",
			IndexMatching -> ContainersInExpanded
		},
		TareData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of ContainersInExpanded, the weight measurement data of the weigh container when empty and before any incoming sample transfer has commenced.",
			Category -> "Tare",
			IndexMatching -> ContainersInExpanded
		},
		ResidueWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of ContainersInExpanded, the weight measurement data of the weigh container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container. Note that this includes the weight of the container.",
			Category -> "Tare",
			IndexMatching -> ContainersInExpanded
		},
		TareWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Weight measurement data recorded with nothing on the balance and after zeroing the reading.",
			Category -> "Tare"
		}
	}
}];
