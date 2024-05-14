(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Autoclave], {
	Description->"A protocol that uses an autoclave to sterilize labware awaiting sterilization and to restock them in sterile conditions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Autoclave -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Autoclave],
			Description -> "Autoclave to sterlize containers and items with.",
			Category -> "Autoclave Setup",
			Abstract -> True
		},
		Labware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container] | Object[Item],
			Description -> "The containers and items to be sterilized during the course of this maintenance.",
			Category -> "Resources"
		},
		LabwareContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Vessel],
			Description -> "The containers to be weighed and sterilized during the course of this maintenance.",
			Category -> "Resources",
			Developer -> True
		}
	}
}];
