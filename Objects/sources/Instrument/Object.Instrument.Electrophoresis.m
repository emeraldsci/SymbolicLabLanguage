

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Electrophoresis], {
	Description->"A device for separating nucleic acids or proteins based on their charge and size.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		ExcitationFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ExcitationFilters]],
			Pattern :> {{GreaterP[0], GreaterP[0]}..},
			Description -> "Fluorescent excitation filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		EmissionFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],EmissionFilters]],
			Pattern :> {{GreaterP[0], GreaterP[0]}..},
			Description -> "Fluorescent emission filters available to the instrument. The first distance in the list is the Center Wavelength which is the midpoint between the wavelengths where transmittance is 50% (also defined as the Full Width at Half Maximum (FWHM))) of the filter. The second distance in the list is the bandwidth or FWHM of the filter.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "The minimum volume that the liquid handler can transfer accurately.",
			Category -> "Operating Limits"
		},
		MaxVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "The maximum volume that the liquid handler can transfer.",
			Category -> "Operating Limits"
		},
		MinVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinVoltage]],
			Pattern :> _?VoltageQ,
			Description -> "The minimum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		},
		MaxVoltage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVoltage]],
			Pattern :> GreaterP[0*Volt],
			Description -> "The maximum voltage that can be applied during sample separation.",
			Category -> "Operating Limits"
		},
		Capacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Capacity]],
			Pattern :> GreaterP[0, 1],
			Description -> "The number of electrophoresis cartridges that fit on the instrument.",
			Category -> "Operating Limits"
		},
		AspirationVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The vessel used to collect liquid waste as it is aspirated off the gels during cleanup of this instrument.",
			Category -> "Cleaning",
			Developer -> True
		}
	}
}];
