(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, PlateReader], {
	Description->"The model for an instrument used to read fluorescence, AlphaScreen, absorbance, or luminescence data from well-plates.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		PlateReaderMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlateReaderModeP,
			Description -> "The type of data that can be collected by the plate reader.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AbsorbanceDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the absorbance.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AbsorbanceFilterTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The types of wavelength selection available for absorbance measurement.",
			Category -> "Instrument Specifications"
		},
		ExcitationSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ExcitationSourceP,
			Description -> "The light sources available to excite and probe the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ExcitationFilterTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The types of wavelength selection available for the excitation.",
			Category -> "Instrument Specifications"
		},
		EmissionFilterTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The types of wavelength selection available for the emission paths.",
			Category -> "Instrument Specifications"
		},
		EmissionDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the emissions from the sample.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LuminescenceDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {OpticalDetectorP..},
			Description -> "The type of wavelength selection available for luminescence measurement.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LuminescenceFilterTypes-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The types of wavelength selection available for luminescence measurement.",
			Category -> "Instrument Specifications"
		},
		PolarizationExcitationSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ExcitationSourceP,
			Description -> "The light source available to excite and probe the sample with polarized light.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ExcitationPolarizers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> OpticalPolarizationP,
			Description -> "List of the possible optical polarizations to use on the excitation source for polarized light.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		PolarizationExcitationFilterTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the excitation.",
			Category -> "Instrument Specifications"
		},
		PolarizationEmissionFilterTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The types of wavelength selection available for the emission paths.",
			Category -> "Instrument Specifications"
		},
		EmissionPolarizers -> {
			Format -> Multiple,
			Class -> {Expression,Expression},
			Pattern :> {OpticalPolarizationP, OpticalPolarizationP},
			Description -> "List of the possible optical polarizations to use on the emission path source for polarized light.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers -> {"Primary Emission Polarization", "Secondary Emission Polarization"}
		},
		PolarizationEmissionDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the light after the polarization and emission filters.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		OpticModules -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part], (*add parts for AlphaScreen*)
			Description -> "A list of optic modules compatible with this model of plate reader.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SamplingPatterns->{
			Format->Single,
			Class->{
				AbsorbanceIntensity->Expression,
				AbsorbanceKinetics->Expression,
				AbsorbanceSpectroscopy->Expression,
				FluorescenceIntensity->Expression,
				FluorescenceKinetics->Expression,
				FluorescenceSpectroscopy->Expression,
				FluorescencePolarization->Expression,
				FluorescencePolarizationKinetics->Expression,
				TimeResolvedFluorescence->Expression,
				TimeResolvedFluorescenceKinetics->Expression,
				LuminescenceIntensity->Expression,
				LuminescenceKinetics->Expression,
				LuminescenceSpectroscopy->Expression
			},
			Pattern:>{
				AbsorbanceIntensity->{PlateReaderSamplingP...},
				AbsorbanceKinetics->{PlateReaderSamplingP...},
				AbsorbanceSpectroscopy->{PlateReaderSamplingP...},
				FluorescenceIntensity->{PlateReaderSamplingP...},
				FluorescenceKinetics->{PlateReaderSamplingP...},
				FluorescenceSpectroscopy->{PlateReaderSamplingP...},
				FluorescencePolarization->{PlateReaderSamplingP...},
				FluorescencePolarizationKinetics->{PlateReaderSamplingP...},
				TimeResolvedFluorescence->{PlateReaderSamplingP...},
				TimeResolvedFluorescenceKinetics->{PlateReaderSamplingP...},
				LuminescenceIntensity->{PlateReaderSamplingP...},
				LuminescenceKinetics->{PlateReaderSamplingP...},
				LuminescenceSpectroscopy->{PlateReaderSamplingP...}
			},
			Description->"Indicates the type of sampling each plate reader mode can perform.",
			Category->"Instrument Specifications"
		},
		AvailableGases -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[CarbonDioxide,Oxygen],
			Description -> "The gases whose levels can be controlled in the atmosphere inside the plate reader.",
			Category -> "Instrument Specifications"
		},

		MinOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "Minimum level of oxygen in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MaxOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "Maximum level of oxygen in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MinCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "Minimum level of carbon dioxide in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MaxCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "Maximum level of carbon dioxide in the atmosphere inside the plate reader that can be maintained.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the plate reader can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the plate reader can incubate.",
			Category -> "Operating Limits"
		},
		InjectorVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the injector used to add liquid to the plate.",
			Category -> "Operating Limits"
		},
		InjectorDeadVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the tube between the injector syringe and the injector nozzle. This volume is required to fill the injector tube and cannot be injected into wells.",
			Category -> "Operating Limits"
		},
		MaxDispensingSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "Maximum speed reagent can be delivered to the read wells.",
			Category -> "Operating Limits"
		},
		MinAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength at which the instrument can take absorbance readings.",
			Category -> "Operating Limits"
		},
		MaxAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength at which the instrument can take absorbance readings.",
			Category -> "Operating Limits"
		},
		AbsorbanceWavelengthResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The resolution available in selecting the absorbance wavelength to measure.",
			Category -> "Operating Limits"
		},
		LinearAbsorbanceRange -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterEqualP[0*AbsorbanceUnit], GreaterEqualP[0*AbsorbanceUnit]},
			Units -> {AbsorbanceUnit,AbsorbanceUnit},
			Description -> "The reliable linear 10 mm-equivalent absorbance range of this model of instrument.",
			Headers -> {"MinAbsorbance","MaxAbsorbance"},
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength at which the instrument can excite the sample.",
			Category -> "Operating Limits"
		},
		MaxExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength at which the instrument can excite the sample.",
			Category -> "Operating Limits"
		},
		ExcitationFilters -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "List of the possible optical filters to use on the excitation source. Output is in the form: {wavelength,..}.",
			Category -> "Operating Limits"
		},
		ExcitationWavelengthResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The resolution available in selecting the excitation wavelength, if is tunable.",
			Category -> "Operating Limits"
		},
		MinEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength at which the instrument can take emission readings.",
			Category -> "Operating Limits"
		},
		MaxEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength at which the instrument can take emission readings.",
			Category -> "Operating Limits"
		},
		EmissionFilters -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter] | Null},
			Description -> "List of the possible optical filters to use on the emission path. Output is in the form: {primary emission wavelength,secondary emission wavelength}.",
			Category -> "Operating Limits"
		},
		EmissionWavelengthResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The resolution available in selecting the emission wavelength to measure.",
			Category -> "Operating Limits"
		},
		AlphaScreenExcitationLaserWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "The laser used as the excitation source for AlphaScreen.",
			Category -> "Operating Limits"
		},
		AlphaScreenEmissionFilter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units-> Nanometer,
			Description -> "The optical filter used on the emission path for AlphaScreen.",
			Category -> "Operating Limits"
		},
		MinLuminescenceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength at which the instrument can take luminescence readings.",
			Category -> "Operating Limits"
		},
		MaxLuminescenceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength at which the instrument can take luminescence readings.",
			Category -> "Operating Limits"
		},
		PolarizationExcitationFilters -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "List of the possible optical filters to use on the excitation source for polarized light. Output is in the form: {wavelength,..}.",
			Category -> "Operating Limits"
		},
		PolarizationEmissionFilters -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter] | Null},
			Description -> "List of the possible optical filters to use on the polarized light path. Output is in the form: {primary polarized emission wavelength,secondary polarized emission wavelength}.",
			Category -> "Operating Limits"
		},
		MinPolarizationEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength at which the instrument can take polarized light readings.",
			Category -> "Operating Limits"
		},
		MaxPolarizationEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength at which the instrument can take polarized light readings.",
			Category -> "Operating Limits"
		},
		CompatiblePlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "Plates that can be placed on the measurement tray of this model of instrument.",
			Category -> "Compatibility"
		},
		MaxOpticModules->{
	    	Format -> Single,
	    	Class -> Integer,
	    	Pattern:> GreaterEqualP[0,1],
			Units -> None,
	    	Description-> "The maximum number of optic modules that can be installed in this model of instrument.",
	    	Category -> "Operating Limits"
	    },
	    MaxFilters->{
	    	Format -> Single,
	    	Class -> Integer,
	    	Pattern:> GreaterEqualP[0,1],
			Units -> None,
	      	Description-> "The maximum number of fluorescence filters that can be installed in this model of instrument.",
	    	Category -> "Operating Limits"
	    },
		MinAbsorbance->{
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterEqualP[0],
			Units -> AbsorbanceUnit,
			Description-> "The minimum 10 mm-equivalent absorbance that this model instrument can read within a manufacturer reported linear range.",
			Category -> "Operating Limits"
		},
		MaxAbsorbance->{
			Format -> Single,
			Class -> Real,
			Pattern:> GreaterEqualP[0],
			Units -> AbsorbanceUnit,
			Description-> "The maximum 10 mm-equivalent absorbance that this model instrument can read within a manufacturer reported linear range.",
			Category -> "Operating Limits"
		},
		MaxFluorescence-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 RFU],
			Units -> RFU,
			Description -> "The maximum relative fluorescence value which this instrument is detector capable of recording (any signal stronger then this simply maxes out by recording this value).",
			Category -> "Operating Limits"
		}
	}
}];
