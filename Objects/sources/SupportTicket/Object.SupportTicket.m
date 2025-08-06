 (* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[SupportTicket], {
	Description->"Tracking for a communication proccess used to discuss items such as improvements, procedures flow or customer logistics.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(* --- Organizational Information --- *)		
		DateResolved -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date when this issue was most recently marked resolved.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ReportedBy -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person who reported this issue.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Assignee -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The ECL team member responsible for resolving this issue.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		AssigneeLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[User], Object[User]},
			Description -> "A log of the ECL team member responsible for resolving this support ticket.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Assigning","Assignee"}
		},
		Followers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The relevant persons to be kept apprised of any updates to this issue, so that they may follow its progress.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		
		Resolved -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the immediate topic presented by this support ticket has been resolved or is still under investigation.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ResolvedLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of whether the support ticket has been resolved or not.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Deciding","Resolved"}
		},				
		Headline -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "One sentence description of the issue being reported.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		HeadlineLog -> {
			Format -> Multiple,
			Class -> {Date, Link, String},
			Pattern :> {_?DateObjectQ, _Link, _String},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of the headline of the issue being reported.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Deciding","Headline"},
			Developer -> True
		},
		Description -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A long form description of the issue being reported.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DescriptionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, String},
			Pattern :> {_?DateObjectQ, _Link, _String},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of the description of the issue being reported.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Deciding","Description"},
			Developer -> True
		},		
		Attachments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Additional supporting material describing this support ticket issue.",
			Category -> "Organizational Information"
		},
		AttachmentLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[User], Object[EmeraldCloudFile]},
			Description -> "A log of the additional supporting material describing this support ticket.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Attaching","Attachment"}
		},
		CommentLog -> {
			Format -> Multiple,
			Class -> {Date, Link, String},
			Pattern :> {_?DateObjectQ, _Link, _String},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of all the comments about the support ticket.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Commenting","Comment"}
		},
		ActionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, TroubleshootingActionP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of the actions executed on this support ticket.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Responsible","Action"}
		},
		AffectedApplication -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ECLApplicationP,
			Description -> "Indicates the ECL Application that is affected.",
			Category -> "Organizational Information"
		},
		AffectedApplicationLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, ECLApplicationP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of the affected Application.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Reporting","Affected Application"},
			Developer -> True
		},
		AffectedFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "The Emerald library function under discussion in this support ticket.",
			Category -> "Organizational Information"
		},
		AffectedFunctionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, _Symbol},
			Relation -> {Null, Object[User], Null},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of the Emerald library function call that this software bug presents itself in.",
			Category -> "Organizational Information",
			Developer -> True,
			Headers -> {"Date","Person Reporting","Affected Function"}
		},
		SourceProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][ProtocolSpecificInternalCommunications],
				Object[Qualification][ProtocolSpecificInternalCommunications],
				Object[Maintenance][ProtocolSpecificInternalCommunications]
			],
			Description -> "The parent or subprotocol that was processing when this ticket was filed.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Priority -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PriorityP,
			Description -> "Indicates the priority of resolving this support ticket. P1 is the lowest priority, P2 is considered medium priority and P3 is considered high priority. There is a special P5 priority for critical tasks requiring immediate attention.",
			Category -> "Organizational Information",
			Developer -> True
		},
		PriorityLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, PriorityP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of the priority assigned to the support ticket.",
			Category -> "Organizational Information",
			Developer -> True,
			Headers -> {"Date","Person Deciding","Priority"}
		},			
		RecentlyViewed -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Object[User]},
			Description -> "A list of when this support ticket was most recently viewed by each individual.",
			Headers -> {"Date","Person Viewing"},
			Category -> "Organizational Information",
			Developer -> True
		},
		IncidenceReduction -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Description of action taken to reduce the probability of this support ticket from repeating.",
			Category -> "Organizational Information"
		},
		ErrorSource->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The classification of the core issue that was responsible for this support ticket.",
			Category->"Organizational Information"
		},
		ErrorCategory->{
			Format->Single,
			Class->String,
			Pattern:>SupportTicketErrorSubcategoryP,
			Description->"The classification of the core issue that was responsible for this support ticket.",
			Category->"Organizational Information"
		},
		ReportedOperatorError -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if an error made by an operator was accidental and reported during their shift.",
			Category -> "Organizational Information",
			Developer -> True
		},
		SystematicChanges -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if scientific operations had an opportunity to make a change to something systematic (e.g. change a function, modify a procedure, change a frequency of maintenance) expected to lower the probability of the root cause of this issue from reoccurring in future experiments.",
			Category -> "Organizational Information",
			Developer -> True
		},
		PullRequest -> {
			Format -> Single,
			Class -> String,
			Pattern :> URLP,
			Description -> "A  GitHub link to a set of changes made to the codebase to prevent the underlying issue described in the ticket from returning.",
			Category -> "Organizational Information",
			Developer -> True
		},
		RootCauseCategory -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RootCauseCategoryP,
			Description -> "The classification of the core issue that was responsible for this support ticket.",
			Category -> "Organizational Information"
		},
		RootCauseCategoryLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, RootCauseCategoryP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of the root cause assigned to the support ticket.",
			Category -> "Organizational Information",
			Developer -> True,
			Headers -> {"Date","Person Deciding","Root Cause"}
		},
		Keywords -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TroubleshootingKeywordsP,
			Description -> "Specific words that pertain to this support ticket object, describing its main content and indicating the area of interests it falls into. These Keywords can subsequently be used to search for similar support ticket objects that also have some or all of those Keywords.",
			Category -> "Organizational Information",
			Developer -> True
		},
		KeywordsLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, {TroubleshootingKeywordsP..}},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of the keywords affiliated to this support ticket.",
			Category -> "Organizational Information",
			Developer -> True,
			Headers -> {"Date","Person Deciding","Keywords"}
		},

		(* --- Data Integrations --- *)
		Sync -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if an Asana task is created for this ticket by the Nexana system, and updates in Asana and Constellation will be synchronized. When set to Null, an Asana task will be created and synchronized.",
			Category -> "Organizational Information",
			Developer -> True
		},
		AsanaSyncedAttachments -> {
			Format      -> Multiple,
			Class       -> { String, Link },
			Pattern     :> { _String, _Link },
			Relation    -> { Null, Object[EmeraldCloudFile] },
			Headers     -> { "Asana Attachment GID", "EmeraldCloudFile" },
			Description -> "Asana attachment GID / cloud file pairs that have been synced to this support ticket.",
			Category    -> "Data Integrations"
		},

		(* --- Versioning --- *)
		SoftwareVersion -> {
			Format -> Multiple,
			Class -> {
				Application -> Expression,
				Mathematica -> String,
				Constellation -> String,
				SLL -> String,
				Distro -> Link
			},
			Pattern :> {
				Application -> {
					DeleteCases[ECLApplicationP, Mathematica],
					VersionNumberP
				},
				Mathematica -> VersionNumberP,
				Constellation -> _String,
				SLL -> _String,
				Distro -> _Link
			},
			Relation -> {
				Application -> {Null,Null},
				Mathematica -> Null,
				Constellation -> Null,
				SLL -> Null,
				Distro -> Object[Software, Distro]
			},
			Headers -> {
				Application -> "Application",
				Mathematica -> "VersionNumber",
				Constellation -> "ConstellationCommit",
				SLL -> "SLLCommit",
				Distro -> "SLLDistro"
			},
			Description -> "Indicates the version of the application (CommandCenter, Engine, or Nexus) from which the ticket was submitted, as well as the version information of Mathematica, Constellation, and SLL that were in use when this support ticket was filed.", 
			Category -> "Versioning"
		}
	}
}];
