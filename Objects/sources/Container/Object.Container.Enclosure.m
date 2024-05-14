(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, Enclosure], {
	Description->"An enclosure configuration used for isolating instruments from their surrounding environment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Vented -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Vented]],
			Pattern :> BooleanP,
			Description -> "Indicates if the enclosure is connected to external ventilation to circulate air to the outside.",
			Category -> "Container Specifications",
			Abstract -> True
		}
	}
}];
