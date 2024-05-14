(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,StrayDroplets], {
	Description->"A protocol that verifies an operator's ability to ensure centrifuged samples remain at the bottom of the container.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		StrayDropletsSamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,ManualSamplePreparation],
			Description -> "The Manual Sample Preparation sub protocol that tests the user's ability in avoiding stray droplet formation with microcentrifuge.",
			Category -> "StrayDroplets Skills"
		},
		StrayDropletsPreparatoryUnitOperations->{
			Units -> None,
			Relation -> Null,
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The list of sample preparation unit operations performed to test the user's ability in avoiding stray droplet formation with microcentrifuge.",
			Category -> "StrayDroplets Skills"
		},
		GradingCriteria -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The allowed percentage from the target mass the must be met to pass.",
			Category -> "Transfer Tubes Skills"
		}
	}
}
]