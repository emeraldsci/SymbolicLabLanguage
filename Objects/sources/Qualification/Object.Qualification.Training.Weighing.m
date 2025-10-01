(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: hanming.yang*)
(* :Date: 2023-6-16 *)

DefineObjectType[Object[Qualification, Training, Weighing], {
	Description -> "The qualification test to verify the user's ability to weigh samples properly.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Objects involved - expanded based on replicates and all index matching when applicable *)
		Balances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Balance],
				Object[Instrument, Balance]
			],
			Description -> "The balance used to test the user's ability to tare and measure typical masses (0.1-200 gram) using a balance (macro, micro, or analytical).",
			Category -> "Weighing Skills"
		},
		TransferEnvironments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, HandlingStation],
				Model[Instrument, HandlingStation]
			],
			Description -> "For each member of Balances, the environment in which the weighing is performed in order to test the user's ability to use a balance.",
			IndexMatching -> Balances,
			Category -> "Weighing Skills"
		},
		TransferSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the sample used to weigh in order to test the user's ability to use a balance.",
			Category -> "Weighing Skills"
		},
		WeighingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Model[Item],
				Object[Container],
				Object[Item]
			],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the container that is placed on the Balances and used to weigh out the BalancesSampleWeights that is transferred to the Destinations.",
			Category -> "Weighing Skills"
		},
		Destinations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of Balances, the destination container to which the weighed sample is transferred from the WeighingContainers.",
			Category -> "Weighing Skills",
			IndexMatching -> Balances
		},
		TargetTransferWeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milligram],
			Units -> Milligram,
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight of the sample that is aimed to transfer to the Destinations.",
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
			Relation -> Alternatives[Model[Item, Spatula], Object[Item, Spatula]],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the spatula used to transfer the sample from the source container to the WeighingContainers.",
			Category -> "Qualification Parameters"
		},
		Funnels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Funnel],
				Object[Part, Funnel]
			],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the funnel that is used to guide the sample from the WeighingContainers into the Destinations and, if applicable, for returning the weighed sample from the Destinations back to the source container.",
			Category -> "Qualification Parameters"
		},
		WasteContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description->"The vessel used to temporarily hold the solid sample removed from the destination container after each weighing test. The solid sample in this vessel will be discarded at the end of the training.",
			Category -> "Qualification Parameters"
		},
		TearDownTransferEnvironments -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Balances, whether the TransferEnvironment needs to be torn down at the end of that iteration of the loop.",
			Category -> "General",
			IndexMatching -> Balances,
			Developer -> True
		},

		(* Data upload *)
		(* We may have multiple data (not index matching) due to retry *)
		TareData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Weight] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data, Weight],
			Description -> "The weight measurement data recorded with nothing on the balance and after zeroing the reading. This data should always be 0 Gram. One more data is collected when repeated, possibly due to ValidDestinationTareWeights, ValidWeighingContainerTareWeights, or ReportedSpillFrees being False.",
			Category -> "Experimental Results"
		},
		DestinationStartingWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight measurement data of the Destinations prior to the start of any sample transfer in each weighing operation. One more data is collected when repeated, possibly due to ValidDestinationTareWeights or ReportedSpillFrees being False.",
			Category -> "Experimental Results"
		},
		DestinationStartingWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight of the Destinations prior to the start of any sample transfer in each weighing operation.",
			Category -> "Experimental Results"
		},
		EmptyContainerWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight measurement data of the weighing container when empty and prior to the start of any sample transfer in each weighing operation. One more data is collected when repeated, possibly due to ValidWeighingContainerTareWeights or ReportedSpillFrees being False.",
			Category -> "Experimental Results"
		},
		EmptyContainerWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight of the weighing container when empty and prior to the start of any sample transfer in each weighing operation.",
			Category -> "Experimental Results"
		},
		MeasuredTransferWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight measurement data of the weighing container when filled with the amount of sample needed prior to transfer to the destination. One more data is collected when repeated due to ReportedSpillFrees being False.",
			Category -> "Experimental Results"
		},
		MeasuredTransferWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight of the weighing container when filled with the amount of sample needed prior to transfer to the destination.",
			Category -> "Experimental Results"
		},
		MaterialLossWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight measurement data recorded after the weighing container is removed from the balance. This measurement accounts for any material lost onto the balance pan during the transfer process.",
			Category -> "Experimental Results"
		},
		MaterialLossWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight recorded after the weighing container is removed from the balance. This weight accounts for any material lost onto the balance pan during the transfer process.",
			Category -> "Experimental Results"
		},
		DestinationFinalWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight measurement data of the destination container after the weighed sample is transferred to it from the weighing container. This weight includes the weight loss on balance because there is no tare after transferring sample to the weighing container. Therefore, the final difference between the TargetTransferWeights and the DestinationFinalWeights only accounts for possible loss outside the balance.",
			Category -> "Experimental Results"
		},
		DestinationFinalWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight of the destination container after the weighed sample is transferred to it from the weighing container.",
			Category -> "Experimental Results"
		},
		ResidueWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight measurement data of the weighing container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container. This weight includes the weight loss on balance because there is no tare after transferring sample to the weighing container. Therefore, the final difference between the EmptyContainerWeights and the ResidueWeights only accounts for what's left on the WeighingContainers.",
			Category -> "Experimental Results"
		},
		ResidueWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the weight of the weighing container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container.",
			Category -> "Experimental Results"
		},

		(* Image upload *)
		DestinationStartingWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of DestinationStartingWeightData by the integrated camera.",
			Category -> "Experimental Results"
		},
		EmptyContainerWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of EmptyContainerWeightData by the integrated camera.",
			Category -> "Experimental Results"
		},
		MeasuredTransferWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of MeasuredTransferWeightData by the integrated camera.",
			Category -> "Experimental Results"
		},
		MaterialLossWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the side on image of the weighing surface of the balance, captured immediately following the weight measurement of MaterialLossWeightData by the integrated camera.",
			Category -> "Experimental Results"
		},
		DestinationFinalWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of DestinationFinalWeightData by the integrated camera.",
			Category -> "Experimental Results"
		},
		ResidueWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance],
			IndexMatching -> Balances,
			Description -> "For each member of Balances, the side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of ResidueWeightData by the integrated camera.",
			Category -> "Experimental Results"
		},
		MultipleChoiceAnswer -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The value selected in the multiple choice tasks, with \"1\" being the correct answer.",
			Category ->  "Weighing Skills"
		},
		NumberOfPracticeRetries -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times operator has retried the multiple choice questions before starting the first weighing.",
			Category ->  "Weighing Skills"
		},
		FastTrackPractice -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if incorrect choice error messages should be suppressed in engine, so operator can continue to retry the multiple choice questions again.",
			Category ->  "Weighing Skills"
		},
		(* Data processing *)
		TargetAmount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milligram],
			Units -> Milligram,
			Description -> "The total weight of the sample and the weighing container that should be achieved on the balance. This target is calculated as the sum of the EmptyContainerWeight and the BalancesSampleWeight.",
			Category -> "Weighing Skills",
			Developer -> True
		},
		ValidDestinationTareWeights -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the measured weight of the empty destination container, i.e. DestinationStartingWeightData, is found valid by validTransferWeighingContainerTareWeightQ. If it was found invalid, the taring and empty container measurement are repeated. Therefore, one more DestinationStartingWeightData is collected, and the invalid one is disregarded in parser.",
			Category -> "Weighing Skills"
		},
		ValidWeighingContainerTareWeights -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the measured weight of the empty weighing container, i.e. EmptyContainerWeightData, is found valid by validTransferWeighingContainerTareWeightQ. If it was found invalid, the taring and empty container measurement are repeated. Therefore, one more EmptyContainerWeightData is collected, and the invalid one is disregarded in parser.",
			Category -> "Weighing Skills"
		},
		ReportedSpillFrees -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the operator reported no material loss on balance after transferring sample onto the weighing container. If False, a material loss is reported, the operator is instructed to go through cleaning and then retry the current loop of weighing. Therefore, one more data will be collected for the following fields: TareData, DestinationStartingWeightData, EmptyContainerWeightData, EmptyContainerWeights, MeasuredTransferWeightData, DestinationStartingWeightData, EmptyContainerWeightAppearances, MeasuredTransferWeightAppearances, and MaterialLossWeightAppearances. The data collected from the round with a self-reported loop is disregarded.",
			Category -> "Weighing Skills"
		},
		FastTrackMaterialLossRetry -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the error message for exceeding the material loss retry limit should be suppressed. If set to True, the engine will allow the operator to continue with another cycle of balance cleaning and reweighing after a reported material loss, bypassing the standard error prompt. By default, up to 3 retries are permitted. Any additional retries require this value to be manually set to True after the shift manager reviews the procedure with the operator.",
			Category ->  "Weighing Skills"
		},
		MovementObjects->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Sample],
				Object[Part]
			],
			Description -> "The objects that was moved onto the TransferEnvironment's work surface at the beginning of each loop.",
			Category -> "General",
			Developer -> True
		},
		CollectionObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Sample],
				Object[Part]
			],
			Description -> "The objects to remove from the TransferEnvironment's work surface when before it is released.",
			Category -> "General",
			Developer -> True
		},
		DiscardedObjects->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Sample],
				Object[Part]
			],
			Description -> "The objects to discard at the end of the protocol.",
			Category -> "General",
			Developer -> True
		}
	}
}]