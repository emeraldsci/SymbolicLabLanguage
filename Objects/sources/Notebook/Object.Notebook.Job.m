(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notebook, Job], {
	Description->"A job asset in a lab notebook, which generates one or more computations to run asynchronously on the ECL Manifold.",
	CreatePrivileges->Developer,
	Cache->Download,
	Fields -> {
		Archive -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this job has been archived, and should not appear in a list of recent computations.",
			Category -> "Organizational Information"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Active,Inactive,Aborted],
			Description -> "Current status of this job.",
			Category -> "Status"
		},
		JobType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				OneTime,
				Scheduled,
				Triggered
			],
			Description -> StringJoin[
				"Type describes the conditions under which this job will enqueue new computations. ",
				"OneTime jobs will enqueue a single computation, and automatically change Status to Inactive once a computation has been enqueued. ",
				"Scheduled jobs will enqueue computations at one or more ScheduledStartDates, and enqueue additiona repeat computations from these start dates according to ComputationFrequency. ",
				"Triggered jobs enqueue computations upon creation of objects of specified type(s), or upon changes to tracked type(s), object(s), or field(s)."
			],
			Category -> "Computation Conditions"
		},
		ScheduledStartDates -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "One or more dates at which this job should add a computation to the Manifold queue.",
			Category -> "Computation Conditions"
		},
		ComputationFrequency -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[1 Minute],
			Units -> Hour,
			Description -> "For each member of ScheduledStartDates, the frequency at which repeated computations should be enqueued. The first enqueued computation is the date specified in ScheduledStartDates.",
			Category -> "Computation Conditions",
			IndexMatching -> ScheduledStartDates
		},
		TrackedTypeChanges -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TypeP[],
			Description -> StringJoin[
				"Changes to objects of these type(s) will trigger this job. ",
				"If TrackedTypeFieldChanges is specified, this job will only be triggered when one of the tracked field(s) is updated. ",
				"Otherwise, computations will be queued if any fields in objects of the tracked type(s) are updated. ",
				"The template notebook may refer to triggering objects with $TrackedObjects, which will contain a list of objects of the tracked type(s) which have been changed."
			],
			Category -> "Computation Conditions"
		},
		TrackedTypeFieldChanges -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Symbol..}, (* Todo: N-Multiples *)
			Description -> StringJoin[
				"For each member of TrackedTypeChanges, a list of one or more field(s) to track. ",
				"This job will enqueue new computations when any of the tracked field(s) in objects of the tracked type(s) are updated. ",
				"The template notebook may refer to triggering objects with $TrackedObjects, which will contain a list of objects for which one of the tracked field(s) has been updated."
			],
			Category -> "Computation Conditions",
			IndexMatching -> TrackedTypeChanges
		},
		TrackedObjectChanges -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[],
			Description -> StringJoin[
				"Changes to one or more of these objects will trigger this job. ",
				"If TrackedObjectFieldChanges is specified, this job will only be triggered when one of the tracked field(s) is updated. ",
				"Otherwise, computations will be queued if any fields in the tracked object(s) are updated. ",
				"The template notebook may refer to triggering objects with $TrackedObjects, which will contain a list of the tracked objects which have been updated."
			],
			Category -> "Computation Conditions"
		},
		TrackedObjectFieldChanges -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Symbol..}, (* Todo: N-Multiples *)
			Description -> StringJoin[
				"For each member of TrackedObjectChanges, a list of one or more field(s) to track. ",
				"This job will enqueue new computations when any of the tracked field(s) in the tracked object(s) are updated. ",
				"The template notebook may refer to triggering objects with $TrackedObjects, which will contain a list of the tracked objects for which one of the tracked field(s) has been updated."
			],
			Category -> "Computation Conditions",
			IndexMatching -> TrackedObjectChanges
		},
		ComputationSchedule -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Relation -> {Null, Object[Notebook,Computation], Null},
			Headers -> {"Date", "Computation", "Status"},
			Pattern :> {
				_?DateObjectQ,
				Null|ObjectP[Object[Notebook,Computation]],
				Pending|Running|Completed|Error
			},
			Description -> StringJoin[
				"One or more dates at which this job will add a computation to the Manifold queue. ",
				"If Type includes Scheduled, then each scheduled start date will appear in this list. ",
				"If Type includes Repeating or Triggered, an entry will be appended to this list each time a new recurring computation is enqueued."
			],
			Category -> "Computation Conditions"
		},
		TemplateNotebookFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The Mathematica notebook file (.nb) containing the SLL commands to be run by Manifold. This template will be used to generate computations.",
			Category -> "Task Definition"
		},
		TemplateNotebook -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Page][ManifoldJobs],
			Description -> "The Mathematica notebook object that is saved on Constellation containing the SLL commands to be run by Manifold. If set, this template will supercede TemplateNotebookFile to generate computations.",
			Category -> "Task Definition"
		},
		TemplateSectionsJSON -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Base64 encoded JSON object representing the section/object hierarchy of this job template page.",
			Category -> "Organizational Information",
			Developer -> True
		},
		HardwareConfiguration -> {
			Format -> Single,
			Class -> Expression,
			Pattern:> Standard|HighRAM,
			Description->StringJoin[
				"Hardware specifications upon which this task should be run. ",
				"Standard - Fargate cluster with 8GB RAM. ",
				"HighRAM - Fargate cluster with 30GB RAM."
			],
			Category -> "Task Definition"
		},
		EstimatedRunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[1 Second],
			Units -> Second,
			Description -> "Estimated time which computations created by this job are expected to take. Must be less than MaximumRunTime.",
			Category -> "Task Definition"
		},
		MaximumRunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[1 Second],
			Units -> Second,
			Description -> "The maximum run time which computations created by this job are allowed to run for. If run time exceeds this value, the job will end with state TimedOut.",
			Category -> "Task Definition"
		},
		MaximumThreads -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The maximum number of computational threads that computations created by this job may use.",
			Category -> "Task Definition"
		},
		ZDriveFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "A list of all Z-drive file paths needed by this Manifold job.",
			Category -> "Task Definition",
			AdminViewOnly -> True,
			Developer -> True
		},
		FargateCluster -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Fargate cluster type to which computations spawned by this job should be submitted.",
			Category -> "Task Definition",
			AdminViewOnly -> True,
			Developer -> True
		},
		DisablePaclets -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "If True, the Mathematica kernel running this Manifold job will be launched with the -nopaclets command line option.",
			Category -> "Task Definition",
			AdminViewOnly -> True,
			Developer -> True
		},
		SLLVersion -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[
				Stable,
				Develop,
				_String
			],
			Description -> "The version (branch) of SLL on which this Manifold job should run. If SLLCommit is not specified, the most recent distro for the specified branch will be loaded.",
			Category -> "Task Definition",
			AdminWriteOnly -> True,
			Developer -> True
		},
		SLLCommit -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SHA-1 hash indicating which SLL commit this Manifold job should run. If not specified, will default to HEAD.",
			Category -> "Task Definition",
			AdminWriteOnly -> True,
			Developer -> True
		},
		SLLPackage -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Standard, Developer],
			Description -> "Determines whether SLL` or SLL`Dev` will be loaded for this Manifold job.",
			Category -> "Task Definition",
			AdminWriteOnly -> True,
			Developer -> True
		},
		MathematicaVersion -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The version of Mathematica to load for this Manifold job. If Null, version will default to 13.3.1.",
			Category -> "Task Definition",
			AdminWriteOnly -> True,
			Developer -> True
		},
		RunAsUser -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The user which Manifold will run the TemplateNotebookFile as.",
			Category -> "Task Definition",
			AdminWriteOnly -> True,
			Developer -> True
		},
		OriginalSLLCommit -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "SHA of the SLL commit that this job was created on.",
			Category -> "Manifold Tracking",
			Developer -> True
		},
		ComputationFinancingTeam -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing][ManifoldJobs],
			Description -> "The organization which should finance the computational costs of computations created by this job.",
			Category -> "Computations"
		},
		Computations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Computation][Job],
			Description -> "List of Manifold computations created by this job.",
			Category -> "Computations"
		},
		DestinationNotebook -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[LaboratoryNotebook],
			Description -> "The notebook in which all Computation pages spawned from the job will bed deposited.",
			Category -> "Computations"
		},
		DestinationNotebookNamingFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function,
			Description -> "A pure function to generate the names of the new computation notebook pages spawned from this job.",
			Category -> "Computations"
		},
		UnitTest -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitTest, Function][Job],
			Description -> "The unit test that launched this computation.",
			Category -> "Computations",
			Developer -> True
		},
		ParallelParentUnitTest -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitTest, Function][ParallelChildJobs],
			Description -> "The computation that spun off a number of parallel jobs (including this one).",
			Category -> "Computations",
			Developer->True
		},
		Environment -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Sandbox, Integrated],
			Description -> "The environment that will run the computation. E.g a localized development environment
			or an integrated environment.",
			Category -> "Task Definition",
			Developer -> True
		}
	}
}];
