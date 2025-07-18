(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, HPLC], {
	Description->"A high performance liquid chromatography (HPLC) instrument that separates mixtures of compounds.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(*--- Instrument Specifications ---*)
		NumberOfBuffers -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],NumberOfBuffers]],
			Pattern :> GreaterEqualP[1,1],
			Description -> "The number of different buffers that can be connected to the pump system. Refer to PumpType for the number of solvents that can actually be mixed simultaneously.",
			Category -> "Instrument Specifications"
		},
		PumpType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PumpType]],
			Pattern :> HPLCPumpTypeP,
			Description -> "The number of solvents that can be blended with each other at a ratio during the gradient (e.g. quaternary can mix up to 4 solvents, while ternary can mix 3 and binary can mix 2 solvents). Binary pumps perform high-pressure mixing which is accomplished by two independent pumps and a mixing chamber located after the pumps, leading to increased gradient accuracy. Quaternary and ternary pumps provide low-pressure mixing environments where the mixing happens before the pumps.",
			Category -> "Instrument Specifications"
		},
		InjectorType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InjectorType]],
			Pattern :> InjectorTypeP,
			Description -> "The technique by which the sample is injected. The FlowThroughNeedle injector is typically less prone to carryover and only the sample drawn is injected. The inside of the needle is washed with the gradient. In contrast, FixedLoop injectors transport the sample into a sample loop from which it gets sandwiched by air gaps and wash solution and then injected. The interior and the exterior of the needle needs to be washed with solvent to avoid contamination.",
			Category -> "Instrument Specifications"
		},
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PurificationScaleP,
			Description -> "Sample scale for which the instrument is currently configured.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Detectors -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Detectors]],
			Pattern :> {ChromatographyDetectorTypeP..},
			Description -> "A list of the available detectors on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		FractionCollectionDetectors -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FractionCollectionDetectors]],
			Pattern :> {ChromatographyDetectorTypeP..},
			Description -> "The detectors of the instrument for which the detector hardware can communicate with the fraction collection.",
			Category -> "Instrument Specifications"
		},
		DetectorLampType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DetectorLampType]],
			Pattern :> {LampTypeP..},
			Description -> "A list of sources of illumination available for use in detection.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AbsorbanceDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the absorbance.",
			Category -> "Instrument Specifications"
		},
		AbsorbanceFilterType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AbsorbanceFilterType]],
			Pattern :> WavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for absorbance measurement.",
			Category -> "Instrument Specifications"
		},
		ExcitationSource -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationSource]],
			Pattern :> ExcitationSourceP,
			Description -> "The light source available to excite and probe the sample in the fluorescence detector.",
			Category -> "Instrument Specifications"
		},
		ExcitationFilterType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ExcitationFilterType]],
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the excitation in the fluorescence detector.",
			Category -> "Instrument Specifications"
		},
		EmissionFilterType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionFilterType]],
			Pattern :> PlateReaderWavelengthSelectionTypeP,
			Description -> "The type of wavelength selection available for the emission paths in the fluorescence detector.",
			Category -> "Instrument Specifications"
		},
		EmissionCutOffFilters -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionCutOffFilters]],
			Pattern :> GreaterP[0*Nanometer],
			Description -> "The cut-off filter(s) available in the fluorescence detector to pre-select the emitted light and allow the light with wavelength above the specified value to pass before the light emission monochromator for final wavelength selection.",
			Category -> "Instrument Specifications"
		},
		EmissionDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],EmissionDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available to measure the emissions from the sample in the fluorescence detector.",
			Category -> "Instrument Specifications"
		},
		LightScatteringSource -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LightScatteringSource]],
			Pattern :> ExcitationSourceP,
			Description -> "The light source available to illuminate the sample in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector.",
			Category -> "Instrument Specifications"
		},
		LightScatteringWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LightScatteringWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The laser wavelength of the LightScatteringSource in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector.",
			Category -> "Instrument Specifications"
		},
		MALSDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MALSDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of Multi-Angle static Light Scattering light detector available to measure the scattered light intensity in the Multi-Angle static Light Scattering (MALS) detector.",
			Category -> "Instrument Specifications"
		},
		MALSDetectorAngles -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MALSDetectorAngles]],
			Pattern :> GreaterEqualP[0Degree],
			Description -> "The angles with regards to the incident light beam at which the MALS detection photodiodes are mounted around the flow cell inside the Multi-Angle static Light Scattering (MALS) detector.",
			Category -> "Instrument Specifications"
		},
		DLSDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DLSDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of Dynamic Light Scattering (DLS) light detector available to measure the scattered light fluctuation in the Multi-Angle static Light Scattering (MALS) detector.",
			Category -> "Instrument Specifications"
		},
		DLSDetectorAngle -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DLSDetectorAngle]],
			Pattern :> GreaterEqualP[0Degree],
			Description -> "The angle with regards to the incident light beam at which the DLS detection photodiode is located inside the Multi-Angle static Light Scattering (MALS) detector.",
			Category -> "Instrument Specifications"
		},
		RefractiveIndexSource -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RefractiveIndexSource]],
			Pattern :> ExcitationSourceP,
			Description -> "The light source used to traverse the sample and measure its refractive index in the differential refractive index (dRI) detector.",
			Category -> "Instrument Specifications"
		},
		RefractiveIndexWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RefractiveIndexWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The wavelength of the light used to traverse the sample and measure its refractive index in the differential refractive index (dRI) detector.",
			Category -> "Instrument Specifications"
		},
		RefractiveIndexDetector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RefractiveIndexDetector]],
			Pattern :> OpticalDetectorP,
			Description -> "The type of detector available used to detect the refracted light in the differential refractive index (dRI) detector for the determination of the differential refractive index of the sample.",
			Category -> "Instrument Specifications"
		},
		CircularDichroismSource -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CircularDichroismSource]],
			Pattern :> ExcitationSourceP,
			Description -> "The light source used for the circular dichroism (CD) measurement in the CD detector of the instrument.",
			Category -> "Instrument Specifications"
		},
		CircularDichroismWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CircularDichroismWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The wavelength of the light source of the circular dichroism (CD) detector.",
			Category -> "Instrument Specifications"
		},
		Mixer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mixer]],
			Pattern :> ChromatographyMixerTypeP,
			Description -> "The type of mixer the pump uses to generate the gradient.",
			Category -> "Instrument Specifications"
		},
		SampleLoop -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],SampleLoop]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The maximum volume of sample that can fit in the injection loop, before it is transferred into the flow path.",
			Category -> "Instrument Specifications"
		},
		BufferLoop -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],BufferLoop]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The maximum volume the buffer loop currently installed can hold.",
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
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FlowCellVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The volume of the instrument's detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		FluorescenceFlowCellVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FluorescenceFlowCellVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The volume of the instrument's fluorescence detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		LightScatteringFlowCellVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LightScatteringFlowCellVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The volume of the instrument's Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		RefractiveIndexFlowCellVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RefractiveIndexFlowCellVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The volume of the instrument's differential refractive index (dRI) detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		CircularDichroismFlowCellVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CircularDichroismFlowCellVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The volume of the instrument's circular dichroism detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		pHFlowCellVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],pHFlowCellVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The volume of the instrument's pH detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		ConductivityFlowCellVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ConductivityFlowCellVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The volume of the instrument's conductivity detector's flow cell.",
			Category -> "Instrument Specifications"
		},
		FlowCellPathLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FlowCellPathLength]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "The pathlength of the instrument's detector flow cell.",
			Category -> "Instrument Specifications"
		},
		FluorescenceFlowCellPathLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FluorescenceFlowCellPathLength]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "The pathlength of the instrument's fluorescence detector flow cell.",
			Category -> "Instrument Specifications"
		},
		CircularDichroismFlowCellPathLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CircularDichroismFlowCellPathLength]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "The pathlength of the instrument's circular dichroism detector flow cell.",
			Category -> "Instrument Specifications"
		},
		MaxAcceleration->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxAcceleration]],
			Pattern:>GreaterP[0*Milliliter/Minute^2],
			Description->"The maximum flow rate acceleration at which the pumping speed can safely be increased for the instrument.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		Timebase -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The software timebase name for the instrument running the protocol.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		PumpName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The software pump device name for the instrument running the protocol.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		FractionCollectorName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The software ID of the fraction collector integrated with this instrument.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		FractionCollectionName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The software ID of the fraction collection software module integrated with this instrument.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		ColumnConnector -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ColumnConnector]],
			Pattern :> {{ConnectorP, ThreadP | NullP, MaterialP, ConnectorGenderP, GreaterEqualP[0*Milli*Meter] | NullP, GreaterEqualP[0*Milli*Meter] | NullP}..},
			Description -> "The connector on the instrument to which a column will be attached to, in the form: {connector type, thread type, material of connector, connector gender, inner diameter, outer diameter}.",
			Category -> "Instrument Specifications"
		},
		ColumnPreheater -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the instrument is equipped with an electric heating element inside the column compartment that directly heats the column inlet tubing. The rapid heating, low volume design reduces gradient delay and extra-column bandspreading.",
			Category -> "Instrument Specifications"
		},
		ColumnCompartmentOrientation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnCompartmentOrientationP,
			Description -> "Indicates whether the instrument is plumbed to use the vertical or horizontal column compartment.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "The diameter of the tubing in the flow path.",
			Category -> "Instrument Specifications"
		},
		WastePump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VacuumPump][HPLC],
			Description -> "Vacuum pump that drains waste liquid into the carboy.",
			Category -> "Instrument Specifications"
		},
		ColumnJoins -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing, ColumnJoin],
				Object[Item, Column]
			],
			Description -> "Column joins or joining columns that stay installed on the instrument.",
			Category -> "Instrument Specifications"
		},
		BufferAInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][HPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer A inlet tubing used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferBInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][HPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer B inlet tubing used to uptake buffer B from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferCInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][HPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer C inlet tubing used to uptake buffer C from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferDInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][HPLC]|Object[Plumbing, Tubing],
			Description -> "The buffer D inlet tubing used to uptake buffer C from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferACap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][HPLC],
				Object[Plumbing,AspirationCap][HPLC]
			],
			Description -> "The aspiration cap used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferBCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][HPLC],
				Object[Plumbing,AspirationCap][HPLC]
			],
			Description -> "The aspiration cap used to uptake buffer B from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferCCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][HPLC],
				Object[Plumbing,AspirationCap][HPLC]
			],
			Description -> "The aspiration cap used to uptake buffer C from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferDCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][HPLC],
				Object[Plumbing,AspirationCap][HPLC]
			],
			Description -> "The aspiration cap used to uptake buffer D from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferAReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container that holds reservoir liquid for buffer A.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		BufferBReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container that holds reservoir liquid for buffer B.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		BufferCReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container that holds reservoir liquid for buffer C.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		BufferDReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container that holds reservoir liquid for buffer D.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		NeedleWashCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][HPLC],
				Object[Plumbing,AspirationCap][HPLC]
			],
			Description -> "The aspiration cap used to take up NeedleWash solution from the container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		NeedleWashSolutionInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][HPLC]|Object[Plumbing, Tubing],
			Description->"The needle wash solution inlet tubing used to uptake NeedleWash solution from container to the autosampler.",
			Category->"Instrument Specifications"
		},
		SecondaryNeedleWashCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][HPLC]
			],
			Description -> "The aspiration cap used to take up a second NeedleWash solution from the container to the instrument pump.",
			Category -> "Instrument Specifications",
			(* Set to developer as this wash solution is not controlled by the user (as of August 2024) *)
			Developer -> True
		},
		SecondaryNeedleWashSolutionInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][HPLC]|Object[Plumbing, Tubing],
			Description->"The needle wash solution inlet tubing used to uptake a second NeedleWash solution from container to the autosampler.",
			Category->"Instrument Specifications",
			(* Set to developer as this wash solution is not controlled by the user (as of August 2024) *)
			Developer -> True
		},
		TertiaryNeedleWashCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][HPLC]
			],
			Description -> "The aspiration cap used to take up a third NeedleWash solution from the container to the instrument pump.",
			Category -> "Instrument Specifications",
			(* Set to developer as this wash solution is not controlled by the user (as of August 2024) *)
			Developer -> True
		},
		TertiaryNeedleWashSolutionInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][HPLC]|Object[Plumbing, Tubing],
			Description->"The needle wash solution inlet tubing used to uptake a third NeedleWash solution from container to the autosampler.",
			Category->"Instrument Specifications",
			(* Set to developer as this wash solution is not controlled by the user (as of August 2024) *)
			Developer -> True
		},
		FluidicsWashCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][HPLC]
			],
			Description -> "The aspiration cap used to take up FluidicsWash solution from the container to the instrument pump. FluidicsWash solution is used to clean the instruments internal plumbing.",
			Category -> "Instrument Specifications",
			(* Set to developer as this wash solution is not controlled by the user (as of August 2024) *)
			Developer -> True
		},
		FluidicsWashSolutionInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][HPLC]|Object[Plumbing, Tubing],
			Description->"The fluidics wash solution inlet tubing used to uptake FluidicsWash solution from container to the autosampler. FluidicsWash solution is used to clean the instruments internal plumbing.",
			Category->"Instrument Specifications",
			(* Set to developer as this wash solution is not controlled by the user (as of August 2024) *)
			Developer -> True
		},
		SealWashCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Cap][HPLC]
			],
			Description -> "The aspiration cap used to take up SealWash solution from the container to the instrument pump. SealWash solution is used to wash away any buffer that leaks from the pumps through the seals and to keep the pump seal gaskets wet.",
			Category -> "Instrument Specifications",
			(* Set to developer as this wash solution is not controlled by the user (as of August 2024) *)
			Developer -> True
		},
		SealWashSolutionInlet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing, Tubing][HPLC]|Object[Plumbing, Tubing],
			Description->"The seal wash solution inlet tubing used to uptake SealWash solution from container to the instrument pump. SealWash solution is used to wash away any buffer that leaks from the pumps through the seals and to keep the pump seal gaskets wet.",
			Category->"Instrument Specifications",
			(* Set to developer as this wash solution is not controlled by the user (as of August 2024) *)
			Developer -> True
		},

		(* --- Operating Limits --- *)
		MinSampleVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinSampleVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The minimum sample volume required for a single run.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		RecommendedSampleVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RecommendedSampleVolume]],
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Description -> "The smallest recommended sample volume required for a single run.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxSampleVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSampleVolume]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "The maximum sample volume that that can be injected in a single run.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinFlowRate]],
			Pattern :> GreaterEqualP[(0*Milli*Liter)/Minute],
			Description -> "The minimum flow rate at whch the instrument can pump buffer through the system.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*Milli*Liter)/Minute],
			Description -> "The maximum flow rate at whch the instrument can pump buffer through the system.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinAbsorbanceWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinAbsorbanceWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum wavelength that the absorbance detector can monitor.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxAbsorbanceWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxAbsorbanceWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The Maximum wavelength that the absorbance detector can monitor.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		AbsorbanceWavelengthBandpass -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AbsorbanceWavelengthBandpass]],
			Pattern :> GreaterEqualP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The range of wavelengths centered around the desired wavelength that the absorbance detector will measure. For e.g. if the bandpass is 10nm and the desired measurement wavelength is 260nm, the detector will measure wavelengths from 255nm - 265nm.",
			Category -> "Operating Limits"
		},
		MinExcitationWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinExcitationWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum wavelength at which the fluorescence detector can excite the sample.",
			Category -> "Operating Limits"
		},
		MaxExcitationWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxExcitationWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The maximum wavelength at which the fluorescence detector can excite the sample.",
			Category -> "Operating Limits"
		},
		MinEmissionWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinEmissionWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum wavelength at which the fluorescence detector can take emission readings.",
			Category -> "Operating Limits"
		},
		MaxEmissionWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxEmissionWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The maximum wavelength at which the fluorescence detector can take emission readings.",
			Category -> "Operating Limits"
		},
		MinColumnTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinColumnTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The minimum temperature at which the column oven can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxColumnTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxColumnTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The maximum temperature at which the column oven can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxColumnLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxColumnLength]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The maximum column length that can be accommodated inside of the column oven.",
			Category -> "Operating Limits"
		},
		MaxColumnOutsideDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxColumnOutsideDiameter]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The maximum column outside diameter that can be accommodated inside of the column oven.",
			Category -> "Operating Limits"
		},
		MinPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinPressure]],
			Pattern :> GreaterEqualP[0*PSI],
			Description -> "The minimum pressure at which the instrument can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		PumpMaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PumpMaxPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum pressure at which the pump can still operate.",
			Category -> "Operating Limits"
		},
		TubingMaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingMaxPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum pressure the tubing in the sample flow path can tolerate.",
			Category -> "Operating Limits"
		},
		FlowCellMaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FlowCellMaxPressure]],
			Pattern :> GreaterEqualP[0*PSI],
			Description -> "The maximum pressure the detector's flow cell can tolerate.",
			Category -> "Operating Limits"
		},
		MinFluorescenceFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinFluorescenceFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The minimum temperature that the temperature of the fluorescence flow cell of the instrument's fluorescence detector can be set to.",
			Category -> "Operating Limits"
		},
		MaxFluorescenceFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFluorescenceFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The maximum temperature that the temperature of the fluorescence flow cell of the instrument's fluorescence detector can be set to.",
			Category -> "Operating Limits"
		},
		MinLightScatteringFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinLightScatteringFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The minimum temperature that the temperature of the flow cell of the instrument's Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector can be set to.",
			Category -> "Operating Limits"
		},
		MaxLightScatteringFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxLightScatteringFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The maximum temperature that the temperature of the flow cell of the instrument's Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector can be set to.",
			Category -> "Operating Limits"
		},
		MinMALSMolecularWeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinMALSMolecularWeight]],
			Pattern :> GreaterP[0*Dalton],
			Description -> "The minimum molecular weight analyte the Multi-Angle static Light Scattering (MALS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MaxMALSMolecularWeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxMALSMolecularWeight]],
			Pattern :> GreaterP[0*Dalton],
			Description -> "The maximum molecular weight analyte the Multi-Angle static Light Scattering (MALS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MinMALSGyrationRadius -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinMALSGyrationRadius]],
			Pattern :> GreaterP[0*Nanometer],
			Description -> "The minimum radius of gyration that the Multi-Angle static Light Scattering (MALS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MaxMALSGyrationRadius -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxMALSGyrationRadius]],
			Pattern :> GreaterP[0*Nanometer],
			Description -> "The maximum radius of gyration that the Multi-Angle static Light Scattering (MALS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MinDLSHydrodynamicRadius -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinDLSHydrodynamicRadius]],
			Pattern :> GreaterP[0*Nanometer],
			Description -> "The minimum hydrodynamic radius that the Dynamic Light Scattering (DLS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MaxDLSHydrodynamicRadius -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDLSHydrodynamicRadius]],
			Pattern :> GreaterP[0*Nanometer],
			Description -> "The maximum hydrodynamic radius that the Dynamic Light Scattering (DLS) detector of the instrument can detect.",
			Category -> "Operating Limits"
		},
		MinRefractiveIndexFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinRefractiveIndexFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The minimum temperature that the temperature of the flow cell of the instrument's differential refractive index (dRI) detector can be set to.",
			Category -> "Operating Limits"
		},
		MaxRefractiveIndexFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxRefractiveIndexFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The maximum temperature that the temperature of the flow cell of the instrument's differential refractive index (dRI) detector can be set to.",
			Category -> "Operating Limits"
		},
		MinCiruclarDichrosimFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinCiruclarDichrosimFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The minimum temperature at which the Circular Dichroism (CD) flow cell of the instrument's CD detector can operate.",
			Category -> "Operating Limits"
		},
		MaxCiruclarDichrosimFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxCiruclarDichrosimFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The maximum temperature at which the Circular Dichroism (CD) flow cell of the instrument's CD detector can operate.",
			Category -> "Operating Limits"
		},
		MinCiruclarDichrosimWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinCiruclarDichrosimWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The minimum light wavelength that the light source of the circular dichroism detector can produce.",
			Category -> "Operating Limits"
		},
		MaxCiruclarDichrosimWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxCiruclarDichrosimWavelength]],
			Pattern :> GreaterP[0*Nano*Meter, 1*Nano*Meter],
			Description -> "The maximum light wavelength that the light source of the circular dichroism detector can produce.",
			Category -> "Operating Limits"
		},
		MinDetectorpH -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinDetectorpH]],
			Pattern :> RangeP[0, 14],
			Description -> "The minimum pH to which the pH detector of this instrument can measure.",
			Category -> "Operating Limits"
		},
		MaxDetectorpH -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDetectorpH]],
			Pattern :> RangeP[0, 14],
			Description -> "The maximum pH to which the pH detector of this instrument can measure.",
			Category -> "Operating Limits"
		},
		MinpHFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinpHFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The minimum temperature at which the pH flow cell of the instrument's pH detector can operate.",
			Category -> "Operating Limits"
		},
		MaxpHFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxpHFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The maximum temperature at which the pH flow cell of the instrument's pH detector can operate.",
			Category -> "Operating Limits"
		},
		MinConductivity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinConductivity]],
			Pattern :> GreaterP[0*Micro*Siemens/Centimeter],
			Description -> "The minimum conductivity that the conductivity detector of this instrument can measure.",
			Category -> "Operating Limits"
		},
		MaxConductivity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxConductivity]],
			Pattern :> GreaterP[0*Micro*Siemens/Centimeter],
			Description -> "The maximum conductivity that the conductivity detector of this instrument can measure.",
			Category -> "Operating Limits"
		},
		MinConductivityFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinConductivityFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The minimum temperature at which the conductivity flow cell of the instrument's conductivity detector can operate.",
			Category -> "Operating Limits"
		},
		MaxConductivityFlowCellTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxConductivityFlowCellTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "The maximum temperature at which the conductivity flow cell of the instrument's conductivity detector can operate.",
			Category -> "Operating Limits"
		},

		(* --- Dimensions & Positions --- *)
		AutosamplerDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform from which samples are robotically aspirated and injected onto the column.",
			Category -> "Dimensions & Positions"
		},
		FractionCollectorDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform that houses containers into which the instrument will direct the fractions into individual wells robotically.",
			Category -> "Dimensions & Positions"
		},
		BufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains the liquids that are used as buffers/solvents for elution by the instrument.",
			Category -> "Dimensions & Positions"
		},
		WashBufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains solvents used to flush and clean the fluid lines of the instrument.",
			Category -> "Dimensions & Positions"
		},
		RearSealWashBufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains solvent used to wash the back of the high pressure seal and the plunger of the instrument's pump.",
			Category -> "Dimensions & Positions"
		},
		ColumnCapRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The rack which contains the column caps and joins while the columns themselves are being used by the instrument.",
			Category -> "Dimensions & Positions"
		},
		(* --- Qualifications & Maintenance---*)
		AutomaticWasteEvacuation-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the pump specified in the WastePump field will be remotely activated to evacuate waste on a schedule of once every hour for 5 minutes.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		SystemPrimeLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Data],Object[Protocol]},
			Description -> "A historical record of chromatography data generated for the system prime runs on this instrument.",
			Category -> "Qualifications & Maintenance",
			Headers ->{"Date","Chromatogram","Protocol"}
		},
		SystemFlushLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Data],Object[Protocol]|Object[Maintenance]},
			Description -> "A historical record of chromatography data generated for the system flush runs on this instrument.",
			Category -> "Qualifications & Maintenance",
			Headers ->{"Date","Chromatogram","Protocol"}
		},

		(* Sensors *)
		BufferACarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferBCarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferCCarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer C volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferDCarboySensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer D volumes in carboys.",
			Category -> "Sensor Information"
		},
		BufferABottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferBBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferCBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer C volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferDBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer D volumes in bottles.",
			Category -> "Sensor Information"
		},
		IntegratedMassSpectrometer-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, MassSpectrometer][IntegratedHPLC],
			Description -> "The mass spectrometer that is connected to this HPLC such that the analytes in the samples may be ionized and measured by mass spectrometry.",
			Category -> "Integrations"
		}
	}
}];
