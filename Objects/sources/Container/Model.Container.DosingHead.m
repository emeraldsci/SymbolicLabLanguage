

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, DosingHead], {
	Description->"A model of a dosing head used to store solids and dispense them automatically using a dispenser.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MinDosingQuantity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The minimum quantity of solid that can be dispensed by this model of dosing head.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		PreferredMaxDosingQuantity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The preferred size of a single dosing quantity of solid that can be dispensed by this model of dosing head. The actual maximum is determined by the volume of solid that can fit in the dosing head and the maximum volume the associated solid dispenser can read.",
			Category -> "Container Specifications"
		},
		PreferredSolids -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "A list of solids that are dispensed most effectively by this model of dosing head.",
			Category -> "Compatibility"
		}
	}
}];
