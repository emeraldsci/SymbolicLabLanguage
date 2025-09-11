(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Flush], {
	Description->"Definition of a set of parameters for a maintenance protocol that flushes an instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		IdleFlush -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the flush continues after the instrument is released from the maintenance.",
			Category -> "General",
			Abstract -> True
		},
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solvent pumped through channel A of the flow path.",
			Category -> "General",
			Abstract -> True
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solvent pumped through channel B of the flow path.",
			Category -> "General",
			Abstract -> True
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solvent pumped through channel C of the flow path.",
			Category -> "General",
			Abstract -> True
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solvent pumped through channel D of the flow path.",
			Category -> "General",
			Abstract -> True
		},
		SystemFlushGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The composition of solvents over time used to purge the instrument.",
			Category -> "General",
			Developer -> True
		}
	}
}];
