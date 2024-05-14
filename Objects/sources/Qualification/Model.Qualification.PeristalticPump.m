(* ::Package:: *)

DefineObjectType[Model[Qualification, PeristalticPump], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a peristaltic pump.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		MaxAllowedVolumeDifference -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The maximum acceptable percent allowed volume difference between the sample before and after the filtration.",
			Category -> "Acceptance Criteria"
		}
	}
}];
