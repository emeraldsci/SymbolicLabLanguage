(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, CapillaryELISA], {
	Description->"A capillary enzyme-linked immunosorbent assays (ELISA) instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(* Instrument Specifications *)
		ExcitationSource -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationSource]],
			Pattern :> ExcitationSourceP,
			Description -> "The light source available to excite and probe the sample.",
			Category -> "Instrument Specifications"
		},
		ExcitationSourceType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationSourceType]],
			Pattern :> LightSourceTypeP,
			Description -> "Specifies whether the instrument lamp provides continuous light or if it is flashed at time of acquisition.",
			Category -> "Instrument Specifications"
		},
		ExcitationFilterType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationFilterType]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the excitation source.",
			Category -> "Instrument Specifications"
		},
		ExcitationWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationWavelength]],
			Pattern :> GreaterP[0*Nano*Meter],
			Description -> "The wavelength at which the instrument can excite the sample.",
			Category -> "Instrument Specifications"
		},
		EmissionFilterType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionFilterType]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the emission detector.",
			Category -> "Instrument Specifications"
		},
		EmissionDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the emissions from the sample.",
			Category -> "Instrument Specifications"
		},
		EmissionWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionWavelength]],
			Pattern :> GreaterP[0*Nano*Meter],
			Description -> "The wavelength at which the instrument can take emission readings.",
			Category -> "Instrument Specifications"
		},
		MovementLockPosition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EllaMovementLockPositionP,
			Description -> "The current position of the locking element of the instrument, which secures it for movement/cleaning.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		BarcodeReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[Part,BarcodeReader]],
			Relation -> Object[Part,BarcodeReader][ConnectedInstrument],
			Description -> "The barcode scanner attached to the instrument computer that is used for scanning kit information QR codes into the capillary ELISA software.",
			Category -> "Instrument Specifications"
		},
		TestCartridge -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Object[Part,CapillaryELISATestCartridge]],
			Relation -> Object[Part,CapillaryELISATestCartridge][SupportedInstrument],
			Description -> "The verification cartridges that can be used by this capillary ELISA instrument to perform a series of diagnostic tests to ensure the instrument is running properly.",
			Category -> "Instrument Specifications"
		},

		(* Operating Limits *)
		MaxAnalytes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxAnalytes]],
			Pattern :> GreaterEqualP[0,1],
			Description -> "Maximum number of analytes that can be detected and quantified for one sample in one capillary ELISA experiment.",
			Category -> "Operating Limits"
		},
		MaxNumberOfSamples -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxNumberOfSamples]],
			Pattern :> GreaterEqualP[0,1],
			Description -> "Maximum number of samples that can be loaded into a single capillary ELISA cartridge plate and analyzed in one experiment.",
			Category -> "Operating Limits"
		},
		MinVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinVolume]],
			Pattern :> GreaterEqualP[0*Microliter],
			Description -> "Minimum volume of each sample required to make the diluted sample loaded into the capillary ELISA cartridge plate for ELISA experiment.",
			Category -> "Operating Limits"
		},
		MaxVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxVolume]],
			Pattern :> GreaterEqualP[0*Microliter],
			Description -> "Maximum volume of each sample that can be loaded into the capillary ELISA cartridge plate for ELISA experiment.",
			Category -> "Operating Limits"
		},
		Temperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Temperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The thermostat temperature at which the capillary ELISA experiment is held during the experiment.",
			Category -> "Operating Limits"
		}

	}
}];
