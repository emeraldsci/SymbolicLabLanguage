(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Certification],
	{
		Description->"A record of a skill set a person has earned or is earning via the completion of a set of training modules.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			User->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[User][Certifications],
				Description->"The person who is earning or has earned this certification.",
				Category->"General"
			},
			ActiveTrainingModules->{
				Format->Multiple,
				Class->{Date, Expression, Link},
				Pattern:>{_?DateObjectQ, TrainingTypeP, _Link},
				Relation->{Null, Null, Object[TrainingModule][Certifications]|Model[TrainingModule]},
				Description->"Training modules currently being completed in order to earn this certification.",
				Category->"General",
				Headers->{"Date Created", "Training Type", "Training Module"}
			},
			Status->{
				Format->Single,
				Class->Expression,
				Pattern:>CertificationStatusP,
				Description->"An indicator of whether or not all training needed for this certification is completed and up-to-date.",
				Category->"General"
			},
			StatusLog -> {
				Format -> Multiple,
				Class -> {Date, Expression, Link},
				Pattern :> {_?DateObjectQ, CertificationStatusP, _Link},
				Relation -> {Null, Null, Object[User]},
				Description -> "A log of the status changes for this certification.",
				Category -> "General",
				Headers -> {"Date", "Status", "Responsible Party"}
			},
			CompletedTrainingModules->{
				Format->Multiple,
				Class->{Date, Expression, Link},
				Pattern:>{_?DateObjectQ, TrainingTypeP, _Link},
				Relation->{Null, Null, Object[TrainingModule]},
				Description->"A record of training modules required for this certification that have already been completed by the user.",
				Category->"General",
				Headers->{"Date Completed", "Training Type", "Training Module"}
			},
			DeveloperObject->{
				Format->Single,
				Class->Expression,
				Pattern:>BooleanP,
				Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
				Category->"Organizational Information",
				Developer->True
			}
		}
	}
];