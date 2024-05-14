

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, ProteinPrep], {
	Description->"A protocol for preparing protein lysate from cell samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		CellType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CultureAdhesionP,
			Description -> "The growth pattern of the cells being lysed, which determines which robotic method is employed.",
			Category -> "General",
			Abstract -> True
		},
		ProteinPrepProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "The program object containing detailed instructions for a robotic liquid handler.",
			Category -> "General"
		},
		TotalVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The total volume that must be removed from each cell sample in order to entirely empty that well prior to washing.",
			Category -> "Cell Washing"
		},
		WashBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to wash cells prior to lysis (e.g. PBS).",
			Category -> "Cell Washing"
		},
		WashBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of wash buffer used to wash cells prior to lysis.",
			Category -> "Cell Washing"
		},
		LysisBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to lyse cells and liberate intracellular protein.",
			Category -> "Cell Lysis"
		},
		LysisBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of lysis buffer used to lyse the cells.",
			Category -> "Cell Lysis"
		},
		LysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which cells are incubated with lysis buffer.",
			Category -> "Cell Lysis"
		},
		LysisTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which cells are incubated with lysis buffer.",
			Category -> "Cell Lysis"
		},
		AliquotVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of protein lysate to filter.",
			Category -> "Lysate Filtration"
		},
		NumberOfAliquots -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of aliquots of cells transferred from the source plate to the filter plate.",
			Category -> "Lysate Filtration"
		}
	}
}];
