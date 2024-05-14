(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, RefillTransferEnvironment], {
	Description->"Definition of a set of parameters for a maintenance protocol that refills any consumables that are stored in a given transfer environment (BSC or glove box).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NumberOfKimwipes ->{
			Format->Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "The number of full boxes of kimwipes that should be stored in this transfer environment.",
			Category -> "Instrument Specifications"
		},
		NumberOfGloves ->{
			Format->Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "The number of full extra-large boxes of gloves that should be stored in this transfer environment.",
			Category -> "Instrument Specifications"
		},
		PipetteModels -> {
			Format -> Multiple,
			Class -> {Link, Integer},
			Pattern :> {_Link, GreaterP[0,1]},
			Relation -> {Model[Instrument, Pipette], Null},
			Units -> {None, None},
			Description -> "A list of the pipette models (and their quantities) that should be stocked in the transfer environment.",
			Category -> "Qualifications & Maintenance",
			Headers ->  {"Pipette Model", "Number of Pipette Models"}
		},
		TipModels-> {
			Format -> Multiple,
			Class -> {Link, Integer},
			Pattern :> {_Link, GreaterP[0,1]},
			Relation -> {Model[Item, Tips], Null},
			Units -> {None, None},
			Description -> "A list of the pipette tip models (and their quantities) that should be stocked in the transfer environment.",
			Category -> "Qualifications & Maintenance",
			Headers ->  {"Pipette Tip Model", "Number of Pipette Models"}
		}
	}
}];
