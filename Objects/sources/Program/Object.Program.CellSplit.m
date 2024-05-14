(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Program, CellSplit], {
	Description->"A robotic liquid handler program to split cells up and dilute them into fresh growth media in order to grow the overall population size.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		CellSamples -> {
			Format -> Multiple,
			Class -> {String, Link, Real, Integer},
			Pattern :> {WellP, _Link, VolumeP, _Integer},
			Relation -> {Null, Object[Sample], Null, Null},
			Units -> {None, None, Liter Micro, None},
			Description -> "The source sample and volume of cells from that sample to put into the deck position of destination plate (since these future plate samples do not exist yet) and well for cell splitting.",
			Category -> "General",
			Headers -> {"Well","Sample","Volume","Plate Number"},
			Abstract -> True
		},
		CellType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CultureAdhesionP,
			Description -> "The type of cells being split by this program.",
			Category -> "General",
			Abstract -> True
		},
		PlateFormat -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> WellNumberP,
			Units -> None,
			Description -> "The number of wells in the plate into which the cells will be moved.",
			Category -> "General",
			Abstract -> True
		},
		InitialWellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Micro,
			Description -> "The initial volume in the wells containing the cells. This determines the amount of media that will be removed prior to cell washing and trypsinization.",
			Category -> "General"
		},
		WashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of wash buffer used to wash cells during the cell split.",
			Category -> "General"
		},
		NumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cells are washed with PBS during the cell split.",
			Category -> "General"
		},
		TrypsinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of trypsin used to loosen cells from the bottom of the wells during the cell split.",
			Category -> "General"
		},
		TrypsinizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the cells are incubated with trypsin during the cell split.",
			Category -> "General"
		},
		InactivationVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of media added to each well of trypsinized cells in order to deactivate the trypsin.",
			Category -> "General"
		},
		BleachVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of bleach added to each well of cells being killed.",
			Category -> "General"
		},
		BleachTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the untransferred cells should be incubated with bleach after the cell split.",
			Category -> "General"
		},
		AspirationVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume to remove from each well of bleached cells in order to fully empty it.",
			Category -> "General"
		},
		Bleach -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> NumericBooleanP,
			Units -> None,
			Description -> "Indicates if the plates will be bleached after the cell split.",
			Category -> "Robotic Liquid Handling"
		},
		ContainersInLidLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The position of the lids on the plate(s) containing the cells to be split.",
			Category -> "Robotic Liquid Handling"
		},
		ContainersOutLidLocations -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The position of the lids on the new plates to which cells are being transferred.",
			Category -> "Robotic Liquid Handling"
		},
		TrypsinLocations -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The position of wells to be trypsinized and/or mixed before splitting.",
			Category -> "Robotic Liquid Handling"
		},
		CellTransfers -> {
			Format -> Multiple,
			Class -> {String, String, Real, Real},
			Pattern :> {Patterns`Private`robotSequenceP, Patterns`Private`robotSequenceP, GreaterEqualP[0*Liter], GreaterEqualP[0*Liter]},
			Units -> {None, None, Liter Micro, Liter Micro},
			Description -> "The positions and volumes describing the cell split.",
			Category -> "Robotic Liquid Handling",
			Headers -> {"Initial Cell Position","Cell Destination","Cell Transfer Volume","Additional Media Volume"}
		},
		IncubatorStorageFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The filename (including full file path) of a JSON file containing instructions for temporary storage of plates in an integrated automated incubator following completion of the cell split robotic method.",
			Category -> "Robotic Liquid Handling"
		}
	}
}];
