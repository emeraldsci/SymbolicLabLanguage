(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Building], {
	Description->"A model of a building with one or multiple floors, rooms, etc.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		PartsList -> {
			Format -> Multiple,
			Class -> {Link, Integer},
			Pattern :> {_Link, _Integer},
			Relation -> {Model[Container] | Model[Instrument] | Model[Part] | Model[Plumbing] | Model[Wiring], Null},
			Description -> "The list of parts (by model) that this container building contains or is built from.",
			Category -> "Inventory",
			Headers -> {"Model", "Quantity"}
		}
		
	}
}];
