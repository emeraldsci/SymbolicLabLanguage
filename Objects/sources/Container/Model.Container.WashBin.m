(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, WashBin], {
	Description->"A model for a container used to store other containers (plate, vessels, graduated cylinders, etc) that need to be washed before further use in the laboratory.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CleaningType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleaningTypeP,
			Description -> "Indicates the type of cleaning or sterilization that the contents of containers of this model will undergo.",
			Category -> "Container Specifications"
		}				
	}
}];
