

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Room], {
	Description->"A container that represents a room within a floor of a building.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		PaintProduct -> {
			Format -> Multiple,
			Class -> {Name -> String, FinishType -> String, PaintID -> String},
			Pattern :> {Name -> _String, FinishType -> _String, PaintID -> _String},
			Units -> {Name -> None, FinishType -> None, PaintID -> None},
			Description -> "Different paint specifications for the multiple paints used in a specific room.",
			Headers -> {Name -> "Brand Of Paint", FinishType -> "Paint Finish", PaintID -> "Paint Code"},
			Category -> "Container Specifications"
		}
	}
}];
