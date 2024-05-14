

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, CapillaryELISA], {
	Description->"Model information for a device that runs capillary Enzyme-Linked Immunosorbent Assays (ELISA) experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* Instrument Specifications *)
		ExcitationSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ExcitationSourceP,
			Description -> "The light source available to excite and probe the sample.",
			Category -> "Instrument Specifications"
		},
		ExcitationSourceType -> {
		    Format -> Single,
		    Class -> Expression,
		    Pattern :> LightSourceTypeP,
		    Description -> "Specifies whether the instrument lamp provides continuous light or if it is flashed at time of acquisition.",
		    Category -> "Instrument Specifications"
        },
		ExcitationFilterType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the excitation source.",
			Category -> "Instrument Specifications"
		},
		ExcitationWavelength -> {
		    Format -> Single,
		    Class -> Real,
		    Pattern :> GreaterP[0*Nano*Meter],
		    Units -> Nano*Meter,
		    Description -> "The wavelength at which the instrument can excite the sample.",
			Category -> "Instrument Specifications"
		},
		EmissionFilterType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the emission detector.",
			Category -> "Instrument Specifications"
		},
		EmissionDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the emissions from the sample.",
			Category -> "Instrument Specifications"
		},
		EmissionWavelength -> {
		    Format -> Single,
		    Class -> Real,
		    Pattern :> GreaterP[0*Nano*Meter],
		    Units -> Nano*Meter,
			Description -> "The wavelength at which the instrument can take emission readings.",
			Category -> "Instrument Specifications"
		},
		BarcodeReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Model[Part,BarcodeReader]],
			Relation -> Model[Part,BarcodeReader][SupportedInstrument],
			Description -> "The model of the barcode scanner that can be used with this model of capillary ELISA device for scanning kit information QR codes into the capillary ELISA software.",
			Category -> "Instrument Specifications"
		},
		TestCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Model[Part,CapillaryELISATestCartridge]],
			Relation -> Model[Part,CapillaryELISATestCartridge][SupportedInstrument],
			Description -> "The model of the verification cartridge plate that can be used by this model of capillary ELISA instrument to perform a series of diagnostic tests to ensure the instrument is running properly.",
			Category -> "Instrument Specifications"
		},
		(* Operating Limits *)
		MaxAnalytes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "Maximum number of analytes that can be detected and quantified for one sample in one capillary ELISA experiment.",
			Category -> "Operating Limits"
		},
		MaxNumberOfSamples -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "Maximum number of samples that can be loaded into a single capillary ELISA cartridge plate and analyzed in one experiment.",
			Category -> "Operating Limits"
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "Minimum volume of each sample required to make the diluted sample loaded into the capillary ELISA cartridge plate for ELISA experiment.",
			Category -> "Operating Limits"
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "Maximum volume of each sample that can be loaded into the capillary ELISA cartridge plate for ELISA experiment.",
			Category -> "Operating Limits"
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The thermostat temperature at which the capillary ELISA experiment is held during the experiment.",
			Category -> "Operating Limits"
		}
	}
}];
