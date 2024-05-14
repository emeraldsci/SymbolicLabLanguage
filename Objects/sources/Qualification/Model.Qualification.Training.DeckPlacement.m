(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Training,DeckPlacement], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to put items to designated locations.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		UnitOperations -> {
			Units -> None,
			Relation -> Null,
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The list of sample preparation unit operations performed during the qualification.",
			Category -> "DeckPlacement Skills"
		}
	}
}]