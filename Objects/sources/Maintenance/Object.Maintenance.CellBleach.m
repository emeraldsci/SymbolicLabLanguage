

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CellBleach], {
	Description->"A protocol that disposes of tissue culture cells by treating them with bleach.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Bleach -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The bleach that is used to dispose of cell samples during this cell bleaching protocol.",
			Category -> "Cell Bleaching",
			Abstract -> True
		},
		BleachVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of bleach used to treat each well of cells.",
			Category -> "Cell Bleaching",
			Abstract -> True
		},
		BleachTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the source cells are incubated with bleach.",
			Category -> "Cell Bleaching",
			Abstract -> True
		},
		AspirationVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The total volume that must be removed from a cell sample in order to entirely empty that well following the bleaching process.",
			Category -> "Cell Bleaching"
		},
		CellBleachProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Maintenance],
			Description -> "A program that contains robot-interpretable instructions for carrying out this cell bleaching protocol.",
			Category -> "General"
		},
		SamplesToBleach -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples to be disposed of by treatment with bleach.",
			Category -> "General",
			Abstract -> True
		},
		ContainersToBleach -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers holding the samples to be disposed of by treatment with bleach.",
			Category -> "General",
			Abstract -> True
		}
	}
}];
