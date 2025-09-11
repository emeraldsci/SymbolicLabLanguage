(* ::Package:: *)

DefineObjectType[Model[Qualification, FumeHood], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a fume hood.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Qualification Parameters *)
		TestLight -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the fume hood's lights are functional.",
			Category -> "Qualification Parameters"
		},
		TestAlarm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the fume hood's flow meter throws an alarm when the sash is at working height.",
			Category -> "Qualification Parameters"
		},
		RecordFlowSpeed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should record the air passing through the opening of the fume hood when the sash is at working height.",
			Category -> "Qualification Parameters"
		},
		ImageCertification -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should take a photograph of the fume hood's certification sticker.",
			Category -> "Qualification Parameters"
		},
		(* Passing Criteria *)
		ExampleCertificationImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An example image of a certification sticker for a fume hood with this qualification model.",
			Category -> "Passing Criteria"
		}
	}
}];