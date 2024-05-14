

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, CellStaining], {
	Description->"A robotic liquid handler program which prepares a plate of stained cells for use in microscopy.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		PlateFormat -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> WellNumberP,
			Units -> None,
			Description -> "The number of wells in the plate(s) containing the cells to stain.",
			Category -> "General",
			Abstract -> True
		},
		LidPositions -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The positions of the cell plate lids.",
			Category -> "Robotic Liquid Handling"
		},
		StainingWells -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The position of the wells containing cells to stain.",
			Category -> "Robotic Liquid Handling"
		},
		StainPosition -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The location of the chemical used for staining.",
			Category -> "Robotic Liquid Handling"
		},
		StainTransfers -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The positions of the wells into which cells, stains and/or antibodies will be transferred.",
			Category -> "Robotic Liquid Handling"
		},
		PrimaryAntibodyTransfers -> {
			Format -> Multiple,
			Class -> {String, String},
			Pattern :> {Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP},
			Units -> {None, None},
			Description -> "Describes the transfer of primary antibodies.",
			Category -> "Robotic Liquid Handling",
			Headers -> {"Initial Position","Destination"}
		},
		SecondaryAntibodyTransfers -> {
			Format -> Multiple,
			Class -> {String, String},
			Pattern :> {Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP},
			Units -> {None, None},
			Description -> "Describes the transfer of secondary antibodies.",
			Category -> "Robotic Liquid Handling",
			Headers -> {"Initial Position","Destination"}
		}
	}
}];
