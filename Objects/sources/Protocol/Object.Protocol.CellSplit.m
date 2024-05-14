

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, CellSplit], {
	Description->"A protocol for propagating tissue culture cells by diluting them into fresh media and placing them in new container(s).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Media -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The sample or model Media object that represents the media that will be used during this cell split.",
			Category -> "Reagents"
		},
		WashBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The sample or model StockSolution object that represents the wash buffer (e.g. PBS) that will be used during this cell split.",
			Category -> "Reagents"
		},
		Trypsin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The sample or model StockSolution or Chemical object that represents the trypsin that will be used during this cell split.",
			Category -> "Reagents"
		},
		Bleach -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The sample model Consumable object that represents the bleach that will be used during this cell split.",
			Category -> "Reagents"
		},
		SplitVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of each member of SamplesIn that will be mixed with the corresponding amount of media in MediaVolumes during this Cell Split operation.",
			Category -> "General"
		},
		MediaVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of media that will be mixed with the corresponding amount of cell sample in SplitVolumes during this Cell Split operation.",
			Category -> "General"
		},
		PlateModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The models of the plates that contain the newly split cells (the contents of ContainersOut).",
			Category -> "General"
		},
		WashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?VolumeQ,
			Units -> Liter Micro,
			Description -> "The volume of wash buffer to use to wash adherent cells during a cell split.",
			Category -> "General"
		},
		TrypsinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of trypsin to use to loosen adherent cells from the bottom of the source wells during a cell split.",
			Category -> "General"
		},
		InactivationVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of media to add to a well of trypsinized cells in order to deactivate that trypsin during a cell split.",
			Category -> "General"
		},
		BleachVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of bleach to use to kill the wells of cells during a cell split or cell bleaching.",
			Category -> "General"
		},
		TotalVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The total volume to remove from a well in order to entirely empty that well.",
			Category -> "General"
		},
		SplitRatio -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[SplitVolumes], Field[TotalVolume]}, Unitless[Field[SplitVolumes]]/Unitless[Field[TotalVolume]]],
			Pattern :> {_?NumericQ..},
			Description -> "The volume ratio of source cells to total volume (source cells + fresh media) at which cells are mixed during the cell splitting procedure.",
			Category -> "General"
		},
		NumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the cells should be washed with PBS during an adherent cell split.",
			Category -> "General"
		},
		TrypsinizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the cells should be incubated with trypsin during an adherent cell split.",
			Category -> "General"
		},
		BleachTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the source cells should be incubated with bleach after a cell split.",
			Category -> "General"
		},
		CellSplitProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "The program Object containing detailed instructions for a robotic liquid handler to perform this CellSplit operation.",
			Category -> "General"
		}
	}
}];
