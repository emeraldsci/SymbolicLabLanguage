(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, Training, Weighing], {
	Description->"The model for a qualification test to verify the user's ability to weigh samples properly.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Balances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Balance],
			Description -> "The balance used to test the user's ability to tare and measure typical masses (0.1-200 gram) using a balance (macro, micro, or analytical).",
			Category -> "Weighing Skills"
		},
		NumberOfReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Indicates the number of times that weighing and transfer using each balance is repeated.",
			Category -> "Qualification Parameters"
		},
		(* Source, weighing container, destination, and amount *)
		TransferSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the model of the sample used to weigh in order to test the user's ability to use a balance.",
			Category -> "Weighing Skills"
		},
		WeighingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Model[Item]
			],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the model of the container that are placed on the Balances and used to weigh out the BalancesSampleWeights that will be transferred to the Destinations.",
			Category -> "Weighing Skills"
		},
		Destinations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "For each member of Balances, the model of the destination container to which the weighed samples are transferred from the WeighingContainers.",
			Category -> "Weighing Skills",
			IndexMatching -> Balances
		},
		TargetTransferWeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milligram],
			Units -> Milligram,
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the target weight of the sample that is weighed and transferred eventually the Destinations.",
			Category -> "Weighing Skills"
		},
		Tolerance->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milligram],
			Units -> Milligram,
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the allowed tolerance of the weighed source sample from the specified amount requested to be transferred.",
			Category -> "Weighing Skills"
		},
		(* Other objects involved *)
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Spatula],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the spatula used to transfer the sample from the source container to the WeighingContainers.",
			Category -> "Qualification Parameters"
		},
		Funnels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, Funnel],
			Description -> "For each member of Balances, the funnel that is used to guide the sample from the WeighingContainers into the Destinations and, if applicable, for returning the weighed sample from the Destinations back to the source container.",
			Category -> "Qualification Parameters"
		},
		(* Criteria *)
		ResidueTolerance -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "For each member of Balances, the maximum percentage of residue that may remain in the WeighingContainers after transferring to the Destinations, expressed relative to the weight of the empty WeighingContainer, for the result to be considered passing.",
			IndexMatching -> Balances,
			Category -> "Passing Criteria"
		},
		BalanceMaterialLossTolerance -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "For each member of Balances, the maximum allowed residue that may remain on the Balances after removing the weighed sample in the WeighingContainers, expressed as the multiple of the resolution of the Balances, for the result to be considered passing.",
			IndexMatching -> Balances,
			Category -> "Passing Criteria"
		},
		MaterialLossTolerance -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "For each member of Balances, the maximum percentage of all other losses contributing to the difference between the actual gained weight in the Destinations and the expected amount, expressed relative to the BalancesSampleWeights, for the result to be considered passing. Such losses may include unintended pressing of 'tare', spillage during transfer from the WeighingContainers to the Destinations, etc.",
			IndexMatching -> Balances,
			Category -> "Passing Criteria"
		}
	}
}]