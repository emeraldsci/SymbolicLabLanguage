(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance,Clean,Dispenser], {
	Description->"A protocol that cleans dedicated liquid dispensers and their associated graduated cylinders used for measuring.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		GraduatedCylinders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "Clean graduated cylinders that replaced the used cylinders on the instrument deck so they can be sent off to cleaning by dishwashing.",
			Category -> "Cleaning"
		},
		DirtyLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container]
			],
			Description -> "Used graduated cylinders on the instrument deck that are sent to be dishwashed during maintenance protocol.",
			Category -> "Cleaning"
		}
	}
}];
