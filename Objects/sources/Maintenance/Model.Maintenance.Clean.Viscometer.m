

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance,Clean,Viscometer],{
	Description->"Definition of a set of parameters for a maintenance protocol that cleans the piston and external surface of a viscometer instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		PistonCleaningWipes -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The cleaning material used to wipe off unwanted impurities from the piston part of the target.",
			Category -> "Cleaning"
		},
		PistonCleaningSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The cleaning solution used to clean uff unwanted impurities from the piston part of the target.",
			Category -> "Cleaning"
		}
	}
}];
