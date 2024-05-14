(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,OpticalFilter],{
	Description->"Model information for an optical filter used to selectively transmit or block light.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* Bandpass filters: allow light to pass through a specified range
				Longpass: transmits wavelengths longer than specified cutoff wavelength
				Shortpass: transmits wavelengths shorter than specified cutoff wavelength
				Notch: block a preselected bandwidth and transmit all other wavelengths
				Dichroic: reflect and transmit different percentages across a given spectrum
				NeutralDensity: reduce transmission evenly across a portion of a spectrum
		*)
		BandpassFilterType->{
			Format->Single,
			Class->Expression,
			Pattern:>BandpassFilterTypeP,
			Description->"The cateogory of filter based on the transmittance properties.",
			Category->"Optical Information"
		},
		(* For neutral density filters that reduce light transmission (e.g. those on the Nikon microscope) *)
		NeutralDensityFilterTransmittance->{
			Format->Single,
			Class->Real,
			Pattern:>PercentP,
			Description->"The percent of light that is allowed through a NeutralDensityFilter.",
			Category->"Optical Information"
		},
		(* For shortpass or longpass filters *)
		SingleEdge->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the sample has one cut-on or cut-off point delineating the transmitted and absorbed/reflected light.",
			Category->"Optical Information"
		},
		SingleEdgeOpticalSpecification->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer,1 Nanometer],
			Units->Nanometer,
			Description->"The wavelength corresponding to the sharp transmittance cut-on or cut-off.",
			Category->"Optical Information"
		},
		MultiEdgeOpticalSpecifications->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 Nanometer,1 Nanometer],GreaterP[0 Nanometer,1 Nanometer]},
			Description->"The list of transmission wavelengths and bandwidths for multi-edge filters, given as a paired list of {CenterWavelength, Bandwidth}.",
			Category->"Optical Information",
			Headers->{"Center Wavelength","Bandwidth"}
		}
	}
}];
