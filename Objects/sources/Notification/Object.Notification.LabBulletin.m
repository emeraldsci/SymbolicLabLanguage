

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Notification, LabBulletin], {
	Description->"A lab operations notice to be shown on the operator dashboard and acknowledged by operators before begining their shift.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Author -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person who posted this bulletin.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		AcknowledgementLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {None, Object[User]},
			Description -> "The people who have acknowledged reading this notification.",
			Headers -> {"Date","Acknowledger"},
			Category -> "Organizational Information",
			Abstract -> True
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BulletinStatusP,
			Description -> "Indicates if the notification is active or inactive.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, BulletinStatusP, _Link},
			Relation -> {None, None, Object[User]},
			Description -> "A log of people who have changed the status of this notification.",
			Headers -> {"Date","Status","Responsible Party"},
			Category -> "Organizational Information",
			Abstract -> False,
			Developer -> True
		}
	}
}];
