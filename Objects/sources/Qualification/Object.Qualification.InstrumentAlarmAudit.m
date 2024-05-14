(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,InstrumentAlarmAudit], {
	Description->"A protocol that audits the status of the instruments within the laboratory target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The instruments that this alarm check qualification is intended to test.",
			Category -> "General"
		},
		BeepingInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The instruments that are indicated to emitting an alarm which can be heard.",
			Category -> "General"
		},
		VisiblyAlarmingInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The instruments that are indicated to be displaying an alarm which can be seen.",
			Category -> "General"
		},
		BeepingInstrumentImages-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of BeepingInstruments, the pictures associated with audible alarms.",
			IndexMatching->BeepingInstruments ,
			Category -> "General"
		},
		VisiblyAlarmingInstrumentImages-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of VisiblyAlarmingInstruments, the pictures associated with visual alarms.",
			IndexMatching->VisiblyAlarmingInstruments,
			Category -> "General"
		}
	}
}];
