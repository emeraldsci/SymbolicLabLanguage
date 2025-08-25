(* ::Package:: *)

DefineObjectType[Model[Qualification, BiosafetyCabinet], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a biosafety cabinet.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Qualification Parameters *)
		TestLight -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the biosafety cabinet's lights are functional.",
			Category -> "Qualification Parameters"
		},
		TestUVLight -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the biosafety cabinet's ultraviolet lights are functional.",
			Category -> "Qualification Parameters"
		},
		TestAlarm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the biosafety cabinet throws an alarm when the sash is at working height.",
			Category -> "Qualification Parameters"
		},
		RecordFlowSpeed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should record the speed of the air entering the sample chamber opening when the biosafety cabinet's sash is at working height.",
			Category -> "Qualification Parameters"
		},
		RecordLaminarFlowSpeed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should record the speed of the filtered air flowing down to the sample chamber surface when the biosafety cabinet's sash is at working height.",
			Category -> "Qualification Parameters"
		},
		ImageCertification -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should take a photograph of the biosafety cabinet's certification sticker.",
			Category -> "Qualification Parameters"
		},
		(* Passing Criteria *)
		ExampleCertificationImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An example image of a certification sticker for a biosafety cabinet with this qualification model.",
			Category -> "Passing Criteria"
		}
	}
}];