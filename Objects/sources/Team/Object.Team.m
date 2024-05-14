(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Team], {
	Description -> "A team which serves as a grouping for users.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Title by which the team is referred to.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Website -> {
			Format -> Single,
			Class -> String,
			Pattern :> URLP,
			Description -> "The website URL to find more information about the team online.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Administrators -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "Users which control membership access to the team.",
			Category -> "Organizational Information",
			Abstract -> False
		},
		Notebooks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[LaboratoryNotebook][Editors] | Object[LaboratoryNotebook][Viewers],
			Description -> "Notebooks which this team has access to.",
			Category -> "Organizational Information"
		},
		PendingMembers -> {
			Format -> Multiple, 
			Class -> {Link, String}, 
			Pattern :> {_Link, _String}, 
			Relation -> {Object[User], Null}, 
			Headers -> {"User", "Invite Email"},
			Description -> "Users which have been invited to the team but have yet to accept the invite, in the format {user link, invited email}.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True,
			AdminWriteOnly->True
		}
	}
}]
