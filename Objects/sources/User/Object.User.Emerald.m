(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[User,Emerald], {
	Description->"A user who is a current or former employee of the Emerald Cloud Lab.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* Note certain fields are marked Developer so that External users cannot see that information when viewing Emeraldians via troubleshooting reports *)
		(* --- Personal Information --- *)
		Biography -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A short biographical sketch about the person's work and educational history.",
			Category -> "Personal Information"
		},
		Photo -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PhotoFile]}, ImportCloudFile[Field[PhotoFile]]],
			Pattern :> _?ImageQ,
			Description -> "Headshot image of this person.",
			Category -> "Personal Information",
			Abstract -> True,
			Developer -> True
		},
		PhotoFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file containing a photo of this person.",
			Category -> "Personal Information",
			Developer -> True
		},
		CakePreference -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Type of birthday cake this users prefers to enjoy when celebrating the day of their birth.",
			Category -> "Personal Information"
		},

		(* --- Company Information --- *)
		HireDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The first day a person started working at Emerald.",
			Category -> "Company Information",
			Developer -> True
		},
		LastWorkDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The last/final day a person worked at Emerald.",
			Category -> "Company Information",
			Developer -> True
		},
		Position -> {
			Format -> Single,
			Class -> String,
			Pattern :> EmeraldPositionP,
			Description -> "Job title of the individual at Emerald.",
			Category -> "Company Information",
			Abstract -> True,
			Developer -> True
		},
		Manager -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User,Emerald][DirectReports],
			Description -> "The Emerald employee responsible for managing this employee.",
			Category -> "Company Information"
		},
		DirectReports -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User,Emerald][Manager],
			Description -> "The Emerald employees that this employee directly manages.",
			Category -> "Company Information"
		},
		Department -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EmeraldDepartmentP,
			Description -> "The department at Emerald that the user reports to.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Site->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Site],
			Description->"The Emerald facility where this person is based.",
			Category->"Company Information",
			Abstract->True
		},
		KeyCardID -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "First five digits of KeyCard ID, that is used to gain physical entry into ECL-1.",
			Category -> "Company Information",
			Developer -> True
		},
		AsanaGID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Asana GID used to represent this person in Asana's API.",
			Category -> "Company Information",
			Developer -> True
		},
		(* --- Training Information --- *)
		SafetyTrainingLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, SafetyTrainingP, _Link},
			Relation -> {Null, Null, Object[User]},
			Description -> "A log of the safety training completed by the user.",
			Category -> "Training Information",
			Headers -> {"Date","Type of Training","Witness"},
			Developer -> True
		},
		LabTechniqueTrainingLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, LabTechniqueTrainingP, _Link},
			Relation -> {Null, Null, Object[User]},
			Description -> "A log of all the lab techniques that the user has been trained on.",
			Category -> "Training Information",
			Headers -> {"Date","Type of Training","Witness"},
			Developer -> True
		},

		(* --- Operations Information fields --- *)

		(* NOTE: This is the same as the bottom of the ProtocolStack (the last since the stack is a stack). *)
		(* NOTE: This does NOT get updated to the most recent protocol on the top of the ProtocolStack because that would sever *)
		(* the two way link in the Protocol object. *)
		CurrentProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][CurrentOperator],
				Object[Maintenance][CurrentOperator],
				Object[Qualification][CurrentOperator]
			],
			Description -> "The protocol that this person is currently facilitating or assigned to facilitate. This is the same as the first protocol in the ProtocolStack field.",
			Category -> "Operations Information",
			Developer -> True
		},
		ProtocolStack -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Maintenance],
				Object[Qualification]
			],
			Description -> "The current stack of protocols, from top to bottom, that the operator is currently executing.",
			Category -> "Operations Information",
			Developer -> True
		},
		ProtocolLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, Enter|Exit, _Link},
			Relation -> {Null, Null, Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "Indicates times at which a user entered or exited a top level protocol.",
			Headers -> {"Date","Event","Protocol"},
			Category -> "Operations Information",
			Developer -> True
		},
		RecentProtocolLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, Enter|Exit, _Link},
			Relation -> {Null, Null, Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "Indicates times at which a user entered or exited a top level protocol. Limited to the most recent 5 weeks of ProtocolLog.",
			Headers -> {"Date","Event","Protocol"},
			Category -> "Operations Information",
			Developer -> True
		},
		PriorityProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol]| Object[Maintenance] | Object[Qualification]|Object[Protocol][ScheduledOperator]| Object[Maintenance][ScheduledOperator] | Object[Qualification][ScheduledOperator],
			Description -> "The protocol that is currently requesting to interrupt this operator.",
			Category -> "Operations Information",
			Developer -> True
		},
		PriorityProtocolLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, Scheduled|Fulfilled|TimedOut|Swapped, _Link},
			Relation -> {Null, Null, Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "Indicates times at which this user was interrupted to operate another protocol.",
			Headers -> {"Date", "Event", "Protocol"},
			Category -> "Operations Information",
			Developer -> True
		},
		FacilitiesReport -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that the user will receive digest emails on the status of the ECL facility.",
			Category -> "Operations Information",
			Developer -> True
		},
		AssociatedTickets -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[SupportTicket]},
			Description -> "A list of tickets representing resolvable or unresolvable errors made by this user.",
			Headers -> {"Ticket Created", "Resolvable", "Ticket"},
			Category -> "Operations Information",
			Developer -> True
		},
		DeputyID -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The identifier used in Deputy for this user.",
			Category -> "Organizational Information",
			Developer -> True
		},
		ShiftTracking -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this user's operations shifts and procedure executions are being logged in OperationStatus and OperationsLog.",
			Category -> "Organizational Information",
			Developer -> True
		},
		OperationStatus -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserOperationStatusP, (* OnShift | OffShift | OnBreak | InProtocol *)
			Description -> "Describes the current operational activity of this user.",
			Category -> "Organizational Information",
			Developer -> True
		},
		OperationsLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, UserOperationStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "A log of the OperationStatus changes for this user.",
			Headers -> {"Date", "Status", "Responsible Party"},
			Category -> "Organizational Information",
			Developer -> True
		},
		TrainingModules->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[TrainingModule][Operator],
			Description->"The list of training modules that this operator has been assigned to.",
			Category->"Operations Information"
		},
		DateTrained -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date that this operator completed all automatically enqueued certifications and was thus able to start running general protocols.",
			Category -> "Operations Information",
			Developer -> True
		},
		TeamsSupported-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing][SolutionsSupport],
			Description -> "The customers for whom this employee onboards and maintains Cloud Lab methods. Every customer has at least one assigned ECL Scientific Solutions team member responsible for collaborating with the subject matter experts to implement methods, build data analysis workflows and generate comprehensive reports.",
			Category -> "Organizational Information"
		},
		TeamsManaged -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing][ClientAccountManagers],
			Description -> "The customers for whom this employee builds and maintains a partnership. Every customer has at least one assigned ECL employee in this role. ECL employees may oversee multiple customer accounts.",
			Category -> "Organizational Information"
		}
	}
}];
