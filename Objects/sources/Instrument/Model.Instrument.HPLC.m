(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, HPLC], {
	Description->"The model for a high performance liquid chromatography instrument used to separate mixtures of compounds.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Instrument Specifications ---*)
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "A list of the available detectors on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		FractionCollectionDetectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "The detectors of the instrument for which the detector hardware can communicate with the fraction collection.",
			Category -> "Instrument Specifications"
		},
		Scale -> {
			Format -> Multiple,
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
			Pattern :> ColumnCompartmentTypeP,
			Description -> "The specification of the module housing the columns. Serial indicates a single flow path for column installation (upto 3 joined columns). Selector indicators multiple serial column flow paths that can be programmatically toggled between.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ColumnPositions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ColumnPositionP,
			Description -> "The list of positions for the columns in the column compartment of the HPLC instrument connected to a valve drive. The flow path can be switched to any of these positions from within the software. Instruments with no column selector have this field as Null.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DetectorLampType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "A list of sources of illumination available for use in detection.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the absorbance.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceFilterType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for absorbance measurement.",
			Category -> "Instrument Specifications"
		},
		ExcitationSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ExcitationSourceP,
			Description -> "The light source available to excite and probe the sample in the fluorescence detector.",
			Category -> "Instrument Specifications"
		},
		ExcitationFilterType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the excitation in the fluorescence detector.",
			Category -> "Instrument Specifications"
		},
		EmissionFilterType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the emission path in the fluorescence detector.",
			Category -> "Instrument Specifications"
		},
		EmissionCutOffFilters -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0*Nanometer],
			Units -> Nanometer,
			Description -> "The cut-off filter(s) available in the fluorescence detector to pre-select the emitted light and allow the light with wavelength above the specified value to pass before the light emission monochromator for final wavelength selection.",
			Category -> "Instrument Specifications"
		},
		EmissionDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the emissions from the sample in the fluorescence detector.",
			Category -> "Instrument Specifications"
		},
		LightScatteringSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ExcitationSourceP,
			Description -> "The light source available to illuminate the sample in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector.",
			Category -> "Instrument Specifications"
		},
		LightScatteringWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The laser wavelength of the LightScatteringSource in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector.",
			Category -> "Instrument Specifications"
		},
		MALSDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of Multi-Angle static Light Scattering light detector available to measure the scattered light intensity in the Multi-Angle static Light Scattering (MALS) detector.",
			Category -> "Instrument Specifications"
		},
		MALSDetectorAngles -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0AngularDegree],
			Units -> AngularDegree,
			Description -> "The angles with regards to the incident light beam at which the MALS detection photodiodes are mounted around the flow cell inside the Multi-Angle static Light Scattering (MALS) detector.",
			Category -> "Instrument Specifications"
		},
		DLSDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of Dynamic Light Scattering (DLS) light detector available to measure the scattered light fluctuation in the Multi-Angle static Light Scattering (MALS) detector.",
			Category -> "Instrument Specifications"
		},
		DLSDetectorAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0AngularDegree],
			Units -> AngularDegree,
			Description -> "The angle with regards to the incident light beam at which the DLS detection photodiode is located inside the Multi-Angle static Light Scattering (MALS) detector.",
			Category -> "Instrument Specifications"
		},
		RefractiveIndexSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ExcitationSourceP,
			Description -> "The light source used to traverse the sample and measure its refractive index in the refractive index (RI) detector.",
			Category -> "Instrument Specifications"
		},
		RefractiveIndexWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of the light used to traverse the sample and measure its refractive index in the refractive index (RI) detector.",
			Category -> "Instrument Specifications"
		},
		RefractiveIndexDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector to detect the refracted light in the refractive index (RI) detector for the determination of the refractive index of the sample.",
			Category -> "Instrument Specifications"
		},
		CircularDichroismSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ExcitationSourceP,
			Description -> "The light source used for the circular dichroism (CD) measurement in the CD detector of the instrument.",
			Category -> "Instrument Specifications"
		},
		CircularDichroismWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of the light source of the circular dichroism (CD) detector.",
			Category -> "Instrument Specifications"
		},
		Mixer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographyMixerTypeP,
			Description -> "The type of mixer the pump uses to generate the gradient.",
			Category -> "Instrument Specifications"
		},
		SampleLoop -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The maximum volume of sample that can be put in the injection loop, before it is transferred into the flow path.",
			Category -> "Instrument Specifications"
		},
		BufferLoop -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of tubing between the syringe and the injection valve that is used to provide system fluid to the autosampler syringe.",
			Category -> "Instrument Specifications"
		},
		DelayVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The tubing volume between the detector and the fraction collector head.",
			Category -> "Instrument Specifications"
		},
		DelayLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Centi*Meter],
			Units -> Centi Meter,
			Description -> "The length of tubing between the detector and the fraction collector.",
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
		FluorescenceFlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the instrument's fluorescence detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		LightScatteringFlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the instrument's Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		RefractiveIndexFlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the instrument's refractive index (RI) detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		CircularDichroismFlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the instrument's circular dichroism (CD) detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		pHFlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the instrument's pH detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		ConductivityFlowCellVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the instrument's conductivity detector's flow cell.",
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
		FluorescenceFlowCellPathLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The pathlength of the instrument's fluorescence detector flow cell.",
			Category -> "Instrument Specifications"
		},
		CircularDichroismFlowCellPathLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The pathlength of the instrument's circular dichroism detector flow cell.",
			Category -> "Instrument Specifications"
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
			Category->"Instrument Specifications",
			Abstract->True
		},
		SystemPrimeBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer model used to generate the buffer gradient to purge the instrument lines at the start of an HPLC protocol.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SystemPrimeGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The gradient used to purge the instrument lines at the start of an HPLC protocol.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SystemPrimeGradients -> {
			Format -> Multiple,
			Class -> {Expression,Link},
			Pattern :> {SeparationModeP,_Link},
			Relation -> {Null,Object[Method]},
			Description -> "List of the gradients used to purge the instrument lines at the start of an HPLC protocol for each chromatography type.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers->{"Chromatography Type","Gradient Method"}
		},
		SystemFlushBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer model used to generate the buffer gradient to purge the instrument lines at the end of an HPLC protocol.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SystemFlushGradient->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The gradient used to purge the instrument lines at the end of an HPLC protocol.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SystemFlushGradients -> {
			Format -> Multiple,
			Class -> {Expression,Link},
			Pattern :> {SeparationModeP,_Link},
			Relation -> {Null,Object[Method]},
			Description -> "List of the gradients used to purge the instrument lines at the end of an HPLC protocol for each chromatography type.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers->{"Chromatography Type","Gradient Method"}
		},
		LeakTestFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The flow rate at which the instrument should pump buffer through the system during system prime and flush leak tests.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		WashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The default solution used to wash the injection needle and pumps during HPLC protocols.",
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
		ImportFileTemplates -> {
			Format -> Multiple,
			Class -> {String,Link},
			Pattern :> {_String,_Link},
			Relation -> {Null,Object[EmeraldCloudFile]},
			Description -> "Files used as templates to import protocol methods into the instrument's software.",
			Headers -> {"Filename","Cloud File"},
			Category -> "Instrument Specifications",
			Developer -> True
		},
		ColumnPreheater -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Whether the instrument is equipped with a preheater in the column compartment.",
			Category -> "Instrument Specifications"
		},
		SyringeVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "Volume of the syringe used by the instrument.",
			Category -> "Instrument Specifications"
		},
		(* --- Operating Limits --- *)
		MinSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The minimum sample volume required for a single run.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		RecommendedSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The smallest recommended sample volume required for a single run.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The maximum sample volume that that can be injected in a single run.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinSampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum possible temperature of the chamber where the samples are stored. Null indicates that temperature control for the sample chamber is not possible.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum possible temperature of the chamber where the samples are stored. Null indicates that temperature control for the sample chamber is not possible.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate at which the instrument can pump buffer through the system.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate at which the instrument can pump buffer through the system absent any pressure limitations.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxNumberOfColumns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "If ColumnCompartmentType is Selector, the maximum of columns that can be installed and toggled between in the instrument.",
			Category -> "Operating Limits"
		},
		MinAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength that the absorbance detector can monitor.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The Maximum wavelength that the absorbance detector can monitor.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		AbsorbanceWavelengthBandpass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter, 0.1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The range of wavelengths centered around the desired wavelength that the absorbance detector will measure. For e.g. if the bandpass is 10nm and the desired measurement wavelength is 260nm, the detector will measure wavelengths from 255nm - 265nm.",
			Category -> "Operating Limits"
		},
		MinExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength at which the fluorescence detector can excite the sample.",
			Category -> "Operating Limits"
		},
		MaxExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength at which the fluorescence detector can excite the sample.",
			Category -> "Operating Limits"
		},
		MinEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum wavelength at which the fluorescence detector can take emission readings.",
			Category -> "Operating Limits"
		},
		MaxEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum wavelength at which the fluorescence detector can take emission readings.",
			Category -> "Operating Limits"
		},
		MinColumnTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the column oven can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
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
		MaxColumnOutsideDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum column outside diameter that can be accommodated inside of the column oven.",
			Category -> "Operating Limits"
		},
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum pressure at which the instrument can operate.",
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
		FlowCellMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure the detector's flow cell can tolerate.",
			Category -> "Operating Limits"
		},
		MinFluorescenceFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature that the temperature of the fluorescence flow cell of the instrument's fluorescence detector can be set to.",
			Category -> "Operating Limits"
		},
		MaxFluorescenceFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature that the temperature of the fluorescence flow cell of the instrument's fluorescence detector can be set to.",
			Category -> "Operating Limits"
		},
		MinLightScatteringFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature that the temperature of the flow cell of the instrument's Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector can be set to.",
			Category -> "Operating Limits"
		},
		MaxLightScatteringFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature that the temperature of the flow cell of the instrument's Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector can be set to.",
			Category -> "Operating Limits"
		},
		MinMALSMolecularWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Dalton],
			Units -> Dalton,
			Description -> "The minimum molecular weight of the analyte molecule that the Multi-Angle static Light Scattering (MALS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MaxMALSMolecularWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Dalton],
			Units -> Dalton,
			Description -> "The maximum molecular weight of the analyte molecule that the Multi-Angle static Light Scattering (MALS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MinMALSGyrationRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nanometer],
			Units -> Nanometer,
			Description -> "The minimum radius of gyration of the analyte molecule that the Multi-Angle static Light Scattering (MALS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MaxMALSGyrationRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nanometer],
			Units -> Nanometer,
			Description -> "The minimum radius of gyration of the analyte molecule that the Multi-Angle static Light Scattering (MALS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MinDLSHydrodynamicRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nanometer],
			Units -> Nanometer,
			Description -> "The minimum hydrodynamic radius of the analyte molecule that the Dynamic Light Scattering (DLS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MaxDLSHydrodynamicRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nanometer],
			Units -> Nanometer,
			Description -> "The maximum hydrodynamic radius of the analyte molecule that the Dynamic Light Scattering (DLS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MinRefractiveIndexFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature that the temperature of the flow cell of the instrument's differential refractive index (dRI) detector can be set to.",
			Category -> "Operating Limits"
		},
		MaxRefractiveIndexFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature that the temperature of the flow cell of the instrument's differential refractive index (dRI) detector can be set to.",
			Category -> "Operating Limits"
		},
		MinCiruclarDichrosimFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the Circular Dichroism (CD) flow cell of the instrument's CD detector can operate.",
			Category -> "Operating Limits"
		},
		MaxCiruclarDichrosimFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which the Circular Dichroism (CD) flow cell of the instrument's CD detector can operate.",
			Category -> "Operating Limits"
		},
		MinCiruclarDichrosimWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The minimum light wavelength that the light source of the circular dichroism detector can produce.",
			Category -> "Operating Limits"
		},
		MaxCiruclarDichrosimWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The maximum light wavelength that the light source of the circular dichroism detector can produce.",
			Category -> "Operating Limits"
		},
		MinDetectorpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The minimum pH to which the pH detector of this instrument can measure.",
			Category -> "Operating Limits"
		},
		MaxDetectorpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The maximum pH to which the pH detector of this instrument can measure.",
			Category -> "Operating Limits"
		},
		MinpHFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the pH flow cell of the instrument's pH detector can operate.",
			Category -> "Operating Limits"
		},
		MaxpHFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which the pH flow cell of the instrument's pH detector can operate.",
			Category -> "Operating Limits"
		},
		MinConductivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Siemens/Centimeter],
			Description -> "The minimum conductivity that the conductivity detector of this instrument can measure.",
			Units -> Micro*Siemens/Centimeter,
			Category -> "Operating Limits"
		},
		MaxConductivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Siemens/Centimeter],
			Description -> "The maximum conductivity that the conductivity detector of this instrument can measure.",
			Units -> Micro*Siemens/Centimeter,
			Category -> "Operating Limits"
		},
		MinConductivityFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the conductivity flow cell of the instrument's conductivity detector can operate.",
			Category -> "Operating Limits"
		},
		MaxConductivityFlowCellTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which the conductivity flow cell of the instrument's conductivity detector can operate.",
			Category -> "Operating Limits"
		}
	}
}];
