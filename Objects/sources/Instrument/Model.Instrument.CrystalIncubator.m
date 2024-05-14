(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, CrystalIncubator], {
	Description->"A model instrument used for incubating and imaging crystallization plate containing crystals. The crystallization plate is used to perform screening/optimization/preparation for X-ray Diffraction (XRD). The growth of crystals is monitored by built-in microscope daily during storage.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Instrument Specifications --- *)
		(*Imaging*)
		ImagingModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ImagingModeP,
			Description -> "The types of images the built-in microscope of this model of crystal incubator is capable of generating.",
			Category -> "Instrument Specifications"
		},
		MicroscopeModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MicroscopeModeP,
			Description -> "For each member of ImagingModes, the type of illumination technique the built-in microscope of this model of crystal incubator is using.",
			IndexMatching -> ImagingModes,
			Category -> "Instrument Specifications"
		},
		ZStackImaging -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the built-in microscope of this model of crystal incubator can acquire a series of images at multiple z-axis positions from a sample.",
			Category -> "Instrument Specifications"
		},
		Autofocus -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the built-in microscope of this model of crystal incubator is fitted with an Autofocus feature to automatically find the focal plane of a sample.",
			Category -> "Instrument Specifications"
		},
		ExcitationFilterWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "Wavelength of excitation light after passing through excitation filter to the sample of the built-in ultraviolet microscope for this model of crystal incubator.",
			Category -> "Instrument Specifications"
		},
		EmissionFilterWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "Wavelength of emitted light after passing through emission filter, on the way to the detector of the built-in ultraviolet microscope for this model of crystal incubator.",
			Category -> "Instrument Specifications"
		},
		(*Storage*)
		MaxPlateDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0 Millimeter],GreaterP[0 Millimeter],GreaterP[0 Millimeter]},
			Units -> {Millimeter,Millimeter,Millimeter},
			Description -> "The maximum size of the crystallization plate that can be put inside this model of crystal incubator for storage and imaging.",
			Category -> "Instrument Specifications",
			Headers -> {"X Direction (Width/Long Axis)","Y Direction (Depth/Short Axis)","Z Direction (Height)"}
		},
		Capacity -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The maximum number of crystallization plates that can be stored inside of this model of crystal incubator at the same time.",
			Category -> "Instrument Specifications"
		},
		(*Parts*)
		Chiller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,Chiller][Instrument],
			Description -> "The model of chiller is used to cool this model of crystal incubator.",
			Category -> "Instrument Specifications"
		},
		LoadingPort -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Shelf],
			Description -> "The SBS plate hotel model designed specifically for the purpose of loading and unloading crystallization plates for this model of crystal incubator.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		(* --- Operating Limits --- *)
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature this model of crystal incubator can maintain.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature this model of crystal incubator can maintain.",
			Category -> "Operating Limits"
		},
		MinExposureTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millisecond],
			Units -> Millisecond,
			IndexMatching -> ImagingModes,
			Description -> "For each member of ImagingModes, the minimum amount of time for which a camera shutter can stay open when acquiring an image.",
			Category -> "Operating Limits"
		},
		MaxExposureTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millisecond],
			Units -> Millisecond,
			IndexMatching -> ImagingModes,
			Description -> "For each member of ImagingModes, the maximum amount of time for which a camera shutter can stay open when acquiring an image.",
			Category -> "Operating Limits"
		}
	}
}];