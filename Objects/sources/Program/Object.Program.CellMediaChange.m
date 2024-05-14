

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, CellMediaChange], {
	Description->"A robotic liquid handler program to add new media to cells in a plate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		PlateFormat -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> WellNumberP,
			Units -> None,
			Description -> "The number of wells in the plate(s) containing the cells which will recieve new media.",
			Category -> "General",
			Abstract -> True
		},
		MediaVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of media to add to each well.",
			Category -> "General",
			Abstract -> True
		},
		LidPositions -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The position of the cell plate lids.",
			Category -> "Robotic Liquid Handling"
		},
		MediaWells -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The position of the wells recieving media.",
			Category -> "Robotic Liquid Handling"
		}
	}
}];
