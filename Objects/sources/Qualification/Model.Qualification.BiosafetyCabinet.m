(* ::Package:: *)

DefineObjectType[Model[Qualification, BiosafetyCabinet], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a biosafety cabinet.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample]
			],
			Description -> "The default buffer solution model which will be utilized during this qualification.",
			Category -> "General"
		}
	}
}];