(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


$OperationStatisticsSharedFields = {
	(* --- Operations Statistics --- *)
	TotalLeadTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The time from when the experiment was confirmed (DateConfirmed) to when it was finished (DateCompleted).",
		Category -> "Operations Statistics",
		Developer -> True
	},
	TotalTurnaroundTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The time from when the experiment entered the lab operations queue (DateEnqueued) until it was completed (DateCompleted).",
		Category -> "Operations Statistics",
		Developer -> True
	},
	TotalCompletionTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The time from when the experiment was first picked up by an operator (DateStarted) to when it was finished (DateCompleted).",
		Category -> "Operations Statistics",
		Developer -> True
	},
	QueueTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The time the experiment spent in the lab operations queue before it was first started (DateEnqueued to DateStarted). This is also known as the time in OperatorStart, though the experiment may have been waiting for available inventory to be released (as opposed to ShippingMaterials), operator availability and/or instrumentation.",
		Category -> "Operations Statistics",
		Developer -> True
	},
	CycleTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The duration during which the experiment is actively processed, either by an operator (OperatorProcessing) or autonomously by an instrument (InstrumentProcessing).",
		Category -> "Operations Statistics",
		Developer -> True
	},
	TotalOperatorTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The duration during which the experiment is actively processed by an operator (OperatorProcessing).",
		Category -> "Operations Statistics",
		Developer -> True
	},
	TotalInstrumentTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The duration during which the experiment is actively processed by an instrument (InstrumentProcessing).",
		Category -> "Operations Statistics",
		Developer -> True
	},
	OperationConstraintTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The total time after processing started that the protocol was being worked on by teams other than lab operations or waiting for materials/instrumentation to be released by other experiments. During this time the experiment is in ShippingMaterials, RepairingInstrumentation, ScientificSupport or OperatorReady and waiting for materials.",
		Category -> "Operations Statistics",
		Developer -> True
	},
	WaitingTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The total time after processing started that the protocol was being worked on by teams other than lab operations, waiting for materials/instrumentation to be released by other experiments, or waiting for available lab operators. During this time the experiment is in ShippingMaterials, RepairingInstrumentation, ScientificSupport or OperatorReady.",
		Category -> "Operations Statistics",
		Developer -> True
	},
	WaitingTimesBreakdown -> {
		Format -> Single,
		Class -> {
			ShippingMaterials -> Real,
			InstrumentRepairs -> Real,
			ScientificSupport -> Real,
			ResourceAvailability -> Real,
			MaterialsAvailability -> Real,
			ECLMaterialsAvailability -> Real,
			UserMaterialsAvailability -> Real,
			InstrumentAvailability -> Real,
			OperatorReturn -> Real,
			SupportTicketQueue -> Real
		},
		Pattern :> {
			ShippingMaterials -> GreaterEqualP[0 Minute],
			InstrumentRepairs -> GreaterEqualP[0 Minute],
			ScientificSupport -> GreaterEqualP[0 Minute],
			ResourceAvailability -> GreaterEqualP[0 Minute],
			MaterialsAvailability -> GreaterEqualP[0 Minute],
			ECLMaterialsAvailability -> GreaterEqualP[0 Minute],
			UserMaterialsAvailability -> GreaterEqualP[0 Minute],
			InstrumentAvailability -> GreaterEqualP[0 Minute],
			OperatorReturn -> GreaterEqualP[0 Minute],
			SupportTicketQueue -> GreaterEqualP[0 Minute]
		},
		Units -> {
			ShippingMaterials -> Hour,
			InstrumentRepairs -> Hour,
			ScientificSupport -> Hour,
			ResourceAvailability -> Hour,
			MaterialsAvailability -> Hour,
			ECLMaterialsAvailability -> Hour,
			UserMaterialsAvailability -> Hour,
			InstrumentAvailability -> Hour,
			OperatorReturn -> Hour,
			SupportTicketQueue -> Hour
		},
		Description -> "The total time after processing started that the protocol was being worked on by teams other than lab operations, waiting for materials/instrumentation to be released by other experiments, or waiting for available lab operators. ShippingMaterials represents the time during which materials where being shipped to Emerald. InstrumentRepairs describes the time during which an instrument needed by the experiment was being fixed by Emerald or by an external vendor. ScientificSupport indicates times when the Scientific Operations team was working on solving an issue preventing the experiment from continuing. ResourceAvailability describes the total time where the protocol was waiting for materials and/or instrumentation to be released by other experiments. MaterialsAvailability is a subset of ResourceAvailability and refers just to the time where materials, including samples, containers, items, or parts were in use by other experiments. MaterialsAvailability is further broken down into ECLMaterialsAvailability and UserMaterialsAvailability which indicate if need materials were owned by ECL or by the experiment's author. InstrumentAvailability references when a piece of equipment was being used by another experiment. OperatorReturn indicates period where a protocol was ready for an operator to continue it (OperatorReady, with instruments and materials available). SupportTicketQueue represents the amount of time operators wait in the OperatorProcessing status before being able to proceed after filing a support ticket. Proceeding in this case includes performing the next task or blocking the protocol.",
		Category -> "Operations Statistics"
	},
	
	QueueTimesBreakdown -> {
		Format -> Single,
		Class -> {
			ResourceAvailability -> Real,
			MaterialsAvailability -> Real,
			ECLMaterialsAvailability -> Real,
			UserMaterialsAvailability -> Real,
			InstrumentAvailability -> Real,
			OperatorStart -> Real
		},
		Pattern :> {
			ResourceAvailability -> GreaterEqualP[0 Minute],
			MaterialsAvailability -> GreaterEqualP[0 Minute],
			ECLMaterialsAvailability -> GreaterEqualP[0 Minute],
			UserMaterialsAvailability -> GreaterEqualP[0 Minute],
			InstrumentAvailability -> GreaterEqualP[0 Minute],
			OperatorStart -> GreaterEqualP[0 Minute]
		},
		Units -> {
			ResourceAvailability -> Hour,
			MaterialsAvailability -> Hour,
			ECLMaterialsAvailability -> Hour,
			UserMaterialsAvailability -> Hour,	
			InstrumentAvailability -> Hour,
			OperatorStart -> Hour
		},
		Description -> "The total time before processing started that the protocol was waiting for materials/instrumentation to be released by other experiments, or waiting for available lab operators. ResourceAvailability describes the total time where the protocol was waiting for materials and/or instrumentation to be released by other experiments. MaterialsAvailability is a subset of ResourceAvailability and refers just to the time where materials, including samples, containers, items, or parts were in use by other experiments. MaterialsAvailability is further broken down into ECLMaterialsAvailability and UserMaterialsAvailability which indicate if need materials were owned by ECL or by the experiment's author. InstrumentAvailability references when a piece of equipment was being used by another experiment. OperatorStart indicates period where a protocol was ready for an operator to continue it.",
		Category -> "Operations Statistics"
	},

	EffectiveTurnaroundTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The time from when the experiment entered the lab operations queue (DateEnqueued) until it was finished (DateCompleted) subtracting any periods where the protocol was out of the operations queue (ShippingMaterials or RepairingInstrumentation).",
		Category -> "Operations Statistics",
		Developer -> True
	},

	EffectiveCompletionTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Hour,
		Description -> "The time from when the experiment was first picked up by an operator (DateStarted) to when it was finished (DateCompleted) subtracting any periods where the protocol was out of the operations queue (in ShippingMaterials or RepairingInstrumentation).",
		Category -> "Operations Statistics",
		Developer -> True
	}
};

