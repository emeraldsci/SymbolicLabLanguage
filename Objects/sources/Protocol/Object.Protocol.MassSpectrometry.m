(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MassSpectrometry], {
	Description->"Protocol for determining the mass of compounds by ionizing them and measuring their mass-to-charge ratio.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	(* General Method information *)
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "Indicates the types of measurements performed for the experiment and available on the Instrument.",
			Category -> "General"
		},
		AcquisitionModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> AcquisitionModeP,
			Description -> "For each member of SamplesIn, the type of acquisition being performed in this protocol. MS mode measures the masses of the intact analytes, whereas MSMS measures the masses of the analytes fragmented by collision-induced dissociation.",
			Category -> "General",
			IndexMatching->SamplesIn,
			Abstract -> True
		},
		MassAnalyzer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassAnalyzerTypeP,
			Description -> "The type of the component of the mass spectrometer that performs ion separation based on m/z (mass-to-charge ratio).",
			Category -> "General",
			Abstract -> True
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to perform the mass spectrometry experiment.",
			Category -> "General"
		},
		IntegratedHPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The HPLC system that is coupled to the mass spectrometer instrument used for this experiment.",
			Category -> "General"
		},
		IonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of SamplesIn, indicates if positively or negatively charged ions are analyzed.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Abstract -> True
		},
		IonSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonSourceP,
			Description -> "The type of ionization used to create gas phase ions from the molecules in the sample. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission. In matrix-assisted laser desorption/ionization (MALDI), the sample is embedded in a laser energy absorbing matrix which is then irradiated with a pulsed laser, ablating and desorbing the molecules with minimal fragmentation and creating gas phase ions from the analyte molecules in the sample.",
			Category -> "General",
			Abstract -> True
		},
		InjectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> InjectionTypeP,
			Description -> "The type of injection used to inject the sample into the mass spectrometer. In DirectInfusion, the sample is directly injected into the instrument using the built-in fluidics pump system of the mass spectrometer without the use of any mobile phase. FlowInjection works by injecting the sample into a flowing solvent stream using a liquid chromatography autosampler and pumps, in the absence of chromatographic separation.",
			Category -> "General",
			Abstract -> True
		},
	(* Sample preparation of MALDI plates *)
		MALDIPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The plate containing the spots of sample and calibrant embedded in laser energy absorbing matrix for matrix-assisted laser desorption/ionization (MALDI) analysis.",
			Category -> "Sample Preparation"
		},
		Calibrants -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SamplesIn, a sample with known m/z (mass-to-charge ratios) used to calibrate the mass spectrometer.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		Matrices -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SamplesIn, the matrix co-spotted with the sample to assist in ionization.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		CalibrantMatrices -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SamplesIn, the calibrant matrix co-spotted with the calibrant to assist in ionization.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		SpottingMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SpottingMethodP,
			Description -> "For each member of SamplesIn, the layering technique used to spot the MALDI plate with sample and matrix.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		SpottingPattern -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SpottingPatternP,
			Description -> "Indicates if all wells can be spotted (All) or if every other well is spotted (Spaced) to avoid contamination.",
			Category -> "Sample Preparation"
		},
		SpottingInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The liquid handler used to spot the MALDI plate.",
			Category -> "Sample Preparation"
		},
		SpottingInstrumentPrimaryKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The key used to identify the robotic liquid handling program used to spot the MALDI plate.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		SpottingInstrumentDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample], Null},
			Description -> "A list of container placements used to set-up the robotic liquid handler deck for MALDI plate spotting.",
			Headers ->  {"Container", "Placement Tree"},
			Category -> "Sample Preparation",
			Developer -> True
		},
		MALDIPlatePlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Instrument], Null},
			Description -> "The information that guide operator to put MALDIPlate to the Instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Plate to Place", "Destination Object", "Destination Position"}
		},
		MixProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
			Description -> "The mix protocols used to mix the source samples prior to use in the experiment.",
			Category -> "Sample Preparation"
		},
		SpottingDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time the samples are left to dry after they have been aliquoted onto the MALDI plate.",
			Category -> "Sample Preparation"
		},
		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the volume taken from the sample and aliquoted onto the MALDI plate (in MALDI mass spectrometry) or injected into the mass spectrometer (in ESI mass spectrometry).",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		MALDIPlatePrep -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "A sample manipulation protocol used to transfer samples, matrices and calibrants onto the MALDI plate.",
			Category -> "Sample Preparation"
		},
		MALDIPlateManipulations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of samples, matrices and calibrants onto the MALDI plate.",
			Category -> "Sample Preparation",
			Developer -> True
		},
	(* Ionization *)
		SourceTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity and is adjusted according to InfusionFlowRates (the higher the flow rate, the higher the temperature).",
			Category -> "Ionization"
		},
		DesolvationTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature setting for the ESI (electrospray ionization) desolvation heater that controls the nitrogen gas temperature used for solvent cluster evaporation, in order to produce single gas phase ions from the ion spray. This temperature setting affects sensitivity and is usually adjusted according to InfusionFlowRates (the higher the flow rate, the higher the temperature). Please refer to the documentation for details.",
			Category -> "Ionization"
		},
		ESICapillaryVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the absolute voltage applied to the tip of the stainless steel ESI (electrospray ionization) capillary tubing in order to produce charged droplets.",
			Category -> "Ionization"
		},
		DesolvationGasFlows -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[(1*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "For each member of SamplesIn, the nitrogen gas flow ejected around the ESI (electrospray ionization) capillary, used for solvent evaporation to produce single gas phase ions from the ion spray. This setting affects sensitivity and is usually adjusted according to InfusionFlowRates (the higher the flow rate, the higher the desolvation gas flow). Please refer to the documentation for details.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		ConeGasFlows -> {
			Format -> Multiple,
			(* L/Hour for ESI-QTOF, PSI for ESI-QQQ *)
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[(0*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "For each member of SamplesIn, the nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate on the source block, acting as a first gate between the sprayer and the reduced-pressure ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		StepwaveVoltages -> { (* Changed from SamplingConeVoltages *)
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the absolute voltage applied to the tip of the stainless steel ESI (electrospray ionization) capillary tubing in order to produce charged droplets.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		IonGuideVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the absolute voltage applied to the tip of the stainless steel ESI (electrospray ionization) capillary tubing in order to produce charged droplets. This option is diagrammed as IonSprayVoltage for ESI-QQQ.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		DeclusteringVoltages -> {(*Changed from SourceVoltageOffset*)
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone (the metal shield covering the front of the source block), towards the quadrupole mass analyzer. For ESI-QTOF this was also known as SourceVoltageOffsets. This option also know as Sampling Cone Voltages and Declustering Potential (DP).",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		(* MALDI specific ionization options *)
		MinLaserPowers -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the minimum laser power used to collect mass spectrometry data for the sample.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		MaxLaserPowers -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the maximum laser power used to collect mass spectrometry data for the sample.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		ShotsPerRaster -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of repeated shots between each raster movement within a well.",
			Category -> "Ionization"
		},
		NumberOfShots -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of times the mass spectrometer fires the laser to collect this mass spectrometry data.",
			Category -> "Ionization"
		},
		DelayTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Nano Second,
			Description -> "For each member of SamplesIn, the delay between laser ablation and ion extraction accepted by the instrument.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		Gains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[1,10],
			Description -> "For each member of SamplesIn, the signal amplification factor applied to the detector.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		LaserFrequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hertz],
			Units -> Hertz,
			Description -> "The rate at which the mass spectrometer fires the laser onto the sample spots on the MALDI plate to create gas phase ions for mass analysis.",
			Category -> "Ionization"
		},
	(* Mass Analysis *)
		MinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of SamplesIn, the lowest value of the range of measured mass-to-charge ratio (m/z).",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		MaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of SamplesIn, the highest value of the range of measured mass-to-charge ratio (m/z).",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
	(* ESI specific *)
		AcquisitionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description ->  "Length of time during which samples are being injected and their m/z signal is sampled and digitized.",
			Category -> "Mass Analysis"
		},
		InfusionSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "For each member of SamplesIn, the syringe used in ESI-QQQ instrument for direct infusion the sample via syringe pump.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InfusionSyringeInnerDiameters->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "For each member of SamplesIn, the inner diameter of the syringes that are supposed to be used on syringe pump.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InfusionSyringeNeedles->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of SamplesIn, the needle used by the syringe in the DirectInfusion process used in ESI-QQQ instrument via syringe pump.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InfusionSyringeTubing->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing, Tubing]
			],
			Description -> "The tubing we used to connect the syringe from the syring pump to the mass spectrometer.",
			Category -> "Mass Analysis"
		},
		InfusionFlowRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter/Minute],
			Units -> Microliter/Minute,
			Description -> "For each member of SamplesIn, the speed at which the sample is being injected into the mass spectrometer.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InfusionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"For each member of SamplesIn, the volume of sample being injected into the mass spectrometer by using syringe pumps, this is a unique field of ESI-QQQ.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},

		(* ESI-QQQ specific calibrant, using syringe pump*)
		(*Infusion Syringes*)
		UniqueCalibrants -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For the analysis, all unique samples with known m/z (mass-to-charge ratios) used to calibrate the mass spectrometer.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantInfusionSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "For each member of UniqueCalibrants, the syringe used in ESI-QQQ instrument for direct infusion the unique calibrants via syringe pump.",
			IndexMatching -> UniqueCalibrants,
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantInfusionSyringeNeedles->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of UniqueCalibrants, the needle used by the syringe in the DirectInfusion process for unique calibrants used in ESI-QQQ instrument via syringe pump.",
			IndexMatching -> UniqueCalibrants,
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantInfusionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"For each member of UniqueCalibrants, the unique calibrants of sample being injected into the mass spectrometer by using syringe pumps, this is a unique field of ESI-QQQ.",
			IndexMatching -> UniqueCalibrants,
			Category -> "Mass Analysis",
			Developer -> True
		},
		(* Calibrant Prime *)
		CalibrantPrimeBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Prior to calibration, the solvent or solution to use to flush the infusion tubing and ion source capillary.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantPrimeInfusionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "The syringe used to contain and inject the CalibrantPrimeBuffer.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantPrimeInfusionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"The volume of CalibrantPrimeBuffer to aspirate into the CalibrantPrimeInfusionSyringe.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantPrimeInfusionSyringeNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "The needle attached to the CalibrantPrimeInfusionSyringe to aid in aspirating CalibrantPrimeBuffer.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		(* Calibrant Flush *)
		CalibrantFlushBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "After calibration, the solvent or solution to use to flush the infusion tubing and ion source capillary.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantFlushInfusionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "The syringe used to contain and inject the CalibrantFlushBuffer.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantFlushInfusionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"The volume of CalibrantFlushBuffer to aspirate into the CalibrantFlushInfusionSyringe.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantFlushInfusionSyringeNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "The needle attached to the CalibrantFlushInfusionSyringe to aid in aspirating CalibrantFlushBuffer.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		(* Infusion flush *)
		FlushBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "After direct infusion, the solvent or solution to use to flush the infusion tubing and ion source capillary.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		FlushInfusionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "The syringe used to contain and inject the FlushBuffer.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		FlushInfusionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"The volume of FlushBuffer to aspirate into the FlushInfusionSyringe.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		FlushInfusionSyringeNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "The needle attached to the FlushInfusionSyringe to aid in aspirating FlushBuffer.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		(*Experiment Information*)
		ScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		RunDurations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the duration of time for which spectra are acquired for the sample currently being injected.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		(* ESI specific using autosampler aided infusion *)
		PlateSeal -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "The package of pierceable, adhesive film used to cover plates of injection samples in this experiment in order to mitigate sample evaporation.",
			Category -> "Sample Preparation",
			Abstract -> False
		},
		SampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The nominal temperature of the autosampler where the input samples are incubated prior to injection into the mass spectrometer.",
			Category -> "Sample Preparation"
		},
		NeedleWashSolution ->  {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solution used to wash the exterior of the injection needle before, during, and after the experiment.",
			Category -> "Cleaning"
		},
		NeedleWashPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing the NeedleWashSolution needed to wash the injection needle.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		TubingRinseSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to rinse buffers lines before and after and the experiment.",
			Category -> "Cleaning"
		},
		Buffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent pumped through the flow path, carrying the sample through the ionization source and into the mass spectrometer.",
			Category -> "General"
		},
		BufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container],Null},
			Description -> "A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		InitialBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of Buffer immediately before the experiment was started.",
			Category -> "General"
		},
		InitialBufferAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of Buffer taken immediately before the experiment was started.",
			Category -> "General"
		},
		FinalBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the Buffer immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalBufferAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of Buffer taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		(* System Prime and Flush information *)
		SystemPrimeBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer line at the start of the protocol before sample injection.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeBufferPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing system prime buffers needed to run the prime protocol onto the instrument buffer deck.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		InitialSystemPrimeBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBuffer as measured by ultrasonics before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeBuffer taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBuffer as measured by ultrasonics after the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemPrimeBuffer taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's system prime methods to a local computer.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeImportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that imports the protocol's system prime raw data to the server.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the prime file into the instrument software prior to priming the instrument for ESI-QTOF. For ESI, this is the TXT file use to submit sample through flow injection.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The solvent composition over time for the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer line at the start of the protocol before sample injection.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing system prime buffers needed to run the prime protocol onto the instrument buffer deck.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		InitialSystemFlushBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemFlushBuffer as measured by ultrasonics before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemFlushBuffer taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBuffer as measured by ultrasonics after the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushBuffer taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's system prime raw data to the server.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the prime file into the instrument software prior to priming the LC system for ESI-QTOF. For ESI, this is the TXT file use to submit sample through flow injection.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The solvent composition over time for the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeFlushPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container]],
			Description -> "The empty plate used for fake as the sample for running system prime and flush for ESI-QQQ.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeFlushPlatePlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "Instructions for placing blank 96-well plate into the autosampler of the HPLC instrument used as fake sample for running system prime and flush.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		PrimingSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Consumable],
				Model[Item, Consumable]
			],
			Description -> "The syringe used to pull air from the lockmass, calibrant, and wash solutions lines of the mass spectrometer.",
			Category -> "Cleaning",
			Developer -> True
		},
		(*Instrument Processing Related Developer Fields*)
		EstimatedProcessingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Description -> "The estimated amount of time remaining until when the current round of instrument processing is projected to finish.",
			Category -> "Mass Analysis",
			Units -> Minute,
			Developer -> True
		},
		(*Information that needs to be pasted*)
		UserCalibrantPasteTable -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The table of information that should be pasted to the Analyst software when using user-specified calibrants. This allows the instrument to be tuned.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		UserCalibrantPasteList -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The table of Mass Velues that should be pasted to the Analyst software when using user-specified calibrants. This allows the instrument to be tuned.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		UserCalibrantCSVFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the CSV file the Lab Opts will copy paste the value to the Analyst software.",
			Category -> "Mass Analysis",
			Developer -> True
		},

	(* method path information *)
		(*---Direct Infusion part*)
		InfusionSyringeInnerDiameterStrings-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, the string represents the unitless values of the infusion syringe inner diameters. This field will be used as snap text in the procedure.",
			Category -> "Mass Analysis",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		InfusionFlowRatesStrings-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, the string represents the flow rates for direct infusion, this will be used as snap text in the procedure.",
			Category -> "Mass Analysis",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		SampleQueueDataFileNames-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, in ESI-QQQ the full sample name of the data file that are generated from each injected sample via direct infusion. This name will influence the name of the data file generated after data collection.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		SampleQueueNames-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, in ESI-QQQ the full sample name of the sample queue used to execute the acquisition of the samples via direct infusion.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		SampleQueueFileNames-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, the full method name of the sample queue used to execute the acquisition of the samples via direct infusion.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		SampleQueueFilePaths-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of SamplesIn, the full file path of the sample queue used to execute the acquisition of the samples via direct infusion (ESI-QQQ and ESI-QTOF) and flow injection (ESI-QQQ).",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},

		(*Flow injection part*)
		FlowInjectionBatchMethodFilePath-> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For ESI-QQQ in using flow injection method, the path for a separate batch method file containing information for batch sample submission.",
			Category -> "Experimental Results",
			Developer -> True
		},
		CalibrantMethodImportPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the batch file used transfer the JSON to the instrument acquisition method file (DAM) file for the calibration, this is a used only for ESI-QQQ for now.",
			Category -> "General",
			Developer -> True
		},
		ExperimentInjectionTableFilePath ->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the experimental HPLC runs into the instrument software.",
			Category -> "General",
			Developer -> True
		},
		CalibrantMethodFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of SamplesIn, the full file path of the calibration tune file used during the calibration.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		CalibrantReportsFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the folder to which the calibration reports are stored after the calibration.",
			Category -> "General",
			Developer -> True
		},
		WorkingSamplesIndices -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Integer,
			Description -> "For each member of WorkingSamples, the index at which the sample occurs in the list of samples to be measured.",
			Category -> "Experimental Results",
			IndexMatching -> WorkingSamples,
			Developer -> True
		},
		AutosamplerDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "Instructions for placing SamplesIn into the autosampler of the HPLC instrument used for injecting the samples into the mass spectrometer instrument.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		AutosamplerRackPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "Instructions for placing the holder containers (racks) for SamplesIn on to the HPLC instrument used for injecting the samples into the mass spectrometer instrument.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},
		RawDataFiles -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The raw data (in .raw Waters format) pertaining to the mass spectrometry measurement of all SamplesIn zipped into one directory.",
			Category -> "Experimental Results"
		},
		FumeHood->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument],Model[Instrument]],
			Description->"The fume hood used to conduct sample manipulations of hazardous chemicals.",
			Developer -> True,
			Category->"Instrument Setup"
		},
		MethodFiles -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Method files used to conduct the mass spectrometry measurement of all SamplesIn zipped into one directory.",
			Category -> "General"
		},
	(* MALDI specific *)
		AccelerationVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Kilo Volt,
			Description -> "For each member of SamplesIn, the voltage applied to the target plate to accelerate the ions.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		GridVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Kilo Volt,
			Description -> "For each member of SamplesIn, the voltage applied to the grid electrode.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		LensVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Kilo Volt,
			Description -> "For each member of SamplesIn, the voltage applied to the ion focusing lens located at the entrance of the mass analyser.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		SamplesInWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "The wells on the MALDI plate used for SamplesIn.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "The wells on the MALDI plate used for calibration.",
			Category -> "Mass Analysis"
		},
		MaxCalibrantLaserPowers -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units :> Percent,
			Description -> "For each member of CalibrantWells, the highest percent laser power that can be used while performing manual calibration.",
			Category -> "Mass Analysis",
			IndexMatching -> CalibrantWells
		},
		CalibrationSmoothingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "For each member of CalibrantWells, the smoothing of the raw calibrant data that was done in preparation of peak detection.",
			Category -> "Mass Analysis",
			IndexMatching -> CalibrantWells
		},
		CalibrationPeakAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "For each member of CalibrantWells, the peak detection that was performed on the smoothed raw calibrant data.",
			Category -> "Mass Analysis",
			IndexMatching -> CalibrantWells
		},
		CalibrationLaserPowers -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units :> Percent,
			Description -> "If manual calibration was performed, this is the laser power used to perform calibration for each of the CalibrantWells, otherwise it is the minimum of the laser powers used during automatic calibration.",
			Category -> "Mass Analysis"
		},
		AutomaticMALDICalibration -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if peak picking and calibration will be performed using an automated algorithm. If False or Null, a manual peak picking and calibration procedure is performed.",
			Category -> "Mass Analysis"
		},
		Calibrated -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if calibration was successful for each of the CalibrantWells.",
			Category -> "Mass Analysis"
		},
		CalibratedMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each of the CalibrantWells, indicates which masses were calibrated and the order in which they were calibrated.",
			Category -> "Mass Analysis"
		},
		MatrixWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "The wells on the MALDI plate used for matrices as the blank control.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrationMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, the calibration settings used to calibrate the instrument.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		CalibrantVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volumes taken from calibrants and aliquoted onto the MALDI plate.",
			Category -> "Mass Analysis"
		},
		MethodFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file paths of the method files containing voltage settings and calibration information.",
			Category -> "General",
			Developer -> True
		},
		UncalibratedMethodFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file paths of the original, uncalibrated method files containing voltage settings.",
			Category -> "General",
			Developer -> True
		},
		AutoExecuteMethodFilePaths -> {
			Format -> Multiple,
			Class -> {Expression, String},
			Pattern :> {{WellP..}, FilePathP},
			Description -> "The full file paths of the method execution files used for specific wells on the MassSpectrometry Plate.",
			Headers -> {"Well", "Autoexecute Method Filename"},
			Category -> "General",
			Developer -> True
		},
		MethodExecutionFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of CalibrantWells, the full file paths of the method execution files containing the information needed to zap the well on the MALDI plate.",
			IndexMatching -> CalibrantWells,
			Category -> "General",
			Developer -> True
		},
		BatchExecutionFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the batch execution file, containing the information needed to zap all the spots on the MALDI plate.",
			Category -> "General",
			Developer -> True
		},
		CalibrantBatchExecutionFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the calibrant batch execution file, containing the information needed to zap the calibrant spots on the MALDI plate.",
			Category -> "General",
			Developer -> True
		},
		InstrumentSettingsFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the instrument settings file, containing protocol level control options.",
			Category -> "General",
			Developer -> True
		},
		ExportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the export script file used to convert and export data gathered by the instrument to the network drive.",
			Category -> "General",
			Developer -> True
		},
		CalibrantExportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the export script file used to convert and export raw calibrant data gathered by the instrument to the network drive.",
			Category -> "General",
			Developer -> True
		},
		RawFileImportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the import script file used to convert procedure JSON file from the network drive to the method file that can be ran by the Instrument .",
			Category -> "General",
			Developer -> True
		},
		ImportScriptFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The files used to perform any data transcription and movement to the public path. This field is appended to multiple times in the procedure for (1) system prime, (2) user data, and (3) system flush respectively.",
			Category -> "Cleaning",
			Developer -> True
		},
		RawFileExportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the export script file used to export the raw data and method files gathered by the instrument to the network drive.",
			Category -> "General",
			Developer -> True
		},
		SyringeDisconnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The disconnection information for removing existing syringe connection from mass spectrometer.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "Instrument Setup",
			Developer -> True
		},
		SyringeConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The connection information for the  syringe connection from mass spectrometer.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "Instrument Setup",
			Developer -> True
		},
		HPLCDisconnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The disconnection information for removing existing HPLC connection from mass spectrometer.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "Instrument Setup",
			Developer -> True
		},
		HPLCConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The connection information for the HPLC connection from mass spectrometer.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "Instrument Setup",
			Developer -> True
		},
		HPLCDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "The destination information for the disconnected HPLC tubing from the MassSpectrometer.",
			Headers -> {"Container", "Position"},
			Category -> "Instrument Setup",
			Developer -> True
		},
	(* Tandem Mass Analysis Specific Fields *)
		ScanModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MassSpecScanModeP,
			Description -> "For each member of SamplesIn, the mass scan mode for using in tandem mass analysis (ESI-QQQ).",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		MassSelections-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>{({GreaterP[(0*Gram)/Mole] ..} | GreaterP[(0*Gram)/Mole] | Null) ..},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if the sample will be scan in tandem mass mode, this option represents the selected mass-to-charge ratio (m/z) value of the first mass analyzer in mass selection mode (MS1, Quadrupole for both ESI-QQQ).",
			Category -> "Mass Analysis"
		},
		FragmentMassSelections-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[(0*Gram)/Mole] ..} | GreaterP[(0*Gram)/Mole] | Null) ..},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, if the sample will be scan in tandem mass mode, this option represents the selected mass-to-charge ratio (m/z) value of the first mass analyzer in mass selection mode (MS2, unique option for the 2nd Quadrupole of ESI-QQQ).",
			Category -> "Mass Analysis"
		},
		CollisionEnergies->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({UnitsP[0*Volt]..}|UnitsP[0*Volt]|Null)..},
			Description ->"For each member of SamplesIn, if the sample will be scanned in tandem mass spectrometry mode, the value of the potential applied on collision cell to fragment the sample ions after passing MS1.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		FragmentMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"For each member of SamplesIn, if the sample will be scanned in tandem mass spectrometry mode, the lowest value of the range of measured mass-to-charge ratio (m/z)for the second mass analyzer (MS2, Qudrapole analyzer for QQQ and TimeOfFlight analyzer for QTOF).",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		FragmentMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"For each member of SamplesIn, if the sample will be scanned in tandem mass spectrometry mode, the highest value of the range of measured mass-to-charge ratio (m/z) for the second mass analyzer (MS2,Quadrapole analyzer for QQQ and Time-Of-Flight analyzer for QTOF).",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		MassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"For each member of SamplesIn, if the sample will be scanned in tandem mass spectrometry mode, the value for the mass tolerance in MS1 and MS2 in mass scan mode, indicating the step size of both MS1 and MS2 when both or either one of them are set in mass selection mode. This value indicate the mass range used to find a peak with twice the entered range.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		CollisionCellExitVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Volt],
			Units -> Volt,
			Description ->"For each member of SamplesIn, if the sample will be scanned in tandem mass spectrometry mode in ESI-QQQ, the value of the potential applied between collision cell and the second Quadrupole mass analyzer (MS2) to guide and focus the ion beam into MS2.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		DwellTimes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*Millisecond]..}|GreaterP[0*Millisecond]|Null)..},
			Description->"For each member of SamplesIn, if the sample will be scan in SelectedIonMonitoring mode or MultipleReactionMonitoring mode, the length of time for each mass selection or mass selection pairs.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		MultipleReactionMonitoringAssays->{
			Format->Multiple,
			Description ->"For each member of SamplesIn, in ESI-QQQ, that firstly targets the ion corresponding to the compound of interest with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and dwell time (length of time of each scan).",
			IndexMatching -> SamplesIn,
			Class->{
				MS1Mass->Expression,
				CollisionEnergy->Expression,
				MS2Mass->Expression,
				DwellTime->Expression
			},
			Pattern :> {
				MS1Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				CollisionEnergy-> {UnitsP[0*Volt]..}|Null,
				MS2Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				DwellTime->{GreaterP[0*Millisecond]..}|Null
			},
			Category -> "Mass Analysis"
		},
		NeutralLosses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"For each member of SamplesIn, if the sample will be scanned in tandem mass spectrometry mode with Neutral Ion Loss mode, the value for the mass offset values between MS1 and MS2 (neutral ion loss value.).",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
	(* Plate Cleaning *)
		Sonicator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The sonicator used to clean the MALDI plate.",
			Category -> "Plate Cleaning"
		},
		PrimaryPlateCleaningSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The initial solution used to clean the MALDI plate after the experimental run has completed.",
			Category -> "Plate Cleaning"
		},
		SecondaryPlateCleaningSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solution used to remove any remaining material on the MALDI plate after the experimental run has completed.",
			Category -> "Plate Cleaning"
		},
		SystemPrimeData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "MassSpectrometry traces generated for the system prime run whereby the system is flushed with solvent before the column is connected.",
			Category -> "Experimental Results",
			Developer->True
		},
		SystemFlushData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "MassSpectrometry traces generated for the system flush run whereby the system is flushed with solvent after the column has been disconnected.",
			Category -> "Experimental Results",
			Developer->True
		},
		CalibrantData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Mass spectra of calibrants used in this protocol.",
			Category -> "Experimental Results"
		},
		RawCalibrantData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Mass spectra of calibrants from before calibration is applied.",
			Category -> "Experimental Results"
		},
		MatrixData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Mass spectra for matrices used in this protocol.",
			Category -> "Experimental Results"
		},
		CalibrantStorage -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of Calibrants, The storage conditions under which any input samples to this experiment should be stored after their usage in this experiment.",
			Category -> "Sample Storage"
		},
		MALDIPlateImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Photographs of the MALDI plate before and after analysis on the instrument.",
			Category -> "Experimental Results"
		},
		ImageFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Photographs and screenshots obtained during the execution of procedures.",
			Category -> "Operations Information",
			Developer -> True
		},
		NitrogenPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "A measurement of nitrogen gas pressure used for branching troubleshooting procedures.",
			Category -> "Operations Information",
			Developer -> True
		},
		ArgonPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "A measurement of argon gas pressure used for branching troubleshooting procedures.",
			Category -> "Operations Information",
			Developer -> True
		},
		GeneralDataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path where data files are stored on along the public path.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		GeneralMethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path where methods files are stored on along the public path.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		MassSpectrometryInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, MassSpectrometer], Object[Instrument, MassSpectrometer]],
			Description -> "A field used to support cross-compatibility of LCMS and MassSpectrometry procedures. The field should link to the same mass spectrometer as the Instrument field.",
			Category -> "Operations Information",
			Developer -> True
		},
		CalibrationLoopCounts -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of UniqueCalibrants, the number of calibration voltage adjustment loops performed during the procedure.",
			Category -> "General",
			Developer -> True
		}
	}
}];


