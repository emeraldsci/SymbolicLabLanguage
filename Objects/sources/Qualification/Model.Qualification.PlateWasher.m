(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, PlateWasher], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a plate washer.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		AbsorbanceWavelength -> {
			Format -> Single,
			Description -> "The wavelength used to detect the signal from samples.",
			Pattern :> GreaterP[0 Nanometer],
			Class -> Real,
			Units -> Nanometer,
			Category -> "Detection"
		},
		SignalCorrectionWavelength -> {
			Format -> Single,
			Description -> "The wavelength for absorbance reading that is used to eliminate the interference of background absorbance.",
			Pattern :> GreaterP[0 Nanometer],
			Class -> Real,
			Units -> Nanometer,
			Category -> "Detection"
		},
		PassingResidualIntensityPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The accepted threshold of percentage of measured signal intensity remaining in the plate well after the wash procedure, normalized to the pre-wash intensity measurement. This metric is used to evaluate plate washer wash efficiency, where values at or below the specified threshold indicate a passing wash performance.",
			Category -> "Detection"
		}
	}
}];
