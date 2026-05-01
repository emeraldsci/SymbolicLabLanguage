(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[SignatureBlock], {
	Description -> "A request and record of a set of signatures from specific roles or individuals.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Signatures -> {
			Format -> Multiple,
			Class -> {Integer, Expression, Link},
			Pattern :> {_Integer, SignatureRoleP, _Link},
			Relation -> {Null, Null, Object[Signature][SignatureBlock]},
			Description -> "The manifest of signatures required to complete this block, including the order in which the signatures must be fulfilled, and the purpose of the signature.",
			Category -> "Organizational Information",
			Headers -> {"Serialization","Role", "Signature Requirement"},
			Abstract -> True
		},
		Deadline -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date by which all of the signatures in this block must be completed.",
			Category -> "Organizational Information",
			Abstract -> True
		},

		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SignatureStatusP,
			Description -> "The current state of the signature block.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Relation -> {Null, Null, Object[User]},
			Pattern :> {_?DateObjectQ, SignatureStatusP, _Link},
			Description -> "The current state of the signature block.",
			Category -> "Organizational Information",
			Headers -> {"Date","Status","User"},
			Abstract -> True
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
}];


