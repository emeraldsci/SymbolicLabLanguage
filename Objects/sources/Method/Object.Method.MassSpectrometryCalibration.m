(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Method, MassSpectrometryCalibration], {
	Description->"A set of parameters used to calibrate a mass spectrometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		IonMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "The type of ion accelerated towards the mass spectrometry detector.",
			Category -> "Ionization",
			Abstract -> True
		},
		Calibrant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample with known mass-to-charge ratios used to calibrate the mass spectrometer.",
			Category -> "Sample Preparation"
		},
		Matrix -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The matrix co-spotted with the calibrant to assist in ionization.",
			Category -> "Sample Preparation"
		},
		SpottingMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SpottingMethodP,
			Description -> "The spotting method used to spot the calibrant sample.",
			Category -> "Sample Preparation"
		},
		MinLaserPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The initial laser power that should be used during analysis as a relative percentage of the nominal laser power.",
			Category -> "Ionization"
		},
		MaxLaserPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The maximum laser power that should be used during analysis (a relative percentage of the nominal laser power).",
			Category -> "Ionization"
		},
		ShotsPerRaster -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of repeated shots between each raster movement within a well.",
			Category -> "Ionization"
		},
		NumberOfShots -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of times the laser is fired to take replicate measurements of the calibrant.",
			Category -> "Ionization"
		},
		DelayTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Nano Second,
			Description -> "The delay measured between the laser shot and the moment where the extraction plate voltage is pulsed down to let the ions pass.",
			Category -> "Ionization"
		},
		Gain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[1,10],
			Description -> "The signal amplification factor applied to the detector.",
			Category -> "Ionization"
		},
		MinMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The lowest measurable mass-to-charge ratio.",
			Category -> "Mass Analysis"
		},
		MaxMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The highest measurable mass-to-charge ratio.",
			Category -> "Mass Analysis"
		},
		AccelerationVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Kilo Volt,
			Description -> "The primary voltage used to accelerate the ionized particles from the source to the detector.",
			Category -> "Mass Analysis"
		},
		GridVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Kilo Volt,
			Description -> "The tuning voltage applied to the grid electrode.",
			Category -> "Mass Analysis"
		},
		LensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Kilo Volt,
			Description -> "The voltage applied to the ion focusing lens.",
			Category -> "Mass Analysis"
		}
	}
}];
