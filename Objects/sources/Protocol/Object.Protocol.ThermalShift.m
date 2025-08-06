

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol,ThermalShift], {
	Description->"A protocol for measuring changes in thermal stability of one or more analytes in the presence of varying ligands or buffer conditions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* === Method Information === *)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to ramp over the specified temperature range and record detected fluorescence.",
			Category -> "General"
		},
		ReactionVolume->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Milli,
			Description ->  "The total volume of the reaction including the sample, any ligands, buffer, and detection reagent.",
			Category -> "General"
		},
		TotalSampleNumber -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[1],
			Description -> "The total number of samples to be run in this protocol.",
			Category -> "General",
			Developer->True
		},
		(* === Sample Preparation === *)
		Dilutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>ListableP[{{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}..}|None],
			Description -> "For each member of SamplesIn, the collection of dilutions performed on each sample before instrument measurement. This is the volume of the sample and the volume of the diluent that will be mixed together for each concentration in the dilution curve.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		SerialDilutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>ListableP[{{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}..}|None],
			Description -> "For each member of SamplesIn, the volume taken out of each sample and transferred serially and the volume of the Diluent it is mixed with at each step.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		NumberOfDilutions->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "Indicates the number of dilutions of each pool.",
			Category -> "Sample Preparation",
			Developer->True
		},
		Diluents->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample],Model[Sample,StockSolution]],
			Description->"For each member of SamplesIn, the sample that is used to dilute each sample to a concentration series.",
			IndexMatching -> SamplesIn,
			Category->"Sample Preparation"
		},
		DilutionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container] | Model[Container],
			Description->"The container or containers in which samples are diluted with the Diluent to make the concentration series.",
			Category->"Sample Preparation"
		},
		DilutionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description -> "The conditions under which any leftover samples from the DilutionCurve should be stored after the samples are transferred to the measurement plate.",
			Category->"Sample Preparation"
		},
		SampleDilutionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the loading and mixing of each sample and the Diluent in the DilutionContainers.",
			Category -> "Sample Preparation"
		},
		DilutionSampleManipulation->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "The sample manipulation protocol used to generate sample dilution curves.",
			Category -> "Sample Preparation"
		},
		DilutionMixVolumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{(GreaterEqualP[0 Microliter]|None)..}],
			Description -> "For each member of SamplesIn, the volume that is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation",
			IndexMatching -> SamplesIn
		},
		DilutionNumberOfMixes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{(RangeP[0,20,1]|None)..}],
			Description -> "For each member of SamplesIn, the number of pipette out and in cycles that is used to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation",
			IndexMatching -> SamplesIn
		},
		DilutionMixRates->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{(RangeP[0.4 Microliter/Second,250 Microliter/Second]|None)..}],
			Description -> "For each member of SamplesIn, the speed at which the DilutionMixVolume is pipetted out and in of the dilution to mix the sample with the Diluent to make the DilutionCurve.",
			Category->"Sample Preparation",
			IndexMatching -> SamplesIn
		},
		PoolingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the aliquoting of the experimental samples into the pooling plate prior to instrument analysis.",
			Category -> "Sample Preparation"
		},

		PooledMixSamplePreparation -> {
			Format -> Multiple,
			Class -> {
				Mix -> Boolean,
				MixType->Expression,
				NumberOfMixes -> Integer,
				MixVolume -> Real,
				Incubate -> Boolean
			},
			Pattern :> {
				Mix -> BooleanP,
				MixType->(Invert|Pipette),
				NumberOfMixes -> GreaterEqualP[0],
				MixVolume -> GreaterP[0 Microliter],
				Incubate -> BooleanP
			},
			Units -> {
				Mix -> None,
				MixType->None,
				NumberOfMixes -> None,
				MixVolume -> Microliter,
				Incubate -> None
			},
			Relation -> {
				Mix -> Null,
				MixType->Null,
				NumberOfMixes -> Null,
				MixVolume -> Null,
				Incubate -> Null
			},
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, parameters describing how the pooled samples should be mixed prior to the start of the experiment.",
			Category -> "Sample Preparation"
		},

		NestedIndexMatchingMixSamplePreparation -> {
			Format -> Multiple,
			Class -> {
				Mix -> Boolean,
				MixType->Expression,
				NumberOfMixes -> Integer,
				MixVolume -> Real,
				Incubate -> Boolean
			},
			Pattern :> {
				Mix -> BooleanP,
				MixType->(Invert|Pipette),
				NumberOfMixes -> GreaterEqualP[0],
				MixVolume -> GreaterP[0 Microliter],
				Incubate -> BooleanP
			},
			Units -> {
				Mix -> None,
				MixType->None,
				NumberOfMixes -> None,
				MixVolume -> Microliter,
				Incubate -> None
			},
			Relation -> {
				Mix -> Null,
				MixType->Null,
				NumberOfMixes -> Null,
				MixVolume -> Null,
				Incubate -> Null
			},
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, parameters describing how the pooled samples should be mixed prior to the start of the experiment.",
			Category -> "Sample Preparation"
		},
		PoolingSampleManipulation->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "The sample manipulation protocol used to pool samples prior to instrument measurement.",
			Category -> "Sample Preparation"
		},
		(* Todo: N-Multiples *)
		PooledWorkingSamples -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectP[Object[Sample]]|{ObjectP[{Object[Container],Model[Container]}],WellP})..}|{ObjectP[{Object[Container], Model[Container]}], WellP},
			Description -> "The derived pooled samples after sample dilution. This list diverges from SamplesIn when input samples are diluted prior to pooling.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		SampleVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of PooledSamplesIn, the volume added to the assay reaction.",
			Category -> "Sample Preparation",
			IndexMatching->PooledSamplesIn
		},
		(* Todo: N-Multiples *)
		Buffers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Link|Null,
			Relation -> Alternatives[Object[Sample],Model[Sample],Model[Sample,StockSolution]],
			Description -> "For each member of PooledSamplesIn, the sample used to bring each reaction to its ReactionVolume once all other components have been added.",
			Category -> "Sample Preparation",
			IndexMatching->PooledSamplesIn
		},
		BufferVolumes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Microliter],Null],
			Description -> "For each member of PooledSamplesIn, the volume of buffer used to bring each reaction to its ReactionVolume once all other components have been added.",
			Category -> "Sample Preparation",
			IndexMatching->PooledSamplesIn
		},
		(* Todo: N-Multiples *)
		DetectionReagents -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Link|Null,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "For each member of PooledSamplesIn, the fluorescent dye that this experiment uses to monitor melting.",
			Category -> "Sample Preparation",
			IndexMatching->PooledSamplesIn
		},
		DetectionReagentVolumes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Microliter],Null],
			Description->"For each member of PooledSamplesIn, the volume of detection reagent added to the well.",
			Category->"Sample Preparation",
			IndexMatching->PooledSamplesIn
		},
		PreparedPlate->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the provided sample container is a prepared plate.",
			Category->"Sample Preparation",
			Developer->True
		},
		CapillaryStripPreparationPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Vessel]|Object[Container,Vessel],
			Description->"The container in which the final assay reaction is assembled prior to loading the Uncle capillary strip.",
			Category->"Sample Preparation"
		},
		AssayPlatePrimitives->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the assembly of the final assay reaction prior to instrument measurement.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		AssayPlateManipulation->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol,SampleManipulation],
				Object[Protocol, ManualSamplePreparation],
				Object[Protocol, RoboticSamplePreparation],
				Object[Notebook, Script]
			],
			Description -> "The sample manipulation protocol used to assemble the final assay reaction prior to instrument measurement.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		PassiveReferenceDye -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The passive fluorescence reference dye used to normalize fluorescence background fluctuations during melting.",
			Category -> "Sample Preparation"
		},
		PassiveReferenceDyeVolume->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description ->  "The volume of the passive fluorescence reference dye added to each well.",
			Category -> "Sample Preparation"
		},
		CapillaryStripLoadingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the transfer of the experimental samples into Uncle Uni capillary strips prior to instrument analysis.",
			Category -> "Sample Preparation"
		},
		CapillaryStripLoadingSampleManipulation->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation] | Object[Protocol, RoboticSamplePreparation],
			Description -> "The sample manipulation protocol used to load experimental samples into Uncle Uni capillary strips prior to instrument analysis.",
			Category -> "Sample Preparation"
		},
		AssayContainers->{
			Format->Multiple,
			Class -> Link,
			Pattern:>_Link,
			Relation-> Alternatives[Object[Container,Plate],Model[Container,Plate]],
			Description -> "The containers the samples are assayed in.",
			Category->"Sample Loading"
		},
		AssayPositions->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The well positions of the samples in the assay containers.",
			Category->"Sample Loading",
			Developer->True
		},
		CapillaryClips->{
			Format->Multiple,
			Class -> Link,
			Pattern:>_Link,
			Relation-> Alternatives[Object[Container,Rack],Model[Container,Rack]],
			Description -> "The capillary clips used to seal the assay containers.",
			Category->"Sample Loading",
			Developer->True
		},
		CapillaryGaskets->{
			Format->Single,
			Class -> Link,
			Pattern:>_Link,
			Relation-> Alternatives[Object[Item,Consumable],Model[Item,Consumable]],
			Description -> "The gaskets inserted into the capillary clips prior to sealing the assay containers.",
			Category->"Sample Loading",
			Developer->True
		},
		CapillaryStripLoadingRack->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Plate],Model[Container,Plate]],
			Description -> "The capillary strip plate adaptor rack for loading samples using a liquid handler.",
			Category->"Sample Loading",
			Developer->True
		},
		SampleStageLid->{
			Format->Single,
			Class -> Link,
			Pattern:>_Link,
			Relation-> Alternatives[Object[Part],Model[Part]],
			Description -> "The lid enclosing the Uncle sample stage.",
			Category->"Sample Loading",
			Developer->True
		},
		PlateSeal->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item], Object[Item]],
			Description->"The optically transparent self-adhesive seal used to cover the assay plate wells during thermal cycling.",
			Category->"Sample Loading"
		},
		ContainersOutLoadingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the sample transfer of the experimental samples into the ContainersOut prior to storage.",
			Category -> "Sample Preparation"
		},
		ContainersOutSampleManipulation->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation] | Object[Protocol, RoboticSamplePreparation],
			Description -> "The sample manipulation protocol used to load experimental samples into the ContainersOut prior to storage.",
			Category -> "Sample Preparation"
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP}},
			Relation -> {Object[Container]|Model[Container]|Object[Part]|Model[Part], Null},
			Description -> "A list of placements used to place the capillary strips to be analyzed into the sample stage of the multimode spectrophotometer.",
			Category -> "Thermocycling",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		(* === Melting Curve === *)
		RunTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units-> Minute,
			Description-> "The length of time for which the instrument is expected to run given the specified parameters.",
			Category->"Thermocycling"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The low temperature of the melting or cooling curve.",
			Category -> "Thermocycling",
			Abstract->True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The high temperature of the melting or cooling curve.",
			Category -> "Thermocycling",
			Abstract->True
		},
		TemperatureRampOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ThermodynamicCycleP,
			Description -> "The order of temperature ramping to be performed in each cycle.",
			Category -> "Thermocycling",
			Abstract -> True
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time to hold the temperature at the thermocycling endpoints.",
			Category -> "Thermocycling"
		},
		NumberOfCycles -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The number of heating/cooling cycles to perform. Each heating or cooling phase is considered a half cycle.",
			Category -> "Thermocycling"
		},
		TemperatureRamping -> {
			Format -> Single,
			Class -> Expression,
			Pattern:> Alternatives[Linear, Step],
			Description-> "The type of temperature ramp. Linear temperature ramps increase temperature at a constant rate given by TemperatureRampRate. Step temperature ramps increase the temperature by TemperartureRampStep and holds the temperature constant for TemperatureRampStepTime before increasing the temperature again.",
			Category -> "Thermocycling"
		},
		TemperatureRampRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Celsius)/Second],
			Units -> Celsius/Second,
			Description -> "The rate at which the temperature is changed in the course of one heating and/or cooling cycle.",
			Category -> "Thermocycling"
		},
		TemperatureResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The amount by which the temperature is changed between each data point and the next during the melting and/or cooling curves.",
			Category -> "Thermocycling"
		},
		NumberOfTemperatureRampSteps->{
			Format-> Single,
			Class-> Integer,
			Pattern:> GreaterP[0],
			Description-> "The number of step changes in temperature for a heating or cooling cycle.",
			Category-> "Thermocycling"
		},
		StepHoldTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description->"The length of time samples are held at each temperature during a stepped temperature ramp.",
			Category -> "Thermocycling"
		},

		(* === Detection === *)
		ExcitationWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Nano*Meter],Null],
			Description->"For each member of PooledSamplesIn, the wavelength of light used to excite intrinsic or extrinsic fluorescence.",
			Category->"Detection",
			IndexMatching->PooledSamplesIn
		},
		StaticLightScatteringExcitationWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[{GreaterEqualP[0*Nano*Meter]..},{Null..}],
			Description->"For each member of PooledSamplesIn, the wavelength(s) of light used to collect static light scattering data.",
			Category->"Detection",
			IndexMatching->PooledSamplesIn
		},
		EmissionWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Nano*Meter],Null],
			Description->"For each member of PooledSamplesIn, the wavelength at which fluorescence emission is detected.",
			Category->"Detection",
			IndexMatching->PooledSamplesIn
		},
		MinEmissionWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Nano*Meter],Null],
			Description->"For each member of PooledSamplesIn, the minimum wavelength at which fluorescence emission is detected.",
			Category->"Detection",
			IndexMatching->PooledSamplesIn
		},
		MaxEmissionWavelengths->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[GreaterEqualP[0*Nano*Meter],Null],
			Description->"For each member of PooledSamplesIn, the maximum wavelength at which fluorescence emission is detected.",
			Category->"Detection",
			IndexMatching->PooledSamplesIn
		},
		(* MultimodeSpectrophotometer specific fields *)
		FluorescenceLaserPower -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LaserPowerFilterP,
			Description -> "For each member of PooledSamplesIn, the UV laser power filter used.",
			Category-> "Detection",
			IndexMatching-> PooledSamplesIn
		},
		StaticLightScatteringLaserPower -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LaserPowerFilterP,
			Description -> "For each member of PooledSamplesIn, the Blue laser power filter used.",
			Category-> "Detection",
			IndexMatching-> PooledSamplesIn
		},
		OptimizeFluorescenceLaserPower -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of PooledSamplesIn and all corresponding dilutions, indicates if the fluorescence laser power filter is adjusted prior to sample measurement.",
			Category-> "Detection"
		},
		OptimizeStaticLightScatteringLaserPower -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of PooledSamplesIn and all corresponding dilutions, indicates if the static light scattering laser power filter is matched to the optimal fluorescence laser power prior to sample measurement.",
			Category-> "Detection"
		},
		LaserOptimizationEmissionWavelengthRange -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[{GreaterP[0*Nanometer]..},Null],
			Description -> "For each member of PooledSamplesIn and all corresponding dilutions, the wavelength(s) of the sample's spectra used to evaluate optimal laser setting.",
			Category-> "Detection"
		},
		LaserOptimizationTargetEmissionIntensityRange -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[{GreaterP[0]..},Null],
			Description -> "For each member of PooledSamplesIn and all corresponding dilutions, the intensity range, expressed as a counts, used to evaluate optimal laser setting.",
			Category-> "Detection"
		},
		FluorescenceLaserPowerOptimizationResult -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LaserOptimizationResultP,
			Description -> "Indicates if the fluorescence laser power filter optimization was successful. \"FailureLowSignal\" indicates the laser power could not be optimized because signal intensity at 100% laser power is lower than the LaserOptimizationTargetEmissionIntensityRange. \"FailureSignalSaturation\" indicates the laser power could not be optimized because signal intensity at 13% laser power is higher than the LaserOptimizationTargetEmissionIntensityRange.",
			Category-> "Detection"
		},
		DynamicLightScattering->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if a DLS measurement of each sample is made before and after the thermal ramping.",
			Category->"Detection"
		},
		DynamicLightScatteringMeasurements->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[
				Before,
				After
			],
			Description->"Indicates if a DLS measurement of each sample is made before thermal ramping, after thermal ramping, or both before and after thermal ramping.",
			Category->"Detection"
		},
		DynamicLightScatteringMeasurementTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[15Celsius,95Celsius],
			Units->Celsius,
			Description->"Indicates the temperatures at which each DLS measurement is made.",
			Category->"Detection"
		},
		NumberOfDynamicLightScatteringAcquisitions->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each DLS measurement, the number of series of speckle patterns that are each collected over the AcquisitionTime to create the measurement's autocorrelation curve.",
			Category -> "Detection"
		},
		DynamicLightScatteringAcquisitionTime->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each DLS measurement, the length of time that each acquisition generates speckle patterns to create the measurement's autocorrelation curve.",
			Category -> "Detection"
		},
		AutomaticDynamicLightScatteringLaserSettings->{
			Format -> Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the DynamicLightScatteringLaserPower and DynamicLightScatteringDiodeAttenuation are automatically set at the beginning of the assay by the Instrument to levels ideal for the samples.",
			Category->"Detection"
		},
		DynamicLightScatteringLaserPower->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The percent of the max dynamic light scattering laser power that is used to make DLS measurements. The laser level is optimized at run time by the instrument software when AutomaticDynamicLightScatteringLaserSettings is True and LaserLevel is Null.",
			Category -> "Detection"
		},
		DynamicLightScatteringDiodeAttenuation->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The percent of scattered light signal that is allowed to reach the avalanche photodiode for DLS measurements. The attenuator level is optimized at run time by the instrument software when AutomaticDynamicLightScatteringLaserSettings is True and DiodeAttenuation is Null.",
			Category -> "Detection"
		},
		DynamicLightScatteringCapillaryLoading->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[Null, Robotic, Manual],
			Description->"The loading method for capillaries for DLS measurements.",
			Category -> "General"
		},
		DynamicLightScatteringManualLoadingPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Vessel]|Object[Container,Vessel],
			Description->"The plate from which samples are loaded onto assay capillaries manually. This plate is set for loading using an 8-channel multichannel pipette.",
			Category -> "Sample Loading"
		},
		DynamicLightScatteringManualLoadingPipette->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Instrument,Pipette]|Object[Instrument,Pipette],
			Description->"The multichannel pipette that is used to manually load samples onto assay capillaries manually. This plate is set for loading using an 8-channel multichannel pipette.",
			Category -> "Sample Loading"
		},
		DynamicLightScatteringManualLoadingTips->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Tips]|Object[Item,Tips],
			Description->"The pipette tips that are used to manually load samples onto assay capillaries manually. This plate is set for loading using an 8-channel multichannel pipette.",
			Category -> "Sample Loading"
		},
		DynamicLightScatteringManualLoadingTuples->{
			Format->Multiple,
			Class->{Sources->Link, SourceRow->Expression ,Targets->Link, TargetRow->Expression, FirstWell->Expression, NumberOfWells->Expression, TargetPositions -> Expression},
			Pattern:>{Sources->_Link, SourceRow->_String, Targets->_Link, TargetRow->_String, FirstWell->_String, NumberOfWells->_String, TargetPositions->_String},
			Relation->{Sources->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Vessel]|Object[Container,Vessel],SourceRow->Null, Targets->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Vessel]|Object[Container,Vessel], TargetRow->Null, FirstWell->Null, NumberOfWells->Null, TargetPositions -> Null},
			Description->"The pipetting instructions used to manually load samples onto assay capillaries manually. This plate is set for loading using an 8-channel multichannel pipette.",
			Category -> "Sample Loading"
		},
		(*Analysis Fields*)
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the file containing instructions used by the instrument software to run this protocol.",
			Category -> "General",
			Developer->True
		},
		SampleFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the file containing the sample information for this protocol.",
			Category -> "General",
			Developer->True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the data files generated at the conclusion of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		InstrumentDataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path on the instrument computer in which the data generated by the experiment is stored locally.",
			Category -> "Data Processing",
			Developer -> True
		},
		DataFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the directory where the data files are stored at the conclusion of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		DataFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The files containing the unprocessed data generated by the instrument.",
			Category -> "Experimental Results"
		},
		DynamicLightScatteringLoadingAnalyses -> {
	        Format -> Multiple,
	        Class -> Link,
	        Pattern :> _Link,
	        Relation -> Object[Analysis][Reference],
	        Description -> "Analyses that determine properly loaded dynamic light scattering samples.",
	        Category -> "Analysis & Reports"
	    }
	}
}]
