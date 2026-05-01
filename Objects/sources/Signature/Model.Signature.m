(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Signature], {
	Description -> "The parameters for a signature from one or more people with specified qualities including skills, role, training, or technical competency.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		NumberOfSigners -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of signatures required from users who meet the indicated requirements.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Timeline -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Units -> Day,
			Description -> "The amount of time allowed to complete this signature.",
			Category -> "Organizational Information",
			Developer -> True
		},
		(* see https://helpx.adobe.com/sign/using/reason-for-signature.html *)
		Meaning -> {
			Format -> Single,
			Class -> String,
			Pattern :> SignatureMeaningP, (* Choose from predefined options: "I'm the Author"|"I'm the Reviewer"|"I'm the Approver" etc. *)
			Description -> "The reason and significance for this signature.",
			Category -> "Organizational Information"
		},

		(* These are ANY of the possible people who can sign*)
		AllowedDepartments -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EmeraldDepartmentP,
			Description -> "The specific organization(s) within ECL that are allowed to sign.",
			Category -> "Skills Knowledge and Ability",
			Abstract -> True
		},
		(* TODO: Make Model[User, Emerald] for each role, use this to link the Certifications/Competancies? *)
		AllowedRoles -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> EmeraldPositionP, (*EmeraldRoleP = Alternatives["Sci Ops Engineer I", "Sci Ops Engineer II", "Sci Ops Engineer III", "Senior Sci Ops Engineer", "Director of Scientific Engineering", "Sci Ops Technician I", "Head of Quality"]*)
			Description -> "The list of specific job function within the ECL organization that are allowed to sign.",
			Category -> "Skills Knowledge and Ability",
			Abstract -> True
		},

		(*These are requirements, meaning that the user must meet ALL listed criteria*)
		RequiredCompetancies -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> EmeraldCompetanciesP, (*EmeraldCompetanciesP = Alternatives["Chemistry", "Biology", "Spectroscopy", "EH&S", "Python", "SLL", "Engine Back End", "Design","Engine Front End", "Constellation"] - this is just an example*)
			Description -> "The technical skills knowledge and ability based on work experience and education required to fulfill this signature.",
			Category -> "Skills Knowledge and Ability",
			Abstract -> True
		},
		RequiredCertifications -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Certification],
			Description -> "The ECL and external trainings that must be completed and up to date in order to fulfill this signature.",
			Category -> "Skills Knowledge and Ability",
			Abstract -> True
		},

		(*Fields for non-ECL users - do we want this in the model? or in the Object?*)
		FinancingTeam -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing],
			Description -> "The non-ECL organization to which the signer must belong.",
			Category -> "Organizational Information"
		},
		ExternalRoles -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The specific job function(s) within the non-ECL organization that are allowed to sign.",
			Category -> "Organizational Information",
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

