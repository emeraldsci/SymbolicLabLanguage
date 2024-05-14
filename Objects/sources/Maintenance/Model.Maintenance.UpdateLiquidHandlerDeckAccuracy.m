(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance,UpdateLiquidHandlerDeckAccuracy],{
	Description->"Definition of a set of parameters for a maintenance protocol that measures and optimizes the offsets of the various positions on deck of the Hamilton liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		NumberOfWells->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[4,1],
			Units->None,
			Description->"Number of individual wells measurements per plate required in order to update the deck offset.",
			Category->"General"
		}
	}
}]