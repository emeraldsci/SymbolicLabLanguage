(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Enclosure], {
	Description->"A model enclosure configuration used for isolating instruments from their surrounding environment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Vented -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the enclosure is connected to external ventilation to circulate air to the outside.",
			Category -> "Container Specifications",
			Abstract -> True
		}
	}
}];
