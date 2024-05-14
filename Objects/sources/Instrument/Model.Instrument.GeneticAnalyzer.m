(* ::Package:: *)

DefineObjectType[Model[Instrument, GeneticAnalyzer], {
	Description->"Model of a device for determining the nucleotide sequence of a DNA sample by running capillary electrophoresis of fluorescent dideoxynucleotide terminated DNA samples using cartridges.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MinCapillaryTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The minimum temperature that the capillary array can reach during an experiment.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxCapillaryTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The maximum temperature that the capillary array can reach during an experiment.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The minimum voltage that can be applied to the capillary array during priming, injection, or running the experiment.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The maximum voltage that can be applied to the capillary array during priming, injection, or running the experiment.",
			Category -> "Operating Limits",
			Abstract -> True
		}
		(*Detectors -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DetectorTypeP,
			Description -> "Type of detector that the genetic analyzer uses to excite the dyes.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LampType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "Type of illumination that the genetic analyzer uses to excite the dyes.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		EmissionFilters -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter]},
			Units -> {Meter Nano, Meter Nano},
			Headers -> {"Center Wavelength","Bandwidth"},
			Description -> "Fluorescent emission filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		ExcitationFilters -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter]},
			Units -> {Meter Nano, Meter Nano},
			Headers -> {"Center Wavelength","Bandwidth"},
			Description -> "Fluorescent excitation filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Category -> "Operating Limits",
			Abstract -> True
		}*)
	}	
}
];
