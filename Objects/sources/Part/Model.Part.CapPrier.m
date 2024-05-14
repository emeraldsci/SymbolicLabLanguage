(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, CapPrier], {
	Description->"Model information for a tool used to pry caps off the tops of containers when CoverType->Pry.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CoverFootprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CoverFootprintP,
			Description -> "The footprint of the caps that this instrument is compatible with.",
			Category -> "Physical Properties"
		}
	}
}];
