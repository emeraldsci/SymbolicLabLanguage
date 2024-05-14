(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Clean, Valve], {
	Description->"A protocol that cleans and ensure the proper function of solvent line check valves.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Sonicator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The sonicator used to clean check valve components.",
			Category -> "General"
		},
		ValveCleaningSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solution used to clean the check valve after it has been disassembled.",
			Category -> "General"
		},
		Wrenches -> {
			Format -> Multiple,
			Class ->Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Object[Part]
			],
			Description->"The wrenches required to disassembly check valves for cleaning.",
			Category -> "General"
		},
		SolventLines -> {
			Format -> Multiple,
			Class ->Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Object[Part],
				Model[Plumbing],
				Object[Plumbing]
			],
			Description->"The solvent lines connected in line with the check valves.",
			Category -> "General"
		},
		CheckValves-> {
			Format -> Multiple,
			Class ->Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Object[Part],
				Model[Plumbing],
				Object[Plumbing]
			],
			Description->"Check valves cleaned during this procedcure.",
			Category -> "General"
		}
	}
		
}];
