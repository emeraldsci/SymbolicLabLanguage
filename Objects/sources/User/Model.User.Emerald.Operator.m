(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[User,Emerald, Operator],{
	Description -> "A model of user who is a current or former member of the Emerald Cloud Lab's operations team responsible for overseeing the conduct of experiments in the ECL's facilities.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		ProtocolPermissions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}],
			Description -> "The types of protocols/qualifications/maintenance that operators with this model can run.",
			Category -> "Training Information",
			Developer -> True
		},
		Specializations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> OperatorSpecializationP,
			Description :> "The special skills that this operator model has to perform laboratory experiments.",
			Category -> "Training Information",
			Developer -> True
		}
	}
}];
