(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, DocumentScanner], {
	Description->"The model for a scanner that takes digital copies of physical documentation produced by an external supplier.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Instrument Specifications --- *)
		ScannerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ScannerTypeP,
			Description -> "The type of optical device for the scanning process.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		OpticalSensor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalSensorP,
			Description -> "The built-in detection hardware for the scanning process.",
			Category -> "Instrument Specifications"
		},
		SensorColorType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SensorColorTypeP,
			Description -> "The produced color of digital documentation following scanning detection.",
			Category -> "Instrument Specifications"
		},
		LightSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LightSourceTypeP,
			Description -> "The built-in illumination device for the scanning process.",
			Category -> "Instrument Specifications"
		},
		ScanningSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 /Minute],
			Description -> "The number of one-sided pages per minute that the scanner can process.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DuplexScanningSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 /Minute],
			Description -> "The number of two-sided pages per minute that the scanner can process.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of pixel sensors per horizontal inch placed on the flatbed.",
			Category -> "Instrument Specifications"
		},
		ColorBitDepth -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of bits used to define RGB color channels for each pixel.",
			Category -> "Instrument Specifications"
		},
		GrayscaleBitDepth -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of bits used to define black to white color channels for each pixel.",
			Category -> "Instrument Specifications"
		},
		FlatbedMaxArea -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0 Inch],GreaterP[0 Inch]},
			Units -> {Inch,Inch},
			Headers -> {"Page Width","Page Length"},
			Description -> "The largest space available to scan documents via the flatbed.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MaxDailyNumberOfPages -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The maximum number of pages the manufacturer recommends processing in a day.",
			Category -> "Instrument Specifications"
		},
		(* --- Document Feeder --- *)
		DocumentFeeder -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the scanner has a device which can automatically feed pages attached to it.",
			Category -> "Document Feeder",
			Abstract -> True
		},
		DocumentFeederMaxArea -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0 Inch],GreaterP[0 Inch]},
			Units -> {Inch,Inch},
			Headers -> {"Page Width","Page Length"},
			Description -> "The largest space available to scan documents via the automatic document feeder.",
			Category -> "Document Feeder"
		},
		DocumentFeederResolution -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Units -> None,
			Description -> "The number of pixel sensors placed per horizontal inch on the automatic document feeder.",
			Category -> "Document Feeder"
		},
		DocumentFeederMaxNumberOfPages -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Units -> None,
			Description -> "The highest count of pages that can be loaded via the document feeder in a single run.",
			Category -> "Document Feeder"
		},
		DocumentFeederScannerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ScannerTypeP,
			Description -> "The type of optical device built into the automatic document feeder.",
			Category -> "Document Feeder"
		},
		DocumentFeederColorSensorType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SensorColorTypeP,
			Description -> "The produced color of digital documentation following automatic feeding.",
			Category -> "Document Feeder"
		}

	}
}];
