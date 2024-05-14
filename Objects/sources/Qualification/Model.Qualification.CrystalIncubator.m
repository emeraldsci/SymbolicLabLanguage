(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, CrystalIncubator], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a crystal incubator.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SampleModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The template protein sample to use in the qualification.",
			Category -> "Sample Preparation"
		},
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of sample in each well in the qualification.",
			Category -> "Sample Preparation"
		},
		SampleWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "The list of sample wells that samples will be transferred to.",
			Category -> "Sample Preparation"
		},
		ReservoirBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> Pattern :> _Link,
			Relation -> (Model[Sample] | Object[Sample]),
			Description -> "The cocktail solution which contains high concentration of precipitants, salts and pH buffers to facilitate the crystallization of qualification sample.",
			Category -> "Sample Preparation"
		},
		ReservoirDropVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VolumeP,
			Units -> Microliter,
			Description -> "The amount of ReservoirBuffer that is transferred into the sample well to mix with the input qualification sample.",
			Category -> "Sample Preparation"
		},
		CrystallizationCover -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, PlateSeal],
			Description -> "The cover to be used to seal the crystallization plate.",
			Category -> "General"
		},
		CrystallizationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Plate, Irregular, Crystallization],
			Description -> "The crystallization plate to be sealed and imaged in the qualification.",
			Category -> "General"
		},
		MaxCrystallizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Day],
			Units -> Day,
			Description -> "The max length of time for which the sample is held inside the crystal incubator in the qualification.",
			Category -> "General"
		},
		CrystalScoreThreshold -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "The MARCO score above that the images of qualification samples are considered a pass. The MARCO score ranges from 0 to 1, where 1 indicates a positive outcome (crystals), and 0 indicates a negative outcome (non-crystals).",
			Category -> "Passing Criteria"
		},
		BlankScoreThreshold -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "The MARCO score below that the images of empty wells are considered a pass. The MARCO score ranges from 0 to 1, where 1 indicates a positive outcome (crystals), and 0 indicates a negative outcome (non-crystals).",
			Category -> "Passing Criteria"
		}
	}
}];
