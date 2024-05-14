(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, CrystalIncubator], {
	Description->"An instrument used for incubating and imaging crystallization plate containing crystals. The crystallization plate is used to perform screening/optimization/preparation for X-ray Diffraction (XRD). The growth of crystals is monitored by built-in imaging during storage.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		(* --- Instrument Specifications --- *)
		ImagingModes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ImagingModes]],
			Pattern :> {ImagingModeP..},
			Description -> "The types of images the built-in microscope of this crystal incubator is capable of generating.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ZStackImaging -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ZStackImaging]],
			Pattern :> BooleanP,
			Description -> "Indicates if the built-in microscope of this crystal incubator can acquire a series of images at multiple z-axis positions from a sample.",
			Category -> "Instrument Specifications"
		},
		Autofocus -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Autofocus]],
			Pattern :> BooleanP,
			Description -> "Indicates if the built-in microscope of this crystal incubator is fitted with an Autofocus feature to automatically find the focal plane of a sample.",
			Category -> "Instrument Specifications"
		},
		DefaultVisibleLightObjectiveMagnification -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[1],
			Description -> "The visible light objective lens magnification provided to zoom in on the sample for this crystal incubator when image scheduling is automatic.",
			Category -> "Instrument Specifications"
		},
		DefaultVisibleLightImageScale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Pixel/Millimeter],
			Units -> Pixel/Millimeter,
			Description -> "The scale in pixels/distance relating pixels of the image to real world distance when the sample was illuminated with visible light and passed through the magnification lens for this crystal incubator with automatic image schedule.",
			Category -> "Instrument Specifications"
		},
		DefaultVisibleLightExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millisecond],
			Units -> Millisecond,
			Description -> "The amount of time for which the visible light camera shutter stays open when acquiring an image with automatic image schedule and AutoExposure setting.",
			Category -> "Operating Limits"
		},
		DefaultUVObjectiveMagnification -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[1],
			Description -> "The ultraviolet light objective lens magnification provided to zoom in on the sample for this crystal incubator with automatic image schedule.",
			Category -> "Instrument Specifications"
		},
		DefaultUVImageScale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Pixel/Millimeter],
			Units -> Pixel/Millimeter,
			Description -> "The scale in pixels/distance relating pixels of the image to real world distance when the sample was illuminated with ultraviolet light and passed through the magnification lens for this crystal incubator with automatic image schedule.",
			Category -> "Instrument Specifications"
		},
		DefaultUVExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millisecond],
			Units -> Millisecond,
			Description -> "The amount of time for which theUV camera shutter stays open when acquiring an image with automatic image schedule and AutoExposure setting.",
			Category -> "Operating Limits"
		},
		DefaultCrossPolarizationObjectiveMagnification -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[1],
			Description -> "The cross polarized light objective lens magnification provided to zoom in on the sample for this crystal incubator when image scheduling is automatic.",
			Category -> "Instrument Specifications"
		},
		DefaultCrossPolarizedImageScale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Pixel/Millimeter],
			Units -> Pixel/Millimeter,
			Description -> "The scale in pixels/distance relating pixels of the image to real world distance when the sample was illuminated with cross polarized light and passed through the magnification lens for this crystal incubator with automatic image schedule.",
			Category -> "Instrument Specifications"
		},
		DefaultCrossPolarizedExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millisecond],
			Units -> Millisecond,
			Description -> "The amount of time for which the visible light camera shutter stays open with motorized polarizer in light path when acquiring an image with automatic image schedule and AutoExposure setting.",
			Category -> "Operating Limits"
		},
		DefaultTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature this crystal incubator is set to maintain.",
			Category -> "Instrument Specifications"
		},
		Chiller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,Chiller][Instrument],
			Description -> "The chiller used to maintain the temperature of this crystal incubator.",
			Category -> "Instrument Specifications"
		},
		SecondaryChiller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,Chiller][Instrument],
			Description -> "The secondary chiller used together with Chiller to maintain the temperature of this crystal incubator.",
			Category -> "Instrument Specifications"
		},
		LoadingPort -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Shelf],
			Description -> "The SBS plate hotel within this crystal incubator, designed specifically for the purpose of loading and unloading crystallization plates.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		IntegratedBarcodePrinter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, InformationTechnology],
				Object[Part, StickerPrinter]
			],
			Description -> "The barcode printer connected to this crystal incubator to produce FormulatrixPlateID sticker before inserting the crystallization plate into the LoadingPort.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		Capacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Capacity]],
			Pattern :> GreaterP[0],
			Description -> "The maximum number of crystallization plates can be stored inside of this model of crystal incubator at the same time.",
			Category -> "Instrument Specifications"
		},
		(* --- Physical Properties --- *)
		TemperatureLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Object[Data,Temperature]},
			Description -> "A historical environment temperature record of this crystal incubator taken daily.",
			Category -> "Physical Properties",
			Headers -> {"Date", "Data"}
		}
	}
}];