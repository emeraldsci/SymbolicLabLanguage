(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, OpticModule], {
	Description->"Model information for an optic module used in a plate reader instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		SchematicFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file showing the layout of the optic module, including optical path, mirrors and filters.",
			Category -> "Optical Information"
		},
		ExcitationFilterWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Wavelength of excitation light after passing through excitation filter.",
			Category -> "Optical Information"
		},
		ExcitationLaserWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Wavelength of excitation light determined by a laser.",
			Category -> "Optical Information"
		},
		ExcitationFilterBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The range of wavelengths centered around the excitation filter wavelength that the filter will allow to pass through. For e.g. if the bandwidth is 10nm and the excitation filter wavelength is 260nm, the allowed wavelengths will range from 255nm - 265nm.",
			Category -> "Optical Information"
		},
		EmissionFilterWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Wavelength of emitted light after passing through emission filter, on the way to primary detector.",
			Category -> "Optical Information"
		},
		EmissionFilterBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The range of wavelengths centered around the primary emission filter wavelength that the filter will allow to pass through. For e.g. if the bandwidth is 10nm and the emission filter wavelength is 260nm, the allowed wavelengths will range from 255nm - 265nm.",
			Category -> "Optical Information"
		},
		SecondaryEmissionFilterWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "Wavelength of emitted light after passing through emission filter, on the way to secondary detector.",
			Category -> "Optical Information"
		},
		SecondaryEmissionFilterBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The range of wavelengths centered around the secondary emission filter wavelength that the filter will allow to pass through. For e.g. if the bandwidth is 10nm and the emission filter wavelength is 260nm, the allowed wavelengths will range from 255nm - 265nm.",
			Category -> "Optical Information"
		},
		ExcitationPolarizer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalPolarizationP,
			Description -> "The direction of polarization of light after polarization of excitation input, on the way to sample.",
			Category -> "Optical Information"
		},
		EmissionPolarizer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalPolarizationP,
			Description -> "The direction of polarization of light after polarization of emission, on the way to primary detector.",
			Category -> "Optical Information"
		},
		SecondaryEmissionPolarizer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalPolarizationP,
			Description -> "The direction of polarization of light after polarization of emission, on the way to secondary detector.",
			Category -> "Optical Information"
		},

		CompatibleInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The instrument this optic module is compatible with.",
			Category -> "Organizational Information"
		}
	}
}];
