(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Clean, Valve], {
	Description->"Definition of a set of parameters for a maintenance protocol that cleans and ensures the proper function of solvent line check valves.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CleaningSolventModel->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The type of solvent used to clean the check valves surface.",
			Category -> "General",
			Developer->True
		},
		SonicatorModel->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Sonicator],
			Description -> "The type(s) of sonicators used to clean the check valves surface.",
			Category -> "General",
			Developer->True
		},
		WrenchModels->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Wrench],
			Description -> "The wrenches used to disassemble the check valves.",
			Category -> "General",
			Developer->True
		}
	}
}];
