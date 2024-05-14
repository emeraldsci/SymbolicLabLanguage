

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, CellBleach], {
	Description->"A robotic liquid handler program which safely disposes of cells by incubating them with bleach and removing them from the plate(s).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		PlateFormat -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> WellNumberP,
			Units -> None,
			Description -> "The number of wells in the plate(s) containing the cells to bleach.",
			Category -> "General",
			Abstract -> True
		},
		BleachTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the cells should be incubated with bleach.",
			Category -> "General",
			Abstract -> True
		},
		BleachVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of bleach to add to each well of cells.",
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
		LidPositions -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The position of the cell plate lids.",
			Category -> "Robotic Liquid Handling"
		},
		BleachWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The position of the wells to be bleached.",
			Category -> "Robotic Liquid Handling"
		}
	}
}];
