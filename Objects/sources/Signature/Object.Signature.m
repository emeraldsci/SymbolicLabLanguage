(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Signature], {
	Description -> "A request and record for a a signature from a qualified or specific individual.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		RequiredUser -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The specific ECL team member or external user eligible to complete this signature.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		NumberOfSigners -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The minimum number of signers required, all of whom meet the indicated requirements.",
			Category -> "Organizational Information",
			Abstract -> True
		},

		(*Customer facing signature fields*)
		FinancingTeam -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing],
			Description -> "The non-ECL organization to which the signing user must belong, when the signature request is for an external user.",
			Category -> "Organizational Information"
		},

		(*SignatureStatusP: Outstanding|Processing|Completed*)
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SignatureStatusP,
			Description -> "The current state of the signature. A signature is completed when the requisite number of individuals has signed.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Deadline -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date by which the signatures must be completed.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		SignatureBlock -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[SignatureBlock][Signatures, 3],
			Description -> "The set of signatures which this is a part of.",
			Category -> "Organizational Information",
			Abstract -> True
		},

		StatusLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Relation -> {Null, Null, Object[User]},
			Pattern :> {_?DateObjectQ, SignatureStatusP, _Link},
			Description -> "The current state of the signature.",
			Category -> "Organizational Information",
			Headers -> {"Date","Status","User"},
			Abstract -> True
		},
		(* this object is a record of the signature, need {title, role, status, date, name, reason for signature} at the time of signature. *)
		(* The meaning of the signature can be stored in the model, or selected from a dropdown/entered manually when signing. This mirrors capabilities of Adobe Sign *)
		(*This is the fields where the e-signature is recorded*)
		Signatures -> {
			Format -> Multiple,
			Class -> {Date, Link, String, Expression, String},
			Pattern :> {_?DateObjectQ, _Link, Alternatives[EmeraldPositionP,_String], SignatureRoleP, Alternatives[_String, SignatureMeaningP]},
			Relation -> {Null, Object[User], Null, Null, Null},
			Description -> "A record of completed signatures including the date, signer, title, role, and purpose of the signature.",
			Category -> "Organizational Information",
			Headers -> {"Date","User", "Title", "Role", "Meaning of Signature"},
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

