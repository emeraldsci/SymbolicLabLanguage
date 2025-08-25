(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Repair], {
	Description -> "A detailed set of information describing the progress of the process of restoring a broken instrument to full functionality.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Organizational Information *)
		Headline -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "One sentence description of the issue being reported. The Scientific Instrumentation team regularly update this field to accurately reflect the repair.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Description -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A long form description of the issue being reported. The Scientific Instrumentation team regularly update this field to accurately reflect the repair.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][RepairLog, 2],
			Description -> "The target of this repair.",
			Category -> "Organizational Information"
		},
		Manufacturer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Supplier],
			Description -> "The manufacturer of the instrument targeted by this repair.",
			Category -> "Organizational Information"
		},
		Vendor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Supplier][RepairLog, 2],
			Description -> "The vendor performing this repair.",
			Category -> "Organizational Information"
		},
		Author -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User, Emerald],
			Description -> "The person who initiated the repair.",
			Category -> "Organizational Information"
		},
		DateResolved -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date when the repair was completed.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Tags -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> RepairTagsP,
			Description -> "A list of keyword tags that are used to organize and analyze repairs.",
			Category -> "Organizational Information",
			Developer -> True
		},
		AsanaTaskID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "ID number of the Asana task created for the Scientific Instrumentation team to track this repair.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},

		(* Repair Status Information *)
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RepairStatusP,
			Description -> "The state of the repair, indicating the party currently responsible for progressing the repair.",
			Category -> "Status",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, RepairStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to the repair's status, and the party who updated the status.",
			Headers -> {"Date", "Status", "Responsible Party"},
			Category -> "Status"
		},
		NextExpectedServiceDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The next agreed upon date on which the instrument manufacturer will perform the instrument repair or other service.",
			Category -> "Status"
		},
		ExpectedServiceDateLog -> {
			Format -> Multiple,
			Class -> {Date, Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _?DateObjectQ, _Link , ServiceCallStatusP},
			Relation -> {Null, Null, Object[Company], Null},
			Description -> "A recording of the service calls scheduled with the vendor, including an indication of whether or not they honored the agreed date.",
			Headers -> {"Date of Update", "Expected Service Date", "Vendor", "Fulfilled"},
			Category -> "Status"
		},
		ManufacturerCommunicationLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, String, Link},
			Pattern :> {_?DateObjectQ, CommunicationTypeP, _String, _Link},
			Relation -> {Null, Null, Null, Object[Company]},
			Description -> "A log of communications with the manufacturer responsible for this repair.",
			Headers -> {"Communication Date", "Communication Type", "Content", "Company"},
			Category -> "Status"
		},

		(* Additional Scientific Support Fields *)
		AssociatedInternalCommunications -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[SupportTicket, Operations][AssociatedRepairs],
			Description -> "A list of operations support tickets related to this instrument repair.",
			Category -> "Troubleshooting",
			AdminViewOnly -> True
		},
		AffectedProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> {
				Object[Protocol][InstrumentRepairs],
				Object[Maintenance][InstrumentRepairs],
				Object[Qualification][InstrumentRepairs]
			},
			Description -> "A list of protocols that are actively being blocked by this instrument repair.",
			Category -> "Troubleshooting"
		},
		Attachments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Any documents related to this repair.",
			Category -> "Troubleshooting",
			Developer -> True (* Many repair documents contain personal information of emerald developers, such as cell phone *)
		},
		ReplacementParts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part], Object[Container], Object[Item], Object[Sensor]],
			Description -> "A list of the new parts installed in the instrument as part of this repair.",
			Category -> "Troubleshooting"
		},
		Cost -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 USD],
			Units -> USD,
			Description -> "The total monies paid by the ECL to complete this repair.",
			Category -> "Troubleshooting"
		},
		Qualifications -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Qualification],
			Description -> "The verification protocols enqueued to confirm the success of this repair.",
			Category -> "Troubleshooting"
		},
		Maintenances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance],
			Description -> "The maintenance protocols enqueued as part of the repair process.",
			Category -> "Troubleshooting"
		},
		Retire -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates the repair process was not successful and the instrument has to be retired.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];