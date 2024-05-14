(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, NMR], {
	Description -> "A nuclear magnetic resonance (NMR) experiment where samples are irradiated with radio-frequency light in a strong magnetic field in order to obtain structural information.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Nuclei -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> NucleusP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the nucleus whose spins were resonated in this experiment.",
			Category -> "General"
		},
		DeuteratedSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the deuterated solvent in which the provided samples were dissolved in prior to taking their spectra.",
			Category -> "General"
		},
		SolventVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			IndexMatching -> DeuteratedSolvents,
			Description -> "For each member of DeuteratedSolvents, the amount of the specified Solvent to add to the sample, the combination of which was read in the NMR spectrometer.",
			Category -> "General"
		},
		SampleAmounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0*Milliliter] | GreaterP[0*Milligram] | GreaterP[0 Unit, 1 Unit],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the amount of sample or aliquot that was dissolved in the specified DeuteratedSolvent.",
			Category -> "General"
		},
		SampleTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the temperature at which the sample was held prior to and during data collection.",
			Category -> "General"
		},
		NumberOfScans -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of pulse and read cycles that are averaged together that are applied to each sample.",
			Category -> "General"
		},
		NumberOfDummyScans -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of scans performed before the receiver is turned on and data is collected.",
			Category -> "General"
		},
		AcquisitionTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the length of time during which the NMR signal was sampled and digitized per scan.",
			Category -> "General"
		},
		RelaxationDelays -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description ->  "For each member of SamplesIn, the length of time before the pulse and acquisition of a given scan.  In effect, this is also the length of time after the AcquisitionTime before the next scan begins.",
			Category -> "General"
		},
		PulseWidths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millisecond],
			Units -> Millisecond,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the length of time during which the radio frequency pulse is turned on and the sample was irradiated per scan, assuming a 90 degree pulse.",
			Category -> "General"
		},
		FlipAngles -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 AngularDegree],
			Units -> AngularDegree,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the angle of rotation of the first radio frequency pulse.",
			Category -> "General"
		},
		SpectralDomains -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {UnitsP[PPM], UnitsP[PPM]},
			Units -> {PPM, PPM},
			Headers -> {"Minimum Chemical Shift", "Maximum Chemical Shift"},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the range of the observed frequencies for a given spectrum.",
			Category -> "General"
		},
		WaterSuppression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> WaterSuppressionMethodP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates the method by which the water peak is eliminated from the spectrum.",
			Category -> "General"
		},
		TimeIntervals -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the length of time between the start of each scan.",
			Category -> "General"
		},
		NumberOfTimeIntervals -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number spectra to collect spaced by the length of time in the TimeIntervals field.",
			Category -> "General"
		},
		TotalTimeCourses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the total duration during which scans are taken according to the TimeIntervals field.",
			Category -> "General"
		},
		ProbeTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the temperature at which the probe coils that surround the NMR tube were held during data collection.",
			Category -> "General"
		},
		NMRTubes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel], Object[Container, Vessel]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the NMR tube in which the provided sample was placed prior to data collection.",
			Category -> "General"
		},
		DepthGauge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, NMRDepthGauge] | Object[Part, NMRDepthGauge],
			Description -> "The part used to set the depth of an NMR tube that does not go into the NMRTubeRack so as to center the sample in the coil.",
			Category -> "General",
			Developer -> True
		},
		NMRSpinners -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, NMRSpinner] | Object[Container, NMRSpinner],
			IndexMatching -> NMRTubes,
			Description -> "For each member of NMRTubes, the containers that hold individual NMR tubes so as to center the sample in the coil.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, NMR] | Model[Instrument, NMR],
			Description -> "The instrument used to measure the nuclear magnetic resonance of samples.",
			Category -> "General"
		},
		UseExternalStandards -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicate if an external standard in a coaxial insert will be used.",
			Category -> "General"
		},
		SealedCoaxialInserts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel] | Object[Container, Vessel],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the container contains the external standard and is inserted inside the NMRTube.",
			Category -> "General"
		},
		SealedCoaxialInsertContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Bag] | Object[Container, Bag],
			IndexMatching -> SealedCoaxialInserts,
			Description -> "For each member of SealedCoaxialInserts, the container with barcode to store the SealedCoaxialInserts.",
			Category -> "General",
			Developer -> True
		},
		ExternalStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the sample used as an external standard during the experiment. This sample stored in a sealed coaxial insert and was measrued together with SamplesIn.",
			Category -> "General"
		},
		InsertWashWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel] | Object[Container, Vessel],
			Description -> "The container use to temporally store the waste generated by washing SealedCoaxialInserts.",
			Category -> "General",
			Developer -> True
		},
		Tweezer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The metal tweezer used to transfer CoaxialInserts.",
			Category -> "General"
		},
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, FumeHood], Object[Instrument, FumeHood]],
			Description -> "Indicates the fume hood where the SealedCoaxialInserts are transferred into the NMRTubes.",
			Category -> "General",
			Developer -> True
		},
		NMRTubeRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack]
			],
			Description -> "The rack that holds the NMR tubes that will be put onto the instrument for data collection.",
			Category -> "General",
			Developer -> True
		},
		AutosamplerDeckModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Deck],
			Description -> "The model of the NMR autosampler deck.",
			Category -> "General",
			Developer -> True
		},
		SealedCoaxialInsertsTubePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "A list of placements used to move the sealed coaxial inserts into the NMR tubes.",
			Headers -> {"Sealed Coaxial Inserts to Place", "Target NMR Tube", "Placement Position"},
			Category -> "Placements",
			Developer -> True
		},
		SealedCoaxialInsertsBagPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "A list of placements used to move the sealed coaxial inserts back to the storage bag.",
			Headers -> {"Sealed Coaxial Inserts to Place", "Target NMR Tube", "Placement Position"},
			Category -> "Placements",
			Developer -> True
		},
		NMRTubePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "A list of placements used to move the NMR tubes onto the NMR tube rack or into the spinners.",
			Headers -> {"NMR Tube to Place", "NMR Tube Destination", "Placement Position"},
			Category -> "Placements",
			Developer -> True
		},
		NMRTubeRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move the NMR tube racks onto the NMR autosampler.",
			Headers -> {"NMR Tube Rack to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		NMRTubePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfers of samples into the NMR tubes.",
			Category -> "General",
			Developer -> True
		},
		NMRTubeManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "A sample manipulation protocol used to transfer samples into the NMR tubes.",
			Category -> "General"
		},
		SampleRecoveryPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfers of samples from the NMR tubes back into storable containers.",
			Category -> "General",
			Developer -> True
		},
		SampleRecoveryManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "A sample manipulation protocol used to transfer samples from the NMR tubes back into storable containers.",
			Category -> "General",
			Developer -> True
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the file necessary for the instrument to load its method file and execute this protocol.",
			Category -> "General",
			Developer -> True
		},
		DataFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of SamplesIn, the file paths where the processed NMR data files are located.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		DataCollectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The estimated completion time for the collection of NMR data.",
			Category -> "General",
			Developer -> True
		}
	}
}];
