(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Cuvette], {
	Description->"A description of a cuvette which can be used to hold a sample during spectroscopic experiments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		VolumeCalibrations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration, Volume][ContainerModels],
			Description -> "Pathlength-to-volume calibrations performed on this model of container.",
			Category -> "Experimental Results",
			Developer->True
		},
		PathLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The distance light will travel from entering the sample to exiting it.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		WallType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WallTypeP,
			Description -> "Indicates if the cuvette has two clear sides (Frosted), four clear sides (Clear) or is self masking (BlackWalled).",
			Category -> "Container Specifications",
			Abstract -> True
		},
		NeckType -> {
			Format -> Single,
			Class -> String,
			Pattern :> NeckTypeP,
			Description -> "The GPI/SPI Neck Finish designation of the cuvette used to determine the cap threading.",
			Category -> "Container Specifications"
		},
		MinRecommendedWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength below which insufficient transmission occurs for most spectroscopic experiments performed using this cuvette.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxRecommendedWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength above which insufficient transmission occurs for most spectroscopic experiments performed using this cuvette.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		WindowWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The horizontal size (left-to-right) of the optical window.",
			Category -> "Container Specifications"
		},
		WindowHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The vertical size (top-to-bottom) of the optical window.",
			Category -> "Container Specifications"
		},
		WindowOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the bottom of the cuvette to the center of the optical window. This should correspond with the beam offset (Z-height) on the instrument used with this cuvette.",
			Category -> "Container Specifications"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli,Meter Milli},
			Headers -> {"Width","Depth"},
			Description -> "Interior dimensions of the cuvette's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		InternalDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Interior diameter of the cuvette's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		InternalDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Maximum interior depth of the cuvette's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		Aperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Milli,
			Description -> "The minimum opening diameter encountered when aspirating from the container.",
			Category -> "Dimensions & Positions"
		},
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CuvetteScaleP,
			Description -> "Indicates the size of the cuvette.",
			Category -> "Dimensions & Positions"
		},
		RecommendedFillVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The largest recommended fill volume in the wells of this plate.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
