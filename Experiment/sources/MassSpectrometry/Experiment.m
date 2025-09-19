(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentMassSpectrometry*)


(* ::Subsubsection:: *)
(*ExperimentMassSpectrometry Options*)


DefineOptions[ExperimentMassSpectrometry,
	Options:>{
		{
		(* acts as master switch *)
			OptionName -> IonSource,
			Default -> Automatic,
			Description -> "The type of ionization used to create gas phase ions from the molecules in the sample. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission. In matrix-assisted laser desorption/ionization (MALDI), the sample is embedded in a laser energy absorbing matrix which is then irradiated with a pulsed laser, ablating and desorbing the molecules with minimal fragmentation and creating gas phase ions from the analyte molecules in the sample.",
			ResolutionDescription -> "Is automatically set to ESI or MALDI, respectively, whenever ESI or MALDI specific options or IonSource are specified. If none specified, defaults to MALDI if sample contains DNA oligomers and other synthetic nucleic acid oligomers, and ESI for all other samples.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> IonSourceP
			]
		},
		{
			OptionName -> Instrument,
			Default -> Automatic,
			Description -> "The instrument used to perform the mass spectrometry analysis by ionization of sample and analysis by sequential mass analyzers.",
			ResolutionDescription -> "Is automatically set to the MALDI time-of-flight (TOF) (Model[Instrument, MassSpectrometer, \"Microflex LT\"]) whenever the IonSource option is set to MALDI and/or MALDI specific options are specified. Otherwise, defaults to ESI-QTOF (Model[Instrument, MassSpectrometer, \"Xevo G2-XS QTOF\"]).",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, MassSpectrometer], Object[Instrument, MassSpectrometer]}]
			]
		},
		(* Mass Analyzer Options*)
		{
			OptionName -> MassAnalyzer,
			Default -> Automatic,
			Description -> "The manner of detection used to resolve and detect molecules. For now, we have 3 mass analyzers available for ExperimentMassSpectrometry. Time-Of-Flight (TOF) analyzer separates the ions by their flight time. QTOF accelerates ions through an elongated flight tube, followed by traveling down the quandrupole analyzer where only ions with selected mass to charge ratio will pass (either a mass range or specific mass value), and then passing a TOF analyzer. QQQ accelerates the ions and selects through two quadrupole analyzers. Both QTOF and QQQ have a collision cell, which optionally fragments the ions, in between the first and the second mass analyzer.",
			ResolutionDescription -> "For MALDI as the ion source, MassAnalyzer is automatically set to TOF detector, as TOF is the only detector that connects to MALDI for now. For ESI ion source, the detector can be TOF/QTOF for the ESI-QTOF study and quadrupole(Q)/triple-quadrupole (QQQ) for ESI-QQQ study. For APCI as the ion source, the analyzer can be quadrupole or triple-quadrupole.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> (TOF|QTOF|TripleQuadrupole) (*Single Quadrupole was excluded from this pattern, since ExpMS will not support that for now*)
			]
		},
		(* MALDI-specific non-indexmatched options *)
		{
			OptionName -> NumberOfShots,
			Default -> Automatic,
			Description -> "The total number of times the laser is fired by the MALDI mass spectrometer during data acquisition.",
			ResolutionDescription -> "Is automatically set to 500 for MALDI mass spectrometry, otherwise is set to Null.",
			AllowNull -> True,
			Category -> "MALDI Ionization",
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[50,10000]
			]
		},
		{
			OptionName -> ShotsPerRaster,
			Default -> Automatic,
			Description -> "The number of repeated laser shots made between each raster movement within a well during a MALDI measurement.",
			ResolutionDescription -> "Is automatically set to 12 for MALDI mass spectrometry, otherwise is set to Null.",
			AllowNull -> True,
			Category -> "MALDI Ionization",
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1,10000]
			]
		},
		{
			OptionName -> SpottingPattern,
			Default -> Automatic,
			Description -> "Indicates if MALDI plate wells are skipped during spotting to decrease any cross contamination risks; All indicates every well on the plate will be spotted and Spaced indicates every other well is filled.",
			ResolutionDescription -> "Is automatically set to All for MALDI mass spectrometry, otherwise is set to Null.",
			AllowNull -> True,
			Category -> "MALDI Sample Preparation",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> SpottingPatternP
			]
		},
		{
			OptionName -> SpottingDryTime,
			Default -> Automatic,
			Description -> "The minimum amount of time the samples are left to dry after they have been aliquoted onto the MALDI plate.",
			ResolutionDescription -> "Is automatically set to 15 minutes for MALDI mass spectrometry, otherwise is set to Null.",
			AllowNull -> True,
			Category -> "MALDI Sample Preparation",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[5 Minute, 1 Hour],
				Units -> Alternatives[Second, Minute, Hour]
			]
		},
		{
			OptionName -> MALDIPlate,
			Default -> Automatic,
			Description -> "The plate spotted with samples and calibrants mixed with laser energy absorbing matrix material. The MALDI plate is subsequenctly placed into the mass spectrometer's reduced pressure sample chamber and irradiated with laser pulses to produce gas phase ions that enter the mass spectrometer for mass analysis.",
			ResolutionDescription -> "Is automatically set to Model[Container, Plate, MALDI, \"96-well Ground Steel MALDI Plate\"] for MALDI mass spectrometry, otherwise is set to Null.",
			AllowNull -> True,
			Category -> "MALDI Sample Preparation",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Container,Plate],Object[Container,Plate],Model[Container,Plate,MALDI],Object[Container,Plate,MALDI]}]
			]
		},
		(* ESI non-indexmatched options *)
		{
			OptionName -> InjectionType,
			Default -> Automatic,
			Description->"The type of sample submission method to employ for ESI-QTOF and ESI-QQQ. In DirectInfusion, the sample is directly injected into the instrument, using either a built-in fluidics pump system (ESI-QTOF) or a syringe pump (ESI-QQQ), of the mass spectrometer without the use of any mobile phase. Due to the manual nature of the injection, this is well suited for measuring a small number of samples. Furthermore, this is recommended when high sample volumes of are available (>500 Microliter), the sample does not require cooling, and a quick result is desired. It produces a constant signal over time. FlowInjection works by injecting the sample into a flowing solvent stream using a liquid chromatography autosampler and pumps, in the absence of chromatographic separation. FlowInjection can accomodate up to 2*96 samples and is thus suited for highthrougput analyses. It produces a brief peak of signal at the time that the analyte reaches the detector.",
			ResolutionDescription->"Is automatically set to Null for MALDI mass spectrometry. If ESI mass spectrometry, is automatically set to FlowInjection if the number of samples is larger than 5, and/or the samples are inside a 96 deep well plate, and/or none of the flow injection options are set, otherwise is set to DirectInfusion.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> ( DirectInfusion | FlowInjection )
			],
			Category -> "General"
		},
		{
			OptionName -> SampleTemperature,
			Default -> Automatic,
			ResolutionDescription -> "Is automatically set to Ambient for FlowInjection ESI mass spectrometry, otherwise is set to Null.",
			Description -> "The temperature at which the samples are kept in the instrument's autosampler prior to injection. This option can only be changed for ESI-QQQ and ESI-QTOF using FlowInjection as the InjectionType.",
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[5 Celsius, 40 Celsius],
					Units -> Celsius
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				]
			],
			Category->"ESI Flow Injection"
		},
		{
			OptionName -> Buffer,
			Default -> Automatic,
			Description -> "The solvent pumped through the flow path, carrying the injected sample to the ionization source where the analytes are ionized via electrospray ionization.",
			ResolutionDescription->"Is automatically set to Model[Sample,StockSolution,\"0.1% FA with 5% Acetonitrile in Water, LCMS-grade\"] for FlowInjection ESI mass spectrometry, otherwise is set to Null.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample],Model[Sample]}]
			],
			Category->"ESI Flow Injection"
		},
		{
			OptionName -> NeedleWashSolution,
			Default -> Automatic,
			Description -> "The solvent used to wash the injection needle before each sample measurement.",
			AllowNull -> True,
			ResolutionDescription->"Is automatically set to Model[Sample,StockSolution,\"20% Methanol in MilliQ Water\"] for FlowInjection ESI mass spectrometry, otherwise is set to Null.",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
				PreparedSample->False,
				PreparedContainer->False
			],
			Category->"ESI Flow Injection"
		},
		(*IndexMatching Options*)
		IndexMatching[
		(* Shared for MALDI and ESI *)
			{
				OptionName -> Analytes,
				Default -> Automatic,
				Description -> "The compounds of interest that are present in the given samples, used to determine the other settings for the Mass Spectrometer (ex. MassDetection).",
				ResolutionDescription -> "If populated, will resolve to the user-specified Analytes field in the Object[Sample]. Otherwise, will resolve to the larger compounds in the sample, in the order of Proteins, Peptides, Oligomers, then other small molecules. Otherwise, set Null.",
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> Object, Pattern :> ObjectP[IdentityModelTypes]]
				]
			},
			{
				OptionName -> IonMode,
				Default -> Automatic,
				Description -> "Indicates if positively or negatively charged ions are analyzed.",
				ResolutionDescription -> "For oligomer samples of the types Peptide, DNA, and other synthetic oligomers, is automatically set to positive ion mode. For other types of samples, defaults to positive ion mode, unless the sample is acid (Acid->True or pKa<=8).",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> IonModeP
				]
			},
			{
				OptionName -> MassDetection, (*Changed from MassRange*)
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded during analysis.",
				ResolutionDescription -> "For MALDI-TOF measurements, is automatically set to ensure there are 3 calibrant peaks which flank the sample's molecular weight in the range. For ESI-QTOF measurements, is automatically set to one of three default mass ranges according to the molecular weight and/or the type of sample (small molecules -> 50-1200 m/z, peptides -> 350 - 2000 m/z, proteins/antibodies -> 500 - 5000 m/z). For ESI-QQQ, the mass range is set by default to be 100 - 1250 m/z if ScanMode is FullScan.",
				AllowNull -> False,
				Widget -> Alternatives[
					"Single"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
						Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
					],
					"Range"  -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[100 Gram / Mole, 500000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"Multiple" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 2000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> Calibrant,
				Default -> Automatic,
				Description ->"A sample with components of known mass-to-charge ratios (m/z) used to calibrate the mass spectrometer. In the chosen ion polarity mode, the calibrant should contain at least 3 masses spread over the mass range of interest.",
				ResolutionDescription -> "Automatically set based on the sample type and MassDetection. For MALDI, is set to Model[Sample,StockSolution,Standard,\"IDT ssDNA Ladder 10-60 nt, 40 ng/uL\"] for DNA, and Model[Sample,StockSolution,Standard,\"Peptide/Protein Calibrant Mix\"] for all others.For ESI, is set to sodium iodide for peptide samples, cesium iodide for intact protein analysis. For other types of samples, is set to cesium iodide if molecular weight is above 2000 Da, to sodium iodide if molecular weight between 1200 and 2000 Da, and to sodium formate for all others (small molecule range). For ESI-QQQ, the default calibrant is polypropylene glycol (PPG) standard sample from SciEX. Where Model[Sample, \"id:zGj91a71kXEO\"] and Model[Sample, \"id:bq9LA0JA1YJz\"] are for the positive and negative ion mode, respectively.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
				]
			},
			(* Syringe Pump Injection for ESI-QQQ *)
			{
				OptionName -> InfusionVolume,
				Default -> Automatic,
				Description ->"The physical quantity of sample loaded into the syringe (for now ESI-QQQ only), when using syringe pump to infusion load the sample.",
				ResolutionDescription -> "Is automatically set to 500 Microliter for DirectInfusion ESI mass spectrometry, otherwise is set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.05 Milliliter, 10*Milliliter],
					Units -> Milliliter
				],
				Category -> "ESI-QQQ Direct Infusion"
			},
			{
				OptionName ->InfusionSyringe,
				Default -> Automatic,
				Description ->"The syringe used for syringe pump infusion injection (For ESI-QQQ only).",
				ResolutionDescription ->"For ESI-QQQ, is automatically resolved based on the infusion volume: (0.01 mL ~ 0.99 mL) -> Model[Container, Syringe, \"1mL All-Plastic Disposable Syringe\"]; (1.01 mL ~ 2.99 mL) ->Model[Container, Syringe, \"3mL Sterile Disposable Syringe\"];(3.00 mL,4.99 mL)->Model[Container, Syringe, \"5mL Sterile Disposable Syringe\"];(5.0mL,9.9mL)->Model[Container, Syringe, \"10mL Syringe\"]. Otherwise is set to Null." ,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}]
				],
				Category -> "ESI-QQQ Direct Infusion"
			},
			(* ESI specific *)
			{
				OptionName -> InfusionFlowRate,
				Default -> Automatic,
				Description -> "The flow rate at which the sample is injected into the mass spectrometer through either the DirectInfustion (the fluidics pump system (ESI-QTOF) or the syringe pump system (ESI-QQQ)) or the FlowInjection under a flowing solvent stream using a liquid chromatography autosampler). Note that source settings such as source voltage/temperature and desolvation temperature/flow rate should be adjusted according to the flow rate for improved sensitivity and spray stability.",
				ResolutionDescription -> "In DirectInfusion: Is automatically set to 20 Microliter/Minute and 5 Microliter/Minute for ESI-QTOF and ESI-QQQ, respectively; In FlowInjection; 100 Microliter/Minute for both ESI-QQQ and ESI-QTOF; otherwise is set to Null.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter/Minute,600 Microliter/Minute],
					Units -> CompoundUnit[
						{1,{Microliter,{Microliter,Milliliter}}},
						{-1,{Minute,{Minute,Hour}}}
					]
				]
			},


			(*
			{
				OptionName -> LockMass,
				Default -> True,
				Description -> "Indicates if a LockMassCompound are introduced into the sample spray as reference mass during data acquisition to correct for mass shifts. QTOF instruments are sensitive to mass shifts so it is recommended to turn this on for samples where high mass accuracy (<2ppm) is desired.",
				AllowNull -> True,
				Category \[Rule] "ESI Mass Analysis",
				Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName -> LockMassCompound,
				Default -> Automatic, (* TODO make the model and an object for the lockmass we have in-House *)
				Description -> "The compound that is introduced into the sample spray as reference mass during data acquisition to correct for mass shifts.",
				AllowNull -> True,
				Category \[Rule] "ESI Mass Analysis",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample, StockSolution, Standard]}]
				]
			}, *)
			{
				OptionName -> ScanTime,
				Default -> Automatic,
				Description -> "The duration of time allowed to pass between each spectral acquisition. Increasing this value improves sensitivity, whereas decreasing this value allows for more data points and spectra to be acquired during the RunDuration.",
				ResolutionDescription -> "Is automatically set to 1 second for ESI-QTOF mass spectrometry. For ESI-QQQ, in MultipleReactionMonitoring, this option is auto resolved by summing up all dwell times of each assay. For FullScan, ScanTime is set to the minimum allowed for the specified MassDetection range (3 microseconds per discrete point in the MassDetection range). For the rest of scan modes, is set to 5 Millisecond (0.005 Second) by default. Otherwise is set to Null.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.005 Millisecond,  195 Second],
					Units -> {Millisecond, {Millisecond, Second}}
				]
			},
			{
				OptionName -> RunDuration,
				Default -> Automatic,
				Description -> "The duration of time for which spectra are acquired for the sample currently being injected.",
				ResolutionDescription -> "Is automatically set to 1 minute for ESI-QTOF and ESI-QQQ mass spectrometry, otherwise is set to Null.",
				AllowNull -> True,
				Category ->"Method Information",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Minute,  60 Minute],
					Units -> {Minute, {Minute, Second, Hour}}
				]
			},
			{
				OptionName -> ESICapillaryVoltage,
				Default -> Automatic,
				Description -> "This option (also known as Ion Spray Voltage) indicates the absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets. Adjust this voltage to maximize sensitivity. For ESI-QTOF, most compounds are optimized between 0.5 and 3.2 kV in ESI positive ion mode and 0.5 and 2.6 kV in ESI negative ion mode. For ESI-QQQ this parameter is 5.5 kV for positive ion mode and -4.5 kV for negative ion mode, for standard flow UPLC a value of 0.5 kV is typically best for maximum sensitivity. Thie parameter can be altered according to sample type. For low flow applications, best sensitivity will be achieved with a relatively high value in ESI positive (e.g. 3.0 kV for ESI-QTOF and 5.5 or -4.5 kV for ESI-QQQ positive and negative, respectively).",
				ResolutionDescription ->"For ESI-QTOF: Is automatically set according to the flow rate: For ESI-QTOF: 0-0.02 ml/min -> 3.0 kV (Positive) or 2.8 kV (Negative), 0.021-0.1 ml/min -> 2.5 kV, 0.101 - 0.3 ml/min -> 2.0 kV, 0.301 - 0.5 ml/min -> 1.5 kV, > 0.5 ml/min -> 1.0 kv . For ESI-QQQ: < 0.02 ml/min -> 5.5 kV or -4.5 kV, 0.02-0.1 ml/min -> 4.5 kV or -4.0 KV, >0.1 ml/min -> 4.0 kV and -4.0 kV, for positive and negative IonMode respectively.",
				AllowNull -> True,
				Category -> "ESI Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-4.5 Kilovolt, 5.5 Kilovolt],
					Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> DeclusteringVoltage, (*Changed from SourceVoltageOffset *)
				Default -> Automatic,
				Description->"For ESI-QTOF, indicates the voltage between the ion block (the reduced-pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer). This voltage attracts charged ions from the capillary tip into the ion block leading into the mass spectrometer. For ESI-QTOF, this voltage is typically set to 25-100 V and its tuning has little effect on sensitivity. For ESI-QQQ, this controls the voltage applied between the orifice (where ions enter the mass spectrometer) and the ion guide to prevent the ionized small particles from aggregating together. It's normally optimized between -300 to 300 V, and its sensitivity depends on chemical composition and charge state.",
				ResolutionDescription -> "Is automatically set to any specified method; otherwise, for ESI-QTOF, is set to 40 Volt; and for ESI-QQQ, is set to 90 Volt and -90 respectively for positive and negative ion mode.",
				AllowNull -> True,
				Category -> "ESI Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-400 Volt, 400 Volt](* RangeP[0.1 Volt, 150 Volt] for ESI-QTOF only *),
					Units -> {Volt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> StepwaveVoltage, (*From SamplingConeVoltage*)
				Default -> Automatic,
				Description -> "This is a unique option for ESI-QTOF. It indicates the voltage offset between the 1st and 2nd stage of the ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired.",
				ResolutionDescription -> "Is automatically set according to the sample type (proteins, antibodies and analytes with MW > 2000 -> 120 V, DNA and synthetic nucleic acid oligomers -> 100 V, all others (including peptides and small molecules) -> 40 V).",
				AllowNull -> True,
				Category -> "ESI Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Volt, 200 Volt],
					Units -> {Volt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> SourceTemperature,
				Default -> Automatic,
				Description ->"The temperature setting of the source block. Heating the source block discourages condensation and decreases solvent clustering in the reduced vacuum region of the source. For ESI-QTOF, This temperature setting is flow rate and sample dependent. Typical values are between 60 to 120 Celsius. For thermally labile analytes, a lower temperature setting is recommended. For ESI-QQQ, this values is set to 150 Celsius cannot be changed.",
				ResolutionDescription -> "For ESI-QTOF: is automatically set according to the flow rate (0-0.02 ml/min -> 100 Celsius, 0.021-0.3 ml/min -> 120 Celsius, >0.3 ml/min -> 150 Celsius). For ESI-QQQ, this value is locked to be 150 Celsius.",
				AllowNull -> True,
				Category -> "ESI Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[$AmbientTemperature,  150 Celsius],
					Units -> Celsius
				]
			},
			{
				OptionName -> DesolvationTemperature,
				Default ->Automatic,
				Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray. Similarly to DesolvationGasFlow, this setting is dependant on solvent flow rate and composition. A typical range is from 150 to 650 Celsius for ESI-QTOF and 350 to 600 Celsius for ESI-QQQ.",
				ResolutionDescription -> "Is automatically set according to the flow rate: For ESI-QTOF (0-0.02 ml/min -> 200 Celsius, 0.021-0.1 ml/min -> 350 Celsius, 0.101-0.3 -> 450 Celsius, 0.301->0.5 ml/min -> 500 Celsius, >0.500 ml/min -> 600 Celsius); For ESI-QQQ (0-0.02 ml/min -> 350 Celsius, 0.021-0.1 ml/min -> 400 Celsius, 0.101-0.3 -> 450 Celsius, 0.301->0.5 ml/min -> 500 Celsius, >0.500 ml/min -> 600 Celsius); .",
				AllowNull -> True,
				Category -> "ESI Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Celsius, 750 Celsius] (* For ESI-QTOF: Up to 650 Celsius. for ESI-QQQ: up to 750 Celsius. *),
					Units -> Celsius
				]
			},
			{
				OptionName -> DesolvationGasFlow,
				Default -> Automatic,
				Description ->"The nitrogen gas flowing around the electrospray inlet capillary in order to desolvate and nebulize analytes. Similarly to DesolvationTemperature, the ideal setting is dependent on solvent flow rate and composition. When MassAnalyzer is QQQ, this value is in terms of pressure (PSI). When MassAnalyzer is QTOF, this value is in terms of flow rate (Liter/Hour).",
				ResolutionDescription ->"Is automatically set according to the flow rate: for ESI-QTOF (0-0.02 ml/min -> 600 L/H, 0.021-0.3 ml/min -> 800 L/H, 0.301-0.5 -> 1000 L/H, >0.500 ml/min -> 1200 L/H); and (0-0.02 ml/min -> 20 PSI, 0.02-0.3 ml/min -> 40 PSI, 0.301-0.500 ml/min -> 60 PSI, >0.500 ml/min -> 80) for ESI-QQQ.",
				AllowNull -> True,
				Category -> "ESI Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :>RangeP[55 Liter/Hour, 1200 Liter/Hour] | RangeP[0 PSI, 85 PSI],
					Units -> Alternatives[
						CompoundUnit[
							{1, {Liter, {Liter, Milliliter}}},
							{-1, {Hour, {Hour, Minute}}}
						],
						PSI
					]
				]
			},
			{
				OptionName -> ConeGasFlow,
				Default -> Automatic,
				Description -> "The nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean. The same parameter is referred to as Curtain Gas Pressure for ESI-QQQ. Typical values are between 0 and 150 L/h for ESI-QTOF or 20 to 55 PSI for ESI-QQQ.",
				ResolutionDescription -> "Is automatically set to 50 Liter/Hour for ESI-QTOF and 50 PSI for ESI-QQQ, and is set to Null in MALDI-TOF. Is not recommended to set to a smaller value of 40 PSI in ESI-QQQ, due to potential deposition of the sample inside the instrument that will lead to contamination.",
				AllowNull -> True,
				Category -> "ESI Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :>RangeP[0 Liter/Hour,  300 Liter/Hour] | RangeP[20 PSI, 55 PSI],
					Units -> Alternatives[
						CompoundUnit[
							{1, {Liter, {Liter, Milliliter}}},
							{-1, {Hour, {Hour, Minute}}}
						],
						PSI
						]
					]
			},
			{
				OptionName -> IonGuideVoltage,
				Default -> Automatic,
				Description -> "This option (also known as Entrance Potential (EP)) is a unique option of ESI-QQQ. This parameter indicates electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region.",
				ResolutionDescription -> "Is automatically set to 10 V for positive ions, or \[Dash]10 V for negative ions in ESI-QQQ, and can be changed between 2-15 V in both positive and negative mode. This value is set to Null in ESI-QTOF.",
				AllowNull -> True,
				Category -> "ESI Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-15 Volt, -2 Volt] | RangeP[2 Volt, 15 Volt],
					Units -> Volt
				]
			},

			(* ESI Flow injection options *)
			{
				OptionName -> InjectionVolume,
				Default -> Automatic,
				Description -> "The physical quantity of sample loaded into the flow path for measurement.",
				ResolutionDescription -> "Is automatically set to 10 Microliter for FlowInjection ESI mass spectrometry (For Both QQQ and QTOF), otherwise is set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 50 Microliter],
					Units -> Microliter
				],
				Category->"ESI Flow Injection"
			},
			(* MALDI specific *)
			{
				OptionName -> LaserPowerRange,
				Default -> Automatic,
				Description -> "The min and max laser power used during analysis (given as a relative percentage of the mass spectrometer's actual laser power). Adjust this value to increase resolution and reduce noise.",
				ResolutionDescription -> "Automatically set according to sample type and molecular weight of the analyte of interest. For DNA below 3500 Da, this is set to 55-75% and for DNA above 3500 Da to 65-85%. For all other samples it is set to 25-75% if below 6000 Da and 25-90% otherwise.",
				AllowNull -> True,
				Category -> "MALDI Ionization",
				Widget -> Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
						Units -> Percent
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
						Units -> Percent
					]
				]
			},
			{
				OptionName -> Matrix,
				Default -> Automatic,
				Description -> "The laser-absorbing reagent co-spotted with the input samples in order to assist ionization of the sample.",
				ResolutionDescription -> "Automatically set according to sample type and ion mode. For DNA oligomers and positive ion mode, HPA MALDI matrix is used. Otherwise, the PreferredMALDIMatrix of the calibrant used for this sample is used, and if that is not informed, it defaults to THAP MALDI matrix.",
				AllowNull -> True,
				Category -> "MALDI Sample Preparation",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample, Matrix], Object[Sample]}]
				]
			},
			{
				OptionName -> CalibrantMatrix,
				Default -> Automatic,
				Description -> "The laser-absorbing reagent co-spotted with the input calibrants in order to assist ionization of the sample.",
				ResolutionDescription -> "Automatically set to according to the PreferredMatrix field of the calibrant models, else will be resolved to be the same as Matrix.",
				AllowNull -> True,
				Category -> "MALDI Sample Preparation",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample, Matrix], Object[Sample]}]
				]
			},
			{
				OptionName -> AccelerationVoltage,
				Default -> Automatic,
				Description -> "The voltage applied to the  MALDI plate in order to accelerate ions towards the detector. Increase this voltage to increase the sensitivity or decrease it to increase the resolution.",
				ResolutionDescription -> "Automatically set to 19.5 kV for MALDI mass spectrometry, otherwise set to Null.",
				AllowNull -> True,
				Category -> "MALDI Mass Analysis",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Kilovolt, 20 Kilovolt],
					Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> GridVoltage,
				Default -> Automatic,
				Description -> "The voltage applied to a secondary plate above the MALDI plate in order to create a gradient such that ions with lower initial kinetic energies are accelerated faster than samples with higher kinetic energies which have drifted farther from the MALDI plate. Use a lower grid voltage for samples with a higher molecular weight.",
				ResolutionDescription -> "Automatically set to 18.15 kV for MALDI mass spectrometry, otherwise set to Null.",
				AllowNull -> True,
				Category -> "MALDI Mass Analysis",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Kilovolt, 20 Kilovolt],
					Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> LensVoltage,
				Default -> Automatic,
				Description -> "The voltage applied to the electrostatic ion focusing lens located at the entrance of the mass analyser.",
				ResolutionDescription -> "Automatically set to 7.8 kV for MALDI mass spectrometry, otherwise set to Null.",
				AllowNull -> True,
				Category -> "MALDI Mass Analysis",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.05 Kilovolt, 10 Kilovolt],
					Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> DelayTime,
				Default -> Automatic,
				Description -> "The duration of time that is allowed to pass between the laser pulse and the application of the acceleration voltage in order to control for differences in kinetic energy introduced during the ionization process. Use a longer delay time for samples with a higher molecular weight.",
				ResolutionDescription -> "A delay of 250 ns is used for DNA oligomers. A 150 ns delay is used for all other samples.",
				AllowNull -> True,
				Category -> "MALDI Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Nanosecond, 5000 Nanosecond],
					Units -> {Nanosecond, {Picosecond, Nanosecond, Microsecond, Millisecond}}
				]
			},
			{
				OptionName -> CalibrantLaserPowerRange,
				Default -> Automatic,
				Description -> "The min and max laser power used during calibration (given as a relative percentage of the mass spectrometer's actual laser power).",
				ResolutionDescription -> "Is automatically set to use the same laser power range determined for the analyte.",
				AllowNull -> True,
				Category -> "MALDI Ionization",
				Widget -> Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
						Units -> Percent
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
						Units -> Percent
					]
				]
			},
			{
				OptionName->Gain,
				Default->Automatic,
				Description->"The signal amplification factor applied to the detector in MALDI-TOF analysis. A gain factor of one corresponds to the lowest voltage applied to the electron multiplier. Larger values can increase signal intensity, but may cause saturation and decreased signal to noise.",
				ResolutionDescription->"Is automatically set to two",
				AllowNull->True,
				Category->"MALDI Mass Analysis",
				Widget->Widget[Type->Number,Pattern:>RangeP[1., 10.]]
			},
			{
				OptionName -> SpottingMethod,
				Default -> Automatic,
				Description -> "Indicates if or how to layer the input samples and matrix onto the MALDI plate in order to form sample and calibration spots for analysis.",
				ResolutionDescription -> "Is automatically set to the calibrant's preferred spotting method.",
				AllowNull -> True,
				Category -> "MALDI Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> SpottingMethodP
				]
			},
			{
				OptionName -> SampleVolume,
				Default -> Automatic,
				Description -> "The volume taken from each input sample and aliquoted onto the MALDI plate.",
				ResolutionDescription -> "Is automatically set to 0.8 Microliter for MALDI mass spectrometry, otherwise is set to Null.",
				AllowNull -> True,
				Category -> "MALDI Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.5 Microliter, 2 Microliter],
					Units -> Microliter
				]
			},
			(* Tandem Mass (ESI-QTOF and ESI-QQQ) Specific Options *)
			{
				OptionName -> ScanMode,
				Default -> Automatic,
				Description -> "The acquisition and selection sequence when MassAnalyzer is TripleQuadrupole. Different scan modes will apply selections to the first (MS1) and third (MS2) quadrupole at specific times. In Full Scan Mode, the entire MS1 range is scanned and fragmentation is off. In SelectedIonMonitoring, select MS1 masses (per the MassDetection option) are monitored and measured without fragmentation. In PrecursorIonScan mode, fragmentation is on, and fragment ion is selected (per the FragmentMassDetection option), while MS1 masses are scanned across a range (MassDetection). In NeutralIonLoss mode, both MS1 and MS2 masses are scanned, in order to track specific MS1/MS2 combinations for neutral ion loss. In ProductIonScan, an MS1 mass is selected (MassDetection) and a range of MS2 mass is scanned in order to survey fragmentation patterns of the parent mass. In MultipleReactionMonitoring mode, both MS1 and MS2 are selected with specific intact and fragment ion pairs are monitored. ScanMode is automatically set to FullScan (no fragmentation of the sample, collecting full mass range scan).",
				ResolutionDescription -> "For ESI-QQQ this value will be automatically resolved based-on tandem mass related input. For ESI-QTOF and MALDI-TOF, this will be resolved to Null.",
				AllowNull -> True,
				Category -> "Tandem Mass Spectrometry",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> MassSpecScanModeP
				]
			},
			{
				OptionName -> FragmentMassDetection,
				Default -> Automatic,
				Description ->"The mass scan range for the second mass analyzer (MS2) in the Tandem MS study. The second mass anaylzer screens and scans the ion after the incoming ions have been fragmented by collision cells. This option can be set at one specific mass value (mass selection mode), or at a mass range (mass scan mode). This option will be checked to match the corresponding ScanMode.",
				ResolutionDescription ->"Is automatically resolved as Null for FullScan and SelectedIonMonitoring mode. Is set to 5 - 1250 m/z by default for ProductionIonScan modes and resolved to be the same as MassDetection in NeutralIonLoss model, and resolved based on MassDetection or 500 m/z for PrecursorIonScan and MultipleReactionMonitoring mode.",
				AllowNull -> True,
				Category -> "Tandem Mass Spectrometry",
				Widget -> Alternatives[
					"Single"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
						Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
					],
					"Range"  -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"Multiple" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> MassTolerance,
				Default -> Automatic,
				Description ->"This options indicates the step size of both MS1 and MS2 when both or either one of them are set in mass selection mode. This value indicates the mass range used to find a peak with twice the entered range. For example, for a mass range 100 Da to 200 Da and step size 0.1, the instrument scans 99.95 to 100.05 (records as value 100), 100.05 to 101.15 (records as value 101) and 199.95 to 200.05 (records as value 200).",
				ResolutionDescription ->"This option will be set to Null if using MALDI-TOF and ESI-QTOF. For ESI-QQQ, if both of the mass anaylzer are in mass selection mode (SelectedIonMonitoring and MultipleReactionMonitoring mode), this option will be auto resolved to Null. In all other mass scan modes in ESI-QQQ, this option will be automatically resolved to 0.1 g/mol.",
				AllowNull -> True,
				Category -> "Tandem Mass Spectrometry",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 Gram/Mole, 1 Gram/Mole],
					Units -> CompoundUnit[
						{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
						{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
					]
				]
			},
			(* Collision Cell setup for Tandem Mass Spectrometry *)
			{
				OptionName -> Fragment,
				Default -> Automatic,
				Description -> "Determines whether to have ions dissociate upon collision with neutral gas species and to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS).",
				ResolutionDescription ->"For ESI-QQQ, this option will be automatically resolved by the corresponding scan modes (False for FullScan and SelectedIonMonitoring Method, True for PrecursorIonScan, NeutralIonLoss, ProductIonScan and MultipleReactionMonitoring mode). For ESI-QTOF and MALDI-TOF this options will be resolved to False.",
				AllowNull -> True,
				Category -> "Tandem Mass Spectrometry",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> CollisionEnergy,
				Default -> Automatic,
				Description ->"The potential used in the collision cell to fragment the incoming ions. Changing the collision energy will change the fragmentation pattern of the incoming ion. High collision energy gives higher ion intensities but the mass patterns will also be more complex. Low collision energy gives simpler mass patterns with lower intensity.",
				ResolutionDescription ->"Is automatically set to 30 V (Positive) and -30 V (Negative) if the collision option is True. This value is Null when Collision option is False and when scan mode is set to MultipleReactionMonitoring.",
				AllowNull -> True,
				Category -> "Tandem Mass Spectrometry",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
						Units -> Volt
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
							Units -> Volt
						],
						Orientation->Vertical
					]
				]
			},
			{
				OptionName -> CollisionCellExitVoltage,
				Default -> Automatic,
				Description ->"Also known as the Collision Cell Exit Potential (CXP). This value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2). This potential is tuned to ensure successful ion acceleration out of collision cell and into MS2, and can be adjusted to reach the maximal signal intensity. This option is unique to ESI-QQQ for now, and only required when Fragment ->True and/or in ScanMode that achieves tandem mass feature (PrecursorIonScan, NeutralIonLoss,ProductIonScan,MultipleReactionMonitoring). For non-tandem mass ScanMode (FullScan and SelectedIonMonitoring) and other massspectrometer (ESI-QTOF and MALDI-TOF), this option is resolved to Null.",
				ResolutionDescription ->"Is automatically set to 15 V (Positive mode) or -15 V (Negative mode) if the collision option is True and using QQQ as the mass analyzer. ",
				AllowNull -> True,
				Category -> "Tandem Mass Spectrometry",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-55 Volt, 55 Volt],
					Units -> Volt
				]
			},

			(* Scan mode specific options for Tandem Mass Spectrometry *)
			{
				OptionName -> DwellTime,
				Default -> Automatic,
				Description -> "The duration of time for which spectra are acquired at the specific mass detection value for SelectedIonMonitoring and MultipleReactionMonitoring mode in ESI-QQQ.",
				ResolutionDescription -> "Is automatically set to 200 microsecond for ESI-QQQ mass spectrometry at SelectedIonMonitoring mode, otherwise is set to Null.",
				AllowNull -> True,
				Category -> "Tandem Mass Spectrometry",
				Widget ->Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
						Units -> {Millisecond, {Millisecond,Second,Minute}}
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
							Units -> {Millisecond, {Millisecond,Second,Minute}}
						],
						Orientation->Vertical
					]
				]
			},
			{
				OptionName -> NeutralLoss,
				Default -> Automatic,
				Description ->"A neutral loss scan is performed on ESI-QQQ instrument by scanning the sample through the first quadrupole (Q1). The ions are then fragmented in the collision cell. The second mass analyzer is then scanned with a fixed offset to MS1. This option represents the value of this offset.",
				ResolutionDescription ->"Is set to 500 g/mol if using scan mode, and is Null in other modes.",
				AllowNull -> True,
				Category -> "Tandem Mass Spectrometry",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Gram/Mole],
					Units ->
						CompoundUnit[
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
							{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
						]
				]
			},
			{
				OptionName -> MultipleReactionMonitoringAssays,
				Default -> Automatic,
				Description -> "In ESI-QQQ, the ion corresponding to the compound of interest is targetted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).",
				ResolutionDescription -> "Need to fill in order to use Multiple Reaction Monitoring mode. Will auto switch to Selected Reaction Monitoring mode if only one mass assay/dwell time is input. Default dwell time is 200 micro second.",
				AllowNull -> True,
				Category -> "Tandem Mass Spectrometry",
				Widget -> Adder[
					{
						"Mass Selection Values" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Gram / Mole],
							Units -> CompoundUnit[
								{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
								{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
							]
						],
						"CollisionEnergies" -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
								Units -> Volt
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						],
						"Fragment Mass Selection Values" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Gram / Mole],
							Units -> CompoundUnit[
								{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
								{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
							]
						],
						"Dwell Times" -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Second],
								Units -> {Millisecond, {Microsecond, Millisecond, Second}}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					},
					Orientation -> Vertical
				]
			},
			{(*Note this was moved from Non-index matching option to a index-matching option*)
				OptionName -> CalibrantVolume,
				Default -> Automatic,
				Description -> "The volume taken from each calibrant sample and aliquoted onto the MALDI plate.",
				ResolutionDescription -> "Is automatically set to 0.8 Microliter for MALDI mass spectrometry, otherwise is set to Null.",
				AllowNull -> True,
				Category -> "MALDI Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.5 Microliter, 2 Microliter],
					Units -> Microliter
				]
			},
			{
				OptionName->CalibrantStorageCondition,
				Default->Null,
				Description->"For each calibrants used in the experiment, the non-default condition under which the calibrants should be stored after the protocol is complete. If not set, the storage condition will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			IndexMatchingInput->"experiment samples"
		],
		{
			OptionName -> CalibrantNumberOfShots,
			Default -> Automatic,
			Description -> "The number of times the mass spectrometer fires the laser during calibration.",
			ResolutionDescription -> "Is automatically set to 100 for MALDI mass spectrometry, otherwise is set to Null.",
			AllowNull -> True,
			Category -> "MALDI Ionization",
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[50,10000]
			]
		},
		{
			OptionName -> MatrixControlScans,
			Default -> Automatic,
			Description -> "Indicates if matrix control samples will be spotted to MALDI plate and investigated as the blank control during the experiment for each different combination of MALDI experiment parameters.",
			ResolutionDescription -> "Is automatically set to True for MALDI mass spectrometry, otherwise is set to Null.",
			AllowNull -> True,
			Category -> "MALDI Sample Preparation",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},

		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 300 Microliter."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"HPLC vial (high recovery)\"]."
			}
		],
		{
			OptionName -> ImageSample,
			Default -> True,
			Description -> "Indicates if any samples that are modified in the course of the experiment are imaged after running the experiment.",
			AllowNull -> False,
			Category -> "Post Experiment",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		SimulationOption,
		AnalyticalNumberOfReplicatesOption (* ,
		SubprotocolDescriptionOption,
*)
	}
];

(* Shared Errors *)
Error::CalibrantIncompatibleWithIonSource="For the following input samples, `1`, the chosen calibrant `2` cannot be used with `3` ionization; therefore, cannot be used for this measurement. If you wish to run an experiment using the ionization type `3`, consider leaving Calibrant blank, otherwise adjust the IonSource option to `4`. Please refer to the documentation for a list of suitable calibrants for each ionization type.";
Error::IncompatibleInstrument="The chosen mass spectrometer `1` does not have `2` IonSource capabilities; therefore, cannot be used for this measurement. If you wish to run an experiment with the ionization type `2`, consider using `3` as Instrument, otherwise adjust the IonSource option to `4` or leave it blank.";
Error::UnneededOptions="The following options, `1` cannot be applied to current IonSource and MassAnalyzer combination. Specifically `2` can only be applied for IonSources: `3` and MassAnalyzer: `4`. Please change accordingly, or leave these options unspecified for samples `5`.";
Error::MassSpecRequiredOptions="When IonSource->`1` and MassAnalyzer->`2`, or a `1`-instrument with `2` as mass analyzer was specified, the options `3` cannot be set to Null. Please provide values for these options for the input samples `4`, or leave these options unspecified.";
Warning::SamplesOutOfMassDetection="The molecular weights of `1` fall outside the specified mass range. In order to capture data about these samples, you may wish to update your mass ranges.";
Error::InvalidMassDetection="The min mass must always be less than the max mass. Please ensure you haven't swapped these values for `1`";
Warning::LowMinMass="For input samples `1`, the instrument `2` is likely to produce noisy data in the lower mass range requested because a high abundance of background peaks in this mass range is common. Consider adjusting the lower limit of the MassDetection to above `3`.";
Error::UnknownAnalytes="The supplied analytes, `1`, are not contained within the Composition field of the input sample(s), `2`. Please only supply analytes that are present in the input samples.";
Warning::FilteredAnalytes="The given analytes, `2`, will be filtered to only include, `3`, since the given analytes occupy a large mass range that will lead to a poor resolution for the given instrument. Please only include analytes that occupy a similar mass range or enqueue multiple runs for the sample(s), `1`, with different mass ranges.";
Error::IncompatibleMassAnalyzerAndInstrument="The chosen mass spectrometer `1` does not have capabilities to use `2` as MassAnalyzer ; therefore, cannot be used for this measurement. If you wish to run an experiment with the instrument `1`, consider using `3` as MassAnalyzer, otherwise leave it blank.";
Error::IncompatibleMassAnalyzerAndIonSource="Currently mass spectrometer with `1` as IonSouce does not have capabilities to use `2` as MassAnalyzer; therefore, cannot be used for this measurement. If you wish to run an experiment with the `1` as IonSource, consider using `3` as MassAnalyzer, otherwise leave it as Automatic.";
Error::MassSpectrometryInvalidCalibrants="For the following sample `1`, have invalid calibrant `2`. In order to be use as an valid calibrant, the model of the sample should have ReferencePeaksPositiveMode and/or ReferencePeaksNegativeMode filled and cannot be deprecated.";

(*ESI-QQQ Specific Errors*)
Error::InvalidSourceTemperatures="When using `1` as the instrument, for the samples `2`, the souce temperature option needs to be 150 Celsius, this instrument won't support the change of this option, please change this option back to 150 Celsius or leave it as Automatic.";
Error::InvalidDesolvationGasFlows="When using `1` as the instrument, for the samples `2`, DesolvationGasFlow option needs to have a unit of pressure (PSI), this instrument won't support using flow rate as the input, please change the unit to PSI or leave it as Automatic.";
Error::InvalidScanTime = "Sample(s) `1` have ScanTime(s) `2` outside the limit allowed by the instrumentation `3` for the MassDetection range(s). The time per discrete MassTolerance point in the MassDetection range must be between 3 microseconds and 5 seconds. Revise the MassDetection, ScanTime, and/or MassTolerance values for these samples.";
Error::InvalidConeGasFlow="When using `1` as the instrument, for the samples `2`, ConeGasFlow option needs to have a unit of pressure (PSI), this instrument won't support using flow rate as the input, please change the unit to PSI or leave it as Automatic.";
Error::InvalidInfusionSyringes="For the samples `1` using the direct infuion, the infusion syringes is not supported by the instrument, please use a proper syringes or use default syringe (Model[Container, Syringe, \"id:o1k9jAKOww7A\"]).";
Error::InvalidInfusionVolumes="For the samples `1` using the direct infuion, The infusion volumes `2` are not supported by the syringes, the valid volume should be larger than the syringe's min volume `4` while smaller than `5`.";
Error::InvalidMassToleranceInputs="For the samples `1` using the scan modes `2`, the MassTolerance option cannot be filled, please leave it Automatic. For ESI-QQQ, MassTolerance is an onption that only valid for ranged mass scan (e.g. MassDetection -> Span[100 Gram/Mole, 300 Gram/Mole]). Please change this option to Null or leave it as Automatic.";
Error::FragmentScanModeMisMatches="For samples `1` in ESI-QQQ, the Fragment options `2`, are not valid under the corresponding ScanMode `3`. For ScanMode (FullScan and SelectedIonMonitoring) that not requires fragmentation of the incoming camples, Fragment should be False. For other ScanModes, Fragment should be True. Please change this option accordingly or leave it as Automatic.";
Error::MassDetectionScanModeMismatches="For samples `1` in ESI-QQQ, the MassDetection options `2`, are not valid under the corresponding ScanMode `3`. For PrecursorIonScan, SelectedIonMonitoring, MultipleReactionMonitoring the input mass values should be a single value or a list of values, otherwise this option should be a range mass value (e.g. Span[100 Gram/Mole, 300 Gram/Mole]).";
Error::FragmentMassDetectionScanModeMismatches="For samples `1` in ESI-QQQ, the FragmentMassDetections options `2`, are not valid under the corresponding ScanMode `3`. For PrecursorIonScan and MultipleReactionMonitoring the input fragment mass detection values should be a single value or a list of values, for FullScan and SelectedIonMonitoring modes, this option should leave as Null or Automatic. For ProductIonScan and NeutralIonLoss as ScanMode, this should be range values (e.g. Span[100 Gram/Mole, 300 Gram/Mole]).";
Error::UnneededTandemMassSpecOptions="For samples `1` in ESI-QQQ in the non-tandem mass scan modes (FullScan and SelectedIonMonitoring) , the options `2` are not required, please set it to Automatic or Null.";
Error::VoltageInputIonModeMisMatches="For samples `1` in ESI-QQQ, the voltage options `2` should be consistent with the IonMode `3`. If the IonMode is positive, all voltage inputs should be positive. If the IonMode is Negative, all voltage inputs should be negative.";
Error::TooShortRunDurations="For samples `1` in ESI-QQQ, each mass scan cycle needs `2` to finish, therefore the input RunDuration `3`  cannot finish one mass scan. Please input a longer RunDuration time or leave as Automatic.";
Error::InvalidMultipleReactionMonitoringLengthOfInputOptions="For samples `1` in ESI-QQQ in MultipleReactionMonitoring mode, the following options `2` don't have same length as MassDetection options. Please change number of inputs of `2` options to be `3`.";
Error::InputOptionsMRMAssaysMismatches="For samples `1` in ESI-QQQ in MultipleReactionMonitoring mode, the input `2` options are different from the MultipleReactionMonitoringAssays options, thereby the function cannot determine which value should be used in the experiment. Please either fill {CollisionEnergy,MassDetection,FragmentMassDetection and DwellTime} or only fill MultipleReactionMonitoringAssays option, or make sure they are identical.";
Warning::TooManyMultpleReactionMonitoringAssays="For samples `1` in ESI-QQQ, the input MultipleReactionMonitoringAssays has a length of `2`, this may influence the quality of the data. Please consider separating this experiment into several separate MultipleReactionMonitoring experiments for higher quality data.";
Warning::AutoNeutralLossValueWarnings="For samples `1` in ESI-QQQ using NeutralIonLoss as the ScanMode, a valid mass value in NeutralLoss option needs to be specified in order to generate useful and reliable data. The experiment can further procees with an automatically assigned value (50 gram/mole), but this experiment may not generate any usefule results.";
Warning::AutoResolvedMassDetectionFixedValue="For samples `1` in ESI-QQQ using `2` as the ScanMode, a single mass value (for ProductIonScan mode only) or a list of mass values (for MultipleReactionMonitoring and SelectedIonMonitoring mode) should be specified in MassDetection option. The experiment will proceed with MassDetection being resolved based on samples' molecular weights (if exist) or was arbitrarily set to 500 gram/mole. Proper mass values for this option needs to be specified to collect useful data.";
Warning::AutoResolvedFragmentMassDetectionFixedValues="For samples `1` in ESI-QQQ using `2` as the ScanMode, a single mass value (for PresursorIonScan mode only) or a list of mass values (for MultipleReactionMonitoring mode) should be specified in FragmentMassDetection option. The experiment will proceed with FragmentMassDetection being resolved based on MassDetection or was arbitrarily set to 500 gram/mole. Proper mass values for this option needs to be specified to collect useful data.";


(*ESI-QQQ Specifie Warnings*)
Warning::ESITripleQuadTooManyCalibrants="For this protocol running in ESI-QQQ, there are `1` calibrants are not the default calibrants of this instrument: `2`. For the precision of the instrument, only the first one,`3`, will be used for the calibration:";

(* ESI specific errors *)
Error::FlowInjectionRequiredOptions="When InjectionType->FlowInjection, the options `1` cannot be set to Null. Please provide values for these options for the input samples `2`, or leave these options unspecified.";
Error::DirectInfusionUnneededOptions="The following options, `1` only apply when the type of injection is FlowInjection, but InjectionType->DirectInfusion was specified. Please update InjectionType, or leave these options unspecified for samples `2`.";
Error::FlowInjectionUnneededOptions="The following options, `1` only apply when the type of injection is DirectInfusion, but InjectionType->FlowInjection was specified. Please update InjectionType, or leave these options unspecified for samples `2`.";
Warning::DefaultMassDetection="For samples `1`, the molecular weight is unknown and the sample type is generic. As a result a default mass range of 350-2000 m/z will be chosen, which may not cover the mass of the analyte(s) of interest. If you have a sense of the expected mass(es), please consider providing a custom mass range or informing the molecular weight of the samples.";
Error::TooManyESISamples="The number of input samples * NumberOfReplicates, `1`, exceeds the threshold for measurement for this protocol. Please select `2` or less samples to run with this protocol or split your samples into multiple protocols.";
Error::MassSpectrometryIncompatibleAliquotContainer="For the following sample(s), `1`, AliquotContainer is set to a container that is not comptatible with this experiment. Please specify one of the following containers , `2`, or leave this option Automatic.";
Error::IncompatibleMassDetection="The ESI instrument `1` does not have the capability to measure masses up to `2`. If you wish to run an experiment covering the requested mass range, consider using the MALDI instrument Model[Instrument, MassSpectrometer, \"Microflex LT\" for `3`, otherwise adjust the upper limit of the MassDetection to below 100 000 Dalton or leave it blank.";
Warning::CalibrantMassDetectionMismatch="For the following input samples, `1`, the mass range that is chosen or automatically determined, `2`, does not fully lie inside the calibrant's `3` mass range, which may result in suboptimal calibration for the masses outside the calibrant's mass range. Consider adjusting the mass range or choosing a different calibrant. Please refer to the documentation for a list of suitable combinations of mass range and calibrants.";
Error::InvalidESIQTOFVoltagesOption="For ESI-QTOF Instruments, all Voltages input (ESICapillaryVoltages and StepwaveVoltages) should be positive, the input sample `1` has voltage options input `2` that are not positive. Please change them to a positive value or leave them as Automatic.";
Error::InvalidESIQTOFGasOption="For ESI-QTOF Instruments, all Gas input (DesolvationGasFlow and ConeGasFlow) needs to be with a unit of flow rate (L/Min), the input sample `1` has gas options input `2` that have units of PSI. Please change the units to PSI or leave them as Automatic.";
Error::InvalidESIQTOFMassDetectionOption="The following samples `1` have MassDetection input that is not a range of Masses, this input is not support by current instrument, if you want to run single mass selection please switch to ESI-QQQ";
Error::InvalidESIQTOFScanTimeOption="The specified values for the the ScanTime option are `1`, but for ESI-QTOF instruments, the maximum allowed value for the ScanTime option is 10 seconds. Please reduce the specified scan time, or consider switching to ESI-QQQ."
Error::OutRangedDesolvationTemperature="The following samples `1` have DesolvationTemperature input that higher than 650 Celsius, this temperature is too high for current instrument (ESI-QTOF), please switch to a smaller temperature (<650 Celsius) or leave this option as Automatic.";
Error::MassSpectrometryNotEnoughVolume="The following sample `1` only have volumes `2`, thereby do not have enough volumes `3` to finish the experiment, consider using a different samples or dilute the sample to desired amount. If DirectInfusion is chosen as the InjectionMode, consider using FlowInjection which requires much smaller amount of sample to finish the experiment.";
Warning::InfusionVolumeLessThanRunDurationTimesFlowRate = "The InfusionVolume for the sample(s) `1` is `2` which is unable to sustain a RunDuration of `3` at an InfusionFlowRate of `4`. Data generated late in the run from the sample(s) will contain only residual sample and background.";

(* MALDI specific errors *)
Warning::UnknownMolecularWeight="The molecular weight of the analytes in the sample(s), `1`, is unknown. As a result a default mass range will be chosen, and the analyte(s) of interest may not be detected if it falls outside of the range. If you have a sense of the expected weight, please consider providing a value for the option MassDetection.";
Warning::IncompatibleCalibrant = "The molecular weights of the analytes (either provided by the user with the option Analytes or deduced from the sample's composition) in the sample(s), `1`, fall outside the range formed by the reference peaks in the calibrants. Consider choosing a calibrant with reference peaks which would flank the expected sample peak(s).";
Error::InvalidLaserPowerRange="The min laser power must be less than the max laser power. Please ensure you haven't swapped these values for `1`";
Error::InvalidCalibrantLaserPowerRange="The min laser power used for the calibrant must be less than the max laser power. Please ensure you haven't swapped these values for `1`";
Error::UnsupportedMALDIPlate="The requested MALDI plate is not supported. Please choose a plate with one the following models: `1`";
Error::TooManyMALDISamples="The MALDI plate has `1` total wells, but the input samples (including any replicates) required `2` wells. Please consider splitting this into multiple protocols.";
Error::UnableToCalibrate="In order to calibrate the instrument there must be at least one calibrant peak in the mass range. Please check the mass ranges for the following samples: `1`.";
Error::NotEnoughReferencePeaks="In order to calibrate the instrument there must be at least 3 calibrant peaks in the specified mass ranges. Please adjust mass ranges for the following samples: `1`.";
Error::SpottingInstrumentIncompatibleAliquots="There is no suitable aliquot container which can hold the requested aliquot volume and still fit on the robotic liquid handler used to prepare the MALDI plate. Please specify an AssayVolume/AliquotVolume below 50mL for `1`.";
Error::ExceedsMALDIPlateCapacity="There are only `1` wells available with the given spotting pattern, but these protocol settings require `2` wells (`3` sample wells, `4` calibrant wells and `5` matrix control wells). Please consider splitting this into multiple protocols.";
Error::invalidMALDITOFMassDetectionOption="The following samples `1` have MassDetection input that is not a range of Masses, this input is not support by current instrument, if you want to run single mass selection please switch to ESI-QQQ.";
Error::MALDINumberOfShotsTooSmall="For MALDI-TOF measurement, the NumberOfShots has to be larger than ShotsPerRaster in order to finish at least one data collection on one spot. Please increase NumberOfShots or decrease ShotsPerRaster or leave these options as Automatic.";
Error::MALDICalibrantNumberOfShotsTooSmall="For MALDI-TOF measurement, the CalibrantNumberOfShots has to be larger than ShotsPerRaster in order to finish at least one data collection on one spot. Please increase CalibrantNumberOfShots or decrease ShotsPerRaster or leave these options as Automatic.";
Error::InvalidMatrixSample="Matrix `1` must have a parent Model of the type Model[Sample, Matrix]. Please update the model for these objects or specify an alternative Object[Sample] or a Model[Sample, Matrix] instead.";
Error::UninformedModelMatrix="Matrix must be models (or objects with models) where SpottingDryTime and SpottingVolume are informed. Please update the fields `2` for Model[Sample, Matrix] of `1` or specify an alternative Matrix.";
Error::InvalidCalibrantMatrixSample="CalibrantMatrix `1` must have a parent Model of the type Model[Sample, Matrix]. Please update the model for these objects or specify an alternative Object[Sample] or a Model[Sample, Matrix] instead.";
Error::UninformedModelCalbirantMatrix="CalibrantMatrix must be models (or objects with models) where SpottingDryTime and SpottingVolume are informed. Please update the fields `2` for Model[Sample, Matrix] of `1` or specify an alternative CalibrantMatrix.";


(* ::Subsubsection::Closed:: *)
(*ExperimentMassSpectrometry Experiment function*)

(* Set a flag to determine whether we will do automatic MALDI calibration *)
$AutomaticMALDICalibration=True;

(* Experiment Function Container overload that takes containers (or containers and samples *)
ExperimentMassSpectrometry[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, containerToSampleOutput, sampleCache,
		samples, sampleOptions, containerToSampleTests, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, updatedSimulation, updatedCache, containerToSampleSimulation},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMassSpectrometry,
			ToList[myContainers],
			ToList[myOptions],
			DefaultPreparedModelAmount -> 300 Microliter,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "HPLC vial (high recovery)"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentMassSpectrometry,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentMassSpectrometry,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentMassSpectrometry[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];


(* This is the core function taking only samples as input *)
ExperimentMassSpectrometry[mySamples:ListableP[ObjectP[Object[Sample]]],myExperimentOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,listedSamples,outputSpecification,output,gatherTests,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,suppliedMALDIPlate,suppliedCalibrants,suppliedMatrices,
		suppliedCalibrantSamples,suppliedMatrixSamples,allRelevantCalibrantModels,matrixModels,liquidHandlerContainers,containerModelFields,
		containerModelPacket,maldiPlateFields,suppliedAliquotContainers,suppliedContainerObjects,sampleModelFields,suppliedInfusionSyringes,
		sampleFields,dereferencedSampleModelPacket,samplePacket,gradientPrimeFlushMethod,suppliedCalibrantMatrices,infusionSyringeSamples,
		dereferencedMatrixModelPacket,matrixModelPacket,matrixPacket,calibrantModelFields,dereferencedCalibrantModelPacket,allRelevantSyringeModels,
		calibrantModelPacket,calibrantDownloadPacket,gradientFields,availableESIInstrumentModels,instrumentFields,lcInstrumentFields,
		matrixModelFields,downloadedPackets,cacheBall,resolvedOptionsResult,suppliedCalibrantSampleModels,allRelevantInstrumentModels,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolPacket,methodPackets,resourcePacketTests,protocolObject,
		validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation,
		mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed, inheritedCache,
		simulatedSampleIdentityModelFields,containerObjectFields,suppliedContainerModels,suppliedFilterSyringes,
		suppliedInstrumentObject
	},


	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myExperimentOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMassSpectrometry,
			listedSamples,
			listedOptions
		],
		$Failed,
	 	{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentMassSpectrometry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMassSpectrometry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentMassSpectrometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMassSpectrometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];



	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myExperimentOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentMassSpectrometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMassSpectrometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentMassSpectrometry,{mySamplesWithPreparedSamples},inheritedOptions]];

	(* Correct or MRM Assay, DwellTime and CollisionEnergy Options *)
	If[!MatchQ[Lookup[inheritedOptions, MultipleReactionMonitoringAssays], Alternatives[Automatic, {Automatic...}]],
		(* If MRM Assays was specified.. *)
		Which[
			(* If MRM Assays is a list of list of lists, it is fully specified for multiple samples *)
			ArrayDepth[Lookup[inheritedOptions, MultipleReactionMonitoringAssays]] >= 3, Nothing,
			(* If MRM Assays is a list of list whose length matches samples, assume its index-matched to samples *)
			ArrayDepth[Lookup[inheritedOptions, MultipleReactionMonitoringAssays]] == 2 && Length[Lookup[inheritedOptions, MultipleReactionMonitoringAssays]] == Length[listedSamples],
			(* ExpandIndexMatchedInputs incorrectly expanded it, undo the expansion. *)
			expandedSafeOps = ReplaceRule[expandedSafeOps, {MultipleReactionMonitoringAssays -> Lookup[inheritedOptions, MultipleReactionMonitoringAssays]}],
			(* Otherwise assume its a list to be applied to each sample and ExpandIndexMatchedInputs output it correct *)
			True, Nothing
		];
		If[!MatchQ[Lookup[inheritedOptions, DwellTime], Alternatives[Automatic, {Automatic...}]],
			(* If DwellTime and MRM Assays were specified.. *)
			Which[
				(* If DwellTime is a list of list of lists, it is fully specified for multiple samples *)
				ArrayDepth[Lookup[inheritedOptions, DwellTime]] >= 3, Nothing,
				(* If DwellTime is a list of list whose length matches samples, assume its index-matched to samples *)
				Length[ToList[Lookup[inheritedOptions, DwellTime]]] == Length[listedSamples],
				(* ExpandIndexMatchedInputs incorrectly expanded DwellTime, undo the expansion. *)
				expandedSafeOps = ReplaceRule[expandedSafeOps, {DwellTime -> ToList[Lookup[inheritedOptions, DwellTime]]}],
				(* Otherwise assume its a list to be applied to each sample and ExpandIndexMatchedInputs output it correct *)
				True, Nothing
			];
		];
		If[!MatchQ[Lookup[inheritedOptions, CollisionEnergy], Alternatives[Automatic, {Automatic...}]],
			(* If CollisionEnergy and MRM Assays were specified.. *)
			Which[
				(* If CollisionEnergy is a list of list of lists, it is fully specified for multiple samples *)
				ArrayDepth[Lookup[inheritedOptions, CollisionEnergy]] >= 3, Nothing,
				(* If CollisionEnergy is a list of list whose length matches samples, assume its index-matched to samples *)
				Length[ToList[Lookup[inheritedOptions, CollisionEnergy]]] == Length[listedSamples],
				(* ExpandIndexMatchedInputs incorrectly expanded CollisionEnergy, undo the expansion. *)
				expandedSafeOps = ReplaceRule[expandedSafeOps, {CollisionEnergy -> ToList[Lookup[inheritedOptions, CollisionEnergy]]}],
				(* Otherwise assume its a list to be applied to each sample and ExpandIndexMatchedInputs output it correct *)
				True, Nothing
			];
		];
	];

	(* Lookup supplied objects from options *)
	{suppliedCalibrants,suppliedMatrices,suppliedCalibrantMatrices,suppliedFilterSyringes}=Lookup[expandedSafeOps,{Calibrant,Matrix,CalibrantMatrix,FilterSyringe}];

	(* Assume we're doing MALDI for the download *)
	suppliedMALDIPlate=resolveAutomaticOption[MALDIPlate,expandedSafeOps,Model[Container, Plate, MALDI, "96-well Ground Steel MALDI Plate"]];

	(* Get just the samples - we'll need to download all models for resolution *)
	suppliedCalibrantSamples=Cases[suppliedCalibrants,ObjectP[Object[Sample]]];
	suppliedCalibrantSampleModels=Cases[suppliedCalibrants,ObjectP[Model[Sample]]];
	suppliedMatrixSamples=Cases[Flatten[{suppliedMatrices,suppliedCalibrantMatrices}],ObjectP[Object[Sample]]];

	(* Get all relevant calibrant and matrix models *)
	allRelevantCalibrantModels=allMassSpectrometrySearchResults["MassSpecCache"][[1]];
	matrixModels=allMassSpectrometrySearchResults["MassSpecCache"][[2]];

	(* Since part of MALDI unit test requires $DeveloperSearch and We cannot bypass is easily, so hardcode the MALDI instruments here for unit tests *)
	allRelevantInstrumentModels=If[
		TrueQ[$DeveloperSearch],
		{
			Model[Instrument, MassSpectrometer, "Microflex LT"],
			Model[Instrument, MassSpectrometer, "Microflex LRF"]
		},
		allMassSpectrometrySearchResults["MassSpecCache"][[3]]
	];
	allRelevantSyringeModels=allMassSpectrometrySearchResults["MassSpecCache"][[4]];


	(* Input samples: download extra fields needed by sample prep resolvers *)
	sampleModelFields=DeleteDuplicates@Flatten[{StandardComponents,Acid,Base,Structure,PolymerType,AluminumFoil,Parafilm,SamplePreparationCacheFields[Model[Sample]]}];
	sampleFields=Flatten[{pH,Acid,Base,SamplePreparationCacheFields[Object[Sample]]}];
	simulatedSampleIdentityModelFields = {pKa,Acid,Base,Molecule,MolecularWeight,StandardComponents,PolymerType};

	dereferencedSampleModelPacket=Packet[Model[sampleModelFields]];
	samplePacket=Packet@@sampleFields;

	(* Calibrant: in addition to calibrant fields, download fields needed from the SamplesIn in case calibrant and inputs overlap *)
	(* This prevents a MssingCacheField error since Download complains if two packets for the same object appear in the cache and only one has the needed fields *)
	calibrantModelFields=Join[{ReferencePeaksPositiveMode,ReferencePeaksNegativeMode,PreferredMALDIMatrix,PreferredSpottingMethod,CompatibleIonSource},sampleModelFields];
	dereferencedCalibrantModelPacket=Packet[Model[calibrantModelFields]];
	calibrantModelPacket=Packet@@calibrantModelFields;
	calibrantDownloadPacket=Packet@@Join[sampleFields,sampleModelFields];

	(* Lookup supplied objects from options *)
	suppliedInfusionSyringes=Lookup[expandedSafeOps,InfusionSyringe];

	(* Select those infusion syringe that were input as Object[Sample]*)
	infusionSyringeSamples=Cases[suppliedInfusionSyringes,ObjectP[Object[Container,Syringe]]];

	(* Set fields to download from gradient objects *)
	gradientFields = Packet[BufferA,BufferB,BufferC,BufferD,Gradient];

	(*all the instruments to use*)
	availableESIInstrumentModels={Model[Instrument, MassSpectrometer, "Xevo G2-XS QTOF"]};

	instrumentFields=Packet[IonSources,MassAnalyzer,Detectors,Objects,MaxMass];
	lcInstrumentFields=Packet[IntegratedHPLC[{Detectors}]];

	(* Matrix: in addition to calibrant fields, download fields needed from the SamplesIn in case matrix and inputs overlap*)
	matrixModelFields=Join[{SpottingDryTime,SpottingVolume},sampleModelFields];
	dereferencedMatrixModelPacket=Packet[Model[matrixModelFields]];
	matrixModelPacket=Packet@@matrixModelFields;
	matrixPacket=Packet@@Join[sampleFields,sampleModelFields];

	(* Get all containers which can fit on the liquid handler - we must make sure our matrices and calibrants are in one of these *)
	liquidHandlerContainers=DeleteDuplicates[
		Prepend[
			Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling],
			PreferredContainer[1.5 Milliliter]
		]
	];

	containerModelFields=DeleteDuplicates@Flatten[{SamplePreparationCacheFields[Model[Container]],RequestedResources,DeadVolume,InnerDiameter,Contents,TareWeight,Status,NumberOfWells,ConnectionType,AluminumFoil,Parafilm}];
	containerModelPacket=Packet@@containerModelFields;

	containerObjectFields=SamplePreparationCacheFields[Object[Container]];

	(*Generate a gradient prime method so we can download it later*)
	gradientPrimeFlushMethod={Object[Method, Gradient, "System Prime Method-Acquity I-Class UPLC FlowInjection"],Object[Method,Gradient,"System Prime Method for QTRAP 6500"]};

	(* Download model info (must dereference if given an object) *)
	maldiPlateFields=If[MatchQ[suppliedMALDIPlate,ObjectP[Object]],
		Packet[Model[Flatten[{containerModelFields,NumberOfWells,AspectRatio}]]],
		Packet@@Flatten[{containerModelFields,NumberOfWells,AspectRatio}]
	];

	suppliedAliquotContainers=Lookup[expandedSafeOps,AliquotContainer];

	(* Get just the containers - we'll need to download all models for resolution *)
	suppliedContainerObjects=Cases[Flatten[{suppliedAliquotContainers,suppliedFilterSyringes}],ObjectP[Object[Container]]];
	suppliedContainerModels=Cases[Flatten[{suppliedAliquotContainers,suppliedFilterSyringes,allRelevantSyringeModels}],ObjectP[Model[Container]]];
	suppliedInstrumentObject=Cases[Flatten[{Lookup[expandedSafeOps,Instrument]}],ObjectP[Object[Instrument]]];

	(* -- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION -- *)
	inheritedCache = Lookup[expandedSafeOps, Cache];
	downloadedPackets=Check[
		Quiet[
			Download[
				{
					(*1*)mySamplesWithPreparedSamples,
					(*2*)suppliedCalibrantSamples,
					(*3*)suppliedCalibrantSampleModels,
					(*4*)allRelevantCalibrantModels,
					(*5*)suppliedMatrixSamples,
					(*6*)matrixModels,
					(*7*)liquidHandlerContainers,
					(*8*){suppliedMALDIPlate},
					(*9*)suppliedContainerObjects,
					(*system prime and flush gradients*)
					(*10*)gradientPrimeFlushMethod,
					(*new system prime buffer for ESI-QTOF*)
					(*12*)allRelevantInstrumentModels,
					(*13*)infusionSyringeSamples,
					(*14*)allRelevantSyringeModels,
					(*15*)suppliedInstrumentObject
				},
				{
					(*1*){
							samplePacket,
							dereferencedSampleModelPacket,
							Packet[Container[containerObjectFields]],
							Packet[Model[StandardComponents[PolymerType]]],
							Packet[Composition[[All,2]][simulatedSampleIdentityModelFields]],
							Packet[Container[Model][containerModelFields]]
						},
					(*2*){calibrantDownloadPacket,dereferencedCalibrantModelPacket},
					(*3*){calibrantModelPacket},
					(*4*){calibrantModelPacket},
					(*5*){matrixPacket,dereferencedMatrixModelPacket},
					(*6*){matrixModelPacket},
					(*7*){containerModelPacket},
					(*8*){maldiPlateFields},
					(*9*){Packet[Sequence@@containerObjectFields]},
					(*10*){gradientFields},
					(*12*){instrumentFields,Packet[Objects[{IntegratedHPLC,Model}]],Packet[Objects[IntegratedHPLC][Detectors]]},
					(*13*){Packet[Model[Object]]},
					(*14*){containerModelPacket},
					(*15*){Packet[Model]}
				},
				Date->Now,
				Cache->inheritedCache,
				Simulation -> updatedSimulation
			],
			{Download::FieldDoesntExist,Download::NotLinkField}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];
	(* Return early if objects do not exist *)
	If[MatchQ[downloadedPackets,$Failed],
		Return[$Failed]
	];

	cacheBall=FlattenCachePackets[{inheritedCache, downloadedPackets}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
	(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveMassSpectrometryOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall, Simulation -> updatedSimulation, Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveMassSpectrometryOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall, Simulation -> updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMassSpectrometry,
		resolvedOptions,
		Ignore->ToList[myExperimentOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentMassSpectrometry,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{{protocolPacket,methodPackets},resourcePacketTests} = Switch[{Lookup[collapsedResolvedOptions,IonSource],Lookup[collapsedResolvedOptions,MassAnalyzer]},
		{ESI,QTOF},If[gatherTests,
			esiQTOFResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,Cache->cacheBall, Simulation -> updatedSimulation,Output->{Result,Tests}],
			{esiQTOFResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,Cache->cacheBall, Simulation -> updatedSimulation],{}}
		],
		{ESI,TripleQuadrupole},If[gatherTests,
			esiTripleQuadResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,Cache->cacheBall, Simulation -> updatedSimulation,Output->{Result,Tests}],
			{esiTripleQuadResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,Cache->cacheBall, Simulation -> updatedSimulation],{}}
		],
		{MALDI,TOF},If[gatherTests,
			maldiResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,Cache->cacheBall, Simulation -> updatedSimulation,Output->{Result,Tests}],
			{maldiResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,Cache->cacheBall, Simulation -> updatedSimulation],{}}
		]
	];


	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMassSpectrometry,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[protocolPacket,$Failed],
		UploadProtocol[
			{protocolPacket},
			{Replace[methodPackets,{}->Null]},
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			ConstellationMessage->Object[Protocol,MassSpectrometry],
			Cache->cacheBall,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentMassSpectrometry,collapsedResolvedOptions],
		Preview -> Null
	}
];



(* ::Subsubsection:: *)
(*resolveMassSpectrometryOptions*)


(* ========== resolveMassSpectrometryOptions Helper function ========== *)
(* resolves any options that are set to Automatic to a specific value and returns a list of resolved options *)
(* the inputs are the simulated samples, the safeOps from the experiment function, and any options passed to the resolver *)


DefineOptions[
	resolveMassSpectrometryOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveMassSpectrometryOptions[mySamples:{ObjectP[Object[Sample]]...},myExperimentOptions:{_Rule...},myResolverOptions:OptionsPattern[resolveMassSpectrometryOptions]]:=Module[{
	outputSpecification,output,gatherTests,messages,outsideEngine,cache,samplePrepOptions,massSpecSpecificOptions,simulatedSamples,
	resolvedSamplePrepOptions,simulatedCache,samplePrepTests,massSpecOptions,suppliedInstrument,suppliedIonSource,
	esiFlowInjectionSpecificOptionNames,suppliedESIFlowInjectionOptions,suppliedInjectionType,maldiSpecificOptionNames,suppliedESIQTOFOptions,
	esiQTOFSpecificOptionNames,suppliedMALDIOptions, suppliedESIOptions,numberOfSuppliedESIOptions,
	numberOfSuppliedMALDIOptions,dominatingIonSource,ionSource,instrument,	suppliedMALDIPlate,suppliedCalibrants,suppliedMatrices,suppliedName,
	suppliedCalibrantSamples,suppliedCalibrantModels,suppliedCalibrantsWithoutAutomatic,allRelevantCalibrantModels,allRelevantInstrumentModels,existingNamedProtocol,
	maldiPlateFields,	instrumentFields,suppliedAliquotContainers,suppliedAliquotContainerObjects,download,instrumentPacket,allInstrumentModelPackets,
	aliquotContainerPackets,sourceAndInstrumentTuples,sampleDownload,suppliedCalibrantSampleDownload,suppliedCalibrantModelDownload,relevantCalibrantModelDownload,maldiPlatePacket,
	simulatedSamplePackets,sampleModelPackets,containerModels,calibrantSamplePackets,calibrantSampleModelPackets,calibrantModelPackets,relevantCalibrantModelPackets,
	discardedSamplePackets,discardedInvalidInputs,discardedTests,nonLiquidSamplePackets,nonLiquidSampleInvalidInputs,nonLiquidSampleTests,
	resolvedAnalytes,invalidAnalytesResult,invalidAnalytes,invalidAnalyteSamples,validAnalytes,filteredAnalytePackets,differentAnalyteMassRangesResult,differentAnalyteMassRangeSamples,
	differentAnalyteMassRangeValidAnalytes,differentAnalyteMassRangeFilteredAnalytes,suppliedInfusionSyringes,
	suppliedMassRanges,validMassRanges,badMassRangeSamplePackets,badMassRangeSamples,invalidMassRangeOption,badMassRangeTests,
	sampleMolecularWeights,sampleMassInMassRange,name,
	outOfMassRangeSamplePackets,outOfMassRangeSamples,outOfMassRangeTests,validNameBoolean,nameTest,invalidNameOption,ionSourceInstrumentMismatchBoolean,
	suppliedInstrumentModel,ionSourceInstrumentMismatchTest,ionsSourceInstrumentMismatchOptions,suppliedInfusionSyringeSamples,syringeModelPacket,
	calibrantIonSourcePackets,calibrantIonSourceCompatibilities,ionSourceCalibrantMismatchBooleans,calibrantIonSourceMismatchSamplePackets,
	calibrantIonSourceMismatchSamples,mismatchedCalibrants,ionSourceCalibrantMismatchTests,ionSourceCalibrantMismatchOptions,
	requiredOptionsResults,requiredOptionsInputPackets,requiredOptions,suppliedCalibrantMatrices,
	requiredFlowInjectionOptionsResults,requiredFlowInjectionOptionsInputPackets,requiredFlowInjectionOptions,requiredFlowInjectionOptionsTests,
	unneededDirectInfusionOptionsResults,unneededDirectInfusionOptionsInputPackets,unneededDirectInfusionOptions,unneededDirectInfusionOptionsTests,
	requiredOptionsTests,unneededOptionsResults,unneededOptionsInputPackets,unneededOptions,unneededOptionsTests,maxMassSupportedBools,
	invalidMaxMassSamplePackets,invalidMaxMassTests,invalidMaxMassOptions,maldiNoiseLimit,esiNoiseLimit,minMassValidBool,
	badMinMassSamplePackets,badMinMassTests,preResolvedExperimentOptions,nonLiquidSamplesBool,discardedSamplesBool,booleans,
	ionSourceResolvedOptions,ionSourceSpecificTests,ionSourceSpecificInvalidOptions,ionSourceSpecificInvalidInputs,email,
	upload,resolvedEmail,invalidInputs,invalidOptions,allResolvedOptions,allTests,resultRule,testsRule,simulatedSamplesFields,simulatedSampleModelFields,
	simulatedSampleIdentityModelPackets,simulatedSampleIdentityModelFields,simulatedVolumes,
	resolvedCalibrants,samplesInStorages,calibrantStorages,validSamplesInStorageConditionBool,validSamplesInStorageConditionTests,samplesInStorageConditionInvalidOptions,
	validCalibrantStorageConditionBool,validCalibrantStorageConditionTests,calibrantStorageConditionInvalidOptions,calibrantNoModels,calibrantStorageNoModels,nonDiscardedSamples,nonDiscardedSampleStorages,
	suppliedMassAnalyzer,esiSyringeInfusionSpecificOptionNames,tandemMassSpecificAllowNullOptionNames,suppliedTandemMassAllowNullOptions,numberOfTandemMassAllowNullOptions,massAnalyzer,massAnalyzerInstrumentMismatchQ,massAnalyzerInstrumentMismatchTest,
	(*ESI-QQQ new options *)
	massAnalyzerInstrumentMismatchOptions,esiTripleQuadSpecificOptionNames,esiSpecificOptionNames,suppliedESITripleQuadOptions,suppliedESISyringeInfusionOptions,
	unneededFlowInjectionOptionsResults,unneededFlowInjectionOptionsInputPackets,unneededFlowInjectionOptions,unneededFlowInjectionOptionsTests,
	allRelevantSyringeModels,allSyringePackets,numberOfSuppliedESITripleQuadOptions,numberOfSuppliedESIQTOFOptions,suppliedESITripleQuadSpecificNames, suppliedESITripleQuadSpecificOptions,
	suppliedESIQTOFSpecificNames, suppliedESIQTOFSpecificOptions,nonDuplicatedUnneededSamples,unneededSamplesIonSourceAndMassAnalyzer,massAnalyzerIonSourceMismatchQ,massAnalyzerIonSourceMismatchTest,massAnalyzerIonSourceMismatchOptions,
	(*MassAnalyzer specified TandemMass options*)
	dominatingESIMassAnalyzer,instrumentModel,defaultMALDIInstrument,defaultESIQTOFInstrument,defaultESITripleQuadInstrument,preResolvedInstrumentSpecificTuple,
	fastCacheBall, maxSpecifiedMassValue, simulation, updatedSimulation
},

	(* -- SETUP OUR USER SPECIFIED OPTIONS AND CACHE -- *)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;
	outsideEngine=!MatchQ[$ECLApplication,Engine];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolverOptions],Cache, {}];
	simulation = Lookup[ToList[myResolverOptions], Simulation, Simulation[]];

	(* Separate out our MassSpectrometry options from our Sample Prep options. *)
	{samplePrepOptions,massSpecSpecificOptions}=splitPrepOptions[myExperimentOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentMassSpectrometry,mySamples,samplePrepOptions,Cache->cache,Simulation -> simulation, Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentMassSpectrometry,mySamples,samplePrepOptions,Cache->cache,Simulation -> simulation, Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	massSpecOptions=Association[massSpecSpecificOptions];

	(* -- RESOLVE THE MASTER SWITCH OF THE IONIZATION TYPE (IonSource and Instrument) *)
	(* This is needed early on since we need to make a decision upfront which things to download, and which resolver helper we're going to call below *)

	(* Lookup ionization related supplied values from options *)
	{suppliedInstrument,suppliedIonSource,suppliedMassAnalyzer}=Lookup[massSpecOptions,{Instrument,IonSource,MassAnalyzer}];

	(* assemble a list of options that are not defaulted (i.e. can be user supplied) and are specific for MALDI or ESI. Note that we can't default any of these since we have to do a silly Automatic (if Maldi, then default) *)
	(* MALDI *)
	maldiSpecificOptionNames={
		SpottingMethod,
		Matrix,
		CalibrantMatrix,
		GridVoltage,
		LensVoltage,
		DelayTime,
		Gain,
		LaserPowerRange,
		CalibrantLaserPowerRange,
		NumberOfShots,
		ShotsPerRaster,
		SpottingPattern,
		MALDIPlate,
		CalibrantVolume,
		CalibrantNumberOfShots,
		AccelerationVoltage,
		SampleVolume,
		SpottingDryTime,
		MatrixControlScans
	};

	(* ESI *)
	esiQTOFSpecificOptionNames={
		InjectionType,
		ESICapillaryVoltage,
		StepwaveVoltage,
		SourceTemperature,
		DesolvationTemperature,
		DesolvationGasFlow,
		InfusionFlowRate,
		ScanTime,
		RunDuration,
		DeclusteringVoltage,
		ConeGasFlow
	};
	esiTripleQuadSpecificOptionNames={
		InjectionType,
		ESICapillaryVoltage,
		SourceTemperature,
		DesolvationTemperature,
		DesolvationGasFlow,
		InfusionFlowRate,
		ScanTime,
		RunDuration,
		DeclusteringVoltage,
		IonGuideVoltage,
		ConeGasFlow,
		ScanMode
	};

	(*Build A ESI specific Option Name as the collection of ESI-QQQ and ESI-QTOF*)
	esiSpecificOptionNames=DeleteDuplicates[Join[esiTripleQuadSpecificOptionNames,esiQTOFSpecificOptionNames]];


	(* ESI-QQQ syringe options *)
	esiSyringeInfusionSpecificOptionNames={
		InfusionSyringe,
		InfusionVolume
	};

	(*ESI-QQQ and QTOF shared FlowInjection options*)

	esiFlowInjectionSpecificOptionNames={
		SampleTemperature,
		Buffer,
		NeedleWashSolution,
		InjectionVolume
	};

	tandemMassSpecificAllowNullOptionNames={
		FragmentMassDetection,
		DwellTime,
		CollisionEnergy,
		CollisionCellExitVoltage,
		NeutralLoss,
		MassTolerance,
		MultipleReactionMonitoringAssays
	};

	(*Generate ESI-QQQ and ESI-QTOF specific option name not shared by each other, most of their options are shared for now*)
	suppliedESITripleQuadSpecificNames=Complement[esiTripleQuadSpecificOptionNames,esiQTOFSpecificOptionNames];
	suppliedESIQTOFSpecificNames=Complement[esiQTOFSpecificOptionNames,esiTripleQuadSpecificOptionNames];

	(* get the option values for the ESI and MALDI specific options *)
	suppliedMALDIOptions=Lookup[massSpecOptions,#]&/@ maldiSpecificOptionNames;
	suppliedESIQTOFOptions=Lookup[massSpecOptions,#]&/@esiQTOFSpecificOptionNames;
	suppliedESITripleQuadOptions=Lookup[massSpecOptions,#]&/@esiTripleQuadSpecificOptionNames;
	suppliedESIOptions=Lookup[massSpecOptions,#]&/@esiSpecificOptionNames;

	(*Check ESI-QQQ and ESI-QTOF options that are not shared with each other*)
	suppliedESITripleQuadSpecificOptions=Lookup[massSpecOptions,#]&/@suppliedESITripleQuadSpecificNames;
	suppliedESIQTOFSpecificOptions=Lookup[massSpecOptions,#]&/@suppliedESIQTOFSpecificNames;

	(* Check if Tandem MassSpec option is specified by user*)
	suppliedTandemMassAllowNullOptions=Lookup[massSpecOptions,#]&/@tandemMassSpecificAllowNullOptionNames;

	(* get the option values for the injection type options *)
	suppliedESISyringeInfusionOptions=Lookup[massSpecOptions,#]&/@esiSyringeInfusionSpecificOptionNames;
	suppliedESIFlowInjectionOptions=Lookup[massSpecOptions,#]&/@esiFlowInjectionSpecificOptionNames;

	(* count how many option values were supplied by the user for MALDI and for ESI *)
	numberOfSuppliedESIQTOFOptions =Count[!MatchQ[#,({Automatic ..}|Automatic)]&/@ suppliedESIQTOFOptions,True];
	numberOfSuppliedESITripleQuadOptions =Count[!MatchQ[#,({Automatic ..}|Automatic)]&/@ suppliedESITripleQuadOptions,True];
	numberOfSuppliedESIOptions =Count[!MatchQ[#,({Automatic ..}|Automatic)]&/@ suppliedESIOptions,True];
	numberOfSuppliedMALDIOptions=Count[!MatchQ[#,({Automatic..}|Automatic)]&/@ suppliedMALDIOptions,True];
	(* Check how many tandem mass options specified by user are not Automatic*)
	numberOfTandemMassAllowNullOptions=Count[(MatchQ[#,Except[{Automatic..}|Automatic]]&/@ suppliedTandemMassAllowNullOptions),True];

	dominatingIonSource=If[numberOfSuppliedMALDIOptions>numberOfSuppliedESIOptions,MALDI,ESI];
	dominatingESIMassAnalyzer=If[numberOfSuppliedESITripleQuadOptions>numberOfSuppliedESIQTOFOptions,TripleQuadrupole,QTOF];



	(* Lookup supplied objects from options *)
	{suppliedCalibrants,suppliedMatrices,suppliedCalibrantMatrices,suppliedName,suppliedInjectionType,suppliedInfusionSyringes}=Lookup[massSpecOptions,{Calibrant,Matrix,CalibrantMatrix,Name,InjectionType,InfusionSyringe}];

	(* Lookup MALDI plate or default it *)
	suppliedMALDIPlate=resolveAutomaticOption[MALDIPlate,massSpecOptions,Model[Container, Plate, MALDI, "96-well Ground Steel MALDI Plate"]];

	(* Get just the samples - we'll need to download all models for resolution *)
	suppliedCalibrantSamples=Cases[suppliedCalibrants,ObjectP[Object[Sample]]];

	(* Get just the samples - we'll need to download all models for resolution *)
	suppliedCalibrantModels=Cases[suppliedCalibrants,ObjectP[Model[Sample]]];

	suppliedCalibrantsWithoutAutomatic=If[MatchQ[#,Automatic],Null,#]&/@suppliedCalibrants;

	(*Generate syringe that we need to download their models*)
	suppliedInfusionSyringeSamples=Cases[suppliedInfusionSyringes,ObjectP[Object[Container,Syringe]]];

	(* Get all relevant calibrant and matrix models *)
	allRelevantCalibrantModels = allMassSpectrometrySearchResults["MassSpecCache"][[1]];

	(* Since part of MALDI unit test requires $DeveloperSearch and We cannot bypass is easily, so hardcode the MALDI instruments here for unit tests *)
	allRelevantInstrumentModels=If[
		TrueQ[$DeveloperSearch],
		{
			Model[Instrument, MassSpectrometer, "Microflex LT"],
			Model[Instrument, MassSpectrometer, "Microflex LRF"]
		},
		allMassSpectrometrySearchResults["MassSpecCache"][[3]]
	];
	allRelevantSyringeModels = allMassSpectrometrySearchResults["MassSpecCache"][[4]];

	(* Download model info (must dereference if given an object) *)
	maldiPlateFields=If[MatchQ[suppliedMALDIPlate,ObjectP[Object]],
		Packet[Model[{NumberOfWells}]],
		Packet[NumberOfWells]
	];

	instrumentFields=If[MatchQ[suppliedInstrument,ObjectP[Object]],
		Packet[Model[{IonSources,MassAnalyzer,Detectors}]],
		Packet[IonSources,MassAnalyzer,Detectors]
	];

	suppliedAliquotContainers=Lookup[samplePrepOptions,AliquotContainer];

	(* Get just the containers - we'll need to download all models for resolution *)
	suppliedAliquotContainerObjects=Cases[suppliedAliquotContainers,ObjectP[Object[Container]]];

	(*Create download packet fields for simulatedSamples*)
	simulatedSamplesFields = Packet@@Flatten[{pH,Acid,Base,SamplePreparationCacheFields[Object[Sample]]}];
	simulatedSampleModelFields = Flatten[{StandardComponents,Acid,Base,Structure,PolymerType,SamplePreparationCacheFields[Model[Sample]]}];
	simulatedSampleIdentityModelFields = {pKa,Acid,Base,Molecule,MolecularWeight,StandardComponents,PolymerType};

	(*We will donwload all instrument model and object for our own conveniences*)


	download=Quiet[
		Download[
			{
				(*1*)simulatedSamples,
				(*2*)suppliedCalibrantsWithoutAutomatic,
				(*3*)suppliedCalibrantsWithoutAutomatic,
				(*4*)allRelevantCalibrantModels,
				(*5*){suppliedMALDIPlate},
				(*6*)allRelevantInstrumentModels,
				(*7*)allRelevantSyringeModels,
				(*8*)suppliedAliquotContainerObjects,
				(*9*)suppliedInfusionSyringeSamples
			},
			{
				(*1*){
					(*1*)simulatedSamplesFields,
					(*2*)Packet[Model[simulatedSampleModelFields]],
					(*3*)Container[Model][Object],
					(*4*)Packet[Model[StandardComponents][PolymerType]],
					(*5*)Packet[Composition[[All,2]][simulatedSampleIdentityModelFields]],
					(*6*)Packet[Container[Model][MinVolume]],
					(*7*)Packet[Container[Model][MaxVolume]],
					(*8*)Packet[Container[Model]],
					(*9*)Packet[Container[Model][InternalDepth]],
					(*10*)Packet[Container[Model][WellDepth]]
			},
				(*2*){Packet[Model],Packet[Model[CompatibleIonSource]]},
				(*3*){Packet[CompatibleIonSource]},
				(*4*){Packet[ReferencePeaksPositiveMode,ReferencePeaksNegativeMode,PreferredMALDIMatrix,PreferredSpottingMethod]},
				(*5*){maldiPlateFields},
				(*6*){Packet[IonSources,MassAnalyzer,Detectors,MaxMass]},
				(*7*){Packet[MaxVolume,MinVolume,DeadVolume,InnerDiameter]},
				(*8*){Packet[Model,Name,Status,Contents,TareWeight]},
				(*9*){Packet[Model]}
			},
			Date->Now,
			Cache->cache,
			Simulation -> updatedSimulation
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];
	simulatedCache = FlattenCachePackets[{cache, download, Lookup[First[updatedSimulation], Packets, {}]}];

	(* Split up the download call into its individual packets *)
	{
		(*1*)sampleDownload,
		(*2*)suppliedCalibrantSampleDownload,
		(*3*)suppliedCalibrantModelDownload,
		(*4*)relevantCalibrantModelDownload,
		(*5*){{maldiPlatePacket}},
		(*6*)allInstrumentModelPackets,
		(*7*)allSyringePackets,
		(*8*)aliquotContainerPackets,
		(*9*)syringeModelPacket
	}=download;

	simulatedSamplePackets=sampleDownload[[All,1]];
	sampleModelPackets=sampleDownload[[All,2]];
	containerModels=sampleDownload[[All,3]];
	simulatedSampleIdentityModelPackets=sampleDownload[[All,5]];

	(* Get the volume from the samples - this is going to be either the volume of the sample, or the aliquoted volume, or the assay volume if we're diluting down *)
	simulatedVolumes=Lookup[#,Volume]&/@simulatedSamplePackets;

	(* these are indexmatched to SamplesIn *)
	calibrantSamplePackets=If[NullQ[#], Null, #[[1]]]&/@suppliedCalibrantSampleDownload;
	calibrantSampleModelPackets=If[NullQ[#], Null, #[[2]]]&/@suppliedCalibrantSampleDownload;
	calibrantModelPackets=Flatten[suppliedCalibrantModelDownload];
	relevantCalibrantModelPackets=Flatten[relevantCalibrantModelDownload];
	sourceAndInstrumentTuples=Flatten/@({First[Lookup[#,IonSources]],Lookup[#,Object]} & /@allInstrumentModelPackets);

	(* gather the supplied ionSource packets from the various downloaded packets so that we have one that is indexmatched to SapmlesIn and contains the CompatibleIonSource information *)
	calibrantIonSourcePackets=MapThread[Switch[#1,
		Automatic,Null,
		ObjectP[Model[Sample]],#2,
		ObjectP[Object[Sample]], #3
	]&,{suppliedCalibrants,calibrantModelPackets,calibrantSampleModelPackets}
	];

	(* Make fast cache *)
	fastCacheBall = makeFastAssocFromCache[simulatedCache];

	(* --- Now resolve Instrument, MassAnalyzer and IonSource --- *)
	suppliedInstrumentModel=If[MatchQ[suppliedInstrument,ObjectP[Object[Instrument]]],
		Download[fastAssocLookup[fastCacheBall, suppliedInstrument, Model],Object],
		Download[suppliedInstrument,Object]
	];

	(* Hardcode default instruments *)
	defaultMALDIInstrument = Model[Instrument, MassSpectrometer, "id:M8n3rxnZLqEO"]; (* Old: Model[Instrument, MassSpectrometer,"Microflex LT"] *)
	defaultESIQTOFInstrument = Model[Instrument, MassSpectrometer, "id:aXRlGn6KaWdO"];
	defaultESITripleQuadInstrument = Model[Instrument,MassSpectrometer,"id:N80DNj1aROOD"];

	(* Also check max specified MassRange *)
	maxSpecifiedMassValue = With[
		{massRangeList = Flatten[Lookup[massSpecOptions,MassRange,{}]/.{Span:>List,Null->{}}]},
		If[
			Length[massRangeList]>0,
			Max[massRangeList],
			0 Gram/Mole
		]
	];

	(* -- Since the entire logic is very complex, here we do 2-step strategy to resolve these 3 options: -- *)
	(* -- First we pre-resolve those options based on options that are not directly related to these options -- *)
	(* -- Like number of supplied options, max supplied mass ranges and min sample volumes -- *)
	(* -- Pre-resolved value will only be used when all 3 options (Instrument, MassAnalyzer, IonSource) are Automatic --*)
	preResolvedInstrumentSpecificTuple = Which[

		(* If user specified tandem mass spectrometry options, we use ESI-QQQ *)
		(numberOfTandemMassAllowNullOptions > 0),
			{ESI, defaultESITripleQuadInstrument, TripleQuadrupole},

		(* MALDI go first, if any MALDI option is specified, preresolved to new Microflex LRF MALDI *)
		(numberOfSuppliedMALDIOptions > 0) && (numberOfSuppliedMALDIOptions > numberOfSuppliedESIOptions) && (maxSpecifiedMassValue < 300000 Dalton),
			{MALDI, defaultMALDIInstrument, TOF},

		(* If any MALDI option is specified, but the specified mass range is high, we use old MALDI *)
		(numberOfSuppliedMALDIOptions > 0) && (numberOfSuppliedMALDIOptions > numberOfSuppliedESIOptions),
			{MALDI, Model[Instrument, MassSpectrometer, "Microflex LT"], TOF},

		(* Else if ESI options is specified, we will use ESI-QTOF *)
		(numberOfSuppliedESIOptions > 0) && (numberOfSuppliedESIOptions > numberOfSuppliedMALDIOptions),
			{ESI, defaultESIQTOFInstrument, QTOF},

		(* If sample amount is too small, also use MALDI. First make sure all samples are liquid and have volume data. If non-liquid samples exist, it will throw an error later *)
		And @@ (VolumeQ /@ simulatedVolumes) && Min[simulatedVolumes] < 20 Microliter,
			{MALDI, defaultMALDIInstrument, TOF},

		(* Catch all *)
		True,
			{ESI, defaultESIQTOFInstrument, QTOF}
	];

	(* Resolve the ion source and instrument Master Switches using a huge Switch *)
	{ionSource,instrument,massAnalyzer}=Switch[
		{
			(*1*)suppliedIonSource,
			(*2*)suppliedInstrument,
			(*3*)suppliedMassAnalyzer
		},

		(* If all IonSource, MassAnalyzer and Instrument were user-supplied, we go with that. We'll throw an error below if those option values don't match up *)
		{(*1*)IonSourceP,(*2*)ObjectP[{Object[Instrument,MassSpectrometer],Model[Instrument,MassSpectrometer]}],(*3*)MassAnalyzerTypeP},
		{suppliedIonSource,suppliedInstrument,suppliedMassAnalyzer},

		(* If both IonSource and Instrument were user-supplied but MassAnalyzer is Automatic, we resolve according to the instrument, and throw error if Ionsource and MassAnalyzer don't match *)
		{(*1*)IonSourceP,(*2*)ObjectP[{Object[Instrument,MassSpectrometer],Model[Instrument,MassSpectrometer]}],(*3*)Automatic},
		{
			suppliedIonSource,
			suppliedInstrument,
			fastAssocLookup[fastCacheBall, suppliedInstrumentModel, MassAnalyzer]
		},


		(* If both IonSource and MassAnalyzer were user-supplied but Instrument is Automatic, we resolve according to the MassAnalyzer, and throw error if Ionsource and Instrument don't match *)
		{(*1*)IonSourceP,(*2*)Automatic,(*3*)MassAnalyzerTypeP},
		{
			suppliedIonSource,
			Switch[suppliedMassAnalyzer,
				TOF,defaultMALDIInstrument,
				QTOF,defaultESIQTOFInstrument,
				TripleQuadrupole,defaultESITripleQuadInstrument
			],
			suppliedMassAnalyzer
		},


		(* If IonSource is supplied, but Instrument and MassAnalyzer are Automatic, we resolve according to the ion source. IonSoucr\[Equal]ESI, the instrument is set to ESI-QTOF by default *)
		{(*1*)IonSourceP,(*2*)Automatic,(*3*)Automatic},
		{
			suppliedIonSource,
			If[MatchQ[suppliedIonSource,MALDI],
				defaultMALDIInstrument,
				defaultESIQTOFInstrument
			],
			If[MatchQ[suppliedIonSource,MALDI],
				TOF,
				QTOF
			]
		},

		(* If both Instrument and MassAnalyzer were user-supplied but IonSource is Automatic, we resolve according to the MassAnalyzer, and throw error if Ionsource and Instrument don't match *)
		{(*1*)Automatic,(*2*)ObjectP[{Object[Instrument,MassSpectrometer],Model[Instrument,MassSpectrometer]}],(*3*)MassAnalyzerTypeP},
		{
			First[fastAssocLookup[fastCacheBall, suppliedInstrumentModel, IonSources]] ,
			suppliedInstrument,
			suppliedMassAnalyzer
		},


		(* If MassAnalyzer is specified, go with that accordingly *)
		{(*1*)Automatic,(*2*)Automatic,(*3*)Except[Automatic]},
		{
			Switch[suppliedMassAnalyzer,
				TOF,MALDI,
				QTOF,ESI,
				TripleQuadrupole,ESI
			],
			Switch[suppliedMassAnalyzer,
				TOF,defaultMALDIInstrument,
				QTOF,defaultESIQTOFInstrument,
				TripleQuadrupole,defaultESITripleQuadInstrument
			],
			suppliedMassAnalyzer
		},

		(* If IonSource is Automatic, but Instrument is supplied, we resolve according to the instrument *)
		{(*1*)Automatic,(*2*)ObjectP[{Object[Instrument,MassSpectrometer],Model[Instrument,MassSpectrometer]}],(*3*)Automatic},
		{
			First[fastAssocLookup[fastCacheBall, suppliedInstrumentModel, IonSources]],
			suppliedInstrument,
			fastAssocLookup[fastCacheBall, suppliedInstrumentModel, MassAnalyzer]
		},

		(* If all IonSource, Instrument and MassAnalyzer were all Automatic, we will resolved them based on other specified options *)
		_,
		Which[

			(* If user specified tandem mass spectrometry options, we use ESI-QQQ *)
			(numberOfTandemMassAllowNullOptions>0),
			{ESI,defaultESITripleQuadInstrument,TripleQuadrupole},

			(* MALDI go first, if any MALDI option is specified, preresolved to new Microflex LRF MALDI *)
			(numberOfSuppliedMALDIOptions>0) && (numberOfSuppliedMALDIOptions > numberOfSuppliedESIOptions) && (maxSpecifiedMassValue < 300000 Dalton),
			{MALDI,defaultMALDIInstrument,TOF},

			(* If any MALDI option is specified, but the specified mass range is high, we use old MALDI *)
			(numberOfSuppliedMALDIOptions>0) && (numberOfSuppliedMALDIOptions > numberOfSuppliedESIOptions),
			{MALDI, Model[Instrument, MassSpectrometer,"Microflex LT"],TOF},

			(* Else if ESI options is specified, we will use ESI-QTOF *)
			(numberOfSuppliedESIOptions>0) && (numberOfSuppliedESIOptions > numberOfSuppliedMALDIOptions),
			{ESI,defaultESIQTOFInstrument,QTOF},

			(* If sample amount is too small, also use MALDI *)
			Min[simulatedVolumes]< 20 Microliter,
			{MALDI,defaultMALDIInstrument,TOF},

			(* Catch all *)
			True,
			{ESI,defaultESIQTOFInstrument,QTOF}
		]
	];

	instrumentModel = If[MatchQ[instrument,ObjectP[Object[Instrument]]],
		Download[fastAssocLookup[fastCacheBall, instrument, Model], Object],
		Download[instrument, Object]
	];

	(*Collect resolved instrument packetet*)
	instrumentPacket = fetchPacketFromFastAssoc[instrumentModel,fastCacheBall];

	(* -- RESOLVE ANALYTES OF INTEREST -- *)

	(* Helper function that resolves to the analytes of interest, given a list of a bunch of analyte packets. *)
	resolveMassSpecAnalytes[myAnalytePackets_]:=Which[
		(* Anything that could be considered analytes (Types[Model[Molecule]) is pulled out of the composition *)
		MemberQ[myAnalytePackets,(ObjectP[Model[Molecule,Protein]]|ObjectP[Model[Molecule,Carbohydrate]]|ObjectP[Model[Molecule,cDNA]]|ObjectP[Model[Molecule,Oligomer]]|ObjectP[Model[Molecule,Transcript]]|ObjectP[Model[Molecule,Polymer]])],
			Download[Cases[myAnalytePackets,ObjectP[{Model[Molecule,Protein],Model[Molecule,Carbohydrate],Model[Molecule,cDNA],Model[Molecule,Oligomer],Model[Molecule,Transcript],Model[Molecule,Polymer]}]],Object],
		(* Small Molecule Identity Model --- use the largest one (including water and solvents) since we don't know better *)
		MemberQ[myAnalytePackets,ObjectP[Model[Molecule]]],
			Module[{allMolWeightTuple,sortedTuple},
				(* Build a tuple for molecular weight and the object*)
				allMolWeightTuple=Download[Cases[myAnalytePackets,ObjectP[Model[Molecule]]], {Object,MolecularWeight}];

				(* Sort the list by molecular weight*)
				sortedTuple=SortBy[allMolWeightTuple,Last];

				(*Return the object with the largest molecular weight *)
				{FirstOrDefault[LastOrDefault[sortedTuple]]}
			],
		(* Field isn't filled out *)
		True,
			{Null}
	];

	(* Resolve the analytes of interest from our Composition field by looking at the Analytes field. *)
	(* Note: this is the option that we return to the user in the builder, but we do some additional filtering for internal use in the next few steps. *)
	resolvedAnalytes=MapThread[
		Function[{analytesOption,samplePacket,sampleComponentPackets},
			(* If the user specified the option, use that. *)
			If[MatchQ[analytesOption,Except[Automatic]],
				analytesOption,
				(* ELSE: If the Analytes field in the Object[Sample] is filled out, use that. *)
				If[!MatchQ[Lookup[samplePacket,Analytes],{}|Null],
					Lookup[samplePacket,Analytes],
					(* ELSE: Prefer Protein>Peptide>Oligomer>Polymer>Small Molecule. *)
					resolveMassSpecAnalytes[Flatten@sampleComponentPackets]
				]
			]
		],
		{Lookup[massSpecOptions,Analytes],simulatedSamplePackets,simulatedSampleIdentityModelPackets}
	];

	(* Error check to make sure that any analytes the user gave us are are the Composition[[All,2]] field on the Object[Sample]. *)
	(* We also do an Intersection[...] to get a list of valid analytes to work with, internal to our function. *)
	invalidAnalytesResult=MapThread[
		Function[{analytesOption,samplePacket},
			If[Length[analytesOption]>0,
			If[Length[Complement[Download[analytesOption,Object],Download[Lookup[samplePacket,Composition][[All,2]],Object]]]>0,
				{
					Complement[Download[analytesOption,Object],Download[Lookup[samplePacket,Composition][[All,2]],Object]],
					Lookup[samplePacket,Object]
				},
				Nothing
			],
				Nothing
			]
		],
		{resolvedAnalytes,simulatedSamplePackets}
	];

	{invalidAnalytes,invalidAnalyteSamples}=If[Length[invalidAnalytesResult]>0,
		Transpose[invalidAnalytesResult],
		{{},{}}
	];

	If[Length[invalidAnalytes]>0,
		Message[Error::UnknownAnalytes,ObjectToString[invalidAnalytes,Cache->simulatedCache],ObjectToString[invalidAnalyteSamples,Cache->simulatedCache]];
	];

	validAnalytes=MapThread[
		Function[{analytesOption,samplePacket},
			Intersection[Download[Lookup[samplePacket,Composition][[All,2]],Object],Download[analytesOption,Object]]
		],
		{resolvedAnalytes,simulatedSamplePackets}
	];

	(* Map over our valid analytes and make sure that we don't have multiple types of analytes that fall in different mass ranges. If we do, then resolve to the largest analytes via our helper function. *)
	(* From here on out, we use these packets internally in our function to resolve the different mass spec options (ex. MassRange). *)
	filteredAnalytePackets=MapThread[
		Function[{sampleModelPackets, validAnalytesForSample},
			Module[{resolvedFilteredAnalytes,analytePackets},
			(* Filter by our mass spec hiearchy Protein>Peptide>Oligomer>Polymer>Small Molecule *)
			(* Note: This helper function takes in packets. *)
				resolvedFilteredAnalytes=resolveMassSpecAnalytes[Cases[sampleModelPackets,ObjectP[validAnalytesForSample]]];
				analytePackets = Cases[sampleModelPackets,ObjectP[resolvedFilteredAnalytes]]
				]
		],
		{simulatedSampleIdentityModelPackets, validAnalytes}
	];

	(* Throw a warning if we filtered out analytes due to the identity models being in a different mass range. *)
	differentAnalyteMassRangesResult=MapThread[
		Function[{sample,filteredAnalytePacketsForSample,validAnalytesForSample},
			If[Length[filteredAnalytePacketsForSample]<Length[Flatten@validAnalytesForSample],
				{
					Lookup[sample,Object],
					{validAnalytesForSample},
					{Lookup[filteredAnalytePacketsForSample,Object]}
				},
				Nothing
			]
		],
		{simulatedSamplePackets,filteredAnalytePackets,validAnalytes}
	];
	{differentAnalyteMassRangeSamples,differentAnalyteMassRangeValidAnalytes,differentAnalyteMassRangeFilteredAnalytes}=If[Length[differentAnalyteMassRangesResult]>0,
		Transpose[differentAnalyteMassRangesResult],
		{{},{},{}}
	];

	If[Length[differentAnalyteMassRangesResult]>0,
		Message[
			Warning::FilteredAnalytes,
			ObjectToString[differentAnalyteMassRangeSamples,Cache->simulatedCache],
			ObjectToString[differentAnalyteMassRangeValidAnalytes,Cache->simulatedCache],
			ObjectToString[differentAnalyteMassRangeFilteredAnalytes,Cache->simulatedCache]
		];
	];

	(* -- MALDI/ESI SHARED INPUT VALIDATION CHECKS -- *)

	(* 1. DISCARDED SAMPLES ARE NOT OK *)

	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets=Cases[simulatedSamplePackets,KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],{},Lookup[discardedSamplePackets,Object]];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&messages,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->simulatedCache]]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	discardedTests=sampleTests[gatherTests,Test,simulatedSamplePackets,discardedSamplePackets,"The input samples `1` are not discarded:",simulatedCache];

	(* 2. SOLID SAMPLES ARE NOT OK *)

	(* Get the samples that are not liquids, we can't do mass spec on those *)
	nonLiquidSamplePackets=MapThread[
		If[Not[MatchQ[Lookup[#1,State],Alternatives[Liquid,Null]]],#1,Nothing]&,
		{simulatedSamplePackets}
	];

	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs=If[MatchQ[nonLiquidSamplePackets,{}],{},Lookup[nonLiquidSamplePackets,Object]];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs]>0&&messages,
		Message[Error::NonLiquidSample,ObjectToString[nonLiquidSampleInvalidInputs,Cache->simulatedCache]];
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	nonLiquidSampleTests=sampleTests[gatherTests,Test,simulatedSamplePackets,nonLiquidSamplePackets,"The input samples `1` are not solid:",simulatedCache];

	(* -- MALDI/ESI SHARED CONFLICTING OPTIONS CHECKS -- *)

	(* 1. Valid MassRange (min < max) *)

	(* get the supplied range *)
	suppliedMassRanges=Lookup[massSpecOptions,MassDetection];

	(* Check that all min masses are less than max masses *)
	validMassRanges=Map[
		If[
			MatchQ[#,(Automatic|Span[_, Automatic]|Span[Automatic,_]|UnitsP[]|{UnitsP[]..})],
			True,
			Module[{minMass,maxMass},
				{minMass,maxMass}=List@@#;
				minMass<maxMass
			]
		]&,
		suppliedMassRanges
	];

	(* Get the samples for which the mass range is invalid *)
	badMassRangeSamplePackets=PickList[simulatedSamplePackets,validMassRanges,False];
	badMassRangeSamples=Lookup[badMassRangeSamplePackets,Object,{}];

	(* Throw message *)
	If[!MatchQ[badMassRangeSamplePackets,{}]&&messages,
		Message[Error::InvalidMassDetection,ObjectToString[badMassRangeSamplePackets,Cache->simulatedCache]]
	];

	(* Collect invalid option *)
	invalidMassRangeOption=If[!MatchQ[badMassRangeSamplePackets,{}],MassDetection];

	(* Create a test for the valid samples and one for the invalid samples *)
	badMassRangeTests=sampleTests[gatherTests,Test,simulatedSamplePackets,badMassRangeSamplePackets,"The lower mass is less than the higher mass in the option MassRange for `1`",simulatedCache];


	(* -- 2a. Mismatching Instrument and IonSource -- *)

	(* we have a mismatch if the ionsource is specified to MALDI but the instrument is ESI and vice versa *)
	ionSourceInstrumentMismatchBoolean = !Or[MatchQ[suppliedIonSource, Automatic],MatchQ[suppliedInstrument, Automatic],MemberQ[Lookup[instrumentPacket, IonSources], suppliedIonSource]];

	(* the user-supplied instrument Object *)
	(*suppliedInstrumentModel=Lookup[instrumentPacket,Object];*)

	(* Create test or throw message *)
	ionSourceInstrumentMismatchTest=If[gatherTests,
		Test["The specified mass spectrometer has the requested ion source capabilities:",!ionSourceInstrumentMismatchBoolean,True],
		If[ionSourceInstrumentMismatchBoolean,
			Message[Error::IncompatibleInstrument,
				suppliedInstrument,
				suppliedIonSource,
				FirstCase[sourceAndInstrumentTuples, {suppliedIonSource, _}][[2]],
				FirstCase[sourceAndInstrumentTuples, {_,suppliedInstrumentModel}][[1]]
			]
		]
	];

	(* Assign Name to tracking variable, if invalid *)
	ionsSourceInstrumentMismatchOptions=If[ionSourceInstrumentMismatchBoolean,{IonSource,Instrument}];

	(* -- 2b. Mismatching Calibrant and IonSource -- *)

	calibrantIonSourceCompatibilities=If[NullQ[#],Null,Lookup[#,CompatibleIonSource,Null]]&/@calibrantIonSourcePackets;

	ionSourceCalibrantMismatchBooleans=MapThread[
		Function[{samplePacket,calibrantIonSource},
			(* We can't do the check if the calibrant doesn't have CompatibleIonSource specified, or if the supplied Ion Source is Automatic, then we don't care *)
			If[NullQ[calibrantIonSource]||MatchQ[suppliedIonSource,Automatic],
				False,
				If[MatchQ[calibrantIonSource,suppliedIonSource],
					False,
					True
				]
			]
		],
		{simulatedSamplePackets,calibrantIonSourceCompatibilities}
	];

	(* Get the samples for which the mass range is invalid *)
	calibrantIonSourceMismatchSamplePackets=PickList[simulatedSamplePackets,ionSourceCalibrantMismatchBooleans,True];
	calibrantIonSourceMismatchSamples=Lookup[calibrantIonSourceMismatchSamplePackets,Object,{}];
	mismatchedCalibrants=PickList[suppliedCalibrants,ionSourceCalibrantMismatchBooleans,True];

	(* Throw message *)
	If[!MatchQ[calibrantIonSourceMismatchSamples,{}]&&messages,
		Message[Error::CalibrantIncompatibleWithIonSource,
			ObjectToString[calibrantIonSourceMismatchSamples,Cache->simulatedCache],
			mismatchedCalibrants,
			suppliedIonSource,
			Complement[List @@ IonSourceP, {suppliedIonSource}] (* the other IonSource *)
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	ionSourceCalibrantMismatchTests=sampleTests[gatherTests,Test,simulatedSamplePackets,calibrantIonSourceMismatchSamplePackets,"The calibrants provided can be used for the requested ion source instrument.",simulatedCache];

	(* Assign Name to tracking variable, if invalid *)
	ionSourceCalibrantMismatchOptions=If[!MatchQ[calibrantIonSourceMismatchSamples,{}],{IonSource,Calibrant}];


	(* -- 2c. Mismatching Instrument and MassAnalyzer -- *)

	(* we have a mismatch if the massAnalyzer is not same as the MassAnalyzer field in Model[Instrument] *)
	massAnalyzerInstrumentMismatchQ =!Or[MatchQ[suppliedMassAnalyzer, Automatic],MatchQ[suppliedInstrument, Automatic],MatchQ[Lookup[instrumentPacket, MassAnalyzer], suppliedMassAnalyzer]];

	(* Create test or throw message *)
	massAnalyzerInstrumentMismatchTest=If[gatherTests,
		Test["The specified mass spectrometer has the requested mass analyzer:",!massAnalyzerInstrumentMismatchQ,True],
		If[massAnalyzerInstrumentMismatchQ,
			Message[Error::IncompatibleMassAnalyzerAndInstrument,
				suppliedInstrument,
				suppliedMassAnalyzer,
				Lookup[instrumentPacket, MassAnalyzer]
			]
		]
	];

	(* Assign Name to tracking variable, if invalid *)
	massAnalyzerInstrumentMismatchOptions=If[massAnalyzerInstrumentMismatchQ,{MassAnalyzer,Instrument}];


	(* -- 2d. Mismatching IonSource and MassAnalyzer -- *)

	(* we have a mismatch if the massAnalyzer is not same as the MassAnalyzer field in Model[Instrument] *)
	massAnalyzerIonSourceMismatchQ =If[
		Or[MatchQ[suppliedMassAnalyzer, Automatic],MatchQ[suppliedIonSource, Automatic]],
		False,
		Xor[MatchQ[suppliedIonSource, MALDI], MatchQ[suppliedMassAnalyzer,TOF]]
	];

	(* Create test or throw message *)
	massAnalyzerIonSourceMismatchTest=If[gatherTests,
		Test["The specified IonSource and mass analyzer are compatible:",!massAnalyzerIonSourceMismatchQ,True],
		If[massAnalyzerIonSourceMismatchQ,
			Message[Error::IncompatibleMassAnalyzerAndIonSource,
				suppliedIonSource,
				suppliedMassAnalyzer,
				If[MatchQ[suppliedIonSource,MALDI],"TOF",
					"QTOF or TripleQuadrupole"
				]
			]
		]
	];

	(* Assign Name to tracking variable, if invalid *)
	massAnalyzerIonSourceMismatchOptions=If[massAnalyzerIonSourceMismatchQ,{MassAnalyzer,IonSource}];

	(* -- 3. Calibrants mass range and MW of sample -- *)

	(* Lookup the molecular weights of the analytes in each sample. *)
	sampleMolecularWeights=MapThread[
		Function[{simulatedSamples, analytePackets},
			If[!MatchQ[analytePackets,{}|{Null..}],
				Cases[Lookup[analytePackets,MolecularWeight],MolecularWeightP],
				{}]],
			{simulatedSamplePackets,filteredAnalytePackets}];

	(* For each sample, determine if molecular weight falls in between min/max calibrant peak *)

	(* -- 4. MassRange and sample MW -- *)

	(* Indicate sample is out of range, provided range is valid and MW is known (if not, we will complain in the ESI or MALDI specific resolver below *)
	(* For single molecular weight input, validMassRange always return true*)

	(* Lookup the molecular weights of the analytes in each sample. *)
	sampleMolecularWeights=MapThread[
		Function[{simulatedSamples, analytePackets},
			If[!MatchQ[analytePackets,{}|{Null..}],
				Cases[Lookup[analytePackets,MolecularWeight],MolecularWeightP],
				{}]],
		{simulatedSamplePackets,filteredAnalytePackets}];

	sampleMassInMassRange=MapThread[
		Function[{samplePacket,molecularWeights,validMassRange,suppliedMassRange},
			(*For most of ESI-QQQ analysis, the mass analysis will target on non-intact mass, for now I skip the check of triple quadruploe mass analyzer*)
			If[MatchQ[molecularWeights,{MolecularWeightP..}]&&MatchQ[suppliedMassRange,_Span]&&validMassRange&&MatchQ[massAnalyzer,Except[TripleQuadrupole]],
				And@@(
					(RangeQ[#,suppliedMassRange]&)/@molecularWeights
				),
				True
			]
		],
		{simulatedSamplePackets,sampleMolecularWeights,validMassRanges,suppliedMassRanges}
	];

	(* Get the samples for which the mass range is invalid *)
	outOfMassRangeSamplePackets=PickList[simulatedSamplePackets,sampleMassInMassRange,False];

	outOfMassRangeSamples=Lookup[outOfMassRangeSamplePackets,Object,{}];

	(* Throw message *)
	If[!MatchQ[outOfMassRangeSamplePackets,{}]&&messages&&outsideEngine,
		Message[Warning::SamplesOutOfMassDetection,ObjectToString[outOfMassRangeSamples,Cache->simulatedCache]]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	outOfMassRangeTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,outOfMassRangeSamplePackets,"If known, the molecular weights of `1` are within the specified mass ranges:",simulatedCache];


	(* -- 5.  Check user-supplied Name -- *)

	(* If we didn't find any protocols with the name in our search, we're okay *)
	(* If the specified Name is not in the database, it is valid *)

	name=Lookup[massSpecOptions,Name];

	validNameBoolean = If[MatchQ[name, _String],
		Not[DatabaseMemberQ[Object[Protocol,MassSpectrometry,name]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	invalidNameOption = If[Not[validNameBoolean] && messages,
		(
			Message[Error::DuplicateName, "MassSpectrometry protocol"];{Name}
		),
		{}
	];

	(* Create test or throw message *)
	nameTest=If[gatherTests,
		Test["The requested name is not already in use:",validNameBoolean,True]
	];

	(* Assign Name to tracking variable, if invalid *)
	invalidNameOption=If[!validNameBoolean,Name];


	(* -- 6. Required IonSource options Error -- *)

	(* If the options specific for the ion source that we resolved to contain any Nulls we have to throw an error since we require these options *)
	requiredOptionsResults=Module[{relevantOptionValues,relevantOptionNames,transposedOptions},

	(* we're looking at the options that should be specified (e.g. if MALDI, then we need to check the MALDI options) *)
		relevantOptionValues=Switch[{ionSource,massAnalyzer},
			{MALDI,_},suppliedMALDIOptions,
			{_,QTOF},suppliedESIQTOFOptions,
			{_,TripleQuadrupole},suppliedESITripleQuadOptions,
			_,suppliedESIQTOFOptions
		];
		relevantOptionNames=Switch[{ionSource,massAnalyzer},
			{MALDI,_},maldiSpecificOptionNames,
			{_,QTOF},esiQTOFSpecificOptionNames,
			{_,TripleQuadrupole},esiTripleQuadSpecificOptionNames,
			_,esiQTOFSpecificOptionNames
		];
		(* since we have a mix of indexmatched and single options, we can't just transpose *)
		transposedOptions=Transpose[Map[If[ListQ[#],#,Table[#, Length[mySamples]]]&,relevantOptionValues]];

		(* determine which samples and which options are unneeded, if we have any optiosn that aren't Automatic or Null *)
		If[
			massAnalyzerInstrumentMismatchQ,
			{},
			MapThread[Function[{sampleOptions,sample},
				If[ContainsAny[sampleOptions,{Null}],
					{sample,PickList[relevantOptionNames,sampleOptions,Null]},
					Nothing
				]],
				{transposedOptions,simulatedSamplePackets}
			]
		]
	];

	(* if we had invalid results, extract the invalid input and the corresponding specified options *)
	{requiredOptionsInputPackets,requiredOptions}=If[Length[requiredOptionsResults]>0,
		Transpose[requiredOptionsResults],
		{{},{}}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	If[(Length[requiredOptionsInputPackets]>0 && messages),
		Message[Error::MassSpecRequiredOptions,
			ionSource, (* the source we've resolved to *)
			massAnalyzer,
			requiredOptions, (* the options that were mistakenly supplied as Null *)
			ObjectToString[Lookup[requiredOptionsInputPackets,Object],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	requiredOptionsTests=sampleTests[gatherTests,Test,simulatedSamplePackets,requiredOptionsInputPackets,"Ion-source relevant options aren't set to Null for `1`",simulatedCache];

	(* -- 7. Unneeded IonSource options Error -- *)

	(* Unless the option values for the ion source that we did NOT resolve to are Automatic or Null, we have to throw an error since we don't need these options *)
	unneededOptionsResults=Module[{relevantOptionValues,relevantOptionNames,transposedOptions},

		(* we're looking at the options that should NOT be specified (e.g. if MALDI, then we need to check the ESI options, otherwise, ESI) *)
		(* For ESI-QQQ added Syringe infusion option as ESI specific options. *)
		relevantOptionValues=Switch[{ionSource,massAnalyzer},
			{MALDI,_},Join[suppliedESIOptions,suppliedESIFlowInjectionOptions,suppliedESISyringeInfusionOptions,suppliedTandemMassAllowNullOptions],

			(*Since ESI-QQQ and ESI-QTOF are not completely shared the same ionsource options, we usue Complement to collect them here*)
			{_,QTOF},Join[suppliedMALDIOptions,suppliedESITripleQuadSpecificOptions,suppliedTandemMassAllowNullOptions],
			{_,TripleQuadrupole},Join[suppliedMALDIOptions,suppliedESIQTOFSpecificOptions],
			_,Join[suppliedMALDIOptions,suppliedESIQTOFSpecificOptions]
		];

		relevantOptionNames=Switch[{ionSource,massAnalyzer},
			{MALDI,_},Join[esiSpecificOptionNames,esiFlowInjectionSpecificOptionNames,esiSyringeInfusionSpecificOptionNames,tandemMassSpecificAllowNullOptionNames],
			{_,QTOF},Join[maldiSpecificOptionNames,suppliedESITripleQuadSpecificNames,tandemMassSpecificAllowNullOptionNames],
			{_,TripleQuadrupole},Join[maldiSpecificOptionNames,suppliedESIQTOFSpecificNames],
			_,Join[suppliedMALDIOptions,suppliedESIQTOFSpecificOptions]
		];
		(* since we have a mix of indexmatched and single options, we can't just transpose *)
		transposedOptions=Transpose[Map[If[ListQ[#],#,Table[#, Length[mySamples]]]&,relevantOptionValues]];

		(* determine which samples and which options are unneeded, if we have any options that aren't Automatic or Null *)
		If[
			massAnalyzerInstrumentMismatchQ,
			{},
			MapThread[Function[{sampleOptions,sample},
				If[!ContainsOnly[sampleOptions,{Automatic,Null}],
					{sample,PickList[relevantOptionNames,sampleOptions,Except[_?(MatchQ[#,Automatic]||MatchQ[#,Null]&)]]},
					Nothing
				]],
				{transposedOptions,simulatedSamplePackets}
			]
		]
	];

	(* if we had invalid results, extract the invalid input and the corresponding specified options *)
	{unneededOptionsInputPackets,unneededOptions}=If[Length[unneededOptionsResults]>0,
		Transpose[unneededOptionsResults],
		{{},{}}
	];

	nonDuplicatedUnneededSamples=DeleteDuplicates[Flatten[unneededOptions]];

	unneededSamplesIonSourceAndMassAnalyzer=If[Length[nonDuplicatedUnneededSamples]>0,
			Transpose[Which[
			MemberQ[maldiSpecificOptionNames,#],{MALDI,TOF},
			MemberQ[esiQTOFSpecificOptionNames,#],{ESI,QTOF},
			True,{ESI,TripleQuadrupole}
		]&/@nonDuplicatedUnneededSamples],
		{{},{}}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	If[(Length[unneededOptionsInputPackets]>0 && messages),
		Message[Error::UnneededOptions,
			unneededOptions,
			nonDuplicatedUnneededSamples, (* the options that were mistakenly supplied *)
			unneededSamplesIonSourceAndMassAnalyzer[[1]],
			unneededSamplesIonSourceAndMassAnalyzer[[2]],
			ObjectToString[Lookup[unneededOptionsInputPackets,Object],Cache->simulatedCache] (* the affected samples *)
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	unneededOptionsTests=sampleTests[gatherTests,Test,simulatedSamplePackets,unneededOptionsInputPackets,"Only ion-source and Mass Analyzer relevant options are specified for `1`",simulatedCache];


	(* -- 8. InjectionType and related options *)

	(* a) If we have FlowInjection specified, then options related to FlowInjection cannot be set to Null *)

	(* If the options specific for the ion source that we resolved to contain any Nulls we have to throw an error since we require these options *)
	requiredFlowInjectionOptionsResults=Module[{relevantOptionValues,relevantOptionNames,transposedOptions},

		(* we're only interested in this check if we're doing FlowInjection *)
		If[!MatchQ[suppliedInjectionType,FlowInjection],Return[{},Module]];

	(* we're looking at the options that should be specified - in this case, the ESI Flow injection options (-- they cannot be Null) *)
		relevantOptionValues=suppliedESIFlowInjectionOptions;
		relevantOptionNames=esiFlowInjectionSpecificOptionNames;

		(* since we have a mix of indexmatched and single options, we can't just transpose *)
		transposedOptions=Transpose[Map[If[ListQ[#],#,Table[#, Length[mySamples]]]&,relevantOptionValues]];

		(* determine which samples and which options are unneeded, if we have any optiosn that aren't Automatic or Null *)
		MapThread[Function[{sampleOptions,sample},
			If[ContainsAny[sampleOptions,{Null}],
				{sample,PickList[relevantOptionNames,sampleOptions,Null]},
				Nothing
			]],
			{transposedOptions,simulatedSamplePackets}
		]
	];

	(* if we had invalid results, extract the invalid input and the corresponding specified options *)
	{requiredFlowInjectionOptionsInputPackets,requiredFlowInjectionOptions}=If[Length[requiredFlowInjectionOptionsResults]>0,
		Transpose[requiredFlowInjectionOptionsResults],
		{{},{}}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	If[(Length[requiredFlowInjectionOptionsInputPackets]>0 && messages),
		Message[Error::FlowInjectionRequiredOptions,
			requiredFlowInjectionOptions, (* the options that were mistakenly supplied as Null *)
			ObjectToString[Lookup[requiredFlowInjectionOptionsInputPackets,Object],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	requiredFlowInjectionOptionsTests=sampleTests[gatherTests,Test,simulatedSamplePackets,requiredFlowInjectionOptionsInputPackets,"FlowInjection relevant options aren't set to Null for `1`.",simulatedCache];

	(* b) If we have DirectInfusion specified, then options related to FlowInjection cannot be set to anything except Automatic or Null *)

	(* Unless the option values for the ion source that we did NOT resolve to are Automatic or Null, we have to throw an error since we don't need these options *)
	unneededDirectInfusionOptionsResults=Module[{relevantOptionValues,relevantOptionNames,transposedOptions},

		(* we are only interested in this check if we're dealing with DirectInfusion *)
		If[!MatchQ[suppliedInjectionType,DirectInfusion],Return[{},Module]];

		(* we're looking at the options that should NOT be specified in DirectInfusion experiments *)
		relevantOptionValues=suppliedESIFlowInjectionOptions;
		relevantOptionNames=esiFlowInjectionSpecificOptionNames;

		(* since we have a mix of indexmatched and single options, we can't just transpose *)
		transposedOptions=Transpose[Map[If[ListQ[#],#,Table[#, Length[mySamples]]]&,relevantOptionValues]];

		(* determine which samples and which options are unneeded, if we have any optiosn that aren't Automatic or Null *)
		MapThread[Function[{sampleOptions,sample},
			If[!ContainsOnly[sampleOptions,{Automatic,Null}],
				{sample,PickList[relevantOptionNames,sampleOptions,Except[_?(MatchQ[#,Automatic]||MatchQ[#,Null]&)]]},
				Nothing
			]],
			{transposedOptions,simulatedSamplePackets}
		]
	];

	(* if we had invalid results, extract the invalid input and the corresponding specified options *)
	{unneededDirectInfusionOptionsInputPackets,unneededDirectInfusionOptions}=If[Length[unneededDirectInfusionOptionsResults]>0,
		Transpose[unneededDirectInfusionOptionsResults],
		{{},{}}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	If[(Length[unneededDirectInfusionOptionsInputPackets]>0 && messages),
		Message[Error::DirectInfusionUnneededOptions,
			unneededDirectInfusionOptions, (* the options that were mistakenly supplied *)
			ObjectToString[Lookup[unneededDirectInfusionOptionsInputPackets,Object],Cache->simulatedCache] (* the affected samples *)
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	unneededDirectInfusionOptionsTests=sampleTests[gatherTests,Test,simulatedSamplePackets,unneededDirectInfusionOptionsInputPackets,"Flow infusion relevant options are not specified when doing direct injection.",simulatedCache];

	(* c) If we have FlowInjection specified, then options related to DirectInfusion (using syringe) cannot be set to anything except Automatic or Null *)

	(* Unless the option values for the ion source that we did NOT resolve to are Automatic or Null, we have to throw an error since we don't need these options *)
	unneededFlowInjectionOptionsResults=Module[{relevantOptionValues,relevantOptionNames,transposedOptions},

		(* we are only interested in this check if we're dealing with DirectInfusion *)
		If[!MatchQ[suppliedInjectionType,FlowInjection],Return[{},Module]];

		(* we're looking at the options that should NOT be specified in DirectInfusion experiments *)
		relevantOptionValues=suppliedESISyringeInfusionOptions;
		relevantOptionNames=esiSyringeInfusionSpecificOptionNames;

		(* since we have a mix of indexmatched and single options, we can't just transpose *)
		transposedOptions=Transpose[Map[If[ListQ[#],#,Table[#, Length[mySamples]]]&,relevantOptionValues]];

		(* determine which samples and which options are unneeded, if we have any optiosn that aren't Automatic or Null *)
		MapThread[Function[{sampleOptions,sample},
			If[!ContainsOnly[sampleOptions,{Automatic,Null}],
				{sample,PickList[relevantOptionNames,sampleOptions,Except[_?(MatchQ[#,Automatic]||MatchQ[#,Null]&)]]},
				Nothing
			]],
			{transposedOptions,simulatedSamplePackets}
		]
	];

	(* if we had invalid results, extract the invalid input and the corresponding specified options *)
	{unneededFlowInjectionOptionsInputPackets,unneededFlowInjectionOptions}=If[Length[unneededFlowInjectionOptionsResults]>0,
		Transpose[unneededFlowInjectionOptionsResults],
		{{},{}}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	If[(Length[unneededFlowInjectionOptionsInputPackets]>0 && messages),
		Message[Error::FlowInjectionUnneededOptions,
			unneededFlowInjectionOptions, (* the options that were mistakenly supplied *)
			ObjectToString[Lookup[unneededFlowInjectionOptionsInputPackets,Object],Cache->simulatedCache] (* the affected samples *)
		];
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	unneededFlowInjectionOptionsTests=sampleTests[gatherTests,Test,simulatedSamplePackets,unneededFlowInjectionOptionsInputPackets,"Diect injection relevant options are not specified when doing flow infusion.",simulatedCache];

	(* -- 9. Instrument and MassRange mismatch *)

	(* the MassRange is a shared option but ESI-QTOF supports 2-100 000 Dalton, ESI-QQQ suport 5-2000 and the MALDI supports 2- 500 000 Dalton *)
	(* -- a. Provided a mass range was supplied by the user, and is valid, and we're doing ESI, we check whether the mass range is below 100000 Da *)
	maxMassSupportedBools=MapThread[
		Function[{validMassRange,suppliedMassRange},
			With[
				{
					instrumentMaxMass = fastAssocLookup[fastCacheBall, instrumentModel, MaxMass],
					massRangeList = suppliedMassRange/. {Span:>List}
				},
				If[
					validMassRange && MatchQ[ToList[massRangeList],{UnitsP[Gram/Mole]..}],
					LessEqual[Max[ToList[massRangeList]],instrumentMaxMass],
					True
				]
			]
		],
		{validMassRanges,suppliedMassRanges}
	];

	(* Get the samples for which the mass range is invalid *)
	invalidMaxMassSamplePackets=PickList[simulatedSamplePackets,maxMassSupportedBools,False];

	(* Throw message *)
	If[!MatchQ[invalidMaxMassSamplePackets,{}]&&messages,
		Message[Error::IncompatibleMassDetection,instrument,Max /@ (Apply[List, #] & /@PickList[suppliedMassRanges,maxMassSupportedBools,False]),ObjectToString[Lookup[invalidMaxMassSamplePackets,Object],Cache->simulatedCache]]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidMaxMassTests=sampleTests[gatherTests,Test,simulatedSamplePackets,invalidMaxMassSamplePackets,"The specified mass range is supported by the mass spectrometer:",simulatedCache];

	(* Assign Name to tracking variable, if invalid *)
	invalidMaxMassOptions=If[!MatchQ[invalidMaxMassSamplePackets,{}],{MassRange,Instrument}];


	(* -- 10. Noise level in supplied mass range *)

	(* For the lower limit of the mass range, we throw a warning if the supplied min mass is below a value that we consider to be prone to noise peaks (in MALDI, this is 750 Dalton, in ESI, 150 *)
	maldiNoiseLimit=750*Dalton;
	esiNoiseLimit=100*Dalton;

	(* If the lower mass is below 750 / 150 Dalton we will throw a warning below *)
	minMassValidBool=MapThread[
		Function[{validMassRange,suppliedMassRange},
			If[validMassRange&&MatchQ[suppliedMassRange,_Span],
				Which[
					MatchQ[ionSource,MALDI],GreaterEqual[Min[List@@suppliedMassRange],maldiNoiseLimit],
					MatchQ[ionSource,ESI],GreaterEqual[Min[List@@suppliedMassRange],esiNoiseLimit]
				],
				True
			]
		],
		{validMassRanges,suppliedMassRanges}
	];

	(* Get the samples for which the mass range is invalid *)
	badMinMassSamplePackets=PickList[simulatedSamplePackets,minMassValidBool,False];

	(* Throw Warning *)
	If[!MatchQ[badMinMassSamplePackets,{}]&&messages&&outsideEngine,
		Message[Warning::LowMinMass,ObjectToString[Lookup[badMinMassSamplePackets,Object],Cache->simulatedCache],instrument,If[MatchQ[ionSource,ESI],ToString[esiNoiseLimit],ToString[maldiNoiseLimit]]]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	badMinMassTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,badMinMassSamplePackets,"The lower end of the specified mass range falls outside the mass range that is known to produce noisy data:",simulatedCache];


	(* -- RESOLVE MALDI and ESI specific options -- *)

	(* Prepare the experiment options by replacing the pre-resolved ionSource and instrument options - this is a list (not an association) *)
	preResolvedExperimentOptions=ReplaceRule[Normal[myExperimentOptions],{Instrument->instrument,IonSource->ionSource,Cache->Lookup[myExperimentOptions,Cache,{}]}];

	(* construct boolean lists for whether our samples are invalid; we need to pass this into the resolvers to know whether to throw other warnings/tests *)
	nonLiquidSamplesBool=MemberQ[Lookup[nonLiquidSamplePackets,Object],#]&/@Download[simulatedSamples,Object];
	discardedSamplesBool=MemberQ[Lookup[discardedSamplePackets,Object],#]&/@Download[simulatedSamples,Object];
	booleans={gatherTests,discardedSamplesBool,nonLiquidSamplesBool,sampleMassInMassRange,ionSourceCalibrantMismatchBooleans,maxMassSupportedBools};

	(* resolve the ESI or MALDI specific options using the helper functions *)
	{ionSourceResolvedOptions,ionSourceSpecificTests,ionSourceSpecificInvalidOptions,ionSourceSpecificInvalidInputs}=Switch[{ionSource,massAnalyzer},
		{MALDI,_},
			resolveMALDIOptions[mySamples,simulatedSamples,download,resolvedSamplePrepOptions,preResolvedExperimentOptions,filteredAnalytePackets,booleans,simulatedCache,updatedSimulation],
		{_,QTOF},
			resolveESIQTOFOptions[mySamples,simulatedSamples,download,resolvedSamplePrepOptions,preResolvedExperimentOptions,filteredAnalytePackets,booleans,simulatedCache,updatedSimulation],
		{_,TripleQuadrupole},
			resolveESITripleQuadOptions[mySamples,simulatedSamples,download,resolvedSamplePrepOptions,preResolvedExperimentOptions,filteredAnalytePackets,booleans,simulatedCache,updatedSimulation],
		_,
			{{},{},{},{}}
	];


	(* Gather Resolved Calibrants *)
	resolvedCalibrants=Lookup[ionSourceResolvedOptions, Calibrant];

	(*Gather SamplesIn storage and Calibrant Storage Conditions*)
	{samplesInStorages,calibrantStorages} = Lookup[myExperimentOptions, {SamplesInStorageCondition,CalibrantStorageCondition}];

	(* Collect those non-discarded samples*)
	nonDiscardedSamples=DeleteCases[mySamples,ObjectP[discardedInvalidInputs]];

	(* Collect the storage conditions of those non-discarded samples *)
	nonDiscardedSampleStorages= PickList[samplesInStorages,mySamples,Except[ObjectP[discardedInvalidInputs]]];

	(*Generate Tests for SamplesInStorageCondition*)
	{validSamplesInStorageConditionBool, validSamplesInStorageConditionTests} =
		Which[
			(*Chcek if all samples were discarded*)
			MatchQ[nonDiscardedSamples,{}],{{},{}},

			(* If not, check their SamplesInStorageConditions *)
			gatherTests, ValidContainerStorageConditionQ[nonDiscardedSamples,nonDiscardedSampleStorages, Output -> {Result, Tests},Cache->simulatedCache, Simulation -> updatedSimulation],
			True,{ValidContainerStorageConditionQ[nonDiscardedSamples,nonDiscardedSampleStorages, Output -> Result,Cache->simulatedCache, Simulation -> updatedSimulation], {}}
		];

	(*Collect Invalide options SamplesInStorageCondition*)
	samplesInStorageConditionInvalidOptions = If[MemberQ[validSamplesInStorageConditionBool, False],SamplesInStorageCondition,Nothing];

	(*Collect thos calibrant with Ojects only, if they were assinged as Model, we don't check their storage condition. *)
	calibrantNoModels=Cases[resolvedCalibrants,ObjectP[Object[Sample]]];
	calibrantStorageNoModels=PickList[calibrantStorages,resolvedCalibrants,ObjectP[Object[Sample]]];

	(*Generate Tests for CalibrantStorageCondition*)
	{validCalibrantStorageConditionBool, validCalibrantStorageConditionTests} =
		Which[
			MatchQ[calibrantNoModels,{}],{{},{}},
			gatherTests, ValidContainerStorageConditionQ[resolvedCalibrants,calibrantStorages, Output -> {Result, Tests},Cache->simulatedCache, Simulation -> updatedSimulation],
			True, {ValidContainerStorageConditionQ[resolvedCalibrants,calibrantStorages, Output -> Result,Cache->simulatedCache, Simulation -> updatedSimulation], {}}
		];

	(*Collect Invalide options SamplesInStorageCondition*)
	calibrantStorageConditionInvalidOptions = If[MemberQ[validCalibrantStorageConditionBool, False],CalibrantStorageCondition,Nothing];

	(* ValidContainerSTorageConditionQ[calibrants, LookupmyOptions] *)
	(* -- RESOLVE SHARED OPTIONS -- *)

	{email,upload}=Lookup[massSpecOptions,{Email,Upload}];

	(* resolve the Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],
		(* If Email!=Automatic, use the supplied value *)
		email,

		(* If BOTH Upload -> True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[upload, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* -- INVALID INPUT/OPTIONS MESSAGES -- *)

	(* Gather our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteCases[
		DeleteDuplicates[Flatten[{
			ionSourceSpecificInvalidInputs,
			(* MALDI/ESI shared invalid checks*)
			discardedInvalidInputs,
			nonLiquidSampleInvalidInputs}]], Null];

	invalidOptions=DeleteCases[DeleteDuplicates[Flatten[{
		ionSourceSpecificInvalidOptions,
		(* MALDI/ESI shared invalid checks*)
		{invalidNameOption},
		{invalidMassRangeOption},
		ionsSourceInstrumentMismatchOptions,
		massAnalyzerInstrumentMismatchOptions,
		ionSourceCalibrantMismatchOptions,
		invalidMaxMassOptions,
		unneededFlowInjectionOptions,
		unneededOptions,
		requiredOptions,
		requiredFlowInjectionOptions,
		unneededDirectInfusionOptions,
		samplesInStorageConditionInvalidOptions,
		calibrantStorageConditionInvalidOptions,
		massAnalyzerIonSourceMismatchOptions
	}]],Null];


	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&messages,
		Message[Error::InvalidInput,invalidInputs]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	allResolvedOptions=ReplaceRule[ionSourceResolvedOptions,{Email->resolvedEmail,Analytes->resolvedAnalytes}];

	(* Gather all tests *)
	allTests=Flatten[Join[
		samplePrepTests,
		{nameTest},
		outOfMassRangeTests,
		discardedTests,
		nonLiquidSampleTests,
		badMassRangeTests,
		{ionSourceInstrumentMismatchTest},
		ionSourceCalibrantMismatchTests,
		invalidMaxMassTests,
		badMinMassTests,
		unneededOptionsTests,
		requiredOptionsTests,
		requiredFlowInjectionOptionsTests,
		unneededDirectInfusionOptionsTests,
		ionSourceSpecificTests,
		validCalibrantStorageConditionTests,
		validSamplesInStorageConditionTests,
		unneededFlowInjectionOptionsTests,
		{massAnalyzerIonSourceMismatchTest},
		{massAnalyzerIonSourceMismatchTest}
	]];

	(* generate the Result output rule *)
	(* if we're not returning results, Results rule is just Null *)
	resultRule = Result -> If[MemberQ[output,Result],
		allResolvedOptions,
		Null
	];

	(* generate the tests rule. If we're not gathering tests, the rule is just Null *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* Return our resolved options and/or tests, as desired *)
	outputSpecification/. {resultRule,testsRule}

];


(* ::Subsubsection:: *)
(*resolveMALDIOptions*)


(* ========== resolveMALDIOptions Helper function ========== *)
(* resolves MALDI specific options that are set to Automatic to a specific value and returns a list of resolved options, tests, and invalid input/option values to the main resolver *)
(* the inputs are the simulated samples, the download packet from the main resolver, the semi-resolved experiment options, and whether we're gathering tests or not *)


resolveMALDIOptions[
	myNonSimulatedSamples:ListableP[ObjectP[Object[Sample]]],
	mySimulatedSamples:ListableP[ObjectP[Object[Sample]]],
	myMaldiDownloadPackets_, (* this is a list of packets, and the model of the maldi plate *)
	myResolvedSamplePrepOptions_,
	mySuppliedExperimentOptions_,
	myFilteredAnalytePackets_, (* {{PacketP[IdentityModelTypes]..}..} - our filtered analytes (all of the same general type) for each of our simulated samples that we use internally to our function. *)
	myBooleans:{({BooleanP..}|BooleanP)..},
	mySimulatedCache_,
	updatedSimulation:_Simulation|Null
]:=Module[
	{
	gatherTests,discardedSamplesBools,nonLiquidSamplesBools,outOfMassRangeBools,ionSourceCalibrantMismatchBooleans,maxMassSupportedBools,
	messages,simulatedCache,outsideEngine,samplePrepOptions,massSpecSpecificOptions,massSpecOptions,suppliedCalibrants,
	suppliedMatrices,sampleDownload,suppliedCalibrantSampleDownload,suppliedCalibrantModelDownload,relevantCalibrantModelDownload,maldiPlatePacket,instrumentPacket,
	allInstrumentPackets,aliquotContainerPackets,simulatedSamplePackets,sampleModelPackets,containerModels,calibrantSamplePackets,
	relevantCalibrantModelPackets,sampleMolecularWeights,unroundedMassRanges,noMolecularWeightSamplePackets,noMolecularWeightTests,
	roundedMassSpecOptions,optionPrecisionTests,suppliedMassRanges,validMassRanges,badMassRangeSamplePackets,suppliedLaserPowerRanges,
	validLaserPowerRanges,badLaserPowerRangeSamplePackets,invalidLaserPowerRangeOption,badLaserPowerRangeTests,
	suppliedCalibrantLaserPowerRanges,validCalibrantLaserPowerRanges,badCalibrantLaserPowerRangeSamplePackets,
	invalidCalibrantLaserPowerRangeOption,badCalibrantLaserPowerRangeTests,allowedMALDIPlates,maldiPlateError,
	invalidMALDIPlateOption,maldiPlateTest,simulatedSampleIdentityModelPackets,suppliedCalibrantMatrices,syringeModelPacket,
	invalidMatrixSampleBools, uninformedMatrixModelBools, invalidCalibrantMatrixSampleBools, uninformedCalibrantMatrixModelBools,
	invalidMatrixOption, invalidCalibrantMatrixOption, matricesPackets, invalidMatrixSampleTests, uninformedMatrixTests,
	calibrantMatricesPackets, invalidCalibrantMatrixSampleTests, uninformedCalibrantMatrixTests,
	(* for resolver *)
	suppliedAliquots,suppliedAssayVolumes,suppliedAliquotVolumes,validCalibrantBools,calibrantMatrices,
	suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers,suppliedIonModes,
	suppliedSpottingMethods,suppliedLensVoltages,suppliedGridVoltages,suppliedDelayTimes,suppliedSampleVolumes,
	resolvedOptionsBySample,ionModes,calibrants,matrices,spottingMethods,massRanges,flankingPeakBooleans,gains,
	numbersOfPeaksInRange,laserPowerRanges,calibrantLaserPowerRanges,lensVoltages,gridVoltages,delayTimes,suppliedGains,
	preResolvedAliquots,requiredAliquotAmounts,compatibleContainers,aliquotWarnings,aliquotVolumeErrors,invalidMassRangeBooleans,
	invalidMALDITOFFMassDetectionOptionTests,invalidMALDITOFMassDetectionOptions,resolvedNumberOfShots,resolvedCalibrantNumberOfShots,
	resolvedShotsPerRaster,invalidNumberOfShots,invalidNumberOfShotsOption,numberOfShotsTest,invalidCalibrantNumberOfShots,invalidCalibrantNumberOfShotsOption,
	calibrantNumberOfShotsTest,suppliedNumberOfShots,suppliedCalibrantNumberOfShots,suppliedShotsPerRaster,suppliedInstrumentModel,
	(*Sample and Calibrant Storage*)
	allSyringePackets,
	(* post resolver *)
	suppliedNumberOfReplicates,numberOfInputSamples,numberOfSampleSpots,numberOfAvailableSpots,tooManySamples,badCalibrantSamplePackets,
	invalidReplicatesOption,tooManySamplesTest,uncalibratableSamplePackets,uncalibratableSamples,invalidCalibrationOption,
	unableToCalibrateTests,hardToCalibrateSamplePackets,hardToCalibrateSamples,limitedReferencePeaksTests,notEnoughReferencePeaksOptions,outOfMassRangeSamplePackets,
	outOfCalibrantRangeSamplePackets,badVolumeSamplePackets,badVolumeSamples,invalidAliquotVolumeOption,invalidCalibrantTests,invalidCalibrantOptions,
	assayVolumeOutOfSpottingInstrumentRangeTest,numberOfAliquots,targetContainers,relevantAliquotWarnings,
	suppliedConsolidation,resolvedConsolidation,suppliedAliquot,resolvedAliquot,aliquotOptions,resolvedAliquotOptions,aliquotTests,resolvedPostProcessingOptions,
	maldiInvalidInputs,maldiInvalidOptions,maldiResolvedOptions,maldiTests,massInCalibrantRangeBools,outOfCalibrantRangeSamples,outOfRangeCalibrantTests,
	fastCacheBall, suppliedInstrument
},

	{gatherTests,discardedSamplesBools,nonLiquidSamplesBools,outOfMassRangeBools,ionSourceCalibrantMismatchBooleans,maxMassSupportedBools}=myBooleans;
	messages = !gatherTests;
	simulatedCache=mySimulatedCache;
	outsideEngine=!MatchQ[$ECLApplication,Engine];

	(* Make fast cache *)
	fastCacheBall = makeFastAssocFromCache[FlattenCachePackets[{simulatedCache}]];

	(* Separate out our MassSpectrometry options from our Sample Prep options. *)
	{samplePrepOptions,massSpecSpecificOptions}=splitPrepOptions[mySuppliedExperimentOptions];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	massSpecOptions=Association[massSpecSpecificOptions];

	(* Lookup supplied objects from options *)
	{suppliedCalibrants,suppliedMatrices,suppliedCalibrantMatrices}=Lookup[massSpecOptions,{Calibrant,Matrix,CalibrantMatrix}];



	(* separate out our download into individual packets and lists *)
	{
		(*1*)sampleDownload,
		(*2*)suppliedCalibrantSampleDownload,
		(*3*)suppliedCalibrantModelDownload,
		(*4*)relevantCalibrantModelDownload,
		(*5*){{maldiPlatePacket}},
		(*6*)allInstrumentPackets,
		(*7*)allSyringePackets,
		(*8*)aliquotContainerPackets,
		(*9*)syringeModelPacket
	}=myMaldiDownloadPackets;

	simulatedSamplePackets=sampleDownload[[All,1]];
	sampleModelPackets=sampleDownload[[All,2]];
	containerModels=sampleDownload[[All,3]];
	simulatedSampleIdentityModelPackets=sampleDownload[[All,5]];

	calibrantSamplePackets=Flatten[suppliedCalibrantSampleDownload];
	relevantCalibrantModelPackets=Flatten[relevantCalibrantModelDownload];

	(* - Samples have molecular weights - *)
	(* Lookup the molecular weights from the analytes per sample *)
	sampleMolecularWeights=MapThread[
		Function[{simulatedSamples, analytePackets},
			If[!MatchQ[analytePackets,{}|{Null..}],
				Cases[Lookup[analytePackets,MolecularWeight],MolecularWeightP],
				{}]],
		{simulatedSamplePackets,myFilteredAnalytePackets}];

	unroundedMassRanges=Lookup[massSpecOptions,MassDetection];

	(* Get a list of samples which are missing molecular weight information and don't have a mass range specified *)
	noMolecularWeightSamplePackets=Complement[
		MapThread[
			If[MatchQ[#1,Except[{MolecularWeightP..}]]&&MatchQ[#2,Automatic],
				#3,
				Nothing
			]&,
			{sampleMolecularWeights,unroundedMassRanges,simulatedSamplePackets}
		],
		PickList[simulatedSamplePackets,discardedSamplesBools,True],PickList[simulatedSamplePackets,nonLiquidSamplesBools,True]
	];

	(* Throw message (but only if we haven't thrown a Discarded or Non-Liquid sample error *)
	If[!MatchQ[noMolecularWeightSamplePackets,{}]&&messages&&outsideEngine,
		Message[Warning::UnknownMolecularWeight,ObjectToString[Lookup[noMolecularWeightSamplePackets,Object],Cache->simulatedCache]]
	];

	(* Generate tests *)
	noMolecularWeightTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,noMolecularWeightSamplePackets,"The molecular weights of `1` are known, so mass spectrometer options can be validated/resolved automatically:",simulatedCache];

	(* -- OPTION PRECISION CHECKS -- *)

	(* Verify that the MALDI mass spec options are not overly precise *)
	{roundedMassSpecOptions,optionPrecisionTests}=If[gatherTests,
		RoundOptionPrecision[massSpecOptions,{SampleVolume,SpottingDryTime,LensVoltage,GridVoltage,AccelerationVoltage,DelayTime,Gain},{10^-1 Microliter,1 Minute,10^-2 Kilovolt,10^-2 Kilovolt,10^-2 Kilovolt,1 Nanosecond,10^-5},Output->{Result,Tests}],
		{RoundOptionPrecision[massSpecOptions,{SampleVolume,SpottingDryTime,LensVoltage,GridVoltage,AccelerationVoltage,DelayTime,Gain},{10^-1 Microliter,1 Minute,10^-2 Kilovolt,10^-2 Kilovolt,10^-2 Kilovolt,1 Nanosecond,10^-5}],Null}
	];

	(* -- CONFLICTING OPTIONS CHECKS -- *)

	(* -- Valid MassRange (min < max) -- *)
	(* Note we've already throw an error in the main resolver, so we don't throw an Error/Test here *)
	(* We just use this below to know when we shouldn't throw any other mass range related tests since that test has been thrown already *)
	suppliedMassRanges=Lookup[roundedMassSpecOptions,MassDetection];

	(* Check that all min masses are less than max masses *)
	validMassRanges=Map[
		If[MatchQ[#,Automatic|Span[_, Automatic]|Span[Automatic,_]]|UnitsP[]|{UnitsP[]..},
			True,
			Module[{minMass,maxMass},
				{minMass,maxMass}=List@@#;
				minMass<maxMass
			]
		]&,
		suppliedMassRanges
	];

	(* Get the samples for which the mass range is invalid *)
	badMassRangeSamplePackets=PickList[simulatedSamplePackets,validMassRanges,False];

	(* -- Valid LaserPowerRange (min < max) -- *)
	suppliedLaserPowerRanges=Lookup[roundedMassSpecOptions,LaserPowerRange];

	(* Check that all min masses are less than max masses, skip this check for user speicified laser range as Automatic (will resolve later) or Null (will throw an error)*)
	validLaserPowerRanges=Map[
		If[MatchQ[#,(Automatic|Null)],
			True,
			Module[{minPower,maxPower},
				{minPower,maxPower}=List@@#;
				minPower<maxPower
			]
		]&,
		suppliedLaserPowerRanges
	];

	(* Get the samples for which the laser power range is invalid *)
	badLaserPowerRangeSamplePackets=PickList[simulatedSamplePackets,validLaserPowerRanges,False];

	(* Throw message *)
	If[!MatchQ[badLaserPowerRangeSamplePackets,{}]&&messages,
		Message[Error::InvalidLaserPowerRange,ObjectToString[Lookup[badLaserPowerRangeSamplePackets,Object],Cache->simulatedCache]]
	];

	(* Collect invalid option *)
	invalidLaserPowerRangeOption=If[!MatchQ[badLaserPowerRangeSamplePackets,{}],LaserPowerRange];

	(* Create a test for the valid samples and one for the invalid samples *)
	badLaserPowerRangeTests=sampleTests[gatherTests,Test,simulatedSamplePackets,badLaserPowerRangeSamplePackets,"The min laser power is less than the max laser power for `1`:",simulatedCache];

	(* -- Valid CalibrantLaserPowerRange (min < max) -- *)
	suppliedCalibrantLaserPowerRanges=Lookup[roundedMassSpecOptions,CalibrantLaserPowerRange];

	(* Check that all min masses are less than max masses, skip this check if user specified CalibrantLaserPowerRange is null, will throw an error at the end *)
	validCalibrantLaserPowerRanges=Map[
		If[MatchQ[#,(Automatic|Null)],
			True,
			Module[{minPower,maxPower},
				{minPower,maxPower}=List@@#;
				minPower<maxPower
			]
		]&,
		suppliedCalibrantLaserPowerRanges
	];

	(* Get the samples for which the calibrant laser power range is invalid *)
	badCalibrantLaserPowerRangeSamplePackets=PickList[simulatedSamplePackets,validCalibrantLaserPowerRanges,False];

	(* Throw message *)
	If[!MatchQ[badCalibrantLaserPowerRangeSamplePackets,{}]&&messages,
		Message[Error::InvalidCalibrantLaserPowerRange,ObjectToString[Lookup[badCalibrantLaserPowerRangeSamplePackets,Object],Cache->simulatedCache]]
	];

	(* Collect invalid option *)
	invalidCalibrantLaserPowerRangeOption=If[!MatchQ[badCalibrantLaserPowerRangeSamplePackets,{}],CalibrantLaserPowerRange];

	(* Create a test for the valid samples and one for the invalid samples *)
	badCalibrantLaserPowerRangeTests=sampleTests[gatherTests,Test,simulatedSamplePackets,badCalibrantLaserPowerRangeSamplePackets,"The min calibrant laser power is less than the max laser power for `1`:",simulatedCache];

	(* - Validate MALDI plate option - *)
	allowedMALDIPlates={Model[Container, Plate, MALDI, "96-well Ground Steel MALDI Plate"],Model[Container, Plate, MALDI, "96-well Polished Steel MALDI Plate"]};
	maldiPlateError=!MemberQ[allowedMALDIPlates, ObjectP[Lookup[maldiPlatePacket,Object]]];

	(* Throw message *)
	If[maldiPlateError&&messages,
		Message[Error::UnsupportedMALDIPlate,allowedMALDIPlates]
	];

	(* Collect invalid option *)
	invalidMALDIPlateOption=If[maldiPlateError,MALDIPlate];

	(* Create test *)
	maldiPlateTest=If[gatherTests,
		Test["The requested MALDI plate is supported by the mass spectrometer:",maldiPlateError,False]
	];

	(* -- RESOLVE EXPERIMENT OPTIONS -- *)

	(* Get user-supplied aliquot options *)
	{suppliedAliquots,suppliedAssayVolumes,suppliedAliquotVolumes,suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers}=Lookup[
		samplePrepOptions,
		{Aliquot,AssayVolume,AliquotAmount,TargetConcentration,AssayBuffer,AliquotContainer}
	];

	(* Get user-supplied mass-spec options *)
	{
		suppliedIonModes,
		suppliedSpottingMethods,
		suppliedLensVoltages,
		suppliedGridVoltages,
		suppliedDelayTimes,
		suppliedGains,
		suppliedNumberOfShots,
		suppliedCalibrantNumberOfShots,
		suppliedShotsPerRaster,
		suppliedInstrument
	}=Lookup[
		roundedMassSpecOptions,
		{
			IonMode,
			SpottingMethod,
			LensVoltage,
			GridVoltage,
			DelayTime,
			Gain,
			NumberOfShots,
			CalibrantNumberOfShots,
			ShotsPerRaster,
			Instrument
		}
	];

	(* Get the Model of suppliedInstrument*)
	suppliedInstrumentModel = If[MatchQ[suppliedInstrument,ObjectP[Object[Instrument]]],
		Download[fastAssocLookup[fastCacheBall, suppliedInstrument, Model],Object],
		Download[suppliedInstrument,Object]
	];

	(* These should be defaulted but are Automatic in case we are doing ESI - default them here *)
	suppliedSampleVolumes=resolveAutomaticOption[SampleVolume,roundedMassSpecOptions,0.8*Microliter];

	(*--- resolve ShotsPerRaster ---*)
	resolvedShotsPerRaster=If[MatchQ[suppliedShotsPerRaster,Except[Automatic]],
		suppliedShotsPerRaster,
		5
	];
	(*--- resolve NumberOfShots ---*)
	resolvedNumberOfShots=If[MatchQ[suppliedNumberOfShots,Except[Automatic]],
		suppliedNumberOfShots,
		If[resolvedShotsPerRaster>500,
			resolvedShotsPerRaster,
			2000
		]
	];
	(*--- resolve CalibrantNumberOfShots ---*)
	resolvedCalibrantNumberOfShots=If[MatchQ[suppliedCalibrantNumberOfShots,Except[Automatic]],
		suppliedCalibrantNumberOfShots,
		If[resolvedShotsPerRaster>100,
			resolvedShotsPerRaster,
			2000
		]
	];


	(* --- Error Check for NumberOfShots*)
	(* Total number of shots needs to be larger than ShotsPerRaster*)
	invalidNumberOfShots=(resolvedNumberOfShots<resolvedShotsPerRaster);

	(* Throw message *)
	If[invalidNumberOfShots&&messages,
		Message[Error::MALDINumberOfShotsTooSmall,allowedMALDIPlates]
	];

	(* Collect invalid option *)
	invalidNumberOfShotsOption=If[invalidNumberOfShots,{NumberOfShots,ShotsPerRaster}];

	(* Create test *)
	numberOfShotsTest=If[gatherTests,
		Test["The NumberOfShots is larger than ShotsPerRaster so it can finsh at lease one data collection:",invalidNumberOfShots,False]
	];

	(* Total number of shots needs to be larger than ShotsPerRaster*)
	invalidCalibrantNumberOfShots=(resolvedCalibrantNumberOfShots<resolvedShotsPerRaster);

	(* Throw message *)
	If[invalidCalibrantNumberOfShots&&messages,
		Message[Error::MALDICalibrantNumberOfShotsTooSmall,allowedMALDIPlates]
	];

	(* Collect invalid option *)
	invalidCalibrantNumberOfShotsOption=If[invalidCalibrantNumberOfShots,{CalibrantNumberOfShots,ShotsPerRaster}];

	(* Create test *)
	calibrantNumberOfShotsTest=If[gatherTests,
		Test["The CalibrantNumberOfShots is larger than ShotsPerRaster so it can finsh at lease one data collection:",invalidNumberOfShots,False]
	];


	(* Resolve master switches *)
	resolvedOptionsBySample=MapThread[
		Function[
			{
				(*1*)suppliedIonMode,
				(*2*)suppliedCalibrant,
				(*3*)suppliedMatrix,
				(*4*)suppliedCalibrantMatrix,
				(*5*)suppliedMassRange,
				(*6*)suppliedLaserPowerRange,
				(*7*)suppliedCalibrantLaserPowerRange,
				(*8*)suppliedSpottingMethod,
				(*9*)suppliedLensVoltage,
				(*10*)suppliedGridVoltage,
				(*11*)suppliedDelayTime,
				(*12*)suppliedGain,
				(*13*)suppliedSampleVolume,
				(*14*)suppliedAliquot,
				(*15*)suppliedAssayVolume,
				(*16*)suppliedAliquotVolume,
				(*17*)suppliedTargetConcentration,
				(*18*)suppliedAssayBuffer,
				(*19*)suppliedAliquotContainer,
				(*20*)simulatedSamplePacket,
				(*21*)sampleModelPacket,
				(*22*)molecularWeights,
				(*23*)containerModel,
				(*24*)filteredAnalytes
			},
			Module[{sampleCategory,pHValue,pKaValue,acid,base,ionMode,calibrant,calibrantPacket,preferredMatrix,matrix,preferredSpottingMethod,
				spottingMethod,suppliedMinMass,suppliedMaxMass,calibrantPeaks,numberOfCalibrantPeaks,roundBuffer,edgeBuffer,
				minMassFromPeakFunction,maxMassFromPeakFunction,minMass,maxMass,peaksInRange,flankingPeaks,numberOfPeaksInRange,laserPowerRange,
				calibrantLaserPowerRange,lensVoltage,gridVoltage,delayTime,impliedAliquot,compatibleContainer,gain,
				preResolvedAliquot,aliquotWarning,requiredAliquotAmount,aliquotVolumeError,invalidMassRangeBoolean,calibrantMatrix,
				massInCalibrantRangeBool,validCalibrantQ, invalidMatrixSampleQ, uninformedMatrixModelQ, invalidCalibrantMatrixSampleQ,
				uninformedCalibrantMatrixModelQ},

				(* If specifically just DNA, we know some optimal settings, otherwise no special settings *)
				sampleCategory=If[MemberQ[filteredAnalytes,ObjectP[Model[Molecule,Oligomer]]],
					If[MemberQ[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[filteredAnalytes,Molecule]],DNA],
						DNA,
						None
					],
						None
				];

				(* -- Resolve ion mode -- *)
				pHValue=Lookup[simulatedSamplePacket,pH];
				pKaValue=If[!MatchQ[filteredAnalytes,{}|{Null..}],
					Mean[Cases[Lookup[filteredAnalytes,pKa],_?NumericQ]],
					Null];
				acid=If[!MatchQ[filteredAnalytes,{}|{Null..}],
					Or@@(Lookup[filteredAnalytes,Acid]/.{Null|$Failed->False}),
					Null];
				base=If[!MatchQ[filteredAnalytes,{}|{Null..}],
					Or@@(Lookup[filteredAnalytes,Base]/.{Null|$Failed->False}),
					Null];

				ionMode=Which[
					MatchQ[suppliedIonMode,IonModeP],suppliedIonMode,

				(* - Resolve automatic - *)

				(* Acid/Based flag based resolution *)
					(* The presence of basic residues enhances the ion yields of protonated molecules -> Positive *)
					TrueQ[acid],Negative,
					TrueQ[base],Positive,

				(* pKa-based resolution *)
					(* high pKa tend to bind protons, gaining a positive charge in the process -> Positive *)
					(* low pKA tend to loose a proton -> Negative *)
					NumericQ[pKaValue]&&pKaValue<8,Negative,
					NumericQ[pKaValue]&&pKaValue>=8,Positive,

				(* pH-based resolution *)
					(* pH is the property of the solution, so with low pH, a lot of protons are available, so most likely we are doing Positive *)
					NumericQ[pHValue]&&pHValue<5,Positive,
					NumericQ[pHValue]&&pHValue>=5,Negative,

				(* Default to positive, since this generally works *)
					True,Positive
				];

				(* Do check if user supplied a calibrant and MWs is known to see if the MW is in range*)
				{massInCalibrantRangeBool,validCalibrantQ}=If[
					MatchQ[molecularWeights,{MolecularWeightP..}]&&MatchQ[suppliedCalibrant,ObjectP[]],
					Module[{internalCalibrantPacket,referencePeaks,eachMassInRangeQ,eachValidCalibrantQ},

						(* Get model packet of the calibrant *)
						internalCalibrantPacket=If[MatchQ[suppliedCalibrant,ObjectP[Object[Sample]]],
							fetchPacketFromFastAssoc[Lookup[fetchPacketFromFastAssoc[suppliedCalibrant,fastCacheBall],Model],fastCacheBall],
							fetchPacketFromFastAssoc[suppliedCalibrant,fastCacheBall]
						];
						(* Lookup calibrant peaks *)
						referencePeaks=If[MatchQ[ionMode,Positive],Lookup[internalCalibrantPacket,ReferencePeaksPositiveMode],Lookup[internalCalibrantPacket,ReferencePeaksNegativeMode]];
						(* Check that all molecular weights are within the min and max of the peaks *)
						eachMassInRangeQ=If[Length[referencePeaks]==0,
							False,
							And@@((RangeQ[#,{Min[referencePeaks],Max[referencePeaks]}]&)/@molecularWeights)
						];
						eachValidCalibrantQ=MemberQ[Lookup[relevantCalibrantModelPackets,Object],Lookup[internalCalibrantPacket,Object]];
						{eachMassInRangeQ,eachValidCalibrantQ}
					],
					{True,True}
				];

				(* -- Resolve calibrant -- *)
				calibrant=Switch[{suppliedCalibrant,ionMode,sampleCategory},
					{ObjectP[],_,_},suppliedCalibrant,
					{_,Negative,_},Model[Sample,StockSolution,Standard,"Peptide/Protein Calibrant Mix"],
					{_,Positive,DNA},Model[Sample,StockSolution,Standard,"IDT ssDNA Ladder 10-60 nt, 40 ng/uL"],
					{_,Positive,_},Model[Sample,StockSolution,Standard,"Peptide/Protein Calibrant Mix"]
				];


				(* Get the packet associated with the resolved calibrant *)
				calibrantPacket=If[validCalibrantQ,findModelPacketFunction[calibrant,calibrantSamplePackets,relevantCalibrantModelPackets],{}];

				(* -- Resolve matrix -- *)
				preferredMatrix=If[validCalibrantQ,Download[FirstOrDefault[Lookup[calibrantPacket,PreferredMALDIMatrix]],Object],{}];

				matrix=Which[
					ObjectQ[suppliedMatrix],
						suppliedMatrix,
					MatchQ[{ionMode,sampleCategory,molecularWeights},{Positive,DNA,_?(MemberQ[#,LessP[10000 Dalton]]&)}],
						Model[Sample,Matrix,"HPA MALDI matrix"],
					MatchQ[{ionMode,sampleCategory,molecularWeights},{Positive,DNA,_?(MemberQ[#,GreaterEqualP[10000 Dalton]]&)}],
						Model[Sample,Matrix,"HPA MALDI matrix"],
					ObjectQ[preferredMatrix],
						preferredMatrix,
					True,
						Model[Sample,Matrix,"THAP MALDI matrix"]
				];

				(* Check if samples were given for Matrix option that have parent Model[Sample, Matrix] *)
				invalidMatrixSampleQ = If[MatchQ[matrix, ObjectP[Object[Sample]]],
					!MatchQ[Download[matrix, Model, Cache -> simulatedCache], ObjectP[Model[Sample, Matrix]]],
					False
				];

				(* Check if (parent) Model Matrix has SpottingDryTime and SpottingVolume informed *)
				uninformedMatrixModelQ = If[!invalidMatrixSampleQ,
					NullQ /@ Which[
						MatchQ[matrix, ObjectP[Object[Sample]]], Download[matrix, Model[{SpottingDryTime, SpottingVolume}], Cache -> simulatedCache],
						True, Download[matrix, {SpottingDryTime, SpottingVolume}, Cache -> simulatedCache]
					],
					{False, False}
				];

				(* --- Resolve CalibrantMatrix ---*)
				calibrantMatrix=If[MatchQ[suppliedCalibrantMatrix,Except[Automatic]],

					(* --- If user specified, use what user specified.----*)
					suppliedCalibrantMatrix,
					If[
						(* --- else checke if prfferred Matrix was specified by the calibrant ---*)
						ObjectQ[preferredMatrix],
						preferredMatrix,
						(*--- catch all to used the same as the samples matrix---*)
						matrix
					]
				];

				(* Check if samples were given for CalibrantMatrix option that have parent Model[Sample, Matrix] *)
				invalidCalibrantMatrixSampleQ = If[MatchQ[calibrantMatrix, ObjectP[Object[Sample]]],
					!MatchQ[Download[calibrantMatrix, Model, Cache -> simulatedCache], ObjectP[Model[Sample, Matrix]]],
					False
				];

				(* Check if (parent) Model CalibrantMatrix has SpottingDryTime and SpottingVolume informed *)
				uninformedCalibrantMatrixModelQ = If[!invalidCalibrantMatrixSampleQ,
					NullQ /@ Which[
						MatchQ[calibrantMatrix, ObjectP[Object[Sample]]], Download[calibrantMatrix, Model[{SpottingDryTime, SpottingVolume}], Cache -> simulatedCache],
						True, Download[calibrantMatrix, {SpottingDryTime, SpottingVolume}, Cache -> simulatedCache]
					],
					{False, False}
				];

				(* -- Resolve spotting method -- *)
				preferredSpottingMethod=Lookup[calibrantPacket,PreferredSpottingMethod];

				spottingMethod=Which[
					MatchQ[suppliedSpottingMethod,SpottingMethodP],suppliedSpottingMethod,
					MatchQ[preferredSpottingMethod,SpottingMethodP],preferredSpottingMethod,
					True,Sandwich
				];

				(* -- Resolve mass range -- *)

				(*For now ESI-QTOF only accept a span as the mass input, we check it here and return a error checker if it's not*)
				invalidMassRangeBoolean=!(MatchQ[suppliedMassRange,(_Span)|Automatic]);

				(* Extract min/max mass from span *)
				{suppliedMinMass,suppliedMaxMass}=If[MatchQ[suppliedMassRange,Automatic|Except[_Span]],
					{Automatic,Automatic},
					List@@suppliedMassRange
				];

				calibrantPeaks=If[
					validCalibrantQ,
					Sort[
						Lookup[
							calibrantPacket,
							If[MatchQ[ionMode,Positive],ReferencePeaksPositiveMode,ReferencePeaksNegativeMode]
						]
					],
					{}
				];

				numberOfCalibrantPeaks=Length[calibrantPeaks];

				roundBuffer=250 Dalton;
				edgeBuffer=25 Dalton;
				(* the minimum MinMass is 750 Dalton *)
				minMassFromPeakFunction[flankingPeaks:{UnitsP[Dalton]..}]:=Max[Floor[First[Sort[flankingPeaks],0 Dalton]-edgeBuffer,roundBuffer],750 Dalton];
				maxMassFromPeakFunction[flankingPeaks:{UnitsP[Dalton]..}]:=With[
					{
						instrumentMaxMassLimit = If[
							MatchQ[suppliedInstrumentModel, ObjectReferenceP[{Model[Instrument, MassSpectrometer, "Microflex LRF"]}]],
							300000 Dalton,
							500000 Dalton
						]
					},
					Min[Ceiling[Last[Sort[flankingPeaks]]+edgeBuffer,roundBuffer], instrumentMaxMassLimit]
				];

				{minMass,maxMass}=Switch[{numberOfCalibrantPeaks,suppliedMinMass,suppliedMaxMass,molecularWeights},
					(* Not enough calibrant peaks, don't worry about trying to come up with something good *)
					{0|1,___},
						{1000 Dalton, 10000 Dalton},

					(* - Resolve both, MW known - *)
					{_,Automatic,Automatic,{MolecularWeightP..}},

					(* Scenario 1: we have 1 analyte inside the sample or more than one but they are close together - select a min mass and max mass by choosing the 3 reference peaks in the center of the calibrant, around the MW of the sample *)
					(* Scenario 2: we have more than 1 analytes in the sample, and their MW is far spread *)
					Module[{nearestPeaks,closestPeakIndex,flankingPeaks,numberOfAnalytes},

						(* determine how many analytes we are looking at *)
						numberOfAnalytes=Length[molecularWeights];

						(* Find the 3 nearest peaks and the position of the closest peak *)
						nearestPeaks=Sort[Nearest[calibrantPeaks,Mean[molecularWeights],3]];
						closestPeakIndex=First[Nearest[calibrantPeaks->"Index",Mean[molecularWeights]]];

						(* Adjust slightly if our 3 nearest peaks are all to the left or all to the right of our sample *)
						flankingPeaks=Switch[nearestPeaks-Mean[molecularWeights],
							(* All close peaks are larger than our molecular weight, so we want one on the left *)
							{GreaterP[0 Dalton]..},
								If[closestPeakIndex-1<1,
									(* No peak to the left of the sample, use sample molecular weight to mark left end *)
									Prepend[nearestPeaks,Min[molecularWeights]],
									(* There is a peak, so replace our rightmost peak with one on the left - go from {b,c,d} to {a,b,c} *)
									Prepend[Drop[nearestPeaks,-1],calibrantPeaks[[closestPeakIndex-1]]]
								],

							(* All close peaks are smaller than our molecular weight, so we want one on the right  - if there isn't one make sure we still include sample in our range *)
							{LessP[0 Dalton]..},
								If[closestPeakIndex+1>numberOfCalibrantPeaks,
									(* No peak to the right of the sample, use sample molecular weight to mark right end *)
									Append[nearestPeaks,Max[molecularWeights]],
									(* There is a peak, so replace our left most peak with one on the right - go from {a,b,c} to {b,c,d} *)
									Append[Drop[nearestPeaks,1],calibrantPeaks[[closestPeakIndex+1]]]
								],

							(* Some peaks are bigger, some smaller so we have nice flanking situation *)
							_,
								nearestPeaks
						];

						(* determine the min/max mass, depending on the flanking situation and the spread of the MW of the sample *)
						Which[
							(* we only have one analyte *)
							numberOfAnalytes==1,
								(* ...the flanking calibrant strategy works for sure - we go for that *)
								{minMassFromPeakFunction[flankingPeaks],maxMassFromPeakFunction[flankingPeaks]},

							(* the smallest and largest MW are both inside the flanking peaks range *)
							Min[molecularWeights]>Min[flankingPeaks] || Max[molecularWeights]<Max[flankingPeaks],
								(* ...the 3 flanking calibrant strategy works - we go for that *)
								{minMassFromPeakFunction[flankingPeaks],maxMassFromPeakFunction[flankingPeaks]},

							(* in all other cases, we have analytes falling outside the range of the 3 flanking peaks, so we adjust *)
							True,
								(* we'll simply use the min and max of the MW from the sample's analytes *)
								{
									Min[minMassFromPeakFunction[molecularWeights],minMassFromPeakFunction[flankingPeaks]],
									Max[maxMassFromPeakFunction[molecularWeights],maxMassFromPeakFunction[flankingPeaks]]
								}
						]
					],
					(* - Resolve both, MW unknown - *)
					(* Select a min mass and max mass by choosing the 3 reference peaks which flank the sample *)
					{_,Automatic,Automatic,_},
						Module[{middleIndices,middlePeaks},
							(* Get the middle index and then take a peak on either side *)
							middleIndices=Ceiling[Length[calibrantPeaks]/2]+{-1, 0, 1};

							(* Take 3 peaks from the middle of the calibrant - unless we have only two total and there is no middle *)
							middlePeaks=If[Length[calibrantPeaks]>2,
								calibrantPeaks[[middleIndices]],
								calibrantPeaks
							];

							{minMassFromPeakFunction[middlePeaks],maxMassFromPeakFunction[middlePeaks]}
						],

					(* - Resolve min mass - *)
					(* Select a min mass that ensures there are at least 3 calibrant peaks and at least one peak to the left of the sample *)
					(* Use the 3 closest calibrant peaks to the left of the maxMass if MW is unknown *)
					{_,Automatic,UnitsP[Dalton],_},
					Module[{peakAndDistanceTuples,positiveDistanceTuples,nearestPeaks,flankingPeaks},
					(* Get a sorted list of peaks to the left of the maxMass (i.e. maxMass-peak>0) *)
						peakAndDistanceTuples=Transpose[{calibrantPeaks,maxMass-calibrantPeaks}];
						positiveDistanceTuples=Sort[Cases[peakAndDistanceTuples,{_,GreaterP[0 Dalton]}],Last];

						(* Take the 3 peaks closest to the left of the maxMass *)
						nearestPeaks=Take[positiveDistanceTuples,UpTo[3]][[All,1]];

						(* If all the nearest peaks are still to the right of the sample, extend range to sample *)
						flankingPeaks=If[MatchQ[molecularWeights,{MolecularWeightP..}]&&MatchQ[nearestPeaks-Min[molecularWeights],{GreaterP[0 Dalton]..}],
							Prepend[nearestPeaks,Min[molecularWeights]],
							nearestPeaks
						];

						{minMassFromPeakFunction[flankingPeaks],suppliedMaxMass}
					],

					(* Resolve max mass *)
					(* Select a max mass that ensures there are at least 3 calibrant peaks and at least one peak to the right of the sample *)
					(* Use the 3 closest calibrant peaks to the right of the minMass if MW is unknown *)
					{_,UnitsP[Dalton],Automatic,UnitsP[Dalton]},
						Module[{peakAndDistanceTuples,positiveDistanceTuples,nearestPeaks,flankingPeaks},

							(* Get a sorted list of peaks to the right of the minMass (i.e. peak-minMass>0) *)
								peakAndDistanceTuples=Transpose[{calibrantPeaks,calibrantPeaks-minMass}];
								positiveDistanceTuples=Sort[Cases[peakAndDistanceTuples,{_,GreaterP[0 Dalton]}],Last];

								(* Take the 3 peaks closest to the left of the maxMass *)
								nearestPeaks=Take[positiveDistanceTuples,UpTo[3]][[All,1]];

								(* If all the nearest peaks are still to the left of the sample, extend range to sample *)
								flankingPeaks=If[MatchQ[molecularWeights,{MolecularWeightP..}]&&MatchQ[Max[molecularWeights]-nearestPeaks,{GreaterP[0 Dalton]..}],
									Append[nearestPeaks,Max[molecularWeights]],
									nearestPeaks
								];

								{suppliedMinMass,maxMassFromPeakFunction[flankingPeaks]}
							],

					(* No resolution needed *)
					{_,UnitsP[Dalton],UnitsP[Dalton],_},
						{suppliedMinMass,suppliedMaxMass}
				];

				(* Check if the peaks flank the molecular weight, provided we know it and there actually are enough peaks that the mass could be flanked *)
				(* We want to avoid throwing additional errors if we already have too few calibrant peaks *)
				peaksInRange=Sort[Cases[calibrantPeaks,RangeP[minMass,maxMass]]];
				flankingPeaks=Or[
					!MatchQ[molecularWeights,{MolecularWeightP..}],
					Length[peaksInRange]<2,
					First[peaksInRange]<Min[molecularWeights]&&Max[molecularWeights]<Last[peaksInRange]
				];

				numberOfPeaksInRange=Length[peaksInRange];

				(* -- Resolve laser power range -- *)
				laserPowerRange=Switch[{suppliedLaserPowerRange,sampleCategory,Mean[molecularWeights]},
					{_Span,_,_},
						suppliedLaserPowerRange,
					{_,DNA,LessP[3500 Dalton]},
						Span[55 Percent,75 Percent],
					{_,DNA,GreaterEqualP[3500 Dalton]},
						Span[65 Percent,85 Percent],
					{_,_,LessP[6000 Dalton]},
						Span[25 Percent,75 Percent],
					{_,_,GreaterEqualP[6000 Dalton]},
						Span[25 Percent,90 Percent],
					(* No known info *)
					{_,_,_},
						Span[25 Percent,90 Percent]
				];

				(* -- Resolve calibrant laser power range -- *)
				calibrantLaserPowerRange=If[MatchQ[suppliedCalibrantLaserPowerRange,Automatic],
					laserPowerRange,
					suppliedCalibrantLaserPowerRange
				];

				(* -- Resolve lens voltage -- *)
				lensVoltage=Switch[{suppliedLensVoltage,sampleCategory},
					{UnitsP[],_},suppliedLensVoltage,
					{_,DNA}, 7.8 Kilovolt,
					_, 7.8 Kilovolt
				];

				(* -- Resolve grid voltage -- *)
				gridVoltage=Switch[{suppliedGridVoltage,sampleCategory},
					{UnitsP[],_},suppliedGridVoltage,
					{_,DNA}, 18.15 Kilovolt,
					_, 18.15 Kilovolt
				];

				(* -- Resolve delay time -- *)
				delayTime=Switch[{suppliedDelayTime,sampleCategory},
					{UnitsP[],_},suppliedDelayTime,
					{_,DNA},250 Nanosecond,
					_,150 Nanosecond
				];

				(* -- Fesolve detector gain -- *)
				gain=If[MatchQ[suppliedGain,Automatic],
					2.,
					suppliedGain
				];

				(* -- Pre-resolve Aliquot Info -- *)
				(* Determine if user wants to aliquot based on their specified options, or leave Automatic if they haven't set any aliquot options *)
				impliedAliquot=If[MatchQ[suppliedAliquot,Automatic],
				(* If user didn't explicitly set Aliquot, but set a core option, assume they want to aliquot *)
					If[MemberQ[{suppliedAssayVolume,suppliedAliquotVolume,suppliedTargetConcentration,suppliedAssayBuffer,suppliedAliquotContainer},Except[False|Null|Automatic]],
						True,
						Automatic
					],
					suppliedAliquot
				];

				(* If the current container won't go in the liquid handler, user must aliquot *)
				(* Note if they supplied an AliquotContainer, this will be the 'containerModel' we're looking at *)
				compatibleContainer=MemberQ[Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling],containerModel];

				(* Aliquot if user asked or if they don't mind and current container needs to change *)
				preResolvedAliquot=If[MatchQ[impliedAliquot,Automatic],
					!compatibleContainer,
					impliedAliquot
				];

				(* If user didn't set any aliquot options, then warn them *)
				aliquotWarning=MatchQ[impliedAliquot,Automatic]&&!compatibleContainer;

				(* - Resolve/Validate Aliquot/AssayVolume- *)
				(* If user indicated they wanted to aliquot, or needs to aliquot and hasn't explicitly indicated not to, set the AssayVolume, min volume is set to 1 Microliter, this is the option limitation from ExperimentAliquot option limit *)
				(* It use to have a hard-coded 50 microliter for requiredAliquotAmount and it was removed.*)
				requiredAliquotAmount= Max[suppliedSampleVolume, 20 Microliter];

				(* No volumes >50mL possible, since they won't fit on the liquid handler *)
				aliquotVolumeError=!MatchQ[impliedAliquot,False]&&MemberQ[{suppliedAssayVolume,suppliedAliquotVolume},GreaterP[50 Milliliter]];

				(*Return resolved single value from big mapthread*)
				{
					(*1*)ionMode,
					(*2*)calibrant,
					(*3*)matrix,
					(*4*)calibrantMatrix,
					(*5*)spottingMethod,
					(*6*)minMass ;; maxMass,
					(*7*)flankingPeaks,
					(*8*)numberOfPeaksInRange,
					(*9*)laserPowerRange,
					(*10*)calibrantLaserPowerRange,
					(*11*)lensVoltage,
					(*12*)gridVoltage,
					(*13*)delayTime,
					(*14*)gain,
					(*15*)preResolvedAliquot,
					(*16*)requiredAliquotAmount,
					(*17*)compatibleContainer,
					(*18*)aliquotWarning,
					(*19*)aliquotVolumeError,
					(*20*)invalidMassRangeBoolean,
					(*21*)massInCalibrantRangeBool,
					(*22*)validCalibrantQ,
					(*23*)invalidMatrixSampleQ,
					(*24*)uninformedMatrixModelQ,
					(*25*)invalidCalibrantMatrixSampleQ,
					(*26*)uninformedCalibrantMatrixModelQ
				}
			]
		],
		{
			(*1*)suppliedIonModes,
			(*2*)suppliedCalibrants,
			(*3*)suppliedMatrices,
			(*4*)suppliedCalibrantMatrices,
			(*5*)suppliedMassRanges,
			(*6*)suppliedLaserPowerRanges,
			(*7*)suppliedCalibrantLaserPowerRanges,
			(*8*)suppliedSpottingMethods,
			(*9*)suppliedLensVoltages,
			(*10*)suppliedGridVoltages,
			(*11*)suppliedDelayTimes,
			(*12*)suppliedGains,
			(*13*)suppliedSampleVolumes,
			(*14*)suppliedAliquots,
			(*15*)suppliedAssayVolumes,
			(*16*)suppliedAliquotVolumes,
			(*17*)suppliedTargetConcentrations,
			(*18*)suppliedAssayBuffers,
			(*19*)suppliedAliquotContainers,
			(*20*)simulatedSamplePackets,
			(*21*)sampleModelPackets,
			(*22*)sampleMolecularWeights,
			(*23*)containerModels,
			(*24*)myFilteredAnalytePackets
		}
	];

	(* Gather MapThread results *)
	{
		(*1*)ionModes,
		(*2*)calibrants,
		(*3*)matrices,
		(*4*)calibrantMatrices,
		(*5*)spottingMethods,
		(*6*)massRanges,
		(*7*)flankingPeakBooleans,
		(*8*)numbersOfPeaksInRange,
		(*9*)laserPowerRanges,
		(*10*)calibrantLaserPowerRanges,
		(*11*)lensVoltages,
		(*12*)gridVoltages,
		(*13*)delayTimes,
		(*14*)gains,
		(*15*)preResolvedAliquots,
		(*16*)requiredAliquotAmounts,
		(*17*)compatibleContainers,
		(*18*)aliquotWarnings,
		(*19*)aliquotVolumeErrors,
		(*20*)invalidMassRangeBooleans,
		(*21*)massInCalibrantRangeBools,
		(*22*)validCalibrantBools,
		(*23*)invalidMatrixSampleBools,
		(*24*)uninformedMatrixModelBools,
		(*25*)invalidCalibrantMatrixSampleBools,
		(*26*)uninformedCalibrantMatrixModelBools
	}=Transpose[resolvedOptionsBySample];

	(* -- UNRESOLVABLE OPTION CHECKS -- *)

	(* Check if all samples with replicates will fit on the plate *)
	suppliedNumberOfReplicates=Lookup[roundedMassSpecOptions,NumberOfReplicates];
	numberOfInputSamples=Length[simulatedSamplePackets];

	numberOfSampleSpots=If[MatchQ[suppliedNumberOfReplicates,Null],
		numberOfInputSamples,
		suppliedNumberOfReplicates*numberOfInputSamples
	];

	numberOfAvailableSpots=Lookup[maldiPlatePacket,NumberOfWells];
	tooManySamples=numberOfAvailableSpots<numberOfSampleSpots;
	invalidReplicatesOption=If[tooManySamples,NumberOfReplicates];


	(* Get the sample for which the calibrant is invalid*)
	badCalibrantSamplePackets=PickList[simulatedSamplePackets,validCalibrantBools,False];


	If[tooManySamples&&messages,
		Message[Error::TooManyMALDISamples,numberOfAvailableSpots,numberOfSampleSpots]
	];

	tooManySamplesTest=If[gatherTests,
		Test["The input samples, and any replicates of those samples, will all fit on one MALDI plate:",tooManySamples,False]
	];

	(* Check if mass range is set such that we can actually calibrate *)
	(* If the mass range is inverted (minMass>maxMass), don't bother throwing additional errors *)
	(* If the calibrant is bad (deprecated or not peaks were populated), don't bother throwing additional errors*)
	uncalibratableSamplePackets=Complement[PickList[simulatedSamplePackets,numbersOfPeaksInRange,0],badMassRangeSamplePackets,badCalibrantSamplePackets];
	uncalibratableSamples=Lookup[uncalibratableSamplePackets,Object,{}];
	invalidCalibrationOption=If[!MatchQ[uncalibratableSamples,{}],MassDetection];

	If[!MatchQ[uncalibratableSamplePackets,{}]&&messages,
		Message[Error::UnableToCalibrate,ObjectToString[uncalibratableSamplePackets,Cache->simulatedCache]];
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	unableToCalibrateTests=sampleTests[gatherTests,Test,simulatedSamplePackets,uncalibratableSamplePackets,"The instrument can be calibrated as there is at least one reference peak in the mass range for `1`:",simulatedCache];

	(* Check if there are fewer than 3 calibrant peaks in range *)
	(* If the mass range is inverted (minMass>maxMass), don't bother throwing additional errors *)
	hardToCalibrateSamplePackets=Complement[PickList[simulatedSamplePackets,numbersOfPeaksInRange,1|2],badMassRangeSamplePackets];
	hardToCalibrateSamples=Lookup[hardToCalibrateSamplePackets,Object,{}];

	If[!MatchQ[hardToCalibrateSamplePackets,{}]&&messages,
		Message[Error::NotEnoughReferencePeaks,ObjectToString[hardToCalibrateSamplePackets,Cache->simulatedCache]];
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	limitedReferencePeaksTests=sampleTests[gatherTests,Test,simulatedSamplePackets,hardToCalibrateSamplePackets,"There are at least 3 reference peaks in the mass range such that the instrument can be calibrated for `1`:",simulatedCache];
	notEnoughReferencePeaksOptions=If[!MatchQ[hardToCalibrateSamplePackets,{}],MassRange];

	(* Get the samples for which the mass range is invalid and samples out of calibrant peak range, so we can throw the below warning only when appropriate *)
	outOfMassRangeSamplePackets=PickList[simulatedSamplePackets,outOfMassRangeBools,False];
	outOfCalibrantRangeSamplePackets=PickList[simulatedSamplePackets,massInCalibrantRangeBools,False];


	(* Get samples out of calibrant peak range - if we already threw the compatible calibrant error above (wrong ion source and invalid calibrants) then we don't throw this warning here *)
	outOfCalibrantRangeSamplePackets=Complement[PickList[simulatedSamplePackets,massInCalibrantRangeBools,False],PickList[simulatedSamplePackets,ionSourceCalibrantMismatchBooleans,True],badCalibrantSamplePackets];
	outOfCalibrantRangeSamples=Lookup[outOfCalibrantRangeSamplePackets,Object,{}];

	(* Throw a message if the MW is not flanked *)
	If[!MatchQ[outOfCalibrantRangeSamplePackets,{}]&&messages&&outsideEngine,
		Message[Warning::IncompatibleCalibrant,ObjectToString[outOfCalibrantRangeSamplePackets,Cache->simulatedCache]]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	outOfRangeCalibrantTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,outOfCalibrantRangeSamplePackets,"The molecular weights of `1` are within the range formed by the reference peaks in the calibrant:",simulatedCache];

	(* Check if user specified Calibrant is valid, if not we throw error message.*)
	If[!And@@validCalibrantBools && messages && outsideEngine,
		Message[Error::MassSpectrometryInvalidCalibrants,
			ObjectToString[PickList[mySimulatedSamples,validCalibrantBools,False],Cache->simulatedCache],
			ObjectToString[PickList[calibrants,validCalibrantBools,False],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidCalibrantTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,validCalibrantBools,False],"For samples `1` in, the specified Calibrant is not valid:",simulatedCache];
	invalidCalibrantOptions=If[!And@@validCalibrantBools,Calibrant];

	(* Check if Matrix was a valid Sample *)
	If[Or@@invalidMatrixSampleBools && messages && outsideEngine,
		Message[Error::InvalidMatrixSample,
			ObjectToString[PickList[matrices,invalidMatrixSampleBools], Cache->simulatedCache]
		]
	];

	(* Check if Matrix was or has a properly informed Model *)
	If[Or@@(Or@@@uninformedMatrixModelBools) && messages && outsideEngine,
		Message[Error::UninformedModelMatrix,
			ObjectToString[PickList[matrices,Or@@@uninformedMatrixModelBools], Cache->simulatedCache],
			PickList[(((uninformedMatrixModelBools /. {True, x_} :> {SpottingDryTime, x}) /. {y_, True} :> {y, SpottingVolume}) /. False -> Nothing), Or@@@uninformedMatrixModelBools]
		]
	];

	(* Assign Matrix to InvalidOptions variable if either error was flagged *)
	invalidMatrixOption = If[Or[Or@@invalidMatrixSampleBools, Or@@(Or@@@uninformedMatrixModelBools)], Matrix, {}];

	matricesPackets = Download[matrices, Cache -> simulatedCache];

	invalidMatrixSampleTests = sampleTests[gatherTests, Test, matricesPackets, PickList[matricesPackets, Or@@invalidMatrixSampleBools], "Matrix `1` in MALDI-TOF should be (or have a Model that is) of the type Model[Sample, Matrix]:", simulatedCache];
	uninformedMatrixTests = sampleTests[gatherTests, Test, matricesPackets, PickList[matricesPackets, Or@@@uninformedMatrixModelBools], "The model for matrix `1` in MALDI-TOF should have SpottingDryTime and SpottingVolume informed:", simulatedCache];

	(* Check if CalibrantMatrix was a valid Sample *)
	If[Or@@invalidCalibrantMatrixSampleBools && messages && outsideEngine,
		Message[Error::InvalidCalibrantMatrixSample,
			ObjectToString[PickList[calibrantMatrices,invalidCalibrantMatrixSampleBools], Cache->simulatedCache]
		]
	];

	(* Check if CalibrantMatrix was or has a properly informed Model *)
	If[Or@@(Or@@@uninformedCalibrantMatrixModelBools) && messages && outsideEngine,
		Message[Error::UninformedModelCalbirantMatrix,
			ObjectToString[PickList[calibrantMatrices,Or@@@uninformedCalibrantMatrixModelBools], Cache->simulatedCache],
			PickList[(((uninformedCalibrantMatrixModelBools /. {True, x_} :> {SpottingDryTime, x}) /. {y_, True} :> {y, SpottingVolume}) /. False -> Nothing), Or@@@uninformedCalibrantMatrixModelBools]
		]
	];

	(* Assign CalibrantMatrix to InvalidOptions variable if either error was flagged *)
	invalidCalibrantMatrixOption = If[Or[Or@@invalidCalibrantMatrixSampleBools, Or@@(Or@@@uninformedCalibrantMatrixModelBools)], CalibrantMatrix, {}];

	calibrantMatricesPackets = Download[calibrantMatrices, Cache -> simulatedCache];

	invalidCalibrantMatrixSampleTests = sampleTests[gatherTests, Test, calibrantMatricesPackets, PickList[calibrantMatricesPackets, Or@@invalidCalibrantMatrixSampleBools], "Calibrant matrix `1` in MALDI-TOF should be (or have a Model that is) of the type Model[Sample, Matrix]", simulatedCache];
	uninformedCalibrantMatrixTests = sampleTests[gatherTests, Test, calibrantMatricesPackets, PickList[calibrantMatricesPackets, Or@@@uninformedCalibrantMatrixModelBools], "The model for calibrant matrix `1` in MALDI-TOF should have SpottingDryTime and SpottingVolume informed", simulatedCache];

	badVolumeSamplePackets=PickList[simulatedSamplePackets,aliquotVolumeErrors,True];
	badVolumeSamples=Lookup[badVolumeSamplePackets,Object,{}];

	If[!MatchQ[badVolumeSamplePackets,{}]&&messages,
		Message[Error::SpottingInstrumentIncompatibleAliquots,ObjectToString[badVolumeSamplePackets,Cache->simulatedCache]];
	];

	(* Check for invalidMassRangeBooleans and throw the corresponding Warning if we're throwing messages *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	If[Or@@invalidMassRangeBooleans && messages && outsideEngine,
		Message[Error::invalidMALDITOFMassDetectionOption,
			ObjectToString[PickList[mySimulatedSamples,invalidMassRangeBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidMALDITOFFMassDetectionOptionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidMassRangeBooleans],"For samples `1` in MALDI-TOF, the MassDetection input should be a mass range (a span):",simulatedCache];
	invalidMALDITOFMassDetectionOptions=If[Or@@invalidMassRangeBooleans,MassDetection];

	invalidAliquotVolumeOption=If[!MatchQ[badVolumeSamples,{}],{AssayVolume,AliquotAmount}];

	(* Create a test for the valid samples and one for the invalid samples *)
	assayVolumeOutOfSpottingInstrumentRangeTest=sampleTests[gatherTests,Test,simulatedSamplePackets,badVolumeSamplePackets,"All of the assay volumes are less than 50mL:",simulatedCache];

	(* Resolve target containers *)
	numberOfAliquots=Length[PickList[mySimulatedSamples,preResolvedAliquots,True]];
	targetContainers=MapThread[
		Function[{compatible,aliquot,assayVolume,aliquotVolume,aliquotContainer},
			Module[{volume},
			(* Default if user didn't supply an aliquot volume, and we didn't pick an AssayVolume (indicating user set Aliquot->False or we resolved to False)
				- this will let is pick a reasonable container if we do need to aliquot
			*)
				volume=FirstCase[{assayVolume,aliquotVolume},VolumeP,1.5 Milliliter];
				If[compatible,
				(* original container/user supplied aliquot container is okay *)
					Null,
				(* original container/user supplied aliquot container can't be used, so we must get a new container *)
					If[numberOfAliquots<10,
						PreferredContainer[volume],
						PreferredContainer[volume,Type -> Plate]
					]
				]
			]
		],
		{compatibleContainers,preResolvedAliquots,requiredAliquotAmounts,suppliedAliquotVolumes,suppliedAliquotContainers}
	];

	(* we only want to throw the aliquot warning if we haven't already thrown the Discarded or NonLiquid error above *)
	relevantAliquotWarnings=MapThread[#1&&!AnyTrue[{#2,#3},TrueQ]&,{aliquotWarnings,discardedSamplesBools,nonLiquidSamplesBools}];

	(* If we're aliquoting and user hasn't supplied ConsolidateAliquots, set to True *)
	(* Since we're going to take a small sample from the aliquots to spot onto the plate, no need for them to be in separate containers *)
	suppliedConsolidation=Lookup[samplePrepOptions,ConsolidateAliquots];
	resolvedConsolidation=If[MatchQ[suppliedConsolidation,Automatic]&&MemberQ[preResolvedAliquots,True],
		True,
		suppliedConsolidation
	];

	(* Prepare options to send to resolveAliquotOptions *)
	aliquotOptions=ReplaceRule[
		mySuppliedExperimentOptions,
		Join[{ConsolidateAliquots->resolvedConsolidation},myResolvedSamplePrepOptions]
	];

	(* Somehow TransferDevices in would fail to populate the cache. A lot of different methods were try to fix this. *)
	(* The final decision is to run TransferDevices[All, All] first to load the Memoization*)
	If[StringQ[$RequiredSearchName],
		Block[{$RequiredSearchName=Null},TransferDevices[All, All]]
	];

	requiredAliquotAmounts=Quiet[AchievableResolution /@ requiredAliquotAmounts];

	(* Resolve Aliquot Options for the MALDI experiment *)
	(* Set warning message to Null since we're throwing our own message above *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[
			ExperimentMassSpectrometry,
			myNonSimulatedSamples,
			mySimulatedSamples,
			aliquotOptions,
			RequiredAliquotContainers -> targetContainers,
			RequiredAliquotAmounts -> requiredAliquotAmounts,
			AliquotWarningMessage -> "because these samples will not be in containers compatible with the instrument which spots the MALDI plate.",
			Cache -> simulatedCache,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentMassSpectrometry,
				myNonSimulatedSamples,
				mySimulatedSamples,
				aliquotOptions,
				RequiredAliquotContainers -> targetContainers,
				RequiredAliquotAmounts -> requiredAliquotAmounts,
				AliquotWarningMessage -> "because these samples will not be in containers compatible with the instrument which spots the MALDI plate.",
				Cache -> simulatedCache,
				Simulation -> updatedSimulation
			],
			{}
		}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[mySuppliedExperimentOptions];

	(* -- GATHER THE OUTPUT -- *)

	(* Gather our invalid input and invalid option variables. *)
	(* Note: We don't throw Error::InvalidInput or Error::InvalidOption here since we only throw this once in the main resolver together with the other option/input checks *)
	maldiInvalidInputs=DeleteDuplicates[Flatten[{}]];
	maldiInvalidOptions=DeleteCases[Flatten[{
		invalidLaserPowerRangeOption,
		invalidCalibrantLaserPowerRangeOption,
		invalidMALDIPlateOption,
		invalidReplicatesOption,
		invalidCalibrationOption,
		invalidAliquotVolumeOption,
		invalidMALDITOFMassDetectionOptions,
		invalidCalibrantOptions,
		notEnoughReferencePeaksOptions,
		invalidNumberOfShotsOption,
		invalidCalibrantNumberOfShotsOption,
		invalidMatrixOption,
		invalidCalibrantMatrixOption
	}],Null];

	(* Gather all the resolved options for MALDI-TOF *)
	maldiResolvedOptions=ReplaceRule[
			Normal[roundedMassSpecOptions],
			Join[
				{
					(* resolved options *)
					IonMode->ionModes,
					Calibrant->calibrants,
					Matrix->matrices,
					CalibrantMatrix->calibrantMatrices,
					SpottingMethod->spottingMethods,
					MassDetection->massRanges,
					LaserPowerRange->laserPowerRanges,
					CalibrantLaserPowerRange->calibrantLaserPowerRanges,
					LensVoltage->lensVoltages,
					GridVoltage->gridVoltages,
					DelayTime->delayTimes,
					Gain->gains,
					MassAnalyzer->resolveAutomaticOption[MassAnalyzer,roundedMassSpecOptions,TOF],
					(* MALDI options that are defaulted to a value (or user-supplied) if doing MALDI *)
					SampleVolume->suppliedSampleVolumes,
					AccelerationVoltage->resolveAutomaticOption[AccelerationVoltage,roundedMassSpecOptions, 19.5*Kilovolt],
					MALDIPlate->resolveAutomaticOption[MALDIPlate,roundedMassSpecOptions,Model[Container,Plate,MALDI,"96-well Ground Steel MALDI Plate"]],
					(*Those 3 options were resolved and error check above*)
					NumberOfShots->resolvedNumberOfShots,
					ShotsPerRaster->resolvedShotsPerRaster,
					CalibrantNumberOfShots->resolvedCalibrantNumberOfShots,
					SpottingPattern->resolveAutomaticOption[SpottingPattern,roundedMassSpecOptions,All],
					SpottingDryTime->resolveAutomaticOption[SpottingDryTime,roundedMassSpecOptions,15*Minute],
					CalibrantVolume->resolveAutomaticOption[CalibrantVolume,roundedMassSpecOptions,0.8*Microliter],
					MatrixControlScans->resolveAutomaticOption[MatrixControlScans,roundedMassSpecOptions,True],


					(*ESI-QQQ specific options are resolved to Null*)
					InfusionSyringe->resolveAutomaticOption[InfusionSyringe,roundedMassSpecOptions,Null],
					IonGuideVoltage->resolveAutomaticOption[IonGuideVoltage,roundedMassSpecOptions,Null],

					(*ESI-QQQ specific TandemMass Specific Options*)
					ScanMode->resolveAutomaticOption[ScanMode,roundedMassSpecOptions,Null],
					MassTolerance->resolveAutomaticOption[MassTolerance,roundedMassSpecOptions,Null],
					FragmentMassDetection->resolveAutomaticOption[FragmentMassDetection,roundedMassSpecOptions,Null],
					DwellTime->resolveAutomaticOption[DwellTime,roundedMassSpecOptions,Null],
					Fragment->resolveAutomaticOption[Fragment,roundedMassSpecOptions,Null],
					CollisionEnergy->resolveAutomaticOption[CollisionEnergy,roundedMassSpecOptions,Null],
					CollisionCellExitVoltage->resolveAutomaticOption[CollisionCellExitVoltage,roundedMassSpecOptions,Null],
					NeutralLoss->resolveAutomaticOption[NeutralLoss,roundedMassSpecOptions,Null],
					MultipleReactionMonitoringAssays->resolveAutomaticOption[MultipleReactionMonitoringAssays,roundedMassSpecOptions,Null],


					(* all ESI options are resolved to Null. We've already thrown an error in the main resolver if they were not Null, so we return here the user-supplied value, or Null) *)
					InjectionType->resolveAutomaticOption[InjectionType,roundedMassSpecOptions,Null],
					SampleTemperature->resolveAutomaticOption[SampleTemperature,roundedMassSpecOptions,Null],
					Buffer->resolveAutomaticOption[Buffer,roundedMassSpecOptions,Null],
					NeedleWashSolution->resolveAutomaticOption[NeedleWashSolution,roundedMassSpecOptions,Null],
					InjectionVolume->resolveAutomaticOption[InjectionVolume,roundedMassSpecOptions,Null],
					ESICapillaryVoltage->resolveAutomaticOption[ESICapillaryVoltage,roundedMassSpecOptions,Null],
					StepwaveVoltage->resolveAutomaticOption[StepwaveVoltage,roundedMassSpecOptions,Null],
					SourceTemperature->resolveAutomaticOption[SourceTemperature,roundedMassSpecOptions,Null],
					DesolvationTemperature->resolveAutomaticOption[DesolvationTemperature,roundedMassSpecOptions,Null],
					DesolvationGasFlow->resolveAutomaticOption[DesolvationGasFlow,roundedMassSpecOptions,Null],
					ConeGasFlow->resolveAutomaticOption[ConeGasFlow,roundedMassSpecOptions,Null],
					DeclusteringVoltage->resolveAutomaticOption[DeclusteringVoltage,roundedMassSpecOptions,Null],
					InfusionFlowRate->resolveAutomaticOption[InfusionFlowRate,roundedMassSpecOptions,Null],
					ScanTime->resolveAutomaticOption[ScanTime,roundedMassSpecOptions,Null],
					RunDuration->resolveAutomaticOption[RunDuration,roundedMassSpecOptions,Null]
				},
				resolvedAliquotOptions,
				myResolvedSamplePrepOptions,
				resolvedPostProcessingOptions
			]
		];

	(* Gather all the MALDI specific collected tests *)
	maldiTests=Flatten[
		{
			noMolecularWeightTests,optionPrecisionTests,
			badLaserPowerRangeTests,badCalibrantLaserPowerRangeTests,maldiPlateTest,
			tooManySamplesTest,unableToCalibrateTests,limitedReferencePeaksTests,(*nonFlankingRangeTests, wideRangeTests,*)
			assayVolumeOutOfSpottingInstrumentRangeTest,aliquotTests,
			invalidMALDITOFFMassDetectionOptionTests,outOfRangeCalibrantTests,invalidCalibrantTests,
			numberOfShotsTest, calibrantNumberOfShotsTest
		}
	];

	(* Return the resolved options, the tests, the invalid input, and the invalid options gathered for MALDI *)
	{maldiResolvedOptions,maldiTests,maldiInvalidOptions,maldiInvalidInputs}

];


(* ::Subsubsection:: *)
(*resolveESIQTOFOptions*)


(* ========== resolveESIQTOFOptions Helper function ========== *)
(* resolves MALDI specific options that are set to Automatic to a specific value and returns a list of resolved options, tests, and invalid input/option values to the main resolver *)
(* the inputs are the simulated samples, the download packet from the main resolver, the semi-resolved experiment options, and whether we're gathering tests or not *)


resolveESIQTOFOptions[
	myNonSimulatedSamples:ListableP[ObjectP[Object[Sample]]],
	mySimulatedSamples:ListableP[ObjectP[Object[Sample]]],
	myESIDownloadPackets_,
	myResolvedSamplePrepOptions_,
	mySuppliedExperimentOptions_,
	myFilteredAnalytePackets_, (* {{PacketP[IdentityModelTypes]..}..} - our filtered analytes (all of the same general type) for each of our simulated samples that we use internally to our function. *)
	myBooleans:{({BooleanP..}|BooleanP)..},
	mySimulatedCache_,
	updatedSimulation:_Simulation|Null
]:=Module[
	{
	gatherTests,discardedSamplesBools,nonLiquidSamplesBools,outOfMassRangeBools,massInCalibrantRangeBools,ionSourceCalibrantMismatchBooleans,maxMassSupportedBools,
	messages,outsideEngine,simulatedCache,samplePrepOptions,massSpecSpecificOptions,massSpecOptions,suppliedCalibrants,unroundedMassRanges,
	sampleDownload,suppliedCalibrantSampleDownload,suppliedCalibrantModelDownload,relevantCalibrantModelDownload,maldiPlatePacket,instrumentPacket,allInstrumentPackets,
	aliquotContainerPackets,simulatedSamplePackets,sampleModelPackets,simulatedSampleContainerModels,sampleAnalytePackets,calibrantSamplePackets,relevantCalibrantModelPackets,
	sampleCategories,simulatedSampleIdentityModelPackets,syringeModelPacket,
	(* compatible container variables *)
	allowedESIContainers, allowedESIContainersP, esiContainerMinVolumes, esiContainerMaxVolumes,

	(* invalid options/input checking *)
	sampleMolecularWeights,noMolecularWeightSamplePackets,noMolecularWeightTests,measurementLimit,numberOfReplicatesNumber,
	numberOfMeasurements,tooManySamplesQ,tooManyMeasurementsInputs,tooManySamplesTest,roundedMassSpecOptions,optionPrecisionTests,
	suppliedAliquotContainers,unresolvedAliquotContainerModels,aliquotContainerConflicts,badAliquotContainerPackets,badALiquotContainers,
	badAliquotContainerOptions,badAliquotContainerTests,suppliedAliquots,suppliedAssayVolumes,suppliedAliquotVolumes,suppliedTargetConcentrations,
	suppliedAssayBuffers,impliedAliquotBools,simulatedVolumes,esiContainerTuples,simulatedSampleContainers,requiredAliquotAmounts,requiredTargetContainer,

	(* for mapThread resolver *)
	flowInjectionQ, infusionFlowRates,scanTimes,runDurations,flowInjectionSampleTemperature,flowInjectionBuffer,flowInjectionNeedleWashSolution,
	suppliedInjectionType,suppliedFlowInjectionOptions,specifiedFlowInjectionOptions,
	injectionType,mapThreadFriendlyOptions,maxInjectionVolume,autosamplerDeadVolume,targetContainers,requiredAliquotVolumes,ionModes,calibrants,massRanges,
	capillaryVoltages,sourceTemperatures,desolvationTemperatures,desolvationGasFlows,stepwaveVoltages,injectionVolumes,calibrantMassRangeMismatches,transferRequiredWarnings,
	calibrantMassRangeMismatchTests,numReplicates,numReplicatesNoNull,injectedAmountAccountedForReplicates,groupedBySample,injectedAmounts,
	sampleCount,uniqueInjectedVolumes,uniqueTargetContainers,targetContainerDeadVolume,uniqueSamples,sampleTargetContainerRules,simulatedSampleContainerMinVolumes,
	targetContainersResolved,totalVolumesNeeded,injectedVolumesPerSample,sampleVolumeRules,suppliedConsolidation,resolvedConsolidation,

	containerCountTest,invalidContainerCountInputs,invalidAliquotContainerOptions,validAliquotContainerTest,allSyringePackets,
	aliquotOptions,resolvedAliquotOptions,aliquotTests,resolvedPostProcessingOptions,esiInvalidInputs,
	esiInvalidOptions,esiResolvedOptions,esiTests,resolvedAliquotVolumes,directInfusionSampleVolumes,invalidNonAliquotSampleInputs,

	(*New conflict option resolver*)
	invalidVoltagesOptionLists,invalidVoltagesOptionBooleans,invalidGasOptionLists,invalidGasOptionBooleans,invalidMassRangeBooleans,outRangedDesolvationTemperatureBooleans,
	(*ESI_QTOF Tests*)
	invalidESIQTOFVoltagesOptionTests,invalidESIQTOFGasOptionTests,invalidESIQTOFMassDetectionOptionTests,outRangedDesolvationTemperatureTests,invalidESIQTOFVoltagesOptions,
	invalidESIQTOFGasOptions,invalidESIQTOFMassDetectionOptions,outRangedDesolvationTemperatureOptions,aliquotQList,requiredVolumes,invalidNonAliquotSampleVolumesQ,invalidNonAliquotSampleVolumeTests,
	validCalibrantBools,outOfCalibrantRangeSamplePackets,outOfCalibrantRangeSamples,outOfRangeCalibrantTests,
	invalidCalibrantTests,invalidCalibrantOptions,invalidScanTimeBool,invalidScanTimeTest,invalidScanTimeOptions,
	badCalibrantSamplePackets
},


	(* -- SETUP OUR USER SPECIFIED OTPIONS AND CACHE -- *)
	{gatherTests,discardedSamplesBools,nonLiquidSamplesBools,outOfMassRangeBools,ionSourceCalibrantMismatchBooleans,maxMassSupportedBools}=myBooleans;
	messages = !gatherTests;
	outsideEngine=!MatchQ[$ECLApplication,Engine];

	testOrNull[testDescription_String,passQ:BooleanP]:=If[gatherTests,
		Test[testDescription,True,Evaluate[passQ]],
		Null
	];

	simulatedCache=mySimulatedCache;

	(* Separate out our MassSpectrometry options from our Sample Prep options. *)
	{samplePrepOptions,massSpecSpecificOptions}=splitPrepOptions[mySuppliedExperimentOptions];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	massSpecOptions=Association[massSpecSpecificOptions];

	(* Lookup supplied values from options *)
	{suppliedCalibrants,unroundedMassRanges}=Lookup[massSpecOptions,{Calibrant,MassDetection}];

	(* deconstruct the download packets *)

	{
		(*1*)sampleDownload,
		(*2*)suppliedCalibrantSampleDownload,
		(*3*)suppliedCalibrantModelDownload,
		(*4*)relevantCalibrantModelDownload,
		(*5*){{maldiPlatePacket}},
		(*6*)allInstrumentPackets,
		(*7*)allSyringePackets,
		(*8*)aliquotContainerPackets,
		(*9*)syringeModelPacket
	}=myESIDownloadPackets;

	simulatedSamplePackets=sampleDownload[[All,1]];
	sampleModelPackets=sampleDownload[[All,2]];

	(* Extact the simulated sample container models *)
	simulatedSampleContainerModels=sampleDownload[[All,3]];

	(* Extract simulated sample containers *)
	simulatedSampleContainers = Download[Lookup[simulatedSamplePackets,Container],Object];

	sampleAnalytePackets=sampleDownload[[All,4]];
	simulatedSampleIdentityModelPackets=sampleDownload[[All,5]];
	calibrantSamplePackets=Flatten[suppliedCalibrantSampleDownload];
	relevantCalibrantModelPackets=Flatten[relevantCalibrantModelDownload];

	(* Determine the sample category of each sample since we will use this for the resolution below. If the category cannot be determined, it will be labeled None *)
	(* Categories are DNA (and all other oligonucleotides) / Peptide / Protein (including antibodies) / None *)
	sampleCategories=MapThread[Function[{samplePacket,modelPacket,sampleAnalytePackets},
		Which[
			MemberQ[Flatten@sampleAnalytePackets,ObjectP[Model[Molecule,Oligomer]]],
				Which[
					(* we treat any oligonucleotide as DNA - don't just look at PolymerType since that may contain the Mixed category *)
					MemberQ[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],(DNA|PNA|RNA|GammaLeftPNA|GammaRightPNA)],
						DNA,
					(* peptides are their own category *)
					MemberQ[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],Peptide],
						Peptide,
					(* just in case we missed a category or the pattern expands, do this catch-all *)
					True,
						None
				],
			(* Intact proteins and antibodies are treated as Protein *)
			MemberQ[Flatten@sampleAnalytePackets,ObjectP[Model[Molecule,Protein]]],
				Protein,
			(* If we're dealing with stock solution standards, and they have oligomers as StandardComponents we can check the StandardComponents properties *)
			MatchQ[Lookup[samplePacket,Model],Model[Sample,StockSolution,Standard]]&&!MatchQ[Flatten@sampleAnalytePackets,{}],
				Which[
					MatchQ[Commonest[DeleteCases[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],Except[PolymerP]]],(DNA|PNA|RNA|GammaLeftPNA|GammaRightPNA)],
						DNA,
					MatchQ[Commonest[DeleteCases[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],Except[PolymerP]]],Peptide],
						Peptide,
					True,
						None
				],
			(* If we're dealing with a sample chemical, a regular stock solution, or any other sample, we can't determine the sample category *)
			True,
				None
		]
		],
		{simulatedSamplePackets,simulatedSampleIdentityModelPackets,myFilteredAnalytePackets}
	];

	(* -- IDENTIFY CONTAINERS -- *)

	(* update pattern to find containers that will match the thread type and have an appropriate min/max volume *)
	allowedESIContainers = allMassSpectrometrySearchResults["MassSpecCache"][[5]];
	allowedESIContainersP = Alternatives@@allowedESIContainers;
	{esiContainerMinVolumes, esiContainerMaxVolumes} = Transpose[Download[allowedESIContainers, {MinVolume, MaxVolume},Date->Now]]/.Null->0.05*Milliliter;

	(* -- ESI-SPECIFIC INPUT VALIDATION CHECKS -- *)

	(* -- Samples have molecular weights and/or sample category -- *)

	(* Lookup the molecular weight of analytes, per sample *)
	sampleMolecularWeights=MapThread[
		Function[{simulatedSamples, analytePackets},
			If[!MatchQ[analytePackets,{}|{Null..}],
				Cases[Lookup[analytePackets,MolecularWeight],MolecularWeightP],
				{}]],
		{simulatedSamplePackets,myFilteredAnalytePackets}];

	(* Get a list of samples which are missing molecular weight information AND don't have a sample category AND don't have a mass range specified *)
	noMolecularWeightSamplePackets=Complement[
		MapThread[Function[{mw,massRange,category,packet},
			If[Length[mw]==0 && MatchQ[massRange,Automatic] && MatchQ[category,None],
				packet,
				Nothing
			]],
			{sampleMolecularWeights,unroundedMassRanges,sampleCategories,simulatedSamplePackets}
		],
		PickList[simulatedSamplePackets,nonLiquidSamplesBools,True],PickList[simulatedSamplePackets,discardedSamplesBools,True]
	];

	(* Throw warning message (but only if we haven't thrown a Discarded or Non-Liquid sample error *)
	If[!MatchQ[noMolecularWeightSamplePackets,{}] && messages && outsideEngine,
		Message[Warning::DefaultMassDetection,ObjectToString[Lookup[noMolecularWeightSamplePackets,Object],Cache->simulatedCache]]
	];

	(* Generate tests *)
	noMolecularWeightTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,noMolecularWeightSamplePackets,"The molecular weights of or the sample category (DNA, Peptide, Protein, etc) of `1` are known, such that a sensible mass range can be determined automatically, if needed:",simulatedCache];



	(* -- ESI-SPECIFIC OPTION PRECISION CHECKS -- *)

	(* Verify that the ESI mass spec options are not overly precise *)
	(* TODO include MassRange precision when Wyatt is done implementing that *)
	{roundedMassSpecOptions,optionPrecisionTests}=If[gatherTests,
		RoundOptionPrecision[massSpecOptions,
			{ESICapillaryVoltage, StepwaveVoltage, DeclusteringVoltage, SourceTemperature,DesolvationTemperature,ConeGasFlow,DesolvationGasFlow,InfusionFlowRate,RunDuration,ScanTime,SampleTemperature,InjectionVolume (*,MinMass,MaxMass *)},
			{1*10^-2 Kilovolt,1*10^0 Volt,1*10^0 Volt,1*10^0 Celsius,1*10^0 Celsius,1*10^0 Liter/Hour,1*10^0 Liter/Hour,1*10^-1 Microliter/Minute,1*10^-2 Minute,1*10^-3 Second, 1*10^-1 Celsius, 10^-1 Microliter (*,1*10^-2 Dalton,1*10^-2 Dalton *)},
			Output->{Result,Tests}
		],
		{RoundOptionPrecision[massSpecOptions,
			{ESICapillaryVoltage, StepwaveVoltage, DeclusteringVoltage, SourceTemperature,DesolvationTemperature,ConeGasFlow,DesolvationGasFlow,InfusionFlowRate,RunDuration,ScanTime,SampleTemperature,InjectionVolume (*,MinMass,MaxMass *)},
			{1*10^-2 Kilovolt,1*10^0 Volt,1*10^0 Volt,1*10^0 Celsius,1*10^0 Celsius,1*10^0 Liter/Hour,1*10^0 Liter/Hour,1*10^-1 Microliter/Minute,1*10^-2 Minute,1*10^-3 Second,1*10^-1 Celsius, 10^-1 Microliter (*,1*10^-2 Dalton,1*10^-2 Dalton *)}
		],Null}
	];

	(* -- ESI-SPECIFIC CONFLICTING OPTIONS CHECKS -- *)

	(* -- Validate AliquotContainer -- *)

	(* get the containers that were specified by the users - Download the object in case they referenced to it by Name *)
	suppliedAliquotContainers=Lookup[samplePrepOptions,AliquotContainer];

	(* get the model container of the user specified aliquot container *)
	unresolvedAliquotContainerModels=MapThread[
		If[MatchQ[#,Automatic],
			Null,
			(* If a model was supplied we just use that *)
			If[MatchQ[#1, ObjectP[Model]],
				#1,
				(* otherwise, it's an object, and we need to lookup the model of the object *)
				Experiment`Private`cacheLookupUVMelting[mySimulatedCache,Download[#1,Object],{Model}]
			]
		]&,
		{suppliedAliquotContainers}
	];

	(* check whether the AliquotContainers, if specified, are compatible with the instrument. Currently these are hardcoded in 'allowedESIContainers' *)
	aliquotContainerConflicts=MapThread[
		Function[{unresolvedAliquotContainer,acModel,samplePacket},
			Switch[unresolvedAliquotContainer,
			(* we're fine if the AliquotContainer is Automatic *)
				Automatic,Nothing,
			(* the user may have given us objects, or models *)
				ObjectP[{Object[Container],Model[Container]}],
				If[
				(* we're fine if the AliquotContainer Model is one of the allowed container models - make sure to Download the Object from it if we were given a Name *)
					MatchQ[Download[acModel,Object],Alternatives@@allowedESIContainers],
					Nothing,
					(* otherwise we collect the sample packet and the bad container *)
					{samplePacket,unresolvedAliquotContainer}
				],
				(* it may be Null if we don't have any AliquotContainer provided, which is fine *)
				_,
				Nothing
			]
		],
		{suppliedAliquotContainers,unresolvedAliquotContainerModels,simulatedSamplePackets}
	];

	(* if we had invalid results, extract the invalid input and the corresponding specified balance *)
	{badAliquotContainerPackets,badALiquotContainers}=If[Length[aliquotContainerConflicts]>0,
		Transpose[aliquotContainerConflicts],
		{{},{}}
	];

	(* Throw Warning message *)
	If[!MatchQ[badAliquotContainerPackets,{}] && messages,
		Message[Error::MassSpectrometryIncompatibleAliquotContainer,ObjectToString[Lookup[badAliquotContainerPackets,Object],Cache->simulatedCache],allowedESIContainers]
	];

	(* Collect invalid options *)
	badAliquotContainerOptions=If[!MatchQ[badAliquotContainerPackets,{}],AliquotContainer];

	(* Create a test for the valid samples and one for the invalid samples *)
	badAliquotContainerTests=sampleTests[gatherTests,Test,simulatedSamplePackets,badLaserPowerRangeSamplePackets,"The provided AliquotContainer is compatible with the instrument for input samples `1`:",simulatedCache];

	(* -- RESOLVE EXPERIMENT OPTIONS -- *)

	(* Get user-supplied aliquot options *)
	{suppliedAliquots,suppliedAssayVolumes,suppliedAliquotVolumes,suppliedTargetConcentrations,suppliedAssayBuffers}=Lookup[
		samplePrepOptions,
		{Aliquot,AssayVolume,AliquotAmount,TargetConcentration,AssayBuffer}
	];

	(* Determine if user wants to aliquot based on their specified options, or leave Automatic if they haven't set any aliquot options *)
	impliedAliquotBools=MapThread[Function[{suppliedAliquot,suppliedAssayVolume,suppliedAliquotVolume,suppliedTargetConcentration,suppliedAssayBuffer,suppliedAliquotContainer},
		If[MatchQ[suppliedAliquot,Automatic],
				(* If user didn't explicitly set Aliquot, but set a core option, assume they want to aliquot *)
				If[MemberQ[{suppliedAssayVolume,suppliedAliquotVolume,suppliedTargetConcentration,suppliedAssayBuffer,suppliedAliquotContainer},Except[False|Null|Automatic]],
					True,
					Automatic
				],
				suppliedAliquot
			]
		],{suppliedAliquots,suppliedAssayVolumes,suppliedAliquotVolumes,suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers}
	];

	(* Get the volume from the samples - this is going to be either the volume of the sample, or the aliquoted volume, or the assay volume if we're diluting down *)
	simulatedVolumes=Lookup[#,Volume]&/@simulatedSamplePackets;

	(* arrange the available containers and their min/max volumes in a transposed list like that {{container,minVol,maxVol}..} since we can use this information further below *)
	esiContainerTuples=Transpose[{allowedESIContainers,esiContainerMinVolumes,esiContainerMaxVolumes}];

	(* get the containers that were specified by the users - Download the object in case they referenced to it by Name *)
	suppliedInjectionType=Lookup[massSpecOptions,InjectionType];
	suppliedFlowInjectionOptions=Lookup[massSpecOptions,{SampleTemperature,Buffer,NeedleWashSolution,InjectionVolume}];

	(* figure out whether any of flowinjections options were specified, as in provided with a value other than Automatic - this is a simple boolean *)
	specifiedFlowInjectionOptions= Or @@ (! MatchQ[#, (Automatic | {Automatic ..})] & /@ suppliedFlowInjectionOptions);

	(* resolve the master switch InjectionType *)
	injectionType=If[!MatchQ[suppliedInjectionType,Automatic],
		(* if the user supplied the injection type, then we just use that - no resolution necessary. WE've thrown errors above if needed *)
		suppliedInjectionType,
		(* If we need to resolve, we look at the options provided, the number of samples, and the container of the samples, in that order *)
		Which[
			(* the moment ANY of the flow-injection specific options are provided by the user, we resolve to FlowInjection (no matter how few) *)
			specifiedFlowInjectionOptions,FlowInjection,

			(*Since DirectInfusion has a much higher dead volume due to the container it gonna use. We check if all simulated volumes is higher than Min volumes of a container, if not we resolved InjectionType to FlowInjection*)
			(!GreaterEqualQ[Min[simulatedVolumes], Min[esiContainerMinVolumes]]),FlowInjection,

			(* if we're dealing with less than 5 samples then we default to DirectInfusion *)
			Length[mySimulatedSamples]<5, DirectInfusion,

			(* if the samples are inside a single plate of the 96 DWP type, we default to FlowInjection *)
			MatchQ[DeleteDuplicates[simulatedSampleContainerModels],{ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]..}]&&Length[DeleteDuplicates[simulatedSampleContainers]]==1, FlowInjection,

			(* catch-all *)
			True,DirectInfusion
		]
	];

	(* make a flow injection check since we're going to switch on that below *)
	flowInjectionQ=MatchQ[injectionType,FlowInjection];


	(* If the user supplied the InfusionFlowRate / ScanTime / RunDuration values, use these, otherwise we default *)
	infusionFlowRates=resolveAutomaticOption[InfusionFlowRate,roundedMassSpecOptions,If[flowInjectionQ,(100*Microliter/Minute),(20*Microliter/Minute)]];
	scanTimes=resolveAutomaticOption[ScanTime,roundedMassSpecOptions,1*Second];
	runDurations=resolveAutomaticOption[RunDuration,roundedMassSpecOptions,1*Minute];


	(* Resolve the single flow-injection specific options *)
	flowInjectionSampleTemperature=If[flowInjectionQ,resolveAutomaticOption[SampleTemperature,roundedMassSpecOptions,Ambient],Null];
	flowInjectionBuffer=If[flowInjectionQ,resolveAutomaticOption[Buffer,roundedMassSpecOptions,Model[Sample,StockSolution,"0.1% FA with 5% Acetonitrile in Water, LCMS-grade"]],Null];
	flowInjectionNeedleWashSolution=If[flowInjectionQ,resolveAutomaticOption[NeedleWashSolution,roundedMassSpecOptions,Model[Sample,StockSolution,"20% Methanol in MilliQ Water"]],Null];

	(* Convert our ESI MS options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentMassSpectrometry,roundedMassSpecOptions];
	(*declaring some globals*)
	maxInjectionVolume=50 Microliter;
	autosamplerDeadVolume=20 Microliter;

	(* Do our big MapThread for resolving the indexmatched options *)
	{
		(*1*)ionModes,
		(*2*)calibrants,
		(*3*)massRanges,
		(*4*)capillaryVoltages,
		(*5*)sourceTemperatures,
		(*6*)desolvationTemperatures,
		(*7*)desolvationGasFlows,
		(*8*)stepwaveVoltages,
		(*9*)injectionVolumes,
		(*10*)calibrantMassRangeMismatches,
		(*11*)transferRequiredWarnings,
		(*12*)invalidVoltagesOptionLists,
		(*13*)invalidVoltagesOptionBooleans,
		(*14*)invalidGasOptionLists,
		(*15*)invalidGasOptionBooleans,
		(*16*)invalidMassRangeBooleans,
		(*17*)outRangedDesolvationTemperatureBooleans,
		(*18*)resolvedAliquotVolumes,
		(*19*)massInCalibrantRangeBools,
		(*20*)validCalibrantBools,
		(*21*)injectedAmounts
	}=Transpose[
		MapThread[Function[
			{
				(*1*)simulatedSamplePacket,
				(*2*)sampleModelPacket,
				(*3*)sample,
				(*4*)containerModel,
				(*5*)options,
				(*6*)suppliedAliquotContainer,
				(*7*)suppliedAliquotContainerModel,
				(*8*)sampleCategory,
				(*9*)molecularWeights,
				(*10*)aliquotBool,
				(*11*)aliquotAmount,
				(*12*)infusionFlowRate,
				(*13*)scanTime,
				(*14*)runDuration,
				(*15*)simulatedSampleVolume,
				(*16*)ionSourceCalibrantMismatchBool,
				(*17*)maxMassSupportedBool,
				(*18*)filteredAnalytes,
				(*19*)eachInfusionFlowRate,
				(*20*)eachScanTime,
				(*21*)eachRunDuration
			},
			Module[{suppliedInjectionVolume,suppliedIonMode,suppliedCalibrant,suppliedMassRange,suppliedInfusionFlowRate,suppliedCapillaryVoltage,
				suppliedSourceTemperature,suppliedDesolvationTemperature,suppliedDesolvationGasFlow,suppliedConeGasFlow,suppliedStepwaveVoltage,
				pKaValue,acid,base, pHValue,ionMode,calibrant,lowRange,midRange,highRange,
				massRange,calibrantPacket,calibrantMassRangeMismatch,capillaryVoltage,
				sourceTemperature,desolvationTemperature,desolvationGasFlow,resolvedCapillaryVoltage,resolvedSourceTemperature,
				resolvedDesolvationTemperature,resolvedDesolvationGasFlow,stepwaveVoltage,injectionVolume,targetContainer,
				transferRequiredWarning,targetContainerModel,requiredAliquotVolume,positiveIonModeQ,resolvedAliquotVolume,
				(*New conflict option resolver*)
				invalidVoltagesOptionList,invalidVoltagesOptionBoolean,invalidGasOptionList,invalidGasOptionBoolean,invalidMassRangeBoolean,outRangedDesolvationTemperatureBoolean,
				massInCalibrantRangeBool,validCalibrantQ,eachInjectedAmount
			},

				(* get user-supplied ESI mass spec options *)
				{suppliedInjectionVolume,suppliedIonMode,suppliedCalibrant,suppliedMassRange,suppliedInfusionFlowRate,suppliedCapillaryVoltage,suppliedSourceTemperature,suppliedDesolvationTemperature,suppliedDesolvationGasFlow,suppliedConeGasFlow,suppliedStepwaveVoltage}
				=Lookup[
					options,
					{InjectionVolume,IonMode,Calibrant,MassDetection,InfusionFlowRate,ESICapillaryVoltage,SourceTemperature,DesolvationTemperature,DesolvationGasFlow,ConeGasFlow,StepwaveVoltage}
				];

				(* -- Resolve ion mode -- *)
				pHValue=Lookup[simulatedSamplePacket,pH];
				pKaValue=If[!MatchQ[filteredAnalytes,{}|{Null..}],
					Mean[Cases[Lookup[filteredAnalytes,pKa],_?NumericQ]],
					Null];
				acid=If[!MatchQ[filteredAnalytes,{}|{Null..}],
					Or@@(Lookup[filteredAnalytes,Acid]/.{Null|$Failed->False}),
				Null];
				base=If[!MatchQ[filteredAnalytes,{}|{Null..}],
					Or@@(Lookup[filteredAnalytes,Base]/.{Null|$Failed->False}),
					Null];

				ionMode=Which[
					MatchQ[suppliedIonMode,IonModeP],suppliedIonMode,

					(* - Resolve automatic - *)
					(* Sample type based resolution *)
					MatchQ[sampleCategory,Peptide|DNA], Positive,

					(* Acid/Based flag based resolution *)

					(* Bases are compounds that are protonated in solution, so they form positive ions -> Positive *)
					(* Acids are compounds that loose their proton in solution, so they form negative ions -> Negative *)
					TrueQ[acid],Negative,
					TrueQ[base],Positive,

					(* pKa-based resolution *)
					(* high pKa tend to bind protons, gaining a positive charge in the process -> Positive *)
					(* low pKA tend to loose a proton -> Negative *)
					NumericQ[pKaValue]&&pKaValue<8,Negative,
					NumericQ[pKaValue]&&pKaValue>=8,Positive,

					(* pH-based resolution *)
					(* pH is the property of the solution, so with low pH, a lot of protons are available, so most likely we are doing Positive *)
					NumericQ[pHValue]&&pHValue<5,Positive,
					NumericQ[pHValue]&&pHValue>=5,Negative,

					(* Default to positive, since this generally works *)
					True,Positive
				];

				(*Build a checker boolean for ionMode*)
				positiveIonModeQ=MatchQ[ionMode,Positive];

				(* Do check if user supplied a calibrant and MWs is known to see if the MW is in range*)
				{massInCalibrantRangeBool,validCalibrantQ}=If[
					MatchQ[molecularWeights,{MolecularWeightP..}]&&MatchQ[suppliedCalibrant,ObjectP[]],
					Module[{internalCalibrantPacket,referencePeaks,eachMassInRangeQ,eachValidCalibrantQ},

						(* Get model packet of the calibrant *)
						internalCalibrantPacket=If[MatchQ[suppliedCalibrant,ObjectP[Object[Sample]]],
							fetchPacketFromCache[Lookup[fetchPacketFromCache[suppliedCalibrant,simulatedCache],Model],simulatedCache],
							fetchPacketFromCache[suppliedCalibrant,simulatedCache]
						];
						(* Lookup calibrant peaks *)
						referencePeaks=If[MatchQ[ionMode,Positive],Lookup[internalCalibrantPacket,ReferencePeaksPositiveMode],Lookup[internalCalibrantPacket,ReferencePeaksNegativeMode]];
						(* Check that all molecular weights are within the min and max of the peaks *)
						eachMassInRangeQ=If[Length[referencePeaks]==0,
							False,
							And@@((RangeQ[#,{Min[referencePeaks],Max[referencePeaks]}]&)/@molecularWeights)
						];
						eachValidCalibrantQ=MemberQ[Lookup[relevantCalibrantModelPackets,Object],Lookup[internalCalibrantPacket,Object]];
						{eachMassInRangeQ,eachValidCalibrantQ}
					],
					{True,True}
				];


				(* -- Resolve calibrant -- *)
				calibrant=Switch[{suppliedCalibrant,sampleCategory,Mean[molecularWeights],ionMode},
					{ObjectP[],_,_,_},suppliedCalibrant,
					(* for Peptides, we always use Sodium Iodide *)
					{_,Peptide,_,_},Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"],
					(* for big stuff, we use cesium iodide if it's Positive and sodium iodide if Negative *)
					{_,Protein,_,Positive},Model[Sample,StockSolution,Standard,"Cesium Iodide ESI Calibrant"],
					{_,Protein,_,Negative},Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"],
					{_,_,GreaterP[2000 Dalton],Positive},Model[Sample,StockSolution,Standard,"Cesium Iodide ESI Calibrant"],
					{_,_,GreaterP[2000 Dalton],Negative},Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"],
					(* for small molecules, we always use Sodium Formate *)
					{_,_,LessEqualP[1200 Dalton],_},Model[Sample,StockSolution,Standard,"Sodium Formate ESI Calibrant"],
					(* catch all for medium sized molecules etc is sodium iodide *)
					_,Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"]
				];

				(* define our default mass ranges *)
				lowRange=Span[100 Dalton, 1200 Dalton];
				midRange=Span[350 Dalton, 2000 Dalton];
				highRange=Span[400 Dalton, 5000 Dalton];

				(* -- Resolve MassRange -- *)
				massRange=Switch[{suppliedMassRange,sampleCategory,Mean[molecularWeights]},
					{Except[Automatic],_,_},suppliedMassRange,
					(* peptides get the mid range *)
					{_,Peptide,_},midRange,
					(* for big stuff, we use protein range *)
					{_,Protein,_},highRange,
					{_,_,RangeP[2000 Dalton,5000 Dalton]},highRange,
					(* for stuff that's bigger than our default range, we go as high as 100 Da above the MolWeight *)
					{_,_,GreaterP[5000 Dalton]},Span[2000 Dalton,Round[Max[molecularWeights]+100 Dalton,1 Dalton]],
					(* for small molecules, we use low range *)
					{_,_,LessEqualP[1200 Dalton]},lowRange,
					(* catch all for medium sized molecules is the mid range *)
					_,midRange
				];

				(* Get the packet associated with the resolved calibrant *)
				calibrantPacket=If[validCalibrantQ,findModelPacketFunction[calibrant,calibrantSamplePackets,relevantCalibrantModelPackets],{}];

				(* figure out whether the calibrant peaks cover the requested mass range*)
				(* we don't bother if we've already thrown a calibrant error,or we have checked that the calibrant is not valid for this experiment, or we have resolved both mass range and the calibrant for the user *)
				calibrantMassRangeMismatch=If[(ionSourceCalibrantMismatchBool||!maxMassSupportedBool||(MatchQ[suppliedMassRange,Automatic]&&MatchQ[suppliedCalibrant,Automatic])||(!validCalibrantQ)),
					False,
					(* Otherwise we do the following checks *)
					Switch[{massRange,calibrant},
						(* These are valid combinations *)
						{midRange,Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"]},False,
						{highRange,Model[Sample,StockSolution,Standard,"Cesium Iodide ESI Calibrant"]},False,
						{lowRange,Model[Sample,StockSolution,Standard,"Sodium Formate ESI Calibrant"]},False,
						(* If we get here, either mass range or calibrant were user specified (or both) *)
						(* In this case we need to check whether the mass range is suitable (we allow the mass range to be 25% above or below the highest and lowest mass of the calibrant *)
						_,
						Module[{calibrantMasses,minCalibrant,maxCalibrant,minMass,maxMass,edgeBuffer,lowerEdge,higherEdge},
							calibrantMasses=If[
								validCalibrantQ,
								If[positiveIonModeQ,Lookup[calibrantPacket,ReferencePeaksPositiveMode],Lookup[calibrantPacket,ReferencePeaksNegativeMode]],
								{}
							];

							{minCalibrant,maxCalibrant}={Min[calibrantMasses],Max[calibrantMasses]};
							{minMass,maxMass}=If[MatchQ[massRange,_Span],List@@massRange,{{},{}}];

							(* calculate the lower and the higher end of a mass range that we would still be OK with *)
							edgeBuffer=25 Percent;
							lowerEdge=minCalibrant-UnitScale[edgeBuffer*minCalibrant];
							higherEdge=maxCalibrant+UnitScale[edgeBuffer*maxCalibrant];

							(*First check if calibrant mass packet is empty, if so, return False and throw warning*)
							If[
								MatchQ[calibrantMasses,{}],
								True,
								(*Else check the min mass or max mass by mass edge*)
								If[
									minMass<lowerEdge||maxMass>higherEdge,
									True,
									False
								]
							]
						]
					]
				];
				(* -- Resolve the flow rate dependent ESI options -- *)
				(* for the low flow, we differentiate between Positive and Negative for the capillary voltage, for all other options we just look at the flow rate *)
				{capillaryVoltage,sourceTemperature,desolvationTemperature,desolvationGasFlow}=Switch[infusionFlowRate,
					RangeP[0*Milliliter/Minute,0.02*Milliliter/Minute],{If[MatchQ[ionMode,Positive],3*Kilovolt,2.8*Kilovolt],100*Celsius,200*Celsius,600*Liter/Hour},
					RangeP[0.021*Milliliter/Minute,0.1*Milliliter/Minute],{2.5*Kilovolt,120*Celsius,350*Celsius,800*Liter/Hour},
					RangeP[0.101*Milliliter/Minute,0.3*Milliliter/Minute],{2*Kilovolt,120*Celsius,450*Celsius,800*Liter/Hour},
					RangeP[0.301*Milliliter/Minute,0.5*Milliliter/Minute],{1.5*Kilovolt,150*Celsius,500*Celsius,1000*Liter/Hour},
					GreaterP[0.5*Milliliter/Minute],{1*Kilovolt,150*Celsius,600*Celsius,1200*Liter/Hour}
				];

				(* If the user supplied any of these values, we use these, otherwise we go with our resolution *)
				{resolvedCapillaryVoltage,resolvedSourceTemperature,resolvedDesolvationTemperature,resolvedDesolvationGasFlow}=MapThread[
					resolveAutomaticOption[#1,options,#2]&,
					{
						{ESICapillaryVoltage,SourceTemperature,DesolvationTemperature,DesolvationGasFlow},
						{capillaryVoltage,sourceTemperature,desolvationTemperature,desolvationGasFlow}
					}
				];

				(* -- Resolve StepwaveVoltage -- *)
				stepwaveVoltage=Switch[{suppliedStepwaveVoltage,sampleCategory,Mean[molecularWeights]},
					{Except[Automatic],_,_}, suppliedStepwaveVoltage,
					{_,DNA,_},100 Volt,
					{_,Protein,_},120 Volt,
					{_,_,GreaterP[2000*Dalton]},120 Volt,
					_,40 Volt
				];

				(*Check if all voltage input (ESICapillaryVoltage and StepwaveVoltage) should be higher than 0*)
				invalidVoltagesOptionList=Module[
					{
						relaventOptionNotListedValues,relaventOptionNotListedNames,voltageOptionNotListedBooleans
					},

					(*Collect voltages input values and names that are not listed*)
					relaventOptionNotListedValues={
						(*1*)suppliedCapillaryVoltage,
						(*2*)suppliedStepwaveVoltage

					};
					relaventOptionNotListedNames={
						(*1*)ESICapillaryVoltage,
						(*2*)StepwaveVoltage

					};

					(*For those nolisted options check if they are smaller than 0 Volt and pick those mismatched options out.*)
					voltageOptionNotListedBooleans= MatchQ[#,LessP[0*Volt]]&/@ relaventOptionNotListedValues;

					PickList[relaventOptionNotListedNames,voltageOptionNotListedBooleans]
				];
				(*Throw a error checker*)
				invalidVoltagesOptionBoolean=(Length[invalidVoltagesOptionList]>0);

				(*Check if all Gas input (ESICapillaryVoltage and StepwaveVoltage) should have a unit of flow rate 0*)
				invalidGasOptionList=Module[
					{
						relaventOptionNotListedValues,relaventOptionNotListedNames,voltageOptionNotListedBooleans
					},

					(*Collect voltages input values and names that are not listed*)
					relaventOptionNotListedValues={
						(*1*)suppliedDesolvationGasFlow,
						(*2*)suppliedConeGasFlow

					};
					relaventOptionNotListedNames={
						(*1*)DesolvationGasFlow,
						(*2*)ConeGasFlow

					};

					(*For those nolisted options check if they are in a unit of pressure.*)
					voltageOptionNotListedBooleans= MatchQ[#,UnitsP[PSI]]&/@ relaventOptionNotListedValues;

					PickList[relaventOptionNotListedNames,voltageOptionNotListedBooleans]
				];
				(*Throw a error checker*)
				invalidGasOptionBoolean=(Length[invalidGasOptionList]>0);

				(*For now ESI-QTOF only accept a span as the mass input, we check it here and return a error checker if it's not*)
				invalidMassRangeBoolean=!(MatchQ[massRange,_Span]);

				(*For now ESI-QTOF only accept DesolvationTemperature< 650 Celsiu, we need to check it here*)
				outRangedDesolvationTemperatureBoolean=!(MatchQ[resolvedDesolvationTemperature,RangeP[0*Celsius,650*Celsius]]);

				(* Resolve the only index-matched option that is specific to flow-injection, based on:
						- Input option value
						- injection type
						- aliquot volume minus dead volume of autosampler
						- default 10ul *)

				(* First Estimate how much sample we need to inject into the instrument*)
				(* 0.2 Milliliter was determined from the Procedure where it says FillVolume to 200 Microliter*)
				eachInjectedAmount=(eachInfusionFlowRate*(eachRunDuration+eachScanTime))+0.2Milliliter;

				(*Resolve an aliquotAmount if user specified the aliquot option but didn't specified aliquot amount*)
				resolvedAliquotVolume= If[
					MatchQ[aliquotAmount,Except[Automatic]],
					aliquotAmount,
					If[flowInjectionQ, 30 Microliter,eachInjectedAmount]
				];

				(* Resolve injection volume*)
				injectionVolume=Which[
					MatchQ[suppliedInjectionVolume,VolumeP],suppliedInjectionVolume,
					MatchQ[injectionType,DirectInfusion], Null,
					(* - Resolve automatic - *)
					TrueQ[aliquotBool],
						Min[resolvedAliquotVolume - autosamplerDeadVolume,maxInjectionVolume - autosamplerDeadVolume],
					True,
					If[MatchQ[Lookup[simulatedSamplePacket,Volume],VolumeP],
						Min[Lookup[simulatedSamplePacket,Volume], 10 Microliter],
						10 Microliter
					]
				];

				(* return the single resolved values for this sample we're mapping over *)
				{
					(*1*)ionMode,
					(*2*)calibrant,
					(*3*)massRange,
					(*4*)resolvedCapillaryVoltage,
					(*5*)resolvedSourceTemperature,
					(*6*)resolvedDesolvationTemperature,
					(*7*)resolvedDesolvationGasFlow,
					(*8*)stepwaveVoltage,
					(*9*)injectionVolume,
					(*10*)calibrantMassRangeMismatch,
					(*11*)transferRequiredWarning,
					(*12*)invalidVoltagesOptionList,
					(*13*)invalidVoltagesOptionBoolean,
					(*14*)invalidGasOptionList,
					(*15*)invalidGasOptionBoolean,
					(*16*)invalidMassRangeBoolean,
					(*17*)outRangedDesolvationTemperatureBoolean,
					(*18*)resolvedAliquotVolume,
					(*19*)massInCalibrantRangeBool,
					(*20*)validCalibrantQ,
					(*21*)eachInjectedAmount
				}
			]
		],
			{
				(*1*)simulatedSamplePackets,
				(*2*)simulatedSampleIdentityModelPackets,
				(*3*)mySimulatedSamples,
				(*4*)simulatedSampleContainerModels,
				(*5*)mapThreadFriendlyOptions,
				(*6*)suppliedAliquotContainers,
				(*7*)unresolvedAliquotContainerModels,
				(*8*)sampleCategories,
				(*9*)sampleMolecularWeights,
				(*10*)impliedAliquotBools,
				(*11*)suppliedAliquotVolumes,
				(*12*)infusionFlowRates,
				(*13*)scanTimes,
				(*14*)runDurations,
				(*15*)simulatedVolumes,
				(*16*)ionSourceCalibrantMismatchBooleans,
				(*17*)maxMassSupportedBools,
				(*18*)myFilteredAnalytePackets,
				(*19*)infusionFlowRates,
				(*20*)scanTimes,
				(*21*)runDurations
			}
		]
	];

	(* -- UNRESOLVABLE OPTION CHECKS -- *)
	(* -- check for calibrantMassRangeMismatches -- *)

	(* Check for calibrantMassRangeMismatches and throw the corresponding Warning if we're throwing messages *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	If[Or@@calibrantMassRangeMismatches && messages && outsideEngine,
		Message[Warning::CalibrantMassDetectionMismatch,
			ObjectToString[PickList[mySimulatedSamples,calibrantMassRangeMismatches],Cache->simulatedCache],
			ObjectToString[PickList[massRanges,calibrantMassRangeMismatches],Cache->simulatedCache],
			ObjectToString[PickList[calibrants,calibrantMassRangeMismatches],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	calibrantMassRangeMismatchTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,PickList[simulatedSamplePackets,calibrantMassRangeMismatches],"For samples `1`, the acquisition mass range is covered by the calibrant's mass range:",simulatedCache];

	(* -- Too many samples -- *)

	(*declare a threshold depending on the type of injection we're doing *)
	measurementLimit=If[MatchQ[injectionType,DirectInfusion],20,2*96];

	(*get the number of replicates and convert a Null to 1*)
	numberOfReplicatesNumber=Lookup[mySuppliedExperimentOptions,NumberOfReplicates]/. {Null -> 1};

	(*calculate the total number of measurements needed*)
	numberOfMeasurements=Length[mySimulatedSamples]*numberOfReplicatesNumber;
	tooManySamplesQ=numberOfMeasurements>measurementLimit;

	(*get all of the excess inputs*)
	tooManyMeasurementsInputs=If[tooManySamplesQ,Drop[Flatten[Table[Lookup[simulatedSamplePackets,Object],numberOfReplicatesNumber]],measurementLimit],{}];

	If[tooManySamplesQ&&!gatherTests,
		Message[Error::TooManyESISamples,ToString[numberOfMeasurements],ToString[measurementLimit]]
	];

	tooManySamplesTest=If[gatherTests,
		Test["The number of input samples (including any replicates) are within the measurement limit of this protocol:",tooManySamplesQ,False]
	];

	(* -- New conflic option checker, after ESI-QQQ was added to ExperimentMassSpectrometry*)
	(*outRangedDesolvationTemperatureBooleans*)

	(* Check for invalidVoltagesOptionBooleans and throw the corresponding Warning if we're throwing messages *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	If[Or@@invalidVoltagesOptionBooleans && messages && outsideEngine,
		Message[Error::InvalidESIQTOFVoltagesOption,
			ObjectToString[PickList[mySimulatedSamples,invalidVoltagesOptionBooleans],Cache->simulatedCache],
			ObjectToString[PickList[invalidVoltagesOptionLists,invalidVoltagesOptionBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidESIQTOFVoltagesOptionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidVoltagesOptionBooleans],"For samples `1` in ESI-QTOF, all the voltages input are positive:",simulatedCache];
	invalidESIQTOFVoltagesOptions=DeleteDuplicates[Flatten[invalidVoltagesOptionLists]];


	(* Check for invalidGasOptionBooleans and throw the corresponding Warning if we're throwing messages *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	If[Or@@invalidGasOptionBooleans && messages && outsideEngine,
		Message[Error::InvalidESIQTOFGasOption,
			ObjectToString[PickList[mySimulatedSamples,invalidGasOptionBooleans],Cache->simulatedCache],
			ObjectToString[PickList[invalidGasOptionLists,invalidGasOptionBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidESIQTOFGasOptionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidGasOptionBooleans],"For samples `1` in ESI-QTOF, all gas option inputs should have a unit of flowrage (mL/Min):",simulatedCache];
	invalidESIQTOFGasOptions=DeleteDuplicates[Flatten[invalidGasOptionLists]];

	(* Check for invalidMassRangeBooleans and throw the corresponding Warning if we're throwing messages *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	If[Or@@invalidMassRangeBooleans && messages && outsideEngine,
		Message[Error::InvalidESIQTOFMassDetectionOption,
			ObjectToString[PickList[mySimulatedSamples,invalidMassRangeBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidESIQTOFMassDetectionOptionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidMassRangeBooleans],"For samples `1` in ESI-QTOF, the MassDetection input should be a mass range (a span):",simulatedCache];
	invalidESIQTOFMassDetectionOptions=If[Or@@invalidMassRangeBooleans,MassDetection];

	(* Check for outRangedDesolvationTemperatureBooleans and throw the corresponding Warning if we're throwing messages *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	If[Or@@outRangedDesolvationTemperatureBooleans && messages && outsideEngine,
		Message[Error::OutRangedDesolvationTemperature,
			ObjectToString[PickList[mySimulatedSamples,outRangedDesolvationTemperatureBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	outRangedDesolvationTemperatureTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,outRangedDesolvationTemperatureBooleans],"For samples `1` in ESI-QTOF, the MassDetection input should be a mass range (a span):",simulatedCache];
	outRangedDesolvationTemperatureOptions=If[Or@@outRangedDesolvationTemperatureBooleans,DesolvationTemperature];

	(* Get the sample for which the calibrant is invalid*)
	badCalibrantSamplePackets=PickList[simulatedSamplePackets,validCalibrantBools,False];

	(* Get samples out of calibrant peak range - if we already threw the compatible calibrant error above (wrong ion source and invalid calibrants) then we don't throw this warning here *)
	outOfCalibrantRangeSamplePackets=Complement[PickList[simulatedSamplePackets,massInCalibrantRangeBools,False],PickList[simulatedSamplePackets,ionSourceCalibrantMismatchBooleans,True],badCalibrantSamplePackets];
	outOfCalibrantRangeSamples=Lookup[outOfCalibrantRangeSamplePackets,Object,{}];

	(* Throw a message if the MW is not flanked *)
	If[!MatchQ[outOfCalibrantRangeSamplePackets,{}]&&messages&&outsideEngine,
		Message[Warning::IncompatibleCalibrant,ObjectToString[outOfCalibrantRangeSamplePackets,Cache->simulatedCache]]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	outOfRangeCalibrantTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,outOfCalibrantRangeSamplePackets,"The molecular weights of `1` are within the range formed by the reference peaks in the calibrant:",simulatedCache];

	(* Check if user specified Calibrant is valid, if not we throw error message.*)
	If[!And@@validCalibrantBools && messages && outsideEngine,
		Message[Error::MassSpectrometryInvalidCalibrants,
			ObjectToString[PickList[mySimulatedSamples,validCalibrantBools,False],Cache->simulatedCache],
			ObjectToString[PickList[calibrants,validCalibrantBools,False],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidCalibrantTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,validCalibrantBools,False],"For samples `1` in, the specified Calibrant is not valid:",simulatedCache];
	invalidCalibrantOptions=If[!And@@validCalibrantBools,Calibrant];

	(* Set a boolean if the specified scan time is invalid *)
	(* 10 seconds was originally the upper bound for the ScanTime option for both QTOF and QQQ, but QQQ actually allows
	scan times of up to 195 seconds, so the upper bound of the option was changed to 195 and this check was added for the QTOF *)
	invalidScanTimeBool = MemberQ[scanTimes, GreaterP[10 Second]];

	(* Check if user specified scan times are valid, if not we throw an error message.*)
	If[invalidScanTimeBool && messages,
		Message[Error::InvalidESIQTOFScanTimeOption, scanTimes]
	];

	(* Create a test for invalid scan times *)
	invalidScanTimeTest=If[gatherTests,
		Test["The specified ScanTime option values are all less than 10 seconds.",invalidScanTimeBool,False]
	];
	invalidScanTimeOptions=If[invalidScanTimeBool,ScanTime];

	(* -- RESOLVE ALIQUOT OPTIONS -- *)

	(* -- Resolve TransferContainer (RequiredAliquotContainer) and RequiredAliquotVolume -- *)

	(* we handle the two injection types separately - FlowInjection pretty much copies what Waters HPLC and SFC do *)
	{requiredAliquotAmounts,requiredTargetContainer}=If[MatchQ[injectionType,DirectInfusion],

		(* DIRECT INFUSION CASE *)
		(* Note: Given duplicate input, or number of replicates > 1, we either from the sample multiple times (if in a container that is compatible)
				or we consolidate the volume for all requested injections into one target container from which the sample is then drawn multiple times *)
		Module[{numReplicates,numReplicatesNoNull,injectedAmountAccountedForReplicates,groupedBySample,sampleCount,
			uniqueInjectedVolumes,uniqueTargetContainers,targetContainerDeadVolume,uniqueSamples,groupedAliquotBools,
			sampleTargetContainerRules,targetContainersResolved,targetContainers,totalVolumesNeeded,groupedAliquotVolumes,
			injectedVolumesPerSample,sampleVolumeRules,requiredAliquotVolumes,volumesToChooseContainer,numberOfEachSample,
			numberOfAliquotsForEachSample},

			(* set the invalid aliquot container flags to {} and tests to Null since these are specific to the flow injection case *)
			invalidAliquotContainerOptions={};
			invalidContainerCountInputs={};
			validAliquotContainerTest=Null;
			containerCountTest=Null;

			(* get the number of replicates so that we calculate the required volume for each sample *)
			(* if NumberOfReplicates -> Null, replace that with 1 for the purposes of the math below *)
			numReplicates=Lookup[massSpecOptions,NumberOfReplicates];
			numReplicatesNoNull =numReplicates /. {Null -> 1};

			(* calculate, indexmatched to SamplesIn, how much volume will be injected, accounting for NumberOfReplicates *)
			injectedAmountAccountedForReplicates=injectedAmounts*numReplicatesNoNull;

			(* we may be dealing with replicate input, so we group by the sample *)
			groupedBySample=GatherBy[Transpose[{mySimulatedSamples,injectedAmountAccountedForReplicates,impliedAliquotBools,resolvedAliquotVolumes}],First];

			(* Calculate how many times each sample is injected. We need this to split the total volume between each sample, so that we can pass resolveAliquotOptions the correct fraction for each sample *)
			sampleCount=Length/@groupedBySample[[All,All,1]]*numReplicatesNoNull;

			(* Generate how many containers we need to aliquot to for each sample*)
			numberOfAliquotsForEachSample=Length/@groupedBySample;

			(* calculate the total volume injected from each sample, then divided by number of aliquot containers we want to aliquot those samples to *)
			uniqueInjectedVolumes=(Total/@groupedBySample[[All,All,2]])/numberOfAliquotsForEachSample;

			(* For Aliquoted sample, gather all aliquotBoolean and aliquot sample tother for us to choose container to use.*)
			groupedAliquotBools=First[DeleteDuplicates[#]]&/@groupedBySample[[All,All,3]];
			groupedAliquotVolumes=Total/@groupedBySample[[All,All,4]];


			(* Resolved the volumes  to choose which container we gonna use, if user specified resolved aliquot amount, we should use user specified aliquot option to choose containers*)
			volumesToChooseContainer=MapThread[
				Function[{eachAliquotBool,eachUniqueInjectionVolume,eachResolvedAliquotVolume},
					If[
						TrueQ[eachAliquotBool],
						Max[eachUniqueInjectionVolume,eachResolvedAliquotVolume],
						eachUniqueInjectionVolume
					]
				],
				{groupedAliquotBools,uniqueInjectedVolumes,groupedAliquotVolumes}
			];

			(* from the total volume injected from each sample, we can determine the container we will transfer the sample into, plus the dead volume that needs to be accounted for for this container *)
			{uniqueTargetContainers,targetContainerDeadVolume}=Transpose[
				Map[
					Function[{volume},
					(* select the smallest container into which the volume plus the deadvolume of that container fits *)
						SelectFirst[esiContainerTuples,
							#[[2]] <= (volume+#[[2]]) <= #[[3]]&
						][[1;;2]]
					],
					volumesToChooseContainer
				]
			];

			(* extract the list of unique samples *)
			uniqueSamples=First/@groupedBySample[[All,All,1]];

			(* construct rules sample->targetContainer so that we can get this indexmatched to samplesIn *)
			sampleTargetContainerRules=MapThread[
				(#1->#2)&,
				{uniqueSamples,uniqueTargetContainers}];

			(* use the replace rules to get targetContainer indexmatched to SamplesIn *)
			targetContainersResolved=mySimulatedSamples/.sampleTargetContainerRules;

			(* we resolved target container ignoring any user input *)
			(* if user input is reasonable, in these cases we do NOT transfer *)
			targetContainers=MapThread[Function[
				{
					(*1*)targetContainer,
					(*2*)aliquotContainerModel,
					(*3*)aliquotContainer,
					(*4*)containerModel,
					(*5*)impliedAliquot
				},
				Switch[{
					(*1*)impliedAliquot,
					(*2*)aliquotContainerModel,
					(*3*)aliquotContainer,
					(*4*)containerModel
				},
				(* if no aliquot container was specified by the user, and no other aliquot options were specified, and the container is compatible, we do NOT transfer *)
				(* this is the case when the sample is for instance in the 30mL reservoir, and targetContainer resolves to the HPLC vial because the volume needed is small. *)
					{Automatic|False,_,Automatic,allowedESIContainersP}, Null,
				(* if an aliquot container MODEL  was specified by the user that is compatible, we use that and ignore whatever we would have resolved to *)
					{Automatic|True,allowedESIContainersP,ObjectP[Model[Container,Vessel]],_}, aliquotContainer,
				(* if an aliquot container OBJECT was specified by the user whose model is compatible, we set target container to Null because RequiredAliquotContainer doesn't accept objects *)
					{Automatic|True,allowedESIContainersP,ObjectP[Object[Container,Vessel]],_}, Null,
				(* in all other cases we use our container we resolved to *)
					_,targetContainer
				]],
				{
					(*1*)targetContainersResolved,
					(*2*)unresolvedAliquotContainerModels,
					(*3*)suppliedAliquotContainers,
					(*4*)simulatedSampleContainerModels,
					(*5*)impliedAliquotBools
				}
			];

			(* the total volume that is needed in the target container needs to account for all injected samples plus the deadvolume of that container *)
			(*totalVolumesNeeded=uniqueInjectedVolumes+targetContainerDeadVolume;*)
			(* calculate that volume needed from each SamplesIn *)
			injectedVolumesPerSample=Round[(uniqueInjectedVolumes+targetContainerDeadVolume),0.1];

			(* construct rules so that we can get the aliquot volumes indexmatched to SamplesIn *)
			sampleVolumeRules=MapThread[
				(#1->#2)&,
				{uniqueSamples,injectedVolumesPerSample}
			];

			(* use the replace rules to get the aliquotVolume indexmatched to SamplesIn *)
			requiredAliquotVolumes=(mySimulatedSamples/.sampleVolumeRules);

			(* Return the aliquot containers and the volumes *)
			{requiredAliquotVolumes,targetContainers}

		],

		(* FlowInjection case - we pretty much copy what HPLC does to figure out the aliquot containers *)
		Module[{preResolvedAliquotOptions,compatibleContainers,namedCompatibleContainers,specifiedAliquotBools,
			incompatibleContainerModelBools,uniqueAliquotableSamples,uniqueNonAliquotablePlates,uniqueNonAliquotableVessels,
			validContainerCountQ,preresolvedAliquotBools,validAliquotContainerBools,
			validAliquotContainerOptions,aliquotOptionSpecifiedBools,resolvedAliquotContainers,

			targetContainers,requiredAliquotVolumes},

			(* Extract shared options relevant for aliquotting *)
			preResolvedAliquotOptions = KeySelect[samplePrepOptions,And[MatchQ[#,Alternatives@@ToExpression[Options[AliquotOptions][[All,1]]]],MemberQ[Keys[samplePrepOptions],#]]&];

			(* The containers that wil fit on the instrument's autosampler *)
			{compatibleContainers,namedCompatibleContainers} = {
				{Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Vessel, "id:jLq9jXvxr6OZ"], Model[Container, Vessel, "id:GmzlKjznOxmE"], Model[Container, Vessel, "id:3em6ZvL8x4p8"], Model[Container, Vessel, "id:aXRlGnRE6A8m"], Model[Container, Vessel, "id:qdkmxz0A884Y"], Model[Container, Vessel, "id:o1k9jAoPw5RN"]},
				{Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Vessel, "HPLC vial (high recovery)"], Model[Container, Vessel, "Amber HPLC vial (high recovery)"], Model[Container, Vessel, "HPLC vial (high recovery), LCMS Certified"],Model[Container, Vessel, "HPLC vial (high recovery) - Deactivated Clear Glass"],Model[Container, Vessel, "Polypropylene HPLC vial (high recovery)"],Model[Container, Vessel, "PFAS Testing Vials, Agilent"]}
			};

			(* Extract list of bools *)
			specifiedAliquotBools = Lookup[preResolvedAliquotOptions,Aliquot];

			(* If the sample's container model is not compatible with the instrument, we may have to aliquot *)
			incompatibleContainerModelBools = Map[
				!MatchQ[#,Alternatives@@compatibleContainers|Alternatives@@namedCompatibleContainers]&,
				simulatedSampleContainerModels
			];

			(* Extract all samples that could be aliquoted *)
			(* NOTE: this doesn't consider samples that are aliquotted and NOT consolidated. Therefore the number could be higher! *)
			uniqueAliquotableSamples = DeleteDuplicates@PickList[mySimulatedSamples,specifiedAliquotBools,True|Automatic];

			(* Find plates and containers that definitely cannot be aliquoted because Aliquot was set to False *)
			uniqueNonAliquotablePlates = DeleteDuplicates@Cases[
				PickList[simulatedSampleContainers,specifiedAliquotBools,False],
				ObjectP[Object[Container,Plate]]
			];
			uniqueNonAliquotableVessels = DeleteDuplicates@Cases[
				PickList[simulatedSampleContainers,specifiedAliquotBools,False],
				ObjectP[Object[Container,Vessel]]
			];


			(* see if we are dealing with a list of valid vessels and/or plates that we can fit into the autosampler *)
			(* Waters autosampler has room for:
					- 96 vials, 0 plates
					- 48 vials, 1 plate
					- 0 vials, 2 plates
					(In HPLC one vial rack is reserved for standards & blanks) but here we don't have these so we can use both racks for a plate each *)
			validContainerCountQ = Or[
			(* If non-aliquotable samples and aliquotable samples exist, the non-aliquotable samples
			must be in at-most 1 plate and the aliquotable samples must be already- in or transferred to vials,
			therefore there must be <= (48 - non aliquotable vials) *)
				And[
					Length[uniqueNonAliquotablePlates] <= 1,
					Length[uniqueAliquotableSamples] <= (48 - Length[uniqueNonAliquotableVessels])
				],
			(* If non-aliquotable samples are all in vials, then the number of aliquottable samples must fit in 1 plate (=96 samples) *)
				And[
					Length[uniqueNonAliquotablePlates] == 0,
					Length[uniqueAliquotableSamples] <= 96
				],
				(* If we have 2 plates, then the number of non-aliquotable AND aliquottable samples must be 0. *)
				And[
					Length[uniqueNonAliquotablePlates] == 2,
					Length[uniqueAliquotableSamples] == 0,
					Length[uniqueNonAliquotableVessels] == 0
				]
			];

			(* Build test for container count validity *)
			containerCountTest = If[!validContainerCountQ,
				(
					If[messages,
						Message[Error::HPLCTooManySamples]
					];
					invalidContainerCountInputs = myNonSimulatedSamples;
					testOrNull["The number of sample and/or aliquot containers can fit on the instrument's autosampler:",False]
				),
				invalidContainerCountInputs = {};
				testOrNull["The number of sample and/or aliquot containers can fit on the instrument's autosampler:",True]
			];

			(*  if sample plate count >1, aliquot.
			We're already throwing an error if the container count is invalid so we know we can just blindly
			flip all Aliquot -> Automatic to True if Aliquot is needed to make the samples fit.

			If the container count is invalid, don't modify any values *)
			preresolvedAliquotBools = If[
				And[
					validContainerCountQ,
					Length[DeleteDuplicates[simulatedSampleContainers]] > 1
				],
				Replace[specifiedAliquotBools,Automatic->True,{1}],
				specifiedAliquotBools
			];

			(* Enforce that _if_ AliquotContainer is specified, they are compatible *)
			validAliquotContainerBools = MapThread[
				Function[{aliquotQ,aliquotContainer},
					Or[
					(* If Aliquot is not explicitly False, we don't need this check *)
						MatchQ[Lookup[preResolvedAliquotOptions,Aliquot],False],
						Or[
						(* If AliquotContainer is not specified, assume it is valid *)
							!MatchQ[aliquotContainer,ObjectP[]],
							MatchQ[Download[aliquotContainer,Object],(Alternatives@@compatibleContainers)]
						]
					]
				],
				{specifiedAliquotBools,Lookup[preResolvedAliquotOptions,AliquotContainer]}
			];

			invalidAliquotContainerOptions=If[!(And@@validAliquotContainerBools),{AliquotContainer},{}];

			(* Build test for aliquot container specification validity *)
			validAliquotContainerTest = If[!(And@@validAliquotContainerBools),
				(
					If[messages,
						Message[Error::MassSpectrometryIncompatibleAliquotContainer,ObjectToString/@namedCompatibleContainers]
					];
					testOrNull["If AliquotContainer is specified, it is compatible with an HPLC autosampler:",False]
				),
				testOrNull["If AliquotContainer is specified, it is compatible with an HPLC autosampler:",True]
			];

			(* Build list of booleans representing if an aliquot option is specified explicitly *)
			aliquotOptionSpecifiedBools = Map[
				MemberQ[Values[preResolvedAliquotOptions],Except[Automatic|Null|{Automatic..}|{Null..}]]&,
				Transpose[Values[KeyDrop[preResolvedAliquotOptions,{ConsolidateAliquots,AliquotPreparation}]]]
			];

			(* we set the target container for all samples that aren't compatible  *)
			(* we let the Aliquot resolver below throw an error if Aliquot was specifically set to False *)
			resolvedAliquotContainers = Map[
				If[TrueQ[#],
					Model[Container,Plate,"96-well 2mL Deep Well Plate"],
					Null
				]&,
				incompatibleContainerModelBools
			];

			(* calculate the required aliquot volume *)
			(* If we end up aliquoting and AliquotAmount is not specified, it is possible we need to force
			AliquotVolume to be the appropriate InjectionVolume. *)
			requiredAliquotVolumes = MapThread[
				Function[
					{samplePacket,injectionVolume},
					Which[
						MatchQ[injectionVolume,VolumeP],
					(* Distribute autosampler dead volume across all instances of an identical aliquots *)
						(injectionVolume + (autosamplerDeadVolume/Count[Download[mySimulatedSamples,Object],Lookup[samplePacket,Object]])),
						True,25 Microliter
					]
				],
				{
					simulatedSamplePackets,
					injectionVolumes
				}
			];

			(* Return the aliquot containers and the volumes *)
			{requiredAliquotVolumes,resolvedAliquotContainers}
		]
	];

	(* If we're aliquoting and user hasn't supplied ConsolidateAliquots, set to True *)
	(* Since for each repeated sample we're going to inject a small volume from the bottle into the mass spec, no need for them to be in separate containers *)
	suppliedConsolidation=Lookup[samplePrepOptions,ConsolidateAliquots];
	resolvedConsolidation=If[MatchQ[suppliedConsolidation,Automatic]&&MemberQ[impliedAliquotBools,True],
		True,
		suppliedConsolidation
	];

	(* Prepare options to send to resolveAliquotOptions --> Pass the ConsolidateAliquots inside the aliquot options *)
	aliquotOptions=ReplaceRule[
		mySuppliedExperimentOptions,
		Join[{ConsolidateAliquots->resolvedConsolidation},myResolvedSamplePrepOptions]
	];

	(* Somehow TransferDevices in would fail to populate the cache. A lot of different methods were try to fix this. *)
	(* The final decision is to run TransferDevices[All, All] first to load the Memoization*)
	If[StringQ[$RequiredSearchName],
		Block[{$RequiredSearchName=Null},TransferDevices[All, All]]
	];

	requiredAliquotAmounts=Quiet[AchievableResolution /@ requiredAliquotAmounts];

	(* Resolve aliquot options for the ESI experiment *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentMassSpectrometry,
			myNonSimulatedSamples,
			mySimulatedSamples,
			aliquotOptions,
			RequiredAliquotContainers->requiredTargetContainer,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->If[MatchQ[injectionType,DirectInfusion],
				"because the given samples don't fit into the fluidics system of the mass spectrometer. If aliquotting is not desired, please move the samples to a suitable container prior to the experiment. Please refer to the documentation for a list of compatible containers.",
				"because the given samples are not in containers that are compatible with the autosampler affiliated with the mass spectrometry instrument."
			],
			Cache->simulatedCache,
			Simulation->Simulation[simulatedCache],
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentMassSpectrometry,
				myNonSimulatedSamples,
				mySimulatedSamples,
				aliquotOptions,
				RequiredAliquotContainers->requiredTargetContainer,
				RequiredAliquotAmounts->requiredAliquotAmounts,
				AliquotWarningMessage->If[MatchQ[injectionType,DirectInfusion],
					"because the given samples don't fit into the fluidics system of the mass spectrometer. If aliquotting is not desired, please move the samples to a suitable container prior to the experiment. Please refer to the documentation for a list of compatible containers.",
					"because the given samples are not in containers that are compatible with the autosampler affiliated with the mass spectrometry instrument."
				],
				Cache->simulatedCache,
				Simulation->Simulation[simulatedCache]
			],
			{}
		}
	];

	(*Collect a list to see if the sample needs to be aliquot*)
	aliquotQList=Lookup[resolvedAliquotOptions,Aliquot];

	(* After all option and aliquot option resolved we calculate the sample volume*)
	(* We calculate the sampele we need to calculate volumes for the direct infusion *)
	directInfusionSampleVolumes=(infusionFlowRates*(runDurations+scanTimes))+0.2Milliliter;

	(* Generate the dead volume for the sample container.*)
	simulatedSampleContainerMinVolumes=If[!NullQ[sampleDownload[[All,6]]],(Lookup[sampleDownload[[All,6]],MinVolume]/.Null->0Milliliter),ConstantArray[0 Milliliter, Length[simulatedSampleContainers]]];

	(* Generate a required volume list by adding the amount of sample we gonna injected in with the containers' dead volume (MinVolumes)*)
	requiredVolumes=(If[flowInjectionQ,injectionVolumes,directInfusionSampleVolumes]+simulatedSampleContainerMinVolumes);

	(* If aliquot option is false for the sample, check and throw warning if the sample does not have enough volume, if the sample does not have enough volume*)
	(* This will be check in resource picking or SM sub protocol, so we will only through a warning here.*)
	invalidNonAliquotSampleVolumesQ=MapThread[
		(*We won't check if the sample will be aliquot, this has been checked in the resolvedAliquot Options*)
		If[#1,False,Less[#2,#3]]&,
		{aliquotQList,(simulatedVolumes/.Null->0Milliliter), requiredVolumes}
	];

	(* Check for outRangedDesolvationTemperatureBooleans and throw the corresponding Warning if we're throwing messages *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	If[Or@@invalidNonAliquotSampleVolumesQ && messages && outsideEngine,
		Message[Error::MassSpectrometryNotEnoughVolume,
			ObjectToString[PickList[mySimulatedSamples,invalidNonAliquotSampleVolumesQ],Cache->simulatedCache],
			ObjectToString[PickList[simulatedVolumes,invalidNonAliquotSampleVolumesQ],Cache->simulatedCache],
			ObjectToString[PickList[requiredVolumes,invalidNonAliquotSampleVolumesQ],Cache->simulatedCache]
		]
	];

	(*Generate sample for the InvalidInputs options*)
	invalidNonAliquotSampleInputs=PickList[mySimulatedSamples,invalidNonAliquotSampleVolumesQ];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidNonAliquotSampleVolumeTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidNonAliquotSampleVolumesQ],"For samples `1` in ESI-QTOF, sample volumes is not enougth to finish the experiment:",simulatedCache];


	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[mySuppliedExperimentOptions];

	(* -- GATHER THE OUTPUT -- *)

	(* Gather our invalid input and invalid option variables. *)
	(* Note: We don't throw Error::InvalidInput or Error::InvalidOption - we pass this to the resolver together with the other option/input checks *)
	esiInvalidInputs=DeleteDuplicates[Flatten[{tooManyMeasurementsInputs,invalidContainerCountInputs,invalidNonAliquotSampleInputs}]];
	esiInvalidOptions=DeleteCases[Flatten[
		{
			badAliquotContainerOptions,
			invalidAliquotContainerOptions,
			invalidESIQTOFVoltagesOptions,
			invalidESIQTOFGasOptions,
			invalidESIQTOFMassDetectionOptions,
			outRangedDesolvationTemperatureOptions,
			invalidCalibrantOptions,
			invalidScanTimeOptions
		}
	],
		Null];

	(* Gather all the resolved options for ESI-QTOF *)
	esiResolvedOptions=ReplaceRule[
		Normal[roundedMassSpecOptions],
		Join[
			{
				(* shared options resolved in the big mapThread *)
				IonMode->ionModes,
				Calibrant->calibrants,
				MassDetection->massRanges,
				MassAnalyzer->resolveAutomaticOption[MassAnalyzer,roundedMassSpecOptions,QTOF],

				(* ESI specific options resolved above in the big mapThread *)
				ESICapillaryVoltage->capillaryVoltages,
				StepwaveVoltage->stepwaveVoltages,
				SourceTemperature->sourceTemperatures,
				DesolvationTemperature->desolvationTemperatures,
				DesolvationGasFlow->desolvationGasFlows,

				(* ESI options that are defaulted to a value (or user-supplied) if doing ESI *)
				InjectionType->injectionType,
				InfusionFlowRate->infusionFlowRates,
				ScanTime->scanTimes,
				RunDuration->runDurations,
				DeclusteringVoltage->resolveAutomaticOption[DeclusteringVoltage,roundedMassSpecOptions,40*Volt],
				ConeGasFlow->resolveAutomaticOption[ConeGasFlow,roundedMassSpecOptions,50*Liter/Hour],
				(* ESI options that are defaulted to a value (or user-supplied) if doing ESI AND FlowInjection *)
				SampleTemperature->flowInjectionSampleTemperature/. Ambient -> $AmbientTemperature,
				Buffer->flowInjectionBuffer,
				NeedleWashSolution->flowInjectionNeedleWashSolution,
				InjectionVolume->injectionVolumes,

				(*ESI-QQQ specific options are resolved to Null*)
				InfusionVolume->resolveAutomaticOption[InfusionVolume,roundedMassSpecOptions,Null],
				InfusionSyringe->resolveAutomaticOption[InfusionSyringe,roundedMassSpecOptions,Null],
				IonGuideVoltage->resolveAutomaticOption[IonGuideVoltage,roundedMassSpecOptions,Null],

				(*ESI-QQQ specific TandemMass Specific Options*)
				ScanMode->resolveAutomaticOption[ScanMode,roundedMassSpecOptions,Null],
				MassTolerance->resolveAutomaticOption[MassTolerance,roundedMassSpecOptions,Null],
				FragmentMassDetection->resolveAutomaticOption[FragmentMassDetection,roundedMassSpecOptions,Null],
				DwellTime->resolveAutomaticOption[DwellTime,roundedMassSpecOptions,Null],
				Fragment->resolveAutomaticOption[Fragment,roundedMassSpecOptions,Null],
				CollisionEnergy->resolveAutomaticOption[CollisionEnergy,roundedMassSpecOptions,Null],
				CollisionCellExitVoltage->resolveAutomaticOption[CollisionCellExitVoltage,roundedMassSpecOptions,Null],
				NeutralLoss->resolveAutomaticOption[NeutralLoss,roundedMassSpecOptions,Null],
				MultipleReactionMonitoringAssays->resolveAutomaticOption[MultipleReactionMonitoringAssays,roundedMassSpecOptions,Null],


				(* all MALDI options are resolved to Null or kept at what the user gave us. We've already thrown an error in the main resolver if they were not Null and will return $Failed in that case *)
							(* indexmatched MALDI options *)
				LaserPowerRange->resolveAutomaticOption[LaserPowerRange,roundedMassSpecOptions,Null],
				CalibrantLaserPowerRange->resolveAutomaticOption[CalibrantLaserPowerRange,roundedMassSpecOptions,Null],
				LensVoltage->resolveAutomaticOption[LensVoltage,roundedMassSpecOptions,Null],
				GridVoltage->resolveAutomaticOption[GridVoltage,roundedMassSpecOptions,Null],
				DelayTime->resolveAutomaticOption[DelayTime,roundedMassSpecOptions,Null],
				Matrix->resolveAutomaticOption[Matrix,roundedMassSpecOptions,Null],
				CalibrantMatrix->resolveAutomaticOption[CalibrantMatrix,roundedMassSpecOptions,Null],
				SpottingMethod->resolveAutomaticOption[SpottingMethod,roundedMassSpecOptions,Null],
				AccelerationVoltage->resolveAutomaticOption[AccelerationVoltage,roundedMassSpecOptions,Null],
				SampleVolume->resolveAutomaticOption[SampleVolume,roundedMassSpecOptions,Null],
				Gain->resolveAutomaticOption[Gain,roundedMassSpecOptions,Null],
				MatrixControlScans->resolveAutomaticOption[MatrixControlScans,roundedMassSpecOptions,Null],
				(* single MALDI options *)
				SpottingPattern->resolveAutomaticOption[SpottingPattern,roundedMassSpecOptions,Null],
				MALDIPlate->resolveAutomaticOption[MALDIPlate,roundedMassSpecOptions,Null],
				ShotsPerRaster->resolveAutomaticOption[ShotsPerRaster,roundedMassSpecOptions,Null],
				NumberOfShots->resolveAutomaticOption[NumberOfShots,roundedMassSpecOptions,Null],
				CalibrantNumberOfShots->resolveAutomaticOption[CalibrantNumberOfShots,roundedMassSpecOptions,Null],
				SpottingDryTime->resolveAutomaticOption[SpottingDryTime,roundedMassSpecOptions,Null],
				CalibrantVolume->resolveAutomaticOption[CalibrantVolume,roundedMassSpecOptions,Null]
			},
			resolvedAliquotOptions,
			myResolvedSamplePrepOptions,
			resolvedPostProcessingOptions
		]
	];

	(* Gather all the MALDI specific collected tests *)
	esiTests=Cases[Flatten[{
		noMolecularWeightTests,
		optionPrecisionTests,
		{tooManySamplesTest},
		calibrantMassRangeMismatchTests,
		aliquotTests,
		{containerCountTest}, (* these can be Null if we're not doing flow injection *)
		{validAliquotContainerTest}, (* these can be Null if we're not doing flow injection *)
		invalidESIQTOFVoltagesOptionTests,
		invalidESIQTOFGasOptionTests,
		invalidESIQTOFMassDetectionOptionTests,
		outRangedDesolvationTemperatureTests,
		invalidNonAliquotSampleVolumeTests,
		outOfRangeCalibrantTests,
		invalidCalibrantTests,
		invalidScanTimeTest
	}],_EmeraldTest];

	(* Return the resolved options, the tests, the invalid input, and the invalid options gathered for MALDI *)
	{esiResolvedOptions,esiTests,esiInvalidOptions,esiInvalidInputs}

];



(* ::Subsubsection:: *)
(*resolveESITripleQuadOptions*)


(* ========== resolveESITripleQuadOptions Helper function ========== *)
(* resolves MALDI specific options that are set to Automatic to a specific value and returns a list of resolved options, tests, and invalid input/option values to the main resolver *)
(* the inputs are the simulated samples, the download packet from the main resolver, the semi-resolved experiment options, and whether we're gathering tests or not *)


resolveESITripleQuadOptions[
	myNonSimulatedSamples:ListableP[ObjectP[Object[Sample]]],
	mySimulatedSamples:ListableP[ObjectP[Object[Sample]]],
	myESITripleQuadDownloadPackets_,
	myResolvedSamplePrepOptions_,
	mySuppliedExperimentOptions_,
	myFilteredAnalytePackets_, (* {{PacketP[IdentityModelTypes]..}..} - our filtered analytes (all of the same general type) for each of our simulated samples that we use internally to our function. *)
	myBooleans:{({BooleanP..}|BooleanP)..},
	mySimulatedCache_,
	updatedSimulation:_Simulation|Null
]:=Module[
	{
	gatherTests,discardedSamplesBools,nonLiquidSamplesBools,outOfMassRangeBools,massInCalibrantRangeBools,ionSourceCalibrantMismatchBooleans,maxMassSupportedBools,
	messages,outsideEngine,simulatedCache,samplePrepOptions,massSpecSpecificOptions,massSpecOptions,suppliedCalibrants,unroundedMassRanges,
	sampleDownload,suppliedCalibrantSampleDownload,suppliedCalibrantModelDownload,relevantCalibrantModelDownload,maldiPlatePacket,instrumentPacket,allInstrumentPackets,
	aliquotContainerPackets,simulatedSamplePackets,sampleModelPackets,simulatedSampleContainerModels,sampleAnalytePackets,calibrantSamplePackets,relevantCalibrantModelPackets,
	sampleCategories,simulatedSampleIdentityModelPackets,allInstrumentModelPackets,
	(* compatible syringe variables *)
	allSyringePackets,allowedSyringeModels,allowedSyringeModelsP, invalidInfusionSyringeBooleans,

	(* invalid options/input checking *)
	sampleMolecularWeights,noMolecularWeightSamplePackets,noMolecularWeightTests,measurementLimit,numberOfReplicatesNumber,
	numberOfMeasurements,tooManySamplesQ,tooManyMeasurementsInputs,tooManySamplesTest,roundedMassSpecOptions,optionPrecisionTests,
	suppliedAliquotContainers,unresolvedAliquotContainerModels,aliquotContainerConflicts,badAliquotContainerPackets,badALiquotContainers,
	badAliquotContainerOptions,badAliquotContainerTests,suppliedAliquots,suppliedAssayVolumes,suppliedAliquotVolumes,suppliedTargetConcentrations,
	suppliedAssayBuffers,impliedAliquotBools,simulatedVolumes,esiContainerTuples,simulatedSampleContainers,requiredAliquotAmounts,requiredTargetContainer,

	(* for mapThread resolver *)
	flowInjectionQ, infusionFlowRates,scanTimes,runDurations,flowInjectionSampleTemperature,flowInjectionBuffer,flowInjectionNeedleWashSolution,
	suppliedInjectionType,suppliedFlowInjectionOptions,specifiedFlowInjectionOptions,syringeModelPacket,
	injectionType,mapThreadFriendlyOptions,maxInjectionVolume,autosamplerDeadVolume,targetContainers,requiredAliquotVolumes,ionModes,calibrants,massRanges,
	capillaryVoltages,sourceTemperatures,desolvationTemperatures,desolvationGasFlows,injectionVolumes,calibrantMassRangeMismatches,transferRequiredWarnings,
	calibrantMassRangeMismatchTests,numReplicates,numReplicatesNoNull,injectedAmountAccountedForReplicates,groupedBySample,
	sampleCount,uniqueInjectedVolumes,uniqueTargetContainers,targetContainerDeadVolume,uniqueSamples,sampleTargetContainerRules,
	targetContainersResolved,totalVolumesNeeded,injectedVolumesPerSample,sampleVolumeRules,suppliedConsolidation,resolvedConsolidation,
	esiTripleQuadResolvedOptions,ionGuideVoltages,dwelltimes,infusionVolumes,syringeMinVolumes,syringeMaxInfusionVolumes,
	infusionSyringes,invalidSourceTemperatureBooleans,invalidDesolvationGasFlowBooleans,invalidConeGasFlowBooleans,invalidInfusionVolumeBooleans,
	runDurationExceedsInfusionOptionsBoolean, runDurationExceedsInfusionOptionsBooleans,


	containerCountTest,invalidContainerCountInputs,invalidAliquotContainerOptions,validAliquotContainerTest,
	aliquotOptions,resolvedAliquotOptions,aliquotTests,resolvedPostProcessingOptions,esiTripleQuadInvalidInputs,
	esiTripleQuadInvalidOptions,esiResolvedOptions,esiTripleQuadTests,declusteringVoltages,validCalibrantBools,
		(*Tandem Mass part*)
	scanModes,massTolerances,fragmentMassDetections,fragmentBooleans,collisionEnergies,collisionCellExitVoltages,neutralLosses,multipleReactionMonitoringAssays,invalidMassToleranceBooleans,fragmentScanModeMismatches,
	massDetectionScanModeMismatches,fragmentMassDetectionScanModeMismatches,unneededTandemMassSpecOptionLists,
	unneededTandemMassSpecOptionBooleans,unneededScanModeSpecifOptionLists,unneededScanModeSpecifOptionBooleans,requiredScanModeSpecifOptionLists,	invalidVoltagesOptionLists,
	voltageInputIonModeMisMatches,multipleReactionMonitoringVoltagesIonModeMisMatches,invalidMultipleReactionMonitoringVoltagesOptionLists,tooShortRunDurationBooleans,cycleRunDurations,tooManyMultpleReactionMonitoringAssayWarnings,autoNeutralLossValueWarnings,
	invalidLengthOfInputOptionLists,invalidLengthOfInputOptionBooleans,inputOptionsMRMAssaysMisMatchedOptionLists,inputOptionsMRMAssaysMisMatches,autoResolvedMassDetectionFixedValueWarnings,allCalibrantModels,
	autoResolvedFragmentMassDetectionFixedValueWarnings,uniqueSampleContainerObjects,uniqueSampleContainerModels,simulatedSampleContainerMinVolumePacket,simulatedSampleContainerMaxVolumePacket,tooManyCalibrantBoolean,

		(*Tests for ESI-QQQ*)
	invalidSourceTemperatureOptionTests,invalidDesolvationGasFlowOptionTests,invalidConeGasFlowTests,invalidInfusionSyringeTests,invalidInfusionVolumeTests,invalidMassToleranceTests,invalidFragmentTests,invalidMassDetectionTests,
	invalidTandemMassSpecOptionTests,invalidVoltageInputsOptionTests,invalidMultipleReactionMonitoringVoltagesOptionTests,invalidRunDurationTests,invalidLengthOfInputTests,invalidInputOptionsMRMAssaysTests,
	autoResolvedMassDetectionFixedValueTests,tooManyMultpleReactionMonitoringAssayTests,autoNeutralLossValueTests,autoResolvedFragmentMassDetectionFixedValueTests, invalidFragmentMassDetectionTests,	tooManyCalibrantWarningTests,
	invalidScanTimeBooleans, numberOfScanPoints, invalidScanTimeTests, invalidScanTimeOptions,
		(*Invalid Options*)
	invalidSourceTemperatureOptions,invalidDesolvationGasFlowOptions,invalidConeGasFlowOptions,invalidInfusionSyringeOptions,invalidInfusionVolumeOptions,invalidMassToleranceOptions,invalidFragmentOptions,
	invalidMassDetectionOptions,invalidTandemMassSpecOptions,invalidVoltageInputsOptions,invalidMultipleReactionMonitoringVoltagesOptions,invalidRunDurationOptions,invalidLengthOfInputOptions, invalidFragmentMassDetectionOptions,invalidInputOptionsMRMAssaysOptions,
	badCalibrantSamplePackets,outOfCalibrantRangeSamplePackets,outOfCalibrantRangeSamples,outOfRangeCalibrantTests,invalidCalibrantTests,invalidCalibrantOptions,defaultCalibrantP,nonDefaultCalibrants,nonDefaultCalibrantBools,
	aliquotQList,simulatedSampleContainerMinVolumes,requiredVolumes,invalidNonAliquotSampleVolumesQ,invalidNonAliquotSampleInputs,invalidNonAliquotSampleVolumeTests
},


	(* -- SETUP OUR USER SPECIFIED OTPIONS AND CACHE -- *)
	{gatherTests,discardedSamplesBools,nonLiquidSamplesBools,outOfMassRangeBools,ionSourceCalibrantMismatchBooleans,maxMassSupportedBools}=myBooleans;
	messages = !gatherTests;
	outsideEngine=!MatchQ[$ECLApplication,Engine];

	testOrNull[testDescription_String,passQ:BooleanP]:=If[gatherTests,
		Test[testDescription,True,Evaluate[passQ]],
		Null
	];

	simulatedCache=mySimulatedCache;

	(* Separate out our MassSpectrometry options from our Sample Prep options. *)
	{samplePrepOptions,massSpecSpecificOptions}=splitPrepOptions[mySuppliedExperimentOptions];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	massSpecOptions=Association[massSpecSpecificOptions];

	(* Lookup supplied values from options *)
	{suppliedCalibrants,unroundedMassRanges}=Lookup[massSpecOptions,{Calibrant,MassDetection}];


	(* deconstruct the download packets *)
	{
		(*1*)sampleDownload,
		(*2*)suppliedCalibrantSampleDownload,
		(*3*)suppliedCalibrantModelDownload,
		(*4*)relevantCalibrantModelDownload,
		(*5*){{maldiPlatePacket}},
		(*6*)allInstrumentModelPackets,
		(*7*)allSyringePackets,
		(*8*)aliquotContainerPackets,
		(*9*)syringeModelPacket
	}=myESITripleQuadDownloadPackets;


	simulatedSamplePackets=sampleDownload[[All,1]];
	sampleModelPackets=sampleDownload[[All,2]];

	(* Extact the simulated sample container models *)
	simulatedSampleContainerModels=sampleDownload[[All,3]];

	(* Extract simulated sample containers *)
	simulatedSampleContainers = Download[Lookup[simulatedSamplePackets,Container],Object];

	sampleAnalytePackets=sampleDownload[[All,4]];
	simulatedSampleIdentityModelPackets=sampleDownload[[All,5]];
	simulatedSampleContainerMinVolumePacket=sampleDownload[[All,6]];
	simulatedSampleContainerMaxVolumePacket=sampleDownload[[All,7]];
	calibrantSamplePackets=Flatten[suppliedCalibrantSampleDownload];
	relevantCalibrantModelPackets=Flatten[relevantCalibrantModelDownload];

	(* Determine the sample category of each sample since we will use this for the resolution below. If the category cannot be determined, it will be labeled None *)
	(* Categories are DNA (and all other oligonucleotides) / Peptide / Protein (including antibodies) / None *)
	sampleCategories=MapThread[Function[{samplePacket,modelPacket,sampleAnalytePackets},
		Which[
			MemberQ[Flatten@sampleAnalytePackets,ObjectP[Model[Molecule,Oligomer]]],
			Which[
				(* we treat any oligonucleotide as DNA - don't just look at PolymerType since that may contain the Mixed category *)
				MemberQ[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],(DNA|PNA|RNA|GammaLeftPNA|GammaRightPNA)],
				DNA,
				(* peptides are their own category *)
				MemberQ[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],Peptide],
				Peptide,
				(* just in case we missed a category or the pattern expands, do this catch-all *)
				True,
				None
			],
			(* Intact proteins and antibodies are treated as Protein *)
			MemberQ[Flatten@sampleAnalytePackets,ObjectP[Model[Molecule,Protein]]],
			Protein,
			(* If we're dealing with stock solution standards, and they have oligomers as StandardComponents we can check the StandardComponents properties *)
			MatchQ[Lookup[samplePacket,Model],Model[Sample,StockSolution,Standard]]&&!MatchQ[Flatten@sampleAnalytePackets,{}],
			Which[
				MatchQ[Commonest[DeleteCases[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],Except[PolymerP]]],(DNA|PNA|RNA|GammaLeftPNA|GammaRightPNA)],
				DNA,
				MatchQ[Commonest[DeleteCases[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],Except[PolymerP]]],Peptide],
				Peptide,
				True,
				None
			],
			(* If we're dealing with a sample chemical, a regular stock solution, or any other sample, we can't determine the sample category *)
			True,
			None
		]
	],
		{simulatedSamplePackets,simulatedSampleIdentityModelPackets,myFilteredAnalytePackets}
	];

	(*-- Indentify Syringes that can be used for syringe pump.*)
	allowedSyringeModels=DeleteDuplicates[Flatten[Lookup[#, Object] &/@allSyringePackets]];
	allowedSyringeModelsP=Alternatives@@allowedSyringeModels;

	(* -- ESI-SPECIFIC INPUT VALIDATION CHECKS -- *)

	(* -- Samples have molecular weights and/or sample category -- *)

	(* Lookup the molecular weight of analytes, per sample *)
	sampleMolecularWeights=MapThread[
		Function[{simulatedSamples, analytePackets},
			If[!MatchQ[analytePackets,{}|{Null..}],
				Cases[Lookup[analytePackets,MolecularWeight],MolecularWeightP],
				{}]],
		{simulatedSamplePackets,myFilteredAnalytePackets}];

	(* Get a list of samples which are missing molecular weight information AND don't have a sample category AND don't have a mass range specified *)
	noMolecularWeightSamplePackets=Complement[
		MapThread[Function[{mw,massRange,category,packet},
			If[Length[mw]==0 && MatchQ[massRange,Automatic] && MatchQ[category,None],
				packet,
				Nothing
			]],
			{sampleMolecularWeights,unroundedMassRanges,sampleCategories,simulatedSamplePackets}
		],
		PickList[simulatedSamplePackets,nonLiquidSamplesBools,True],PickList[simulatedSamplePackets,discardedSamplesBools,True]
	];

	(* Throw warning message (but only if we haven't thrown a Discarded or Non-Liquid sample error *)
	If[!MatchQ[noMolecularWeightSamplePackets,{}] && messages && outsideEngine,
		Message[Warning::DefaultMassDetection,ObjectToString[Lookup[noMolecularWeightSamplePackets,Object],Cache->simulatedCache]]
	];

	(* Generate tests *)
	noMolecularWeightTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,noMolecularWeightSamplePackets,"The molecular weights of or the sample category (DNA, Peptide, Protein, etc) of `1` are known, such that a sensible mass range can be determined automatically, if needed:",simulatedCache];

	(* -- ESI-SPECIFIC OPTION PRECISION CHECKS -- *)

	(* Verify that the ESI mass spec options are not overly precise *)
	{roundedMassSpecOptions,optionPrecisionTests}=If[gatherTests,
		RoundOptionPrecision[massSpecOptions,
			{
				(*1*)ESICapillaryVoltage,
				(*2*)IonGuideVoltage,
				(*3*)DeclusteringVoltage,
				(*4*)SourceTemperature,
				(*5*)DesolvationTemperature,
				(*6*)ConeGasFlow,
				(*7*)DesolvationGasFlow,
				(*8*)InfusionFlowRate,
				(*9*)RunDuration,
				(*10*)ScanTime,
				(*11*)SampleTemperature,
				(*12*)InjectionVolume,
				(*13*)InfusionVolume,
				(*14*)CollisionEnergy,
				(*15*)CollisionCellExitVoltage,
				(*16*)NeutralLoss,
				(*17*)MassTolerance,
				(*18*)DwellTime
			},
			{
				(*1*)1*10^-2 Kilovolt,
				(*2*)1*10^0 Volt,
				(*3*)1*10^0 Volt,
				(*4*)1*10^0 Celsius,
				(*5*)1*10^0 Celsius,
				(*6*)1*10^0 PSI,
				(*7*)1*10^0 PSI,
				(*8*)1*10^-1 Microliter/Minute,
				(*9*)1*10^-2 Minute,
				(*10*)1*10^-3 Second,
				(*11*)1*10^-1 Celsius,
				(*12*)10^-1 Microliter,
				(*13*)10^-2 Milliliter,
				(*14*)1*10^0 Volt,
				(*15*)1*10^0 Volt,
				(*16*)1*10^-1 Gram/Mole,
				(*17*)1*10^-1 Gram/Mole,
				(*18*)1*10^0 Millisecond
			},
			Output->{Result,Tests}
		],
		{RoundOptionPrecision[massSpecOptions,
			{
				(*1*)ESICapillaryVoltage,
				(*2*)IonGuideVoltage,
				(*3*)DeclusteringVoltage,
				(*4*)SourceTemperature,
				(*5*)DesolvationTemperature,
				(*6*)ConeGasFlow,
				(*7*)DesolvationGasFlow,
				(*8*)InfusionFlowRate,
				(*9*)RunDuration,
				(*10*)ScanTime,
				(*11*)SampleTemperature,
				(*12*)InjectionVolume,
				(*13*)InfusionVolume,
				(*14*)CollisionEnergy,
				(*15*)CollisionCellExitVoltage,
				(*16*)NeutralLoss,
				(*17*)MassTolerance,
				(*18*)DwellTime
			},
			{
				(*1*)1*10^-2 Kilovolt,
				(*2*)1*10^0 Volt,
				(*3*)1*10^0 Volt,
				(*4*)1*10^0 Celsius,
				(*5*)1*10^0 Celsius,
				(*6*)1*10^0 PSI,
				(*7*)1*10^0 PSI,
				(*8*)1*10^-1 Microliter/Minute,
				(*9*)1*10^-2 Minute,
				(*10*)1*10^-3 Second,
				(*11*)1*10^-1 Celsius,
				(*12*)10^-1 Microliter,
				(*13*)10^-1 Microliter,
				(*14*)1*10^0 Volt,
				(*15*)1*10^0 Volt,
				(*16*)1*10^-1 Gram/Mole,
				(*17*)1*10^-1 Gram/Mole,
				(*18*)1*10^0 Millisecond

			}],Null}
	];

	(* -- ESI-SPECIFIC CONFLICTING OPTIONS CHECKS -- *)


	(* -- Validate AliquotContainer -- *)

	(* get the containers that were specified by the users - Download the object in case they referenced to it by Name *)
	suppliedAliquotContainers=Lookup[samplePrepOptions,AliquotContainer];

	(* get the model container of the user specified aliquot container *)
	unresolvedAliquotContainerModels=MapThread[
		If[MatchQ[#,Automatic],
			Null,
			(* If a model was supplied we just use that *)
			If[MatchQ[#1, ObjectP[Model]],
				#1,
				(* otherwise, it's an object, and we need to lookup the model of the object *)
				Experiment`Private`cacheLookupUVMelting[mySimulatedCache,Download[#1,Object],{Model}]
			]
		]&,
		{suppliedAliquotContainers}
	];

	(* check whether the AliquotContainers, if specified, are compatible with the instrument. *)
	aliquotContainerConflicts={};


	(* if we had invalid results, extract the invalid input and the corresponding specified balance *)
	{badAliquotContainerPackets,badALiquotContainers}=If[Length[aliquotContainerConflicts]>0,
		Transpose[aliquotContainerConflicts],
		{{},{}}
	];

	(* Throw Warning message *)
	If[!MatchQ[badAliquotContainerPackets,{}] && messages,
		Message[Error::MassSpectrometryIncompatibleAliquotContainer,ObjectToString[Lookup[badAliquotContainerPackets,Object],Cache->simulatedCache],allowedESIContainers]
	];

	(* Collect invalid options *)
	badAliquotContainerOptions=If[!MatchQ[badAliquotContainerPackets,{}],AliquotContainer];

	(* Create a test for the valid samples and one for the invalid samples *)
	badAliquotContainerTests=sampleTests[gatherTests,Test,simulatedSamplePackets,badLaserPowerRangeSamplePackets,"The provided AliquotContainer is compatible with the instrument for input samples `1`:",simulatedCache];

	(* -- RESOLVE EXPERIMENT OPTIONS -- *)
	(* Get user-supplied aliquot options *)
	{(*1*)suppliedAliquots,(*2*)suppliedAssayVolumes,(*3*)suppliedAliquotVolumes,(*4*)suppliedTargetConcentrations,(*5*)suppliedAssayBuffers}=Lookup[
		samplePrepOptions,
		{(*1*)Aliquot,(*2*)AssayVolume,(*3*)AliquotAmount,(*4*)TargetConcentration,(*5*)AssayBuffer}
	];


	(* Determine if user wants to aliquot based on their specified options, or leave Automatic if they haven't set any aliquot options *)
	impliedAliquotBools=MapThread[
		Function[
			{
				(*1*)suppliedAliquot,
				(*2*)suppliedAssayVolume,
				(*3*)suppliedAliquotVolume,
				(*4*)suppliedTargetConcentration,
				(*5*)suppliedAssayBuffer,
				(*6*)suppliedAliquotContainer
			},
			If[
				MatchQ[suppliedAliquot,Automatic],
				(* If user didn't explicitly set Aliquot, but set a core option, assume they want to aliquot *)
				If[MemberQ[{suppliedAssayVolume,suppliedAliquotVolume,suppliedTargetConcentration,suppliedAssayBuffer,suppliedAliquotContainer},Except[False|Null|Automatic]],
					True,
					Automatic
				],
				suppliedAliquot
			]
		],
		{
			(*1*)suppliedAliquots,
			(*2*)suppliedAssayVolumes,
			(*3*)suppliedAliquotVolumes,
			(*4*)suppliedTargetConcentrations,
			(*5*)suppliedAssayBuffers,
			(*6*)suppliedAliquotContainers
		}
	];

	(* Get the volume from the samples - this is going to be either the volume of the sample, or the aliquoted volume, or the assay volume if we're diluting down *)
	simulatedVolumes=Lookup[#,Volume]&/@simulatedSamplePackets;


	(* get the containers that were specified by the users - Download the object in case they referenced to it by Name *)
	suppliedInjectionType=Lookup[massSpecOptions,InjectionType];
	suppliedFlowInjectionOptions=Lookup[massSpecOptions,{SampleTemperature,Buffer,NeedleWashSolution,InjectionVolume}];

	(* figure out whether any of flowinjections options were specified, as in provided with a value other than Automatic - this is a simple boolean *)
	specifiedFlowInjectionOptions= Or @@ (! MatchQ[#, (Automatic | {Automatic ..})] & /@ suppliedFlowInjectionOptions);

	(* resolve the master switch InjectionType *)
	injectionType=If[!MatchQ[suppliedInjectionType,Automatic],
		(* if the user supplied the injection type, then we just use that - no resolution necessary. WE've thrown errors above if needed *)
		suppliedInjectionType,
		(* If we need to resolve, we look at the options provided, the number of samples, and the container of the samples, in that order *)
		Which[
			(* the moment ANY of the flow-injection specific options are provided by the user, we resolve to FlowInjection (no matter how few) *)
			specifiedFlowInjectionOptions,FlowInjection,

			(*If sample volumes is smaller than 0.2 mL, we resolved to flowinjection*)
			Min[simulatedVolumes]<0.2Milliliter,FlowInjection,

			(* if we're dealing with less than 5 samples then we default to DirectInfusion *)
			Length[mySimulatedSamples]<5, DirectInfusion,

			(* if the samples are inside a single plate of the 96 DWP type, we default to FlowInjection *)
			MatchQ[DeleteDuplicates[simulatedSampleContainerModels],{ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]..}]&&Length[DeleteDuplicates[simulatedSampleContainers]]==1, FlowInjection,

			(* catch-all *)
			True,DirectInfusion
		]
	];

	(* make a flow injection check since we're going to switch on that below *)
	flowInjectionQ=MatchQ[injectionType,FlowInjection];


	(* If the user supplied the InfusionFlowRate values, use these, otherwise we default *)
	infusionFlowRates=If[flowInjectionQ,
		resolveAutomaticOption[InfusionFlowRate,roundedMassSpecOptions,100*Microliter/Minute],
		resolveAutomaticOption[InfusionFlowRate,roundedMassSpecOptions,5*Microliter/Minute]
	 ];


	(* Resolve the single flow-injection specific options *)
	flowInjectionSampleTemperature=If[flowInjectionQ,resolveAutomaticOption[SampleTemperature,roundedMassSpecOptions,$AmbientTemperature],Null];
	flowInjectionBuffer=If[flowInjectionQ,resolveAutomaticOption[Buffer,roundedMassSpecOptions,Model[Sample,StockSolution,"0.1% FA with 5% Acetonitrile in Water, LCMS-grade"]],Null];
	flowInjectionNeedleWashSolution=If[flowInjectionQ,resolveAutomaticOption[NeedleWashSolution,roundedMassSpecOptions,Model[Sample,StockSolution,"20% Methanol in MilliQ Water"]],Null];

	(* Convert our ESI MS options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentMassSpectrometry,roundedMassSpecOptions];

	(* Correct index-matching issues with MRM Assay, DwellTime and CollisionEnergy Options *)
	If[!MatchQ[Lookup[roundedMassSpecOptions, MultipleReactionMonitoringAssays], Alternatives[Automatic,{Automatic...}]],
		(*If MRM Assays was specified.. *)
		Which[
			(* If MRM is a list of list of lists, it is fully specified for multiple sample inputs and we can continue*)
			ArrayDepth[Lookup[roundedMassSpecOptions, MultipleReactionMonitoringAssays]] >= 3, Nothing,
			(*If MRM is a list of list whose length matches the length of samples, assume its index-matched to samples *)
			ArrayDepth[Lookup[roundedMassSpecOptions, MultipleReactionMonitoringAssays]] == 2 && Length[Lookup[roundedMassSpecOptions, MultipleReactionMonitoringAssays]] == Length[myNonSimulatedSamples],
			(*mapThreadFriendlyOptions should have paired each MRM Assay element with the options for each sample *)
			mapThreadFriendlyOptions = MapThread[Append[#1, {MultipleReactionMonitoringAssays -> #2}]&, {mapThreadFriendlyOptions, {Lookup[roundedMassSpecOptions, MultipleReactionMonitoringAssays]}}],
			(* Otherwise assume its a global option meant to be applied to each sample, the entire MRM Assays list should be applied to each sample*)
			True, Nothing
		];
		If[!MatchQ[Lookup[roundedMassSpecOptions, DwellTime], Alternatives[Automatic,{Automatic...}]],
			(* If DwellTime was specified.. *)
			Which[
				(* If DwellTime is a list of lists of lists, it is fully specified for multiple sample inputs and we can continue *)
				ArrayDepth[Lookup[roundedMassSpecOptions, DwellTime]] >= 3, Nothing,
				(* If DwellTime is a list of lists whose length matches the length of samples, assume its index-matched to samples *)
				Length[ToList[Lookup[roundedMassSpecOptions, DwellTime]]] == Length[myNonSimulatedSamples],
				(*mapThreadFriendlyOptions should have paired each DwellTime element with the options for each sample *)
				mapThreadFriendlyOptions = MapThread[Append[#1, {DwellTime -> ConstantArray[#2, Length[Lookup[#1, MultipleReactionMonitoringAssays]]]}]&, {mapThreadFriendlyOptions, ToList[Lookup[roundedMassSpecOptions, DwellTime]]}],
				(* Otherwise assume its a global option meant to be applied to each sample, the entire DwellTime list should be applied to each sample*)
				True, Nothing
			];
		];
		If[!MatchQ[Lookup[roundedMassSpecOptions, CollisionEnergy], Alternatives[Automatic,{Automatic...}]],
			(* If CollisionEnergy was Specified.. *)
			Which[
				(* If CollisionEnergy is a list of lists of lists, it is fully specified for multiple sample inputs and we can continue *)
				ArrayDepth[Lookup[roundedMassSpecOptions, CollisionEnergy]] >= 3, Nothing,
				(* If CollisionEnergy is a list of lists whose length matches the length of samples, assume its index-matched to samples *)
				Length[ToList[Lookup[roundedMassSpecOptions, CollisionEnergy]]] == Length[myNonSimulatedSamples],
				(*mapThreadFriendlyOptions should have paired each CollisionEnergy element with the options for each sample *)
				mapThreadFriendlyOptions = MapThread[Append[#1, {CollisionEnergy -> ConstantArray[#2, Length[Lookup[#1, MultipleReactionMonitoringAssays]]]}]&,{mapThreadFriendlyOptions, ToList[Lookup[roundedMassSpecOptions, CollisionEnergy]]}],
				(* Otherwise assume its a global option meant to be applied to each sample, the entire DwellTime list should be applied to each sample*)
				True, Nothing
			];
		];
	];

	(*declaring some globals*)
	maxInjectionVolume=50 Microliter;
	autosamplerDeadVolume=20 Microliter;


	(* Do our big MapThread for resolving the indexmatched options*)
	{
		(*1*)ionModes,
		(*2*)calibrants,
		(*3*)massRanges,
		(*4*)capillaryVoltages,
		(*5*)declusteringVoltages,
		(*6*)desolvationTemperatures,
		(*7*)desolvationGasFlows,
		(*8*)injectionVolumes,
		(*9*)calibrantMassRangeMismatches,
		(*10*)transferRequiredWarnings,
		(*11*)ionGuideVoltages,
		(*12*)infusionVolumes,
		(*13*)invalidInfusionVolumeBooleans,
		(*14*)infusionSyringes,
		(*15*)invalidInfusionSyringeBooleans,
		(*16*)invalidSourceTemperatureBooleans,
		(*17*)invalidDesolvationGasFlowBooleans,
		(*18*)invalidConeGasFlowBooleans,
		(*19*)scanTimes,
		(*20*)runDurations,
		(*21*)scanModes,
		(*22*)massTolerances,
		(*23*)fragmentMassDetections,
		(*24*)dwelltimes,
		(*25*)fragmentBooleans,
		(*26*)collisionEnergies,
		(*27*)collisionCellExitVoltages,
		(*28*)neutralLosses,
		(*29*)multipleReactionMonitoringAssays,
		(*30*)invalidMassToleranceBooleans,
		(*31*)fragmentScanModeMismatches,
		(*32*)massDetectionScanModeMismatches,
		(*33*)fragmentMassDetectionScanModeMismatches,
		(*34*)unneededTandemMassSpecOptionLists,
		(*35*)unneededTandemMassSpecOptionBooleans,
		(*36*)unneededScanModeSpecifOptionLists,
		(*37*)unneededScanModeSpecifOptionBooleans,
		(*38*)requiredScanModeSpecifOptionLists,
		(*39*)invalidVoltagesOptionLists,
		(*40*)voltageInputIonModeMisMatches,
		(*41*)multipleReactionMonitoringVoltagesIonModeMisMatches,
		(*42*)invalidMultipleReactionMonitoringVoltagesOptionLists,
		(*43*)tooManyMultpleReactionMonitoringAssayWarnings,
		(*44*)tooShortRunDurationBooleans,
		(*45*)cycleRunDurations,
		(*46*)autoNeutralLossValueWarnings,
		(*47*)invalidLengthOfInputOptionLists,
		(*48*)invalidLengthOfInputOptionBooleans,
		(*49*)inputOptionsMRMAssaysMisMatchedOptionLists,
		(*50*)inputOptionsMRMAssaysMisMatches,
		(*51*)autoResolvedMassDetectionFixedValueWarnings,
		(*52*)autoResolvedFragmentMassDetectionFixedValueWarnings,
		(*53*)massInCalibrantRangeBools,
		(*54*)validCalibrantBools,
		(*55*)syringeMinVolumes,
		(*56*)syringeMaxInfusionVolumes,
		(*57*)invalidScanTimeBooleans,
		(*58*)runDurationExceedsInfusionOptionsBooleans
	}=Transpose[
		MapThread[
			Function[
			{
				(*1*)simulatedSamplePacket,
				(*2*)sampleModelPacket,
				(*3*)sample,
				(*4*)containerModel,
				(*5*)options,
				(*6*)suppliedAliquotContainer,
				(*7*)suppliedAliquotContainerModel,
				(*8*)sampleCategory,
				(*9*)molecularWeights,
				(*10*)aliquotBool,
				(*11*)aliquotAmount,
				(*12*)infusionFlowRate,
				(*15*)simulatedSampleVolume,
				(*16*)ionSourceCalibrantMismatchBool,
				(*17*)maxMassSupportedBool,
				(*18*)filteredAnalytes
			},
			Module[{suppliedInjectionVolume,suppliedIonMode,suppliedCalibrant,suppliedMassRange,suppliedInfusionFlowRate,suppliedCapillaryVoltage,allSuppliedVoltages,
				suppliedSourceTemperature,suppliedDesolvationTemperature,suppliedConeGasFlow,suppliedDesolvationGasFlow,suppliedIonGuideVoltage,positiveSuppliedVoltages,
				pKaValue,acid,base, pHValue,ionMode,calibrant,lowRange,highRange,syringeMaxInfusionVolume,negativeSuppliedVoltages,
				massRange,calibrantPacket,calibrantMassRangeMismatch,capillaryVoltage,desolvationTemperature,desolvationGasFlow,resolvedCapillaryVoltage,
				resolvedDesolvationTemperature,resolvedDesolvationGasFlow,injectionVolume,suppliedDeclusteringVoltage,
				transferRequiredWarning,resolvedIonGuideVoltage,massInCalibrantRangeBool,validCalibrantQ,simulatedVolume,
				resolvedInfusionVolume, resolvedInfusionSyringe,resolvedInfusionFlowRate,invalidSourceTemperatureBoolean,invalidDesolvationGasFlowBoolean,invalidConeGasFlowBoolean,suppliedInfusionSyringe,suppliedInfusionVolume,
				invalidInfusionSyringeBoolean,syringePacket,syringeMaxVolume,syringeMinVolume,syringeDeadVolume,invalidInfusionVolumeBoolean, resolvedDeclusteringVoltage,
				(*Tandem Mass Part*)
				tandemMassSpecificAllowNullOptionNames,suppliedTandemMassAllowNullOptions,numberOfMassInputs,
				suppliedScanTime,suppliedRunDuration,suppliedScanMode,suppliedMassTolerance,suppliedFragmentMassDetection,suppliedFragment,suppliedCollisionEnergy,suppliedCollisionCellExitVoltage,suppliedNeutralLoss,suppliedMultipleReactionMonitoringAssay,suppliedDwellTime,
				resolvedMassTolerance,resolvedFragmentMassDetection,resolvedFragmentBoolean,resolvedCollisionEnergy,resolvedCollisionCellExitVoltage,resolvedNeutralLoss,resolvedMultipleReactionMonitoringAssay,resolvedDwellTime,resolvedScanMode,
				rangedMassScanQ,rangedMS1MassScanQ,invalidMassToleranceBoolean,tandemMassQ,fragmentScanModeMisMatch,massDetectionScanModeMisMatch,fragmentMassDetectionScanModeMisMatch,
				unneededTandemMassSpecOptionList,unneededTandemMassSpecOptionBoolean,unneededScanModeSpecifOptionList,unneededScanModeSpecifOptionBoolean,requiredScanModeSpecifOptionList,invalidVoltagesOptionList,
				voltageInputIonModeMisMatch,multipleReactionMonitoringVoltagesIonModeMisMatch,invalidMultipleReactionMonitoringVoltagesOptionList,resolvedScanTime,resolvedRunDuration,
				tooManyMultpleReactionMonitoringAssayWarning,tooShortRunDurationBoolean,cycleRunDuration,minAmountSampleForExperiment,positiveIonModeQ,autoNeutralLossValueWarning,defaultMassSelectionValue,invalidLengthOfInputOptionList,invalidLengthOfInputOptionBoolean,inputOptionsMRMAssaysMisMatchedOptionList,inputOptionsMRMAssaysMisMatch,
				autoResolvedMassDetectionFixedValueWarnings,autoResolvedFragmentMassDetectionFixedValueWarning,resolvedInfusionSyringeModel,resolvedAliquotVolume, invalidScanTime

			},

				(* get user-supplied ESI mass spec options *)
				{
					(*1*)suppliedInjectionVolume,
					(*2*)suppliedIonMode,
					(*3*)suppliedCalibrant,
					(*4*)suppliedMassRange,
					(*5*)suppliedInfusionFlowRate,
					(*6*)suppliedCapillaryVoltage,
					(*7*)suppliedDeclusteringVoltage,
					(*8*)suppliedSourceTemperature,
					(*9*)suppliedDesolvationTemperature,
					(*10*)suppliedDesolvationGasFlow,
					(*11*)suppliedConeGasFlow,
					(*12*)suppliedIonGuideVoltage,
					(*13*)suppliedInfusionSyringe,
					(*14*)suppliedInfusionVolume,
					(*15*)suppliedScanTime,
					(*16*)suppliedRunDuration,
					(*17*)suppliedScanMode,
					(*18*)suppliedMassTolerance,
					(*19*)suppliedFragmentMassDetection,
					(*20*)suppliedFragment,
					(*21*)suppliedCollisionEnergy,
					(*22*)suppliedCollisionCellExitVoltage,
					(*23*)suppliedNeutralLoss,
					(*24*)suppliedMultipleReactionMonitoringAssay,
					(*25*)suppliedDwellTime
				} =Lookup[
					options,
					{
						(*1*)InjectionVolume,
						(*2*)IonMode,
						(*3*)Calibrant,
						(*4*)MassDetection,
						(*5*)InfusionFlowRate,
						(*6*)ESICapillaryVoltage,
						(*7*)DeclusteringVoltage,
						(*8*)SourceTemperature,
						(*9*)DesolvationTemperature,
						(*10*)DesolvationGasFlow,
						(*11*)ConeGasFlow,
						(*12*)IonGuideVoltage,
						(*13*)InfusionSyringe,
						(*14*)InfusionVolume,
						(*15*)ScanTime,
						(*16*)RunDuration,
						(*17*)ScanMode,
						(*18*)MassTolerance,
						(*19*)FragmentMassDetection,
						(*20*)Fragment,
						(*21*)CollisionEnergy,
						(*22*)CollisionCellExitVoltage,
						(*23*)NeutralLoss,
						(*24*)MultipleReactionMonitoringAssays,
						(*25*)DwellTime
					}
				];

				(* -- Resolve ion mode -- *)
				(* Grab some useful values*)
				pHValue=Lookup[simulatedSamplePacket,pH];
				pKaValue=If[!MatchQ[filteredAnalytes,{}|{Null..}],
					Mean[Cases[Lookup[filteredAnalytes,pKa],_?NumericQ]],
					Null];
				acid=If[!MatchQ[filteredAnalytes,{}|{Null..}],
					Or@@(Lookup[filteredAnalytes,Acid]/.{Null|$Failed->False}),
					Null];
				base=If[!MatchQ[filteredAnalytes,{}|{Null..}],
					Or@@(Lookup[filteredAnalytes,Base]/.{Null|$Failed->False}),
					Null];

				(*-- Check user specified voltage options, if user specified positive voltage, we should resolve ion mode to positve and vice versa--*)
				allSuppliedVoltages={suppliedCapillaryVoltage,suppliedDeclusteringVoltage,suppliedIonGuideVoltage,suppliedCollisionEnergy,suppliedCollisionCellExitVoltage};
				positiveSuppliedVoltages=Cases[allSuppliedVoltages,GreaterP[0*Volt]];
				negativeSuppliedVoltages=Cases[allSuppliedVoltages,LessP[0*Volt]];


				ionMode=Which[
					MatchQ[suppliedIonMode,IonModeP],suppliedIonMode,

					(* - Resolve automatic - *)

					(* User specified voltages based resolution*)
					(Length[positiveSuppliedVoltages]>Length[negativeSuppliedVoltages]),Positive,
					(Length[positiveSuppliedVoltages]<Length[negativeSuppliedVoltages]),Negative,

					(* Sample type based resolution *)
					MatchQ[sampleCategory,Peptide|DNA], Positive,

					(* Acid/Based flag based resolution *)

					(* Bases are compounds that are protonated in solution, so they form positive ions -> Positive *)
					(* Acids are compounds that loose their proton in solution, so they form negative ions -> Negative *)
					TrueQ[acid],Negative,
					TrueQ[base],Positive,

					(* pKa-based resolution *)
					(* high pKa tend to bind protons, gaining a positive charge in the process -> Positive *)
					(* low pKA tend to loose a proton -> Negative *)
					NumericQ[pKaValue]&&pKaValue<8,Negative,
					NumericQ[pKaValue]&&pKaValue>=8,Positive,

					(* pH-based resolution *)
					(* pH is the property of the solution, so with low pH, a lot of protons are available, so most likely we are doing Positive *)
					NumericQ[pHValue]&&pHValue<5,Positive,
					NumericQ[pHValue]&&pHValue>=5,Negative,

					(* Default to positive, since this generally works *)
					True,Positive
				];

				positiveIonModeQ=MatchQ[ionMode,Positive];

				(* Do check if user supplied a calibrant and MWs is known to see if the MW is in range*)
				{massInCalibrantRangeBool,validCalibrantQ}=If[
					MatchQ[molecularWeights,{MolecularWeightP..}]&&MatchQ[suppliedCalibrant,ObjectP[]],
					Module[{internalCalibrantPacket,referencePeaks,eachMassInRangeQ,eachValidCalibrantQ},

						(* Get model packet of the calibrant *)
						internalCalibrantPacket=If[MatchQ[suppliedCalibrant,ObjectP[Object[Sample]]],
							fetchPacketFromCache[Lookup[fetchPacketFromCache[suppliedCalibrant,simulatedCache],Model],simulatedCache],
							fetchPacketFromCache[suppliedCalibrant,simulatedCache]
						];
						(* Lookup calibrant peaks *)
						referencePeaks=If[positiveIonModeQ,Lookup[internalCalibrantPacket,ReferencePeaksPositiveMode],Lookup[internalCalibrantPacket,ReferencePeaksNegativeMode]];
						(* Check that all molecular weights are within the min and max of the peaks *)
						eachMassInRangeQ=If[Length[referencePeaks]==0,
							False,
							And@@((RangeQ[#,{Min[referencePeaks],Max[referencePeaks]}]&)/@molecularWeights)
						];
						eachValidCalibrantQ=MemberQ[Lookup[relevantCalibrantModelPackets,Object],Lookup[internalCalibrantPacket,Object]];
						{eachMassInRangeQ,eachValidCalibrantQ}
					],
					{True,True}
				];

				(* -- source Tempeprature cannot be set to a value other than 150 Celsiu ESI-QQQ *)
				invalidSourceTemperatureBoolean=!Or[(suppliedSourceTemperature===150 Celsius)||MatchQ[suppliedSourceTemperature,Automatic]];

				(*-- Check if DesolvationGasFlow and ConeGasFlow are inputed as pressure, For ESI-QQQ these two value need to be input as pressure (PSI) insead of flow rate (L/h)*)
				invalidDesolvationGasFlowBoolean=!Or[(MatchQ[suppliedDesolvationGasFlow,UnitsP[PSI]])||MatchQ[suppliedDesolvationGasFlow,Automatic]];
				invalidConeGasFlowBoolean=!Or[MatchQ[suppliedConeGasFlow,UnitsP[PSI]]||MatchQ[suppliedConeGasFlow,Automatic]];

				(* -- Resolve the flow rate dependent ESI options -- *)
				(* for the low flow, we differentiate between Positive and Negative for the capillary voltage, for all other options we just look at the flow rate *)
				{capillaryVoltage,desolvationTemperature,desolvationGasFlow}=Switch[infusionFlowRate,
					RangeP[0*Milliliter/Minute,0.02*Milliliter/Minute],{If[positiveIonModeQ,5.5*Kilovolt,-4.5*Kilovolt],100*Celsius,20*PSI},
					RangeP[0.021*Milliliter/Minute,0.1*Milliliter/Minute],{If[positiveIonModeQ,4.5*Kilovolt,-4.0*Kilovolt],200*Celsius,40*PSI},
					RangeP[0.101*Milliliter/Minute,0.3*Milliliter/Minute],{If[positiveIonModeQ,4.5*Kilovolt,-4.0*Kilovolt],350*Celsius,60*PSI},
					RangeP[0.301*Milliliter/Minute,0.5*Milliliter/Minute],{If[positiveIonModeQ,4.0*Kilovolt,-4.0*Kilovolt],500*Celsius,60*PSI},
					GreaterP[0.5*Milliliter/Minute],{If[positiveIonModeQ,4.0*Kilovolt,-4.0*Kilovolt],600*Celsius,75*PSI}
				];


				(* If the user supplied any of these values, we use these, otherwise we go with our resolution *)
				{resolvedCapillaryVoltage,resolvedDesolvationTemperature,resolvedDesolvationGasFlow}=MapThread[
					resolveAutomaticOption[#1,options,#2]&,
					{
						{ESICapillaryVoltage,DesolvationTemperature,DesolvationGasFlow},
						{capillaryVoltage,desolvationTemperature,desolvationGasFlow}
					}
				];


				(*Resolve declusteringVoltage and check if the value matches IonMode*)
				resolvedDeclusteringVoltage=Switch[{suppliedDeclusteringVoltage,ionMode},

					(* If user specified a value, will check if it's match the resolvedIonMode with other Voltage Options*)
					{Except[Automatic],_},suppliedDeclusteringVoltage,

					(*Resolve Automatic Deslustering Voltage input*)
					{_,Positive},90*Volt,
					{_,Negative},-90*Volt
				];

				(*Resove IonGuideVoltage and Check if it's consistent with IonMode, e.g. Positive voltage for Positive ion mode and vice versa.*)
				resolvedIonGuideVoltage=Switch[{suppliedIonGuideVoltage,ionMode},

					(* For user specified IonGuidVoltage, check if its consistant with resovled ion mode.*)
					{Except[Automatic],_}, suppliedIonGuideVoltage,

					(* Resolve Automatic option *)
					{_,Positive},10*Volt,
					{_,Negative},-10*Volt
				];

				(*Resolve an aliquotAmount if user specified the aliquot option but didn't specified aliquot amount*)
				resolvedAliquotVolume= If[
					MatchQ[aliquotAmount,Except[Automatic]],
					aliquotAmount,
					If[flowInjectionQ, 30 Microliter,0.5 Milliliter]
				];


				(* Resolve injection volume*)
				(* Resolve the only index-matched option that is specific to flow-injection, based on:
						- Input option value
						- injection type
						- aliquot volume minus dead volume of autosampler
						- default 10ul *)
				injectionVolume=Which[
					MatchQ[suppliedInjectionVolume,VolumeP],suppliedInjectionVolume,
					MatchQ[injectionType,DirectInfusion], Null,
					(* - Resolve automatic - *)
					TrueQ[aliquotBool],
					Min[resolvedAliquotVolume - autosamplerDeadVolume,maxInjectionVolume - autosamplerDeadVolume],
					True,
					If[MatchQ[Lookup[simulatedSamplePacket,Volume],VolumeP],
						Min[Lookup[simulatedSamplePacket,Volume], 10 Microliter],
						10 Microliter
					]
				];


				(*-- Resolving all tandem mass and MassDetection options here*)
				(*MassSpecScanModeP = FullScan|SelectedIonMonitoring|PrecursorIonScan|NeutralIonLoss|ProductIonScan|SelectedReactionMonitoring|MultipleReactionMonitoring)*)

				tandemMassSpecificAllowNullOptionNames={
					CollisionEnergy,
					CollisionCellExitVoltage,
					NeutralLoss,
					MultipleReactionMonitoringAssays
				};

				(* Check if Tandem MassSpec option is specified by user*)
				suppliedTandemMassAllowNullOptions=Lookup[massSpecOptions,#]&/@tandemMassSpecificAllowNullOptionNames;

				(* Check how many tandem mass options specified by user are not Automatic*)
				numberOfTandemMassAllowNullOptions=Count[!MatchQ[#,({Automatic..}|Automatic)]&/@ suppliedTandemMassAllowNullOptions,True];

				(*We first resolved Fragment Boolean, this option is easier, simply indicate if the collision cell is on*)

				resolvedFragmentBoolean=If[

					(*If user specified a value, we use what user specified*)
					MatchQ[suppliedFragment, Except[Automatic]],
					suppliedFragment,

					(*If user did not specified anything, we check if user specified any tandem mass related options, if so, resolve it to True, otherwith resolved it to False*)
					If[
						MatchQ[suppliedScanMode,Automatic],
						Or[MatchQ[suppliedFragmentMassDetection,Except[(Automatic|Null)]],(numberOfTandemMassAllowNullOptions>0)],
						!MatchQ[suppliedScanMode,(FullScan|SelectedIonMonitoring)]
					]

				];

				(*-- ReSolved ScanMode as the MasterSwitch*)
				resolvedScanMode=If[MatchQ[suppliedScanMode,Except[Automatic]],
					(*if user specified a value, use what user specified*)
					suppliedScanMode,

					(*Resolved automatic scan mode*)
					Switch[{resolvedFragmentBoolean,suppliedMassRange,suppliedFragmentMassDetection},
						(*If user specified Fragment options as False, we resolved *)
						{False,_Span,_},FullScan,
						{False,({UnitsP[Gram/Mole] ..}|UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}),_},SelectedIonMonitoring,

						(*Default all input as FullScan*)
						{False,_,_},FullScan,

						(*MS1:Range, MS2:Range, NeutralIonScan*)
						{True,_Span,_Span},NeutralIonLoss,

						(*MS1:Range, MS2:Selection, PrecursorIonScan*)
						{True,_Span,{UnitsP[Gram/Mole]}|UnitsP[Gram/Mole]},PrecursorIonScan,

						(*MS1:Selection, MS2:Range, ProductioIonScan*)
						{True,{UnitsP[Gram/Mole]}|UnitsP[Gram/Mole],_Span},ProductIonScan,

						(*MS1:Selection, MS2:Selection, MultipleReactionMonitoring*)
						{True,UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}|{UnitsP[Gram/Mole] ..},UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}|{UnitsP[Gram/Mole] ..}},MultipleReactionMonitoring,

						(*MS1:Selection, MS2:Automatic, Fragment is on we assigned it to ProductioIonScan*)
						{True,{UnitsP[Gram/Mole]}|{UnitsP[Gram/Mole]},_},ProductIonScan,

						(*MS1:Range, MS2:Selection, Fragment is on we assigned it to PrecursorIonScan*)
						{True,_Span,_},PrecursorIonScan,



						(*If we cannoe resolved by mass detection values, we check if user specified mass scan mode specific options*)
						{True,_,_},If[MatchQ[suppliedNeutralLoss,Except[Automatic]],
						NeutralIonLoss,
						If[
							MatchQ[suppliedMultipleReactionMonitoringAssay, Except[Automatic]],
							MultipleReactionMonitoring,
							PrecursorIonScan
						]]
					]
				];


				(*Add a judgement ranged Mass scan boolean here. *)
				rangedMassScanQ=MatchQ[resolvedScanMode,(FullScan|PrecursorIonScan|NeutralIonLoss|ProductIonScan)];
				rangedMS1MassScanQ=MatchQ[resolvedScanMode,(FullScan|PrecursorIonScan|NeutralIonLoss)];
				tandemMassQ=!MatchQ[resolvedScanMode,(FullScan|SelectedIonMonitoring)];

				(* define our default mass ranges *)
				lowRange=Span[5 *Gram/Mole, 1250 *Gram/Mole];
				highRange=Span[500 *Gram/Mole, 2000 *Gram/Mole];

				(*Use a helper function to help us figure out what default mass selection value we should give our user*)
				defaultMassSelectionValue=If[
					MatchQ[Min[molecularWeights],RangeP[5*Gram/Mole,1998*Gram/Mole]],
					If[
						positiveIonModeQ,
						(Min[molecularWeights]+1*Gram/Mole),
						(Min[molecularWeights]-1*Gram/Mole)
					],
					500*Gram/Mole
				];

				(* Resolve MassDetection, here the legacy code used massRange and we didn't chenge it*)
				massRange=If[
					MatchQ[suppliedMassRange,Except[Automatic]],

					(*If user specified a value, we use what user specified, we will check if this value is conflict with other options*)
					suppliedMassRange,

					(*Resolve Automatic Mass detection input*)
					Which[
						(*For thos mass scan mode require MS1 as a ranged mass input, resolved it based on sample's category and molecular weight*)
						rangedMS1MassScanQ, Switch[
						{sampleCategory,Mean[molecularWeights]},
							{Peptide,_},lowRange,
							{_,RangeP[100*Gram/Mole,1250*Gram/Mole]},lowRange,
							{_,RangeP[500*Gram/Mole,2000*Gram/Mole]},highRange,
							_,lowRange
						],

						(*If user specified multiple reaction monitoring assays options, we resolved it based on what user specified*)
						MatchQ[suppliedMultipleReactionMonitoringAssay,Except[Automatic]],suppliedMultipleReactionMonitoringAssay[[All,1]],

						(*For thos mass scan mode require MS1 as a ranged mass input, resolved it based on sample's and molecular weight*)
						(*If its Mininum MW fall into detection range, we use its protonated or deprotonated value (Positive or Negative value)*)

						MatchQ[resolvedScanMode,SelectedIonMonitoring|MultipleReactionMonitoring|ProduectIonScan],{defaultMassSelectionValue},
						True,defaultMassSelectionValue
					]
				];


				(* -- Resolve calibrant -- *)
				(* For ESI-QQQ, since the mass range is narrow, and the calibrant we have POS PPG and NEG PPG can cover entire masss range, so it will be resolved by the ion mode*)
				calibrant=Switch[{suppliedCalibrant,ionMode},
					{Except[Automatic],_},suppliedCalibrant,
					{Automatic,Positive},Model[Sample,StockSolution,Standard,"POS PPG, 2E-7M (0.2 microMolar or 500:1), SciEX Standard"], (*id:zGj91a7DEKxx*)
					{Automatic,Negative},Model[Sample,StockSolution,Standard,"NEG PPG, 3E-5M (30 microMolar or stocksolution), SciEX Standard"], (*id:mnk9jOR70aJN*)
					{_,_},Model[Sample,StockSolution,Standard,"POS PPG, 2E-7M (0.2 microMolar or 500:1), SciEX Standard"] (*Catch all with positive low concentration standard*)
				];


				(* Get the packet associated with the resolved calibrant *)
				calibrantPacket=If[validCalibrantQ,findModelPacketFunction[calibrant,calibrantSamplePackets,relevantCalibrantModelPackets],{}];

				(* figure out whether the calibrant peaks cover the requested mass range*)
				(* we don't bother if we've already thrown a calibrant error, or we have resolved the calibrant for the user, our calibrants can cover fullrange. *)
				calibrantMassRangeMismatch=If[(ionSourceCalibrantMismatchBool||!maxMassSupportedBool||MatchQ[suppliedCalibrant,Automatic]),
					False,
					(* Otherwise we do the following checks *)
					(* In this case we need to check whether the mass range is suitable (we allow the mass range to be 25% above or below the highest and lowest mass of the calibrant *)
					Module[{calibrantMasses,minCalibrant,maxCalibrant,minMass,maxMass,edgeBuffer,lowerEdge,higherEdge},

						calibrantMasses=If[positiveIonModeQ,Lookup[calibrantPacket,ReferencePeaksPositiveMode],Lookup[calibrantPacket,ReferencePeaksNegativeMode]];

						{minCalibrant,maxCalibrant}={Min[calibrantMasses],Max[calibrantMasses]};
						{minMass,maxMass}=Switch[massRange,
							{UnitsP[Gram/Mole] ..},{Min[massRange],Max[massRange]},
							_Span,List@@massRange,
							_,{massRange,massRange}
						];

						(* calculate the lower and the higher end of a mass range that we would still be OK with *)
						edgeBuffer=25 Percent;
						lowerEdge=minCalibrant-UnitScale[edgeBuffer*minCalibrant];
						higherEdge=maxCalibrant+UnitScale[edgeBuffer*maxCalibrant];

						If[minMass<lowerEdge||maxMass>higherEdge,
							True,
							False
						]
					]
				];

				(*Resolve MassTolerance Here*)
				{resolvedMassTolerance,invalidMassToleranceBoolean}=Switch[{suppliedMassTolerance,rangedMassScanQ},

					(*Use user specified value, if the we are not using ranged scan mode, return the error checker as error*)
					{Except[Automatic],True},{suppliedMassTolerance,False},
					{Except[Automatic],False},{suppliedMassTolerance,True},

					(*For Ranged MassScan and resolved the Automatic to 0.1 g/mole*)
					{_,True}, {0.1*Gram/Mole,False},

					(*For Selected MassScan and resolved the Automatic to Null*)
					{_,False}, {Null,False}

				];


				(*Resolve Fragment Mass Detection*)

				resolvedFragmentMassDetection=If[
					MatchQ[suppliedFragmentMassDetection,Except[Automatic]],

					(* if user specified this value, we used this value*)
					suppliedFragmentMassDetection,

					(*Resolve Automatic options*)
					If[
						!tandemMassQ,
						(*Resolved the Automatic to Null if we are not using Tandem Mass Scan*)
						Null,

						(*In tandem mass scan*)
						Switch[resolvedScanMode,
							(*For Product Ion Scan, resolve the automatic options to lowrange*)
							ProductIonScan,lowRange,

							(*For MultipleReactionMonitoring mode*)
							MultipleReactionMonitoring,If[MatchQ[suppliedMultipleReactionMonitoringAssay,Except[Automatic]],

							(*First we check if user specified MultipleReactionMonitoring Assays*)
								suppliedMultipleReactionMonitoringAssay[[All,3]],

							(*we arbitarily resolved it to detect the dehydration product of the mass detection*)
								(massRange-18*Gram/Mole)],

							(*For PrecursorIonScan, give it a arbitary value, throw an error in the later section*)
							PrecursorIonScan, 500*Gram/Mole,

							(*For NeutralLoss, Resolved it to the MassDetection value*)
							NeutralIonLoss, massRange
						]
					]

				];


				(* If we are not running tandem mass scan (i.e. we are in FullScan or SelectedIonMonitoring Scan) the tandem Mass relevant options should be in Null or Automatic *)
				unneededTandemMassSpecOptionList=Module[{tandemMassRelevantOptionValues,tandemMasRelevantOptionNames,tandemOptionBooleans},
					tandemMassRelevantOptionValues={
						suppliedCollisionEnergy,
						suppliedCollisionCellExitVoltage,
						suppliedNeutralLoss,
						suppliedMultipleReactionMonitoringAssay,
						suppliedFragmentMassDetection
					};
					tandemMasRelevantOptionNames={
						CollisionEnergy,
						CollisionCellExitVoltage,
						NeutralLoss,
						MultipleReactionMonitoringAssays,
						FragmentMassDetection
					};

					(* determine which samples and which options are unneeded, if we have any options that aren't Automatic or Null *)
					tandemOptionBooleans=(!MatchQ[#,Null|Automatic])& /@ tandemMassRelevantOptionValues;

					(*Check if we are in TandemMass mode if yes return the unneccessary option name list*)
					If[tandemMassQ,
						{},
						PickList[tandemMasRelevantOptionNames,tandemOptionBooleans]
					]
				];

				(*Return a Boolean for this unneededOptions*)
				unneededTandemMassSpecOptionBoolean=(Length[unneededTandemMassSpecOptionList]>0);

				(* For Dwell Time, NeutralLoss and MultipleReactionMonitoring these options only required in one or two specific scan modes, we collect them in a single option list. *)
				unneededScanModeSpecifOptionList=Module[{scanModeSpecificOptionNames,unneededNeutralLossBoolean,unneededMultipleReactionMonitoringBoolean,
					unneededDwellTimeBoolean,unneededScanModeBooleans,unneededCollisionEnergyBoolean},
					scanModeSpecificOptionNames={
						NeutralLoss,
						MultipleReactionMonitoringAssays,
						DwellTime,
						CollisionEnergy
					};

					(*For NeutralLoss option, if the scanmode is not NutralIonLoss, then its value needs to be Automatic or Null, if not throw a error checker*)
					(*Only when MatchQ[scanMode,NeutralIonLoss] and MatchQ[suppliedNeutralLoss,(Automatic|Null)] are both false, give a true. *)
					unneededNeutralLossBoolean=!Or[MatchQ[resolvedScanMode,NeutralIonLoss],MatchQ[suppliedNeutralLoss,(Automatic|Null)]];

					(*For MultipleReactionMonitoringAssays option, if the scanmode is not MultipleReactionMonitoring, then its value needs to be Automatic or Null, if not throw a error checker*)
					unneededMultipleReactionMonitoringBoolean=!Or[MatchQ[resolvedScanMode,MultipleReactionMonitoring],MatchQ[suppliedNeutralLoss,(Automatic|Null)]];

					(*For Dwell option, if the scanmode is not SelectedIonMonitoring or SelectedReactionMonitoring Mode, then its value needs to be Automatic or Null, if not throw a error checker*)
					unneededDwellTimeBoolean=!Or[MatchQ[resolvedScanMode,(SelectedIonMonitoring|MultipleReactionMonitoring)],MatchQ[suppliedNeutralLoss,(Automatic|Null)]];

					(*For CollisionEnergy, if the scanmode is MultipleReactionMonitoring Mode, then its value needs to be Automatic or Null, if not throw a error checker*)
					unneededCollisionEnergyBoolean=!Or[MatchQ[resolvedScanMode,MultipleReactionMonitoring],MatchQ[suppliedCollisionEnergy,(Automatic|Null)]];

					(*Generate a list of booleans*)
					unneededScanModeBooleans={unneededNeutralLossBoolean,unneededMultipleReactionMonitoringBoolean,unneededDwellTimeBoolean,unneededCollisionEnergyBoolean};

					(*Return the list*)
					PickList[scanModeSpecificOptionNames,unneededScanModeBooleans]
				];

				(*Return a Boolean for this unneeded scan mode specifie Options*)
				unneededScanModeSpecifOptionBoolean=(Length[unneededScanModeSpecifOptionList]);


				(*Resolve CollisionEnergy*)
				resolvedCollisionEnergy=If[

					(* If user specified a value, we use  what user specified and will check for conflict in later section*)
					MatchQ[suppliedCollisionEnergy,Except[Automatic]],

					(* If user specified a list of input mass detection values, but specified only a single collision energy value, we assume this collision value will applied to all detections, thereby we expand it*)
					If[
						MatchQ[massRange,{UnitsP[Gram/Mole] ..}]&&MatchQ[suppliedCollisionEnergy,{UnitsP[Volt]}],
						ConstantArray[First[suppliedCollisionEnergy],Length[massRange]],

						(* In all other cases we use what user specified, we will check if the length of each input are the same in below*)
						suppliedCollisionEnergy
					],


					(*Resolve automatic option input.*)
					(*Resolve it to Null if we are not gonna use Fragment*)
					Which[
						(*Resolved it to Null if it's not in Tandem Mass Spec Mode*)
						!resolvedFragmentBoolean, Null,

						(*If user specified MultipleReactionAssays, we check user specified value and resolved those are Automatic*)
						MatchQ[suppliedMultipleReactionMonitoringAssay,Except[Automatic]],
						Map[
							Function[eachCollisionEnergy,
								If[
									MatchQ[eachCollisionEnergy, Except[Automatic]],
									eachCollisionEnergy,
									If[positiveIonModeQ, 40*Volt, -40*Volt]
								]
							],
						suppliedMultipleReactionMonitoringAssay[[All,2]]
						],


						(*Otherwise resolved it based on input massRange type*)
						(*for single massDetection input, give it a single value*)
						MatchQ[massRange,_Span|UnitsP[Gram/Mole]], If[positiveIonModeQ,40*Volt,-40*Volt],

						(*For a list of inputs, give it a ConstantAssay*)
						True,If[positiveIonModeQ,ConstantArray[40*Volt, Length[massRange]],ConstantArray[-40*Volt, Length[massRange]]]

					]
				];

				(*Resolved dwelltime*)
				resolvedDwellTime=If[

					(* If user specified a value, we use  what user specified and will check for conflict in later section*)
					 MatchQ[suppliedDwellTime,Except[Automatic]],
						If[
						(* If user specified a list of input mass detection values, but specified only a single dwell time value, we assume this dwell time will applied to all detections, thereby we expand it*)
						MatchQ[massRange,{UnitsP[Gram/Mole] ..}]&&MatchQ[suppliedDwellTime,{TimeP}],
						ConstantArray[First[suppliedDwellTime],Length[massRange]],

						(* In all the other cases we use what user specified us, will check if there is a mis match in the later section*)
						suppliedDwellTime
					],

					(*Resolve automatic option input.*)
					(*Resolve it to Null if we are not gonna use Fragment*)
					Which[
						(*Resolved it to Null if it's not in Tandem Mass Spec Mode*)
						!MatchQ[resolvedScanMode,SelectedIonMonitoring|MultipleReactionMonitoring], Null,

						(*If user specified MultipleReactionAssays, we check user specified value and resolved those are Automatic*)
						MatchQ[suppliedMultipleReactionMonitoringAssay,Except[Automatic]],
						Map[
							Function[eachDwellTime,
								If[
									MatchQ[eachDwellTime, Except[Automatic]],
									eachDwellTime,
									200*Millisecond
								]
							],
							suppliedMultipleReactionMonitoringAssay[[All,4]]
						],


						(*Otherwise resolved it based on input massRange type*)
						(*for single massDetection fixed valueinput, give it a single value*)
						MatchQ[massRange,UnitsP[Gram/Mole]], 200*Millisecond,

						(*For a list of inputs, give it a ConstantAssay*)
						True,ConstantArray[200*Millisecond, Length[massRange]]

					]
				];


				(*Resolve MultipleReactionMonitoringAssay Here*)
				resolvedMultipleReactionMonitoringAssay=Which[

					(* If fully user-specified, use that value *)
					!MemberQ[ToList[suppliedMultipleReactionMonitoringAssay], Automatic, Infinity], suppliedMultipleReactionMonitoringAssay,

					(* If the scan mode does not allow for MultipleReactionMonitoring, resolve this option to Null *)
					MatchQ[resolvedScanMode, Except[MultipleReactionMonitoring]], Null,

					(* Otherwise, for MultipleReactionMonitoring scan mode, if MultipleReactionMonitoringAssays or its sub-options were Automatic, these values were resolved above, reconstruct them into an list of ordered lists *)
					True, Transpose[PadRight[{ToList[massRange],ToList[resolvedCollisionEnergy],ToList[resolvedFragmentMassDetection],ToList[resolvedDwellTime]},{4,Length[ToList[massRange]]},Null]]
				];


				(*Resolve CollisionCellExitVoltage*)
				resolvedCollisionCellExitVoltage=Switch[{tandemMassQ,suppliedCollisionCellExitVoltage,ionMode},
					(*If we are not in Tandem mass scan mode, resolve automatic values to Null*)
					{False,Automatic,_},Null,

					(*If we are not in Tandem mass scan mode, and user specified a value, we will use user specified value, we have checked if this one should be null in above*)

					{False,Except[Automatic],_},suppliedCollisionCellExitVoltage,

					(*Resolve Automatic options based on ionMode, if we are in Tandem Mass Scan mode*)
					{_,Automatic,Positive},15*Volt,
					{_,Automatic,_},-15*Volt,

					(*If user specified a value, we use user specified value, will check if this value matches ion mode along with other voltages input*)
					{_,Except[Automatic],_},suppliedCollisionCellExitVoltage

				];


				(*Resolved NeutralLoss and throw warning for automatic resolved value*)
				{resolvedNeutralLoss,autoNeutralLossValueWarning}=Switch[{resolvedScanMode,suppliedNeutralLoss},
					(*Catch all with user specified options, we checked if this options is valid in above.*)
					{_,Except[Automatic]},{suppliedNeutralLoss,False},

					(*If we are not in NeutralIonLoss scan mode, resolve automatic values to Null*)
					{Except[NeutralIonLoss],Automatic},{Null,False},

					(*If we are not in SelectedIonMonitoring mass scan mode, and user specified a value, we will use user specified value, we have checked if this one should be null in above*)
					{Except[NeutralIonLoss],_},{suppliedNeutralLoss,False},

					(*Throw a random value for this and trow a warning message*)
					{_,_},{50*Gram/Mole,True}

				];

				(*Resolved the conflicts between Fragment and ScanMode*)
				fragmentScanModeMisMatch=Xor[resolvedFragmentBoolean,tandemMassQ];

				(*Resolve the conflicts between voltages inputs (ESICapillaryVoltage, DeclusteringVoltage, IonGuidVoltage ,CollisionEnergy, CollisionCellExitingVoltage) and IonMode*)
				invalidVoltagesOptionList=Module[
					{
						relaventOptionNotListedValues,relaventOptionNotListedNames,voltageOptionNotListedBooleans,
						relaventOptionListedValues,relaventOptionListedNames,relaventOptionNames,voltageOptionListedBooleans,voltageOptionBooleans
					},

					(*Collect voltages input values and names that are not listed*)
					relaventOptionNotListedValues={
						(*1*)resolvedCapillaryVoltage,
						(*2*)resolvedDeclusteringVoltage,
						(*3*)resolvedIonGuideVoltage,
						(*4*)resolvedCollisionCellExitVoltage
					};
					relaventOptionNotListedNames={
						(*1*)ESICapillaryVoltage,
						(*2*)DeclusteringVoltage,
						(*3*)IonGuideVoltage,
						(*4*)CollisionCellExitingVoltage
					};

					(*Collect voltages values and names that can be*)
					relaventOptionListedValues={
						(*1*)If[MatchQ[resolvedCollisionEnergy,_List],resolvedCollisionEnergy,{resolvedCollisionEnergy}]
					};
					relaventOptionListedNames={
						(*1*)If[MatchQ[resolvedCollisionEnergy,_List],ConstantArray[CollisionEnergy,Length[resolvedCollisionEnergy]],{CollisionEnergy}]
					};

					(*For those nolisted options check if they matched the ionmode and pick those mismatched options out.*)
					voltageOptionNotListedBooleans=If[positiveIonModeQ,
						(*For positive ion mode, we picked those voltages input is <0 Volt*)
						MatchQ[#,LessP[0*Volt]]&/@ relaventOptionNotListedValues,
						MatchQ[#,GreaterP[0*Volt]]&/@ relaventOptionNotListedValues
					];

					voltageOptionListedBooleans=If[positiveIonModeQ,
						(*For positive ion mode, we picked those voltages input is <0 Volt*)
						MatchQ[#,LessP[0*Volt]]&/@ Flatten[relaventOptionListedValues],
						MatchQ[#,GreaterP[0*Volt]]&/@ Flatten[relaventOptionListedValues]
					];

					relaventOptionNames=Flatten@Join[relaventOptionNotListedNames,relaventOptionListedNames];
					voltageOptionBooleans=Flatten@Join[voltageOptionNotListedBooleans,voltageOptionListedBooleans];

					DeleteDuplicates[PickList[relaventOptionNames,voltageOptionBooleans]]
				];

				voltageInputIonModeMisMatch=(Length[invalidVoltagesOptionList]>0);

				(*Check if mass detection and fragment mass detection didn't matched the scan mode *)
				massDetectionScanModeMisMatch=Which[
					(*For ranged MS1 scan, check if massRange is a Span if not, throw a error checker*)
					rangedMS1MassScanQ, !MatchQ[massRange,_Span],

					(*For ProductIonScan, check if massRange is a single value, otherwise throw a error checker*)
					MatchQ[resolvedScanMode,ProductIonScan], !MatchQ[massRange,{UnitsP[Gram/Mole]}|UnitsP[Gram/Mole]],

					(*For ProductIonScan, check if massRange is a single value, otherwise throw a error checker*)
					True, (!MatchQ[massRange,UnitsP[Gram/Mole]|{UnitsP[Gram/Mole] ..}])
				];

				(*Throw a warning if we have to auto resolved the mass values with a fixed value*)
				autoResolvedMassDetectionFixedValueWarnings=And[
					!rangedMS1MassScanQ,
					MatchQ[suppliedMassRange,Automatic],
					MatchQ[suppliedMultipleReactionMonitoringAssay,Automatic|Null]
				];


				(*Check if the fragment mass detection and regular mass detection has a mis match*)
				fragmentMassDetectionScanModeMisMatch=Which[

					!tandemMassQ,MatchQ[resolvedFragmentMassDetection,Except[Null]],
					(*For ProductIonScan, check if framentMassDetection is a Span, if not, throw a error checker*)
					MatchQ[resolvedScanMode,ProductIonScan], !MatchQ[resolvedFragmentMassDetection,_Span],

					(*For PrecursorIonScan, check if framentMassDetection is a single value, otherwise throw a error checker*)
					MatchQ[resolvedScanMode,PrecursorIonScan], !MatchQ[resolvedFragmentMassDetection,{UnitsP[Gram/Mole]}|(UnitsP[Gram/Mole])],

					(*For PrecursorIonScan, check if framentMassDetection is the same as input mass scan*)
					MatchQ[resolvedScanMode,NeutralIonLoss], !MatchQ[resolvedFragmentMassDetection,_Span],

					(*For  MultipleReactionMonitoring, check if FragmengMassRange is a single value, otherwise throw a error checker*)
					True, (!MatchQ[resolvedFragmentMassDetection,UnitsP[Gram/Mole]|{UnitsP[Gram/Mole] ..}])
				];


				(*Throw a warning if we have to auto resolved the fragment mass values with a fixed value*)
				autoResolvedFragmentMassDetectionFixedValueWarning=And[
					MatchQ[resolvedScanMode,(MultipleReactionMonitoring|PrecursorIonScan)],
					MatchQ[suppliedFragmentMassDetection,Automatic],
					MatchQ[suppliedMultipleReactionMonitoringAssay,Automatic|Null]
				];

				(*Generate how many mass detection values for this samplw we have*)
				numberOfMassInputs=Length[ToList[massRange]];

				(*Check if we have same number of inputs for those options with an adder*)
				invalidLengthOfInputOptionList=Module[
					{
						relaventOptionNotListedNames, finalBooleanList,
						relaventOptionNotListedOptions
					},

					relaventOptionNotListedOptions={
						(*1*)resolvedCollisionEnergy,
						(*2*)resolvedFragmentMassDetection,
						(*3*)resolvedDwellTime
					};

					relaventOptionNotListedNames={
						(*1*)CollisionEnergy,
						(*2*)FragmentMassDetection,
						(*3*)DwellTime
					};
					finalBooleanList=If[MatchQ[#,Null],False,!((Length[ToList[#]])===numberOfMassInputs)]&/@relaventOptionNotListedOptions;

					(*Out put which option does not have same length as the mass detection input*)
					PickList[relaventOptionNotListedNames,finalBooleanList]
				];

				invalidLengthOfInputOptionBoolean=(Length[invalidLengthOfInputOptionList]>0);


				(*If user specified both regular options (MassDetection,CollisionEnergy,FragmentMassDetection and DwellTime), and MultipleReactionMonitoringAssays, check if they are same.*)
				inputOptionsMRMAssaysMisMatchedOptionList=Module[
					{
						relaventOptionNotListedNames,
						relaventOptionNotListedOptions,
						finalBooleanList
					},

					relaventOptionNotListedOptions={
						massRange,
						resolvedCollisionEnergy,
						resolvedFragmentMassDetection,
						resolvedDwellTime
					};
					relaventOptionNotListedNames={
						MassDetection,
						CollisionEnergy,
						FragmentMassDetection,
						DwellTime
					};
					finalBooleanList=If[
						(* If we are using a different scan mode or had the MRM Assay option as Automatic skip this check *)
						Or[MatchQ[resolvedScanMode,Except[MultipleReactionMonitoring]],MatchQ[suppliedMultipleReactionMonitoringAssay,Automatic]],
						ConstantArray[False,4],
						(*Otherwise check if the MRM Assay option allows for the resolved options (or matches or was given as Automatic)*)
						(*This happens if the user supplied options for MassDetection, CollisionEnergy, FragmentMassDetection, DwellTime that are mismatched with the indicies of MRM Assay option *)
						MapThread[
							Function[
								{eachOption,eachMRMOption},
								!MatchQ[eachMRMOption,Alternatives[ToList[eachOption], {Automatic...}]]
							],
							{relaventOptionNotListedOptions,
							Transpose[suppliedMultipleReactionMonitoringAssay]}
						]
					];
					PickList[relaventOptionNotListedNames,finalBooleanList]
				];

				(*if invalidLengthOfInputOptionBoolean is True, we won't throw additional error*)
				inputOptionsMRMAssaysMisMatch=If[invalidLengthOfInputOptionBoolean,False,(Length[inputOptionsMRMAssaysMisMatchedOptionList]>0)];


				(*Resolved ScanTime *)
				resolvedScanTime = Which[
					MatchQ[suppliedScanTime,Except[Automatic]], suppliedScanTime,
					(* If ScanMode is FullScan, resolve to quickest possible ScanTime which is dependant on the MassRange and MassTolerance options *)
					MatchQ[resolvedScanMode, FullScan], ((massRange[[2]] - massRange[[1]])/resolvedMassTolerance + 1) * 3 Microsecond,
					(* Otherwise, set ScanTime to 5 Millisecond *)
					True, 5*Millisecond
				];

				(* Check for an Invalid Scan Time *)
				invalidScanTime = Which[
					MatchQ[resolvedScanMode, FullScan] && Or[resolvedScanTime > ((massRange[[2]] - massRange[[1]])/resolvedMassTolerance + 1) * 5 Second, resolvedScanTime < ((massRange[[2]] - massRange[[1]])/resolvedMassTolerance + 1) * 3 Microsecond], True,
					(* Otherwise, the scan time is valid *)
					True, False
				];

				(*Resolved RunDuration*)
				resolvedRunDuration=If[MatchQ[suppliedRunDuration,Except[Automatic]],
					suppliedRunDuration,
					2*Minute
				];

				(*Too many MRM assays, generally user can specified as many MRM assays as possible, but too many MRM assays will cause too long analysis time *)
				(* we throw a warning checker here if user specified to many MRM Assasy*)

				tooManyMultpleReactionMonitoringAssayWarning=If[
					MatchQ[resolvedMultipleReactionMonitoringAssay,Null],
					False,
					Length[resolvedMultipleReactionMonitoringAssay]>10
				];


				(* RunDuration should be long enough for each sample run, this should be a error checker*)
				(* Return boolean and run time for each cycle*)
				{tooShortRunDurationBoolean,cycleRunDuration}=Module[{eachRunTime,massRangeRunTime},

					(*A short helper function to help calculate the time needed for each run, if we scan mass in range*)

					massRangeRunTime[inputMassSpan_Span] := ((Max[List @@ inputMassSpan] - Min[List @@ inputMassSpan])/(200*Gram/(Mole*Second)));

					(*Resolve how long we need for each run*)
					eachRunTime=Switch[{resolvedDwellTime,massRange,resolvedFragmentMassDetection},

						(*If DwellTime has specified, count the dwellTime + ScanTime*)
						{Except[Null],_,_},(Total[ToList[resolvedDwellTime]]+resolvedScanTime*Length[ToList[resolvedDwellTime]]),

						(*For ranged mass detection, used the helperfunction to find out how long for each scan we need.*)
						{_,_Span,_},(massRangeRunTime[massRange]+resolvedScanTime),

						{_,_,_Span},(massRangeRunTime[resolvedFragmentMassDetection]+resolvedScanTime),

						(*Catch all with return only resolvedScanTime*)
						{_,_,_},resolvedScanTime

					];
					(*Return the boolean of if each RunTime is smaller than resolved RunDuration*)
					{!(eachRunTime<resolvedRunDuration),eachRunTime}
				];


				(*resolve InfusionFlowRate*)
				resolvedInfusionFlowRate=If[MatchQ[suppliedInfusionFlowRate,Except[Automatic]],
					suppliedInfusionFlowRate,
					10*(Microliter/Minute)
				];

				(*Calculate the minimum amount of solution we need to finished the solution *)
				(* we calculate a value based on resolved RunDuration and InfusionFlowrate, we give two more minutes in RunDuration to allow operation *)
				minAmountSampleForExperiment=((resolvedRunDuration+2*Minute)*resolvedInfusionFlowRate);

				simulatedVolume=Lookup[simulatedSamplePacket,Volume];

				(*Resolve Infusion Volume here*)
				resolvedInfusionVolume=If[
					MatchQ[suppliedInfusionVolume,Except[Automatic]],
					suppliedInfusionVolume,
					(*Resolved this volume to to null if the injection type is flow injection*)
					If[
						flowInjectionQ,
						Null,
						If[MatchQ[suppliedInfusionVolume,Except[Automatic]],
							suppliedInfusionVolume,

							(* Resolve automatic value based on RunDuration and flowrate *)
							(* We also check if this value is higher than 0.5 mL, if not, we use 0.5 mL*)
							If[(minAmountSampleForExperiment<(0.5 Milliliter))&&(minAmountSampleForExperiment<simulatedVolume),
								If[simulatedVolume>0.5Milliliter,
									0.5Milliliter,
									simulatedVolume
								],
								minAmountSampleForExperiment
							]
						]
					]
				];

				(* Check resolved RunDuration relative to resolved InfusionVolume and resolved InfusionFlowRate *)
				runDurationExceedsInfusionOptionsBoolean = If[
					(* If DirectInfusion and the RunDuration is longer than the InfusionVolume over InfusionFlowRate *)
					!flowInjectionQ && resolvedRunDuration > resolvedInfusionVolume / resolvedInfusionFlowRate,
					(* Set runDurationExceedsInfusionOptionsBoolean to True *)
					True,
					(* Otherwise, set to False *)
					False
				];

				(*Resolve Infusion Syringe*)
				resolvedInfusionSyringe=If[
					MatchQ[suppliedInfusionSyringe,Except[Automatic]],
					suppliedInfusionSyringe,
					(* Check if the injection type is FlowInjection, if it is, resolve this option to Null*)
					If[
						flowInjectionQ,
						Null,

					(* If the injection type is DirectInfusion, go ahead to resolve this *)
						If[MatchQ[suppliedInfusionSyringe,Except[Automatic]],
							(*User specified syringe *)
							suppliedInfusionSyringe,
							(*Resolve default syringe type based on resolved infusion volume*)
							Switch[resolvedInfusionVolume,
								RangeP[0*Milliliter,0.99*Milliliter],Model[Container, Syringe, "1mL All-Plastic Disposable Syringe"],(*"id:o1k9jAKOww7A"*)
								RangeP[1.00*Milliliter,2.99*Milliliter],Model[Container, Syringe, "3mL Sterile Disposable Syringe"],(*"id:01G6nvkKrrKY"*)
								RangeP[3.00*Milliliter,4.99*Milliliter],Model[Container, Syringe, "5mL Sterile Disposable Syringe"],(*"id:P5ZnEj4P88P0"*)
								RangeP[5.0*Milliliter,10*Milliliter],Model[Container, Syringe, "10mL Syringe"](*"id:4pO6dMWvnn7z"*)
							]
						]
					]
				];


				(*Collect syringePacket from all syringe packet *)
				syringePacket = If[
					MatchQ[resolvedInfusionSyringe,ObjectP[Object[Container,Syringe]]],
					fetchPacketFromCache[Download[Lookup[fetchPacketFromCache[resolvedInfusionSyringe,Flatten[syringeModelPacket]],Model],Object],Flatten[allSyringePackets]],
					fetchPacketFromCache[Download[resolvedInfusionSyringe,Object],Flatten[allSyringePackets]]
				];


				(*Collect the Model of the input syringe, if user specified a Object[Container,Syringe]*)
				resolvedInfusionSyringeModel=If[
					(* Check if the injection type is FlowInjection, if it is, resolve this option to {}*)
					flowInjectionQ,
					{},

					(* If the injection type is DirectInfusion, go find the model of the input syringe *)
					If[MatchQ[resolvedInfusionSyringe,ObjectP[Model[Container,Syringe]]],
						Download[resolvedInfusionSyringe,Object],
						Download[resolvedInfusionSyringe,Model[Object]]
					]
				];

				(*Check if resolvedSyringe is allowed by our instrument*)
				invalidInfusionSyringeBoolean=If[
					(* Check if the injection type is FlowInjection, if it is, resolve this option to False*)
					flowInjectionQ,
					False,
					(* Else check if the syringe model is one of our allowed syringe models*)
					!MatchQ[resolvedInfusionSyringeModel,allowedSyringeModelsP]
				];


				(*Collect info for conflicts checking*)
				{syringeMaxVolume,syringeMinVolume,syringeDeadVolume}= If[Or[flowInjectionQ,invalidInfusionSyringeBoolean],ConstantArray[0 Milliliter,3],Lookup[syringePacket,{MaxVolume,MinVolume,DeadVolume}]/.(Null->0Milliliter)];


				(* the max volume we can infuse by DirectInfusion.*)
				syringeMaxInfusionVolume=Min[(syringeMaxVolume-syringeDeadVolume),(simulatedVolume/.(Null->0Milliliter))];

				(*Check if infusion volume is conflicting with the syringe.*)
				invalidInfusionVolumeBoolean=If[
					(*Skip this check for flowinjeciton, infusionSyringe is not allowed or where sample voluem is null*)
					Or[flowInjectionQ,NullQ[simulatedVolume],invalidInfusionSyringeBoolean],
					False,
					(* make sure the infusionVolume is within the volume range of the syringe and smaller than the sample volume*)
					!MatchQ[resolvedInfusionVolume,RangeP[syringeMinVolume,syringeMaxInfusionVolume]]
				];



				(* return the single resolved values for this sample we're mapping over *)
				{
					(*1*)ionMode,
					(*2*)calibrant,
					(*3*)massRange,
					(*4*)resolvedCapillaryVoltage,
					(*5*)resolvedDeclusteringVoltage,
					(*6*)resolvedDesolvationTemperature,
					(*7*)resolvedDesolvationGasFlow,
					(*8*)injectionVolume,
					(*9*)calibrantMassRangeMismatch,
					(*10*)transferRequiredWarning,
					(*11*)resolvedIonGuideVoltage,
					(*12*)resolvedInfusionVolume,
					(*13*)invalidInfusionVolumeBoolean,
					(*14*)resolvedInfusionSyringe,
					(*15*)invalidInfusionSyringeBoolean,
					(*16*)invalidSourceTemperatureBoolean,
					(*17*)invalidDesolvationGasFlowBoolean,
					(*18*)invalidConeGasFlowBoolean,
					(*19*)resolvedScanTime,
					(*20*)resolvedRunDuration,
					(*21*)resolvedScanMode,
					(*22*)resolvedMassTolerance,
					(*23*)resolvedFragmentMassDetection,
					(*24*)resolvedDwellTime,
					(*25*)resolvedFragmentBoolean,
					(*26*)resolvedCollisionEnergy,
					(*27*)resolvedCollisionCellExitVoltage,
					(*28*)resolvedNeutralLoss,
					(*29*)resolvedMultipleReactionMonitoringAssay,
					(*30*)invalidMassToleranceBoolean,
					(*31*)fragmentScanModeMisMatch,
					(*32*)massDetectionScanModeMisMatch,
					(*33*)fragmentMassDetectionScanModeMisMatch,
					(*34*)unneededTandemMassSpecOptionList,
					(*35*)unneededTandemMassSpecOptionBoolean,
					(*36*)unneededScanModeSpecifOptionList,
					(*37*)unneededScanModeSpecifOptionBoolean,
					(*38*)requiredScanModeSpecifOptionList,
					(*39*)invalidVoltagesOptionList,
					(*40*)voltageInputIonModeMisMatch,
					(*41*)multipleReactionMonitoringVoltagesIonModeMisMatch,
					(*42*)invalidMultipleReactionMonitoringVoltagesOptionList,
					(*43*)tooManyMultpleReactionMonitoringAssayWarning,
					(*44*)tooShortRunDurationBoolean,
					(*45*)cycleRunDuration,
					(*46*)autoNeutralLossValueWarning,
					(*47*)invalidLengthOfInputOptionList,
					(*48*)invalidLengthOfInputOptionBoolean,
					(*49*)inputOptionsMRMAssaysMisMatchedOptionList,
					(*50*)inputOptionsMRMAssaysMisMatch,
					(*51*)autoResolvedMassDetectionFixedValueWarnings,
					(*52*)autoResolvedFragmentMassDetectionFixedValueWarning,
					(*53*)massInCalibrantRangeBool,
					(*54*)validCalibrantQ,
					(*55*)syringeMinVolume,
					(*56*)syringeMaxInfusionVolume,
					(*57*)invalidScanTime,
					(*58*)runDurationExceedsInfusionOptionsBoolean
				}
			]
		],
			{
				(*1*)simulatedSamplePackets,
				(*2*)simulatedSampleIdentityModelPackets,
				(*3*)mySimulatedSamples,
				(*4*)simulatedSampleContainerModels,
				(*5*)mapThreadFriendlyOptions,
				(*6*)suppliedAliquotContainers,
				(*7*)unresolvedAliquotContainerModels,
				(*8*)sampleCategories,
				(*9*)sampleMolecularWeights,
				(*10*)impliedAliquotBools,
				(*11*)suppliedAliquotVolumes,
				(*12*)infusionFlowRates,
				(*13*)simulatedVolumes,
				(*14*)ionSourceCalibrantMismatchBooleans,
				(*15*)maxMassSupportedBools,
				(*16*)myFilteredAnalytePackets
			}
		]
	];

	(* -- UNRESOLVABLE OPTION CHECKS -- *)

	(* -- check for calibrantMassRangeMismatches -- *)

	(* -- check if we have too many calibrants, we will only run 1 each calibrant for each ion mode in direct infustion, and only 1 for the flow injection. *)
	(* -- If user specified more than 1 calibrants we will also only run 1*)
	allCalibrantModels=MapThread[
		If[
			(*If the calibrant is not valid, we skip this check and return a empty list.*)
			#1,
			Lookup[findModelPacketFunction[#2,calibrantSamplePackets,relevantCalibrantModelPackets],Object],
			{}
		]&,
		{validCalibrantBools,calibrants}
	];

	defaultCalibrantP=(Model[Sample, StockSolution, Standard, "id:zGj91a7DEKxx"]|Model[Sample, StockSolution, Standard, "id:mnk9jOR70aJN"]);

	(* --- Check how many non-default calibrants were specified by user ---*)
	nonDefaultCalibrants=Cases[allCalibrantModels,Except[defaultCalibrantP]];
	nonDefaultCalibrantBools=MatchQ[#,defaultCalibrantP]&/@allCalibrantModels;

	(* -- we will only let thet user specified one calibrants for now so throw an error here*)
	(* -- If more than 3 calibrants were specified we also only run 3 of them (1 default poisitive, 1 default negative and 1 user specified.). *)
	tooManyCalibrantBoolean=Length[nonDefaultCalibrants]>1;

	If[Or@@tooManyCalibrantBoolean && messages && outsideEngine,
		Message[Warning::ESITripleQuadTooManyCalibrants,
			ToString[Length[nonDefaultCalibrants]],
			ObjectToString[PickList[calibrants,nonDefaultCalibrantBools,False],Cache->simulatedCache],
			ObjectToString[First[PickList[calibrants,nonDefaultCalibrantBools,False]],Cache->simulatedCache]
		]
	];
	tooManyCalibrantWarningTests=sampleTests[gatherTests,Test,simulatedSamplePackets,Length[DeleteDuplicates[nonDefaultCalibrants]],"For this protocol running in ESI-QQQ, there `1` user specified calibrants were input, which it too many to be run in a experiment. The amount of non-default calibrants will be truncated to 1:",simulatedCache];

	(* Check for invalidSourceTemperatureBooleans and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@invalidSourceTemperatureBooleans && messages && outsideEngine,
		Message[Error::InvalidSourceTemperatures,
			Lookup[massSpecOptions,Instrument],
			ObjectToString[PickList[mySimulatedSamples,invalidSourceTemperatureBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidSourceTemperatureOptionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidSourceTemperatureBooleans],"For samples `1` in ESI-QQQ, the input SourceTemperature is 150 Celsius:",simulatedCache];
	invalidSourceTemperatureOptions=If[Or@@invalidSourceTemperatureBooleans,SourceTemperature];

	(* Check for invalidDesolvationGasFlowBoolean and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@invalidDesolvationGasFlowBooleans && messages && outsideEngine,
		Message[Error::InvalidDesolvationGasFlows,
			Lookup[massSpecOptions,Instrument],
			ObjectToString[PickList[mySimulatedSamples,invalidDesolvationGasFlowBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidDesolvationGasFlowOptionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidDesolvationGasFlowBooleans],"For samples `1` in ESI-QQQ, the input DesolvationGasFlow using PSI as the unit:",simulatedCache];
	invalidDesolvationGasFlowOptions=If[Or@@invalidDesolvationGasFlowBooleans,DesolvationGasFlow];

	(* Check for invalidConeGasFlowBooleans and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@invalidConeGasFlowBooleans && messages && outsideEngine,
		Message[Error::InvalidConeGasFlow,
			Lookup[massSpecOptions,Instrument],
			ObjectToString[PickList[mySimulatedSamples,invalidConeGasFlowBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidConeGasFlowTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidConeGasFlowBooleans],"For samples `1` in ESI-QQQ, the input ConeGasFlow using PSI as the unit:",simulatedCache];
	invalidConeGasFlowOptions=If[Or@@invalidConeGasFlowBooleans,ConeGasFlow];

	(* Check runDurationExceedsInfusionOptionsBooleans and throw the corresponding Warning if we are throwing messages*)
	If[Or@@runDurationExceedsInfusionOptionsBooleans && messages && outsideEngine,
		Message[Warning::InfusionVolumeLessThanRunDurationTimesFlowRate,
			ObjectToString[PickList[mySimulatedSamples,runDurationExceedsInfusionOptionsBooleans],Cache->simulatedCache],
			Convert[PickList[infusionVolumes,runDurationExceedsInfusionOptionsBooleans],Milliliter],
			Convert[PickList[runDurations,runDurationExceedsInfusionOptionsBooleans],Minute],
			Convert[PickList[infusionFlowRates,runDurationExceedsInfusionOptionsBooleans],Milliliter/Minute]
		]
	];


	(* Check for invalidInfusionSyringeBooleans and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@invalidInfusionSyringeBooleans && messages && outsideEngine,
		Message[Error::InvalidInfusionSyringes,
			ObjectToString[PickList[mySimulatedSamples,invalidInfusionSyringeBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidInfusionSyringeTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidInfusionSyringeBooleans],"For samples `1` in ESI-QQQ, the input syringe type for the direct infusion can be used in this instrument:",simulatedCache];
	invalidInfusionSyringeOptions=If[Or@@invalidInfusionSyringeBooleans,InfusionSyringe];

	(* Check for invalidInfusionSyringeBooleans and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@invalidInfusionVolumeBooleans && messages && outsideEngine,
		Message[Error::InvalidInfusionVolumes,
			ObjectToString[PickList[mySimulatedSamples,invalidInfusionVolumeBooleans],Cache->simulatedCache],
			ObjectToString[Convert[PickList[infusionVolumes,invalidInfusionVolumeBooleans],Milliliter],Cache->simulatedCache],
			ObjectToString[Convert[PickList[infusionSyringes,invalidInfusionVolumeBooleans],Milliliter],Cache->simulatedCache],
			ObjectToString[Convert[PickList[syringeMinVolumes,invalidInfusionVolumeBooleans],Milliliter],Cache->simulatedCache],
			ObjectToString[Convert[PickList[syringeMaxInfusionVolumes,invalidInfusionVolumeBooleans],Milliliter],Cache->simulatedCache]

		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidInfusionVolumeTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidInfusionVolumeBooleans],"For samples `1` in ESI-QQQ, the input InfusionVolume for the amount of solution loaded to the syringe for the direct infusion is allowed:",simulatedCache];
	invalidInfusionVolumeOptions=If[Or@@invalidInfusionVolumeBooleans,InfusionVolume];

	(*Check for invalidScanTimeBooleans and throw corresponding Error if we are throwing messages*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	If[Or@@invalidScanTimeBooleans && messages && outsideEngine,
		numberOfScanPoints = MapThread[((Part[#1,2]-Part[#1,1])/#2 + 1)&, {massRanges,massTolerances}];
		Message[Error::InvalidScanTime,
			ObjectToString[PickList[mySimulatedSamples,invalidScanTimeBooleans],Cache->simulatedCache],
			PickList[scanTimes, invalidScanTimeBooleans],
			PickList[Map[Span[Ceiling[UnitConvert[# * 3 Microsecond, Millisecond]], # * 5 Second]&, numberOfScanPoints], invalidScanTimeBooleans]
		]
	];

	invalidScanTimeTests=sampleTests[gatherTests, Test, simulatedSamplePackets, PickList[simulatedSamplePackets, invalidScanTimeBooleans],"For samples `1` in ESI-QQQ, the input ScanTime for the sample is allowed:",simulatedCache];
	invalidScanTimeOptions = If[Or@@invalidScanTimeBooleans,InfusionVolume];

	(* Check for invalidMassToleranceBooleans and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@invalidMassToleranceBooleans && messages && outsideEngine,
		Message[Error::InvalidMassToleranceInputs,
			ObjectToString[PickList[mySimulatedSamples,invalidMassToleranceBooleans],Cache->simulatedCache],
			ObjectToString[PickList[scanModes,invalidMassToleranceBooleans],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidMassToleranceTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidMassToleranceBooleans],"For samples `1` in ESI-QQQ, the MassTolerance is a valid input in this scan mode:",simulatedCache];
	invalidMassToleranceOptions=If[Or@@invalidMassToleranceBooleans,MassTolerance];


	(* Check for fragmentScanModeMismatches and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@fragmentScanModeMismatches && messages && outsideEngine,
		Message[Error::FragmentScanModeMisMatches,
			ObjectToString[PickList[mySimulatedSamples,fragmentScanModeMismatches],Cache->simulatedCache],
			ObjectToString[PickList[fragmentBooleans,fragmentScanModeMismatches],Cache->simulatedCache],
			ObjectToString[PickList[scanModes,fragmentScanModeMismatches],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidFragmentTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,fragmentScanModeMismatches],"For samples `1` in ESI-QQQ, the Fragment is a valid input in this scan mode:",simulatedCache];
	invalidFragmentOptions=If[Or@@fragmentScanModeMismatches,Fragment];

	(* Check for massDetectionScanModeMismatches and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@massDetectionScanModeMismatches && messages && outsideEngine,
		Message[Error::MassDetectionScanModeMismatches,
			ObjectToString[PickList[mySimulatedSamples,massDetectionScanModeMismatches],Cache->simulatedCache],
			ObjectToString[PickList[massRanges,massDetectionScanModeMismatches],Cache->simulatedCache],
			ObjectToString[PickList[scanModes,massDetectionScanModeMismatches],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidMassDetectionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,massDetectionScanModeMismatches],"For samples `1` in ESI-QQQ, the MassDetection is a valid input in this scan mode:",simulatedCache];
	invalidMassDetectionOptions=If[Or@@massDetectionScanModeMismatches,MassDetection];

	(* Check for fragmentMassDetectionScanModeMismatches and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@fragmentMassDetectionScanModeMismatches && messages && outsideEngine,
		Message[Error::FragmentMassDetectionScanModeMismatches,
			ObjectToString[PickList[mySimulatedSamples,fragmentMassDetectionScanModeMismatches],Cache->simulatedCache],
			ObjectToString[PickList[fragmentMassDetections,fragmentMassDetectionScanModeMismatches],Cache->simulatedCache],
			ObjectToString[PickList[scanModes,fragmentMassDetectionScanModeMismatches],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidFragmentMassDetectionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,fragmentMassDetectionScanModeMismatches],"For samples `1` in ESI-QQQ, the FragmentMassDetection is a valid input in this scan mode:",simulatedCache];
	invalidFragmentMassDetectionOptions=If[Or@@fragmentMassDetectionScanModeMismatches,FragmentMassDetection];



	(* Check for unneededScanModeSpecifOptionBooleans and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@unneededTandemMassSpecOptionBooleans && messages && outsideEngine,
		Message[Error::UnneededTandemMassSpecOptions,
			ObjectToString[PickList[mySimulatedSamples,unneededTandemMassSpecOptionBooleans],Cache->simulatedCache],
			ObjectToString[Flatten[unneededTandemMassSpecOptionLists],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidTandemMassSpecOptionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,unneededTandemMassSpecOptionBooleans],"For samples `1` in ESI-QQQ and is not running tandem mass analysis, all unneccessary options are not filled:",simulatedCache];
	invalidTandemMassSpecOptions=DeleteDuplicates[Flatten[unneededTandemMassSpecOptionLists]];


	(* Check for voltageInputIonModeMisMatches and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@voltageInputIonModeMisMatches && messages && outsideEngine,
		Message[Error::VoltageInputIonModeMisMatches,
			ObjectToString[PickList[mySimulatedSamples,voltageInputIonModeMisMatches],Cache->simulatedCache],
			ObjectToString[PickList[invalidVoltagesOptionLists,voltageInputIonModeMisMatches],Cache->simulatedCache],
			ObjectToString[PickList[ionModes,voltageInputIonModeMisMatches]]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidVoltageInputsOptionTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,voltageInputIonModeMisMatches],"For samples `1` in ESI-QQQ, all voltage inputs matches corresponding IonMode (positive volts for positive mode and negative volts for negative mode) are not filled:",simulatedCache];
	invalidVoltageInputsOptions=DeleteDuplicates[Flatten[invalidVoltagesOptionLists]];


	(* Check for tooShortRunDurationBooleans and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@tooShortRunDurationBooleans && messages && outsideEngine,
		Message[Error::TooShortRunDurations,
			ObjectToString[PickList[mySimulatedSamples,tooShortRunDurationBooleans],Cache->simulatedCache],
			ObjectToString[PickList[cycleRunDurations,tooShortRunDurationBooleans],Cache->simulatedCache],
			ObjectToString[PickList[runDurations,tooShortRunDurationBooleans],Cache->simulatedCache]

		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidRunDurationTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,tooShortRunDurationBooleans],"For samples `1` in ESI-QQQ, RunDuration is long enough to finsh all input measurement with resolved scan time:",simulatedCache];
	invalidRunDurationOptions=If[Or@@tooShortRunDurationBooleans,RunDuration];

	(* Check for invalidLengthOfInputOptionBooleans and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@invalidLengthOfInputOptionBooleans && messages && outsideEngine,
		Message[Error::InvalidMultipleReactionMonitoringLengthOfInputOptions,
			ObjectToString[PickList[mySimulatedSamples,invalidLengthOfInputOptionBooleans],Cache->simulatedCache],
			ObjectToString[PickList[invalidLengthOfInputOptionLists,invalidLengthOfInputOptionBooleans],Cache->simulatedCache],
			ObjectToString[Length[mySimulatedSamples],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidLengthOfInputTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidLengthOfInputOptionBooleans],"For samples `1` in ESI-QQQ, all listable inputs (MassDetection,FragmentMassDetection,CollisionEnergy,DwellTime) have same length:",simulatedCache];
	invalidLengthOfInputOptions=DeleteDuplicates[Flatten[invalidLengthOfInputOptionLists]];

	(* Check for inputOptionsMRMAssaysMisMatches and throw the corresponding Error if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@inputOptionsMRMAssaysMisMatches && messages && outsideEngine,
		Message[Error::InputOptionsMRMAssaysMismatches,
			ObjectToString[PickList[mySimulatedSamples,inputOptionsMRMAssaysMisMatches],Cache->simulatedCache],
			ObjectToString[PickList[inputOptionsMRMAssaysMisMatchedOptionLists,inputOptionsMRMAssaysMisMatches],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidInputOptionsMRMAssaysTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,inputOptionsMRMAssaysMisMatches],"For samples `1` in ESI-QQQ and running MultipleReacionMonitoring analysis, if both listable inputs and MultipleReactionMonitoringAssays are specified, they are same:",simulatedCache];
	invalidInputOptionsMRMAssaysOptions=DeleteDuplicates[Flatten[inputOptionsMRMAssaysMisMatchedOptionLists]];

	(* Get the sample for which the calibrant is invalid*)
	badCalibrantSamplePackets=PickList[simulatedSamplePackets,validCalibrantBools,False];

	(* Get samples out of calibrant peak range - if we already threw the compatible calibrant error above (wrong ion source and invalid calibrants) then we don't throw this warning here *)
	outOfCalibrantRangeSamplePackets=Complement[PickList[simulatedSamplePackets,massInCalibrantRangeBools,False],PickList[simulatedSamplePackets,ionSourceCalibrantMismatchBooleans,True],badCalibrantSamplePackets];
	outOfCalibrantRangeSamples=Lookup[outOfCalibrantRangeSamplePackets,Object,{}];

	(* Throw a message if the MW is not flanked *)
	If[!MatchQ[outOfCalibrantRangeSamplePackets,{}]&&messages&&outsideEngine,
		Message[Warning::IncompatibleCalibrant,ObjectToString[outOfCalibrantRangeSamplePackets,Cache->simulatedCache]]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	outOfRangeCalibrantTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,outOfCalibrantRangeSamplePackets,"The molecular weights of `1` are within the range formed by the reference peaks in the calibrant:",simulatedCache];

	(* Check if user specified Calibrant is valid, if not we throw error message.*)
	If[!And@@validCalibrantBools && messages && outsideEngine,
		Message[Error::MassSpectrometryInvalidCalibrants,
			ObjectToString[PickList[mySimulatedSamples,validCalibrantBools,False],Cache->simulatedCache],
			ObjectToString[PickList[calibrants,validCalibrantBools,False],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidCalibrantTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,validCalibrantBools,False],"For samples `1` in, the specified Calibrant is not valid:",simulatedCache];
	invalidCalibrantOptions=If[!And@@validCalibrantBools,Calibrant];


	(*All warning here*)

	(* Check for tooShortRunDurationBooleans and throw the corresponding Warning if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@tooManyMultpleReactionMonitoringAssayWarnings && messages && outsideEngine,
		Message[Warning::TooManyMultpleReactionMonitoringAssays,
			ObjectToString[PickList[mySimulatedSamples,tooManyMultpleReactionMonitoringAssayWarnings],Cache->simulatedCache],
			ObjectToString[PickList[Length/@multipleReactionMonitoringAssays,tooManyMultpleReactionMonitoringAssayWarnings],Cache->simulatedCache]
		]
	];
	(* Create a test for the valid samples and one for the invalid samples *)
	tooManyMultpleReactionMonitoringAssayTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,PickList[simulatedSamplePackets,tooManyMultpleReactionMonitoringAssayWarnings],"For samples `1` in ESI-QQQ runing MultipleReactionMonitoring analysis, the total number of MultipleReactionMonitoring assays is less than 10:",simulatedCache];


	(* Check for tooShortRunDurationBooleans and throw the corresponding Warning if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@autoNeutralLossValueWarnings && messages && outsideEngine,
		Message[Warning::AutoNeutralLossValueWarnings,
			ObjectToString[PickList[mySimulatedSamples,autoNeutralLossValueWarnings],Cache->simulatedCache]
		]
	];
	(* Create a test for the valid samples and one for the invalid samples *)
	autoNeutralLossValueTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,PickList[simulatedSamplePackets,autoNeutralLossValueWarnings],"For samples `1` in ESI-QQQ running NeutralIonLoss analysis, the NeutralLoss mass value is specified by the user:",simulatedCache];


	(* Check for autoResolvedMassDetectionFixedValueWarnings and throw the corresponding Warning if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@autoResolvedMassDetectionFixedValueWarnings && messages && outsideEngine,
		Message[Warning::AutoResolvedMassDetectionFixedValue,
			ObjectToString[PickList[mySimulatedSamples,autoResolvedMassDetectionFixedValueWarnings],Cache->simulatedCache],
			ObjectToString[PickList[scanModes,autoResolvedMassDetectionFixedValueWarnings],Cache->simulatedCache]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	autoResolvedMassDetectionFixedValueTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,PickList[simulatedSamplePackets,autoResolvedMassDetectionFixedValueWarnings],"For samples `1` in ESI-QQQ, if fixed mass values is required for MassDetection, it's specified by the user:",simulatedCache];

	(* Check for autoResolvedFragmentMassDetectionFixedValueWarnings and throw the corresponding Warning if we are throwing message*)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)

	If[Or@@autoResolvedFragmentMassDetectionFixedValueWarnings && messages && outsideEngine,
		Message[Warning::AutoResolvedFragmentMassDetectionFixedValues,
			ObjectToString[PickList[mySimulatedSamples,autoResolvedFragmentMassDetectionFixedValueWarnings],Cache->simulatedCache],
			ObjectToString[PickList[scanModes,autoResolvedFragmentMassDetectionFixedValueWarnings],Cache->simulatedCache]

		]
	];
	autoResolvedFragmentMassDetectionFixedValueTests=sampleTests[gatherTests,Warning,simulatedSamplePackets,PickList[simulatedSamplePackets,autoResolvedFragmentMassDetectionFixedValueWarnings],"For samples `1` in ESI-QQQ, if fixed mass values is required for FragmentMassDetection, it's specified by the user:",simulatedCache];


	(* -- Too many samples -- *)

	(*declare a threshold depending on the type of injection we're doing *)
	measurementLimit=If[MatchQ[injectionType,DirectInfusion],10,2*96];

	(*get the number of replicates and convert a Null to 1*)
	numberOfReplicatesNumber=Lookup[mySuppliedExperimentOptions,NumberOfReplicates]/. {Null -> 1};

	(*calculate the total number of measurements needed*)
	numberOfMeasurements=Length[mySimulatedSamples]*numberOfReplicatesNumber;
	tooManySamplesQ=numberOfMeasurements>measurementLimit;

	(*get all of the excess inputs*)
	tooManyMeasurementsInputs=If[tooManySamplesQ,Drop[Flatten[Table[Lookup[simulatedSamplePackets,Object],numberOfReplicatesNumber]],measurementLimit],{}];

	If[tooManySamplesQ&&!gatherTests,
		Message[Error::TooManyESISamples,ToString[numberOfMeasurements],ToString[measurementLimit]]
	];

	tooManySamplesTest=If[gatherTests,
		Test["The number of input samples (including any replicates) are within the measurement limit of this protocol:",tooManySamplesQ,False]
	];


	(* -- RESOLVE ALIQUOT OPTIONS -- *)

	(* -- Resolve TransferContainer (RequiredAliquotContainer) and RequiredAliquotVolume -- *)

	(* we handle the two injection types separately - FlowInjection pretty much copies what Waters HPLC and SFC do *)
	{requiredAliquotAmounts,requiredTargetContainer}=If[MatchQ[injectionType,DirectInfusion],
		(* DIRECT INFUSION CASE *)
		(* Note: Given duplicate input, or number of replicates > 1, we either from the sample multiple times (if in a container that is compatible)
				or we consolidate the volume for all requested injections into one target container from which the sample is then drawn multiple times *)
		Module[{numReplicates,numReplicatesNoNull,injectedAmountAccountedForReplicates,groupedBySample,sampleCount,
			uniqueInjectedVolumes,uniqueSamples,targetContainers,totalVolumesNeeded,
			injectedVolumesPerSample,sampleVolumeRules,requiredAliquotVolumes,uniqueSampleContainerDeadVolumes},

			(* First resolve the target containers*)
			(* we resolved target container ignoring any user input,since in ESI-QQQ direct infusion used syringe pump, we won't worry about target containers*)
			targetContainers=ConstantArray[Null,Length[mySimulatedSamples]];

			(* set the invalid aliquot container flags to {} and tests to Null since these are specific to the flow injection case *)
			invalidAliquotContainerOptions={};
			invalidContainerCountInputs={};
			validAliquotContainerTest=Null;
			containerCountTest=Null;

			(* get the number of replicates so that we calculate the required volume for each sample *)
			(* if NumberOfReplicates -> Null, replace that with 1 for the purposes of the math below *)
			numReplicates=Lookup[massSpecOptions,NumberOfReplicates];
			numReplicatesNoNull =numReplicates /. {Null -> 1};

			(* calculate, indexmatched to SamplesIn, how much volume will be injected, accounting for NumberOfReplicates *)
			(* Since for Direct Infusion we have resolved InfusionVolume, which is the volume used in syringe, we will use this value here*)
			injectedAmountAccountedForReplicates=infusionVolumes*numReplicatesNoNull;

			(* we may be dealing with replicate input, so we group by the sample *)
			groupedBySample=GatherBy[Transpose[{mySimulatedSamples,injectedAmountAccountedForReplicates}],First];

			(* Calculate how many times each sample is injected. We need this to split the total volume between each sample, so that we can pass resolveAliquotOptions the correct fraction for each sample *)
			sampleCount=Length/@groupedBySample[[All,All,1]]*numReplicatesNoNull;

			(* calculate the total volume injected from each sample *)
			uniqueInjectedVolumes=Total/@groupedBySample[[All,All,2]];

			(* extract the list of unique samples *)
			uniqueSamples=First/@groupedBySample[[All,All,1]];

			(*Generate unique Container Volume*)
			(*Collect Unique sample container object*)
			uniqueSampleContainerObjects=Download[Lookup[fetchPacketFromCache[#, Flatten[sampleDownload]] & /@ uniqueSamples, Container], Object];

			(*Check the model of each container*)
			uniqueSampleContainerModels=Download[Lookup[fetchPacketFromCache[#, Flatten[sampleDownload]] & /@ uniqueSampleContainerObjects, Model], Object];

			(*Collect the dead volumes of each containers*)
			uniqueSampleContainerDeadVolumes=Lookup[fetchPacketFromCache[#, Flatten[sampleDownload]] & /@ uniqueSampleContainerModels, MinVolume] /.(Null -> 0.5 Milliliter);

			(* the total volume that is needed in the target container needs to account for all injected samples plus the deadvolume of that container *)
			totalVolumesNeeded=uniqueInjectedVolumes+uniqueSampleContainerDeadVolumes;

			(* calculate that volume needed from each SamplesIn *)
			injectedVolumesPerSample=Round[totalVolumesNeeded/sampleCount,0.1];

			(* construct rules so that we can get the aliquot volumes indexmatched to SamplesIn *)
			sampleVolumeRules=MapThread[
				(#1->#2)&,
				{uniqueSamples,injectedVolumesPerSample}
			];

			(* use the replace rules to get the aliquotVolume indexmatched to SamplesIn *)
			requiredAliquotVolumes=(mySimulatedSamples/.sampleVolumeRules);

			(* Return the aliquot containers and the volumes *)
			{requiredAliquotVolumes,targetContainers}

		],

		(* FlowInjection case - we pretty much copy what HPLC does to figure out the aliquot containers *)
		Module[{preResolvedAliquotOptions,compatibleContainers,namedCompatibleContainers,specifiedAliquotBools,
			incompatibleContainerModelBools,uniqueAliquotableSamples,uniqueNonAliquotablePlates,uniqueNonAliquotableVessels,
			validContainerCountQ,preresolvedAliquotBools,validAliquotContainerBools,
			validAliquotContainerOptions,aliquotOptionSpecifiedBools,resolvedAliquotContainers,

			targetContainers,requiredAliquotVolumes},

			(* Extract shared options relevant for aliquotting *)
			preResolvedAliquotOptions = KeySelect[samplePrepOptions,And[MatchQ[#,Alternatives@@ToExpression[Options[AliquotOptions][[All,1]]]],MemberQ[Keys[samplePrepOptions],#]]&];

			(* The containers that wil fit on the instrument's autosampler *)
			{compatibleContainers,namedCompatibleContainers} = {
				{Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Vessel, "id:jLq9jXvxr6OZ"], Model[Container, Vessel, "id:GmzlKjznOxmE"], Model[Container, Vessel, "id:3em6ZvL8x4p8"], Model[Container, Vessel, "id:aXRlGnRE6A8m"],Model[Container, Vessel, "id:qdkmxz0A884Y"], Model[Container, Vessel, "id:o1k9jAoPw5RN"]},
				{Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Vessel, "HPLC vial (high recovery)"], Model[Container, Vessel, "Amber HPLC vial (high recovery)"], Model[Container, Vessel, "HPLC vial (high recovery), LCMS Certified"], Model[Container, Vessel, "HPLC vial (high recovery) - Deactivated Clear Glass"],Model[Container, Vessel, "Polypropylene HPLC vial (high recovery)"],Model[Container, Vessel, "PFAS Testing Vials, Agilent"]}
			};

			(* Extract list of bools *)
			specifiedAliquotBools = Lookup[preResolvedAliquotOptions,Aliquot];

			(* If the sample's container model is not compatible with the instrument, we may have to aliquot *)
			incompatibleContainerModelBools = Map[
				!MatchQ[#,Alternatives@@compatibleContainers|Alternatives@@namedCompatibleContainers]&,
				simulatedSampleContainerModels
			];

			(* Extract all samples that could be aliquoted *)
			(* NOTE: this doesn't consider samples that are aliquotted and NOT consolidated. Therefore the number could be higher! *)
			uniqueAliquotableSamples = DeleteDuplicates@PickList[mySimulatedSamples,specifiedAliquotBools,True|Automatic];

			(* Find plates and containers that definitely cannot be aliquoted because Aliquot was set to False *)
			uniqueNonAliquotablePlates = DeleteDuplicates@Cases[
				PickList[simulatedSampleContainers,specifiedAliquotBools,False],
				ObjectP[Object[Container,Plate]]
			];
			uniqueNonAliquotableVessels = DeleteDuplicates@Cases[
				PickList[simulatedSampleContainers,specifiedAliquotBools,False],
				ObjectP[Object[Container,Vessel]]
			];


			(* see if we are dealing with a list of valid vessels and/or plates that we can fit into the autosampler *)
			(* Waters autosampler has room for:
					- 96 vials, 0 plates
					- 48 vials, 1 plate
					- 0 vials, 2 plates
					(In HPLC one vial rack is reserved for standards & blanks) but here we don't have these so we can use both racks for a plate each *)
			validContainerCountQ = Or[
				(* If non-aliquotable samples and aliquotable samples exist, the non-aliquotable samples
        must be in at-most 1 plate and the aliquotable samples must be already- in or transferred to vials,
        therefore there must be <= (48 - non aliquotable vials) *)
				And[
					Length[uniqueNonAliquotablePlates] <= 1,
					Length[uniqueAliquotableSamples] <= (48 - Length[uniqueNonAliquotableVessels])
				],
				(* If non-aliquotable samples are all in vials, then the number of aliquottable samples must fit in 1 plate (=96 samples) *)
				And[
					Length[uniqueNonAliquotablePlates] == 0,
					Length[uniqueAliquotableSamples] <= 96
				],
				(* If we have 2 plates, then the number of non-aliquotable AND aliquottable samples must be 0. *)
				And[
					Length[uniqueNonAliquotablePlates] == 2,
					Length[uniqueAliquotableSamples] == 0,
					Length[uniqueNonAliquotableVessels] == 0
				]
			];

			(* Build test for container count validity *)
			containerCountTest = If[!validContainerCountQ,
				(
					If[messages,
						Message[Error::HPLCTooManySamples]
					];
					invalidContainerCountInputs = myNonSimulatedSamples;
					testOrNull["The number of sample and/or aliquot containers can fit on the instrument's autosampler:",False]
				),
				invalidContainerCountInputs = {};
				testOrNull["The number of sample and/or aliquot containers can fit on the instrument's autosampler:",True]
			];

			(*  if sample plate count >1, aliquot.
			We're already throwing an error if the container count is invalid so we know we can just blindly
			flip all Aliquot -> Automatic to True if Aliquot is needed to make the samples fit.

			If the container count is invalid, don't modify any values *)
			preresolvedAliquotBools = If[
				And[
					validContainerCountQ,
					Length[DeleteDuplicates[simulatedSampleContainers]] > 1
				],
				Replace[specifiedAliquotBools,Automatic->True,{1}],
				specifiedAliquotBools
			];

			(* Enforce that _if_ AliquotContainer is specified, they are compatible *)
			validAliquotContainerBools = MapThread[
				Function[{aliquotQ,aliquotContainer},
					Or[
						(* If Aliquot is not explicitly False, we don't need this check *)
						MatchQ[Lookup[preResolvedAliquotOptions,Aliquot],False],
						Or[
							(* If AliquotContainer is not specified, assume it is valid *)
							!MatchQ[aliquotContainer,ObjectP[]],
							MatchQ[Download[aliquotContainer,Object],(Alternatives@@compatibleContainers)]
						]
					]
				],
				{specifiedAliquotBools,Lookup[preResolvedAliquotOptions,AliquotContainer]}
			];

			invalidAliquotContainerOptions=If[!(And@@validAliquotContainerBools),{AliquotContainer},{}];

			(* Build test for aliquot container specification validity *)
			validAliquotContainerTest = If[!(And@@validAliquotContainerBools),
				(
					If[messages,
						Message[Error::MassSpectrometryIncompatibleAliquotContainer,ObjectToString/@namedCompatibleContainers]
					];
					testOrNull["If AliquotContainer is specified, it is compatible with an HPLC autosampler:",False]
				),
				testOrNull["If AliquotContainer is specified, it is compatible with an HPLC autosampler:",True]
			];

			(* Build list of booleans representing if an aliquot option is specified explicitly *)
			aliquotOptionSpecifiedBools = Map[
				MemberQ[Values[preResolvedAliquotOptions],Except[Automatic|Null|{Automatic..}|{Null..}]]&,
				Transpose[Values[KeyDrop[preResolvedAliquotOptions,{ConsolidateAliquots,AliquotPreparation}]]]
			];

			(* we set the target container for all samples that aren't compatible  *)
			(* we let the Aliquot resolver below throw an error if Aliquot was specifically set to False *)
			resolvedAliquotContainers = Map[
				If[TrueQ[#],
					Model[Container,Plate,"96-well 2mL Deep Well Plate"],
					Null
				]&,
				incompatibleContainerModelBools
			];

			(* calculate the required aliquot volume *)
			(* If we end up aliquoting and AliquotAmount is not specified, it is possible we need to force
			AliquotVolume to be the appropriate InjectionVolume. *)
			requiredAliquotVolumes = MapThread[
				Function[
					{samplePacket,injectionVolume},
					Which[
						MatchQ[injectionVolume,VolumeP],
						(* Distribute autosampler dead volume across all instances of an identical aliquots *)
						injectionVolume + (autosamplerDeadVolume/Count[Download[mySimulatedSamples,Object],Lookup[samplePacket,Object]]),
						True,25 Microliter
					]
				],
				{
					simulatedSamplePackets,
					injectionVolumes
				}
			];

			(* Return the aliquot containers and the volumes *)
			{requiredAliquotVolumes,resolvedAliquotContainers}
		]
	];

	(* If we're aliquoting and user hasn't supplied ConsolidateAliquots, set to True *)
	(* Since for each repeated sample we're going to inject a small volume from the bottle into the mass spec, no need for them to be in separate containers *)
	suppliedConsolidation=Lookup[samplePrepOptions,ConsolidateAliquots];
	resolvedConsolidation=If[MatchQ[suppliedConsolidation,Automatic]&&MemberQ[impliedAliquotBools,True],
		True,
		suppliedConsolidation
	];

	(* Prepare options to send to resolveAliquotOptions --> Pass the ConsolidateAliquots inside the aliquot options *)
	aliquotOptions=ReplaceRule[
		mySuppliedExperimentOptions,
		Join[{ConsolidateAliquots->resolvedConsolidation},myResolvedSamplePrepOptions]
	];

	If[StringQ[$RequiredSearchName],
		Block[{$RequiredSearchName=Null},TransferDevices[All, All]]
	];
	requiredAliquotAmounts=Quiet[AchievableResolution /@ requiredAliquotAmounts];
	(* Resolve aliquot options for the ESI experiment *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentMassSpectrometry,
			myNonSimulatedSamples,
			mySimulatedSamples,
			aliquotOptions,
			RequiredAliquotContainers->requiredTargetContainer,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->If[MatchQ[injectionType,DirectInfusion],
				"because the given samples don't fit into the fluidics system of the mass spectrometer. If aliquotting is not desired, please move the samples to a suitable container prior to the experiment. Please refer to the documentation for a list of compatible containers.",
				"because the given samples are not in containers that are compatible with the autosampler affiliated with the mass spectrometry instrument."
			],
			Cache->simulatedCache,
			Simulation->Simulation[simulatedCache],
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentMassSpectrometry,
				myNonSimulatedSamples,
				mySimulatedSamples,
				aliquotOptions,
				RequiredAliquotContainers->requiredTargetContainer,
				RequiredAliquotAmounts->requiredAliquotAmounts,
				AliquotWarningMessage->If[MatchQ[injectionType,DirectInfusion],
					"because the given samples don't fit into the fluidics system of the mass spectrometer. If aliquotting is not desired, please move the samples to a suitable container prior to the experiment. Please refer to the documentation for a list of compatible containers.",
					"because the given samples are not in containers that are compatible with the autosampler affiliated with the mass spectrometry instrument."
				],
				Cache->simulatedCache,
				Simulation->Simulation[simulatedCache]
			],
			{}
		}
	];

	(*Collect a list to see if the sample needs to be aliquot*)
	aliquotQList=Lookup[resolvedAliquotOptions,Aliquot];

	(* After all option and aliquot option resolved we calculate the sample volume*)
	(* We calculate the sampele we need to calculate volumes for the direct infusion *)

	(* Generate the dead volume for the sample container.*)
	simulatedSampleContainerMinVolumes=If[!NullQ[sampleDownload[[All,6]]],(Lookup[sampleDownload[[All,6]],MinVolume]/.Null->0Milliliter),ConstantArray[0 Milliliter, Length[simulatedSampleContainers]]];

	(* Generate a required volume list by adding the amount of sample we gonna injected in with the containers' dead volume (MinVolumes)*)
	requiredVolumes=(If[flowInjectionQ,injectionVolumes,infusionVolumes]+simulatedSampleContainerMinVolumes);

	(* If aliquot option is false for the sample, check and throw warning if the sample does not have enough volume, if the sample does not have enough volume*)
	(* This will be check in resource picking or SM sub protocol, so we will only through a warning here.*)
	invalidNonAliquotSampleVolumesQ=MapThread[
		(*We won't check if the sample will be aliquot, this has been checked in the resolvedAliquot Options*)
		If[#1,False,Less[#2,#3]]&,
		{aliquotQList,(simulatedVolumes/.Null->0Milliliter), requiredVolumes}
	];

	(* Check for outRangedDesolvationTemperatureBooleans and throw the corresponding Warning if we're throwing messages *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	If[Or@@invalidNonAliquotSampleVolumesQ && messages && outsideEngine,
		Message[Error::MassSpectrometryNotEnoughVolume,
			ObjectToString[PickList[mySimulatedSamples,invalidNonAliquotSampleVolumesQ],Cache->simulatedCache],
			ObjectToString[PickList[simulatedVolumes,invalidNonAliquotSampleVolumesQ],Cache->simulatedCache],
			ObjectToString[PickList[requiredVolumes,invalidNonAliquotSampleVolumesQ],Cache->simulatedCache]
		]
	];

	(*Generate sample for the InvalidInputs options*)
	invalidNonAliquotSampleInputs=PickList[mySimulatedSamples,invalidNonAliquotSampleVolumesQ];

	(* Create a test for the valid samples and one for the invalid samples *)
	invalidNonAliquotSampleVolumeTests=sampleTests[gatherTests,Test,simulatedSamplePackets,PickList[simulatedSamplePackets,invalidNonAliquotSampleVolumesQ],"For samples `1` in ESI-QTOF, sample volumes is not enougth to finish the experiment:",simulatedCache];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[mySuppliedExperimentOptions];

	(* -- GATHER THE OUTPUT -- *)
	(* Gather our invalid input and invalid option variables. *)
	(* Note: We don't throw Error::InvalidInput or Error::InvalidOption - we pass this to the resolver together with the other option/input checks *)

	 (*Add all your tests here*)
	esiTripleQuadInvalidInputs=DeleteDuplicates[
		Flatten[
			{
				tooManyMeasurementsInputs,
				invalidContainerCountInputs,
				invalidNonAliquotSampleInputs
			}
		]
	];
	esiTripleQuadInvalidOptions=DeleteCases[
		Flatten[
			{
				invalidAliquotContainerOptions,
				invalidSourceTemperatureOptions,
				invalidDesolvationGasFlowOptions,
				invalidConeGasFlowOptions,
				invalidInfusionSyringeOptions,
				invalidInfusionVolumeOptions,
				invalidScanTimeOptions,
				invalidMassToleranceOptions,
				invalidFragmentOptions,
				invalidMassDetectionOptions,
				invalidTandemMassSpecOptions,
				invalidVoltageInputsOptions,
				(*	invalidMultipleReactionMonitoringVoltagesOptions,*)
				invalidRunDurationOptions,
				invalidLengthOfInputOptions,
				invalidInputOptionsMRMAssaysOptions,
				invalidFragmentMassDetectionOptions,
				invalidCalibrantOptions
			}
		],
		Null
	];

	(* Gather all the resolved options *)
	esiTripleQuadResolvedOptions=ReplaceRule[
		Normal[roundedMassSpecOptions],
		Join[
			{
				(* shared options resolved in the big mapThread *)
				IonMode->ionModes,
				Calibrant->calibrants,
				MassDetection->massRanges,
				MassAnalyzer->resolveAutomaticOption[MassAnalyzer,roundedMassSpecOptions,TripleQuadrupole],

				(* ESI specific options resolved above in the big mapThread *)
				ESICapillaryVoltage->capillaryVoltages,
				IonGuideVoltage->ionGuideVoltages,
				SourceTemperature->resolveAutomaticOption[SourceTemperature,roundedMassSpecOptions,150*Celsius],
				DesolvationTemperature->desolvationTemperatures,
				DesolvationGasFlow->desolvationGasFlows,
				InfusionVolume->infusionVolumes,
				InfusionSyringe->infusionSyringes,
				InfusionFlowRate->infusionFlowRates,

				(* ESI options that are defaulted to a value (or user-supplied) if doing ESI *)
				InjectionType->injectionType,
				ScanTime->scanTimes,
				RunDuration->runDurations,
				DeclusteringVoltage->declusteringVoltages,
				ConeGasFlow->resolveAutomaticOption[ConeGasFlow,roundedMassSpecOptions,50*PSI],
				(* ESI options that are defaulted to a value (or user-supplied) if doing ESI AND FlowInjection *)
				SampleTemperature->flowInjectionSampleTemperature/. Ambient -> $AmbientTemperature,
				Buffer->flowInjectionBuffer,
				NeedleWashSolution->flowInjectionNeedleWashSolution,
				InjectionVolume->injectionVolumes,
				IonGuideVoltage->ionGuideVoltages,

				(*TandemMass Specific Options*)
				ScanMode->scanModes,
				MassTolerance->massTolerances,
				FragmentMassDetection->fragmentMassDetections,
				DwellTime->dwelltimes,
				Fragment->fragmentBooleans,
				CollisionEnergy->collisionEnergies,
				CollisionCellExitVoltage->collisionCellExitVoltages,
				NeutralLoss->neutralLosses,
				MultipleReactionMonitoringAssays->multipleReactionMonitoringAssays,

				(* Resolve StepwaveVoltage to Null, it's an option specifially to ESI-QTOF, if user specified this value, we will check it in the Main ExperimentMassSpectrometry function *)
				StepwaveVoltage->resolveAutomaticOption[StepwaveVoltage,roundedMassSpecOptions,Null],

				(* all MALDI options are resolved to Null or kept at what the user gave us. We've already thrown an error in the main resolver if they were not Null and will return $Failed in that case *)
				(* indexmatched MALDI options *)
				LaserPowerRange->resolveAutomaticOption[LaserPowerRange,roundedMassSpecOptions,Null],
				CalibrantLaserPowerRange->resolveAutomaticOption[CalibrantLaserPowerRange,roundedMassSpecOptions,Null],
				LensVoltage->resolveAutomaticOption[LensVoltage,roundedMassSpecOptions,Null],
				GridVoltage->resolveAutomaticOption[GridVoltage,roundedMassSpecOptions,Null],
				DelayTime->resolveAutomaticOption[DelayTime,roundedMassSpecOptions,Null],
				Matrix->resolveAutomaticOption[Matrix,roundedMassSpecOptions,Null],
				CalibrantMatrix->resolveAutomaticOption[CalibrantMatrix,roundedMassSpecOptions,Null],
				SpottingMethod->resolveAutomaticOption[SpottingMethod,roundedMassSpecOptions,Null],
				AccelerationVoltage->resolveAutomaticOption[AccelerationVoltage,roundedMassSpecOptions,Null],
				SampleVolume->resolveAutomaticOption[SampleVolume,roundedMassSpecOptions,Null],
				Gain->resolveAutomaticOption[Gain,roundedMassSpecOptions,Null],
				MatrixControlScans->resolveAutomaticOption[MatrixControlScans,roundedMassSpecOptions,Null],

				(* single MALDI options *)
				SpottingPattern->resolveAutomaticOption[SpottingPattern,roundedMassSpecOptions,Null],
				MALDIPlate->resolveAutomaticOption[MALDIPlate,roundedMassSpecOptions,Null],
				ShotsPerRaster->resolveAutomaticOption[ShotsPerRaster,roundedMassSpecOptions,Null],
				NumberOfShots->resolveAutomaticOption[NumberOfShots,roundedMassSpecOptions,Null],
				CalibrantNumberOfShots->resolveAutomaticOption[CalibrantNumberOfShots,roundedMassSpecOptions,Null],
				SpottingDryTime->resolveAutomaticOption[SpottingDryTime,roundedMassSpecOptions,Null],
				CalibrantVolume->resolveAutomaticOption[CalibrantVolume,roundedMassSpecOptions,Null]

			},
			resolvedAliquotOptions,
			myResolvedSamplePrepOptions,
			resolvedPostProcessingOptions
		]
	];


	(* Gather all the esi-triplequad specific collected tests *)
	esiTripleQuadTests=Cases[Flatten[{
		noMolecularWeightTests,
		optionPrecisionTests,
		{tooManySamplesTest},
		calibrantMassRangeMismatchTests,
		aliquotTests,
		{containerCountTest}, (* these can be Null if we're not doing flow injection *)
		{validAliquotContainerTest}, (* these can be Null if we're not doing flow injection *)
		invalidSourceTemperatureOptionTests,
		invalidDesolvationGasFlowOptionTests,
		invalidConeGasFlowTests,
		invalidInfusionSyringeTests,
		invalidInfusionVolumeTests,
		invalidScanTimeTests,
		invalidMassToleranceTests,
		invalidFragmentTests,
		invalidMassDetectionTests,
		invalidTandemMassSpecOptionTests,
		invalidVoltageInputsOptionTests,
		(*invalidMultipleReactionMonitoringVoltagesOptions,*)
		invalidRunDurationTests,
		invalidLengthOfInputTests,
		invalidInputOptionsMRMAssaysTests,
		invalidFragmentMassDetectionTests,
		outOfRangeCalibrantTests,
		invalidCalibrantTests,
		invalidFragmentTests
	}],_EmeraldTest];

	(* Return the resolved options, the tests, the invalid input, and the invalid options gathered for MALDI *)
	{esiTripleQuadResolvedOptions,esiTripleQuadTests,esiTripleQuadInvalidOptions,esiTripleQuadInvalidInputs}

];


(* ::Subsubsection::Closed:: *)
(*esiQTOFResourcePackets*)


DefineOptions[
	esiQTOFResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

(* NumberOfReplicates *)
esiQTOFResourcePackets[mySamples:{ObjectP[Object[Sample]]...},myUnresolvedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[{
	outputSpecification,output,gatherTests,messages,cache,numberOfReplicates,samplesWithReplicates,optionsWithReplicates,
	expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,
	calibrants,uniqueCalibrants,uniqueCalibrantSamples,uniqueCalibrantModels,sampleDownload,calibrantDownload,
	msDetectors,lcDetectors,instrumentDownload,sampleObjects,sampleContainers,uniquePlateContainers,calibrantSampleModels,calibrantModels,
	infusionFlowRates,runDurations,scanTimes,ionModes,sourceTemperatures,desolvationTemperatures,desolvationGasFlows,
	coneGasFlows,declusteringVoltages,esiCapillaryVoltages,stepwaveVoltages,sampleVolumesWithReplicate,samplesInResourceVolumes,
	flowInjectionSampleVolumes,directInfusionSampleVolumes,sampleTemperature,injectionType,minMasses,maxMasses,aliquotVolumesWithReplicates,
	volumePerSample,sampleResourceLookup,samplesInResources,calibrantVolumePerSample,volumePerCalibrant,calibrantResourceLookup,
	calibrantResources,bufferDeadVolume,gradients,bufferVolumes,totalBufferVolumeNeeded,flowInjectionQ,bufferResource,needleWashSolutionResource,needleWashSolutionPlacements,
	instrumentModel,instrumentModelPacket,systemPrimeGradientMethod,systemFlushGradientMethod,systemPrimeGradientPacket,systemFlushGradientPacket,systemPrimeGradient,
	systemFlushGradient,systemPrimeBufferContainer,systemFlushBufferContainer,systemPrimeBufferVolume,systemPrimeBufferResource,systemFlushBufferVolume,
	systemFlushBufferResource,systemPrimeBufferPlacements,systemFlushBufferPlacements,instrumentSetupTime,sampleRunTime,
	massSpectrometerResource,containersIn,numberOfContainersInvolved,flowInjectionBuffersInvolved,sampleContainersDeadVolumes,
	resourcePickingTime,dataAcquisitionTime,checkpoints,massSpecPacket,sharedFieldPacket,finalizedPacket, simulation,
	allResourceBlobs,fulfillable,frqTests,previewRule, optionsRule,testsRule,resultRule,aliquotQList},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Get our cache. *)
	cache=Lookup[ToList[ops], Cache, {}];
	simulation = Lookup[ToList[ops], Simulation, Simulation[]];

	(* Determine if we need to make replicate spots *)
	numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentMassSpectrometry, {mySamples}, myResolvedOptions];

	(* Repeat the inputs and options according to replicates *)
	{samplesWithReplicates,optionsWithReplicates}=expandMassSpecReplicates[mySamples,expandedResolvedOptions,numberOfReplicates];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentMassSpectrometry,
		RemoveHiddenOptions[ExperimentMassSpectrometry, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* --- SET-UP DOWNLOAD --- *)

	(*get the mass spectrometry instrument model *)
	instrumentModel=If[MatchQ[Lookup[myResolvedOptions,Instrument],ObjectP[Object[Instrument]]],
		cacheLookup[cache, Lookup[myResolvedOptions, Instrument], Model],
		Lookup[myResolvedOptions,Instrument]
	];

	(* Get objects in options *)
	calibrants=Lookup[optionsWithReplicates,Calibrant];

	(* Get unique calibrant objects *)
	uniqueCalibrants=DeleteDuplicates[calibrants];

	(* User can specify objects or models, split so that we can download the right thing *)
	{uniqueCalibrantSamples,uniqueCalibrantModels}={Cases[uniqueCalibrants,ObjectP[Object[Sample]]],Cases[uniqueCalibrants,ObjectP[Model[Sample]]]};

	(* --- SET-UP DOWNLOAD --- *)

	(* Download info needed to make packets *)
	{sampleDownload,calibrantDownload,instrumentDownload}=Download[
		{mySamples,uniqueCalibrantSamples,{instrumentModel}},
		{
			{Object,Container[Object],Container[Model][MinVolume]},
			{Model[Object]},
			{Detectors,Objects[IntegratedHPLC[Detectors]]}
		},
		Cache->cache,
		Simulation -> simulation
	];

	msDetectors=instrumentDownload[[All,1,1]];
	(* if there are several, we'll take the first *)

	lcDetectors=DeleteCases[instrumentDownload[[All, 2, 1]], Null][[1]];

	(* - Extract downloaded values into relevant variables - *)
	sampleObjects=duplicateMassSpecReplicates[sampleDownload[[All,1]],numberOfReplicates]; (* TODO do I need this since I have samplesWithReplicates above? *)
	sampleContainers=duplicateMassSpecReplicates[sampleDownload[[All,2]],numberOfReplicates];
	sampleContainersDeadVolumes=duplicateMassSpecReplicates[sampleDownload[[All,2]],numberOfReplicates];

	calibrantSampleModels=calibrantDownload[[All,1]];

	calibrantModels=Replace[calibrants,AssociationThread[uniqueCalibrantSamples,calibrantSampleModels],{1}];

	(* Lookup options needed below *)
	{infusionFlowRates, runDurations,scanTimes,ionModes,sourceTemperatures,desolvationTemperatures,desolvationGasFlows,
		coneGasFlows,declusteringVoltages,esiCapillaryVoltages,stepwaveVoltages,flowInjectionSampleVolumes,sampleTemperature,injectionType}=Lookup[optionsWithReplicates,
		{InfusionFlowRate,RunDuration,ScanTime,IonMode,SourceTemperature,DesolvationTemperature,DesolvationGasFlow,
			ConeGasFlow,DeclusteringVoltage,ESICapillaryVoltage,StepwaveVoltage,InjectionVolume,SampleTemperature,InjectionType}];
	minMasses=Apply[List,Lookup[optionsWithReplicates,MassDetection]][[All,1]];
	maxMasses=Apply[List,Lookup[optionsWithReplicates,MassDetection]][[All,2]];
	(* --- CREATE RESOURCES --- *)

	(*get the number of unique plate containers*)
	uniquePlateContainers=DeleteDuplicates[Cases[sampleContainers,ObjectP[Object[Container,Plate]]]];

	(* - SampleIn Resources - *)


	(*Generate a FlowInjectionQ for the easiness of later use*)
	flowInjectionQ=MatchQ[injectionType,FlowInjection];


	(* Resolve the sample volume for the DirectInfusion by using flow rate times total experiment time for each run (runDurations+scanTimes)*)
	(* 0.2 Milliliter was determined from the Procedure where it says FillVolume to 200 Microliter*)
	directInfusionSampleVolumes=(infusionFlowRates*(runDurations+scanTimes))+0.2Milliliter;

	(*Generate SampleVolumes for each SamplesIn*)
	sampleVolumesWithReplicate=If[flowInjectionQ,flowInjectionSampleVolumes,directInfusionSampleVolumes];

	(*Determine is the sample needs Aliquots*)
	aliquotQList=Lookup[optionsWithReplicates,Aliquot];

	(* Determine volume we're using - either enough to aliquot or enough to make the sample spot *)
	aliquotVolumesWithReplicates=Lookup[optionsWithReplicates,AliquotAmount];

	(* Resolve the Amount-> in the SamplesIn resource*)
	samplesInResourceVolumes=MapThread[
		Function[{eachAliquotQ,eachAliquotVolume,eachSampleVolume},
			If[eachAliquotQ,eachAliquotVolume,eachSampleVolume]
		],
		{aliquotQList,aliquotVolumesWithReplicates,sampleVolumesWithReplicate}
	];

	(* Get the total volume taken from each sample in the form <|sample1->totalVolume1, sample2->totalVolume2,...|>*)
	volumePerSample=Merge[MapThread[<|#1->#2|>&,{sampleObjects,samplesInResourceVolumes}],Total];

	(* Create a lookup linking each unique sample to its resource *)
	sampleResourceLookup=KeyValueMap[
		If[!VolumeQ[#2],
			#1->Resource[Sample->#1,Name->ToString[#1]],
			#1->Resource[Sample->#1,Amount->#2,Name->ToString[#1]]
		]&,
		volumePerSample
	];

	(* Get list of resources index-matched to the input samples - this is expanded according to NumberOfReplicates *)
	samplesInResources=Lookup[sampleResourceLookup,sampleObjects];

	(* - Calibrant Resources - *)

	(* The needle get's filled with 200 Microliter which is enough to perform the initial check plus the calibration *)
	calibrantVolumePerSample=250*Microliter;

	(* Get the total volume taken from each calibrant in the form <|calibrant1->totalVolume1, calibrant2->totalVolume2,...|>*)
	(* if multiple samples require the same calibrant, we'll only calibrate once, so use 'uniqueCalibrants' here *)
	volumePerCalibrant=Merge[Map[<|#->calibrantVolumePerSample|>&,uniqueCalibrants],Total];

	(* Create a lookup linking each unique calibrant to its resource *)
	calibrantResourceLookup=KeyValueMap[
		Module[{amount,container},
			(* add 5mL dead volume we need inside the container for Model[Container,Vessel,"id:1ZA60vLx3RB5"], we'll also purge once which takes approx. 0.5mL *)
			amount=#2+5 Milliliter+0.5 Milliliter;
			(* Make sure the calibrant is in the 30ml reservoir that fits on the deck *)
			container=Model[Container,Vessel,"id:1ZA60vLx3RB5"];
			#1->Resource[Sample->#1,Amount->amount,Container->container,Name->ToString[#1]]
		]&,
		volumePerCalibrant
	];

	(* Get list of resources index-matched to the expanded calibrants (and thus to the input samples) *)
	calibrantResources=Lookup[calibrantResourceLookup,calibrants];

	(* we need to double-check whether the initialization steps consume the buffer. Currently, we're adding extra amount of buffer *)
	bufferDeadVolume = 300 Milliliter;

	(* we don't have gradient for the buffer; we'll use 100% Buffer A without for as long as the run takes, for each sample - so construct a dummy gradient here *)
	gradients=MapThread[{
		{Quantity[0.,"Minutes"],Quantity[100.,"Percent"],Quantity[0.,"Percent"], #2},
		{Quantity[Unitless[#1,Minute],"Minutes"],Quantity[100.,"Percent"],Quantity[0.,"Percent"], #2}
	}&,{runDurations,infusionFlowRates}];

	(* calculate the amount of buffer needed for all the runs together *)
	(* we use the helper from HPLC/FPLC/SFC for ths to interpolate *)
	bufferVolumes=Map[Function[{currentGradientTuple},
		calculateBufferUsage[
			currentGradientTuple[[All,{1, 2}]], (* the specific buffer line *)
			Max[currentGradientTuple[[All, 1]]], (* last time point *)
			currentGradientTuple[[All,{1,4}]], (* the flow rate profile *)
			Last[currentGradientTuple[[All, 2]]] (* the last percentage *)
		]
	],gradients];

	(* the total volume needed is the sum of the buffer needed for each sample *)
	totalBufferVolumeNeeded=Total[bufferVolumes];

	(* make the resource for the buffer *)
	bufferResource= If[flowInjectionQ,
		Resource[
			Sample -> Lookup[myResolvedOptions,Buffer],
			(*can't supply more than the volume of the container, but also can't go for less than the dead volume *)
			Amount -> Min[2 Liter, bufferDeadVolume+totalBufferVolumeNeeded],
			Container -> Model[Container, Vessel, "id:rea9jlRPKB05"], (* 2L Glass Bottle, Detergent-Sensitive *)
			RentContainer -> True,
			Name -> CreateUUID[]
		],
		Null
	];

	(*make the resources for the needle wash solution*)
	needleWashSolutionResource= If[flowInjectionQ,
		Resource[
			Sample -> Lookup[myResolvedOptions,NeedleWashSolution],
			Amount -> 300 Milliliter,
			Container -> Model[Container, Vessel, "id:4pO6dM5l83Vz"],  (* 1L Glass Bottle, Detergent-Sensitive *)
			RentContainer -> True,
			Name -> CreateUUID[]
		],
		Null
	];

	(*create the placement fields for the needle wash solution*)
	needleWashSolutionPlacements={
		{Link[needleWashSolutionResource],{"SM Wash Reservoir Slot"}}
	};

	(*get the instrument model packet*)
	instrumentModelPacket=fetchPacketFromCache[instrumentModel,cache];

	(*for the system prime and flush we will defer to the default method*)
	systemPrimeGradientMethod=Object[Method, Gradient, "id:XnlV5jKXaknM"]; (* Object[Method,Gradient,"System Prime Method-Acquity I-Class UPLC FlowInjection"] *)
	systemFlushGradientMethod=Object[Method, Gradient, "id:XnlV5jKXaknM"]; (* Object[Method,Gradient,"System Prime Method-Acquity I-Class UPLC FlowInjection"] *)

	(*get the packet from the cache*)
	systemPrimeGradientPacket=fetchPacketFromCache[systemPrimeGradientMethod,cache];
	systemFlushGradientPacket=fetchPacketFromCache[systemFlushGradientMethod,cache];

	(*get the gradient tuple*)
	systemPrimeGradient=Lookup[systemPrimeGradientPacket,Gradient];
	systemFlushGradient=Lookup[systemFlushGradientPacket,Gradient];


	(*define the suitable containers for the priming*)
	systemPrimeBufferContainer=Model[Container, Vessel, "id:4pO6dM5l83Vz"]; (*1 liter detergent senstitive bottles*)
	systemFlushBufferContainer=Model[Container, Vessel, "id:4pO6dM5l83Vz"]; (*1 liter detergent senstitive bottles*)

	(* Determine volume of Cosolvent required for system prime run *)
	systemPrimeBufferVolume = calculateBufferUsage[
		systemPrimeGradient[[All,{1,2}]], (*the specific gradient*)
		Max[systemPrimeGradient[[All,1]]], (*the last time*)
		systemPrimeGradient[[All,{1,-1}]], (*the flow rate profile*)
		Last[systemPrimeGradient[[All,2]]] (*the last percentage*)
	];

	(* Create resource for SystemPrime's BufferA *)
	systemPrimeBufferResource =  Resource[
		Sample -> Lookup[systemPrimeGradientPacket,BufferA],
		Amount -> systemPrimeBufferVolume + bufferDeadVolume,
		Container -> systemPrimeBufferContainer,
		RentContainer -> True,
		Name -> CreateUUID[]
	];

	(*do the same for the system flushes*)
	(* Determine volume of buffer required for system flush run *)
	systemFlushBufferVolume = calculateBufferUsage[
		systemFlushGradient[[All,{1,2}]], (*the specific gradient (A in this case)*)
		Max[systemFlushGradient[[All,1]]], (*the last time*)
		systemFlushGradient[[All,{1,-1}]], (*the flow rate profile*)
		Last[systemFlushGradient[[All,2]]] (*the last percentage*)
	];

	(* Create resource for SystemPrime's BufferA *)
	systemFlushBufferResource =  Resource[
		Sample -> Lookup[systemFlushGradientPacket,BufferA],
		Amount -> systemPrimeBufferVolume + bufferDeadVolume,
		Container -> systemPrimeBufferContainer,
		RentContainer -> True,
		Name -> CreateUUID[]
	];


	(* Create placement field value for SystemPrime buffers *)
	systemPrimeBufferPlacements = {
		{Link[systemPrimeBufferResource], {"Buffer A Slot"}}
	};

	(* Create placement field value for SystemFlush buffers *)
	systemFlushBufferPlacements = {
		{Link[systemFlushBufferResource], {"Buffer A Slot"}}
	};

	(* - Instrument Resource - *)

	(* consider 30 Minutes to configure the methods, and 10 minutes to perform each calibration *)
	instrumentSetupTime=30 Minute+Length[uniqueCalibrants]*15 Minute;

	(* the run time of data acquisition will be dictated by how many samples we have, and the run duration of each sample *)
	(* let's assume 3 minutes overhead for the injection and communication (in case of flowinjection) *)
	sampleRunTime=(Length[sampleObjects]*3 Minute)+Total[Lookup[optionsWithReplicates,RunDuration]];

	(* Create a resource for the mass spectrometer *)
	(* Note that even in the case of flow injection we do NOT consider priming and flushing as part of the resource since we don't give the user option to change that so why would we charge them *)
	massSpectrometerResource=Resource[Instrument->Lookup[optionsWithReplicates,Instrument],Time->(instrumentSetupTime+sampleRunTime), Name -> "mass instrument"<>CreateUUID[]];

	(* --- ESTIMATE CHECKPOINTS --- *)
	(* Get containers involved *)
	containersIn=DeleteDuplicates[sampleContainers];
	numberOfContainersInvolved=(Length[containersIn]+Length[uniqueCalibrants]);

	flowInjectionBuffersInvolved=If[!flowInjectionQ,0,Length[{systemPrimeBufferResource,systemFlushBufferResource,needleWashSolutionResource,bufferResource}]];

	(* 30 second/pick + 5 minute overhead *)
	resourcePickingTime=numberOfContainersInvolved * 5 Minute + flowInjectionBuffersInvolved * 10Minute + 5 Minute;

	(* set-up time, then assume time to put away samples, calibrants and matrix is the same as picking time, +5 minute for data exporting and instrument release *)
	dataAcquisitionTime=sampleRunTime+resourcePickingTime+5 Minute;

	(* Create the Checkpoints field -- Note that in constrast to MALDI we do NOT have "Cleaning Up" but we do have "Purging Instrument" and "Flushing Instrument" *)
	(* be careful adding the correct check points inside the respective procedures *)
	checkpoints={
		{"Picking Resources",resourcePickingTime,"Samples required to execute this protocol are gathered from storage.",Resource[Operator->$BaselineOperator,Time ->resourcePickingTime]},
		{"Purging Instrument",3 Hour, "System priming buffers are connected to the LC instrument and the instrument's buffer lines, needle and pump seals are purged at a high flow rates.",Resource[Operator->$BaselineOperator,Time ->3*Hour]},
		{"Preparing Samples",0*Hour,"Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.",Resource[Operator->$BaselineOperator,Time -> 0*Minute]},
		{"Acquiring Data",dataAcquisitionTime,"The instrument is calibrated, and samples are injected and measured.",Resource[Operator->$BaselineOperator,Time ->(instrumentSetupTime+dataAcquisitionTime)]},
		{"Sample Post-Processing",0*Minute,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Resource[Operator->$BaselineOperator,Time ->0*Minute]},
		{"Flushing Instrument", 2 Hour, "Buffers are connected to the LC instrument and the instrument is flushed with each buffer at high flow rates.",Resource[Operator->$BaselineOperator,Time ->2*Hour]},
		{"Returning Materials", 20 Minute, "Samples are retrieved from instrumentation and materials are cleaned and returned to storage.", Resource[Operator->$BaselineOperator,Time ->20*Minute]}
	};

	(* FINALIZE PACKETS ESI*)
	massSpecPacket=<|
		Object->CreateID[Object[Protocol, MassSpectrometry]],
		Replace[SamplesIn]->samplesInResources,
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@containersIn,
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->resolvedOptionsNoHidden,
		ImageSample->Lookup[optionsWithReplicates,ImageSample],
		Template -> Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated],

		Replace[SamplesInStorage]->Lookup[optionsWithReplicates,SamplesInStorageCondition],
		Replace[CalibrantStorage]->Lookup[optionsWithReplicates,CalibrantStorageCondition],

	(* Mass Spectrometer Options *)
		IonSource->First@Lookup[instrumentModelPacket,IonSources],
		MassAnalyzer->Lookup[instrumentModelPacket,MassAnalyzer],
		(* if we're doing flow injection, we also need to pass the lc detectors in order to make sure to also create the lc methods (pda and inlet) *)
		Replace[Detectors]->If[flowInjectionQ,DeleteDuplicates[Join[lcDetectors,msDetectors]],msDetectors],
		(* if we're doing flow injection, we also need to pass the AcquisitionTime so that we can use it for our processing stage. Doesn't hurt to populate it always *)
		AcquisitionTime->sampleRunTime,
		InjectionType->injectionType,
		Replace[AcquisitionModes]->ConstantArray[MS,Length[samplesWithReplicates]], (* hardcode this since the instrument can do both and at this point we only do MSMS *)
		Replace[IonModes]->ionModes,
		Replace[MinMasses]->minMasses,
		Replace[MaxMasses]->maxMasses,
		Replace[SourceTemperatures]-> sourceTemperatures,
		Replace[DesolvationTemperatures]->desolvationTemperatures,
		Replace[DesolvationGasFlows]-> desolvationGasFlows,
		Replace[ConeGasFlows]-> coneGasFlows,
		Replace[DeclusteringVoltages]-> declusteringVoltages,
		Replace[ESICapillaryVoltages]-> esiCapillaryVoltages,
		Replace[StepwaveVoltages]-> stepwaveVoltages,
		Replace[RunDurations]->runDurations,
		Replace[ScanTimes]->scanTimes,
		Replace[InfusionFlowRates]->infusionFlowRates,

	(* -- Resources -- *)
		Replace[Calibrants]->calibrantResources,
		Instrument->massSpectrometerResource,
		(* Populate MassSpectrometryInstrument so that LCMS procedures may be called *)
		MassSpectrometryInstrument->massSpectrometerResource,
		PrimingSyringe -> Link[Resource[Sample -> Model[Item, Consumable, "id:9RdZXvdkxzGZ"], Rent -> True]],

	(* flow injection specific options and resources *)
		Replace[SampleVolumes]->sampleVolumesWithReplicate,
		SampleTemperature->sampleTemperature,
		Buffer->If[flowInjectionQ,bufferResource,Null],
		NeedleWashSolution->If[flowInjectionQ,needleWashSolutionResource,Null],
		SystemPrimeBuffer->If[flowInjectionQ,Link@(systemPrimeBufferResource),Null],
		SystemPrimeGradient->If[flowInjectionQ,Link@systemPrimeGradientMethod,Null],
		Replace[SystemPrimeBufferPlacements] -> If[flowInjectionQ,systemPrimeBufferPlacements,{}],
		SystemFlushBuffer->If[flowInjectionQ,systemFlushBufferResource,Null],
		SystemFlushGradient->If[flowInjectionQ,Link@systemPrimeGradientMethod],
		Replace[SystemFlushContainerPlacements] -> If[flowInjectionQ,systemFlushBufferPlacements],
		Replace[NeedleWashPlacements]->If[flowInjectionQ,needleWashSolutionPlacements],
		(* We let Cover pick the plate seal resource and this is just a model here *)
		PlateSeal -> If[flowInjectionQ,
			Link[Model[Item, PlateSeal, "id:Vrbp1jKZJ0Rm"]],
			Null
		],
		TubingRinseSolution -> If[flowInjectionQ,
			Link[
				Resource[
					Sample -> Model[Sample, "Milli-Q water"],
					Amount -> 500 Milli Liter,
					(* 1000 mL Glass Beaker *)
					Container -> Model[Container, Vessel, "id:O81aEB4kJJJo"],
					RentContainer -> True
				]
			],
			Null
		],


	(* -- Checkpoints -- *)
		Replace[Checkpoints]->checkpoints
	|>;

	(* generate a packet with the shared sample prep and aliquotting fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples,expandedResolvedOptions,Cache->cache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, massSpecPacket];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];


	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache, Simulation -> simulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache, Simulation -> simulation],Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		{finalizedPacket,{}},
		{$Failed,{}}
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];


(* ::Subsubsection::Closed:: *)
(*maldiResourcePackets*)


DefineOptions[
maldiResourcePackets,
Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

(* NumberOfReplicates *)
maldiResourcePackets[mySamples:{ObjectP[Object[Sample]]...},templatedOptions:{(_Rule|_RuleDelayed)...},resolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		accelerationVoltages, aliquotVolumes, cache, calibrantDownload, calibrantMatrices, calibrantMatricesForControlSpots,
		calibrantMatrixControlSpotVolumes, calibrantMatrixDownload, calibrantMatrixDryTimeLookup, calibrantMatrixDryTimes,
		calibrantMatrixModelDownload, calibrantMatrixModelDryTimes, calibrantMatrixModels, calibrantMatrixModelSpottingVolumes,
		calibrantMatrixResourceLookup, calibrantMatrixResources, calibrantMatrixSampleDryTimes, calibrantMatrixSampleModels,
		calibrantMatrixSampleSpottingVolumes, calibrantMatrixSpottingVolumeLookup, calibrantMatrixSpottingVolumes,
		calibrantMatrixVolumePerSpot, calibrantMaxLaserPowers, calibrantMinLaserPowers, calibrantModels, calibrantResourceLookup,
		calibrantResources, calibrants, calibrantSampleModels, calibrantsForSpots, calibrantSpottingVolume,
		calibrantSpottingVolumes, calibrantVolumePerMatrix, calibrationLookup, calibrationMethods, calibrationOptionAssociations,
		capacityOk, checkpoints, cleanUpOperator, cleanUpTime, containersIn, dataAcquisitionOperator, dataAcquisitionTime, delayTimes,
		emptyPositions, existingMethods, gains, gatherTests, gridVoltages, ionModes, lensVoltages, liquidHandlerContainerDownload,
		liquidHandlerContainerMaxVolumes, liquidHandlerContainers, maldiPlate, maldiPlateFields, maldiPlatePacket, maldiPlateResource,
		maldiSetUpTime, maldiZapTime, massSpecPacket, massSpectrometerResource, matrices, matricesForControlSpots,
		matrixControlScansQ, matrixControlSpotVolumes, matrixDownload, matrixDryTimeLookup, matrixDryTimes, matrixModelDownload,
		matrixModelDryTimes, matrixModels, matrixModelSpottingVolumes, matrixResourceLookup, matrixResources, matrixSampleDryTimes,
		matrixSampleModels, matrixSampleSpottingVolumes, matrixSpottingVolumeLookup, matrixSpottingVolumes,
		matrixVolumePerSpot, maxLaserPowers, maxMasses, messages, minLaserPowers, minMasses, newMethodIDs, newMethodOptionAssociations,
		newMethodPackets, numberOfContainersInvolved, numberOfReplicates, operator, optionsWithReplicates, output, outputSpecification,
		postProcessingOperator, postProcessingTime, prepPacket, primaryCleaningResource, primaryCleaningSample, protocolPacket,
		protocolWideCalibrationOptionAssociation, resourcePickingOperator, resourcePickingTime, resources, resourcesOk, resourceTests,
		returningOperator, returningTime, sampleContainers, sampleDownload, sampleObjects, samplePrepOperator, samplePrepTime,
		sampleResourceLookup, samplesInResources, sampleSpecificCalibrationOptionAssociations, sampleSpottingVolumes,
		samplesWithReplicates, sampleVolumes, secondaryCleaningResource, settingsPerSample, sonicatorResource, spottingMethods,
		spottingPattern, spottingTime, sufficientWellsTest, totalMatrixDryTime, uniqueCalibrantMatrices,
		uniqueCalibrantMatrixModels, uniqueCalibrantMatrixSamples, uniqueCalibrantModels, uniqueCalibrants, uniqueCalibrantSamples,
		uniqueCalibrationMethods, uniqueCalibrationOptionAssociations, uniqueCalibrationSearchTerms, uniqueMatrices, uniqueMatrixModels,
		uniqueMatrixSamples, volumePerCalibrant, volumePerMatrix, volumePerSample, wellAssignments ,sampleWells, calibrantWells, matrixWells
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Get our cache. *)
	cache=Lookup[ToList[ops], Cache, {}];
	simulation=Lookup[ToList[ops], Simulation, {}];

	(* Determine if we need to make replicate spots *)
	numberOfReplicates=Lookup[resolvedOptions,NumberOfReplicates];

	(* Repeat the inputs and options if we have replicates *)
	{samplesWithReplicates,optionsWithReplicates}=expandMassSpecReplicates[mySamples,resolvedOptions,numberOfReplicates];

	(* --- SET-UP DOWNLOAD --- *)

	(* First retrieve the master switch for MatrixControlScans, this will control if we spott pure matrices as the blank control*)
	matrixControlScansQ=Lookup[optionsWithReplicates,MatrixControlScans];

	(* Get objects in options *)
	maldiPlate=Lookup[optionsWithReplicates,MALDIPlate];
	{matrices,calibrants,calibrantMatrices}=Download[Lookup[optionsWithReplicates,{Matrix,Calibrant,CalibrantMatrix}],Object];

	(* Get unique matrix and calibrant objects *)
	uniqueMatrices=DeleteDuplicates[matrices];
	uniqueCalibrants=DeleteDuplicates[calibrants];
	uniqueCalibrantMatrices=DeleteDuplicates[calibrantMatrices];

	(* User can specify objects or models, split so that we can download the right thing *)
	{uniqueMatrixSamples,uniqueMatrixModels}={Cases[uniqueMatrices,ObjectP[Object[Sample]]],Cases[uniqueMatrices,ObjectP[Model[Sample]]]};
	{uniqueCalibrantSamples,uniqueCalibrantModels}={Cases[uniqueCalibrants,ObjectP[Object[Sample]]],Cases[uniqueCalibrants,ObjectP[Model[Sample]]]};
	{uniqueCalibrantMatrixSamples,uniqueCalibrantMatrixModels}={Cases[uniqueCalibrantMatrices,ObjectP[Object[Sample]]],Cases[uniqueCalibrantMatrices,ObjectP[Model[Sample]]]};

	(* Get all containers which can fit on the liquid handler - we must make sure our matrices and calibrants are in one of these *)
	(* In case we need to prepare the resource add 2mL tube to the beginning of the list (Engine uses the first requested container if it has to transfer or make a stock solution) *)
	liquidHandlerContainers=DeleteDuplicates[
		Prepend[
			Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling],
			PreferredContainer[1.5 Milliliter]
		]
	];

	(* Download model info (must dereference if given an object) *)
	maldiPlateFields=If[MatchQ[maldiPlate,ObjectP[Object]],
		Packet[Model[{NumberOfWells,AspectRatio}]],
		Packet[NumberOfWells,AspectRatio]
	];

	(* Download info needed to make packets *)
	{
		(*1*)sampleDownload,
		(*2*)calibrantDownload,
		(*3*)matrixDownload,
		(*4*)matrixModelDownload,
		(*5*)calibrantMatrixDownload,
		(*6*)calibrantMatrixModelDownload,
		(*7*){{maldiPlatePacket}},
		(*8*)liquidHandlerContainerDownload
	}=Download[
		{
			(*1*)mySamples,
			(*2*)uniqueCalibrantSamples,
			(*3*)uniqueMatrixSamples,
			(*4*)uniqueMatrixModels,
			(*5*)uniqueCalibrantMatrixSamples,
			(*6*)uniqueCalibrantMatrixModels,
			(*7*){maldiPlate},
			(*8*)liquidHandlerContainers
		},
		{
			(*1*){Object,Container[Object]},
			(*2*){Model[Object]},
			(*3*){Model[Object],Model[{SpottingDryTime,SpottingVolume}]},
			(*4*){SpottingDryTime,SpottingVolume},
			(*5*){Model[Object],Model[{SpottingDryTime,SpottingVolume}]},
			(*6*){SpottingDryTime,SpottingVolume},
			(*7*){maldiPlateFields},
			(*8*){MaxVolume}
		},
		Cache->cache,
		Simulation -> simulation
	];

	(* - Extract downloaded values into relevant variables - *)
	sampleObjects=duplicateMassSpecReplicates[sampleDownload[[All,1]],numberOfReplicates];
	sampleContainers=duplicateMassSpecReplicates[sampleDownload[[All,2]],numberOfReplicates];
	calibrantSampleModels=calibrantDownload[[All,1]];

	(* - Extract the sample matrix value*)
	{matrixSampleModels,matrixSampleDryTimes,matrixSampleSpottingVolumes}={matrixDownload[[All,1]],matrixDownload[[All,2,1]],matrixDownload[[All,2,2]]};
	{matrixModelDryTimes,matrixModelSpottingVolumes}={matrixModelDownload[[All,1]],matrixModelDownload[[All,2]]};

	(* - Extract the calibrant matrix value*)
	{calibrantMatrixSampleModels,calibrantMatrixSampleDryTimes,calibrantMatrixSampleSpottingVolumes}={calibrantMatrixDownload[[All,1]],calibrantMatrixDownload[[All,2,1]],calibrantMatrixDownload[[All,2,2]]};
	{calibrantMatrixModelDryTimes,calibrantMatrixModelSpottingVolumes}={calibrantMatrixModelDownload[[All,1]],calibrantMatrixModelDownload[[All,2]]};

	(* - Extract the calibrant matrix value*)
	liquidHandlerContainerMaxVolumes=Flatten[liquidHandlerContainerDownload,1];

	(* Create a lookup table linking matrix model/sample to dry time, then lookup the matrix dry time for each specified matrix*)
	matrixDryTimeLookup=Join[AssociationThread[uniqueMatrixSamples,matrixSampleDryTimes],AssociationThread[uniqueMatrixModels,matrixModelDryTimes]];
	matrixSpottingVolumeLookup=Join[AssociationThread[uniqueMatrixSamples,matrixSampleSpottingVolumes],AssociationThread[uniqueMatrixModels,matrixModelSpottingVolumes]];

	(* Create a lookup table linking calibrant matrix model/sample to dry time, then lookup the matrix dry time for each specified matrix*)
	calibrantMatrixDryTimeLookup=Join[AssociationThread[uniqueCalibrantMatrixSamples,calibrantMatrixSampleDryTimes],AssociationThread[uniqueCalibrantMatrixModels,calibrantMatrixModelDryTimes]];
	calibrantMatrixSpottingVolumeLookup=Join[AssociationThread[uniqueCalibrantMatrixSamples,calibrantMatrixSampleSpottingVolumes],AssociationThread[uniqueCalibrantMatrixModels,calibrantMatrixModelSpottingVolumes]];

	(* Get list of matrix dry times, spotting volumes index-matched to expanded matrix option. If fields aren't populated use sensible defaults *)
	matrixDryTimes=Replace[Lookup[matrixDryTimeLookup,matrices],Null->420 Second,{1}];
	matrixSpottingVolumes=Replace[Lookup[matrixSpottingVolumeLookup,matrices],Null->1 Microliter,{1}];

	(* Get list of calibrant matrix dry times, spotting volumes index-matched to expanded matrix option. If fields aren't populated use sensible defaults *)
	calibrantMatrixDryTimes=Replace[Lookup[calibrantMatrixDryTimeLookup,calibrantMatrices],Null->420 Second,{1}];
	calibrantMatrixSpottingVolumes=Replace[Lookup[calibrantMatrixSpottingVolumeLookup,calibrantMatrices],Null->1 Microliter,{1}];

	(* Create lookup tables linking samples to their models, then replace samples with models to get a list of all models index-matched in SamplesIn *)
	matrixModels=Replace[matrices,AssociationThread[uniqueMatrixSamples,matrixSampleModels],{1}];
	calibrantMatrixModels=Replace[calibrantMatrices,AssociationThread[uniqueCalibrantMatrixSamples,calibrantMatrixSampleModels],{1}];
	calibrantModels=Replace[calibrants,AssociationThread[uniqueCalibrantSamples,calibrantSampleModels],{1}];

	(* --- CREATE CALIBRATION METHODS --- *)

	(* Lookup options needed to determine calibration method *)
	{ionModes,accelerationVoltages,gridVoltages,lensVoltages,delayTimes,gains,spottingMethods}=Lookup[optionsWithReplicates,{IonMode,AccelerationVoltage,GridVoltage,LensVoltage,DelayTime,Gain,SpottingMethod}];
	minMasses=Apply[List,Lookup[optionsWithReplicates,MassDetection]][[All,1]];
	maxMasses=Apply[List,Lookup[optionsWithReplicates,MassDetection]][[All,2]];

	(* Search won't be happy with fractions so make sure the values are in percent *)
	calibrantMinLaserPowers=UnitConvert[Apply[List,Lookup[optionsWithReplicates,CalibrantLaserPowerRange]][[All,1]],Percent];
	calibrantMaxLaserPowers=UnitConvert[Apply[List,Lookup[optionsWithReplicates,CalibrantLaserPowerRange]][[All,2]],Percent];

	(* Organize MapThread options into a list of association i.e. instead of: {DelayTime->{100 Nanosecond,250 Nanosecond},...} we want: {<|DelayTime->100 Nanosecond,...|>,<|DelayTime->250 Nanosecond,...|>} *)
	(* Use Matrix here instead CalibrantMatrix, since Object[Method, MassSpecCalibration] only has matrix field*)
	sampleSpecificCalibrationOptionAssociations=Map[
		AssociationThread[{IonMode,Matrix,Calibrant,SpottingMethod,MinMass,MaxMass,AccelerationVoltage,GridVoltage,LensVoltage,DelayTime,Gain,MinLaserPower,MaxLaserPower},#]&,
		Transpose[{ionModes,calibrantMatrixModels,calibrantModels,spottingMethods,minMasses,maxMasses,accelerationVoltages,gridVoltages,lensVoltages,delayTimes,gains,calibrantMinLaserPowers,calibrantMaxLaserPowers}]
	];

	(* Get one association for each set of calibration options *)
	protocolWideCalibrationOptionAssociation=<|
		ShotsPerRaster->Lookup[optionsWithReplicates,ShotsPerRaster],
		NumberOfShots->Lookup[optionsWithReplicates,CalibrantNumberOfShots]
	|>;
	calibrationOptionAssociations=Append[#,protocolWideCalibrationOptionAssociation]&/@sampleSpecificCalibrationOptionAssociations;

	(* Get only the unique option associations to avoid redundant searching *)
	uniqueCalibrationOptionAssociations=DeleteDuplicates[calibrationOptionAssociations];

	(* Convert option associations into search terms, e.g. from MinMass-> 5000 Dalton to MinMass==5000 Dalton, then change head to 'And' since our method needs all of these terms to be true *)
	uniqueCalibrationSearchTerms=Apply[
		And,
		Apply[Equal,Normal[uniqueCalibrationOptionAssociations],{2}],
		{1}
	];

	(* Find existing methods with all the same parameters *)
	existingMethods=Search[ConstantArray[Object[Method, MassSpectrometryCalibration],Length[uniqueCalibrationSearchTerms]],Evaluate[uniqueCalibrationSearchTerms],MaxResults->1];

	(* Get option sets for which Search returned {} indicating we need to make new objects *)
	newMethodOptionAssociations=PickList[uniqueCalibrationOptionAssociations,existingMethods,{}];

	(* Create new calibration methods - replacing Matrix and Calibrant rules to have links as needed for upload packet *)
	newMethodIDs=CreateID[ConstantArray[Object[Method, MassSpectrometryCalibration],Length[newMethodOptionAssociations]]];
	newMethodPackets=MapThread[
		Join[#,<|
			Object->#2,
			Matrix->Link[Lookup[#,Matrix]],
			Calibrant->Link[Lookup[#,Calibrant]]
		|>]&,
		{newMethodOptionAssociations,newMethodIDs}
	];

	(* Sub our new IDs into empty list positions - to create a master list of the methods, old and new *)
	emptyPositions=Position[existingMethods,{},{1}];
	uniqueCalibrationMethods=ReplacePart[existingMethods, AssociationThread[emptyPositions, newMethodIDs]];

	(* Create a mapping from option sets to method IDs, then use to get the method for each sample - take First since Search returns methods in a list *)
	calibrationLookup=AssociationThread[uniqueCalibrationOptionAssociations,uniqueCalibrationMethods];
	calibrationMethods=If[ListQ[#],First[#],#]&/@Lookup[calibrationLookup,calibrationOptionAssociations];

	(* --- CREATE RESOURCES --- *)

	(* - SampleIn Resources - *)
	(* Determine volume we're using - either enough to aliquot or enough to make the sample spot *)
	{aliquotVolumes,sampleSpottingVolumes}=Lookup[optionsWithReplicates,{AliquotAmount,SampleVolume}];
	sampleVolumes=MapThread[
		If[MatchQ[#1,VolumeP],
			#1,
			#2
		]&,
		{aliquotVolumes,sampleSpottingVolumes}
	];

	(* Get the total volume taken from each sample in the form <|sample1->totalVolume1, sample2->totalVolume2,...|>*)
	volumePerSample=Merge[MapThread[<|#1->#2|>&,{sampleObjects,sampleVolumes}],Total];

	(* Create a lookup linking each unique sample to its resource *)
	sampleResourceLookup=KeyValueMap[
		#1->Resource[Sample->#1,Amount->#2,Name->ToString[#1]]&,
		volumePerSample
	];

	(* Get list of resources index-matched to the input samples *)
	samplesInResources=Lookup[sampleResourceLookup,sampleObjects];

	(* - Matrix Resources - *)

	(* Get the collection of settings used for each sample - we need one matrix control spot for each unique collection of settings *)
	(* The matrix model is included in the method, but to avoid downloading it, include it in our tuple *)
	minLaserPowers=Apply[List,Lookup[optionsWithReplicates,LaserPowerRange]][[All,1]];
	maxLaserPowers=Apply[List,Lookup[optionsWithReplicates,LaserPowerRange]][[All,2]];

	(* Sample setting tuples *)
	settingsPerSample=Transpose[{matrices,calibrants,calibrationMethods,minLaserPowers,maxLaserPowers,calibrantMatrices}];

	(* Gather how may martices for scan spots we need for this experiment, if MatrixControlScans is specified to False, return an empty list, which means not matrice control spots for this experiment. *)
	matricesForControlSpots=If[matrixControlScansQ,DeleteDuplicates[settingsPerSample][[All,1]],{}];

	(* Get the total volume taken from each matrix in the form <|sample1->totalVolume1, sample2->totalVolume2,...|>*)
	matrixControlSpotVolumes=Replace[Lookup[matrixSpottingVolumeLookup,matricesForControlSpots],Null->1 Microliter,{1}];

	(* Get the total volume taken from each matrix in the form <|matrix1->totalVolume1, matrix2->totalVolume2,...|>*)
	(* Each sample being spotted needs 0,1 or 2 layers of matrix depending on spotting method
		 Each control spot of matrix needs a single layer
	 *)
	matrixVolumePerSpot=matrixSpottingVolumes*Replace[spottingMethods,{Sandwich->2,OpenFace->1,Monolayer->0},{1}];
	volumePerMatrix=Merge[
		MapThread[
			<|#1->#2|>&,
			{Join[matrices,matricesForControlSpots],Join[matrixVolumePerSpot,matrixControlSpotVolumes]}
		],
		Total
	];

	(* Create a lookup linking each unique matrix to its resource *)
	matrixResourceLookup=KeyValueMap[
		Module[{amount,containers},
			amount=#2+50 Microliter;
			containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
			#1->Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[#1]]
		]&,
		volumePerMatrix
	];

	(* Get list of resources index-matched to the expanded matrices (and thus to the input samples) *)
	matrixResources=Lookup[matrixResourceLookup,matrices];

	(* - CalibrantMatrix Resources - *)

	(* Get the matrices control for calibrants, if MatrixControlScans is specified to False, return an empty list, which means not matrice control spots for this experiment. *)
	calibrantMatricesForControlSpots=If[matrixControlScansQ,DeleteDuplicates[settingsPerSample][[All,6]],{}];

	(* Get the total volume taken from each matrix in the form <|sample1->totalVolume1, sample2->totalVolume2,...|>*)
	calibrantMatrixControlSpotVolumes=Replace[Lookup[calibrantMatrixSpottingVolumeLookup,calibrantMatricesForControlSpots],Null->1 Microliter,{1}];

	(* Get the total volume taken from each matrix in the form <|matrix1->totalVolume1, matrix2->totalVolume2,...|>*)
	(* Each sample being spotted needs 0,1 or 2 layers of matrix depending on spotting method
		 Each control spot of matrix needs a single layer
	 *)
	calibrantMatrixVolumePerSpot=calibrantMatrixSpottingVolumes*Replace[spottingMethods,{Sandwich->2,OpenFace->1,Monolayer->0},{1}];
	calibrantVolumePerMatrix=Merge[
		MapThread[
			<|#1->#2|>&,
			{Join[calibrantMatrices,calibrantMatricesForControlSpots],Join[calibrantMatrixVolumePerSpot,calibrantMatrixControlSpotVolumes]}
		],
		Total
	];

	(* Create a lookup linking each unique matrix to its resource *)
	calibrantMatrixResourceLookup=KeyValueMap[
		Module[{amount,containers},
			amount=#2+50 Microliter;
			containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
			#1->Resource[Sample->#1,Amount->amount,Container->containers,Name->"Calibrant "<>ToString[#1]]
		]&,
		calibrantVolumePerMatrix
	];

	(* Get list of resources index-matched to the expanded matrices (and thus to the input samples) *)
	calibrantMatrixResources=Lookup[calibrantMatrixResourceLookup,calibrantMatrices];


	(* - Calibrant Resources - *)
	(* Determine the number of calibrant spots needed - need one spot for each unique calibration method *)
	(* calibrantsForSpots=DeleteDuplicates[settingsPerSample][[All,2]]; *)
	calibrantsForSpots=settingsPerSample[[All,2]];

	(* Get the total volume taken from each calibrant in the form <|calibrant1->totalVolume1, calibrant2->totalVolume2,...|>*)
	calibrantSpottingVolumes=Lookup[optionsWithReplicates,CalibrantVolume];

	volumePerCalibrant=Merge[MapThread[<|#1->#2|>&,{calibrantsForSpots,calibrantSpottingVolumes}],Total];

	(* Create a lookup linking each unique calibrant to its resource *)
	calibrantResourceLookup=KeyValueMap[
		Module[{amount,containers},
			amount=#2+20 Microliter;
			containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
			#1->Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[#1]]
		]&,
		volumePerCalibrant
	];

	(* Get list of resources index-matched to the expanded calibrants (and thus to the input samples) *)
	calibrantResources=Lookup[calibrantResourceLookup,calibrants];

	(* MALDI Plate Resource - users don't buy this stainless steel plate, cleaned and returned in the protocol *)
	maldiPlateResource=Resource[Sample->maldiPlate,Rent->True];

	(* - MALDI Instrument Resource - *)
	(* 15 minutes to load all the files, 10 minutes to perform each calibration *)
	(* maldiSetUpTime will count as both instrument time and operator time *)
	maldiSetUpTime=15 Minute+Length[calibrantsForSpots]*10 Minute;

	(* 30 seconds to zap each spot *)
	maldiZapTime=(Length[matricesForControlSpots]+Length[calibrantsForSpots]+Length[samplesWithReplicates])*30 Second;

	(* Create a resource for the mass spectrometer *)
	massSpectrometerResource=Resource[Instrument->Lookup[optionsWithReplicates,Instrument],Time->maldiSetUpTime+maldiZapTime];

	(* - Sonciator Resources - *)
	(* Create a resource for the sonicators used to clean the MALDI plates *)
	(* We can select any $EquivalentInstrumentModelLookup from the three different types of Branson sonicators *)
	sonicatorResource=Resource[
		Instrument->Flatten[
			Replace[
			Link[{
				Model[Instrument, Sonicator, "id:3em6Zv9NjwJo"](*Branson 1800 - regular *) (* Only allowing this one because this one has the holder cap that can hold beaker in place *)
			}],
			Resources`Private`$EquivalentInstrumentModelLookup, 1]],
		Time->25 Minute (* 2 10-minute baths, assume 5 minutes to move in and out*)
	];

	(* - MALDI Plate Cleaning Resources - *)
	primaryCleaningResource=Resource[
		Sample->Model[Sample,"id:vXl9j5qEnnRD"],
		Amount->100 Milli Liter,
		Container->{Model[Container,Vessel,"600mL Pyrex Beaker"]},
		RentContainer->True
	];

	secondaryCleaningResource=Resource[
		Sample->Model[Sample,StockSolution,"id:Z1lqpMGjeepz"],
		Amount->100 Milli Liter,
		Container->{Model[Container,Vessel,"600mL Pyrex Beaker"]},
		RentContainer->True
	];

	(* --- WELL ASSIGNMENTS --- *)
	(* Call a helper used by the experiment, compiler and parser to determine the wells which should be spotted with analyze, with just matrix and with calibrant *)
	spottingPattern=Lookup[optionsWithReplicates,SpottingPattern];
	{wellAssignments,sufficientWellsTest}=maldiWellAssignments[gatherTests,spottingPattern,maldiPlatePacket,calibrationMethods,minLaserPowers,maxLaserPowers,matrices,calibrantMatrices,calibrants,matrixControlScansQ];

	(* Check if we have enough spaces on the maldi wells *)
	capacityOk=!MatchQ[wellAssignments,$Failed];

	(* separate the wells into differnece categoried *)
	{sampleWells,calibrantWells,matrixWells}=If[capacityOk,wellAssignments,{{},{},{}}];

	(* --- ESTIMATE CHECKPOINTS --- *)
	(* Get containers involved *)
	containersIn=DeleteDuplicates[sampleContainers];
	numberOfContainersInvolved=(Length[containersIn]+Length[uniqueCalibrants]+Length[uniqueMatrices]);

	(* 30 second/pick + 5 minute overhead *)
	resourcePickingTime=numberOfContainersInvolved*30 Second+5 Minute;

	(* 30 minutes to clean the plate, wait for any samples to dry *)
	samplePrepTime=30 Minute;

	(* MALDI set-up time, then assume time to put away samples, calibrants and matrix is the same as picking time, +5 minute for data exporting and instrument release *)
	dataAcquisitionTime=maldiSetUpTime+resourcePickingTime+5 Minute;

	(* 10 minutes to pick cleaning resources, wipe plate and place into sonicator; 10 minutes in the sonicator; 5 minutes to move into second sonicator and clean-up solvents *)
	(* Second sonication happens during a processing stage *)
	cleanUpTime=25 Minute;

	(* All time is in subprotocols *)
	postProcessingTime=1 Minute;

	(* Parse and store any remaining objects *)
	returningTime=10 Minute;

	(* Use specified operator, if no request, default to Level 0 *)
	operator=Replace[Lookup[optionsWithReplicates,Operator],Null->$BaselineOperator];

	(* Generate operator resources for each checkpoint *)
	{resourcePickingOperator,samplePrepOperator,dataAcquisitionOperator,cleanUpOperator,postProcessingOperator,returningOperator}=Map[
		Resource[Operator -> operator, Time -> #]&,
		{resourcePickingTime,samplePrepTime,dataAcquisitionTime,cleanUpTime,postProcessingTime,returningTime}
	];

	(* Create the Checkpoints field -- Note that in constrast to ESI we have "Cleaning Up" but NOT "Purging Instrument" *)
	(* be careful adding the correct check points inside the respective procedures *)
	checkpoints={
		{"Picking Resources",resourcePickingTime,"Samples required to execute this protocol are gathered from storage.",resourcePickingOperator},
		{"Preparing Samples",samplePrepTime,"Samples are aliquoted and deposited along with matrix onto a MALDI plate.",samplePrepOperator},
		{"Acquiring Data",dataAcquisitionTime,"Samples are ionized and their mass is analyzed.",dataAcquisitionOperator},
		{"Sample Post-Processing",postProcessingTime,"Any measuring of volume, weight, or sample imaging post experiment is performed.",postProcessingOperator},
		{"Cleaning Up",cleanUpTime,"The MALDI plate is cleaned.",cleanUpOperator},
		{"Returning Materials",returningTime,"Samples are retrieved from instrumentation and materials are cleaned and returned to storage.",returningOperator}
	};

	resources=Join[samplesInResources,calibrantResources,matrixResources,calibrantMatrixResources,
		{maldiPlateResource,massSpectrometerResource},
		{sonicatorResource,primaryCleaningResource,secondaryCleaningResource}
	];

	{resourcesOk,resourceTests}=If[gatherTests,
		Resources`Private`fulfillableResourceQ[resources,Output->{Result,Tests},Cache -> cache, Simulation -> simulation],
		{Resources`Private`fulfillableResourceQ[resources,Cache -> cache, Simulation -> simulation],{}}
	];

	(* FINALIZE PACKETS MALDI *)
	massSpecPacket=<|
		Object->CreateID[Object[Protocol, MassSpectrometry]],
		Replace[SamplesIn]->samplesInResources,
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@containersIn,
		UnresolvedOptions->templatedOptions,
		ResolvedOptions->optionsWithReplicates,
		ImageSample->Lookup[optionsWithReplicates,ImageSample],
		Replace[SamplesInStorage]->Lookup[optionsWithReplicates,SamplesInStorageCondition],
		Replace[CalibrantStorage]->Lookup[optionsWithReplicates,CalibrantStorageCondition],
		(* MALDI specific settings *)
		IonSource->MALDI,
		MassAnalyzer->TOF,

		(* Spotting Options *)
		Replace[SpottingMethods]->spottingMethods,
		SpottingPattern->spottingPattern,
		SpottingDryTime->Lookup[optionsWithReplicates,SpottingDryTime],
		Replace[SampleVolumes]->sampleSpottingVolumes,
		Replace[CalibrantVolumes]->calibrantSpottingVolumes,
		(*CalibrantVolume->calibrantSpottingVolume,*)

		(* Mass Spectrometer Options *)
		Replace[AcquisitionModes]->ConstantArray[MS,Length[samplesWithReplicates]],
		Replace[IonModes]->ionModes,
		Replace[MinMasses]->minMasses,
		Replace[MaxMasses]->maxMasses,
		Replace[MinLaserPowers]->UnitConvert[minLaserPowers,Percent],
		Replace[MaxLaserPowers]->UnitConvert[maxLaserPowers,Percent],
		Replace[AccelerationVoltages]->accelerationVoltages,
		Replace[LensVoltages]->lensVoltages,
		Replace[GridVoltages]->gridVoltages,
		Replace[DelayTimes]->delayTimes,
		Replace[Gains]->gains,
		ShotsPerRaster->Lookup[optionsWithReplicates,ShotsPerRaster],
		NumberOfShots->Lookup[optionsWithReplicates,NumberOfShots],

		(* Calibration *)
		Replace[SamplesInWells]->sampleWells,
		Replace[CalibrantWells]->calibrantWells,
		Replace[MatrixWells]->matrixWells,
		Replace[CalibrationMethods]->Link[calibrationMethods],
		AutomaticMALDICalibration->TrueQ[$AutomaticMALDICalibration],

		(* -- Resources -- *)
		Replace[Calibrants]->calibrantResources,
		Replace[Matrices]->matrixResources,
		Replace[CalibrantMatrices]->calibrantMatrixResources,
		MALDIPlate->maldiPlateResource,
		Instrument->massSpectrometerResource,
		Sonicator->sonicatorResource,
		PrimaryPlateCleaningSolvent->primaryCleaningResource,
		SecondaryPlateCleaningSolvent->secondaryCleaningResource,

		Replace[Checkpoints]->checkpoints
	|>;

	(* populateSamplePrepFields will handle replicates for sample prep, allow it to do work using original values *)
	prepPacket=populateSamplePrepFields[mySamples,resolvedOptions,Cache->cache, Simulation -> simulation];

	(* protocolPacket=Join[massSpecPacket,prepPacket]; *)
	protocolPacket=Association@@(ReplaceRule[Normal[massSpecPacket], Normal[prepPacket]]);

	(* Return requested output *)
	outputSpecification/.{
		Result -> If[capacityOk&&resourcesOk,
			{protocolPacket,newMethodPackets},
			{$Failed,$Failed}
		],
		Tests -> Prepend[resourceTests,sufficientWellsTest]
	}
];


(* ::Subsubsection::Closed:: *)
(*esiTripleQuadResourcePackets*)


DefineOptions[
	esiTripleQuadResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

(* NumberOfReplicates *)
esiTripleQuadResourcePackets[mySamples:{ObjectP[Object[Sample]]...},myUnresolvedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		allAvalableNeedleList,allRelaventNeedleModels,allRelaventNeedlePacket,aliquotVolumesWithReplicates,allResourceBlobs,
		bufferDeadVolume, bufferResource, bufferVolumes, calibrantSyringes,	calibrantSyringeNeedles,calibrantSyringeInfusionVolume,	calibrantSyringeResource,calibrantSyringeNeedleResource,
		cache, calibrantDownload, calibrantModels,calibrationTime, calibrantStorages, calibrantResourceLookup, calibrants, calibrantSampleModels,
		calibrantVolumePerSample, checkpoints, collisionCellExitVoltages,collisionEnergies, coneGasFlows, containersIn, dataAcquisitionTime,
		declusteringVoltages, desolvationGasFlows, desolvationTemperatures,dwellTimes, esiCapillaryVoltages, expandedInputs,
		expandedResolvedOptions, finalizedPacket,finalNeedleList,flowInjectionBuffersInvolved, flowInjectionQ, fragmentMassDetections,
		fragmentMinMasses,fragmentMaxMasses,fragmentMassSelections,acquisitionModes,
		fragments, frqTests, fulfillable, gatherTests, gradients,infusionFlowRates, infusionSyringes, infusionVolumes,infusionSyringeInnerDiameters,infusionSyringeModels,infusionSyringeNeedleResource,
		infusionSyringeResource,injectionType, injectionVolume, instrumentDownload, instrumentModel, instrumentSetupTime, ionGuideVoltages,
		ionModes, lcDetectors,massDetections,massSelections, massSpecPacket, massSpectrometerResource,
		massTolerances, maxMasses, messages, minMasses, msDetectors,multipleReactionMonitoringAssays,multipleReactionMonitoringAssayPackets, needleWashSolutionPlacements,
		needleWashSolutionResource, neutralLosses,numberOfContainersInvolved, numberOfReplicates, optionsRule,
		optionsWithReplicates, output, outputSpecification, previewRule,resolvedOptionsNoHidden, resourcePickingTime, resultRule,
		runDurations, sampleContainers,sampleContainerInnerDepth,sampleContainerInnerDepthReplicates,sampleDownload, sampleObjects,sampleResourceLookup, sampleRunTime, samplesInResources,
		samplesWithReplicates, sampleTemperature, sampleVolumes, scanModes,scanTimes, sharedFieldPacket, sourceTemperatures,
		systemFlushBufferContainer, systemFlushBufferPlacements,systemFlushBufferResource, systemFlushBufferVolume,
		systemFlushGradient, systemFlushGradientMethod,systemFlushGradientPacket, systemPrimeBufferContainer, simulation,
		systemPrimeBufferPlacements, systemPrimeBufferResource,systemPrimeBufferVolume, systemPrimeGradient,systemPrimeFlushPlateResource,
		systemPrimeGradientMethod, systemPrimeGradientPacket, testsRule,totalBufferVolumeNeeded, uniqueCalibrantModels, uniqueCalibrants,
		uniqueCalibrantSamples, uniqueCalibrantTuples,uniqueCalibrantStorages, uniquePlateContainers,volumePerCalibrant,volumePerSample,uniqueCalibrantResources,calibrationLoopCounts,
		defaultCalibrantP,defaultCalibrants,nonDefaultCalibrant,truncatedUniqueCalibrants,defaultOnlyCalibrantQ,detectors,
		calibrantPrimeBufferResource, calibrantPrimeInfusionSyringeResource, calibrantPrimeInfusionSyringeNeedleResource,
		calibrantFlushBufferResource, calibrantFlushInfusionSyringeResource, calibrantFlushInfusionSyringeNeedleResource,
		flushBufferResource, flushInfusionSyringeResource, flushInfusionSyringeNeedleResource
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Get our cache. *)
	cache=Lookup[ToList[ops], Cache, {}];
	simulation=Lookup[ToList[ops], Simulation, Simulation[]];

	(* Determine if we need to make replicate spots *)
	numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentMassSpectrometry, {mySamples}, myResolvedOptions];

	(* Repeat the inputs and options according to replicates *)
	{samplesWithReplicates,optionsWithReplicates}=expandMassSpecReplicates[mySamples,expandedResolvedOptions,numberOfReplicates];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentMassSpectrometry,
		RemoveHiddenOptions[ExperimentMassSpectrometry, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* --- SET-UP DOWNLOAD --- *)

	(*get the mass spectrometry instrument model *)
	instrumentModel=If[MatchQ[Lookup[myResolvedOptions,Instrument],ObjectP[Object[Instrument]]],
		cacheLookup[cache, Lookup[myResolvedOptions, Instrument], Model],
		Lookup[myResolvedOptions,Instrument]
	];

	(* Get objects in options *)
	calibrants=Download[Lookup[optionsWithReplicates,Calibrant],Object];

	(* Get the infusion syringes models*)
	infusionSyringeModels=Map[
		Function[{eachSyringe},
			Which[
				MatchQ[eachSyringe,ObjectP[Model[Container,Syringe]]], Download[eachSyringe,Object],
				MatchQ[eachSyringe,ObjectP[Object[Container,Syringe]]], Download[eachSyringe,Model[Object]],
				True, Null
			]
		],
		Lookup[optionsWithReplicates,InfusionSyringe]
	];


	(* Get unique calibrant objects *)
	calibrantStorages=Lookup[optionsWithReplicates,CalibrantStorageCondition];

	uniqueCalibrantTuples=DeleteDuplicates[Transpose[{calibrants,calibrantStorages}]];

	(*Generate unique calibrant storage conditions*)
	uniqueCalibrants=uniqueCalibrantTuples[[All,1]];
	uniqueCalibrantStorages=uniqueCalibrantTuples[[All,2]];

	(* User can specify objects or models, split so that we can download the right thing *)
	{uniqueCalibrantSamples,uniqueCalibrantModels}={Cases[uniqueCalibrants,ObjectP[Object[Sample]]],Cases[uniqueCalibrants,ObjectP[Model[Sample]]]};

	(*Search all avalable needle packets*)
	allAvalableNeedleList = allMassSpectrometrySearchResults["MassSpecCache"][[6]];

	(* --- SET-UP DOWNLOAD --- *)
	(* Download info needed to make packets *)
	{
		(*1*)sampleDownload,
		(*2*)calibrantDownload,
		(*3*)instrumentDownload,
		(*4*)allRelaventNeedlePacket,
		(*6*)infusionSyringeInnerDiameters
	}= Quiet[
		Download[
			{
				(*1*)mySamples,
				(*2*)uniqueCalibrantSamples,
				(*3*){instrumentModel},
				(*4*)allAvalableNeedleList,
				(*5*)infusionSyringeModels
			},
			{
				(*1*){Object,Container[Object],Container[Model][InternalDepth]},
				(*2*){Model[Object]},
				(*3*){Detectors,Objects[IntegratedHPLC[Detectors]]},
				(*4*){Packet[NeedleLength,ConnectionType,Bevel]},
				(*5*){InnerDiameter}
			},
			Cache->cache,
			Simulation -> simulation,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	 ];

	msDetectors=First[instrumentDownload[[All,1]]];

	(* if there are several, we'll take the first *)
	lcDetectors=DeleteCases[First[instrumentDownload[[All, 2]]], Null];

	(* - Extract downloaded values into relevant variables - *)
	sampleObjects=duplicateMassSpecReplicates[sampleDownload[[All,1]],numberOfReplicates];
	sampleContainers=duplicateMassSpecReplicates[sampleDownload[[All,2]],numberOfReplicates];

	sampleContainerInnerDepth=sampleDownload[[All,3]];
	sampleContainerInnerDepthReplicates=duplicateMassSpecReplicates[Flatten[sampleContainerInnerDepth],numberOfReplicates] /. ($Failed -> 0.5 Centimeter);
	calibrantSampleModels=calibrantDownload[[All,1]];

	calibrantModels=Replace[calibrants,AssociationThread[uniqueCalibrantSamples,calibrantSampleModels],{1}];

	(*Generate Needle and needle Models*)
	allRelaventNeedleModels=Experiment`Private`compatibleNeedles[Flatten[allRelaventNeedlePacket], MinimumLength -> #] & /@ sampleContainerInnerDepthReplicates;

	(*Collect first available needle model for each one*)
	(* Default to Reusable Stainless Steel Non-Coring 4 in x 18G Needle*)
	finalNeedleList=If[MemberQ[#,Model[Item,Needle,"id:XnlV5jmbZZpn"]],Model[Item,Needle,"id:XnlV5jmbZZpn"],FirstOrDefault[#]]&/@allRelaventNeedleModels;

	(* Lookup options needed below *)

	{
		(*1*)collisionCellExitVoltages,
		(*2*)collisionEnergies,
		(*3*)coneGasFlows,
		(*4*)declusteringVoltages,
		(*5*)desolvationGasFlows,
		(*6*)desolvationTemperatures,
		(*7*)dwellTimes,
		(*8*)esiCapillaryVoltages,
		(*9*)fragmentMassDetections,
		(*10*)fragments,
		(*11*)infusionFlowRates,
		(*12*)infusionSyringes,
		(*13*)infusionVolumes,
		(*14*)injectionType,
		(*15*)injectionVolume,
		(*16*)ionGuideVoltages,
		(*17*)ionModes,
		(*18*)massDetections,
		(*19*)massTolerances,
		(*20*)multipleReactionMonitoringAssays,
		(*21*)neutralLosses,
		(*22*)runDurations,
		(*23*)sampleTemperature,
		(*24*)scanModes,
		(*25*)scanTimes,
		(*26*)sourceTemperatures
	}=Lookup[
		optionsWithReplicates,
		{
			(*1*)CollisionCellExitVoltage,
			(*2*)CollisionEnergy,
			(*3*)ConeGasFlow,
			(*4*)DeclusteringVoltage,
			(*5*)DesolvationGasFlow,
			(*6*)DesolvationTemperature,
			(*7*)DwellTime,
			(*8*)ESICapillaryVoltage,
			(*9*)FragmentMassDetection,
			(*10*)Fragment,
			(*11*)InfusionFlowRate,
			(*12*)InfusionSyringe,
			(*13*)InfusionVolume,
			(*14*)InjectionType,
			(*15*)InjectionVolume,
			(*16*)IonGuideVoltage,
			(*17*)IonMode,
			(*18*)MassDetection,
			(*19*)MassTolerance,
			(*20*)MultipleReactionMonitoringAssays,
			(*21*)NeutralLoss,
			(*22*)RunDuration,
			(*23*)SampleTemperature,
			(*24*)ScanMode,
			(*25*)ScanTime,
			(*26*)SourceTemperature
		}
	];

	(*Separte MassDetections in to minMasses and maxMasses for Mass Span and Mass Selections for Mass Value and Mass value lists.*)
	{minMasses,maxMasses}=Transpose@Map[
		Function[{eachMassInput},
			If[
				MatchQ[eachMassInput,_Span],
				List@@eachMassInput,
				{Null,Null}
			]
		],
		massDetections
	];

	massSelections=Map[
		Function[{eachMassInput},
			If[
				MatchQ[eachMassInput, UnitsP[Gram/Mole] | {UnitsP[Gram/Mole] ..}],
				eachMassInput,
				Null
			]
		],
		massDetections
	];

	(*Separte FragmentMassDetections in to minMasses and maxMasses for Mass Span and Mass Selections for Mass Value and Mass value lists.*)

	{fragmentMinMasses,fragmentMaxMasses}=Transpose@Map[
		Function[{eachMassInput},
			If[
				MatchQ[eachMassInput,_Span],
				List@@eachMassInput,
				{Null,Null}
			]
		],
		fragmentMassDetections
	];

	fragmentMassSelections=Map[
		Function[{eachMassInput},
			If[
				MatchQ[eachMassInput, UnitsP[Gram/Mole] | {UnitsP[Gram/Mole] ..}],
				eachMassInput,
				Null
			]
		],
		fragmentMassDetections
	];

	(*Build a flowinjectionQ for convenience*)
	flowInjectionQ=MatchQ[injectionType,FlowInjection];

	(*Count how many syringe we gonna use and how many of them we gonna neeed *)
	infusionSyringeResource=If[flowInjectionQ,Null,(Resource[Sample->#])&/@infusionSyringes];

	(*Creat needle resources*)
	infusionSyringeNeedleResource=If[flowInjectionQ,Null,(Resource[Sample->#])&/@finalNeedleList];

	(*Resolve sample volumes based on injection and infusion volume*)
	sampleVolumes=If[flowInjectionQ,injectionVolume,infusionVolumes];

	(*Acquisition Mode*)
	acquisitionModes=If[MatchQ[#,True],MSMS,MS]&/@ fragments;

	(* --- CREATE RESOURCES --- *)

	(*get the number of unique plate containers*)
	uniquePlateContainers=DeleteDuplicates[Cases[sampleContainers,ObjectP[Object[Container,Plate]]]];

	(* - SampleIn Resources - *)
	(* Determine volume we're using - either enough to aliquot or enough to make the sample spot *)
	aliquotVolumesWithReplicates=Lookup[optionsWithReplicates,AliquotAmount];

	(* Get the total volume taken from each sample in the form <|sample1->totalVolume1, sample2->totalVolume2,...|>*)
	volumePerSample=Merge[MapThread[<|#1->#2|>&,{sampleObjects,aliquotVolumesWithReplicates}],Total];

	(* Create a lookup linking each unique sample to its resource *)
	sampleResourceLookup=KeyValueMap[
		If[!VolumeQ[#2],
			#1->Resource[Sample->#1,Name->ToString[#1]],
			#1->Resource[Sample->#1,Amount->#2,Name->ToString[#1]]
		]&,
		volumePerSample
	];

	(* Get list of resources index-matched to the input samples - this is expanded according to NumberOfReplicates *)
	samplesInResources=Lookup[sampleResourceLookup,sampleObjects];

	(* -- Calibrant Resources - *)
	(* -- Define the ESI-QQQ default calibrants*)
	defaultCalibrantP=(Model[Sample, StockSolution, Standard, "id:zGj91a7DEKxx"]|Model[Sample, StockSolution, Standard, "id:mnk9jOR70aJN"]);
	(* --Truncate our calibrants, limit user specified calibrant to only one*)
	defaultCalibrants=ToList[Cases[uniqueCalibrants, defaultCalibrantP]];

	defaultOnlyCalibrantQ= ContainsOnly[uniqueCalibrants,List@@defaultCalibrantP];
	(* --If user specified more than one their own calibrants, we only use and save one of them.*)
	nonDefaultCalibrant=If[defaultOnlyCalibrantQ,{},ToList[FirstCase[uniqueCalibrants, Except[defaultCalibrantP]]]];
	(* -- Join two list together for truncatedUniqueCalibrants*)
	truncatedUniqueCalibrants= Flatten[Join[defaultCalibrants,nonDefaultCalibrant]];


	(* The needle get's filled with 200 Microliter which is enough to perform the initial check plus the calibration *)
	calibrantVolumePerSample=0.5 Milliliter;

	(* Get the total volume taken from each calibrant in the form <|calibrant1->totalVolume1, calibrant2->totalVolume2,...|>*)
	(* if multiple samples require the same calibrant, we'll only calibrate once, so use 'truncatedUniqueCalibrants' here *)
	volumePerCalibrant=Merge[Map[<|#->calibrantVolumePerSample|>&,uniqueCalibrants],Total];

	(* Create a lookup linking each unique calibrant to its resource *)
	calibrantResourceLookup=KeyValueMap[
		Module[{amount,container},
			(* since we are using sryinge pump to do the calibrant, we will transfer it to calibrant we added 0.5 Milliliter as the dead volume to the syringe *)
			amount=#2+0.5 Milliliter;

			#1->Resource[Sample->#1,Amount->amount,Name->ToString[#1]]
		]&,
		volumePerCalibrant
	];


	(* Get list of resources index-matched to the expanded calibrants (and thus to the input samples ) *)
	(*calibrantResources=Lookup[calibrantResourceLookup,calibrants];*)

	uniqueCalibrantResources=Lookup[calibrantResourceLookup,truncatedUniqueCalibrants];

	(*Initialize loop count to track how many calibration loops are performed for each calibrant during the procedure*)
	calibrationLoopCounts=ConstantArray[0, Length[uniqueCalibrantResources]];

	(*For ESI-QQQ we run calibrant by syringe pump, *)
	(*First generate syringes and needle resources for that*)
	calibrantSyringes=ConstantArray[Model[Container, Syringe, "id:o1k9jAKOww7A"](*1mL All-Plastic Disposable Syringe*),Length[truncatedUniqueCalibrants]];
	calibrantSyringeNeedles=ConstantArray[Model[Item, Needle, "id:P5ZnEj4P88YE"](*21g x 1 Inch Single-Use Needle*),Length[truncatedUniqueCalibrants]];

	(*Calibrant volumes*)
	calibrantSyringeInfusionVolume=ConstantArray[calibrantVolumePerSample,Length[truncatedUniqueCalibrants]];

	(*Count how many syringe we gonna use and how many of them we gonna neeed *)
	calibrantSyringeResource=(Resource[Sample->#])&/@ calibrantSyringes;

	(*Creat needle resources*)
	calibrantSyringeNeedleResource=(Resource[Sample->#])&/@ calibrantSyringeNeedles;

	(* Create resource for calibrant prime/flush *)
	(* Prime *)
	calibrantPrimeBufferResource = Resource[Sample -> Model[Sample, StockSolution, "id:7X104v6zO6X9"](*1:1 LCMS-Grade Methanol/Milli-Q Water*), Amount -> 3 Milliliter, Container -> Model[Container, Vessel, "id:9RdZXvKBeeqL"](*20mL Glass Scintillation Vial*), Name -> "Pre-Calibration Prime Buffer"];
	calibrantPrimeInfusionSyringeResource = Resource[Sample -> Model[Container, Syringe, "id:o1k9jAKOww7A"](*1mL All-Plastic Disposable Syringe*), Name -> "Pre-Calibration Prime Syringe"];
	calibrantPrimeInfusionSyringeNeedleResource = Resource[Sample -> Model[Item, Needle, "id:P5ZnEj4P88YE"](*21g x 1 Inch Single-Use Needle*), Name -> "Pre-Calibration Prime Syringe Needle"];
	(* Flush *)
	calibrantFlushBufferResource = Resource[Sample -> Model[Sample, StockSolution, "id:7X104v6zO6X9"](*1:1 LCMS-Grade Methanol/Milli-Q Water*), Amount -> 3 Milliliter, Container -> Model[Container, Vessel, "id:9RdZXvKBeeqL"](*20mL Glass Scintillation Vial*), Name -> "Post-Calibration Flush Buffer"];
	calibrantFlushInfusionSyringeResource = Resource[Sample -> Model[Container, Syringe, "id:o1k9jAKOww7A"](*1mL All-Plastic Disposable Syringe*), Name -> "Post-Calibration Flush Syringe"];
	calibrantFlushInfusionSyringeNeedleResource = Resource[Sample -> Model[Item, Needle, "id:P5ZnEj4P88YE"](*21g x 1 Inch Single-Use Needle*), Name -> "Post-Calibration Flush Syringe Needle"];

	(* Create resource for post-direct injection flush *)
	(* Only need these in the direct infusion branch. *)
	flushBufferResource = Resource[Sample -> Model[Sample, StockSolution, "id:7X104v6zO6X9"](*1:1 LCMS-Grade Methanol/Milli-Q Water*), Amount -> 3 Milliliter, Container -> Model[Container, Vessel, "id:9RdZXvKBeeqL"](*20mL Glass Scintillation Vial*), Name -> "Post-Infusion Flush Buffer"];
	flushInfusionSyringeResource = Resource[Sample -> Model[Container, Syringe, "id:o1k9jAKOww7A"](*1mL All-Plastic Disposable Syringe*), Name -> "Post-Infusion Flush Syringe"];
	flushInfusionSyringeNeedleResource = Resource[Sample -> Model[Item, Needle, "id:P5ZnEj4P88YE"](*21g x 1 Inch Single-Use Needle*), Name -> "Post-Infusion Flush Syringe Needle"];

	(*Generate buffer dead volume*)
	bufferDeadVolume=150*Milliliter;

	(* we don't have gradient for the buffer; we'll use 100% Buffer A without for as long as the run takes, for each sample - so construct a dummy gradient here *)
	gradients=MapThread[{
		{Quantity[0.,"Minutes"],Quantity[100.,"Percent"],Quantity[0.,"Percent"], #2},
		{Quantity[Unitless[#1,Minute],"Minutes"],Quantity[100.,"Percent"],Quantity[0.,"Percent"], #2}
	}&,{runDurations,infusionFlowRates}];

	(* calculate the amount of buffer needed for all the runs together *)
	(* we use the helper from HPLC/FPLC/SFC for ths to interpolate *)
	bufferVolumes=Map[Function[{currentGradientTuple},
		calculateBufferUsage[
			currentGradientTuple[[All,{1, 2}]], (* the specific buffer line *)
			Max[currentGradientTuple[[All, 1]]], (* last time point *)
			currentGradientTuple[[All,{1,4}]], (* the flow rate profile *)
			Last[currentGradientTuple[[All, 2]]] (* the last percentage *)
		]
	],gradients];

	(* the total volume needed is the sum of the buffer needed for each sample *)
	totalBufferVolumeNeeded=Total[bufferVolumes];


	(* make the resource for the buffer *)
	bufferResource= If[flowInjectionQ,
		Resource[
			Sample -> Lookup[myResolvedOptions,Buffer],
			(*can't supply more than the volume of the container, but also can't go for less than the dead volume *)
			Amount -> Min[2 *Liter, bufferDeadVolume+totalBufferVolumeNeeded],
			Container -> Model[Container, Vessel, "id:rea9jlRPKB05"], (* 2L Glass Bottle, Detergent-Sensitive *)
			RentContainer -> True,
			Name -> CreateUUID[]
		],
		Null
	];

	(*make the resources for the needle wash solution*)
	needleWashSolutionResource= If[flowInjectionQ,
		Resource[
			Sample -> Lookup[myResolvedOptions,NeedleWashSolution],
			Amount -> 300 Milli Liter,
			Container -> Model[Container, Vessel, "id:4pO6dM5l83Vz"],  (* 1L Glass Bottle, Detergent-Sensitive *)
			RentContainer -> True,
			Name -> CreateUUID[]
		],
		Null
	];

	(*create the placement fields for the needle wash solution*)
	needleWashSolutionPlacements={
		{Link[needleWashSolutionResource],{"SM Wash Reservoir Slot"}}
	};

	(*get the instrument model packet*)
	(*Since we resolved this in ESI-QQQ option resolver, I will used resolved option instead of using this one.*)
	(*instrumentModelPacket=fetchPacketFromCache[instrumentModel,cache];*)

	(*for the system prime and flush we will defer to the default method*)
	systemPrimeGradientMethod=Object[Method, Gradient, "id:qdkmxzqZAGY4"]; (*Object[Method,Gradient,"System Prime Method for QTRAP 6500"];*)(* Milli-Q water for 15 minutes*)
	systemFlushGradientMethod=Object[Method, Gradient, "id:XnlV5jKXaknM"]; (*Object[Method,Gradient,"System Prime Method-Acquity I-Class UPLC FlowInjection"];*) (* 50% methanol in water for 15 minutes*)

	(*get the packet from the cache*)
	systemPrimeGradientPacket=fetchPacketFromCache[systemPrimeGradientMethod,cache];
	systemFlushGradientPacket=fetchPacketFromCache[systemFlushGradientMethod,cache];

	(*get the gradient tuple*)
	systemPrimeGradient=Lookup[systemPrimeGradientPacket,Gradient];
	systemFlushGradient=Lookup[systemFlushGradientPacket,Gradient];


	(*define the suitable containers for the priming*)
	systemPrimeBufferContainer=Model[Container, Vessel, "id:4pO6dM5l83Vz"]; (*1 liter detergent senstitive bottles*)
	systemFlushBufferContainer=Model[Container, Vessel, "id:4pO6dM5l83Vz"]; (*1 liter detergent senstitive bottles*)

	(* Determine volume of Cosolvent required for system prime run *)
	systemPrimeBufferVolume = calculateBufferUsage[
		systemPrimeGradient[[All,{1,2}]], (*the specific gradient*)
		Max[systemPrimeGradient[[All,1]]], (*the last time*)
		systemPrimeGradient[[All,{1,-1}]], (*the flow rate profile*)
		Last[systemPrimeGradient[[All,2]]] (*the last percentage*)
	];

	(* Create resource for SystemPrime's BufferA *)
	systemPrimeBufferResource =  Resource[
		Sample -> Lookup[systemPrimeGradientPacket,BufferA],
		Amount -> systemPrimeBufferVolume + bufferDeadVolume,
		Container -> systemPrimeBufferContainer,
		RentContainer -> True,
		Name -> CreateUUID[]
	];

	(*do the same for the system flushes*)
	(* Determine volume of buffer required for system flush run *)
	systemFlushBufferVolume = calculateBufferUsage[
		systemFlushGradient[[All,{1,2}]], (*the specific gradient (A in this case)*)
		Max[systemFlushGradient[[All,1]]], (*the last time*)
		systemFlushGradient[[All,{1,-1}]], (*the flow rate profile*)
		Last[systemFlushGradient[[All,2]]] (*the last percentage*)
	];

	(* Create resource for SystemPrime's BufferA *)
	systemFlushBufferResource =  Resource[
		Sample -> Lookup[systemFlushGradientPacket,BufferA],
		Amount -> systemPrimeBufferVolume + bufferDeadVolume,
		Container -> systemPrimeBufferContainer,
		RentContainer -> True,
		Name -> CreateUUID[]
	];

	(*For the SystemPrime and SystemFlush in ESI-QQQ, since we want to collect the data for system flush and prime but we don't want to run any sample, we will just put a empty 96-Well 2-mL plate and set injection volume == 0 mL and run the sample*)
	systemPrimeFlushPlateResource = Resource[
		Sample -> Model[Container, Plate,"96-well 2mL Deep Well Plate"],
		Name -> CreateUUID[]
	];


	(* Create placement field value for SystemPrime buffers *)
	systemPrimeBufferPlacements = {
		{Link[systemPrimeBufferResource], {"Buffer A Slot"}}
	};

	(* Create placement field value for SystemFlush buffers *)
	systemFlushBufferPlacements = {
		{Link[systemFlushBufferResource], {"Buffer A Slot"}}
	};

	(*Tranfer MultipleReacitonMonitoringAssays to a assaociation*)
	multipleReactionMonitoringAssayPackets=Map[
		Function[{eachMRMAssay},
			If[
				MatchQ[eachMRMAssay, Null],
				<|MS1Mass ->Null,
					CollisionEnergy -> Null,
					MS2Mass -> Null,
					DwellTime -> Null
				|>,
				Module[{transposedMRM},
					transposedMRM = Transpose@eachMRMAssay;
					<|MS1Mass -> transposedMRM[[1]],
						CollisionEnergy -> transposedMRM[[2]],
						MS2Mass -> transposedMRM[[3]],
						DwellTime -> transposedMRM[[4]]
					|>
				]
			]
		],

		multipleReactionMonitoringAssays
	];
	(* - Instrument Resource - *)

	(* consider 30 Minutes to configure the methods, and 20 minutes to perform each calibration *)
	instrumentSetupTime=30 Minute;

	(* the run time of data acquisition will be dictated by how many samples we have, and the run duration of each sample *)
	(* let's assume 3 minutes overhead for the injection and communication (in case of flowinjection) *)
	sampleRunTime=(Length[sampleObjects]*10 Minute)+Total[Lookup[optionsWithReplicates,RunDuration]];

	(* Create a resource for the mass spectrometer *)
	(* Note that even in the case of flow injection we do NOT consider priming and flushing as part of the resource since we don't give the user option to change that so why would we charge them *)
	massSpectrometerResource=Resource[Instrument->Lookup[optionsWithReplicates,Instrument],Time->(instrumentSetupTime+sampleRunTime)];

	(* --- ESTIMATE CHECKPOINTS --- *)
	(* Get containers involved *)
	containersIn=DeleteDuplicates[sampleContainers];
	numberOfContainersInvolved=(Length[containersIn]+Length[uniqueCalibrants]);

	flowInjectionBuffersInvolved=If[!flowInjectionQ,0,Length[{systemPrimeBufferResource,systemFlushBufferResource,needleWashSolutionResource,bufferResource}]];

	(* 30 second/pick + 5 minute overhead *)
	resourcePickingTime=numberOfContainersInvolved * 5 Minute + flowInjectionBuffersInvolved * 10Minute + 5 Minute;

	(* set-up time, then assume time to put away samples, calibrants and matrix is the same as picking time, +5 minute for data exporting and instrument release *)
	dataAcquisitionTime=sampleRunTime+resourcePickingTime+20 Minute;
	calibrationTime=40*Minute*Length[uniqueCalibrants];

	(*Generate detectors to be uploaded*)
	detectors=Flatten[If[flowInjectionQ,DeleteDuplicates[Join[lcDetectors,msDetectors]],msDetectors]];

	(* Create the Checkpoints field -- Note that in constrast to MALDI we do NOT have "Cleaning Up" but we do have "Purging Instrument" and "Flushing Instrument" *)
	(* be careful adding the correct check points inside the respective procedures *)
	checkpoints=If[flowInjectionQ,
		{
			{"Picking Resources",resourcePickingTime,"Samples required to execute this protocol are gathered from storage.",Resource[Operator->$BaselineOperator,Time ->resourcePickingTime]},
			{"Calibrate the Instrument",calibrationTime, "Check if the instrument is ready to run the sample, and calibrate the voltage offset if needed.",Resource[Operator->$BaselineOperator,Time ->(instrumentSetupTime+calibrationTime)]},
			{"Purging Instrument",3 Hour, "System priming buffers are connected to the LC instrument and the instrument's buffer lines, needle and pump seals are purged at a high flow rates.",Resource[Operator->$BaselineOperator,Time ->3*Hour]},
			{"Preparing Samples",0*Hour,"Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.",Resource[Operator->$BaselineOperator,Time -> 0*Minute]},
			{"Acquiring Data",dataAcquisitionTime,"The instrument is calibrated, and samples are injected and measured.",Resource[Operator->$BaselineOperator,Time ->(instrumentSetupTime+dataAcquisitionTime)]},
			{"Sample Post-Processing",0*Minute,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Resource[Operator->$BaselineOperator,Time ->0*Minute]},
			{"Flushing Instrument", 2 Hour, "Buffers are connected to the LC instrument and the instrument is flushed with each buffer at high flow rates.",Resource[Operator->$BaselineOperator,Time ->2*Hour]},
			{"Returning Materials", 20 Minute, "Samples are retrieved from instrumentation and materials are cleaned and returned to storage.", Resource[Operator->$BaselineOperator,Time ->20*Minute]}
		},
		{
			{"Picking Resources",resourcePickingTime,"Samples required to execute this protocol are gathered from storage.",Resource[Operator->$BaselineOperator,Time ->resourcePickingTime]},
			{"Preparing Samples",0*Hour,"Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.",Resource[Operator->$BaselineOperator,Time -> 0*Minute]},
			{"Calibrate the Instrument",calibrationTime, "Check if the instrument is ready to run the sample, and calibrate the voltage offset if needed.",Resource[Operator->$BaselineOperator,Time ->(instrumentSetupTime+calibrationTime)]},
			{"Acquiring Data",dataAcquisitionTime,"The instrument is calibrated, and samples are transferred then loaded to a syringe pump then injected to the instrument and get measured.",Resource[Operator->$BaselineOperator,Time ->(instrumentSetupTime+dataAcquisitionTime)]},
			{"Sample Post-Processing",0*Minute,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Resource[Operator->$BaselineOperator,Time ->0*Minute]},
			{"Returning Materials", 20 Minute, "Samples are retrieved from instrumentation and materials are cleaned and returned to storage.", Resource[Operator->$BaselineOperator,Time ->20*Minute]}
		}
	];


	(* FINALIZE PACKETS ESI-QQQ*)
	massSpecPacket=<|
		Object->CreateID[Object[Protocol, MassSpectrometry]],
		Replace[SamplesIn]->samplesInResources,
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@containersIn,
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->resolvedOptionsNoHidden,
		ImageSample->Lookup[optionsWithReplicates,ImageSample],
		Template -> Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated],

		Replace[SamplesInStorage]->Lookup[optionsWithReplicates,SamplesInStorageCondition],
		Replace[CalibrantStorage]->Lookup[optionsWithReplicates,CalibrantStorageCondition],

		(* Mass Spectrometer Options for ESI-QQQ *)
		IonSource->Lookup[optionsWithReplicates, IonSource],
		Replace[AcquisitionModes]->acquisitionModes,
		MassAnalyzer->Lookup[optionsWithReplicates, MassAnalyzer],
		(* if we're doing flow injection, we also need to pass the lc detectors in order to make sure to also create the lc methods (pda and inlet) *)
		Replace[Detectors]->detectors, (*Check this*)
		(* if we're doing flow injection, we also need to pass the AcquisitionTime so that we can use it for our processing stage. Doesn't hurt to populate it always *)
		AcquisitionTime->sampleRunTime,
		InjectionType->injectionType,
		Replace[IonModes]->ionModes,
		Replace[MinMasses]->minMasses,
		Replace[MaxMasses]->maxMasses,
		Replace[MassSelections]->massSelections,
		Replace[SourceTemperatures]-> sourceTemperatures,
		Replace[DesolvationTemperatures]->desolvationTemperatures,
		Replace[DesolvationGasFlows]-> desolvationGasFlows,
		Replace[ConeGasFlows]-> coneGasFlows,
		Replace[DeclusteringVoltages]-> declusteringVoltages,
		Replace[ESICapillaryVoltages]-> esiCapillaryVoltages,
		Replace[IonGuideVoltages]->ionGuideVoltages,
		Replace[RunDurations]->runDurations,
		Replace[ScanTimes]->scanTimes,
		Replace[InfusionFlowRates]->infusionFlowRates,
		(*We will use UniqueCalibranst to gather resources.*)
		Replace[Calibrants]->Link[calibrants],


		(*Tandem Mass Specific Options*)
		Replace[ScanModes]->scanModes,
		Replace[FragmentMinMasses]->fragmentMinMasses,
		Replace[FragmentMaxMasses]->fragmentMaxMasses,
		Replace[FragmentMassSelections]->fragmentMassSelections,
		Replace[MassTolerances]->massTolerances,
		Replace[CollisionEnergies]->collisionEnergies,
		Replace[CollisionCellExitVoltages]->collisionCellExitVoltages,
		Replace[NeutralLosses]->neutralLosses,
		Replace[DwellTimes]->dwellTimes,
		Replace[MultipleReactionMonitoringAssays]->multipleReactionMonitoringAssayPackets,

		Replace[CalibrantInfusionVolumes]->calibrantSyringeInfusionVolume,
		Replace[CalibrationLoopCounts]->calibrationLoopCounts,

		(* -- Resources -- *)
		Instrument->massSpectrometerResource,
		(* Populate the MassSpectrometryInstrument field to enable use of LCMS procedures *)
		MassSpectrometryInstrument -> massSpectrometerResource,

		(*Generate Calibrant Resources*)
		Replace[UniqueCalibrants]->uniqueCalibrantResources,
		Replace[CalibrantInfusionSyringes]->calibrantSyringeResource,
		Replace[CalibrantInfusionSyringeNeedles]->calibrantSyringeNeedleResource,

		(* Fields and resources to flush the infusion tubing and ion source capillary post-calibration. *)
		CalibrantPrimeBuffer -> calibrantPrimeBufferResource,
		CalibrantPrimeInfusionSyringe -> calibrantPrimeInfusionSyringeResource,
		CalibrantPrimeInfusionVolume -> 1 Milliliter,
		CalibrantPrimeInfusionSyringeNeedle -> calibrantPrimeInfusionSyringeNeedleResource,

		(* Fields and resources to flush the infusion tubing and ion source capillary post-calibration. *)
		CalibrantFlushBuffer -> calibrantFlushBufferResource,
		CalibrantFlushInfusionSyringe -> calibrantFlushInfusionSyringeResource,
		CalibrantFlushInfusionVolume -> 1 Milliliter,
		CalibrantFlushInfusionSyringeNeedle -> calibrantFlushInfusionSyringeNeedleResource,

		(* Fields and resources to flush the infusion tubing and ion source capillary post-infusion. *)
		(* Note: Calibration flush that occurs first is the prime. *)
		Sequence @@ If[MatchQ[injectionType, DirectInfusion],
			{
				FlushBuffer -> flushBufferResource,
				FlushInfusionSyringe -> flushInfusionSyringeResource,
				FlushInfusionVolume -> 1 Milliliter,
				FlushInfusionSyringeNeedle -> flushInfusionSyringeNeedleResource
			},
			{
				Nothing
			}
		],

		(*ESI Specific Syringe Pump*)
		Replace[InfusionSyringes]->infusionSyringeResource,
		Replace[InfusionSyringeNeedles]->infusionSyringeNeedleResource,
		Replace[InfusionVolumes]->If[!flowInjectionQ,infusionVolumes,Null],
		Replace[InfusionSyringeInnerDiameters]->If[!flowInjectionQ,Flatten[infusionSyringeInnerDiameters],Null],

		(* flow injection specific options and resources *)
		Replace[SampleVolumes]->sampleVolumes,
		SampleTemperature->sampleTemperature,
		Buffer->If[flowInjectionQ,bufferResource,Null],
		NeedleWashSolution->If[flowInjectionQ,needleWashSolutionResource,Null],
		SystemPrimeBuffer->If[flowInjectionQ,Link@(systemPrimeBufferResource),Null],
		SystemPrimeGradient->If[flowInjectionQ,Link@systemPrimeGradientMethod,Null],
		Replace[SystemPrimeBufferPlacements] -> If[flowInjectionQ,systemPrimeBufferPlacements,{}],
		SystemFlushBuffer->If[flowInjectionQ,systemFlushBufferResource,Null],
		SystemFlushGradient->If[flowInjectionQ,Link@systemPrimeGradientMethod],
		Replace[SystemFlushContainerPlacements] -> If[flowInjectionQ,systemFlushBufferPlacements],
		Replace[NeedleWashPlacements]->If[flowInjectionQ,needleWashSolutionPlacements],
		SystemPrimeFlushPlate->If[flowInjectionQ,Link[systemPrimeFlushPlateResource],Null],
		PlateSeal -> If[flowInjectionQ,
			Link[
				Resource[
					Sample -> Model[Item, PlateSeal, "id:Vrbp1jKZJ0Rm"]
				]
			],
			Null
		],
		TubingRinseSolution -> If[flowInjectionQ,
			Link[
				Resource[
					Sample -> Model[Sample, "Milli-Q water"],
					Amount -> 500 Milli Liter,
					(* 1000 mL Glass Beaker *)
					Container -> Model[Container, Vessel, "id:O81aEB4kJJJo"],
					RentContainer -> True
				]
			],
			Null
		],

		EstimatedProcessingTime->If[flowInjectionQ,Round[(instrumentSetupTime+sampleRunTime+10Minute),10Minute],Round[(instrumentSetupTime+dataAcquisitionTime),10Minute]],

		(* -- Checkpoints -- *)
		Replace[Checkpoints]->checkpoints
	|>;

	(* generate a packet with the shared sample prep and aliquotting fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples,expandedResolvedOptions,Cache->cache,Simulation -> simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, massSpecPacket];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache, Simulation -> simulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache, Simulation -> simulation],Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		{finalizedPacket,{}},
		{$Failed,{}}
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];


(* ::Subsubsection::Closed:: *)
(*ExperimentMassSpectrometry general helper functions*)


(* DEFINE HELPER FUNCTIONS TO CALL THROUGHOUT THE RESOLVER AND RESOURCE PACKET HELPERS *)

(* == findPacketFunction HELPER == *)
(* Lookup the packet given any form of an object *)
findPacketFunction[myObjectToFind:ObjectP[],myPacketList_List]:=SelectFirst[Cases[myPacketList,PacketP[]],MatchQ[Lookup[#,Object],Download[myObjectToFind,Object]]&];


(* == findModelPacketFunction HELPER == *)
(* Lookup the model packet given any form of an object *)
findModelPacketFunction[myObjectToFind:ObjectP[],myObjectPacketList_List,myModelPacketList_List]:=Module[
{containerPacket,modelPacket,objectModel},

	objectModel=If[MatchQ[myObjectToFind,ObjectP[Model]],
		myObjectToFind,
		Lookup[findPacketFunction[myObjectToFind,myObjectPacketList],Model]
	];

	findPacketFunction[objectModel,myModelPacketList]
];


(* == resolveAutomaticOption HELPER == *)
(* This helper takes in either single or multiple (indexmatched) option keys and return the value it should be resolved to via Automatic Resolution *)
(* This would be either the default value if we're in the respective ion source path, or Null if we're not *)
(* If the option was supplied, we return that user supplied value. If they were wrongly specified, we will have thrown an error, so in that case we just give back the user-provided input *)
(* this helper CAN be used inside the big resolving mapThread *)
resolveAutomaticOption[myOptionToResolve_,myOptions_,desiredResolution_]:=Module[{suppliedOptionValue},

(* get the supplied option value for this particular option *)
	suppliedOptionValue=Lookup[myOptions,myOptionToResolve];

	If[!ListQ[suppliedOptionValue],

	(* if we're dealing with a single option, we just turn it to the desired value *)
		If[MatchQ[suppliedOptionValue,Automatic],
			desiredResolution,
			suppliedOptionValue
		],
	(* Otherwise we map over the list and turn all Automatics to the desired value *)
		Map[
			If[MatchQ[#,Automatic],
				desiredResolution,
				#
			]&,Lookup[myOptions,myOptionToResolve]
		]
	]
];


(* == sampleTests HELPER == *)
(* Conditionally returns appropriate tests based on the number of failing samples and the gather tests boolean
	Inputs:
		testFlag - Indicates if we should actually make tests
		allSamples - The input samples
		badSamples - Samples which are invalid in some way
		testDescription - A description of the sample invalidity check
			- must be formatted as a template with an `1` which can be replaced by a list of samples or "all input samples"
	Outputs:
		out: {(_Test|_Warning)...} - Tests for the good and bad samples - if all samples fall in one category, only one test is returned *)
sampleTests[testFlag:False,testHead:(Test|Warning),allSamples_,badSamples_,testDescription_,cache_]:={};
sampleTests[testFlag:True,testHead:(Test|Warning),allSamples:{PacketP[]..},badSamples:{PacketP[]...},testDescription_String,cache_]:=Module[{
	numberOfSamples,numberOfBadSamples,allSampleObjects,badObjects,goodObjects},

	(* Convert packets to objects *)
	allSampleObjects=Lookup[allSamples,Object];
	badObjects=Lookup[badSamples,Object,{}];

	(* Determine how many of each sample we have - delete duplicates in case one of sample sets was sent to us with duplicates removed *)
	numberOfSamples=Length[DeleteDuplicates[allSampleObjects]];
	numberOfBadSamples=Length[DeleteDuplicates[badObjects]];

	(* Get a list of objects which are okay *)
	goodObjects=Complement[allSampleObjects,badObjects];

	Which[
	(* All samples are okay *)
		MatchQ[numberOfBadSamples,0],{testHead[StringTemplate[testDescription]["all input samples"],True,True]},

	(* All samples are bad *)
		MatchQ[numberOfBadSamples,numberOfSamples],{testHead[StringTemplate[testDescription]["all input samples"],False,True]},

	(* Mixed samples *)
		True,{
	(* Passing Test *)
		testHead[StringTemplate[testDescription][ObjectToString[goodObjects,Cache->cache]],True,True],
	(* Failing Test *)
		testHead[StringTemplate[testDescription][ObjectToString[badObjects,Cache->cache]],False,True]
	}
	]
];

(* == maldiWellAssignments HELPER == *)
(*	Returns
Input:
	gatherTests - Indicates if a message or a test should be thrown
	spottingPattern - Symbol indicating if every well should be spotted, or if every other well should be spotted
	maldiPlatePacket - MALDI model container packet containing NumberOfWells and AspectRatio
	calibrationMethods -
	minLaserPowers -
	maxLaserPowers -
	matrices -
	calibrants -
Output: wells to receive spots and test if generating {{analyteWells,calibrantWells,matrixWells},test}
*)
maldiWellAssignments[
	gatherTests:BooleanP,
	spottingPattern:SpottingPatternP,
	maldiPlatePacket:PacketP[Model[Container,Plate]],
	calibrationMethods:{ObjectReferenceP[]...},
	minLaserPowers:{PercentP..},
	maxLaserPowers:{PercentP..},
	matrices:{ObjectP[]..},
	calibrantMatrices:{ObjectP[]..},
	calibrants:{ObjectP[]..},
	matrixControlQ:BooleanP
	]:=Module[{
	listedWells,wells,settingsPerSample,uniqueCalibrationMethods,uniqueSettingCombos,numberOfAnalyteSpots,
	numberOfCalibrantSpots,numberOfMatrixSpots,numberOfWellsRequired,insufficientWells,test},

	(* If wells are to be spaced, map over each row of wells and alternate starting between 1st and 2nd well, then take every other well *)
	listedWells=If[MatchQ[spottingPattern,Spaced],
		MapIndexed[
			#1[[(Mod[First[#2+1],2]+1);;;;2]] &,
			AllWells[maldiPlatePacket]
		],
		AllWells[maldiPlatePacket]
	];

	wells=Flatten[listedWells];

	(* Get the collection of settings used for each sample *)
	settingsPerSample=Transpose[{calibrationMethods,matrices,calibrants,minLaserPowers,maxLaserPowers,calibrantMatrices}];

	(* Get the collection of settings used for each calibration *)
	uniqueCalibrationMethods=DeleteDuplicates[Transpose[{calibrationMethods,calibrantMatrices,calibrants}]];

	(* Get the unique collections of settings - we should make one matrix spot for each unique group of settings *)
	uniqueSettingCombos=DeleteDuplicates[settingsPerSample];

	(* Determine the number of each data type *)
	numberOfAnalyteSpots=Length[calibrationMethods];
	numberOfCalibrantSpots=Length[uniqueCalibrationMethods];

	(* for matrix control spots, if user specify MatrixControlScans if false, we won't assign any wells for matrix spots *)
	numberOfMatrixSpots=If[matrixControlQ,Length[uniqueSettingCombos],0];

	numberOfWellsRequired=numberOfAnalyteSpots+numberOfCalibrantSpots+numberOfMatrixSpots;

	insufficientWells=Length[wells]<numberOfWellsRequired;

	test=If[gatherTests,
		Test[
			TemplateApply[
				StringTemplate["The MALDI plate has enough wells for the `1` sample spots, `2` calibrant spots and `3` matrix control spots."],
				{numberOfAnalyteSpots,numberOfCalibrantSpots,numberOfMatrixSpots}
			],
			insufficientWells,
			False
		]
	];

	If[insufficientWells,
		{
			$Failed,
			If[gatherTests,
				test,
				Message[Error::ExceedsMALDIPlateCapacity,Length[wells],numberOfWellsRequired,numberOfAnalyteSpots,numberOfCalibrantSpots,numberOfMatrixSpots]
			]
		},
		Module[{spottedWells,analyteWells,controlWells,calibrantWells,matrixWells},
			(* Determine the wells associated with each set of data *)
			(* Compiler enforces that the first X wells are taken up by the X SamplesIn, next Y by the Y calibrant spots, last Z by the Z matrix spots *)
			spottedWells=Take[wells,numberOfWellsRequired];
			{analyteWells,controlWells}=TakeDrop[spottedWells,numberOfAnalyteSpots];
			{calibrantWells,matrixWells}=TakeDrop[controlWells,numberOfCalibrantSpots];

			{{analyteWells,calibrantWells,matrixWells},test}
		]
	]
];


(* == maldiWellAssignments HELPER == *)
(* expand samples/options for replicates *)
expandMassSpecReplicates[mySamples:{ObjectP[]...},options:{(_Rule|_RuleDelayed)..},numberOfReplicates:(_Integer|Null)]:=Module[
	{samplesWithReplicates,mapThreadOptions,optionsWithReplicates},

	(*Repeat the inputs if we have replicates*)
	samplesWithReplicates=duplicateMassSpecReplicates[mySamples,numberOfReplicates];

	(* Determine options index-matched to the input *)
	mapThreadOptions=Lookup[Select[OptionDefinition[ExperimentMassSpectrometry],MatchQ[Lookup[#,"IndexMatchingInput"],Except[Null]]&],"OptionSymbol"];

	(*Repeat MapThread options if we have replicates*)
	optionsWithReplicates=Map[
		If[MemberQ[mapThreadOptions,First[#]],
			First[#]->duplicateMassSpecReplicates[Last[#],numberOfReplicates],
			First[#]->Last[#]
		]&,
		options
	];

	{samplesWithReplicates,optionsWithReplicates}
];

(* == duplicateMassSpecReplicates HELPER == *)
(* Helper for expandMassSpecReplicates. Given non-expanded sample input, and the numberOfReplicate, repeat the inputs if we have replicates *)
duplicateMassSpecReplicates[value_,numberOfReplicates_]:=Module[{},
	If[MatchQ[numberOfReplicates,Null],
		value,
		Flatten[Map[ConstantArray[#,numberOfReplicates]&,value],1]
	]
];

(* Use memoization to store all mass spectrometry search information *)
allMassSpectrometrySearchResults[fakeString:_String] := allMassSpectrometrySearchResults[fakeString] = Module[{},
	(*Add allMassSpectrometrySearchResults to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`allMassSpectrometrySearchResults];

	Search[
		{
			Model[Sample,StockSolution,Standard],
			Model[Sample,Matrix],
			Model[Instrument,MassSpectrometer],
			Model[Container,Syringe],
			Model[Container, Vessel],
			Model[Item,Needle]
		},
		{
			(ReferencePeaksPositiveMode!=Null||ReferencePeaksNegativeMode!=Null)&&Deprecated!=True,
			Deprecated!=True,
			Deprecated!=True && DeveloperObject != True,
			Deprecated!=True&&(Field[Dimensions[[1]]] < (4* Centimeter))&&MaxVolume>=50*Microliter&&(ConnectionType == (SlipLuer | LuerLock)),
			NeckType == ("10/425" | "20/430") && Deprecated!=True,
			(Deprecated ===Null) && (ConnectionType === (SlipLuer | LuerLock))
		}
	]
];