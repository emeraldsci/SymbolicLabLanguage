(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notebook,Script], {
	Description->"A sequence of code that generates an experimental workflow that is executed in the laboratory.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ScriptStatusP, (* Template | InCart | Running | Exception | Paused | Stopped | Completed *)
			Description -> "The current status of this script.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ExceptionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ScriptExceptionTypeP,
			Description -> "The reason for the exception. None if there is no exception.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DateCompleted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which the last step of this script's execution was finished.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Script -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook][Protocols],
			Description -> "The script that created this script.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ParentProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][SubprotocolScripts],
				Object[Qualification][SubprotocolScripts],
				Object[Maintenance][SubprotocolScripts]
			],
			Description -> "The protocol that generated this script during its execution.",
			Category -> "General",
			Developer -> True
		},
		(* This field only stores the PAST expressions that have been run from this script. *)
		History -> {
			Format -> Multiple,
			Class -> {
				Expression -> Compressed, (* ex. Hold[1+1] *)
				Kernel -> Compressed, (* Stores the state of the kernel (down, up, and ownvalues) after this expression was evaluated. *)
				Messages -> Compressed, (* Stores the messages that were thrown during the evaluation of this expression. *)
				Exception -> Boolean, (* Indicates if a hard Error:: was thrown during this expression and the script needs to stop. *)
				Output -> Compressed, (* Stores the result of the computation. *)
				ObjectsGenerated -> Compressed (* Keeps track of the constellation objects generated during this expression. *)
			},
			Pattern :> {
				Expression -> _,
				Kernel -> KernelP|OldKernelV2P|OldKernelV1P,
				Messages -> _List,
				Exception -> BooleanP,
				Output -> _,
				ObjectsGenerated -> {ObjectP[]...}
			},
			Description -> "The series of code cells that have been run as part of this script.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		CurrentProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol]|Object[Qualification]|Object[Maintenance]|Object[Notebook,Script], (* Note: No backlink because this field is changed over time. *)
			Description -> "The protocol objects that must be completed before this script should resume.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ParallelizeProtocols -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the CurrentProtocols should be run in parallel or in series, if there are multiple.",
			Category -> "Organizational Information"
		},
		Overclock -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this script can be run or continued even if its author's team has exceeded its MaxNumberOfThreads (up to 2 * MaxNumberOfThreads).",
			Category -> "General",
			Developer -> True
		},
		TimeConstraint -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "The maximum amount of time that each cell in this script is allowed to run for before timing out.",
			Category -> "Organizational Information"
		},
		IgnoreWarnings -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the script should stop if a Warning message is thrown.",
			Category -> "Organizational Information"
		},
		TemplateNotebookFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The cloud file storing the original notebook used to create this script.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		TemplateNotebookFileLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[EmeraldCloudFile], Object[User]},
			Headers -> {"Date Changed", "Notebook", "Updating User"},
			Description -> "The history of files for the template notebooks, oldest to newest.",
			Category -> "Organizational Information"
		},
		TemplateDateModified -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the Notebook Template was modified.",
			Category -> "Organizational Information",
			Developer -> True
		},
		CompletedNotebookFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The cloud file storing the completed notebook over this script's history.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		CompletedNotebookFileLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[EmeraldCloudFile], Object[User]},
			Headers -> {"Date Changed", "Notebook", "Updating User"},
			Description -> "The history of files for the completed notebooks, oldest to newest.",
			Category -> "Organizational Information"
		},
		PendingNotebookFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The cloud file storing the pending notebook of this script's future commands.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		PendingNotebookFileLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[EmeraldCloudFile], Object[User]},
			Headers -> {"Date Changed", "Notebook", "Updating User"},
			Description -> "The history of files for the notebook with the pending commands, oldest to newest.",
			Category -> "Organizational Information"
		},
		InstanceDateCreated -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the Notebook Script Instance was created.",
			Category -> "Organizational Information",
			Developer -> True
		},
		InstanceDateModified -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the Notebook Script Instance was modified.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Contents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Maintenance],
				Object[Qualification],
				Object[Analysis],
				Object[Data],
				Object[Transaction],
				Object[Notebook, Script]
			],
			Description -> "References to protocols, analysis, and data that were created in this script.",
			Category -> "Organizational Information",
			Developer -> True (* We hide this field because the History  field already shows when certain objects were uploaded. *)
		},
		TemplateSectionsJSON -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Base64 encoded JSON object representing the section/object hierarchy of the page.",
			Category -> "Organizational Information",
			Developer -> True
		},
		InstanceSectionsJSON -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Base64 encoded JSON object representing the section/object hierarchy of the page.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Kernel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Local|Cloud,
			Description -> "Indicates whether this script should be run locally or in the cloud via Manifold.",
			Category -> "Organizational Information"
		},
		LogFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The cloud file storing the information about the execution of the script.",
			Category->"Organizational Information",
			Developer->True
		},

		UserCommunications->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[SupportTicket,UserCommunication][AffectedScript],
			Description->"Discussions with users about the set-up or execution of this script.",
			Category->"Organizational Information"
		},

		(* == Fields to Be Replaced, should be removed April 2024 post migration to SupportTicket ==*)
		TroubleshootingReports->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Troubleshooting, Report][AffectedScript],
			Description->"The troubleshooting reports field for this script.",
			Category->"Troubleshooting"
		},
		(* ==== *)

		Autogenerated->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the script was created programmatically or by a user.",
			Category->"Organizational Information",
			Developer->True
		},
		DesignOfExperiment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[DesignOfExperiment][Script],
			Description -> "The design of experiment that the script is based on.",
			Category -> "Organizational Information"
		},

		(* New fields to support "Scripts as Functions" *)
		Description -> {
			Category -> "Organizational Information",
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A summary of this Script Template, including any relevant details that are specific about this script."
		},

		InputArguments -> {
			Category -> "Organizational Information",
			Description -> "The set of arguments for the Script Template that are required to be filled to create a Script Instance.  For each listed argument, a corresponding $ScriptInput occurs somewhere in the code to indicate the location at which the literal values are explicitly substituted.",
			Format -> Multiple,
			Class -> {
				Name -> String,
				Pattern -> Expression,
				Description -> String},
			Pattern :> {
				Name -> _String,
				Pattern -> _,
				Description -> _String
			},
			Headers -> {
				Name -> "Name",
				Pattern -> "Pattern",
				Description -> "Description"
			}
		},

		(*This is field is used in Afterburner*)
		ScriptInputArguments -> {
			Category -> "Organizational Information",
			Description -> "Language-agnostic form of the data contained in the InputArguments field wherein the 'Pattern' subfield has been replaced with 'DataType', 'MinLength', and 'MaxLength'.  \
Name: The name of the argument matching the name inside $ScriptInput in the script.  \
DataType: Language-agnostic form of the data type for this argument.  e.g. \"Object.Sample\" or \"Integer\"   \
MinLength: The lowest number of elements for this argument.   \
MaxLength: The highest number of elements for this argument.   \
Description: Information about this argument.  \
SearchClause: A back-end query string to fetch the set of possible objects suitable for this argument.  \
ValidationFunction: A Wolfram Language function that runs on each element of the list that returns True if it passes validation tests, and False alongisde an explanatory message if it fails validation.  \
CorrelatedValidationFunction: A Wolfram Language function that runs the full list of inputs that returns True they collectively pass correlated validation tests, and False alongisde an explanatory message if it fails validation.",
			Developer -> True,
			Format -> Multiple,
			Class -> {
				Name -> String,
				DataType -> String, (*eg "Object.Sample" or "Integer" etc. *)
				MinLength -> Integer,
				MaxLength -> Integer,
				Description -> String,
				SearchClause -> String,
				ValidationFunction -> Expression,
				CorrelatedValidationFunction -> Expression
			},
			Pattern :> {
				Name -> _String,
				DataType -> "Object.Sample",
				MinLength -> _Integer,
				MaxLength -> _Integer,
				Description -> _String,
				SearchClause -> _String,
				ValidationFunction -> _Function,
				CorrelatedValidationFunction -> _Function
			},
			Headers -> {
				Name -> "Name",
				DataType -> "DataType",
				MinLength -> "Minimum length",
				MaxLength -> "Maximum length",
				Description -> "Description",
				SearchClause -> "Search clause",
				ValidationFunction -> "Validation function",
				CorrelatedValidationFunction -> "Correlated validation function"
			}
		},

		ParentScriptTemplate -> {
			Category -> "General",
			Description -> "The original script template that instantiated this script.",
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Script][ScriptInstantiations]
		},

		ScriptInstantiations -> {
			Category -> "General",
			Description -> "Scripts with filled arguments that have been generated from this script template.",
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Script][ParentScriptTemplate]
		},

		(*This field currently only supports filling a single argument as a list of Links to Sample[Object]*)
		FilledArguments -> {
			Category -> "Organizational Information",
			Description -> "The list of links to samples supplied as the argument to the Script Template.",
			Format -> Multiple,
			Pattern :> _Link,
			Class -> Link,
			Relation -> Object[Sample]
		},

		Output -> {
			Category -> "Organizational Information",
			Description -> "An Emerald Cloud File containing any data that was saved upon successful completion of a Script.",
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile]
		},

		ManifoldJob -> {
			Developer -> True,
			Category -> "Organizational Information",
			Description -> "The Manifold Job running this script. Only scripts launched from Afterburner will have an associated Job.",
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Job]
		}
	}
}];
