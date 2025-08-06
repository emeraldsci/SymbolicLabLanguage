(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Software,Script], {
	Description->"An instance of a piece of software at a specific commit in history.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The people who created this script.",
			Category -> "Organizational Information"
		},
		DateLastStarted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The date and time that this script last began to run.",
			Category -> "Organizational Information"
		},
		DateLastCompleted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The date and time that this script last finishied running.",
			Category -> "Organizational Information"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Pass|Fail|Running,
			Description -> "Indicates whether the last run passed all checks or completed with errors.",
			Category -> "Organizational Information"
		},
		Frequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units->Hour,
			Description -> "Indicates how often this script is expected to run.",
			Category -> "Organizational Information"
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this script is historical and no longer used in the ECL.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Evaluations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Association,
			Description -> "A log of all evaluations completed in the script.",
			Category -> "Organizational Information"
		},
		TimedOut -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the last run timed out.",
			Category -> "Organizational Information"
		},
		Job -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Job],
			Description -> "The Job object which is responsible of launching this script.",
			Category -> "Organizational Information"
		}
	}
}];
