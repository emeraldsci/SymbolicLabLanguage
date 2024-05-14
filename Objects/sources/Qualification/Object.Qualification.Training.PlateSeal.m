(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: joonyeup.lee*)
(* :Date: 2023-6-16 *)

DefineObjectType[Object[Qualification,Training,PlateSeal], {
	Description->"The qualification test to test the user's understanding of Plate Sealing.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		TargetedPlateSeal -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The model or sample describing the liquid that will be used in this Qualification to test the linearity of the pipettors.",
			Category -> "General"
		},
		PlateSealContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The model or sample describing the liquid that will be used in this Qualification to test the linearity of the pipettors.",
			Category -> "General"
		},
		
		PlateSealImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The cloud file images of the plate seals on its container.",
			Category -> "General"
		},
		
		PlateSealProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,ImageSample],
			Description -> "The Image Sample sub protocol that observes the user's plate sealing skills.",
			Category -> "General"
		},
		
		PlateSealBench -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Bench],
				Object[Container,Bench]
			],
			Description -> "The bench on which the plates will be sealed.",
			Category -> "General"
		}
	}
}]