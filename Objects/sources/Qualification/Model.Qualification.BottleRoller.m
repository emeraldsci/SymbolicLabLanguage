(* ::Package:: *)

DefineObjectType[Model[Qualification,BottleRoller], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a bottle roller.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
	
		Tachometer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument]
			],
			Description -> "The instrument used to measure the rotation speed of the bottle roller.",
			Category -> "General"
		},
		ExpectedRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The expected rotational speed of the main shaft in the bottle roller.",
			Category -> "Acceptance Criteria"
		},
		MaxRotationRateError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The maximum acceptable absolute difference between measured rotation rate and expected rotation rate.",
			Category -> "Acceptance Criteria"
		}
			 																																																																								 																																																																						
	}
}];
