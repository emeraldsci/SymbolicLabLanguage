(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,AlphaScreen], {
	Description->"A detailed set of parameters that specifies a single alpha screen reading step in a larger protocol.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The samples that are being read.",
			Category -> "General",
			Migration->SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the samples that are being read.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "For each member of SampleLink, the samples that are being read.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, PlateReader],
				Object[Instrument, PlateReader]
			],
			Description -> "The plate reader used for this plate reader experiment step.",
			Category -> "General"
		},
		ReadTemperatureReal->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units->Celsius,
			Description -> "The temperature at which the plate reader chamber is held.",
			Category -> "General",
			Migration->SplitField
		},
		ReadTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Ambient,
			Description -> "The temperature at which the plate reader chamber is held.",
			Category -> "General",
			Migration->SplitField
		},
		ReadEquilibrationTime->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description->"The length of time for which the assay plates equilibrate at the requested temperature in the plate reader before being read.",
			Category -> "Sample Handling"
		},
		TargetCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of carbon dioxide in the atmosphere in the plate reader chamber.",
			Category -> "Sample Handling"
		},
		TargetOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of oxygen in the atmosphere in the plate reader chamber. If specified, nitrogen gas is pumped into the chamber to force oxygen in ambient air out of the chamber until the desired level is reached.",
			Category -> "Sample Handling"
		},
		AtmosphereEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the samples equilibrate at the requested oxygen and carbon dioxide level before being read.",
			Category -> "Sample Handling"
		},
		PlateReaderMix -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the assay plate is agitated inside the plate reader chamber prior to measurement.",
			Category -> "Mixing"
		},
		PlateReaderMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The frequency at which the plate is agitated inside the plate reader chamber prior to measurement.",
			Category -> "Mixing"
		},
		PlateReaderMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the plate is agitated inside the plate reader chamber prior to measurement.",
			Category -> "Mixing"
		},
		PlateReaderMixMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MechanicalShakingP,
			Description -> "The mode of shaking which should be used to mix the plate.",
			Category -> "Mixing"
		},

		Gain->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microvolt],
			Units -> Microvolt,
			Description->"The gain which should be applied to the signal reaching the primary detector photomultiplier tube (PMT). This is specified as a direct voltage. If it sets to Automatic, the gain is set from the result of OptimizeGain or a previous protocol.",
			Category -> "Optics"
		},
		GainOptimizationSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample]],
			Description->"When optimizing gain, the list of samples used for gain optimization.",
			Category -> "Optics Optimization"
		},
		GainOptimizationSampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of GainOptimizationSamples, the label of the samples that are used as gain optimization samples, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			Developer->True,
			IndexMatching -> GainOptimizationSamples
		},

		FocalHeightReal -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Milli,
			Description -> "The height above the assay plates from which the readings are made.",
			Migration -> SplitField,
			Category -> "Optics"
		},
		FocalHeightExpression -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Automatic|Auto],
			Description -> "The height above the assay plates from which the readings are made.",
			Migration -> SplitField,
			Category -> "Optics"
		},
		FocalHeightOptimizationSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample]],
			Description->"The list of samples used for focal height optimization.",
			Category -> "Optics Optimization"
		},
		FocalHeightOptimizationSampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of FocalHeightOptimizationSamples, the label of the samples that are used for focal height optimization, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			Developer->True,
			IndexMatching -> FocalHeightOptimizationSamples
		},
		SettlingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The time between the movement of the plate and the beginning of the measurement. It reduces potential vibration of the samples in plate due to the stop and go motion of the plate carrier.",
			Category -> "Optics"
		},
		ExcitationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The time that the samples will be excited by the light source and the singlet Oxygen is generated.",
			Category -> "Optics"
		},
		DelayTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The time between end of excitation and start of the emission signal integration. It allows the singlet Oxygen to react with the acceptor beads and reduces potential auto-fluorescent noise generated by biomolecular components.",
			Category -> "Optics"
		},
		IntegrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The amount of time for which the emission signal is integrated. The signal is added, rather than averaged over time. For example, if the interaction time is doubled, the signal is expected to be doubled.",
			Category -> "Optics"
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanometer],
			Units -> Nanometer,
			Description -> "The excitation wavelength determined by the AlphaScreen laser. The AlphaScreen laser excites the AlphaScreen donor beads to generate singlet Oxygen.",
			Category -> "Optics",
			Abstract -> True
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Nanometer],
			Units -> Nanometer,
			Description -> "The emission wavelength selected by the optical filter. The emitted light from the AlphaScreen acceptor beads is captured by the primary detector photomultiplier tube (PMT).",
			Category -> "Optics",
			Abstract -> True
		},

		RetainCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation.",
			Category -> "General"
		},
		ReadDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadDirectionP,
			Description -> "The plate path the instrument follows as it measures each well, for instance reading all wells in a row before continuing on to the next row (Row).",
			Category -> "General"
		},

		MoatWells -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description->"Indicates if moat wells are set to decrease evaporation from the assay samples during the experiment.",
			Category -> "Sample Preparation"
		},
		MoatSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of concentric perimeters of wells filled with MoatBuffer in order to slow evaporation of inner assay samples.",
			Category -> "Sample Preparation"
		},
		MoatBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples.",
			Category -> "Sample Preparation"
		},
		MoatVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume which each moat is filled with in order to slow evaporation of inner assay samples.",
			Category -> "Sample Preparation"
		},

		PreparedPlate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the SamplesIn are from a prepared plate. The prepared plate contains the analytes, acceptor and donor AlphaScreen beads that are ready to be excited by AlphaScreen laser for luminescent AlphaScreen measurement in a plate reader. If the 'PreparedPlate' option is False, the samples that contain all the components will be transferred to the 'AssayPlate' for AlphaScreen measurement.",
			Category -> "General"
		},
		AssayPlateModel -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container,Plate]],
			Description -> "The plates where the samples are transferred and measured in the plate reader.",
			Category -> "General"
		},
		AlphaAssayVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The total volume that each sample is transferred to the 'AssayPlate'.",
			Category -> "General"
		},

		OpticsOptimizationTemplate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,AlphaScreen],
			Description -> "A previous protocol that contains the optimized gain and focal height values for the AlphaScreen measurement. The gain and focal height values from the previous protocol are taken and used in the current protocol with no further optimization.",
			Category -> "Optics Optimization"
		},
		OptimizeGain -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if luminescence gain value is optimized before the plate reader measurement. The gain value is set so that the signal from the optimization samples would reach the 'TargetSaturationPercentage' of the plate reader's dynamic range. Each optimization sample can only be used once for the optimization, because the signal from the AlphaScreen beads reduces after repeated excitation. The gain optimization is performed by measuring one optimization sample at once and increasing or decreasing the gain value until the 'TargetSaturationPercentage' is reached.",
			Category -> "Optics Optimization"
		},
		TargetSaturationPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			Description -> "When optimizing gain, the gain value is set so that the signal from the optimization samples reaches the 'TargetSaturationPercentage' of the plate reader's dynamic range.",
			Category -> "Optics Optimization"
		},
		NumberOfGainOptimizations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "When optimizing gain, the number of the optimization samples aliquoted onto the assay plate for gain optimization. Each aliquot is used only once to measure signal and adjust the gain.",
			Category -> "Optics Optimization"
		},
		StartingGain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microvolt],
			Units -> Microvolt,
			Description -> "When optimizing gain, the initial gain value to begin the gain optimization. If the readout from the current gain value is lower/higher than the 'TargetSaturationPercentage', the next gain value for the optimization will be increased/decreased.",
			Category -> "Optics Optimization"
		},

		OptimizeFocalHeight -> { (*TBU*)
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if focal height value is optimized prior to the gain optimization before the plate reader measurement.",
			Category -> "Optics Optimization"
		},
		FocalHeightStep -> {(*TBU*)
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "When optimizing focal height, the step size that the focal height is increased or decreased after measuring each optimization sample.",
			Category -> "Optics Optimization"
		},
		NumberOfFocalHeightOptimizations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "When optimizing focal height, the number of the optimization samples is aliquoted onto the assay plate for focal height optimization. Each aliquot is used only once to measure signal and adjust the focal height.",
			Category -> "Optics Optimization"
		},
		StartingFocalHeight -> {(*TBU*)
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "When optimizing focal height, the initial focal height to begin the focal height optimization. An optimization sample is first measured using the 'StartingFocalHeight'. The focal height is then increased by a 'FocalHeightStep' and applied to the next optimization sample. If the new signal readout is less than the previous one, the focal height is decreased by a 'FocalHeightStep' from the previous value. Otherwise, the focal height is increased again stepwise. The focal height that leads to the maximum signal is selected.",
			Category -> "Optics Optimization"
		},

		StoreMeasuredPlates -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate if the assay plates are stored after the experiment is completed. If it is True, the plates are stored according to the storage condition of the samples after measurement. If it is False, the plates are discarded after measurement.",
			Category -> "Sample Storage"
		},

		OpticsOptimizationSampleStorage -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[SampleStorageTypeP,Disposal],
			Description -> "The non-default conditions under which the unused 'GainOptimizationSamples' and 'FocalHeightOptimizationSamples' of this experiment should be stored after the protocol is completed. If left unset, 'GainOptimizationSamples' and 'FocalHeightOptimizationSamples' will be stored according to their current StorageCondition.",
			Category -> "Sample Storage"
		}

	}
}];
