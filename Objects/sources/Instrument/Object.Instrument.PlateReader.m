(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, PlateReader], {
	Description->"Optical readers of Absorbance, fluorescence, AlphaScreen, and luminescence in multi-well plates.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		OpticModules -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Object]}, Computables`Private`getOpticModules[Field[Object]]],
			Pattern :> {ObjectReferenceP[Object[Part, OpticModule]]...},
			Description -> "Optic modules (containing filters, dichroic mirrors, beam splitters and/or polarization film) installed on this instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		PlateReaderMode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PlateReaderMode]],
			Pattern :> {PlateReaderModeP..},
			Description -> "The type of data that can be collected by the plate reader.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AbsorbanceDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AbsorbanceDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the absorbance.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AbsorbanceFilterTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AbsorbanceFilterTypes]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for absorbance measurement.",
			Category -> "Instrument Specifications"
		},
		ExcitationSource -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationSource]],
			Pattern :> {ExcitationSourceP..},
			Description -> "The light sources available to excite and probe the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ExcitationFilterTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationFilterTypes]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the excitation.",
			Category -> "Instrument Specifications"
		},
		EmissionFilterTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionFilterTypes]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the emission paths.",
			Category -> "Instrument Specifications"
		},
		EmissionDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the emissions from the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LuminescenceDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LuminescenceDetector]],
			Pattern :> {OpticalDetectorP..},
			Description -> "The type of detector(s) available to measure the luminescence.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LuminescenceFilterTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LuminescenceFilterTypes]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for luminescence measurement.",
			Category -> "Instrument Specifications"
		},
		PolarizationExcitationSource -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PolarizationExcitationSource]],
			Pattern :> {ExcitationSourceP...},
			Description -> "The light source available to excite and probe the sample with polarized light.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ExcitationPolarizers -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationPolarizers]],
			Pattern :> {OpticalPolarizationP...},
			Description -> "List of the possible optical polarizations to use on the excitation source based on the available optics modules for polarized light.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		PolarizationExcitationFilterTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PolarizationExcitationFilterTypes]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the excitation.",
			Category -> "Instrument Specifications"
		},
		PolarizationEmissionFilterTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PolarizationEmissionFilterTypes]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the emission paths.",
			Category -> "Instrument Specifications"
		},
		EmissionPolarizers -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionPolarizers]],
			Pattern :> {{OpticalPolarizationP, OpticalPolarizationP}..},
			Description -> "List of the possible optical polarizations to use on the emission path source based on the available optics modules for polarized light.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers -> {"Primary Emission Polarization", "Secondary Emission Polarization"}
		},
		PolarizationEmissionDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PolarizationEmissionDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the light after the polarization and emission filters.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AvailableGases -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AvailableGases]],
			Pattern :> Alternatives[CarbonDioxide,Oxygen],
			Description -> "The gases whose levels can be controlled in the atmosphere inside the plate reader.",
			Category -> "Instrument Specifications"
		},

		MinOxygenLevel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinOxygenLevel]],
			Pattern :> GreaterP[0*Percent],
			Description -> "Minimum level of oxygen in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MaxOxygenLevel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxOxygenLevel]],
			Pattern :> GreaterP[0*Percent],
			Description -> "Maximum level of oxygen in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MinCarbonDioxideLevel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinCarbonDioxideLevel]],
			Pattern :> GreaterP[0*Percent],
			Description -> "Minimum level of carbon dioxide in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MaxCarbonDioxideLevel -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxCarbonDioxideLevel]],
			Pattern :> GreaterP[0*Percent],
			Description -> "Maximum level of carbon dioxide in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the plate reader can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the plate reader can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InjectorVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InjectorVolume]],
			Pattern :> GreaterEqualP[0*Liter],
			Description -> "The volume of the injector used to add liquid to the plate.",
			Category -> "Operating Limits"
		},
		InjectorDeadVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InjectorDeadVolume]],
			Pattern :> GreaterEqualP[0*Liter],
			Description -> "The volume of the tube between the injector syringe and the injector nozzle. This volume is required to fill the injector tube and cannot be injected into wells.",
			Category -> "Operating Limits"
		},
		MaxDispensingSpeed -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDispensingSpeed]],
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Description -> "Maximum speed reagent can be delivered to the read wells.",
			Category -> "Operating Limits"
		},
		MinAbsorbanceWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinAbsorbanceWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum wavelength at which the instrument can take absorbance readings.",
			Category -> "Operating Limits"
		},
		MaxAbsorbanceWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxAbsorbanceWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The maximum wavelength at which the instrument can take absorbance readings.",
			Category -> "Operating Limits"
		},
		AbsorbanceWavelengthResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AbsorbanceWavelengthResolution]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The resolution available in selecting the absorbance wavelength to measure.",
			Category -> "Operating Limits"
		},
		MinExcitationWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinExcitationWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum wavelength at which the instrument can excite the sample.",
			Category -> "Operating Limits"
		},
		MaxExcitationWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxExcitationWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The maximum wavelength at which the instrument can excite the sample.",
			Category -> "Operating Limits"
		},
		ExcitationFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationFilters]],
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter]..},
			Description -> "List of the possible optical filters to use on the excitation source.",
			Category -> "Operating Limits"
		},
		ExcitationWavelengthResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationWavelengthResolution]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The resolution available in selecting the excitation wavelength, if is tunable.",
			Category -> "Operating Limits"
		},
		MinEmissionWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinEmissionWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum wavelength at which the instrument can take emission readings.",
			Category -> "Operating Limits"
		},
		MaxEmissionWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxEmissionWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The maximum wavelength at which the instrument can take emission readings.",
			Category -> "Operating Limits"
		},
		EmissionFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionFilters]],
			Pattern :> {{GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter] | Null}..},
			Description -> "List of the possible optical filters to use on the emission path.",
			Category -> "Operating Limits",
			Headers -> {"Primary Emission Wavelength", "Secondary Emission Wavelength"}
		},
		EmissionWavelengthResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionWavelengthResolution]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The resolution available in selecting the emission wavelength to measure.",
			Category -> "Operating Limits"
		},
		AlphaScreenExcitationLaserWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AlphaScreenExcitationLaserWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The laser used as the excitation source for AlphaScreen.",
			Category -> "Operating Limits"
		},
		AlphaScreenEmissionFilter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AlphaScreenEmissionFilter]],
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter] | Null},
			Description -> "The optical filter used on the emission path for AlphaScreen.",
			Category -> "Operating Limits"
		},
		MinLuminescenceWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinLuminescenceWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum wavelength at which the instrument can take luminescence readings.",
			Category -> "Operating Limits"
		},
		MaxLuminescenceWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxLuminescenceWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The maximum wavelength at which the instrument can take luminescence readings.",
			Category -> "Operating Limits"
		},
		PolarizationExcitationFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PolarizationExcitationFilters]],
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter]..},
			Description -> "List of the possible optical filters to use on the excitation source for polarized light.",
			Category -> "Operating Limits"
		},
		PolarizationEmissionFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PolarizationEmissionFilters]],
			Pattern :> {{GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter] | Null}..},
			Description -> "List of the possible optical filters to use on the polarized light path.",
			Category -> "Operating Limits",
			Headers -> {"Primary Polarized Emission Wavelength", "Secondary Polarized Emission Wavelength"}
		},
		MinPolarizationEmissionWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinPolarizationEmissionWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum wavelength at which the instrument can take polarized light readings.",
			Category -> "Operating Limits"
		},
		MaxPolarizationEmissionWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxPolarizationEmissionWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The maximum wavelength at which the instrument can take polarized light readings.",
			Category -> "Operating Limits"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedPlateReader],
			Description -> "The liquid handler that is connected to this plate reader such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		SecondaryWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "An additional container associated with the instrument used to collect any liquid waste produced by the instrument during operation.",
			Category -> "Instrument Specifications"
		},
		LampFlashCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times the integrated ExcitationSource lamp has been used.",
			Category -> "Optical Information"
		}
	}
}];
