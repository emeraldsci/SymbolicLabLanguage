(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, WashBin], {
	Description->"A container used to store other containers (plate, vessels, graduated cylinders, etc) that need to be washed before further use in the laboratory.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {	
		CleaningType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleaningTypeP,
			Description -> "Indicates the type of cleaning or sterilization process that the contents of this bin will undergo.",
			Category -> "Container Specifications"
		}		
	}
}];
