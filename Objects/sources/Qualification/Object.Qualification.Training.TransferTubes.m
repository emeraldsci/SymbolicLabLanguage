(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,TransferTubes], {
	Description->"A protocol that verifies an operator's ability to accurately use a transfer tube.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TransferTubesPreparatoryUnitOperations->{
			Units -> None,
			Relation -> Null,
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The list of sample preparation unit operations performed to test the user's ability in using transfer tubes.",
			Category -> "Transfer Tubes Skills"
		},
		TransferSamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,ManualSamplePreparation],
			Description -> "The Manual Sample Preparation sub protocol that tests the user's ability to use transfer tubes.",
			Category -> "Transfer Tubes Skills"
		},
		GradingCriteria -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The allowed percentage from the target mass that must be met to pass the qualification.",
			Category -> "Transfer Tubes Skills"
		},
		AllowedTransferTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Units -> Minute,
			Description -> "The allowed time an operator can spend to complete a transfer task.",
			Category -> "Transfer Tubes Skills"
		}
	}
}
]