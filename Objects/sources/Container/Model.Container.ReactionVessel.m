(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, ReactionVessel], {
	Description->"A vessel in which chemical reaction are conducted.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		ProductsContained -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][DefaultContainerModel],
			Description -> "Products representing regularly ordered items that are delivered in this type of reaction vessel by default.",
			Category -> "Inventory",
			Developer->True
		},
		(* --- Operating Limits --- *)
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum pressure to which the reaction vessel can be exposed without becoming damaged.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure to which the reaction vessel can be exposed without becoming damaged.",
			Category -> "Operating Limits"
		},
		SelfStandingContainers->{
			Format->Multiple,
			Class->Link,
			Pattern :> _Link,
			Relation->Model[Container,Rack],
			Description->"Model of a container capable of holding this type of vessel upright.",
			Category->"Compatibility"
		}
	}
}];
