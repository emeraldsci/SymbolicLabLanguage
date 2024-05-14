

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, AlphaScreen], {
	Description->"Protocol for AlphaScreen measurement of the samples. The samples contain analytes with acceptor and donor AlphaScreen beads. Upon laser excitation at 680nm to the donor AlphaScreen beads, singlet Oxygen is produced and diffuses to the acceptor AlphaScreen beads only when the two beads are in close proximity. The acceptor AlphaScreen beads react with the singlet Oxygen and emit light signal at 570nm which is captured by a detector in plate reader. A plate which contains the AlphaScreen beads and analytes loaded are provided as input and the plate is excited directly and measured in the plate reader. Alternatively, prepared samples may be provided and transferred to an assay plate for AlphaScreen measurement along with control samples for signal normalization.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(*General*)
		PreparedPlate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the SamplesIn are from a prepared plate. The prepared plate contains the analytes, acceptor and donor AlphaScreen beads that are ready to be excited by AlphaScreen laser for luminescent AlphaScreen measurement in a plate reader. If the 'PreparedPlate' option is False, the samples that contain all the components will be transferred to the 'AssayPlate' for AlphaScreen measurement.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,PlateReader],
				Object[Instrument,PlateReader]
			],
			Description -> "The plate reader that equipped with AlphaScreen optic module for excitation and signal measurement.",
			Category -> "General",
			Abstract -> True
		},
		AssayPlates -> {
			Format -> Multiple, (*More than one plate can be provided/used. We have automatic resolution for the AssayPlate options. Do we need to indicate more than one plate?*)
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Plate],
				Object[Container,Plate]
			],
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
		(*NumberOfReplicates is in shared fields. How about its category?*)
		(*optic Optimization*)
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
		GainOptimizationSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "When optimizing gain, the list of samples used for gain optimization. If PreparedPlate->False, one optimization sample should be specified and the sample is aliquoted equal to the 'NumberOfGainOptimizations' option. If PreparedPlate->True, the optimization samples should be in the provided plate. Each aliquot is used only once to measure signal and adjust the gain.",
			Category -> "Optics Optimization"
		},
		GainOptimizationSamplesWell->{
			Format -> Multiple,
			Class -> {Link,Link,String},
			Pattern :> {_Link,_Link,WellP},
			Relation -> {Object[Sample],Object[Container],Null},
			Description -> "When optimizing gain, the container and well that contain the gain optimization sample.",
			Headers -> {"Sample","Container","Well"},
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
		(*move this to data*)
		OptimizeGainValues -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0 Microvolt],RangeP[0 Percent, 100 Percent]}, (*how do we represent over-saturation?*)
			Units -> {Microvolt,Percent},
			Description -> "The gain values and the saturation percentages of their signal readouts during the gain optimization process.",
			Headers -> {"Gain","Saturation Percentage"},
			Category -> "Optics Optimization"
		},
		OptimizeFocalHeight -> { (*TBU*)
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if focal height value is optimized prior to the gain optimization before the plate reader measurement.",
			Category -> "Optics Optimization"
		},
		FocalHeightOptimizationSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "When optimizing focal height, the list of samples used for focal height optimization. If PreparedPlate->False, one optimization sample should be specified and the sample is aliquoted equal to the 'NumberOfFocalHeightOptimizations' option. If PreparedPlate->True, the optimization samples should be in the provided plate. Each aliquot is used only once to measure signal and adjust the focal height.",
			Category -> "Optics Optimization"
		},
		FocalHeightOptimizationSamplesWell->{
			Format -> Multiple,
			Class -> {Link,Link,String},
			Pattern :> {_Link,_Link,WellP},
			Relation -> {Object[Sample],Object[Container],Null},
			Description -> "When optimizing gain, the container and well that contain the focal height optimization sample.",
			Headers -> {"Sample","Container","Well"},
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
		(*move this to data*)
		OptimizeFocalHeightValues -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0 Millimeter],GreaterEqualP[0 RLU]},
			Units -> {Millimeter,RLU},
			Description -> "The focal height values and their signal readouts during the focal height optimization process.",
			Headers -> {"Focal Height","Luminescent Intensity"},
			Category -> "Optics Optimization"
		},
		OpticsOptimizationSampleStorage ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "To store any unused samples, the storage condition under which the gain and focal height optimization sample should be stored after its usage in this experiment.",
			Category -> "Optics Optimization"
		},
		OpticsOptimizationContainer->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Plate],
				Object[Container,Plate]
			],
			Description -> "The plate that is measured in plate reader which contains the optics optimization samples.",
			Category -> "Optics Optimization",
			Developer -> True
		},
		GainOptimizationPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the loading of gain optimization samples into the plates.",
			Category -> "Optics Optimization",
			Developer -> True
		},
		GainOptimizationManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The manipulations protocol used to load gain optimization samples into the plates.",
			Category -> "Optics Optimization",
			Developer -> True
		},
		GainOptimizationMethodFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The set of file paths for the executable files that set the plate reader parameters and run the experiment for AlphaScreen gain optimization.",
			Category -> "Optics Optimization", (*Sort the order of the category*)
			Developer -> True
		},
		GainOptimizationDataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The set of file names of the exported raw data file from plate reader for AlphaScreen gain optimization.",
			Category -> "Optics Optimization",
			Developer -> True
		},
		GainOptimizationData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Any data generated for gain optimization.",
			Category -> "Optics Optimization",
			Developer -> True
		},
		FocalHeightOptimizationPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the loading of focal height optimization samples into the plates.",
			Category -> "Optics Optimization",
			Developer -> True
		},
		FocalHeightOptimizationManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The manipulations protocol used to load focal height optimization samples into the plates.",
			Category -> "Optics Optimization",
			Developer -> True
		},
		FocalHeightOptimizationMethodFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The set of file paths for the executable files that set the plate reader parameters and run the experiment for AlphaScreen focal height optimization.",
			Category -> "Optics Optimization", (*Sort the order of the category*)
			Developer -> True
		},
		FocalHeightOptimizationDataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The set of file names of the exported raw data file from plate reader for AlphaScreen focal height optimization.",
			Category -> "Optics Optimization",
			Developer -> True
		},
		FocalHeightOptimizationData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Any data generated for gain optimization.",
			Category -> "Optics Optimization",
			Developer -> True
		},
		(*Sample handling*)
		MoatSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of concentric perimeters of wells which should be filled with moat buffer when setting Moat wells to decrease evaporation from samples during the experiment.",
			Category -> "Sample Handling"
		},
		MoatVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of moat buffer should be added to each moat well.",
			Category -> "Sample Handling"
		},
		MoatBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The buffer which should be used to fill each moat well.",
			Category -> "Sample Handling"
		},
		MoatPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "For each member of AssayPlates, a set of instructions specifying the loading of moat into the plates.",
			Category -> "Sample Handling",
			IndexMatching -> AssayPlates,
			Developer -> True
		},
		MoatManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The manipulations protocol used to load moat into the plates.",
			Category -> "Sample Handling"
		},
		(* AssayPlateLoadingPrimitives and AssayPlateLoadingSampleManipulation are reserved fields for automatic plate loading *)
		AssayPlateLoadingPrimitives -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {{SampleManipulationP..}..},
			Description -> "A set of instructions specifying the loading and reading of plate in the plate reader.",
			Category -> "Sample Handling",
			Developer -> True
		},
		AssayPlateLoadingSampleManipulation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The manipulation protocols used to load and read plates in the plate reader.",
			Category -> "Sample Handling",
			Developer -> True
		},
		(*Optics*)
		ReadTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "The temperature at which the measurement of each plate will be taken in the plate reader.",
			Category -> "Optics"
		},
		ReadEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The length of time for which the assay plates equilibrate at the assay temperature in the plate reader before being read.",
			Category -> "Optics"
		},
		PlateReaderMix -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if samples should be mixed inside the plate reader chamber before the samples are read.",
			Category -> "Optics"
		},
		PlateReaderMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the samples in each plate are mixed inside the plate reader chamber before the samples are read.",
			Category -> "Optics"
		},
		PlateReaderMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The rate at which each plate is agitated inside the plate reader chamber before the samples are read.",
			Category -> "Optics"
		},
		PlateReaderMixMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MechanicalShakingP,
			Description -> "The pattern of motion which should be employed to shake each plate before the samples are read.",
			Category -> "Optics"
		},
		PlateReaderMixSchedule -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MixingScheduleP,
			Description -> "The time points at which mixing should occur for each plate in the plate reader.",
			Category -> "Optics"
		},
		Gain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microvolt],
			Units -> Microvolt,
			Description -> "The gain which should be applied to the signal reaching the primary detector photomultiplier tube (PMT). This is specified as a direct voltage.",
			Category -> "Optics"
		},
		FocalHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The distance from the focal point to the lens that collect the light to the primary detector photomultiplier tube (PMT).",
			Category -> "Optics"
		},
		AutoFocalHeight -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the FocalHeight will be determined automatically by the liquid handler.",
			Category -> "Optics"
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
		PlateCover -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Lid],
				Object[Item,Lid]
			],
			Description -> "The plate seal or lid on the assay container that is left on during reads to decrease evaporation. It is strongly recommended not to retain a cover because AlphaScreen can only read from top.",
			Category -> "Optics"
		},
		ReadDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadDirectionP,
			Description -> "The order in which wells should be read by specifying the plate path the instrument should follow when measuring signal.",
			Category -> "Optics"
		},
		(*Other*)
		(*SamplesInStorage is a shared field*)
		StoreMeasuredPlates -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate if the assay plates are stored after the experiment is completed. If it is True, the plates are stored according to the storage condition of the samples after measurement. If it is False, the plates are discarded after measurement.",
			Category -> "Sample Storage"
		},
		MinCycleTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The minimum duration of time each measurement will take, as determined by the Plate Reader software.",
			Category -> "Cycling",
			Developer -> True
		},
		MethodFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of AssayPlates, the file path for the executable file that sets the plate reader parameters and runs the experiment for AlphaScreen assay measurement.",
			Category -> "General",
			IndexMatching -> AssayPlates,
			Developer -> True
		},
		DataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of AssayPlates, the file name of the exported raw data file from plate reader for AlphaScreen assay measurement.",
			Category -> "General",
			IndexMatching -> AssayPlates,
			Developer -> True
		}
	}
}];
