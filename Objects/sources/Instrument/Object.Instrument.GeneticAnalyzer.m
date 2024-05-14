(* ::Package:: *)

DefineObjectType[Object[Instrument, GeneticAnalyzer], {
	Description->"Device for determining the nucleotide sequence of a DNA sample based on Sanger sequencing techniques.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MaxCapillaryTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxCapillaryTemperature]],
			Pattern :> GreaterP[0*Celsius],
			Description -> "The maximum temperature that the capillary array can reach during an experiment.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinCapillaryTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinCapillaryTemperature]],
			Pattern :> GreaterP[0*Celsius],
			Description -> "The minimum temperature that the capillary array can reach during an experiment.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxVoltage]],
			Pattern :> GreaterP[0*Volt],
			Description -> "The maximum voltage that can be applied to the capillary array during priming, injection, or running the experiment.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinVoltage]],
			Pattern :> GreaterP[0*Volt],
			Description -> "The minimum voltage that can be applied to the capillary array during injection or running the experiment.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InstrumentPIN -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The PIN to unlock the touch screen of the SeqStudio instrument.",
			Category -> "Organizational Information",
			Abstract->False,
			Developer->True
		}
		(*LampType -> {
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
}];
