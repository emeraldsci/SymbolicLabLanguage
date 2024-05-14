(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Defrost], {
	Description->"Definition of a set of parameters for a maintenance protocol that transfers all the contents of a freezer to a backup freezer and defrosts the freezer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AbsorbentMatModel-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "Model of absorbent mat used to soak up liquid.",
			Category -> "General",
			Developer -> True
		},
		AbsorbentMatNumber->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "Indicates the number of absorbent pads required to complete defrost.",
			Category -> "General",
			Developer->True
		}
	}
}];
