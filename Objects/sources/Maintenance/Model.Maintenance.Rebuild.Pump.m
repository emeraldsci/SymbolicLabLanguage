(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Rebuild, Pump], {
	Description->"Definition of a set of parameters for a maintenance protocol that makes extensive repairs to the HPLC pump.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ToolBox->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container, Box],
			Description->"The tool box which stores pump maintenance tools.",
			Category -> "General"
		},
		PrimeBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer model used to rinse the pump to remove toxic solutions.",
			Category -> "General"
		},
		FlushBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer model used to run in new piston seals.",
			Category -> "General"
		},
		FlowRestrictor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,FlowRestrictor],
			Description -> "The capillary that can generate high back pressure used to run in new piston seals.",
			Category -> "General"
		},
		CheckValves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,CheckValve],
			Description -> "The new check valves for the replacement during this maintenance.",
			Category -> "General"
		},
		PistonSeals -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,Seal],
			Description -> "The new piston seals for the replacement during this maintenance.",
			Category -> "General"
		},
		PistonSealsOldPump -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,Seal],
			Description -> "The new piston seals for the old pump model for the replacement during this maintenance.",
			Category -> "General"
		},
		Pistons -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,Piston],
			Description -> "The new pistons for the replacement during this maintenance. They will be replaced only if the old ones are damaged.",
			Category -> "General"
		},
		PistonsOldPump -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,Piston],
			Description -> "The new pistons for the old pump model for the replacement during this maintenance. They will be replaced only if the old ones are damaged.",
			Category -> "General"
		},
		SystemFlushGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The composition of solvents over time used to purge the instrument lines at the end.",
			Category -> "General",
			Developer -> True
		}
	}
}];
