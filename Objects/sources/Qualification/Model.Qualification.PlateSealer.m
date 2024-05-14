(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,PlateSealer],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a plate sealer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Cover -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,PlateSeal],
			Description -> "The cover to be used to seal the container.",
			Category -> "General"
		},
		Container -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Plate],
			Description -> "The container to be sealed.",
			Category -> "General"
		}
	}
}];
