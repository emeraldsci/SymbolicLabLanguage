(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, Training, HermeticTransfer], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to perform hermetic transfer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		HermeticPreparatoryUnitOperations -> {
				Units -> None,
				Relation -> Null,
				Format -> Multiple,
				Class -> Expression,
				Pattern :> SamplePreparationP,
				Description -> "The list of sample preparation unit operations performed to test the user's ability in hermetic transfer.",
				Category -> "Hermetic Sealed Transfer Skills"
		}
	}
}]