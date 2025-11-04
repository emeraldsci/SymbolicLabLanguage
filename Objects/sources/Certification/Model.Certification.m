(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Certification],
	{
		Description->"A description of a skill set that is earned via the completion of a set of training modules.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			DeveloperObject->{
				Format->Single,
				Class->Expression,
				Pattern:>BooleanP,
				Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
				Category->"Organizational Information",
				Developer->True
			},
			TrainingModules->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[TrainingModule][ParentCertifications],
				Description->"Individual trainings completed in order to earn a certification.",
				Category->"Operations Information"
			},
			RequiredCertifications->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Certification],
				Description->"The list of skill sets needed before any training modules making up this certification can be started.",
				Category->"Operations Information"
			},
			Users -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> TypeP[Object[User]],
				Description -> "Indicates who this certification is intended to train. User types in this field must be an exact match of the user.",
				Category -> "Operations Information",
				Abstract -> True
			},
			AutoEnqueue -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this certification will automatically be added to a trainee's training queue once any required certifications are complete.",
				Category -> "Operations Information"
			},
			Deprecated -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "Indicates that this model is historical and no longer used.",
				Category -> "Operations Information",
				Abstract -> True
			}

		}
	}
];
