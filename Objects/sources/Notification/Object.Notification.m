(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notification], {
	Description->"A notification containing information relevant to user experiments or team administration.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		
		(* Team and Recipient Information *)
		Recipients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The users who receives this notification.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Acknowledgements -> {
			Format -> Multiple,
			Class -> {User->Link, Read->Expression, DateRead->Date},
			Pattern :> {User->_Link, Read->BooleanP, DateRead->_?DateObjectQ},
			Relation -> {User->Object[User], Read->Null, DateRead->Null},
			Units -> {User->None, Read->None, DateRead->None},
			Headers -> {User->"User", Read->"User has Read", DateRead->"Date Read"},
			Description -> "The users who receives this notification and information on whether/when each user viewed the notification.",
			Developer -> True,
			Category -> "Organizational Information"
		},
		ResponsibleParty -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The party responsible for the action that generated this notification.",
			Developer -> True,
			Category -> "Organizational Information"
		},
				

		(* --- Notification Information -- *)
		Message -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The content of the notification to be displayed.",
			Category -> "Notification Information",
			Abstract -> True
		}
	}
}];
