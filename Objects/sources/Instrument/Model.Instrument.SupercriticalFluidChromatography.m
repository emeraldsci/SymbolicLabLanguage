(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, SupercriticalFluidChromatography], {
	Description->"The model for an instrument that uses supercritical CO2 and sometimes organic cosolvents in order to separate mixtures of compounds.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Instrument Specifications ---*)
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "A list of the measurement modules on the instrument; for example, PhotoDiodeArray will measure the absorption of light at varying wavelengths.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PurificationScaleP,
			Description -> "Indicates if the instrument is intended to separate material (Preparative) and therefore collect fractions and/or analyze properties of the material (Analytical).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AutosamplerDeckModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Deck],
			Description -> "The model of container used to house samples.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		BufferDeckModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Deck],
			Description -> "The model of container used to house buffers.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		MassAnalyzer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassAnalyzerTypeP,
			Description -> "The type of the component of the mass spectrometer that performs ion separation based on mass-to-charge (m/z) ratio. SingleQuadrupole selects single ions for detection.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IonSources -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonSourceP,
			Description -> "The type of ionization source used to generate gas phase ions from the molecules in the sample. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "The possible detection modes for ions (in Negative mode, negatively charged ions and in Positive mode, positively charged ions are generated and analyzed).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AcquisitionModes -> { 
			Format -> Multiple,
			Class -> Expression,
			Pattern :> AcquisitionModeP,
			Description -> "The capability of the instrument to measure only intact ions (MS) versus fragments of ions (MS/MS).",
			Category -> "Instrument Specifications"
		},
		NumberOfBuffers -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of different buffers that can be connected to the pump system. Refer to PumpType for the number of solvents that can actually be mixed simultaneously.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		PumpType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> HPLCPumpTypeP,
			Description -> "The number of solvents that can be blended with each other at a ratio during the gradient (e.g. quaternary can mix up to 4 solvents, while ternary can mix 3 and binary can mix 2 solvents). Binary pumps perform high-pressure mixing which is accomplished by two independent pumps and a mixing chamber located after the pumps, leading to increased gradient accuracy. Quaternary and ternary pumps provide low-pressure mixing environments where the mixing happens before the pumps.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		InjectorType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> InjectorTypeP,
			Description -> "The technique by which the sample is injected. The FlowThroughNeedle injector is typically less prone to carryover and only the sample drawn is injected. The inside of the needle is washed with the gradient. In contrast, FixedLoop injectors transport the sample into a sample loop from which it gets sandwiched by air gaps and wash solution and then injected. The interior and the exterior of the needle needs to be washed with solvent to avoid contamination.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ColumnCompartmentType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnCompartmentTypeP (*Serial | Selector*),
			Description -> "The specification of the module housing the columns. Serial indicates a single flow path for column installation (upto 3 joined columns). Selector indicators multiple serial column flow paths that can be programmatically toggled between.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ColumnConnector -> {
			Format -> Multiple,
			Class -> {Expression, String, Expression, Expression, Real, Real},
			Pattern :> {ConnectorP, ThreadP, MaterialP, ConnectorGenderP, GreaterEqualP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {None, None, None, None, Meter Milli, Meter Milli},
			Description -> "The connector on the instrument to which a column will be attached to.",
			Headers -> {"Connector Type", "Thread Type", "Material", "Gender", "Inner Diameter", "Outer Diameter"},
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The diameter of the tubing in the flow path.",
			Category -> "Instrument Specifications"
		},
		FlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the instrument's detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		FlowCellPathLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The pathlength of the instrument's detector flow cell.",
			Category -> "Instrument Specifications"
		},
		DetectorLampType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "A list of sources of illumination available for use in absorbance detection.",
			Category -> "Instrument Specifications"
		},

		(* --- Operating Limits --- *)
		MaxNumberOfColumns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The maximum of columns that can be installed and switched between in the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The lowest value of mass-to-charge ratio (m/z) the instrument can detect.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The highest value of mass-to-charge ratio (m/z) the instrument can detect.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength that the absorbance detector can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The Maximum wavelength that the absorbance detector can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		AbsorbanceResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum increment in wavelength that the absorbance detector can measure.",
			Category -> "Operating Limits"
		},
		MinAcceleration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milliliter/Minute^2],
			Units->Milliliter/Minute^2,
			Description->"The minimum flow rate acceleration at which the pumping speed can be increased for this model of instrument.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		MaxAcceleration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milliliter/Minute^2],
			Units->Milliliter/Minute^2,
			Description->"The maximum flow rate acceleration at which the pumping speed can safely be increased for this model of instrument.",
			Category->"Instrument Specifications"
		},
		MinSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The minimum sample volume required for a single run.",
			Category -> "Operating Limits"
		},
		MaxSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The maximum sample volume that that can be injected in a single run.",
			Category -> "Operating Limits"
		},
		MinSampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum possible temperature of the chamber where the samples are stored.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum possible temperature of the chamber where the samples are stored.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate at which the instrument can pump CO2 and cosolvents through the system.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate at which the instrument can pump CO2 and cosolvents through the system.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinBackPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum pressure before waste outlet -- affects the density of the mobile phase and the flow split to the mass spectrometer.",
			Category -> "Operating Limits"
		},
		MaxBackPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure before waste outlet -- affects the density of the mobile phase and the flow split to the mass spectrometer.",
			Category -> "Operating Limits"
		},
		MinMakeupFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate at which the instrument can pump buffer through the system.",
			Category -> "Operating Limits"
		},
		MaxMakeupFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate at which the instrument can pump buffer through the system absent any pressure limitations.",
			Category -> "Operating Limits"
		},
		MinpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Minimum pH the instrument can operate under.",
			Category -> "Operating Limits"
		},
		MaxpH-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Maximum pH the instrument can operate under.",
			Category -> "Operating Limits"
		},
		MinColumnTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the column oven can incubate.",
			Category -> "Operating Limits"
		},
		MaxColumnTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which the column oven can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxColumnLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum column length that can be accommodated inside of the column oven.",
			Category -> "Operating Limits"
		},
		MaxColumnInternalDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum column internal diameter (I.D.) that can be accommodated inside of the column oven.",
			Category -> "Operating Limits"
		},
		MinFlowPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum pressure at which the instrument can operate.",
			Category -> "Operating Limits"
		},
		MaxFlowPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure at which the instrument can operate.",
			Category -> "Operating Limits"
		},
		MinCO2Pressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum CO2 source pressure supplied into the instrument acceptable for operation.",
			Category -> "Operating Limits"
		},
		MaxCO2Pressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The maximum CO2 source pressure supplied into the instrument acceptable for operation.",
			Category -> "Operating Limits"
		},
		MinSpectrometerSamplingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*1/Second],
			Units -> 1/Second,
			Description -> "Minimum frequency that the mass spectrometer can measure for each selected ion.",
			Category -> "Operating Limits"
		},
		MaxSpectrometerSamplingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*1/Second],
			Units -> 1/Second,
			Description -> "Maximum frequency that the mass spectrometer can measure for each selected ion.",
			Category -> "Operating Limits"
		},
		TubingMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure the tubing in the sample flow path can tolerate.",
			Category -> "Operating Limits"
		},
		PumpMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure at which the pump can still operate.",
			Category -> "Operating Limits"
		},
		(* ESI MS parameters *)
		MinESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Minimum voltage that can be applied to the stainless steel capillary from which the ion spray is generated.",
			Category -> "Operating Limits"
		},
		MaxESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "Maximum voltage that can be applied to the stainless steel capillary from which the ion spray is generated.",
			Category -> "Operating Limits"
		},
		MinSamplingConeVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Volt,
			Description -> "Minimum voltage that can be applied as voltage offset between the 1st and 2nd stage of the ion guide.",
			Category -> "Operating Limits"
		},
		MaxSamplingConeVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "Maximum voltage that can be applied as voltage offset between the 1st and 2nd stage of the ion guide.",
			Category -> "Operating Limits"
		},
		MinSourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The minimum temperature setting for the source block (the reduced pressure chamber holding the sample cone through which the ions travel on their way to the mass analyzer).",
			Category -> "Operating Limits"
		},
		MaxSourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The maximum temperature setting for the source block (the reduced pressure chamber holding the sample cone through which the ions travel on their way to the mass analyzer).",
			Category -> "Operating Limits"
		},
		MinDesolvationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The minimum temperature setting for the source desolvation heater that controls the nitrogen gas temperature used for solvent cluster evaporation before ions enter the mass spectrometer through the sampling cone.",
			Category -> "Operating Limits"
		},
		MaxDesolvationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The maximum temperature setting for the source desolvation heater that controls the nitrogen gas temperature used for solvent cluster evaporation before ions enter the mass spectrometer through the sampling cone.",
			Category -> "Operating Limits"
		},
		FlowCellMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure the detector's flow cell can tolerate.",
			Category -> "Operating Limits"
		}

	}
}];
