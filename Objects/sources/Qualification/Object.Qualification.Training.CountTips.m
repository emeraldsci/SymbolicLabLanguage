(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,CountTips], {
	Description->"A protocol that verifies an operator's ability to count the number of tips in a box of tips.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		QualTrainingTips->{
			Units -> None,
			Relation -> Object[Item]|Model[Item],
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Description -> "Box of 200ul non-sterile tips for Training only.",
			Category -> "General"
		},
		QualTrainingTipsCount -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The number of tips that the user counted during the qualification.",
			Category -> "General"
		},
		CountTipsMatchSLLQ -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the count inputted by the user matches with the count in SLL.",
			Category -> "General"
		},
		CountTipsImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> EmeraldCloudFileP,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The most recent images taken of this container.",
			Category -> "General"
		}
		}
}
]