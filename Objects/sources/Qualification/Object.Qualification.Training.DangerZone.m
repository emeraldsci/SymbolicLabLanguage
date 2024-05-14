(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: hanming.yang*)
(* :Date: 2023-6-22 *)

DefineObjectType[Object[Qualification,Training,DangerZone], {
	Description->"The qualification test to verify operator's ability to correct pass down to other operators inside a danger zone.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DangerZonePassOffImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The cloudfile images of the pass off screen.",
			Category -> "General"
		}
	}
}];