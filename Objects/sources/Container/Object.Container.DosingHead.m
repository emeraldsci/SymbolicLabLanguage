

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, DosingHead], {
	Description->"A dosing head used for storing and dispensing small amounts of solids.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MinDosingQuantity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinDosingQuantity]],
			Pattern :> GreaterP[0*Gram],
			Description -> "The minimum quantity of solid that can be dispensed by this model of dosing head.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		PreferredMaxDosingQuantity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PreferredMaxDosingQuantity]],
			Pattern :> GreaterP[0*Gram],
			Description -> "The preferred size of a single dosing quantity of solid that can be dispensed by this model of dosing head. The actual maximum is determined by the volume of solid that can fit in the dosing head and the maximum volume the associated solid dispenser can read.",
			Category -> "Container Specifications"
		}
	}
}];
