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
		},
		ShiftTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ShiftTimeP,
			Description -> "If the developer works on a shift, the hours that the developer is scheduled to work on a regular basis - options include Morning, Night, Swing.",
			Category -> "Organizational Information"
		},
		ShiftName -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ShiftNameP,
			Description -> "If the developer works on a shift, the team name they are scheduled to work with. Options include Alpha and Bravo.",
			Category -> "Organizational Information"
		}
	}
}];
