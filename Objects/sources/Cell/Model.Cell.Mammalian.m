(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Cell,Mammalian], {
	Description->"Model information for a cell line that is derived from a mammalian organism.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Tissues -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Tissue][Cells],
			Description -> "The types of tissue that this cell helps comprise.",
			Category -> "Organizational Information"
		},
		Morphology -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MammalianCellMorphologyP,
			Description -> "The morphological type of the cell line.",
			Category -> "Physical Properties"
		}
	}
}];
