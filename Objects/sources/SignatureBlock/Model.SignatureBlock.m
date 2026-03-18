(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[SignatureBlock], {
	Description -> "A requirement for a set of signatures.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* make serialized such that signer 3 cant sign until after the 1 and 2 *)
		(*TODO: add description of how the ordering works. Write spec of UploadSignature for Alexis and Al to review*)
		(* SignatureRoleP = (Approver|Reviewer|Author|Witness) *)
		(*Example of signature meanings*)
		Requirements -> {
			Format -> Multiple,
			Class -> {Integer, Expression, Link},
			Pattern :> {_Integer, SignatureRoleP, _Link},
			Relation -> {Null, Null, Model[Signature]},
			Description -> "The signatures which compose the block including the serialization, roles of the signatures in the context of the block, and the requirements of which user can sign for each.",
			Headers -> {"Serialization", "Role", "Requirement"},
			Category -> "Organizational Information",
			Abstract -> True
		},
		Timeline -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Units -> Day,
			Description -> "The amount of time allowed to complete this signature block. Individual requirements may have shorter timelines.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}]