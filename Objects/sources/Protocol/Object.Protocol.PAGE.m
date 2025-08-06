(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, PAGE], {
	Description->"A polyacrylamide gel electrophoresis (PAGE) experiment which separate biological macromolecules acording to their electrophoretic mobility (a combination of size and charge).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			Units -> Microliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the volume of sample that is mixed with the LoadingBuffer before a portion of the mixture, the SampleLoadingVolume, is loaded into the gel.",
			Category -> "Sample Preparation"
		},
		LoadingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The buffer that is mixed with the input samples before a portion of the mixture, the SampleLoadingVolume, is loaded into the gel.",
			Category -> "Sample Preparation"
		},
		LoadingBufferVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the amount of LoadingBuffer that is mixed with a SampleVolume amount of the input sample before a portion of the mixture, the SampleLoadingVolume, is loaded into the gel.",
			Category -> "Sample Preparation"
		},
		Ladder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The ladder that is run with samples on the gel.",
			Category -> "Sample Preparation"
		},
		LadderVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of the Ladder that is mixed with the LoadingBuffer before a portion of the mixture, the SampleLoadingVolume, is loaded into the gel.",
			Category->"Sample Preparation"
		},
		LadderLoadingBuffer->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The buffer that is mixed with the Ladder before a portion of the mixture, the SampleLoadingVolume, is loaded into the gel.",
			Category -> "Sample Preparation"
		},
		LadderLoadingBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of the LadderLoadingBuffer that is mixed with the Ladder before a portion of the mixture, the SampleLoadingVolume, is loaded into the gel.",
			Category->"Sample Preparation"
		},
		SampleLoadingVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?VolumeQ,
			Units -> Liter Micro,
			Description -> "The volume of dye-sample mixture that is loaded into each well.",
			Category -> "Sample Preparation"
		},
		LadderMixing -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
			Description -> "The protocol(s) used to mix the ladder sample(s) before transferring samples into the loading plate.",
			Category -> "Sample Preparation"
		},
		LadderCentrifugations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Alternatives[Object[Protocol,Centrifuge],Object[Protocol,ManualSamplePreparation]],
			Description -> "The protocol(s) used to centrifuge the ladder sample(s) before transferring samples into the loading plate.",
			Category -> "Sample Preparation"
		},
		LoadingPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The plate used to mix ladder, sample, and loading buffer before transferring to the lanes of the gels.",
			Category -> "Sample Preparation"
		},
		LoadingPlateManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "A sample manipulation protocol used to transfer the loading buffer, ladders and samples into the loading plate.",
			Category -> "Sample Preparation"
		},
		LoadingPlatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of the loading buffer, ladders, and samples into the loading plate.",
			Category -> "Staining & Imaging"
		},
		SampleDenaturing->{
			Format->Single,
			Class->Expression,
			Pattern :> BooleanP,
			Description->"Indicates if the mixtures of input samples and loading buffer are heated prior electrophoresis.",
			Category->"Denaturation"
		},
		DenaturingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The temperature which the mixture of input samples and loading buffer is heated to before prior to electrophoresis.",
			Category->"Denaturation"
		},
		DenaturingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The duration for which the mixture of input samples and loading buffer is heated to DenaturingTemperature prior to electrophoresis.",
			Category->"Denaturation"
		},
		PipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "Pipette tips used to prepare the loading plate for the protocol.",
			Category -> "Sample Preparation"
		},
		PrimaryPipetteTips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "Pipette tips used by the Instrument to load the contents of the LoadingPlate into the Gels.",
			Category -> "Running the Gel"
		},
		SecondaryPipetteTips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "If necessary, an additional set of pipette tips used by the Instrument to load the contents of the LoadingPlate into the Gels.",
			Category -> "Running the Gel"
		},
		Gels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of SamplesIn, the electrophoresis gel that the sample is run on.",
			IndexMatching -> SamplesIn,
			Category -> "Running the Gel"
		},
		GelModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Model[Item],
			Description -> "The model of the type of gel that the samples are separated on.",
			Category -> "Running the Gel"
		},
		GelMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GelMaterialP,
			Description -> "The polymer material that the gel is composed of.",
			Category -> "Running the Gel",
			Abstract -> True
		},
		GelPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The polymer density of the gel by percent weight.",
			Category -> "Running the Gel",
			Abstract -> True
		},
		CrosslinkerRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The weight ratio of acrylamide monomer to bis-acrylamide crosslinker used to prepare the gel.",
			Category -> "Running the Gel"
		},
		DenaturingGel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the gel contains additives that disrupt the secondary structure of macromolecules.",
			Category -> "Running the Gel"
		},
		NumberOfGels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of gels run during this experiment.",
			Category -> "Running the Gel"
		},
		NumberOfLanes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 80, 1],
			Units -> None,
			Description -> "The number of gel lanes run during this experiment.",
			Category -> "Running the Gel"
		},
		GelBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The buffer used to wet the gels during electrophoresis.",
			Category -> "Running the Gel"
		},
		ReservoirBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The buffer used to fill the end reservoirs of the gel cassettes.",
			Category -> "Running the Gel"
		},
		GelBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The volume of buffer that is used to wet the gels during eletrophoresis.",
			Category -> "Instrument Setup"
		},
		ReservoirBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The volume of buffer that is poured into each of the end reservoirs of the gel cassettes.",
			Category -> "Instrument Setup"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to apply current for this electrophoresis experiment.",
			Category -> "Running the Gel"
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path where the electrophoresis method files are located.",
			Category -> "General",
			Developer -> True
		},
		ElectrodeCleaningVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect liquid run-off as the electrodes are cleaned.",
			Category -> "Cleaning",
			Developer -> True
		},
		AspirationVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The vessel used to collect liquid waste as it is aspirated off of the gels during cleanup.",
			Category -> "Cleaning",
			Developer -> True
		},
		SeparationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The amount of time a voltage is applied across the gel.",
			Category -> "Running the Gel",
			Abstract -> True
		},
		Voltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage of the current applied to the gel during the run.",
			Category -> "Running the Gel",
			Abstract -> True
		},
		DutyCycle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent, 1*Percent, Inclusive -> Right],
			Units -> Percent,
			Description -> "The percentage of each power cycle that voltage is applied to the gel.",
			Category -> "Running the Gel",
			Abstract -> True
		},
		CycleDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Second],
			Units -> Micro Second,
			Description -> "The time duration of each power cycle applied to the gel. If duty cycle is less than 100%, this is the period over which the voltage switches on and off once.",
			Category -> "Running the Gel"
		},
		PostRunStaining->{
			Format->Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the gel is incubated with the StainingSolution after electrophoresis in order to visualize the analytes.",
			Category -> "Staining & Imaging"
		},
		PrewashingSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to rinse the gel after electrophoresis before staining.",
			Category -> "Staining & Imaging"
		},
		PrewashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The amount of PrewashingSolution that is added to each gel after electrophoresis before staining.",
			Category -> "Staining & Imaging"
		},
		PrewashingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time the post-electrophoresis PrewashingSolution is incubated with the gel.",
			Category -> "Staining & Imaging"
		},
		StainingSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to stain the gel in order to visualize the analytes.",
			Category -> "Staining & Imaging"
		},
		StainVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The amount of StainingSolution that is added to each gel after electrophoresis.",
			Category -> "Staining & Imaging"
		},
		StainingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time the post-electrophoresis stain is incubated with the gel.",
			Category -> "Staining & Imaging"
		},
		RinsingSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to rinse the gels after stain incubation.",
			Category -> "Staining & Imaging"
		},
		RinseVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The amount of RinsingSolution that is added to each gel after staining to remove .",
			Category -> "Staining & Imaging"
		},
		RinsingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time the post-electrophoresis RinsingSolution is incubated with the gel after the StainingSolution.",
			Category -> "Staining & Imaging"
		},
		NumberOfRinses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of times the RinsingSolution will be added to each gel, incubated for the RinsingTime, and removed, before the gel images are taken.",
			Category -> "Running the Gel"
		},
		StainReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The reservoir plate used to store staining solution and rinsing solution, if required.",
			Category -> "Staining & Imaging"
		},
		RinseReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The reservoir plate used to store additional RinsingSolution, if required.",
			Category -> "Staining & Imaging"
		},
		SecondaryRinseReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The reservoir plate used to store PrewashingSolution and additional RinsingSolution, if required.",
			Category -> "Staining & Imaging"
		},
		WasteReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The reservoir plate used for collecting buffer waste.",
			Category -> "Staining & Imaging"
		},
		SecondaryWasteReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The reservoir plate used for collecting buffer waste.",
			Category -> "Staining & Imaging"
		},
		GelBufferTransferVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The vessel used to transfer gel buffer from a source bottle to the gel.",
			Category -> "Staining & Imaging"
		},
		ReservoirBufferTransferVessel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The vessel used to transfer reservoir buffer from a source bottle into the cassette reservoirs.",
			Category -> "Staining & Imaging"
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the gel for a fluorescence image.",
			Category -> "Staining & Imaging"
		},
		ExcitationBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The range in wavelengths centered around the excitation wavelength that the excitation filter allows to pass through at 50% of the maximum transmission.",
			Category -> "Staining & Imaging"
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which fluorescence emitted from the gel is captured for a fluorescence image.",
			Category -> "Staining & Imaging"
		},
		EmissionBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The range in wavelengths centered around the emission wavelength that the emission filter allows to pass through at 50% of the maximum transmission.",
			Category -> "Staining & Imaging"
		},
		LowExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The shortest length of time for which a camera shutter stayed open for each gel image.",
			Category -> "Staining & Imaging"
		},
		MediumLowExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The second shortest length of time for which a camera shutter stayed open for each gel image.",
			Category -> "Staining & Imaging"
		},
		MediumHighExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The second longest amount of time for which a camera shutter stayed open for each gel image.",
			Category -> "Staining & Imaging"
		},
		HighExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The longest amount of time for which a camera shutter stayed open for each gel image.",
			Category -> "Staining & Imaging"
		},
		ExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The amount of time for which a camera shutter stayed open for each gel image.",
			Category -> "Staining & Imaging"
		},
		ReservoirPlateManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "A sample manipulation protocol used to transfer the stain and rinse solutions into the stain reservoir.",
			Category -> "Staining & Imaging"
		},
		ReservoirPlatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of individual components required to prepare the stain and rinse solutions.",
			Category -> "Staining & Imaging"
		},
		LadderStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The storage condition under which the Ladder should be stored after its usage in the experiment.",
			Category->"Sample Storage"
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path where the electrophoresis data files are located.",
			Category -> "General",
			Developer -> True
		},
		DataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The compressed folder containing the raw and processed data generated by the instrument, as well as method information.",
			Category -> "Experimental Results"
		},
		LadderData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Data for ladder lanes generated by this protocol.",
			Category -> "Experimental Results"
		},
		DeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Object[Item], Null},
			Description -> "A list of container placements to set up the electrophoresis instrument deck.",
			Category -> "Placements",
			Headers -> {"Container", "Placement Tree"},
			Developer -> True
		}
	}
}];
