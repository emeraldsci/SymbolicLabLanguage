(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Team,Sharing], {
	Description -> "A team which serves as a grouping for users for sharing notebook access privileges.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Members -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User][SharingTeams],
			Description -> "Users who will have access to any notebooks shared with this team.",
			Category -> "Organizational Information"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserStatusP,
			Description -> "Indicates if a team has an active ECL account open or the account has been retired and retained for historical authorship information.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ViewOnly -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Determines whether members have read or write access to the notebooks and objects attached to this sharing team.",
			Category -> "Organizational Information"
		}
	}
}]
