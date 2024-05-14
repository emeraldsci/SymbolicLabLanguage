(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Example, Person], {
	Description->"A person for testing and examples.",
	CreatePrivileges->None,
	Fields -> {
		FirstName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The person's given name.",
			Category -> "Personal Information",
			Abstract -> True
		},
		MiddleName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Any names placed between the first and last name of the person.",
			Category -> "Personal Information"
		},
		LastName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The person's family name (surname).",
			Category -> "Personal Information",
			Abstract -> True
		},
		Address -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Permanent home mailing address of the individual.",
			Category -> "Personal Information"
		},
		Email -> {
			Format -> Single,
			Class -> String,
			Pattern :> EmailP,
			Description -> "A person's e-mail address.",
			Category -> "Personal Information",
			Abstract -> True
		}
	}
}];
