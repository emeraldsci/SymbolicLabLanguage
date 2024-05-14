(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[User,Emerald, Developer],{
	Description -> "A user with developer privileges with who is a current or former employee of the Emerald Cloud Lab.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		PagerDutyID-> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The PagerDuty ID used to represent this person in PagerDuty's API.",
			Category -> "Company Information",
			Developer -> True
		},
		Remote -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "A boolean indicating whether a developer is working from a remote location.",
			Category -> "Company Information",
			Developer -> True
		}
	}
}];
