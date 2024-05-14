(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Software, DocumentationJob], {
	Description->"A single run of a documention building job.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Requestor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The user who requested this documentation job run.",
			Category -> "Organizational Information"
		},
		(* Note that DateCreated is inherited from Object.Software *)
		DateStarted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The date and time that this documentation job run was started.",
			Category -> "Organizational Information"
		},
		DateCompleted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The date and time that this documentation job was completed.",
			Category -> "Organizational Information"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Requested|Running|AwaitingNotification|Completed|Aborted,
			Description -> "Whether the documentation job run is currently started or has completed.",
			Category -> "Organizational Information"
		},
		NotifyOnlyOnChanges -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Whether emails should be sent only when the job results in doc changes or not.",
			Category -> "Organizational Information"
		},
		Distro -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Software, Distro],
			Description -> "The distro object that this documentation job run was run against.",
			Category -> "Organizational Information"
		},
		SymbolsRequested -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "A list of the symbols requested to have their docs rebuilt in this run.",
			Category -> "Organizational Information"
		},
		SymbolsChanged -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "A list of the symbols whose docs changed after this run.",
			Category -> "Organizational Information"
		},
		TypesRequested -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "A list of the types requested to have their docs rebuilt in this run.",
			Category -> "Organizational Information"
		},
		TypesChanged -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "A list of the types whose docs changed after this run.",
			Category -> "Organizational Information"
		},
		DocumentationArchive -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "An archive of the documentation created the appropriate format for the job.",
			Category -> "Organizational Information"
		}
	}
}];
