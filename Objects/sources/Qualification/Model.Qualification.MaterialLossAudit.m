(* ::Package:: *)

DefineObjectType[Model[Qualification, MaterialLossAudit], {
	Description -> "Definition of a set of parameters for a qualification protocol that evaluates material loss reporting at a given site.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		MaxUnreportedMaterialLossRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The maximum acceptable percent of unit operations that are allowed to have an unreported material loss for the qualification to be considered passing.",
			Category -> "Acceptance Criteria"
		},
		TimePeriod->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Day],
			Units->Day,
			Description->"The time period over which to evaluate the site.",
			Category->"General"
		}
	}
}];
