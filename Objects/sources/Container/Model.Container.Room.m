(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Room], {
	Description->"A model that represents a room within a floor of a building.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		LabArea -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LabAreaP,
			Description -> "Name used to classify this room type within the floor of a building.",
			Category -> "Organizational Information", 
			Abstract->True
		}
	}
}];
