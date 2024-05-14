

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, OpticModule], {
	Description->"An optic module used in a plate reader instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		SchematicFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],SchematicFile]],
			Pattern :> ImageFileP,
			Description -> "Image showing the layout of the optic module, including optical path, mirrors and filters.",
			Category -> "Optical Information"
		},
		ExcitationFilterWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ExcitationFilterWavelength]],
			Pattern :> GreaterP[0*Meter*Nano, 1*Nano*Meter],
			Description -> "Wavelength of excitation light after passing through excitation filter.",
			Category -> "Optical Information"
		},
		ExcitationLaserWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ExcitationLaserWavelength]],
			Pattern :> GreaterP[0*Meter*Nano, 1*Nano*Meter],
			Description -> "Wavelength of excitation light determined by a laser.",
			Category -> "Optical Information"
		},
		ExcitationFilterBandwidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ExcitationFilterBandwidth]],
			Pattern :> GreaterP[0*Meter*Nano, 1*Nano*Meter],
			Description -> "The range of wavelengths centered around the excitation filter wavelength that the filter will allow to pass through. For e.g. if the bandwidth is 10nm and the excitation filter wavelength is 260nm, the allowed wavelengths will range from 255nm - 265nm.",
			Category -> "Optical Information"
		},
		EmissionFilterWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],EmissionFilterWavelength]],
			Pattern :> GreaterP[0*Meter*Nano, 1*Nano*Meter],
			Description -> "Wavelength of emitted light after passing through emission filter, on the way to primary detector.",
			Category -> "Optical Information"
		},
		EmissionFilterBandwidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],EmissionFilterBandwidth]],
			Pattern :> GreaterP[0*Meter*Nano, 1*Nano*Meter],
			Description -> "The range of wavelengths centered around the primary emission filter wavelength that the filter will allow to pass through. For e.g. if the bandwidth is 10nm and the emission filter wavelength is 260nm, the allowed wavelengths will range from 255nm - 265nm.",
			Category -> "Optical Information"
		},
		SecondaryEmissionFilterWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],SecondaryEmissionFilterWavelength]],
			Pattern :> GreaterP[0*Meter*Nano, 1*Nano*Meter],
			Description -> "Wavelength of emitted light after passing through emission filter, on the way to secondary detector.",
			Category -> "Optical Information"
		},
		SecondaryEmissionFilterBandwidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],SecondaryEmissionFilterBandwidth]],
			Pattern :> GreaterP[0*Meter*Nano, 1*Nano*Meter],
			Description -> "The range of wavelengths centered around the secondary emission filter wavelength that the filter will allow to pass through. For e.g. if the bandwidth is 10nm and the emission filter wavelength is 260nm, the allowed wavelengths will range from 255nm - 265nm.",
			Category -> "Optical Information"
		},
		ExcitationPolarizer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ExcitationPolarizer]],
			Pattern :> OpticalPolarizationP,
			Description -> "The direction of polarization of light after polarization of excitation input, on the way to sample.",
			Category -> "Optical Information"
		},
		EmissionPolarizer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],EmissionPolarizer]],
			Pattern :> OpticalPolarizationP,
			Description -> "The direction of polarization of light after polarization of emission, on the way to primary detector.",
			Category -> "Optical Information"
		},
		SecondaryEmissionPolarizer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],SecondaryEmissionPolarizer]],
			Pattern :> OpticalPolarizationP,
			Description -> "The direction of polarization of light after polarization of emission, on the way to secondary detector.",
			Category -> "Optical Information"
		}
	}
}];
