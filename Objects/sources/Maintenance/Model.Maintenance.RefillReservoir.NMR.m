(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, RefillReservoir, NMR], {
	Description->"Definition of a set of parameters for a maintenance protocol that refills an NMR liquid nitrogen reservoir.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		HeatGunModels->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, HeatGun],
			Description -> "The type(s) of heat gun(s) used to warm and defrost a surface.",
			Category -> "General",
			Developer->True
		},

		FaceShieldModels->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,FaceShield],
 			Description -> "The type(s) of face shield(s) worn to protect the face from chemical splashes/airborne debris.",
			Category -> "General",
			Developer->True
		},

		CryoGloveModels->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Glove],
			Description -> "The type(s) of cryo gloves(s) worn to the hands from ultra low temperature surfaces/fluids.",
			Category -> "General",
			Developer->True
		}
	}
}];
