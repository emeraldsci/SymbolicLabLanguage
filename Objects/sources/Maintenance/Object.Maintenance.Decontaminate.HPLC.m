(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Decontaminate, HPLC], {
	Description->"A protocol that decontaminates an HPLC flowpath.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer A sample used to generate the buffer gradient for the HPLC protocol.",
			Category -> "Gradient",
			Abstract -> True
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer B sample used to generate the buffer gradient for the HPLC protocol.",
			Category -> "Gradient",
			Abstract -> True
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer C sample used to generate the buffer gradient for the HPLC protocol.",
			Category -> "Gradient",
			Abstract -> True
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The Buffer D sample used to generate the buffer gradient for the HPLC protocol.",
			Category -> "Gradient",
			Abstract -> True
		},
		GradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The gradient method used to decontaminate the HPLC flowpath.",
			Category -> "Gradient",
			Abstract -> True
		},
		HPLCProtocol ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,HPLC],
			Description -> "The HPLC protocol executed to decontaminate HPLC instrument using decontaminating reagents.",
			Category -> "General"
		}
	}
}];
