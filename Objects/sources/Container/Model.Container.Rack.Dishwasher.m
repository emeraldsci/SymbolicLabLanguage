(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Rack, Dishwasher], {
	Description->"A model of a rack container that is inserted into dishwashers and holds dirty labware.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Container Specifications *)
		RackType->{
			Format->Single,
			Class->Expression,
			Pattern:>DishRackTypeP,
			Description->"The category of this rack model that describes whether it passively holds items or has nozzles that actively spray water and air.",
			Category->"Container Specifications"
		},
		BaseHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"Vertical distance from the bottom of the rack to the bottom of its nozzles or to its surface.",
			Category->"Container Specifications"
		},
		(* Compatibility *)			
		SprayNozzles -> {
			Format -> Multiple,
			Class ->Link,
			Pattern :> _Link,
			Relation->Model[Part,Nozzle],
			Description -> "The spray nozzle parts that can be attached to this dishwashing rack.",
			Category -> "Compatibility"
		}	
	}
}];
