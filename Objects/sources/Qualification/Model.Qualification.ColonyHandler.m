(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, ColonyHandler], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a colony handler.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		ImageColonies -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's ability to perform imaging colonies.",
			Category -> "Qualification Parameters"
		},
		SpreadCells -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's ability to perform spreading cells.",
			Category -> "Qualification Parameters"
		},
		PickColonies -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's ability to perform picking colonies.",
			Category -> "Qualification Parameters"
		},
		ImagingSamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A list of transfers, mixes and incubation that will be performed in the order listed to prepare samples for the qualification of imaging module.",
			Category -> "General"
		},
		ImagingStrategies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[QPixImagingStrategiesP],
			Description -> "The imaging capabilities of the instrument model this qualification tests. The available options include BrightField imaging, BlueWhite Screening, and Fluorescence imaging.",
			Category -> "Imaging Specifications"
		},
		ImagingChannels -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[QPixFluorescenceWavelengthsP, QPixAbsorbanceWavelengthsP, BrightField],
			Description -> "The imaging channels the qualification should test the instrument's ability to perform imaging.",
			Category -> "Imaging Specifications"
		}
	}
}];
