

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, MitochondrialIntegrityAssay], {
	Description->"A program that runs the assay to detect the loss of the electrochemical potential gradient across the mitochondrial membrane.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		CellType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CultureAdhesionP,
			Description -> "The type of cells being assayed by this program.",
			Category -> "General",
			Abstract -> True
		},
		NumberOfWells -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> WellNumberP,
			Units -> None,
			Description -> "The number of wells in the plate being prepared, options include 6, 12, 24, 96.",
			Category -> "General",
			Abstract -> True
		},
		StainingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The length of time the cells are incubated with the mitochondrial detector dye reagent.",
			Category -> "General",
			Abstract -> True
		},
		StainingTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature at which the cells are incubated with the mitochondrial detector dye.",
			Category -> "General"
		},
		TrypsinizedVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The total volume of cells and media in the source plate wells after trypsinization.",
			Category -> "General"
		},
		FilterVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of suspended cells to transfer from the source wells to the filter wells.",
			Category -> "General"
		},
		WashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of mitochondrial detector dye and buffer to wash the cells.",
			Category -> "General"
		},
		MitochondrialDetectorVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of mitochondrial detector dye to incubate with the cells.",
			Category -> "General",
			Abstract -> True
		},
		BufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of buffer to use in washing adherent cells during staining and flow prep when the cells are to be trypsinized.",
			Category -> "General"
		},
		TrypsinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of trypsin to use to loosen adherent cells from the bottom of the source wells during an adherent staining and flow prep when the cells are to be trypsinized.",
			Category -> "General",
			Abstract -> True
		},
		InactivationVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of media to add to a well of trypsinized cells in order to deactivate that trypsin during an adherent staining and flow prep when the cells are to be trypsinized.",
			Category -> "General"
		},
		ResuspensionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of resuspended cells to stamp from one well to the next during consolidation of wells.",
			Category -> "General"
		},
		FinalVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "Volume to fill the well up to with reaction buffer for resuspension of cells after washing and staining.",
			Category -> "General"
		},
		NumberOfFilterings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the FilterVolume of cells is moved to the vacuum filter plate and vacuumed.",
			Category -> "General"
		},
		NumberOfReactionWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times to wash the stained cells with reaction buffer after staining.",
			Category -> "General"
		},
		NumberOfBufferWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cells are washed with buffer during staining and flow prep when the cells are to be trypsinized.",
			Category -> "General"
		},
		PlateLidLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string  of the positions of the cell plate lids on the robot deck.",
			Category -> "Robotic Liquid Handling"
		},
		WellsToMix -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string containing the wells of cells to be trypsinized and/or mixed before filtering and staining.",
			Category -> "Robotic Liquid Handling"
		},
		CellSourcePositions -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string containing the wells of cells from which to transfer to the filter plate.",
			Category -> "Robotic Liquid Handling"
		},
		FiltrationWells -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string of filter plate wells to which cells must be transferred for filtration.",
			Category -> "Robotic Liquid Handling"
		},
		ResuspensionWells -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string describing the location of wells of cells in the filter plate to be resuspended by mixing up and down and then transferred to the final destination plate for analysis.",
			Category -> "Robotic Liquid Handling"
		},
		ReadWells -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string describing the destination wells for resuspended cells from the filter plate, that are ready for measurement.",
			Category -> "Robotic Liquid Handling"
		},
		MitochondrialDetectorLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string of the location of the mitochondrial detector dye on the robot deck.",
			Category -> "Robotic Liquid Handling"
		},
		ReactionBufferLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string of the location of the reaction buffer on the robot deck.",
			Category -> "Robotic Liquid Handling"
		},
		TipLoad -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> 0 | 1,
			Units -> None,
			Description -> "A robot-interpretable string indicating whether new tips need to be loaded to the tip adapter: 1 = load, 0 = do not load.",
			Category -> "Robotic Liquid Handling"
		},
		TipUnload -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> 0 | 1,
			Units -> None,
			Description -> "A robot-interpretable string indicating whether residual tips in the tip adapter need to be unloaded to make way for a new batch of tips: 1 = unload, 0 = do not unload.",
			Category -> "Robotic Liquid Handling"
		},
		TipLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The location of the tips that are compatible with the 96-head pipettor.",
			Category -> "Robotic Liquid Handling"
		},
		TipAdapterLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The location of the tip adapter (specifically the A1 position), from which the 96-head pipettor can pick up any arbitrary number of tips (up to 96).",
			Category -> "Robotic Liquid Handling"
		}
	}
}];
