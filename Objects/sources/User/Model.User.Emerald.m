(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[User, Emerald], {
	Description -> "A model of user who is a current or former employee of the Emerald Cloud Lab.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		QualificationLevel -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The difficulty level of protocols/qualifications/maintenance that operators with this model can run.",
			Category -> "Operations Information",
			Developer -> True
		}
	}
}]
