(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(*<MIGRATION-TAG: DO-NOT-MIGRATE>*)

DefineObjectType[Object[Example, Person, Emerald], {
	Description->"Stores information a fake peron.",
	CreatePrivileges->Developer,
	Fields -> {
		Position -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Job title of the fake individual.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		DataRelation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data][PersonRelation],
			Description -> "Any data parsed by this user.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		},
		OneWayData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Example, Data],
			Description -> "Any data parsed by this user.",
			Category -> "References",
			Required -> False,
			Abstract -> False
		},
		OneWayDataTemporal -> {
			Format -> Multiple,
			Class -> TemporalLink,
			Pattern :> _Link,
			Relation -> Object[Example, Data],
			Description -> "Any data parsed by this user.",
			Category -> "References",
			Required -> False,
			Abstract -> False
		}
	}
}];
