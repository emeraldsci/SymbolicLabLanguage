

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Objective], {
	Description->"Model information for an objective lens used in a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Magnification -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times that the object is enlarged by the objective.",
			Category -> "Optical Information",
			Abstract -> True
		},
		NumericalAperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "A dimensionless number that describes the ability of the objective to gather light and resolve detail. It is equal to n(sin(Theta)) where n is the refractive index of the medium and Theta is the half-angle of the maximum cone of light that can enter the objective lens.",
			Category -> "Optical Information"
		},
		ImmersionMedium -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ObjectiveImmersionMediumP,
			Description -> "The type of medium that should be placed between the sample container bottom and the objective lens when imaging the sample to reduce refractive index differences.",
			Category -> "Optical Information"
		},
		MinWorkingDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The minimum distance between the tip (front edge) of the objective lens and the surface of the specimen for focused images.",
			Category -> "Optical Information"
		},
		MaxWorkingDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum distance between the tip (front edge) of the objective lens and the surface of the specimen for focused images.",
			Category -> "Optical Information"
		},

		(* TODO: remove ObjectiveFieldNumber *)
		ObjectiveFieldNumber -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The diameter of the view field measured in millimeters at the intermediate image plane. The field size in the specimen plane is defined as the objective field number divided by the magnification of the objective.",
			Category -> "Optical Information"
		},

		PhaseContrast -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PhaseContrastObjectiveP,
			Description -> "The type of phase contrast that this objective is designed for.",
			Category -> "Optical Information"
		},
		PhaseRing -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PhaseRingP,
			Description -> "The type of Phase Ring (Condenser Annulus Ring) on the condenser turret that this objective should be used with for Phase Contrast Microscopy.",
			Category -> "Optical Information"
		},
		DifferentialInterferenceContrast -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the objective is designed for differential interference contrast (a.k.a Nomarski interference contrast) microscopy, whereby interferometry techniques are used to gather information on the optical path length to better see unstained, transparent specimens.",
			Category -> "Optical Information"
		},
		BrightField -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the objective can be used for Brightfield imaging.",
			Category -> "Optical Information"
		},
		Fluorescence -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the objective can be used for Fluorescence imaging.",
			Category -> "Optical Information"
		},
		FlatFieldCorrection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the objective has inbuilt optics for flat-field correction, i.e. correcting for the Petzval Curvature of the lens.",
			Category -> "Optical Information"
		},
		AberrationCorrection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AberrationCorrectionP,
			Description -> "The type of aberration correction that the objective employs, including spherical and axial chromatic aberration.",
			Category -> "Optical Information"
		},

		(* TODO: migrate value from CoverGlassAdjustmentGauge to CorrectionCollar *)
		CoverGlassAdjustmentGauge -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the presence of a secondary focusing ring on the objective to adjust for subtle differences in cover glass thickness that can cause spherical aberrations in the image.",
			Category -> "Optical Information"
		},
		CorrectionCollar -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if there is a secondary focusing ring on the objective to adjust for differences in container bottom thickness that can cause spherical aberrations in the image. When present, the correction collar should be adjusted based on the container bottom thickness.",
			Category -> "Optical Information"
		},

		MinCoverGlassThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The minimum cover glass thickness for which this objective is designed for.",
			Category -> "Optical Information"
		},
		MaxCoverGlassThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum cover glass thickness for which this objective is designed for.",
			Category -> "Optical Information"
		},

		(* TODO: migrate value from RetractiveStopper to SpringLoaded *)
		SpringLoaded -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if objective is equipped with a retractable front lens assembly to prevent collision damage when the objective is accidentally driven into the container surface.",
			Category -> "Optical Information"
		},
		RetractiveStopper -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if a stopper to prevent clean slides from being accidentally smeared with immersion oil is present.",
			Category -> "Optical Information"
		},
		TubeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> Meter Milli,
			Description -> "This is the length of the microscope tube body for which the objective is designed for.",
			Category -> "Optical Information"
		},
		InfinityCorrectedTube -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the objective has been designed for a microscope tube body that has been infinity corrected. This implies that the objective produces a parallel wavefront, imaged at infinity.",
			Category -> "Optical Information"
		},
		LensMaterial -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The lens material designation given by the manufacturer.",
			Category -> "Optical Information"
		},
		MetaXpressPrefix->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The unique string prefix used to reference this objective in the MetaXpress software.",
			Category -> "General",
			Developer->True
		}
	}
}];
