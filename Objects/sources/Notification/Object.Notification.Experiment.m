(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notification, Experiment], {
	Description -> "A notification containing information regarding the execution of user experiments in the ECL.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
	
		(* --- Notification Information --- *)
		Protocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol] | Object[Qualification] | Object[Maintenance],
			Description -> "The protocol for which this notification provides a status update.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		StatusChange -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ProtocolStatusP,
			Description -> "The new status of protocol that this notification announces.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		(* Renamed from ProtocolAuthor when transactions were opened to troubleshooting; namespace open for discussion *)
		ObjectAuthor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The author or creator of the protocol or transaction to which this notification applies.",
			Category -> "Notification Information"
		},
		Troubleshooting -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[SupportTicket, UserCommunication],
			Description -> "The underlying report providing the information being sent in this notification.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		TroubleshootingEvent -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TroubleshootingEventP,
			Description -> "The type of troubleshooting-related event that this notification announces.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		Script -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Script],
			Description -> "The script to which this notification applies.",
			Category -> "Notification Information"
		},
		ScriptEvent -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ScriptEventP,
			Description -> "The type of script event that this notification announces.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		ScriptMessage -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The message(s) thrown during evaluation of the Script to which this notification applies.",
			Category -> "Notification Information"
		},
		ScriptExpression -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The expression that produced error message(s) during evaluation of the Script to which this notification applies.",
			Category -> "Notification Information"
		}
	}
}]
