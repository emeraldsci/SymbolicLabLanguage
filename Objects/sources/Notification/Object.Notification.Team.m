(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notification, Team], {
	Description -> "A notification containing information relevant to the status or composition of an ECL team.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
	
		(* --- Team and Recipient Information --- *)
		Team -> {
			Format -> Single, 
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team],
			Description -> "The team to which this notification applies.",
			Abstract -> True,
			Category -> "Organizational Information"
		},
	
		(* --- Notification Information --- *)
		Member -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "User whose addition to, or removal from, the team is announced by this notification.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		TeamEvent -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TeamEventP,
			Description -> "The event this notification anounces, such as the addition of a member to a team.",
			Abstract -> True,
			Category -> "Notification Information"
		}
		
	}
}]
