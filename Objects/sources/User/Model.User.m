(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[User], {
	Description -> "A model of user with login information on the ECL.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of this model of ECL user.",
			Category -> "Organizational Information",
			Abstract -> True
		},

		(* --- Developer object field --- *)
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},

		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this user model is historical and no longer used in the lab.",
			Category -> "Organizational Information"
		},

		(* Qualifications *)
		QualificationFrequency -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterP[0*Second]},
			Relation -> {Model[Qualification][Targets], Null},
			Units -> {None, Day},
			Description -> "A list of the Qualifications which should be run for users of this model and their required frequencies.",
			Headers -> {"Qualification Model", "Time"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		}
	}
}]
