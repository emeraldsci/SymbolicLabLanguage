(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Replace, Filter], {
	Description->"A protocol that replaces the filters for the target instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FilterActivationLiquid -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The liquid used to chemically activate filter prior to the replacement.",
			Category -> "General",
			Developer->True
		},
		ActivationLiquidContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container used to hold the FilterActivationLiquid.",
			Category -> "General",
			Developer->True
		},
		ActivationLiquidTransferUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of the liquid sample used to activate filters into a container.",
			Category -> "General"
		},
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol executed to transfer FillLiquid to the FillLiquidContainer.",
			Category -> "Refilling"
		}
	}
}];
