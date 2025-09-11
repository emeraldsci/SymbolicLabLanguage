(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, AgaroseGelElectrophoresis], {
	Description->"An agarose gel electrophoresis experiment which separates biological macromolecules acording to their electrophoretic mobility (a combination of size and charge).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PurificationScaleP,
			Description -> "Indicates whether the run is meant to preparatively purify the samples or meant to analyze the purity of the samples.",
			Category -> "General",
			Abstract -> True
		},
		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			Units -> Microliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the volume of sample that is mixed with the Primary and SecondaryLoadingDye before the mixture is loaded into the gel.",
			Category -> "Sample Preparation"
		},
		PrimaryLoadingDyes-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the first dye solution that is mixed with the input sample, SecondaryLoadingDye, and LoadingDilutionBuffer according to the SampleVolumes, LoadingDilutionBufferVolumes, and LoadingDyeVolumes fields.",
			Category -> "Loading"
		},
		SecondaryLoadingDyes-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the second dye solution that is mixed with the input sample, PrimaryLoadingDye, and LoadingDilutionBuffer according to the SampleVolumes, LoadingDilutionBufferVolumes, and LoadingDyeVolumes fields.",
			Category -> "Loading"
		},
		LoadingDyeVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the amount of loading dye that is mixed with the sample and loading buffer according to the SampleVolumes, LoadingDilutionBufferVolumes, and LoadingDyeVolumes fields.",
			Category -> "Loading"
		},
		LoadingDilutionBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the buffer that is mixed with the sample and loading dye according to the SampleVolumes, LoadingDilutionBufferVolumes, and LoadingDyeVolumes fields.",
			Category -> "Loading"
		},
		LoadingDilutionBufferVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the amount loading buffer that is mixed with the sample and loading dye according to the SampleVolumes, LoadingDilutionBufferVolumes, and LoadingDyeVolumes fields.",
         	Category -> "Loading"
      	},
		SampleLoadingVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?VolumeQ,
			Units -> Liter Micro,
			Description -> "The volume of dye-sample mixture that is loaded into each well.",
			Category -> "Loading"
		},
		LoadingPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The plate used to mix ladder, sample, and loading dye before transferring to the lanes of the gels.",
			Category -> "Loading"
		},
		LoadingPlatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of the loading dye, ladders, and samples into the loading plate.",
			Category -> "Loading"
		},
		LoadingPlateManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation] | Object[Protocol, RoboticSamplePreparation],
			Description -> "A sample manipulation protocol used to transfer the loading dye, ladders and samples into the loading plate.",
			Category -> "Loading"
		},
		DestinationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The plate used to collect the samples if Scale is set to Preparative.",
			Category -> "Separation"
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
			Category -> "Loading"
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
			Category -> "Loading"
		},
		Ladder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The ladder to be run with samples on the gel.",
			Category -> "Loading"
		},
		LadderFrequency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[First, FirstAndLast, Null],
			Description -> "The frequency the ladder will be loaded to be run with samples on each gel in Analytical experiments.",
			Category -> "Loading"
		},
		LadderVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of the Ladder that is mixed with the LadderLoadingDyes before a portion of the mixture, the SampleLoadingVolume, is loaded into the gel.",
			Category->"Loading"
		},
		LadderLoadingDyes->{
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The dye solutions that are mixed with the Ladder before a portion of the mixture, the SampleLoadingVolume, is loaded into the gel.",
			Category -> "Loading"
		},
		LadderLoadingDyeVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume each LadderLoadingDyes that is mixed with the Ladder before a portion of the mixture, the SampleLoadingVolume, is loaded into the gel.",
			Category->"Loading"
		},
		LadderStorageCondition -> {
            Format -> Single,
        	Class -> Expression,
        	Pattern :> SampleStorageTypeP | Disposal,
            Description->"The non-default conditions under which any ladder used by this experiment should be stored after the protocol is completed. If left unset, the ladder will be stored according to their Models' DefaultStorageCondition.",
            Category -> "Loading"
        },
		Gels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of SamplesIn, the electrophoresis gel that the sample was run on.",
			IndexMatching -> SamplesIn,
			Category -> "Separation"
		},
		GelModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Model[Item],
			Description -> "The Model of the Gel that the samples are run through in this protocol.",
			Category -> "Separation"
		},
		GelMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GelMaterialP,
			Description -> "The polymer material that the gel is composed of.",
			Category -> "Separation",
			Abstract -> True
		},
		GelPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The polymer density of the gel by percent weight.",
			Category -> "Separation",
			Abstract -> True
		},
		NumberOfGels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of gels run during this experiment.",
			Category -> "Separation"
		},
		NumberOfLanes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of gel lanes run during this experiment.",
			Category -> "Separation"
		},
		SeparationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "If Scale is Analytical, the amount of time that Voltage is applied across the Gel. If Scale is Preparative, the maximum amount of time that Voltage is applied across the Gel before the run is stopped. The actual separation time may be shorter if all bands have been extracted before the SeparationTime has been reached.",
			Category -> "Separation",
			Abstract -> True
		},
		Voltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage of the current applied to the gel during the run.",
			Category -> "Separation",
			Abstract -> True
		},
		DutyCycle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent, 1*Percent, Inclusive -> Right],
			Units -> Percent,
			Description -> "If Scale is Analytical, the percentage of each power cycle that Voltage is applied across the gel. If Scale is Preparative, the maximum percentage of each power cycle that Voltage is applied across the gel.",
			Category -> "Separation",
			Abstract -> True
		},
		CycleDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Second],
			Units -> Micro Second,
			Description -> "The time duration of each power cycle applied to the gel. If duty cycle is less than 100%, this is the period over which the voltage switches on and off once.",
			Category -> "Separation"
		},
		AutomaticPeakDetections->{
			Format->Multiple,
			Class->Expression,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description->"For each member of SamplesIn, indicates if, when Scale -> Preparative, the instrument software will automatically detect and collect the largest peak present between the corresponding MinPeakDetectionSize and MaxPeakDetectionSize.",
			Category->"Separation"
		},
		MinPeakDetectionSizes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*BasePair],
			Units->BasePair,
			IndexMatching -> SamplesIn,
			Description->"For each member of SamplesIn, the lower bound, in base pairs, of the range the instrument software searches for a peak to collect when the Scale is Preparative and the corresponding member of AutomaticPeakDetections is True.",
			Category->"Separation"
		},
		MaxPeakDetectionSizes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*BasePair],
			Units->BasePair,
			IndexMatching -> SamplesIn,
			Description->"For each member of SamplesIn, the upper bound, in base pairs, of the range the instrument software searches for a peak to collect when the Scale is Preparative and the corresponding member of AutomaticPeakDetections is True.",
			Category->"Separation"
		},
		CollectionSizes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*BasePair],
			Units->BasePair,
			IndexMatching -> SamplesIn,
			Description->"For each member of SamplesIn, the size of the sample, in base paris, to collect in the ExtractionVolume when Scale is Preparative and the corresponding member of AutomaticPeakDetections is False.",
			Category->"Separation"
		},
		MinCollectionRangeSizes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*BasePair],
			Units->BasePair,
			IndexMatching -> SamplesIn,
			Description->"For each member of SamplesIn, the lower bound, in base pairs, of the range of Oligomers to collect in the ExtractionVolume when the corresponding member of AutomaticPeakDetections is True and the corresponding member of CollectionSizes is Null.",
			Category->"Separation"
		},
		MaxCollectionRangeSizes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*BasePair],
			Units->BasePair,
			IndexMatching -> SamplesIn,
			Description->"For each member of SamplesIn, the upper bound, in base pairs, of the range of Oligomers to collect in the ExtractionVolume when the corresponding member of AutomaticPeakDetections is True and the corresponding member of CollectionSizes is Null.",
			Category->"Separation"
		},
		ExtractionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Microliter],
			Units->Microliter,
			Description->"The total volume of sample-containing buffer that is removed from the gel for each input sample. The ExtractionVolume is either centered around the largest peak between the MinPeakDetectionSize and MaxPeakDetectionSize, centered around the CollectionSize, or spans the MinCollectionRangeSize and MaxCollectionRangeSize, depending on the method of peak selection chosen.",
			Category->"Separation"
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
			Category -> "General"
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
		LadderData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Data for all lanes for featuring the sample in the Ladder field generated by this protocol.",
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
		},
		ExposureTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The amounts of time for which a camera shutter stays open for each set of gel images.",
			Category -> "Imaging"
		},
		ExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelengths of light used to excite the gel for fluorescence images.",
			Category -> "Imaging"
		},
		ExcitationBandwidths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			IndexMatching -> ExcitationWavelengths,
			Description -> "For each member of ExcitationWavelengths, the range in wavelengths centered around the ExcitationWavelength that the excitation filter allows through at 50% of the maximum transmission.",
			Category -> "Imaging"
		},
		EmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelengths at which fluorescence emitted from the gels was for fluorescence images.",
			Category -> "Imaging"
		},
		EmissionBandwidths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			IndexMatching -> EmissionWavelengths,
			Description -> "For each member of EmissionWavelengths, the range in wavelengths centered around the EmissionWavelength that the emission allows to pass through at 50% of the maximum transmission.",
			Category -> "Imaging"
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
		}
	}
}];