With[
	{insertMe=Sequence@@$OperationStatisticsSharedFields},

	DefineObjectType[Object[Maintenance], {
		Description->"A detailed set of parameters describing the execution of a protocol that maintains the functionality of a target and keeps it operating to specification.",
		CreatePrivileges->None,
		Cache->Session,
		Fields -> {

			DateConfirmed -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The date on which the maintenance first entered processing.",
				Category -> "Organizational Information",
				Abstract -> True
			},
			DateEnqueued -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The date on which the maintenance was put accepted for execution in the ECL.",
				Category -> "Organizational Information",
				Abstract -> True
			},
			DateRequested -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The date on which the maintenance was available for ECL to begin activities in order to run the maintenance. If the maintenance was in and out of the user's backlog this will be the final time the maintenance exited the backlog. If the user immediately had threads available this will be the date the maintenance was first marked as Processing. In the case where the maintenance needed an instrument repair or materials before it could start, this is the time when when it entered ShippingMaterials or RepairingInstrumentation.",
				Category -> "General",
				Abstract -> True
			},
			DateStarted -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The date on which the maintenance moved from the front of the queue to begin running in the lab.",
				Category -> "Organizational Information"
			},
			DateCompleted -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The date on which the last step of this maintenance's execution was finished.",
				Category -> "Organizational Information",
				Abstract -> True
			},
			DateCanceled -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The date on which the maintenance was removed from the queue prior to starting.",
				Category -> "Organizational Information",
				Abstract -> True
			},
			Author -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[User],
				Description -> "The person who requested this maintenance to be run.",
				Category -> "Organizational Information"
			},
			Script -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Notebook][Protocols],
				Description -> "The experimental workflow (i.e., the script) that created this maintenance.",
				Category -> "Organizational Information",
				Abstract -> True
			},
			SubprotocolScripts -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Notebook, Script][ParentProtocol],
				Description -> "All experiment workflows (i.e., scripts) generated by this maintenance as a list of subprotocols.",
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
			CanaryBranch -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The user-defined git branch other than the stable branch on which this maintenance is meant to be run.",
				Category -> "Organizational Information",
				Developer -> True
			},
			Distro-> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Software,Distro],
				Description -> "The pre-built set of packages for a specific commit of SLL used to generate this maintenance.",
				Category -> "Organizational Information",
				Developer -> True
			},
			Commit -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The git SHA1 hash for the commit to load this maintenance for specific distro with Engine.",
				Category -> "General",
				Developer -> True
			},
			Status -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> ProtocolStatusP,
				Description -> "A general status indicating the stage of execution of the maintenance.  The most common states are before confirmation (InCart), after confirmation (Backlogged or Processing), or after completion (Completed).",
				Category -> "Organizational Information",
				Abstract -> True
			},
			OperationStatus -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> OperationStatusP,
				Description -> "A detailed status relevant during execution of the maintenance that describes whether the maintenance is actively being set up by an operator (OperatorProcessing), currently running on an instrument (InstrumentProcessing), or awaiting for further operator action (OperatorReady).",
				Category -> "Organizational Information",
				Developer -> True
			},
			Checkpoints -> {
				Format -> Multiple,
				Class -> {String, Real, String, Link},
				Pattern :> {_String, GreaterEqualP[0*Second], _String, _Link},
				Units -> {None, Minute, None, None},
				Relation -> {Null, Null, Null, Model[User, Emerald]|Object[User, Emerald]},
				Description -> "A list of expected checkpoints and estimated time (including processing stages) for each checkpoint in the procedure of the maintenance.",
				Category -> "Organizational Information",
				Headers -> {"Name", "Duration", "Description", "Operator"}

			},
			CheckpointProgress -> {
				Format -> Multiple,
				Class -> {String, Date, Date},
				Pattern :> {_String, _?DateObjectQ, _?DateObjectQ | Null},
				Units -> {None, None, None},
				Description -> "A listing of all the checkpoints passed in the execution of this maintenance.",
				Category -> "Organizational Information",
				Headers -> {"Name","Start Time","End Time"}
			},
			ProcedureLog -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Program][Protocol],
				Description -> "A list of log events tracking every step that has occurred in the progress of the current maintenance.",
				Category -> "Organizational Information",
				Developer -> True
			},
			StatusLog -> {
				Format -> Multiple,
				Class -> {Expression, Expression, Link},
				Pattern :> {_?DateObjectQ, ProtocolStatusP | OperationStatusP, _Link},
				Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance] | Object[Repair]},
				Description -> "Log of the history of the Status and OperationStatus fields for this maintenance.",
				Category -> "Organizational Information",
				Headers -> {"Date","Status","Protocol/Person"},
				Developer -> True
			},
			Target -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument],
					Model[Container],
					Object[Instrument],
					Object[Container],
					Object[Sample],
					Object[Sensor][Maintenance],
					Object[Part][Maintenance],
					Object[Item][Maintenance],
					Object[Plumbing],
					Object[Wiring],
					Object[Product]
				],
				Description -> "The designated object that this maintenance is intended to service.",
				Category -> "General",
				Abstract -> True
			},
			CurrentInstruments -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Instrument][CurrentProtocol],
				Description -> "The instruments which are actively being used by this maintenance.",
				Category -> "General",
				Developer -> True
			},
			ReservedStorageAvailability -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[StorageAvailability][CurrentProtocol],
				Description -> "The positions used for storage that are reserved for this maintenance during a storage task.",
				Category -> "Storage Information",
				Developer -> True
			},
			InstrumentLog -> {
				Format -> Multiple,
				Class -> {Date, Link},
				Pattern :> {_?DateObjectQ, _Link},
				Relation -> {Null, Object[Instrument]},
				Description -> "Log of the instruments used during execution of this maintenance.",
				Category -> "Organizational Information",
				Headers -> {"Date","Instrument"},
				Developer -> True
			},
			InstrumentRepairs -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Repair][AffectedProtocols],
				Description -> "A record of instrument maintenance or servicing required throughout this experiment.",
				Category -> "General",
				Developer -> True
			},
			Site -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container,Site],
				Description -> "The ECL site at which this maintenance was executed.",
				Category -> "Organizational Information",
				Abstract -> True
			},
			Sterile -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "Indicates if aseptic techniques are followed for handling this sample in lab. Aseptic techniques include sanitization, autoclaving, sterile filtration, or transferring in a biosafety cabinet during experimentation and storage.",
				Category -> "General"
			},
			CartResources -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Description -> "Any resources that must be re-picked for use in this maintenance upon resumption from scientific support or processing.",
				Category -> "Protocol Support",
				Developer -> True
			},
			CartInstruments -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Instrument],
				Description -> "Any instruments that must be re-selected for use in this maintenance upon resumption from scientific support or processing.",
				Category -> "Protocol Support",
				Developer -> True
			},
			CoveredCartResources -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Sensor],
					Object[Wiring]
				],
				Description -> "Any resources that must be re-covered after resource picking of CartResources for use in this maintenance upon resumption from scientific support or processing.",
				Category -> "Protocol Support",
				Developer -> True
			},
			ImagingSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container]
				],
				Description -> "Any resources used during the course of this maintenance that must be imaged.",
				Category -> "General",
				Developer -> True
			},
			VolumeMeasurementSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container]
				],
				Description -> "Any resources used during the course of this maintenance whose volumes must be updated.",
				Category -> "General",
				Developer -> True
			},
			WeightMeasurementSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container]
				],
				Description -> "Any resources used during the course of this maintenance whose weights must be updated.",
				Category -> "General",
				Developer -> True
			},
			Sensors -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Sensor],
				Description -> "The sensors used during execution of this maintenance.",
				Category -> "General"
			},
			LiquidHandlingLogs -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "The instrumentation trace files that monitored and recorded the execution of robotic liquid handling performed in this maintenance.",
				Category -> "General"
			},
			LiquidHandlingLogPaths -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> FilePathP,
				Description -> "The file paths of the instrumentation trace files that monitored and recorded the execution of robotic liquid handling performed in this maintenance.",
				Category -> "General",
				Developer -> True
			},
			Data -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Data][Maintenance]
				],
				Description -> "Primary data generated by this maintenance.",
				Category -> "Experimental Results"
			},
			UserCommunications -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[SupportTicket, UserCommunication][AffectedProtocol],
				Description -> "Discussions with users about the execution of this top-level maintenance.",
				Category -> "Protocol Support"
			},
			InternalCommunications -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[SupportTicket, Operations][AffectedProtocol],
				Description -> "Support tickets associated with the execution of this top-level maintenance.",
				Category -> "Protocol Support",
				Developer -> True,
				AdminViewOnly -> True
			},
			ProtocolSpecificInternalCommunications -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[SupportTicket][SourceProtocol],
				Description -> "Support tickets that were encountered during execution of this particular maintenance (parent or subprotocol as the case may be).",
				Category -> "Protocol Support",
				Developer -> True,
				AdminViewOnly -> True
			},
			SupportNotebook -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Notebook, Page],
				Description -> "The record of manual intervention steps performed during scientific support of this maintenance.",
				Category -> "Protocol Support",
				Developer -> True,
				AdminViewOnly -> True
			},

			(* ===== *)
			ObjectReplacementLog -> {
				Format -> Multiple,
				Class -> {Expression, Expression, Expression, Link, Link, Link},
				Pattern:> {_?DateObjectQ, _Link, _Field, _Link, _Link, _Link},
				Relation -> {
					Null,
					Alternatives[Object[Qualification],Object[Protocol],Object[Maintenance], Object[Resource], Object[UnitOperation], Object[Program]],
					Null,
					Alternatives[
						Object[Container],Object[Sample],Object[Item],Object[Instrument],Object[Plumbing],Object[Wiring],Object[Part],Object[Sensor],
						Model[Container],Model[Sample],Model[Item],Model[Instrument],Model[Plumbing],Model[Wiring],Model[Part],Model[Sensor]
					],
					Alternatives[
						Object[Container],Object[Sample],Object[Item],Object[Instrument],Object[Plumbing],Object[Wiring],Object[Part],Object[Sensor],
						Model[Container],Model[Sample],Model[Item],Model[Instrument],Model[Plumbing],Model[Wiring],Model[Part],Model[Sensor]
					],
					Object[User]
				},
				Description -> "A list of labware replaced during the course of running this maintenance.",
				Headers -> {"Date", "Object Updated", "Field Updated", "Original Labware", "New Labware", "UpdatedBy"},
				Developer -> True,
				Category->"Protocol Support"
			},
			ParentProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Protocol][Subprotocols],
					Object[Qualification][Subprotocols],
					Object[Maintenance][Subprotocols]
				],
				Description -> "The protocol that generated this sub-maintenance during its execution.",
				Category -> "Organizational Information",
				Developer -> True
			},
			RootProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Protocol],
					Object[Qualification],
					Object[Maintenance]
				],
				Description -> "The highest-level parent protocol that generated this maintenance (or the one that generated the subprotocol that generated this maintenance, etc.) during its execution. If this maintenance is the highest-level parent protocol, then its RootProtocol field will link to itself.",
				Category -> "General",
				Developer -> True
			},
			Subprotocols -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Protocol][ParentProtocol],
					Object[Qualification][ParentProtocol],
					Object[Maintenance][ParentProtocol]
				],
				Description -> "Any specific-purpose protocols that were generated by this maintenance during its execution.",
				Category -> "Organizational Information",
				Developer -> True
			},
			SubprotocolDescription -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "A short title indicating what this subprotocol accomplishes.",
				Category -> "Organizational Information",
				Abstract -> True
			},
			ReplacementProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation ->  Alternatives[
					Object[Protocol],
					Object[Qualification],
					Object[Maintenance]
				],
				Description -> "If this maintenance was aborted due to technical reasons, links to the replacement maintenance run in it's place.",
				Category -> "Organizational Information"
			},
			PostProcessingProtocols -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Protocol],
				Description -> "Protocols used to analyze samples after the main maintenance is complete (such as volume measurement or sample imaging).",
				Category -> "Sample Post-Processing"
			},
			PostProcessing -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Protocol],
				Description -> "Protocols used to perform post-processing such as sample imaging or volume measurement.",
				Category -> "Sample Post-Processing"
			},
			CurrentOperator -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				(* If we are operating this as our main maintenance (not in a interrupting snapback), we upload the backlink. *)
				(* Otherwise, we upload this without a backlink because we want to allow the user to operator more than one maintenance and the same time. *)
				(* Also because we can't backlink to the PriorityProtocol field since that field is set by the scheduler to tell the user about the interrupt (before they start operating). *)
				Relation -> Object[User,Emerald][CurrentProtocol]|Object[User,Emerald],
				Description -> "The operator that is currently assigned to execute this maintenance.",
				Category -> "General",
				Developer -> True
			},
			CurrentTablet -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Part,Computer],
				Description -> "The tablet computer on which the maintenance is currently being executed in Engine.",
				Category -> "General",
				Developer -> True
			},
			ActiveCart -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container],
				Description -> "The operator cart currently in use by the CurrentOperator for this maintenance.",
				Category -> "General",
				Developer -> True
			},
			CartLog -> {
				Format -> Multiple,
				Class -> {Date, Link},
				Pattern :> {_?DateObjectQ, _Link},
				Relation -> {Null, Object[Container,OperatorCart]},
				Description -> "Log of the history of the operator carts used for this maintenance.",
				Category -> "Organizational Information",
				Headers -> {"Date","Cart"},
				Developer -> True
			},
			ActiveRacks -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Container, Rack],Model[Container, Rack]],
				Description -> "The racks that are currently located on the ActiveCart and into which containers can be placed immediately from resource picking.",
				Category -> "General",
				Developer -> True
			},
			HoldOrder -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the queue position of this maintenance should be strictly enforced, regardless of the available resources in the lab.",
				Category -> "Organizational Information",
				Developer -> True
			},
			BatchedStorage -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if storage via StorageUpdate is available for this maintenance. When True, items not requiring specialized storage conditions will be placed in a holding area during storage tasks.",
				Category -> "General",
				Developer -> True
			},
			Priority -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this maintenance should be prioritized over other protocols in the queue to start at the given StartDate, have dedicated operation for its entirety, and not be interrupted by other protocols.",
				Category -> "Organizational Information",
				Developer -> True
			},
			StartDate -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The date at which this maintenance should be prioritized to start if Priority is set to True.",
				Category -> "Organizational Information"
			},
			PriorityReturn -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this maintenance must interrupt a non-DangerZone protocol to be picked up at the indicated PickUpTime.",
				Category -> "Organizational Information",
				Developer -> True
			},
			ScheduledOperator -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[User, Emerald][PriorityProtocol],
				Description -> "The operator that is scheduled to be interrupted from their own protocol by this priority maintenance.",
				Category -> "Organizational Information",
				Developer -> True
			},
			ExplicitPriorityReturn -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the priority return for this maintenance was explicitly required by the developer. If the priority return was explicitly required, the DangerZoneCounter will be incremented when the maintenance is returned to. If the priority return was not explicitly required, the DangerZoneCounter will not be incremented when returned to.",
				Category -> "Organizational Information",
				Developer -> True
			},
			PickUpTime -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The date at which an operator should re-enter this maintenance and pick it up from processing.",
				Category -> "Organizational Information",
				Developer -> True
			},
			PriorityReturnEstimatedTime -> {
				Format -> Single,
				Class -> Real,
				Pattern :> TimeP,
				Units -> Hour,
				Description -> "The estimated time that the operator will spend in the DangerZone that follows the time critical interrupt.",
				Category -> "Organizational Information",
				Developer -> True
			},
			PriorityReturnAlarm -> {
				Format -> Single,
				Class -> Real,
				Pattern :> TimeP,
				Units -> Hour,
				Description -> "The amount of time that is allowed to pass before an alarm is raised about a missed priority event.",
				Category -> "Organizational Information",
				Developer -> True
			},
			PriorityReturnBuffer -> {
				Format -> Single,
				Class -> Real,
				Pattern :> TimeP,
				Units -> Hour,
				Description -> "The amount of time that an operator should be interrupted before the priority event.",
				Category -> "Organizational Information",
				Developer -> True
			},
			ReturnToProtocol -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if operators should return to their original protocol if they have been interrupted to complete a time critical event for this maintenance.",
				Category -> "Organizational Information",
				Developer -> True
			},
			DangerZone -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the current operator is forbidden from exiting until DangerZone is set to False. This field is set to True if DangerZoneCounter>0 and is set to False if DangerZoneCounter==0.",
				Category -> "Organizational Information",
				Developer -> True
			},
			DangerZoneCounter -> {
				Format -> Single,
				Class -> Integer,
				Pattern :> _Integer,
				Description -> "The number of StartDangerZone tasks that this maintenance has encountered. If this field is greater than zero, this maintenance is currently in a DangerZone. This field is only tracked in the parent protocol object.",
				Category -> "Organizational Information",
				Developer -> True
			},
			PriorityReturnLog -> {
				Format -> Multiple,
				Class -> {
					Date,
					Boolean,
					Link
				},
				Pattern :> {
					_?DateObjectQ,
					BooleanP,
					_Link
				},
				Relation -> {
					Null,
					Null,
					Object[User]
				},
				Headers -> {"Date","PriorityReturn","Responsible Party"},
				Description -> "The historical record of the PriorityReturn field.",
				Category -> "Organizational Information",
				Developer -> True
			},
			PickUpTimeLog -> {
				Format -> Multiple,
				Class -> {
					Date,
					Date,
					Link
				},
				Pattern :> {
					_?DateObjectQ,
					_?DateObjectQ,
					_Link
				},
				Relation -> {
					Null,
					Null,
					Object[User]
				},
				Headers -> {"Date","PickUpTime","Responsible Party"},
				Description -> "The historical record of the PickUpTime field.",
				Category -> "Organizational Information",
				Developer -> True
			},
			PriorityReturnEstimatedTimeLog -> {
				Format -> Multiple,
				Class -> {
					Date,
					Real,
					Link
				},
				Pattern :> {
					_?DateObjectQ,
					TimeP,
					_Link
				},
				Relation -> {
					Null,
					Null,
					Object[User]
				},
				Units :> {
					None,
					Hour,
					None
				},
				Headers -> {"Date","PriorityReturnEstimatedTime","Responsible Party"},
				Description -> "The historical record of the PriorityReturnEstimatedTime field.",
				Category -> "Organizational Information",
				Developer -> True
			},
			PriorityReturnAlarmLog -> {
				Format -> Multiple,
				Class -> {
					Date,
					Real,
					Link
				},
				Pattern :> {
					_?DateObjectQ,
					TimeP,
					_Link
				},
				Relation -> {
					Null,
					Null,
					Object[User]
				},
				Units :> {
					None,
					Hour,
					None
				},
				Headers -> {"Date","PriorityReturnAlarm","Responsible Party"},
				Description -> "The historical record of the PriorityReturnAlarm field.",
				Category -> "Organizational Information",
				Developer -> True
			},
			PriorityReturnBufferLog -> {
				Format -> Multiple,
				Class -> {
					Date,
					Real,
					Link
				},
				Pattern :> {
					_?DateObjectQ,
					TimeP,
					_Link
				},
				Relation -> {
					Null,
					Null,
					Object[User]
				},
				Units :> {
					None,
					Hour,
					None
				},
				Headers -> {"Date","PriorityReturnBuffer","Responsible Party"},
				Description -> "The historical record of the PriorityReturnBuffer field.",
				Category -> "Organizational Information",
				Developer -> True
			},
			ReturnToProtocolLog -> {
				Format -> Multiple,
				Class -> {
					Date,
					Boolean,
					Link
				},
				Pattern :> {
					_?DateObjectQ,
					BooleanP,
					_Link
				},
				Relation -> {
					Null,
					Null,
					Object[User]
				},
				Headers -> {"Date","ReturnToProtocol","Responsible Party"},
				Description -> "The historical record of the ReturnToProtocol field.",
				Category -> "Organizational Information",
				Developer -> True
			},
			Overclock -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this maintenance can be run or continued even if its author's team has exceeded its MaxNumberOfThreads (up to 2 * MaxNumberOfThreads).",
				Category -> "General",
				Developer -> True
			},
			HandsFreeOperation -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this maintenance is currently in a HandsFreeOperation procedure. This means the operator is controlling Engine through foot pedals and are currently working inside a biosafety cabinet.",
				Category -> "General",
				Developer -> True
			},
			HandsFreeOperationLog -> {
				Format -> Multiple,
				Class -> {
					Date,
					Expression,
					Link,
					Link
				},
				Pattern :> {
					_?DateObjectQ,
					BooleanP,
					_Link,
					_Link
				},
				Relation -> {
					Null,
					Null,
					Object[Instrument],
					Object[User]
				},
				Headers -> {"Date","Status","Instrument","Responsible Party"},
				Description -> "The historical record of a maintenance entering and exiting HandsFreeOperation.",
				Category -> "General",
				Developer -> True
			},
			ResumeHandsFreeOperation -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the operator of this maintenance must re-enter a hands free operation to the most recently exited instrument in the HandsFreeOperationLog upon resuming from scientific support or processing.",
				Category -> "General",
				Developer -> True
			},
			Resources -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample][CurrentProtocol],
					Object[Container][CurrentProtocol],
					Object[Part][CurrentProtocol],
					Object[Plumbing][CurrentProtocol],
					Object[Item][CurrentProtocol],
					Object[Sensor][CurrentProtocol],
					Object[Wiring][CurrentProtocol],
					Object[Package][CurrentProtocol]
				],
				Description -> "The items (e.g., samples, containers, parts, items) which are actively being used by this maintenance.",
				Category -> "Resources",
				Developer -> True
			},
			RequiredResources -> {
				Format -> Multiple,
				Class -> {Link, Expression, Integer, Expression},
				Pattern :> {_Link, _Symbol, _Integer, _Integer|_Symbol},
				Relation -> {Object[Resource][Requestor], Null, Null, Null},
				Units -> {None, None, None, None},
				Description -> "Resources used by this maintenance and a description of the field in which a resource's resolved object is stored. Position and index are Null when a resource's resolution is stored in a single field.",
				Category -> "Resources",
				Headers -> {"Resource","Field Name","Field Position", "Field Index"},
				Developer -> True
			},
			SubprotocolRequiredResources -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Resource][RootProtocol],
				Description -> "The resource objects tied to this parent maintenance, including all resources of the maintenance itself and its subprotocols.",
				Category -> "Resources",
				Developer -> True
			},
			DispenserContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "Containers gathered as destinations for any resources obtained from a chemical dispenser.",
				Category -> "Resources"
			},
			GasSources -> {
				Format -> Multiple,
				Class-> {Expression, Link, Link},
				Pattern :> {GasP, _Link, _Link},
				Relation -> {
					Null,
					Object[Container],
					Object[Instrument]
				},
				Description -> "A list of containers that supply gas to instruments in this maintenance through plumbing connections.",
				Headers -> {"Gas Type", "Source Container", "Supplied Instrument"},
				Category -> "Resources"
			},
			AwaitingResources -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this maintenance is awaiting the arrival of items before it can be begun or continued.",
				Category -> "Resources"
			},
			ShippingMaterials -> {
				Format -> Multiple,
				Class -> {Link, Link},
				Pattern :> {_Link, _Link},
				Relation ->{Alternatives[Object[Transaction, Order][DependentProtocols], Object[Transaction, ShipToECL][DependentProtocols], Object[Transaction, SiteToSite][DependentProtocols]], Alternatives[Object[Product], Object[Sample], Model[Sample], Model[Item], Object[Item]]},
				Description -> "Indicates the transactions, and the specific products or samples therein, that must be received before this maintenance can be begun or continued.",
				Category -> "Resources",
				Headers -> {"Transaction", "Required Product"}
			},
			Result -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> QualificationResultP,
				Description -> "Indicates if the maintenance achieved its objective, such as if it produced an acceptable calibration.",
				Category -> "Experimental Results",
				Abstract -> True
			},
			InitialNitrogenPressure -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The pressure data of the nitrogen gas source before starting the experiment.",
				Category -> "General"
			},
			NitrogenPressureLog -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The pressure log for the nitrogen gas source for the relvent section of the facility.",
				Category -> "General"
			},
			InitialCO2Pressure -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The pressure data of the CO2 gas source before starting the experiment.",
				Category -> "General"
			},
			CO2PressureLog -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The pressure log for the CO2 gas source for the relvent section of the facility.",
				Category -> "General"
			},
			InitialArgonPressure -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The pressure data of the argon gas source before starting the experiment.",
				Category -> "General"
			},
			ArgonPressureLog -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The pressure log for the argon gas source for the relvent section of the facility.",
				Category -> "General"
			},
			EnvironmentalData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "Measurements of environmental conditions (temperature and humidity) recorded during the execution of this maintenance.",
				Category -> "Experimental Results"
			},

			(* --- Sample Storage --- *)
			TransportChilledDevice -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Instrument, PortableCooler] | Model[Instrument, PortableCooler],
				Description -> "Indicates the instrument(s) used to transport chilled samples during this maintenance.",
				Category -> "Sample Storage",
				Developer -> True
			},
			TransportChilledTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius,
				Description -> "The temperature(s) at which the TransportChilledDevice(s) were set during this maintenance.",
				Category -> "Sample Storage",
				Developer -> True
			},
			TransportWarmedDevice -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Instrument, PortableHeater] | Model[Instrument, PortableHeater],
				Description -> "Indicates the instrument(s) used to transport warmed samples during this maintenance.",
				Category -> "Sample Storage",
				Developer -> True
			},
			TransportWarmedTemperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius,
				Description -> "The temperature(s) at which the TransportWarmedDevice(s) were set during this maintenance.",
				Category -> "Sample Storage",
				Developer -> True
			},

			(* --- Waste Handling --- *)
			WasteWeightTare -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The weight data of the waste carboy before the maintenance is started.",
				Category -> "Sensor Information",
				Developer -> True
			},
			SecondaryWasteWeightTare -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The weight data of the secondary waste carboy before the maintenance is started.",
				Category -> "Sensor Information",
				Developer -> True
			},
			WasteWeight -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The weight data of the waste carboy after the maintenance is completed.",
				Category -> "Sensor Information",
				Developer -> True
			},
			SecondaryWasteWeight -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data][Maintenance],
				Description -> "The weight data of the secondary waste carboy after the maintenance is completed.",
				Category -> "Sensor Information",
				Developer -> True
			},
			WasteGenerated -> {
				Format -> Multiple,
				Class -> {Waste -> Link, Weight -> Real},
				Pattern :> {Waste -> _Link, Weight -> GreaterEqualP[0*Gram]},
				Units -> {Waste -> None, Weight -> Gram},
				Relation -> {Waste -> Model[Sample], Weight -> None},
				Description -> "For each type of waste generated by this maintenance, the total amount (in grams) generated during the course of the maintenance.",
				Headers -> {Waste -> "Waste Type", Weight -> "Amount"},
				Category -> "Cleaning"
			},

			(* --- Operator handling --- *)
			Operator -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[User, Emerald] | Model[User, Emerald],
				Description -> "Indicates the operator allowed to run this maintenance.  If not populated, then all operators are allowed.",
				Category -> "Operations Information",
				Developer -> True
			},
			RequiredCertifications->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Certification],
				Description->"The list of skill sets needed for an operator to execute this maintenance.",
				Category->"Operations Information",
				Developer -> True
			},
			Interruptible -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this maintenance can be interrupted and the current operator of this maintenance can be assigned to another priority protocol.",
				Category -> "Operations Information",
				Developer -> True
			},
			ReadyCheckResult -> {
				Format -> Single,
				Class -> {
					ProtocolStatus -> Expression,
					Blocked -> Boolean,
					Blockers -> Expression,
					Suspended -> Boolean,
					Suspenders -> Expression,
					Checkpoint -> String,
					CheckpointProgress -> Expression,
					CheckpointEstimates -> Expression,
					CurrentOperator -> Expression,
					CurrentOperatorName -> String,
					InstrumentsAvailable->Boolean,
					Instruments->Expression,
					ItemsAvailable->Boolean,
					Items->Expression,
					SamplesAvailable->Boolean,
					Samples->Expression,
					ObjectsInUse->Expression,
					CurrentInstrument -> Expression,
					CurrentInstrumentName -> String,
					LastInstrument -> Expression,
					LastInstrumentName -> String,
					ActiveCart -> Expression,
					ActiveCartName -> String,
					LastCart -> Expression,
					LastCartName -> String,
					LastOperator -> Expression,
					LastOperatorName -> String,
					PickUpTime -> Date,
					DateEnqueued -> Date,
					Error -> Boolean,
					DangerZone -> Boolean,
					Priority -> Boolean,
					Resolved -> Expression,
					Unresolved -> Expression,
					CanaryBranch -> String,
					VerifiedSelectAgentFree -> Boolean
				},
				Pattern :> {
					ProtocolStatus -> ProtocolStatusP|OperationStatusP,
					Blocked -> BooleanP,
					Blockers -> {{ObjectP[{Object[SupportTicket,Operations],Object[SupportTicket,UserCommunication]}],_String|Null}...},
					Suspended -> BooleanP,
					Suspenders -> {{ObjectP[{Object[SupportTicket,Operations],Object[SupportTicket,UserCommunication]}],_String|Null}...},
					Checkpoint -> _String,
					CheckpointProgress -> {{_String, _?DateObjectQ, _?DateObjectQ | Null}...},
					CheckpointEstimates -> {{_String, GreaterEqualP[0*Second], _String}...},
					CurrentOperator -> ObjectP[],
					CurrentOperatorName -> _String,
					InstrumentsAvailable->BooleanP,
					Instruments->{_Association...},
					ItemsAvailable->BooleanP,
					Items->{_Association...},
					SamplesAvailable->BooleanP,
					Samples->{_Association...},
					ObjectsInUse->{ObjectP[]...},
					CurrentInstrument -> ObjectP[],
					CurrentInstrumentName -> _String,
					LastInstrument -> ObjectP[],
					LastInstrumentName -> _String,
					ActiveCart -> ObjectP[],
					ActiveCartName -> _String,
					LastCart -> ObjectP[],
					LastCartName -> _String,
					LastOperator -> ObjectP[],
					LastOperatorName -> _String,
					PickUpTime -> _?DateObjectQ,
					DateEnqueued -> _?DateObjectQ,
					Error -> BooleanP,
					DangerZone -> BooleanP,
					Priority -> BooleanP,
					Resolved -> {{ObjectP[{Object[SupportTicket,Operations],Object[SupportTicket,UserCommunication]}],_String|Null}...},
					Unresolved -> {{ObjectP[{Object[SupportTicket,Operations],Object[SupportTicket,UserCommunication]}],_String|Null}...},
					CanaryBranch -> _String | Null,
					VerifiedSelectAgentFree -> BooleanP
				},
				Units -> {
					ProtocolStatus -> None,
					Blocked -> None,
					Blockers -> None,
					Suspended -> None,
					Suspenders -> None,
					Checkpoint -> None,
					CheckpointProgress -> None,
					CheckpointEstimates -> None,
					CurrentOperator -> None,
					CurrentOperatorName -> None,
					InstrumentsAvailable->None,
					Instruments->None,
					ItemsAvailable->None,
					Items->None,
					SamplesAvailable->None,
					Samples->None,
					ObjectsInUse->None,
					CurrentInstrument -> None,
					CurrentInstrumentName -> None,
					LastInstrument -> None,
					LastInstrumentName -> None,
					ActiveCart -> None,
					ActiveCartName -> None,
					LastCart -> None,
					LastCartName -> None,
					LastOperator -> None,
					LastOperatorName -> None,
					PickUpTime -> None,
					DateEnqueued -> None,
					Error -> None,
					DangerZone -> None,
					Priority -> None,
					Resolved -> None,
					Unresolved -> None,
					CanaryBranch -> None,
					VerifiedSelectAgentFree -> None
				},
				Headers -> {
					ProtocolStatus -> "The current OperationStatus/ProtocolStatus for the given protocol.",
					Blocked -> "Indicates if the protocol object is currently blocked by an unresolved support ticket.",
					Blockers -> "Any tickets that are currently blocking the protocol.",
					Suspended -> "Indicates if the protocol type is currently suspended by a support ticket.",
					Suspenders -> "Any tickets that are currently suspending the protocol type.",
					Checkpoint -> "The current checkpoint for the given protocol.",
					CheckpointProgress -> "The current state of checkpoints for the given protocol.",
					CheckpointEstimates -> "The estimated checkpoints for the given protocol.",
					CurrentOperator -> "The operator currently executing the protocol (or Null if no-one).",
					CurrentOperatorName -> "The name of the operator currently executing the protocol (or Null if no-one).",
					InstrumentsAvailable -> "Indicates if all required instruments are available.",
					Instruments->"Stores a list of associations describing the availability of each required instrument.",
					ItemsAvailable->"Indicates if all required items/parts are available.",
					Items->"Stores a list of associations describing the availability of each required item/part.",
					SamplesAvailable->"Indicates if all required samples are available.",
					Samples->"Stores a list of associations describing the availability of each required sample.",
					ObjectsInUse->"Stores a list of the objects that are currently being used by this protocol.",
					CurrentInstrument -> "The instrument whose status is set to InUse by the protocol.",
					CurrentInstrumentName -> "The name of the CurrentInstrument.",
					LastInstrument -> "The instrument whose status was last set to InUse by the protocol.",
					LastInstrumentName -> "The name of the LastInstrument.",
					ActiveCart -> "The cart on which the protocol's procedure is running.",
					ActiveCartName -> "The name of the ActiveCart.",
					LastCart -> "The cart on which the protocol's procedure was previously running.",
					LastCartName -> "The name of the LastCart.",
					LastOperator -> "The operator previously executing the protocol (or Null if no-one).",
					LastOperatorName -> "The name of the LastOperator.",
					PickUpTime -> "The next date at which the protocol should be picked up from processing.",
					DateEnqueued -> "The date the protocol was Enqueued.",
					Error -> "Indicates if an error occurred while fetching information.",
					DangerZone -> "Indicates if the given protocol currently requires continuous operation.",
					Priority -> "Indicates if the given protocol can be interrupted by other protocols.",
					Resolved -> "Any tickets about the protocol that are resolved.",
					Unresolved -> "Any tickets about the protocol that are unresolved, but not blocking or suspending the protocol.",
					CanaryBranch -> "The user-defined Canary branch on which the given protocol is meant to be run.",
					VerifiedSelectAgentFree -> "Indicates that the strands in this protocol have been verified to not contain any harmful sequences as defined by the Select Agents and Toxins List issued by the Food & Drug Administration (FDA)."
				},
				Description -> "Cached information describing the current state of this maintenance and its resource availability.",
				Category -> "Operations Information",
				Developer -> True
			},
			ReadyCheckDateLastUpdated -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "Indicates if the ReadyCheckResult is out of date and is currently being recomputed in the lab. If this field is Null and ReadyCheckResult is populated, ReadyCheckResult is up to date.",
				Category -> "Operations Information",
				Developer->True
			},
			ReadyCheckLog -> {
				Format -> Multiple,
				Class -> {Date, Boolean, Expression},
				Pattern :> ReadyCheckLogP,
				Description -> "The historical record of the ReadyCheck field.",
				Category -> "Operations Information",
				Headers -> {"Date","ReadyCheck Result","State of Resources"},
				Developer -> True
			},
			(* Legacy *)
			LegacyID -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
				Category -> "Migration Support",
				Developer -> True
			},
			RemainingTasks -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> RosettaTaskP[],
				Description -> "A cached list of outstanding Engine tasks saved at the last procedure exit of this maintenance. If Null, outstanding tasks will be determined from the maintenance's ProcedureLog events when the procedure is next opened.",
				Category -> "Organizational Information",
				Developer -> True
			},
			CompletedTasks -> {
				Format -> Multiple,
				Class -> {Date,Date,Link,Expression,Expression},
				Pattern :> {_?DateObjectQ,_?DateObjectQ,_Link,_String|Null,_String|Null},
				Relation -> {None, None, Object[User], None, None},
				Description -> "A cached list of completed Rosetta tasks saved at the last procedure exit of this maintenance. If Null, completed tasks will be determined from the maintenance's ProcedureLog events when the procedure is next opened.",
				Category -> "Organizational Information",
				Headers -> {"Date Started","Date Completed","Operator", "Task ID","Task HTML"},
				Units -> {None,None,None,None,None},
				Developer -> True
			},
			(* --- Storage pricing --- *)
			StoragePrice -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0*USD/Month],
				Units -> USD/Month,
				Description -> "The total monthly price for warehousing all user owned items associated with this maintenance in an ECL facility under the storage conditions specified by each item.",
				Category -> "Storage Information"
			},
			StoragePrices -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> UnitsP[0*USD/Month],
				Units -> USD/Month,
				Description -> "The running tally of the total monthly price for warehousing all user owned items associated with this maintenance in an ECL facility under the storage conditions specified by each item.  To find the current price, sum all values of this field.",
				Category -> "Storage Information",
				Developer -> True
			},
			StoredObjects -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Part],
					Object[Plumbing],
					Object[Item],
					Object[Wiring]
				],
				Description -> "List of all physical items associated with this maintenance that are currently being warehoused in an ECL facility.",
				Category -> "Storage Information"
			},
			DateLastUsed -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "Date any physical items associated with this maintenance were last handled in the lab.",
				Category -> "Storage Information"
			},
			PurchasedItems -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample][Source],
					Object[Item][Source],
					Object[Container][Source],
					Object[Part][Source],
					Object[Plumbing][Source],
					Object[Sensor][Source],
					Object[Wiring][Source]
				],
				Description -> "List of any items that were purchased on behalf of the user in the course of running this maintenance.",
				Category -> "Pricing Information"
			},
			SamplesOutPrices -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> UnitsP[0*USD/Month],
				Units -> USD/Month,
				Description -> "The running tally of the total monthly price for warehousing all samples generated by this maintenance in an ECL facility under the storage conditions specified by each item.  To find the current price, sum all values of this field.",
				Category -> "Storage Information",
				Developer -> True
			},
			AliquotSamplesPrices -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> UnitsP[0*USD/Month],
				Units -> USD/Month,
				Description -> "The running tally of the total monthly price for warehousing all aliquot samples associated with this maintenance in an ECL facility under the storage conditions specified by each item.  To find the current price, sum all values of this field.",
				Category -> "Storage Information",
				Developer -> True
			},
			PurchasedItemsPrices -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> UnitsP[0*USD/Month],
				Units -> USD/Month,
				Description -> "The running tally of the total monthly price for warehousing all items purchased in the course of running this maintenance in an ECL facility under the storage conditions specified by each item.  To find the current price, sum all values of this field.",
				Category -> "Storage Information",
				Developer -> True
			},

			ParallelComputations -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Notebook, Job],
					Object[Software, ManifoldKernelCommand]
				],
				Description -> "List of computational jobs generated and run in parallel to the execution of this maintenance.",
				Category -> "Computations",
				Developer -> True
			},
			ComputationsOutstanding -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if any of the computation jobs in ParallelComputations have not yet completed.",
				Category -> "Computations",
				Developer -> True
			},
			ErroneousComputations -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Notebook, Job],
					Object[Software, ManifoldKernelCommand]
				],
				Description -> "List of computational jobs generated and run in parallel to the execution of this maintenance in which a warning or error was thown, or that did not finish.",
				Category -> "Computations",
				Developer -> True
			},
			ReadyCheckComputations -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Notebook, Job],
				Description -> "The list of manifold job notebooks that was used to evaluate ReadyCheck for this maintenance.",
				Category -> "Computations",
				Developer -> True
			},
			Streams -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Stream][Protocol],
				Description -> "The list of video streams associated with this maintenance.",
				Category -> "General"
			},
			StreamErrors -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The error operator encountered when trying to start stream for the protocol.",
				Category -> "General",
				Developer -> True
			},
			Movements -> {
				Format -> Multiple,
				Class -> {Link, Link, String, String, Integer, Integer},
				Pattern :> {
					_Link,
					_Link,
					LocationPositionP,
					_String,
					GreaterP[0, 1],
					GreaterP[0, 1]
				},
				Relation -> {
					Alternatives[
						Object[Sample],
						Object[Container],
						Object[Part],
						Object[Item],
						Object[Instrument],
						Object[Plumbing],
						Object[Wiring],
						Object[Sensor]
					],
					Alternatives[
						Object[Sample],
						Object[Container],
						Object[Part],
						Object[Item],
						Object[Instrument],
						Object[Plumbing],
						Object[Wiring],
						Object[Sensor]
					],
					Null,
					Null,
					Null,
					Null
				},
				Headers -> {"Source", "Destination Object", "Destination Position", "TaskID", "Iteration", "TotalIterations"},
				Description -> "Lists all movements from a non-aseptic source into a non-aspetic destination that the indicated task is currently performing.  This field is only populated during the process of any sort of movement task, and is emptied once it is complete.",
				Developer -> True,
				Category -> "Placements"
			},
			AsepticToNonAsepticMovements -> {
				Format -> Multiple,
				Class -> {Link, Link, String, String, Integer, Integer},
				Pattern :> {
					_Link,
					_Link,
					LocationPositionP,
					_String,
					GreaterP[0, 1],
					GreaterP[0, 1]
				},
				Relation -> {
					Alternatives[
						Object[Sample],
						Object[Container],
						Object[Part],
						Object[Item],
						Object[Instrument],
						Object[Plumbing],
						Object[Wiring],
						Object[Sensor]
					],
					Alternatives[
						Object[Sample],
						Object[Container],
						Object[Part],
						Object[Item],
						Object[Instrument],
						Object[Plumbing],
						Object[Wiring],
						Object[Sensor]
					],
					Null,
					Null,
					Null,
					Null
				},
				Headers -> {"Source", "Destination Object", "Destination Position", "TaskID", "Iteration", "TotalIterations"},
				Description -> "Lists all movements from an aseptic source into a non-aspetic destination that the indicated task is currently performing.  This field is only populated during the process of any sort of movement task, and is emptied once it is complete.",
				Developer -> True,
				Category -> "Placements"
			},
			NonAsepticToAsepticMovements -> {
				Format -> Multiple,
				Class -> {Link, Link, String, String, Integer, Integer},
				Pattern :> {
					_Link,
					_Link,
					LocationPositionP,
					_String,
					GreaterP[0, 1],
					GreaterP[0, 1]
				},
				Relation -> {
					Alternatives[
						Object[Sample],
						Object[Container],
						Object[Part],
						Object[Item],
						Object[Instrument],
						Object[Plumbing],
						Object[Wiring],
						Object[Sensor]
					],
					Alternatives[
						Object[Sample],
						Object[Container],
						Object[Part],
						Object[Item],
						Object[Instrument],
						Object[Plumbing],
						Object[Wiring],
						Object[Sensor]
					],
					Null,
					Null,
					Null,
					Null
				},
				Headers -> {"Source", "Destination Object", "Destination Position", "TaskID", "Iteration", "TotalIterations"},
				Description -> "Lists all movements from a non-aseptic source into an aspetic destination that the indicated task is currently performing.  This field is only populated during the process of any sort of movement task, and is emptied once it is complete.",
				Developer -> True,
				Category -> "Placements"
			},
			AsepticToAsepticMovements -> {
				Format -> Multiple,
				Class -> {Link, Link, String, String, Integer, Integer},
				Pattern :> {
					_Link,
					_Link,
					LocationPositionP,
					_String,
					GreaterP[0, 1],
					GreaterP[0, 1]
				},
				Relation -> {
					Alternatives[
						Object[Sample],
						Object[Container],
						Object[Part],
						Object[Item],
						Object[Instrument],
						Object[Plumbing],
						Object[Wiring],
						Object[Sensor]
					],
					Alternatives[
						Object[Sample],
						Object[Container],
						Object[Part],
						Object[Item],
						Object[Instrument],
						Object[Plumbing],
						Object[Wiring],
						Object[Sensor]
					],
					Null,
					Null,
					Null,
					Null
				},
				Headers -> {"Source", "Destination Object", "Destination Position", "TaskID", "Iteration", "TotalIterations"},
				Description -> "Lists all movements from an aseptic source into an aspetic destination that the indicated task is currently performing.  This field is only populated during the process of any sort of movement task, and is emptied once it is complete.",
				Developer -> True,
				Category -> "Placements"
			},
			ErrorRecoveryLog -> {
				Format -> Multiple,
				Class -> {
					Date -> Date,
					Procedure -> String,
					TaskID -> String,
					Subprotocol -> Link,
					ResponsibleOperator -> Link
				},
				Pattern :> {
					Date -> _?DateObjectQ,
					Procedure -> _String,
					TaskID -> _String,
					Subprotocol -> _Link,
					ResponsibleOperator -> _Link
				},
				Relation -> {
					Date -> Null,
					Procedure -> Null,
					TaskID -> Null,
					Subprotocol -> Alternatives[Object[Protocol], Object[Maintenance], Object[Qualification]],
					ResponsibleOperator -> Object[User, Emerald][ErrorRecoveryEvents, RootProtocol]
				},
				Description -> "The error recovery procedures triggered during execution of this protocol.",
				Category -> "Organizational Information"
			},
			GloveChangeLog -> {
				Format -> Multiple,
				Class -> {Date, Link, Link},
				Pattern :> {_?DateObjectQ, _Link, _Link},
				Relation -> {None, Object[Item, Consumable], Object[User]},
				Description -> "The history of glove replacements during this protocol in the form: {Date, Glove Box, Operator}. This field records when gloves were replaced, which gloves  were used, and who performed the replacement.",
				Headers -> {"Date", "Glove Box", "Operator"},
				Category -> "Health & Safety",
				Developer -> True
			},

			insertMe
		}
	}]
];
