(* ::Package:: *)

DefineObjectType[Model[Qualification, Centrifuge], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a centrifuge.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		FilterModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Model[Item]
			],
			Description -> "The default filter model which will be utilized during qualifications of based on this model.",
			Category -> "Filtration"
		}
	}
}];
