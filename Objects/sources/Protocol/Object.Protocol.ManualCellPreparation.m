(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, ManualCellPreparation], {
	Description->"A protocol that prepares cell samples (ex. incubation, washing, splitting, imaging etc.) for further experimentation, manually in the laboratory.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		InputUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation][Protocol],
			Description -> "The individual steps of the protocol that should be executed, as inputted by the user to the experiment function.",
			Category -> "General"
		},
		OptimizedUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation][Protocol],
			Description -> "The transformed steps of the protocol, re-arranged to be executed in the most efficient manner by the protocol.",
			Category -> "General"
		},
		CalculatedUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation][Protocol],
			Description -> "The optimized unit operations with fully specified options, in the order they will be executed in the laboratory.",
			Category -> "General"
		},
		OutputUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation][Protocol],
			Description -> "The unit operations, after they have been executed in the lab. These unit operations contain additional data about their execution (such as pressure traces, environmental data, etc.) as well as the specific samples, containers, and items that were used in the laboratory.",
			Category -> "General"
		},
		Protocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "For each member of CalculatedUnitOperations, the cell preparation protocol that was performed to execute that unit operation.",
			Category -> "General",
			IndexMatching -> CalculatedUnitOperations
		},
		UnresolvedUnitOperationInputs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[ObjectP[]|_String|_LabelField|_],
			Description -> "For each member of CalculatedUnitOperations, the inputs, including any unresolved Labels, that should be fed into the subprotocol task.",
			Category -> "General",
			IndexMatching -> CalculatedUnitOperations,
			Developer -> True
		},
		UnresolvedUnitOperationOptions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Rule...},
			Description -> "For each member of CalculatedUnitOperations, the options, including any unresolved Labels, that should be fed into the subprotocol task.",
			Category -> "General",
			IndexMatching -> CalculatedUnitOperations,
			Developer -> True
		},
		ResolvedUnitOperationInputs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[ObjectP[]|_],
			Description -> "For each member of CalculatedUnitOperations, the inputs, without any unresolved Labels, that should be fed into the subprotocol task.",
			Category -> "General",
			IndexMatching -> CalculatedUnitOperations,
			Developer -> True
		},
		ResolvedUnitOperationOptions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Rule...},
			Description -> "For each member of CalculatedUnitOperations, the options, without any unresolved Labels, that should be fed into the subprotocol task.",
			Category -> "General",
			IndexMatching -> CalculatedUnitOperations,
			Developer -> True
		},
		LabeledObjects -> {
			Format -> Multiple,
			Class -> {String,Link},
			Pattern :> {_String,_Link},
			Relation -> {Null,Object[Container]| Model[Container] | Object[Sample] | Model[Sample] | Object[Item] | Model[Item]},
			Description -> "Relates a LabelSample/LabelContainer's label to the sample or container which fulfilled the label during execution.",
			Category -> "General",
			Headers -> {"Label","Object"}
		},
		FutureLabeledObjects -> {
			Format -> Multiple,
			Class -> Expression,
			(* futureLabel_String -> Alternatives[{existingLabel_String, relationToFutureLabel:(Container|LocationPositionP)}, labelField_LabelField] *)
			Pattern :> (_String -> Alternatives[{_String, Container|LocationPositionP}, _LabelField]),
			Relation -> Null,
			Units -> None,
			Description -> "LabeledObjects will not exist until the protocol has finished running in the lab (created at parse time). For example, destination samples that are given labels are only created by Transfer's parser and therefore can only be added to the LabeledObjects field after parse time.",
			Category -> "General",
			Developer -> True
		},
		RequiredInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "Integrated instruments required for the protocol.",
			Category -> "General"
		},
		RequiredObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample],
				Model[Container],
				Object[Container],
				Model[Item],
				Object[Item],
				Model[Part],
				Object[Part],
				Model[Plumbing],
				Object[Plumbing]
			],
			Description -> "Objects that are required for this protocol. This includes both labeled and non-labeled objects.",
			Category -> "General",
			Developer -> True
		},
		PreparedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Resource, Sample][Preparation]
			],
			Description -> "The resource in the parent protocol that is fulfilled by performing the requested sample preparation to generate a new sample.",
			Category -> "Resources",
			Developer -> True
		}
	}
}];
