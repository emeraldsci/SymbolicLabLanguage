(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, CellThaw], {
	Description->"A device that thaws cryogenically preserved cells in a controlled manner.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Capacity -> {
			Format -> Multiple,
			Class -> {Link, Integer},
			Pattern :> {_Link, GreaterP[0, 1]},
			Relation -> {Model[Container], Null},
			Units -> {None, None},
			Description -> "The thawing capacity of the instrument.",
			Category -> "Instrument Specifications",
			Headers -> {"Model Container","Max Number"}
		}
	}
}];
