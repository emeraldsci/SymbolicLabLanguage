(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Program, ProcedureEvent], {
	Description->"Single log entry in the ProcedureLog for a protocol. Records information necessary for tracking progress of a protocol through a procedure and is used when resuming a protocol to the correct place.",
	CreatePrivileges->None,
	Cache->Session,
	FlatTable -> True,
	Fields -> {
		
		Procedure -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The procedure or subprocedure actively under execution when this event was logged.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		EventType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ProtocolEventP,
			Description -> "The action occurring during protocol execution which is being logged by this event.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ProtocolStatus -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ProtocolStatusP | OperationStatusP,
			Description -> "Status of the protocol at the time this event was logged.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Creator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[User],
				Object[Protocol],
				Object[Qualification],
				Object[Maintenance],
				Object[Repair]
			],
			Description -> "The person or protocol which generated this log entry.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		TaskID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "ID of the task in the procedure definition this event was logged for. Used to find the correct position in a procedure when re-opening a protocol.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		TaskType -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The task type from which the procedure event was generated.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		BranchObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Qualification],
				Object[Maintenance]
			],
			Description -> "When branching to another procedure, the procedure will be executed for each object in the list (in order).",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Iteration -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer?Positive,
			Units -> None,
			Description -> "The current index when looping a procedure over values in a field.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		TotalIterations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer?Positive,
			Units -> None,
			Description -> "The total number of times to iterate a sub-procedure over the values in a field.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		NumberOfItems -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer?Positive,
			Units -> None,
			Description -> "The number of individual actions or objects scanned in the task.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		CheckpointName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Title to describe the completion of a set of tasks in a procedure and having reached a specific point in the procedure.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		TaskJSON -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Base64 encoded JSON for the completed task received from Rosetta.js.",
			Category -> "Organizational Information",
			Abstract -> False
		},
		Votes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> VoteTypeP,
			Description -> "Operator opinion as to the effectiveness of the task with this TaskID.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Reload -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this event is part of a procedure reload initiated by using the 'Reload Procedure' button.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		TabletName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The tablet running the procedure when this event was created.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ErrorMessage -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "In the event of an error, a description of the reason behind the error.",
			Category -> "Troubleshooting",
			Abstract -> True
		},
		LegacySessionZipFile -> {
			Format -> Single,
			Class -> EmeraldCloudFile,
			Pattern :> EmeraldFileP,
			Description -> "Zip file containing session log from Rosetta.js. Includes screenshot, Mathematica messages log, and Javascript console output.",
			Category -> "Troubleshooting",
			Abstract -> True
		},
		TracingURL -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> URLP,
			Description -> "A link to a Honeycomb visualization of the events within the task.",
			Category -> "Troubleshooting"
		},
		TracingZipFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Zip file containing the list of functions run along with their timings during the loading, execution and completion of the previous task.",
			Category -> "Troubleshooting"
		},
		SessionZipFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Zip file containing session log from Rosetta.js. Includes screenshot, Mathematica messages log, and Javascript console output.",
			Category -> "Troubleshooting",
			Abstract -> True
		}
	}
}];
