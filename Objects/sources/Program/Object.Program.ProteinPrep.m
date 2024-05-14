

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, ProteinPrep], {
	Description->"A set of parameters used by a robotic liquid handler to prepare whole-cell protein lysates from tissue culture cells.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		CellType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CultureAdhesionP,
			Description -> "The morphology of cell line from which protein is being extracted.",
			Category -> "General"
		},
		MediaVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of media that is aspirated from adherent cells before washing and adding lysis buffer.",
			Category -> "General"
		},
		WashBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of PBS that is applied to adherent cells to wash before adding lysis buffer.",
			Category -> "General"
		},
		LysisVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of lysis buffer that is added to the cells.",
			Category -> "General"
		},
		LysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second, Second],
			Units -> Second,
			Description -> "The length of time for which the cells are incubated with lysis buffer.",
			Category -> "General"
		},
		LysisTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[4*Celsius],
			Units -> Celsius,
			Description -> "The temperature at which the cells are incubated with lysis buffer.",
			Category -> "General"
		},
		PlateFormat -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> WellNumberP,
			Units -> None,
			Description -> "The number of wells in the source plate.",
			Category -> "General"
		},
		ProteinLysates -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {SLLWellPositionP, _Link},
			Relation -> {Null, Object[Sample]},
			Units -> {None, None},
			Description -> "The list of wells holding protein samples.",
			Category -> "General",
			Abstract -> True,
			Headers -> {"Filter Plate Well", "Source Sample"}
		},
		CellSourceLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string containing the wells of cells from which protein is extracted.",
			Category -> "Robotic Liquid Handling"
		},
		FiltrationLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string containing the filter plate wells through which cell lysate is filtered.",
			Category -> "Robotic Liquid Handling"
		},
		LysisBufferDestinationLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string containing the wells to which lysis buffer is added to lyse the cells.",
			Category -> "Robotic Liquid Handling"
		},
		PlateLidPositions -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The positions of the source plate lids on the robot deck.",
			Category -> "Robotic Liquid Handling"
		},
		AliquotVolume -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotNumberListP,
			Description -> "The volume of cells that are transferred from the CellSourceLocations to the FiltrationLocations during each aliquot.",
			Category -> "Robotic Liquid Handling"
		},
		NumberOfAliquots -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of aliquots of suspension cells that are filtered through each well before lysis buffer is added.",
			Category -> "Robotic Liquid Handling"
		},
		WellsToMix -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "A robot-interpretable string containing the cell source wells that are mixed before aliquoting.",
			Category -> "Robotic Liquid Handling"
		},
		ProteinQuantificationID -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The numerical ID of the protein quantification program associated with this protein prep, if any.",
			Category -> "Robotic Liquid Handling"
		}
	}
}];
