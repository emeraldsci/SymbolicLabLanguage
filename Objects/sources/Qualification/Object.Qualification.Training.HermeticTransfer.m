(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, Training ,HermeticTransfer], {
	Description->"A protocol that verifies an operator's ability to perform hermetic transfer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		HermeticSamplePreparationProtocol -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,ManualSamplePreparation],
			Description->"The Manual Sample Preparation sub protocol that tests the user's hermetic transfer skills.",
			Category->"Hermetic Sealed Transfer Skills"
		}
	}
}
]