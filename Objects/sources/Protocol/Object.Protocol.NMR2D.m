(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, NMR2D], {
	Description -> "A two-dimensional nuclear magnetic resonance (NMR) experiment where samples are irradiated with radio-frequency light in a strong magnetic field in order to obtain structural information.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
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
			Description -> "For each member of SamplesIn, the number of pulse and read cycles that are averaged together that are applied for each directly measured free induction decay (FID).",
			Category -> "General"
		},
		NumberOfDummyScans -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of scans performed before the receiver is turned on and data is collected for each directly measured free induction decay (FID).",
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
		NMRTubeReplicates -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the NMR tube in which the provided sample was placed is a duplicate. The first instance of the duplicates is marked False while the rest is marked True.",
			Category -> "General",
			Developer -> True
		},
		StickerSheet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Consumable] | Model[Item, Consumable],
			Description -> "A book of laminated sheets that is used to collect the object stickers for NMR tubes going into the instrument. The stickers of NMR tubes are taken off temporarily and collected in this book, and restickered after the measurement is done, because loading NMR tubes with stickers into the NMR instrument can lead to bad shimming, compromised data quality, and even broken tubes inside NMR historically.",
			Developer -> True,
			Category -> "General"
		},
		RackedNMRTubeStickerPositions -> {
			Format -> Multiple,
			Class -> {Integer, String},
			Pattern :> {GreaterP[0], _String},
			Headers -> {"Page", "Slot Name"},
			Description -> "For each member of RackedNMRTubePlacements, indicates the page number and the slot on the StickerSheet book where the sticker of the racked NMR tube is collected temporarily.",
			Developer -> True,
			IndexMatching -> RackedNMRTubePlacements,
			Category -> "General"
		},
		UnrackedNMRTubeStickerPositions -> {
			Format -> Multiple,
			Class -> {Integer, String},
			Pattern :> {GreaterP[0], _String},
			Headers -> {"Page", "Slot Name"},
			Description -> "For each member of UnrackedNMRTubeLoadingPlacements, indicates the page number and the slot on the StickerSheet book where the sticker of the unracked NMR tube is collected temporarily.",
			Developer -> True,
			IndexMatching -> UnrackedNMRTubeLoadingPlacements,
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
		ShimmingStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The standard sample used to perform 3D shimming if a probe change is required.",
			Category -> "General",
			Developer -> True
		},
		ShimmingStandardSpinner -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, NMRSpinner] | Object[Container, NMRSpinner],
			Description -> "The container that holds the ShimmingStandard NMR tube.",
			Category -> "General",
			Developer -> True
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, NMR] | Model[Instrument, NMR],
			Description -> "The instrument used to measure the nuclear magnetic resonance of samples.",
			Category -> "General"
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
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, FumeHood], Model[Instrument, FumeHood], Object[Instrument, HandlingStation, FumeHood], Model[Instrument, HandlingStation, FumeHood]],
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
		Probe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, NMRProbe],
				Object[Part, NMRProbe]
			],
			Description -> "The part inserted into the NMR that excites nuclear spins, detects the signal, and collects data.",
			Category -> "General"
		},
		NucleusConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Part, NMRProbe],Null},
			Description -> "The connection information for attaching cables to the nucleus ports of the probe prior to data collection.",
			Headers -> {"Probe Cable","Probe Cable Connector Name","Probe","Probe Port Name"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		HeaterConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Part, NMRProbe],Null},
			Description -> "The connection information for attaching cables to the heater ports of the probe prior to data collection.",
			Headers -> {"Probe Cable","Probe Cable Connector Name","Probe","Probe Port Name"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		PicsConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Part, NMRProbe],Null},
			Description -> "The connection information for attaching cables to the pics ports of the probe prior to data collection.",
			Headers -> {"Probe Cable","Probe Cable Connector Name","Probe","Probe Port Name"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		ExhaustConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Part, NMRProbe],Null},
			Description -> "The connection information for attaching cables to the exhaust ports of the probe prior to data collection.",
			Headers -> {"Probe Cable","Probe Cable Connector Name","Probe","Probe Port Name"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		SystemDefaultNucleusConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Part, NMRProbe],Null},
			Description -> "The connection information for attaching cables to the nucleus ports of the NMR's default probe after data collection.",
			Headers -> {"Probe Cable","Probe Cable Connector Name","Probe","Probe Port Name"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		SystemDefaultHeaterConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Part, NMRProbe],Null},
			Description -> "The connection information for attaching cables to the heater ports of the NMR's default probe after data collection.",
			Headers -> {"Probe Cable","Probe Cable Connector Name","Probe","Probe Port Name"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		SystemDefaultPicsConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Part, NMRProbe],Null},
			Description -> "The connection information for attaching cables to the pics ports of the NMR's default probe after data collection.",
			Headers -> {"Probe Cable","Probe Cable Connector Name","Probe","Probe Port Name"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		SystemDefaultExhaustConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Part, NMRProbe],Null},
			Description -> "The connection information for attaching cables to the exhaust ports of the NMR's default probe after data collection.",
			Headers -> {"Probe Cable","Probe Cable Connector Name","Probe","Probe Port Name"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		ProbeDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Instrument] | Object[Instrument], Null},
			Description -> "The destination information for the disconnected probe cables.",
			Headers -> {"Instrument", "Position"},
			Category -> "Plumbing Information",
			Developer -> True
		},
		ExperimentTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> NMR2DExperimentP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the spectroscopic method used to obtain the 2D NMR spectrum.",
			Category -> "General"
		},
		DirectNuclei -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> NucleusP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the nucleus whose spectrum is measured repeatedly and directly over the course of the experiment.  This is sometimes referred to as the f2 or T2 nucleus, and is displayed on the horizontal axis of the output plot.",
			Category -> "General"
		},
		IndirectNuclei -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> NucleusP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the nucleus whose spectrum is measured through the modulation of the directly-measured 1H spectrum as a function of time rather than directly-measured. This is sometimes referred to as the f1 or T1 nucleus, and is displayed on the vertical axis of the output plot.",
			Category -> "General"
		},
		DirectNumberOfPoints -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of data points collected for each directly-measured free induction decay (FID). A higher value represents in observation of the FID for a longer length of time and thus an increase of signal-to-noise in the direct dimension.",
			Category -> "General"
		},
		DirectAcquisitionTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the length of time during which the NMR signal is sampled and digitized per scan.",
			Category -> "General"
		},
		DirectSpectralDomains -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {UnitsP[PPM], UnitsP[PPM]},
			Units -> {PPM, PPM},
			Headers -> {"Minimum Chemical Shift", "Maximum Chemical Shift"},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the range of the observed frequencies for the directly-observed nucleus.",
			Category -> "General"
		},
		IndirectNumberOfPoints -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of directly-measured free induction decays (FIDs) collected that together constitute the FIDs of the indirectly-measured nucleus.",
			Category -> "General"
		},
		IndirectSpectralDomains -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {UnitsP[PPM], UnitsP[PPM]},
			Units -> {PPM, PPM},
			Headers -> {"Minimum Chemical Shift", "Maximum Chemical Shift"},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the range of the observed frequencies for the indirectly-observed nucleus.",
			Category -> "General"
		},
		TOCSYMixTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[Millisecond],
			Units -> Millisecond,
			IndexMatching -> ExperimentTypes,
			Description -> "For each member of ExperimentTypes, the duration of the spin-lock sequence prior to data collection for TOCSY, HSQCTOCSY, and HMQCTOCSY.",
			Category -> "General"
		},
		SamplingMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> NMRSamplingMethodP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the method of spacing the directly-measured Free Induction Decays (FIDs) to create the 2D spectrum.  TraditionalSampling spaces the directly-measured spectra uniformly, but because of the FID's periodicity, this collects a lot of redundancy.  NonUniformSampling spaces the FIDs such that less redundancy is obtained, which allows for the collection of more data and higher resolution spectra and/or shorter acquisition times.",
			Category -> "General"
		},
		WaterSuppression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> WaterSuppressionMethodP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates the method by which the water peak is eliminated from the 1D spectrum collected prior to the 2D spectrum.",
			Category -> "General"
		},
		PulseSequences -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, he file delineating the custom pulse sequence desired for this experiment, overriding whatever the corresponding value of ExperimentTypes is.",
			Category -> "General"
		},
		RackedNMRTubePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "A list of placements used to move the NMR tubes onto the NMR tube rack.",
			Headers -> {"NMR Tube to Place", "NMR Tube Destination", "Placement Position"},
			Category -> "Placements",
			Developer -> True
		},
		UnrackedNMRTubePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "For each member of UnrackedNMRTubeLoadingPlacements, the placement used to move the NMR tubes into the spinners.",
			Headers -> {"Spinner", "NMR Tube To Move", "Placement Position"},
			IndexMatching -> UnrackedNMRTubeLoadingPlacements,
			Category -> "Placements",
			Developer -> True
		},
		RackedNMRTubeLoadingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move the NMR tube racks onto the NMR autosampler.",
			Headers -> {"NMR Tube Rack to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		UnrackedNMRTubeLoadingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move the unracked NMR tubes onto the NMR autosampler.",
			Headers -> {"NMR Tube Rack to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		NMRTubePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of samples into the NMR tubes.",
			Category -> "General",
			Developer -> True
		},
		NMRTubeManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "A sample manipulation protocol used to transfer samples into the NMR tubes.",
			Category -> "General"
		},
		SampleRecoveryPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of samples from the NMR tubes back into storable containers.",
			Category -> "General",
			Developer -> True
		},
		SampleRecoveryManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, ManualSamplePreparation],
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
		},
		TopSpinVersion -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The current version of TopSpin used by the NMR instrument.",
			Category -> "General",
			Developer -> True
		}
	}
}];
