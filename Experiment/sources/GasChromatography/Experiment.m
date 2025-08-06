(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(* Options *)


DefineOptions[ExperimentGasChromatography,
	Options :> {
		(* Instrument configuration *)

		(* Choose the GC instrument *)
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, GasChromatograph, "Agilent 8890 GCMS"],
			Description -> "The gas chromatograph used to separate analytes in a sample in the gas phase within a capillary stationary phase during this experiment.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, GasChromatograph], Object[Instrument, GasChromatograph]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Instruments",
						"Chromatography",
						"Gas Chromatography"
					}
				}
			]
		},
		(* Carrier gas selection (Configuration > Modules) *)
		{
			OptionName -> CarrierGas,
			Default -> Helium,
			Description -> "The gas to be used to push the vaporized analytes through the column during chromatographic separation of the samples injected into the gas chromatograph.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Helium] (*GCCarrierGasP*)
			],
			Category -> "Gas Input Configuration"
		},

		(* Inlet configuration *)

		(* Select the inlet *)
		{
			OptionName -> Inlet,
			Default -> Multimode,
			Description -> "The heated antechamber attached to the column into which the samples to be analyzed will be injected, and where those samples will be subsequently vaporized and pushed onto the column. See Figure 3.1 for more information about the inlet.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> GCInletP
			]
		},
		(* Inlet liner *)
		{
			OptionName -> InletLiner,
			Default -> Automatic,
			Description -> "The glass insert placed inside the inlet into which the sample is injected (to minimize any reaction of the analytes with the metal walls of the inlet) that will be installed in the inlet during this experiment. See Figure 3.1 for more information about the inlet.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, GCInletLiner], Object[Item, GCInletLiner]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Gas Chromatography",
						"GC Inlet Liners"
					}
				}
			]
		},
		(* Inlet liner O-ring *)
		{
			OptionName -> LinerORing,
			Default -> Automatic,
			Description -> "A compressible ring that forms a seal separating the inlet volume from the septum purge volume in the inlet, to be installed in the inlet during this experiment. See Figure 3.1 for more information about the inlet.",
			ResolutionDescription -> "Selects a fluoroelastomer O-ring unless the inlet temperature is above 350 C, in which case graphite will be selected.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, ORing], Object[Item, ORing]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Gas Chromatography",
						"GC Inlet Liner O-Rings"
					}
				}
			]
		},
		(* Inlet septum *)
		{
			OptionName -> InletSeptum,
			Default -> Automatic,
			Description -> "The barrier that the injection syringe will penetrate to inject the sample into the inlet, to be installed in the inlet during this experiment. See Figure 3.1 for more information about the inlet.",
			ResolutionDescription -> "Selects an Advanced Green septum unless the inlet temperature is above 350 C, in which case a bleed & temperature optimized septum will be selected.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Septum], Object[Item, Septum]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Gas Chromatography",
						"GC Inlet Septa"
					}
				}
			]
		},

		(* Column setup *)

		(* Column selection *)
		IndexMatching[
			IndexMatchingParent -> Column,
			{
				OptionName -> Column,
				Default -> Model[Item, Column, "HP-5ms Ultra Inert, 30 m, 0.25 mm ID, 0.25 \[Mu]m film thickness, 7 inch cage"],
				Description -> "The capillary tube containing a wall-coated stationary phase into which injected samples are carried from the inlet by the continuous flow of carrier gas. As the sample flows through the column, analytes in each injected sample are separated according to their differing interaction with the column stationary phase and boiling points.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Gas Chromatography",
							"Gas Chromatography Columns"
						}
					}
				]
			},
			{
				OptionName -> TrimColumn,
				Default -> False,
				Description -> "Indicates whether or not a length of the inlet end of the column will be separated from the remainder of the column and discarded, typically in an attempt to remove contamination of the inlet end of the column that may result from injections of samples containing nonvolatile and/or reactive compounds.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> TrimColumnLength,
				Default -> Automatic,
				Description -> "The length of the inlet end of the column to separate from the column and discard prior to installation of the column into the gas chromatograph.",
				ResolutionDescription -> "If TrimColumn is True, automatically set to 50 cm.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Meter, 100 * Meter],
					Units -> {1, {Meter, {Meter, Centimeter}}}
				]
			}
		],

		(* Condition column Boolean *)
		{
			OptionName -> ConditionColumn,
			Default -> True,
			Description -> "Indicates whether or not the column will be conditioned prior to the separation of samples.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		(* Column conditioning gas *)
		{
			OptionName -> ColumnConditioningGas,
			Default -> Automatic,
			Description -> "The carrier gas used to purge the column(s) during the column conditioning step, which occurs when the column is installed.",
			AllowNull -> False,
			Category -> "Column Preparation",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Helium]
			]
		},
		(* Column conditioning gas flow rate *)
		(*{
			OptionName -> ColumnConditioningGasFlowRate,
			Default -> Automatic,
			Description -> "The flow rate of carrier gas to be flowed through the column while it is heated to remove oxygen, water vapor, and other impurities that may have accumulated in the column during disuse.",
			ResolutionDescription -> "The conditioning gas flow rate is automatically set using the column internal diameter table.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0*Milliliter/Minute,10*Milliliter/Minute],
				Units -> Milliliter/Minute
			],
			Category -> "Column Preparation"
		},*)
		(* Column conditioning time and temperature *)
		{
			OptionName -> ColumnConditioningTime,
			Default -> Automatic,
			Description -> "The time for which carrier gas will be flowed through the column while it is heated to remove oxygen, water vapor, and other impurities that may have accumulated in the column during disuse prior to separation of standards and samples in the column during the experiment.",
			ResolutionDescription -> "The column conditioning time will be determined by the column length and polarity of the stationary phase according to Figure 3.2", (* TODO: Link this resolution description to a table in the helpfile *)
			AllowNull -> True,
			Category -> "Column Preparation",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Minute, 999.99 * Minute],
				Units -> {1, {Minute, {Minute, Hour}}}
			]
		},
		{
			OptionName -> ColumnConditioningTemperature,
			Default -> Automatic,
			Description -> "The temperature at which the column will be incubated while carrier gas is flowed through the column while it is heated to remove oxygen, water vapor, and other impurities that may have accumulated in the column during disuse prior to separation of standards and samples in the column during the experiment.",
			ResolutionDescription -> "The column conditioning temperature will be set to 20 Celsius above the highest temperature setpoint to be used during separation of the analytes, or the MaxColumnTemperature, whichever is lower.",
			AllowNull -> True,
			Category -> "Column Preparation",
			Widget -> Alternatives[Widget[
				Type -> Quantity,
				Pattern :> RangeP[30 * Celsius, 450 * Celsius],
				Units -> Celsius
			],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				]]
		},

		(* Injection tool setup *)

		(* Choose installed liquid injection syringe *)
		{
			OptionName -> LiquidInjectionSyringe,
			Default -> Automatic,
			Description -> "The combination of plunger, cylinder, and needle that will be used to penetrate the sample vial cap to aspirate a liquid sample that will be injected onto the column.",
			ResolutionDescription -> "If a liquid injection sample is specified, selects the smallest available liquid injection syringe that can accommodate the largest specified injection volume.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				PreparedContainer -> False,
				Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Gas Chromatography",
						"Liquid Injection Syringes for GC"
					}
				}
			]
		},
		(* Choose installed headspace injection syringe *)
		{
			OptionName -> HeadspaceInjectionSyringe,
			Default -> Automatic, (* 2500 uL headspace sample injection syringe *)
			Description -> "The combination of plunger, cylinder, and needle that will be used to penetrate the sample vial cap to aspirate a sample of the vial's gas volume (headspace) that will be injected onto the column.",
			ResolutionDescription -> "If a headspace injection sample is included, automatically selects a 2.5 mL headspace injection syringe.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				PreparedContainer -> False,
				Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Gas Chromatography",
						"Headspace Injection Syringes for GC"
					}
				}
			]
		},
		(* Choose installed SPME fiber *)
		(* https://www.palsystem.com/fileadmin/public/docs/Various/Smart_SPME_Fiber_Leaflet.pdf *)
		{
			OptionName -> SPMEInjectionFiber,
			Default -> Automatic,
			Description -> "The filament of a stationary phase matrix with retractable sheath that will be used to selectively adsorb analytes from a sample matrix during a Solid Phase MicroExtraction (SPME), and then desorb those analytes onto the column.",
			ResolutionDescription -> "If Solid Phase MicroExtraction (SPME) injections are specified, a 30 \[Mu]m film thickness polydimethylsiloxane (PDMS) fiber will be used.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, SPMEFiber], Object[Item, SPMEFiber]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Gas Chromatography",
						"Solid Phase MicroExtraction (SPME) Fibers for GC"
					}
				}
			]
		},
		(* Choose installed liquid handling syringe *)
		{
			OptionName -> LiquidHandlingSyringe,
			Default -> Automatic,
			Description -> "The combination of plunger, cylinder, and needle that will be used to transfer liquid from specified dilution solvents into samples on the GC autosampler deck.",
			ResolutionDescription -> "Automatically selects a 2.5 mL liquid handling syringe if sample dilutions are specified.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				PreparedContainer -> False,
				Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Gas Chromatography",
						"Liquid Handling Syringes for GC"
					}
				}
			]
		},


		(* Dilution solvents *)
		{
			OptionName -> DilutionSolvent,
			Default -> Automatic,
			Description -> "A liquid solution that may be aliquoted robotically into samples on the GC autosampler.",
			ResolutionDescription -> "Automatically selects hexanes if dilutions are specified.",
			AllowNull -> True,
			Category -> "Solvent Configuration",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Reagents"
					}
				}
			]
		},
		{
			OptionName -> SecondaryDilutionSolvent,
			Default -> Automatic,
			Description -> "A liquid solution that may be aliquoted robotically into samples on the GC autosampler.",
			ResolutionDescription -> "Automatically selects hexanes if dilutions are specified.",
			AllowNull -> True,
			Category -> "Solvent Configuration",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Reagents"
					}
				}
			]
		},
		{
			OptionName -> TertiaryDilutionSolvent,
			Default -> Automatic,
			Description -> "A liquid solution that may be aliquoted robotically into samples on the GC autosampler.",
			ResolutionDescription -> "Automatically selects hexanes if dilutions are specified.",
			AllowNull -> True,
			Category -> "Solvent Configuration",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Reagents"
					}
				}
			]
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(* Dilute boolean *)
			{
				OptionName -> Dilute,
				Default -> Automatic,
				Description -> "Indicates whether or not an aliquot of a specified liquid solution will be added to the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically set to to True if any dilution parameters are specified.",
				AllowNull -> False,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Dilution volume using DilutionSolvent *)
			{
				OptionName -> DilutionSolventVolume,
				Default -> Automatic,
				Description -> "The volume of the DilutionSolvent to aliquot into the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically fills the sample's container to the sample container's MaxVolume with an equal volume mixture of each DilutionSolvent specified and the sample if Dilute is True.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[25 * Microliter, 2500 * Microliter], (* Total sample volume not to exceed the listed volume of the sample vial *)
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Dilution volume using SecondaryDilutionSolvent *)
			{
				OptionName -> SecondaryDilutionSolventVolume,
				Default -> Automatic,
				Description -> "The volume of the DilutionSolvent to aliquot into the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically fills the sample's container to the sample container's MaxVolume with an equal volume mixture of each DilutionSolvent specified and the sample if Dilute is True.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[25 * Microliter, 2500 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Dilution volume using TertiaryDilutionSolvent *)
			{
				OptionName -> TertiaryDilutionSolventVolume,
				Default -> Automatic,
				Description -> "The volume of the DilutionSolvent to aliquot into the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically fills the sample's container to the sample container's MaxVolume with an equal volume mixture of each DilutionSolvent specified and the sample if Dilute is True.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[25 * Microliter, 2500 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Vortex boolean *)
			{
				OptionName -> Vortex,
				Default -> Automatic,
				Description -> "Indicates whether or not the sample will be spun in place to mix (vortexed) prior to sampling.",
				ResolutionDescription -> "Automatically set to True if vortex parameters are specified.",
				AllowNull -> False,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Vortex speed: 0-2000 rpm *)
			{
				OptionName -> VortexMixRate,
				Default -> Automatic,
				Description -> "The rate (in RPM) at which the sample will be spun in place to mix (vortexed) in the vortex mixer prior to analysis.",
				ResolutionDescription -> "Automatically set to 750 RPM if the sample will be vortexed.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * RPM, 2000 * RPM],
					Units -> RPM
				]
			},
			(* Vortex time: 0-100 s *)
			{
				OptionName -> VortexTime,
				Default -> Automatic,
				Description -> "The amount of time for which the sample will be spun in place to mix (vortexed) prior to analysis.",
				ResolutionDescription -> "Automatically set to 10 seconds if the sample will be vortexed.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 100 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Agitate boolean *)
			{
				OptionName -> Agitate,
				Default -> Automatic,
				Description -> "Indicates whether or not the sample will be mixed by swirling the sample's container for a specified time at a specified rotational speed and incubated at a specified temperature prior to sampling.",
				ResolutionDescription -> "Automatically set to True if any agitation parameters are specified.",
				AllowNull -> False,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Agitator incubation time: 0-600 minutes def 0.2 minutes *)
			{
				OptionName -> AgitationTime,
				Default -> Automatic,
				Description -> "The time that each sample will be mixed by swirling the sample's container for a specified time at a specified rotational speed and incubated at a specified temperature in the agitator prior to sample aspiration for injection onto the column.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> Minute
				]
			},
			(* Agitator incubation temperature: 30-200C def 40 *)
			{
				OptionName -> AgitationTemperature,
				Default -> Automatic,
				Description -> "The temperature at which each sample will be mixed by swirling the sample's container for a specified time at a specified rotational speed and incubated at a specified temperature in the agitator prior to sample aspiration for injection onto the column.",
				ResolutionDescription -> "Automatically set to Ambient if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[30 * Celsius, 200 * Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				]
			},
			(* Agitator speed: 250-750 rpm def 250 *)
			{
				OptionName -> AgitationMixRate,
				Default -> Automatic,
				Description -> "The rate (in RPM) at which each sample will be swirled at in the agitator prior to analysis.",
				ResolutionDescription -> "Automatically set to 250 RPM if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[250 * RPM, 750 * RPM],
					Units -> RPM
				]
			},
			(* Agitator on time interval: 0-600s def 5 *)
			{
				OptionName -> AgitationOnTime,
				Default -> Automatic,
				Description -> "The amount of time for which the agitator will swirl before switching directions.",
				ResolutionDescription -> "Automatically set to 5 seconds if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 600 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Agitator off time interval: 0-600s def 2 *)
			{
				OptionName -> AgitationOffTime,
				Default -> Automatic,
				Description -> "The amount of time for which the agitator will idle while switching directions.",
				ResolutionDescription -> "Automatically set to 2 seconds if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 600 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},

			(* Select injection tool *)
			{
				OptionName -> SamplingMethod,
				Default -> Automatic,
				Description -> "The process by which a sample will be aspirated or analytes extracted in preparation for injection of those analytes onto the column to be separated.",
				ResolutionDescription -> "Selects a SamplingMethod of LiquidInjection unless the sample does not contain a liquid component, in which case HeadspaceInjection is selected.",
				AllowNull -> False,
				Category -> "Sampling Method",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> GCSamplingMethodP
				]
			}
		],

		(* Syringe wash solvents *)
		{
			OptionName -> SyringeWashSolvent,
			Default -> Automatic,
			Description -> "A liquid solution that will be used to flush the LiquidInjectionSyringe to remove residual impurities in the syringe prior to aspiration of the sample.",
			ResolutionDescription -> "Automatically set to hexanes if any pre-injection liquid syringe washing options using this solvent are specified.",
			AllowNull -> True,
			Category -> "Solvent Configuration",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Reagents"
					}
				}
			]
		},
		{
			OptionName -> SecondarySyringeWashSolvent,
			Default -> Automatic,
			Description -> "A liquid solution that will be used to flush the LiquidInjectionSyringe to remove residual impurities in the syringe prior to aspiration of the sample.",
			ResolutionDescription -> "Automatically set to hexanes if any pre-injection liquid syringe washing options using this solvent are specified.",
			AllowNull -> True,
			Category -> "Solvent Configuration",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Reagents"
					}
				}
			]
		},
		{
			OptionName -> TertiarySyringeWashSolvent,
			Default -> Automatic,
			Description -> "A liquid solution that will be used to flush the LiquidInjectionSyringe to remove residual impurities in the syringe prior to aspiration of the sample.",
			ResolutionDescription -> "Automatically set to hexanes if any pre-injection liquid syringe washing options using this solvent are specified.",
			AllowNull -> True,
			Category -> "Solvent Configuration",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Reagents"
					}
				}
			]
		},
		{
			OptionName -> QuaternarySyringeWashSolvent,
			Default -> Automatic,
			Description -> "A liquid solution that will be used to flush the LiquidInjectionSyringe to remove residual impurities in the syringe prior to aspiration of the sample.",
			ResolutionDescription -> "Automatically set to hexanes if any pre-injection liquid syringe washing options using this solvent are specified.",
			AllowNull -> True,
			Category -> "Solvent Configuration",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Reagents"
					}
				}
			]
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(* Pre injection syringe wash boolean *)
			{
				OptionName -> LiquidPreInjectionSyringeWash,
				Default -> Automatic,
				Description -> "Indicates whether the liquid injection syringe will be (repeatedly) filled with a volume of solvent which will subsequently be discarded, in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to True if any pre-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Pre injection syringe wash volume *)
			{
				OptionName -> LiquidPreInjectionSyringeWashVolume,
				Default -> Automatic,
				Description -> "The volume of the syringe wash solvent to aspirate and dispense using the liquid injection syringe in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the InjectionVolume if any pre-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			{
				OptionName -> LiquidPreInjectionSyringeWashRate,
				Default -> Automatic,
				Description -> "The aspiration rate that will be used to draw and dispense syringe wash solvent(s) in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the 5 microliters per second if any pre-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Microliter / Second, 100 Microliter / Second],
					Units -> Microliter / Second
				]
			},
			{
				OptionName -> LiquidPreInjectionNumberOfSolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> LiquidPreInjectionNumberOfSecondarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SecondarySyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> LiquidPreInjectionNumberOfTertiarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified TertiarySyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> LiquidPreInjectionNumberOfQuaternarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified QuaternarySyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			(* Sample wash master switch *)
			{
				OptionName -> LiquidSampleWash,
				Default -> Automatic,
				Description -> "Indicates whether the syringe will be washed with the sample prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to True for all samples with a corresponding SamplingMethod of LiquidInjection.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Sample washes: 0-10 def 1 *)
			{
				OptionName -> NumberOfLiquidSampleWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume of the sample using the liquid injection syringe in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 3 if a volume is specified for LiquidSampleWashVolume.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 10]
				]
			},
			(* Sample wash volume: 0-1000uL def 1 *)
			{
				OptionName -> LiquidSampleWashVolume,
				Default -> Automatic,
				Description -> "The volume of the sample that will be aspirateed and discarded in an attempt to remove any impurities in the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 125% of the InjectionVolume or the maximum volume of the injection syringe, whichever is smaller, if LiquidSampleWash is True.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Filling strokes: 0-15 def 4 *)
			{
				OptionName -> LiquidSampleFillingStrokes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and rapidly dispense the sample in an attempt to eliminate any bubbles from the cylinder of the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 4 if a value is set for LiquidSampleFillingStrokesVolume.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 15]
				]
			},
			(* Filling strokes volume: 0-1000uL def 3 *)
			{
				OptionName -> LiquidSampleFillingStrokesVolume,
				Default -> Automatic, (* Sample volume *)
				Description -> "The volume the sample to be aspirated and rapidly dispensed in an attempt to eliminate any bubbles from the cylinder of the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 125% of the InjectionVolume or the total syringe volume, whichever is smaller, if a number of LiquidSampleFillingStrokes is set.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Delay after filling strokes: 0-10 s def 0.5 s *)
			{
				OptionName -> LiquidFillingStrokeDelay,
				Default -> Automatic,
				Description -> "The amount of time to wait for any remaining bubbles to settle after aspirating and rapidly dispensing the sample in an attempt to eliminate any bubbles from the cylinder of the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 0.5 seconds if the SamplingMethod is LiquidInjection.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 10 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Sample vial penetration depth *)
			{
				OptionName -> SampleVialAspirationPosition,
				Default -> Top,
				Description -> "The extremity of the sample vial (Top or Bottom) where the tip of the injection syringe's needle or Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				AllowNull -> False,
				Category -> "Sample Aspiration",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> GCVialPositionP
				]
			},
			{
				OptionName -> SampleVialAspirationPositionOffset,
				Default -> Automatic,
				Description -> "The distance from the specified extremity of the sample vial (Top or Bottom) where the tip of the injection syringe's needle or Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				ResolutionDescription -> "Automatically set to 30 mm if SamplingMethod is LiquidInjection, 15 mm if SamplingMethod is HeadspaceInjection, or 40 mm if SamplingMethod is SPMEInjection.",
				AllowNull -> False,
				Category -> "Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Millimeter, 65 * Millimeter],
					Units -> Millimeter
				]
			},
			(* Sample vial penetration speed *)
			{
				OptionName -> SampleVialPenetrationRate,
				Default -> 20 * Millimeter / Second,
				Description -> "The velocity at which the tip of the injection syringe or fiber will penetrate the sample vial septum during aspiration or extraction of the sample.",
				AllowNull -> False,
				Category -> "Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Millimeter / Second, 75 * Millimeter / Second], (* Instrument limits: Liquid: 1-75 Headspace: 1-75 SPME: 2-75 *) (*  *)
					Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Centimeter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* sample volume: 0-1000uL def 1 *)
			{
				OptionName -> InjectionVolume,
				Default -> Automatic,
				Description -> "The amount of sample to draw into the liquid or headspace injection syringe for subsequent injection into the inlet.",
				ResolutionDescription -> "Automatically set to 25% of the LiquidInjectionSyringe volume if a LiquidInjectionSyringe is provided, or 2.5 \[Micro]L if the SamplingMethod is LiquidInjection, or 1.5 mL if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Microliter, 2500 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Air volume: 0-1000uL def 1 *)
			{
				OptionName -> LiquidSampleOverAspirationVolume,
				Default -> Automatic,
				Description -> "The volume of air to draw into the liquid injection syringe after aspirating the sample, prior to injection.",
				ResolutionDescription -> "Automatically set to 0 microliters if the SamplingMethod is LiquidInjection.",
				AllowNull -> True,
				Category -> "Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Sample aspirate flow rate: 0.1-100uL/s def 1 *)
			{
				OptionName -> SampleAspirationRate, (* Combine this with headspace option? *)
				Default -> Automatic,
				Description -> "The volume of sample per time unit at which the sample will be drawn into the injection syringe for subsequent injection onto the column.",
				ResolutionDescription -> "Automatically set to 1 microliters per second if the SamplingMethod is LiquidInjection, or 10 milliliters per minute if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Microliter / Second, 100 * Milliliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* Sample post aspirate delay: 0-10s def 2 *)
			{
				OptionName -> SampleAspirationDelay, (* Combine w headspace *)
				Default -> Automatic,
				Description -> "The amount of time for which the autosampler will pause after drawing the injection volume into the injection syringe, while the syringe remains in the sample environment. This pause is often used to develop an equilibrium between conditions in the sample environment and syringe contents.",
				ResolutionDescription -> "Automatically set to 2 seconds if the SamplingMethod is LiquidInjection or HeadspaceInjection, or Null if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 10 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Inlet penetration depth *)
			{
				OptionName -> InjectionInletPenetrationDepth,
				Default -> 45 * Millimeter,
				Description -> "The distance through the inlet septum that the tip of the injection syringe's needle or Solid Phase MicroExtraction (SPME) fiber tip will be positioned during injection of the sample.",
				AllowNull -> False,
				Category -> "Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Millimeter, 73 * Millimeter], (* Instrument limits: Liquid: 10-73 Headspace: 15-50 SPME: 15-65 *)
					Units -> Millimeter
				]
			},
			(* Inlet penetration speed *)
			{
				OptionName -> InjectionInletPenetrationRate,
				Default -> 75 * Millimeter / Second,
				Description -> "The speed at which the tip of the injection syringe's needle or Solid Phase MicroExtraction (SPME) fiber will penetrate the inlet septum during injection of the sample.",
				AllowNull -> False,
				Category -> "Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Millimeter / Second, 100 * Millimeter / Second], (* Instrument limits: Liquid: 2-100 Headspace: 1-100 SPME: 2-100 *)
					Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Centimeter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* Injection signal mode: Plunger up/Plunger down OR Before fiber exposed/After fiber exposed. We might want to use a generic "tool inserted"/"sample injected" and have the resolver figure out which option to change *)
			{
				OptionName -> InjectionSignalMode,
				Default -> PlungerDown,
				Description -> "Specifies whether the instrument will start the separation timer and data collection once the syringe tip is in position in the inlet but before the sample is dispensed (PlungerUp) or after the syringe's plunger has been depressed and the sample has been dispensed or exposed to the inlet (PlungerDown) during the sample injection.",
				AllowNull -> False,
				Category -> "Sample Injection",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (PlungerUp | PlungerDown)
				]
			},
			(* Pre injection time delay*)
			{
				OptionName -> PreInjectionTimeDelay,
				Default -> Null,
				Description -> "The amount of time for which the syringe's needle tip or Solid Phase MicroExtraction (SPME) fiber will be held in the inlet before the plunger is depressed and the sample is introduced into the inlet environment.",
				AllowNull -> True,
				Category -> "Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 15 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Injection flow rate: 1-250uL/s def 100 *)
			{
				OptionName -> SampleInjectionRate, (* Combine this with headspace option *)
				Default -> Automatic,
				Description -> "The volume of sample per time that will be dispensed into the inlet in order to transfer the sample onto the column.",
				ResolutionDescription -> "Automatically set to 50 microliters per second if the SamplingMethod is LiquidInjection, or 10 milliliters per minute if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Microliter / Second, 100 * Milliliter / Minute],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* Post injection time delay*)
			{
				OptionName -> PostInjectionTimeDelay,
				Default -> Null,
				Description -> "The amount of time the syringe's needle tip or Solid Phase MicroExtraction (SPME) fiber will be held in the inlet after the plunger has been completely depressed before it is withdrawn from the inlet.",
				AllowNull -> True,
				Category -> "Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 15 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Post injection syringe wash boolean *)
			{
				OptionName -> LiquidPostInjectionSyringeWash,
				Default -> Automatic,
				Description -> "Indicates whether the liquid injection syringe will be (repeatedly) filled with a volume of solvent which will subsequently be discarded, in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to True if any post-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Post injection syringe wash volume *)
			{
				OptionName -> LiquidPostInjectionSyringeWashVolume,
				Default -> Automatic,
				Description -> "The volume of the syringe wash solvent to aspirate and dispense using the liquid injection syringe in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the InjectionVolume if any post-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			{
				OptionName -> LiquidPostInjectionSyringeWashRate,
				Default -> Automatic,
				Description -> "The aspiration rate that will be used to draw and dispense syringe wash solvent(s) in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the 5 microliters per second if any post-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Microliter / Second, 100 Microliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			{
				OptionName -> LiquidPostInjectionNumberOfSolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> LiquidPostInjectionNumberOfSecondarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SecondarySyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> LiquidPostInjectionNumberOfTertiarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified TertiarySyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> LiquidPostInjectionNumberOfQuaternarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified QuaternarySyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			(* Wait for System Ready: ("At start"|"After solvent wash"|"After sample wash"|"After sample draw"|"After bubble elimination") *)
			{
				OptionName -> PostInjectionNextSamplePreparationSteps, (* was WaitForSystemReady *)
				Default -> Automatic,
				Description -> "The sample preparation step up to which the autosampling arm will proceed (as described in Figures 3.5, 3.6, 3.7, and 3.10) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected. If NoSteps are specified, the autosampler will wait until a separation is complete to begin preparing the next sample in the injection queue.",
				ResolutionDescription -> "Automatically set to NoSteps if the SamplingMethod is LiquidInjection.",
				AllowNull -> True,
				Category -> "Advanced Autosampler Options",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (NoSteps | SolventWash | SampleWash | SampleFillingStrokes | SampleAspiration)
				]
			},
			(* Syringe temperature: 40-150C, def 85 *)
			{
				OptionName -> HeadspaceSyringeTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the cylinder of the headspace syringe will be incubated throughout the experiment.",
				ResolutionDescription -> "Automatically set to Ambient if the SamplingMethod for the corresponding sample is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Cleaning",
				Widget -> Alternatives[Widget[
					Type -> Quantity,
					Pattern :> RangeP[40 * Celsius, 150 * Celsius],
					Units -> Celsius
				],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				]
			},
			(* Continuous flush: On/Off (flushes until next sample is prepared) *)
			{
				OptionName -> HeadspaceSyringeFlushing,
				Default -> Automatic,
				Description -> "Specifies whether a stream of Helium will be flowed through the cylinder of the headspace syringe without interruption between injections (Continuous), or if Helium will be flowed through the cylinder of the headspace syringe before and/or after sample aspiration for specified amounts of time.",
				ResolutionDescription -> "Automatically set to BeforeSampleAspiration if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Cleaning",
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Continuous]
					],
					Widget[
						Type -> MultiSelect,
						Pattern :> DuplicateFreeListableP[BeforeSampleAspiration | AfterSampleInjection]
					]
				]

			},
			(* Pre-injection flush time: 0-60s def 5 (flushes sample with z axis He) *)
			{
				OptionName -> HeadspacePreInjectionFlushTime,
				Default -> Automatic,
				Description -> "The amount of time to flow Helium through the cylinder of the headspace injection syringe (to remove residual analytes in the syringe barrel) before aspirating a sample.",
				ResolutionDescription -> "Automatically set to 3 seconds if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Cleaning",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 60 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Post-injection flush time: 0-600s def 10 *)
			{
				OptionName -> HeadspacePostInjectionFlushTime,
				Default -> Automatic,
				Description -> "The amount of time to flow Helium through the cylinder of the headspace injection syringe (to remove residual analytes in the syringe barrel) after injecting a sample.",
				ResolutionDescription -> "Automatically set to 3 seconds if HeadspaceSyringeFlushing includes BeforeSampleAspiration, or Null if HeadspaceSyringeFlushing is Continuous.",
				AllowNull -> True,
				Category -> "Post-Injection Syringe Cleaning",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 60 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Condition SPME Fiber *)
			{
				OptionName -> SPMECondition,
				Default -> Automatic,
				Description -> "Indicates whether or not the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in a flow of Helium prior to sample extraction to desorb residual analytes from the fiber.",
				ResolutionDescription -> "Automatically set to True if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Fiber conditioning station temperature: 40-350C def 40 *)
			{
				OptionName -> SPMEConditioningTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in flowing Helium prior to sample extraction to desorb residual analytes from the fiber.",
				ResolutionDescription -> "If SPMECondition is True, automatically set to the minimum recommended conditioning temperature associated with the SPME fiber.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[40 * Celsius, 350 * Celsius],
					Units -> Celsius
				]
			},
			(* Conditioning time: 0-600min def 0.1min *)
			{
				OptionName -> SPMEPreConditioningTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in flowing Helium prior to sample extraction to desorb residual analytes from the fiber.",
				ResolutionDescription -> "Automatically set to 30 minutes if the SPMECondition is True.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Define derivatizing agent *)
			{
				OptionName -> SPMEDerivatizingAgent,
				Default -> Automatic,
				Description -> "The matrix in which the Solid Phase MicroExtraction (SPME) fiber will be allowed to react prior to sample extraction.",
				ResolutionDescription -> "Automatically set to Hexanes if derivatization parameters are specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Reagents"
						}
					}
				]
			},
			(* Derivatizing agent adsorption time: 0-600 minutes def 0.2 minutes *)
			{
				OptionName -> SPMEDerivatizingAgentAdsorptionTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be allowed to react in the specified derivatizing agent prior to sample extraction.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the SPMEDerivatizingAgent is specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Derivatizing agent penetration depth: 10-70mm def 25 *)
			{
				OptionName -> SPMEDerivatizationPosition,
				Default -> Automatic,
				Description -> "The extremity of the sample vial (Top or Bottom) where the tip of the Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				ResolutionDescription -> "Automatically set to Top if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (Top | Bottom)
				]
			},
			{
				OptionName -> SPMEDerivatizationPositionOffset,
				Default -> Automatic,
				Description -> "The distance from the specified extremity of the sample vial (Top or Bottom) where the tip of the Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				ResolutionDescription -> "Automatically set to 25 mm if the SPMEDerivatizingAgent is specified.",
				AllowNull -> True,
				Category -> "Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Millimeter, 70 * Millimeter],
					Units -> Millimeter
				]
			},
			(* Sample while agitating *)
			{
				OptionName -> AgitateWhileSampling,
				Default -> Automatic,
				Description -> "Indicates whether the sample will be drawn or adsorbed while the sample is being swirled as specified by AgitationTime, AgitationTemperature, AgitationMixRate, AgitationOnTime, AgitationOffTime. This option must be True if the SamplingMethod is HeadspaceInjection, and is not available if the SamplingMethod is LiquidInjection.",
				ResolutionDescription -> "Automatically set to False if the SamplingMethod is SPMEInjection, or True if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Sample Aspiration",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Sample extraction time: 0-600 minutes def 0.2 *)
			{
				OptionName -> SPMESampleExtractionTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be left in contact with the sample environment to adsorb analytes onto the fiber.",
				ResolutionDescription -> "Automatically set to 10 minutes if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Sample desorption time: 0-600 minutes def 0.2 *)
			{
				OptionName -> SPMESampleDesorptionTime,
				Default -> Automatic, (* >= ExtractionTime *)
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be held inside the heated inlet, where analytes will be heated off the fiber and onto the column.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Postinjection conditioning time: 0-600 minutes def 0.1 *)
			{
				OptionName -> SPMEPostInjectionConditioningTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in flowing Helium after sample desorption onto the column to desorb residual analytes from the fiber.",
				ResolutionDescription -> "Automatically set to 0.5 minutes if SPMECondition is True.",
				AllowNull -> True,
				Category -> "Post-Injection Syringe Cleaning",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},

			(* === 3. GC INSTRUMENT METHOD === *)

			(* 3.1 Inlet options *)

			(* 3.1.1 Inlet temperature options *)

			(* Inlet temperature profile initial temp -160-450C *)
			{
				OptionName -> InitialInletTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the inlet, a heated, pressurized antechamber attached to the beginning of the column (see Figure 3.1 for more details), will be held at as the separation begins.",
				ResolutionDescription -> "Automatically set to 275 C if the InletTemperatureProfile is Isothermal, or the first point of the InletTemperatureProfile if this temperature is possible to determine. If it is not, automatically set to 100 C.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[40 * Celsius, 450 * Celsius],
					Units -> Celsius
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Inlet temperature profile initial hold time *)
			{
				OptionName -> InitialInletTemperatureDuration,
				Default -> Automatic,
				Description -> "The amount of time into the separation to hold the inlet at its InitialInletTemperature before beginning the inlet temperature profile.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the InletTemperatureProfile is a temperature profile, otherwise Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Inlet temperature profile {Rate (0-900C/min), Value (-160-450C), Hold time (0-999.99min) } *)
			{
				OptionName -> InletTemperatureProfile,
				Default -> Automatic,
				Description -> "Specifies the evolution of the inlet temperature over the course of the separation.",
				ResolutionDescription -> "Automatically set to the InitialInletTemperature.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-160 * Celsius, 450 * Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Isothermal]
					],
					(* "Standard" time/temperature profile *)
					Adder[{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						],
						"InletTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-160 * Celsius, 450 * Celsius],
							Units -> Celsius
						]
					}],
					(* "Weird" ramp rate profile *)
					Adder[{
						"InletTemperatureRampRate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Celsius / Minute, 900 * Celsius / Minute],
							Units -> CompoundUnit[{1, {Celsius, {Celsius, Fahrenheit}}}, {-1, {Second, {Hour, Minute, Second}}}]
						],
						"InletTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-160 * Celsius, 450 * Celsius],
							Units -> Celsius
						],
						"InletTemperatureHoldTime" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						]
					}]
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* Inlet options *)

			(* Inlet septum purge *)
			{
				OptionName -> InletSeptumPurgeFlowRate,
				Default -> Automatic,
				Description -> "The flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner (see Figure 3.1).",
				ResolutionDescription -> "Automatically set to 3 milliliters per minute.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Milliliter / Minute, 30 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.2 Split options *)

			(* Split ratio *)
			{
				OptionName -> SplitRatio,
				Default -> Automatic,
				Description -> "The ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column (see Figure 3.1). This value is equal to the theoretical ratio of the amount of injected sample that will pass onto the column to the amount of sample that will be eliminated from the inlet through the split valve.",
				ResolutionDescription -> "Automatically set to 10.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 7500]
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Split FlowRate: 0-1250 milliliters per minute *)
			{
				OptionName -> SplitVentFlowRate,
				Default -> Automatic,
				Description -> "The flow rate through the split valve that exits the instrument out the split vent (see Figure 3.1). If no SplitlessTime has been specified, this flow rate will be set for the duration of the separation.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Milliliter / Minute, 1250 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.3 Splitless options *)

			(* Splitless time *)
			{
				OptionName -> SplitlessTime,
				Default -> Automatic,
				Description -> "The amount of time into the separation for which to keep the split valve closed. After this time the split valve will open to allow the SplitVentFlowRate through the split valve (cannot be specified in conjunction with SplitRatio).",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.4 Pulsed injection options *)

			(* Injection Pulse Pressure: 0-100 psi *)
			{
				OptionName -> InitialInletPressure,
				Default -> Automatic,
				Description -> "The pressure at which the inlet will be set (in PSI gauge pressure) at the beginning of the separation.",
				ResolutionDescription -> "Automatically set to twice the initial column head pressure (as determined by the InitialColumnFlowRate, InitialColumnPressure, InitialColumnResidenceTime, or InitialColumnAverageVelocity) if an InitialInletTime is specified.", (* See http://www.sge.com/uploads/8e/ab/8eab977f6cac78408d503bb3ee2eafa1/TA-0025-C.pdf for Poiseuilles equation and relevant parameters incl. dynamic viscosity of carrier gases *)
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * PSI, 100 * PSI],
					Units -> PSI
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Injection pulse time: 0-999.99 minutes *)
			{
				OptionName -> InitialInletTime,
				Default -> Automatic,
				Description -> "The time into the separation for which the InitialInletPressure and/or SolventEliminationFlowRate will be maintained.",
				ResolutionDescription -> "Automatically set to 2 minutes if an InitialInletPressure is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.5 Gas saver *)

			(* Gas saver on/off *)
			{
				OptionName -> GasSaver,
				Default -> Automatic,
				Description -> "Indicates whether to reduce flow through the split vent after a certain time into the sample separation, reducing carrier gas consumption.",
				ResolutionDescription -> "If GasSaver parameters are specified, this is automatically set to True, otherwise False.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Gas Saver"
			},
			(* Gas saver FlowRate: 15-1250 milliliters per minute *)
			{
				OptionName -> GasSaverFlowRate,
				Default -> Automatic,
				Description -> "The carrier gas flow rate that the total inlet flow (flow onto column plus flow through the split vent) will be reduced to when the gas saver is activated.",
				ResolutionDescription -> "If GasSaver is True, this is automatically set to 25 milliliters per minute.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[15 * Milliliter / Minute, 1250 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Gas Saver"
			},
			(* Gas saver time *)
			{
				OptionName -> GasSaverActivationTime,
				Default -> Automatic,
				Description -> "The amount of time after the beginning of the separation that the gas saver will be activated.",
				ResolutionDescription -> "If GasSaver is True, this is automatically set to 6 residence times of the inlet liner.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Gas Saver"
			},

			(* 3.1.6 MMI Solvent Vent: https://www.agilent.com/cs/library/usermanuals/Public/G3510-90020.pdf *)

			(* MMI solvent vent flow rate 0-1250 milliliters per minute *)
			{
				OptionName -> SolventEliminationFlowRate,
				Default -> Automatic,
				Description -> "The flow through the split valve that will be set at the beginning of the separation. If this option is specified, the split valve will be closed after the InitialInletTime. This option is often used in an attempt to selectively remove solvent from the inlet by also setting the initial inlet temperature to a temperature just above the boiling point of the sample solvent, then ramping the inlet temperature to a higher temperature to vaporize the remaining analytes.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter / Minute, 1250 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.2 Column options *)
			(* Initial column flow rate *)
			{
				OptionName -> InitialColumnFlowRate,
				Default -> Automatic,
				Description -> "The flow rate of carrier gas through the column at the beginning of the separation.",
				ResolutionDescription -> "Automatically set to 1.7 milliliters per minute, or calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter / Minute, 150 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Column Pressures and Flow Rates"
			},
			(* Initial column pressure *)
			{
				OptionName -> InitialColumnPressure,
				Default -> Automatic,
				Description -> "The column head pressure of carrier gas in PSI gauge pressure at the beginning of the separation.",
				ResolutionDescription -> "Automatically calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * PSI, 100 * PSI],
					Units -> PSI
				],
				Category -> "Column Pressures and Flow Rates"
			},
			(* Initial column average velocity *)
			{
				OptionName -> InitialColumnAverageVelocity,
				Default -> Automatic,
				Description -> "The length of the column divided by the average time taken by a molecule of carrier gas to travel through the column at the beginning of the separation.",
				ResolutionDescription -> "Automatically calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Centimeter / Second, 200 * Centimeter / Second],
					Units -> CompoundUnit[{1, {Centimeter, {Centimeter, Millimeter, Meter}}}, {-1, {Second, {Hour, Minute, Second}}}]
				],
				Category -> "Column Pressures and Flow Rates"
			},
			(* Initial column residence time *)
			{
				OptionName -> InitialColumnResidenceTime,
				Default -> Automatic,
				Description -> "The average time taken by a molecule of carrier gas to travel through the column at the beginning of the separation.",
				ResolutionDescription -> "Automatically calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second}}}
				],
				Category -> "Column Pressures and Flow Rates"
			},
			(* Initial setpoint hold time *)
			{
				OptionName -> InitialColumnSetpointDuration,
				Default -> Automatic,
				Description -> "The amount of time into the method to hold the column at a specified initial column parameter (InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime) before starting a pressure or flow rate profile.",
				ResolutionDescription -> "Automatically set to 2 min.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Column Pressures and Flow Rates"
			},

			(* Column pressure Profile *)
			{
				OptionName -> ColumnPressureProfile,
				Default -> Automatic,
				Description -> "Specifies the evolution of the column head pressure over the course of the separation.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[ConstantPressure]
					],
					Adder[
						{
							"Time" ->
								Widget[Type -> Quantity,
									Pattern :> RangeP[0 * Minute, 999.99 * Minute], Units -> {1, {Minute, {Minute, Second, Hour}}}],
							"ColumnPressure" ->
								Widget[Type -> Quantity,
									Pattern :> RangeP[0 * PSI, 100 * PSI], Units -> PSI]
						}
					],
					Adder[
						{
							"ColumnPressureRampRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * PSI / Minute, 150 * PSI / Minute],
								Units -> PSI / Minute
							],
							"ColumnPressure" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * PSI, 100 * PSI],
								Units -> PSI
							],
							"ColumnPressureHoldTime" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Minute, 999.99 * Minute],
								Units -> {1, {Minute, {Minute, Second, Hour}}}
							]
						}
					]
				],
				Category -> "Column Pressures and Flow Rates"
			},

			(* Column flow rate Profile *)
			{
				OptionName -> ColumnFlowRateProfile,
				Default -> Automatic,
				Description -> "Specifies the evolution of the column flow rate over the course of the separation.",
				ResolutionDescription -> "Automatically set to a ConstantFlowRate profile at the InitialColumnFlowRate.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[ConstantFlowRate]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Minute, 999.99 * Minute], Units -> {1, {Minute, {Minute, Second, Hour}}}
							],
							"ColumnFlowRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Milliliter / Minute, 30 * Milliliter / Minute], Units -> Milliliter / Minute
							]
						}
					],
					Adder[
						{
							"ColumnFlowRateRampRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Milliliter / Minute / Minute, 100 * Milliliter / Minute / Minute],
								Units -> Milliliter / Minute / Minute
							],
							"ColumnFlowRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Milliliter / Minute, 30 * Milliliter / Minute],
								Units -> Milliliter / Minute
							],
							"ColumnFlowRateHoldTime" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Minute, 999.99 * Minute],
								Units -> {1, {Minute, {Minute, Second, Hour}}}
							]
						}
					]
				],
				Category -> "Column Pressures and Flow Rates"
			},
			(* Column post-run flow rate: 0-25mL/min *)
			{
				OptionName -> PostRunFlowRate,
				Default -> Automatic,
				Description -> "The column flow rate that will be set at the end of the sample separation as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to the initial column flow rate if a PostRunOvenTime is specified and a ColumnFlowRateProfile (including ConstantFlowRate) is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter / Minute, 25 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Column Pressures and Flow Rates"
			}, (* Column post-run pressure: 30-450C *)
			{
				OptionName -> PostRunPressure,
				Default -> Automatic,
				Description -> "The column pressure that will be set at the end of the sample separation as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to the initial column pressure if a PostRunOvenTime is specified and a ColumnPressureProfile (including ConstantPressure) is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * PSI, 100 * PSI],
					Units -> PSI
				],
				Category -> "Column Pressures and Flow Rates"
			},

			(* 3.3 Column oven options *)

			(* Equilibration time: 0-999.99min *)
			{
				OptionName -> OvenEquilibrationTime,
				Default -> Automatic,
				Description -> "The duration of time for which the initial OvenTemperature will be held before allowing the instrument to begin the next separation.",
				ResolutionDescription -> "Automatically set to 2 minutes unless another value is specified by a SeparationMethod.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Column Oven Temperature Profile"
			},

			(* 3.3.1 Temperature Profile *)

			(* Column oven initial temp 30-450C *)
			{
				OptionName -> InitialOvenTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the column oven will be held at the beginning of the separation.",
				ResolutionDescription -> "Automatically set to 50 degrees Celsius unless another value is specified by a SeparationMethod.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[30 * Celsius, 450 * Celsius],
					Units -> Celsius
				],
				Category -> "Column Oven Temperature Profile"
			},
			(* Column oven temperature initial hold time *)
			{
				OptionName -> InitialOvenTemperatureDuration, (* Rename Duration *)
				Default -> Automatic,
				Description -> "The amount of time after sample injection for which the column oven will be held at its InitialOvenTemperature before starting the column oven temperature profile.",
				ResolutionDescription -> "Automatically set to 3 minutes.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Column Oven Temperature Profile"
			},
			(* Column Oven Temperature Profile Adder {Rate (0-120C/min), Value (30-450C), Hold time (0-999.99min) } *)
			{
				OptionName -> OvenTemperatureProfile, (*  *)
				Default -> Automatic,
				Description -> "Specifies the evolution of the column temperature over the course of the separation.",
				ResolutionDescription -> "Automatically set to a linear ramp at 20 C/min to 50 degrees Celsius below the maximum column temperature followed by a hold for 3 minutes if not specified.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Isothermal]
					],
					(* Constant temperature *)
					{
						"OvenTemperature" -> Widget[ (* refactor to ColumnTemperature *)
							Type -> Quantity,
							Pattern :> RangeP[-60 * Celsius, 450 * Celsius],
							Units -> Celsius
						],
						"OvenTemperatureDuration" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						]
					},
					(* "Weird" ramp rate profile *)
					Adder[{
						"OvenTemperatureRampRate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Celsius / Minute, 900 * Celsius / Minute, Inclusive -> Right],
							Units -> CompoundUnit[{1, {Celsius, {Celsius, Fahrenheit}}}, {-1, {Second, {Hour, Minute, Second}}}]
						],
						"OvenTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-60 * Celsius, 450 * Celsius],
							Units -> Celsius
						],
						"OvenTemperatureHoldTime" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						]
					}],
					(* "Standard" time/temperature profile *)
					Adder[{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						],
						"OvenTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-60 * Celsius, 450 * Celsius],
							Units -> Celsius
						]
					}]
				],
				Category -> "Column Oven Temperature Profile"
			},

			(* 3.3.2 Column oven post-run *)

			(* Column oven post-run temperature: 30-450C *)
			{
				OptionName -> PostRunOvenTemperature,
				Default -> Automatic,
				Description -> "The column oven temperature that will be set at the end of the sample separation as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to the initial column oven temperature if a PostRunOvenTime is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[30 * Celsius, 450 * Celsius],
					Units -> Celsius
				],
				Category -> "Column Oven Temperature Profile"
			},
			(* Column oven post-run time 0-999.99min*)
			{
				OptionName -> PostRunOvenTime, (* Time -> Duration *)
				Default -> Automatic, (* 2 minutes if set *)
				Description -> "The amount of time to hold the column oven at the PostRunOvenTemperature as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to 2 minutes if a PostRunOvenTemperature is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Column Oven Temperature Profile"
			},

			(* SEPARATION METHOD *)

			{
				OptionName -> SeparationMethod,
				Default -> Automatic,
				Description -> "A collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected.",
				ResolutionDescription -> "Automatically creates an Object[Method, GasChromatography] using the specified options if no SeparationMethod is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, GasChromatography]]
				],
				Category -> "Method"
			}
		],

		(* === 4. Detector setup === *)

		(* Choose the detector *)
		{
			OptionName -> Detector,
			Default -> FlameIonizationDetector,
			Description -> "The detector used to obtain data during this experiment.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> GCDetectorP
			],
			Category -> "Detectors"
		},
		(* 4.1 FID Options *)

		(* Choose FID makeup gas (Configuration > Modules) *)
		{
			OptionName -> FIDMakeupGas,
			Default -> Automatic,
			Description -> "The desired capillary makeup gas flowed into the Flame Ionization Detector (FID) during sample analysis.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Helium] (*InertGCCarrierGasP*)
			],
			Category -> "Flame Ionization Detector"
		},
		(* FID temperature *)
		{
			OptionName -> FIDTemperature,
			Default -> Automatic, (* From Agilent: if <150C, the flame will not light. We recommend a temperature >= 300C to prevent condensation damage. The detector temperature should be approximately 20C greater than the highest oven ramp temperature.*)
			Description -> "The temperature of the Flame Ionization Detector (FID) body during analysis of the samples.",
			ResolutionDescription -> "Automatically set to 300C if Detector is set to FlameIonizationDetector.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[150 * Celsius, 450 * Celsius],
				Units -> Celsius
			],
			Category -> "Flame Ionization Detector"
		},
		(* FID air flow rate *)
		{
			OptionName -> FIDAirFlowRate,
			Default -> Automatic , (* Agilent recommended setting 450*Milliliter/Minute *)
			Description -> "The flow rate of air supplied from a Zero Air generator as an oxidant to the Flame Ionization Detector (FID) during sample analysis.",
			ResolutionDescription -> "Automatically set to 450 milliliters per minute if Detector is set to FlameIonizationDetector.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Milliliter / Minute, 800 * Milliliter / Minute],
				Units -> Milliliter / Minute
			],
			Category -> "Flame Ionization Detector"
		},
		(* FID H2 flow rate *)
		{
			OptionName -> FIDDihydrogenFlowRate,
			Default -> Automatic , (* Agilent recommended setting 40*Milliliter/Minute, but the hydrogen/air ratio should be 8-12% to keep the flame lit. *)
			Description -> "The flow rate of dihydrogen gas supplied from a Dihydrogen generator as a fuel to the Flame Ionization Detector (FID) during sample analysis.",
			ResolutionDescription -> "Automatically set to 8.5% of the air flow if Detector is set to FlameIonizationDetector.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Milliliter / Minute, 100 * Milliliter / Minute],
				Units -> Milliliter / Minute
			],
			Category -> "Flame Ionization Detector"
		},
		(* FID makeup gas flow rate *)
		{
			OptionName -> FIDMakeupGasFlowRate,
			Default -> Automatic, (* Agilent recommended setting 50*Milliliter/Minute *)
			Description -> "The desired makeup gas flow rate added to the fuel flow supplied to the Flame Ionization Detector (FID) during sample analysis.",
			ResolutionDescription -> "Automatically set to 50 milliliters per minute if Detector is set to FlameIonizationDetector.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Milliliter / Minute, 100 * Milliliter / Minute],
				Units -> Milliliter / Minute
			],
			Category -> "Flame Ionization Detector"
		},
		(* FID carrier gas flow correction *)
		{
			OptionName -> CarrierGasFlowCorrection,
			Default -> Automatic,
			Description -> "Specifies which (if any) of the Flame Ionization Detector (FID) gas supply flow rates (Fuel or Makeup) will be adjusted as the column flow rate changes to keep the total flow into the FID constant during the separation.",
			ResolutionDescription -> "Automatically set to None if Detector is set to FlameIonizationDetector.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> (Fuel | Makeup | None)
			],
			Category -> "Flame Ionization Detector" (* change widget type to multiselect widget *)
		},
		(* FID Data Collection Frequency *)
		{
			OptionName -> FIDDataCollectionFrequency,
			Default -> Automatic,
			Description -> "The number of times per second (in Hertz) that data points will be collected by the Flame Ionization Detector (FID).",
			ResolutionDescription -> "Automatically set to 20 Hz.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[5 * Hertz, 10 * Hertz, 20 * Hertz, 50 * Hertz, 100 * Hertz, 200 * Hertz, 500 * Hertz, 1000 * Hertz]
			],
			Category -> "Flame Ionization Detector"
		},

		(* 4.2 MSD Options *)

		(* Transfer line temperature *)
		{
			OptionName -> TransferLineTemperature,
			Default -> Automatic,
			Description -> "The temperature at which the segment of column the extends out of the column oven and into the mass spectrometer is held.",
			ResolutionDescription -> "Automatically set to 20 C above the maximum oven temperature if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Celsius, 400 * Celsius],
				Units -> Celsius
			],
			Category -> "Mass Spectrometer"
		},
		(* MSD ionization type: EI or CI *)
		{
			OptionName -> IonSource,
			Default -> Automatic,
			Description -> "Specifies the method by which the analytes will be ionized. Electron Ionization uses a heated filament to create energetic electrons that collide with the gaseous analytes flowing into the mass spectrometer from the column, creating ionized fragments of the analytes that can be focused into the detector. Chemical ionization uses a reagent gas to intercept electrons from the filament to create primary ions that undergo subsequent reaction with the analytes flowing into the mass spectrometer from the column, ionizing the analytes more gently than the traditional Electron Ionization method, but also producing a different fragmentation pattern as a result of the chemical reactions taking place during ionization.",
			ResolutionDescription -> "Automatically set to ElectronIonization if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[ElectronIonization, ChemicalIonization]
			],
			Category -> "Mass Spectrometer"
		},
		{
			OptionName -> IonMode,
			Default -> Automatic,
			Description -> "Indicates whether positively or negatively charged molecular fragments will be analyzed by the mass spectrometer.",
			ResolutionDescription -> "Automatically set to Positive if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> IonModeP
			],
			Category -> "Mass Spectrometer"
		},
		(*{
			OptionName -> TuneMassSpectrometer,
			Default -> Automatic,
			Description -> "Indicates whether the mass spectrometer should automatically determine its optimal parameters, or if user specified parameters should be set.",
			ResolutionDescription -> "Automatically set to ElectronIonization if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Automatic,Manual]
			],
			Category -> "Mass Spectrometer"
		},
		(* CI: select reagent gas (if other than methane is offered) *)
		{
			OptionName -> ChemicalIonizationGas,
			Default -> Methane,
			Description -> "The temperature at which the segment of column the extends out of the column oven and into the mass spectrometer is held.",
			ResolutionDescription -> "Automatically set to ElectronIonization if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Methane]
			],
			Category -> "Mass Spectrometer"
		},*)

		(* Source Temp *)
		{
			OptionName -> SourceTemperature,
			Default -> Automatic,
			Description -> "The temperature at which the ionization source, where the sample is ionized inside the mass spectrometer, is held.",
			ResolutionDescription -> "Automatically set to 250 C if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Celsius, 300 * Celsius],
				Units -> Celsius
			],
			Category -> "Mass Spectrometer"
		},
		(* MS Quad Temperature *)
		{
			OptionName -> QuadrupoleTemperature,
			Default -> Automatic,
			Description -> "The temperature at which the parallel metal rods, which select the mass of ion to be analyzed inside the mass spectrometer, are held.",
			ResolutionDescription -> "Automatically set to 150 C if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Celsius, 200 * Celsius],
				Units -> Celsius
			],
			Category -> "Mass Spectrometer"
		},
		(* Solvent delay *)
		{
			OptionName -> SolventDelay,
			Default -> Automatic,
			Description -> "The amount of time into the separation after which the mass spectrometer will turn on its controlling voltages. This time should be set to a point in the separation after which the main solvent peak from the separation has already entered and exited the mass spectrometer to avoid damaging the filament.",
			ResolutionDescription -> "Automatically set to 3 minutes if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 * Minute, 1000 * Minute],
				Units -> {1, {Minute, {Minute, Second, Hour}}}
			],
			Category -> "Mass Spectrometer"
		},
		(* Gain factor *)
		{
			OptionName -> MassDetectionGain,
			Default -> Automatic,
			Description -> "The linear signal amplification factor applied to the ions detected in the mass spectrometer. A gain factor of 1.0 indicates a signal multiplication of 100,000 by the detector. Higher gain factors raise the signal sensitivity but can also cause a nonlinear detector response at higher ion abundances. It is recommended that the lowest possible gain that allows achieving the desired detection limits be used to avoid damaging the electron multiplier.",
			ResolutionDescription -> "Automatically set to 2.0 if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0.05, 25]
			],
			Category -> "Mass Spectrometer"
		},
		(* Trace Ion Detection *)
		{
			OptionName -> TraceIonDetection,
			Default -> Automatic,
			Description -> "Indicates whether a proprietary set of algorithms to reduce noise in ion abundance measurements during spectral collection, resulting in lower detection limits for trace compounds, will be used.",
			ResolutionDescription -> "Automatically set to False if Detector is set to MassSpectrometer.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Mass Spectrometer"
		},
		(* acquisition windows *)

		IndexMatching[
			IndexMatchingParent -> AcquisitionWindowStartTime,
			{
				OptionName -> AcquisitionWindowStartTime,
				Default -> Automatic,
				Description -> "The times during the separation at which the mass spectrometer will begin to collect data using the specified index-matched MassRanges and/or MassSelections.",
				ResolutionDescription -> "Automatically set to the SolventDelay if Detector is set to MassSpectrometer.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 1000 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Mass Spectrometer"
			},
			(* mass ranges *)
			{
				OptionName -> MassRange,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded during analysis.",
				ResolutionDescription -> "Automatically set to the range 50-500 m/z",
				AllowNull -> True,
				Widget -> List[
					"Min m/z" -> Widget[
						Type -> Number,
						Pattern :> RangeP[1.6, 1050]
					],
					"Max m/z" -> Widget[
						Type -> Number,
						Pattern :> RangeP[1.6, 1050]
					]
				],
				Category -> "Mass Spectrometer"
			},
			(* Threshold *)
			{
				OptionName -> MassRangeThreshold,
				Default -> Automatic,
				Description -> "The ion abundance above which a data point at any given m/z must exceed to be further analyzed.",
				ResolutionDescription -> "Automatically set to 0 if Detector is set to MassSpectrometer.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 99999, 1]
				],
				Category -> "Mass Spectrometer"
			},
			{
				OptionName -> MassRangeScanSpeed,
				Default -> Automatic,
				Description -> "The speed (in m/z per second) at which the mass spectrometer will collect data.",
				ResolutionDescription -> "Automatically set to 781 u/s if Detector is set to MassSpectrometer.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[49, 98, 195, 391, 781, 1562, 3125, 6250, 10000, 12500]
				],
				Category -> "Mass Spectrometer"
			},
			(* SIMMonitoredMass *)
			{
				OptionName -> MassSelection,
				Default -> Automatic,
				Description -> "The specific mass-to-charge ratios (m/z) and the time for which data will be collect at each specified m/z during data collection.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Adder[{
					"m/z" -> Widget[
						Type -> Number,
						Pattern :> RangeP[1.6, 1050, 0.1]
					],
					"Dwell time" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milli * Second, 500 Milli * Second, 1 * Milli * Second],
						Units -> {1, {Milli * Second, {Second, Micro * Second, Milli * Second}}}
					]
				}],
				Category -> "Mass Spectrometer"
			},
			(*SIMResolution*)
			{
				OptionName -> MassSelectionResolution,
				Default -> Automatic,
				Description -> "The m/z range window that may be transmitted through the quadrupole at the selected mass. Low resolution will allow a larger range of masses through the quadrupole and increase sensitivity and repeatability, but is not ideal for comparing adjacent m/z values as there may be some overlap in the measured abundances.",
				ResolutionDescription -> "Automatically set to Low if m/z ratios are specified in MassSelection.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Low, High]
				],
				Category -> "Mass Spectrometer"
			},
			(*SIMMassDetectionGain*)
			{
				OptionName -> MassSelectionDetectionGain,
				Default -> Automatic,
				Description -> "The arbitrary scaling factor that will be used to increase the detected signal during the collection of the corresponding list of selectively monitored m/z in MassSelection.",
				ResolutionDescription -> "Automatically set to the specified MassDetectionGain if Selected Ion Monitoring (SIM) m/z ratios are specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0.1, 25, 0.1]
				],
				Category -> "Mass Spectrometer"
			}

			(* manual tune parameters? *)

		],

		(* Sample vial storage conditions? *)

		(* Number of replicates per sample *)
		{
			OptionName -> NumberOfReplicates,
			Default -> 1,
			Description -> "The number of identical replicates to run using the sample.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterEqualP[1, 1]
			]
		},

		(* === 5. STANDARDS === *)

		IndexMatching[
			IndexMatchingParent -> Standard,

			(* 5.1 Define standards *)
			{
				OptionName -> Standard,
				Default -> Automatic,
				Description -> "A reference compound to inject into the instrument, often used for quantification or to check internal measurement consistency.",
				AllowNull -> True,
				Category -> "Standards",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Standards"
						}
					}
				]
			},
			{
				OptionName -> StandardVial,
				Default -> Automatic,
				Description -> "The container in which to prepare a reference compound to inject into the instrument, often used for quantification or to check internal measurement consistency.",
				AllowNull -> True,
				Category -> "Standards",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				]
			},
			{
				OptionName -> StandardAmount,
				Default -> Automatic,
				Description -> "The amount of a reference compound to prepare in a vial for subsequent injection into the instrument, often used for quantification or to check internal measurement consistency.",
				AllowNull -> True,
				Category -> "Standards",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 * Microliter, 20000 * Microliter],
						Units -> {1, {Microliter, {Microliter, Milliliter}}}
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 * Micro * Gram, 2000 * Micro * Gram],
						Units -> Micro * Gram
					]
				]
			},

			(* Index-matched options *)

			(* Dilute boolean *)
			{
				OptionName -> StandardDilute,
				Default -> Automatic,
				Description -> "Indicates whether or not an aliquot of a specified liquid solution will be added to the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically set to to True if any dilution parameters are specified.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Dilution volume using DilutionSolvent *)
			{
				OptionName -> StandardDilutionSolventVolume,
				Default -> Automatic,
				Description -> "The volume of the DilutionSolvent to aliquot into the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically fills the sample's container to the sample container's MaxVolume with an equal volume mixture of each DilutionSolvent specified and the sample if Dilute is True.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 2500 * Microliter], (* Total sample volume not to exceed the listed volume of the sample vial *)
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Dilution volume using SecondaryDilutionSolvent *)
			{
				OptionName -> StandardSecondaryDilutionSolventVolume,
				Default -> Automatic,
				Description -> "The volume of the DilutionSolvent to aliquot into the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically fills the sample's container to the sample container's MaxVolume with an equal volume mixture of each DilutionSolvent specified and the sample if Dilute is True.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 2500 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Dilution volume using TertiaryDilutionSolvent *)
			{
				OptionName -> StandardTertiaryDilutionSolventVolume,
				Default -> Automatic,
				Description -> "The volume of the DilutionSolvent to aliquot into the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically fills the sample's container to the sample container's MaxVolume with an equal volume mixture of each DilutionSolvent specified and the sample if Dilute is True.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 2500 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Vortex boolean *)
			{
				OptionName -> StandardVortex,
				Default -> Automatic,
				Description -> "Indicates whether or not the sample will be spun in place to mix (vortexed) prior to sampling.",
				ResolutionDescription -> "Automatically set to True if vortex parameters are specified.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Vortex speed: 0-2000 rpm *)
			{
				OptionName -> StandardVortexMixRate,
				Default -> Automatic,
				Description -> "The rate (in RPM) at which the sample will be spun in place to mix (vortexed) in the vortex mixer prior to analysis.",
				ResolutionDescription -> "Automatically set to 750 RPM if the sample will be vortexed.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * RPM, 2000 * RPM],
					Units -> RPM
				]
			},
			(* Vortex time: 0-100 s *)
			{
				OptionName -> StandardVortexTime,
				Default -> Automatic,
				Description -> "The amount of time for which the sample will be spun in place to mix (vortexed) prior to analysis.",
				ResolutionDescription -> "Automatically set to 10 seconds if the sample will be vortexed.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 100 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Agitate boolean *)
			{
				OptionName -> StandardAgitate,
				Default -> Automatic,
				Description -> "Indicates whether or not the sample will be mixed by swirling the sample's container for a specified time at a specified rotational speed and incubated at a specified temperature prior to sampling.",
				ResolutionDescription -> "Automatically set to True if any agitation parameters are specified.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Agitator incubation time: 0-600 minutes def 0.2 minutes *)
			{
				OptionName -> StandardAgitationTime,
				Default -> Automatic,
				Description -> "The time that each sample will be mixed by swirling the sample's container for a specified time at a specified rotational speed and incubated at a specified temperature in the agitator prior to sample aspiration for injection onto the column.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				]
			},
			(* Agitator incubation temperature: 30-200C def 40 *)
			{
				OptionName -> StandardAgitationTemperature,
				Default -> Automatic,
				Description -> "The temperature at which each sample will be mixed by swirling the sample's container for a specified time at a specified rotational speed and incubated at a specified temperature in the agitator prior to sample aspiration for injection onto the column.",
				ResolutionDescription -> "Automatically set to Ambient if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[30 * Celsius, 200 * Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				]
			},
			(* Agitator speed: 250-750 rpm def 250 *)
			{
				OptionName -> StandardAgitationMixRate,
				Default -> Automatic,
				Description -> "The rate (in RPM) at which each sample will be swirled at in the agitator prior to analysis.",
				ResolutionDescription -> "Automatically set to 250 RPM if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[250 * RPM, 750 * RPM],
					Units -> RPM
				]
			},
			(* Agitator on time interval: 0-600s def 5 *)
			{
				OptionName -> StandardAgitationOnTime,
				Default -> Automatic,
				Description -> "The amount of time for which the agitator will swirl before switching directions.",
				ResolutionDescription -> "Automatically set to 5 seconds if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 600 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Agitator off time interval: 0-600s def 2 *)
			{
				OptionName -> StandardAgitationOffTime,
				Default -> Automatic,
				Description -> "The amount of time for which the agitator will idle while switching directions.",
				ResolutionDescription -> "Automatically set to 2 seconds if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Standard Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 600 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},

			(* Select injection tool *)
			{
				OptionName -> StandardSamplingMethod,
				Default -> Automatic,
				Description -> "The process by which a sample will be aspirated or analytes extracted in preparation for injection of those analytes onto the column to be separated.",
				ResolutionDescription -> "Selects a SamplingMethod of LiquidInjection unless the sample does not contain a liquid component, in which case HeadspaceInjection is selected.",
				AllowNull -> True,
				Category -> "Standard Sampling Method",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> GCSamplingMethodP
				]
			},
			{
				OptionName -> StandardLiquidPreInjectionSyringeWash,
				Default -> Automatic,
				Description -> "Indicates whether the liquid injection syringe will be (repeatedly) filled with a volume of solvent which will subsequently be discarded, in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to True if any pre-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Pre injection syringe wash volume *)
			{
				OptionName -> StandardLiquidPreInjectionSyringeWashVolume,
				Default -> Automatic,
				Description -> "The volume of the syringe wash solvent to aspirate and dispense using the liquid injection syringe in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the InjectionVolume if any pre-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			{
				OptionName -> StandardLiquidPreInjectionSyringeWashRate,
				Default -> Automatic,
				Description -> "The aspiration rate that will be used to draw and dispense syringe wash solvent(s) in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the 5 microliters per second if any pre-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Microliter / Second, 100 Microliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			{
				OptionName -> StandardLiquidPreInjectionNumberOfSolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> StandardLiquidPreInjectionNumberOfSecondarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SecondarySyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> StandardLiquidPreInjectionNumberOfTertiarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified TertiarySyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> StandardLiquidPreInjectionNumberOfQuaternarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified QuaternarySyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			(* Sample wash master switch *)
			{
				OptionName -> StandardLiquidSampleWash,
				Default -> Automatic,
				Description -> "Indicates whether the syringe will be washed with the sample prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to True for all samples with a corresponding StandardSamplingMethod of LiquidInjection.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Sample washes: 0-10 def 1 *)
			{
				OptionName -> StandardNumberOfLiquidSampleWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume of the sample using the liquid injection syringe in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 3 if StandardLiquidSampleWash is True.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 10]
				]
			},
			(* Sample wash volume: 0-1000uL def 1 *)
			{
				OptionName -> StandardLiquidSampleWashVolume,
				Default -> Automatic,
				Description -> "The volume of the sample that will be aspirateed and discarded in an attempt to remove any impurities in the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 125% of the StandardInjectionVolume or the maximum volume of the injection syringe, whichever is smaller, if StandardLiquidSampleWash is True.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Filling strokes: 0-15 def 4 *)
			{
				OptionName -> StandardLiquidSampleFillingStrokes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and rapidly dispense the sample in an attempt to eliminate any bubbles from the cylinder of the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 4 if a value is set for StandardLiquidSampleFillingStrokesVolume.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 15]
				]
			},
			(* Filling strokes volume: 0-1000uL def 3 *)
			{
				OptionName -> StandardLiquidSampleFillingStrokesVolume,
				Default -> Automatic, (* Sample volume *)
				Description -> "The volume the sample to be aspirated and rapidly dispensed in an attempt to eliminate any bubbles from the cylinder of the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 125% of the StandardInjectionVolume or the total syringe volume, whichever is smaller, if a number of LiquidSampleFillingStrokes is set.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Delay after filling strokes: 0-10 s def 0.5 s *)
			{
				OptionName -> StandardLiquidFillingStrokeDelay,
				Default -> Automatic,
				Description -> "The amount of time to wait for any remaining bubbles to settle after aspirating and rapidly dispensing the sample in an attempt to eliminate any bubbles from the cylinder of the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 0.5 seconds if the SamplingMethod is LiquidInjection.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 10 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Sample vial penetration depth *)
			{
				OptionName -> StandardSampleVialAspirationPosition,
				Default -> Automatic,
				Description -> "The extremity of the sample vial (Top or Bottom) where the tip of the injection syringe's needle or Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				AllowNull -> True,
				Category -> "Standard Sample Aspiration",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> GCVialPositionP
				]
			},
			{
				OptionName -> StandardSampleVialAspirationPositionOffset,
				Default -> Automatic,
				Description -> "The distance from the specified extremity of the sample vial (Top or Bottom) where the tip of the injection syringe's needle or Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				ResolutionDescription -> "Automatically set to 30 mm if SamplingMethod is LiquidInjection, 15 mm if SamplingMethod is HeadspaceInjection, or 40 mm if SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Standard Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Millimeter, 65 * Millimeter],
					Units -> Millimeter
				]
			},
			(* Sample vial penetration speed *)
			{
				OptionName -> StandardSampleVialPenetrationRate,
				Default -> Automatic,
				Description -> "The velocity at which the tip of the injection syringe or fiber will penetrate the sample vial septum during aspiration or extraction of the sample.",
				AllowNull -> True,
				Category -> "Standard Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Millimeter / Second, 75 * Millimeter / Second], (* Instrument limits: Liquid: 1-75 Headspace: 1-75 SPME: 2-75 *) (*  *)
					Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Centimeter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* sample volume: 0-1000uL def 1 *)
			{
				OptionName -> StandardInjectionVolume,
				Default -> Automatic,
				Description -> "The amount of sample to draw into the liquid or headspace injection syringe for subsequent injection into the inlet.",
				ResolutionDescription -> "Automatically set to 25% of the LiquidInjectionSyringe volume if a LiquidInjectionSyringe is provided, or 2.5 \[Micro]L if the SamplingMethod is LiquidInjection, or 1.5 mL if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Standard Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Microliter, 2500 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Air volume: 0-1000uL def 1 *)
			{
				OptionName -> StandardLiquidSampleOverAspirationVolume,
				Default -> Automatic,
				Description -> "The volume of air to draw into the liquid injection syringe after aspirating the sample, prior to injection.",
				ResolutionDescription -> "Automatically set to 0 microliters if the SamplingMethod is LiquidInjection.",
				AllowNull -> True,
				Category -> "Standard Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Sample aspirate flow rate: 0.1-100uL/s def 1 *)
			{
				OptionName -> StandardSampleAspirationRate,
				Default -> Automatic,
				Description -> "The volume of sample per time unit at which the sample will be drawn into the injection syringe for subsequent injection onto the column.",
				ResolutionDescription -> "Automatically set to 1 microliters per second if the SamplingMethod is LiquidInjection, or 10 milliliters per minute if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Standard Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Microliter / Second, 100 * Milliliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* Sample post aspirate delay: 0-10s def 2 *)
			{
				OptionName -> StandardSampleAspirationDelay,
				Default -> Automatic,
				Description -> "The amount of time for which the autosampler will pause after drawing the injection volume into the injection syringe, while the syringe remains in the sample environment. This pause is often used to develop an equilibrium between conditions in the sample environment and syringe contents.",
				ResolutionDescription -> "Automatically set to 2 seconds if the SamplingMethod is LiquidInjection or HeadspaceInjection, or Null if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Standard Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 10 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Inlet penetration depth *)
			{
				OptionName -> StandardInjectionInletPenetrationDepth,
				Default -> Automatic,
				Description -> "The distance through the inlet septum that the tip of the injection syringe's needle or Solid Phase MicroExtraction (SPME) fiber tip will be positioned during injection of the sample.",
				AllowNull -> True,
				Category -> "Standard Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Millimeter, 73 * Millimeter], (* Instrument limits: Liquid: 10-73 Headspace: 15-50 SPME: 15-65 *)
					Units -> Millimeter
				]
			},
			(* Inlet penetration speed *)
			{
				OptionName -> StandardInjectionInletPenetrationRate,
				Default -> Automatic,
				Description -> "The speed at which the tip of the injection syringe's needle or Solid Phase MicroExtraction (SPME) fiber will penetrate the inlet septum during injection of the sample.",
				AllowNull -> True,
				Category -> "Standard Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Millimeter / Second, 100 * Millimeter / Second], (* Instrument limits: Liquid: 2-100 Headspace: 1-100 SPME: 2-100 *)
					Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Centimeter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* Injection signal mode: Plunger up/Plunger down OR Before fiber exposed/After fiber exposed. We might want to use a generic "tool inserted"/"sample injected" and have the resolver figure out which option to change *)
			{
				OptionName -> StandardInjectionSignalMode,
				Default -> Automatic,
				Description -> "Specifies whether the instrument will start the separation timer and data collection once the syringe tip is in position in the inlet but before the sample is dispensed (PlungerUp) or after the syringe's plunger has been depressed and the sample has been dispensed or exposed to the inlet (PlungerDown) during the sample injection.",
				AllowNull -> True,
				Category -> "Standard Sample Injection",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (PlungerUp | PlungerDown)
				]
			},
			(* Pre injection time delay*)
			{
				OptionName -> StandardPreInjectionTimeDelay,
				Default -> Automatic,
				Description -> "The amount of time for which the syringe's needle tip or Solid Phase MicroExtraction (SPME) fiber will be held in the inlet before the plunger is depressed and the sample is introduced into the inlet environment.",
				AllowNull -> True,
				Category -> "Standard Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 15 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Injection flow rate: 1-250uL/s def 100 *)
			{
				OptionName -> StandardSampleInjectionRate, (* Combine this with headspace option *)
				Default -> Automatic,
				Description -> "The volume of sample per time that will be dispensed into the inlet in order to transfer the sample onto the column.",
				ResolutionDescription -> "Automatically set to 50 microliters per second if the SamplingMethod is LiquidInjection, or 10 milliliters per minute if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Standard Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Microliter / Second, 100 * Milliliter / Minute],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* Post injection time delay*)
			{
				OptionName -> StandardPostInjectionTimeDelay,
				Default -> Automatic,
				Description -> "The amount of time the syringe's needle tip or Solid Phase MicroExtraction (SPME) fiber will be held in the inlet after the plunger has been completely depressed before it is withdrawn from the inlet.",
				AllowNull -> True,
				Category -> "Standard Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 15 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Post injection syringe wash boolean *)
			{
				OptionName -> StandardLiquidPostInjectionSyringeWash,
				Default -> Automatic,
				Description -> "Indicates whether the liquid injection syringe will be (repeatedly) filled with a volume of solvent which will subsequently be discarded, in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to True if any post-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Standard Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Post injection syringe wash volume *)
			{
				OptionName -> StandardLiquidPostInjectionSyringeWashVolume,
				Default -> Automatic,
				Description -> "The volume of the syringe wash solvent to aspirate and dispense using the liquid injection syringe in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the InjectionVolume if any post-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Standard Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			{
				OptionName -> StandardLiquidPostInjectionSyringeWashRate,
				Default -> Automatic,
				Description -> "The aspiration rate that will be used to draw and dispense syringe wash solvent(s) in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the 5 microliters per second if any post-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Standard Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Microliter / Second, 100 Microliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			{
				OptionName -> StandardLiquidPostInjectionNumberOfSolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Standard Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> StandardLiquidPostInjectionNumberOfSecondarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SecondarySyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Standard Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> StandardLiquidPostInjectionNumberOfTertiarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified TertiarySyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Standard Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> StandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified QuaternarySyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Standard Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			(* Wait for System Ready: ("At start"|"After solvent wash"|"After sample wash"|"After sample draw"|"After bubble elimination") *)
			{
				OptionName -> StandardPostInjectionNextSamplePreparationSteps, (* was WaitForSystemReady *)
				Default -> Automatic,
				Description -> "The sample preparation step up to which the autosampling arm will proceed (as described in Figures 3.5, 3.6, 3.7, and 3.10) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected. If NoSteps are specified, the autosampler will wait until a separation is complete to begin preparing the next sample in the injection queue.",
				ResolutionDescription -> "Automatically set to NoSteps if the SamplingMethod is LiquidInjection.",
				AllowNull -> True,
				Category -> "Standard Advanced Autosampler Options",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (NoSteps | SolventWash | SampleWash | SampleFillingStrokes | SampleAspiration)
				]
			},
			(* Syringe temperature: 40-150C, def 85 *)
			{
				OptionName -> StandardHeadspaceSyringeTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the cylinder of the headspace syringe will be incubated throughout the experiment.",
				ResolutionDescription -> "Automatically set to Ambient if the SamplingMethod for the corresponding sample is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Cleaning",
				Widget -> Alternatives[Widget[
					Type -> Quantity,
					Pattern :> RangeP[40 * Celsius, 150 * Celsius],
					Units -> Celsius
				],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				]
			},
			(* Continuous flush: On/Off (flushes until next sample is prepared) *)
			{
				OptionName -> StandardHeadspaceSyringeFlushing,
				Default -> Automatic,
				Description -> "Specifies whether a stream of Helium will be flowed through the cylinder of the headspace syringe without interruption between injections (Continuous), or if Helium will be flowed through the cylinder of the headspace syringe before and/or after sample aspiration for specified amounts of time.",
				ResolutionDescription -> "Automatically set to BeforeSampleAspiration if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Cleaning",
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Continuous]
					],
					Widget[
						Type -> MultiSelect,
						Pattern :> DuplicateFreeListableP[BeforeSampleAspiration | AfterSampleInjection]
					]
				]

			},
			(* Pre-injection flush time: 0-60s def 5 (flushes sample with z axis He) *)
			{
				OptionName -> StandardHeadspacePreInjectionFlushTime, (* can we retube the autosampling deck with N2 or Ar *)
				Default -> Automatic,
				Description -> "The amount of time to flow Helium through the cylinder of the headspace injection syringe (to remove residual analytes in the syringe barrel) before aspirating a sample.",
				ResolutionDescription -> "Automatically set to 3 seconds if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Cleaning",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 60 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Post-injection flush time: 0-600s def 10 *)
			{
				OptionName -> StandardHeadspacePostInjectionFlushTime,
				Default -> Automatic,
				Description -> "The amount of time to flow Helium through the cylinder of the headspace injection syringe (to remove residual analytes in the syringe barrel) after injecting a sample.",
				ResolutionDescription -> "Automatically set to 3 seconds if HeadspaceSyringeFlushing includes BeforeSampleAspiration, or Null if HeadspaceSyringeFlushing is Continuous.",
				AllowNull -> True,
				Category -> "Standard Post-Injection Syringe Cleaning",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 60 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Condition SPME Fiber *)
			{
				OptionName -> StandardSPMECondition,
				Default -> Automatic,
				Description -> "Indicates whether or not the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in a flow of Helium prior to sample extraction to desorb residual analytes from the fiber.",
				ResolutionDescription -> "Automatically set to True if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Fiber conditioning station temperature: 40-350C def 40 *)
			{
				OptionName -> StandardSPMEConditioningTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in flowing Helium prior to sample extraction to desorb residual analytes from the fiber.",
				ResolutionDescription -> "If SPMECondition is True, automatically set to the minimum recommended conditioning temperature associated with the SPME fiber.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[40 * Celsius, 350 * Celsius],
					Units -> Celsius
				]
			},
			(* Conditioning time: 0-600min def 0.1min *)
			{
				OptionName -> StandardSPMEPreConditioningTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in flowing Helium prior to sample extraction to desorb residual analytes from the fiber.",
				ResolutionDescription -> "Automatically set to 30 minutes if the SPMECondition is True.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Define derivatizing agent *)
			{
				OptionName -> StandardSPMEDerivatizingAgent,
				Default -> Automatic,
				Description -> "The matrix in which the Solid Phase MicroExtraction (SPME) fiber will be allowed to react prior to sample extraction.",
				ResolutionDescription -> "Automatically set to Hexanes if derivatization parameters are specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents"
						}
					}
				]
			},
			(* Derivatizing agent adsorption time: 0-600 minutes def 0.2 minutes *)
			{
				OptionName -> StandardSPMEDerivatizingAgentAdsorptionTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be allowed to react in the specified derivatizing agent prior to sample extraction.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the SPMEDerivatizingAgent is specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Derivatizing agent penetration depth: 10-70mm def 25 *)
			{
				OptionName -> StandardSPMEDerivatizationPosition,
				Default -> Automatic,
				Description -> "The extremity of the sample vial (Top or Bottom) where the tip of the Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				ResolutionDescription -> "Automatically set to Top if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (Top | Bottom)
				]
			},
			{
				OptionName -> StandardSPMEDerivatizationPositionOffset,
				Default -> Automatic,
				Description -> "The distance from the specified extremity of the sample vial (Top or Bottom) where the tip of the Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				ResolutionDescription -> "Automatically set to 25 mm if the SPMEDerivatizingAgent is specified.",
				AllowNull -> True,
				Category -> "Standard Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Millimeter, 70 * Millimeter],
					Units -> Millimeter
				]
			},
			(* Sample while agitating *)
			{
				OptionName -> StandardAgitateWhileSampling,
				Default -> Automatic,
				Description -> "Indicates whether the sample will be drawn or adsorbed while the sample is being swirled as specified by AgitationTime, AgitationTemperature, AgitationMixRate, AgitationOnTime, AgitationOffTime. This option must be True for headspace injections, and is not available for liquid injections.",
				ResolutionDescription -> "Automatically set to False if the SamplingMethod is SPMEInjection, or True if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Standard Sample Aspiration",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Sample extraction time: 0-600 minutes def 0.2 *)
			{
				OptionName -> StandardSPMESampleExtractionTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be left in contact with the sample environment to adsorb analytes onto the fiber.",
				ResolutionDescription -> "Automatically set to 10 minutes if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Standard Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Sample desorption time: 0-600 minutes def 0.2 *)
			{
				OptionName -> StandardSPMESampleDesorptionTime,
				Default -> Automatic, (* >= ExtractionTime *)
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be held inside the heated inlet, where analytes will be heated off the fiber and onto the column.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Standard Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Postinjection conditioning time: 0-600 minutes def 0.1 *)
			{
				OptionName -> StandardSPMEPostInjectionConditioningTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in flowing Helium after sample desorption onto the column to desorb residual analytes from the fiber.",
				ResolutionDescription -> "Automatically set to 0.5 minutes if SPMECondition is True.",
				AllowNull -> True,
				Category -> "Standard Post-Injection Syringe Cleaning",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},

			(* === 3. GC INSTRUMENT METHOD === *)

			(* 3.1 Inlet options *)

			(* 3.1.1 Inlet temperature options *)

			(* Inlet temperature profile initial temp -160-450C *)
			{
				OptionName -> StandardInitialInletTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the inlet, a heated, pressurized antechamber attached to the beginning of the column (see Figure 3.1 for more details), will be held at as the separation begins.",
				ResolutionDescription -> "Automatically set to 275 C if the InletTemperatureProfile is Isothermal, or the first point of the InletTemperatureProfile if this temperature is possible to determine. If it is not, automatically set to 100 C.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[40 * Celsius, 450 * Celsius],
					Units -> Celsius
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Inlet temperature profile initial hold time *)
			{
				OptionName -> StandardInitialInletTemperatureDuration,
				Default -> Automatic,
				Description -> "The amount of time into the separation to hold the inlet at its InitialInletTemperature before beginning the inlet temperature profile.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the InletTemperatureProfile is a temperature profile, otherwise Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Inlet temperature profile {Rate (0-900C/min), Value (-160-450C), Hold time (0-999.99min) } *)
			{
				OptionName -> StandardInletTemperatureProfile,
				Default -> Automatic,
				Description -> "Specifies the evolution of the inlet temperature over the course of the separation.",
				ResolutionDescription -> "Automatically set to the InitialInletTemperature.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-160 * Celsius, 450 * Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Isothermal]
					],
					(* "Standard" time/temperature profile *)
					Adder[{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						],
						"InletTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-160 * Celsius, 450 * Celsius],
							Units -> Celsius
						]
					}],
					(* "Weird" ramp rate profile *)
					Adder[{
						"InletTemperatureRampRate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Celsius / Minute, 900 * Celsius / Minute],
							Units -> CompoundUnit[{1, {Celsius, {Celsius, Fahrenheit}}}, {-1, {Second, {Hour, Minute, Second}}}]
						],
						"InletTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-160 * Celsius, 450 * Celsius],
							Units -> Celsius
						],
						"InletTemperatureHoldTime" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						]
					}]
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* Inlet options *)

			(* Inlet septum purge *)
			{
				OptionName -> StandardInletSeptumPurgeFlowRate,
				Default -> Automatic,
				Description -> "The flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner (see Figure 3.1).",
				ResolutionDescription -> "Automatically set to 3 milliliters per minute.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Milliliter / Minute, 30 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.2 Split options *)

			(* Split ratio *)
			{
				OptionName -> StandardSplitRatio,
				Default -> Automatic,
				Description -> "The ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column (see Figure 3.1). This value is equal to the theoretical ratio of the amount of injected sample that will pass onto the column to the amount of sample that will be eliminated from the inlet through the split valve.",
				ResolutionDescription -> "Automatically set to 10.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 7500]
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Split FlowRate: 0-1250 milliliters per minute *)
			{
				OptionName -> StandardSplitVentFlowRate,
				Default -> Automatic,
				Description -> "The flow rate through the split valve that exits the instrument out the split vent (see Figure 3.1). If no SplitlessTime has been specified, this flow rate will be set for the duration of the separation.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Milliliter / Minute, 1250 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.3 Splitless options *)

			(* Splitless time *)
			{
				OptionName -> StandardSplitlessTime,
				Default -> Automatic,
				Description -> "The amount of time into the separation for which to keep the split valve closed. After this time the split valve will open to allow the SplitVentFlowRate through the split valve (cannot be specified in conjunction with SplitRatio).",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.4 Pulsed injection options *)

			(* Injection Pulse Pressure: 0-100 psi *)
			{
				OptionName -> StandardInitialInletPressure,
				Default -> Automatic,
				Description -> "The pressure at which the inlet will be set (in PSI gauge pressure) at the beginning of the separation.",
				ResolutionDescription -> "Automatically set to twice the initial column head pressure (as determined by the InitialColumnFlowRate, InitialColumnPressure, InitialColumnResidenceTime, or InitialColumnAverageVelocity) if an InitialInletTime is specified.", (* See http://www.sge.com/uploads/8e/ab/8eab977f6cac78408d503bb3ee2eafa1/TA-0025-C.pdf for Poiseuilles equation and relevant parameters incl. dynamic viscosity of carrier gases *)
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * PSI, 100 * PSI],
					Units -> PSI
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Injection pulse time: 0-999.99 minutes *)
			{
				OptionName -> StandardInitialInletTime,
				Default -> Automatic,
				Description -> "The time into the separation for which the InitialInletPressure and/or SolventEliminationFlowRate will be maintained.",
				ResolutionDescription -> "Automatically set to 2 minutes if an InitialInletPressure is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.5 Gas saver *)

			(* Gas saver on/off *)
			{
				OptionName -> StandardGasSaver,
				Default -> Automatic,
				Description -> "Indicates whether to reduce flow through the split vent after a certain time into the sample separation, reducing carrier gas consumption.",
				ResolutionDescription -> "If GasSaver parameters are specified, this is automatically set to True, otherwise False.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Standard Gas Saver"
			},
			(* Gas saver FlowRate: 15-1250 milliliters per minute *)
			{
				OptionName -> StandardGasSaverFlowRate,
				Default -> Automatic,
				Description -> "The carrier gas flow rate that the total inlet flow (flow onto column plus flow through the split vent) will be reduced to when the gas saver is activated.",
				ResolutionDescription -> "If GasSaver is True, this is automatically set to 25 milliliters per minute.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[15 * Milliliter / Minute, 1250 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Standard Gas Saver"
			},
			(* Gas saver time *)
			{
				OptionName -> StandardGasSaverActivationTime,
				Default -> Automatic,
				Description -> "The amount of time after the beginning of the separation that the gas saver will be activated.",
				ResolutionDescription -> "If GasSaver is True, this is automatically set to 6 residence times of the inlet liner.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Standard Gas Saver"
			},

			(* MMI solvent vent flow rate 0-1250 milliliters per minute *)
			{
				OptionName -> StandardSolventEliminationFlowRate,
				Default -> Automatic,
				Description -> "The flow through the split valve that will be set at the beginning of the separation. If this option is specified, the split valve will be closed after the InitialInletTime. This option is often used in an attempt to selectively remove solvent from the inlet by also setting the initial inlet temperature to a temperature just above the boiling point of the sample solvent, then ramping the inlet temperature to a higher temperature to vaporize the remaining analytes.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter / Minute, 1250 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Standard Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.2 Column options *)
			(* Initial column flow rate *)
			{
				OptionName -> StandardInitialColumnFlowRate,
				Default -> Automatic,
				Description -> "The flow rate of carrier gas through the column at the beginning of the separation.",
				ResolutionDescription -> "Automatically set to 1.7 milliliters per minute, or calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter / Minute, 150 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Standard Column Pressures and Flow Rates"
			},
			(* Initial column pressure *)
			{
				OptionName -> StandardInitialColumnPressure,
				Default -> Automatic,
				Description -> "The column head pressure of carrier gas in PSI gauge pressure at the beginning of the separation.",
				ResolutionDescription -> "Automatically calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * PSI, 100 * PSI],
					Units -> PSI
				],
				Category -> "Standard Column Pressures and Flow Rates"
			},
			(* Initial column average velocity *)
			{
				OptionName -> StandardInitialColumnAverageVelocity,
				Default -> Automatic,
				Description -> "The length of the column divided by the average time taken by a molecule of carrier gas to travel through the column at the beginning of the separation.",
				ResolutionDescription -> "Automatically calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Centimeter / Second, 200 * Centimeter / Second],
					Units -> CompoundUnit[{1, {Centimeter, {Centimeter, Millimeter, Meter}}}, {-1, {Second, {Hour, Minute, Second}}}]
				],
				Category -> "Standard Column Pressures and Flow Rates"
			},
			(* Initial column residence time *)
			{
				OptionName -> StandardInitialColumnResidenceTime,
				Default -> Automatic,
				Description -> "The average time taken by a molecule of carrier gas to travel through the column at the beginning of the separation.",
				ResolutionDescription -> "Automatically calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Standard Column Pressures and Flow Rates"
			},
			(* Initial setpoint hold time *)
			{
				OptionName -> StandardInitialColumnSetpointDuration,
				Default -> Automatic,
				Description -> "The amount of time into the method to hold the column at a specified initial column parameter (InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime) before starting a pressure or flow rate profile.",
				ResolutionDescription -> "Automatically set to 2 min.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Standard Column Pressures and Flow Rates"
			},

			(* Column pressure Profile *)
			{
				OptionName -> StandardColumnPressureProfile,
				Default -> Automatic,
				Description -> "Specifies the evolution of the column head pressure over the course of the separation.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[ConstantPressure]
					],
					Adder[
						{
							"Time" ->
								Widget[Type -> Quantity,
									Pattern :> RangeP[0 * Minute, 999.99 * Minute], Units -> {1, {Minute, {Minute, Second, Hour}}}],
							"ColumnPressure" ->
								Widget[Type -> Quantity,
									Pattern :> RangeP[0 * PSI, 100 * PSI], Units -> PSI]
						}
					],
					Adder[
						{
							"ColumnPressureRampRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * PSI / Minute, 150 * PSI / Minute],
								Units -> PSI / Minute
							],
							"ColumnPressure" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * PSI, 100 * PSI],
								Units -> PSI
							],
							"ColumnPressureHoldTime" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Minute, 999.99 * Minute],
								Units -> {1, {Minute, {Minute, Second, Hour}}}
							]
						}
					]
				],
				Category -> "Standard Column Pressures and Flow Rates"
			},

			(* Column flow rate Profile *)
			{
				OptionName -> StandardColumnFlowRateProfile,
				Default -> Automatic,
				Description -> "Specifies the evolution of the column flow rate over the course of the separation.",
				ResolutionDescription -> "Automatically set to a ConstantFlowRate profile at the InitialColumnFlowRate.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[ConstantFlowRate]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Minute, 999.99 * Minute], Units -> {1, {Minute, {Minute, Second, Hour}}}
							],
							"ColumnFlowRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Milliliter / Minute, 30 * Milliliter / Minute], Units -> Milliliter / Minute
							]
						}
					],
					Adder[
						{
							"ColumnFlowRateRampRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Milliliter / Minute / Minute, 100 * Milliliter / Minute / Minute],
								Units -> Milliliter / Minute / Minute
							],
							"ColumnFlowRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Milliliter / Minute, 30 * Milliliter / Minute],
								Units -> Milliliter / Minute
							],
							"ColumnFlowRateHoldTime" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Minute, 999.99 * Minute],
								Units -> {1, {Minute, {Minute, Second, Hour}}}
							]
						}
					]
				],
				Category -> "Standard Column Pressures and Flow Rates"
			},
			(* Column post-run flow rate: 0-25mL/min *)
			{
				OptionName -> StandardPostRunFlowRate,
				Default -> Automatic,
				Description -> "The column flow rate that will be set at the end of the sample separation as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to the initial column flow rate if a PostRunOvenTime is specified and a ColumnFlowRateProfile (including ConstantFlowRate) is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter / Minute, 25 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Standard Column Pressures and Flow Rates"
			}, (* Column post-run pressure: 30-450C *)
			{
				OptionName -> StandardPostRunPressure,
				Default -> Automatic,
				Description -> "The column pressure that will be set at the end of the sample separation as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to the initial column pressure if a PostRunOvenTime is specified and a ColumnPressureProfile (including ConstantPressure) is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * PSI, 100 * PSI],
					Units -> PSI
				],
				Category -> "Standard Column Pressures and Flow Rates"
			},

			(* 3.3 Column oven options *)

			(* Equilibration time: 0-999.99min *)
			{
				OptionName -> StandardOvenEquilibrationTime,
				Default -> Automatic,
				Description -> "The duration of time for which the initial OvenTemperature will be held before allowing the instrument to begin the next separation.",
				ResolutionDescription -> "Automatically set to 2 minutes unless another value is specified by a SeparationMethod.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Standard Column Oven Temperature Profile"
			},

			(* 3.3.1 Temperature Profile *)

			(* Column oven initial temp 30-450C *)
			{
				OptionName -> StandardInitialOvenTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the column oven will be held at the beginning of the separation.",
				ResolutionDescription -> "Automatically set to 50 degrees Celsius unless another value is specified by a SeparationMethod.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[30 * Celsius, 450 * Celsius],
					Units -> Celsius
				],
				Category -> "Standard Column Oven Temperature Profile"
			},
			(* Column oven temperature initial hold time *)
			{
				OptionName -> StandardInitialOvenTemperatureDuration, (* Rename Duration *)
				Default -> Automatic,
				Description -> "The amount of time after sample injection for which the column oven will be held at its InitialOvenTemperature before starting the column oven temperature profile.",
				ResolutionDescription -> "Automatically set to 3 minutes.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Standard Column Oven Temperature Profile"
			},
			(* Column Oven Temperature Profile Adder {Rate (0-120C/min), Value (30-450C), Hold time (0-999.99min) } *)
			{
				OptionName -> StandardOvenTemperatureProfile, (*  *)
				Default -> Automatic,
				Description -> "Specifies the evolution of the column temperature over the course of the separation.",
				ResolutionDescription -> "Automatically set to a linear ramp at 20 C/min to 50 degrees Celsius below the maximum column temperature followed by a hold for 3 minutes if not specified.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Isothermal]
					],
					(* Constant temperature *)
					{
						"OvenTemperature" -> Widget[ (* refactor to ColumnTemperature *)
							Type -> Quantity,
							Pattern :> RangeP[-60 * Celsius, 450 * Celsius],
							Units -> Celsius
						],
						"OvenTemperatureDuration" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						]
					},
					(* "Weird" ramp rate profile *)
					Adder[{
						"OvenTemperatureRampRate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Celsius / Minute, 900 * Celsius / Minute, Inclusive -> Right],
							Units -> CompoundUnit[{1, {Celsius, {Celsius, Fahrenheit}}}, {-1, {Second, {Hour, Minute, Second}}}]
						],
						"OvenTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-60 * Celsius, 450 * Celsius],
							Units -> Celsius
						],
						"OvenTemperatureHoldTime" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						]
					}],
					(* "Standard" time/temperature profile *)
					Adder[{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						],
						"OvenTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-60 * Celsius, 450 * Celsius],
							Units -> Celsius
						]
					}]
				],
				Category -> "Standard Column Oven Temperature Profile"
			},

			(* 3.3.2 Column oven post-run *)

			(* Column oven post-run temperature: 30-450C *)
			{
				OptionName -> StandardPostRunOvenTemperature,
				Default -> Automatic,
				Description -> "The column oven temperature that will be set at the end of the sample separation as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to the initial column oven temperature if a PostRunOvenTime is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[30 * Celsius, 450 * Celsius],
					Units -> Celsius
				],
				Category -> "Standard Column Oven Temperature Profile"
			},
			(* Column oven post-run time 0-999.99min*)
			{
				OptionName -> StandardPostRunOvenTime, (* Time -> Duration *)
				Default -> Automatic, (* 2 minutes if set *)
				Description -> "The amount of time to hold the column oven at the PostRunOvenTemperature as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to 2 minutes if a PostRunOvenTemperature is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Standard Column Oven Temperature Profile"
			},

			(* SEPARATION METHOD *)

			{
				OptionName -> StandardSeparationMethod,
				Default -> Automatic,
				Description -> "A collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected.",
				ResolutionDescription -> "Automatically creates an Object[Method, GasChromatography] using the specified options if no SeparationMethod is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, GasChromatography]]
				],
				Category -> "Standard Method"
			}
		],

		(* 5.5 Standard frequency *)
		{
			OptionName -> StandardFrequency,
			Default -> Automatic,
			Description -> "The frequency at which Standard measurements will be inserted among samples.",
			ResolutionDescription -> "Automatically set to FirstAndLast when any Standard options are specified.",
			AllowNull -> True,
			Category -> "Standards",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> None | First | Last | FirstAndLast | MethodChange
				],
				Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			]
		},

		(* === 6. BLANKS === *)

		IndexMatching[
			IndexMatchingParent -> Blank,

			(* 5.1 Define blanks *)
			{
				OptionName -> Blank,
				Default -> Automatic,
				Description -> "A reference compound to inject into the instrument, often used as a negative control.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents"
							}
						}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[NoInjection]
					]
				]
			},
			{
				OptionName -> BlankVial,
				Default -> Automatic,
				Description -> "The container in which to prepare a reference compound to inject into the instrument, often used as a negative control.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				]
			},
			{
				OptionName -> BlankAmount,
				Default -> Automatic,
				Description -> "The amount of a reference compound to prepare in a vial for subsequent injection into the instrument, often used as a negative control.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 * Microliter, 20000 * Microliter],
						Units -> {1, {Microliter, {Microliter, Milliliter}}}
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 * Micro * Gram, 2000 * Micro * Gram],
						Units -> Micro * Gram
					]
				]
			},

			(* Index-matched options *)

			(* Dilute boolean *)
			{
				OptionName -> BlankDilute,
				Default -> Automatic,
				Description -> "Indicates whether or not an aliquot of a specified liquid solution will be added to the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically set to to True if any dilution parameters are specified.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Dilution volume using DilutionSolvent *)
			{
				OptionName -> BlankDilutionSolventVolume,
				Default -> Automatic,
				Description -> "The volume of the DilutionSolvent to aliquot into the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically fills the sample's container to the sample container's MaxVolume with an equal volume mixture of each DilutionSolvent specified and the sample if Dilute is True.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 2500 * Microliter], (* Total sample volume not to exceed the listed volume of the sample vial *)
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Dilution volume using SecondaryDilutionSolvent *)
			{
				OptionName -> BlankSecondaryDilutionSolventVolume,
				Default -> Automatic,
				Description -> "The volume of the DilutionSolvent to aliquot into the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically fills the sample's container to the sample container's MaxVolume with an equal volume mixture of each DilutionSolvent specified and the sample if Dilute is True.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 2500 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Dilution volume using TertiaryDilutionSolvent *)
			{
				OptionName -> BlankTertiaryDilutionSolventVolume,
				Default -> Automatic,
				Description -> "The volume of the DilutionSolvent to aliquot into the sample's container prior to injection of the sample.",
				ResolutionDescription -> "Automatically fills the sample's container to the sample container's MaxVolume with an equal volume mixture of each DilutionSolvent specified and the sample if Dilute is True.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 2500 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Vortex boolean *)
			{
				OptionName -> BlankVortex,
				Default -> Automatic,
				Description -> "Indicates whether or not the sample will be spun in place to mix (vortexed) prior to sampling.",
				ResolutionDescription -> "Automatically set to True if vortex parameters are specified.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Vortex speed: 0-2000 rpm *)
			{
				OptionName -> BlankVortexMixRate,
				Default -> Automatic,
				Description -> "The rate (in RPM) at which the sample will be spun in place to mix (vortexed) in the vortex mixer prior to analysis.",
				ResolutionDescription -> "Automatically set to 750 RPM if the sample will be vortexed.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * RPM, 2000 * RPM],
					Units -> RPM
				]
			},
			(* Vortex time: 0-100 s *)
			{
				OptionName -> BlankVortexTime,
				Default -> Automatic,
				Description -> "The amount of time for which the sample will be spun in place to mix (vortexed) prior to analysis.",
				ResolutionDescription -> "Automatically set to 10 seconds if the sample will be vortexed.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 100 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Agitate boolean *)
			{
				OptionName -> BlankAgitate,
				Default -> Automatic,
				Description -> "Indicates whether or not the sample will be mixed by swirling the sample's container for a specified time at a specified rotational speed and incubated at a specified temperature prior to sampling.",
				ResolutionDescription -> "Automatically set to True if any agitation parameters are specified.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Agitator incubation time: 0-600 minutes def 0.2 minutes *)
			{
				OptionName -> BlankAgitationTime,
				Default -> Automatic,
				Description -> "The time that each sample will be mixed by swirling the sample's container for a specified time at a specified rotational speed and incubated at a specified temperature in the agitator prior to sample aspiration for injection onto the column.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				]
			},
			(* Agitator incubation temperature: 30-200C def 40 *)
			{
				OptionName -> BlankAgitationTemperature,
				Default -> Automatic,
				Description -> "The temperature at which each sample will be mixed by swirling the sample's container for a specified time at a specified rotational speed and incubated at a specified temperature in the agitator prior to sample aspiration for injection onto the column.",
				ResolutionDescription -> "Automatically set to Ambient if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[30 * Celsius, 200 * Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				]
			},
			(* Agitator speed: 250-750 rpm def 250 *)
			{
				OptionName -> BlankAgitationMixRate,
				Default -> Automatic,
				Description -> "The rate (in RPM) at which each sample will be swirled at in the agitator prior to analysis.",
				ResolutionDescription -> "Automatically set to 250 RPM if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[250 * RPM, 750 * RPM],
					Units -> RPM
				]
			},
			(* Agitator on time interval: 0-600s def 5 *)
			{
				OptionName -> BlankAgitationOnTime,
				Default -> Automatic,
				Description -> "The amount of time for which the agitator will swirl before switching directions.",
				ResolutionDescription -> "Automatically set to 5 seconds if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 600 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Agitator off time interval: 0-600s def 2 *)
			{
				OptionName -> BlankAgitationOffTime,
				Default -> Automatic,
				Description -> "The amount of time for which the agitator will idle while switching directions.",
				ResolutionDescription -> "Automatically set to 2 seconds if the sample will be agitated.",
				AllowNull -> True,
				Category -> "Blank Sample Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 600 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},

			(* Select injection tool *)
			{
				OptionName -> BlankSamplingMethod,
				Default -> Automatic,
				Description -> "The process by which a sample will be aspirated or analytes extracted in preparation for injection of those analytes onto the column to be separated.",
				ResolutionDescription -> "Selects a SamplingMethod of LiquidInjection unless the sample does not contain a liquid component, in which case HeadspaceInjection is selected.",
				AllowNull -> True,
				Category -> "Blank Sampling Method",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> GCSamplingMethodP
				]
			},
			{
				OptionName -> BlankLiquidPreInjectionSyringeWash,
				Default -> Automatic,
				Description -> "Indicates whether the liquid injection syringe will be (repeatedly) filled with a volume of solvent which will subsequently be discarded, in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to True if any pre-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Pre injection syringe wash volume *)
			{
				OptionName -> BlankLiquidPreInjectionSyringeWashVolume,
				Default -> Automatic,
				Description -> "The volume of the syringe wash solvent to aspirate and dispense using the liquid injection syringe in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the InjectionVolume if any pre-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			{
				OptionName -> BlankLiquidPreInjectionSyringeWashRate,
				Default -> Automatic,
				Description -> "The aspiration rate that will be used to draw and dispense syringe wash solvent(s) in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the 5 microliters per second if any pre-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Microliter / Second, 100 Microliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			{
				OptionName -> BlankLiquidPreInjectionNumberOfSolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> BlankLiquidPreInjectionNumberOfSecondarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SecondarySyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> BlankLiquidPreInjectionNumberOfTertiarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified TertiarySyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> BlankLiquidPreInjectionNumberOfQuaternarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified QuaternarySyringeWashSolvent prior to aspirating the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any pre-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			(* Sample wash master switch *)
			{
				OptionName -> BlankLiquidSampleWash,
				Default -> Automatic,
				Description -> "Indicates whether the syringe will be washed with the sample prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to True for all samples with a corresponding BlankSamplingMethod of LiquidInjection.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Sample washes: 0-10 def 1 *)
			{
				OptionName -> BlankNumberOfLiquidSampleWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume of the sample using the liquid injection syringe in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 3 if LiquidSampleWash is True.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 10]
				]
			},
			(* Sample wash volume: 0-1000uL def 1 *)
			{
				OptionName -> BlankLiquidSampleWashVolume,
				Default -> Automatic,
				Description -> "The volume of the sample that will be aspirateed and discarded in an attempt to remove any impurities in the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 125% of the BlankInjectionVolume or the maximum volume of the injection syringe, whichever is smaller, if BlankLiquidSampleWash is True.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Filling strokes: 0-15 def 4 *)
			{
				OptionName -> BlankLiquidSampleFillingStrokes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and rapidly dispense the sample in an attempt to eliminate any bubbles from the cylinder of the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 4 if a value is set for LiquidSampleFillingStrokesVolume.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 15]
				]
			},
			(* Filling strokes volume: 0-1000uL def 3 *)
			{
				OptionName -> BlankLiquidSampleFillingStrokesVolume,
				Default -> Automatic, (* Sample volume *)
				Description -> "The volume the sample to be aspirated and rapidly dispensed in an attempt to eliminate any bubbles from the cylinder of the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 125% of the BlankInjectionVolume or the total syringe volume, whichever is smaller, if a number of LiquidSampleFillingStrokes is set.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Delay after filling strokes: 0-10 s def 0.5 s *)
			{
				OptionName -> BlankLiquidFillingStrokeDelay,
				Default -> Automatic,
				Description -> "The amount of time to wait for any remaining bubbles to settle after aspirating and rapidly dispensing the sample in an attempt to eliminate any bubbles from the cylinder of the liquid injection syringe prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to 0.5 seconds if the SamplingMethod is LiquidInjection.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 10 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Sample vial penetration depth *)
			{
				OptionName -> BlankSampleVialAspirationPosition,
				Default -> Automatic,
				Description -> "The extremity of the sample vial (Top or Bottom) where the tip of the injection syringe's needle or Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				AllowNull -> True,
				Category -> "Blank Sample Aspiration",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> GCVialPositionP
				]
			},
			{
				OptionName -> BlankSampleVialAspirationPositionOffset,
				Default -> Automatic,
				Description -> "The distance from the specified extremity of the sample vial (Top or Bottom) where the tip of the injection syringe's needle or Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				ResolutionDescription -> "Automatically set to 30 mm if SamplingMethod is LiquidInjection, 15 mm if SamplingMethod is HeadspaceInjection, or 40 mm if SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Blank Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Millimeter, 65 * Millimeter],
					Units -> Millimeter
				]
			},
			(* Sample vial penetration speed *)
			{
				OptionName -> BlankSampleVialPenetrationRate,
				Default -> Automatic,
				Description -> "The velocity at which the tip of the injection syringe or fiber will penetrate the sample vial septum during aspiration or extraction of the sample.",
				AllowNull -> True,
				Category -> "Blank Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Millimeter / Second, 75 * Millimeter / Second], (* Instrument limits: Liquid: 1-75 Headspace: 1-75 SPME: 2-75 *) (*  *)
					Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Centimeter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* sample volume: 0-1000uL def 1 *)
			{
				OptionName -> BlankInjectionVolume,
				Default -> Automatic,
				Description -> "The amount of sample to draw into the liquid or headspace injection syringe for subsequent injection into the inlet.",
				ResolutionDescription -> "Automatically set to 25% of the LiquidInjectionSyringe volume if a LiquidInjectionSyringe is provided, or 2.5 \[Micro]L if the SamplingMethod is LiquidInjection, or 1.5 mL if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Blank Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Microliter, 2500 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Air volume: 0-1000uL def 1 *)
			{
				OptionName -> BlankLiquidSampleOverAspirationVolume,
				Default -> Automatic,
				Description -> "The volume of air to draw into the liquid injection syringe after aspirating the sample, prior to injection.",
				ResolutionDescription -> "Automatically set to 0 microliters if the SamplingMethod is LiquidInjection.",
				AllowNull -> True,
				Category -> "Blank Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			(* Sample aspirate flow rate: 0.1-100uL/s def 1 *)
			{
				OptionName -> BlankSampleAspirationRate, (* Combine this with headspace option? *)
				Default -> Automatic,
				Description -> "The volume of sample per time unit at which the sample will be drawn into the injection syringe for subsequent injection onto the column.",
				ResolutionDescription -> "Automatically set to 1 microliters per second if the SamplingMethod is LiquidInjection, or 10 milliliters per minute if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Blank Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Microliter / Second, 100 * Milliliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* Sample post aspirate delay: 0-10s def 2 *)
			{
				OptionName -> BlankSampleAspirationDelay,
				Default -> Automatic,
				Description -> "The amount of time for which the autosampler will pause after drawing the injection volume into the injection syringe, while the syringe remains in the sample environment. This pause is often used to develop an equilibrium between conditions in the sample environment and syringe contents.",
				ResolutionDescription -> "Automatically set to 2 seconds if the SamplingMethod is LiquidInjection or HeadspaceInjection, or Null if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Blank Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 10 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Inlet penetration depth *)
			{
				OptionName -> BlankInjectionInletPenetrationDepth,
				Default -> Automatic,
				Description -> "The distance through the inlet septum that the tip of the injection syringe's needle or Solid Phase MicroExtraction (SPME) fiber tip will be positioned during injection of the sample.",
				AllowNull -> True,
				Category -> "Blank Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Millimeter, 73 * Millimeter], (* Instrument limits: Liquid: 10-73 Headspace: 15-50 SPME: 15-65 *)
					Units -> Millimeter
				]
			},
			(* Inlet penetration speed *)
			{
				OptionName -> BlankInjectionInletPenetrationRate,
				Default -> Automatic,
				Description -> "The speed at which the tip of the injection syringe's needle or Solid Phase MicroExtraction (SPME) fiber will penetrate the inlet septum during injection of the sample.",
				AllowNull -> True,
				Category -> "Blank Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Millimeter / Second, 100 * Millimeter / Second], (* Instrument limits: Liquid: 2-100 Headspace: 1-100 SPME: 2-100 *)
					Units -> CompoundUnit[{1, {Millimeter, {Millimeter, Centimeter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* Injection signal mode: Plunger up/Plunger down OR Before fiber exposed/After fiber exposed. We might want to use a generic "tool inserted"/"sample injected" and have the resolver figure out which option to change *)
			{
				OptionName -> BlankInjectionSignalMode,
				Default -> Automatic,
				Description -> "Specifies whether the instrument will start the separation timer and data collection once the syringe tip is in position in the inlet but before the sample is dispensed (PlungerUp) or after the syringe's plunger has been depressed and the sample has been dispensed or exposed to the inlet (PlungerDown) during the sample injection.",
				AllowNull -> True,
				Category -> "Blank Sample Injection",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (PlungerUp | PlungerDown)
				]
			},
			(* Pre injection time delay*)
			{
				OptionName -> BlankPreInjectionTimeDelay,
				Default -> Automatic,
				Description -> "The amount of time for which the syringe's needle tip or Solid Phase MicroExtraction (SPME) fiber will be held in the inlet before the plunger is depressed and the sample is introduced into the inlet environment.",
				AllowNull -> True,
				Category -> "Blank Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 15 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Injection flow rate: 1-250uL/s def 100 *)
			{
				OptionName -> BlankSampleInjectionRate, (* Combine this with headspace option *)
				Default -> Automatic,
				Description -> "The volume of sample per time that will be dispensed into the inlet in order to transfer the sample onto the column.",
				ResolutionDescription -> "Automatically set to 50 microliters per second if the SamplingMethod is LiquidInjection, or 10 milliliters per minute if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Blank Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Microliter / Second, 100 * Milliliter / Minute],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			(* Post injection time delay*)
			{
				OptionName -> BlankPostInjectionTimeDelay,
				Default -> Automatic,
				Description -> "The amount of time the syringe's needle tip or Solid Phase MicroExtraction (SPME) fiber will be held in the inlet after the plunger has been completely depressed before it is withdrawn from the inlet.",
				AllowNull -> True,
				Category -> "Blank Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 15 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Post injection syringe wash boolean *)
			{
				OptionName -> BlankLiquidPostInjectionSyringeWash,
				Default -> Automatic,
				Description -> "Indicates whether the liquid injection syringe will be (repeatedly) filled with a volume of solvent which will subsequently be discarded, in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to True if any post-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Blank Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Post injection syringe wash volume *)
			{
				OptionName -> BlankLiquidPostInjectionSyringeWashVolume,
				Default -> Automatic,
				Description -> "The volume of the syringe wash solvent to aspirate and dispense using the liquid injection syringe in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the InjectionVolume if any post-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Blank Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Microliter, 100 * Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
			},
			{
				OptionName -> BlankLiquidPostInjectionSyringeWashRate,
				Default -> Automatic,
				Description -> "The aspiration rate that will be used to draw and dispense syringe wash solvent(s) in an attempt to remove any impurities present prior to sample aspiration.",
				ResolutionDescription -> "Automatically set to the 5 microliters per second if any post-injection liquid syringe washing options are specified.",
				AllowNull -> True,
				Category -> "Blank Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Microliter / Second, 100 Microliter / Second],
					Units -> CompoundUnit[{1, {Microliter, {Milliliter, Microliter}}}, {-1, {Second, {Minute, Second}}}]
				]
			},
			{
				OptionName -> BlankLiquidPostInjectionNumberOfSolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Blank Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> BlankLiquidPostInjectionNumberOfSecondarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified SecondarySyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Blank Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> BlankLiquidPostInjectionNumberOfTertiarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified TertiarySyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Blank Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			{
				OptionName -> BlankLiquidPostInjectionNumberOfQuaternarySolventWashes,
				Default -> Automatic,
				Description -> "The number of times to aspirate and discard a volume the specified QuaternarySyringeWashSolvent after injecting the sample in an attempt to remove any residual contamination from the liquid injection syringe.",
				ResolutionDescription -> "Automatically set to 3 if any post-injection liquid syringe washing options are specified and this wash solvent is specified.",
				AllowNull -> True,
				Category -> "Blank Post-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				]
			},
			(* Wait for System Ready: ("At start"|"After solvent wash"|"After sample wash"|"After sample draw"|"After bubble elimination") *)
			{
				OptionName -> BlankPostInjectionNextSamplePreparationSteps, (* was WaitForSystemReady *)
				Default -> Automatic,
				Description -> "The sample preparation step up to which the autosampling arm will proceed (as described in Figures 3.5, 3.6, 3.7, and 3.10) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected. If NoSteps are specified, the autosampler will wait until a separation is complete to begin preparing the next sample in the injection queue.",
				ResolutionDescription -> "Automatically set to NoSteps if the SamplingMethod is LiquidInjection.",
				AllowNull -> True,
				Category -> "Blank Advanced Autosampler Options",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (NoSteps | SolventWash | SampleWash | SampleFillingStrokes | SampleAspiration)
				]
			},
			(* Syringe temperature: 40-150C, def 85 *)
			{
				OptionName -> BlankHeadspaceSyringeTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the cylinder of the headspace syringe will be incubated throughout the experiment.",
				ResolutionDescription -> "Automatically set to Ambient if the SamplingMethod for the corresponding sample is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Cleaning",
				Widget -> Alternatives[Widget[
					Type -> Quantity,
					Pattern :> RangeP[40 * Celsius, 150 * Celsius],
					Units -> Celsius
				],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				]
			},
			(* Continuous flush: On/Off (flushes until next sample is prepared) *)
			{
				OptionName -> BlankHeadspaceSyringeFlushing,
				Default -> Automatic,
				Description -> "Specifies whether a stream of Helium will be flowed through the cylinder of the headspace syringe without interruption between injections (Continuous), or if Helium will be flowed through the cylinder of the headspace syringe before and/or after sample aspiration for specified amounts of time.",
				ResolutionDescription -> "Automatically set to BeforeSampleAspiration if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Cleaning",
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Continuous]
					],
					Widget[
						Type -> MultiSelect,
						Pattern :> DuplicateFreeListableP[BeforeSampleAspiration | AfterSampleInjection]
					]
				]

			},
			(* Pre-injection flush time: 0-60s def 5 (flushes sample with z axis He) *)
			{
				OptionName -> BlankHeadspacePreInjectionFlushTime, (* can we retube the autosampling deck with N2 or Ar *)
				Default -> Automatic,
				Description -> "The amount of time to flow Helium through the cylinder of the headspace injection syringe (to remove residual analytes in the syringe barrel) before aspirating a sample.",
				ResolutionDescription -> "Automatically set to 3 seconds if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Cleaning",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 60 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Post-injection flush time: 0-600s def 10 *)
			{
				OptionName -> BlankHeadspacePostInjectionFlushTime,
				Default -> Automatic,
				Description -> "The amount of time to flow Helium through the cylinder of the headspace injection syringe (to remove residual analytes in the syringe barrel) after injecting a sample.",
				ResolutionDescription -> "Automatically set to 3 seconds if HeadspaceSyringeFlushing includes BeforeSampleAspiration, or Null if HeadspaceSyringeFlushing is Continuous.",
				AllowNull -> True,
				Category -> "Blank Post-Injection Syringe Cleaning",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Second, 60 * Second],
					Units -> {1, {Second, {Minute, Second}}}
				]
			},
			(* Condition SPME Fiber *)
			{
				OptionName -> BlankSPMECondition,
				Default -> Automatic,
				Description -> "Indicates whether or not the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in a flow of Helium prior to sample extraction to desorb residual analytes from the fiber.",
				ResolutionDescription -> "Automatically set to True if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Fiber conditioning station temperature: 40-350C def 40 *)
			{
				OptionName -> BlankSPMEConditioningTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in flowing Helium prior to sample extraction to desorb residual analytes from the fiber.",
				ResolutionDescription -> "If SPMECondition is True, automatically set to the minimum recommended conditioning temperature associated with the SPME fiber.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[40 * Celsius, 350 * Celsius],
					Units -> Celsius
				]
			},
			(* Conditioning time: 0-600min def 0.1min *)
			{
				OptionName -> BlankSPMEPreConditioningTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in flowing Helium prior to sample extraction to desorb residual analytes from the fiber.",
				ResolutionDescription -> "Automatically set to 30 minutes if the SPMECondition is True.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Define derivatizing agent *)
			{
				OptionName -> BlankSPMEDerivatizingAgent,
				Default -> Automatic,
				Description -> "The matrix in which the Solid Phase MicroExtraction (SPME) fiber will be allowed to react prior to sample extraction.",
				ResolutionDescription -> "Automatically set to Hexanes if derivatization parameters are specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents"
						}
					}
				]
			},
			(* Derivatizing agent adsorption time: 0-600 minutes def 0.2 minutes *)
			{
				OptionName -> BlankSPMEDerivatizingAgentAdsorptionTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be allowed to react in the specified derivatizing agent prior to sample extraction.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the SPMEDerivatizingAgent is specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Derivatizing agent penetration depth: 10-70mm def 25 *)
			{
				OptionName -> BlankSPMEDerivatizationPosition,
				Default -> Automatic,
				Description -> "The extremity of the sample vial (Top or Bottom) where the tip of the Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				ResolutionDescription -> "Automatically set to Top if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (Top | Bottom)
				]
			},
			{
				OptionName -> BlankSPMEDerivatizationPositionOffset,
				Default -> Automatic,
				Description -> "The distance from the specified extremity of the sample vial (Top or Bottom) where the tip of the Solid Phase MicroExtraction fiber will be positioned during sample aspiration or extraction.",
				ResolutionDescription -> "Automatically set to 25 mm if the SPMEDerivatizingAgent is specified.",
				AllowNull -> True,
				Category -> "Blank Pre-Injection Syringe Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Millimeter, 70 * Millimeter],
					Units -> Millimeter
				]
			},
			(* Sample while agitating *)
			{
				OptionName -> BlankAgitateWhileSampling,
				Default -> Automatic,
				Description -> "Indicates whether the sample will be drawn or adsorbed while the sample is being swirled as specified by AgitationTime, AgitationTemperature, AgitationMixRate, AgitationOnTime, AgitationOffTime. This option must be True for headspace injections, and is not available for liquid injections.",
				ResolutionDescription -> "Automatically set to False if the SamplingMethod is SPMEInjection, or True if the SamplingMethod is HeadspaceInjection.",
				AllowNull -> True,
				Category -> "Blank Sample Aspiration",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			(* Sample extraction time: 0-600 minutes def 0.2 *)
			{
				OptionName -> BlankSPMESampleExtractionTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be left in contact with the sample environment to adsorb analytes onto the fiber.",
				ResolutionDescription -> "Automatically set to 10 minutes if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Blank Sample Aspiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Sample desorption time: 0-600 minutes def 0.2 *)
			{
				OptionName -> BlankSPMESampleDesorptionTime,
				Default -> Automatic, (* >= ExtractionTime *)
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be held inside the heated inlet, where analytes will be heated off the fiber and onto the column.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the SamplingMethod is SPMEInjection.",
				AllowNull -> True,
				Category -> "Blank Sample Injection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},
			(* Postinjection conditioning time: 0-600 minutes def 0.1 *)
			{
				OptionName -> BlankSPMEPostInjectionConditioningTime,
				Default -> Automatic,
				Description -> "The amount of time for which the Solid Phase MicroExtraction (SPME) fiber will be heat-treated in flowing Helium after sample desorption onto the column to desorb residual analytes from the fiber.",
				ResolutionDescription -> "Automatically set to 0.5 minutes if SPMECondition is True.",
				AllowNull -> True,
				Category -> "Blank Post-Injection Syringe Cleaning",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 600 * Minute],
					Units -> {1, {Minute, {Minute, Hour}}}
				]
			},

			(* === 3. GC INSTRUMENT METHOD === *)

			(* 3.1 Inlet options *)

			(* 3.1.1 Inlet temperature options *)

			(* Inlet temperature profile initial temp -160-450C *)
			{
				OptionName -> BlankInitialInletTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the inlet, a heated, pressurized antechamber attached to the beginning of the column (see Figure 3.1 for more details), will be held at as the separation begins.",
				ResolutionDescription -> "Automatically set to 275 C if the InletTemperatureProfile is Isothermal, or the first point of the InletTemperatureProfile if this temperature is possible to determine. If it is not, automatically set to 100 C.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[40 * Celsius, 450 * Celsius],
					Units -> Celsius
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Inlet temperature profile initial hold time *)
			{
				OptionName -> BlankInitialInletTemperatureDuration,
				Default -> Automatic,
				Description -> "The amount of time into the separation to hold the inlet at its InitialInletTemperature before beginning the inlet temperature profile.",
				ResolutionDescription -> "Automatically set to 0.2 minutes if the InletTemperatureProfile is a temperature profile, otherwise Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Inlet temperature profile {Rate (0-900C/min), Value (-160-450C), Hold time (0-999.99min) } *)
			{
				OptionName -> BlankInletTemperatureProfile,
				Default -> Automatic,
				Description -> "Specifies the evolution of the inlet temperature over the course of the separation.",
				ResolutionDescription -> "Automatically set to the InitialInletTemperature.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-160 * Celsius, 450 * Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Isothermal]
					],
					(* "Standard" time/temperature profile *)
					Adder[{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						],
						"InletTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-160 * Celsius, 450 * Celsius],
							Units -> Celsius
						]
					}],
					(* "Weird" ramp rate profile *)
					Adder[{
						"InletTemperatureRampRate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Celsius / Minute, 900 * Celsius / Minute],
							Units -> CompoundUnit[{1, {Celsius, {Celsius, Fahrenheit}}}, {-1, {Second, {Hour, Minute, Second}}}]
						],
						"InletTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-160 * Celsius, 450 * Celsius],
							Units -> Celsius
						],
						"InletTemperatureHoldTime" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						]
					}]
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* Inlet options *)

			(* Inlet septum purge *)
			{
				OptionName -> BlankInletSeptumPurgeFlowRate,
				Default -> Automatic,
				Description -> "The flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner (see Figure 3.1).",
				ResolutionDescription -> "Automatically set to 3 milliliters per minute.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Milliliter / Minute, 30 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.2 Split options *)

			(* Split ratio *)
			{
				OptionName -> BlankSplitRatio,
				Default -> Automatic,
				Description -> "The ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column (see Figure 3.1). This value is equal to the theoretical ratio of the amount of injected sample that will pass onto the column to the amount of sample that will be eliminated from the inlet through the split valve.",
				ResolutionDescription -> "Automatically set to 10.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 7500]
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Split FlowRate: 0-1250 milliliters per minute *)
			{
				OptionName -> BlankSplitVentFlowRate,
				Default -> Automatic,
				Description -> "The flow rate through the split valve that exits the instrument out the split vent (see Figure 3.1). If no SplitlessTime has been specified, this flow rate will be set for the duration of the separation.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Milliliter / Minute, 1250 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.3 Splitless options *)

			(* Splitless time *)
			{
				OptionName -> BlankSplitlessTime,
				Default -> Automatic,
				Description -> "The amount of time into the separation for which to keep the split valve closed. After this time the split valve will open to allow the SplitVentFlowRate through the split valve (cannot be specified in conjunction with SplitRatio).",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.4 Pulsed injection options *)

			(* Injection Pulse Pressure: 0-100 psi *)
			{
				OptionName -> BlankInitialInletPressure,
				Default -> Automatic,
				Description -> "The pressure at which the inlet will be set (in PSI gauge pressure) at the beginning of the separation.",
				ResolutionDescription -> "Automatically set to twice the initial column head pressure (as determined by the InitialColumnFlowRate, InitialColumnPressure, InitialColumnResidenceTime, or InitialColumnAverageVelocity) if an InitialInletTime is specified.", (* See http://www.sge.com/uploads/8e/ab/8eab977f6cac78408d503bb3ee2eafa1/TA-0025-C.pdf for Poiseuilles equation and relevant parameters incl. dynamic viscosity of carrier gases *)
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * PSI, 100 * PSI],
					Units -> PSI
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},
			(* Injection pulse time: 0-999.99 minutes *)
			{
				OptionName -> BlankInitialInletTime,
				Default -> Automatic,
				Description -> "The time into the separation for which the InitialInletPressure and/or SolventEliminationFlowRate will be maintained.",
				ResolutionDescription -> "Automatically set to 2 minutes if an InitialInletPressure is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.1.5 Gas saver *)

			(* Gas saver on/off *)
			{
				OptionName -> BlankGasSaver,
				Default -> Automatic,
				Description -> "Indicates whether to reduce flow through the split vent after a certain time into the sample separation, reducing carrier gas consumption.",
				ResolutionDescription -> "If GasSaver parameters are specified, this is automatically set to True, otherwise False.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Blank Gas Saver"
			},
			(* Gas saver FlowRate: 15-1250 milliliters per minute *)
			{
				OptionName -> BlankGasSaverFlowRate,
				Default -> Automatic,
				Description -> "The carrier gas flow rate that the total inlet flow (flow onto column plus flow through the split vent) will be reduced to when the gas saver is activated.",
				ResolutionDescription -> "If GasSaver is True, this is automatically set to 25 milliliters per minute.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[15 * Milliliter / Minute, 1250 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Blank Gas Saver"
			},
			(* Gas saver time *)
			{
				OptionName -> BlankGasSaverActivationTime,
				Default -> Automatic,
				Description -> "The amount of time after the beginning of the separation that the gas saver will be activated.",
				ResolutionDescription -> "If GasSaver is True, this is automatically set to 6 residence times of the inlet liner.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Blank Gas Saver"
			},

			(* MMI solvent vent flow rate 0-1250 milliliters per minute *)
			{
				OptionName -> BlankSolventEliminationFlowRate,
				Default -> Automatic,
				Description -> "The flow through the split valve that will be set at the beginning of the separation. If this option is specified, the split valve will be closed after the InitialInletTime. This option is often used in an attempt to selectively remove solvent from the inlet by also setting the initial inlet temperature to a temperature just above the boiling point of the sample solvent, then ramping the inlet temperature to a higher temperature to vaporize the remaining analytes.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter / Minute, 1250 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Blank Inlet Temperatures, Pressures, and Flow Rates"
			},

			(* 3.2 Column options *)
			(* Initial column flow rate *)
			{
				OptionName -> BlankInitialColumnFlowRate,
				Default -> Automatic,
				Description -> "The flow rate of carrier gas through the column at the beginning of the separation.",
				ResolutionDescription -> "Automatically set to 1.7 milliliters per minute, or calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter / Minute, 150 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Blank Column Pressures and Flow Rates"
			},
			(* Initial column pressure *)
			{
				OptionName -> BlankInitialColumnPressure,
				Default -> Automatic,
				Description -> "The column head pressure of carrier gas in PSI gauge pressure at the beginning of the separation.",
				ResolutionDescription -> "Automatically calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * PSI, 100 * PSI],
					Units -> PSI
				],
				Category -> "Blank Column Pressures and Flow Rates"
			},
			(* Initial column average velocity *)
			{
				OptionName -> BlankInitialColumnAverageVelocity,
				Default -> Automatic,
				Description -> "The length of the column divided by the average time taken by a molecule of carrier gas to travel through the column at the beginning of the separation.",
				ResolutionDescription -> "Automatically calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Centimeter / Second, 200 * Centimeter / Second],
					Units -> CompoundUnit[{1, {Centimeter, {Centimeter, Millimeter, Meter}}}, {-1, {Second, {Hour, Minute, Second}}}]
				],
				Category -> "Blank Column Pressures and Flow Rates"
			},
			(* Initial column residence time *)
			{
				OptionName -> BlankInitialColumnResidenceTime,
				Default -> Automatic,
				Description -> "The average time taken by a molecule of carrier gas to travel through the column at the beginning of the separation.",
				ResolutionDescription -> "Automatically calculated if another InitialColumn parameter is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Blank Column Pressures and Flow Rates"
			},
			(* Initial setpoint hold time *)
			{
				OptionName -> BlankInitialColumnSetpointDuration,
				Default -> Automatic,
				Description -> "The amount of time into the method to hold the column at a specified initial column parameter (InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime) before starting a pressure or flow rate profile.",
				ResolutionDescription -> "Automatically set to 2 min.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Blank Column Pressures and Flow Rates"
			},

			(* Column pressure Profile *)
			{
				OptionName -> BlankColumnPressureProfile,
				Default -> Automatic,
				Description -> "Specifies the evolution of the column head pressure over the course of the separation.",
				ResolutionDescription -> "Automatically set to Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[ConstantPressure]
					],
					Adder[
						{
							"Time" ->
								Widget[Type -> Quantity,
									Pattern :> RangeP[0 * Minute, 999.99 * Minute], Units -> {1, {Minute, {Minute, Second, Hour}}}],
							"ColumnPressure" ->
								Widget[Type -> Quantity,
									Pattern :> RangeP[0 * PSI, 100 * PSI], Units -> PSI]
						}
					],
					Adder[
						{
							"ColumnPressureRampRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * PSI / Minute, 150 * PSI / Minute],
								Units -> PSI / Minute
							],
							"ColumnPressure" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * PSI, 100 * PSI],
								Units -> PSI
							],
							"ColumnPressureHoldTime" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Minute, 999.99 * Minute],
								Units -> {1, {Minute, {Minute, Second, Hour}}}
							]
						}
					]
				],
				Category -> "Blank Column Pressures and Flow Rates"
			},

			(* Column flow rate Profile *)
			{
				OptionName -> BlankColumnFlowRateProfile,
				Default -> Automatic,
				Description -> "Specifies the evolution of the column flow rate over the course of the separation.",
				ResolutionDescription -> "Automatically set to a ConstantFlowRate profile at the InitialColumnFlowRate.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[ConstantFlowRate]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Minute, 999.99 * Minute], Units -> {1, {Minute, {Minute, Second, Hour}}}
							],
							"ColumnFlowRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Milliliter / Minute, 30 * Milliliter / Minute], Units -> Milliliter / Minute
							]
						}
					],
					Adder[
						{
							"ColumnFlowRateRampRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Milliliter / Minute / Minute, 100 * Milliliter / Minute / Minute],
								Units -> Milliliter / Minute / Minute
							],
							"ColumnFlowRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Milliliter / Minute, 30 * Milliliter / Minute],
								Units -> Milliliter / Minute
							],
							"ColumnFlowRateHoldTime" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 * Minute, 999.99 * Minute],
								Units -> {1, {Minute, {Minute, Second, Hour}}}
							]
						}
					]
				],
				Category -> "Blank Column Pressures and Flow Rates"
			},
			(* Column post-run flow rate: 0-25mL/min *)
			{
				OptionName -> BlankPostRunFlowRate,
				Default -> Automatic,
				Description -> "The column flow rate that will be set at the end of the sample separation as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to the initial column flow rate if a PostRunOvenTime is specified and a ColumnFlowRateProfile (including ConstantFlowRate) is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter / Minute, 25 * Milliliter / Minute],
					Units -> Milliliter / Minute
				],
				Category -> "Blank Column Pressures and Flow Rates"
			}, (* Column post-run pressure: 30-450C *)
			{
				OptionName -> BlankPostRunPressure,
				Default -> Automatic,
				Description -> "The column pressure that will be set at the end of the sample separation as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to the initial column pressure if a PostRunOvenTime is specified and a ColumnPressureProfile (including ConstantPressure) is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * PSI, 100 * PSI],
					Units -> PSI
				],
				Category -> "Blank Column Pressures and Flow Rates"
			},

			(* 3.3 Column oven options *)

			(* Equilibration time: 0-999.99min *)
			{
				OptionName -> BlankOvenEquilibrationTime,
				Default -> Automatic,
				Description -> "The duration of time for which the initial OvenTemperature will be held before allowing the instrument to begin the next separation.",
				ResolutionDescription -> "Automatically set to 2 minutes unless another value is specified by a SeparationMethod.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Blank Column Oven Temperature Profile"
			},

			(* 3.3.1 Temperature Profile *)

			(* Column oven initial temp 30-450C *)
			{
				OptionName -> BlankInitialOvenTemperature,
				Default -> Automatic,
				Description -> "The temperature at which the column oven will be held at the beginning of the separation.",
				ResolutionDescription -> "Automatically set to 50 degrees Celsius unless another value is specified by a SeparationMethod.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[30 * Celsius, 450 * Celsius],
					Units -> Celsius
				],
				Category -> "Blank Column Oven Temperature Profile"
			},
			(* Column oven temperature initial hold time *)
			{
				OptionName -> BlankInitialOvenTemperatureDuration, (* Rename Duration *)
				Default -> Automatic,
				Description -> "The amount of time after sample injection for which the column oven will be held at its InitialOvenTemperature before starting the column oven temperature profile.",
				ResolutionDescription -> "Automatically set to 3 minutes.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Blank Column Oven Temperature Profile"
			},
			(* Column Oven Temperature Profile Adder {Rate (0-120C/min), Value (30-450C), Hold time (0-999.99min) } *)
			{
				OptionName -> BlankOvenTemperatureProfile, (*  *)
				Default -> Automatic,
				Description -> "Specifies the evolution of the column temperature over the course of the separation.",
				ResolutionDescription -> "Automatically set to a linear ramp at 20 C/min to 50 degrees Celsius below the maximum column temperature followed by a hold for 3 minutes if not specified.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Isothermal]
					],
					(* Constant temperature *)
					{
						"OvenTemperature" -> Widget[ (* refactor to ColumnTemperature *)
							Type -> Quantity,
							Pattern :> RangeP[-60 * Celsius, 450 * Celsius],
							Units -> Celsius
						],
						"OvenTemperatureDuration" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						]
					},
					(* "Weird" ramp rate profile *)
					Adder[{
						"OvenTemperatureRampRate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Celsius / Minute, 900 * Celsius / Minute, Inclusive -> Right],
							Units -> CompoundUnit[{1, {Celsius, {Celsius, Fahrenheit}}}, {-1, {Second, {Hour, Minute, Second}}}]
						],
						"OvenTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-60 * Celsius, 450 * Celsius],
							Units -> Celsius
						],
						"OvenTemperatureHoldTime" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						]
					}],
					(* "Standard" time/temperature profile *)
					Adder[{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 * Minute, 999.99 * Minute],
							Units -> {1, {Minute, {Minute, Second, Hour}}}
						],
						"OvenTemperature" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[-60 * Celsius, 450 * Celsius],
							Units -> Celsius
						]
					}]
				],
				Category -> "Blank Column Oven Temperature Profile"
			},

			(* 3.3.2 Column oven post-run *)

			(* Column oven post-run temperature: 30-450C *)
			{
				OptionName -> BlankPostRunOvenTemperature,
				Default -> Automatic,
				Description -> "The column oven temperature that will be set at the end of the sample separation as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to the initial column oven temperature if a PostRunOvenTime is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[30 * Celsius, 450 * Celsius],
					Units -> Celsius
				],
				Category -> "Blank Column Oven Temperature Profile"
			},
			(* Column oven post-run time 0-999.99min*)
			{
				OptionName -> BlankPostRunOvenTime, (* Time -> Duration *)
				Default -> Automatic, (* 2 minutes if set *)
				Description -> "The amount of time to hold the column oven at the PostRunOvenTemperature as the instrument prepares for the next injection in the injection queue.",
				ResolutionDescription -> "Automatically set to 2 minutes if a PostRunOvenTemperature is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 999.99 * Minute],
					Units -> {1, {Minute, {Minute, Second, Hour}}}
				],
				Category -> "Blank Column Oven Temperature Profile"
			},

			(* SEPARATION METHOD *)

			{
				OptionName -> BlankSeparationMethod,
				Default -> Automatic,
				Description -> "A collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected.",
				ResolutionDescription -> "Automatically creates an Object[Method, GasChromatography] using the specified options if no SeparationMethod is specified.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, GasChromatography]]
				],
				Category -> "Blank Method"
			}
		],

		(* 5.5 Blank frequency *)
		{
			OptionName -> BlankFrequency,
			Default -> Automatic,
			Description -> "The frequency at which Blank measurements will be inserted among samples.",
			ResolutionDescription -> "Automatically set to FirstAndLast when any Blank options are specified.",
			AllowNull -> True,
			Category -> "Blanks",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> None | First | Last | FirstAndLast | MethodChange
				],
				Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			]
		},

		(* Shared chromatography options *)
		(* Injection table to determine what order to inject the samples, insert blank or standard runs, etc., from LC experiments *)
		{
			OptionName -> InjectionTable,
			Default -> Automatic,
			Description -> "The order of Sample, Standard, and Blank sample loading into the Instrument during measurement and/or collection.",
			ResolutionDescription -> "Determined to the order of input samples articulated. Standard and Blank samples are inserted based on the determination of StandardFrequency and BlankFrequency. For example, StandardFrequency -> FirstAndLast and BlankFrequency -> Null result in Standard samples injected first, then samples, and then the Standard sample set again at the end.",
			AllowNull -> False,
			Widget -> Adder[
				{
					"Type" -> Widget[
						Type -> Enumeration,
						Pattern :> Standard | Sample | Blank
					],
					"Sample" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
							ObjectTypes -> {Model[Sample], Object[Sample]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Materials"
								}
							}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, GCBlankTypeP, Null]
						]
					],
					"SamplingMethod" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[LiquidInjection, HeadspaceInjection, SPMEInjection, Automatic, Null]
					],
					"SamplePreparationOptions" -> Alternatives[
						Widget[
							Type -> Expression,
							Pattern :> GCSamplePreparationOptionsP,
							Size -> Paragraph
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic]
						]
					],
					"SeparationMethod" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Method, GasChromatography]]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic]
						]
					]
				},
				Orientation -> Vertical
			],
			Category -> "Injection Table"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleCaps,
				Default -> Automatic,
				Description -> "A cover to place on the working container to facilitate the injection or any movements on the autosampler deck.",
				ResolutionDescription -> "If a new cap on the sample container is required automatically set to a cap compatible with the autosampler and the working container; if the sample needs to move on the autosampler, a magnetic cap is required, otherwise a pierceable cap is sufficient.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Item, Cap]]
				],
				Category -> "Hidden"
			}
		],
		IndexMatching[
			IndexMatchingParent -> Standard,
			{
				OptionName -> StandardCaps,
				Default -> Automatic,
				Description -> "A cover to place on the standard container to facilitate the injection or any movements on the autosampler deck.",
				ResolutionDescription -> "If a new cap on the sample container is required automatically set to a cap compatible with the autosampler and the working container; if the standard needs to move on the autosampler, a magnetic cap is required, otherwise a pierceable cap is sufficient.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Item, Cap]]
				],
				Category -> "Hidden"
			}
		],
		IndexMatching[
			IndexMatchingParent -> Blank,
			{
				OptionName -> BlankCaps,
				Default -> Automatic,
				Description -> "A cover to place on the blank container to facilitate the injection or any movements on the autosampler deck.",
				ResolutionDescription -> "If a new cap on the sample container is required automatically set to a cap compatible with the autosampler and the working container; if the blank needs to move on the autosampler, a magnetic cap is required, otherwise a pierceable cap is sufficient.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Item, Cap]]
				],
				Category -> "Hidden"
			}
		],

		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SimulationOption,
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelAmount
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"2 mL clear glass GC vial\"]."
			}
		]
	}
];


(* Errors *)


(* Testing warning *)
Error::GCColumnMaxTemperatureExceeded = "Temperature setpoint(s) `1` in option `2` exceed(s) the maximum column temperature of `3`. Your column may be damaged and/or cause damage to the instrument above this temperature. Please select temperature setpoints below the column maximum temperature of `3`.";
Error::GCSampleVolumeOutOfRange = "The specified InjectionVolume(s) `1` with SamplingMethod `2`Injection do(es) not fall between 1% and 100% of the volume of the specified `2`InjectionSyringe (`3`). Please specify an InjectionVolume between 1% and 100% of `3`.";
Error::CospecifiedInitialColumnConditions = "Options `1` and `2` cannot be specified for any separation simultaneously. Please specify only one of options `1` and `2`.";
Error::IncompatibleInletAndInletOption = "Options `1` are not compatible with the specified `2` inlet. Please select the Multimode inlet to use these options.";
Error::SplitRatioAndFlowRateCospecified = "Options SplitRatio and SplitVentFlowRate cannot be specified simultaneously for any sample. Please make sure these options are not specified at the same time for any sample.";
Error::GCOptionsAreConflicting = "Options `1` cannot be specified while `2` is set to `3` for a given sample. Please make sure these options are not specified at the same time for any sample.";
Error::OptionsNotCompatibleWithSamplingMethod = "Options `1` cannot be specified if the SamplingMethod is `2`. Please do not specify these options for this SamplingMethod, or change the SamplingMethod to be compatible with these options.";
Error::GCContainerIncompatible = "Containers `2` specified in option `1` are incompatible with the specified Instrument. Containers must have a CEVial or HeadspaceVial footprint. For samples that require on-deck agitation or vortexing, the containers must have a respective NeckType of 9/425 or 18/425. Otherwise, the sample containers must be capable of being covered by a pierceable cap.";
Error::OptionValueOutOfBounds = "If the SamplingMethod is `5` and a `1` syringe has been selected, `2` must be within `3` - `4`. Please specify a value within the allowed range for this option and SamplingMethod.";
Error::DetectorOptionsIncompatible = "Options `1` are not compatible with the specified detector: `2`. Please make sure the specified options are compatible with the specified detector.";
Error::GCORingNotCompatible = "The specified LinerORing `1` cannot currently be used on instrument `2` because its inner diameter must be greater than `3`, its outer diameter must be less than `4`, and it must have a max temperature rating of `5`. Please select an o-ring of the correct specifications.";
Error::GCSeptumNotCompatible = "The specified InletSeptum `1` cannot currently be used on instrument `2` because its diameter must be `3`, its thickness must be greater than `4`, and it must have a max temperature rating of `5`. Please select a septum of the correct specifications.";
Error::GCIncompatibleColumn = "The specified Column `1` is not a gas chromatography column. Please select a column with a ChromatographyType of GasChromatography.";
Error::GCTrimColumnConflict = "Option TrimColumnLength may only be specified if TrimColumn is True, otherwise it may not be specified. Please ensure these options are not conflicting.";
Error::GCLiquidInjectionSyringeRequired = "A LiquidInjection sample has been specified but a LiquidInjectionSyringe has not. Please specify a LiquidInjectionSyringe.";
Error::GCIncompatibleLiquidInjectionSyringe = "The specified LiquidInjectionSyringe does not have the correct GCInjectionType. Please specify a LiquidInjectionSyringe with a GCInjectionType of LiquidInjection.";
Error::GCHeadspaceInjectionSyringeRequired = "A HeadspaceInjection sample has been specified but a HeadspaceInjectionSyringe has not. Please specify a HeadspaceInjectionSyringe.";
Error::GCIncompatibleHeadspaceInjectionSyringe = "The specified HeadspaceInjectionSyringe does not have the correct GCInjectionType. Please specify a HeadspaceInjectionSyringe with a GCInjectionType of HeadspaceInjection.";
Error::GCSPMEInjectionFiberRequired = "A SPMEInjection sample has been specified but a SPMEInjectionFiber has not. Please specify a SPMEInjectionFiber.";
Error::GCLiquidHandlingSyringeRequired = "A LiquidHandling step has been specified but a LiquidHandlingSyringe has not. Please specify a LiquidHandlingSyringe.";
Error::GCIncompatibleLiquidHandlingSyringe = "The specified LiquidHandlingSyringe does not have the correct GCInjectionType. Please specify a LiquidHandlingSyringe with a GCInjectionType of LiquidHandling.";
Error::ColumnConditioningOptionsConflict = "ConditionColumn is `1`, but options `2` are`3`set to Null. Please ensure options `2` are`3`set to Null if ConditionColumn is `1`.";
Error::LiquidInjectionAgitationConflict = "Agitation options `2` are specified, but the specified `1`SamplingMethod is LiquidInjection. Please do not specify Agitation options for samples that will be injected using a LiquidInjection `1`SamplingMethod.";
Error::AgitationOptionsConflict = "For any sample, all Agitation options `1` must be specified if and only if the corresponding Agitate is set to True. Please ensure either all or none of the Agitation options are specified, and that these options agree with the corresponding Agitate option specification.";
Error::ContainersOverfilledByDilution = "Dilution options `1` are specified that result in overfilling of the final sample GC vials. Please review the sample volumes, dilution volumes, and container volumes to ensure the containers are not overfilled during dilution.";
Error::VortexOptionsConflict = "For any sample, all Vortex options `1` must be specified if and only if the corresponding Vortex is set to True. Please ensure either all or none of the Vortex options are specified, and that these options agree with the corresponding Vortex option specification.";
Error::PreInjectionSyringeWashOptionsConflict = "For any sample, all LiquidPreInjectionSyringeWash options `1` must be specified if and only if the corresponding LiquidPreInjectionSyringeWash is set to True. Please ensure either all or none of the LiquidPreInjectionSyringeWash options are specified, and that these options agree with the corresponding LiquidPreInjectionSyringeWash option specification.";
Error::LiquidSampleWashOptionsConflict = "For any sample, all LiquidSampleWash options `1` must be specified if and only if the corresponding LiquidSampleWash is set to True. Please ensure either all or none of the LiquidSampleWash options are specified, and that these options agree with the corresponding LiquidSampleWash option specification.";
Error::InsufficientSampleVolume = "Specified `2`InjectionVolume amounts `1` request a larger amount of sample than will be present in the target sample container at the time of injection, including replicates. Please make sure a sufficient volume of sample is present in the target sample container prior to sampling.";
Error::PostInjectionSyringeWashOptionsConflict = "For any sample, all LiquidPostInjectionSyringeWash options `1` must be specified if and only if the corresponding LiquidPostInjectionSyringeWash is set to True. Please ensure either all or none of the LiquidPostInjectionSyringeWash options are specified, and that these options agree with the corresponding LiquidPostInjectionSyringeWash option specification.";
Error::HeadspaceSyringeFlushingOptionsConflict = "Options `1` must be specified if and only if `2`HeadspaceSyringeFlushing contains `3`, respectively. Please ensure the syringe flushing times specified agree with the specified `2`HeadspaceSyringeFlushing types.";
Error::SPMEConditionOptionsConflict = "Specified options `1` do not agree with the specified `2`SPMECondition option. Please ensure that `2`SPMEConditioningTemperature and at least one of {`2`SPMEPreConditioningTime, `2`SPMEPostInjectionConditioningTime} is specified if and only if `2`SPMECondition is True.";
Error::SPMEDerivatizationOptionsConflict = "Options `1` must be specified if and only if a `2`SPMEDerivatizingAgent is specified. Please ensure that these SPME derivatization options are only specified if a SPMEDerivatizationAgent is specified.";
Error::HeadspaceAgitateWhileSampling = "If the `1`SamplingMethod is HeadspaceInjection, `1`AgitateWhileSampling must be True. Please ensure that `1`AgitateWhileSampling is True for all HeadspaceInjection samples.";
Error::HeadspaceWithoutAgitation = "If the `1`SamplingMethod is HeadspaceInjection, `1`Agitate must be True. Please ensure that `1`Agitate is True for all HeadspaceInjection samples.";
Error::LiquidAgitateWhileSampling = "If the `1`SamplingMethod is LiquidInjection, `1`AgitateWhileSampling must not be True. Please ensure that `1`AgitateWhileSampling is not specified for all LiquidInjection samples.";
Error::InvalidBlankSamplePreparationOptions = "Options `1` may not be specified if the Blank is NoInjection. Please ensure no sample preparation options are specified for Blanks that do not require a sample (NoInjection).";
Error::GCUnspecifiedVials = "When a `1` must be aliquoted into a GC-compatible container, a `1`Vial must be specified. Please specify a `1`Vial for all `1`s that must be aliquoted.";
Error::GCUnspecifiedAmounts = "When a `1` must be aliquoted into a GC-compatible container, a `1`Amount must be specified. Please specify a `1`Amount for all `1`s that must be aliquoted.";
Error::GCUnneededVials = "When a `1` is not specified, or a Blank type of NoInjection is specified, a `1`Vial should not be specified. Please do not specify a `1`Vial for `1`s that do not require one.";
Error::GCUnneededAmounts = "When a `1` is not specified, or a Blank type of NoInjection is specified, a `1`Amount should not be specified. Please do not specify a `1`Amount for `1`s that do not require one.";
Error::GCMismatchedVialsAndAmounts = "When using an Object as a `1`, either both a `1`Amount and `1`Vial or neither must be specified. Please specify either both a `1`Amount and a `1`Vial or neither for all `1`s that request an Object.";
Error::GCStandardBlankContainer = "`1`s `2` are currently in GC-incompatible containers, and no compatible `1`Vial has been specified for these `1`s. Please ensure that a `1`Vial is specified for all `1`s in GC-incompatible containers.";
Error::GCPostRunOvenTimeTemperatureConflict = "The options `1`PostRunOvenTime and `1`PostRunOvenTemperature must be specified together. Please specify both options if a post run period is desired, or remove the post run period by setting both options to Null.";
Error::DetectorOptionsRequired = "Options `1` are required for the specified detector: `2`. Please make sure the specified options are not Null with the specified detector";
Error::GCGasSaverConflict = "Options `1`GasSaverFlowRate and `1`GasSaverActivationTime must be specified if GasSaver is True, and Null if GasSaver is False. If GasSaver is required, please make sure that GasSaver is set to True and these options are non-Null. If GasSaver is not required, please make sure GasSaver is set to False and these options are Null.";
Error::TooManyCEVialsForAutosampler = "The number of samples, standards, and blanks that have been requested in CEVial Footprint containers exceeds the maximum number of vials that can fit on the autosampler deck (81). Please reduce the number of samples, standards, and blanks to be used in this experiment.";
Error::TooManyHeadspaceVialsForAutosampler = "The number of samples, standards, and blanks that have been requested in HeadspaceVial Footprint containers exceeds the maximum number of vials that can fit on the autosampler deck (3 groups of up to 15 vials, with each group containing only 1 container size, e.g. 2 groups of 20 mL HeadspaceVials and 1 group of 10 mL HeadspaceVials). Please reduce the number of samples, standards, and blanks to be used in this experiment or request all samples, standards, and blanks in HeadspaceVials of the same size if fewer than 45 vials are to be analyzed.";
Error::CoverNeededForContainer = "The `1`sample(s) `2` at indices `3` have a container model for which a cover compatible with both the gas chromatrography autosampler and container could not be found. Please source a compatible cap for this container, specify another container, or allow an aliquot container to resolve automatically.";

Warning::AutomaticallySelectedWashSolvent = "No `1`SyringeWashSolvent has been specified, using default Hexanes.";
Warning::AutomaticallySelectedDilutionSolvent = "No `1`DilutionSolvent has been specified, using default Hexanes.";
(*Warning::AutomaticallySelectedGCStandard="No Standard was specified, using default Hexanes.";
Warning::AutomaticallySelectedGCBlank="No Blank type was specified, using default NoInjection.";*)          (* these warnings are not thrown in the experiment function *)
Warning::GCColumnMinTemperatureExceeded = "Temperature setpoint(s) `1` in option `2` are below the minimum column temperature of `3`! Your column may not be able to perform separations at this temperature.";
Warning::OverwritingSeparationMethod = "The values for `2` as specified in the `1` will be overwritten based on explicitly set values for the `2` option(s). Please review and ensure that it meets desired specifications. Note that these options are dependent on each other, which means that changing one from the Method will change the others.";
Warning::UnneededSyringeComponent = "The specified `1` is not required, as none of the values in option(s) `3` specified are `2`. Please ensure option `3` has been specified correctly for each sample.";
Warning::ContainerCapSwapRequired = "The `1`samples `2` at indices `3` will be re-covered automatically with the following GC-compatible cover models: `4`.";


(* ::Subsection::Closed:: *)
(* ExperimentGasChromatography *)


(* ::Subsubsection:: *)
(* ExperimentGasChromatography *)

(* Set a flag to determine whether we are doing streaming for GC protocols *)
$GasChromatographyStreaming = True;

(* Core sample overload *)
ExperimentGasChromatography[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedSamples, listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		safeOps,safeOpsTests,validLengths,validLengthTests,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,safeOptionsNamed,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,optionsWithObjects,
		allObjects,availableInstruments,injectionTableLookup,injectionTableObjects,sampleObjects,modelContainerObjects,instrumentObjects,
		modelInstrumentObjects,columnObjects,modelColumnObjects,syringeObjects, modelSyringeObjects, spmeFiberObjects, modelSPMEFiberObjects,
		methodObjects, modelLinerObjects,linerObjects, runningCache,
		oRingObjects, modelORingObjects, septumObjects, modelSeptumObjects, containerObjects, sampleFields, modelSampleFields, containerFields,
		modelContainerFields, fieldsToDownload, objsToDownloadFrom, downloadedStuff,samplePreparationSimulation, modelCaps, modelCapObjects,
		(* timeTableQ*)
		timeTable, status, rawTimes,
		tick,
		tock,
		timeTableQ

	},
	(* hidden TimeTable option *)
	timeTableQ = If[MemberQ[Keys[ToList@myOptions], TimeTable], Quiet[OptionValue[TimeTable]], False];

	timeTable = {};
	rawTimes = {};
	status = "Simulating sample preparation...";
	tick = AbsoluteTime[];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Make sure we're working with a list of options, remove the TimeTable option *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], DeleteCases[ToList[myOptions], Rule[TimeTable, _]]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentGasChromatography,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	status = "Parsing options...";
	tock = AbsoluteTime[];
	rawTimes = Append[rawTimes, Ceiling[tock - tick, 0.01]];
	timeTable = Append[timeTable, "Simulating sample preparation: " <> ToString[Last[rawTimes]] <> " sec"];
	tick = AbsoluteTime[];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentGasChromatography, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentGasChromatography, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(*change all Names to objects *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

	(* we need to get the cache from the container overload *)
	runningCache = Lookup[safeOps, Cache];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentGasChromatography, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentGasChromatography, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentGasChromatography, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentGasChromatography, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentGasChromatography, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

	status = "Building cache...";
	tock = AbsoluteTime[];
	rawTimes = Append[rawTimes, Ceiling[tock - tick, 0.01]];
	timeTable = Append[timeTable, "Parsing options: " <> ToString[Last[rawTimes]] <> " sec"];
	tick = AbsoluteTime[];

	(* Any options whose values _could_ be an object *)
	optionsWithObjects = {
		Column,
		Instrument,
		LiquidInjectionSyringe,
		HeadspaceInjectionSyringe,
		SPMEInjectionFiber,
		LiquidHandlingSyringe,
		SyringeWashSolvent,
		SecondarySyringeWashSolvent,
		TertiarySyringeWashSolvent,
		QuaternarySyringeWashSolvent,
		DilutionSolvent,
		SecondaryDilutionSolvent,
		TertiaryDilutionSolvent,
		InletLiner,
		LinerORing,
		InletSeptum,
		ColumnValidationStandard,
		SPMEDerivatizingAgent,
		SeparationMethod,
		StandardSeparationMethod,
		BlankSeparationMethod,
		Standard,
		Blank,
		StandardVial,
		BlankVial,
		AliquotContainer
	};

	(*we also need to the check the objects within the injection table*)
	injectionTableLookup = Lookup[ToList[safeOps], InjectionTable, Null];

	(*if injection table is specified, need to check all of the column and gradient objects within*)
	injectionTableObjects = If[MatchQ[injectionTableLookup, Except[Automatic | Null]],
		(*get the samples, SeparationMethod and Columns*)
		Flatten[injectionTableLookup[[All, {2, 4, 5}]]],
		(*otherwise, we can just say Null*)
		Null
	];

	(*all the instruments to use*)
	availableInstruments = {Model[Instrument, GasChromatograph, "Agilent 8890 GCMS"]};

	{
		modelCaps
	} = Search[
		{
			Model[Item, Cap]
		},
		{
			Pierceable == True && DeveloperObject != True && Deprecated != True
		}
	];

	(* Flatten and merge all possible objects needed into a list *)
	allObjects = DeleteDuplicates@Download[
		Cases[
			Flatten@Join[
				mySamplesWithPreparedSamples,
				(* Default objects *)
				{
					(* default column *)
					Model[Item, Column, "HP-5ms Ultra Inert, 30 m, 0.25 mm ID, 0.25 \[Mu]m film thickness, 7 inch cage"],
					(* containers *)
					Model[Container, Vessel, "20 mL clear glass GC vial"],
					Model[Container, Vessel, "10 mL clear glass GC vial"],
					Model[Container, Vessel, "2 mL clear glass GC vial"],
					Model[Container, Vessel, "0.3 mL clear glass GC vial"],
					(* caps *)
					(* magnetic caps *)
					Model[Item, Cap, "id:L8kPEjn1PRww"],
					Model[Item, Cap, "id:AEqRl9Kmnrqv"],
					(* non-magnetic caps *)
					modelCaps,
					(* Instruments *)
					availableInstruments,
					(* default GC liner consumables *)
					Model[Item, GCInletLiner, "GC inlet liner, split, single taper, glass wool, deactivated, low pressure drop"],
					Model[Item, GCInletLiner, "GC inlet liner, splitless, single taper, glass wool, deactivated"],
					(* default liquid injection syringes *)
					Model[Container, Syringe, "1 \[Mu]L GC liquid sample injection syringe"],
					Model[Container, Syringe, "5 \[Mu]L GC liquid sample injection syringe"],
					Model[Container, Syringe, "10 \[Mu]L GC liquid sample injection syringe"],
					Model[Container, Syringe, "25 \[Mu]L GC liquid sample injection syringe"],
					Model[Container, Syringe, "100 \[Mu]L GC liquid sample injection syringe"],
					(* default headspace injection syringe *)
					Model[Container, Syringe, "2500 \[Mu]L GC headspace sample injection syringe"],
					(* default liquid handling syringe *)
					Model[Container, Syringe, "2500 \[Mu]L GC PAL3 liquid handling syringe"],
					(* default spme fibers *)
					Model[Item, SPMEFiber, "PDMS, 30 \[Mu]m"] (* 30 um PDMS fiber *)
					(* default septa *)
					(* default orings *)
				},
				(* All options that _could_ have an object *)
				Lookup[expandedSafeOps, optionsWithObjects],
				(*also include anything within the injection table*)
				If[!NullQ[injectionTableObjects], injectionTableObjects, {}]
			],
			ObjectP[]
		],
		Object,
		Date -> Now
	];

	(* Isolate objects of particular types so we can build a indexed-download call *)
	sampleObjects = Cases[allObjects, NonSelfContainedSampleP];
	containerObjects = Cases[allObjects, ObjectP[Object[Container]]];
	modelCapObjects = Cases[allObjects, ObjectP[Model[Item, Cap]]];
	modelContainerObjects = Cases[allObjects, ObjectP[Model[Container]]];
	instrumentObjects = Cases[allObjects, ObjectP[Object[Instrument, GasChromatograph]]];
	modelInstrumentObjects = Cases[allObjects, ObjectP[Model[Instrument, GasChromatograph]]];
	columnObjects = Cases[allObjects, ObjectP[Object[Item, Column]]];
	modelColumnObjects = Cases[allObjects, ObjectP[Model[Item, Column]]];
	syringeObjects = Cases[allObjects, ObjectP[Object[Container, Syringe]]];
	modelSyringeObjects = Cases[allObjects, ObjectP[Model[Container, Syringe]]];
	spmeFiberObjects = Cases[allObjects, ObjectP[Object[Item, SPMEFiber]]];
	modelSPMEFiberObjects = Cases[allObjects, ObjectP[Model[Item, SPMEFiber]]];
	methodObjects = Cases[allObjects, ObjectP[Object[Method, GasChromatography]]];
	linerObjects = Cases[allObjects, ObjectP[Object[Item, GCInletLiner]]];
	modelLinerObjects = Cases[allObjects, ObjectP[Model[Item, GCInletLiner]]];
	oRingObjects = Cases[allObjects, ObjectP[Object[Item, ORing]]];
	modelORingObjects = Cases[allObjects, ObjectP[Model[Item, ORing]]];
	septumObjects = Cases[allObjects, ObjectP[Object[Item, Septum]]];
	modelSeptumObjects = Cases[allObjects, ObjectP[Model[Item, Septum]]];

	(* get the fields from SamplePreparationCacheFields *)
	sampleFields = SamplePreparationCacheFields[Object[Sample], Format -> Sequence];
	modelSampleFields = SamplePreparationCacheFields[Model[Sample], Format -> Sequence];
	containerFields = SamplePreparationCacheFields[Object[Container], Format -> Sequence];
	modelContainerFields = Sequence @@ Join[
		SamplePreparationCacheFields[Model[Container]],
		{NeckType}
	];

	(* get the objects to download from *)
	objsToDownloadFrom = {
		(*1*)sampleObjects,
		(*2*)containerObjects,
		(*3*)modelCapObjects,
		(*4*)modelContainerObjects,
		(*5*)modelInstrumentObjects,
		(*6*)modelColumnObjects,
		(*7*)modelSyringeObjects,
		(*8*)modelSPMEFiberObjects,
		(*9*)modelLinerObjects,
		(*10*)linerObjects,
		(*11*)methodObjects,
		(*12*)instrumentObjects,
		(*13*)columnObjects,
		(*14*)syringeObjects,
		(*15*)spmeFiberObjects,
		(*16*)oRingObjects,
		(*17*)modelORingObjects,
		(*18*)septumObjects,
		(*19*)modelSeptumObjects
	};

	(* get all the fields to download from*)
	(* should probably narrow down the needed fields to speed this up *)
	fieldsToDownload = {
		(* sampleObjects *)
		(*1*){
			Packet[sampleFields],
			Packet[Container[{containerFields}]],
			Packet[Container[Model][{modelContainerFields}]],
			(* Also downloading model now *)
			Packet[Model[modelSampleFields]]
		},
		(* containerObjects *)
		(*2*){
			Packet[containerFields],
			Packet[Model[{modelContainerFields}]]
		},
		(* capObjects *)
		(*3*){Packet[CoverFootprint, Pierceable]},
		(* modelContainerObjects *)
		(*4*){Packet[modelContainerFields]},
		(* modelInstrumentObjects *)
		(*5*){Packet[Name]},
		(* modelColumnObjects *)
		(*6*){Packet[Name, MinTemperature, MaxTemperature, ChromatographyType, Diameter, Polarity, ColumnLength, FilmThickness]},
		(* modelSyringeObjects *)
		(*7*){Packet[Name, GCInjectionType, MaxVolume, ConnectionType]},
		(* modelSPMEFiberObjects *)
		(*8*){Packet[Name, MaxTemperature, MinTemperature]},
		(* modelLinerObjects *)
		(*9*){Packet[Name, Volume]},
		(* linerObjects *)
		(*10*){Packet[Name, Model], Packet[Model[{Name, Volume}]]},
		(* methodObjects *)
		(*11*){Packet[Name, ColumnLength, ColumnDiameter, ColumnFilmThickness, InletLinerVolume, Detector, CarrierGas, InletSeptumPurgeFlowRate, InitialInletTemperature,
			InitialInletTemperatureDuration, InletTemperatureProfile, SplitRatio, SplitVentFlowRate, SplitlessTime, InitialInletPressure, InitialInletTime, GasSaver,
			GasSaverFlowRate, GasSaverActivationTime, SolventEliminationFlowRate, InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity,
			InitialColumnResidenceTime, InitialColumnSetpointDuration, ColumnPressureProfile, ColumnFlowRateProfile, OvenEquilibrationTime, InitialOvenTemperature,
			InitialOvenTemperatureDuration, OvenTemperatureProfile, PostRunOvenTemperature, PostRunOvenTime, PostRunFlowRate, PostRunPressure]},
		(* instrumentObjects *)
		(*12*){Packet[Name, Model], Packet[Model[{Name}]]},
		(* columnObjects *)
		(*13*){Packet[Name, Model], Packet[Model[{Name, MinTemperature, MaxTemperature, ChromatographyType, Diameter, Polarity, ColumnLength, FilmThickness}]]}, (* MinTemperature,MaxTemperature *)                        (* syringeObjects *)
		(*14*){Packet[Name, Model], Packet[Model[{Name, GCInjectionType, MaxVolume, ConnectionType}]]}, (* GCInjectionType,MaxVolume *)
		(* spmeFiberObjects *)
		(*15*){Packet[Name, Model], Packet[Model[{Name, MaxTemperature, MinTemperature}]]}, (* MaxTemperature, MinTemperature *)
		(* oRingObjects *)
		(*16*){Packet[Name, Model], Packet[Model[{Name, InnerDiameter, OuterDiameter, MaxTemperature}]]}, (* InnerDiameter,OuterDiameter,MaxTemperature *)
		(* modelORingObjects *)
		(*17*){Packet[Name, InnerDiameter, OuterDiameter, MaxTemperature]}, (* MaxTemperature, MinTemperature *)
		(* septumObjects *)
		(*18*){Packet[Name, Model], Packet[Model[{Name, Diameter, Thickness, MaxTemperature}]]}, (* InnerDiameter,OuterDiameter,MaxTemperature *)
		(* modelSeptumObjects *)
		(*19*){Packet[Name, Diameter, Thickness, MaxTemperature]} (* Diameter,Thickness,MaxTemperature *)
	};

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	downloadedStuff = Quiet[
		Download[
			objsToDownloadFrom,
			fieldsToDownload,
			Cache -> runningCache,
			Simulation -> samplePreparationSimulation,
			Date -> Now
		],
		(* we need to quiet object does not exist because there could be prep primitive options here that create nonexistent samples *)
		{Download::FieldDoesntExist, Download::NotLinkField, Download::MissingCacheField, Download::ObjectDoesNotExist,Download::MissingField}
	];
	cacheBall=FlattenCachePackets[
		{
			runningCache,
			downloadedStuff
		}
	];

	status = "Resolving options...";
	tock = AbsoluteTime[];
	rawTimes = Append[rawTimes, Ceiling[tock - tick, 0.01]];
	timeTable = Append[timeTable, "Building cache: " <> ToString[Last[rawTimes]] <> " sec"];
	tick = AbsoluteTime[];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentGasChromatographyOptions[ToList[mySamplesWithPreparedSamples], expandedSafeOps, Cache -> cacheBall, Simulation -> samplePreparationSimulation,Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {resolveExperimentGasChromatographyOptions[ToList[mySamplesWithPreparedSamples], expandedSafeOps, Cache -> cacheBall, Simulation -> samplePreparationSimulation], {}},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentGasChromatography,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentGasChromatography, collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	status = "Creating resources...";
	tock = AbsoluteTime[];
	rawTimes = Append[rawTimes, Ceiling[tock - tick, 0.01]];
	timeTable = Append[timeTable, "Resolving options: " <> ToString[Last[rawTimes]] <> " sec"];
	tick = AbsoluteTime[];

	protocolObject = Null;

	(* Build packets with resources *)
	{resourcePackets, resourcePacketTests} = If[gatherTests,
		experimentGasChromatographyResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> samplePreparationSimulation,Output -> {Result, Tests}],
		{experimentGasChromatographyResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> samplePreparationSimulation], {}}
	];

	status = "Uploading protocol...";
	tock = AbsoluteTime[];
	rawTimes = Append[rawTimes, Ceiling[tock - tick, 0.01]];
	timeTable = Append[timeTable, "Creating resources: " <> ToString[Last[rawTimes]] <> " sec"];
	tick = AbsoluteTime[];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		status = "Finished!";
		tock = AbsoluteTime[];
		rawTimes = Append[rawTimes, Ceiling[tock - tick, 0.01]];
		timeTable = Append[timeTable, "Returning options: " <> ToString[Last[rawTimes]] <> " sec"];
		timeTable = Append[timeTable, "Total timing: " <> ToString[Total[rawTimes]] <> " sec"];
		tick = AbsoluteTime[];

		If[timeTableQ, Print[TableForm@timeTable]];

		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentGasChromatography, collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets, $Failed] && !MatchQ[resolvedOptionsResult, $Failed],
		(*if we need to also upload accessory packets*)
		If[Length[resourcePackets] > 1,
			UploadProtocol[
				First[resourcePackets],
				Rest[resourcePackets],
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				CanaryBranch -> Lookup[safeOps, CanaryBranch],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> Object[Protocol, GasChromatography],
				Cache -> cacheBall,
				Simulation -> samplePreparationSimulation
			],
			(*otherwise just protocol packet*)
			UploadProtocol[
				First[resourcePackets],
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				CanaryBranch -> Lookup[safeOps, CanaryBranch],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> Object[Protocol, GasChromatography],
				Cache -> cacheBall,
				Simulation -> samplePreparationSimulation
			]
		],
		$Failed
	];

	status = "Finished!";
	tock = AbsoluteTime[];
	rawTimes = Append[rawTimes, Ceiling[tock - tick, 0.01]];
	timeTable = Append[timeTable, "Uploading protocol: " <> ToString[Last[rawTimes]] <> " sec"];
	timeTable = Append[timeTable, "Total timing: " <> ToString[Total[rawTimes]] <> " sec"];
	tick = AbsoluteTime[];

	If[timeTableQ, Print[TableForm@timeTable]];

	(* Return requested output *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentGasChromatography, collapsedResolvedOptions],
		Preview -> Null
	}
];

(* Mixed input overload *)
ExperimentGasChromatography[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationSimulation, cache,
		containerToSampleResult, containerToSampleOutput, samples, sampleOptions, containerToSampleTests, containerToSampleSimulation},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];
	cache = Lookup[listedOptions, Cache, {}];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentGasChromatography,
			ToList[myContainers],
			ToList[myOptions],
			DefaultPreparedModelContainer -> Model[Container, Vessel, "2 mL clear glass GC vial"]
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

	(* convert the containers to samples, and also get the options index matched properly *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentGasChromatography,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> samplePreparationSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentGasChromatography,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> samplePreparationSimulation
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
			Preview -> Null,
			Simulation -> Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentGasChromatography[samples, ReplaceRule[sampleOptions, Simulation->containerToSampleSimulation]]
	]
];









(* ::Subsection::Closed:: *)
(* Resolve Options *)


(* ::Subsubsection::Closed:: *)
(* resolveExperimentGasChromatographyOptions *)


DefineOptions[
	resolveExperimentGasChromatographyOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentGasChromatographyOptions[mySamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentGasChromatographyOptions]] := Module[
	{outputSpecification, output, gatherTests, engineQ, cache, samplePrepOptions, gasChromatographyOptions, simulatedSamples, resolvedSamplePrepOptions, samplePrepTests,
		gasChromatographyOptionsAssociation, invalidInputs, invalidOptions, targetVials, resolvedAliquotOptions, aliquotTests, samplePackets, discardedSamplePackets, discardedInvalidInputs,
		discardedTest,  simulatedContainerModels, sampleContainers, resolvedExperimentOptions, resolvedPostProcessingOptions, requiredAliquotAmounts,
		resolvedOptions, allTests, resolvedInletLiner, columnModelPacket, minColumnTempLimit, maxColumnTempLimit, recalculateSampleMethodOptions,	recalculateStandardMethodOptions,	recalculateBlankMethodOptions,
		containerlessSamples, containerlessInvalidInputs, containersExistTest, protocolName, validProtocolNameQ, invalidProtocolName, validProtocolNameTest, standards, tooManySamplesQ,
		tooManySamplesInputs, tooManySamplesTest, column, separationMode, roundedInletTemperatureProfile, inletTemperatureProfileTests, roundedColumnPressureProfile,
		columnPressureProfileTests, roundedColumnFlowRateProfile, columnFlowRateProfileTests, roundedOvenTemperatureProfile, ovenTemperatureProfileTests, columnModel,
		allInitialColumnFlowrates, allInitialColumnPressures, allInitialColumnAverageVelocities, allInitialColumnResidenceTimes,
		specifiedInletModes, specifiedSamplingMethods, resolvedSamplingMethods, specifiedLiquidInjectionSyringe, specifiedLiquidInjectionSyringeModel,
		specifiedLiquidInjectionSyringeModelType, specifiedLiquidInjectionSyringeVolume, preResolvedLiquidInjectionSyringe, specifiedLiquidSampleVolumes, resolvedLiquidInjectionSyringe, invalidColumns, invalidInputColumns, invalidColumnsTest, roundedGasChromatographyOptions,
		precisionTests, sampleStates, sampleMasses, sampleVolumes, specifiedLiquidSamplingOptions, specifiedLiquidPreInjectionSyringeWashVolumes, specifiedLiquidPreInjectionSyringeWashRates,
		specifiedLiquidPreInjectionNumberOfSolventWashes, specifiedLiquidPreInjectionNumberOfSecondarySolventWashes, specifiedLiquidPreInjectionNumberOfTertiarySolventWashes, specifiedLiquidPreInjectionNumberOfQuaternarySolventWashes,
		specifiedNumberOfLiquidSampleWashes, specifiedLiquidSampleWashVolumes, specifiedLiquidSampleFillingStrokes, specifiedLiquidSampleFillingStrokesVolumes, specifiedLiquidFillingStrokeDelays,
		specifiedSampleAspirationRates, specifiedLiquidSampleAspirationDelays, specifiedLiquidSampleOverAspirationVolumes, specifiedLiquidSampleInjectionRates,
		specifiedLiquidPostInjectionSyringeWashVolumes, specifiedLiquidPostInjectionSyringeWashRates, specifiedLiquidPostInjectionNumberOfSolventWashes, specifiedLiquidPostInjectionNumberOfSecondarySolventWashes,
		specifiedLiquidPostInjectionNumberOfTertiarySolventWashes, specifiedLiquidPostInjectionNumberOfQuaternarySolventWashes, specifiedHeadspaceSamplingOptions, specifiedHeadspaceSyringeTemperatures,
		specifiedHeadspaceSampleVolumes, specifiedHeadspaceSampleAspirationRates, specifiedHeadspaceSampleAspirationDelays, specifiedHeadspaceSampleInjectionRates,
		specifiedHeadspaceAgitateWhileSamplings, specifiedHeadspacePostInjectionFlushTimes, specifiedHeadspaceSyringeFlushings, specifiedSPMESamplingOptions,
		specifiedSPMEConditions, specifiedSPMEConditioningTemperatures, specifiedSPMEPreConditioningTimes, specifiedSPMEDerivatizingAgents, specifiedSPMEDerivatizingAgentAdsorptionTimes,
		specifiedSPMEDerivatizationPositions, specifiedSPMEDerivatizationPositionOffsets, specifiedSPMESampleExtractionTimes, specifiedSPMEAgitateWhileSamplings, specifiedSPMESampleDesorptionTimes,
		specifiedSPMEPostInjectionConditioningTimes, conditionColumnQ, resolvedColumnConditioningGas, combinedInletModes, preResolvedSamplingMethods, specifiedDiluteBooleans,
		specifiedDilutionSolventVolumes, specifiedSecondaryDilutionSolventVolumes, specifiedTertiaryDilutionSolventVolumes, resolvedDilutes, specifiedDilutionSolvent,
		specifiedSecondaryDilutionSolvent, specifiedTertiaryDilutionSolvent, numberOfDilutionSolventsSpecified, liquidSampleVolumeQuantities, specifiedHeadspaceInjectionSyringe,
		specifiedHeadspaceInjectionSyringeModel, compatibleHeadspaceInjectionSyringeModels,
		resolvedHeadspaceInjectionSyringe, specifiedSPMEInjectionFiber, specifiedSPMEInjectionFiberModel, resolvedSPMEInjectionFiber,
		specifiedLiquidHandlingSyringe, compatibleLiquidHandlingSyringeModels, specifiedLiquidHandlingSyringeModel, resolvedLiquidHandlingSyringe,
		specifiedOvenEquilibrationTimes, resolvedOvenEquilibrationTimes, specifiedOvenTemperatureProfiles, defaultOvenTemperatureProfile, resolvedOvenTemperatureProfiles,
		specifiedPostRunOvenTemperatures, specifiedInitialOvenTemperatures, resolvedPostRunOvenTemperatures, specifiedAgitateBooleans, specifiedAgitationTemperatures,
		specifiedAgitationMixRates, specifiedAgitationTimes, specifiedAgitationOnTimes, specifiedAgitationOffTimes, resolvedAgitates, resolvedAgitationTemperatures,
		resolvedAgitationTimes, resolvedAgitationMixRates, resolvedAgitationOnTimes, resolvedAgitationOffTimes, specifiedVortexBooleans, specifiedVortexMixRates, specifiedVortexTimes,
		resolvedVortexs, resolvedVortexMixRates, resolvedVortexTimes, masterSwitchedLiquidSamplingOptions, masterSwitchedHeadspaceSamplingOptions, masterSwitchedSPMESamplingOptions,
		masterSwitchedLiquidPreInjectionSyringeWashVolumes, masterSwitchedLiquidPreInjectionSyringeWashRates, masterSwitchedLiquidPreInjectionNumberOfSolventWashes, masterSwitchedLiquidPreInjectionNumberOfSecondarySolventWashes,
		masterSwitchedLiquidPreInjectionNumberOfTertiarySolventWashes, masterSwitchedLiquidPreInjectionNumberOfQuaternarySolventWashes, masterSwitchedLiquidSampleVolumes, masterSwitchedNumberOfLiquidSampleWashes,
		masterSwitchedLiquidSampleWashVolumes, masterSwitchedLiquidSampleFillingStrokes, masterSwitchedLiquidSampleFillingStrokesVolumes, masterSwitchedLiquidFillingStrokeDelays,
		masterSwitchedLiquidSampleAspirationDelays, masterSwitchedLiquidSampleOverAspirationVolumes, masterSwitchedLiquidSampleInjectionRates, masterSwitchedLiquidPostInjectionSyringeWashVolumes,
		masterSwitchedLiquidPostInjectionSyringeWashRates, masterSwitchedLiquidPostInjectionNumberOfSolventWashes, masterSwitchedLiquidPostInjectionNumberOfSecondarySolventWashes, masterSwitchedLiquidPostInjectionNumberOfTertiarySolventWashes,
		masterSwitchedLiquidPostInjectionNumberOfQuaternarySolventWashes, masterSwitchedHeadspaceSyringeTemperatures, masterSwitchedHeadspaceSampleVolumes, masterSwitchedHeadspaceSampleAspirationRates,
		masterSwitchedHeadspaceSampleAspirationDelays, masterSwitchedHeadspaceSampleInjectionRates, masterSwitchedHeadspaceAgitateWhileSamplings, masterSwitchedHeadspacePostInjectionFlushTimes,
		masterSwitchedHeadspaceSyringeFlushings, masterSwitchedSPMEConditions, masterSwitchedSPMEConditioningTemperatures, masterSwitchedSPMEPreConditioningTimes,
		masterSwitchedSPMEDerivatizingAgents, masterSwitchedSPMEDerivatizingAgentAdsorptionTimes, masterSwitchedSPMEDerivatizationPositions, masterSwitchedSPMEDerivatizationPositionOffsets,
		masterSwitchedSPMESampleExtractionTimes, masterSwitchedSPMEAgitateWhileSamplings, masterSwitchedSPMESampleDesorptionTimes, masterSwitchedSPMEPostInjectionConditioningTimes,
		resolvedLiquidSampleVolumes, syringeWashSolventSpecifiedQ, secondarySyringeWashSolventSpecifiedQ, tertiarySyringeWashSolventSpecifiedQ, quaternarySyringeWashSolventSpecifiedQ,
		syringeWashSolventsPresentQ, resolvedLiquidPreInjectionSyringeWashVolumes, resolvedLiquidPreInjectionSyringeWashRates, resolvedLiquidPreInjectionNumberOfSolventWashes, resolvedLiquidPreInjectionNumberOfSecondarySolventWashes,
		resolvedLiquidPreInjectionNumberOfTertiarySolventWashes, resolvedLiquidPreInjectionNumberOfQuaternarySolventWashes, resolvedNumberOfLiquidSampleWashes, resolvedLiquidSampleWashVolumes, resolvedLiquidSampleFillingStrokes,
		resolvedLiquidSampleFillingStrokesVolumes, resolvedLiquidFillingStrokeDelays, resolvedSampleAspirationRates, resolvedLiquidSampleAspirationDelays, resolvedLiquidSampleInjectionRates,
		resolvedLiquidSampleOverAspirationVolumes, resolvedLiquidPostInjectionSyringeWashVolumes, resolvedLiquidPostInjectionSyringeWashRates, resolvedLiquidPostInjectionNumberOfSolventWashes, resolvedLiquidPostInjectionNumberOfSecondarySolventWashes,
		resolvedLiquidPostInjectionNumberOfTertiarySolventWashes, resolvedLiquidPostInjectionNumberOfQuaternarySolventWashes, columnLength, columnPolarity, columnFilmThickness, maxColumnPolarity, totalColumnLength,
		maxFilmThickness, resolvedColumnConditioningTime, specifiedColumnConditioningGasFlowRate, columnDiameter, maxColumnDiameter, resolvedColumnConditioningGasFlowRate, specifiedInletLiner,
		resolvedHeadspaceSyringeTemperatures, resolvedHeadspaceSampleVolumes, resolvedHeadspaceSampleAspirationRates, resolvedHeadspaceSampleAspirationDelays, resolvedHeadspaceSampleInjectionRates,
		resolvedHeadspaceAgitateWhileSamplings, resolvedHeadspacePostInjectionFlushTimes, resolvedHeadspaceSyringeFlushings, resolvedSPMEConditions, fiberMinTemperature, resolvedSPMEConditioningTemperatures,
		resolvedSPMEPreConditioningTimes, resolvedSPMEDerivatizingAgentAdsorptionTimes, resolvedSPMEDerivatizationPositions, resolvedSPMEDerivatizationPositionOffsets,
		resolvedSPMESampleExtractionTimes, resolvedSPMEAgitateWhileSamplings, resolvedSPMESampleDesorptionTimes, resolvedSPMEPostInjectionConditioningTimes, specifiedSampleVialAspirationPositionOffsets,
		resolvedSampleVialAspirationPositionOffsets, specifiedHeadspacePreInjectionFlushTimes, masterSwitchedHeadspacePreInjectionFlushTimes, resolvedHeadspacePreInjectionFlushTimes,
		specifiedInitialInletTemperatures, specifiedInitialInletTemperatureDurations, specifiedInletTemperatureProfiles, resolvedInitialInletTemperatures,
		resolvedInitialInletTemperatureDurations, resolvedInletTemperatureProfiles, specifiedSplitRatios, specifiedSplitVentFlowRates, specifiedSplitlessTimes, specifiedInitialInletPressures,
		specifiedInitialInletTimes, specifiedSolventEliminationFlowRates, resolvedSplitRatios, resolvedSplitlessTimes,
		resolvedInitialInletPressures, resolvedInitialInletTimes, resolvedSolventEliminationFlowRates, resolvedGasSavers, resolvedGasSaverFlowRates,
		resolvedGasSaverActivationTimes, specifiedGasSavers, specifiedGasSaverFlowRates, specifiedGasSaverActivationTimes, specifiedInitialColumnFlowRates, specifiedInitialColumnPressures, specifiedInitialColumnAverageVelocities,
		specifiedInitialColumnResidenceTimes, specifiedInitialColumnSetpointDurations, specifiedColumnPressureProfiles, specifiedColumnFlowRateProfiles, resolvedInitialColumnFlowRates, resolvedInitialColumnPressures,
		resolvedInitialColumnAverageVelocities, resolvedInitialColumnResidenceTimes, resolvedInitialColumnSetpointDurations, resolvedColumnPressureProfiles, resolvedColumnFlowRateProfiles, specifiedCarrierGas,
		resolvedLiquidInjectionSyringeVolume, resolvedHeadspaceInjectionSyringeVolume, resolvedSPMEInjectionFiberMaxTemperature, columnReferencePressure, columnReferenceTemperature, specifiedDetector, expectedOutletPressure,
		resolvedInitialColumnFlowRateValues, specifiedFIDTemperature, specifiedFIDAirFlowRate, specifiedFIDDihydrogenFlowRate, specifiedFIDMakeupGasFlowRate, specifiedFIDMakeupGas, specifiedCarrierGasFlowCorrection,
		resolvedCarrierGasFlowCorrection, resolvedFIDTemperature, resolvedFIDAirFlowRate, resolvedFIDDihydrogenFlowRate, resolvedFIDMakeupGasFlowRate, resolvedFIDMakeupGas, specifiedStandardSamplingMethods, specifiedBlankSamplingMethods,
		specifiedLiquidPreInjectionSyringeWashes, specifiedLiquidPostInjectionSyringeWashes, specifiedPostInjectionNextSamplePreparationSteps, specifiedStandardLiquidSamplingOptions, specifiedStandardLiquidPreInjectionSyringeWashes,
		specifiedStandardLiquidPreInjectionSyringeWashVolumes, specifiedStandardLiquidPreInjectionSyringeWashRates, specifiedStandardLiquidPreInjectionNumberOfSolventWashes, specifiedStandardLiquidPreInjectionNumberOfSecondarySolventWashes,
		specifiedStandardLiquidPreInjectionNumberOfTertiarySolventWashes, specifiedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes, specifiedStandardNumberOfLiquidSampleWashes, specifiedStandardLiquidSampleWashVolumes,
		specifiedStandardLiquidSampleFillingStrokes, specifiedStandardLiquidSampleFillingStrokesVolumes, specifiedStandardLiquidFillingStrokeDelays, specifiedStandardLiquidSampleOverAspirationVolumes,
		specifiedStandardLiquidPostInjectionSyringeWashes, specifiedStandardLiquidPostInjectionSyringeWashVolumes, specifiedStandardLiquidPostInjectionSyringeWashRates, specifiedStandardLiquidPostInjectionNumberOfSolventWashes,
		specifiedStandardLiquidPostInjectionNumberOfSecondarySolventWashes, specifiedStandardLiquidPostInjectionNumberOfTertiarySolventWashes, specifiedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
		specifiedStandardPostInjectionNextSamplePreparationSteps, specifiedBlankLiquidSamplingOptions, specifiedBlankLiquidPreInjectionSyringeWashes, specifiedBlankLiquidPreInjectionSyringeWashVolumes,
		specifiedBlankLiquidPreInjectionSyringeWashRates, specifiedBlankLiquidPreInjectionNumberOfSolventWashes, specifiedBlankLiquidPreInjectionNumberOfSecondarySolventWashes, specifiedBlankLiquidPreInjectionNumberOfTertiarySolventWashes,
		specifiedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes, specifiedBlankLiquidPostInjectionSyringeWashes, specifiedBlankLiquidPostInjectionSyringeWashVolumes, specifiedBlankLiquidPostInjectionSyringeWashRates,
		specifiedBlankLiquidPostInjectionNumberOfSolventWashes, specifiedBlankLiquidPostInjectionNumberOfSecondarySolventWashes, specifiedBlankLiquidPostInjectionNumberOfTertiarySolventWashes,
		specifiedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes, specifiedBlankPostInjectionNextSamplePreparationSteps, specifiedStandardHeadspaceSamplingOptions, specifiedStandardHeadspaceSyringeTemperatures,
		specifiedStandardHeadspacePreInjectionFlushTimes, specifiedStandardHeadspacePostInjectionFlushTimes, specifiedStandardHeadspaceSyringeFlushings, specifiedBlankHeadspaceSamplingOptions, specifiedBlankHeadspaceSyringeTemperatures,
		specifiedBlankHeadspacePreInjectionFlushTimes, specifiedBlankHeadspacePostInjectionFlushTimes, specifiedBlankHeadspaceSyringeFlushings, specifiedStandardSPMESamplingOptions, specifiedStandardSPMEConditions,
		specifiedStandardSPMEConditioningTemperatures, specifiedStandardSPMEPreConditioningTimes, specifiedStandardSPMEDerivatizingAgents, specifiedStandardSPMEDerivatizingAgentAdsorptionTimes,
		specifiedStandardSPMEDerivatizationPositions, specifiedStandardSPMEDerivatizationPositionOffsets, specifiedStandardSPMESampleExtractionTimes, specifiedStandardSPMESampleDesorptionTimes, specifiedStandardSPMEPostInjectionConditioningTimes,
		specifiedBlankSPMESamplingOptions, specifiedBlankSPMEConditions, specifiedBlankSPMEConditioningTemperatures, specifiedBlankSPMEPreConditioningTimes, specifiedBlankSPMEDerivatizingAgents, specifiedBlankSPMEDerivatizingAgentAdsorptionTimes,
		specifiedBlankSPMEDerivatizationPositions, specifiedBlankSPMEDerivatizationPositionOffsets, specifiedBlankSPMEPostInjectionConditioningTimes, specifiedInjectionVolumes, specifiedSampleAspirationDelays, specifiedSampleInjectionRates,
		specifiedLiquidSampleAspirationRates, specifiedAgitateWhileSamplings, aliquotOptions, resolvedStandards, injectionTableLookup, injectionTableSpecifiedQ, roundedStandardInletTemperatureProfile, standardInletTemperatureProfileTests,
		roundedBlankInletTemperatureProfile, blankInletTemperatureProfileTests, roundedStandardColumnPressureProfile, standardColumnPressureProfileTests, roundedBlankColumnPressureProfile, blankColumnPressureProfileTests,
		roundedStandardColumnFlowRateProfile, standardColumnFlowRateProfileTests, roundedBlankColumnFlowRateProfile, blankColumnFlowRateProfileTests, roundedStandardOvenTemperatureProfile, standardOvenTemperatureProfileTests,
		roundedBlankOvenTemperatureProfile, blankOvenTemperatureProfileTests, standardOptions, standardOptionSpecifiedBool, numberOfStandardsSpecified, standardExistsQ, maxStandardOptionLength, standardExpansionLength, expandedStandardsAssociation,
		expandedStandardInletTemperatureProfile, expandedStandardColumnPressureProfile, expandedStandardColumnFlowRateProfile, expandedStandardOvenTemperatureProfile, expandedStandards, blankOptions, blankOptionSpecifiedBool,
		numberOfBlanksSpecified, blankExistsQ, maxBlankOptionLength, blankExpansionLength, expandedBlanksAssociation, expandedBlankInletTemperatureProfile, expandedBlankColumnPressureProfile, expandedBlankColumnFlowRateProfile,
		expandedBlankOvenTemperatureProfile, expandedBlanks, defaultStandard, defaultBlank, resolvedStandardBlankOptions, invalidStandardBlankOptions, invalidStandardBlankTests, resolvedStandardFrequency, preResolvedStandard,
		resolvedBlankFrequency, preResolvedBlankWithPlaceholder, specifiedInjectionTable, injectionTableStandardInjectionVolumes, resolvedBlanks, injectionTableBlankInjectionVolumes, specifiedStandardInletModes, specifiedBlankInletModes,
		preResolvedStandardSamplingMethods, preResolvedBlankSamplingMethods, standardStates, standardMasses, standardVolumes, blankStates, blankMasses, blankVolumes, resolvedStandardSamplingMethods, resolvedBlankSamplingMethods,
		specifiedStandardInjectionVolumes, specifiedStandardSampleAspirationRates, specifiedStandardSampleAspirationDelays, specifiedStandardSampleInjectionRates, specifiedStandardLiquidSampleVolumes, specifiedStandardHeadspaceSampleVolumes,
		specifiedStandardLiquidSampleAspirationRates, specifiedStandardHeadspaceSampleAspirationRates, specifiedStandardLiquidSampleAspirationDelays, specifiedStandardHeadspaceSampleAspirationDelays, specifiedStandardLiquidSampleInjectionRates,
		specifiedStandardHeadspaceSampleInjectionRates, specifiedStandardAgitateWhileSamplings, specifiedStandardHeadspaceAgitateWhileSamplings, specifiedStandardSPMEAgitateWhileSamplings, specifiedStandardDiluteBooleans,
		resolvedDilutionSolvent, resolvedSecondaryDilutionSolvent, resolvedTertiaryDilutionSolvent, dilutionSolventSpecifiedQ, secondaryDilutionSolventSpecifiedQ, tertiaryDilutionSolventSpecifiedQ, resolvedDilutionSolventVolumes,
		resolvedSecondaryDilutionSolventVolumes, resolvedTertiaryDilutionSolventVolumes, targetStandardVials, resolvedStandardDilutionSolventVolumes, resolvedStandardSecondaryDilutionSolventVolumes, resolvedStandardTertiaryDilutionSolventVolumes,
		requiredStandardAliquotAmounts, specifiedStandardSplitRatios, specifiedStandardSplitVentFlowRates, specifiedStandardSplitlessTimes, specifiedStandardInitialInletPressures,
		specifiedStandardInitialInletTimes, specifiedStandardSolventEliminationFlowRates, specifiedBlankSplitRatios,
		specifiedBlankSplitVentFlowRates, specifiedBlankSplitlessTimes, specifiedBlankInitialInletPressures, specifiedBlankInitialInletTimes, specifiedBlankSolventEliminationFlowRates,
		specifiedStandardOvenEquilibrationTimes, specifiedBlankOvenEquilibrationTimes, specifiedStandardOvenTemperatureProfiles,
		specifiedBlankOvenTemperatureProfiles, specifiedStandardPostRunOvenTemperatures, specifiedStandardInitialOvenTemperatures, specifiedBlankPostRunOvenTemperatures, specifiedBlankInitialOvenTemperatures, resolvedOvenTemperatureProfileSetpoints,
		resolvedStandardOvenEquilibrationTimes, resolvedStandardOvenTemperatureProfiles, resolvedStandardOvenTemperatureProfileSetpoints, resolvedStandardPostRunOvenTemperatures, resolvedBlankOvenEquilibrationTimes,
		resolvedBlankOvenTemperatureProfiles, resolvedBlankOvenTemperatureProfileSetpoints, resolvedBlankPostRunOvenTemperatures, specifiedStandardAgitateBooleans, specifiedStandardAgitationTemperatures, specifiedStandardAgitationMixRates,
		specifiedStandardAgitationTimes, specifiedStandardAgitationOnTimes, specifiedStandardAgitationOffTimes, resolvedStandardAgitates, resolvedStandardAgitationTemperatures, resolvedStandardAgitationTimes, resolvedStandardAgitationMixRates,
		resolvedStandardAgitationOnTimes, resolvedStandardAgitationOffTimes, specifiedStandardVortexBooleans, specifiedStandardVortexMixRates, specifiedStandardVortexTimes, resolvedStandardVortexs, resolvedStandardVortexMixRates,
		resolvedStandardVortexTimes, masterSwitchedStandardLiquidSamplingOptions, masterSwitchedStandardHeadspaceSamplingOptions, masterSwitchedStandardSPMESamplingOptions, masterSwitchedBlankLiquidSamplingOptions,
		masterSwitchedBlankHeadspaceSamplingOptions, masterSwitchedBlankSPMESamplingOptions, masterSwitchedLiquidPreInjectionSyringeWashes, masterSwitchedLiquidPostInjectionSyringeWashes, masterSwitchedPostInjectionNextSamplePreparationSteps,
		masterSwitchedLiquidSampleAspirationRates, masterSwitchedStandardLiquidPreInjectionSyringeWashes, masterSwitchedStandardLiquidPreInjectionSyringeWashVolumes, masterSwitchedStandardLiquidPreInjectionSyringeWashRates,
		masterSwitchedStandardLiquidPreInjectionNumberOfSolventWashes, masterSwitchedStandardLiquidPreInjectionNumberOfTertiarySolventWashes,
		masterSwitchedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes, masterSwitchedStandardNumberOfLiquidSampleWashes, masterSwitchedStandardLiquidSampleWashVolumes, masterSwitchedStandardLiquidSampleFillingStrokes,
		masterSwitchedStandardLiquidSampleFillingStrokesVolumes, masterSwitchedStandardLiquidFillingStrokeDelays, masterSwitchedStandardLiquidSampleOverAspirationVolumes, masterSwitchedStandardLiquidPostInjectionSyringeWashes,
		masterSwitchedStandardLiquidPostInjectionSyringeWashVolumes, masterSwitchedStandardLiquidPostInjectionSyringeWashRates, masterSwitchedStandardLiquidPostInjectionNumberOfSolventWashes,
		masterSwitchedStandardLiquidPostInjectionNumberOfSecondarySolventWashes, masterSwitchedStandardLiquidPostInjectionNumberOfTertiarySolventWashes, masterSwitchedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
		masterSwitchedStandardPostInjectionNextSamplePreparationSteps, masterSwitchedStandardLiquidSampleVolumes, masterSwitchedStandardLiquidSampleAspirationRates, masterSwitchedStandardLiquidSampleAspirationDelays,
		masterSwitchedStandardLiquidSampleInjectionRates, masterSwitchedBlankLiquidPreInjectionSyringeWashes, masterSwitchedBlankLiquidPreInjectionSyringeWashVolumes, masterSwitchedBlankLiquidPreInjectionSyringeWashRates,
		masterSwitchedBlankLiquidPreInjectionNumberOfSolventWashes, masterSwitchedBlankLiquidPreInjectionNumberOfSecondarySolventWashes, masterSwitchedBlankLiquidPreInjectionNumberOfTertiarySolventWashes,
		masterSwitchedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes, masterSwitchedBlankLiquidPostInjectionSyringeWashes, masterSwitchedBlankLiquidPostInjectionSyringeWashVolumes, masterSwitchedBlankLiquidPostInjectionSyringeWashRates,
		masterSwitchedBlankLiquidPostInjectionNumberOfSolventWashes, masterSwitchedBlankLiquidPostInjectionNumberOfSecondarySolventWashes, masterSwitchedBlankLiquidPostInjectionNumberOfTertiarySolventWashes,
		masterSwitchedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes, masterSwitchedBlankPostInjectionNextSamplePreparationSteps, masterSwitchedStandardHeadspaceSyringeTemperatures, masterSwitchedStandardHeadspacePreInjectionFlushTimes,
		masterSwitchedStandardHeadspacePostInjectionFlushTimes, masterSwitchedStandardHeadspaceSyringeFlushings, masterSwitchedStandardHeadspaceSampleVolumes, masterSwitchedStandardHeadspaceSampleAspirationRates,
		masterSwitchedStandardHeadspaceSampleAspirationDelays, masterSwitchedStandardHeadspaceSampleInjectionRates, masterSwitchedStandardHeadspaceAgitateWhileSamplings, masterSwitchedBlankHeadspaceSyringeTemperatures,
		masterSwitchedBlankHeadspacePreInjectionFlushTimes, masterSwitchedBlankHeadspacePostInjectionFlushTimes, masterSwitchedBlankHeadspaceSyringeFlushings, masterSwitchedStandardSPMEConditions,
		masterSwitchedStandardSPMEConditioningTemperatures, masterSwitchedStandardSPMEPreConditioningTimes, masterSwitchedStandardSPMEDerivatizingAgents, masterSwitchedStandardSPMEDerivatizingAgentAdsorptionTimes,
		masterSwitchedStandardSPMEDerivatizationPositions, masterSwitchedStandardSPMEDerivatizationPositionOffsets, masterSwitchedStandardSPMESampleExtractionTimes, masterSwitchedStandardSPMESampleDesorptionTimes,
		masterSwitchedStandardSPMEPostInjectionConditioningTimes, masterSwitchedStandardSPMEAgitateWhileSamplings, masterSwitchedBlankSPMEConditions, masterSwitchedBlankSPMEConditioningTemperatures, masterSwitchedBlankSPMEPreConditioningTimes,
		masterSwitchedBlankSPMEDerivatizingAgents, masterSwitchedBlankSPMEDerivatizingAgentAdsorptionTimes, masterSwitchedBlankSPMEDerivatizationPositions, masterSwitchedBlankSPMEDerivatizationPositionOffsets,
		masterSwitchedBlankSPMEPostInjectionConditioningTimes, resolvedStandardLiquidSampleVolumes, resolvedLiquidPreInjectionSyringeWashes, resolvedStandardLiquidPreInjectionSyringeWashes, resolvedStandardLiquidPreInjectionSyringeWashVolumes,
		resolvedStandardLiquidPreInjectionSyringeWashRates, resolvedStandardLiquidPreInjectionNumberOfSolventWashes, resolvedStandardLiquidPreInjectionNumberOfSecondarySolventWashes, resolvedStandardLiquidPreInjectionNumberOfTertiarySolventWashes,
		resolvedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes, resolvedBlankLiquidPreInjectionSyringeWashes, resolvedBlankLiquidPreInjectionSyringeWashVolumes, resolvedBlankLiquidPreInjectionSyringeWashRates,
		resolvedBlankLiquidPreInjectionNumberOfSolventWashes, resolvedBlankLiquidPreInjectionNumberOfSecondarySolventWashes, resolvedBlankLiquidPreInjectionNumberOfTertiarySolventWashes, resolvedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes,
		resolvedStandardNumberOfLiquidSampleWashes, resolvedStandardLiquidSampleWashVolumes, resolvedStandardLiquidSampleFillingStrokes, resolvedStandardLiquidSampleFillingStrokesVolumes, resolvedStandardLiquidFillingStrokeDelays,
		resolvedLiquidSampleAspirationRates, resolvedStandardLiquidSampleAspirationRates, resolvedStandardLiquidSampleAspirationDelays, resolvedStandardLiquidSampleInjectionRates, resolvedStandardLiquidSampleOverAspirationVolumes,
		resolvedLiquidPostInjectionSyringeWashes, resolvedStandardLiquidPostInjectionSyringeWashes, resolvedStandardLiquidPostInjectionSyringeWashVolumes, resolvedStandardLiquidPostInjectionSyringeWashRates,
		resolvedStandardLiquidPostInjectionNumberOfSolventWashes, resolvedStandardLiquidPostInjectionNumberOfSecondarySolventWashes, resolvedStandardLiquidPostInjectionNumberOfTertiarySolventWashes,
		resolvedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes, resolvedBlankLiquidPostInjectionSyringeWashes, resolvedBlankLiquidPostInjectionSyringeWashVolumes, resolvedBlankLiquidPostInjectionSyringeWashRates,
		resolvedBlankLiquidPostInjectionNumberOfSolventWashes, resolvedBlankLiquidPostInjectionNumberOfSecondarySolventWashes, resolvedBlankLiquidPostInjectionNumberOfTertiarySolventWashes,
		resolvedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes, specifiedSyringeWashSolvent, specifiedSecondarySyringeWashSolvent, specifiedTertiarySyringeWashSolvent, specifiedQuaternarySyringeWashSolvent,
		resolvedSyringeWashSolvent, resolvedSecondarySyringeWashSolvent, resolvedTertiarySyringeWashSolvent, resolvedQuaternarySyringeWashSolvent, resolvedPostInjectionNextSamplePreparationSteps,
		resolvedStandardPostInjectionNextSamplePreparationSteps, resolvedBlankPostInjectionNextSamplePreparationSteps, resolvedStandardHeadspaceSyringeTemperatures, resolvedStandardHeadspacePreInjectionFlushTimes,
		resolvedStandardHeadspaceSampleVolumes, resolvedStandardHeadspaceSampleAspirationRates, resolvedStandardHeadspaceSampleAspirationDelays, resolvedStandardHeadspaceSampleInjectionRates, resolvedStandardHeadspaceAgitateWhileSamplings,
		resolvedStandardHeadspacePostInjectionFlushTimes, resolvedStandardHeadspaceSyringeFlushings, resolvedBlankHeadspaceSyringeTemperatures, resolvedBlankHeadspacePreInjectionFlushTimes, resolvedBlankHeadspaceSampleVolumes,
		resolvedBlankHeadspaceSampleAspirationRates, resolvedBlankHeadspaceSampleAspirationDelays, resolvedBlankHeadspaceSampleInjectionRates, resolvedBlankHeadspaceAgitateWhileSamplings,
		resolvedBlankHeadspacePostInjectionFlushTimes, resolvedBlankHeadspaceSyringeFlushings, resolvedInjectionVolumes, resolvedSampleAspirationDelays, resolvedSampleInjectionRates, resolvedStandardInjectionVolumes,
		resolvedStandardSampleAspirationRates, resolvedStandardSampleAspirationDelays, resolvedStandardSampleInjectionRates, resolvedStandardSPMEConditions, resolvedStandardSPMEConditioningTemperatures,
		resolvedStandardSPMEPreConditioningTimes, resolvedStandardSPMEDerivatizingAgentAdsorptionTimes, resolvedStandardSPMEDerivatizationPositions, resolvedStandardSPMEDerivatizationPositionOffsets, resolvedStandardSPMESampleExtractionTimes,
		resolvedStandardSPMEAgitateWhileSamplings, resolvedStandardSPMESampleDesorptionTimes, resolvedStandardSPMEPostInjectionConditioningTimes, resolvedBlankSPMEConditions, resolvedBlankSPMEConditioningTemperatures,
		resolvedBlankSPMEPreConditioningTimes, resolvedBlankSPMEDerivatizingAgentAdsorptionTimes, resolvedBlankSPMEDerivatizationPositions, resolvedBlankSPMEDerivatizationPositionOffsets, resolvedBlankSPMESampleExtractionTimes,
		resolvedBlankSPMEAgitateWhileSamplings, resolvedBlankSPMESampleDesorptionTimes, resolvedBlankSPMEPostInjectionConditioningTimes, resolvedAgitateWhileSamplings, resolvedStandardAgitateWhileSamplings,
		specifiedStandardSampleVialAspirationPositionOffsets, specifiedStandardInitialInletTemperatures, specifiedStandardInitialInletTemperatureDurations, specifiedStandardInletTemperatureProfiles,
		specifiedBlankInitialInletTemperatures, specifiedBlankInitialInletTemperatureDurations, specifiedBlankInletTemperatureProfiles, resolvedStandardInletTemperatureProfiles, resolvedStandardInitialInletTemperatures, resolvedStandardInitialInletTemperatureDurations, resolvedBlankInletTemperatureProfiles,
		resolvedBlankInitialInletTemperatures, resolvedBlankInitialInletTemperatureDurations, resolvedInletTemperatureProfileSetpoints, resolvedStandardSplitRatios, resolvedStandardSolventEliminationFlowRates,
		resolvedStandardInitialInletPressures, resolvedStandardInitialInletTimes, resolvedBlankSplitRatios, resolvedBlankSolventEliminationFlowRates, resolvedBlankInitialInletPressures, resolvedBlankInitialInletTimes,
		specifiedStandardGasSavers, specifiedStandardGasSaverFlowRates, specifiedStandardGasSaverActivationTimes, specifiedBlankGasSavers, specifiedBlankGasSaverFlowRates, specifiedBlankGasSaverActivationTimes, resolvedStandardGasSavers,
		resolvedStandardGasSaverFlowRates, resolvedBlankGasSavers, resolvedBlankGasSaverFlowRates, specifiedStandardInitialColumnFlowRates, specifiedStandardInitialColumnPressures, specifiedStandardInitialColumnAverageVelocities,
		specifiedStandardInitialColumnResidenceTimes, specifiedStandardInitialColumnSetpointDurations, specifiedBlankInitialColumnFlowRates, specifiedBlankInitialColumnPressures, specifiedBlankInitialColumnAverageVelocities,
		specifiedBlankInitialColumnResidenceTimes, specifiedBlankInitialColumnSetpointDurations, specifiedStandardColumnPressureProfiles, specifiedStandardColumnFlowRateProfiles, specifiedBlankColumnPressureProfiles,
		specifiedBlankColumnFlowRateProfiles, resolvedStandardInitialColumnAverageVelocities, resolvedStandardInitialColumnFlowRates, resolvedStandardInitialColumnPressures, resolvedStandardInitialColumnResidenceTimes,
		resolvedStandardInitialColumnSetpointDurations, resolvedStandardColumnPressureProfiles, resolvedStandardColumnFlowRateProfiles, resolvedBlankInitialColumnAverageVelocities, resolvedBlankInitialColumnFlowRates, resolvedBlankInitialColumnPressures,
		resolvedBlankInitialColumnResidenceTimes, resolvedBlankInitialColumnSetpointDurations, resolvedBlankColumnPressureProfiles, resolvedBlankColumnFlowRateProfiles, resolvedStandardInitialColumnFlowRateValues,
		resolvedStandardSplitlessTimes, resolvedStandardGasSaverActivationTimes, resolvedBlankInitialColumnFlowRateValues,
		resolvedBlankSplitlessTimes, resolvedBlankGasSaverActivationTimes, maxOvenTemperatureSetpoint, specifiedLinerORing, specifiedInletSeptum, maxInletTemperatureSetpoint,
		gasSaverConflictTuples, gasSaverConflictOptions, gasSaverConflictTests, resolvedLinerORing, resolvedInletSeptum, resolvedColumnConditioningTemperature, specifiedInletSeptumPurgeFlowRates, specifiedInitialOvenTemperatureDurations, specifiedPostRunOvenTimes, specifiedPostRunFlowRates, specifiedPostRunPressures,
		specifiedStandardInletSeptumPurgeFlowRates, specifiedStandardInitialOvenTemperatureDurations, specifiedStandardPostRunOvenTimes, specifiedStandardPostRunFlowRates, specifiedStandardPostRunPressures, specifiedBlankInletSeptumPurgeFlowRates, specifiedBlankInitialOvenTemperatureDurations,
		specifiedBlankPostRunOvenTimes, specifiedBlankPostRunFlowRates, specifiedBlankPostRunPressures, specifiedSeparationMethods, specifiedStandardSeparationMethods, specifiedBlankSeparationMethods, resolvedSeparationMethods, resolvedStandardSeparationMethods, resolvedBlankSeparationMethods, intermediateInjectionTable, injectionTableBlanks,
		injectionTableStandards, injectionTableStandardSeparationMethods, injectionTableBlankSeparationMethods, overwriteSeparationMethodsBool, overwrittenSeparationMethodOptions, overwriteStandardSeparationMethodsBool,overwrittenBlankSeparationMethodOptions, overwrittenStandardSeparationMethodOptions, overwriteBlankSeparationMethodsBool, overwriteOptionBool, adjustedOverwriteStandardBool,
		adjustedOverwriteBlankBool, resolvedOptionsForInjectionTable, resolvedInjectionTableResult, invalidInjectionTableOptions, invalidInjectionTableTests, preResolvedInjectionTable, resolvedInjectionTable, resolvedInjectionTableBlanks,
		resolvedInjectionTableBlankInjectionVolumes, resolvedInjectionTableBlankSeparationMethods, foreignBlanksQ, foreignBlankOptions, foreignBlankTest, resolvedInjectionTableStandards, resolvedInjectionTableStandardInjectionVolumes,
		resolvedInjectionTableStandardSeparationMethods, foreignStandardsQ, foreignStandardOptions, foreignStandardTest, drawVolumesTooLargeQ, standardDrawVolumesTooLargeQ, incompatibleSampleAndAirVolumes, incompatibleStandardSampleAndAirVolumes,
		allStandardInitialColumnFlowrates, allStandardInitialColumnPressures, allStandardInitialColumnAverageVelocities, allStandardInitialColumnResidenceTimes, allBlankInitialColumnFlowrates, allBlankInitialColumnPressures,
		allBlankInitialColumnAverageVelocities, allBlankInitialColumnResidenceTimes, specifiedInitialColumnConditions, specifiedStandardInitialColumnConditions, specifiedBlankInitialColumnConditions, cospecifiedSampleOptions,
		cospecifiedSampleOptionsTests, cospecifiedStandardOptions, cospecifiedStandardOptionsTests, cospecifiedBlankOptions, cospecifiedBlankOptionsTests, magneticCapCompatibleGCVialModels, aliquotQ, resolvedTargetVials, resolvedAliquotAmounts,
		specifiedStandardDilutionSolventVolumes, specifiedStandardSecondaryDilutionSolventVolumes, specifiedStandardTertiaryDilutionSolventVolumes, resolvedStandardDilutes, masterSwitchedStandardLiquidPreInjectionNumberOfSecondarySolventWashes,
		outOfRangeLiquidSampleVolumes, outOfRangeStandardLiquidSampleVolumes, outOfRangeLiquidSampleVolumeTests, outOfRangeStandardLiquidSampleVolumeTests, simulatedContainers,
		outOfRangeHeadspaceSampleVolumes, outOfRangeStandardHeadspaceSampleVolumes, outOfRangeHeadspaceSampleVolumeTests, outOfRangeStandardHeadspaceSampleVolumeTests, specifiedInitialInletTemperatureSetpoints, specifiedStandardAmounts,
		specifiedStandardVials, resolvedStandardAmounts, resolvedStandardVials, specifiedColumnConditioningTemperature, specifiedColumnConditioningTime, separationMethodSpecifiedQ,
		specifiedSeparationMethodParameters, standardSeparationMethodSpecifiedQ, specifiedStandardSeparationMethodParameters, blankSeparationMethodSpecifiedQ, specifiedBlankSeparationMethodParameters,
		separationMethodColumnLengths, separationMethodColumnDiameters, separationMethodColumnFilmThicknesses, separationMethodInletLinerVolumes, separationMethodDetectors, separationMethodCarrierGases,
		separationMethodInletSeptumPurgeFlowRates, separationMethodInitialInletTemperatures, separationMethodInitialInletTemperatureDurations,
		separationMethodInletTemperatureProfiles, separationMethodSplitRatios, separationMethodSplitVentFlowRates, magneticCapRequiredQ, standardMagneticCapRequiredQ, blankMagneticCapRequiredQ,
		separationMethodSplitlessTimes, separationMethodInitialInletPressures, separationMethodInitialInletTimes, separationMethodGasSavers, separationMethodGasSaverFlowRates,
		separationMethodGasSaverActivationTimes, separationMethodSolventEliminationFlowRates,
		separationMethodInitialColumnFlowRates, separationMethodInitialColumnPressures, separationMethodInitialColumnAverageVelocities,
		separationMethodInitialColumnResidenceTimes, separationMethodInitialColumnSetpointDurations, separationMethodColumnPressureProfiles, separationMethodColumnFlowRateProfiles,
		separationMethodOvenEquilibrationTimes, separationMethodInitialOvenTemperatures, separationMethodInitialOvenTemperatureDurations, separationMethodOvenTemperatureProfiles,
		separationMethodPostRunOvenTemperatures, separationMethodPostRunOvenTimes, separationMethodPostRunFlowRates, separationMethodPostRunPressures, separationMethodStandardColumnLengths, separationMethodStandardColumnDiameters,
		separationMethodStandardColumnFilmThicknesses, separationMethodStandardInletLinerVolumes, separationMethodStandardDetectors, separationMethodStandardCarrierGases,
		separationMethodStandardInletSeptumPurgeFlowRates, separationMethodStandardInitialInletTemperatures,
		separationMethodStandardInitialInletTemperatureDurations, separationMethodStandardInletTemperatureProfiles, separationMethodStandardSplitRatios,
		separationMethodStandardSplitVentFlowRates, separationMethodStandardSplitlessTimes, separationMethodStandardInitialInletPressures,
		separationMethodStandardInitialInletTimes, separationMethodStandardGasSavers, separationMethodStandardGasSaverFlowRates, separationMethodStandardGasSaverActivationTimes,
		separationMethodStandardSolventEliminationFlowRates,
		separationMethodStandardInitialColumnFlowRates, separationMethodStandardInitialColumnPressures, separationMethodStandardInitialColumnAverageVelocities,
		separationMethodStandardInitialColumnResidenceTimes, separationMethodStandardInitialColumnSetpointDurations, separationMethodStandardColumnPressureProfiles,
		separationMethodStandardColumnFlowRateProfiles, separationMethodStandardOvenEquilibrationTimes, separationMethodStandardInitialOvenTemperatures,
		separationMethodStandardInitialOvenTemperatureDurations, separationMethodStandardOvenTemperatureProfiles, separationMethodStandardPostRunOvenTemperatures,
		separationMethodStandardPostRunOvenTimes, separationMethodStandardPostRunFlowRates, separationMethodStandardPostRunPressures, separationMethodBlankColumnLengths, separationMethodBlankColumnDiameters, separationMethodBlankColumnFilmThicknesses,
		separationMethodBlankInletLinerVolumes, separationMethodBlankDetectors, separationMethodBlankCarrierGases, separationMethodBlankInletSeptumPurgeFlowRates,
		separationMethodBlankInitialInletTemperatures, separationMethodBlankInitialInletTemperatureDurations,
		separationMethodBlankInletTemperatureProfiles, separationMethodBlankSplitRatios, separationMethodBlankSplitVentFlowRates,
		separationMethodBlankSplitlessTimes, separationMethodBlankInitialInletPressures, separationMethodBlankInitialInletTimes,
		separationMethodBlankGasSavers, separationMethodBlankGasSaverFlowRates, separationMethodBlankGasSaverActivationTimes, separationMethodBlankSolventEliminationFlowRates,
		separationMethodBlankInitialColumnFlowRates, noCapForContainerInvalidOptions, noStandardVialCapInvalidOption, invalidBlankVialCapInvalidOption,
		separationMethodBlankInitialColumnPressures, separationMethodBlankInitialColumnAverageVelocities, separationMethodBlankInitialColumnResidenceTimes,
		separationMethodBlankInitialColumnSetpointDurations, separationMethodBlankColumnPressureProfiles, separationMethodBlankColumnFlowRateProfiles, separationMethodBlankOvenEquilibrationTimes,
		separationMethodBlankInitialOvenTemperatures, separationMethodBlankInitialOvenTemperatureDurations, separationMethodBlankOvenTemperatureProfiles, separationMethodBlankPostRunOvenTemperatures,
		separationMethodBlankPostRunOvenTimes, separationMethodBlankPostRunFlowRates, separationMethodBlankPostRunPressures, prespecifiedInletSeptumPurgeFlowRates, prespecifiedStandardInletSeptumPurgeFlowRates, prespecifiedBlankInletSeptumPurgeFlowRates,
		prespecifiedInitialOvenTemperatureDurations, prespecifiedStandardInitialOvenTemperatureDurations, prespecifiedBlankInitialOvenTemperatureDurations, prespecifiedPostRunOvenTimes, prespecifiedPostRunFlowRates, prespecifiedPostRunPressures,
		prespecifiedStandardPostRunOvenTimes, prespecifiedStandardPostRunFlowRates, prespecifiedStandardPostRunPressures, prespecifiedBlankPostRunOvenTimes, prespecifiedBlankPostRunFlowRates, prespecifiedBlankPostRunPressures, prespecifiedSplitVentFlowRates, prespecifiedStandardSplitVentFlowRates, prespecifiedBlankSplitVentFlowRates,
		prespecifiedInitialOvenTemperatures, prespecifiedStandardInitialOvenTemperatures, prespecifiedBlankInitialOvenTemperatures, prespecifiedInitialInletTemperatures,
		prespecifiedInitialInletTemperatureDurations, capForVialTests, capForStandardVialTests, capForBlankVialTests,
		prespecifiedStandardInitialInletTemperatures, prespecifiedStandardInitialInletTemperatureDurations, prespecifiedBlankInitialInletTemperatures,
		prespecifiedBlankInitialInletTemperatureDurations, prespecifiedInletTemperatureProfiles, prespecifiedStandardInletTemperatureProfiles, prespecifiedBlankInletTemperatureProfiles, prespecifiedSplitRatios,
		prespecifiedSplitlessTimes, prespecifiedInitialInletPressures, prespecifiedInitialInletTimes, prespecifiedSolventEliminationFlowRates,
		prespecifiedStandardSplitRatios, prespecifiedStandardSplitlessTimes, prespecifiedStandardInitialInletPressures,
		prespecifiedStandardInitialInletTimes, prespecifiedStandardSolventEliminationFlowRates, prespecifiedBlankSplitRatios,
		prespecifiedBlankSplitlessTimes, prespecifiedBlankInitialInletPressures, prespecifiedBlankInitialInletTimes, prespecifiedBlankSolventEliminationFlowRates,
		prespecifiedGasSavers, prespecifiedGasSaverFlowRates, prespecifiedGasSaverActivationTimes, prespecifiedStandardGasSavers,
		prespecifiedStandardGasSaverFlowRates, prespecifiedStandardGasSaverActivationTimes, prespecifiedBlankGasSavers, prespecifiedBlankGasSaverFlowRates, prespecifiedBlankGasSaverActivationTimes, prespecifiedInitialColumnFlowRates,
		prespecifiedInitialColumnPressures, prespecifiedInitialColumnAverageVelocities, prespecifiedInitialColumnResidenceTimes, prespecifiedInitialColumnSetpointDurations, prespecifiedStandardInitialColumnFlowRates,
		prespecifiedStandardInitialColumnPressures, prespecifiedStandardInitialColumnAverageVelocities, prespecifiedStandardInitialColumnResidenceTimes, prespecifiedStandardInitialColumnSetpointDurations, prespecifiedBlankInitialColumnFlowRates,
		prespecifiedBlankInitialColumnPressures, prespecifiedBlankInitialColumnAverageVelocities, prespecifiedBlankInitialColumnResidenceTimes, prespecifiedBlankInitialColumnSetpointDurations, prespecifiedColumnPressureProfiles,
		prespecifiedColumnFlowRateProfiles, prespecifiedStandardColumnPressureProfiles, prespecifiedStandardColumnFlowRateProfiles, prespecifiedBlankColumnPressureProfiles, prespecifiedBlankColumnFlowRateProfiles,
		prespecifiedPostRunOvenTemperatures, prespecifiedStandardPostRunOvenTemperatures, prespecifiedBlankPostRunOvenTemperatures, prespecifiedOvenEquilibrationTimes, prespecifiedStandardOvenEquilibrationTimes,
		prespecifiedBlankOvenEquilibrationTimes, prespecifiedOvenTemperatureProfiles, prespecifiedStandardOvenTemperatureProfiles, prespecifiedBlankOvenTemperatureProfiles, prespecifiedSeparationModeOptions,
		prespecifiedStandardSeparationModeOptions, prespecifiedBlankSeparationModeOptions, separationMethodSeparationModeOptions, separationMethodStandardSeparationModeOptions, separationMethodBlankSeparationModeOptions,
		specifiedSeparationModeParameters, specifiedTemperatureProfileSetpoints, specifiedStandardTemperatureProfileSetpoints, specifiedBlankTemperatureProfileSetpoints, specifiedStandardSeparationModeParameters,
		specifiedBlankSeparationModeParameters, ovenTemperaturesTooHotQ, ovenTemperaturesTooColdQ, postRunOvenTemperaturesTooHotQ, postRunOvenTemperaturesTooColdQ, initialOvenTemperaturesTooHotQ,
		initialOvenTemperaturesTooColdQ, standardOvenTemperaturesTooHotQ, standardOvenTemperaturesTooColdQ, standardPostRunOvenTemperaturesTooHotQ, standardPostRunOvenTemperaturesTooColdQ,
		standardInitialOvenTemperaturesTooHotQ, standardInitialOvenTemperaturesTooColdQ, blankOvenTemperaturesTooHotQ, blankOvenTemperaturesTooColdQ, blankPostRunOvenTemperaturesTooHotQ,
		blankPostRunOvenTemperaturesTooColdQ, blankInitialOvenTemperaturesTooHotQ, blankInitialOvenTemperaturesTooColdQ, tooHotTemperatureProfileSetpoints, tooHotPostRunOvenTemperatures,
		tooHotInitialOvenTemperatures, tooHotStandardTemperatureProfileSetpoints, tooHotStandardPostRunOvenTemperatures, tooHotStandardInitialOvenTemperatures, tooHotBlankTemperatureProfileSetpoints,
		tooHotBlankPostRunOvenTemperatures, tooHotBlankInitialOvenTemperatures, tooColdOvenTemperatureProfileTests, tooColdPostRunOvenTemperatureTests, tooColdInitialOvenTemperatureTests,
		tooColdStandardOvenTemperatureProfileTests, tooColdStandardPostRunOvenTemperatureTests, tooColdStandardInitialOvenTemperatureTests, tooColdBlankOvenTemperatureProfileTests,
		tooColdBlankPostRunOvenTemperatureTests, tooColdBlankInitialOvenTemperatureTests, tooHotOvenTemperatureProfileTests, tooHotPostRunOvenTemperatureTests, tooHotInitialOvenTemperatureTests,
		tooHotStandardOvenTemperatureProfileTests, tooHotStandardPostRunOvenTemperatureTests, tooHotStandardInitialOvenTemperatureTests, tooHotBlankOvenTemperatureProfileTests,
		tooHotBlankPostRunOvenTemperatureTests, tooHotBlankInitialOvenTemperatureTests, tooColdTemperatureProfileSetpoints, tooColdPostRunOvenTemperatures, tooColdInitialOvenTemperatures,
		tooColdStandardTemperatureProfileSetpoints, tooColdStandardPostRunOvenTemperatures, tooColdStandardInitialOvenTemperatures, tooColdBlankTemperatureProfileSetpoints,
		tooColdBlankPostRunOvenTemperatures, tooColdBlankInitialOvenTemperatures, resolvedSeparationMethodAssociations, resolvedStandardSeparationMethodAssociations,
		resolvedBlankSeparationMethodAssociations, inletLinerPacket, inletLinerVolume, resolvedStandardSampleVialAspirationPositionOffsets, expandedStandardNull, expandedBlankNull, resolvedSPMEDerivatizingAgents,
		resolvedStandardSPMEDerivatizingAgents, resolvedBlankSPMEDerivatizingAgents, resolvedSplitVentFlowRates, resolvedStandardSplitVentFlowRates, resolvedBlankSplitVentFlowRates, preresolvedInitialInletPressures,
		preresolvedInitialInletTimes, preresolvedStandardInitialInletPressures, preresolvedStandardInitialInletTimes, preresolvedBlankInitialInletPressures, preresolvedBlankInitialInletTimes, resolvedInletTemperatureModes,
		resolvedStandardInletTemperatureModes, resolvedBlankInletTemperatureModes, resolvedSeparationMethodsWithObjects, resolvedStandardSeparationMethodsWithObjects,
		resolvedBlankSeparationMethodsWithObjects, specifiedTrimColumn, specifiedTrimColumnLength, resolvedTrimColumnLength, resolvedTrimColumn, resolvedTransferLineTemperature,
		resolvedIonSource, resolvedSourceTemperature, resolvedQuadrupoleTemperature, resolvedSolventDelay, resolvedMassDetectionGain, resolvedMassRangeThreshold, resolvedTraceIonDetection, massRangeSpecifiedQ, numberOfMassRanges,
		simOptionsSpecifiedQ, numberOfSIMGroups, resolvedMassRange, resolvedAcquisitionWindowStartTime, resolvedMassRangeScanSpeed, resolvedMassSelection,
		resolvedMassSelectionResolution, resolvedMassSelectionDetectionGain, fidOptions, msOptions, specifiedFIDOptions, specifiedMSOptions, resolvedFIDDataCollectionFrequency, specifiedFIDDataCollectionFrequency,
		resolvedBlankInjectionVolumes, samplePreparationOptionsInternal, resolvedSamplePreparationOptionsInternal, standardPreparationOptionsInternal,
		resolvedStandardPreparationOptionsInternal, blankPreparationOptionsInternal, resolvedBlankPreparationOptionsInternal, injectionTableColumnOptionValue,
		injectionTableStandardColumnOptionValue, injectionTableBlankColumnOptionValue, specifiedTransferLineTemperature, specifiedIonSource,
		specifiedIonMode, specifiedSourceTemperature, specifiedQuadrupoleTemperature, specifiedSolventDelay, specifiedMassDetectionGain, specifiedMassRangeThreshold, specifiedTraceIonDetection, specifiedAcquisitionWindowStartTime, specifiedMassRange,
		specifiedMassRangeScanSpeed, specifiedMassSelection, specifiedMassSelectionResolution, specifiedMassSelectionDetectionGain, resolvedIonMode, specifiedInlet, multimodeInletOptionsSpecifiedQ,
		incompatibleInletOptions, inletOptionsCompatibleTests, cospecifiedOptionsTests, conflictingBlankLiquidSamplingOptionsQ, conflictingBlankHeadspaceSamplingOptionsQ, conflictingBlankSPMESamplingOptionsQ,
		sampleLiquidOps, sampleHeadspaceOps, sampleSPMEOps, standardLiquidOps, standardHeadspaceOps, standardSPMEOps, blankLiquidOps, blankHeadspaceOps, blankSPMEOps, conflictingLiquidSamplingOptions,
		conflictingHeadspaceSamplingOptions, conflictingSPMESamplingOptions, conflictingStandardLiquidSamplingOptions, conflictingStandardHeadspaceSamplingOptions, conflictingStandardSPMESamplingOptions,
		conflictingBlankLiquidSamplingOptions, conflictingBlankHeadspaceSamplingOptions, conflictingBlankSPMESamplingOptions, conflictingSamplingMethodTests, conflictingLiquidSamplingOptionsQ,
		conflictingHeadspaceSamplingOptionsQ, conflictingSPMESamplingOptionsQ, conflictingStandardLiquidSamplingOptionsQ, conflictingStandardHeadspaceSamplingOptionsQ, conflictingStandardSPMESamplingOptionsQ,
		agitationConflictTests, specifiedFakeInjectionTable, blankPrepOptions, resolvedStandardAliquotAmounts, resolvedStandardTargetVials, resolvedBlankAliquotAmounts, resolvedBlankTargetVials,
		specifiedBlankAmounts, specifiedBlankVials, resolvedBlankVials, resolvedBlankAmounts, resolvedBlankLiquidSampleAspirationRates, resolvedBlankLiquidSampleAspirationDelays,
		resolvedBlankLiquidSampleInjectionRates, resolvedBlankLiquidSampleOverAspirationVolumes, outOfRangeBlankHeadspaceSampleVolumes, outOfRangeBlankHeadspaceSampleVolumeTests,
		resolvedBlankSampleAspirationRates, resolvedBlankSampleAspirationDelays, resolvedBlankSampleInjectionRates, specifiedBlankSampleVialAspirationPositionOffsets,
		specifiedBlankInjectionVolumes, specifiedBlankSampleAspirationRates, specifiedBlankSampleAspirationDelays, specifiedBlankSampleInjectionRates, specifiedBlankLiquidSampleVolumes,
		specifiedBlankHeadspaceSampleVolumes, specifiedBlankLiquidSampleAspirationRates, specifiedBlankHeadspaceSampleAspirationRates, specifiedBlankLiquidSampleAspirationDelays,
		specifiedBlankHeadspaceSampleAspirationDelays, specifiedBlankLiquidSampleInjectionRates, specifiedBlankHeadspaceSampleInjectionRates, specifiedBlankHeadspaceAgitateWhileSamplings,
		specifiedBlankSPMEAgitateWhileSamplings, targetBlankVials, resolvedBlankDilutionSolventVolumes, resolvedBlankSecondaryDilutionSolventVolumes, resolvedBlankTertiaryDilutionSolventVolumes,
		requiredBlankAliquotAmounts, resolvedBlankAgitates, resolvedBlankAgitationTemperatures, resolvedBlankAgitationTimes, resolvedBlankAgitationMixRates, resolvedBlankAgitationOnTimes,
		resolvedBlankAgitationOffTimes, resolvedBlankVortexs, resolvedBlankVortexMixRates, resolvedBlankVortexTimes, masterSwitchedBlankNumberOfLiquidSampleWashes,
		masterSwitchedBlankLiquidSampleWashVolumes, masterSwitchedBlankLiquidSampleFillingStrokes, masterSwitchedBlankLiquidSampleFillingStrokesVolumes,
		masterSwitchedBlankLiquidFillingStrokeDelays, masterSwitchedBlankLiquidSampleOverAspirationVolumes, masterSwitchedBlankLiquidSampleVolumes, masterSwitchedBlankLiquidSampleAspirationRates,
		masterSwitchedBlankLiquidSampleAspirationDelays, masterSwitchedBlankLiquidSampleInjectionRates, masterSwitchedBlankHeadspaceSampleVolumes, masterSwitchedBlankHeadspaceSampleAspirationRates,
		masterSwitchedBlankHeadspaceSampleAspirationDelays, masterSwitchedBlankHeadspaceSampleInjectionRates, masterSwitchedBlankHeadspaceAgitateWhileSamplings,
		masterSwitchedBlankSPMESampleExtractionTimes, masterSwitchedBlankSPMESampleDesorptionTimes, masterSwitchedBlankSPMEAgitateWhileSamplings, resolvedBlankNumberOfLiquidSampleWashes,
		resolvedBlankLiquidSampleWashVolumes, resolvedBlankLiquidSampleFillingStrokes, resolvedBlankLiquidSampleFillingStrokesVolumes, resolvedBlankLiquidFillingStrokeDelays,
		specifiedBlankDiluteBooleans, specifiedBlankDilutionSolventVolumes, specifiedBlankSecondaryDilutionSolventVolumes, specifiedBlankTertiaryDilutionSolventVolumes,
		specifiedBlankAgitateBooleans, specifiedBlankAgitationTimes, specifiedBlankAgitationTemperatures, specifiedBlankAgitationMixRates, specifiedBlankAgitationOnTimes,
		specifiedBlankAgitationOffTimes, specifiedBlankVortexBooleans, specifiedBlankVortexMixRates, specifiedBlankVortexTimes,
		aliquotStandardQ, aliquotBlankQ, specifiedBlankNumberOfLiquidSampleWashes, specifiedBlankLiquidSampleWashVolumes, specifiedBlankLiquidSampleFillingStrokes,
		specifiedBlankLiquidSampleFillingStrokesVolumes, specifiedBlankLiquidFillingStrokeDelays, specifiedBlankLiquidSampleOverAspirationVolumes, specifiedBlankSPMESampleExtractionTimes,
		specifiedBlankSPMESampleDesorptionTimes, specifiedBlankAgitateWhileSamplings, resolvedBlankDilutes, outOfRangeBlankLiquidSampleVolumes, resolvedBlankLiquidSampleVolumes,
		outOfRangeBlankLiquidSampleVolumeTests, maxLiquidSampleAspirationRate, maxLiquidFillingStrokesRate, maxLiquidInjectionRate, sampleAspirationRatesOutOfBoundsQ,
		standardAspirationRatesOutOfBoundsQ, blankAspirationRatesOutOfBoundsQ, sampleInjectionRatesOutOfBoundsQ, standardInjectionRatesOutOfBoundsQ, blankInjectionRatesOutOfBoundsQ, sampleAspirationRatesOutOfBoundsTest,
		standardAspirationRatesOutOfBoundsTest, blankAspirationRatesOutOfBoundsTest, sampleInjectionRatesOutOfBoundsTest, standardInjectionRatesOutOfBoundsTest, blankInjectionRatesOutOfBoundsTest,
		headspaceSampleAspirationRatesOutOfBoundsQ, headspaceStandardAspirationRatesOutOfBoundsQ, headspaceBlankAspirationRatesOutOfBoundsQ, headspaceSampleInjectionRatesOutOfBoundsQ,
		headspaceStandardInjectionRatesOutOfBoundsQ, headspaceBlankInjectionRatesOutOfBoundsQ, headspaceSampleAspirationRatesOutOfBoundsTest, headspaceStandardAspirationRatesOutOfBoundsTest,
		headspaceBlankAspirationRatesOutOfBoundsTest, headspaceSampleInjectionRatesOutOfBoundsTest, headspaceStandardInjectionRatesOutOfBoundsTest, headspaceBlankInjectionRatesOutOfBoundsTest,
		specifiedBlankWithAutomatics, injectionTableRules, injectionTableGasChromatographyOptionsAssociation, resolvedBlankAgitateWhileSamplings, resolvedEmail,
		resolvedPostRunOvenTimes, resolvedPostRunFlowRates, resolvedPostRunPressures, resolvedStandardPostRunOvenTimes, resolvedStandardPostRunFlowRates, resolvedStandardPostRunPressures,
		resolvedBlankPostRunOvenTimes, resolvedBlankPostRunFlowRates, resolvedBlankPostRunPressures, incompatibleDetectorOptionsQ, incompatibleDetectorOptions, incompatibleDetectorOptionTests,
		fidRequiredOptions, msRequiredOptions, specifiedRequiredFIDOptions, specifiedRequiredMSOptions, incompatibleNullDetectorOptionsQ, incompatibleNullDetectorOptions, incompatibleNullDetectorOptionTests,
		compatibleORingQ, incompatibleORing, compatibleSeptumQ, incompatibleSeptum, specifiedInstrument,
		compatibleORingTest, compatibleSeptumTest, conflictingTrimOptionsQ, conflictingTrimOptionsTest, invalidTrimOptions, liquidInjectionSyringeMissingQ,
		incompatibleLiquidInjectionSyringeQ, liquidInjectionSyringeOption, specifiedHeadspaceInjectionSyringeModelType, headspaceInjectionSyringeMissingQ, incompatibleHeadspaceInjectionSyringeQ,
		headspaceInjectionSyringeOption, spmeInjectionFiberMissingQ, spmeInjectionFiberOption, specifiedLiquidHandlingSyringeModelType, liquidHandlingSyringeMissingQ,
		incompatibleLiquidHandlingSyringeQ, liquidHandlingSyringeOption, allSamplingMethods, unneededLiquidInjectionSyringeQ, unneededHeadspaceInjectionSyringeQ, unneededSPMEFiberQ,
		unneededLiquidHandlingSyringeQ, unneededSyringeTests, columnConditionOptionsConflictQ, conflictingColumnConditioningOptions, conditionColumnTests,
		ovenTimeTemperatureConflictTuples, ovenTimeTemperatureConflictOptions, ovenTimeTemperatureConflictTests,
		conditioningTemperatureTooHighQ, conditioningTemperatureTooLowQ, agitationConflictOptions, agitationConflictTuples, simulatedSampleVolumes, simulatedSampleMasses,
		simulatedSampleStates, overfilledSampleQ, overfilledStandardQ, overfilledBlankQ, dilutionTuples, standardDilutionTuples, blankDilutionTuples, offendingDilutions, offendingStandardDilutions,
		offendingBlankDilutions, offendingDilutionOptions, overfilledContainerTests, specifiedAliquotAmounts, specifiedAssayVolumes, specifiedAliquotContainers, specifiedAliquotBoolean, blanks,
		blanksWithoutNoInjection, standardContainers, blankContainers, vortexConflictTuples, vortexConflictOptions, vortexConflictTests, preInjectionSyringeWashesConflictTuples,
		preInjectionSyringeWashesConflictOptions, preInjectionSyringeWashesConflictTests, specifiedLiquidSampleWashes, specifiedStandardLiquidSampleWashes, specifiedBlankLiquidSampleWashes,
		masterSwitchedLiquidSampleWashes, masterSwitchedStandardLiquidSampleWashes, masterSwitchedBlankLiquidSampleWashes, resolvedLiquidSampleWashes, resolvedStandardLiquidSampleWashes,
		resolvedBlankLiquidSampleWashes, sampleWashConflictTuples, sampleWashConflictOptions, sampleWashConflictTests, totalNumberOfReplicates, injectionVolumeErrorTuples,
		insufficientSampleVolumeOptions, insufficientSampleVolumeTests, postInjectionSyringeWashesConflictTuples, postInjectionSyringeWashesConflictOptions,
		postInjectionSyringeWashesConflictTests, liquidInjectionSyringeTests, headspaceInjectionSyringeTests, spmeInjectionFiberTests, headspaceFlushingConflictTuples,
		headspaceFlushingConflictOptions, headspaceFlushingConflictTests, spmeConflictConflictOptions, spmeConflictConflictTests, spmeConflictTuples, headspaceAgitationConflictOptions,
		headspaceAgitationConflictTests, headspaceAgitateWhileSamplingTuples, cospecifiedOptionsOptions, cospecifiedOptionsTuples, invalidBlankPrepOpsQ, invalidBlankPrepOptions,
		invalidBlankPrepOpsTest, standardBlankTransferErrorTuples, standardBlankTransferErrorOptions, standardBlankTransferErrorTests, compatibleAliquotContainerQ,
		incompatibleAliquotContainers, incompatibleAliquotContainersOptions, incompatibleAliquotContainersTest, allSpecifiedLiquidInjectionVolumes, allSpecifiedHeadspaceInjectionVolumes,
		oRingPacket, oRingParameters, septumPacket, septumParameters, invalidGCSampleVolumeOutOfRangeOptions, optionValueOutOfBoundsOptions,
		finalVialModels, finalStandardVialModels, finalBlankVialModels, allVials, smallVials, shortBigVials, tallBigVials, tooManySmallSamplesInvalidOption,
		tooManyBigSamplesInvalidOption, simulation, updatedSimulation, blankDrawVolumesTooLargeQ, incompatibleBlankSampleAndAirVolumes, simulatedContainerCoverPackets, simulatedContainerModelPackets,
		simulatedContainerModelCoverPackets, standardContainerCoverPackets, standardContainerModelPackets, standardContainerCoverModelPackets, blankContainerCoverPackets,
		blankContainerModelPackets, blankContainerCoverModelPackets, modelCapPackets, resolvedSampleCaps, resolvedStandardCaps, resolvedBlankCaps,
		standardContainerCoverPacketsWithNulls, standardContainerModelPacketsWithNulls, standardContainerCoverModelPacketsWithNulls,
		blankContainerCoverPacketsWithNulls, blankContainerModelPacketsWithNulls, blankContainerCoverModelPacketsWithNull, aliquotContainerModelPackets, standardAliquotContainerModelPackets, blankAliquotContainerModelPackets
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];

	(* Determine if we're being executed in Engine *)
	engineQ = MatchQ[$ECLApplication, Engine];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, {}];

	(* Separate out our GasChromatography options from our Sample Prep options. *)
	{samplePrepOptions, gasChromatographyOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentGasChromatography, mySamples, samplePrepOptions, Cache -> cache, Simulation->simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentGasChromatography, mySamples, samplePrepOptions, Cache -> cache, Simulation->simulation, Output -> Result], {}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	gasChromatographyOptionsAssociation = Association[gasChromatographyOptions];

	specifiedInstrument = Lookup[gasChromatographyOptionsAssociation, Instrument];

	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our updatedSimulation *)
	(* Quiet[Download[...],Download::FieldDoesntExist] *)

	(* Download sample packets *)
	samplePackets = Quiet[Download[
		mySamples,
		(*{
			Packet[Fields to download from each sample: Expect to need: Composition, Analytes, Solvent, Status, State, Density, MeltingPoint, BoilingPoint, VaporPressure, Container, et al. ]
		},*)
		Cache -> cache,
		Simulation->updatedSimulation,
		Date -> Now
	], {Download::MissingField, Download::FieldDoesntExist, Download::NotLinkField, Download::MissingCacheField}];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(* Pull out the container and model of each sample *)
	sampleContainers = Download[samplePackets, Container[Object], Cache -> cache, Simulation->updatedSimulation, Date -> Now];

	(* Pull out the container model and properties of each simulated sample *)
	Quiet[
		{
			simulatedContainers,
			simulatedContainerModels,
			simulatedContainerCoverPackets,
			simulatedContainerModelPackets,
			simulatedContainerModelCoverPackets,
			simulatedSampleVolumes,
			simulatedSampleMasses,
			simulatedSampleStates
		} = Transpose@Download[
			simulatedSamples,
			{
				Container[Object],
				Container[Model][Object],
				Container[Cover][Packet[]],
				Container[Model][Packet[Footprint, NeckType, CoverFootprints]],
				Container[Cover][Model][Packet[Pierceable]],
				Volume,
				Mass,
				State
			},
			Cache -> cache,
		Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist}
	];

	(*-- INPUT VALIDATION CHECKS --*)

	(* == Discarded sample check == *)

	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets = Cases[Flatten[samplePackets], KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = If[
		MatchQ[discardedSamplePackets, {}],
		{},
		Lookup[discardedSamplePackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && !gatherTests,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Input sample(s) " <> ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Input sample(s) " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Simulation -> updatedSimulation] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* == Samples have containers check == *)

	(* Get any samples that have Null container model *)
	containerlessSamples = PickList[mySamples, sampleContainers, Null];

	(* If we are throwing messages, throw an error *)
	containerlessInvalidInputs = If[!gatherTests && Length[containerlessSamples] > 0,
		(
			Message[Error::ContainerlessSamples, ObjectToString[containerlessSamples, Simulation -> updatedSimulation]];
			containerlessSamples
		),
		containerlessSamples
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	containersExistTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[containerlessInvalidInputs] == 0,
				Nothing,
				Test["Input sample(s) " <> ObjectToString[containerlessInvalidInputs, Simulation -> updatedSimulation] <> " are in containers:", True, False]
			];

			passingTest = If[Length[containerlessInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Input sample(s) " <> ObjectToString[Complement[mySamples, containerlessInvalidInputs], Simulation -> updatedSimulation] <> " are in containers:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];



	(* == Compatible container checking == *)

	(* make a list of the compatible GC vials *)
	compatibleGCVialModels = Download[
		{
			Model[Container, Vessel, "20 mL clear glass GC vial"],
			Model[Container, Vessel, "10 mL clear glass GC vial"],
			Model[Container, Vessel, "0.3 mL clear glass GC vial"],
			Model[Container, Vessel, "2 mL clear glass GC vial"]
		},
		Object,
		Cache -> cache,
		Simulation -> updatedSimulation,
		Date -> Now
	];

	(* let's update the aliquotQ check here. in order to fit on the autosampler, the vials must:
	 1. be either CEVial or HeadspaceVial footprint.
	 2. have 9/245 or 18/425 NeckType *)

	{specifiedAliquotAmounts, specifiedAssayVolumes, specifiedAliquotContainers, specifiedAliquotBoolean} = Lookup[samplePrepOptions, {AliquotAmount, AssayVolume, AliquotContainer, Aliquot}];

	(* error check any specified aliquot containers to ensure they are of the correct type *)
	compatibleAliquotContainerQ = Map[
		Function[{vial},
			(* if we don't specify an aliquot then it doesn't matter *)
			If[MatchQ[vial, (Null | Automatic)],
				True,
				Module[{footprint, neckType},
					(* get the relevant fields from the simulated cache *)
					{footprint, neckType} = If[!NullQ[vial],
						Switch[
							vial,
							ObjectP[Object[Container, Vessel]],
							Download[vial, Model[{Footprint, NeckType}], Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
							ObjectP[Model[Container, Vessel]],
							Download[vial, {Footprint, NeckType}, Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
							_,
							{Null, Null}
						],
						{Null, Null}
					];
					(* check if the vial is compatible *)
					MatchQ[
						{footprint, neckType},
						Alternatives[
							(* small GC vials *)
							{CEVial, "9/425"},
							(* larger headspace vials *)
							{HeadspaceVial, "18/425"}
						]
					]
				]
			]
		],
		specifiedAliquotContainers
	];

	(* determine any incompatible aliquot containers *)
	incompatibleAliquotContainers = DeleteDuplicates@PickList[specifiedAliquotContainers /. {x : ObjectP[] :> Download[x, Object]}, compatibleAliquotContainerQ, False];

	(*errors*)
	incompatibleAliquotContainersOptions = If[!gatherTests,
		If[Nand @@ compatibleAliquotContainerQ,
			Message[Error::GCContainerIncompatible, "AliquotContainer", incompatibleAliquotContainers];
			AliquotContainer,
			Nothing
		],
		{}
	];

	(* tests *)
	incompatibleAliquotContainersTest = If[gatherTests,
		Test["If AliquotContainers are specified, they must have {Footprint,NeckType} of {CEVial,9/425} or {HeadspaceVial,18/425}:",
			And @@ compatibleAliquotContainerQ,
			True],
		{}
	];

	(* decide if any samples will need to be moved into a GC compatible vial*)
	aliquotQ = MapThread[
		Function[{containerModel, aliquotAmount, aliquotContainer, aliquotBool},
			(* if the containerType is not a vessel (such as a plate), or an aliquot option is already specified we can return True early *)
			If[
				!MatchQ[containerModel, ObjectP[Model[Container, Vessel]]] || TrueQ[aliquotBool] || MatchQ[aliquotAmount, Except[Null | Automatic]] || MatchQ[aliquotContainer, Except[Null | Automatic]],
				True,
				(* otherwise we should check to see if the current container is GC compatible *)
				Module[{footprint, neckType},
					(* get the relevant fields from the simulated cache *)
					{footprint, neckType} = If[!NullQ[containerModel],
						Download[containerModel, {Footprint, NeckType}, Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
						{Null, Null}
					];
					(* check if the vial is compatible *)
					!MatchQ[
						{footprint, neckType},
						Alternatives[
							(* small GC vials *)
							{CEVial, "9/425"},
							(* larger headspace vials *)
							{HeadspaceVial, "18/425"}
						]
					]
				]
			]
		],
		(*!MatchQ[#,Alternatives@@compatibleGCVialModels]&*)
		{simulatedContainerModels, specifiedAliquotAmounts, specifiedAliquotContainers, specifiedAliquotBoolean}
	];

	(* == Protocol name uniqueness check == *)

	(* Get the name of the protocol if specified *)
	protocolName = Lookup[myOptions, Name];

	(* Determine if the name exists in the DB *)
	validProtocolNameQ = If[MatchQ[protocolName, _String],
		Not[DatabaseMemberQ[Object[Protocol, GasChromatography, protocolName]]],
		True
	];

	(* If we are throwing messages, throw an error if the name already exists in the DB *)
	invalidProtocolName = If[!gatherTests && !validProtocolNameQ,
		(
			Message[Error::DuplicateName, "GasChromatography protocol"];
			protocolName
		),
		Null
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	validProtocolNameTest = If[gatherTests && MatchQ[protocolName, _String],
		Test["The specified GasChromatography protocol Name is not already taken:",
			validProtocolNameQ,
			True
		],
		Nothing
	];

	(* == Column is a gas chromatography column == *)

	(* Get the column and corresponding separation mode *)
	column = ToList[Lookup[gasChromatographyOptionsAssociation, Column]];

	(* Get the model(s) of the installed column(s) *)
	columnModel = Map[
		Switch[
			#,
			ObjectP[Object[Item, Column]],
			Download[#, Model, Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
			ObjectP[Model[Item, Column]],
			#,
			_,
			$Failed
		]&,
		column
	];

	separationMode = Map[
		Switch[
			#,
			ObjectP[Object[Item, Column]],
			Download[
				Download[#, Model, Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
				ChromatographyType,
				Cache -> cache,
				Simulation -> updatedSimulation,
				Date -> Now
			],
			ObjectP[Model[Item, Column]],
			Download[#, ChromatographyType, Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
			_,
			$Failed
		]&,
		column
	];

	(* Get any invalid columns that don't have SeparationMode->GasChromatography *)
	invalidColumns = PickList[Flatten@column, Flatten@separationMode, Except[GasChromatography]];

	(* If we are throwing messages, throw an error *)
	invalidInputColumns = If[Length[invalidColumns] > 0,
		(
			If[!gatherTests, Message[Error::GCIncompatibleColumn, ObjectToString[invalidColumns, Cache -> cache, Simulation -> updatedSimulation]]];
			Column
		),
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidColumnsTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidColumns] == 0,
				Nothing,
				Test["Input column(s) " <> ObjectToString[invalidColumns, Cache -> cache, Simulation -> updatedSimulation] <> " are gas chromatography columns:", True, False]
			];

			passingTest = If[Length[invalidColumns] == Length[column],
				Nothing,
				Test["Input column(s) " <> ObjectToString[Complement[column, invalidColumns], Cache -> cache, Simulation -> updatedSimulation] <> " are gas chromatography columns:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* -- INJECTIONTABLE -- *)

	(*get the injection table option and see if need consider the suboptions within it*)
	injectionTableLookup = Lookup[gasChromatographyOptionsAssociation, InjectionTable, Null];

	(*is the injection specified (meaning that it has tuples within it)?*)
	injectionTableSpecifiedQ = MatchQ[injectionTableLookup, Except[Automatic | Null | {}]];

	(* if the injection table is specified, we need to create all the experiment options from the injection table and then
	use those to overwrite the normally specified experiment options: it is therefore critical that if options are specified that they be identical
	to what comes out of the injection table otherwise we have a conflict and can't proceed *)

	(* make a helper function *)
	gcInjectionTableReplaceRules[myInjectionTable_] := Module[
		{
			injectionTableSampleEntries, injectionTableStandardEntries, injectionTableBlankEntries, injectionTableSpecifiedSamples, injectionTableSpecifiedStandards,
			injectionTableSpecifiedBlanks, injectionTableSpecifiedSampleSamplingMethods, injectionTableSpecifiedStandardSamplingMethods, injectionTableSpecifiedBlankSamplingMethods,
			injectionTableSpecifiedSampleSeparationMethods, injectionTableSpecifiedStandardSeparationMethods, injectionTableSpecifiedBlankSeparationMethods, injectionTableSpecifiedSampleOps,
			injectionTableSpecifiedStandardOps, injectionTableSpecifiedBlankOps, injectionTableSpecifiedSampleOpKeys, injectionTableSpecifiedStandardOpKeys, injectionTableSpecifiedBlankOpKeys,
			injectionTableReplaceRules, standardTableRules, blankTableRules, tableRules
		},
		(* break the table down into its constituents *)
		{
			injectionTableSampleEntries,
			injectionTableStandardEntries,
			injectionTableBlankEntries
		} = {
			Cases[myInjectionTable, {Sample, ___}], Cases[myInjectionTable, {Standard, ___}], Cases[myInjectionTable, {Blank, ___}]
		};

		(* extract the samples, standards, and blanks *)
		{injectionTableSpecifiedSamples, injectionTableSpecifiedStandards, injectionTableSpecifiedBlanks} = {injectionTableSampleEntries, injectionTableStandardEntries, injectionTableBlankEntries}[[All, All, 2]];

		(* extract the samplingMethods *)
		{injectionTableSpecifiedSampleSamplingMethods, injectionTableSpecifiedStandardSamplingMethods, injectionTableSpecifiedBlankSamplingMethods} = {injectionTableSampleEntries, injectionTableStandardEntries, injectionTableBlankEntries}[[All, All, 3]];

		(* extract the samplingMethods *)
		{injectionTableSpecifiedSampleSeparationMethods, injectionTableSpecifiedStandardSeparationMethods, injectionTableSpecifiedBlankSeparationMethods} = {injectionTableSampleEntries, injectionTableStandardEntries, injectionTableBlankEntries}[[All, All, 5]];

		(* Extract the specified options (we will still automatically resolve unspecified options in the experiment, options must be completely nulled to be forced Null at the injectionTable stage) *)

		(* get injection table sample prep ops *)
		{injectionTableSpecifiedSampleOps, injectionTableSpecifiedStandardOps, injectionTableSpecifiedBlankOps} = {injectionTableSampleEntries, injectionTableStandardEntries, injectionTableBlankEntries}[[All, All, 4]];

		(* extract the keys *)
		{injectionTableSpecifiedSampleOpKeys, injectionTableSpecifiedStandardOpKeys, injectionTableSpecifiedBlankOpKeys} = Keys /@ ({injectionTableSpecifiedSampleOps, injectionTableSpecifiedStandardOps, injectionTableSpecifiedBlankOps}/.{(Automatic|Null)-><||>});

		(* prepare the replace rule groups and return the list as an association *)
		injectionTableReplaceRules = Flatten@MapThread[
			Function[{keys, specifiedOpsList, prefix},
				(* for each unique key, look up the key in each injection table entry. if it has not been specified (_Missing) it will be replaced by Automatic *)
				Map[
					Function[{key},
						(* create a rule for each key, but we need to do some special work to make sure the rules are correct *)
						Rule[
							(* finalize the rule key by appending the prefix, but we have to except a few keys from that rule because of ? poor planning perhaps? *)
							If[!MatchQ[key,
								(* list of excepted keys *)
								Alternatives[StandardVial, StandardAmount, BlankVial, BlankAmount, BlankType]
							],
								ToExpression[prefix <> ToString[key]],
								key
							],
							(* seems like the easiest way to join all the key values *)
							Lookup[specifiedOpsList, key] /. {_Missing :> Automatic}
						]
					],
					DeleteDuplicates[Flatten[keys]]
				]
			],
			{
				{injectionTableSpecifiedSampleOpKeys, injectionTableSpecifiedStandardOpKeys, injectionTableSpecifiedBlankOpKeys},
				{injectionTableSpecifiedSampleOps, injectionTableSpecifiedStandardOps, injectionTableSpecifiedBlankOps},
				{"", "Standard", "Blank"}
			}
		];

		(* Only include Standard options when there are standards, otherwise just Standard -> {} *)
		standardTableRules=If[MatchQ[injectionTableSpecifiedStandards,{}],
			<|Standard -> injectionTableSpecifiedStandards|>,
			<|
				Standard -> injectionTableSpecifiedStandards,
				StandardSamplingMethod -> injectionTableSpecifiedStandardSamplingMethods,
				StandardSeparationMethod -> injectionTableSpecifiedStandardSeparationMethods
			|>
		];

		(* Only include Blank options when there are standards, otherwise just Blank -> {} *)
		blankTableRules=If[MatchQ[injectionTableSpecifiedStandards,{}],
			<|Blank -> injectionTableSpecifiedBlanks /. {Null -> NoInjection}|>,
			<|
				Blank -> injectionTableSpecifiedBlanks /. {Null -> NoInjection},
				BlankSamplingMethod -> injectionTableSpecifiedBlankSamplingMethods,
				BlankSeparationMethod -> injectionTableSpecifiedBlankSeparationMethods
			|>
		];

		(* Join the Sample, Standard, Blank rules together. Note we should always have Sample *)
		tableRules = Join[
			<|
				SamplingMethod -> injectionTableSpecifiedSampleSamplingMethods,
				SeparationMethod -> injectionTableSpecifiedSampleSeparationMethods
			|>,
			standardTableRules,
			blankTableRules
		];

		Join[Association[injectionTableReplaceRules], tableRules]
	];

	(* get the association to join *)
	injectionTableRules = If[injectionTableSpecifiedQ,
		gcInjectionTableReplaceRules[injectionTableLookup],
		<||>
	];

	(* replace the specified options with those derived from the injection table. this is currently pretty aggressive, and probably needs to do more checks to ensure merging the injection table and specified options, if any *)
	injectionTableGasChromatographyOptionsAssociation = Join[gasChromatographyOptionsAssociation, injectionTableRules];

	(* == Number of samples check == *)


	(* Get the standards,blanks *)
	{standards, blanks} = ToList /@ Lookup[injectionTableGasChromatographyOptionsAssociation, {Standard, Blank}];

	blanksWithoutNoInjection = blanks /. {NoInjection | Null -> Nothing};

	(* Determine if the number of samples is too many (>207) *)
	tooManySamplesQ = Length[mySamples] + Length[standards] + Length[blanksWithoutNoInjection] > 207;

	(* If there are more than 207 samples, and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	tooManySamplesInputs = Which[
		TrueQ[tooManySamplesQ] && !gatherTests,
		(
			Message[Error::GCTooManySamples, 207];
			Join[Download[mySamples, Object, Cache -> cache, Simulation -> updatedSimulation, Date -> Now], standards]
		),
		TrueQ[tooManySamplesQ], Join[Download[mySamples, Object, Cache -> cache, Simulation -> updatedSimulation, Date -> Now], standards, blanksWithoutNoInjection],
		True, {}
	];

	(* If we are gathering tests, test for too many samples *)
	tooManySamplesTest = If[gatherTests,
		Test["The number of samples provided is not greater than 207:",
			tooManySamplesQ,
			False
		],
		Nothing
	];

	(* -- OPTION PRECISION CHECKS -- *)

	(* Round and test (if applicable) for invalid option precision in all the options that aren't tuples *)
	{roundedGasChromatographyOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[injectionTableGasChromatographyOptionsAssociation,
			{
				(* Temperature options to round to 10^-2*Celsius *)
				ColumnConditioningTemperature,
				InitialInletTemperature,
				InitialOvenTemperature,
				PostRunOvenTemperature,
				FIDTemperature,
				StandardInitialInletTemperature,
				StandardInitialOvenTemperature,
				StandardPostRunOvenTemperature,
				BlankInitialInletTemperature,
				BlankInitialOvenTemperature,
				BlankPostRunOvenTemperature,
				(* Time options to round to 10^(-4)*Minute *)
				ColumnConditioningTime,
				SplitlessTime,
				InitialInletTime,
				GasSaverActivationTime,
				InitialInletTemperatureDuration,
				InitialColumnResidenceTime,
				InitialColumnSetpointDuration,
				OvenEquilibrationTime,
				InitialOvenTemperatureDuration,
				OvenPostRunTime,
				StandardSplitlessTime,
				StandardInitialInletTime,
				StandardGasSaverActivationTime,
				StandardInitialInletTemperatureDuration,
				StandardInitialColumnResidenceTime,
				StandardInitialColumnSetpointDuration,
				StandardOvenEquilibrationTime,
				StandardInitialOvenTemperatureDuration,
				StandardOvenPostRunTime,
				BlankSplitlessTime,
				BlankInitialInletTime,
				BlankGasSaverActivationTime,
				BlankInitialInletTemperatureDuration,
				BlankInitialColumnResidenceTime,
				BlankInitialColumnSetpointDuration,
				BlankOvenEquilibrationTime,
				BlankInitialOvenTemperatureDuration,
				BlankOvenPostRunTime,
				(* Flow rate options to round to 10^(-4)*Milliliter/Minute *)
				InletSeptumPurgeFlowRate,
				SplitVentFlowRate,
				GasSaverFlowRate,
				InitialColumnFlowRate,
				FIDAirFlowRate,
				FIDDihydrogenFlowRate,
				FIDMakeupGasFlowRate,
				SolventEliminationFlowRate,
				StandardInletSeptumPurgeFlowRate,
				StandardSplitVentFlowRate,
				StandardGasSaverFlowRate,
				StandardInitialColumnFlowRate,
				StandardSolventEliminationFlowRate,
				BlankInletSeptumPurgeFlowRate,
				BlankSplitVentFlowRate,
				BlankGasSaverFlowRate,
				BlankInitialColumnFlowRate,
				BlankSolventEliminationFlowRate,
				(* Pressure options to round to 10^(-4)*PSI *)
				InletPressure,
				InitialInletPressure,
				InitialColumnPressure,
				ColumnPressure,
				StandardInletPressure,
				StandardInitialInletPressure,
				StandardInitialColumnPressure,
				StandardColumnPressure,
				BlankInletPressure,
				BlankInitialInletPressure,
				BlankInitialColumnPressure,
				BlankColumnPressure,
				(* autosampler options all accept values down to the 10^(-10) of the autosampler value *)
				(* volume (uL) *)
				DilutionSolventVolume,
				SecondaryDilutionSolventVolume,
				TertiaryDilutionSolventVolume,
				LiquidPreInjectionSyringeWashVolume,
				LiquidSampleWashVolume,
				LiquidSampleFillingStrokesVolume,
				InjectionVolume,
				LiquidSampleOverAspirationVolume,
				LiquidPostInjectionSyringeWashVolume,
				StandardDilutionSolventVolume,
				StandardSecondaryDilutionSolventVolume,
				StandardTertiaryDilutionSolventVolume,
				StandardLiquidPreInjectionSyringeWashVolume,
				StandardLiquidSampleWashVolume,
				StandardLiquidSampleFillingStrokesVolume,
				StandardInjectionVolume,
				StandardLiquidSampleOverAspirationVolume,
				StandardLiquidPostInjectionSyringeWashVolume,
				BlankDilutionSolventVolume,
				BlankSecondaryDilutionSolventVolume,
				BlankTertiaryDilutionSolventVolume,
				BlankLiquidPreInjectionSyringeWashVolume,
				BlankLiquidSampleWashVolume,
				BlankLiquidSampleFillingStrokesVolume,
				BlankInjectionVolume,
				BlankLiquidSampleOverAspirationVolume,
				BlankLiquidPostInjectionSyringeWashVolume,
				(* volume rate (uL/s) *)
				LiquidPreInjectionSyringeWashRate,
				SampleAspirationRate,
				SampleInjectionRate,
				LiquidPostInjectionSyringeWashRate,
				StandardLiquidPreInjectionSyringeWashRate,
				StandardSampleAspirationRate,
				StandardSampleInjectionRate,
				StandardLiquidPostInjectionSyringeWashRate,
				BlankLiquidPreInjectionSyringeWashRate,
				BlankSampleAspirationRate,
				BlankSampleInjectionRate,
				BlankLiquidPostInjectionSyringeWashRate,
				(* distance (mm) *)
				SampleVialAspirationPositionOffset,
				InjectionInletPenetrationDepth,
				SPMEDerivatizationPositionOffset,
				StandardSampleVialAspirationPositionOffset,
				StandardInjectionInletPenetrationDepth,
				StandardSPMEDerivatizationPositionOffset,
				BlankSampleVialAspirationPositionOffset,
				BlankInjectionInletPenetrationDepth,
				BlankSPMEDerivatizationPositionOffset,
				(* distance rate (mm/s) *)
				SampleVialPenetrationRate,
				InjectionInletPenetrationRate,
				StandardSampleVialPenetrationRate,
				StandardInjectionInletPenetrationRate,
				BlankSampleVialPenetrationRate,
				BlankInjectionInletPenetrationRate,
				(* temperature (C) *)
				AgitationTemperature,
				HeadspaceSyringeTemperature,
				SPMEConditioningTemperature,
				StandardAgitationTemperature,
				StandardHeadspaceSyringeTemperature,
				StandardSPMEConditioningTemperature,
				BlankAgitationTemperature,
				BlankHeadspaceSyringeTemperature,
				BlankSPMEConditioningTemperature,
				(* duration (s) *)
				VortexTime,
				AgitationTime,
				AgitationOnTime,
				AgitationOffTime,
				PreInjectionTimeDelay,
				PostInjectionTimeDelay,
				HeadspacePreInjectionFlushTime,
				HeadspacePostInjectionFlushTime,
				SPMEPreConditioningTime,
				SPMEDerivatizingAgentAdsorptionTime,
				SPMESampleExtractionTime,
				SPMESampleDesorptionTime,
				SPMEPostInjectionConditioningTime,
				StandardVortexTime,
				StandardAgitationTime,
				StandardAgitationOnTime,
				StandardAgitationOffTime,
				StandardPreInjectionTimeDelay,
				StandardPostInjectionTimeDelay,
				StandardHeadspacePreInjectionFlushTime,
				StandardHeadspacePostInjectionFlushTime,
				StandardSPMEPreConditioningTime,
				StandardSPMEDerivatizingAgentAdsorptionTime,
				StandardSPMESampleExtractionTime,
				StandardSPMESampleDesorptionTime,
				StandardSPMEPostInjectionConditioningTime,
				BlankVortexTime,
				BlankAgitationTime,
				BlankAgitationOnTime,
				BlankAgitationOffTime,
				BlankPreInjectionTimeDelay,
				BlankPostInjectionTimeDelay,
				BlankHeadspacePreInjectionFlushTime,
				BlankHeadspacePostInjectionFlushTime,
				BlankSPMEPreConditioningTime,
				BlankSPMEDerivatizingAgentAdsorptionTime,
				BlankSPMESampleExtractionTime,
				BlankSPMESampleDesorptionTime,
				BlankSPMEPostInjectionConditioningTime,
				(* RPM (RPM) *)
				VortexMixRate,
				AgitationMixRate,
				StandardVortexMixRate,
				StandardAgitationMixRate,
				BlankVortexMixRate,
				BlankAgitationMixRate,
				(* TrimColumn *)
				TrimColumn
			},
			{
				(* Temperature options to round to 10^(-2)*Celsius *)
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				(* Time options to round to 10^(-4)*Minute *)
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				(* Flow rate options to round to 10^(-4)*Milliliter/Minute *)
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				(* Pressure options to round to 10^(-3)*PSI *)
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				(* autosampler options all accept values down to the 10^(-10) of the autosampler value *)
				(* volume (uL) *)
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				(* volume rate (Attoliter/s) *)
				100 Attoliter / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				(* distance (mm) *)
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				(* distance rate (mm/s) *)
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				(* temperature (C) *)
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				(* duration (s) *)
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				(* RPM (RPM) *)
				10^(-10) * RPM,
				10^(-10) * RPM,
				10^(-10) * RPM,
				10^(-10) * RPM,
				10^(-10) * RPM,
				10^(-10) * RPM,
				(* TrimColumn *)
				10^(0) * Millimeter
			},

			Output -> {Result, Tests}
		],
		{RoundOptionPrecision[injectionTableGasChromatographyOptionsAssociation,
			{
				(* Temperature options to round to 10^-2*Celsius *)
				ColumnConditioningTemperature,
				InitialInletTemperature,
				InitialOvenTemperature,
				PostRunOvenTemperature,
				FIDTemperature,
				StandardInitialInletTemperature,
				StandardInitialOvenTemperature,
				StandardPostRunOvenTemperature,
				BlankInitialInletTemperature,
				BlankInitialOvenTemperature,
				BlankPostRunOvenTemperature,
				(* Time options to round to 10^(-4)*Minute *)
				ColumnConditioningTime,
				SplitlessTime,
				InitialInletTime,
				GasSaverActivationTime,
				InitialInletTemperatureDuration,
				InitialColumnResidenceTime,
				InitialColumnSetpointDuration,
				OvenEquilibrationTime,
				InitialOvenTemperatureDuration,
				OvenPostRunTime,
				StandardSplitlessTime,
				StandardInitialInletTime,
				StandardGasSaverActivationTime,
				StandardInitialInletTemperatureDuration,
				StandardInitialColumnResidenceTime,
				StandardInitialColumnSetpointDuration,
				StandardOvenEquilibrationTime,
				StandardInitialOvenTemperatureDuration,
				StandardOvenPostRunTime,
				BlankSplitlessTime,
				BlankInitialInletTime,
				BlankGasSaverActivationTime,
				BlankInitialInletTemperatureDuration,
				BlankInitialColumnResidenceTime,
				BlankInitialColumnSetpointDuration,
				BlankOvenEquilibrationTime,
				BlankInitialOvenTemperatureDuration,
				BlankOvenPostRunTime,
				(* Flow rate options to round to 10^(-4)*Milliliter/Minute *)
				InletSeptumPurgeFlowRate,
				SplitVentFlowRate,
				GasSaverFlowRate,
				InitialColumnFlowRate,
				FIDAirFlowRate,
				FIDDihydrogenFlowRate,
				FIDMakeupGasFlowRate,
				SolventEliminationFlowRate,
				StandardInletSeptumPurgeFlowRate,
				StandardSplitVentFlowRate,
				StandardGasSaverFlowRate,
				StandardInitialColumnFlowRate,
				StandardSolventEliminationFlowRate,
				BlankInletSeptumPurgeFlowRate,
				BlankSplitVentFlowRate,
				BlankGasSaverFlowRate,
				BlankInitialColumnFlowRate,
				BlankSolventEliminationFlowRate,
				(* Pressure options to round to 10^(-4)*PSI *)
				InletPressure,
				InitialInletPressure,
				InitialColumnPressure,
				ColumnPressure,
				StandardInletPressure,
				StandardInitialInletPressure,
				StandardInitialColumnPressure,
				StandardColumnPressure,
				BlankInletPressure,
				BlankInitialInletPressure,
				BlankInitialColumnPressure,
				BlankColumnPressure,
				(* autosampler options all accept values down to the 10^(-10) of the autosampler value *)
				(* volume (uL) *)
				DilutionSolventVolume,
				SecondaryDilutionSolventVolume,
				TertiaryDilutionSolventVolume,
				LiquidPreInjectionSyringeWashVolume,
				LiquidSampleWashVolume,
				LiquidSampleFillingStrokesVolume,
				InjectionVolume,
				LiquidSampleOverAspirationVolume,
				LiquidPostInjectionSyringeWashVolume,
				StandardDilutionSolventVolume,
				StandardSecondaryDilutionSolventVolume,
				StandardTertiaryDilutionSolventVolume,
				StandardLiquidPreInjectionSyringeWashVolume,
				StandardLiquidSampleWashVolume,
				StandardLiquidSampleFillingStrokesVolume,
				StandardInjectionVolume,
				StandardLiquidSampleOverAspirationVolume,
				StandardLiquidPostInjectionSyringeWashVolume,
				BlankDilutionSolventVolume,
				BlankSecondaryDilutionSolventVolume,
				BlankTertiaryDilutionSolventVolume,
				BlankLiquidPreInjectionSyringeWashVolume,
				BlankLiquidSampleWashVolume,
				BlankLiquidSampleFillingStrokesVolume,
				BlankInjectionVolume,
				BlankLiquidSampleOverAspirationVolume,
				BlankLiquidPostInjectionSyringeWashVolume,
				(* volume rate (uL/s) *)
				LiquidPreInjectionSyringeWashRate,
				SampleAspirationRate,
				SampleInjectionRate,
				LiquidPostInjectionSyringeWashRate,
				StandardLiquidPreInjectionSyringeWashRate,
				StandardSampleAspirationRate,
				StandardSampleInjectionRate,
				StandardLiquidPostInjectionSyringeWashRate,
				BlankLiquidPreInjectionSyringeWashRate,
				BlankSampleAspirationRate,
				BlankSampleInjectionRate,
				BlankLiquidPostInjectionSyringeWashRate,
				(* distance (mm) *)
				SampleVialAspirationPositionOffset,
				InjectionInletPenetrationDepth,
				SPMEDerivatizationPositionOffset,
				StandardSampleVialAspirationPositionOffset,
				StandardInjectionInletPenetrationDepth,
				StandardSPMEDerivatizationPositionOffset,
				BlankSampleVialAspirationPositionOffset,
				BlankInjectionInletPenetrationDepth,
				BlankSPMEDerivatizationPositionOffset,
				(* distance rate (mm/s) *)
				SampleVialPenetrationRate,
				InjectionInletPenetrationRate,
				StandardSampleVialPenetrationRate,
				StandardInjectionInletPenetrationRate,
				BlankSampleVialPenetrationRate,
				BlankInjectionInletPenetrationRate,
				(* temperature (C) *)
				AgitationTemperature,
				HeadspaceSyringeTemperature,
				SPMEConditioningTemperature,
				StandardAgitationTemperature,
				StandardHeadspaceSyringeTemperature,
				StandardSPMEConditioningTemperature,
				BlankAgitationTemperature,
				BlankHeadspaceSyringeTemperature,
				BlankSPMEConditioningTemperature,
				(* duration (s) *)
				VortexTime,
				AgitationTime,
				AgitationOnTime,
				AgitationOffTime,
				PreInjectionTimeDelay,
				PostInjectionTimeDelay,
				HeadspacePreInjectionFlushTime,
				HeadspacePostInjectionFlushTime,
				SPMEPreConditioningTime,
				SPMEDerivatizingAgentAdsorptionTime,
				SPMESampleExtractionTime,
				SPMESampleDesorptionTime,
				SPMEPostInjectionConditioningTime,
				StandardVortexTime,
				StandardAgitationTime,
				StandardAgitationOnTime,
				StandardAgitationOffTime,
				StandardPreInjectionTimeDelay,
				StandardPostInjectionTimeDelay,
				StandardHeadspacePreInjectionFlushTime,
				StandardHeadspacePostInjectionFlushTime,
				StandardSPMEPreConditioningTime,
				StandardSPMEDerivatizingAgentAdsorptionTime,
				StandardSPMESampleExtractionTime,
				StandardSPMESampleDesorptionTime,
				StandardSPMEPostInjectionConditioningTime,
				BlankVortexTime,
				BlankAgitationTime,
				BlankAgitationOnTime,
				BlankAgitationOffTime,
				BlankPreInjectionTimeDelay,
				BlankPostInjectionTimeDelay,
				BlankHeadspacePreInjectionFlushTime,
				BlankHeadspacePostInjectionFlushTime,
				BlankSPMEPreConditioningTime,
				BlankSPMEDerivatizingAgentAdsorptionTime,
				BlankSPMESampleExtractionTime,
				BlankSPMESampleDesorptionTime,
				BlankSPMEPostInjectionConditioningTime,
				(* RPM (RPM) *)
				VortexMixRate,
				AgitationMixRate,
				StandardVortexMixRate,
				StandardAgitationMixRate,
				BlankVortexMixRate,
				BlankAgitationMixRate,
				(* TrimColumn *)
				TrimColumn
			},

			{
				(* Temperature options to round to 10^(-2)*Celsius *)
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				10^(-2) * Celsius,
				(* Time options to round to 10^(-4)*Minute *)
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				10^(-4) * Minute,
				(* Flow rate options to round to 10^(-4)*Milliliter/Minute *)
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				10^(-4) * Milliliter / Minute,
				(* Pressure options to round to 10^(-3)*PSI *)
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				10^(-3) * PSI,
				(* autosampler options all accept values down to the 10^(-10) of the autosampler value *)
				(* volume (uL) *)
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				10^(-10) * Microliter,
				(* volume rate (Attoliter/s) *)
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				100 Attoliter  / Second,
				(* distance (mm) *)
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				10^(-10) * Millimeter,
				(* distance rate (mm/s) *)
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				10^(-10) * Millimeter / Second,
				(* temperature (C) *)
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				10^(-10) * Celsius,
				(* duration (s) *)
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				10^(-10) * Second,
				(* RPM (RPM) *)
				10^(-10) * RPM,
				10^(-10) * RPM,
				10^(-10) * RPM,
				10^(-10) * RPM,
				10^(-10) * RPM,
				10^(-10) * RPM,
				(* TrimColumn *)
				10^(0) * Millimeter
			}
		],
			{}
		}
	];

	(* Helper function to round a profile containing three quantities, as is the format of the profiles found here. This could be expanded to do all the profiles at once, using any number of quantities *)

	roundProfileOptions[myProfile_, myPrecisions : {_Quantity, _Quantity, _Quantity}, optionsAssociation_, gatherTestsBoolean_] := Module[
		{myProfileOptionValues, primaryUnitPositions, primaryUnitList, primaryUnitAssociation, primaryUnitRoundedAssociation, primaryUnitRoundedTests,
			secondaryUnitPositions, secondaryUnitList, secondaryUnitAssociation, secondaryUnitRoundedAssociation, secondaryUnitRoundedTests,
			tertiaryUnitPositions, tertiaryUnitList, tertiaryUnitAssociation, tertiaryUnitRoundedAssociation, tertiaryUnitRoundedTests,
			replaceRoundedValuesRules, myProfileRounded, myProfileRoundedTests},

		(* Pull the profile in question *)
		myProfileOptionValues = Lookup[optionsAssociation, myProfile];

		(* Get the position of all of the first type of units with precision specified: *)
		primaryUnitPositions = Position[myProfileOptionValues, GreaterEqualP[0 * myPrecisions[[1]]], All];

		(* Create a flat list of profile components with the specified units *)
		primaryUnitList = Fold[Function[{expr, pos}, Part[expr, pos]], myProfileOptionValues, #] & /@ primaryUnitPositions;

		(* Turn the flat list into an association *)
		primaryUnitAssociation = Association[myProfile -> primaryUnitList];

		(* Round the profile components *)
		{primaryUnitRoundedAssociation, primaryUnitRoundedTests} = If[gatherTestsBoolean,
			RoundOptionPrecision[
				primaryUnitAssociation,
				myProfile,
				myPrecisions[[1]],
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					primaryUnitAssociation,
					myProfile,
					myPrecisions[[1]]
				],
				{}
			}
		];

		(* Get the position of all of the second type of units with precision specified: *)
		secondaryUnitPositions = Position[myProfileOptionValues, GreaterEqualP[0 * myPrecisions[[2]]], All];

		(* Create a flat list of profile components with the specified units *)
		secondaryUnitList = Fold[Function[{expr, pos}, Part[expr, pos]], myProfileOptionValues, #] & /@ secondaryUnitPositions;

		(* Turn the flat list into an association *)
		secondaryUnitAssociation = Association[myProfile -> secondaryUnitList];

		(* Round the profile components *)
		{secondaryUnitRoundedAssociation, secondaryUnitRoundedTests} = If[gatherTestsBoolean,
			RoundOptionPrecision[
				secondaryUnitAssociation,
				myProfile,
				myPrecisions[[2]],
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					secondaryUnitAssociation,
					myProfile,
					myPrecisions[[2]]
				],
				{}
			}
		];

		(* Get the position of all of the third type of units with precision specified: *)
		tertiaryUnitPositions = Position[myProfileOptionValues, GreaterEqualP[0 * myPrecisions[[3]]], All];

		(* Create a flat list of profile components with the specified units *)
		tertiaryUnitList = Fold[Function[{expr, pos}, Part[expr, pos]], myProfileOptionValues, #] & /@ tertiaryUnitPositions;

		(* Turn the flat list into an association *)
		tertiaryUnitAssociation = Association[myProfile -> tertiaryUnitList];

		(* Round the profile components *)
		{tertiaryUnitRoundedAssociation, tertiaryUnitRoundedTests} = If[gatherTestsBoolean,
			RoundOptionPrecision[
				tertiaryUnitAssociation,
				myProfile,
				myPrecisions[[3]],
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					tertiaryUnitAssociation,
					myProfile,
					myPrecisions[[3]]
				],
				{}
			}
		];

		(* Build the replacement rules *)
		replaceRoundedValuesRules = MapThread[
			Rule,
			{
				Join[primaryUnitPositions, secondaryUnitPositions, tertiaryUnitPositions],
				Join[Sequence @@ Join[Lookup[{primaryUnitRoundedAssociation, secondaryUnitRoundedAssociation, tertiaryUnitRoundedAssociation}, myProfile]]]
			}
		];

		(* Rebuild the profile and test lists *)
		myProfileRounded = ReplacePart[myProfileOptionValues, replaceRoundedValuesRules];
		myProfileRoundedTests = Flatten[{primaryUnitRoundedTests, secondaryUnitRoundedTests, tertiaryUnitRoundedTests}];

		(* Output the rounded profile, followed by the list of tests *)
		{myProfileRounded, myProfileRoundedTests}

	];

	(* Round the profiles using the helper function *)
	{
		{roundedInletTemperatureProfile, inletTemperatureProfileTests},
		{roundedStandardInletTemperatureProfile, standardInletTemperatureProfileTests},
		{roundedBlankInletTemperatureProfile, blankInletTemperatureProfileTests}
	} = Map[
		roundProfileOptions[#, {10^(-4) * Celsius / Minute, 10^(-2) * Celsius, 10^(-4) * Minute}, roundedGasChromatographyOptions, gatherTests]&,
		{InletTemperatureProfile, StandardInletTemperatureProfile, BlankInletTemperatureProfile}
	];

	{
		{roundedColumnPressureProfile, columnPressureProfileTests},
		{roundedStandardColumnPressureProfile, standardColumnPressureProfileTests},
		{roundedBlankColumnPressureProfile, blankColumnPressureProfileTests}
	} = Map[
		roundProfileOptions[#, {10^(-3) * PSI / Minute, 10^(-4) * PSI, 10^(-4) * Minute}, roundedGasChromatographyOptions, gatherTests]&,
		{ColumnPressureProfile, StandardColumnPressureProfile, BlankColumnPressureProfile}
	];

	{
		{roundedColumnFlowRateProfile, columnFlowRateProfileTests},
		{roundedStandardColumnFlowRateProfile, standardColumnFlowRateProfileTests},
		{roundedBlankColumnFlowRateProfile, blankColumnFlowRateProfileTests}
	} = Map[roundProfileOptions[#, {10^(-4) * Milliliter / Minute / Minute, 10^(-2) * Milliliter / Minute, 10^(-4) * Minute}, roundedGasChromatographyOptions, gatherTests]&, {ColumnFlowRateProfile, StandardColumnFlowRateProfile, BlankColumnFlowRateProfile}];

	{
		{roundedOvenTemperatureProfile, ovenTemperatureProfileTests},
		{roundedStandardOvenTemperatureProfile, standardOvenTemperatureProfileTests},
		{roundedBlankOvenTemperatureProfile, blankOvenTemperatureProfileTests}
	} = Map[roundProfileOptions[#, {10^(-3) * Celsius / Minute, 10^(-2) * Celsius, 10^(-4) * Minute}, roundedGasChromatographyOptions, gatherTests]&, {OvenTemperatureProfile, StandardOvenTemperatureProfile, BlankOvenTemperatureProfile}];

	(* Expand and resolve the standard and blank options so we can work with them the same way we work with all other options *)

	(* define Standard options *)
	standardOptions = {StandardAmount, StandardVial, StandardDilute, StandardDilutionSolventVolume, StandardSecondaryDilutionSolventVolume, StandardTertiaryDilutionSolventVolume, StandardAgitate, StandardAgitationTime,
		StandardAgitationTemperature, StandardAgitationMixRate, StandardAgitationOnTime, StandardAgitationOffTime, StandardVortex, StandardVortexMixRate, StandardVortexTime, StandardSamplingMethod,
		StandardHeadspaceSyringeTemperature, StandardLiquidPreInjectionSyringeWash, StandardLiquidPreInjectionSyringeWashVolume, StandardLiquidPreInjectionSyringeWashRate, StandardLiquidPreInjectionNumberOfSolventWashes,
		StandardLiquidPreInjectionNumberOfSecondarySolventWashes, StandardLiquidPreInjectionNumberOfTertiarySolventWashes, StandardLiquidPreInjectionNumberOfQuaternarySolventWashes, StandardLiquidSampleWash, StandardNumberOfLiquidSampleWashes,
		StandardLiquidSampleWashVolume, StandardLiquidSampleFillingStrokes, StandardLiquidSampleFillingStrokesVolume, StandardLiquidFillingStrokeDelay, StandardHeadspaceSyringeFlushing,
		StandardHeadspacePreInjectionFlushTime, StandardSPMECondition, StandardSPMEConditioningTemperature, StandardSPMEPreConditioningTime, StandardSPMEDerivatizingAgent, StandardSPMEDerivatizingAgentAdsorptionTime,
		StandardSPMEDerivatizationPosition, StandardSPMEDerivatizationPositionOffset, StandardAgitateWhileSampling, StandardSampleVialAspirationPosition, StandardSampleVialAspirationPositionOffset,
		StandardSampleVialPenetrationRate, StandardInjectionVolume, StandardLiquidSampleOverAspirationVolume, StandardSampleAspirationRate, StandardSampleAspirationDelay, StandardSPMESampleExtractionTime,
		StandardInjectionInletPenetrationDepth, StandardInjectionInletPenetrationRate, StandardInjectionSignalMode, StandardPreInjectionTimeDelay, StandardSampleInjectionRate, StandardSPMESampleDesorptionTime,
		StandardPostInjectionTimeDelay, StandardLiquidPostInjectionSyringeWash, StandardLiquidPostInjectionSyringeWashVolume, StandardLiquidPostInjectionSyringeWashRate, StandardLiquidPostInjectionNumberOfSolventWashes,
		StandardLiquidPostInjectionNumberOfSecondarySolventWashes, StandardLiquidPostInjectionNumberOfTertiarySolventWashes, StandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
		StandardPostInjectionNextSamplePreparationSteps, StandardHeadspacePostInjectionFlushTime, StandardSPMEPostInjectionConditioningTime, StandardSeparationMethod, (*StandardInletMode, *)StandardInletSeptumPurgeFlowRate,
		StandardInitialInletTemperature, StandardInitialInletTemperatureDuration, StandardInletTemperatureProfile, StandardSplitRatio, StandardSplitVentFlowRate,
		StandardSplitlessTime, StandardInitialInletPressure, StandardInitialInletTime, StandardGasSaver, StandardGasSaverFlowRate, StandardGasSaverActivationTime, StandardSolventEliminationFlowRate,
		StandardInitialColumnFlowRate, StandardInitialColumnPressure, StandardInitialColumnAverageVelocity,
		StandardInitialColumnResidenceTime, StandardInitialColumnSetpointDuration, StandardColumnPressureProfile, StandardColumnFlowRateProfile, StandardOvenEquilibrationTime, StandardInitialOvenTemperature,
		StandardInitialOvenTemperatureDuration, StandardOvenTemperatureProfile, StandardPostRunOvenTemperature, StandardPostRunOvenTime, StandardPostRunFlowRate, StandardPostRunPressure, StandardFrequency};

	(* Check if any standard options are specified *)
	standardOptionSpecifiedBool = Map[MatchQ[Lookup[roundedGasChromatographyOptions, #], Except[ListableP[(Null | None | Automatic)]]]&, standardOptions];

	(* Figure out how far we need to expand standard options *)

	(* Count number of standards specified *)
	numberOfStandardsSpecified = Switch[
		Lookup[roundedGasChromatographyOptions, Standard],
		(Automatic | Null),
		0,
		ObjectP[{Model[Sample], Object[Sample]}],
		1,
		_List,
		Length[Lookup[roundedGasChromatographyOptions, Standard]]
	];

	(* Determine if any standards exist or will need to be resolved *)
	standardExistsQ = Or[Or @@ standardOptionSpecifiedBool, numberOfStandardsSpecified >= 1];

	(* Determine the maximum number of standards implied by the length of standard options *)
	maxStandardOptionLength = Max[
		MapThread[
			Function[
				{optionValue, option},
				(* we have to treat options that show up as lists differently *)
				If[!MatchQ[option, Alternatives[StandardInletTemperatureProfile, StandardColumnPressureProfile, StandardColumnFlowRateProfile, StandardOvenTemperatureProfile]],
					Length[
						If[
							MatchQ[optionValue, Except[Automatic | Null]],
							{optionValue},
							optionValue
						]
					],
					Length[
						Switch[optionValue,
							{{_Quantity..}..},
							{optionValue},
							Automatic | Null,
							optionValue,
							Except[Automatic | Null],
							ToList[optionValue]
						]
					]
				]
			],
			{Lookup[roundedGasChromatographyOptions, standardOptions], standardOptions}
		]
	];

	standardExpansionLength = Max[numberOfStandardsSpecified, maxStandardOptionLength];
	(* todo THROW AN ERROR IF MORE Standards OPTIONS THAN SPECIFIED Standards *)

	(* Create a list of Nulls qual to the length of the standards list, should come in handy later. *)
	expandedStandardNull = Switch[
		standardExpansionLength,
		0,
		{Null},
		GreaterP[0],
		PadRight[{},
			standardExpansionLength,
			Null
		]
	];

	(* Now expand the standard options. here we have to do a quick check to make sure that any singletons get expanded *)
	expandedStandardsAssociation = Association[
		Map[
			Function[option,
				Rule[
					option,
					Switch[
						standardExpansionLength,
						0,
						{Null},
						GreaterP[0],
						Which[
							(* if we have a zero length input (e.g. a naked symbol), a non-list, or a single profile input, expand it *)
							Or @@ {
								Length[Lookup[roundedGasChromatographyOptions, option]] == 0,
								!MatchQ[Lookup[roundedGasChromatographyOptions, option], _List],
								MatchQ[Lookup[roundedGasChromatographyOptions, option],
									Alternatives[
										(* 2-point profile (temperature, pressure, flow rate simplifid to wuantity, hopefully nothing gets caught here) *)
										{{_?(CompatibleUnitQ[#, Minute]&), _Quantity}..},
										(* 3-point profile *)
										{{_Quantity, _Quantity, _?(CompatibleUnitQ[#, Minute]&)}..}
									]
								]
							},
							ConstantArray[Lookup[roundedGasChromatographyOptions, option], standardExpansionLength],
							(* otherwise we have a list: *)
							True,
							Lookup[roundedGasChromatographyOptions, option]
						]
					]
				]
			],
			standardOptions
		]
	];

	{expandedStandardInletTemperatureProfile, expandedStandardColumnPressureProfile, expandedStandardColumnFlowRateProfile, expandedStandardOvenTemperatureProfile} = Map[
		Switch[
			#,
			Automatic,
			If[standardExpansionLength > 0,
				ConstantArray[#, standardExpansionLength],
				{Null}
			],
			_Symbol | {{_Quantity..}..},
			ConstantArray[#, Max[standardExpansionLength, 1]],
			{(_Symbol | {{_Quantity..}..})..}, (* e.g., {Automatic...} *)
			PadRight[#, Max[standardExpansionLength, Length[#]], Automatic]
		]&,
		{roundedStandardInletTemperatureProfile,
			roundedStandardColumnPressureProfile,
			roundedStandardColumnFlowRateProfile,
			roundedStandardOvenTemperatureProfile}
	];

	expandedStandards = Switch[
		Lookup[injectionTableGasChromatographyOptionsAssociation, Standard],
		ObjectP[{Model[Sample], Object[Sample]}],
		{Lookup[injectionTableGasChromatographyOptionsAssociation, Standard]},
		_List,
		PadRight[
			Lookup[injectionTableGasChromatographyOptionsAssociation, Standard],
			standardExpansionLength,
			Automatic
		]
	];

	blankOptions = {BlankAmount, BlankVial, BlankDilute, BlankDilutionSolventVolume, BlankSecondaryDilutionSolventVolume, BlankTertiaryDilutionSolventVolume, BlankAgitate, BlankAgitationTime,
		BlankAgitationTemperature, BlankAgitationMixRate, BlankAgitationOnTime, BlankAgitationOffTime, BlankVortex, BlankVortexMixRate, BlankVortexTime, BlankSamplingMethod,
		BlankHeadspaceSyringeTemperature, BlankLiquidPreInjectionSyringeWash, BlankLiquidPreInjectionSyringeWashVolume, BlankLiquidPreInjectionSyringeWashRate, BlankLiquidPreInjectionNumberOfSolventWashes,
		BlankLiquidPreInjectionNumberOfSecondarySolventWashes, BlankLiquidPreInjectionNumberOfTertiarySolventWashes, BlankLiquidPreInjectionNumberOfQuaternarySolventWashes, BlankLiquidSampleWash, BlankNumberOfLiquidSampleWashes,
		BlankLiquidSampleWashVolume, BlankLiquidSampleFillingStrokes, BlankLiquidSampleFillingStrokesVolume, BlankLiquidFillingStrokeDelay, BlankHeadspaceSyringeFlushing,
		BlankHeadspacePreInjectionFlushTime, BlankSPMECondition, BlankSPMEConditioningTemperature, BlankSPMEPreConditioningTime, BlankSPMEDerivatizingAgent, BlankSPMEDerivatizingAgentAdsorptionTime,
		BlankSPMEDerivatizationPosition, BlankSPMEDerivatizationPositionOffset, BlankAgitateWhileSampling, BlankSampleVialAspirationPosition, BlankSampleVialAspirationPositionOffset,
		BlankSampleVialPenetrationRate, BlankInjectionVolume, BlankLiquidSampleOverAspirationVolume, BlankSampleAspirationRate, BlankSampleAspirationDelay, BlankSPMESampleExtractionTime,
		BlankInjectionInletPenetrationDepth, BlankInjectionInletPenetrationRate, BlankInjectionSignalMode, BlankPreInjectionTimeDelay, BlankSampleInjectionRate, BlankSPMESampleDesorptionTime,
		BlankPostInjectionTimeDelay, BlankLiquidPostInjectionSyringeWash, BlankLiquidPostInjectionSyringeWashVolume, BlankLiquidPostInjectionSyringeWashRate, BlankLiquidPostInjectionNumberOfSolventWashes,
		BlankLiquidPostInjectionNumberOfSecondarySolventWashes, BlankLiquidPostInjectionNumberOfTertiarySolventWashes, BlankLiquidPostInjectionNumberOfQuaternarySolventWashes,
		BlankPostInjectionNextSamplePreparationSteps, BlankHeadspacePostInjectionFlushTime, BlankSPMEPostInjectionConditioningTime,
		BlankSeparationMethod, BlankInletSeptumPurgeFlowRate,
		BlankInitialInletTemperature, BlankInitialInletTemperatureDuration, BlankInletTemperatureProfile, BlankSplitRatio, BlankSplitVentFlowRate,
		BlankSplitlessTime, BlankInitialInletPressure, BlankInitialInletTime, BlankGasSaver, BlankGasSaverFlowRate, BlankGasSaverActivationTime, BlankSolventEliminationFlowRate,
		BlankInitialColumnFlowRate, BlankInitialColumnPressure, BlankInitialColumnAverageVelocity,
		BlankInitialColumnResidenceTime, BlankInitialColumnSetpointDuration, BlankColumnPressureProfile, BlankColumnFlowRateProfile, BlankOvenEquilibrationTime, BlankInitialOvenTemperature,
		BlankInitialOvenTemperatureDuration, BlankOvenTemperatureProfile, BlankPostRunOvenTemperature, BlankPostRunOvenTime, BlankPostRunFlowRate, BlankPostRunPressure, BlankFrequency};

	(* Check if any standard options are specified *)
	blankOptionSpecifiedBool = Map[MatchQ[Lookup[roundedGasChromatographyOptions, #], Except[ListableP[(Null | None | Automatic)]]]&, blankOptions];

	(* Figure out how far we need to expand standard options *)

	(* Count number of standards specified *)
	numberOfBlanksSpecified = Switch[
		Lookup[roundedGasChromatographyOptions, Blank],
		(Automatic | Null),
		0,
		(GCBlankTypeP | ObjectP[{Model[Sample], Object[Sample]}]),
		1,
		_List,
		Length[Lookup[roundedGasChromatographyOptions, Blank]]
	];

	(* Determine if any standards exist or will need to be resolved *)
	blankExistsQ = Or[Or @@ blankOptionSpecifiedBool, numberOfBlanksSpecified >= 1];

	(* Determine the maximum number of blanks implied by the length of blank options *)
	maxBlankOptionLength = Max[
		MapThread[
			Function[
				{optionValue, option},
				(* we have to treat options that show up as lists differently *)
				If[!MatchQ[option, Alternatives[BlankInletTemperatureProfile, BlankColumnPressureProfile, BlankColumnFlowRateProfile, BlankOvenTemperatureProfile]],
					Length[
						If[
							MatchQ[optionValue, Except[Automatic | Null]],
							{optionValue},
							optionValue
						]
					],
					Length[
						Switch[optionValue,
							{{_Quantity..}..},
							{optionValue},
							Automatic | Null,
							optionValue,
							Except[Automatic | Null],
							ToList[optionValue]
						]
					]
				]
			],
			{Lookup[roundedGasChromatographyOptions, blankOptions], blankOptions}
		]
	];

	blankExpansionLength = Max[numberOfBlanksSpecified, maxBlankOptionLength];

	(* todo THROW AN ERROR IF MORE BLANK OPTIONS THAN SPECIFIED BLANKS *)

	(* Create a list of Nulls equal to the length of the blanks list, should come in handy later. *)
	expandedBlankNull = Switch[
		blankExpansionLength,
		0,
		{Null},
		GreaterP[0],
		PadRight[{},
			blankExpansionLength,
			Null
		]
	];

	(* Now expand the blank options. here we have to do a quick check to make sure that any singletons get list-ified *)
	expandedBlanksAssociation = Association[
		Map[
			Function[option,
				Rule[
					option,
					Switch[
						blankExpansionLength,
						0,
						{Null},
						GreaterP[0],
						Which[
							(* if we have a zero length input (e.g. a naked symbol), a non-list, or a profile input, expand it *)
							Or @@ {
								Length[Lookup[roundedGasChromatographyOptions, option]] == 0,
								!MatchQ[Lookup[roundedGasChromatographyOptions, option], _List],
								MatchQ[Lookup[roundedGasChromatographyOptions, option],
									Alternatives[
										(* single 2-point profile (temperature, pressure, flow rate simplifid to wuantity, hopefully nothing gets caught here) *)
										{{_?(CompatibleUnitQ[#, Minute]&), _Quantity}..},
										(* single 3-point profile *)
										{{_Quantity, _Quantity, _?(CompatibleUnitQ[#, Minute]&)}..}
									]
								]
							},
							ConstantArray[Lookup[roundedGasChromatographyOptions, option], blankExpansionLength],
							(* check to make sure the already expanded option is the right length? *)
							(* otherwise we have a list: *)
							True,
							Lookup[roundedGasChromatographyOptions, option]
						]
					]
				]
			],
			blankOptions
		]
	];

	{expandedBlankInletTemperatureProfile, expandedBlankColumnPressureProfile, expandedBlankColumnFlowRateProfile, expandedBlankOvenTemperatureProfile} = Map[
		Switch[
			#,
			(* if we get Automatic or Null, we might be able to shrink to the Null list *)
			Automatic | Null,
			If[blankExpansionLength > 0,
				ConstantArray[#, blankExpansionLength],
				{Null}
			],
			(* with a singleton symbol or singleton profile, we either keep it and listify or expand so the floor is 1 *)
			_Symbol | {{_Quantity..}..},
			ConstantArray[#, Max[blankExpansionLength, 1]],
			(* otherwise if we have a list of symbols and/or profiles we just expand to the expandion length if it's longer than the specification. it shouldn't ever be shorter in this case *)
			{(_Symbol | {{_Quantity..}..})..}, (* e.g., {Automatic...} *)
			PadRight[#, Max[blankExpansionLength, Length[#]], Automatic]
		]&,
		{roundedBlankInletTemperatureProfile,
			roundedBlankColumnPressureProfile,
			roundedBlankColumnFlowRateProfile,
			roundedBlankOvenTemperatureProfile}
	];

	defaultStandard = Model[Sample, "Hexanes"];
	defaultBlank = NoInjection;

	(*call our shared helper in order to resolve common options related to the Standard and Blank*)
	{{resolvedStandardBlankOptions, invalidStandardBlankOptions}, invalidStandardBlankTests} = If[gatherTests,
		resolveChromatographyStandardsAndBlanks[mySamples, roundedGasChromatographyOptions, standardExistsQ, defaultStandard, blankExistsQ, defaultBlank, Output -> {Result, Tests}],
		{resolveChromatographyStandardsAndBlanks[mySamples, roundedGasChromatographyOptions, standardExistsQ, defaultStandard, blankExistsQ, defaultBlank], {}}
	];

	(* pull out the resolved frequency and pre-resolved (i.e., not necessarily expanded) standard and blank options *)
	{resolvedStandardFrequency, preResolvedStandard, resolvedBlankFrequency, preResolvedBlankWithPlaceholder} = Lookup[resolvedStandardBlankOptions, {StandardFrequency, Standard, BlankFrequency, Blank}];

	specifiedInjectionTable = Lookup[roundedGasChromatographyOptions, InjectionTable];

	(* injection table is in the form: {{Type, Sample, SamplingMethod, SamplePreparationOptions, SeparationMethod}...}
	but it should be in the form {{Type, Sample, InjectionVolume, {SamplingMethod, SamplePreparationOptions}, SeparationMethod}...}*)
	specifiedFakeInjectionTable = If[MatchQ[specifiedInjectionTable, _List],
		(* if the table was specified we gotta fake it, null out the injection volume *)
		Map[
			Function[tableEntry,
				{tableEntry[[1]], tableEntry[[2]], 10 * Microliter, {tableEntry[[3]], tableEntry[[4]]}, tableEntry[[5]]}
			],
			specifiedInjectionTable
		],
		(* otherwise it's automatic so just leave it alone *)
		specifiedInjectionTable
	];

	(* expand standards with automatic *)
	expandedStandards = Switch[
		preResolvedStandard,
		Null|{},
		Null,
		ObjectP[{Model[Sample], Object[Sample]}],
		PadRight[
			{preResolvedStandard},
			standardExpansionLength,
			defaultStandard
		],
		_List,
		PadRight[
			preResolvedStandard,
			standardExpansionLength,
			defaultStandard
		]
	];

	resolvedStandards = ToList[expandedStandards];

	injectionTableStandardInjectionVolumes = If[injectionTableSpecifiedQ,
		Cases[specifiedFakeInjectionTable, {Standard, _, injectionVolume_, _, _} :> injectionVolume],
		(*otherwise pad automatic*)
		ConstantArray[Null, Length[resolvedStandards]]
	];

	blankPrepOptions = {BlankAmount, BlankVial, BlankDilute, BlankDilutionSolventVolume, BlankSecondaryDilutionSolventVolume, BlankTertiaryDilutionSolventVolume, BlankAgitate, BlankAgitationTime,
		BlankAgitationTemperature, BlankAgitationMixRate, BlankAgitationOnTime, BlankAgitationOffTime, BlankVortex, BlankVortexMixRate, BlankVortexTime, BlankSamplingMethod,
		BlankHeadspaceSyringeTemperature, BlankLiquidPreInjectionSyringeWash, BlankLiquidPreInjectionSyringeWashVolume, BlankLiquidPreInjectionSyringeWashRate, BlankLiquidPreInjectionNumberOfSolventWashes,
		BlankLiquidPreInjectionNumberOfSecondarySolventWashes, BlankLiquidPreInjectionNumberOfTertiarySolventWashes, BlankLiquidPreInjectionNumberOfQuaternarySolventWashes, BlankNumberOfLiquidSampleWashes,
		BlankLiquidSampleWashVolume, BlankLiquidSampleFillingStrokes, BlankLiquidSampleFillingStrokesVolume, BlankLiquidFillingStrokeDelay, BlankHeadspaceSyringeFlushing,
		BlankHeadspacePreInjectionFlushTime, BlankSPMECondition, BlankSPMEConditioningTemperature, BlankSPMEPreConditioningTime, BlankSPMEDerivatizingAgent, BlankSPMEDerivatizingAgentAdsorptionTime,
		BlankSPMEDerivatizationPosition, BlankSPMEDerivatizationPositionOffset, BlankAgitateWhileSampling, BlankSampleVialAspirationPosition, BlankSampleVialAspirationPositionOffset,
		BlankSampleVialPenetrationRate, BlankInjectionVolume, BlankLiquidSampleOverAspirationVolume, BlankSampleAspirationRate, BlankSampleAspirationDelay, BlankSPMESampleExtractionTime,
		BlankInjectionInletPenetrationDepth, BlankInjectionInletPenetrationRate, BlankInjectionSignalMode, BlankPreInjectionTimeDelay, BlankSampleInjectionRate, BlankSPMESampleDesorptionTime,
		BlankPostInjectionTimeDelay, BlankLiquidPostInjectionSyringeWash, BlankLiquidPostInjectionSyringeWashVolume, BlankLiquidPostInjectionSyringeWashRate, BlankLiquidPostInjectionNumberOfSolventWashes,
		BlankLiquidPostInjectionNumberOfSecondarySolventWashes, BlankLiquidPostInjectionNumberOfTertiarySolventWashes, BlankLiquidPostInjectionNumberOfQuaternarySolventWashes,
		BlankPostInjectionNextSamplePreparationSteps, BlankHeadspacePostInjectionFlushTime, BlankSPMEPostInjectionConditioningTime};

	(* expand specified Blanks *)
	expandedBlanks = Switch[
		preResolvedBlankWithPlaceholder,
		Null|{},
		Null,
		ObjectP[{Model[Sample], Object[Sample]}] | NoInjection,
		PadRight[
			ToList@preResolvedBlankWithPlaceholder,
			blankExpansionLength,
			defaultBlank
		],
		_List,
		(* todo if the number of blanks and the expansion length is DIFFERENT, we need to throw a warning (error?) to indicate a length mismatch *)
		PadRight[
			preResolvedBlankWithPlaceholder,
			blankExpansionLength,
			defaultBlank
		]
	];

	(* expand the specified blanks with automatics so we know which if any were specified *)
	specifiedBlankWithAutomatics = PadRight[
		ToList@Lookup[roundedGasChromatographyOptions, Blank],
		blankExpansionLength,
		Automatic
	];

	(* we shouldn't expand the blanks unless they are set to automatic, right? *)

	(* If any sample preparation options are specified for blanks, replace those blanks with a sample unless the NoInjection type was explicitly specified *)
	resolvedBlanks = MapThread[
		Function[{specifiedBlank, expandedPreResolvedBlank, expandedPrepOps},
			(* only change the blank if it has been automatically resolved *)
			If[MatchQ[specifiedBlank, Automatic] && MemberQ[expandedPrepOps, Except[Automatic | Null]],
				defaultStandard,
				expandedPreResolvedBlank
			]
		],
		{specifiedBlankWithAutomatics /. {{} -> {Null}}, ToList@expandedBlanks, Transpose@Lookup[expandedBlanksAssociation, blankPrepOptions]}
	];

	(* now we'd like to error check the blanks to make sure that no prep ops are specified if the specified blank type is NoInjection *)
	invalidBlankPrepOpsQ = MapThread[
		Function[{specifiedBlank, expandedPrepOps},
			(* make sure no prep ops were specified if the blank is NoInjection *)
			MatchQ[specifiedBlank, NoInjection] && MemberQ[expandedPrepOps, Except[Automatic | Null]]
		],
		{specifiedBlankWithAutomatics /. {{} -> {Null}}, Transpose@Lookup[expandedBlanksAssociation, blankPrepOptions]}
	];

	(* if we have a red flag, we actually have to go into the preparation options and figure out which options are incorrectly specified *)
	invalidBlankPrepOptions = DeleteDuplicates[
		Flatten[
			(* if there were no failures reported skip this check *)
			If[!Or @@ invalidBlankPrepOpsQ,
				{},
				(* check out each blank *)
				MapThread[
					Function[{specifiedBlank, specifiedBlankOptions, badOpsQ},
						(* if we didn't find a failure in this blank then again skip the check *)
						If[!badOpsQ,
							{},
							(* otherwise we need to look at each option to see if it was specified *)
							MapThread[
								Function[{optionValue, optionName},
									If[MatchQ[optionValue, (Automatic | Null)],
										Nothing,
										optionName
									]
								],
								{specifiedBlankOptions, blankPrepOptions}
							]
						]
					],
					{specifiedBlankWithAutomatics /. {{} -> {Null}}, Transpose@Lookup[expandedBlanksAssociation, blankPrepOptions], invalidBlankPrepOpsQ}
				]
			]
		]
	];

	(* throw errors if appropriate *)
	If[!gatherTests && Length[invalidBlankPrepOptions] > 0,
		Message[Error::InvalidBlankSamplePreparationOptions, invalidBlankPrepOptions]
	];

	(* gather tests if applicable *)
	invalidBlankPrepOpsTest = If[gatherTests,
		Test["Blank sample preparation options are not specified for any Blank if the Blank is NoInjection:",
			Length[invalidBlankPrepOptions] > 0,
			False
		],
		{}
	];

	(* extract the injection volume from the injection table*)
	injectionTableBlankInjectionVolumes = If[injectionTableSpecifiedQ,
		Cases[specifiedFakeInjectionTable, {Blank, _, injectionVolume_, _, _} :> injectionVolume],
		(*otherwise pad automatic*)
		ConstantArray[Automatic, Length[resolvedBlanks]]
	];

	(* get the specified standards and blanks container and aliquot ops *)
	{specifiedStandardAmounts, specifiedStandardVials} = Lookup[expandedStandardsAssociation, {StandardAmount, StandardVial}];
	{specifiedBlankAmounts, specifiedBlankVials} = Lookup[expandedBlanksAssociation, {BlankAmount, BlankVial}];

	(* resolve whether we need to move specified standards and blanks around if they aren't already in compatible vials *)
	{aliquotStandardQ, aliquotBlankQ} = MapThread[
		Function[
			{samples, vials, amounts},
			MapThread[
				Function[
					{sample, vial, amount},
					Which[
						NullQ[sample] || MatchQ[sample, NoInjection],
						False,
						!MatchQ[vial, Null | Automatic] || !MatchQ[amount, Null | Automatic],
						True,
						True,
						Module[{footprint, neckType},
							(* get the relevant fields from the simulated cache *)
							{footprint, neckType} = If[!NullQ[sample] && !MatchQ[sample, NoInjection],
								Switch[
									sample,
									(* if the sample is an object, we need to download its container model's info *)
									ObjectP[Object[]],
									Download[
										Download[sample, Container[Model], Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
										{Footprint, NeckType},
										Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
									(* if the sample is a model, then i guess we assume it will have to be moved? nothing ships in a GC vial afaik *)
									ObjectP[Model[]],
									{Null, Null}
									(*Download[#,Container[{Footprint,NeckType}],Cache -> cache, Simulation -> updatedSimulation]*)
								],
								{Null, Null}
							];
							(* check if the container is compatible *)
							!MatchQ[
								{footprint, neckType},
								Alternatives[
									(* small GC vials *)
									{CEVial, "9/425"},
									(* larger headspace vials *)
									{HeadspaceVial, "18/425"}
								]
							]
						]
					]
				],
				(*!MatchQ[#,Alternatives@@compatibleGCVialModels]&*)
				{samples, vials, amounts}
			]
		],
		{
			{resolvedStandards, resolvedBlanks},
			{specifiedStandardVials, specifiedBlankVials},
			{specifiedStandardAmounts, specifiedBlankAmounts}
		}
	];

	(* if the blank type is NoInjection or Null, turn all the sample prep options for that blank off *)
	Map[
		Function[optionName,
			expandedBlanksAssociation[optionName] = MapThread[
				Switch[
					{#1, #2},
					{Automatic, NoInjection},
					Null,
					_,
					#1
				]&,
				{expandedBlanksAssociation[optionName], resolvedBlanks}
			]
		],
		blankPrepOptions
	];

	(* Pre-fill all the options in Standards and Blanks that would be set to default values but are instead Automatic *)
	MapThread[
		Function[
			{grouping, optionNames, optionDefaults},
			MapThread[
				Function[{optionName, default},
					Switch[
						grouping,
						Standard,
						If[MatchQ[expandedStandardsAssociation[optionName], {}],
							Nothing,
							expandedStandardsAssociation[optionName] = (expandedStandardsAssociation[optionName]) /. Rule[Automatic, default]
						],
						Blank,
						If[MatchQ[expandedBlanksAssociation[optionName], {}],
							Nothing,
							expandedBlanksAssociation[optionName] = (expandedBlanksAssociation[optionName]) /. Rule[Automatic, default]
						]
					]
				],
				{
					optionNames,
					optionDefaults
				}
			]
		],
		{
			{
				Standard,
				Blank
			},
			{
				{
					StandardSPMEDerivatizingAgent,
					StandardSampleVialAspirationPosition,
					StandardSampleVialPenetrationRate,
					StandardInjectionInletPenetrationDepth,
					StandardInjectionInletPenetrationRate,
					StandardInjectionSignalMode,
					StandardPreInjectionTimeDelay,
					StandardPostInjectionTimeDelay,
					StandardSeparationMethod
				},
				{
					BlankSPMEDerivatizingAgent,
					BlankSampleVialAspirationPosition,
					BlankSampleVialPenetrationRate,
					BlankInjectionInletPenetrationDepth,
					BlankInjectionInletPenetrationRate,
					BlankInjectionSignalMode,
					BlankPreInjectionTimeDelay,
					BlankPostInjectionTimeDelay,
					BlankSeparationMethod
				}
			},
			{
				{
					Null,
					Top,
					20 * Millimeter / Second,
					40 * Millimeter,
					75 * Millimeter / Second,
					PlungerDown,
					Null,
					Null,
					Null
				},
				{
					Null,
					Top,
					20 * Millimeter / Second,
					40 * Millimeter,
					75 * Millimeter / Second,
					PlungerDown,
					Null,
					Null,
					Null
				}
			}
		}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* Get the column temperature limits *)
	columnModelPacket = fetchPacketFromCache[#, cache]& /@ columnModel;
	minColumnTempLimit = Max[Lookup[columnModelPacket, MinTemperature]];
	maxColumnTempLimit = Min[Lookup[columnModelPacket, MaxTemperature]];

	(* get all the GC method stuff that's specified *)

	(* get the specified GC methods *)
	{specifiedSeparationMethods, specifiedStandardSeparationMethods, specifiedBlankSeparationMethods} = {Lookup[roundedGasChromatographyOptions, SeparationMethod], Lookup[expandedStandardsAssociation, StandardSeparationMethod], Lookup[expandedBlanksAssociation, BlankSeparationMethod]};

	(* figure out if the user specified a method with an object and get the values in each specified object *)
	{
		{separationMethodSpecifiedQ, specifiedSeparationMethodParameters},
		{standardSeparationMethodSpecifiedQ, specifiedStandardSeparationMethodParameters},
		{blankSeparationMethodSpecifiedQ, specifiedBlankSeparationMethodParameters}
	} = Map[
		Function[{methodsList},
			Transpose@Map[
				Function[{separationMethod},
					If[MatchQ[separationMethod, ObjectP[Object[Method, GasChromatography]]],
						{
							True,
							Lookup[
								fetchPacketFromCache[separationMethod, cache],
								{
									ColumnLength,
									ColumnDiameter,
									ColumnFilmThickness,
									InletLinerVolume,
									Detector,
									CarrierGas,
									InletSeptumPurgeFlowRate,
									InitialInletTemperature,
									InitialInletTemperatureDuration,
									InletTemperatureProfile,
									SplitRatio,
									SplitVentFlowRate,
									SplitlessTime,
									InitialInletPressure,
									InitialInletTime,
									GasSaver,
									GasSaverFlowRate,
									GasSaverActivationTime,
									SolventEliminationFlowRate,
									InitialColumnFlowRate,
									InitialColumnPressure,
									InitialColumnAverageVelocity,
									InitialColumnResidenceTime,
									InitialColumnSetpointDuration,
									ColumnPressureProfile,
									ColumnFlowRateProfile,
									OvenEquilibrationTime,
									InitialOvenTemperature,
									InitialOvenTemperatureDuration,
									OvenTemperatureProfile,
									PostRunOvenTemperature,
									PostRunOvenTime,
									PostRunFlowRate,
									PostRunPressure
								}
							]
						},
						(* Keep an eye on that padright number if changing anything in the method, especially during QA updates because it will change *)
						{False, PadRight[{}, 34, Null]}
					]
				],
				methodsList
			]
		],
		{specifiedSeparationMethods, specifiedStandardSeparationMethods, specifiedBlankSeparationMethods}
	];

	(* turn these into method specified values, that is, if a separation method has been specified, swap out the value in the method for the value in the method object. *)

	(* if throwing errors, determine if any of the methods were designed for column(s) with different length, diameter, film thickness, inlet liner volume etc. and throw
	 a warning to let the user know that their separation may perform differently with the different column*)

	(* turn the separationMethod specified parameters into lists of each option index-matched *)
	{
		{
			separationMethodColumnLengths,
			separationMethodColumnDiameters,
			separationMethodColumnFilmThicknesses,
			separationMethodInletLinerVolumes,
			separationMethodDetectors,
			separationMethodCarrierGases,
			separationMethodInletSeptumPurgeFlowRates,
			separationMethodInitialInletTemperatures,
			separationMethodInitialInletTemperatureDurations,
			separationMethodInletTemperatureProfiles, (*
			separationMethodInletModes,*)
			separationMethodSplitRatios,
			separationMethodSplitVentFlowRates,
			separationMethodSplitlessTimes,
			separationMethodInitialInletPressures,
			separationMethodInitialInletTimes,
			separationMethodGasSavers,
			separationMethodGasSaverFlowRates,
			separationMethodGasSaverActivationTimes,
			separationMethodSolventEliminationFlowRates,
			separationMethodInitialColumnFlowRates,
			separationMethodInitialColumnPressures,
			separationMethodInitialColumnAverageVelocities,
			separationMethodInitialColumnResidenceTimes,
			separationMethodInitialColumnSetpointDurations,
			separationMethodColumnPressureProfiles,
			separationMethodColumnFlowRateProfiles,
			separationMethodOvenEquilibrationTimes,
			separationMethodInitialOvenTemperatures,
			separationMethodInitialOvenTemperatureDurations,
			separationMethodOvenTemperatureProfiles,
			separationMethodPostRunOvenTemperatures,
			separationMethodPostRunOvenTimes,
			separationMethodPostRunFlowRates,
			separationMethodPostRunPressures
		},
		{
			separationMethodStandardColumnLengths,
			separationMethodStandardColumnDiameters,
			separationMethodStandardColumnFilmThicknesses,
			separationMethodStandardInletLinerVolumes,
			separationMethodStandardDetectors,
			separationMethodStandardCarrierGases,
			separationMethodStandardInletSeptumPurgeFlowRates,
			separationMethodStandardInitialInletTemperatures,
			separationMethodStandardInitialInletTemperatureDurations,
			separationMethodStandardInletTemperatureProfiles, (*
			separationMethodStandardInletModes,*)
			separationMethodStandardSplitRatios,
			separationMethodStandardSplitVentFlowRates,
			separationMethodStandardSplitlessTimes,
			separationMethodStandardInitialInletPressures,
			separationMethodStandardInitialInletTimes,
			separationMethodStandardGasSavers,
			separationMethodStandardGasSaverFlowRates,
			separationMethodStandardGasSaverActivationTimes,
			separationMethodStandardSolventEliminationFlowRates,
			separationMethodStandardInitialColumnFlowRates,
			separationMethodStandardInitialColumnPressures,
			separationMethodStandardInitialColumnAverageVelocities,
			separationMethodStandardInitialColumnResidenceTimes,
			separationMethodStandardInitialColumnSetpointDurations,
			separationMethodStandardColumnPressureProfiles,
			separationMethodStandardColumnFlowRateProfiles,
			separationMethodStandardOvenEquilibrationTimes,
			separationMethodStandardInitialOvenTemperatures,
			separationMethodStandardInitialOvenTemperatureDurations,
			separationMethodStandardOvenTemperatureProfiles,
			separationMethodStandardPostRunOvenTemperatures,
			separationMethodStandardPostRunOvenTimes,
			separationMethodStandardPostRunFlowRates,
			separationMethodStandardPostRunPressures
		},
		{
			separationMethodBlankColumnLengths,
			separationMethodBlankColumnDiameters,
			separationMethodBlankColumnFilmThicknesses,
			separationMethodBlankInletLinerVolumes,
			separationMethodBlankDetectors,
			separationMethodBlankCarrierGases,
			separationMethodBlankInletSeptumPurgeFlowRates,
			separationMethodBlankInitialInletTemperatures,
			separationMethodBlankInitialInletTemperatureDurations,
			separationMethodBlankInletTemperatureProfiles, (*
			separationMethodBlankInletModes,*)
			separationMethodBlankSplitRatios,
			separationMethodBlankSplitVentFlowRates,
			separationMethodBlankSplitlessTimes,
			separationMethodBlankInitialInletPressures,
			separationMethodBlankInitialInletTimes,
			separationMethodBlankGasSavers,
			separationMethodBlankGasSaverFlowRates,
			separationMethodBlankGasSaverActivationTimes,
			separationMethodBlankSolventEliminationFlowRates,
			separationMethodBlankInitialColumnFlowRates,
			separationMethodBlankInitialColumnPressures,
			separationMethodBlankInitialColumnAverageVelocities,
			separationMethodBlankInitialColumnResidenceTimes,
			separationMethodBlankInitialColumnSetpointDurations,
			separationMethodBlankColumnPressureProfiles,
			separationMethodBlankColumnFlowRateProfiles,
			separationMethodBlankOvenEquilibrationTimes,
			separationMethodBlankInitialOvenTemperatures,
			separationMethodBlankInitialOvenTemperatureDurations,
			separationMethodBlankOvenTemperatureProfiles,
			separationMethodBlankPostRunOvenTemperatures,
			separationMethodBlankPostRunOvenTimes,
			separationMethodBlankPostRunFlowRates,
			separationMethodBlankPostRunPressures
		}
	} = Transpose /@ {specifiedSeparationMethodParameters,
		specifiedStandardSeparationMethodParameters,
		specifiedBlankSeparationMethodParameters};

	(* Pull in all options specified in the separation method object *)



	(* Get the specified InletMode of each sample *)(*
	prespecifiedInletModes = Lookup[roundedGasChromatographyOptions,InletMode];
	prespecifiedStandardInletModes = Lookup[expandedStandardsAssociation,StandardInletMode];
	prespecifiedBlankInletModes = Lookup[expandedBlanksAssociation,BlankInletMode];*)

	(* Inlet parameters *)
	{prespecifiedInitialInletTemperatures, prespecifiedInitialInletTemperatureDurations} = Lookup[roundedGasChromatographyOptions, {InitialInletTemperature, InitialInletTemperatureDuration}];
	{prespecifiedStandardInitialInletTemperatures, prespecifiedStandardInitialInletTemperatureDurations} = Lookup[expandedStandardsAssociation, {StandardInitialInletTemperature, StandardInitialInletTemperatureDuration}];
	{prespecifiedBlankInitialInletTemperatures, prespecifiedBlankInitialInletTemperatureDurations} = Lookup[expandedBlanksAssociation, {BlankInitialInletTemperature, BlankInitialInletTemperatureDuration}];

	{prespecifiedInletTemperatureProfiles, prespecifiedStandardInletTemperatureProfiles, prespecifiedBlankInletTemperatureProfiles} = {roundedInletTemperatureProfile, expandedStandardInletTemperatureProfile, expandedBlankInletTemperatureProfile};

	(* Inlet mode parameters *)
	{
		prespecifiedSplitRatios,
		prespecifiedSplitVentFlowRates,
		prespecifiedSplitlessTimes,
		prespecifiedInitialInletPressures,
		prespecifiedInitialInletTimes,
		prespecifiedSolventEliminationFlowRates
	} = Lookup[roundedGasChromatographyOptions,
		{
			SplitRatio,
			SplitVentFlowRate,
			SplitlessTime,
			InitialInletPressure,
			InitialInletTime,
			SolventEliminationFlowRate
		}
	];

	{
		prespecifiedStandardSplitRatios,
		prespecifiedStandardSplitVentFlowRates,
		prespecifiedStandardSplitlessTimes,
		prespecifiedStandardInitialInletPressures,
		prespecifiedStandardInitialInletTimes,
		prespecifiedStandardSolventEliminationFlowRates
	} = Lookup[expandedStandardsAssociation,
		{
			StandardSplitRatio,
			StandardSplitVentFlowRate,
			StandardSplitlessTime,
			StandardInitialInletPressure,
			StandardInitialInletTime,
			StandardSolventEliminationFlowRate
		}
	];

	{
		prespecifiedBlankSplitRatios,
		prespecifiedBlankSplitVentFlowRates,
		prespecifiedBlankSplitlessTimes,
		prespecifiedBlankInitialInletPressures,
		prespecifiedBlankInitialInletTimes,
		prespecifiedBlankSolventEliminationFlowRates
	} = Lookup[expandedBlanksAssociation,
		{
			BlankSplitRatio,
			BlankSplitVentFlowRate,
			BlankSplitlessTime,
			BlankInitialInletPressure,
			BlankInitialInletTime,
			BlankSolventEliminationFlowRate
		}
	];

	(* Get the specified gas saver option values *)
	{prespecifiedGasSavers, prespecifiedGasSaverFlowRates, prespecifiedGasSaverActivationTimes} = Lookup[roundedGasChromatographyOptions, {GasSaver, GasSaverFlowRate, GasSaverActivationTime}];
	{prespecifiedStandardGasSavers, prespecifiedStandardGasSaverFlowRates, prespecifiedStandardGasSaverActivationTimes} = Lookup[expandedStandardsAssociation, {StandardGasSaver, StandardGasSaverFlowRate, StandardGasSaverActivationTime}];
	{prespecifiedBlankGasSavers, prespecifiedBlankGasSaverFlowRates, prespecifiedBlankGasSaverActivationTimes} = Lookup[expandedBlanksAssociation, {BlankGasSaver, BlankGasSaverFlowRate, BlankGasSaverActivationTime}];

	{
		prespecifiedInitialColumnFlowRates,
		prespecifiedInitialColumnPressures,
		prespecifiedInitialColumnAverageVelocities,
		prespecifiedInitialColumnResidenceTimes,
		prespecifiedInitialColumnSetpointDurations
	} = Lookup[roundedGasChromatographyOptions, {InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime, InitialColumnSetpointDuration}];
	{
		prespecifiedStandardInitialColumnFlowRates,
		prespecifiedStandardInitialColumnPressures,
		prespecifiedStandardInitialColumnAverageVelocities,
		prespecifiedStandardInitialColumnResidenceTimes,
		prespecifiedStandardInitialColumnSetpointDurations
	} = Lookup[expandedStandardsAssociation, {StandardInitialColumnFlowRate, StandardInitialColumnPressure, StandardInitialColumnAverageVelocity, StandardInitialColumnResidenceTime, StandardInitialColumnSetpointDuration}];
	{
		prespecifiedBlankInitialColumnFlowRates,
		prespecifiedBlankInitialColumnPressures,
		prespecifiedBlankInitialColumnAverageVelocities,
		prespecifiedBlankInitialColumnResidenceTimes,
		prespecifiedBlankInitialColumnSetpointDurations
	} = Lookup[expandedBlanksAssociation, {BlankInitialColumnFlowRate, BlankInitialColumnPressure, BlankInitialColumnAverageVelocity, BlankInitialColumnResidenceTime, BlankInitialColumnSetpointDuration}];

	{prespecifiedColumnPressureProfiles, prespecifiedColumnFlowRateProfiles} = {roundedColumnPressureProfile, roundedColumnFlowRateProfile};
	{prespecifiedStandardColumnPressureProfiles, prespecifiedStandardColumnFlowRateProfiles} = {expandedStandardColumnPressureProfile, expandedStandardColumnFlowRateProfile};
	{prespecifiedBlankColumnPressureProfiles, prespecifiedBlankColumnFlowRateProfiles} = {expandedBlankColumnPressureProfile, expandedBlankColumnFlowRateProfile};

	specifiedCarrierGas = Lookup[roundedGasChromatographyOptions, CarrierGas];
	columnReferencePressure = 1.031 * Atmosphere;
	columnReferenceTemperature = 301.1 * Kelvin;
	specifiedDetector = Lookup[roundedGasChromatographyOptions, Detector];
	expectedOutletPressure = Switch[
		specifiedDetector,
		MassSpectrometer,
		0 * PSI,
		FlameIonizationDetector,
		14.7 * PSI,
		_,
		14.7 * PSI
	];

	(* Get column parameters *)
	{columnLength, columnPolarity, columnFilmThickness, columnDiameter} = Transpose[Lookup[#, {ColumnLength, Polarity, FilmThickness, Diameter}]& /@ columnModelPacket];

	(* Get the specified PostRunOvenTemperatures and InitialOvenTemperatures *)
	{
		{prespecifiedPostRunOvenTemperatures, prespecifiedInitialOvenTemperatures},
		{prespecifiedStandardPostRunOvenTemperatures, prespecifiedStandardInitialOvenTemperatures},
		{prespecifiedBlankPostRunOvenTemperatures, prespecifiedBlankInitialOvenTemperatures}
	} = {
		Lookup[roundedGasChromatographyOptions, {PostRunOvenTemperature, InitialOvenTemperature}],
		Lookup[expandedStandardsAssociation, {StandardPostRunOvenTemperature, StandardInitialOvenTemperature}],
		Lookup[expandedBlanksAssociation, {BlankPostRunOvenTemperature, BlankInitialOvenTemperature}]
	};

	(* Get OvenEquilibrationTimes *)
	{prespecifiedOvenEquilibrationTimes, prespecifiedStandardOvenEquilibrationTimes, prespecifiedBlankOvenEquilibrationTimes} = {Lookup[roundedGasChromatographyOptions, OvenEquilibrationTime], Lookup[expandedStandardsAssociation, StandardOvenEquilibrationTime], Lookup[expandedBlanksAssociation, BlankOvenEquilibrationTime]};

	(* Get the specified OvenTemperatureProfiles *)
	{prespecifiedOvenTemperatureProfiles, prespecifiedStandardOvenTemperatureProfiles, prespecifiedBlankOvenTemperatureProfiles} = {roundedOvenTemperatureProfile, expandedStandardOvenTemperatureProfile, expandedBlankOvenTemperatureProfile};

	(* Get some defaulted parameters first and resolve because they are easy *)
	{prespecifiedInletSeptumPurgeFlowRates, prespecifiedInitialOvenTemperatureDurations, prespecifiedPostRunOvenTimes, prespecifiedPostRunFlowRates, prespecifiedPostRunPressures} = Lookup[roundedGasChromatographyOptions, {InletSeptumPurgeFlowRate, InitialOvenTemperatureDuration, PostRunOvenTime, PostRunFlowRate, PostRunPressure}];
	{prespecifiedStandardInletSeptumPurgeFlowRates, prespecifiedStandardInitialOvenTemperatureDurations, prespecifiedStandardPostRunOvenTimes, prespecifiedStandardPostRunFlowRates, prespecifiedStandardPostRunPressures} = Lookup[expandedStandardsAssociation, {StandardInletSeptumPurgeFlowRate, StandardInitialOvenTemperatureDuration, StandardPostRunOvenTime, StandardPostRunFlowRate, StandardPostRunPressure}];
	{prespecifiedBlankInletSeptumPurgeFlowRates, prespecifiedBlankInitialOvenTemperatureDurations, prespecifiedBlankPostRunOvenTimes, prespecifiedBlankPostRunFlowRates, prespecifiedBlankPostRunPressures} = Lookup[expandedBlanksAssociation, {BlankInletSeptumPurgeFlowRate, BlankInitialOvenTemperatureDuration, BlankPostRunOvenTime, BlankPostRunFlowRate, BlankPostRunPressure}];

	(* Turn these to either their defaults or the values set by the separation methods, with separation mode values taking precedence *)
	{
		{
			specifiedInletSeptumPurgeFlowRates,
			specifiedInitialOvenTemperatures,
			specifiedInitialOvenTemperatureDurations,
			specifiedPostRunOvenTimes,
			specifiedPostRunFlowRates,
			specifiedPostRunPressures,
			specifiedOvenEquilibrationTimes
		},
		{
			specifiedStandardInletSeptumPurgeFlowRates,
			specifiedStandardInitialOvenTemperatures,
			specifiedStandardInitialOvenTemperatureDurations,
			specifiedStandardPostRunOvenTimes,
			specifiedStandardPostRunFlowRates,
			specifiedStandardPostRunPressures,
			specifiedStandardOvenEquilibrationTimes
		},
		{
			specifiedBlankInletSeptumPurgeFlowRates,
			specifiedBlankInitialOvenTemperatures,
			specifiedBlankInitialOvenTemperatureDurations,
			specifiedBlankPostRunOvenTimes,
			specifiedBlankPostRunFlowRates,
			specifiedBlankPostRunPressures,
			specifiedBlankOvenEquilibrationTimes
		}
	} = MapThread[
		Function[{optionSet, methodSpecifiedQList},
			MapThread[
				Function[{specifiedParameterList, separationMethodParameterList, parameterDefault},
					MapThread[
						Function[{parameter, methodSpecifiedParameter, methodSpecifiedQ},
							Switch[
								{parameter, methodSpecifiedQ},
								{Except[Automatic], _},
								parameter,
								{Automatic, False},
								parameterDefault,
								{Automatic, True},
								methodSpecifiedParameter
							]
						],
						(* this separationMethodSpecified needs to be split between sample, standard, and blank *)
						{specifiedParameterList, separationMethodParameterList, methodSpecifiedQList}
					]
				],
				optionSet
			]
		],
		{
			Transpose@{
				{
					{
						prespecifiedInletSeptumPurgeFlowRates,
						prespecifiedInitialOvenTemperatures,
						prespecifiedInitialOvenTemperatureDurations,
						prespecifiedPostRunOvenTimes,
						prespecifiedPostRunFlowRates,
						prespecifiedPostRunPressures,
						prespecifiedOvenEquilibrationTimes
					},
					{
						prespecifiedStandardInletSeptumPurgeFlowRates,
						prespecifiedStandardInitialOvenTemperatures,
						prespecifiedStandardInitialOvenTemperatureDurations,
						prespecifiedStandardPostRunOvenTimes,
						prespecifiedStandardPostRunFlowRates,
						prespecifiedStandardPostRunPressures,
						prespecifiedStandardOvenEquilibrationTimes
					},
					{
						prespecifiedBlankInletSeptumPurgeFlowRates,
						prespecifiedBlankInitialOvenTemperatures,
						prespecifiedBlankInitialOvenTemperatureDurations,
						prespecifiedBlankPostRunOvenTimes,
						prespecifiedBlankPostRunFlowRates,
						prespecifiedBlankPostRunPressures,
						prespecifiedBlankOvenEquilibrationTimes
					}
				},
				{
					{
						separationMethodInletSeptumPurgeFlowRates,
						separationMethodInitialOvenTemperatures,
						separationMethodInitialOvenTemperatureDurations,
						separationMethodPostRunOvenTimes,
						separationMethodPostRunFlowRates,
						separationMethodPostRunPressures,
						separationMethodOvenEquilibrationTimes
					},
					{
						separationMethodStandardInletSeptumPurgeFlowRates,
						separationMethodStandardInitialOvenTemperatures,
						separationMethodStandardInitialOvenTemperatureDurations,
						separationMethodStandardPostRunOvenTimes,
						separationMethodStandardPostRunFlowRates,
						separationMethodStandardPostRunPressures,
						separationMethodStandardOvenEquilibrationTimes
					},
					{
						separationMethodBlankInletSeptumPurgeFlowRates,
						separationMethodBlankInitialOvenTemperatures,
						separationMethodBlankInitialOvenTemperatureDurations,
						separationMethodBlankPostRunOvenTimes,
						separationMethodBlankPostRunFlowRates,
						separationMethodBlankPostRunPressures,
						separationMethodBlankOvenEquilibrationTimes
					}
				},
				PadRight[{}, 3,
					{
						{
							3 * Milliliter / Minute,
							50 * Celsius,
							3 * Minute,
							Automatic,
							Automatic,
							Automatic,
							2 * Minute
						}
					}
				]
			},
			{separationMethodSpecifiedQ, standardSeparationMethodSpecifiedQ, blankSeparationMethodSpecifiedQ}
		}
	];

	(* do the same for the new profile options *)

	(* every other separation mode option should already default to automatic, so we can do a simpler version of this for those separation *)

	(* group the directly specified options for later readability *)
	{prespecifiedSeparationModeOptions, prespecifiedStandardSeparationModeOptions, prespecifiedBlankSeparationModeOptions} = {
		{
			prespecifiedInitialInletTemperatures,
			prespecifiedInitialInletTemperatureDurations,
			prespecifiedInletTemperatureProfiles, (*
			prespecifiedInletModes,*)
			prespecifiedSplitRatios,
			prespecifiedSplitVentFlowRates,
			prespecifiedSplitlessTimes,
			prespecifiedInitialInletPressures,
			prespecifiedInitialInletTimes,
			prespecifiedGasSavers,
			prespecifiedGasSaverFlowRates,
			prespecifiedGasSaverActivationTimes,
			prespecifiedSolventEliminationFlowRates,
			prespecifiedInitialColumnFlowRates,
			prespecifiedInitialColumnPressures,
			prespecifiedInitialColumnAverageVelocities,
			prespecifiedInitialColumnResidenceTimes,
			prespecifiedInitialColumnSetpointDurations,
			prespecifiedColumnPressureProfiles,
			prespecifiedColumnFlowRateProfiles,
			prespecifiedOvenTemperatureProfiles,
			prespecifiedPostRunOvenTemperatures
		},
		{
			prespecifiedStandardInitialInletTemperatures,
			prespecifiedStandardInitialInletTemperatureDurations,
			prespecifiedStandardInletTemperatureProfiles, (*
			prespecifiedStandardInletModes,*)
			prespecifiedStandardSplitRatios,
			prespecifiedStandardSplitVentFlowRates,
			prespecifiedStandardSplitlessTimes,
			prespecifiedStandardInitialInletPressures,
			prespecifiedStandardInitialInletTimes,
			prespecifiedStandardGasSavers,
			prespecifiedStandardGasSaverFlowRates,
			prespecifiedStandardGasSaverActivationTimes,
			prespecifiedStandardSolventEliminationFlowRates,
			prespecifiedStandardInitialColumnFlowRates,
			prespecifiedStandardInitialColumnPressures,
			prespecifiedStandardInitialColumnAverageVelocities,
			prespecifiedStandardInitialColumnResidenceTimes,
			prespecifiedStandardInitialColumnSetpointDurations,
			prespecifiedStandardColumnPressureProfiles,
			prespecifiedStandardColumnFlowRateProfiles,
			prespecifiedStandardOvenTemperatureProfiles,
			prespecifiedStandardPostRunOvenTemperatures
		},
		{
			prespecifiedBlankInitialInletTemperatures,
			prespecifiedBlankInitialInletTemperatureDurations,
			prespecifiedBlankInletTemperatureProfiles, (*
			prespecifiedBlankInletModes,*)
			prespecifiedBlankSplitRatios,
			prespecifiedBlankSplitVentFlowRates,
			prespecifiedBlankSplitlessTimes,
			prespecifiedBlankInitialInletPressures,
			prespecifiedBlankInitialInletTimes,
			prespecifiedBlankGasSavers,
			prespecifiedBlankGasSaverFlowRates,
			prespecifiedBlankGasSaverActivationTimes,
			prespecifiedBlankSolventEliminationFlowRates,
			prespecifiedBlankInitialColumnFlowRates,
			prespecifiedBlankInitialColumnPressures,
			prespecifiedBlankInitialColumnAverageVelocities,
			prespecifiedBlankInitialColumnResidenceTimes,
			prespecifiedBlankInitialColumnSetpointDurations,
			prespecifiedBlankColumnPressureProfiles,
			prespecifiedBlankColumnFlowRateProfiles,
			prespecifiedBlankOvenTemperatureProfiles,
			prespecifiedBlankPostRunOvenTemperatures
		}
	};

	(* group the options taken from the separation mode for later readability *)
	{separationMethodSeparationModeOptions, separationMethodStandardSeparationModeOptions, separationMethodBlankSeparationModeOptions} = {
		{
			separationMethodInitialInletTemperatures,
			separationMethodInitialInletTemperatureDurations,
			separationMethodInletTemperatureProfiles, (*
			separationMethodInletModes,*)
			separationMethodSplitRatios,
			separationMethodSplitVentFlowRates,
			separationMethodSplitlessTimes,
			separationMethodInitialInletPressures,
			separationMethodInitialInletTimes,
			separationMethodGasSavers,
			separationMethodGasSaverFlowRates,
			separationMethodGasSaverActivationTimes,
			separationMethodSolventEliminationFlowRates,
			separationMethodInitialColumnFlowRates,
			separationMethodInitialColumnPressures,
			separationMethodInitialColumnAverageVelocities,
			separationMethodInitialColumnResidenceTimes,
			separationMethodInitialColumnSetpointDurations,
			separationMethodColumnPressureProfiles,
			separationMethodColumnFlowRateProfiles,
			separationMethodOvenTemperatureProfiles,
			separationMethodPostRunOvenTemperatures
		},
		{
			separationMethodStandardInitialInletTemperatures,
			separationMethodStandardInitialInletTemperatureDurations,
			separationMethodStandardInletTemperatureProfiles, (*
			separationMethodStandardInletModes,*)
			separationMethodStandardSplitRatios,
			separationMethodStandardSplitVentFlowRates,
			separationMethodStandardSplitlessTimes,
			separationMethodStandardInitialInletPressures,
			separationMethodStandardInitialInletTimes,
			separationMethodStandardGasSavers,
			separationMethodStandardGasSaverFlowRates,
			separationMethodStandardGasSaverActivationTimes,
			separationMethodStandardSolventEliminationFlowRates,
			separationMethodStandardInitialColumnFlowRates,
			separationMethodStandardInitialColumnPressures,
			separationMethodStandardInitialColumnAverageVelocities,
			separationMethodStandardInitialColumnResidenceTimes,
			separationMethodStandardInitialColumnSetpointDurations,
			separationMethodStandardColumnPressureProfiles,
			separationMethodStandardColumnFlowRateProfiles,
			separationMethodStandardOvenTemperatureProfiles,
			separationMethodStandardPostRunOvenTemperatures
		},
		{
			separationMethodBlankInitialInletTemperatures,
			separationMethodBlankInitialInletTemperatureDurations,
			separationMethodBlankInletTemperatureProfiles, (*
			separationMethodBlankInletModes,*)
			separationMethodBlankSplitRatios,
			separationMethodBlankSplitVentFlowRates,
			separationMethodBlankSplitlessTimes,
			separationMethodBlankInitialInletPressures,
			separationMethodBlankInitialInletTimes,
			separationMethodBlankGasSavers,
			separationMethodBlankGasSaverFlowRates,
			separationMethodBlankGasSaverActivationTimes,
			separationMethodBlankSolventEliminationFlowRates,
			separationMethodBlankInitialColumnFlowRates,
			separationMethodBlankInitialColumnPressures,
			separationMethodBlankInitialColumnAverageVelocities,
			separationMethodBlankInitialColumnResidenceTimes,
			separationMethodBlankInitialColumnSetpointDurations,
			separationMethodBlankColumnPressureProfiles,
			separationMethodBlankColumnFlowRateProfiles,
			separationMethodBlankOvenTemperatureProfiles,
			separationMethodBlankPostRunOvenTemperatures
		}
	};
	recalculateOptionsQ[prespecifiedSeparationModeOptions_, separationMethodSeparationModeOptions_] := Module[{variableMethodOptions,booleanList,recalculate,boolean},
		(*These are the method options that vary depending on the other input method options*)
		variableMethodOptions = Transpose[{prespecifiedSeparationModeOptions[[{13,14,15,16}]],separationMethodSeparationModeOptions[[{13,14,15,16}]]}];
		booleanList = Transpose[Map[MapThread[Function[{prespecifiedSeparationModeOption,separationMethodSeparationModeOption},
			Which[
				MatchQ[separationMethodSeparationModeOption,Null],False,
				MatchQ[{prespecifiedSeparationModeOption,separationMethodSeparationModeOption},{Automatic,_}],False,
				MatchQ[prespecifiedSeparationModeOption,separationMethodSeparationModeOption], False,
				!MatchQ[prespecifiedSeparationModeOption,separationMethodSeparationModeOption], True]],#]&,variableMethodOptions]];
		boolean=Or@@#&/@booleanList;
		Map[PadRight[PadLeft[Table[#,4],16,False],21,False]&,boolean]
	];

	{
		recalculateSampleMethodOptions,
		recalculateStandardMethodOptions,
		recalculateBlankMethodOptions
	} =	MapThread[Function[{specifiedOptionSet, methodSpecifiedOptionSet}, recalculateOptionsQ[specifiedOptionSet,methodSpecifiedOptionSet]],
		{
			{
				prespecifiedSeparationModeOptions,
				prespecifiedStandardSeparationModeOptions,
				prespecifiedBlankSeparationModeOptions
			},
			{
				separationMethodSeparationModeOptions,
				separationMethodStandardSeparationModeOptions,
				separationMethodBlankSeparationModeOptions
			}
		}
	];

	(* Here we are again replacing anything that is specified in the separationmethod, unless the user has already specified it in the options *)
	(* Not all of these options can be taken directly from the method. If any of the velocity, flowRate, pressure,or residenceTime are modified, the others need to be
	recalculated. Whether or not an option needs to be recalculated is listed in recalculateOptionsQ. *)

	{
		specifiedSeparationModeParameters,
		specifiedStandardSeparationModeParameters,
		specifiedBlankSeparationModeParameters
	} = MapThread[
		Function[{optionSet, methodSpecifiedQList},
			MapThread[
				Function[{specifiedParameterList, separationMethodParameterList,recalculateOptionQ},
					MapThread[
						Function[{parameter, methodSpecifiedParameter,recalculateParameterQ, methodSpecifiedQ},
							Which[
								(*Use parameter, if the parameter is set automatic, given in the methodSpecifiedParameter and does not need to be recalculated*)
								!recalculateParameterQ&&!methodSpecifiedQ, parameter,
								(*Use methodSpecifiedParameter, if the parameter is set automatic, given in the methodSpecifiedParameter and does not need to be recalculated*)
								MatchQ[parameter,(methodSpecifiedParameter|Automatic)]&&!recalculateParameterQ&&methodSpecifiedQ, methodSpecifiedParameter,
								(*Use Automatic, if the parameter is set automatic, given in the methodSpecifiedParameter and needs to be recalculated*)
								MatchQ[parameter,(methodSpecifiedParameter|Automatic)]&&recalculateParameterQ&&methodSpecifiedQ, Automatic,
								(*Use the specified paramter, differs from the methodSpecifiedParameter*)
								!MatchQ[parameter,(methodSpecifiedParameter|Automatic)]&&recalculateParameterQ&&methodSpecifiedQ, parameter
							]
						],
						(* this separationMethodSpecified needs to be split between sample, standard, and blank *)
						{specifiedParameterList, separationMethodParameterList, recalculateOptionQ, methodSpecifiedQList}
					]
				],
				optionSet
			]
		],
		{
			Transpose@{
				{prespecifiedSeparationModeOptions, prespecifiedStandardSeparationModeOptions, prespecifiedBlankSeparationModeOptions},
				{separationMethodSeparationModeOptions, separationMethodStandardSeparationModeOptions, separationMethodBlankSeparationModeOptions},
				Transpose[#]&/@{recalculateSampleMethodOptions,recalculateStandardMethodOptions,recalculateBlankMethodOptions}
			},
			{separationMethodSpecifiedQ, standardSeparationMethodSpecifiedQ, blankSeparationMethodSpecifiedQ}
		}
	];

	(* now unpack that huge list *)
	{
		{
			specifiedInitialInletTemperatures,
			specifiedInitialInletTemperatureDurations,
			specifiedInletTemperatureProfiles, (*
			specifiedInletModes,*)
			specifiedSplitRatios,
			specifiedSplitVentFlowRates,
			specifiedSplitlessTimes,
			specifiedInitialInletPressures,
			specifiedInitialInletTimes,
			specifiedGasSavers,
			specifiedGasSaverFlowRates,
			specifiedGasSaverActivationTimes,
			specifiedSolventEliminationFlowRates,
			specifiedInitialColumnFlowRates,
			specifiedInitialColumnPressures,
			specifiedInitialColumnAverageVelocities,
			specifiedInitialColumnResidenceTimes,
			specifiedInitialColumnSetpointDurations,
			specifiedColumnPressureProfiles,
			specifiedColumnFlowRateProfiles,
			specifiedOvenTemperatureProfiles,
			specifiedPostRunOvenTemperatures
		},
		{
			specifiedStandardInitialInletTemperatures,
			specifiedStandardInitialInletTemperatureDurations,
			specifiedStandardInletTemperatureProfiles, (*
			specifiedStandardInletModes,*)
			specifiedStandardSplitRatios,
			specifiedStandardSplitVentFlowRates,
			specifiedStandardSplitlessTimes,
			specifiedStandardInitialInletPressures,
			specifiedStandardInitialInletTimes,
			specifiedStandardGasSavers,
			specifiedStandardGasSaverFlowRates,
			specifiedStandardGasSaverActivationTimes,
			specifiedStandardSolventEliminationFlowRates,
			specifiedStandardInitialColumnFlowRates,
			specifiedStandardInitialColumnPressures,
			specifiedStandardInitialColumnAverageVelocities,
			specifiedStandardInitialColumnResidenceTimes,
			specifiedStandardInitialColumnSetpointDurations,
			specifiedStandardColumnPressureProfiles,
			specifiedStandardColumnFlowRateProfiles,
			specifiedStandardOvenTemperatureProfiles,
			specifiedStandardPostRunOvenTemperatures
		},
		{
			specifiedBlankInitialInletTemperatures,
			specifiedBlankInitialInletTemperatureDurations,
			specifiedBlankInletTemperatureProfiles, (*
			specifiedBlankInletModes,*)
			specifiedBlankSplitRatios,
			specifiedBlankSplitVentFlowRates,
			specifiedBlankSplitlessTimes,
			specifiedBlankInitialInletPressures,
			specifiedBlankInitialInletTimes,
			specifiedBlankGasSavers,
			specifiedBlankGasSaverFlowRates,
			specifiedBlankGasSaverActivationTimes,
			specifiedBlankSolventEliminationFlowRates,
			specifiedBlankInitialColumnFlowRates,
			specifiedBlankInitialColumnPressures,
			specifiedBlankInitialColumnAverageVelocities,
			specifiedBlankInitialColumnResidenceTimes,
			specifiedBlankInitialColumnSetpointDurations,
			specifiedBlankColumnPressureProfiles,
			specifiedBlankColumnFlowRateProfiles,
			specifiedBlankOvenTemperatureProfiles,
			specifiedBlankPostRunOvenTemperatures
		}
	} = {
		specifiedSeparationModeParameters,
		specifiedStandardSeparationModeParameters,
		specifiedBlankSeparationModeParameters
	};

	(* === Error/Warning: Column oven temperature profile contains temperatures above/below the column temperature limits === *)

	{specifiedTemperatureProfileSetpoints, specifiedStandardTemperatureProfileSetpoints, specifiedBlankTemperatureProfileSetpoints} = Map[
		Function[profile, Select[ToList[profile], CompatibleUnitQ[#, Celsius] &]],
		{specifiedOvenTemperatureProfiles, specifiedStandardOvenTemperatureProfiles, specifiedBlankOvenTemperatureProfiles},
		{2}
	];

	(* figure out if any oven temperatures specified are too hot or cold *)
	{
		{
			{ovenTemperaturesTooHotQ, ovenTemperaturesTooColdQ},
			{postRunOvenTemperaturesTooHotQ, postRunOvenTemperaturesTooColdQ},
			{initialOvenTemperaturesTooHotQ, initialOvenTemperaturesTooColdQ}
		},
		{
			{standardOvenTemperaturesTooHotQ, standardOvenTemperaturesTooColdQ},
			{standardPostRunOvenTemperaturesTooHotQ, standardPostRunOvenTemperaturesTooColdQ},
			{standardInitialOvenTemperaturesTooHotQ, standardInitialOvenTemperaturesTooColdQ}
		},
		{
			{blankOvenTemperaturesTooHotQ, blankOvenTemperaturesTooColdQ},
			{blankPostRunOvenTemperaturesTooHotQ, blankPostRunOvenTemperaturesTooColdQ},
			{blankInitialOvenTemperaturesTooHotQ, blankInitialOvenTemperaturesTooColdQ}
		}
	} = MapThread[
		Function[{profileSetpoints, postRunTemps, initialOvenTemps},
			Map[
				Function[{temperatureList},
					Transpose@Map[
						Function[{temperature},
							{temperature > maxColumnTempLimit, temperature < minColumnTempLimit}
						],
						temperatureList
					]
				],
				{
					profileSetpoints,
					postRunTemps,
					initialOvenTemps
				}
			]
		],
		Transpose@{
			{
				specifiedTemperatureProfileSetpoints,
				specifiedPostRunOvenTemperatures,
				specifiedInitialOvenTemperatures
			},
			{
				specifiedStandardTemperatureProfileSetpoints,
				specifiedStandardPostRunOvenTemperatures,
				specifiedStandardInitialOvenTemperatures
			},
			{
				specifiedBlankTemperatureProfileSetpoints,
				specifiedBlankPostRunOvenTemperatures,
				specifiedBlankInitialOvenTemperatures
			}
		}
	];

	(* now throw some errors for the options that are not set properly *)

	(* pick the too hot setpoints *)
	{
		tooHotTemperatureProfileSetpoints,
		tooHotPostRunOvenTemperatures,
		tooHotInitialOvenTemperatures,
		tooHotStandardTemperatureProfileSetpoints,
		tooHotStandardPostRunOvenTemperatures,
		tooHotStandardInitialOvenTemperatures,
		tooHotBlankTemperatureProfileSetpoints,
		tooHotBlankPostRunOvenTemperatures,
		tooHotBlankInitialOvenTemperatures
	} = MapThread[
		Function[{tempsList, tooHotQ},
			PickList[tempsList, tooHotQ, True]
		],
		{
			{
				specifiedTemperatureProfileSetpoints,
				specifiedPostRunOvenTemperatures,
				specifiedInitialOvenTemperatures,
				specifiedStandardTemperatureProfileSetpoints,
				specifiedStandardPostRunOvenTemperatures,
				specifiedStandardInitialOvenTemperatures,
				specifiedBlankTemperatureProfileSetpoints,
				specifiedBlankPostRunOvenTemperatures,
				specifiedBlankInitialOvenTemperatures
			},
			{
				ovenTemperaturesTooHotQ,
				postRunOvenTemperaturesTooHotQ,
				initialOvenTemperaturesTooHotQ,
				standardOvenTemperaturesTooHotQ,
				standardPostRunOvenTemperaturesTooHotQ,
				standardInitialOvenTemperaturesTooHotQ,
				blankOvenTemperaturesTooHotQ,
				blankPostRunOvenTemperaturesTooHotQ,
				blankInitialOvenTemperaturesTooHotQ
			}
		}
	];

	(* if we're throwing errors, throw em *)
	If[!gatherTests,
		MapThread[
			Function[{setpointsList, optionName},
				If[Length[setpointsList] > 0,
					Message[Error::GCColumnMaxTemperatureExceeded, setpointsList, optionName, maxColumnTempLimit],
					Nothing
				]
			],
			{
				{
					tooHotTemperatureProfileSetpoints,
					tooHotPostRunOvenTemperatures,
					tooHotInitialOvenTemperatures,
					tooHotStandardTemperatureProfileSetpoints,
					tooHotStandardPostRunOvenTemperatures,
					tooHotStandardInitialOvenTemperatures,
					tooHotBlankTemperatureProfileSetpoints,
					tooHotBlankPostRunOvenTemperatures,
					tooHotBlankInitialOvenTemperatures
				},
				{
					OvenTemperatureProfile,
					PostRunOvenTemperature,
					InitialOvenTemperature,
					StandardOvenTemperatureProfile,
					StandardPostRunOvenTemperature,
					StandardInitialOvenTemperature,
					BlankOvenTemperatureProfile,
					BlankPostRunOvenTemperature,
					BlankInitialOvenTemperature
				}
			}
		],
		Nothing
	];

	(* If we are gathering tests, test each Option with an oven temperature setpoint *)

	{
		tooHotOvenTemperatureProfileTests,
		tooHotPostRunOvenTemperatureTests,
		tooHotInitialOvenTemperatureTests,
		tooHotStandardOvenTemperatureProfileTests,
		tooHotStandardPostRunOvenTemperatureTests,
		tooHotStandardInitialOvenTemperatureTests,
		tooHotBlankOvenTemperatureProfileTests,
		tooHotBlankPostRunOvenTemperatureTests,
		tooHotBlankInitialOvenTemperatureTests
	} = If[gatherTests,
		MapThread[
			Function[{setpointsList, optionName},
				Test["The temperature setpoint(s) in Option " <> ToString[optionName] <> " do(es) not exceed the column temperature limit of " <> ToString[maxColumnTempLimit] <> ".",
					setpointsList,
					{}
				]
			],
			{
				{
					tooHotTemperatureProfileSetpoints,
					tooHotPostRunOvenTemperatures,
					tooHotInitialOvenTemperatures,
					tooHotStandardTemperatureProfileSetpoints,
					tooHotStandardPostRunOvenTemperatures,
					tooHotStandardInitialOvenTemperatures,
					tooHotBlankTemperatureProfileSetpoints,
					tooHotBlankPostRunOvenTemperatures,
					tooHotBlankInitialOvenTemperatures
				},
				{
					OvenTemperatureProfile,
					PostRunOvenTemperature,
					InitialOvenTemperature,
					StandardOvenTemperatureProfile,
					StandardPostRunOvenTemperature,
					StandardInitialOvenTemperature,
					BlankOvenTemperatureProfile,
					BlankPostRunOvenTemperature,
					BlankInitialOvenTemperature
				}
			}
		],
		{ {}, {}, {}, {}, {}, {}, {}, {}, {} }
	];

	(* Repeat and pick setpoints that are too cold *)
	{
		tooColdTemperatureProfileSetpoints,
		tooColdPostRunOvenTemperatures,
		tooColdInitialOvenTemperatures,
		tooColdStandardTemperatureProfileSetpoints,
		tooColdStandardPostRunOvenTemperatures,
		tooColdStandardInitialOvenTemperatures,
		tooColdBlankTemperatureProfileSetpoints,
		tooColdBlankPostRunOvenTemperatures,
		tooColdBlankInitialOvenTemperatures
	} = MapThread[
		Function[{tempsList, tooColdQ},
			PickList[tempsList, tooColdQ, True]
		],
		{
			{
				specifiedTemperatureProfileSetpoints,
				specifiedPostRunOvenTemperatures,
				specifiedInitialOvenTemperatures,
				specifiedStandardTemperatureProfileSetpoints,
				specifiedStandardPostRunOvenTemperatures,
				specifiedStandardInitialOvenTemperatures,
				specifiedBlankTemperatureProfileSetpoints,
				specifiedBlankPostRunOvenTemperatures,
				specifiedBlankInitialOvenTemperatures
			},
			{
				ovenTemperaturesTooColdQ,
				postRunOvenTemperaturesTooColdQ,
				initialOvenTemperaturesTooColdQ,
				standardOvenTemperaturesTooColdQ,
				standardPostRunOvenTemperaturesTooColdQ,
				standardInitialOvenTemperaturesTooColdQ,
				blankOvenTemperaturesTooColdQ,
				blankPostRunOvenTemperaturesTooColdQ,
				blankInitialOvenTemperaturesTooColdQ
			}
		}
	];

	(* if throwing errors, throw if too cold *)
	If[!gatherTests,
		MapThread[
			Function[{setpointsList, optionName},
				If[Length[setpointsList] > 0,
					Message[Warning::GCColumnMinTemperatureExceeded, setpointsList, optionName, minColumnTempLimit],
					Nothing
				]
			],
			{
				{
					tooColdTemperatureProfileSetpoints,
					tooColdPostRunOvenTemperatures,
					tooColdInitialOvenTemperatures,
					tooColdStandardTemperatureProfileSetpoints,
					tooColdStandardPostRunOvenTemperatures,
					tooColdStandardInitialOvenTemperatures,
					tooColdBlankTemperatureProfileSetpoints,
					tooColdBlankPostRunOvenTemperatures,
					tooColdBlankInitialOvenTemperatures
				},
				{
					OvenTemperatureProfile,
					PostRunOvenTemperature,
					InitialOvenTemperature,
					StandardOvenTemperatureProfile,
					StandardPostRunOvenTemperature,
					StandardInitialOvenTemperature,
					BlankOvenTemperatureProfile,
					BlankPostRunOvenTemperature,
					BlankInitialOvenTemperature
				}
			}
		],
		Nothing
	];

	(* If we are gathering tests, test each Option with an oven temperature setpoint for too cold *)

	{
		tooColdOvenTemperatureProfileTests,
		tooColdPostRunOvenTemperatureTests,
		tooColdInitialOvenTemperatureTests,
		tooColdStandardOvenTemperatureProfileTests,
		tooColdStandardPostRunOvenTemperatureTests,
		tooColdStandardInitialOvenTemperatureTests,
		tooColdBlankOvenTemperatureProfileTests,
		tooColdBlankPostRunOvenTemperatureTests,
		tooColdBlankInitialOvenTemperatureTests
	} = If[gatherTests,
		MapThread[
			Function[{setpointsList, optionName},
				Test["The temperature setpoint(s) in Option " <> ToString[optionName] <> " do(es) not fall below the column minimum temperature limit of " <> ToString[minColumnTempLimit] <> ".",
					setpointsList,
					{}
				]
			],
			{
				{
					tooColdTemperatureProfileSetpoints,
					tooColdPostRunOvenTemperatures,
					tooColdInitialOvenTemperatures,
					tooColdStandardTemperatureProfileSetpoints,
					tooColdStandardPostRunOvenTemperatures,
					tooColdStandardInitialOvenTemperatures,
					tooColdBlankTemperatureProfileSetpoints,
					tooColdBlankPostRunOvenTemperatures,
					tooColdBlankInitialOvenTemperatures
				},
				{
					OvenTemperatureProfile,
					PostRunOvenTemperature,
					InitialOvenTemperature,
					StandardOvenTemperatureProfile,
					StandardPostRunOvenTemperature,
					StandardInitialOvenTemperature,
					BlankOvenTemperatureProfile,
					BlankPostRunOvenTemperature,
					BlankInitialOvenTemperature
				}
			}
		],
		{ {}, {}, {}, {}, {}, {}, {}, {}, {} }
	];

	(* This won't happen until MS is brought online *)

	(* === Error: More than one of InitialColumnFlowRate/InitialColumnPressure/InitialColumnAverageVelocity/InitialColumnResidenceTime is specified === *)

	(* Get the values we're testing against *)
	{allInitialColumnFlowrates, allInitialColumnPressures, allInitialColumnAverageVelocities, allInitialColumnResidenceTimes} = Lookup[roundedGasChromatographyOptions, {InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime}];
	{allStandardInitialColumnFlowrates, allStandardInitialColumnPressures, allStandardInitialColumnAverageVelocities, allStandardInitialColumnResidenceTimes} = Lookup[expandedStandardsAssociation, {StandardInitialColumnFlowRate, StandardInitialColumnPressure, StandardInitialColumnAverageVelocity, StandardInitialColumnResidenceTime}];
	{allBlankInitialColumnFlowrates, allBlankInitialColumnPressures, allBlankInitialColumnAverageVelocities, allBlankInitialColumnResidenceTimes} = Lookup[expandedBlanksAssociation, {BlankInitialColumnFlowRate, BlankInitialColumnPressure, BlankInitialColumnAverageVelocity, BlankInitialColumnResidenceTime}];

	(* check each sample, standard, and blank to see which initial conditions were specified *)
	{specifiedInitialColumnConditions, specifiedStandardInitialColumnConditions, specifiedBlankInitialColumnConditions} = Map[
		Function[{optionsList},
			MapThread[
				Function[{flowRate, pressure, velocities, holdupTime},
					Map[
						If[MatchQ[#, _Quantity],
							True,
							False
						]&,
						{flowRate, pressure, velocities, holdupTime}
					]
				],
				optionsList
			]
		],
		{
			{allInitialColumnFlowrates, allInitialColumnPressures, allInitialColumnAverageVelocities, allInitialColumnResidenceTimes},
			{allStandardInitialColumnFlowrates, allStandardInitialColumnPressures, allStandardInitialColumnAverageVelocities, allStandardInitialColumnResidenceTimes},
			{allBlankInitialColumnFlowrates, allBlankInitialColumnPressures, allBlankInitialColumnAverageVelocities, allBlankInitialColumnResidenceTimes}
		}
	];

	{
		{cospecifiedSampleOptions, cospecifiedSampleOptionsTests},
		{cospecifiedStandardOptions, cospecifiedStandardOptionsTests},
		{cospecifiedBlankOptions, cospecifiedBlankOptionsTests}
	} = Map[
		Function[{listsOfOptions},
			Module[{initialColumnConditions, optionNames, specifiedColumnConditionsQ, cospecifiedColumnConditionsQ, cospecifiedOptions, cospecifiedOptionsTests},
				{initialColumnConditions, optionNames} = listsOfOptions;
				(* Now for each option, pick out any cases where more than one option was defined simultaneously *)
				specifiedColumnConditionsQ = Select[initialColumnConditions, Length[Cases[#, True]] > 1 &];

				(* If there are no cases, then no options have been cospecified, otherwise transpose and apply Or to get a boolean list corresponding to any cospecified options *)
				cospecifiedColumnConditionsQ = If[MatchQ[specifiedColumnConditionsQ, {}],
					PadRight[{}, 4, False],
					Apply[Or, #] & /@ (Transpose@specifiedColumnConditionsQ)
				];

				cospecifiedOptions = PickList[{InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime}, cospecifiedColumnConditionsQ];

				(* If we're throwing errors, give an error saying the x options can't be specified at the same time *)
				If[!gatherTests,
					If[
						!MatchQ[cospecifiedOptions, {}],
						Message[Error::CospecifiedInitialColumnConditions, ToString@(StringRiffle[Most[cospecifiedOptions], ", "]), ToString@Last[cospecifiedOptions]]
					],
					Nothing
				];

				(* What if somehow they all get nulled out? this can happen if no standards or blanks are specified but shouldn't in any other case. *)
				(*MapThread[
			MatchQ[{#1,#2,#3,#4},Apply[Alternatives, Permutations[{_Quantity, Null, Null, Null}]]]&,
			{allInitialColumnFlowrates,allInitialColumnPressures,allInitialColumnAverageVelocities,allInitialColumnResidenceTimes}
		];*)

				(* If we are gathering tests, create tests with the desired results *)
				cospecifiedOptionsTests = If[gatherTests,
					MapThread[
						Function[{optionName, cospecifiedQ},
							Test["Option " <> ToString[optionName] <> " is not cospecified with any other initial column conditions:",
								cospecifiedQ,
								False
							]
						],
						{optionNames, cospecifiedColumnConditionsQ}
					],
					{}
				];

				{cospecifiedOptions, cospecifiedOptionsTests}
			]
		],
		{
			{specifiedInitialColumnConditions, {InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime}},
			{specifiedStandardInitialColumnConditions, {StandardInitialColumnFlowRate, StandardInitialColumnPressure, StandardInitialColumnAverageVelocity, StandardInitialColumnResidenceTime}},
			{specifiedBlankInitialColumnConditions, {BlankInitialColumnFlowRate, BlankInitialColumnPressure, BlankInitialColumnAverageVelocity, BlankInitialColumnResidenceTime}}
		}
	];

	(* Errors related to the inlet *)

	(* === Error: Inlet option is incompatible with Inlet === *)

	(* get the Inlet *)
	specifiedInlet = Lookup[roundedGasChromatographyOptions, Inlet];

	(* determine if MMI options were specified *)
	multimodeInletOptionsSpecifiedQ = Map[
		MemberQ[#, Except[Null | Automatic]]&,
		{
			specifiedInletTemperatureProfiles,
			specifiedSolventEliminationFlowRates,
			specifiedStandardInletTemperatureProfiles,
			specifiedStandardSolventEliminationFlowRates,
			specifiedBlankInletTemperatureProfiles,
			specifiedBlankSolventEliminationFlowRates
		}
	];

	(* if the inlet is not MMI, we can't do temperature profiling or solvent elimination but pressure pulsing is still an option. *)
	incompatibleInletOptions = If[!MatchQ[specifiedInlet, Multimode],
		PickList[{
			InletTemperatureProfile,
			SolventEliminationFlowRate,
			StandardInletTemperatureProfile,
			StandardSolventEliminationFlowRate,
			BlankInletTemperatureProfile,
			BlankSolventEliminationFlowRate
		}, multimodeInletOptionsSpecifiedQ, True],
		{}
	];

	(* throw errors if that's your jam *)
	If[Length[incompatibleInletOptions] > 0 && !gatherTests,
		Message[Error::IncompatibleInletAndInletOption, incompatibleInletOptions, specifiedInlet],
		Nothing
	];

	(* otherwise gather tests *)
	inletOptionsCompatibleTests = If[gatherTests,
		MapThread[
			If[
				#1,
				Test["If option " <> ToString[#2] <> " is specified, the specified inlet is Multimode:",
					(* if the specified inlet is splitsplitless, none of the multimode inlet options should be specified: not {True,True} *)
					Nand[MatchQ[specifiedInlet, SplitSplitless], #1],
					True
				],
				Nothing
			]&,
			{multimodeInletOptionsSpecifiedQ,
				{
					InletTemperatureProfile,
					SolventEliminationFlowRate,
					StandardInletTemperatureProfile,
					StandardSolventEliminationFlowRate,
					BlankInletTemperatureProfile,
					BlankSolventEliminationFlowRate
				}
			}
		],
		{}
	];




	(* Get the Dilute Boolean values *)
	specifiedDiluteBooleans = Lookup[roundedGasChromatographyOptions, Dilute];
	specifiedStandardDiluteBooleans = Lookup[expandedStandardsAssociation, StandardDilute];
	specifiedBlankDiluteBooleans = Lookup[expandedBlanksAssociation, BlankDilute];

	(* Get dilution parameters *)
	{specifiedDilutionSolventVolumes, specifiedSecondaryDilutionSolventVolumes, specifiedTertiaryDilutionSolventVolumes} = Lookup[roundedGasChromatographyOptions, {DilutionSolventVolume, SecondaryDilutionSolventVolume, TertiaryDilutionSolventVolume}];
	{specifiedStandardDilutionSolventVolumes, specifiedStandardSecondaryDilutionSolventVolumes, specifiedStandardTertiaryDilutionSolventVolumes} = Lookup[expandedStandardsAssociation, {StandardDilutionSolventVolume, StandardSecondaryDilutionSolventVolume, StandardTertiaryDilutionSolventVolume}];
	{specifiedBlankDilutionSolventVolumes, specifiedBlankSecondaryDilutionSolventVolumes, specifiedBlankTertiaryDilutionSolventVolumes} = Lookup[expandedBlanksAssociation, {BlankDilutionSolventVolume, BlankSecondaryDilutionSolventVolume, BlankTertiaryDilutionSolventVolume}];

	(* Get the specified Agitate Boolean values *)
	specifiedAgitateBooleans = Lookup[roundedGasChromatographyOptions, Agitate];
	specifiedStandardAgitateBooleans = Lookup[expandedStandardsAssociation, StandardAgitate];
	specifiedBlankAgitateBooleans = Lookup[expandedBlanksAssociation, BlankAgitate];

	(* Get agitation parameters AgitationTemperature, AgitationMixRate, AgitationTime, AgitationOnTime, AgitationOffTime *)
	{specifiedAgitationTemperatures, specifiedAgitationMixRates, specifiedAgitationTimes, specifiedAgitationOnTimes, specifiedAgitationOffTimes} = Lookup[roundedGasChromatographyOptions, {AgitationTemperature, AgitationMixRate, AgitationTime, AgitationOnTime, AgitationOffTime}];
	{specifiedStandardAgitationTemperatures, specifiedStandardAgitationMixRates, specifiedStandardAgitationTimes, specifiedStandardAgitationOnTimes, specifiedStandardAgitationOffTimes} = Lookup[expandedStandardsAssociation, {StandardAgitationTemperature, StandardAgitationMixRate, StandardAgitationTime, StandardAgitationOnTime, StandardAgitationOffTime}];
	{specifiedBlankAgitationTemperatures, specifiedBlankAgitationMixRates, specifiedBlankAgitationTimes, specifiedBlankAgitationOnTimes, specifiedBlankAgitationOffTimes} = Lookup[expandedBlanksAssociation, {BlankAgitationTemperature, BlankAgitationMixRate, BlankAgitationTime, BlankAgitationOnTime, BlankAgitationOffTime}];

	(* Get the specified Vortex Boolean values *)
	specifiedVortexBooleans = Lookup[roundedGasChromatographyOptions, Vortex];
	specifiedStandardVortexBooleans = Lookup[expandedStandardsAssociation, StandardVortex];
	specifiedBlankVortexBooleans = Lookup[expandedBlanksAssociation, BlankVortex];

	(* Get vortex parameters VortexMixRate, VortexTime *)
	{specifiedVortexMixRates, specifiedVortexTimes} = Lookup[roundedGasChromatographyOptions, {VortexMixRate, VortexTime}];
	{specifiedStandardVortexMixRates, specifiedStandardVortexTimes} = Lookup[expandedStandardsAssociation, {StandardVortexMixRate, StandardVortexTime}];
	{specifiedBlankVortexMixRates, specifiedBlankVortexTimes} = Lookup[expandedBlanksAssociation, {BlankVortexMixRate, BlankVortexTime}];

	(* Get LiquidInjection options *)
	specifiedLiquidSamplingOptions = {
		specifiedLiquidPreInjectionSyringeWashes,
		specifiedLiquidPreInjectionSyringeWashVolumes,
		specifiedLiquidPreInjectionSyringeWashRates,
		specifiedLiquidPreInjectionNumberOfSolventWashes,
		specifiedLiquidPreInjectionNumberOfSecondarySolventWashes,
		specifiedLiquidPreInjectionNumberOfTertiarySolventWashes,
		specifiedLiquidPreInjectionNumberOfQuaternarySolventWashes,
		specifiedLiquidSampleWashes,
		specifiedNumberOfLiquidSampleWashes,
		specifiedLiquidSampleWashVolumes,
		specifiedLiquidSampleFillingStrokes,
		specifiedLiquidSampleFillingStrokesVolumes,
		specifiedLiquidFillingStrokeDelays,
		specifiedLiquidSampleOverAspirationVolumes,
		specifiedLiquidPostInjectionSyringeWashes,
		specifiedLiquidPostInjectionSyringeWashVolumes,
		specifiedLiquidPostInjectionSyringeWashRates,
		specifiedLiquidPostInjectionNumberOfSolventWashes,
		specifiedLiquidPostInjectionNumberOfSecondarySolventWashes,
		specifiedLiquidPostInjectionNumberOfTertiarySolventWashes,
		specifiedLiquidPostInjectionNumberOfQuaternarySolventWashes,
		specifiedPostInjectionNextSamplePreparationSteps
	} = Lookup[roundedGasChromatographyOptions,
		{
			LiquidPreInjectionSyringeWash,
			LiquidPreInjectionSyringeWashVolume,
			LiquidPreInjectionSyringeWashRate,
			LiquidPreInjectionNumberOfSolventWashes,
			LiquidPreInjectionNumberOfSecondarySolventWashes,
			LiquidPreInjectionNumberOfTertiarySolventWashes,
			LiquidPreInjectionNumberOfQuaternarySolventWashes,
			LiquidSampleWash,
			NumberOfLiquidSampleWashes,
			LiquidSampleWashVolume,
			LiquidSampleFillingStrokes,
			LiquidSampleFillingStrokesVolume,
			LiquidFillingStrokeDelay,
			LiquidSampleOverAspirationVolume,
			LiquidPostInjectionSyringeWash,
			LiquidPostInjectionSyringeWashVolume,
			LiquidPostInjectionSyringeWashRate,
			LiquidPostInjectionNumberOfSolventWashes,
			LiquidPostInjectionNumberOfSecondarySolventWashes,
			LiquidPostInjectionNumberOfTertiarySolventWashes,
			LiquidPostInjectionNumberOfQuaternarySolventWashes,
			PostInjectionNextSamplePreparationSteps
		}
	];

	specifiedStandardLiquidSamplingOptions = {
		specifiedStandardLiquidPreInjectionSyringeWashes,
		specifiedStandardLiquidPreInjectionSyringeWashVolumes,
		specifiedStandardLiquidPreInjectionSyringeWashRates,
		specifiedStandardLiquidPreInjectionNumberOfSolventWashes,
		specifiedStandardLiquidPreInjectionNumberOfSecondarySolventWashes,
		specifiedStandardLiquidPreInjectionNumberOfTertiarySolventWashes,
		specifiedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes,
		specifiedStandardLiquidSampleWashes,
		specifiedStandardNumberOfLiquidSampleWashes,
		specifiedStandardLiquidSampleWashVolumes,
		specifiedStandardLiquidSampleFillingStrokes,
		specifiedStandardLiquidSampleFillingStrokesVolumes,
		specifiedStandardLiquidFillingStrokeDelays,
		specifiedStandardLiquidSampleOverAspirationVolumes,
		specifiedStandardLiquidPostInjectionSyringeWashes,
		specifiedStandardLiquidPostInjectionSyringeWashVolumes,
		specifiedStandardLiquidPostInjectionSyringeWashRates,
		specifiedStandardLiquidPostInjectionNumberOfSolventWashes,
		specifiedStandardLiquidPostInjectionNumberOfSecondarySolventWashes,
		specifiedStandardLiquidPostInjectionNumberOfTertiarySolventWashes,
		specifiedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
		specifiedStandardPostInjectionNextSamplePreparationSteps
	} = Lookup[expandedStandardsAssociation,
		{
			StandardLiquidPreInjectionSyringeWash,
			StandardLiquidPreInjectionSyringeWashVolume,
			StandardLiquidPreInjectionSyringeWashRate,
			StandardLiquidPreInjectionNumberOfSolventWashes,
			StandardLiquidPreInjectionNumberOfSecondarySolventWashes,
			StandardLiquidPreInjectionNumberOfTertiarySolventWashes,
			StandardLiquidPreInjectionNumberOfQuaternarySolventWashes,
			StandardLiquidSampleWash,
			StandardNumberOfLiquidSampleWashes,
			StandardLiquidSampleWashVolume,
			StandardLiquidSampleFillingStrokes,
			StandardLiquidSampleFillingStrokesVolume,
			StandardLiquidFillingStrokeDelay,
			StandardLiquidSampleOverAspirationVolume,
			StandardLiquidPostInjectionSyringeWash,
			StandardLiquidPostInjectionSyringeWashVolume,
			StandardLiquidPostInjectionSyringeWashRate,
			StandardLiquidPostInjectionNumberOfSolventWashes,
			StandardLiquidPostInjectionNumberOfSecondarySolventWashes,
			StandardLiquidPostInjectionNumberOfTertiarySolventWashes,
			StandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
			StandardPostInjectionNextSamplePreparationSteps
		}
	];

	specifiedBlankLiquidSamplingOptions = {
		specifiedBlankLiquidPreInjectionSyringeWashes,
		specifiedBlankLiquidPreInjectionSyringeWashVolumes,
		specifiedBlankLiquidPreInjectionSyringeWashRates,
		specifiedBlankLiquidPreInjectionNumberOfSolventWashes,
		specifiedBlankLiquidPreInjectionNumberOfSecondarySolventWashes,
		specifiedBlankLiquidPreInjectionNumberOfTertiarySolventWashes,
		specifiedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes,
		specifiedBlankLiquidSampleWashes,
		specifiedBlankNumberOfLiquidSampleWashes,
		specifiedBlankLiquidSampleWashVolumes,
		specifiedBlankLiquidSampleFillingStrokes,
		specifiedBlankLiquidSampleFillingStrokesVolumes,
		specifiedBlankLiquidFillingStrokeDelays,
		specifiedBlankLiquidSampleOverAspirationVolumes,
		specifiedBlankLiquidPostInjectionSyringeWashes,
		specifiedBlankLiquidPostInjectionSyringeWashVolumes,
		specifiedBlankLiquidPostInjectionSyringeWashRates,
		specifiedBlankLiquidPostInjectionNumberOfSolventWashes,
		specifiedBlankLiquidPostInjectionNumberOfSecondarySolventWashes,
		specifiedBlankLiquidPostInjectionNumberOfTertiarySolventWashes,
		specifiedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes,
		specifiedBlankPostInjectionNextSamplePreparationSteps
	} = Lookup[expandedBlanksAssociation,
		{
			BlankLiquidPreInjectionSyringeWash,
			BlankLiquidPreInjectionSyringeWashVolume,
			BlankLiquidPreInjectionSyringeWashRate,
			BlankLiquidPreInjectionNumberOfSolventWashes,
			BlankLiquidPreInjectionNumberOfSecondarySolventWashes,
			BlankLiquidPreInjectionNumberOfTertiarySolventWashes,
			BlankLiquidPreInjectionNumberOfQuaternarySolventWashes,
			BlankLiquidSampleWash,
			BlankNumberOfLiquidSampleWashes,
			BlankLiquidSampleWashVolume,
			BlankLiquidSampleFillingStrokes,
			BlankLiquidSampleFillingStrokesVolume,
			BlankLiquidFillingStrokeDelay,
			BlankLiquidSampleOverAspirationVolume,
			BlankLiquidPostInjectionSyringeWash,
			BlankLiquidPostInjectionSyringeWashVolume,
			BlankLiquidPostInjectionSyringeWashRate,
			BlankLiquidPostInjectionNumberOfSolventWashes,
			BlankLiquidPostInjectionNumberOfSecondarySolventWashes,
			BlankLiquidPostInjectionNumberOfTertiarySolventWashes,
			BlankLiquidPostInjectionNumberOfQuaternarySolventWashes,
			BlankPostInjectionNextSamplePreparationSteps
		}
	];

	(* Get HeadspaceInjection options *)
	specifiedHeadspaceSamplingOptions = {
		specifiedHeadspaceSyringeTemperatures,
		specifiedHeadspacePreInjectionFlushTimes,
		specifiedHeadspacePostInjectionFlushTimes,
		specifiedHeadspaceSyringeFlushings
	} = Lookup[roundedGasChromatographyOptions,
		{
			HeadspaceSyringeTemperature,
			HeadspacePreInjectionFlushTime,
			HeadspacePostInjectionFlushTime,
			HeadspaceSyringeFlushing
		}
	];

	specifiedStandardHeadspaceSamplingOptions = {
		specifiedStandardHeadspaceSyringeTemperatures,
		specifiedStandardHeadspacePreInjectionFlushTimes,
		specifiedStandardHeadspacePostInjectionFlushTimes,
		specifiedStandardHeadspaceSyringeFlushings
	} = Lookup[expandedStandardsAssociation,
		{
			StandardHeadspaceSyringeTemperature,
			StandardHeadspacePreInjectionFlushTime,
			StandardHeadspacePostInjectionFlushTime,
			StandardHeadspaceSyringeFlushing
		}
	];

	specifiedBlankHeadspaceSamplingOptions = {
		specifiedBlankHeadspaceSyringeTemperatures,
		specifiedBlankHeadspacePreInjectionFlushTimes,
		specifiedBlankHeadspacePostInjectionFlushTimes,
		specifiedBlankHeadspaceSyringeFlushings
	} = Lookup[expandedBlanksAssociation,
		{
			BlankHeadspaceSyringeTemperature,
			BlankHeadspacePreInjectionFlushTime,
			BlankHeadspacePostInjectionFlushTime,
			BlankHeadspaceSyringeFlushing
		}
	];

	(* Get SPMEInjection options *)
	specifiedSPMESamplingOptions = {
		specifiedSPMEConditions,
		specifiedSPMEConditioningTemperatures,
		specifiedSPMEPreConditioningTimes,
		specifiedSPMEDerivatizingAgents,
		specifiedSPMEDerivatizingAgentAdsorptionTimes,
		specifiedSPMEDerivatizationPositions,
		specifiedSPMEDerivatizationPositionOffsets,
		specifiedSPMESampleExtractionTimes,
		specifiedSPMESampleDesorptionTimes,
		specifiedSPMEPostInjectionConditioningTimes
	} = Lookup[roundedGasChromatographyOptions,
		{
			SPMECondition,
			SPMEConditioningTemperature,
			SPMEPreConditioningTime,
			SPMEDerivatizingAgent,
			SPMEDerivatizingAgentAdsorptionTime,
			SPMEDerivatizationPosition,
			SPMEDerivatizationPositionOffset,
			SPMESampleExtractionTime,
			SPMESampleDesorptionTime,
			SPMEPostInjectionConditioningTime
		}
	];

	specifiedStandardSPMESamplingOptions = {
		specifiedStandardSPMEConditions,
		specifiedStandardSPMEConditioningTemperatures,
		specifiedStandardSPMEPreConditioningTimes,
		specifiedStandardSPMEDerivatizingAgents,
		specifiedStandardSPMEDerivatizingAgentAdsorptionTimes,
		specifiedStandardSPMEDerivatizationPositions,
		specifiedStandardSPMEDerivatizationPositionOffsets,
		specifiedStandardSPMESampleExtractionTimes,
		specifiedStandardSPMESampleDesorptionTimes,
		specifiedStandardSPMEPostInjectionConditioningTimes
	} = Lookup[expandedStandardsAssociation,
		{
			StandardSPMECondition,
			StandardSPMEConditioningTemperature,
			StandardSPMEPreConditioningTime,
			StandardSPMEDerivatizingAgent,
			StandardSPMEDerivatizingAgentAdsorptionTime,
			StandardSPMEDerivatizationPosition,
			StandardSPMEDerivatizationPositionOffset,
			StandardSPMESampleExtractionTime,
			StandardSPMESampleDesorptionTime,
			StandardSPMEPostInjectionConditioningTime
		}
	];

	specifiedBlankSPMESamplingOptions = {
		specifiedBlankSPMEConditions,
		specifiedBlankSPMEConditioningTemperatures,
		specifiedBlankSPMEPreConditioningTimes,
		specifiedBlankSPMEDerivatizingAgents,
		specifiedBlankSPMEDerivatizingAgentAdsorptionTimes,
		specifiedBlankSPMEDerivatizationPositions,
		specifiedBlankSPMEDerivatizationPositionOffsets,
		specifiedBlankSPMESampleExtractionTimes,
		specifiedBlankSPMESampleDesorptionTimes,
		specifiedBlankSPMEPostInjectionConditioningTimes
	} = Lookup[expandedBlanksAssociation,
		{
			BlankSPMECondition,
			BlankSPMEConditioningTemperature,
			BlankSPMEPreConditioningTime,
			BlankSPMEDerivatizingAgent,
			BlankSPMEDerivatizingAgentAdsorptionTime,
			BlankSPMEDerivatizationPosition,
			BlankSPMEDerivatizationPositionOffset,
			BlankSPMESampleExtractionTime,
			BlankSPMESampleDesorptionTime,
			BlankSPMEPostInjectionConditioningTime
		}
	];

	(* === Error: Hydrogen to air ratio in FID flowrates is not within the 6-14% limit === *)

	(* If the detector is not FID, don't do anything *)

	(* calculate the specified ratios. if they are wrong, error. a single test here should be fine *)

	(* ===  === *)
	(* ===  === *)
	(* ===  === *)

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* resolve TrimColumnLength *)

	{specifiedTrimColumn, specifiedTrimColumnLength} = ToList /@ Lookup[roundedGasChromatographyOptions, {TrimColumn, TrimColumnLength}];

	resolvedTrimColumn = MapThread[
		Function[{trimColumn, trimColumnLength},
			If[MatchQ[trimColumn, Except[Automatic]],
				trimColumn,
				If[MatchQ[trimColumnLength, Except[Null | Automatic]],
					True,
					False
				]
			]
		],
		{specifiedTrimColumn, specifiedTrimColumnLength}
	];

	resolvedTrimColumnLength = MapThread[
		Function[{trimColumn, trimColumnLength},
			If[trimColumn,
				Replace[trimColumnLength, {Automatic -> 0.5 * Meter}],
				Replace[trimColumnLength, {Automatic -> Null}]
			]
		],
		{resolvedTrimColumn, specifiedTrimColumnLength}
	];

	(* == error check that these two options agree == *)

	conflictingTrimOptionsQ = Switch[
		{resolvedTrimColumn, resolvedTrimColumnLength},
		{{False}, {Null}} | {{True}, {GreaterP[0 * Meter]}},
		False,
		_,
		True
	];

	(* throw a message if needed *)
	invalidTrimOptions = If[conflictingTrimOptionsQ,
		If[!gatherTests, Message[Error::GCTrimColumnConflict]];
		{TrimColumn, TrimColumnLength},
		{}
	];

	(* create a test *)
	conflictingTrimOptionsTest = If[gatherTests,
		Test["A TrimColumnLength is only specified if TrimColumn is True:",
			conflictingTrimOptionsQ,
			False
		],
		{}
	];

	(* === Resolve the separation method that will be used by the experiment === *)

	(* check to make sure there weren't any bad inlet options specified *)



	(* === Error: Incompatible inlet options (solvent vent and split ratio/flowrate, both split ratio and split flowrate set) are specified. === *)

	cospecifiedOptionsTuples = MapThread[
		Function[
			{
				splitRatios, splitVentFlowRates, solventEliminationFlowRates,
				prefix
			},
			Module[
				{
					cospecifiedSplitFlowRatesQ, cospecifiedSplitFlowRatesTest, splitOptionSpecifiedQ, solventEliminationFlowRateSpecifiedQ, splitAndSolventEliminationCospecifiedQ,
					cospecifiedSplitAndSolventEliminationFlowRatesTest, cospecifiedSplitFlowRatesOptions, splitRatioSpecifiedQ, splitVentFlowRateSpecifiedQ, splitRatioAndSolventEliminationCospecifiedQ,
					splitVentFlowRateAndSolventEliminationCospecifiedQ, cospecifiedSplitSolventFlowRatesOptions
				},

				(* determine which options have been specified *)
				{splitRatioSpecifiedQ, splitVentFlowRateSpecifiedQ, solventEliminationFlowRateSpecifiedQ} = Transpose@MapThread[
					Function[
						{splitRatio, splitVentFlowRate, solventEliminationFlowRate},
						Map[
							Function[{var},
								MatchQ[var, Except[Null | Automatic]]
							],
							{splitRatio, splitVentFlowRate, solventEliminationFlowRate}
						]
					],
					{splitRatios, splitVentFlowRates, solventEliminationFlowRates}
				];

				(* === Split options cospecified === *)
				(* check that nothing is cospecified incorrectly *)
				cospecifiedSplitFlowRatesQ = MapThread[
					Function[{splitRatioQ, splitVentFlowRateQ},
						And[splitRatioQ, splitVentFlowRateQ]
					],
					{
						splitRatioSpecifiedQ,
						splitVentFlowRateSpecifiedQ
					}
				];

				cospecifiedSplitFlowRatesOptions = If[Or @@ cospecifiedSplitFlowRatesQ,
					prependSymbol[
						{SplitRatio, SplitVentFlowRate},
						prefix
					],
					{}
				];

				(* if there is a cospecification issue throw an error *)
				If[Or @@ cospecifiedSplitFlowRatesQ && !gatherTests,
					Message[Error::SplitRatioAndFlowRateCospecified]
				];

				(* otherwise gather tests *)
				cospecifiedSplitFlowRatesTest = ToList@If[gatherTests,
					Test["No samples have both a " <> prefix <> "SplitRatio and " <> prefix <> "SplitVentFlowRate specified:",
						Or @@ cospecifiedSplitFlowRatesQ,
						False
					],
					{}
				];

				(*=== split and solvent elimination flow rates cospecified ===*)

				(* make sure no split/vent options are cospecified *)
				{splitRatioAndSolventEliminationCospecifiedQ, splitVentFlowRateAndSolventEliminationCospecifiedQ} = Transpose@MapThread[
					Function[{splitRatioQ, splitVentFlowRateQ, solventEliminationQ},
						{
							splitRatioQ && solventEliminationQ,
							splitVentFlowRateQ && solventEliminationQ
						}
					],
					{
						splitRatioSpecifiedQ,
						splitVentFlowRateSpecifiedQ,
						solventEliminationFlowRateSpecifiedQ
					}
				];

				splitAndSolventEliminationCospecifiedQ = Or @@ Flatten[{splitRatioAndSolventEliminationCospecifiedQ}];

				cospecifiedSplitSolventFlowRatesOptions = If[Or @@ splitAndSolventEliminationCospecifiedQ,
					prependSymbol[
						{SplitRatio, SolventEliminationFlowRate(*,SplitVentFlowRate*)},
						prefix
					],
					{}
				];

				(* if there is a cospecification issue throw an error *)
				If[Or @@ splitAndSolventEliminationCospecifiedQ && !gatherTests,
					Message[Error::GCOptionsAreConflicting, "{SplitRatio,SplitVentFlowRate}", "SolventEliminationFlowRate", "any value"]
				];

				(* otherwise gather tests *)
				cospecifiedSplitAndSolventEliminationFlowRatesTest = ToList@If[gatherTests,
					Test["No samples have either " <> prefix <> "SplitRatio or " <> prefix <> "SplitVentFlowRate specified while " <> prefix <> "SolventEliminationFlowRate is specified:",
						Or @@ splitAndSolventEliminationCospecifiedQ,
						False
					],
					{}
				];

				(* return the tests *)
				{
					Flatten[{cospecifiedSplitFlowRatesOptions, cospecifiedSplitSolventFlowRatesOptions}],
					Flatten[{cospecifiedSplitFlowRatesTest, cospecifiedSplitAndSolventEliminationFlowRatesTest}]
				}
			]
		],
		{
			{specifiedSplitRatios, specifiedStandardSplitRatios, specifiedBlankSplitRatios},
			{specifiedSplitVentFlowRates, specifiedStandardSplitVentFlowRates, specifiedBlankSplitVentFlowRates},
			{specifiedSolventEliminationFlowRates, specifiedStandardSolventEliminationFlowRates, specifiedBlankSolventEliminationFlowRates},
			{"", "Standard", "Blank"}
		}
	];

	{cospecifiedOptionsOptions, cospecifiedOptionsTests} = {cospecifiedOptionsTuples[[All, 1]], cospecifiedOptionsTuples[[All, 2]]};

	(* === Resolve Inlet Liner === *)

	(* Resolve InletLiner based on the specified InletModes. Any totally unspecified InletModes will be set to Split (or maybe should be whichever inletmode is already specified and in the majority), so Automatic counts as a split type. *)

	specifiedInletLiner = Lookup[roundedGasChromatographyOptions, InletLiner];

	{specifiedInletModes, specifiedStandardInletModes, specifiedBlankInletModes} = Map[
		Function[{opsList},
			Module[{splitRatios, splitVentFlowRates, splitlessTimes, initialInletPressures, solventEliminationFlowRates, initialInletTimes, samplesLength},
				{splitRatios, splitVentFlowRates, splitlessTimes, initialInletPressures, solventEliminationFlowRates, initialInletTimes, samplesLength} = opsList;
				MapThread[
					Function[{splitRatio, splitVentFlowRate, splitlessTime, initialInletPressure, solventEliminationFlowRate, initialInletTime},
						Switch[
							{splitRatio, splitVentFlowRate, splitlessTime, initialInletPressure, solventEliminationFlowRate, initialInletTime, samplesLength},
							{_, _, _, _, _, _, EqualP[0]},
							Null,
							Alternatives[
								{Except[Null], (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), GreaterP[0]},
								{(Automatic | Null), Except[Null], (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), GreaterP[0]}
							],
							Split,
							Alternatives[
								{(Automatic | Null), _, Except[Null], (Automatic | Null), (Automatic | Null), (Automatic | Null), GreaterP[0]}
							],
							Splitless,
							Alternatives[
								{Except[Null], (Automatic | Null), (Automatic | Null), _, (Automatic | Null), _, GreaterP[0]},
								{(Automatic | Null), Except[Null], (Automatic | Null), _, (Automatic | Null), _, GreaterP[0]},
								{(Automatic), (Automatic | Null), (Automatic | Null), _, (Automatic | Null), _, GreaterP[0]},
								{(Automatic | Null), (Automatic), (Automatic | Null), _, (Automatic | Null), _, GreaterP[0]}
							],
							PulsedSplit,
							{(Automatic | Null), _, Except[Null], _, (Automatic | Null), _, GreaterP[0]},
							PulsedSplitless,
							{(Automatic | Null), _, _, _, Except[Null], _, GreaterP[0]},
							SolventVent,
							{Null, Null, Null, (Automatic | Null), (Automatic | Null), (Automatic | Null), GreaterP[0]},
							DirectInjection,
							{_, _, _, _, _, _, GreaterP[0]},
							$Failed (* error checking should catch anything that would produce this result *)
						]
					],
					{splitRatios, splitVentFlowRates, splitlessTimes, initialInletPressures, solventEliminationFlowRates, initialInletTimes}
				]
			]
		],
		{
			{
				specifiedSplitRatios,
				specifiedSplitVentFlowRates,
				specifiedSplitlessTimes,
				specifiedInitialInletPressures,
				specifiedSolventEliminationFlowRates,
				specifiedInitialInletTimes,
				Length[mySamples]
			},
			{
				specifiedStandardSplitRatios,
				specifiedStandardSplitVentFlowRates,
				specifiedStandardSplitlessTimes,
				specifiedStandardInitialInletPressures,
				specifiedStandardSolventEliminationFlowRates,
				specifiedStandardInitialInletTimes,
				standardExpansionLength
			},
			{
				specifiedBlankSplitRatios,
				specifiedBlankSplitVentFlowRates,
				specifiedBlankSplitlessTimes,
				specifiedBlankInitialInletPressures,
				specifiedBlankSolventEliminationFlowRates,
				specifiedBlankInitialInletTimes,
				blankExpansionLength
			}
		}
	];

	combinedInletModes = DeleteCases[Flatten@Join[specifiedInletModes, specifiedStandardInletModes, specifiedBlankInletModes], Null];

	resolvedInletLiner = Switch[
		{specifiedInletLiner, combinedInletModes},
		(* If the InletLiner is specified, use that liner *)
		{Except[Automatic], _},
		specifiedInletLiner,
		(* If only split modes are specified *)
		{Automatic, {(Automatic | Split | PulsedSplit)..}},
		Model[Item, GCInletLiner, "GC inlet liner, split, single taper, glass wool, deactivated, low pressure drop"],
		(* If only splitless modes are specified *)
		{Automatic, {(Splitless | PulsedSplitless | DirectInjection | SolventVent)..}},
		Model[Item, GCInletLiner, "GC inlet liner, splitless, single taper, glass wool, deactivated"],
		(* A mixture of types is specified *)
		{Automatic, {GCInletModeP..}},
		Model[Item, GCInletLiner, "GC inlet liner, split, single taper, glass wool, deactivated, low pressure drop"],
		(* we failed to resolve a mode for some reason: definitely error check *)
		{Automatic, {___}},
		Model[Item, GCInletLiner, "GC inlet liner, split, single taper, glass wool, deactivated, low pressure drop"]
	];

	(* get the inlet liner *)
	inletLinerPacket = fetchPacketFromCache[resolvedInletLiner, cache];
	inletLinerVolume = If[MatchQ[inletLinerPacket, ObjectP[Model[Item, GCInletLiner]]],
		Lookup[inletLinerPacket, Volume],
		Lookup[fetchPacketFromCache[Lookup[inletLinerPacket, Model], cache], Volume]
	] /. {_Missing -> Null};

	(* === Resolve Column Joins === *)

	(* Skip this for now and only use Ultimetal *)

	(* === SamplingMethod, AliquotContainer, and AliquotAmount === *)

	(* Get the specifiedSamplingMethods *)
	specifiedSamplingMethods = Lookup[roundedGasChromatographyOptions, SamplingMethod];
	specifiedStandardSamplingMethods = Lookup[expandedStandardsAssociation, StandardSamplingMethod];
	specifiedBlankSamplingMethods = Lookup[expandedBlanksAssociation, BlankSamplingMethod];

	(* round up some of the options that are shared between multiple sampling methods *)

	{specifiedAgitateWhileSamplings, specifiedStandardAgitateWhileSamplings, specifiedBlankAgitateWhileSamplings} = {Lookup[roundedGasChromatographyOptions, AgitateWhileSampling], Lookup[expandedStandardsAssociation, StandardAgitateWhileSampling], Lookup[expandedBlanksAssociation, BlankAgitateWhileSampling]};

	(* pre-resolve the samplingMethod for each sample, standard, and blank *)

	{preResolvedSamplingMethods, preResolvedStandardSamplingMethods, preResolvedBlankSamplingMethods} = Map[
		Function[{optionsList},
			Module[{samplingMethodOptionsSpecifiedQ, samplingMethodOptionsSpecified, preResolvedMethods, liquidSamplingOptions, headspaceSamplingOptions, spmeSamplingOptions, samplingMethods, liquidHeadspaceSharedOptions, headspaceSPMEsharedOptions},

				(* pull the specified variables into the code *)
				{liquidSamplingOptions, headspaceSamplingOptions, spmeSamplingOptions, samplingMethods, liquidHeadspaceSharedOptions, headspaceSPMEsharedOptions} = optionsList;
				(* Pre-resolve the SamplingMethods in case any SamplingMethod options have already been specified *)

				(* Create a matrix to describe whether Liquid, Heaspace, or SPME options are specified for each sample *)
				samplingMethodOptionsSpecifiedQ = MapThread[
					Function[{liquidOptions, headspaceOptions, spmeOptions, liquidHeadspaceShared, headspaceSPMEShared},
						{
							MemberQ[liquidOptions, Except[(Automatic | Null)]] || (MemberQ[liquidHeadspaceShared, Except[(Automatic | Null)]] && !MemberQ[headspaceOptions, Except[(Automatic | Null)]]),
							MemberQ[headspaceOptions, Except[(Automatic | Null)]] || (MemberQ[headspaceSPMEShared, Except[(Automatic | Null)]] && !MemberQ[spmeOptions, Except[(Automatic | Null)]]),
							MemberQ[spmeOptions, Except[(Automatic | Null)]]
						}],
					{Transpose@liquidSamplingOptions, Transpose@headspaceSamplingOptions, Transpose@spmeSamplingOptions, Transpose@liquidHeadspaceSharedOptions, Transpose@headspaceSPMEsharedOptions}
				];

				(* Determine which SamplingMethod options were specified for each sample *)
				samplingMethodOptionsSpecified = Map[
					PickList[{LiquidInjection, HeadspaceInjection, SPMEInjection}, #, True]&,
					samplingMethodOptionsSpecifiedQ
				];

				(* Pre-resolve the sampling methods only if the SamplingMethod is not already specified *)
				preResolvedMethods = MapThread[
					Switch[
						{Length[#1], #2},
						(* If the method is specified or no options are specified, pass through the specifiedSamplingMethod (probably Automatic) *)
						({_, Except[Automatic]} | {0, _}),
						#2,
						(* If options for 1 method are specified and the SamplingMethod is Automatic, resolve to that method *)
						{1, Automatic},
						First[#1],
						(* If options for more than 1 method are specified and the SamplingMethod is Automatic, give a $Failed *)
						{GreaterP[1], Automatic},
						$Failed
					]&,
					{samplingMethodOptionsSpecified, samplingMethods}
				]
			]
		],
		{
			{specifiedLiquidSamplingOptions, specifiedHeadspaceSamplingOptions, specifiedSPMESamplingOptions, specifiedSamplingMethods, {PadRight[{}, Length[mySamples], Null]}, {specifiedAgitateWhileSamplings}},
			{specifiedStandardLiquidSamplingOptions, specifiedStandardHeadspaceSamplingOptions, specifiedStandardSPMESamplingOptions, specifiedStandardSamplingMethods, {expandedStandardNull}, {specifiedStandardAgitateWhileSamplings}},
			{specifiedBlankLiquidSamplingOptions, specifiedBlankHeadspaceSamplingOptions, specifiedBlankSPMESamplingOptions, specifiedBlankSamplingMethods, {expandedBlankNull}, {specifiedBlankAgitateWhileSamplings}}
		}
	];

	(* Resolve the standards and blanks here as well *)

	(* Download the State, Mass, and Volume of each sample and standard, create a dummy list for blanks *)

	(* we have to make sure we aren't trying to find the mass/volume of models here *)
	{sampleStates, sampleMasses, sampleVolumes} = If[
		MemberQ[mySamples, _Model],
		Transpose@Map[
			Function[{standard},
				If[MatchQ[standard, _Model],
					{Download[standard, State, Cache -> cache, Simulation-> updatedSimulation, Date -> Now], ModelNoMass, ModelNoVolume},
					Download[standard, {State, Mass, Volume}, Cache -> cache, Simulation-> updatedSimulation, Date -> Now]
				]
			],
			mySamples
		],
		(* we need to change this to download the simulated samples instead of the samples *)
		Transpose@Download[mySamples, {State, Mass, Volume}, Cache -> cache, Simulation-> updatedSimulation, Date -> Now]
	];

	{standardStates, standardMasses, standardVolumes} = Which[
		MatchQ[resolvedStandards, {Null}],
		{{Null}, {Null}, {Null}},
		MemberQ[resolvedStandards, ObjectP[]],
		Transpose@Map[
			Function[{standard},
				Switch[standard,
					ObjectP[Model[]],
					{Download[standard, State, Cache -> cache, Simulation-> updatedSimulation, Date -> Now], ModelNoMass, ModelNoVolume},
					ObjectP[],
					Download[standard, {State, Mass, Volume}, Cache -> cache, Simulation-> updatedSimulation, Date -> Now],
					_,
					{Null, Null, Null}
				]
			],
			resolvedStandards
		],
		True,
		Transpose@Download[resolvedStandards, {State, Mass, Volume}, Cache -> cache, Simulation-> updatedSimulation, Date -> Now]
	];

	{blankStates, blankMasses, blankVolumes} = Which[
		MatchQ[resolvedBlanks, {Null}],
		{{Null}, {Null}, {Null}},
		MemberQ[resolvedBlanks, ObjectP[] | NoInjection],
		Transpose@Map[
			Function[{standard},
				Switch[
					standard,
					ObjectP[Model[]],
					{Download[standard, State, Cache -> cache, Simulation-> updatedSimulation, Date -> Now], ModelNoMass, ModelNoVolume},
					ObjectP[],
					Download[standard, {State, Mass, Volume}, Cache -> cache, Simulation-> updatedSimulation, Date -> Now],
					_,
					{Null, Null, Null}
				]
			],
			resolvedBlanks
		],
		(* give it a try I guess *)
		True,
		Transpose@Download[resolvedBlanks, {State, Mass, Volume}, Cache -> cache, Simulation-> updatedSimulation, Date -> Now]
	];

	(* Resolve SamplingMethod *)

	{resolvedSamplingMethods, resolvedStandardSamplingMethods, resolvedBlankSamplingMethods} = Map[
		Function[{optionsList},
			Module[{samplingMethods, states, preResolvedMethods},
				{states, preResolvedMethods} = optionsList;
				samplingMethods = MapThread[
					Switch[
						{#1, #2},
						{_, (LiquidInjection | HeadspaceInjection | SPMEInjection)},
						#2,
						{Liquid, Automatic},
						LiquidInjection,
						{Solid, Automatic},
						HeadspaceInjection,
						{_, Automatic},
						LiquidInjection,
						{_, Null|{}},
						Null
					]&,
					{states, preResolvedMethods}
				]
			]
		],
		{
			{sampleStates, preResolvedSamplingMethods},
			{standardStates, preResolvedStandardSamplingMethods},
			{blankStates, preResolvedBlankSamplingMethods}
		}
	];

	(* combine all sampling methods for later use *)
	allSamplingMethods = Flatten[
		{
			resolvedSamplingMethods,
			If[standardExistsQ,
				resolvedStandardSamplingMethods,
				{}
			],
			If[blankExistsQ,
				resolvedBlankSamplingMethods,
				{}
			]
		}
	];

	(* split some shared option parameters into liquid and headspace *)

	(* get the options with shared parameters *)
	{specifiedInjectionVolumes, specifiedSampleAspirationRates, specifiedSampleAspirationDelays, specifiedSampleInjectionRates} = Lookup[roundedGasChromatographyOptions,
		{InjectionVolume, SampleAspirationRate, SampleAspirationDelay, SampleInjectionRate}];
	{specifiedStandardInjectionVolumes, specifiedStandardSampleAspirationRates, specifiedStandardSampleAspirationDelays, specifiedStandardSampleInjectionRates} = Lookup[expandedStandardsAssociation,
		{StandardInjectionVolume, StandardSampleAspirationRate, StandardSampleAspirationDelay, StandardSampleInjectionRate}];
	{specifiedBlankInjectionVolumes, specifiedBlankSampleAspirationRates, specifiedBlankSampleAspirationDelays, specifiedBlankSampleInjectionRates} = Lookup[expandedBlanksAssociation,
		{BlankInjectionVolume, BlankSampleAspirationRate, BlankSampleAspirationDelay, BlankSampleInjectionRate}];

	(* split them, and do so for all injectables *)
	{
		{
			{specifiedLiquidSampleVolumes, specifiedHeadspaceSampleVolumes},
			{specifiedLiquidSampleAspirationRates, specifiedHeadspaceSampleAspirationRates},
			{specifiedLiquidSampleAspirationDelays, specifiedHeadspaceSampleAspirationDelays},
			{specifiedLiquidSampleInjectionRates, specifiedHeadspaceSampleInjectionRates}
		},
		{
			{specifiedStandardLiquidSampleVolumes, specifiedStandardHeadspaceSampleVolumes},
			{specifiedStandardLiquidSampleAspirationRates, specifiedStandardHeadspaceSampleAspirationRates},
			{specifiedStandardLiquidSampleAspirationDelays, specifiedStandardHeadspaceSampleAspirationDelays},
			{specifiedStandardLiquidSampleInjectionRates, specifiedStandardHeadspaceSampleInjectionRates}
		},
		{
			{specifiedBlankLiquidSampleVolumes, specifiedBlankHeadspaceSampleVolumes},
			{specifiedBlankLiquidSampleAspirationRates, specifiedBlankHeadspaceSampleAspirationRates},
			{specifiedBlankLiquidSampleAspirationDelays, specifiedBlankHeadspaceSampleAspirationDelays},
			{specifiedBlankLiquidSampleInjectionRates, specifiedBlankHeadspaceSampleInjectionRates}
		}
	} = Map[
		Function[{optionsList},
			Module[{samplingMethodsInternal, injectionVolumes, aspirationRates, aspirationDelays, injectionRates},
				{samplingMethodsInternal, injectionVolumes, aspirationRates, aspirationDelays, injectionRates} = optionsList;
				Map[
					Transpose@MapThread[
						Function[{injectionParameter, samplingMethod},
							Switch[{injectionParameter, samplingMethod},
								{_, LiquidInjection}, {injectionParameter, Null},
								{_, HeadspaceInjection}, {Null, injectionParameter},
								{_, Except[LiquidInjection | HeadspaceInjection]}, {Null, Null}
							]] ,
						{#, samplingMethodsInternal}
					]&,
					{injectionVolumes, aspirationRates, aspirationDelays, injectionRates}
				]
			]
		],
		{
			{resolvedSamplingMethods, specifiedInjectionVolumes, specifiedSampleAspirationRates, specifiedSampleAspirationDelays, specifiedSampleInjectionRates},
			{resolvedStandardSamplingMethods, specifiedStandardInjectionVolumes, specifiedStandardSampleAspirationRates, specifiedStandardSampleAspirationDelays, specifiedStandardSampleInjectionRates},
			{resolvedBlankSamplingMethods, specifiedBlankInjectionVolumes, specifiedBlankSampleAspirationRates, specifiedBlankSampleAspirationDelays, specifiedBlankSampleInjectionRates}
		}
	];

	{allSpecifiedLiquidInjectionVolumes, allSpecifiedHeadspaceInjectionVolumes} = Flatten /@ {
		{
			specifiedLiquidSampleVolumes,
			specifiedStandardLiquidSampleVolumes,
			specifiedBlankLiquidSampleVolumes
		},
		{
			specifiedHeadspaceSampleVolumes,
			specifiedStandardHeadspaceSampleVolumes,
			specifiedBlankHeadspaceSampleVolumes
		}
	};

	(* split the shared option parameters into headspace and SPME *)

	{
		{specifiedHeadspaceAgitateWhileSamplings, specifiedSPMEAgitateWhileSamplings},
		{specifiedStandardHeadspaceAgitateWhileSamplings, specifiedStandardSPMEAgitateWhileSamplings},
		{specifiedBlankHeadspaceAgitateWhileSamplings, specifiedBlankSPMEAgitateWhileSamplings}
	} = MapThread[
		Transpose@MapThread[
			Function[{injectionParameter, samplingMethod},
				Switch[{injectionParameter, samplingMethod},
					{_, HeadspaceInjection}, {injectionParameter, Null},
					{_, SPMEInjection}, {Null, injectionParameter},
					{_, Except[SPMEInjection | HeadspaceInjection]}, {Null, Null}
				]] ,
			{#1, #2}
		]&,
		{
			{specifiedAgitateWhileSamplings, specifiedStandardAgitateWhileSamplings, specifiedBlankAgitateWhileSamplings},
			{resolvedSamplingMethods, resolvedStandardSamplingMethods, resolvedBlankSamplingMethods}
		}
	];

	(* Resolve the dilutionBooleans *)

	{resolvedDilutes, resolvedStandardDilutes, resolvedBlankDilutes} = Map[
		Function[{optionsList},
			Module[{diluteBooleans, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes},
				{diluteBooleans, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes} = optionsList;
				MapThread[Switch[
					#1,
					BooleanP,
					#1,
					Automatic,
					If[MemberQ[{#2, #3, #4}, Except[(Null | Automatic)]],
						True,
						False
					],
					Null,
					Null
				]&,
					{diluteBooleans, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes}
				]
			]
		],
		{
			{specifiedDiluteBooleans, specifiedDilutionSolventVolumes, specifiedSecondaryDilutionSolventVolumes, specifiedTertiaryDilutionSolventVolumes},
			{specifiedStandardDiluteBooleans, specifiedStandardDilutionSolventVolumes, specifiedStandardSecondaryDilutionSolventVolumes, specifiedStandardTertiaryDilutionSolventVolumes},
			{specifiedBlankDiluteBooleans, specifiedBlankDilutionSolventVolumes, specifiedBlankSecondaryDilutionSolventVolumes, specifiedBlankTertiaryDilutionSolventVolumes}
		}
	];

	(* Get specified dilution solvents *)
	{specifiedDilutionSolvent, specifiedSecondaryDilutionSolvent, specifiedTertiaryDilutionSolvent} = Lookup[roundedGasChromatographyOptions, {DilutionSolvent, SecondaryDilutionSolvent, TertiaryDilutionSolvent}];

	(* resolve the dilution solvents *)
	(* Right now we're going to check to see if they are specified. If not specified but dilutions using this solvent are specified, specify the model as Hexane *)

	{resolvedDilutionSolvent, resolvedSecondaryDilutionSolvent, resolvedTertiaryDilutionSolvent} = MapThread[
		Switch[
			#1,
			(* If one is already specified, leave it *)
			Except[Automatic],
			#1,
			(* If Automatic, and a numberOfSolventWashes is specified, resolve to Hexane and throw a warning *)
			Automatic,
			If[!gatherTests,
				If[MemberQ[#2, _Quantity],
					Message[Warning::AutomaticallySelectedDilutionSolvent, #3];
					Model[Sample, "Hexanes"],
					Null
				],
				If[MemberQ[#2, _Quantity],
					Model[Sample, "Hexanes"],
					Null
				]
			]
		]&,
		{
			{specifiedDilutionSolvent, specifiedSecondaryDilutionSolvent, specifiedTertiaryDilutionSolvent},
			{Join[specifiedDilutionSolventVolumes, specifiedStandardDilutionSolventVolumes, specifiedBlankDilutionSolventVolumes],
				Join[specifiedSecondaryDilutionSolventVolumes, specifiedStandardSecondaryDilutionSolventVolumes, specifiedBlankSecondaryDilutionSolventVolumes],
				Join[specifiedTertiaryDilutionSolventVolumes, specifiedStandardTertiaryDilutionSolventVolumes, specifiedBlankTertiaryDilutionSolventVolumes]},
			{"", "Secondary", "Tertiary"}
		}
	];

	(* Count how many dilutionSolvents are specified *)
	numberOfDilutionSolventsSpecified = Length[Cases[
		{resolvedDilutionSolvent, resolvedSecondaryDilutionSolvent, resolvedTertiaryDilutionSolvent},
		ObjectP[{Model[Sample], Object[Sample]}]
	]];

	{dilutionSolventSpecifiedQ, secondaryDilutionSolventSpecifiedQ, tertiaryDilutionSolventSpecifiedQ} = Map[!NullQ[#]&, {resolvedDilutionSolvent, resolvedSecondaryDilutionSolvent, resolvedTertiaryDilutionSolvent}];

	(* Resolve targetContainers and requiredAliquotAmounts. *)

	(* we need to get the containers of the standards and blanks, in case specific objects were indicated *)
	{standardContainers, blankContainers} = Map[
		Function[{sampleList},
			Map[
				Function[{sample},
					If[MatchQ[sample, ObjectP[Object[Sample]]],
						Download[sample, Container, Cache -> cache, Simulation -> updatedSimulation],
						Null
					]
				],
				sampleList
			]
		],
		{resolvedStandards, resolvedBlanks}
	];

	(* === MapThread to resolve DilutionSolventVolume, SecondaryDilutionSolventVolume, TertiaryDilutionSolventVolume, Agitate, AgitationTemperature, AgitationMixRate, AgitationTime, AgitationOnTime, AgitationOffTime, Vortex, VortexMixRate, VortexTime === *)

	(* Agitate *)
	(* resolve the sample and standard agitation parameters *)

	{
		{resolvedAgitates, resolvedAgitationTemperatures, resolvedAgitationTimes, resolvedAgitationMixRates, resolvedAgitationOnTimes, resolvedAgitationOffTimes},
		{resolvedStandardAgitates, resolvedStandardAgitationTemperatures, resolvedStandardAgitationTimes, resolvedStandardAgitationMixRates, resolvedStandardAgitationOnTimes, resolvedStandardAgitationOffTimes},
		{resolvedBlankAgitates, resolvedBlankAgitationTemperatures, resolvedBlankAgitationTimes, resolvedBlankAgitationMixRates, resolvedBlankAgitationOnTimes, resolvedBlankAgitationOffTimes}
	} = Map[
		Function[{optionsList},
			Module[{agitates, agitateBooleans, agitationTemperatures, agitationMixRates, agitationTimes, agitationOnTimes, agitationOffTimes, resolvedTemperatures, resolvedTimes, resolvedMixRates, resolvedOnTimes, resolvedOffTimes, samplingMethods},
				{agitateBooleans, agitationTemperatures, agitationMixRates, agitationTimes, agitationOnTimes, agitationOffTimes, samplingMethods} = optionsList;
				(* === FUNCTION === *)

				(* Resolve the agitateBooleans *)
				agitates = MapThread[Switch[
					#1,
					BooleanP,
					#1,
					Automatic,
					If[MemberQ[{#2, #3, #4, #5, #6}, Except[(Null | Automatic)]] || MatchQ[#7, HeadspaceInjection],
						True,
						False
					],
					Null,
					Null
				]&,
					{agitateBooleans, agitationTemperatures, agitationMixRates, agitationTimes, agitationOnTimes, agitationOffTimes, samplingMethods}
				];

				(* Resolve the Agitation parameters *)
				{resolvedTemperatures, resolvedTimes, resolvedMixRates, resolvedOnTimes, resolvedOffTimes} = MapThread[
					MapThread[
						Function[{agitateBoolean, agitateParameter},
							Switch[
								{agitateBoolean, agitateParameter},
								(* If the parameter is already specified, then leave it as is.*)
								{_, Except[Automatic]},
								agitateParameter,
								(* If agitate is False, any Automatic agitation parameter should be set to Null *)
								{False, Automatic},
								Null,
								(* If agitate is True, any Automatic agitation parameter should be set to its default *)
								{True, Automatic},
								#2,
								{Null, Null},
								Null
							]
						],
						{agitates, #1}
					]&,
					{{agitationTemperatures, agitationTimes, agitationMixRates, agitationOnTimes, agitationOffTimes}, {Ambient, 0.2 * Minute, 250 * RPM, 5 * Second, 2 * Second}}
				];

				(* Return the resolved options *)
				{agitates, resolvedTemperatures, resolvedTimes, resolvedMixRates, resolvedOnTimes, resolvedOffTimes}

				(* === FUNCTION === *)
			]
		],
		{
			{specifiedAgitateBooleans, specifiedAgitationTemperatures, specifiedAgitationMixRates, specifiedAgitationTimes, specifiedAgitationOnTimes, specifiedAgitationOffTimes, resolvedSamplingMethods},
			{specifiedStandardAgitateBooleans, specifiedStandardAgitationTemperatures, specifiedStandardAgitationMixRates, specifiedStandardAgitationTimes, specifiedStandardAgitationOnTimes, specifiedStandardAgitationOffTimes, resolvedStandardSamplingMethods},
			{specifiedBlankAgitateBooleans, specifiedBlankAgitationTemperatures, specifiedBlankAgitationMixRates, specifiedBlankAgitationTimes, specifiedBlankAgitationOnTimes, specifiedBlankAgitationOffTimes, resolvedBlankSamplingMethods}
		}
	];

	(* error check all the agitation options *)
	agitationConflictTuples = Map[
		Function[opsList,
			Module[
				{
					method, boolean, temperatures, times, mixRates, onTimes, offTimes, prefix, liquidInjectionAgitationConflicts, liquidInjectionAgitationTemperatureConflicts,
					liquidInjectionAgitationTimeConflicts, liquidInjectionAgitationMixRateConflicts, liquidInjectionAgitationOnTimeConflicts, liquidInjectionAgitationOffTimeConflicts,
					liquidInjectionAgitationConflictTests, liquidInjectionAgitationBooleanConflicts, liquidInjectionAgitationConflictTest, conflictingOptions, conflictingLiquidInjectionOptions,
					conflictingAgitateBooleanOptions, agitationBooleanAgitationTemperatureConflicts, agitationBooleanAgitationTimeConflicts, agitationBooleanAgitationMixRateConflicts,
					agitationBooleanAgitationOnTimeConflicts, agitationBooleanAgitationOffTimeConflicts, agitateBooleanAgitationConflicts, agitateBooleanAgitationConflictTest,
					agitateWhileSamplings, agitateWhileSamplingConflicts, agitateWhileSamplingConflictsQ, conflictingAgitateWhileSamplingOptions, liquidInjectionAgitateWhileSamplingConflictTest
				},
				{method, boolean, temperatures, times, mixRates, onTimes, offTimes, agitateWhileSamplings, prefix} = opsList;
				(* figure out if we have an agitate option specified when we're trying to do a liquid injection *)
				(* with autosampler primitives this will be possible, but I'm considering the options here to represent only the behavior at injection time *)

				(* figure out which options are broken *)
				(* conflicts with SamplingMethod *)
				{
					liquidInjectionAgitationBooleanConflicts,
					liquidInjectionAgitationTemperatureConflicts,
					liquidInjectionAgitationTimeConflicts,
					liquidInjectionAgitationMixRateConflicts,
					liquidInjectionAgitationOnTimeConflicts,
					liquidInjectionAgitationOffTimeConflicts
				} = Transpose@MapThread[
					Function[
						{samplingMethod, agitateQ, temperature, time, mixRate, onTime, offTime},
						{
							MatchQ[samplingMethod, LiquidInjection] && MatchQ[agitateQ, True],
							MatchQ[samplingMethod, LiquidInjection] && MatchQ[temperature, Except[Null]],
							MatchQ[samplingMethod, LiquidInjection] && MatchQ[time, Except[Null]],
							MatchQ[samplingMethod, LiquidInjection] && MatchQ[mixRate, Except[Null]],
							MatchQ[samplingMethod, LiquidInjection] && MatchQ[onTime, Except[Null]],
							MatchQ[samplingMethod, LiquidInjection] && MatchQ[offTime, Except[Null]]
						}
					],
					{method, boolean, temperatures, times, mixRates, onTimes, offTimes}
				];

				(* conflicts with agitate boolean *)
				{
					agitationBooleanAgitationTemperatureConflicts,
					agitationBooleanAgitationTimeConflicts,
					agitationBooleanAgitationMixRateConflicts,
					agitationBooleanAgitationOnTimeConflicts,
					agitationBooleanAgitationOffTimeConflicts
				} = Transpose@MapThread[
					Function[
						{samplingMethod, agitateQ, temperature, time, mixRate, onTime, offTime},
						{
							(MatchQ[agitateQ, True] && MatchQ[temperature, Null]) || (MatchQ[agitateQ, False] && MatchQ[temperature, Except[Null]]),
							(MatchQ[agitateQ, True] && MatchQ[time, Null]) || (MatchQ[agitateQ, False] && MatchQ[time, Except[Null]]),
							(MatchQ[agitateQ, True] && MatchQ[mixRate, Null]) || (MatchQ[agitateQ, False] && MatchQ[mixRate, Except[Null]]),
							(MatchQ[agitateQ, True] && MatchQ[onTime, Null]) || (MatchQ[agitateQ, False] && MatchQ[onTime, Except[Null]]),
							(MatchQ[agitateQ, True] && MatchQ[offTime, Null]) || (MatchQ[agitateQ, False] && MatchQ[offTime, Except[Null]])
						}
					],
					{method, boolean, temperatures, times, mixRates, onTimes, offTimes}
				];

				(* conflicts with agitate while sampling *)
				agitateWhileSamplingConflicts = MapThread[
					Function[{samplingMethod, agitateWhileSampling},
						MatchQ[samplingMethod, LiquidInjection] && TrueQ[agitateWhileSampling]
					],
					{method, agitateWhileSamplings}
				];

				(* figure out if we have a problem *)
				{liquidInjectionAgitationConflicts, agitateBooleanAgitationConflicts, agitateWhileSamplingConflictsQ} = {
					Or @@ Flatten[{liquidInjectionAgitationBooleanConflicts, liquidInjectionAgitationTemperatureConflicts,
						liquidInjectionAgitationTimeConflicts, liquidInjectionAgitationMixRateConflicts, liquidInjectionAgitationOnTimeConflicts,
						liquidInjectionAgitationOffTimeConflicts}],
					Or @@ Flatten[{agitationBooleanAgitationTemperatureConflicts, agitationBooleanAgitationTimeConflicts,
						agitationBooleanAgitationMixRateConflicts, agitationBooleanAgitationOnTimeConflicts, agitationBooleanAgitationOffTimeConflicts}],
					Or @@ agitateWhileSamplingConflicts
				};

				conflictingLiquidInjectionOptions = MapThread[
					If[Or @@ #1, ToExpression@StringJoin[prefix, #2], Nothing]&,
					{
						{
							liquidInjectionAgitationConflicts,
							liquidInjectionAgitationBooleanConflicts,
							liquidInjectionAgitationTemperatureConflicts,
							liquidInjectionAgitationTimeConflicts,
							liquidInjectionAgitationMixRateConflicts,
							liquidInjectionAgitationOnTimeConflicts,
							liquidInjectionAgitationOffTimeConflicts
						},
						{
							"SamplingMethod",
							"Agitate",
							"AgitationTemperature",
							"AgitationTime",
							"AgitationMixRate",
							"AgitationOnTime",
							"AgitationOffTime"
						}
					}
				];

				conflictingAgitateBooleanOptions = MapThread[
					If[Or @@ #1, ToExpression@StringJoin[prefix, #2], Nothing]&,
					{
						{
							agitateBooleanAgitationConflicts,
							agitationBooleanAgitationTemperatureConflicts,
							agitationBooleanAgitationTimeConflicts,
							agitationBooleanAgitationMixRateConflicts,
							agitationBooleanAgitationOnTimeConflicts,
							agitationBooleanAgitationOffTimeConflicts
						},
						{
							"Agitate",
							"AgitationTemperature",
							"AgitationTime",
							"AgitationMixRate",
							"AgitationOnTime",
							"AgitationOffTime"
						}
					}
				];

				conflictingAgitateWhileSamplingOptions = MapThread[
					If[Or @@ #1, ToExpression@StringJoin[prefix, #2], Nothing]&,
					{
						{
							agitateWhileSamplingConflictsQ
						},
						{
							"AgitateWhileSampling"
						}
					}
				];

				conflictingOptions = Union[conflictingLiquidInjectionOptions, conflictingAgitateBooleanOptions, conflictingAgitateWhileSamplingOptions];

				(* if we have conflicts, throw an error *)
				If[!gatherTests,
					If[liquidInjectionAgitationConflicts,
						Message[Error::LiquidInjectionAgitationConflict, prefix, Cases[conflictingLiquidInjectionOptions, Except[ToExpression@StringJoin[prefix, "SamplingMethod"]]]],
						Nothing
					];
					If[agitateBooleanAgitationConflicts,
						Message[Error::AgitationOptionsConflict, Cases[conflictingAgitateBooleanOptions, Except[ToExpression@StringJoin[prefix, "Agitate"]]]],
						Nothing
					];
					If[agitateWhileSamplingConflictsQ,
						Message[Error::LiquidAgitateWhileSampling, prefix],
						Nothing
					],
					Nothing
				];

				(* gather relevant tests *)
				agitateBooleanAgitationConflictTest = If[gatherTests,
					Test["Agitation options are only specified if " <> prefix <> "Agitate is True:",
						agitateBooleanAgitationConflicts,
						False
					],
					{}
				];

				liquidInjectionAgitationConflictTest = If[gatherTests,
					Test[prefix <> "Agitate is not True nor are Agitation options specified if the " <> prefix <> "SamplingMethod of the injectable object is LiquidInjection:",
						liquidInjectionAgitationConflicts,
						False
					],
					{}
				];

				liquidInjectionAgitateWhileSamplingConflictTest = If[gatherTests,
					Test[prefix <> "AgitateWhileSampling is not True if the " <> prefix <> "SamplingMethod of the injectable object is LiquidInjection:",
						agitateWhileSamplingConflictsQ,
						False
					],
					{}
				];

				(* format the output *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{agitateBooleanAgitationConflictTest, liquidInjectionAgitationConflictTest, liquidInjectionAgitateWhileSamplingConflictTest}]
				}
			]
		],
		{
			{resolvedSamplingMethods, resolvedAgitates, resolvedAgitationTemperatures, resolvedAgitationTimes, resolvedAgitationMixRates, resolvedAgitationOnTimes, resolvedAgitationOffTimes, specifiedAgitateWhileSamplings, ""},
			{resolvedStandardSamplingMethods, resolvedStandardAgitates, resolvedStandardAgitationTemperatures, resolvedStandardAgitationTimes, resolvedStandardAgitationMixRates, resolvedStandardAgitationOnTimes, resolvedStandardAgitationOffTimes, specifiedStandardAgitateWhileSamplings, "Standard"},
			{resolvedBlankSamplingMethods, resolvedBlankAgitates, resolvedBlankAgitationTemperatures, resolvedBlankAgitationTimes, resolvedBlankAgitationMixRates, resolvedBlankAgitationOnTimes, resolvedBlankAgitationOffTimes, specifiedBlankAgitateWhileSamplings, "Blank"}
		}
	];

	(* split the resulting tuples to create error issues *)
	{agitationConflictOptions, agitationConflictTests} = {Flatten[agitationConflictTuples[[All, 1]]], Flatten[agitationConflictTuples[[All, 2]]]};

	(* Vortex *)

	(* Resolve the sample and standard vortex parameters *)

	{
		{resolvedVortexs, resolvedVortexMixRates, resolvedVortexTimes},
		{resolvedStandardVortexs, resolvedStandardVortexMixRates, resolvedStandardVortexTimes},
		{resolvedBlankVortexs, resolvedBlankVortexMixRates, resolvedBlankVortexTimes}
	} = Map[
		Function[{optionsList},
			Module[{vortexs, resolvedMixRates, resolvedTimes, vortexBooleans, vortexMixRates, vortexTimes},
				{vortexBooleans, vortexMixRates, vortexTimes} = optionsList;
				(* === FUNCTION === *)

				(* Resolve the vortexBooleans *)
				vortexs = MapThread[Switch[
					#1,
					BooleanP,
					#1,
					Automatic,
					If[MemberQ[{#2, #3}, Except[(Null | Automatic)]],
						True,
						False
					],
					Null,
					Null
				]&,
					{vortexBooleans, vortexMixRates, vortexTimes}
				];

				(* Resolve the Vortex parameters *)
				{resolvedMixRates, resolvedTimes} = MapThread[
					MapThread[
						Function[{vortexBoolean, vortexParameter},
							Switch[
								{vortexBoolean, vortexParameter},
								(* If vortex is False, any Automatic vortex parameter should be set to Null *)
								{False, Automatic},
								Null,
								(* If vortex is True, any Automatic vortex parameter should be set to its default *)
								{True, Automatic},
								#2,
								(* If the parameter is already specified, then leave it as is. There shouldn't be any {False,Parameter} though because of the above resolution. *)
								{BooleanP, Except[Automatic]},
								vortexParameter,
								{Null, Null},
								Null
							]
						],
						{vortexs, #1}
					]&,
					{{vortexMixRates, vortexTimes}, {750 * RPM, 10 * Second}}
				];

				{vortexs, resolvedMixRates, resolvedTimes}

				(* === FUNCTION === *)
			]
		],
		{
			{specifiedVortexBooleans, specifiedVortexMixRates, specifiedVortexTimes},
			{specifiedStandardVortexBooleans, specifiedStandardVortexMixRates, specifiedStandardVortexTimes},
			{specifiedBlankVortexBooleans, specifiedBlankVortexMixRates, specifiedBlankVortexTimes}
		}
	];

	(* error check all the vortex options *)
	vortexConflictTuples = Map[
		Function[opsList,
			Module[
				{
					boolean, times, mixRates, prefix, conflictingOptions, conflictingVortexBooleanOptions, vortexBooleanVortexTimeConflicts, vortexBooleanVortexMixRateConflicts,
					vortexBooleanVortexConflicts, vortexBooleanVortexConflictTest
				},
				{boolean, times, mixRates, prefix} = opsList;
				(* with autosampler primitives this will be possible, but I'm considering the options here to represent only the behavior at injection time *)

				(* conflicts with vortex boolean *)
				{
					vortexBooleanVortexTimeConflicts,
					vortexBooleanVortexMixRateConflicts
				} = Transpose@MapThread[
					Function[
						{vortexQ, time, mixRate},
						{
							(MatchQ[vortexQ, True] && MatchQ[time, Null]) || (MatchQ[vortexQ, False] && MatchQ[time, Except[Null]]),
							(MatchQ[vortexQ, True] && MatchQ[mixRate, Null]) || (MatchQ[vortexQ, False] && MatchQ[mixRate, Except[Null]])
						}
					],
					{boolean, times, mixRates}
				];

				(* figure out if we have a problem *)
				vortexBooleanVortexConflicts = Or @@ Flatten[{vortexBooleanVortexTimeConflicts,
					vortexBooleanVortexMixRateConflicts}];

				conflictingVortexBooleanOptions = MapThread[
					If[Or @@ #1, ToExpression@StringJoin[prefix, #2], Nothing]&,
					{
						{
							vortexBooleanVortexConflicts,
							vortexBooleanVortexTimeConflicts,
							vortexBooleanVortexMixRateConflicts
						},
						{
							"Vortex",
							"VortexTime",
							"VortexMixRate"
						}
					}
				];

				conflictingOptions = conflictingVortexBooleanOptions;

				(* if we have conflicts, throw an error *)
				If[vortexBooleanVortexConflicts && !gatherTests,
					Message[Error::VortexOptionsConflict, Cases[conflictingVortexBooleanOptions, Except[ToExpression@StringJoin[prefix, "Vortex"]]]]
				];

				(* gather relevant tests *)
				vortexBooleanVortexConflictTest = If[gatherTests,
					Test["Vortex options are only specified if " <> prefix <> "Vortex is True:",
						vortexBooleanVortexConflicts,
						False
					],
					{}
				];

				(* format the output *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{vortexBooleanVortexConflictTest}]
				}
			]
		],
		{
			{resolvedVortexs, resolvedVortexTimes, resolvedVortexMixRates, ""},
			{resolvedStandardVortexs, resolvedStandardVortexTimes, resolvedStandardVortexMixRates, "Standard"},
			{resolvedBlankVortexs, resolvedBlankVortexTimes, resolvedBlankVortexMixRates, "Blank"}
		}
	];

	(* split the resulting tuples to create error issues *)
	{vortexConflictOptions, vortexConflictTests} = {Flatten[vortexConflictTuples[[All, 1]]], Flatten[vortexConflictTuples[[All, 2]]]};

	(* Determine if a magnetic cap is required. *)
	(* Currently the compiler has the operator places the vials onto the sample rack. *)
	(* If the user requests to agitate or vortex the sample will be moved to a new rack with the magnetic mover. *)
	(* HeadspaceInjection (currently) requires agitation so we can check resolved Agitate as a proxy. *)
	magneticCapRequiredQ = MapThread[Or, {resolvedAgitates, resolvedVortexs}];
	standardMagneticCapRequiredQ = MapThread[Or, {resolvedStandardAgitates /. Null -> False, resolvedStandardVortexs /. Null -> False}];
	blankMagneticCapRequiredQ = MapThread[Or, {resolvedBlankAgitates /. Null -> False, resolvedBlankVortexs /. Null -> False}];

	(* resolve whether we need to move specified standards and blanks around if they aren't already in compatible vials *)
	{aliquotStandardQ, aliquotBlankQ} = MapThread[
		Function[
			{samples, vials, amounts, requiresMagneticCapQs},
			MapThread[
				Function[
					{sample, vial, amount, requiresMagneticCapQ},
					Which[
						NullQ[sample] || MatchQ[sample, NoInjection],
						False,
						!MatchQ[vial, Null | Automatic] || !MatchQ[amount, Null | Automatic],
						True,
						True,
						Module[{footprint, neckType, coverFootprints},
							(* get the relevant fields from the simulated cache *)
							{footprint, neckType, coverFootprints} = If[!NullQ[sample] && !MatchQ[sample, NoInjection],
								Switch[
									sample,
									(* If the sample is an object, we need to download its container model's info *)
									ObjectP[Object[]],
									Download[
										Download[sample, Container[Model], Simulation -> updatedSimulation, Date -> Now],
										{Footprint, NeckType, CoverFootprints},
										Simulation -> updatedSimulation, Date -> Now],
									(* If the sample is a model, download *)
									ObjectP[Model[]],
									{Null, Null, Null}
								],
								{Null, Null, Null}
							];
							(* check if the container is compatible *)
							If[requiresMagneticCapQ,
								!MatchQ[
									{footprint, neckType},
									Alternatives[
										(* small GC vials *)
										{CEVial, "9/425"},
										(* larger headspace vials *)
										{HeadspaceVial, "18/425"}
									]
								],
								If[!ValueQ[modelCapPackets],
									modelCapPackets = Cases[cache, PacketP[Model[Item, Cap]]]
								];
								(* If a magnetic cap is not required just check that the footprint will fit the autosampler & a pierceable cap exits for the container. *)
								Nand[MatchQ[footprint, Alternatives[CEVial, HeadspaceVial]], !MatchQ[FirstCase[modelCapPackets, KeyValuePattern[{CoverFootprint -> Alternatives@@coverFootprints, Pierceable -> True}]], Missing["NotFound"]]]
							]
						]
					]
				],
				{samples, vials, amounts, requiresMagneticCapQs}
			]
		],
		{
			{resolvedStandards, resolvedBlanks},
			{specifiedStandardVials, specifiedBlankVials},
			{specifiedStandardAmounts, specifiedBlankAmounts},
			{standardMagneticCapRequiredQ, blankMagneticCapRequiredQ}
		}
	];

	(* == Compatible container checking == *)

	(* let's update the aliquotQ check here. in order to fit on the autosampler, the vials must:
	 1. be either CEVial or HeadspaceVial footprint.
	 2. have 9/245 or 18/425 NeckType *)

	{specifiedAliquotAmounts, specifiedAssayVolumes, specifiedAliquotContainers, specifiedAliquotBoolean} = Lookup[samplePrepOptions, {AliquotAmount, AssayVolume, AliquotContainer, Aliquot}];

	(* error check any specified aliquot containers to ensure they are of the correct type *)
	compatibleAliquotContainerQ = MapThread[
		Function[{vial, requiresMagneticCapQ},
			(* if we don't specify an aliquot then it doesn't matter *)
			If[MatchQ[vial, (Null | Automatic)],
				True,
				Module[{footprint, neckType, coverFootprints},
					(* get the relevant fields from the simulated cache *)
					{footprint, neckType, coverFootprints} = If[!NullQ[vial],
						Switch[
							vial,
							ObjectP[Object[Container, Vessel]],
							Download[vial, Model[{Footprint, NeckType, CoverFootprints}], Simulation -> updatedSimulation, Date -> Now],
							ObjectP[Model[Container, Vessel]],
							Download[vial, {Footprint, NeckType, CoverFootprints}, Simulation -> updatedSimulation, Date -> Now],
							_,
							{Null, Null, Null}
						],
						{Null, Null, Null}
					];
					(* check if the vial is compatible *)
					If[requiresMagneticCapQ,
						(* If a magnetic cap is not required just check both the footprint will fit the autosampler. *)
						(* And that the neck will fit the magnetic cap. *)
						MatchQ[
							{footprint, neckType},
							Alternatives[
								(* small GC vials *)
								{CEVial, "9/425"},
								(* larger headspace vials *)
								{HeadspaceVial, "18/425"}
							]
						],
						If[!ValueQ[modelCapPackets],
							modelCapPackets =  Cases[cache, PacketP[Model[Item, Cap]]]
						];
						(* If a magnetic cap is not required just check that the footprint will fit the autosampler & a pierceable cap exits for the container. *)
						MatchQ[footprint, Alternatives[CEVial, HeadspaceVial]] && !MatchQ[FirstCase[modelCapPackets, KeyValuePattern[{CoverFootprint -> Alternatives@@coverFootprints, Pierceable -> True}]], Missing["NotFound"]]
					]
				]
			]
		],
		{specifiedAliquotContainers, magneticCapRequiredQ}
	];

	(* determine any incompatible aliquot containers *)
	incompatibleAliquotContainers = DeleteDuplicates@PickList[specifiedAliquotContainers /. {x : ObjectP[] :> Download[x, Object]}, compatibleAliquotContainerQ, False];

	(*errors*)
	incompatibleAliquotContainersOptions = If[!gatherTests,
		If[Nand @@ compatibleAliquotContainerQ,
			Message[Error::GCContainerIncompatible, "AliquotContainer", incompatibleAliquotContainers];
			AliquotContainer,
			Nothing
		],
		{}
	];

	(* tests *)
	incompatibleAliquotContainersTest = If[gatherTests,
		Test["If AliquotContainers are specified, they must have Footprint of CEVial or HeadspaceVial. If samples are to undergo on-deck agitation or vortexing the containers must also have a NeckType of 9/425 or 18/425, respectively. Otherwise, the container must be capable of being covered by a pierceable cap:",
			And @@ compatibleAliquotContainerQ,
			True],
		{}
	];

	(* decide if any samples will need to be moved into a GC compatible vial*)
	aliquotQ = MapThread[
		Function[{containerModel, aliquotAmount, aliquotContainer, aliquotBool, requiresMagneticCapQ},
			(* if the containerType is not a vessel (such as a plate), or an aliquot option is already specified we can return True early *)
			If[
				!MatchQ[containerModel, ObjectP[Model[Container, Vessel]]] || TrueQ[aliquotBool] || MatchQ[aliquotAmount, Except[Null | Automatic]] || MatchQ[aliquotContainer, Except[Null | Automatic]],
				True,
				(* otherwise we should check to see if the current container is GC compatible *)
				Module[{footprint, neckType, coverFootprints},
					(* get the relevant fields from the simulated cache *)
					{footprint, neckType, coverFootprints} = If[!NullQ[containerModel],
						Download[containerModel, {Footprint, NeckType, CoverFootprints}, Simulation -> updatedSimulation, Date -> Now],
						{Null, Null, Null}
					];

					(* check if the vial is compatible *)
					If[requiresMagneticCapQ,
						(* If a magnetic cap is not required just check both the footprint will fit the autosampler. *)
						(* And that the neck will fit the magnetic cap. *)
						!MatchQ[
							{footprint, neckType},
							Alternatives[
								(* small GC vials *)
								{CEVial, "9/425"},
								(* larger headspace vials *)
								{HeadspaceVial, "18/425"}
							]
						],
						If[!ValueQ[modelCapPackets],
							modelCapPackets =  Cases[cache, PacketP[Model[Item, Cap]]]
						];
						(* If a magnetic cap is not required just check that the footprint will fit the autosampler & a pierceable cap exsists for the container. *)
						Nand[MatchQ[footprint, Alternatives[CEVial, HeadspaceVial]], !MatchQ[FirstCase[modelCapPackets, KeyValuePattern[{CoverFootprint -> Alternatives@@coverFootprints, Pierceable -> True}]], Missing["NotFound"]]]
					]
				]
			]
		],
		{simulatedContainerModels, specifiedAliquotAmounts, specifiedAliquotContainers, specifiedAliquotBoolean, magneticCapRequiredQ}
	];

	{
		{targetVials, resolvedDilutionSolventVolumes, resolvedSecondaryDilutionSolventVolumes, resolvedTertiaryDilutionSolventVolumes, requiredAliquotAmounts},
		{targetStandardVials, resolvedStandardDilutionSolventVolumes, resolvedStandardSecondaryDilutionSolventVolumes, resolvedStandardTertiaryDilutionSolventVolumes, requiredStandardAliquotAmounts},
		{targetBlankVials, resolvedBlankDilutionSolventVolumes, resolvedBlankSecondaryDilutionSolventVolumes, resolvedBlankTertiaryDilutionSolventVolumes, requiredBlankAliquotAmounts}
	} = Map[
		Function[{optionsList},
			Module[{samplingMethodsInternal, states, volumes, masses, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes, dilutes, initialContainers, aliquotBooleans, specifiedAliquots, assayVolumes, aliquotContainers},
				{samplingMethodsInternal, states, volumes, masses, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes, dilutes, initialContainers, aliquotBooleans, specifiedAliquots, assayVolumes, aliquotContainers} = optionsList;
				Transpose@MapThread[
					Function[{samplingMethod, sampleState, sampleVolume, sampleMass, dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume, diluteBoolean, initialContainer, aliquotBoolean, specifiedAliquot, assayVolume, aliquotContainer},
						Module[{targetContainer, requiredAmount, resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume, targetContainerVolume},
							(*logic for target container for each sample*)
							(* check if we need to aliquot *)
							{targetContainer, targetContainerVolume} = If[!aliquotBoolean,
								(* if we do not need to aliquot, then we are already in an acceptable target container so we need to determine that container and its max volume? *)
								{
									initialContainer,
									Switch[
										initialContainer,
										ObjectP[Object[]],
										Download[initialContainer, Model[MaxVolume], Cache -> cache, Simulation -> updatedSimulation],
										ObjectP[Model[]],
										Download[initialContainer, MaxVolume, Cache -> cache, Simulation -> updatedSimulation],
										Null,
										Null
									]
								},
								(* otherwise if we do need to aliquot, we need to resolve a container based on first whether an aliquot container is specified, and if not then the specified, volume, sampling method, state, etc. *)
								If[MatchQ[aliquotContainer, ObjectP[]],
									{
										aliquotContainer,
										Switch[
											aliquotContainer,
											ObjectP[Object[]],
											Download[aliquotContainer, Model[MaxVolume], Cache -> cache, Simulation -> updatedSimulation],
											ObjectP[Model[]],
											Download[aliquotContainer, MaxVolume, Cache -> cache, Simulation -> updatedSimulation]
										]
									},
									(* if a volume is specified *)
									Which[
										MatchQ[assayVolume, GreaterP[0 * Liter]],
										Which[
											assayVolume <= 0.27 Milliliter,
											{Model[Container, Vessel, "0.3 mL clear glass GC vial"], 0.3 * Milliliter},
											(* 2 mL clear glass GC vial can hold only 1.5 mL *)
											assayVolume <= 1.5 Milliliter,
											{Model[Container, Vessel, "2 mL clear glass GC vial"], 2 * Milliliter},
											assayVolume <= 10 Milliliter,
											{Model[Container, Vessel, "10 mL clear glass GC vial"], 10 * Milliliter},
											assayVolume <= 20 Milliliter,
											{Model[Container, Vessel, "20 mL clear glass GC vial"], 20 * Milliliter}
										],
										MatchQ[specifiedAliquot, GreaterP[0 * Liter]],
										Which[
											specifiedAliquot <= 0.27 Milliliter,
											{Model[Container, Vessel, "0.3 mL clear glass GC vial"], 0.3 * Milliliter},
											(* 2 mL clear glass GC vial can hold only 1.5 mL *)
											specifiedAliquot <= 1.5 Milliliter,
											{Model[Container, Vessel, "2 mL clear glass GC vial"], 2 * Milliliter},
											specifiedAliquot <= 10 Milliliter,
											{Model[Container, Vessel, "10 mL clear glass GC vial"], 10 * Milliliter},
											specifiedAliquot <= 20 Milliliter,
											{Model[Container, Vessel, "20 mL clear glass GC vial"], 20 * Milliliter}
										],
										True,
										Switch[
											samplingMethod,
											(* If headspace/spme injection, use the 10 mL clear glass GC vials *)
											(HeadspaceInjection | SPMEInjection),
											{Model[Container, Vessel, "10 mL clear glass GC vial"], 10 * Milliliter},
											(* If liquid injection, use the 2 mL clear glass GC vials *)
											(LiquidInjection),
											If[Switch[sampleState,
												Liquid,
												If[MatchQ[sampleVolume, _Quantity],
													sampleVolume < 300 * Microliter,
													False
												],
												Solid,
												If[MatchQ[sampleMass, _Quantity],
													sampleMass < 200 * Milli * Gram,
													False
												],
												(* if no sample state is available *)
												Null,
												Which[
													MatchQ[sampleVolume, _Quantity],
													If[MatchQ[sampleVolume, _Quantity],
														sampleVolume < 300 * Microliter,
														False
													],
													MatchQ[sampleMass, _Quantity],
													If[MatchQ[sampleMass, _Quantity],
														sampleMass < 200 * Milli * Gram,
														False
													],
													True,
													False
												]
											],
												{Model[Container, Vessel, "0.3 mL clear glass GC vial"], 0.3 * Milliliter},
												{Model[Container, Vessel, "2 mL clear glass GC vial"], 2 * Milliliter}
											],
											Null,
											Null
										]
									]
								]
							];
							(* logic for dilution volumes *)
							{resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume} = MapThread[
								Function[{solventVolume, solventSpecifiedQ},
									Switch[
										{solventVolume, diluteBoolean},
										{Except[Automatic], _},
										solventVolume,
										(* To automatically resolve the dilution solvent volume, take the target container and subtract the volume of all specified dilution solvent volumes. Then divide that quantity by the number of specified dilution solvents plus one. *)
										{Automatic, True},
										If[solventSpecifiedQ,
											If[!aliquotBoolean,
												(* if we are not aliquoting, we already have some volume in the container. this should be the simulated volume so use that to determine how much to add. MUST BE POSITIVE *)
												Max[0 * Milliliter, (0.9 * targetContainerVolume - ((dilutionSolventVolume + secondaryDilutionSolventVolume + tertiaryDilutionSolventVolume + sampleVolume) /. {Automatic -> 0 * Milliliter, Null -> 0 * Milliliter})) / (numberOfDilutionSolventsSpecified)],
												(* if we are aliquoting, then we just need to make sure the volumes don't add up to more than the container's max volume. Still must be greater than 0 *)
												Max[0 * Milliliter, (0.9 * targetContainerVolume - ((dilutionSolventVolume + secondaryDilutionSolventVolume + tertiaryDilutionSolventVolume + specifiedAliquot) /. {Automatic -> 0 * Milliliter, Null -> 0 * Milliliter})) / (numberOfDilutionSolventsSpecified + If[MatchQ[specifiedAliquot, Automatic], 1, 0])]
											],
											Null
										],
										{Automatic, False},
										Null
									]
								],
								{
									{dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume},
									{dilutionSolventSpecifiedQ, secondaryDilutionSolventSpecifiedQ, tertiaryDilutionSolventSpecifiedQ}
								}
							];

							(*logic for aliquot amount for each sample: take the minimum of either the sample amount or the resolve total volume target minus the automatically selected amount of diluent *)
							requiredAmount = Which[
								aliquotBoolean && !MatchQ[specifiedAliquot, Automatic],
								specifiedAliquot,
								!aliquotBoolean,
								sampleVolume,
								True(* including aliquotBoolean && MatchQ[specifiedAliquot,Automatic]*),
								Switch[
									{targetContainerVolume, samplingMethod},
									{_, HeadspaceInjection},
									Switch[sampleState,
										Liquid,
										Max[1 * Microliter,
											If[MatchQ[sampleVolume, _Quantity],
												Min[sampleVolume, 0.2 * targetContainerVolume - Total[{resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}]],
												0.2 * targetContainerVolume - Total[{resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}]
											]
										],
										Solid,
										If[MatchQ[sampleMass, _Quantity],
											Clip[sampleMass, {1 * Milligram, 0.5 * Gram}],
											0.5 * Gram
										]
									],
									{_, LiquidInjection},
									Max[1 * Microliter,
										If[MatchQ[sampleVolume, _Quantity],
											Min[sampleVolume, 1.5 * Milliliter - Total[{resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}]],
											1.5 * Milliliter - Total[{resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}]
										]
									],
									{LessP[5 * Milliliter], SPMEInjection},
									Switch[sampleState,
										Liquid,
										Max[1 * Microliter,
											If[MatchQ[sampleVolume, _Quantity],
												Min[sampleVolume, 0.9 * targetContainerVolume - Total[{resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}]],
												0.9 * targetContainerVolume - Total[{resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}]
											]
										],
										Solid,
										If[MatchQ[sampleMass, _Quantity],
											Clip[sampleMass, {1 * Milligram, 0.25 * Gram}],
											0.25 * Gram
										]
									],
									{GreaterEqualP[5 * Milliliter], SPMEInjection},
									Switch[sampleState,
										Liquid,
										Max[1 * Microliter,
											If[MatchQ[sampleVolume, _Quantity],
												Min[sampleVolume, 0.2 * targetContainerVolume - Total[{resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}]],
												0.2 * targetContainerVolume - Total[{resolvedDilutionSolventVolume, resolvedSecondaryDilutionSolventVolume, resolvedTertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}]
											]
										],
										Solid,
										If[MatchQ[sampleMass, _Quantity],
											Clip[sampleMass, {1 * Milligram, 0.5 * Gram}],
											0.5 * Gram
										]
									],
									{_, Null},
									Null
								]
							];

							(* return the result *)
							{
								targetContainer,
								resolvedDilutionSolventVolume,
								resolvedSecondaryDilutionSolventVolume,
								resolvedTertiaryDilutionSolventVolume,
								requiredAmount
							}
						]
					],
					{
						samplingMethodsInternal,
						states,
						volumes,
						masses,
						dilutionSolventVolumes,
						secondaryDilutionSolventVolumes,
						tertiaryDilutionSolventVolumes,
						dilutes,
						initialContainers,
						aliquotBooleans,
						specifiedAliquots,
						assayVolumes,
						aliquotContainers
					}
				]
			]
		],
		{
			{
				resolvedSamplingMethods,
				simulatedSampleStates,
				simulatedSampleVolumes,
				simulatedSampleMasses,
				specifiedDilutionSolventVolumes,
				specifiedSecondaryDilutionSolventVolumes,
				specifiedTertiaryDilutionSolventVolumes,
				resolvedDilutes,
				simulatedContainerModels,
				aliquotQ,
				specifiedAliquotAmounts,
				specifiedAssayVolumes,
				specifiedAliquotContainers
			},
			{
				resolvedStandardSamplingMethods,
				standardStates,
				standardVolumes,
				standardMasses,
				specifiedStandardDilutionSolventVolumes,
				specifiedStandardSecondaryDilutionSolventVolumes,
				specifiedStandardTertiaryDilutionSolventVolumes,
				resolvedStandardDilutes,
				standardContainers,
				aliquotStandardQ,
				(* For Standard, there is no AssayVolume. The total volume is always the standard amount (equivalent to AliquotAmount for SamplesIn *)
				specifiedStandardAmounts,
				specifiedStandardAmounts,
				specifiedStandardVials
			},
			{
				resolvedBlankSamplingMethods,
				blankStates,
				blankVolumes,
				blankMasses,
				specifiedBlankDilutionSolventVolumes,
				specifiedBlankSecondaryDilutionSolventVolumes,
				specifiedBlankTertiaryDilutionSolventVolumes,
				resolvedBlankDilutes,
				blankContainers,
				aliquotBlankQ,
				(* For Blank, there is no AssayVolume. The total volume is always the blank amount (equivalent to AliquotAmount for SamplesIn *)
				specifiedBlankAmounts,
				specifiedBlankAmounts,
				specifiedBlankVials
			}
		}
	];

	{
		{
			standardContainerCoverPacketsWithNulls,
			standardContainerModelPacketsWithNulls,
			standardContainerCoverModelPacketsWithNulls
		},
		{
			blankContainerCoverPacketsWithNulls,
			blankContainerModelPacketsWithNulls,
			blankContainerCoverModelPacketsWithNull
		}
	} = Transpose /@ Replace[
		Quiet[Download[
		(* If either list is {Null} it Download will not generated the correct pattern, expand to {Null, Null, Null} to prevent that. *)
		{
			resolvedStandards,
			(resolvedBlanks /. NoInjection -> Null)
		},
		{
			Container[Cover][Packet[]],
			Container[Model][Packet[Footprint, CoverFootprints]],
			Container[Cover][Model][Packet[Pierceable]]
		},
		Simulation -> updatedSimulation], {Download::FieldDoesntExist}],
	(* Replace any Nulls so we can transpose. *)
	Null -> {Null, Null, Null}, {2}];

	(* If there are no Standards or Blanks than the download returned a Null at the first level *)
	{
		standardContainerCoverPackets,
		standardContainerModelPackets,
		standardContainerCoverModelPackets,
		blankContainerCoverPackets,
		blankContainerModelPackets,
		blankContainerCoverModelPackets
	} = Map[Replace[#, Null -> {Null} , {0}]&,
	{
		standardContainerCoverPacketsWithNulls,
		standardContainerModelPacketsWithNulls,
		standardContainerCoverModelPacketsWithNulls,
		blankContainerCoverPacketsWithNulls,
		blankContainerModelPacketsWithNulls,
		blankContainerCoverModelPacketsWithNull
	}];

	{aliquotContainerModelPackets, standardAliquotContainerModelPackets, blankAliquotContainerModelPackets} = Map[Function[{containers},
		Map[Function[{container},
			(* If the container is a model. *)
			If[MatchQ[container, ObjectP[Model[Container]]],
				(* Download the fields as a packet. *)
				Download[container, Packet[Footprint, NeckType, CoverFootprints], Simulation -> updatedSimulation],
				(* Otherwise it was an object, download the fields after traversing to the model. *)
				Download[container, Model[Packet[Footprint, NeckType, CoverFootprints]], Simulation -> updatedSimulation]
			]
		],
			(* Map over each container in the list. *)
			containers
		]],
		(* Map over the list of containers for samples, standards, and blanks. *)
			{targetVials, targetStandardVials, targetBlankVials}
	];

	(* Determine if we'll need to swap out any sample, standard, or blank caps to be compatible with the injector or autosampler movements. *)
	{
		resolvedSampleCaps,
		resolvedStandardCaps,
		resolvedBlankCaps
	} = MapThread[
		Function[
			{samples, aliquotBooles, aliquotModelContainers, coverPackets, magneticCapRequiredQs, coverModelPackets, containerModelPackets},
			MapThread[
				Function[
					{sample, aliquotBoole, aliquotModelContainer, coverPacket, requiresMagneticCapQ, coverModelPacket, containerModelPacket},
					Which[
						(* If we don't have a sample (e.g. no Standards or no Blanks).. *)
						MatchQ[sample, Null|NoInjection],
						(* .. then we don't need to resolve a cap. *)
						Null,

						(* If we're aliquoting pick a cap *)
						MatchQ[aliquotBoole, True],
						Which[
							MatchQ[aliquotModelContainer, KeyValuePattern[{Footprint -> CEVial, NeckType -> "9/425"}]],
							Model[Item, Cap, "id:L8kPEjn1PRww"],
							MatchQ[aliquotModelContainer, KeyValuePattern[{Footprint -> HeadspaceVial, NeckType ->"18/425"}]],
							Model[Item, Cap, "id:AEqRl9Kmnrqv"],
							True,
							If[!ValueQ[modelCapPackets],
								modelCapPackets =  Cases[cache, PacketP[Model[Item, Cap]]]
							];
							Lookup[
								FirstCase[modelCapPackets, KeyValuePattern[{Pierceable -> True, CoverFootprint -> Alternatives@@Lookup[containerModelPacket, CoverFootprints]}], <||>],
								Object,
								$Failed
							]
						],

						(* If were not aliquoting and the container has a cover, check that is it compatible. *)
						MatchQ[coverPacket, ObjectP[]] &&
								Or[
									(* If we need a magnetic cover it has to be either Model[Item, Cap, "id:L8kPEjn1PRww"] or Model[Item, Cap, "id:AEqRl9Kmnrqv"] *)
									(requiresMagneticCapQ && MatchQ[coverModelPacket, ObjectP[{Model[Item, Cap, "id:L8kPEjn1PRww"], Model[Item, Cap, "id:AEqRl9Kmnrqv"]}]]),
									(* If we do not need a magnetic cover it has to be pierceable (the container is already compatible) *)
									(!requiresMagneticCapQ && TrueQ[Lookup[coverModelPacket, Pierceable, False]])
								],
						(* If its already compatible than we do not need a cap. *)
						Null,

						(* Otherwise we need to ensure the container has a specific cover *)
						(* Magnetic covers are resolved for the container footprint: *)
						requiresMagneticCapQ && MatchQ[Lookup[containerModelPacket, Footprint], CEVial],
						Model[Item, Cap, "id:L8kPEjn1PRww"],
						requiresMagneticCapQ && MatchQ[Lookup[containerModelPacket, Footprint], HeadspaceVial],
						Model[Item, Cap, "id:AEqRl9Kmnrqv"],

						(* For non-magnetic covers pick the first cover with a compatible cover footprint that is also pierceable. *)
						MatchQ[Lookup[containerModelPacket, CoverFootprints], {__Symbol}],
						(* Searching the cache is computationally expensive. Only do it if we have to and only do it once. *)
						If[!ValueQ[modelCapPackets],
							modelCapPackets =  Cases[cache, PacketP[Model[Item, Cap]]]
						];
						(* Look for a compatible cap, return an association if no cap was found. *)
						Lookup[
							FirstCase[modelCapPackets, KeyValuePattern[{Pierceable -> True, CoverFootprint -> Alternatives@@Lookup[containerModelPacket, CoverFootprints]}], <||>], Object,
							(* If there was no object, return $Failed*)
							$Failed
						],

						(* If there the model container has no CoverFootprint, we cannot search for a cap, return $Failed *)
						True,
						$Failed
					]
				],
				{samples, aliquotBooles, aliquotModelContainers, coverPackets, magneticCapRequiredQs, coverModelPackets, containerModelPackets}
			]
		],
		{
			(* Samples, Standards, and Blanks *)
			{simulatedSamples, resolvedStandards, resolvedBlanks},
			(* Aliquot Booles*)
			{aliquotQ, aliquotStandardQ, aliquotBlankQ},
			(* Aliquot Model Container Packets *)
			{aliquotContainerModelPackets, standardAliquotContainerModelPackets, blankAliquotContainerModelPackets},
			(* Covers *)
			Replace[{simulatedContainerCoverPackets, standardContainerCoverPackets, blankContainerCoverPackets}, Except[PacketP[]] -> {} , {2}],
			(* MangeticCapRequireQ *)
			{magneticCapRequiredQ, standardMagneticCapRequiredQ, blankMagneticCapRequiredQ},
			(* Cover Model Packets *)
			Replace[{simulatedContainerModelCoverPackets, standardContainerCoverModelPackets, blankContainerCoverModelPackets}, Except[PacketP[]] -> {}, {2}],
			(* Container Model Packets *)
			Replace[{simulatedContainerModelPackets, standardContainerModelPackets, blankContainerModelPackets}, Except[PacketP[]] -> {}, {2}]
		}
	];

	(* Throw an error if we cannot find a compatible cap. *)
	{noCapForContainerInvalidOptions, noStandardVialCapInvalidOption, invalidBlankVialCapInvalidOption} = MapThread[Function[
		{caps, samples, prefix},
			If[MemberQ[caps, $Failed|Missing["NotFound"]],
				Message[Error::CoverNeededForContainer, prefix, ObjectToString[PickList[samples, caps, $Failed], Simulation -> updatedSimulation], Flatten[Position[caps, $Failed]]];
				Which[
					MatchQ[prefix, ""], {AliquotContainer},
					MatchQ[prefix, "standard "], {StandardVial},
					MatchQ[prefix, "blank "], {BlankVial}
				],
				{}
			]
		],
		{
			{resolvedSampleCaps, resolvedStandardCaps, resolvedBlankCaps},
			{simulatedSamples, resolvedStandards, resolvedBlanks},
			{"", "standard ", "blank "}
		}
	];

	(* Tests for GC-method compatible caps: *)
	capForVialTests = If[gatherTests,
		Module[{containers, failingMagneticContainers, failingPierceableContainers, passingMagneticContainers, passingPierceableContainers, failingMagneticTest, failingPierceableTest, passingMagneticTest, passingPierceableTest},
			(* Determine which container to reference in the test. *)
			containers = MapThread[Function[{aliquot, container, aliquotContainer},
				If[aliquot, aliquotContainer, container]],
				{aliquotQ, simulatedContainers, targetVials}
			];

			(* Determine what is failing or passing. *)
			failingMagneticContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {$Failed|Missing["NotFound"], True}];
			failingPierceableContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {$Failed|Missing["NotFound"], False}];
			passingMagneticContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {Except[$Failed|Missing["NotFound"]], True}];
			passingPierceableContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {Except[$Failed|Missing["NotFound"]], False}];

			(* Construct failing tests. *)
			failingMagneticTest = If[failingMagneticContainers == {},
				Nothing,
				Test["Pierceable, magnetic caps exist for sample containers " <> ObjectToString[DeleteDuplicates@failingMagneticContainers, Simulation -> updatedSimulation] <> ":", True, False]
			];

			failingPierceableTest = If[failingPierceableContainers == {},
					Nothing,
				Test["Pierceable caps exist for sample containers" <> ObjectToString[DeleteDuplicates@failingPierceableContainers, Simulation -> updatedSimulation] <> ":", True, False]
			];

			(* Construct passing tests. *)
			passingMagneticTest = If[passingMagneticContainers == {},
				Nothing,
				Test["Pierceable, magnetic caps exist for sample containers" <> ObjectToString[DeleteDuplicates@passingMagneticContainers, Simulation -> updatedSimulation] <> ":", True, True]
			];

			passingPierceableTest = If[passingPierceableContainers == {},
				Nothing,
				Test["Pierceable caps exist for sample containers" <> ObjectToString[DeleteDuplicates@passingPierceableContainers, Simulation -> updatedSimulation] <> ":", True, True]
			];

			(* Return the tests as a list. *)
			{failingMagneticTest, failingPierceableTest, passingMagneticTest, passingPierceableTest}
		],
		Nothing
	];

	capForStandardVialTests = If[gatherTests,
		Module[{containers, failingMagneticContainers, failingPierceableContainers, passingMagneticContainers, passingPierceableContainers, failingMagneticTest, failingPierceableTest, passingMagneticTest, passingPierceableTest},
			(* Determine which container to reference in the test. *)
			containers = MapThread[Function[{aliquot, container, aliquotContainer},
				If[aliquot, aliquotContainer, container]],
				{aliquotStandardQ, standardContainers, targetStandardVials}
			];

			(* Determine what is failing or passing. *)
			failingMagneticContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {$Failed|Missing["NotFound"], True}];
			failingPierceableContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {$Failed|Missing["NotFound"], False}];
			passingMagneticContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {Except[$Failed|Missing["NotFound"]], True}];
			passingPierceableContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {Except[$Failed|Missing["NotFound"]], False}];

			(* Construct failing tests. *)
			failingMagneticTest = If[failingMagneticContainers == {},
				Nothing,
				Test["Pierceable, magnetic caps exist for Standard containers " <> ObjectToString[DeleteDuplicates@failingMagneticContainers, Simulation -> updatedSimulation] <> ":", True, False]
			];

			failingPierceableTest = If[failingPierceableContainers == {},
				Nothing,
				Test["Pierceable caps exist for Standard containers " <> ObjectToString[DeleteDuplicates@failingPierceableContainers, Simulation -> updatedSimulation] <> ":", True, False]
			];

			(* Construct passing tests. *)
			passingMagneticTest = If[passingMagneticContainers == {},
				Nothing,
				Test["Pierceable, magnetic caps exist for Standard containers " <> ObjectToString[DeleteDuplicates@passingMagneticContainers, Simulation -> updatedSimulation] <> ":", True, True]
			];

			passingPierceableTest = If[passingPierceableContainers == {},
				Nothing,
				Test["Pierceable caps exist for Standard containers " <> ObjectToString[DeleteDuplicates@passingPierceableContainers, Simulation -> updatedSimulation] <> ":", True, True]
			];

			(* Return the tests as a list. *)
			{failingMagneticTest, failingPierceableTest, passingMagneticTest, passingPierceableTest}
			],
			Nothing
		];

	capForBlankVialTests = If[gatherTests,
		Module[{containers, failingMagneticContainers, failingPierceableContainers, passingMagneticContainers, passingPierceableContainers, failingMagneticTest, failingPierceableTest, passingMagneticTest, passingPierceableTest},
			(* Determine which container to reference in the test. *)
			containers = MapThread[Function[{aliquot, container, aliquotContainer},
				If[aliquot, aliquotContainer, container]],
				{aliquotBlankQ, blankContainers, targetBlankVials}
			];

			(* Determine what is failing or passing. *)
			failingMagneticContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {$Failed|Missing["NotFound"], True}];
			failingPierceableContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {$Failed|Missing["NotFound"], False}];
			passingMagneticContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {Except[$Failed|Missing["NotFound"]], True}];
			passingPierceableContainers = PickList[containers, Transpose[{resolvedSampleCaps, magneticCapRequiredQ}], {Except[$Failed|Missing["NotFound"]], False}];

			(* Construct failing tests. *)
			failingMagneticTest = If[failingMagneticContainers == {},
				Nothing,
				Test["Pierceable, magnetic caps exist for Blank containers " <> ObjectToString[DeleteDuplicates@failingMagneticContainers, Simulation -> updatedSimulation] <> ":", True, False]
			];

			failingPierceableTest = If[failingPierceableContainers == {},
				Nothing,
				Test["Pierceable caps exist for Blank containers " <> ObjectToString[DeleteDuplicates@failingPierceableContainers, Simulation -> updatedSimulation] <> ":", True, False]
			];

			(* Construct passing tests. *)
			passingMagneticTest = If[passingMagneticContainers == {},
				Nothing,
				Test["Pierceable, magnetic caps exist for Blank containers " <> ObjectToString[DeleteDuplicates@passingMagneticContainers, Simulation -> updatedSimulation] <> ":", True, True]
			];

			passingPierceableTest = If[passingPierceableContainers == {},
				Nothing,
				Test["Pierceable caps exist for Blank containers " <> ObjectToString[DeleteDuplicates@passingPierceableContainers, Simulation -> updatedSimulation] <> ":", True, True]
			];

			(* Return the tests as a list. *)
			{failingMagneticTest, failingPierceableTest, passingMagneticTest, passingPierceableTest}
		],
		Nothing
	];

	(* Throw a warning if a cap swap will occur. *)
	MapThread[Function[
		{caps, aliquotBooles, containerCoverPackets, prefix, samples},
		Module[{pickList},
			(* Determine which samples to include in the warning if any. *)
			pickList = MapThread[
				Function[{cap, aliquotBoole, coverPacket},
					Which[
						(* If we're aliquoting the sample cap is going to change anyways. *)
						aliquotBoole, False,
						(* If there isn't a cap they probably don't care that we will cap it. *)
						MatchQ[coverPacket, Null|{}], False,
						(* Otherwise we're not aliquoting and there is a cap, if we're swapping it mark it as True. *)
						MatchQ[cap, ObjectP[]], True,
						(* Otherwise it has the correct cap for the experiment and we do not need to Warn. *)
						True, False
					]
				], {caps, aliquotBooles, containerCoverPackets}];

			(* If we have to surface a warning, surface one. *)
			If[MemberQ[pickList, True],
				Message[Warning::ContainerCapSwapRequired, prefix, ObjectToString[PickList[samples, pickList], Simulation -> updatedSimulation], Flatten[Position[pickList, True]], ObjectToString[PickList[caps, pickList], Simulation -> updatedSimulation]]
			]
		]
	],
		{
			(* Resolved swaps *)
			Replace[{resolvedSampleCaps, resolvedStandardCaps, resolvedBlankCaps}, $Failed -> Null, {2}],
			(* Aliquot Booles*)
			{aliquotQ, aliquotStandardQ, aliquotBlankQ},
			(* Covers *)
			Replace[{simulatedContainerCoverPackets, standardContainerCoverPackets, blankContainerCoverPackets}, Except[PacketP[]] -> {} , {2}],
			(* Prefix *)
			{"", "standard ", "blank "},
			(* Samples*)
			{simulatedSamples, resolvedStandards, resolvedBlanks}
		}
	];

	(* DilutionSolventVolume *)

	(* SecondaryDilutionSolventVolume *)

	(* TertiaryDilutionSolventVolume *)

	(* === Handle LiquidInjectionSyringe === *)
	(* Resolution of LiquidInjectionSyringe is performed later when we have resolved injection volumes, to avoid conflict between the resolved volumes and the syringes used *)
	(* Get the specified LiquidInjectionSyringe *)
	specifiedLiquidInjectionSyringe = Lookup[roundedGasChromatographyOptions, LiquidInjectionSyringe];

	(* Get the model of the specified LiquidInjectionSyringe *)
	specifiedLiquidInjectionSyringeModel = Switch[
		specifiedLiquidInjectionSyringe,
		ObjectP[Model[Container, Syringe]],
		Download[specifiedLiquidInjectionSyringe, Object],
		ObjectP[Object[Container, Syringe]],
		Download[specifiedLiquidInjectionSyringe, Model, Cache -> cache, Simulation -> updatedSimulation],
		_,
		Null
	];

	(* Get the list of compatible LiquidInjectionSyringes *)
	specifiedLiquidInjectionSyringeModelType = Lookup[
		fetchPacketFromCache[specifiedLiquidInjectionSyringeModel, cache] /. {Null -> <||>},
		GCInjectionType,
		Null
	];

	specifiedLiquidInjectionSyringeVolume = If[MatchQ[specifiedLiquidInjectionSyringeModelType, LiquidInjection],
		Convert[Lookup[fetchPacketFromCache[specifiedLiquidInjectionSyringeModel, cache], MaxVolume], Microliter]
	];

	(* Pre-Resolve LiquidInjectionSyringe so that we turn the syringe to Null if needed *)
	preResolvedLiquidInjectionSyringe = Which[
		(* If the LiquidInjectionSyringe is already specified, go with that one *)
		MatchQ[specifiedLiquidInjectionSyringeModelType, LiquidInjection],
		specifiedLiquidInjectionSyringe,
		(* If there are no LiquidInjection samples, we don't need a LiquidInjectionSyringe *)
		MatchQ[specifiedLiquidInjectionSyringe, Automatic] && Not[MemberQ[allSamplingMethods, LiquidInjection]],
		Null,
		MatchQ[specifiedLiquidInjectionSyringe, Automatic] && MemberQ[allSamplingMethods, LiquidInjection],
		Automatic,
		True,
		Null
	];

	(* === Resolve HeadspaceInjectionSyringe === *)

	(* Get the specified HeadspaceInjectionSyringe *)
	specifiedHeadspaceInjectionSyringe = Lookup[roundedGasChromatographyOptions, HeadspaceInjectionSyringe];

	(* Get the model of the specified HeadspaceInjectionSyringe *)
	specifiedHeadspaceInjectionSyringeModel = Switch[
		specifiedHeadspaceInjectionSyringe,
		ObjectP[Model[Container, Syringe]],
		Download[specifiedHeadspaceInjectionSyringe, Object],
		ObjectP[Object[Container, Syringe]],
		Download[specifiedHeadspaceInjectionSyringe, Model, Cache -> cache, Simulation -> updatedSimulation],
		_,
		Null
	];

	(* Get the list of compatible HeadspaceInjectionSyringes *)
	specifiedHeadspaceInjectionSyringeModelType = Lookup[
		fetchPacketFromCache[specifiedHeadspaceInjectionSyringeModel, cache] /. {Null -> <||>},
		GCInjectionType,
		Null
	];

	(* Get the list of compatible HeadspaceInjectionSyringe *)
	compatibleHeadspaceInjectionSyringeModels = Alternatives[
		Model[Container, Syringe, "2500 \[Mu]L GC headspace sample injection syringe"], (* 2500 uL headspace syringe *)
		Model[Container, Syringe, "id:4pO6dM50O14B"] (* id form *)
	];

	(* Resolve the HeadspaceInjectionSyringe *)
	resolvedHeadspaceInjectionSyringe = Which[
		(* If the HeadspaceInjectionSyringe is already specified properly, go with that one *)
		MatchQ[specifiedHeadspaceInjectionSyringeModelType, HeadspaceInjection],
		specifiedHeadspaceInjectionSyringe,
		(* If there are no HeadspaceInjection samples, we don't need a HeadspaceInjectionSyringe *)
		MatchQ[specifiedHeadspaceInjectionSyringe, Automatic] && Not[MemberQ[allSamplingMethods, HeadspaceInjection]],
		Null,
		(* If there are HeadspaceInjection samples but none have specified injection volumes, pick a 2500 microliter syringe *)
		MatchQ[specifiedHeadspaceInjectionSyringe, Automatic] && MemberQ[allSamplingMethods, HeadspaceInjection] && MemberQ[allSpecifiedHeadspaceInjectionVolumes, Except[Null]],
		Model[Container, Syringe, "2500 \[Mu]L GC headspace sample injection syringe"],
		True,
		Null
	];

	(* if we failed to resolve a headspace injection syringe, we have to figure out why and throw an error. *)

	(* first case: a headspace injection sample is specified but the specified value is null. *)
	headspaceInjectionSyringeMissingQ = MemberQ[allSamplingMethods, HeadspaceInjection] && MatchQ[specifiedHeadspaceInjectionSyringe, Null];

	(* second case: the injection type of the specified syringe was incorrect *)
	incompatibleHeadspaceInjectionSyringeQ = MatchQ[specifiedHeadspaceInjectionSyringe, ObjectP[]] && !MatchQ[specifiedHeadspaceInjectionSyringeModelType, HeadspaceInjection];

	(* throw the appropriate errors *)
	headspaceInjectionSyringeOption = If[(headspaceInjectionSyringeMissingQ || incompatibleHeadspaceInjectionSyringeQ),
		If[!gatherTests && headspaceInjectionSyringeMissingQ, Message[Error::GCHeadspaceInjectionSyringeRequired]];
		If[!gatherTests && incompatibleHeadspaceInjectionSyringeQ, Message[Error::GCIncompatibleHeadspaceInjectionSyringe]];
		HeadspaceInjectionSyringe,
		{}
	];

	headspaceInjectionSyringeTests = If[gatherTests,
		{
			Test["If a headspace injection sample is specified, a headspace injection syringe is also specified:",
				headspaceInjectionSyringeMissingQ,
				False
			],
			Test["If a headspace injection syringe is specified, it is compatible with the requested instrument:",
				incompatibleHeadspaceInjectionSyringeQ,
				False
			]
		},
		{}
	];

	resolvedHeadspaceInjectionSyringeVolume = If[NullQ[resolvedHeadspaceInjectionSyringe],
		Null,
		Lookup[fetchPacketFromCache[resolvedHeadspaceInjectionSyringe, cache], MaxVolume]
	];


	(* === Resolve SPMEInjectionFiber === *)

	(* Get the specified SPMEInjectionFiber *)
	specifiedSPMEInjectionFiber = Lookup[roundedGasChromatographyOptions, SPMEInjectionFiber];

	(* Get the model of the specified SPMEInjectionFiber *)
	specifiedSPMEInjectionFiberModel = Switch[
		specifiedSPMEInjectionFiber,
		ObjectP[Model[Item, SPMEFiber]],
		specifiedSPMEInjectionFiber[Object],
		ObjectP[Object[Item, SPMEFiber]],
		specifiedSPMEInjectionFiber[Model],
		Automatic,
		Automatic,
		_,
		Null
	];

	(* Resolve the SPMEInjectionFiber *)
	resolvedSPMEInjectionFiber = Which[
		(* If the SPMEInjectionFiber is already specified, go with that one *)
		MatchQ[specifiedSPMEInjectionFiberModel, ObjectP[{Model[Item, SPMEFiber], Object[Item, SPMEFiber]}]],
		specifiedSPMEInjectionFiber,
		(* If there are no SPMEInjection samples, we don't need a SPMEInjectionFiber *)
		MatchQ[specifiedSPMEInjectionFiber, Automatic] && Not[MemberQ[allSamplingMethods, SPMEInjection]],
		Null,
		(* If there are SPMEInjection samples, pick the all-purpose fiber *)
		MatchQ[specifiedSPMEInjectionFiber, Automatic] && MemberQ[allSamplingMethods, SPMEInjection],
		Model[Item, SPMEFiber, "id:54n6evLR3kLG"], (* 30 um PDMS fiber *)
		True,
		Null
	];

	(* if we failed to resolve a fiber, we have to figure out why and throw an error. *)

	(* first case: a spme injection sample is specified but the specified value is null. *)
	spmeInjectionFiberMissingQ = MemberQ[allSamplingMethods, SPMEInjection] && MatchQ[specifiedSPMEInjectionFiber, Null];

	(* throw the appropriate errors *)
	spmeInjectionFiberOption = If[(spmeInjectionFiberMissingQ),
		If[!gatherTests && spmeInjectionFiberMissingQ, Message[Error::GCSPMEInjectionFiberRequired]];
		SPMEInjectionFiber,
		{}
	];

	spmeInjectionFiberTests = If[gatherTests,
		{
			Test["If a SPME injection sample is specified, a SPME injection fiber is also specified:",
				spmeInjectionFiberMissingQ,
				False
			]
		},
		{}
	];

	resolvedSPMEInjectionFiberMaxTemperature = If[NullQ[resolvedSPMEInjectionFiber],
		Null,
		Lookup[fetchPacketFromCache[resolvedSPMEInjectionFiber, cache], MaxTemperature]
	];


	(* === Resolve LiquidHandlingSyringe === *)

	(* Get the specified LiquidHandlingSyringe *)
	specifiedLiquidHandlingSyringe = Lookup[roundedGasChromatographyOptions, LiquidHandlingSyringe];

	(* Get the model of the specified LiquidHandlingSyringe *)
	specifiedLiquidHandlingSyringeModel = Switch[
		specifiedLiquidHandlingSyringe,
		ObjectP[Model[Container, Syringe]],
		Download[specifiedLiquidHandlingSyringe, Object],
		ObjectP[Object[Container, Syringe]],
		Download[specifiedLiquidHandlingSyringe, Model, Cache -> cache, Simulation -> updatedSimulation],
		_,
		Null
	];

	(* Get the list of compatible LiquidHandlingSyringes *)
	specifiedLiquidHandlingSyringeModelType = Lookup[
		fetchPacketFromCache[specifiedLiquidHandlingSyringeModel, cache] /. {Null -> <||>},
		GCInjectionType,
		Null
	];

	(* Get the list of compatible LiquidHandlingSyringes *)
	compatibleLiquidHandlingSyringeModels = Alternatives[
		Model[Container, Syringe, "2500 \[Mu]L GC PAL3 liquid handling syringe"][Object] (* 2500 uL liquid syringe *)
	];

	(* Get the model of the specified LiquidHandlingSyringe *)
	specifiedLiquidHandlingSyringeModel = Switch[
		specifiedLiquidHandlingSyringe,
		ObjectP[Model[Container, Syringe]],
		specifiedLiquidHandlingSyringe[Object],
		ObjectP[Object[Container, Syringe]],
		specifiedLiquidHandlingSyringe[Model],
		_,
		$Failed
	];

	(* Resolve the LiquidHandlingSyringe *)
	resolvedLiquidHandlingSyringe = Which[
		(* If the LiquidHandlingSyringe is already specified, go with that one *)
		MatchQ[specifiedLiquidHandlingSyringeModelType, LiquidHandling],
		specifiedLiquidHandlingSyringe,
		(* If there are no LiquidHandling steps, we don't need a LiquidHandlingSyringe *)
		MatchQ[specifiedLiquidHandlingSyringe, Automatic] && Not[MemberQ[Flatten[{resolvedDilutes, resolvedStandardDilutes, resolvedBlankDilutes}], True]],
		Null,
		(* If there are LiquidHandling samples and syringe isn't specified, pick the 2500 microliter syringe *)
		MatchQ[specifiedLiquidHandlingSyringe, Automatic] && MemberQ[Flatten[{resolvedDilutes, resolvedStandardDilutes, resolvedBlankDilutes}], True],
		Model[Container, Syringe, "2500 \[Mu]L GC PAL3 liquid handling syringe"]
	];

	(* if we failed to resolve a liquid handling syringe, we have to figure out why and throw an error. *)

	(* first case: a liquid handling step is specified but the specified value is null. *)
	liquidHandlingSyringeMissingQ = MemberQ[
		Flatten[
			{
				resolvedDilutionSolventVolumes,
				resolvedSecondaryDilutionSolventVolumes,
				resolvedTertiaryDilutionSolventVolumes,
				resolvedStandardDilutionSolventVolumes,
				resolvedStandardSecondaryDilutionSolventVolumes,
				resolvedStandardTertiaryDilutionSolventVolumes,
				resolvedBlankDilutionSolventVolumes,
				resolvedBlankSecondaryDilutionSolventVolumes,
				resolvedBlankTertiaryDilutionSolventVolumes
			}
		],
		Except[Null]
	] && MatchQ[specifiedLiquidHandlingSyringe, Null];

	(* second case: the injection type of the specified syringe was incorrect *)
	incompatibleLiquidHandlingSyringeQ = MatchQ[specifiedLiquidHandlingSyringe, ObjectP[]] && !MatchQ[specifiedLiquidHandlingSyringeModelType, LiquidHandling];

	(* throw the appropriate errors *)
	liquidHandlingSyringeOption = If[(liquidHandlingSyringeMissingQ || incompatibleLiquidHandlingSyringeQ),
		If[!gatherTests && liquidHandlingSyringeMissingQ, Message[Error::GCLiquidHandlingSyringeRequired]];
		If[!gatherTests && incompatibleLiquidHandlingSyringeQ, Message[Error::GCIncompatibleLiquidHandlingSyringe]];
		LiquidHandlingSyringe,
		{}
	];

	(* === Resolve OvenEquilibrationTime, ColumnOvenTemperatureProfile, PostRunOvenTemperature === *)

	(* OvenEquilibrationTime *)

	(* Create the default resolved OvenTemperatureProfile if not specified *)
	defaultOvenTemperatureProfile = {{20 * Celsius / Minute, maxColumnTempLimit - 50 * Celsius, 3 * Minute}};

	(* Resolve the oven temperature parameters, post run parameters *)

	{
		{resolvedOvenEquilibrationTimes, resolvedOvenTemperatureProfiles, resolvedOvenTemperatureProfileSetpoints, resolvedPostRunOvenTemperatures, resolvedPostRunOvenTimes},
		{resolvedStandardOvenEquilibrationTimes, resolvedStandardOvenTemperatureProfiles, resolvedStandardOvenTemperatureProfileSetpoints, resolvedStandardPostRunOvenTemperatures, resolvedStandardPostRunOvenTimes},
		{resolvedBlankOvenEquilibrationTimes, resolvedBlankOvenTemperatureProfiles, resolvedBlankOvenTemperatureProfileSetpoints, resolvedBlankPostRunOvenTemperatures, resolvedBlankPostRunOvenTimes}
	} = Map[
		Function[{optionsList},
			Module[{ovenEquilibrationTimes, ovenTemperatureProfiles, postRunOvenTemperatures, postRunOvenTimes, postRunFlowRates, postRunPressures, initialOvenTemperatures,
				resolvedEquilibrationTimes, resolvedTemperatureProfiles, resolvedTemperatureProfileSetpoints, resolvedPostRunTemperatures, resolvedPostRunFlows, resolvedPostRunPress, resolvedPostRunTimes, samples},
				{ovenEquilibrationTimes, ovenTemperatureProfiles, postRunOvenTemperatures, postRunOvenTimes, postRunFlowRates, postRunPressures, initialOvenTemperatures, samples} = optionsList;

				(* Oven equilibration times *)

				resolvedEquilibrationTimes = Map[Switch[
					#,
					GreaterEqualP[0 * Minute],
					#,
					Automatic | Null,
					Null
				]&,
					ovenEquilibrationTimes
				];

				(* OvenTemperatureProfile *)

				(* Generate the list of resolved OvenTemperatureProfiles *)
				resolvedTemperatureProfiles = MapThread[Switch[
					{#1, #2},
					{Except[Automatic | Null], _},
					#1,
					{Automatic, Except[Null]},
					defaultOvenTemperatureProfile,
					{Automatic, Null},
					Null,
					{Null, _},
					Null
				]&,
					{ovenTemperatureProfiles, samples}
				];

				resolvedTemperatureProfileSetpoints = Map[
					Function[profile, Cases[ToList[profile], _?(CompatibleUnitQ[#, Celsius] &), {2}]],
					resolvedTemperatureProfiles
				];

				(* PostRunOvenTemperature *)

				(* Resolve PostRunOvenTemperatures to either the specified or initial value, unless null *)
				resolvedPostRunTemperatures = MapThread[
					Function[
						{temp, flow, pressure, time, initialTemps},
						Switch[
							{temp, flow, pressure, time},
							(* keep option if specified *)
							{Except[Automatic], __},
							temp,
							(* null option if nothing else is specified and it's automatic *)
							{Automatic, Automatic | Null, Automatic | Null, Automatic | Null},
							Null,
							(* resolve to initial temperature, presuming that value is not null *)
							{Automatic, __},
							initialTemps
						]
					],
					{postRunOvenTemperatures, postRunFlowRates, postRunPressures, postRunOvenTimes, initialOvenTemperatures}
				];

				(* Resolve PostRunOvenTimes to either the specified or initial value, unless null *)
				resolvedPostRunTimes = MapThread[
					Function[
						{temp, flow, pressure, time},
						Switch[
							{temp, flow, pressure, time},
							(* keep option if specified *)
							{_, _, _, Except[Automatic]},
							time,
							(* null option if nothing else is specified and it's automatic *)
							{Automatic | Null, Automatic | Null, Automatic | Null, Automatic},
							Null,
							(* resolve to 2 Minutes if we're using other options *)
							{_, _, _, Automatic},
							2 * Minute
						]
					],
					{postRunOvenTemperatures, postRunFlowRates, postRunPressures, postRunOvenTimes}
				];

				(* Return the resolved values *)
				{resolvedEquilibrationTimes, resolvedTemperatureProfiles, resolvedTemperatureProfileSetpoints, resolvedPostRunTemperatures, resolvedPostRunTimes}
			]
		],
		{
			{specifiedOvenEquilibrationTimes, specifiedOvenTemperatureProfiles, specifiedPostRunOvenTemperatures, specifiedPostRunOvenTimes, specifiedPostRunFlowRates, specifiedPostRunPressures,
				specifiedInitialOvenTemperatures, mySamples},
			{specifiedStandardOvenEquilibrationTimes, specifiedStandardOvenTemperatureProfiles, specifiedStandardPostRunOvenTemperatures, specifiedStandardPostRunOvenTimes, specifiedStandardPostRunFlowRates,
				specifiedStandardPostRunPressures, specifiedStandardInitialOvenTemperatures, resolvedStandards},
			{specifiedBlankOvenEquilibrationTimes, specifiedBlankOvenTemperatureProfiles, specifiedBlankPostRunOvenTemperatures, specifiedBlankPostRunOvenTimes, specifiedBlankPostRunFlowRates,
				specifiedBlankPostRunPressures, specifiedBlankInitialOvenTemperatures, resolvedBlanks}
		}
	];

	(* error check the profiles to make sure they are not broken TODO HERE *)

	(* Check that if an oven time period is specified, we have a temperature/temperature profile for that period *)
	(* Also warn if a temperature is provided, but we have a Null/0 time *)

	ovenTimeTemperatureConflictTuples = Map[
		Function[opsList,
			Module[
				{
					postRunOvenTemperatures, postRunOvenTimes, prefix, postRunOvenTimeNoTemperatureConflicts, conflictingPostRunOvenTimeNoTemperatureOptions, conflictingOptions,
					postRunOvenTimeNoTemperatureConflictTest
				},
				{postRunOvenTemperatures, postRunOvenTimes, prefix} = opsList;

				(* Figure out if we have oven times specified, but no temperature or profile *)
				{
					postRunOvenTimeNoTemperatureConflicts
				} = Transpose@MapThread[
					Function[
						{postRunTime, postRunTemperatures},

						{
							(MatchQ[postRunTime, GreaterP[0 Minute]] && NullQ[postRunTemperatures]) || (NullQ[postRunTime] && MatchQ[postRunTemperatures, GreaterEqualP[0 Kelvin]])
						}
					],
					{postRunOvenTimes, postRunOvenTemperatures}
				];

				(* Gather the options names that are used to specify the temperatures *)
				{
					conflictingPostRunOvenTimeNoTemperatureOptions
				} = MapThread[
					Function[{conflicts, options},
						If[Or @@ conflicts, ToExpression@StringJoin[prefix, #]& /@ options, {}]
					],
					{
						{
							postRunOvenTimeNoTemperatureConflicts
						},
						{
							{"PostRunOvenTime", "PostRunOvenTemperature"}
						}
					}
				];

				conflictingOptions = Union[conflictingPostRunOvenTimeNoTemperatureOptions];

				(* If we have conflicts,throw an error *)
				If[!gatherTests,
					If[Or @@ postRunOvenTimeNoTemperatureConflicts,
						Message[Error::GCPostRunOvenTimeTemperatureConflict, prefix],
						Nothing
					];
				];

				(* Gather the tests *)
				postRunOvenTimeNoTemperatureConflictTest = If[gatherTests,
					Test[prefix <> "PostRunOvenTemperature is not Null if " <> prefix <> "PostRunOvenTime is not null:",
						Or @@ postRunOvenTimeNoTemperatureConflicts,
						False
					],
					{}
				];

				(* Format the output *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{postRunOvenTimeNoTemperatureConflictTest}]
				}

			]
		],
		{
			{resolvedPostRunOvenTemperatures, resolvedPostRunOvenTimes, ""},
			{resolvedStandardPostRunOvenTemperatures, resolvedStandardPostRunOvenTimes, "Standard"},
			{resolvedBlankPostRunOvenTemperatures, resolvedBlankPostRunOvenTimes, "Blank"}
		}
	];

	(* Split the resulting tuples to create error issues *)
	{ovenTimeTemperatureConflictOptions, ovenTimeTemperatureConflictTests} = {Flatten[ovenTimeTemperatureConflictTuples[[All, 1]]], Flatten[ovenTimeTemperatureConflictTuples[[All, 2]]]};


	(* === MapThread to resolve Master Switch for SamplingMethod of each sample, error check for mismatched options, then resolve the sampling and injection parameters relevant to each sample. === *)

	{
		{masterSwitchedLiquidSamplingOptions, masterSwitchedHeadspaceSamplingOptions, masterSwitchedSPMESamplingOptions},
		{masterSwitchedStandardLiquidSamplingOptions, masterSwitchedStandardHeadspaceSamplingOptions, masterSwitchedStandardSPMESamplingOptions},
		{masterSwitchedBlankLiquidSamplingOptions, masterSwitchedBlankHeadspaceSamplingOptions, masterSwitchedBlankSPMESamplingOptions}
	} = Map[
		Function[{optionsList},
			Module[{samplingMethods, liquidSamplingOptions, headspaceSamplingOptions, spmeSamplingOptions, masterSwitchedLiquidOptions, masterSwitchedHeadspaceOptions, masterSwitchedSPMEOptions},
				{samplingMethods, liquidSamplingOptions, headspaceSamplingOptions, spmeSamplingOptions} = optionsList;
				(* === FUNCTION === *)
				(* For each sample or standard, get the resolvedSamplingMethod and set all options for other SamplingMethods that are currently Automatic to Null *)
				{masterSwitchedLiquidOptions, masterSwitchedHeadspaceOptions, masterSwitchedSPMEOptions} = Transpose@MapThread[
					Switch[
						#1,
						LiquidInjection,
						{#2, #3 /. {Automatic -> Null}, #4 /. {Automatic -> Null}},
						HeadspaceInjection,
						{#2 /. {Automatic -> Null}, #3, #4 /. {Automatic -> Null}},
						SPMEInjection,
						{#2 /. {Automatic -> Null}, #3 /. {Automatic -> Null}, #4},
						Null,
						{#2, #3, #4}
					]&,
					{samplingMethods,
						liquidSamplingOptions,
						headspaceSamplingOptions,
						spmeSamplingOptions}
				]
				(* === FUNCTION === *)
			]
		],
		{
			{
				resolvedSamplingMethods,
				Transpose@Join[specifiedLiquidSamplingOptions, {specifiedLiquidSampleVolumes, specifiedLiquidSampleAspirationRates, specifiedLiquidSampleAspirationDelays, specifiedLiquidSampleInjectionRates}],
				Transpose@Join[specifiedHeadspaceSamplingOptions, {specifiedHeadspaceSampleVolumes, specifiedHeadspaceSampleAspirationRates, specifiedHeadspaceSampleAspirationDelays, specifiedHeadspaceSampleInjectionRates, specifiedHeadspaceAgitateWhileSamplings}],
				Transpose@Join[specifiedSPMESamplingOptions, {specifiedSPMEAgitateWhileSamplings}]
			},
			{
				resolvedStandardSamplingMethods,
				Transpose@Join[specifiedStandardLiquidSamplingOptions, {specifiedStandardLiquidSampleVolumes, specifiedStandardLiquidSampleAspirationRates, specifiedStandardLiquidSampleAspirationDelays, specifiedStandardLiquidSampleInjectionRates}],
				Transpose@Join[specifiedStandardHeadspaceSamplingOptions, {specifiedStandardHeadspaceSampleVolumes, specifiedStandardHeadspaceSampleAspirationRates, specifiedStandardHeadspaceSampleAspirationDelays, specifiedStandardHeadspaceSampleInjectionRates, specifiedStandardHeadspaceAgitateWhileSamplings}],
				Transpose@Join[specifiedStandardSPMESamplingOptions, {specifiedStandardSPMEAgitateWhileSamplings}]
			},
			{
				resolvedBlankSamplingMethods,
				Transpose@Join[specifiedBlankLiquidSamplingOptions, {specifiedBlankLiquidSampleVolumes, specifiedBlankLiquidSampleAspirationRates, specifiedBlankLiquidSampleAspirationDelays, specifiedBlankLiquidSampleInjectionRates}],
				Transpose@Join[specifiedBlankHeadspaceSamplingOptions, {specifiedBlankHeadspaceSampleVolumes, specifiedBlankHeadspaceSampleAspirationRates, specifiedBlankHeadspaceSampleAspirationDelays, specifiedBlankHeadspaceSampleInjectionRates, specifiedBlankHeadspaceAgitateWhileSamplings}],
				Transpose@Join[specifiedBlankSPMESamplingOptions, {specifiedBlankSPMEAgitateWhileSamplings}]
			}
		}
	];

	(* error check here to make sure that there are no options specified corresponding to a non-specified SamplingMethod *)

	{
		{conflictingLiquidSamplingOptionsQ, conflictingHeadspaceSamplingOptionsQ, conflictingSPMESamplingOptionsQ},
		{conflictingStandardLiquidSamplingOptionsQ, conflictingStandardHeadspaceSamplingOptionsQ, conflictingStandardSPMESamplingOptionsQ},
		{conflictingBlankLiquidSamplingOptionsQ, conflictingBlankHeadspaceSamplingOptionsQ, conflictingBlankSPMESamplingOptionsQ}
	} = Map[
		Function[{optionsList},
			Module[{samplingMethods, liquidSamplingOptions, headspaceSamplingOptions, spmeSamplingOptions, conflictingLiquidOptionsQ, conflictingHeadspaceOptionsQ, conflictingSPMEOptionsQ},
				{samplingMethods, liquidSamplingOptions, headspaceSamplingOptions, spmeSamplingOptions} = optionsList;
				(* === FUNCTION === *)
				(* For each sample or standard, mak sure that no options for the wrong samplingmethod are set *)
				{conflictingLiquidOptionsQ, conflictingHeadspaceOptionsQ, conflictingSPMEOptionsQ} = Transpose@MapThread[
					Function[
						{samplingMethod, liquidSamplingOption, headspaceSamplingOption, spmeSamplingOption},
						{
							If[!MatchQ[samplingMethod, LiquidInjection],
								MatchQ[#, Except[Null | Automatic]]& /@ liquidSamplingOption,
								ConstantArray[False, Length[liquidSamplingOption]]
							],
							If[!MatchQ[samplingMethod, HeadspaceInjection],
								MatchQ[#, Except[Null | Automatic]]& /@ headspaceSamplingOption,
								ConstantArray[False, Length[headspaceSamplingOption]]
							],
							If[!MatchQ[samplingMethod, SPMEInjection],
								MatchQ[#, Except[Null | Automatic]]& /@ spmeSamplingOption,
								ConstantArray[False, Length[spmeSamplingOption]]
							]
						}
					],
					{
						samplingMethods,
						liquidSamplingOptions,
						headspaceSamplingOptions,
						spmeSamplingOptions
					}
				]
				(* === FUNCTION === *)
			]
		],
		{
			{
				resolvedSamplingMethods,
				Transpose@Join[specifiedLiquidSamplingOptions, {specifiedLiquidSampleVolumes, specifiedLiquidSampleAspirationRates, specifiedLiquidSampleAspirationDelays, specifiedLiquidSampleInjectionRates}],
				Transpose@Join[specifiedHeadspaceSamplingOptions, {specifiedHeadspaceSampleVolumes, specifiedHeadspaceSampleAspirationRates, specifiedHeadspaceSampleAspirationDelays, specifiedHeadspaceSampleInjectionRates, specifiedHeadspaceAgitateWhileSamplings}],
				Transpose@Join[specifiedSPMESamplingOptions, {specifiedSPMEAgitateWhileSamplings}]
			},
			{
				resolvedStandardSamplingMethods,
				Transpose@Join[specifiedStandardLiquidSamplingOptions, {specifiedStandardLiquidSampleVolumes, specifiedStandardLiquidSampleAspirationRates, specifiedStandardLiquidSampleAspirationDelays, specifiedStandardLiquidSampleInjectionRates}],
				Transpose@Join[specifiedStandardHeadspaceSamplingOptions, {specifiedStandardHeadspaceSampleVolumes, specifiedStandardHeadspaceSampleAspirationRates, specifiedStandardHeadspaceSampleAspirationDelays, specifiedStandardHeadspaceSampleInjectionRates, specifiedStandardHeadspaceAgitateWhileSamplings}],
				Transpose@Join[specifiedStandardSPMESamplingOptions, {specifiedStandardSPMEAgitateWhileSamplings}]
			},
			{
				resolvedBlankSamplingMethods,
				Transpose@Join[specifiedBlankLiquidSamplingOptions, {specifiedBlankLiquidSampleVolumes, specifiedBlankLiquidSampleAspirationRates, specifiedBlankLiquidSampleAspirationDelays, specifiedBlankLiquidSampleInjectionRates}],
				Transpose@Join[specifiedBlankHeadspaceSamplingOptions, {specifiedBlankHeadspaceSampleVolumes, specifiedBlankHeadspaceSampleAspirationRates, specifiedBlankHeadspaceSampleAspirationDelays, specifiedBlankHeadspaceSampleInjectionRates, specifiedBlankHeadspaceAgitateWhileSamplings}],
				Transpose@Join[specifiedBlankSPMESamplingOptions, {specifiedBlankSPMEAgitateWhileSamplings}]
			}
		}
	];

	{
		sampleLiquidOps,
		sampleHeadspaceOps,
		sampleSPMEOps,
		standardLiquidOps,
		standardHeadspaceOps,
		standardSPMEOps,
		blankLiquidOps,
		blankHeadspaceOps,
		blankSPMEOps
	} = {
		{
			LiquidPreInjectionSyringeWash,
			LiquidPreInjectionSyringeWashVolume,
			LiquidPreInjectionSyringeWashRate,
			LiquidPreInjectionNumberOfSolventWashes,
			LiquidPreInjectionNumberOfSecondarySolventWashes,
			LiquidPreInjectionNumberOfTertiarySolventWashes,
			LiquidPreInjectionNumberOfQuaternarySolventWashes,
			LiquidSampleWash,
			NumberOfLiquidSampleWashes,
			LiquidSampleWashVolume,
			LiquidSampleFillingStrokes,
			LiquidSampleFillingStrokesVolume,
			LiquidFillingStrokeDelay,
			LiquidSampleOverAspirationVolume,
			LiquidPostInjectionSyringeWash,
			LiquidPostInjectionSyringeWashVolume,
			LiquidPostInjectionSyringeWashRate,
			LiquidPostInjectionNumberOfSolventWashes,
			LiquidPostInjectionNumberOfSecondarySolventWashes,
			LiquidPostInjectionNumberOfTertiarySolventWashes,
			LiquidPostInjectionNumberOfQuaternarySolventWashes,
			PostInjectionNextSamplePreparationSteps,
			LiquidSampleVolume,
			LiquidSampleAspirationRate,
			LiquidSampleAspirationDelay,
			LiquidSampleInjectionRate
		},
		{
			HeadspaceSyringeTemperature,
			HeadspacePreInjectionFlushTime,
			HeadspacePostInjectionFlushTime,
			HeadspaceSyringeFlushing,
			HeadspaceSampleVolume,
			HeadspaceSampleAspirationRate,
			HeadspaceSampleAspirationDelay,
			HeadspaceSampleInjectionRate,
			HeadspaceAgitateWhileSampling
		},
		{
			SPMECondition,
			SPMEConditioningTemperature,
			SPMEPreConditioningTime,
			SPMEDerivatizingAgent,
			SPMEDerivatizingAgentAdsorptionTime,
			SPMEDerivatizationPosition,
			SPMEDerivatizationPositionOffset,
			SPMESampleExtractionTime,
			SPMESampleDesorptionTime,
			SPMEPostInjectionConditioningTime,
			SPMEAgitateWhileSampling
		},
		{
			StandardLiquidPreInjectionSyringeWash,
			StandardLiquidPreInjectionSyringeWashVolume,
			StandardLiquidPreInjectionSyringeWashRate,
			StandardLiquidPreInjectionNumberOfSolventWashes,
			StandardLiquidPreInjectionNumberOfSecondarySolventWashes,
			StandardLiquidPreInjectionNumberOfTertiarySolventWashes,
			StandardLiquidPreInjectionNumberOfQuaternarySolventWashes,
			StandardLiquidSampleWash,
			StandardNumberOfLiquidSampleWashes,
			StandardLiquidSampleWashVolume,
			StandardLiquidSampleFillingStrokes,
			StandardLiquidSampleFillingStrokesVolume,
			StandardLiquidFillingStrokeDelay,
			StandardLiquidSampleOverAspirationVolume,
			StandardLiquidPostInjectionSyringeWash,
			StandardLiquidPostInjectionSyringeWashVolume,
			StandardLiquidPostInjectionSyringeWashRate,
			StandardLiquidPostInjectionNumberOfSolventWashes,
			StandardLiquidPostInjectionNumberOfSecondarySolventWashes,
			StandardLiquidPostInjectionNumberOfTertiarySolventWashes,
			StandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
			StandardPostInjectionNextSamplePreparationSteps,
			StandardLiquidSampleVolume,
			StandardLiquidSampleAspirationRate,
			StandardLiquidSampleAspirationDelay,
			StandardLiquidSampleInjectionRate
		},
		{
			StandardHeadspaceSyringeTemperature,
			StandardHeadspacePreInjectionFlushTime,
			StandardHeadspacePostInjectionFlushTime,
			StandardHeadspaceSyringeFlushing,
			StandardHeadspaceSampleVolume,
			StandardHeadspaceSampleAspirationRate,
			StandardHeadspaceSampleAspirationDelay,
			StandardHeadspaceSampleInjectionRate,
			StandardHeadspaceAgitateWhileSampling
		},
		{
			StandardSPMECondition,
			StandardSPMEConditioningTemperature,
			StandardSPMEPreConditioningTime,
			StandardSPMEDerivatizingAgent,
			StandardSPMEDerivatizingAgentAdsorptionTime,
			StandardSPMEDerivatizationPosition,
			StandardSPMEDerivatizationPositionOffset,
			StandardSPMESampleExtractionTime,
			StandardSPMESampleDesorptionTime,
			StandardSPMEPostInjectionConditioningTime,
			StandardSPMEAgitateWhileSampling
		},
		{
			BlankLiquidPreInjectionSyringeWash,
			BlankLiquidPreInjectionSyringeWashVolume,
			BlankLiquidPreInjectionSyringeWashRate,
			BlankLiquidPreInjectionNumberOfSolventWashes,
			BlankLiquidPreInjectionNumberOfSecondarySolventWashes,
			BlankLiquidPreInjectionNumberOfTertiarySolventWashes,
			BlankLiquidPreInjectionNumberOfQuaternarySolventWashes,
			BlankLiquidSampleWash,
			BlankNumberOfLiquidSampleWashes,
			BlankLiquidSampleWashVolume,
			BlankLiquidSampleFillingStrokes,
			BlankLiquidSampleFillingStrokesVolume,
			BlankLiquidFillingStrokeDelay,
			BlankLiquidSampleOverAspirationVolume,
			BlankLiquidPostInjectionSyringeWash,
			BlankLiquidPostInjectionSyringeWashVolume,
			BlankLiquidPostInjectionSyringeWashRate,
			BlankLiquidPostInjectionNumberOfSolventWashes,
			BlankLiquidPostInjectionNumberOfSecondarySolventWashes,
			BlankLiquidPostInjectionNumberOfTertiarySolventWashes,
			BlankLiquidPostInjectionNumberOfQuaternarySolventWashes,
			BlankPostInjectionNextSamplePreparationSteps,
			BlankLiquidSampleVolume,
			BlankLiquidSampleAspirationRate,
			BlankLiquidSampleAspirationDelay,
			BlankLiquidSampleInjectionRate
		},
		{
			BlankHeadspaceSyringeTemperature,
			BlankHeadspacePreInjectionFlushTime,
			BlankHeadspacePostInjectionFlushTime,
			BlankHeadspaceSyringeFlushing,
			BlankHeadspaceSampleVolume,
			BlankHeadspaceSampleAspirationRate,
			BlankHeadspaceSampleAspirationDelay,
			BlankHeadspaceSampleInjectionRate,
			BlankHeadspaceAgitateWhileSampling
		},
		{
			BlankSPMECondition,
			BlankSPMEConditioningTemperature,
			BlankSPMEPreConditioningTime,
			BlankSPMEDerivatizingAgent,
			BlankSPMEDerivatizingAgentAdsorptionTime,
			BlankSPMEDerivatizationPosition,
			BlankSPMEDerivatizationPositionOffset,
			BlankSPMESampleExtractionTime,
			BlankSPMESampleDesorptionTime,
			BlankSPMEPostInjectionConditioningTime,
			BlankSPMEAgitateWhileSampling
		}
	};

	{
		{conflictingLiquidSamplingOptions, conflictingHeadspaceSamplingOptions, conflictingSPMESamplingOptions},
		{conflictingStandardLiquidSamplingOptions, conflictingStandardHeadspaceSamplingOptions, conflictingStandardSPMESamplingOptions},
		{conflictingBlankLiquidSamplingOptions, conflictingBlankHeadspaceSamplingOptions, conflictingBlankSPMESamplingOptions}
	} = Map[
		Function[opsList,
			Module[
				{conflictingLiquidOpsQ, conflictingHeadspaceOpsQ, conflictingSPMEOpsQ, conflictingLiquidOps, conflictingHeadspaceOps, conflictingSPMEOps, liquidOps, headspaceOps, spmeOps},
				{conflictingLiquidOpsQ, conflictingHeadspaceOpsQ, conflictingSPMEOpsQ, liquidOps, headspaceOps, spmeOps} = opsList;
				{conflictingLiquidOps, conflictingHeadspaceOps, conflictingSPMEOps} = Transpose@MapThread[
					Function[{liquidOpsQ, headspaceOpsQ, spmeOpsQ},
						{
							PickList[liquidOps, liquidOpsQ, True],
							PickList[headspaceOps, headspaceOpsQ, True],
							PickList[spmeOps, spmeOpsQ, True]
						}
					],
					{
						conflictingLiquidOpsQ,
						conflictingHeadspaceOpsQ,
						conflictingSPMEOpsQ
					}
				]
			]
		],
		{
			{conflictingLiquidSamplingOptionsQ, conflictingHeadspaceSamplingOptionsQ, conflictingSPMESamplingOptionsQ, sampleLiquidOps, sampleHeadspaceOps, sampleSPMEOps},
			{conflictingStandardLiquidSamplingOptionsQ, conflictingStandardHeadspaceSamplingOptionsQ, conflictingStandardSPMESamplingOptionsQ, standardLiquidOps, standardHeadspaceOps, standardSPMEOps},
			{conflictingBlankLiquidSamplingOptionsQ, conflictingBlankHeadspaceSamplingOptionsQ, conflictingBlankSPMESamplingOptionsQ, blankLiquidOps, blankHeadspaceOps, blankSPMEOps}
		}
	];

	conflictingSamplingMethodTests = Flatten@Map[
		Function[
			opsList,
			Module[
				{samplingMethods, conflictingLiquidOps, conflictingHeadspaceOps, conflictingSPMEOps, tests, samplingMethodsNew, conflictingLiquidOpsNew, conflictingHeadspaceOpsNew, conflictingSPMEOpsNew, noDuplicatesConflicts},
				{samplingMethods, conflictingLiquidOps, conflictingHeadspaceOps, conflictingSPMEOps} = opsList;

				noDuplicatesConflicts = DeleteDuplicates[Transpose[{samplingMethods, conflictingLiquidOps, conflictingHeadspaceOps, conflictingSPMEOps}]];

				{samplingMethodsNew, conflictingLiquidOpsNew, conflictingHeadspaceOpsNew, conflictingSPMEOpsNew} = Transpose[noDuplicatesConflicts];

				tests = MapThread[
					Function[
						{samplingMethod, liquidOps, headspaceOps, spmeOps},
						If[Length[liquidOps] > 0 && !gatherTests,
							Message[Error::OptionsNotCompatibleWithSamplingMethod, liquidOps, samplingMethod],
							Nothing
						];
						If[Length[headspaceOps] > 0 && !gatherTests,
							Message[Error::OptionsNotCompatibleWithSamplingMethod, headspaceOps, samplingMethod],
							Nothing
						];
						If[Length[spmeOps] > 0 && !gatherTests,
							Message[Error::OptionsNotCompatibleWithSamplingMethod, spmeOps, samplingMethod],
							Nothing
						];
						If[gatherTests,
							{
								Test["Liquid sampling options " <> ToString[liquidOps] <> " are only specified if the SamplingMethod is set to LiquidInjection.",
									Length[liquidOps] > 0,
									False
								],
								Test["Headspace sampling options " <> ToString[headspaceOps] <> " are only specified if the SamplingMethod is set to HeadspaceInjection.",
									Length[headspaceOps] > 0,
									False
								],
								Test["SPME sampling options " <> ToString[spmeOps] <> " are only specified if the SamplingMethod is set to SPMEInjection.",
									Length[spmeOps] > 0,
									False
								]
							}
						]
					],
					{samplingMethodsNew, conflictingLiquidOpsNew, conflictingHeadspaceOpsNew, conflictingSPMEOpsNew}
				]
			]
		],
		{
			{resolvedSamplingMethods, conflictingLiquidSamplingOptions, conflictingHeadspaceSamplingOptions, conflictingSPMESamplingOptions},
			{resolvedStandardSamplingMethods, conflictingStandardLiquidSamplingOptions, conflictingStandardHeadspaceSamplingOptions, conflictingStandardSPMESamplingOptions},
			{resolvedBlankSamplingMethods, conflictingBlankLiquidSamplingOptions, conflictingBlankHeadspaceSamplingOptions, conflictingBlankSPMESamplingOptions}
		}
	];

	(* ======= *)

	(* Pull out all the master switched variables *)

	(* Liquid options *)
	{
		masterSwitchedLiquidPreInjectionSyringeWashes,
		masterSwitchedLiquidPreInjectionSyringeWashVolumes,
		masterSwitchedLiquidPreInjectionSyringeWashRates,
		masterSwitchedLiquidPreInjectionNumberOfSolventWashes,
		masterSwitchedLiquidPreInjectionNumberOfSecondarySolventWashes,
		masterSwitchedLiquidPreInjectionNumberOfTertiarySolventWashes,
		masterSwitchedLiquidPreInjectionNumberOfQuaternarySolventWashes,
		masterSwitchedLiquidSampleWashes,
		masterSwitchedNumberOfLiquidSampleWashes,
		masterSwitchedLiquidSampleWashVolumes,
		masterSwitchedLiquidSampleFillingStrokes,
		masterSwitchedLiquidSampleFillingStrokesVolumes,
		masterSwitchedLiquidFillingStrokeDelays,
		masterSwitchedLiquidSampleOverAspirationVolumes,
		masterSwitchedLiquidPostInjectionSyringeWashes,
		masterSwitchedLiquidPostInjectionSyringeWashVolumes,
		masterSwitchedLiquidPostInjectionSyringeWashRates,
		masterSwitchedLiquidPostInjectionNumberOfSolventWashes,
		masterSwitchedLiquidPostInjectionNumberOfSecondarySolventWashes,
		masterSwitchedLiquidPostInjectionNumberOfTertiarySolventWashes,
		masterSwitchedLiquidPostInjectionNumberOfQuaternarySolventWashes,
		masterSwitchedPostInjectionNextSamplePreparationSteps,
		masterSwitchedLiquidSampleVolumes,
		masterSwitchedLiquidSampleAspirationRates,
		masterSwitchedLiquidSampleAspirationDelays,
		masterSwitchedLiquidSampleInjectionRates
	} = Transpose@masterSwitchedLiquidSamplingOptions;

	{
		masterSwitchedStandardLiquidPreInjectionSyringeWashes,
		masterSwitchedStandardLiquidPreInjectionSyringeWashVolumes,
		masterSwitchedStandardLiquidPreInjectionSyringeWashRates,
		masterSwitchedStandardLiquidPreInjectionNumberOfSolventWashes,
		masterSwitchedStandardLiquidPreInjectionNumberOfSecondarySolventWashes,
		masterSwitchedStandardLiquidPreInjectionNumberOfTertiarySolventWashes,
		masterSwitchedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes,
		masterSwitchedStandardLiquidSampleWashes,
		masterSwitchedStandardNumberOfLiquidSampleWashes,
		masterSwitchedStandardLiquidSampleWashVolumes,
		masterSwitchedStandardLiquidSampleFillingStrokes,
		masterSwitchedStandardLiquidSampleFillingStrokesVolumes,
		masterSwitchedStandardLiquidFillingStrokeDelays,
		masterSwitchedStandardLiquidSampleOverAspirationVolumes,
		masterSwitchedStandardLiquidPostInjectionSyringeWashes,
		masterSwitchedStandardLiquidPostInjectionSyringeWashVolumes,
		masterSwitchedStandardLiquidPostInjectionSyringeWashRates,
		masterSwitchedStandardLiquidPostInjectionNumberOfSolventWashes,
		masterSwitchedStandardLiquidPostInjectionNumberOfSecondarySolventWashes,
		masterSwitchedStandardLiquidPostInjectionNumberOfTertiarySolventWashes,
		masterSwitchedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
		masterSwitchedStandardPostInjectionNextSamplePreparationSteps,
		masterSwitchedStandardLiquidSampleVolumes,
		masterSwitchedStandardLiquidSampleAspirationRates,
		masterSwitchedStandardLiquidSampleAspirationDelays,
		masterSwitchedStandardLiquidSampleInjectionRates
	} = Transpose@masterSwitchedStandardLiquidSamplingOptions;

	{
		masterSwitchedBlankLiquidPreInjectionSyringeWashes,
		masterSwitchedBlankLiquidPreInjectionSyringeWashVolumes,
		masterSwitchedBlankLiquidPreInjectionSyringeWashRates,
		masterSwitchedBlankLiquidPreInjectionNumberOfSolventWashes,
		masterSwitchedBlankLiquidPreInjectionNumberOfSecondarySolventWashes,
		masterSwitchedBlankLiquidPreInjectionNumberOfTertiarySolventWashes,
		masterSwitchedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes,
		masterSwitchedBlankLiquidSampleWashes,
		masterSwitchedBlankNumberOfLiquidSampleWashes,
		masterSwitchedBlankLiquidSampleWashVolumes,
		masterSwitchedBlankLiquidSampleFillingStrokes,
		masterSwitchedBlankLiquidSampleFillingStrokesVolumes,
		masterSwitchedBlankLiquidFillingStrokeDelays,
		masterSwitchedBlankLiquidSampleOverAspirationVolumes,
		masterSwitchedBlankLiquidPostInjectionSyringeWashes,
		masterSwitchedBlankLiquidPostInjectionSyringeWashVolumes,
		masterSwitchedBlankLiquidPostInjectionSyringeWashRates,
		masterSwitchedBlankLiquidPostInjectionNumberOfSolventWashes,
		masterSwitchedBlankLiquidPostInjectionNumberOfSecondarySolventWashes,
		masterSwitchedBlankLiquidPostInjectionNumberOfTertiarySolventWashes,
		masterSwitchedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes,
		masterSwitchedBlankPostInjectionNextSamplePreparationSteps,
		masterSwitchedBlankLiquidSampleVolumes,
		masterSwitchedBlankLiquidSampleAspirationRates,
		masterSwitchedBlankLiquidSampleAspirationDelays,
		masterSwitchedBlankLiquidSampleInjectionRates
	} = Transpose@masterSwitchedBlankLiquidSamplingOptions;

	(* Headspace options *)
	{
		masterSwitchedHeadspaceSyringeTemperatures,
		masterSwitchedHeadspacePreInjectionFlushTimes,
		masterSwitchedHeadspacePostInjectionFlushTimes,
		masterSwitchedHeadspaceSyringeFlushings,
		masterSwitchedHeadspaceSampleVolumes,
		masterSwitchedHeadspaceSampleAspirationRates,
		masterSwitchedHeadspaceSampleAspirationDelays,
		masterSwitchedHeadspaceSampleInjectionRates,
		masterSwitchedHeadspaceAgitateWhileSamplings
	} = Transpose@masterSwitchedHeadspaceSamplingOptions;

	{
		masterSwitchedStandardHeadspaceSyringeTemperatures,
		masterSwitchedStandardHeadspacePreInjectionFlushTimes,
		masterSwitchedStandardHeadspacePostInjectionFlushTimes,
		masterSwitchedStandardHeadspaceSyringeFlushings,
		masterSwitchedStandardHeadspaceSampleVolumes,
		masterSwitchedStandardHeadspaceSampleAspirationRates,
		masterSwitchedStandardHeadspaceSampleAspirationDelays,
		masterSwitchedStandardHeadspaceSampleInjectionRates,
		masterSwitchedStandardHeadspaceAgitateWhileSamplings
	} = Transpose@masterSwitchedStandardHeadspaceSamplingOptions;

	{
		masterSwitchedBlankHeadspaceSyringeTemperatures,
		masterSwitchedBlankHeadspacePreInjectionFlushTimes,
		masterSwitchedBlankHeadspacePostInjectionFlushTimes,
		masterSwitchedBlankHeadspaceSyringeFlushings,
		masterSwitchedBlankHeadspaceSampleVolumes,
		masterSwitchedBlankHeadspaceSampleAspirationRates,
		masterSwitchedBlankHeadspaceSampleAspirationDelays,
		masterSwitchedBlankHeadspaceSampleInjectionRates,
		masterSwitchedBlankHeadspaceAgitateWhileSamplings
	} = Transpose@masterSwitchedBlankHeadspaceSamplingOptions;

	(* SPME options *)
	{
		masterSwitchedSPMEConditions,
		masterSwitchedSPMEConditioningTemperatures,
		masterSwitchedSPMEPreConditioningTimes,
		masterSwitchedSPMEDerivatizingAgents,
		masterSwitchedSPMEDerivatizingAgentAdsorptionTimes,
		masterSwitchedSPMEDerivatizationPositions,
		masterSwitchedSPMEDerivatizationPositionOffsets,
		masterSwitchedSPMESampleExtractionTimes,
		masterSwitchedSPMESampleDesorptionTimes,
		masterSwitchedSPMEPostInjectionConditioningTimes,
		masterSwitchedSPMEAgitateWhileSamplings
	} = Transpose@masterSwitchedSPMESamplingOptions;

	{
		masterSwitchedStandardSPMEConditions,
		masterSwitchedStandardSPMEConditioningTemperatures,
		masterSwitchedStandardSPMEPreConditioningTimes,
		masterSwitchedStandardSPMEDerivatizingAgents,
		masterSwitchedStandardSPMEDerivatizingAgentAdsorptionTimes,
		masterSwitchedStandardSPMEDerivatizationPositions,
		masterSwitchedStandardSPMEDerivatizationPositionOffsets,
		masterSwitchedStandardSPMESampleExtractionTimes,
		masterSwitchedStandardSPMESampleDesorptionTimes,
		masterSwitchedStandardSPMEPostInjectionConditioningTimes,
		masterSwitchedStandardSPMEAgitateWhileSamplings
	} = Transpose@masterSwitchedStandardSPMESamplingOptions;

	{
		masterSwitchedBlankSPMEConditions,
		masterSwitchedBlankSPMEConditioningTemperatures,
		masterSwitchedBlankSPMEPreConditioningTimes,
		masterSwitchedBlankSPMEDerivatizingAgents,
		masterSwitchedBlankSPMEDerivatizingAgentAdsorptionTimes,
		masterSwitchedBlankSPMEDerivatizationPositions,
		masterSwitchedBlankSPMEDerivatizationPositionOffsets,
		masterSwitchedBlankSPMESampleExtractionTimes,
		masterSwitchedBlankSPMESampleDesorptionTimes,
		masterSwitchedBlankSPMEPostInjectionConditioningTimes,
		masterSwitchedBlankSPMEAgitateWhileSamplings
	} = Transpose@masterSwitchedBlankSPMESamplingOptions;

	(* we'll need the total number of replicates *)
	totalNumberOfReplicates = Lookup[roundedGasChromatographyOptions, NumberOfReplicates] /. {Null -> 1};

	(* Resolve liquid injection options *)

	{resolvedLiquidSampleVolumes, resolvedStandardLiquidSampleVolumes, resolvedBlankLiquidSampleVolumes} = Map[
		Function[{optionsList},
			Module[{resolvedSampleVolumes, simulatedVolumes, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes, diluteQs, aliquotBools, aliquotVolumes, liquidSampleVolumesInternal},
				{liquidSampleVolumesInternal, simulatedVolumes, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes, diluteQs, aliquotBools, aliquotVolumes} = optionsList;
				(* === FUNCTION === *)
				(* resolve LiquidSampleVolume *)
				resolvedSampleVolumes = MapThread[
					Function[{specifiedVolume, simulatedVolume, dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume, diluteQ, aliquotBool, aliquotVolume},
						Switch[
							specifiedVolume,
							Automatic,
							(* if we will aliquot, test against the aliquot volume. If we did not, use the simulated sample volume *)
							If[aliquotBool,
								Which[
									(* No LiquidInjection *)
									Or[NullQ[aliquotVolume], NullQ[preResolvedLiquidInjectionSyringe]],
									Null,
									(* No LiquidInjectionSyringe provided, go with our default and use this to resolve LiquidInjectionSyringe downstream *)
									MatchQ[preResolvedLiquidInjectionSyringe,Automatic]||NullQ[specifiedLiquidInjectionSyringeVolume],
									Min[
										2.5Microliter,
										If[diluteQ,
											aliquotVolume + Total[{dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}],
											aliquotVolume] / totalNumberOfReplicates
									],
									(* Consider the max volume of LiquidInjectionSyringe provided *)
									True,
									Min[
										0.25 * specifiedLiquidInjectionSyringeVolume,
										If[diluteQ,
											aliquotVolume + Total[{dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}],
											aliquotVolume] / totalNumberOfReplicates
									]
								],
								Which[
									(* No LiquidInjection *)
									Or[NullQ[simulatedVolume], NullQ[preResolvedLiquidInjectionSyringe]],
									Null,
									MatchQ[preResolvedLiquidInjectionSyringe,Automatic]||NullQ[specifiedLiquidInjectionSyringeVolume],
									(* No LiquidInjectionSyringe provided, go with our default and use this to resolve LiquidInjectionSyringe downstream *)
									Min[
										2.5Microliter,
										If[diluteQ,
											simulatedVolume + Total[{dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}],
											simulatedVolume] / totalNumberOfReplicates
									],
									(* Consider the max volume of LiquidInjectionSyringe provided *)
									True,
									Min[
										0.25 * specifiedLiquidInjectionSyringeVolume,
										If[diluteQ,
											simulatedVolume + Total[{dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume} /. {Null -> 0 * Milliliter}],
											simulatedVolume] / totalNumberOfReplicates
									]
								]
							],
							Except[Automatic],
							specifiedVolume
						]
					],
					{liquidSampleVolumesInternal, simulatedVolumes, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes, diluteQs, aliquotBools, aliquotVolumes}
				]
				(* === FUNCTION === *)
			]
		],
		{
			{
				masterSwitchedLiquidSampleVolumes,
				simulatedSampleVolumes,
				resolvedDilutionSolventVolumes,
				resolvedSecondaryDilutionSolventVolumes,
				resolvedTertiaryDilutionSolventVolumes,
				resolvedDilutes,
				aliquotQ,
				requiredAliquotAmounts
			},
			{
				masterSwitchedStandardLiquidSampleVolumes,
				standardVolumes,
				resolvedStandardDilutionSolventVolumes,
				resolvedStandardSecondaryDilutionSolventVolumes,
				resolvedStandardTertiaryDilutionSolventVolumes,
				resolvedStandardDilutes,
				aliquotStandardQ,
				requiredStandardAliquotAmounts
			},
			{
				masterSwitchedBlankLiquidSampleVolumes,
				blankVolumes,
				resolvedBlankDilutionSolventVolumes,
				resolvedBlankSecondaryDilutionSolventVolumes,
				resolvedBlankTertiaryDilutionSolventVolumes,
				resolvedBlankDilutes,
				aliquotBlankQ,
				requiredBlankAliquotAmounts
			}
		}
	];

	(* make sure we have enough sample to complete the experiment if we are working with liquid samples *)
	injectionVolumeErrorTuples = Map[
		Function[{optionsList},
			Module[{insufficientVolumeOptions, insufficientVolumeTests, insufficientVolumeQ, resolvedVolumes, simulatedVolumes, dilutionSolventVolumes, secondaryDilutionSolventVolumes,
				tertiaryDilutionSolventVolumes, diluteQs, aliquotBools, aliquotVolumes, prefix},
				{resolvedVolumes, simulatedVolumes, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes, diluteQs, aliquotBools, aliquotVolumes, prefix} = optionsList;
				(* === FUNCTION === *)
				(* make sure the resolved amount has a sufficient source volume *)
				insufficientVolumeQ = MapThread[
					Function[{resolvedVolume, simulatedVolume, dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume, diluteQ, aliquotBool, aliquotVolume},
						(* make sure the resolved volume is less than the required amount *)
						MatchQ[resolvedVolume,
							GreaterEqualP[
								If[aliquotBool,
									If[diluteQ,
										aliquotVolume + Total[{dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume} /. {Null -> 0 * Mililiter}],
										aliquotVolume] / totalNumberOfReplicates,
									If[diluteQ,
										simulatedVolume + Total[{dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume} /. {Null -> 0 * Mililiter}],
										simulatedVolume] / totalNumberOfReplicates
								]
							]
						]
					],
					{resolvedVolumes, simulatedVolumes, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes, diluteQs, aliquotBools, aliquotVolumes}
				];

				(* if we have an insufficient volume, add the right options to the bad options list *)
				insufficientVolumeOptions = If[Or @@ insufficientVolumeQ, {ToExpression@StringJoin[prefix, "InjectionVolume"]}, {}];

				(* throw an error if we need to *)
				If[!gatherTests,
					If[Or @@ insufficientVolumeQ,
						Message[Error::InsufficientSampleVolume, PickList[resolvedVolumes, insufficientVolumeQ, True], prefix],
						Nothing
					],
					Nothing
				];

				(* create tests *)
				insufficientVolumeTests = If[gatherTests,
					Test[
						"If " <> prefix <> "InjectionVolume is specified, the amount of sample expected to be present in the sample is expected to be less than or equal to the total amount to be injected:",
						Or @@ insufficientVolumeQ,
						False
					],
					{}
				];

				(* return results *)
				{insufficientVolumeOptions, insufficientVolumeTests}

				(* === FUNCTION === *)
			]
		],
		{
			{
				resolvedLiquidSampleVolumes,
				simulatedSampleVolumes,
				resolvedDilutionSolventVolumes,
				resolvedSecondaryDilutionSolventVolumes,
				resolvedTertiaryDilutionSolventVolumes,
				resolvedDilutes,
				aliquotQ,
				requiredAliquotAmounts,
				""
			},
			{
				resolvedStandardLiquidSampleVolumes,
				standardVolumes,
				resolvedStandardDilutionSolventVolumes,
				resolvedStandardSecondaryDilutionSolventVolumes,
				resolvedStandardTertiaryDilutionSolventVolumes,
				resolvedStandardDilutes,
				aliquotStandardQ,
				requiredStandardAliquotAmounts,
				"Standard"
			},
			{
				resolvedBlankLiquidSampleVolumes,
				blankVolumes,
				resolvedBlankDilutionSolventVolumes,
				resolvedBlankSecondaryDilutionSolventVolumes,
				resolvedBlankTertiaryDilutionSolventVolumes,
				resolvedBlankDilutes,
				aliquotBlankQ,
				requiredBlankAliquotAmounts,
				"Blank"
			}
		}
	];

	(* extract the options and tests from the tuples *)
	{insufficientSampleVolumeOptions, insufficientSampleVolumeTests} = {Flatten[injectionVolumeErrorTuples[[All, 1]]], Flatten[injectionVolumeErrorTuples[[All, 2]]]};

	(* === Resolve LiquidInjectionSyringe === *)
	(* Now we have resolvedLiquidSampleVolumes/resolvedStandardLiquidSampleVolumes/resolvedBlankLiquidSampleVolumes *)
	(* supported syringes: Alternatives[
	(*name form*)
	Model[Container,Syringe,"1 \[Mu]L GC liquid sample injection syringe"], (* 1 microliter *)
	Model[Container,Syringe,"5 \[Mu]L GC liquid sample injection syringe"], (* 5 microliter *)
	Model[Container,Syringe,"10 \[Mu]L GC liquid sample injection syringe"], (* 10 microliter *)
	Model[Container,Syringe,"25 \[Mu]L GC liquid sample injection syringe"], (* 25 microliter *)
	Model[Container,Syringe,"100 \[Mu]L GC liquid sample injection syringe"],  (* 100 microliter *)
	(*object form*)
	Model[Container, Syringe, "id:bq9LA0JE9VG6"], (* 1 microliter *)
	Model[Container, Syringe, "id:KBL5Dvw9LKjj"], (* 5 microliter *)
	Model[Container, Syringe, "id:dORYzZJxRqER"], (* 10 microliter *)
	Model[Container, Syringe, "id:R8e1Pjp9eN0K"], (* 25 microliter *)
	Model[Container, Syringe, "id:eGakldJEaRYG"]  (* 100 microliter *)
] *)
	(* Get the resolved injection volumes *)
	liquidSampleVolumeQuantities = Cases[Flatten[{resolvedLiquidSampleVolumes,resolvedStandardLiquidSampleVolumes,resolvedBlankLiquidSampleVolumes}], _Quantity];

	resolvedLiquidInjectionSyringe = Which[
		(* If the LiquidInjectionSyringe is already specified, go with that one *)
		MatchQ[specifiedLiquidInjectionSyringeModelType, LiquidInjection],
		specifiedLiquidInjectionSyringe,
		(* If there are no LiquidInjection samples, we don't need a LiquidInjectionSyringe *)
		MatchQ[specifiedLiquidInjectionSyringe, Automatic] && Not[MemberQ[allSamplingMethods, LiquidInjection]],
		Null,
		(* If there are LiquidInjection samples with resolved liquid injection volumes, resolve a syringe that can fit the range of the smallest to the largest sample size *)
		MatchQ[specifiedLiquidInjectionSyringe, Automatic] && MemberQ[allSamplingMethods, LiquidInjection] && MemberQ[liquidSampleVolumeQuantities, _Quantity],
		(* Get the minimum and maximum injection sizes and pick the smallest syringe that can accommodate these values (largest volume fits) *)
		Which[
			Max[liquidSampleVolumeQuantities] < 1 * Microliter,
			Model[Container, Syringe, "1 \[Mu]L GC liquid sample injection syringe"],
			Max[liquidSampleVolumeQuantities] < 5 * Microliter,
			Model[Container, Syringe, "5 \[Mu]L GC liquid sample injection syringe"],
			Max[liquidSampleVolumeQuantities] < 10 * Microliter,
			Model[Container, Syringe, "10 \[Mu]L GC liquid sample injection syringe"],
			Max[liquidSampleVolumeQuantities] < 25 * Microliter,
			Model[Container, Syringe, "25 \[Mu]L GC liquid sample injection syringe"],
			Max[liquidSampleVolumeQuantities] > 25 * Microliter,
			Model[Container, Syringe, "100 \[Mu]L GC liquid sample injection syringe"]
		],
		(* what if we haven't been able to resolve a syringe based on all these options? *)
		True,
		Null
	];

	(* if we failed to resolve a liquid injection syringe, we have to figure out why and throw an error. *)

	(* first case: a liquid injection sample is specified but the specified value is null. *)
	liquidInjectionSyringeMissingQ = MemberQ[allSamplingMethods, LiquidInjection] && MatchQ[specifiedLiquidInjectionSyringe, Null];

	(* second case: the injection type of the specified syringe was incorrect *)
	incompatibleLiquidInjectionSyringeQ = MatchQ[specifiedLiquidInjectionSyringe, ObjectP[]] && !MatchQ[specifiedLiquidInjectionSyringeModelType, LiquidInjection];

	(* throw the appropriate errors *)
	liquidInjectionSyringeOption = If[(liquidInjectionSyringeMissingQ || incompatibleLiquidInjectionSyringeQ),
		If[!gatherTests && liquidInjectionSyringeMissingQ, Message[Error::GCLiquidInjectionSyringeRequired]];
		If[!gatherTests && incompatibleLiquidInjectionSyringeQ, Message[Error::GCIncompatibleLiquidInjectionSyringe]];
		LiquidInjectionSyringe,
		{}
	];

	liquidInjectionSyringeTests = If[gatherTests,
		{
			Test["If a liquid injection sample is specified, a liquid injection syringe is also specified:",
				liquidInjectionSyringeMissingQ,
				False
			],
			Test["If a liquid injection syringe is specified, it is compatible with the requested instrument:",
				incompatibleLiquidInjectionSyringeQ,
				False
			]
		},
		{}
	];

	(* Get the MaxVolume of the syringe from cache *)
	resolvedLiquidInjectionSyringeVolume = If[NullQ[resolvedLiquidInjectionSyringe],
		Nothing,
		Convert[Lookup[fetchPacketFromCache[resolvedLiquidInjectionSyringe, cache], MaxVolume], Microliter]
	];

	(* now that we have resolved all the required syringes, do a final check to make sure the user hasn't specified an unneeded syringe/fiber *)
	{unneededLiquidInjectionSyringeQ, unneededHeadspaceInjectionSyringeQ, unneededSPMEFiberQ, unneededLiquidHandlingSyringeQ} = MapThread[
		(* a syringe is unneeded if a syringe is specified but there are no injections of that type *)
		MatchQ[#1, ObjectP[]] && Not[MemberQ[#3, #2]]&,
		{
			{resolvedLiquidInjectionSyringe, resolvedHeadspaceInjectionSyringe, resolvedSPMEInjectionFiber, resolvedLiquidHandlingSyringe},
			{LiquidInjection, HeadspaceInjection, SPMEInjection, True},
			{allSamplingMethods, allSamplingMethods, allSamplingMethods, Flatten[{resolvedDilutes, resolvedStandardDilutes, resolvedBlankDilutes}]}
		}
	];

	(* throw a warning if needed *)
	If[!gatherTests,
		MapThread[
			(* a syringe is specified but there are no injections of that type *)
			If[#1,
				Message[Warning::UnneededSyringeComponent, #2, #3, #4],
				Nothing
			]&,
			{
				{unneededLiquidInjectionSyringeQ, unneededHeadspaceInjectionSyringeQ, unneededSPMEFiberQ, unneededLiquidHandlingSyringeQ},
				{LiquidInjectionSyringe, HeadspaceInjectionSyringe, SPMEInjectionFiber, LiquidHandlingSyringe},
				{LiquidInjection, HeadspaceInjection, SPMEInjection, True},
				{SamplingMethod, SamplingMethod, SamplingMethod, {Dilute, StandardDilute, BlankDilute}}
			}
		],
		Nothing
	];

	(* create tests if needed *)
	unneededSyringeTests = If[gatherTests,
		MapThread[
			(* a syringe is specified but there are no injections of that type *)
			Test["If a " <> ToString[#2] <> " is specified, at least one value in option(s) " <> ToString[#4] <> " must be set to " <> ToString[#3] <> ".",
				#1,
				False
			]&,
			{
				{unneededLiquidInjectionSyringeQ, unneededHeadspaceInjectionSyringeQ, unneededSPMEFiberQ, unneededLiquidHandlingSyringeQ},
				{LiquidInjectionSyringe, HeadspaceInjectionSyringe, SPMEInjectionFiber, LiquidHandlingSyringe},
				{LiquidInjection, HeadspaceInjection, SPMEInjection, True},
				{SamplingMethod, SamplingMethod, SamplingMethod, {Dilute, StandardDilute, BlankDilute}}
			}
		],
		{}
	];

	(* Make sure all the sample volumes are between 1-100% of the syringe volume *)

	{outOfRangeLiquidSampleVolumes, outOfRangeStandardLiquidSampleVolumes, outOfRangeBlankLiquidSampleVolumes} = Map[
		Function[{sampleVolumes},
			Select[
				Cases[sampleVolumes, _Quantity],
				# < 0.01 * resolvedLiquidInjectionSyringeVolume || # > resolvedLiquidInjectionSyringeVolume || NullQ[resolvedLiquidInjectionSyringeVolume] &
			]
		],
		{resolvedLiquidSampleVolumes, resolvedStandardLiquidSampleVolumes, resolvedBlankLiquidSampleVolumes}
	] /. {{} -> Null}; (* Can't mapthread empty lists, wow *)

	(* if there are volumes outside that range, either throw an error or generate a failing test *)
	invalidGCSampleVolumeOutOfRangeOptions = If[
		Length[DeleteCases[Flatten[{outOfRangeLiquidSampleVolumes, outOfRangeStandardLiquidSampleVolumes, outOfRangeBlankLiquidSampleVolumes}], Null]] > 0,
		{InjectionVolume, LiquidInjectionSyringe},
		Nothing
	];

	If[!gatherTests,
		Map[
			Function[{incompatibleSampleVolumes},
				If[Length[incompatibleSampleVolumes] > 0,
					Message[Error::GCSampleVolumeOutOfRange, incompatibleSampleVolumes, Liquid, resolvedLiquidInjectionSyringeVolume],
					Nothing
				]
			],
			{outOfRangeLiquidSampleVolumes, outOfRangeStandardLiquidSampleVolumes, outOfRangeBlankLiquidSampleVolumes}
		],
		Nothing
	];

	{outOfRangeLiquidSampleVolumeTests, outOfRangeStandardLiquidSampleVolumeTests, outOfRangeBlankLiquidSampleVolumeTests} = If[gatherTests,
		MapThread[
			Function[{incompatibleSampleVolumes, name},
				Test["The specified " <> name <> "InjectionVolume for each LiquidInjection sample falls between 1% and 100% of the volume of the specified LiquidInjectionSyringe (" <> ToString[resolvedLiquidInjectionSyringeVolume] <> ").",
					Length[incompatibleSampleVolumes] > 0,
					False
				]
			],
			{
				{outOfRangeLiquidSampleVolumes, outOfRangeStandardLiquidSampleVolumes, outOfRangeBlankLiquidSampleVolumes},
				{"", "Standard", "Blank"}
			}
		],
		{{}, {}, {}}
	];

	(* Create a boolean to describe whether the Nth syringe wash solvent has been specified *)
	{
		syringeWashSolventSpecifiedQ,
		secondarySyringeWashSolventSpecifiedQ,
		tertiarySyringeWashSolventSpecifiedQ,
		quaternarySyringeWashSolventSpecifiedQ
	} = Map[MatchQ[#, ObjectP[{Object[Sample], Model[Sample]}]]&,
		Lookup[roundedGasChromatographyOptions, {SyringeWashSolvent, SecondarySyringeWashSolvent, TertiarySyringeWashSolvent, QuaternarySyringeWashSolvent}]];

	(* Indicate whether a syringe wash solvent has been specified *)
	syringeWashSolventsPresentQ = MemberQ[{syringeWashSolventSpecifiedQ, secondarySyringeWashSolventSpecifiedQ, tertiarySyringeWashSolventSpecifiedQ, quaternarySyringeWashSolventSpecifiedQ}, True];

	(* there are weird hidden options for the sample aspiration, filling strokes, and injection flow rates *)
	maxLiquidSampleAspirationRate = Switch[
		resolvedLiquidInjectionSyringeVolume,
		EqualP[1 * Microliter],
		10 * Microliter / Second,
		RangeP[5 * Microliter, 25 * Microliter],
		25 * Microliter / Second,
		EqualP[100 * Microliter],
		50 * Microliter / Second,
		Nothing,
		50 * Microliter / Second
	];

	maxLiquidFillingStrokesRate = Switch[
		resolvedLiquidInjectionSyringeVolume,
		EqualP[1 * Microliter],
		10 * Microliter / Second,
		GreaterEqualP[5 * Microliter],
		50 * Microliter / Second,
		Nothing,
		50 * Microliter / Second
	];

	maxLiquidInjectionRate = Switch[
		resolvedLiquidInjectionSyringeVolume,
		EqualP[1 * Microliter],
		10 * Microliter / Second,
		EqualP[5 * Microliter],
		50 * Microliter / Second,
		EqualP[10 * Microliter],
		100 * Microliter / Second,
		EqualP[25 * Microliter],
		225 * Microliter / Second,
		EqualP[100 * Microliter],
		250 * Microliter / Second,
		Nothing,
		250 * Microliter / Second
	];

	(* Resolve the pre injection syringe wash procedure for samples, standards, and blanks *)
	{
		{
			resolvedLiquidPreInjectionSyringeWashes,
			resolvedLiquidPreInjectionSyringeWashVolumes,
			resolvedLiquidPreInjectionSyringeWashRates,
			resolvedLiquidPreInjectionNumberOfSolventWashes,
			resolvedLiquidPreInjectionNumberOfSecondarySolventWashes,
			resolvedLiquidPreInjectionNumberOfTertiarySolventWashes,
			resolvedLiquidPreInjectionNumberOfQuaternarySolventWashes
		},
		{
			resolvedStandardLiquidPreInjectionSyringeWashes,
			resolvedStandardLiquidPreInjectionSyringeWashVolumes,
			resolvedStandardLiquidPreInjectionSyringeWashRates,
			resolvedStandardLiquidPreInjectionNumberOfSolventWashes,
			resolvedStandardLiquidPreInjectionNumberOfSecondarySolventWashes,
			resolvedStandardLiquidPreInjectionNumberOfTertiarySolventWashes,
			resolvedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes
		},
		{
			resolvedBlankLiquidPreInjectionSyringeWashes,
			resolvedBlankLiquidPreInjectionSyringeWashVolumes,
			resolvedBlankLiquidPreInjectionSyringeWashRates,
			resolvedBlankLiquidPreInjectionNumberOfSolventWashes,
			resolvedBlankLiquidPreInjectionNumberOfSecondarySolventWashes,
			resolvedBlankLiquidPreInjectionNumberOfTertiarySolventWashes,
			resolvedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes
		}
	} = Map[
		Function[{optionsList},
			Module[{liquidPreInjectionSyringeWashes, liquidPreInjectionSyringeWashVolumes, liquidPreInjectionSyringeWashRates, liquidPreInjectionNumberOfSolventWashes,
				liquidPreInjectionNumberOfSecondarySolventWashes, liquidPreInjectionNumberOfTertiarySolventWashes, liquidPreInjectionNumberOfQuaternarySolventWashes, liquidSampleVolumesInternal,
				resolvedWashBooleans, resolvedPreInjectionSyringeWashVolumes, resolvedPreInjectionSyringeWashRates, resolvedPreInjectionNumberOfSolventWashes,
				resolvedPreInjectionNumberOfSecondarySolventWashes, resolvedPreInjectionNumberOfTertiarySolventWashes, resolvedPreInjectionNumberOfQuaternarySolventWashes},
				{liquidPreInjectionSyringeWashes, liquidPreInjectionSyringeWashVolumes, liquidPreInjectionSyringeWashRates, liquidPreInjectionNumberOfSolventWashes,
					liquidPreInjectionNumberOfSecondarySolventWashes, liquidPreInjectionNumberOfTertiarySolventWashes, liquidPreInjectionNumberOfQuaternarySolventWashes,
					liquidSampleVolumesInternal} = optionsList;
				(* === FUNCTION === *)

				resolvedWashBooleans = MapThread[
					Function[{washBoolean, washVolume, washRate, solventWashes, secondarySolventWashes, tertiarySolventWashes, quaternarySolventWashes},
						Switch[
							{washBoolean, washVolume, washRate, solventWashes, secondarySolventWashes, tertiarySolventWashes, quaternarySolventWashes},
							(* If boolean is set, leave it *)
							{Except[Automatic], _, _, _, _, _, _},
							washBoolean,
							(* If boolean is Automatic and everything else is Automatic or Null, set it to false *)
							{Automatic, (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null)},
							False,
							(* If boolean is Automatic and and any washes, volume, or rate are specified, set this to true *)
							{Automatic, (Automatic | Null | _Quantity), (Automatic | Null | _Quantity), (Automatic | Null | _Integer | _Real), (Automatic | Null | _Integer | _Real), (Automatic | Null | _Integer | _Real), (Automatic | Null | _Integer | _Real)},
							True
						]
					],
					{
						liquidPreInjectionSyringeWashes,
						liquidPreInjectionSyringeWashVolumes,
						liquidPreInjectionSyringeWashRates,
						liquidPreInjectionNumberOfSolventWashes,
						liquidPreInjectionNumberOfSecondarySolventWashes,
						liquidPreInjectionNumberOfTertiarySolventWashes,
						liquidPreInjectionNumberOfQuaternarySolventWashes
					}
				];

				(* Resolve PreInjectionSyringeWash parameters *)

				(* LiquidPreInjectionSyringeWashVolume *)
				resolvedPreInjectionSyringeWashVolumes = MapThread[
					Switch[
						{#1, #2},
						(* If the parameter is specified, leave it alone *)
						{Except[Automatic], _},
						#1,
						(* If the parameter is Automatic and washBoolean is False, set it to Null *)
						{Automatic, False},
						Null,
						(* If the parameter is Automatic and the washBoolean is True, resolve to 1.2*resolvedLiquidSampleVolume *)
						{Automatic, True},
						Switch[
							#3,
							BlankNoVolume,
							0.25 * resolvedLiquidInjectionSyringeVolume,
							_,
							1.2 * #3
						]
					]&,
					{
						liquidPreInjectionSyringeWashVolumes,
						resolvedWashBooleans,
						liquidSampleVolumesInternal
					}
				];

				(* LiquidPreInjectionSyringeWashRate *)
				resolvedPreInjectionSyringeWashRates = MapThread[
					Switch[
						{#1, #2},
						(* If the parameter is specified, leave it alone *)
						{Except[Automatic], _},
						#1,
						(* If the parameter is Automatic and washBoolean is False, set it to Null *)
						{Automatic, False},
						Null,
						(* If the parameter is Automatic and the washBoolean is True, resolve to 5 uL/sec *)
						{Automatic, True},
						maxLiquidSampleAspirationRate * 0.2
					]&,
					{
						liquidPreInjectionSyringeWashRates,
						resolvedWashBooleans
					}
				];

				(* LiquidPreInjectionNumberOfSolventWashes *)

				(* Use the solvent specified booleans to resolve whether the syringe should be washed with any of the solvents *)
				{resolvedPreInjectionNumberOfSolventWashes, resolvedPreInjectionNumberOfSecondarySolventWashes, resolvedPreInjectionNumberOfTertiarySolventWashes, resolvedPreInjectionNumberOfQuaternarySolventWashes} = MapThread[
					MapThread[
						Function[{specifiedWashes, washBoolean},
							Switch[
								specifiedWashes,
								(* If the number of washes has already been specified, leave it as is. *)
								Except[Automatic],
								specifiedWashes,
								(* If the specified # of washes is Automatic and the washBoolean is True, resolve the number of washes to 3 *)
								Automatic,
								If[#2 && washBoolean,
									3,
									Null
								]
							]
						],
						{#1, resolvedWashBooleans}
					]&,
					{
						{liquidPreInjectionNumberOfSolventWashes, liquidPreInjectionNumberOfSecondarySolventWashes, liquidPreInjectionNumberOfTertiarySolventWashes, liquidPreInjectionNumberOfQuaternarySolventWashes},
						{syringeWashSolventSpecifiedQ, secondarySyringeWashSolventSpecifiedQ, tertiarySyringeWashSolventSpecifiedQ, quaternarySyringeWashSolventSpecifiedQ}
					}
				];

				{
					resolvedWashBooleans,
					resolvedPreInjectionSyringeWashVolumes,
					resolvedPreInjectionSyringeWashRates,
					resolvedPreInjectionNumberOfSolventWashes,
					resolvedPreInjectionNumberOfSecondarySolventWashes,
					resolvedPreInjectionNumberOfTertiarySolventWashes,
					resolvedPreInjectionNumberOfQuaternarySolventWashes
				}
				(* === FUNCTION === *)
			]
		],
		{
			{
				masterSwitchedLiquidPreInjectionSyringeWashes,
				masterSwitchedLiquidPreInjectionSyringeWashVolumes,
				masterSwitchedLiquidPreInjectionSyringeWashRates,
				masterSwitchedLiquidPreInjectionNumberOfSolventWashes,
				masterSwitchedLiquidPreInjectionNumberOfSecondarySolventWashes,
				masterSwitchedLiquidPreInjectionNumberOfTertiarySolventWashes,
				masterSwitchedLiquidPreInjectionNumberOfQuaternarySolventWashes,
				resolvedLiquidSampleVolumes
			},
			{
				masterSwitchedStandardLiquidPreInjectionSyringeWashes,
				masterSwitchedStandardLiquidPreInjectionSyringeWashVolumes,
				masterSwitchedStandardLiquidPreInjectionSyringeWashRates,
				masterSwitchedStandardLiquidPreInjectionNumberOfSolventWashes,
				masterSwitchedStandardLiquidPreInjectionNumberOfSecondarySolventWashes,
				masterSwitchedStandardLiquidPreInjectionNumberOfTertiarySolventWashes,
				masterSwitchedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes,
				resolvedStandardLiquidSampleVolumes
			},
			{
				masterSwitchedBlankLiquidPreInjectionSyringeWashes,
				masterSwitchedBlankLiquidPreInjectionSyringeWashVolumes,
				masterSwitchedBlankLiquidPreInjectionSyringeWashRates,
				masterSwitchedBlankLiquidPreInjectionNumberOfSolventWashes,
				masterSwitchedBlankLiquidPreInjectionNumberOfSecondarySolventWashes,
				masterSwitchedBlankLiquidPreInjectionNumberOfTertiarySolventWashes,
				masterSwitchedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes,
				resolvedBlankLiquidSampleVolumes
			}
		}
	];

	(* error check all the pre-injection syringe wash options for internal conflicts *)
	preInjectionSyringeWashesConflictTuples = Map[
		Function[opsList,
			Module[
				{
					boolean, syringeWashVolumes, syringeWashRates, numberOfSolventWashes, numberOfSecondarySolventWashes, numberOfTertiarySolventWashes, numberOfQuaternarySolventWashes, prefix,
					conflictingOptions, conflictingPreInjectionSyringeWashesBooleanOptions, syringeWashVolumeConflicts, syringeWashRateConflicts, numberOfSolventWashConflicts,
					numberOfSecondarySolventWashConflicts, numberOfTertiarySolventWashConflicts, numberOfQuaternarySolventWashConflicts, preInjectionSyringeWashBooleanConflicts,
					preInjectionSyringeWashBooleanConflictTest
				},
				{boolean, syringeWashVolumes, syringeWashRates, numberOfSolventWashes, numberOfSecondarySolventWashes, numberOfTertiarySolventWashes, numberOfQuaternarySolventWashes, prefix} = opsList;
				(* with autosampler primitives this will be possible, but I'm considering the options here to represent only the behavior at injection time *)

				(* conflicts with preInjectionSyringeWashes boolean *)
				{
					syringeWashVolumeConflicts,
					syringeWashRateConflicts,
					numberOfSolventWashConflicts,
					numberOfSecondarySolventWashConflicts,
					numberOfTertiarySolventWashConflicts,
					numberOfQuaternarySolventWashConflicts
				} = Transpose@MapThread[
					Function[
						{preInjectionSyringeWashesQ, syringeWashVolume, syringeWashRate, solventWashes, secondarySolventWashes, tertiarySolventWashes, quaternarySolventWashes},
						{
							(MatchQ[preInjectionSyringeWashesQ, True] && MatchQ[syringeWashVolume, Null]) || (MatchQ[preInjectionSyringeWashesQ, False] && MatchQ[syringeWashVolume, Except[Null | Automatic]]),
							(MatchQ[preInjectionSyringeWashesQ, True] && MatchQ[syringeWashRate, Null]) || (MatchQ[preInjectionSyringeWashesQ, False] && MatchQ[syringeWashRate, Except[Null | Automatic]]),
							(MatchQ[preInjectionSyringeWashesQ, True] && MatchQ[solventWashes, Null]) || (MatchQ[preInjectionSyringeWashesQ, False] && MatchQ[solventWashes, Except[Null | Automatic]]),
							(MatchQ[preInjectionSyringeWashesQ, True] && MatchQ[secondarySolventWashes, Null]) || (MatchQ[preInjectionSyringeWashesQ, False] && MatchQ[secondarySolventWashes, Except[Null | Automatic]]),
							(MatchQ[preInjectionSyringeWashesQ, True] && MatchQ[tertiarySolventWashes, Null]) || (MatchQ[preInjectionSyringeWashesQ, False] && MatchQ[tertiarySolventWashes, Except[Null | Automatic]]),
							(MatchQ[preInjectionSyringeWashesQ, True] && MatchQ[quaternarySolventWashes, Null]) || (MatchQ[preInjectionSyringeWashesQ, False] && MatchQ[quaternarySolventWashes, Except[Null | Automatic]])
						}
					],
					{boolean, syringeWashVolumes, syringeWashRates, numberOfSolventWashes, numberOfSecondarySolventWashes, numberOfTertiarySolventWashes, numberOfQuaternarySolventWashes}
				];

				(* figure out if we have a problem *)
				preInjectionSyringeWashBooleanConflicts = Or @@ Flatten[{syringeWashVolumeConflicts, syringeWashRateConflicts, numberOfSolventWashConflicts,
					numberOfSecondarySolventWashConflicts, numberOfTertiarySolventWashConflicts, numberOfQuaternarySolventWashConflicts}];

				conflictingPreInjectionSyringeWashesBooleanOptions = MapThread[
					If[Or @@ #1, ToExpression@StringJoin[prefix, #2], Nothing]&,
					{
						{
							preInjectionSyringeWashBooleanConflicts,
							syringeWashVolumeConflicts,
							syringeWashRateConflicts,
							numberOfSolventWashConflicts,
							numberOfSecondarySolventWashConflicts,
							numberOfTertiarySolventWashConflicts,
							numberOfQuaternarySolventWashConflicts
						},
						{
							"LiquidPreInjectionSyringeWash",
							"LiquidPreInjectionSyringeWashVolume",
							"LiquidPreInjectionSyringeWashRate",
							"LiquidPreInjectionNumberOfSolventWashes",
							"LiquidPreInjectionNumberOfSecondarySolventWashes",
							"LiquidPreInjectionNumberOfTertiarySolventWashes",
							"LiquidPreInjectionNumberOfQuaternarySolventWashes"
						}
					}
				];

				conflictingOptions = conflictingPreInjectionSyringeWashesBooleanOptions;

				(* if we have conflicts, throw an error *)
				If[preInjectionSyringeWashBooleanConflicts && !gatherTests,
					Message[Error::PreInjectionSyringeWashOptionsConflict, Cases[conflictingPreInjectionSyringeWashesBooleanOptions, Except[ToExpression@StringJoin[prefix, "LiquidPreInjectionSyringeWash"]]]]
				];

				(* gather relevant tests *)
				preInjectionSyringeWashBooleanConflictTest = If[gatherTests,
					Test["LiquidPreInjectionSyringeWash options are only specified if " <> prefix <> "LiquidPreInjectionSyringeWash is True:",
						preInjectionSyringeWashBooleanConflicts,
						False
					],
					{}
				];

				(* format the output *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{preInjectionSyringeWashBooleanConflictTest}]
				}
			]
		],
		{
			{resolvedLiquidPreInjectionSyringeWashes, specifiedLiquidPreInjectionSyringeWashVolumes, specifiedLiquidPreInjectionSyringeWashRates, specifiedLiquidPreInjectionNumberOfSolventWashes, specifiedLiquidPreInjectionNumberOfSecondarySolventWashes, specifiedLiquidPreInjectionNumberOfTertiarySolventWashes, specifiedLiquidPreInjectionNumberOfQuaternarySolventWashes, ""},
			{resolvedStandardLiquidPreInjectionSyringeWashes, specifiedStandardLiquidPreInjectionSyringeWashVolumes, specifiedStandardLiquidPreInjectionSyringeWashRates, specifiedStandardLiquidPreInjectionNumberOfSolventWashes, specifiedStandardLiquidPreInjectionNumberOfSecondarySolventWashes, specifiedStandardLiquidPreInjectionNumberOfTertiarySolventWashes, specifiedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes, "Standard"},
			{resolvedBlankLiquidPreInjectionSyringeWashes, specifiedBlankLiquidPreInjectionSyringeWashVolumes, specifiedBlankLiquidPreInjectionSyringeWashRates, specifiedBlankLiquidPreInjectionNumberOfSolventWashes, specifiedBlankLiquidPreInjectionNumberOfSecondarySolventWashes, specifiedBlankLiquidPreInjectionNumberOfTertiarySolventWashes, specifiedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes, "Blank"}
		}
	];

	(* split the resulting tuples to create error issues *)
	{preInjectionSyringeWashesConflictOptions, preInjectionSyringeWashesConflictTests} = {Flatten[preInjectionSyringeWashesConflictTuples[[All, 1]]], Flatten[preInjectionSyringeWashesConflictTuples[[All, 2]]]};


	(* Resolved the sample washing step for samples and standards *)
	{
		{resolvedLiquidSampleWashes, resolvedNumberOfLiquidSampleWashes, resolvedLiquidSampleWashVolumes},
		{resolvedStandardLiquidSampleWashes, resolvedStandardNumberOfLiquidSampleWashes, resolvedStandardLiquidSampleWashVolumes},
		{resolvedBlankLiquidSampleWashes, resolvedBlankNumberOfLiquidSampleWashes, resolvedBlankLiquidSampleWashVolumes}
	} = Map[
		Function[{optionsList},
			Module[{resolvedNumberOfSampleWashes, resolvedSampleWashVolumes, numberOfLiquidSampleWashes, liquidSampleWashVolumes, liquidSampleVolumesInternal, sampleWashMasterSwitches, resolvedSampleWashMasterSwitches},
				{sampleWashMasterSwitches, numberOfLiquidSampleWashes, liquidSampleWashVolumes, liquidSampleVolumesInternal} = optionsList;
				(* === FUNCTION === *)

				(* LiquidSampleWash *)
				resolvedSampleWashMasterSwitches = MapThread[
					Function[{switch, sampleWashes, washVolumes, sampleVolumes},
						Switch[
							switch,
							Automatic,
							!MemberQ[{sampleWashes, washVolumes}, Null] && !NullQ[sampleVolumes],
							Except[Automatic],
							switch
						]
					],
					{sampleWashMasterSwitches, numberOfLiquidSampleWashes, liquidSampleWashVolumes, liquidSampleVolumesInternal}
				];

				(*NumberOfLiquidSampleWashes*)
				resolvedNumberOfSampleWashes = MapThread[
					Switch[
						{#1, #2},
						{Automatic, True},
						3,
						{Automatic, False | Null},
						Null,
						{Except[Automatic], _},
						#1
					]&,
					{numberOfLiquidSampleWashes, resolvedSampleWashMasterSwitches}
				];

				(*LiquidSampleWashVolume*)
				resolvedSampleWashVolumes = MapThread[
					Switch[
						{#1, #2},
						(* If there will be sample washes, specify a default volume of 125% the sample volume or the maximum volume of the syringe, whichever is smaller because we can't exceed the syringe volume*)
						{Automatic, Except[False | Null]},
						If[NullQ[#3],
							Null,
							Min[1.25 * #3, resolvedLiquidInjectionSyringeVolume]
						],
						(* Otherwise Null *)
						{Automatic, (False | Null)},
						Null,
						(* If specified leave it alone *)
						{Except[Automatic], _},
						#1
					]&,
					{liquidSampleWashVolumes, resolvedSampleWashMasterSwitches, liquidSampleVolumesInternal}
				];

				{resolvedSampleWashMasterSwitches, resolvedNumberOfSampleWashes, resolvedSampleWashVolumes}

				(* === FUNCTION === *)
			]
		],
		{
			{
				masterSwitchedLiquidSampleWashes,
				masterSwitchedNumberOfLiquidSampleWashes,
				masterSwitchedLiquidSampleWashVolumes,
				resolvedLiquidSampleVolumes
			},
			{
				masterSwitchedStandardLiquidSampleWashes,
				masterSwitchedStandardNumberOfLiquidSampleWashes,
				masterSwitchedStandardLiquidSampleWashVolumes,
				resolvedStandardLiquidSampleVolumes
			},
			{
				masterSwitchedBlankLiquidSampleWashes,
				masterSwitchedBlankNumberOfLiquidSampleWashes,
				masterSwitchedBlankLiquidSampleWashVolumes,
				resolvedBlankLiquidSampleVolumes
			}
		}
	];

	(* error check all the pre-injection syringe wash options for internal conflicts *)
	sampleWashConflictTuples = Map[
		Function[opsList,
			Module[
				{
					boolean, samplesWashes, washVolumes, prefix, samplesWashConflicts, washVolumeConflicts, sampleWashBooleanConflicts, conflictingLiquidSampleWashBooleanOptions,
					conflictingOptions, liquidSampleWashBooleanConflictTest
				},
				{boolean, samplesWashes, washVolumes, prefix} = opsList;
				(* with autosampler primitives this will be possible, but I'm considering the options here to represent only the behavior at injection time *)

				(* conflicts with preInjectionSyringeWashes boolean *)
				{
					samplesWashConflicts,
					washVolumeConflicts
				} = Transpose@MapThread[
					Function[
						{washQ, samplesWash, washVolume},
						{
							(MatchQ[washQ, True] && MatchQ[samplesWash, Null]) || (MatchQ[washQ, False] && MatchQ[samplesWash, Except[Null | Automatic]]),
							(MatchQ[washQ, True] && MatchQ[washVolume, Null]) || (MatchQ[washQ, False] && MatchQ[washVolume, Except[Null | Automatic]])
						}
					],
					{boolean, samplesWashes, washVolumes}
				];

				(* figure out if we have a problem *)
				sampleWashBooleanConflicts = Or @@ Flatten[{samplesWashConflicts, washVolumeConflicts}];

				conflictingLiquidSampleWashBooleanOptions = MapThread[
					If[Or @@ #1, ToExpression@StringJoin[prefix, #2], Nothing]&,
					{
						{
							sampleWashBooleanConflicts,
							samplesWashConflicts,
							washVolumeConflicts
						},
						{
							"LiquidSampleWash",
							"NumberOfLiquidSampleWashes",
							"LiquidSampleWashVolume"
						}
					}
				];

				conflictingOptions = conflictingLiquidSampleWashBooleanOptions;

				(* if we have conflicts, throw an error *)
				If[sampleWashBooleanConflicts && !gatherTests,
					Message[Error::LiquidSampleWashOptionsConflict, Cases[conflictingLiquidSampleWashBooleanOptions, Except[ToExpression@StringJoin[prefix, "LiquidSampleWash"]]]]
				];

				(* gather relevant tests *)
				liquidSampleWashBooleanConflictTest = If[gatherTests,
					Test["LiquidSampleWash options are only specified if " <> prefix <> "LiquidSampleWash is True:",
						sampleWashBooleanConflicts,
						False
					],
					{}
				];

				(* format the output *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{liquidSampleWashBooleanConflictTest}]
				}
			]
		],
		{
			{resolvedLiquidSampleWashes, resolvedNumberOfLiquidSampleWashes, resolvedLiquidSampleWashVolumes, ""},
			{resolvedStandardLiquidSampleWashes, resolvedStandardNumberOfLiquidSampleWashes, resolvedStandardLiquidSampleWashVolumes, "Standard"},
			{resolvedBlankLiquidSampleWashes, resolvedBlankNumberOfLiquidSampleWashes, resolvedBlankLiquidSampleWashVolumes, "Blank"}
		}
	];

	(* split the resulting tuples to create error issues *)
	{sampleWashConflictOptions, sampleWashConflictTests} = {Flatten[sampleWashConflictTuples[[All, 1]]], Flatten[sampleWashConflictTuples[[All, 2]]]};


	(* Resolve filling strokes for samples and standards *)
	{
		{
			resolvedLiquidSampleFillingStrokes,
			resolvedLiquidSampleFillingStrokesVolumes,
			resolvedLiquidFillingStrokeDelays
		},
		{
			resolvedStandardLiquidSampleFillingStrokes,
			resolvedStandardLiquidSampleFillingStrokesVolumes,
			resolvedStandardLiquidFillingStrokeDelays
		},
		{
			resolvedBlankLiquidSampleFillingStrokes,
			resolvedBlankLiquidSampleFillingStrokesVolumes,
			resolvedBlankLiquidFillingStrokeDelays
		}
	} = Map[
		Function[{optionsList},
			Module[{liquidSampleFillingStrokes, liquidSampleFillingStrokesVolumes, sampleVolumesInternal, liquidFillingStrokeDelays, resolvedSampleFillingStrokes,
				resolvedSampleFillingStrokesVolumes, resolvedFillingStrokeDelays},
				{liquidSampleFillingStrokes, liquidSampleFillingStrokesVolumes, sampleVolumesInternal, liquidFillingStrokeDelays} = optionsList;
				(* === FUNCTION === *)
				(* LiquidSampleFillingStrokes *)
				resolvedSampleFillingStrokes = MapThread[
					Switch[
						{#1, #2},
						{Automatic, Except[Null]},
						3,
						{Automatic, Null},
						Null,
						{Except[Automatic], _},
						#
					]&,
					{liquidSampleFillingStrokes, liquidSampleFillingStrokesVolumes}
				];

				(*LiquidSampleFillingStrokesVolume*)
				resolvedSampleFillingStrokesVolumes = MapThread[
					Switch[
						{#1, #2},
						(* If there will be sample filling strokes, specify a default volume of the sample volume *)
						{Automatic, Except[0 | Null]},
						#3,
						(* Otherwise Null *)
						{Automatic, (0 | Null)},
						Null,
						(* If specified leave it alone *)
						{Except[Automatic], _},
						#1
					]&,
					{liquidSampleFillingStrokesVolumes, resolvedSampleFillingStrokes, sampleVolumesInternal}
				];

				(*LiquidFillingStrokeDelay*)
				resolvedFillingStrokeDelays = MapThread[
					Switch[
						{#1, #2},
						(* If there will be sample filling strokes, specify a default time of the sample volume *)
						{Automatic, Except[0 | Null]},
						0.5 * Second,
						(* Otherwise Null *)
						{Automatic, (0 | Null)},
						Null,
						(* If specified leave it alone *)
						{Except[Automatic], _},
						#1
					]&,
					{liquidFillingStrokeDelays, resolvedSampleFillingStrokes}
				];

				{resolvedSampleFillingStrokes, resolvedSampleFillingStrokesVolumes, resolvedFillingStrokeDelays}
				(* === FUNCTION === *)
			]
		],
		{
			{
				masterSwitchedLiquidSampleFillingStrokes,
				masterSwitchedLiquidSampleFillingStrokesVolumes,
				resolvedLiquidSampleVolumes,
				masterSwitchedLiquidFillingStrokeDelays
			},
			{
				masterSwitchedStandardLiquidSampleFillingStrokes,
				masterSwitchedStandardLiquidSampleFillingStrokesVolumes,
				resolvedStandardLiquidSampleVolumes,
				masterSwitchedStandardLiquidFillingStrokeDelays
			},
			{
				masterSwitchedBlankLiquidSampleFillingStrokes,
				masterSwitchedBlankLiquidSampleFillingStrokesVolumes,
				resolvedBlankLiquidSampleVolumes,
				masterSwitchedBlankLiquidFillingStrokeDelays
			}
		}
	];

	(* Liquid aspiration rate, delay, injection rate, and OverAspirationVolume *)
	{
		{resolvedLiquidSampleAspirationRates, resolvedLiquidSampleAspirationDelays, resolvedLiquidSampleInjectionRates, resolvedLiquidSampleOverAspirationVolumes},
		{resolvedStandardLiquidSampleAspirationRates, resolvedStandardLiquidSampleAspirationDelays, resolvedStandardLiquidSampleInjectionRates, resolvedStandardLiquidSampleOverAspirationVolumes},
		{resolvedBlankLiquidSampleAspirationRates, resolvedBlankLiquidSampleAspirationDelays, resolvedBlankLiquidSampleInjectionRates, resolvedBlankLiquidSampleOverAspirationVolumes}
	} = Map[
		Function[{optionsList},
			Module[{liquidSampleAspirationRates, liquidSampleAspirationDelays, liquidSampleInjectionRates, liquidSampleOverAspirationVolumes, resolvedSampleAspirationRatesInternal, resolvedSampleAspirationDelays, resolvedSampleInjectionRates, resolvedSampleOverAspirationVolumes},
				{liquidSampleAspirationRates, liquidSampleAspirationDelays, liquidSampleInjectionRates, liquidSampleOverAspirationVolumes} = optionsList;
				(* === FUNCTION === *)
				{resolvedSampleAspirationRatesInternal, resolvedSampleAspirationDelays, resolvedSampleInjectionRates, resolvedSampleOverAspirationVolumes} = MapThread[
					Map[
						Function[{specifiedParameter},
							Switch[
								specifiedParameter,
								Automatic,
								#2,
								Except[Automatic],
								specifiedParameter
							]
						],
						#1
					]&,
					{
						{liquidSampleAspirationRates, liquidSampleAspirationDelays, liquidSampleInjectionRates, liquidSampleOverAspirationVolumes},
						{maxLiquidSampleAspirationRate / 10.0, 2 * Second, maxLiquidInjectionRate / 2.0, 0.0 * Microliter}
					}
				]
				(* === FUNCTION === *)
			]
		],
		{
			{masterSwitchedLiquidSampleAspirationRates, masterSwitchedLiquidSampleAspirationDelays, masterSwitchedLiquidSampleInjectionRates, masterSwitchedLiquidSampleOverAspirationVolumes},
			{masterSwitchedStandardLiquidSampleAspirationRates, masterSwitchedStandardLiquidSampleAspirationDelays, masterSwitchedStandardLiquidSampleInjectionRates, masterSwitchedStandardLiquidSampleOverAspirationVolumes},
			{masterSwitchedBlankLiquidSampleAspirationRates, masterSwitchedBlankLiquidSampleAspirationDelays, masterSwitchedBlankLiquidSampleInjectionRates, masterSwitchedBlankLiquidSampleOverAspirationVolumes}
		}
	];

	(* Resolve the post injection syringe wash procedure for samples, standards, and blanks *)
	{
		{
			resolvedLiquidPostInjectionSyringeWashes,
			resolvedLiquidPostInjectionSyringeWashVolumes,
			resolvedLiquidPostInjectionSyringeWashRates,
			resolvedLiquidPostInjectionNumberOfSolventWashes,
			resolvedLiquidPostInjectionNumberOfSecondarySolventWashes,
			resolvedLiquidPostInjectionNumberOfTertiarySolventWashes,
			resolvedLiquidPostInjectionNumberOfQuaternarySolventWashes
		},
		{
			resolvedStandardLiquidPostInjectionSyringeWashes,
			resolvedStandardLiquidPostInjectionSyringeWashVolumes,
			resolvedStandardLiquidPostInjectionSyringeWashRates,
			resolvedStandardLiquidPostInjectionNumberOfSolventWashes,
			resolvedStandardLiquidPostInjectionNumberOfSecondarySolventWashes,
			resolvedStandardLiquidPostInjectionNumberOfTertiarySolventWashes,
			resolvedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes
		},
		{
			resolvedBlankLiquidPostInjectionSyringeWashes,
			resolvedBlankLiquidPostInjectionSyringeWashVolumes,
			resolvedBlankLiquidPostInjectionSyringeWashRates,
			resolvedBlankLiquidPostInjectionNumberOfSolventWashes,
			resolvedBlankLiquidPostInjectionNumberOfSecondarySolventWashes,
			resolvedBlankLiquidPostInjectionNumberOfTertiarySolventWashes,
			resolvedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes
		}
	} = Map[
		Function[{optionsList},
			Module[{liquidPostInjectionSyringeWashes, liquidPostInjectionSyringeWashVolumes, liquidPostInjectionSyringeWashRates, liquidPostInjectionNumberOfSolventWashes,
				liquidPostInjectionNumberOfSecondarySolventWashes, liquidPostInjectionNumberOfTertiarySolventWashes, liquidPostInjectionNumberOfQuaternarySolventWashes, liquidSampleVolumesInternal,
				resolvedWashBooleans, resolvedPostInjectionSyringeWashVolumes, resolvedPostInjectionSyringeWashRates, resolvedPostInjectionNumberOfSolventWashes,
				resolvedPostInjectionNumberOfSecondarySolventWashes, resolvedPostInjectionNumberOfTertiarySolventWashes, resolvedPostInjectionNumberOfQuaternarySolventWashes},
				{liquidPostInjectionSyringeWashes, liquidPostInjectionSyringeWashVolumes, liquidPostInjectionSyringeWashRates, liquidPostInjectionNumberOfSolventWashes,
					liquidPostInjectionNumberOfSecondarySolventWashes, liquidPostInjectionNumberOfTertiarySolventWashes, liquidPostInjectionNumberOfQuaternarySolventWashes,
					liquidSampleVolumesInternal} = optionsList;
				(* === FUNCTION === *)

				resolvedWashBooleans = MapThread[
					Function[{washBoolean, washVolume, washRate, solventWashes, secondarySolventWashes, tertiarySolventWashes, quaternarySolventWashes},
						Switch[
							{washBoolean, washVolume, washRate, solventWashes, secondarySolventWashes, tertiarySolventWashes, quaternarySolventWashes},
							(* If boolean is set, leave it *)
							{Except[Automatic], _, _, _, _, _, _},
							washBoolean,
							(* If boolean is Automatic and everything else is Automatic or Null, set it to false *)
							{Automatic, (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null)},
							False,
							(* If boolean is Automatic and and any washes, volume, or rate are specified, set this to true *)
							{Automatic, (Automatic | Null | _Quantity), (Automatic | Null | _Quantity), (Automatic | Null | _Integer), (Automatic | Null | _Integer), (Automatic | Null | _Integer), (Automatic | Null | _Integer)},
							True
						]
					],
					{
						liquidPostInjectionSyringeWashes,
						liquidPostInjectionSyringeWashVolumes,
						liquidPostInjectionSyringeWashRates,
						liquidPostInjectionNumberOfSolventWashes,
						liquidPostInjectionNumberOfSecondarySolventWashes,
						liquidPostInjectionNumberOfTertiarySolventWashes,
						liquidPostInjectionNumberOfQuaternarySolventWashes
					}
				];

				(* Resolve PostInjectionSyringeWash parameters *)

				(* LiquidPostInjectionSyringeWashVolume *)
				resolvedPostInjectionSyringeWashVolumes = MapThread[
					Switch[
						{#1, #2},
						(* If the parameter is specified, leave it alone *)
						{Except[Automatic], _},
						#1,
						(* If the parameter is Automatic and washBoolean is False, set it to Null *)
						{Automatic, False},
						Null,
						(* If the parameter is Automatic and the washBoolean is True, resolve to 1.2*resolvedLiquidSampleVolume *)
						{Automatic, True},
						Switch[
							#3,
							BlankNoVolume,
							0.25 * resolvedLiquidInjectionSyringeVolume,
							_,
							1.2 * #3
						]
					]&,
					{
						liquidPostInjectionSyringeWashVolumes,
						resolvedWashBooleans,
						liquidSampleVolumesInternal
					}
				];

				(* LiquidPostInjectionSyringeWashRate *)
				resolvedPostInjectionSyringeWashRates = MapThread[
					Switch[
						{#1, #2},
						(* If the parameter is specified, leave it alone *)
						{Except[Automatic], _},
						#1,
						(* If the parameter is Automatic and washBoolean is False, set it to Null *)
						{Automatic, False},
						Null,
						(* If the parameter is Automatic and the washBoolean is True, resolve to 5 uL/sec *)
						{Automatic, True},
						5 * Microliter / Second
					]&,
					{
						liquidPostInjectionSyringeWashRates,
						resolvedWashBooleans
					}
				];

				(* LiquidPostInjectionNumberOfSolventWashes *)

				(* Use the solvent specified booleans to resolve whether the syringe should be washed with any of the solvents *)
				{resolvedPostInjectionNumberOfSolventWashes, resolvedPostInjectionNumberOfSecondarySolventWashes, resolvedPostInjectionNumberOfTertiarySolventWashes, resolvedPostInjectionNumberOfQuaternarySolventWashes} = MapThread[
					MapThread[
						Function[{specifiedWashes, washBoolean},
							Switch[
								specifiedWashes,
								(* If the number of washes has already been specified, leave it as is. *)
								Except[Automatic],
								specifiedWashes,
								(* If the specified # of washes is Automatic and the washBoolean is True, resolve the number of washes to 3 *)
								Automatic,
								If[#2 && washBoolean,
									3,
									Null
								]
							]
						],
						{#1, resolvedWashBooleans}
					]&,
					{
						{liquidPostInjectionNumberOfSolventWashes, liquidPostInjectionNumberOfSecondarySolventWashes, liquidPostInjectionNumberOfTertiarySolventWashes, liquidPostInjectionNumberOfQuaternarySolventWashes},
						{syringeWashSolventSpecifiedQ, secondarySyringeWashSolventSpecifiedQ, tertiarySyringeWashSolventSpecifiedQ, quaternarySyringeWashSolventSpecifiedQ}
					}
				];

				{
					resolvedWashBooleans,
					resolvedPostInjectionSyringeWashVolumes,
					resolvedPostInjectionSyringeWashRates,
					resolvedPostInjectionNumberOfSolventWashes,
					resolvedPostInjectionNumberOfSecondarySolventWashes,
					resolvedPostInjectionNumberOfTertiarySolventWashes,
					resolvedPostInjectionNumberOfQuaternarySolventWashes
				}
				(* === FUNCTION === *)
			]
		],
		{
			{
				masterSwitchedLiquidPostInjectionSyringeWashes,
				masterSwitchedLiquidPostInjectionSyringeWashVolumes,
				masterSwitchedLiquidPostInjectionSyringeWashRates,
				masterSwitchedLiquidPostInjectionNumberOfSolventWashes,
				masterSwitchedLiquidPostInjectionNumberOfSecondarySolventWashes,
				masterSwitchedLiquidPostInjectionNumberOfTertiarySolventWashes,
				masterSwitchedLiquidPostInjectionNumberOfQuaternarySolventWashes,
				resolvedLiquidSampleVolumes
			},
			{
				masterSwitchedStandardLiquidPostInjectionSyringeWashes,
				masterSwitchedStandardLiquidPostInjectionSyringeWashVolumes,
				masterSwitchedStandardLiquidPostInjectionSyringeWashRates,
				masterSwitchedStandardLiquidPostInjectionNumberOfSolventWashes,
				masterSwitchedStandardLiquidPostInjectionNumberOfSecondarySolventWashes,
				masterSwitchedStandardLiquidPostInjectionNumberOfTertiarySolventWashes,
				masterSwitchedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
				resolvedStandardLiquidSampleVolumes
			},
			{
				masterSwitchedBlankLiquidPostInjectionSyringeWashes,
				masterSwitchedBlankLiquidPostInjectionSyringeWashVolumes,
				masterSwitchedBlankLiquidPostInjectionSyringeWashRates,
				masterSwitchedBlankLiquidPostInjectionNumberOfSolventWashes,
				masterSwitchedBlankLiquidPostInjectionNumberOfSecondarySolventWashes,
				masterSwitchedBlankLiquidPostInjectionNumberOfTertiarySolventWashes,
				masterSwitchedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes,
				resolvedBlankLiquidSampleVolumes
			}
		}
	];

	(* error check all the post-injection syringe wash options for internal conflicts *)
	postInjectionSyringeWashesConflictTuples = Map[
		Function[opsList,
			Module[
				{
					boolean, syringeWashVolumes, syringeWashRates, numberOfSolventWashes, numberOfSecondarySolventWashes, numberOfTertiarySolventWashes, numberOfQuaternarySolventWashes, prefix,
					conflictingOptions, conflictingPostInjectionSyringeWashesBooleanOptions, syringeWashVolumeConflicts, syringeWashRateConflicts, numberOfSolventWashConflicts,
					numberOfSecondarySolventWashConflicts, numberOfTertiarySolventWashConflicts, numberOfQuaternarySolventWashConflicts, postInjectionSyringeWashBooleanConflicts,
					postInjectionSyringeWashBooleanConflictTest
				},
				{boolean, syringeWashVolumes, syringeWashRates, numberOfSolventWashes, numberOfSecondarySolventWashes, numberOfTertiarySolventWashes, numberOfQuaternarySolventWashes, prefix} = opsList;
				(* with autosampler primitives this will be possible, but I'm considering the options here to represent only the behavior at injection time *)

				(* conflicts with postInjectionSyringeWashes boolean *)
				{
					syringeWashVolumeConflicts,
					syringeWashRateConflicts,
					numberOfSolventWashConflicts,
					numberOfSecondarySolventWashConflicts,
					numberOfTertiarySolventWashConflicts,
					numberOfQuaternarySolventWashConflicts
				} = Transpose@MapThread[
					Function[
						{postInjectionSyringeWashesQ, syringeWashVolume, syringeWashRate, solventWashes, secondarySolventWashes, tertiarySolventWashes, quaternarySolventWashes},
						{
							(MatchQ[postInjectionSyringeWashesQ, True] && MatchQ[syringeWashVolume, Null]) || (MatchQ[postInjectionSyringeWashesQ, False] && MatchQ[syringeWashVolume, Except[Null | Automatic]]),
							(MatchQ[postInjectionSyringeWashesQ, True] && MatchQ[syringeWashRate, Null]) || (MatchQ[postInjectionSyringeWashesQ, False] && MatchQ[syringeWashRate, Except[Null | Automatic]]),
							(MatchQ[postInjectionSyringeWashesQ, True] && MatchQ[solventWashes, Null]) || (MatchQ[postInjectionSyringeWashesQ, False] && MatchQ[solventWashes, Except[Null | Automatic]]),
							(MatchQ[postInjectionSyringeWashesQ, True] && MatchQ[secondarySolventWashes, Null]) || (MatchQ[postInjectionSyringeWashesQ, False] && MatchQ[secondarySolventWashes, Except[Null | Automatic]]),
							(MatchQ[postInjectionSyringeWashesQ, True] && MatchQ[tertiarySolventWashes, Null]) || (MatchQ[postInjectionSyringeWashesQ, False] && MatchQ[tertiarySolventWashes, Except[Null | Automatic]]),
							(MatchQ[postInjectionSyringeWashesQ, True] && MatchQ[quaternarySolventWashes, Null]) || (MatchQ[postInjectionSyringeWashesQ, False] && MatchQ[quaternarySolventWashes, Except[Null | Automatic]])
						}
					],
					{boolean, syringeWashVolumes, syringeWashRates, numberOfSolventWashes, numberOfSecondarySolventWashes, numberOfTertiarySolventWashes, numberOfQuaternarySolventWashes}
				];

				(* figure out if we have a problem *)
				postInjectionSyringeWashBooleanConflicts = Or @@ Flatten[{syringeWashVolumeConflicts, syringeWashRateConflicts, numberOfSolventWashConflicts,
					numberOfSecondarySolventWashConflicts, numberOfTertiarySolventWashConflicts, numberOfQuaternarySolventWashConflicts}];

				conflictingPostInjectionSyringeWashesBooleanOptions = MapThread[
					If[Or @@ #1, ToExpression@StringJoin[prefix, #2], Nothing]&,
					{
						{
							postInjectionSyringeWashBooleanConflicts,
							syringeWashVolumeConflicts,
							syringeWashRateConflicts,
							numberOfSolventWashConflicts,
							numberOfSecondarySolventWashConflicts,
							numberOfTertiarySolventWashConflicts,
							numberOfQuaternarySolventWashConflicts
						},
						{
							"LiquidPostInjectionSyringeWash",
							"LiquidPostInjectionSyringeWashVolume",
							"LiquidPostInjectionSyringeWashRate",
							"LiquidPostInjectionNumberOfSolventWashes",
							"LiquidPostInjectionNumberOfSecondarySolventWashes",
							"LiquidPostInjectionNumberOfTertiarySolventWashes",
							"LiquidPostInjectionNumberOfQuaternarySolventWashes"
						}
					}
				];

				conflictingOptions = conflictingPostInjectionSyringeWashesBooleanOptions;

				(* if we have conflicts, throw an error *)
				If[postInjectionSyringeWashBooleanConflicts && !gatherTests,
					Message[Error::PostInjectionSyringeWashOptionsConflict, Cases[conflictingPostInjectionSyringeWashesBooleanOptions, Except[ToExpression@StringJoin[prefix, "LiquidPostInjectionSyringeWash"]]]]
				];

				(* gather relevant tests *)
				postInjectionSyringeWashBooleanConflictTest = If[gatherTests,
					Test["LiquidPostInjectionSyringeWash options are only specified if " <> prefix <> "LiquidPostInjectionSyringeWash is True:",
						postInjectionSyringeWashBooleanConflicts,
						False
					],
					{}
				];

				(* format the output *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{postInjectionSyringeWashBooleanConflictTest}]
				}
			]
		],
		{
			{resolvedLiquidPostInjectionSyringeWashes, specifiedLiquidPostInjectionSyringeWashVolumes, specifiedLiquidPostInjectionSyringeWashRates, specifiedLiquidPostInjectionNumberOfSolventWashes, specifiedLiquidPostInjectionNumberOfSecondarySolventWashes, specifiedLiquidPostInjectionNumberOfTertiarySolventWashes, specifiedLiquidPostInjectionNumberOfQuaternarySolventWashes, ""},
			{resolvedStandardLiquidPostInjectionSyringeWashes, specifiedStandardLiquidPostInjectionSyringeWashVolumes, specifiedStandardLiquidPostInjectionSyringeWashRates, specifiedStandardLiquidPostInjectionNumberOfSolventWashes, specifiedStandardLiquidPostInjectionNumberOfSecondarySolventWashes, specifiedStandardLiquidPostInjectionNumberOfTertiarySolventWashes, specifiedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes, "Standard"},
			{resolvedBlankLiquidPostInjectionSyringeWashes, specifiedBlankLiquidPostInjectionSyringeWashVolumes, specifiedBlankLiquidPostInjectionSyringeWashRates, specifiedBlankLiquidPostInjectionNumberOfSolventWashes, specifiedBlankLiquidPostInjectionNumberOfSecondarySolventWashes, specifiedBlankLiquidPostInjectionNumberOfTertiarySolventWashes, specifiedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes, "Blank"}
		}
	];

	(* split the resulting tuples to create error issues *)
	{postInjectionSyringeWashesConflictOptions, postInjectionSyringeWashesConflictTests} = {Flatten[postInjectionSyringeWashesConflictTuples[[All, 1]]], Flatten[postInjectionSyringeWashesConflictTuples[[All, 2]]]};


	(* resolve the wash solvents *)
	(* Right now we're going to check to see if they are specified. If not specified but the resolved number of washes with that solvent is true, specify the model for Hexane *)
	{specifiedSyringeWashSolvent, specifiedSecondarySyringeWashSolvent, specifiedTertiarySyringeWashSolvent, specifiedQuaternarySyringeWashSolvent} = Lookup[roundedGasChromatographyOptions, {SyringeWashSolvent, SecondarySyringeWashSolvent, TertiarySyringeWashSolvent, QuaternarySyringeWashSolvent}];

	{resolvedSyringeWashSolvent, resolvedSecondarySyringeWashSolvent, resolvedTertiarySyringeWashSolvent, resolvedQuaternarySyringeWashSolvent} = MapThread[
		Switch[
			#1,
			(* If one is already specified, leave it *)
			Except[Automatic],
			#1,
			(* If Automatic, and a numberOfSolventWashes is specified, resolve to Hexane and throw a warning *)
			Automatic,
			If[!gatherTests,
				If[MemberQ[#2, _Integer],
					Message[Warning::AutomaticallySelectedWashSolvent, #3];
					Model[Sample, "Hexanes"],
					Null
				],
				If[MemberQ[#2, _Integer],
					Model[Sample, "Hexanes"],
					Null
				]
			]
		]&,
		{
			{
				specifiedSyringeWashSolvent,
				specifiedSecondarySyringeWashSolvent,
				specifiedTertiarySyringeWashSolvent,
				specifiedQuaternarySyringeWashSolvent
			},
			{
				Join[resolvedLiquidPreInjectionNumberOfSolventWashes, resolvedStandardLiquidPreInjectionNumberOfSolventWashes, resolvedBlankLiquidPreInjectionNumberOfSolventWashes, resolvedLiquidPostInjectionNumberOfSolventWashes, resolvedStandardLiquidPostInjectionNumberOfSolventWashes, resolvedBlankLiquidPostInjectionNumberOfSolventWashes],
				Join[resolvedLiquidPreInjectionNumberOfSecondarySolventWashes, resolvedStandardLiquidPreInjectionNumberOfSecondarySolventWashes, resolvedBlankLiquidPreInjectionNumberOfSecondarySolventWashes, resolvedLiquidPostInjectionNumberOfSecondarySolventWashes, resolvedStandardLiquidPostInjectionNumberOfSecondarySolventWashes, resolvedBlankLiquidPostInjectionNumberOfSecondarySolventWashes],
				Join[resolvedLiquidPreInjectionNumberOfTertiarySolventWashes, resolvedStandardLiquidPreInjectionNumberOfTertiarySolventWashes, resolvedBlankLiquidPreInjectionNumberOfTertiarySolventWashes, resolvedLiquidPostInjectionNumberOfTertiarySolventWashes, resolvedStandardLiquidPostInjectionNumberOfTertiarySolventWashes, resolvedBlankLiquidPostInjectionNumberOfTertiarySolventWashes],
				Join[resolvedLiquidPreInjectionNumberOfQuaternarySolventWashes, resolvedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes, resolvedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes, resolvedLiquidPostInjectionNumberOfQuaternarySolventWashes, resolvedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes, resolvedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes]
			},
			{"", "Secondary", "Tertiary", "Quaternary"}
		}
	];

	(* Resolve the nefarious WaitForSystemReady *)
	{
		resolvedPostInjectionNextSamplePreparationSteps,
		resolvedStandardPostInjectionNextSamplePreparationSteps,
		resolvedBlankPostInjectionNextSamplePreparationSteps
	} = Map[
		Function[{optionsList},
			Module[{postInjectionNextSamplePreparationSteps},
				postInjectionNextSamplePreparationSteps = optionsList;
				Map[
					Switch[
						#,
						Except[Automatic],
						#,
						Automatic,
						NoSteps
					]&,
					postInjectionNextSamplePreparationSteps
				]
			]
		],
		{
			masterSwitchedPostInjectionNextSamplePreparationSteps,
			masterSwitchedStandardPostInjectionNextSamplePreparationSteps,
			masterSwitchedBlankPostInjectionNextSamplePreparationSteps
		}
	];

	(* Resolve Headspace Sampling Options *)
	{
		{
			resolvedHeadspaceSyringeTemperatures,
			resolvedHeadspaceSampleVolumes,
			resolvedHeadspaceSampleAspirationRates,
			resolvedHeadspaceSampleAspirationDelays,
			resolvedHeadspaceSampleInjectionRates,
			resolvedHeadspaceAgitateWhileSamplings
		},
		{
			resolvedStandardHeadspaceSyringeTemperatures,
			resolvedStandardHeadspaceSampleVolumes,
			resolvedStandardHeadspaceSampleAspirationRates,
			resolvedStandardHeadspaceSampleAspirationDelays,
			resolvedStandardHeadspaceSampleInjectionRates,
			resolvedStandardHeadspaceAgitateWhileSamplings
		},
		{
			resolvedBlankHeadspaceSyringeTemperatures,
			resolvedBlankHeadspaceSampleVolumes,
			resolvedBlankHeadspaceSampleAspirationRates,
			resolvedBlankHeadspaceSampleAspirationDelays,
			resolvedBlankHeadspaceSampleInjectionRates,
			resolvedBlankHeadspaceAgitateWhileSamplings
		}
	} = Map[
		Function[{optionsList},
			Module[
				{
					headspaceSyringeTemperatures, headspaceSampleVolumes, headspaceSampleAspirationRates, headspaceSampleAspirationDelays, headspaceSampleInjectionRates,
					headspaceAgitateWhileSamplings, resolvedSyringeTemperatures, resolvedSampleVolumes, resolvedSampleAspirationRates, resolvedSampleAspirationDelays,
					resolvedSampleInjectionRates, resolvedAgitateWhileSamplings
				},
				{
					headspaceSyringeTemperatures, headspaceSampleVolumes, headspaceSampleAspirationRates,
					headspaceSampleAspirationDelays, headspaceSampleInjectionRates, headspaceAgitateWhileSamplings
				} = optionsList;
				(* === FUNCTION === *)

				(* Resolve all of these guys to their default values if they are Automatic, none are interrelated. *)
				{resolvedSyringeTemperatures, resolvedSampleVolumes, resolvedSampleAspirationRates,
					resolvedSampleAspirationDelays, resolvedSampleInjectionRates, resolvedAgitateWhileSamplings} = MapThread[
					Map[
						Function[{specifiedParameter},
							Switch[
								specifiedParameter,
								Except[Automatic],
								specifiedParameter,
								Automatic,
								#2
							]
						],
						#1
					]&,
					{
						{
							headspaceSyringeTemperatures,
							headspaceSampleVolumes,
							headspaceSampleAspirationRates,
							headspaceSampleAspirationDelays,
							headspaceSampleInjectionRates,
							headspaceAgitateWhileSamplings
						},
						{
							Ambient,
							1500 * Microliter,
							12 * Milliliter / Minute,
							2 * Second,
							10 * Milliliter / Minute,
							True
						}
					}
				]
				(* === FUNCTION === *)
			]
		],
		{
			{
				masterSwitchedHeadspaceSyringeTemperatures,
				masterSwitchedHeadspaceSampleVolumes,
				masterSwitchedHeadspaceSampleAspirationRates,
				masterSwitchedHeadspaceSampleAspirationDelays,
				masterSwitchedHeadspaceSampleInjectionRates,
				masterSwitchedHeadspaceAgitateWhileSamplings
			},
			{
				masterSwitchedStandardHeadspaceSyringeTemperatures,
				masterSwitchedStandardHeadspaceSampleVolumes,
				masterSwitchedStandardHeadspaceSampleAspirationRates,
				masterSwitchedStandardHeadspaceSampleAspirationDelays,
				masterSwitchedStandardHeadspaceSampleInjectionRates,
				masterSwitchedStandardHeadspaceAgitateWhileSamplings
			},
			{
				masterSwitchedBlankHeadspaceSyringeTemperatures,
				masterSwitchedBlankHeadspaceSampleVolumes,
				masterSwitchedBlankHeadspaceSampleAspirationRates,
				masterSwitchedBlankHeadspaceSampleAspirationDelays,
				masterSwitchedBlankHeadspaceSampleInjectionRates,
				masterSwitchedBlankHeadspaceAgitateWhileSamplings
			}
		}
	];

	(* require that all agitate while sampling booleans must be true for headspace samples *)
	headspaceAgitateWhileSamplingTuples = Map[
		Function[{vars},
			Module[{headspaceAgitateWhileSamplings, samplingMethods, agitateWhileSamplingConflict, headspaceAgitateWhileSamplingConflicts, prefix, conflictingOptions, conflictTests,
				agitateBooleans, headspaceAgitateConflicts, agitateConflict},
				(* get inputs *)
				{headspaceAgitateWhileSamplings, agitateBooleans, samplingMethods, prefix} = vars;

				(* if there are conflicts in the headspace agitate while samplings, figure it out *)
				headspaceAgitateWhileSamplingConflicts = MapThread[
					Function[{agitateWhileSampling, samplingMethod},
						MatchQ[samplingMethod, HeadspaceInjection] && !TrueQ[agitateWhileSampling]
					],
					{headspaceAgitateWhileSamplings, samplingMethods}
				];

				(* if there are conflicts in the headspace agitates, figure it out *)
				headspaceAgitateConflicts = MapThread[
					Function[{agitate, samplingMethod},
						MatchQ[samplingMethod, HeadspaceInjection] && !TrueQ[agitate]
					],
					{agitateBooleans, samplingMethods}
				];

				(* if we have a problem, determine *)
				{agitateWhileSamplingConflict, agitateConflict} = {Or @@ headspaceAgitateWhileSamplingConflicts, Or @@ headspaceAgitateConflicts};

				(* figure out the options we need to report *)
				conflictingOptions = If[agitateWhileSamplingConflict || agitateConflict,
					MapThread[
						If[TrueQ[#1],
							StringJoin[prefix, #2],
							Nothing
						]&,
						{
							{
								agitateWhileSamplingConflict,
								agitateConflict
							},
							{
								"AgitateWhileSampling",
								"Agitate"
							}
						}
					],
					{}
				];

				(* throw errors *)
				If[!gatherTests,
					If[agitateWhileSamplingConflict,
						Message[Error::HeadspaceAgitateWhileSampling, prefix],
						Nothing
					];
					If[agitateConflict,
						Message[Error::HeadspaceWithoutAgitation, prefix],
						Nothing
					],
					Nothing
				];

				(* make relevant tests *)
				conflictTests = If[gatherTests,
					{
						Test["If the " <> prefix <> "SamplingMethod for a given sample is HeadspaceInjection, " <> prefix <> "AgitateWhileSampling is set to True:",
							agitateWhileSamplingConflict,
							False
						],
						Test["If the " <> prefix <> "SamplingMethod for a given sample is HeadspaceInjection, " <> prefix <> "Agitate is set to True:",
							agitateConflict,
							False
						]
					},
					{}
				];

				(* return results *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{conflictTests}]
				}
			]
		],
		{
			{resolvedHeadspaceAgitateWhileSamplings, resolvedAgitates, resolvedSamplingMethods, ""},
			{resolvedStandardHeadspaceAgitateWhileSamplings, resolvedStandardAgitates, resolvedStandardSamplingMethods, "Standard"},
			{resolvedBlankHeadspaceAgitateWhileSamplings, resolvedBlankAgitates, resolvedBlankSamplingMethods, "Blank"}
		}
	];

	(* part slice the options and tests *)
	{headspaceAgitationConflictOptions, headspaceAgitationConflictTests} = {headspaceAgitateWhileSamplingTuples[[All, 1]], headspaceAgitateWhileSamplingTuples[[All, 2]]};



	(* check our inputs to make sure that we haven't exceeded the maximum allowed aspiration or injection speeds *)
	{
		sampleAspirationRatesOutOfBoundsQ,
		standardAspirationRatesOutOfBoundsQ,
		blankAspirationRatesOutOfBoundsQ,
		headspaceSampleAspirationRatesOutOfBoundsQ,
		headspaceStandardAspirationRatesOutOfBoundsQ,
		headspaceBlankAspirationRatesOutOfBoundsQ
	} = MapThread[
		Function[{aspirationRateList, lowerLimit, upperLimit},
			Map[
				Function[
					aspirationRate,
					If[!NullQ[aspirationRate],
						(* Original author did strictly greater than.. I changed this to or equal to without testing on the instrument *)
						Or[aspirationRate <= lowerLimit, aspirationRate >= upperLimit],
						False
					]
				],
				aspirationRateList
			]
		],
		{
			{
				resolvedLiquidSampleAspirationRates,
				resolvedStandardLiquidSampleAspirationRates,
				resolvedBlankLiquidSampleAspirationRates,
				resolvedHeadspaceSampleAspirationRates,
				resolvedStandardHeadspaceSampleAspirationRates,
				resolvedBlankHeadspaceSampleAspirationRates
			},
			Flatten@{
				ConstantArray[0.01 Microliter / Second, 3],
				ConstantArray[1 Milliliter / Minute, 3]
			},
			Flatten@{
				ConstantArray[maxLiquidSampleAspirationRate, 3],
				ConstantArray[100 Milliliter / Minute, 3]
			}
		}
	];

	{
		sampleInjectionRatesOutOfBoundsQ,
		standardInjectionRatesOutOfBoundsQ,
		blankInjectionRatesOutOfBoundsQ,
		headspaceSampleInjectionRatesOutOfBoundsQ,
		headspaceStandardInjectionRatesOutOfBoundsQ,
		headspaceBlankInjectionRatesOutOfBoundsQ
	} = MapThread[
		Function[{aspirationRateList, lowerLimit, upperLimit},
			Map[
				Function[
					aspirationRate,
					If[!NullQ[aspirationRate],
						Or[aspirationRate <= lowerLimit, aspirationRate >= upperLimit],
						False
					]
				],
				aspirationRateList
			]
		],
		{
			{
				resolvedLiquidSampleInjectionRates,
				resolvedStandardLiquidSampleInjectionRates,
				resolvedBlankLiquidSampleInjectionRates,
				resolvedHeadspaceSampleInjectionRates,
				resolvedStandardHeadspaceSampleInjectionRates,
				resolvedBlankHeadspaceSampleInjectionRates
			},
			Flatten@{
				ConstantArray[1 Microliter / Second, 3],
				ConstantArray[1 * Milliliter / Minute, 3]
			},
			Flatten@{
				ConstantArray[maxLiquidInjectionRate, 3],
				ConstantArray[100 * Milliliter / Minute, 3]
			}
		}
	];

	(* if there were any failures, we should throw an error if we're not gathering tests *)
	optionValueOutOfBoundsOptions = If[!gatherTests,
		MapThread[
			Function[
				{boolList, optionName, minRate, maxRate, samplingMethod},
				If[And @@ boolList,
					Message[Error::OptionValueOutOfBounds, resolvedLiquidInjectionSyringeVolume, optionName, minRate, maxRate, samplingMethod];
					{optionName},
					Nothing
				]
			],
			{
				{
					sampleAspirationRatesOutOfBoundsQ,
					standardAspirationRatesOutOfBoundsQ,
					blankAspirationRatesOutOfBoundsQ,
					sampleInjectionRatesOutOfBoundsQ,
					standardInjectionRatesOutOfBoundsQ,
					blankInjectionRatesOutOfBoundsQ,
					headspaceSampleAspirationRatesOutOfBoundsQ,
					headspaceStandardAspirationRatesOutOfBoundsQ,
					headspaceBlankAspirationRatesOutOfBoundsQ,
					headspaceSampleInjectionRatesOutOfBoundsQ,
					headspaceStandardInjectionRatesOutOfBoundsQ,
					headspaceBlankInjectionRatesOutOfBoundsQ
				},
				{
					SampleAspirationRate,
					StandardSampleAspirationRate,
					BlankSampleAspirationRate,
					SampleInjectionRate,
					StandardSampleInjectionRate,
					BlankSampleInjectionRate,
					SampleAspirationRate,
					StandardSampleAspirationRate,
					BlankSampleAspirationRate,
					SampleInjectionRate,
					StandardSampleInjectionRate,
					BlankSampleInjectionRate
				},
				Flatten[
					{
						ConstantArray[0.01 Microliter / Second, 3],
						ConstantArray[1 Microliter / Second, 3],
						ConstantArray[1 Milliliter / Minute, 6]
					}
				],
				Flatten[
					{
						ConstantArray[maxLiquidSampleAspirationRate, 3],
						ConstantArray[maxLiquidInjectionRate, 3],
						ConstantArray[100 Milliliter / Minute, 6]
					}
				],
				Flatten[
					{
						ConstantArray[LiquidInjection, 6],
						ConstantArray[HeadspaceInjection, 6]
					}
				]
			}
		],
		Nothing
	];

	(* otherwise create some tests *)
	{
		sampleAspirationRatesOutOfBoundsTest,
		standardAspirationRatesOutOfBoundsTest,
		blankAspirationRatesOutOfBoundsTest,
		sampleInjectionRatesOutOfBoundsTest,
		standardInjectionRatesOutOfBoundsTest,
		blankInjectionRatesOutOfBoundsTest,
		headspaceSampleAspirationRatesOutOfBoundsTest,
		headspaceStandardAspirationRatesOutOfBoundsTest,
		headspaceBlankAspirationRatesOutOfBoundsTest,
		headspaceSampleInjectionRatesOutOfBoundsTest,
		headspaceStandardInjectionRatesOutOfBoundsTest,
		headspaceBlankInjectionRatesOutOfBoundsTest
	} = If[gatherTests,
		MapThread[
			Function[
				{boolList, optionName, minRate, maxRate},
				Test["The specified values for " <> ToString[optionName] <> " are within the (inclusive) range " <> ToString[minRate] <> " - " <> ToString[maxRate] <> " set by the instrument:",
					And @@ boolList,
					False
				]
			],
			{
				{
					sampleAspirationRatesOutOfBoundsQ,
					standardAspirationRatesOutOfBoundsQ,
					blankAspirationRatesOutOfBoundsQ,
					sampleInjectionRatesOutOfBoundsQ,
					standardInjectionRatesOutOfBoundsQ,
					blankInjectionRatesOutOfBoundsQ,
					headspaceSampleAspirationRatesOutOfBoundsQ,
					headspaceStandardAspirationRatesOutOfBoundsQ,
					headspaceBlankAspirationRatesOutOfBoundsQ,
					headspaceSampleInjectionRatesOutOfBoundsQ,
					headspaceStandardInjectionRatesOutOfBoundsQ,
					headspaceBlankInjectionRatesOutOfBoundsQ
				},
				{
					SampleAspirationRate,
					StandardSampleAspirationRate,
					BlankSampleAspirationRate,
					SampleInjectionRate,
					StandardSampleInjectionRate,
					BlankSampleInjectionRate,
					SampleAspirationRate,
					StandardSampleAspirationRate,
					BlankSampleAspirationRate,
					SampleInjectionRate,
					StandardSampleInjectionRate,
					BlankSampleInjectionRate
				},
				Flatten[{
					ConstantArray[0.01 Microliter/Second, 3],
					ConstantArray[1 Microliter/Second, 3],
					ConstantArray[1 Milliliter / Minute, 6]
				}],
				Flatten[{
					ConstantArray[maxLiquidSampleAspirationRate, 3],
					ConstantArray[maxLiquidInjectionRate, 3],
					ConstantArray[100 Milliliter / Minute, 6]
				}]
			}
		],
		ConstantArray[{}, 12]
	];

	(* Resolve syringe flushing *)
	{
		{
			resolvedHeadspacePreInjectionFlushTimes,
			resolvedHeadspacePostInjectionFlushTimes,
			resolvedHeadspaceSyringeFlushings
		},
		{
			resolvedStandardHeadspacePreInjectionFlushTimes,
			resolvedStandardHeadspacePostInjectionFlushTimes,
			resolvedStandardHeadspaceSyringeFlushings
		},
		{
			resolvedBlankHeadspacePreInjectionFlushTimes,
			resolvedBlankHeadspacePostInjectionFlushTimes,
			resolvedBlankHeadspaceSyringeFlushings
		}
	} = Map[
		Function[{optionsList},
			Module[{headspacePreInjectionFlushTimes, headspacePostInjectionFlushTimes, headspaceSyringeFlushings, resolvedPreInjectionFlushTimes, resolvedPostInjectionFlushTimes, resolvedContinuousFlushings},
				{headspacePreInjectionFlushTimes, headspacePostInjectionFlushTimes, headspaceSyringeFlushings} = optionsList;
				(* === FUNCTION === *)

				(* Resolve all of these guys to their default values if they are Automatic, none are interrelated. *)
				{resolvedPreInjectionFlushTimes, resolvedPostInjectionFlushTimes, resolvedContinuousFlushings} = Transpose@MapThread[
					Function[{preInjectionFlushTimes, postInjectionFlushTimes, syringeFlushings},
						Which[
							MatchQ[syringeFlushings, Null],
							{Null, Null, Null},
							MatchQ[syringeFlushings, Automatic],
							Switch[
								{preInjectionFlushTimes, postInjectionFlushTimes},
								{Automatic, Automatic},
								{3 * Second, Null, {BeforeSampleAspiration}},
								{Except[Automatic], Except[Automatic]},
								{preInjectionFlushTimes, postInjectionFlushTimes, {If[NullQ[preInjectionFlushTimes], Nothing, BeforeSampleAspiration], If[NullQ[prostInjectionFlushTimes], Nothing, AfterSampleInjection]}},
								{Except[Automatic], Automatic},
								{preInjectionFlushTimes, Null, {If[NullQ[preInjectionFlushTimes], Nothing, BeforeSampleAspiration]}},
								{Automatic, Except[Automatic]},
								{3 * Second, postInjectionFlushTimes, {BeforeSampleAspiration, If[NullQ[prostInjectionFlushTimes], Nothing, AfterSampleInjection]}}
							],
							MatchQ[syringeFlushings, Continuous],
							{
								preInjectionFlushTimes /. {Automatic -> Null},
								postInjectionFlushTimes /. {Automatic -> Null},
								syringeFlushings
							},
							SubsetQ[syringeFlushings, {BeforeSampleAspiration, AfterSampleInjection}],
							{
								preInjectionFlushTimes /. {Automatic -> 3 * Second},
								postInjectionFlushTimes /. {Automatic -> 3 * Second},
								syringeFlushings
							},
							SubsetQ[syringeFlushings, {BeforeSampleAspiration}],
							{
								preInjectionFlushTimes /. {Automatic -> 3 * Second},
								postInjectionFlushTimes /. {Automatic -> Null},
								syringeFlushings
							},
							SubsetQ[syringeFlushings, {AfterSampleInjection}],
							{
								preInjectionFlushTimes /. {Automatic -> Null},
								postInjectionFlushTimes /. {Automatic -> 3 * Second},
								syringeFlushings
							}
						]
					],
					{headspacePreInjectionFlushTimes, headspacePostInjectionFlushTimes, headspaceSyringeFlushings}
				]
				(* === FUNCTION === *)
			]
		],
		{
			{
				masterSwitchedHeadspacePreInjectionFlushTimes,
				masterSwitchedHeadspacePostInjectionFlushTimes,
				masterSwitchedHeadspaceSyringeFlushings
			},
			{
				masterSwitchedStandardHeadspacePreInjectionFlushTimes,
				masterSwitchedStandardHeadspacePostInjectionFlushTimes,
				masterSwitchedStandardHeadspaceSyringeFlushings
			},
			{
				masterSwitchedBlankHeadspacePreInjectionFlushTimes,
				masterSwitchedBlankHeadspacePostInjectionFlushTimes,
				masterSwitchedBlankHeadspaceSyringeFlushings
			}
		}
	];

	(* error check all the post-injection syringe wash options for internal conflicts *)
	headspaceFlushingConflictTuples = Map[
		Function[opsList,
			Module[
				{
					flushingTypes, preInjectionFlushTimes, postInjectionFlushTimes, preInjectionFlushTimeConflicts, postInjectionFlushTimeConflicts,
					flushingTypeConflicts, prefix, conflictingFlushingTypeOptions, conflictingOptions, flushingTypeConflictTest, errorOps
				},
				{flushingTypes, preInjectionFlushTimes, postInjectionFlushTimes, prefix} = opsList;

				(* conflicts with postInjectionSyringeWashes boolean *)
				{
					preInjectionFlushTimeConflicts,
					postInjectionFlushTimeConflicts
				} = Transpose@MapThread[
					Function[
						{flushingType, preInjectionFlushTime, postInjectionFlushTime},
						{
							((MatchQ[flushingType, Continuous] || !MemberQ[flushingType, BeforeSampleAspiration]) && MatchQ[preInjectionFlushTime, Except[Null | Automatic]]) || (MemberQ[flushingType, BeforeSampleAspiration] && MatchQ[preInjectionFlushTime, Null]),
							((MatchQ[flushingType, Continuous] || !MemberQ[flushingType, AfterSampleInjection]) && MatchQ[postInjectionFlushTime, Except[Null | Automatic]]) || (MemberQ[flushingType, AfterSampleInjection] && MatchQ[postInjectionFlushTime, Null])
						}
					],
					{flushingTypes, preInjectionFlushTimes, postInjectionFlushTimes}
				];

				(* figure out if we have a problem *)
				flushingTypeConflicts = Or @@ Flatten[{preInjectionFlushTimeConflicts, postInjectionFlushTimeConflicts}];

				conflictingFlushingTypeOptions = MapThread[
					If[Or @@ #1, ToExpression@StringJoin[prefix, #2], Nothing]&,
					{
						{
							flushingTypeConflicts,
							preInjectionFlushTimeConflicts,
							postInjectionFlushTimeConflicts
						},
						{
							"HeadspaceSyringeFlushing",
							"HeadspacePreInjectionFlushTime",
							"HeadspacePostInjectionFlushTime"
						}
					}
				];

				conflictingOptions = conflictingFlushingTypeOptions;

				errorOps = Cases[conflictingFlushingTypeOptions, Except[ToExpression@StringJoin[prefix, "HeadspaceSyringeFlushing"]]];

				(* if we have conflicts, throw an error *)
				If[flushingTypeConflicts && !gatherTests,
					Message[Error::HeadspaceSyringeFlushingOptionsConflict, errorOps, prefix,
						ToExpression /@ StringReplace[
							(ToString /@ errorOps),
							{
								LetterCharacter... ~~ "HeadspacePreInjectionFlushTime" -> "BeforeSampleAspiration",
								LetterCharacter... ~~ "HeadspacePostInjectionFlushTime" -> "AfterSampleInjection"
							}
						]
					]
				];

				(* gather relevant tests *)
				flushingTypeConflictTest = If[gatherTests,
					Test["HeadspaceSyringeFlushing options agree with the specified " <> prefix <> "HeadspaceSyringeFlushing flushing types:",
						flushingTypeConflicts,
						False
					],
					{}
				];

				(* format the output *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{flushingTypeConflictTest}]
				}
			]
		],
		{
			{resolvedHeadspaceSyringeFlushings, masterSwitchedHeadspacePreInjectionFlushTimes, masterSwitchedHeadspacePostInjectionFlushTimes, ""},
			{resolvedStandardHeadspaceSyringeFlushings, masterSwitchedStandardHeadspacePreInjectionFlushTimes, masterSwitchedStandardHeadspacePostInjectionFlushTimes, "Standard"},
			{resolvedBlankHeadspaceSyringeFlushings, masterSwitchedBlankHeadspacePreInjectionFlushTimes, masterSwitchedBlankHeadspacePostInjectionFlushTimes, "Blank"}
		}
	];

	(* split the resulting tuples to create error issues *)
	{headspaceFlushingConflictOptions, headspaceFlushingConflictTests} = {Flatten[headspaceFlushingConflictTuples[[All, 1]]], Flatten[headspaceFlushingConflictTuples[[All, 2]]]};

	(* Make sure all the sample volumes are between 1-100% of the syringe volume *)

	{outOfRangeHeadspaceSampleVolumes, outOfRangeStandardHeadspaceSampleVolumes, outOfRangeBlankHeadspaceSampleVolumes} = Map[
		Function[{sampleVolumes},
			Select[
				Cases[sampleVolumes, _Quantity],
				# < 0.01 * resolvedHeadspaceInjectionSyringeVolume || # > resolvedHeadspaceInjectionSyringeVolume || NullQ[resolvedHeadspaceInjectionSyringeVolume]&
			]
		],
		{resolvedHeadspaceSampleVolumes, resolvedStandardHeadspaceSampleVolumes, resolvedStandardHeadspaceSampleVolumes}
	] /. {{} -> Null};

	(* if there are volumes outside that range, either throw an error or generate a failing test *)
	If[!gatherTests,
		Map[
			Function[{incompatibleSampleVolumes},
				If[Length[incompatibleSampleVolumes] > 0,
					Message[Error::GCSampleVolumeOutOfRange, incompatibleSampleVolumes, Headspace, resolvedHeadspaceInjectionSyringeVolume],
					Nothing
				]
			],
			{outOfRangeHeadspaceSampleVolumes, outOfRangeStandardHeadspaceSampleVolumes, outOfRangeBlankHeadspaceSampleVolumes}
		],
		Nothing
	];

	{outOfRangeHeadspaceSampleVolumeTests, outOfRangeStandardHeadspaceSampleVolumeTests, outOfRangeBlankHeadspaceSampleVolumeTests} = If[gatherTests,
		MapThread[
			Function[{incompatibleSampleVolumes, name},
				Test["The specified " <> name <> "InjectionVolume for each HeadspaceInjection sample falls between 1% and 100% of the volume of the specified HeadspaceInjectionSyringe (" <> ToString[resolvedHeadspaceInjectionSyringeVolume] <> ").",
					Length[incompatibleSampleVolumes] > 0,
					False
				]
			],
			{
				{outOfRangeHeadspaceSampleVolumes, outOfRangeStandardHeadspaceSampleVolumes, outOfRangeBlankHeadspaceSampleVolumes},
				{"", "Standard", "Blank"}
			}
		],
		{{}, {}, {}}
	];

	(* resolve the shared Liquid and Headspace parameters by recombining the list of resolved Liquid and Headspace parameters *)
	{
		{resolvedInjectionVolumes, resolvedSampleAspirationRates, resolvedSampleAspirationDelays, resolvedSampleInjectionRates},
		{resolvedStandardInjectionVolumes, resolvedStandardSampleAspirationRates, resolvedStandardSampleAspirationDelays, resolvedStandardSampleInjectionRates},
		{resolvedBlankInjectionVolumes, resolvedBlankSampleAspirationRates, resolvedBlankSampleAspirationDelays, resolvedBlankSampleInjectionRates}
	} = Map[
		Function[{optionsList},
			Module[{liquidSampleVolumesInternal, headspaceSampleVolumesInternal, liquidSampleAspirationRates, headspaceSampleAspirationRates,
				liquidSampleAspirationDelays, headspaceSampleAspirationDelays, liquidSampleInjectionRates, headspaceSampleInjectionRates,
				injectionVolumes, sampleAspirationRates, sampleAspirationDelays, sampleInjectionRates, samplingMethodsInternal},
				{
					{liquidSampleVolumesInternal, headspaceSampleVolumesInternal},
					{liquidSampleAspirationRates, headspaceSampleAspirationRates},
					{liquidSampleAspirationDelays, headspaceSampleAspirationDelays},
					{liquidSampleInjectionRates, headspaceSampleInjectionRates},
					samplingMethodsInternal
				} = optionsList;
				(* === FUNCTION === *)
				{injectionVolumes, sampleAspirationRates, sampleAspirationDelays, sampleInjectionRates} = Map[
					MapThread[
						Function[{resolvedLiquidParameter, resolvedHeadspaceParameter, samplingMethod},
							Switch[
								samplingMethod,
								LiquidInjection,
								resolvedLiquidParameter,
								HeadspaceInjection,
								resolvedHeadspaceParameter,
								_,
								Null
							]],
						Join[#, {samplingMethodsInternal}]
					]&,
					{
						{liquidSampleVolumesInternal, headspaceSampleVolumesInternal},
						{liquidSampleAspirationRates, headspaceSampleAspirationRates},
						{liquidSampleAspirationDelays, headspaceSampleAspirationDelays},
						{liquidSampleInjectionRates, headspaceSampleInjectionRates}
					}
				]
				(* === FUNCTION === *)
			]
		],
		{
			{
				{resolvedLiquidSampleVolumes, resolvedHeadspaceSampleVolumes},
				{resolvedLiquidSampleAspirationRates, resolvedHeadspaceSampleAspirationRates},
				{resolvedLiquidSampleAspirationDelays, resolvedHeadspaceSampleAspirationDelays},
				{resolvedLiquidSampleInjectionRates, resolvedHeadspaceSampleInjectionRates},
				resolvedSamplingMethods
			},
			{
				{resolvedStandardLiquidSampleVolumes, resolvedStandardHeadspaceSampleVolumes},
				{resolvedStandardLiquidSampleAspirationRates, resolvedStandardHeadspaceSampleAspirationRates},
				{resolvedStandardLiquidSampleAspirationDelays, resolvedStandardHeadspaceSampleAspirationDelays},
				{resolvedStandardLiquidSampleInjectionRates, resolvedStandardHeadspaceSampleInjectionRates},
				resolvedStandardSamplingMethods
			},
			{
				{resolvedBlankLiquidSampleVolumes, resolvedBlankHeadspaceSampleVolumes},
				{resolvedBlankLiquidSampleAspirationRates, resolvedBlankHeadspaceSampleAspirationRates},
				{resolvedBlankLiquidSampleAspirationDelays, resolvedBlankHeadspaceSampleAspirationDelays},
				{resolvedBlankLiquidSampleInjectionRates, resolvedBlankHeadspaceSampleInjectionRates},
				resolvedBlankSamplingMethods
			}
		}
	];


	(* Resolve SPME Sampling Options *)

	(* Get minimum installed Fiber temperature *)

	fiberMinTemperature = If[!NullQ[resolvedSPMEInjectionFiber],
		Lookup[fetchPacketFromCache[resolvedSPMEInjectionFiber, cache], MinTemperature],
		Null
	];

	(* Resolve SPME derivatizing agents if a parameter is specified *)

	(* Resolve SPME parameters for samples, standards, and blanks *)

	{
		{
			resolvedSPMEConditions,
			resolvedSPMEConditioningTemperatures,
			resolvedSPMEPreConditioningTimes,
			resolvedSPMEDerivatizingAgents,
			resolvedSPMEDerivatizingAgentAdsorptionTimes,
			resolvedSPMEDerivatizationPositions,
			resolvedSPMEDerivatizationPositionOffsets,
			resolvedSPMESampleExtractionTimes,
			resolvedSPMEAgitateWhileSamplings,
			resolvedSPMESampleDesorptionTimes,
			resolvedSPMEPostInjectionConditioningTimes
		},
		{
			resolvedStandardSPMEConditions,
			resolvedStandardSPMEConditioningTemperatures,
			resolvedStandardSPMEPreConditioningTimes,
			resolvedStandardSPMEDerivatizingAgents,
			resolvedStandardSPMEDerivatizingAgentAdsorptionTimes,
			resolvedStandardSPMEDerivatizationPositions,
			resolvedStandardSPMEDerivatizationPositionOffsets,
			resolvedStandardSPMESampleExtractionTimes,
			resolvedStandardSPMEAgitateWhileSamplings,
			resolvedStandardSPMESampleDesorptionTimes,
			resolvedStandardSPMEPostInjectionConditioningTimes
		},
		{
			resolvedBlankSPMEConditions,
			resolvedBlankSPMEConditioningTemperatures,
			resolvedBlankSPMEPreConditioningTimes,
			resolvedBlankSPMEDerivatizingAgents,
			resolvedBlankSPMEDerivatizingAgentAdsorptionTimes,
			resolvedBlankSPMEDerivatizationPositions,
			resolvedBlankSPMEDerivatizationPositionOffsets,
			resolvedBlankSPMESampleExtractionTimes,
			resolvedBlankSPMEAgitateWhileSamplings,
			resolvedBlankSPMESampleDesorptionTimes,
			resolvedBlankSPMEPostInjectionConditioningTimes
		}
	} = Map[
		Function[{optionsList},
			Module[{spmeConditions, sPMEConditioningTemperatures, spmePreConditioningTimes, spmeDerivatizingAgentAdsorptionTimes,
				spmeDerivatizationPositions, spmeDerivatizationPositionOffsets, spmeSampleExtractionTimes, spmeAgitateWhileSamplings, spmeSampleDesorptionTimes,
				spmePostInjectionConditioningTimes, resolvedConditions, resolvedPreConditioningTemperatures, resolvedPreConditioningTimes,
				resolvedDerivatizingAgentAdsorptionTimes, resolvedDerivatizationPositions, resolvedDerivatizationPositionOffsets, resolvedSampleExtractionTimes,
				resolvedAgitateWhileSamplings, resolvedSampleDesorptionTimes, resolvedPostInjectionConditioningTimes, spmeDerivatizingAgents, resolvedDerivatizingAgents,
				derivatizationParametersSpecifiedQ},
				{
					spmeConditions,
					sPMEConditioningTemperatures,
					spmePreConditioningTimes,
					spmeDerivatizingAgents,
					spmeDerivatizingAgentAdsorptionTimes,
					spmeDerivatizationPositions,
					spmeDerivatizationPositionOffsets,
					spmeSampleExtractionTimes,
					spmeAgitateWhileSamplings,
					spmeSampleDesorptionTimes,
					spmePostInjectionConditioningTimes
				} = optionsList;
				(* === FUNCTION === *)
				derivatizationParametersSpecifiedQ = MapThread[
					Function[{derivatizingAgentAdsorptionTimes, derivatizationPositions, derivatizationPositionOffsets},
						MemberQ[{derivatizingAgentAdsorptionTimes, derivatizationPositions, derivatizationPositionOffsets}, Except[(Null | Automatic)]]
					],
					{spmeDerivatizingAgentAdsorptionTimes, spmeDerivatizationPositions, spmeDerivatizationPositionOffsets}
				];

				(* SPMEDerivatizingAgent *)
				resolvedDerivatizingAgents = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, False},
						Null,
						{Automatic, True},
						Model[Sample, "Hexanes"]
					]&,
					{spmeDerivatizingAgents, derivatizationParametersSpecifiedQ}
				];

				(*SPMECondition*)

				(* Unless SPMEConditioningTemperature has been set to Null, set this to true *)
				resolvedConditions = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, Except[Null]},
						True
					]&,
					{spmeConditions, sPMEConditioningTemperatures}
				];

				(*SPMEConditioningTemperature*)

				(* Unless SPMECondition is False, set this to the resolved fiber's MinTemperature *)
				resolvedPreConditioningTemperatures = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, Except[Null | False]},
						fiberMinTemperature
					]&,
					{sPMEConditioningTemperatures, resolvedConditions}
				];

				(*SPMEPreConditioningTime*)

				(* Unless SPMECondition is False, set this to a universal minumum time *)
				resolvedPreConditioningTimes = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, Except[Null | False]},
						30 * Minute
					]&,
					{spmePreConditioningTimes, resolvedConditions}
				];

				(*SPMEDerivatizingAgentAdsorptionTime*)

				(* Default to 0.2 Minute unless SPMEDerivatizingAgent is Null *)
				resolvedDerivatizingAgentAdsorptionTimes = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, ObjectP[{Object[Sample], Model[Sample]}]},
						30 * Minute,
						{Automatic, Null},
						Null
					]&,
					{spmeDerivatizingAgentAdsorptionTimes, resolvedDerivatizingAgents}
				];

				(*SPMEDerivatizationPosition*)

				(* Default to Top unless SPMEDerivatizingAgent is Null *)
				resolvedDerivatizationPositions = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, ObjectP[{Object[Sample], Model[Sample]}]},
						Top,
						{Automatic, Null},
						Null
					]&,
					{spmeDerivatizationPositions, resolvedDerivatizingAgents}
				];

				(*SPMEDerivatizationPositionOffset*)

				(* Default to 10 mm unless SPMEDerivatizingAgent is Null *)
				resolvedDerivatizationPositionOffsets = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, ObjectP[{Object[Sample], Model[Sample]}]},
						10 * Millimeter,
						{Automatic, Null},
						Null
					]&,
					{spmeDerivatizationPositionOffsets, resolvedDerivatizingAgents}
				];

				(*SPMESampleExtractionTime*)
				resolvedSampleExtractionTimes = Map[
					Switch[
						#,
						Except[Automatic],
						#,
						Automatic,
						10 * Minute
					]&,
					spmeSampleExtractionTimes
				];

				(*SPMEAgitateWhileSampling*)
				resolvedAgitateWhileSamplings = Map[
					Switch[
						#,
						Except[Automatic],
						#,
						Automatic,
						False
					]&,
					spmeAgitateWhileSamplings
				];
				(* Set to False *)

				(*SPMESampleDesorptionTime*)
				resolvedSampleDesorptionTimes = Map[
					Switch[
						#,
						Except[Automatic],
						#,
						Automatic,
						0.2 * Minute
					]&,
					spmeSampleDesorptionTimes
				];
				(* Resolve to 1 minute *)

				(*SPMEPostInjectionConditioningTime*)
				resolvedPostInjectionConditioningTimes = Map[
					Switch[
						#,
						Except[Automatic],
						#,
						Automatic,
						0 * Minute
					]&,
					spmePostInjectionConditioningTimes
				];
				(* Resolve to 0 minutes *)

				{
					resolvedConditions,
					resolvedPreConditioningTemperatures,
					resolvedPreConditioningTimes,
					resolvedDerivatizingAgents,
					resolvedDerivatizingAgentAdsorptionTimes,
					resolvedDerivatizationPositions,
					resolvedDerivatizationPositionOffsets,
					resolvedSampleExtractionTimes,
					resolvedAgitateWhileSamplings,
					resolvedSampleDesorptionTimes,
					resolvedPostInjectionConditioningTimes
				}
				(* === FUNCTION === *)
			]
		],
		{
			{
				masterSwitchedSPMEConditions,
				masterSwitchedSPMEConditioningTemperatures,
				masterSwitchedSPMEPreConditioningTimes,
				masterSwitchedSPMEDerivatizingAgents,
				masterSwitchedSPMEDerivatizingAgentAdsorptionTimes,
				masterSwitchedSPMEDerivatizationPositions,
				masterSwitchedSPMEDerivatizationPositionOffsets,
				masterSwitchedSPMESampleExtractionTimes,
				masterSwitchedSPMEAgitateWhileSamplings,
				masterSwitchedSPMESampleDesorptionTimes,
				masterSwitchedSPMEPostInjectionConditioningTimes
			},
			{
				masterSwitchedStandardSPMEConditions,
				masterSwitchedStandardSPMEConditioningTemperatures,
				masterSwitchedStandardSPMEPreConditioningTimes,
				masterSwitchedStandardSPMEDerivatizingAgents,
				masterSwitchedStandardSPMEDerivatizingAgentAdsorptionTimes,
				masterSwitchedStandardSPMEDerivatizationPositions,
				masterSwitchedStandardSPMEDerivatizationPositionOffsets,
				masterSwitchedStandardSPMESampleExtractionTimes,
				masterSwitchedStandardSPMEAgitateWhileSamplings,
				masterSwitchedStandardSPMESampleDesorptionTimes,
				masterSwitchedStandardSPMEPostInjectionConditioningTimes
			},
			{
				masterSwitchedBlankSPMEConditions,
				masterSwitchedBlankSPMEConditioningTemperatures,
				masterSwitchedBlankSPMEPreConditioningTimes,
				masterSwitchedBlankSPMEDerivatizingAgents,
				masterSwitchedBlankSPMEDerivatizingAgentAdsorptionTimes,
				masterSwitchedBlankSPMEDerivatizationPositions,
				masterSwitchedBlankSPMEDerivatizationPositionOffsets,
				masterSwitchedBlankSPMESampleExtractionTimes,
				masterSwitchedBlankSPMEAgitateWhileSamplings,
				masterSwitchedBlankSPMESampleDesorptionTimes,
				masterSwitchedBlankSPMEPostInjectionConditioningTimes
			}
		}
	];

	(* error check all the post-injection syringe wash options for internal conflicts *)
	spmeConflictTuples = Map[
		Function[opsList,
			Module[
				{
					spmeConditions, spmeConditioningTemperatures, spmePreConditioningTimes, spmePostInjectionConditioningTimes, spmeDerivatizingAgents, spmeDerivatizingAgentAdsorptionTimes,
					spmeDerivatizationPositions, spmeDerivatizationPositionOffsets, prefix, spmeConditioningTemperatureConflicts, spmePreConditioningTimeConflicts, spmePostInjectionConditioningTimeConflicts,
					spmeDerivatizingAgentAdsorptionTimeConflicts, spmeDerivatizationPositionConflicts, spmeDerivatizationPositionOffsetConflicts, spmeConditionConflicts, spmeDerivatizationConflicts,
					conflictingSPMEConditionOptions, conflictingSPMEDerivatizationOptions, conflictingOptions, spmeOptionConflictTests
				},
				{spmeConditions, spmeConditioningTemperatures, spmePreConditioningTimes, spmePostInjectionConditioningTimes, spmeDerivatizingAgents, spmeDerivatizingAgentAdsorptionTimes,
					spmeDerivatizationPositions, spmeDerivatizationPositionOffsets, prefix} = opsList;

				(* conflicts between spmeCondition and conditioning options *)
				{
					spmeConditioningTemperatureConflicts,
					spmePreConditioningTimeConflicts,
					spmePostInjectionConditioningTimeConflicts
				} = Transpose@MapThread[
					Function[
						{spmeCondition, spmeConditioningTemperature, spmePreConditioningTime, spmePostInjectionConditioningTime},
						{
							(MatchQ[spmeCondition, False] && MatchQ[spmeConditioningTemperature, Except[Null | Automatic]]) || (MatchQ[spmeCondition, True] && MatchQ[spmeConditioningTemperature, Null]),
							(* little trickier here: if SPMECondition is True, but NONE of the times are specified, then we have a problem *)
							(MatchQ[spmeCondition, False] && MatchQ[spmePreConditioningTime, Except[Null | Automatic]]) || (MatchQ[spmeCondition, True] && MatchQ[spmePreConditioningTime, Null] && MatchQ[spmePostInjectionConditioningTime, (Null | Automatic)]),
							(MatchQ[spmeCondition, False] && MatchQ[spmePostInjectionConditioningTime, Except[Null | Automatic]]) || (MatchQ[spmeCondition, True] && MatchQ[spmePostInjectionConditioningTime, (Null | Automatic)] && MatchQ[spmePreConditioningTime, Null])
						}
					],
					{spmeConditions, spmeConditioningTemperatures, spmePreConditioningTimes, spmePostInjectionConditioningTimes}
				];

				(* conflicts between specified derivatization agent and options and conditioning options *)
				{
					spmeDerivatizingAgentAdsorptionTimeConflicts,
					spmeDerivatizationPositionConflicts,
					spmeDerivatizationPositionOffsetConflicts
				} = Transpose@MapThread[
					Function[
						{spmeDerivatizingAgent, spmeDerivatizingAgentAdsorptionTime, spmeDerivatizationPosition, spmeDerivatizationPositionOffset},
						{
							(NullQ[spmeDerivatizingAgents] && MatchQ[spmeDerivatizingAgentAdsorptionTime, Except[Null | Automatic]]) || (MatchQ[spmeDerivatizingAgents, ObjectP[]] && MatchQ[spmeDerivatizingAgentAdsorptionTime, Null]),
							(NullQ[spmeDerivatizingAgents] && MatchQ[spmeDerivatizationPosition, Except[Null | Automatic]]) || (MatchQ[spmeDerivatizingAgents, ObjectP[]] && MatchQ[spmeDerivatizationPosition, Null]),
							(NullQ[spmeDerivatizingAgents] && MatchQ[spmeDerivatizationPositionOffset, Except[Null | Automatic]]) || (MatchQ[spmeDerivatizingAgents, ObjectP[]] && MatchQ[spmeDerivatizationPositionOffset, Null])
						}
					],
					{spmeDerivatizingAgents, spmeDerivatizingAgentAdsorptionTimes, spmeDerivatizationPositions, spmeDerivatizationPositionOffsets}
				];

				(* figure out if we have a problem *)
				{spmeConditionConflicts, spmeDerivatizationConflicts} = {
					Or @@ Flatten[{spmeConditioningTemperatureConflicts, spmePreConditioningTimeConflicts, spmePostInjectionConditioningTimeConflicts}],
					Or @@ Flatten[{spmeDerivatizingAgentAdsorptionTimeConflicts, spmeDerivatizationPositionConflicts, spmeDerivatizationPositionOffsetConflicts}]
				};

				{conflictingSPMEConditionOptions, conflictingSPMEDerivatizationOptions} = Map[
					Function[{boolsAndOps},
						Module[{conflictBools, optionNames},
							{conflictBools, optionNames} = boolsAndOps;

							MapThread[
								If[Or @@ #1, ToExpression@StringJoin[prefix, #2], Nothing]&,
								{
									conflictBools,
									optionNames
								}
							]
						]
					],
					{
						{
							{
								spmeConditionConflicts,
								spmeConditioningTemperatureConflicts,
								spmePreConditioningTimeConflicts,
								spmePostInjectionConditioningTimeConflicts
							},
							{
								"SPMECondition",
								"SPMEConditioningTemperature",
								"SPMEPreConditioningTime",
								"SPMEPostInjectionConditioningTime"
							}
						},
						{
							{
								spmeDerivatizationConflicts,
								spmeDerivatizingAgentAdsorptionTimeConflicts,
								spmeDerivatizationPositionConflicts,
								spmeDerivatizationPositionOffsetConflicts
							},
							{
								"SPMEDerivatizingAgent",
								"SPMEDerivatizingAgentAdsorptionTime",
								"SPMEDerivatizationPosition",
								"SPMEDerivatizationPositionOffset"
							}
						}
					}
				];

				conflictingOptions = Flatten[{conflictingSPMEConditionOptions, conflictingSPMEDerivatizationOptions}];

				(* if we have conflicts, throw an error based on the type of conflict *)
				If[!gatherTests,
					If[spmeConditionConflicts,
						Message[Error::SPMEConditionOptionsConflict, Cases[conflictingSPMEConditionOptions, Except[ToExpression@StringJoin[prefix, "SPMECondition"]]], prefix],
						Nothing
					];
					If[spmeDerivatizationConflicts,
						Message[Error::SPMEDerivatizationOptionsConflict, Cases[conflictingSPMEDerivatizationOptions, Except[ToExpression@StringJoin[prefix, "SPMEDerivatizingAgent"]]], prefix],
						Nothing
					],
					Nothing
				];

				(* gather relevant tests *)
				spmeOptionConflictTests = If[gatherTests,
					{
						Test[prefix <> " SPME conditioning options are only specified if " <> prefix <> "SPMECondition is true:",
							spmeConditionConflicts,
							False
						],
						Test[prefix <> " SPME derivatization options are only specified if a " <> prefix <> "SPMEDerivatization is specified:",
							spmeDerivatizationConflicts,
							False
						]
					},
					{}
				];

				(* format the output *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{spmeOptionConflictTests}]
				}
			]
		],
		{
			{
				resolvedSPMEConditions,
				masterSwitchedSPMEConditioningTemperatures,
				masterSwitchedSPMEPreConditioningTimes,
				masterSwitchedSPMEPostInjectionConditioningTimes,
				resolvedSPMEDerivatizingAgents,
				masterSwitchedSPMEDerivatizingAgentAdsorptionTimes,
				masterSwitchedSPMEDerivatizationPositions,
				masterSwitchedSPMEDerivatizationPositionOffsets,
				""
			},
			{
				resolvedStandardSPMEConditions,
				masterSwitchedStandardSPMEConditioningTemperatures,
				masterSwitchedStandardSPMEPreConditioningTimes,
				masterSwitchedStandardSPMEPostInjectionConditioningTimes,
				resolvedStandardSPMEDerivatizingAgents,
				masterSwitchedStandardSPMEDerivatizingAgentAdsorptionTimes,
				masterSwitchedStandardSPMEDerivatizationPositions,
				masterSwitchedStandardSPMEDerivatizationPositionOffsets,
				"Standard"
			},
			{
				resolvedBlankSPMEConditions,
				masterSwitchedBlankSPMEConditioningTemperatures,
				masterSwitchedBlankSPMEPreConditioningTimes,
				masterSwitchedBlankSPMEPostInjectionConditioningTimes,
				resolvedBlankSPMEDerivatizingAgents,
				masterSwitchedBlankSPMEDerivatizingAgentAdsorptionTimes,
				masterSwitchedBlankSPMEDerivatizationPositions,
				masterSwitchedBlankSPMEDerivatizationPositionOffsets,
				"Blank"
			}
		}
	];

	(* split the resulting tuples to create error issues *)
	{spmeConflictConflictOptions, spmeConflictConflictTests} = {Flatten[spmeConflictTuples[[All, 1]]], Flatten[spmeConflictTuples[[All, 2]]]};

	{resolvedAgitateWhileSamplings, resolvedStandardAgitateWhileSamplings, resolvedBlankAgitateWhileSamplings} = Map[
		Function[{optionsList},
			Module[{headspaceAgitateWhileSamplings, spmeAgitateWhileSamplings, specifiedAgitateWSamplings, agitateWhileSamplings, samplingMethodsInternal},
				{headspaceAgitateWhileSamplings, spmeAgitateWhileSamplings, specifiedAgitateWSamplings, samplingMethodsInternal} = optionsList;
				(* === FUNCTION === *)
				agitateWhileSamplings = MapThread[
					Function[{resolvedHeadspaceParameter, resolvedSPMEParameter, specifiedValue, samplingMethod},
						If[MatchQ[specifiedValue, Automatic],
							Switch[
								samplingMethod,
								HeadspaceInjection,
								resolvedHeadspaceParameter,
								SPMEInjection,
								resolvedSPMEParameter,
								_,
								Null
							],
							specifiedValue
						]
					],
					{headspaceAgitateWhileSamplings, spmeAgitateWhileSamplings, specifiedAgitateWSamplings, samplingMethodsInternal}
				]
			]
			(* === FUNCTION === *)
		],
		{
			{resolvedHeadspaceAgitateWhileSamplings, resolvedSPMEAgitateWhileSamplings, specifiedAgitateWhileSamplings, resolvedSamplingMethods},
			{resolvedStandardHeadspaceAgitateWhileSamplings, resolvedStandardSPMEAgitateWhileSamplings, specifiedStandardAgitateWhileSamplings, resolvedStandardSamplingMethods},
			{resolvedBlankHeadspaceAgitateWhileSamplings, resolvedBlankSPMEAgitateWhileSamplings, specifiedBlankAgitateWhileSamplings, resolvedBlankSamplingMethods}
		}
	];

	(* SampleVialAspirationPositionOffset *)(* Instrument penetration depth limits: Liquid: 1-45 Headspace: 10-50 SPME: 8-65 TODO: error check these limits, and also against the vials that are being used *)

	specifiedSampleVialAspirationPositionOffsets = Lookup[roundedGasChromatographyOptions, SampleVialAspirationPositionOffset];
	specifiedStandardSampleVialAspirationPositionOffsets = Lookup[expandedStandardsAssociation, StandardSampleVialAspirationPositionOffset];
	specifiedBlankSampleVialAspirationPositionOffsets = Lookup[expandedBlanksAssociation, BlankSampleVialAspirationPositionOffset];

	{resolvedSampleVialAspirationPositionOffsets, resolvedStandardSampleVialAspirationPositionOffsets, resolvedBlankSampleVialAspirationPositionOffsets} = Map[
		Function[{optionsList},
			Module[{resolvedAspirationPositionOffsets, sampleVialAspirationPositionOffsets, samplingMethodsInternal},
				{sampleVialAspirationPositionOffsets, samplingMethodsInternal} = optionsList;
				(* === FUNCTION === *)
				resolvedAspirationPositionOffsets = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, LiquidInjection},
						30 * Millimeter,
						{Automatic, HeadspaceInjection},
						15 * Millimeter,
						{Automatic, SPMEInjection},
						40 * Millimeter
					]&,
					{sampleVialAspirationPositionOffsets, samplingMethodsInternal}
				]
				(* === FUNCTION === *)
			]
		],
		{
			{specifiedSampleVialAspirationPositionOffsets, resolvedSamplingMethods},
			{specifiedStandardSampleVialAspirationPositionOffsets, resolvedStandardSamplingMethods},
			{specifiedBlankSampleVialAspirationPositionOffsets, resolvedBlankSamplingMethods}
		}
	];

	(* === Resolve InletTemperatureMode, mini-Master-Switch for InletMode (SplitRatio or SplitlessTime), InitialInletPressure, InitialInletTime, GasSaver, GasSaverFlowRate, GasSaverActivationTime, InitialInletTemperature, InitialInletTemperatureDuration, InletTemperatureProfile, (MMIFastCooldown), InitialColumnAverageVelocity, InitialColumnPressure,InitialColumnFlowRate, InitialColumnResidenceTime, InitialColumnSetpointDuration, ColumnPressureProfile, ColumnFlowRateProfile === *)

	(* Resolve the inlet temperature options for all samples, standards, blanks *)
	{
		{
			resolvedInletTemperatureModes,
			resolvedInletTemperatureProfiles,
			resolvedInitialInletTemperatures,
			resolvedInitialInletTemperatureDurations
		},
		{
			resolvedStandardInletTemperatureModes,
			resolvedStandardInletTemperatureProfiles,
			resolvedStandardInitialInletTemperatures,
			resolvedStandardInitialInletTemperatureDurations
		},
		{
			resolvedBlankInletTemperatureModes,
			resolvedBlankInletTemperatureProfiles,
			resolvedBlankInitialInletTemperatures,
			resolvedBlankInitialInletTemperatureDurations
		}
	} = Map[
		Function[{optionsList},
			Module[{inletTemperatureProfiles, initialInletTemperatures, initialInletTemperatureDurations,
				resolvedTemperatureModes, resolvedInitialTemperatures, resolvedInitialTemperatureHoldTimes, resolvedTemperatureProfiles},
				{
					inletTemperatureProfiles,
					initialInletTemperatures,
					initialInletTemperatureDurations
				} = optionsList;
				(* === FUNCTION === *)
				(* InletTemperatureMode *)
				(* Resolve to isothermal unless there's a temperatureProfile specified *)
				resolvedTemperatureModes = Map[
					Switch[
						#,
						(Automatic | Isothermal | Null | _Quantity),
						Isothermal,
						_,
						TemperatureProfile
					]&,
					inletTemperatureProfiles
				];

				(* InitialInletTemperature *)
				(* Resolve to 275 Celsius if isothermal mode, 100 Celsius if temperatureprofile *)
				resolvedInitialTemperatures = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, Isothermal},
						275 * Celsius,
						{Automatic, TemperatureProfile},
						100 * Celsius,
						{Automatic, Null},
						Null
					]&,
					{initialInletTemperatures, resolvedTemperatureModes}
				];


				(* InitialInletTemperatureDuration *)
				(* Resolve to Null unless a TemperatureProfile is specified, then 0.1 min *)
				resolvedInitialTemperatureHoldTimes = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, Isothermal},
						Null,
						{Automatic, TemperatureProfile},
						0.2 * Minute,
						{Automatic, Null},
						Null
					]&,
					{initialInletTemperatureDurations, resolvedTemperatureModes}
				];

				(* InletTemperatureProfile *)
				(* Resolve to Null unless a TemperatureProfile is specified, then {{720*Celsius/Minute,275*Celsius,0*Minute}} *)
				resolvedTemperatureProfiles = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, Isothermal},
						Null,
						{Automatic, TemperatureProfile},
						{{720 * Celsius / Minute, 275 * Celsius, 0 * Minute}},
						{Automatic, Null},
						Null
					]&,
					{inletTemperatureProfiles, resolvedTemperatureModes}
				];

				{
					resolvedTemperatureModes,
					resolvedTemperatureProfiles,
					resolvedInitialTemperatures,
					resolvedInitialTemperatureHoldTimes
				}
				(* === FUNCTION === *)
			]
		],
		{
			{
				specifiedInletTemperatureProfiles,
				specifiedInitialInletTemperatures,
				specifiedInitialInletTemperatureDurations
			},
			{
				specifiedStandardInletTemperatureProfiles,
				specifiedStandardInitialInletTemperatures,
				specifiedStandardInitialInletTemperatureDurations
			},
			{
				specifiedBlankInletTemperatureProfiles,
				specifiedBlankInitialInletTemperatures,
				specifiedBlankInitialInletTemperatureDurations
			}
		}
	];

	(* error check the profiles to make sure they are not broken todo *)



	resolvedInletTemperatureProfileSetpoints = Map[
		Function[profile,
			Select[profile, CompatibleUnitQ[#, Celsius] &]
		],
		Join[resolvedInletTemperatureProfiles, resolvedStandardInletTemperatureProfiles, resolvedBlankInletTemperatureProfiles],
		{2}
	];

	specifiedInitialInletTemperatureSetpoints = Select[Join[resolvedInitialInletTemperatures, resolvedStandardInitialInletTemperatures, resolvedBlankInitialInletTemperatures], CompatibleUnitQ[#, Celsius] &];

	(* Resolve inlet mode parameters for samples, standards and blanks *)

	{
		{
			resolvedSplitRatios,
			resolvedSolventEliminationFlowRates,
			preresolvedInitialInletPressures,
			preresolvedInitialInletTimes
		},
		{
			resolvedStandardSplitRatios,
			resolvedStandardSolventEliminationFlowRates,
			preresolvedStandardInitialInletPressures,
			preresolvedStandardInitialInletTimes
		},
		{
			resolvedBlankSplitRatios,
			resolvedBlankSolventEliminationFlowRates,
			preresolvedBlankInitialInletPressures,
			preresolvedBlankInitialInletTimes
		}
	} = Map[
		Function[{optionsList},
			Module[{splitRatios, splitVentFlowRates, solventEliminationFlowRates, initialInletPressures, initialInletTimes, resolvedModes, resolvedRatios, resolvedSolventEliminationFlowRates, resolvedSolventVentPressures, resolvedSolventVentTimes},
				{ splitRatios, splitVentFlowRates, solventEliminationFlowRates, initialInletPressures, initialInletTimes, resolvedModes } = optionsList;
				(* === FUNCTION === *)
				(* SplitRatio *)
				(* Resolve to 10 if inlet mode is split type, or Null if SplitVentFlowRate is specified *)
				resolvedRatios = MapThread[
					Switch[
						{#1, #2, #3},
						{Except[Automatic], _, _},
						#1,
						{Automatic, Null | Automatic, (Split | PulsedSplit)},
						10,
						{Automatic, Except[Null], _},
						Null
					]&,
					{splitRatios, splitVentFlowRates, resolvedModes}
				];

				(* SolventEliminationFlowRate *)
				(* Automatically set to 100 mL/min if InletMode is SolventVent *)
				resolvedSolventEliminationFlowRates = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, SolventVent},
						100 * Milliliter / Minute,
						{Automatic, _},
						Null
					]&,
					{solventEliminationFlowRates, resolvedModes}
				];

				(* InitialInletPressure *)
				(* Automatically set to 2 PSI if InletMode is SolventVent *)
				resolvedSolventVentPressures = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, SolventVent},
						2 * PSI,
						{Automatic, PulsedSplit | PulsedSplitless},
						#1,
						{Automatic, _},
						Null
					]&,
					{initialInletPressures, resolvedModes}
				];

				(* InitialInletTime *)
				(* is automatically set to 0.1 min if InletMode is SolventVent *)
				resolvedSolventVentTimes = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, SolventVent},
						0.1 * Minute,
						{Automatic, PulsedSplit | PulsedSplitless},
						#1,
						{Automatic, _},
						Null
					]&,
					{initialInletTimes, resolvedModes}
				];

				{resolvedRatios, resolvedSolventEliminationFlowRates, resolvedSolventVentPressures, resolvedSolventVentTimes}
				(* === FUNCTION === *)
			]
		],
		{
			{
				specifiedSplitRatios,
				specifiedSplitVentFlowRates,
				specifiedSolventEliminationFlowRates,
				specifiedInitialInletPressures,
				specifiedInitialInletTimes,
				specifiedInletModes
			},
			{
				specifiedStandardSplitRatios,
				specifiedStandardSplitVentFlowRates,
				specifiedStandardSolventEliminationFlowRates,
				specifiedStandardInitialInletPressures,
				specifiedStandardInitialInletTimes,
				specifiedStandardInletModes
			},
			{
				specifiedBlankSplitRatios,
				specifiedBlankSplitVentFlowRates,
				specifiedBlankSolventEliminationFlowRates,
				specifiedBlankInitialInletPressures,
				specifiedBlankInitialInletTimes,
				specifiedBlankInletModes
			}
		}
	];

	(* Resolve gas saver parameters for all samples, standards, blanks *)
	{
		{
			resolvedGasSavers,
			resolvedGasSaverFlowRates
		},
		{
			resolvedStandardGasSavers,
			resolvedStandardGasSaverFlowRates
		},
		{
			resolvedBlankGasSavers,
			resolvedBlankGasSaverFlowRates
		}
	} = Map[
		Function[{optionsList},
			Module[{resolvedSavers, resolvedSaverFlowRates, gasSavers, resolvedModes, gasSaverFlowRates },
				{ gasSavers, resolvedModes, gasSaverFlowRates } = optionsList;
				(* === FUNCTION === *)
				(* GasSaver *)
				(* Resolves to True unless InletMode is DirectInjection *)
				resolvedSavers = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, Except[DirectInjection]},
						True,
						{Automatic, DirectInjection},
						Null
					]&,
					{gasSavers, resolvedModes}
				];

				(* GasSaverFlowRate *)
				resolvedSaverFlowRates = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, (False | Null)},
						Null,
						{Automatic, True},
						25 * Milliliter / Minute
					]&,
					{gasSaverFlowRates, resolvedSavers}
				];

				{resolvedSavers, resolvedSaverFlowRates}
				(* === FUNCTION === *)
			]
		],
		{
			{
				specifiedGasSavers,
				specifiedInletModes,
				specifiedGasSaverFlowRates
			},
			{
				specifiedStandardGasSavers,
				specifiedStandardInletModes,
				specifiedStandardGasSaverFlowRates
			},
			{
				specifiedBlankGasSavers,
				specifiedBlankInletModes,
				specifiedBlankGasSaverFlowRates
			}
		}
	];



	(* Column parameters *)

	(* Column flow parameters: resolve for samples, standards, blanks *)
	(* todo: add SecondaryColumn...options for all of these? that way we can plumb to the PSD? *)
	{
		{
			resolvedInitialColumnAverageVelocities,
			resolvedInitialColumnFlowRates,
			resolvedInitialColumnPressures,
			resolvedInitialColumnResidenceTimes,
			resolvedInitialColumnSetpointDurations,
			resolvedColumnPressureProfiles,
			resolvedColumnFlowRateProfiles
		},
		{
			resolvedStandardInitialColumnAverageVelocities,
			resolvedStandardInitialColumnFlowRates,
			resolvedStandardInitialColumnPressures,
			resolvedStandardInitialColumnResidenceTimes,
			resolvedStandardInitialColumnSetpointDurations,
			resolvedStandardColumnPressureProfiles,
			resolvedStandardColumnFlowRateProfiles
		},
		{
			resolvedBlankInitialColumnAverageVelocities,
			resolvedBlankInitialColumnFlowRates,
			resolvedBlankInitialColumnPressures,
			resolvedBlankInitialColumnResidenceTimes,
			resolvedBlankInitialColumnSetpointDurations,
			resolvedBlankColumnPressureProfiles,
			resolvedBlankColumnFlowRateProfiles
		}
	} = Map[
		Function[{optionsList},
			Module[{initialColumnAverageVelocities, initialColumnFlowRates, initialColumnPressures, initialColumnResidenceTimes, initialColumnSetpointDurations,
				columnPressureProfiles, columnFlowRateProfiles, resolvedInitialAverageVelocities, resolvedInitialFlowRates, resolvedInitialPressures,
				resolvedInitialResidenceTimes, resolvedInitialHoldTimes, resolvedPressureProfiles, resolvedFlowRateProfiles, samples, initialTemperatures, outletPressure,
				referenceTemperature, referencePressure, defaultFlowRate
			},
				{ initialColumnAverageVelocities, initialColumnFlowRates, initialColumnPressures, initialColumnResidenceTimes, initialColumnSetpointDurations, columnPressureProfiles, columnFlowRateProfiles, samples, initialTemperatures } = optionsList;
				(* === FUNCTION === *)
				(* Resolves to 1.7, 2.0, or 0.5 mL/min for He, H2, or N2 carrierGas respectively, if no InitialColumn options are defined *)
				defaultFlowRate = Switch[
					specifiedCarrierGas,
					Helium,
					1.7 * Milliliter / Minute,
					Dihydrogen,
					2.0 * Milliliter / Minute,
					Dinitrogen,
					0.5 * Milliliter / Minute
				];

				(* figure out the outlet pressure *)
				outletPressure = Switch[specifiedDetector,
					FlameIonizationDetector,
					0 * PSI,
					MassSpectrometer,
					Convert[10^(-6) * Pascal, PSI]
				];


				referencePressure = 1.031 * Atmosphere;
				referenceTemperature = 301.1 * Kelvin;

				(* resolve the initial params *)
				{resolvedInitialAverageVelocities, resolvedInitialFlowRates, resolvedInitialPressures, resolvedInitialResidenceTimes} = Transpose@MapThread[
					Function[{velocity, flowRate, pressure, residenceTime, temperature},
						Switch[
							{velocity, flowRate, pressure, residenceTime},
							{Automatic, Automatic, Automatic, Automatic},
							{
								convertColumnFlowRateToVelocity[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, defaultFlowRate, temperature, outletPressure, referencePressure, referenceTemperature],
								defaultFlowRate,
								convertColumnFlowRateToPressure[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, defaultFlowRate, temperature, outletPressure, referencePressure, referenceTemperature],
								convertColumnFlowRateToResidenceTime[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, defaultFlowRate, temperature, outletPressure, referencePressure, referenceTemperature]
							},
							{Except[Automatic | Null], Except[Automatic | Null], Except[Automatic | Null], Except[Automatic | Null]},
							{velocity, flowRate, pressure, residenceTime},
							{Null, Null, Null, Null},
							{
								Null,
								Null,
								Null,
								Null
							},
							{Except[Automatic | Null], _, _, _},
							{
								velocity,
								convertColumnVelocityToFlowRate[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, velocity, temperature, outletPressure, referencePressure, referenceTemperature],
								convertColumnVelocityToPressure[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, velocity, temperature, outletPressure, referencePressure, referenceTemperature],
								convertColumnVelocityToResidenceTime[First@columnLength, velocity]
							},
							{_, Except[Automatic | Null], _, _},
							{
								convertColumnFlowRateToVelocity[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, flowRate, temperature, outletPressure, referencePressure, referenceTemperature],
								flowRate,
								convertColumnFlowRateToPressure[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, flowRate, temperature, outletPressure, referencePressure, referenceTemperature],
								convertColumnFlowRateToResidenceTime[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, flowRate, temperature, outletPressure, referencePressure, referenceTemperature]
							},
							{_, _, Except[Automatic | Null], _},
							{
								convertColumnPressureToVelocity[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, pressure, temperature, outletPressure, referencePressure, referenceTemperature],
								convertColumnPressureToFlowRate[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, pressure, temperature, outletPressure, referencePressure, referenceTemperature],
								pressure,
								convertColumnPressureToResidenceTime[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, pressure, temperature, outletPressure, referencePressure, referenceTemperature]
							},
							{_, _, _, Except[Automatic | Null]},
							{
								convertColumnResidenceTimeToVelocity[First@columnLength, residenceTime],
								convertColumnResidenceTimeToFlowRate[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, residenceTime, temperature, outletPressure, referencePressure, referenceTemperature],
								convertColumnResidenceTimeToPressure[specifiedCarrierGas, First@columnDiameter - 2 * First@columnFilmThickness, First@columnLength, residenceTime, temperature, outletPressure, referencePressure, referenceTemperature],
								residenceTime
							}
						]
					],
					{initialColumnAverageVelocities, initialColumnFlowRates, initialColumnPressures, initialColumnResidenceTimes, initialTemperatures}
				];
				(* InitialColumnSetpointDuration *)
				(* Resolves to 40, 50, or 20 cm/s for He, H2, or N2 carrierGas respectively *)
				resolvedInitialHoldTimes = MapThread[
					Switch[
						{#1, #2, #3},
						{Except[Automatic], _, _},
						#1,
						(* if a ramp rate profile is set, need to have an initial duration *)
						{Automatic, {{_, _, _}..}, (Automatic | Null)} | {Automatic, (Automatic | Null), {{_, _, _}..}},
						2 * Minute,
						(* if we have profiles that are automatic or we indicate that we're holding constant, we don't need an initial hold time *)
						{Automatic, Automatic | ConstantFlowRate, Automatic | ConstantPressure},
						Null,
						{Automatic, Null, Null},
						Null
					]&,
					{initialColumnSetpointDurations, columnFlowRateProfiles, columnPressureProfiles}
				];

				(* ColumnPressureProfile *)
				(* Resolves to 40, 50, or 20 cm/s for He, H2, or N2 carrierGas respectively *)
				resolvedPressureProfiles = MapThread[
					Switch[
						{#1, #2, #3},
						{Except[Automatic], _, _},
						#1,
						{Automatic, Except[Null], Except[Null]},
						Null,
						{Automatic, Except[Null], Null},
						{{1 * PSI / Minute, 20 * PSI, 5 * Minute}},
						{Automatic, Null, _},
						Null
					]&,
					{columnPressureProfiles, resolvedInitialHoldTimes, columnFlowRateProfiles}
				];

				(* ColumnFlowRateProfile *)
				(* Resolves to 40, 50, or 20 cm/s for He, H2, or N2 carrierGas respectively *)
				resolvedFlowRateProfiles = MapThread[
					Switch[
						{#1, #2, #3, #4},
						{Except[Automatic], _, _, _},
						#1,
						(* I'm pretty sure this is right but not 100% sure *)
						(* if we have a resolved pressure profile and we're automatic for flow rate, then we can't control the flow rate and the pressure so we have to be Null *)
						{Automatic, _, Except[Null], _},
						Null,
						{Automatic, Except[Null], Null, _},
						{{1 * Milliliter / Minute / Minute, 20 * Milliliter / Minute, 5 * Minute}},
						{Automatic, Null, Null, Null},
						Null,
						{Automatic, Null, Null, _},
						ConstantFlowRate
					]&,
					{columnFlowRateProfiles, resolvedInitialHoldTimes, resolvedPressureProfiles, samples}
				];

				{resolvedInitialAverageVelocities, resolvedInitialFlowRates, resolvedInitialPressures, resolvedInitialResidenceTimes,
					resolvedInitialHoldTimes, resolvedPressureProfiles, resolvedFlowRateProfiles}
				(* === FUNCTION === *)
			]
		],
		{
			{
				specifiedInitialColumnAverageVelocities,
				specifiedInitialColumnFlowRates,
				specifiedInitialColumnPressures,
				specifiedInitialColumnResidenceTimes,
				specifiedInitialColumnSetpointDurations,
				specifiedColumnPressureProfiles,
				specifiedColumnFlowRateProfiles,
				mySamples,
				specifiedInitialOvenTemperatures
			},
			{
				specifiedStandardInitialColumnAverageVelocities,
				specifiedStandardInitialColumnFlowRates,
				specifiedStandardInitialColumnPressures,
				specifiedStandardInitialColumnResidenceTimes,
				specifiedStandardInitialColumnSetpointDurations,
				specifiedStandardColumnPressureProfiles,
				specifiedStandardColumnFlowRateProfiles,
				resolvedStandards,
				specifiedStandardInitialOvenTemperatures
			},
			{
				specifiedBlankInitialColumnAverageVelocities,
				specifiedBlankInitialColumnFlowRates,
				specifiedBlankInitialColumnPressures,
				specifiedBlankInitialColumnResidenceTimes,
				specifiedBlankInitialColumnSetpointDurations,
				specifiedBlankColumnPressureProfiles,
				specifiedBlankColumnFlowRateProfiles,
				resolvedBlanks,
				specifiedBlankInitialOvenTemperatures
			}
		}
	];

	(* resolve post run flow and pressure *)
	{
		{resolvedPostRunFlowRates, resolvedPostRunPressures},
		{resolvedStandardPostRunFlowRates, resolvedStandardPostRunPressures},
		{resolvedBlankPostRunFlowRates, resolvedBlankPostRunPressures}
	} = Map[
		Function[{optionsList},
			Module[{postRunOvenTemperatures, postRunOvenTimes, postRunFlowRates, postRunPressures, initialFlowRates, initialPressures, resolvedPostRunFlows, resolvedPostRunPress, pressureProfiles, flowProfiles},
				{postRunOvenTemperatures, postRunOvenTimes, postRunFlowRates, postRunPressures, initialFlowRates, initialPressures, pressureProfiles, flowProfiles} = optionsList;

				(* Resolve PostRunOvenTemperatures to either the specified or initial value, unless null *)
				resolvedPostRunFlows = MapThread[
					Function[
						{temp, flow, pressure, time, initialFlow, pressureProfile, flowProfile},
						Switch[
							{temp, flow, pressure, time, pressureProfile, flowProfile},
							(* keep option if specified *)
							{_, Except[Automatic], __},
							flow,
							(* null option if nothing else is specified and it's automatic, or if the relevant profile is Null *)
							{Automatic | Null, Automatic, Automatic | Null, Automatic | Null, _, Automatic | Null} | {_, Automatic, _, _, Except[Null], Null},
							Null,
							(* resolve to initial flow rate, presuming that value is not null *)
							{_, Automatic, __},
							initialFlow
						]
					],
					{postRunOvenTemperatures, postRunFlowRates, postRunPressures, postRunOvenTimes, initialFlowRates, pressureProfiles, flowProfiles}
				];

				(* Resolve PostRunOvenTemperatures to either the specified or initial value, unless null *)
				resolvedPostRunPress = MapThread[
					Function[
						{temp, flow, pressure, time, initialPressure, pressureProfile, flowProfile},
						Switch[
							{temp, flow, pressure, time, pressureProfile, flowProfile},
							(* keep option if specified *)
							{_, _, Except[Automatic], __},
							pressure,
							(* null option if nothing else is specified and it's automatic, or if the relevant profile is Null *)
							({Automatic | Null, Automatic | Null, Automatic, Automatic | Null, Automatic | Null, _} | {_, _, Automatic, _, Null, Except[Null]}),
							Null,
							(* resolve to initial pressure, presuming that value is not null *)
							{_, _, Automatic, __},
							initialPressure
						]
					],
					{postRunOvenTemperatures, postRunFlowRates, postRunPressures, postRunOvenTimes, initialPressures, pressureProfiles, flowProfiles}
				];

				(* Return the resolved values *)
				{resolvedPostRunFlows, resolvedPostRunPress}
			]
		],
		{
			{specifiedPostRunOvenTemperatures, specifiedPostRunOvenTimes, specifiedPostRunFlowRates, specifiedPostRunPressures, resolvedInitialColumnFlowRates, resolvedInitialColumnPressures, resolvedColumnPressureProfiles, resolvedColumnFlowRateProfiles},
			{specifiedStandardPostRunOvenTemperatures, specifiedStandardPostRunOvenTimes, specifiedStandardPostRunFlowRates, specifiedStandardPostRunPressures, resolvedStandardInitialColumnFlowRates, resolvedStandardInitialColumnPressures, resolvedStandardColumnPressureProfiles, resolvedStandardColumnFlowRateProfiles},
			{specifiedBlankPostRunOvenTemperatures, specifiedBlankPostRunOvenTimes, specifiedBlankPostRunFlowRates, specifiedBlankPostRunPressures, resolvedBlankInitialColumnFlowRates, resolvedBlankInitialColumnPressures, resolvedBlankColumnPressureProfiles, resolvedBlankColumnFlowRateProfiles}
		}
	];

	(* error check our profiles to make sure they are not broken TODO *)

	(* Resolve the final inlet options that require an approximate residence time of gas in the inlet volume *)
	{
		{
			resolvedInitialColumnFlowRateValues,
			resolvedSplitVentFlowRates,
			resolvedSplitlessTimes,
			resolvedInitialInletPressures,
			resolvedInitialInletTimes,
			resolvedGasSaverActivationTimes
		},
		{
			resolvedStandardInitialColumnFlowRateValues,
			resolvedStandardSplitVentFlowRates,
			resolvedStandardSplitlessTimes,
			resolvedStandardInitialInletPressures,
			resolvedStandardInitialInletTimes,
			resolvedStandardGasSaverActivationTimes
		},
		{
			resolvedBlankInitialColumnFlowRateValues,
			resolvedBlankSplitVentFlowRates,
			resolvedBlankSplitlessTimes,
			resolvedBlankInitialInletPressures,
			resolvedBlankInitialInletTimes,
			resolvedBlankGasSaverActivationTimes
		}
	} = Map[
		Function[{optionsList},
			Module[{resolvedInitialAverageVelocities, resolvedInitialFlowRates, resolvedInitialPressures, resolvedInitialResidenceTimes, initialOvenTemperatures,
				splitVentFlowRates, resolvedModes, splitlessTimes, initialInletPressures, initialInletTimes, gasSaverActivationTimes, gasSavers, resolvedInitialFlowRateValues,
				resolvedPurgeFlowRates, resolvedSplitlessTimesInternal, resolvedPulsedPressures, resolvedPulsedTimes, resolvedGasSaverTimes},
				{ resolvedInitialAverageVelocities, resolvedInitialFlowRates, resolvedInitialPressures, resolvedInitialResidenceTimes, initialOvenTemperatures,
					splitVentFlowRates, resolvedModes, splitlessTimes, initialInletPressures, initialInletTimes, gasSaverActivationTimes, gasSavers} = optionsList;
				(* === FUNCTION === *)
				(* APPROXIMATE THE RESIDENCE TIME IN THE LINER. FOR MULTIPLE COLUMNS THESE VALUES WILL BE WAYYYY OFF, but they are nearly identical to Agilent's software calculated values for a single column *)
				resolvedInitialFlowRateValues = MapThread[
					Function[{averageVelocity, columnFlowRate, columnPressure, columnHolupTime, initialOvenTemperature},
						Switch[
							{averageVelocity, columnFlowRate, columnPressure, columnHolupTime},
							{_Quantity, _, _, _},
							convertColumnVelocityToFlowRate[specifiedCarrierGas, First@columnDiameter, First@columnLength, averageVelocity, initialOvenTemperature, expectedOutletPressure, columnReferencePressure, columnReferenceTemperature],
							{_, _Quantity, _, _},
							columnFlowRate,
							{_, _, _Quantity, _},
							convertColumnPressureToFlowRate[specifiedCarrierGas, First@columnDiameter, First@columnLength, columnPressure, initialOvenTemperature, expectedOutletPressure, columnReferencePressure, columnReferenceTemperature],
							{_, _, _, _Quantity},
							convertColumnResidenceTimeToFlowRate[specifiedCarrierGas, First@columnDiameter, First@columnLength, columnHolupTime, initialOvenTemperature, expectedOutletPressure, columnReferencePressure, columnReferenceTemperature],
							_,
							1.5 * Milliliter / Minute
						]
					],
					{resolvedInitialAverageVelocities, resolvedInitialFlowRates, resolvedInitialPressures, resolvedInitialResidenceTimes, initialOvenTemperatures}
				];

				(* SplitVentFlowRate *)
				(* Resolves to 2*Liner volume/column flowrate if the InletMode is a Splitless type or SolventVent *)
				resolvedPurgeFlowRates = MapThread[
					Switch[
						{#1, #2, #3},
						{Except[Automatic], _, _},
						#1,
						{Automatic, _, (Splitless | PulsedSplitless | SolventVent)},
						20 * #2,
						{Automatic, _, _},
						Null
					]&,
					{splitVentFlowRates, resolvedInitialFlowRateValues, resolvedModes}
				];

				(* SplitlessTime *)
				(* Resolves to 2*Liner volume/column flowrate if the InletMode is a Splitless type *)
				resolvedSplitlessTimesInternal = MapThread[
					Switch[
						{#1, #2, #3},
						{Except[Automatic], _, _},
						#1,
						{Automatic, _, (Splitless | PulsedSplitless | SolventVent)},
						2 * inletLinerVolume / #2,
						{Automatic, _, _},
						Null
					]&,
					{splitlessTimes, resolvedInitialFlowRateValues, resolvedModes}
				];

				(* InitialInletPressure *)
				(* If a pulsed inlet mode is used, resolves to a pressure that doubles the column flowrate (max 100PSI) *)
				resolvedPulsedPressures = MapThread[
					Function[{inletPressure, initialFlowRate, inletMode, initialOvenTemperature},
						Switch[
							{inletPressure, initialFlowRate, inletMode},
							{Except[Automatic], _, _},
							inletPressure,
							{Automatic, _, (PulsedSplitless | PulsedSplit)},
							convertColumnFlowRateToPressure[specifiedCarrierGas, First@columnDiameter, First@columnLength, 2 * initialFlowRate, initialOvenTemperature, expectedOutletPressure, columnReferencePressure, columnReferenceTemperature],
							{Automatic, _, _},
							Null
						]
					],
					{initialInletPressures, resolvedInitialFlowRateValues, resolvedModes, initialOvenTemperatures}
				];

				(* PulsedInjection *)
				(* Resolves to 2*Liner volume/column flowrate if the InletMode is a Pulsed type *)
				resolvedPulsedTimes = MapThread[
					Switch[
						{#1, #2, #3},
						{Except[Automatic], _, _},
						#1,
						{Automatic, _, (PulsedSplitless | PulsedSplit)},
						2 * inletLinerVolume / #2,
						{Automatic, _, _},
						Null
					]&,
					{initialInletTimes, resolvedInitialFlowRateValues, resolvedModes}
				];

				(* GasSaverActivationTime *)
				resolvedGasSaverTimes = MapThread[
					Switch[
						{#1, #2},
						{Except[Automatic], _},
						#1,
						{Automatic, False},
						Null,
						{Automatic, True},
						Switch[
							#3,
							Split,
							2 * Minute,
							Splitless,
							#5 + 1 * Minute,
							PulsedSplit,
							#4 + 1 * Minute,
							PulsedSplitless,
							Max[#4, #5] + 1 * Minute,
							SolventVent,
							Max[#6, #5] + 1 * Minute
						]
					]&,
					{gasSaverActivationTimes, gasSavers, resolvedModes, resolvedPulsedTimes, resolvedSplitlessTimesInternal, initialInletTimes}
				];

				{ resolvedInitialFlowRateValues, resolvedPurgeFlowRates, resolvedSplitlessTimesInternal, resolvedPulsedPressures, resolvedPulsedTimes, resolvedGasSaverTimes }
				(* === FUNCTION === *)
			]
		],
		{
			{
				resolvedInitialColumnAverageVelocities,
				resolvedInitialColumnFlowRates,
				resolvedInitialColumnPressures,
				resolvedInitialColumnResidenceTimes,
				specifiedInitialOvenTemperatures,
				specifiedSplitVentFlowRates,
				specifiedInletModes,
				specifiedSplitlessTimes,
				preresolvedInitialInletPressures,
				preresolvedInitialInletTimes,
				specifiedGasSaverActivationTimes,
				resolvedGasSavers
			},
			{
				resolvedStandardInitialColumnAverageVelocities,
				resolvedStandardInitialColumnFlowRates,
				resolvedStandardInitialColumnPressures,
				resolvedStandardInitialColumnResidenceTimes,
				specifiedStandardInitialOvenTemperatures,
				specifiedStandardSplitVentFlowRates,
				specifiedStandardInletModes,
				specifiedStandardSplitlessTimes,
				preresolvedStandardInitialInletPressures,
				preresolvedStandardInitialInletTimes,
				specifiedStandardGasSaverActivationTimes,
				resolvedStandardGasSavers
			},
			{
				resolvedBlankInitialColumnAverageVelocities,
				resolvedBlankInitialColumnFlowRates,
				resolvedBlankInitialColumnPressures,
				resolvedBlankInitialColumnResidenceTimes,
				specifiedBlankInitialOvenTemperatures,
				specifiedBlankSplitVentFlowRates,
				specifiedBlankInletModes,
				specifiedBlankSplitlessTimes,
				preresolvedBlankInitialInletPressures,
				preresolvedBlankInitialInletTimes,
				specifiedBlankGasSaverActivationTimes,
				resolvedBlankGasSavers
			}
		}
	];




	(* Error check the gas saver parameters *)
	gasSaverConflictTuples = Map[
		Function[opsList,
			Module[
				{
					gasSavers, gasSaverFlowRates, gasSaverActivationTimes, prefix, gasSaverConflicts, conflictingGasSaverOptions, conflictingOptions,
					gasSaverConflictTest
				},
				{gasSavers, gasSaverFlowRates, gasSaverActivationTimes, prefix} = opsList;

				(* Figure out if we have gas saver specified, but no parameters or vice versa *)
				{
					gasSaverConflicts
				} = Transpose@MapThread[
					Function[
						{gasSaver, flowRate, activationTime},

						{
							(MatchQ[gasSaver, True] && (NullQ[flowRate] || NullQ[activationTime])) || (MatchQ[gasSaver, False] && (!NullQ[flowRate] || !NullQ[activationTime]))
						}
					],
					{gasSavers, gasSaverFlowRates, gasSaverActivationTimes}
				];

				(* Gather the options names that are used to specify the gas saver *)
				{
					conflictingGasSaverOptions
				} = MapThread[
					Function[{conflicts, options},
						If[Or @@ conflicts, ToExpression@StringJoin[prefix, #]& /@ options, {}]
					],
					{
						{
							gasSaverConflicts
						},
						{
							{"GasSaver", "GasSaverFlowRate", "GasSaverActivationTime"}
						}
					}
				];

				conflictingOptions = Union[conflictingGasSaverOptions];

				(* If we have conflicts,throw an error *)
				If[!gatherTests,
					If[Or @@ gasSaverConflicts,
						Message[Error::GCGasSaverConflict, prefix],
						Nothing
					];
				];

				(* Gather the tests *)
				gasSaverConflictTest = If[gatherTests,
					Test[prefix <> "Gas saver activation time and flow rate are Null if and only if gas saver is false:",
						Or @@ gasSaverConflicts,
						False
					],
					{}
				];

				(* Format the output *)
				{
					Flatten[{conflictingOptions}],
					Flatten[{gasSaverConflictTest}]
				}

			]
		],
		{
			{resolvedGasSavers, resolvedGasSaverFlowRates, resolvedGasSaverActivationTimes, ""},
			{resolvedStandardGasSavers, resolvedStandardGasSaverFlowRates, resolvedStandardGasSaverActivationTimes, "Standard"},
			{resolvedBlankGasSavers, resolvedBlankGasSaverFlowRates, resolvedBlankGasSaverActivationTimes, "Blank"}
		}
	];

	(* Split the resulting tuples to create error issues *)
	{gasSaverConflictOptions, gasSaverConflictTests} = {Flatten[gasSaverConflictTuples[[All, 1]]], Flatten[gasSaverConflictTuples[[All, 2]]]};


	maxOvenTemperatureSetpoint = Max[Flatten@Join[
		resolvedOvenTemperatureProfileSetpoints, specifiedInitialOvenTemperatures,
		resolvedStandardOvenTemperatureProfileSetpoints, specifiedStandardInitialOvenTemperatures,
		resolvedBlankOvenTemperatureProfileSetpoints, specifiedBlankInitialOvenTemperatures
	] /. {Null -> Nothing}];

	(* get all detector options to do a master switch *)

	fidOptions = {
		FIDTemperature,
		FIDAirFlowRate,
		FIDDihydrogenFlowRate,
		FIDMakeupGas,
		FIDMakeupGasFlowRate,
		CarrierGasFlowCorrection,
		FIDDataCollectionFrequency
	};

	msOptions = {
		TransferLineTemperature,
		IonSource,
		IonMode,
		SourceTemperature,
		QuadrupoleTemperature,
		SolventDelay,
		MassDetectionGain,
		MassRangeThreshold,
		TraceIonDetection,
		AcquisitionWindowStartTime,
		MassRange,
		MassRangeScanSpeed,
		MassSelection,
		MassSelectionResolution,
		MassSelectionDetectionGain
	};

	(* List of options that cannot be Null if the FID is the detector *)
	fidRequiredOptions = {
		FIDTemperature,
		FIDAirFlowRate,
		FIDDihydrogenFlowRate,
		FIDMakeupGas,
		FIDMakeupGasFlowRate,
		CarrierGasFlowCorrection,
		FIDDataCollectionFrequency
	};

	(* List of options that cannot be Null if the MSD is the detector *)
	msRequiredOptions = {
		TransferLineTemperature,
		IonSource,
		IonMode,
		SourceTemperature,
		QuadrupoleTemperature,
		SolventDelay,
		MassDetectionGain,
		MassRangeThreshold,
		TraceIonDetection,
		AcquisitionWindowStartTime,
		MassRange,
		MassRangeScanSpeed,
		MassSelection,
		MassSelectionResolution,
		MassSelectionDetectionGain
	};

	specifiedFIDOptions = {
		specifiedFIDTemperature,
		specifiedFIDAirFlowRate,
		specifiedFIDDihydrogenFlowRate,
		specifiedFIDMakeupGas,
		specifiedFIDMakeupGasFlowRate,
		specifiedCarrierGasFlowCorrection,
		specifiedFIDDataCollectionFrequency
	} = Lookup[roundedGasChromatographyOptions, fidOptions];

	specifiedMSOptions = {
		specifiedTransferLineTemperature,
		specifiedIonSource,
		specifiedIonMode,
		specifiedSourceTemperature,
		specifiedQuadrupoleTemperature,
		specifiedSolventDelay,
		specifiedMassDetectionGain,
		specifiedMassRangeThreshold,
		specifiedTraceIonDetection,
		specifiedAcquisitionWindowStartTime,
		specifiedMassRange,
		specifiedMassRangeScanSpeed,
		specifiedMassSelection,
		specifiedMassSelectionResolution,
		specifiedMassSelectionDetectionGain
	} = Lookup[roundedGasChromatographyOptions, msOptions];

	(* Extract the values of the required options *)
	specifiedRequiredFIDOptions = Lookup[roundedGasChromatographyOptions, fidRequiredOptions];

	specifiedRequiredMSOptions = Lookup[roundedGasChromatographyOptions, msRequiredOptions];

	(* replace any automatics in the unspecified detector with Null so that nothing happens during resolution *)
	Switch[specifiedDetector,
		FlameIonizationDetector,
		{
			specifiedTransferLineTemperature,
			specifiedIonSource,
			specifiedIonMode,
			specifiedSourceTemperature,
			specifiedQuadrupoleTemperature,
			specifiedSolventDelay,
			specifiedMassDetectionGain,
			specifiedMassRangeThreshold,
			specifiedTraceIonDetection,
			specifiedAcquisitionWindowStartTime,
			specifiedMassRange,
			specifiedMassRangeScanSpeed,
			specifiedMassSelection,
			specifiedMassSelectionResolution,
			specifiedMassSelectionDetectionGain
		} = specifiedMSOptions /. {Automatic -> Null},
		MassSpectrometer,
		{
			specifiedFIDTemperature,
			specifiedFIDAirFlowRate,
			specifiedFIDDihydrogenFlowRate,
			specifiedFIDMakeupGas,
			specifiedFIDMakeupGasFlowRate,
			specifiedCarrierGasFlowCorrection,
			specifiedFIDDataCollectionFrequency
		} = specifiedFIDOptions /. {Automatic -> Null}
	];


	(* incompatible detector options - check that we haven't got options specified that aren't compatible with the specified detector *)
	incompatibleDetectorOptionsQ = Which[
		MatchQ[specifiedDetector, FlameIonizationDetector],
		Map[
			MatchQ[#, Except[Null | Automatic | {}]]&,
			specifiedMSOptions
		],
		MatchQ[specifiedDetector, MassSpectrometer],
		Map[
			MatchQ[#, Except[Null | Automatic | {}]]&,
			specifiedFIDOptions
		]
	];

	(* figure out the bad options *)
	incompatibleDetectorOptions = Which[
		MatchQ[specifiedDetector, FlameIonizationDetector],
		PickList[msOptions, incompatibleDetectorOptionsQ, True],
		MatchQ[specifiedDetector, MassSpectrometer],
		PickList[fidOptions, incompatibleDetectorOptionsQ, True]
	];

	(* throw errors if appropriate *)
	If[Or @@ incompatibleDetectorOptionsQ && !gatherTests,
		Message[Error::DetectorOptionsIncompatible, incompatibleDetectorOptions, specifiedDetector]
	];

	(* otherwise we should gather tests *)
	incompatibleDetectorOptionTests = If[gatherTests,
		MapThread[
			Test["If the Detector is " <> ToString[specifiedDetector] <> ", option " <> ToString[#1] <> " is not specified:",
				#2,
				False
			]&,
			{
				Which[
					MatchQ[specifiedDetector, FlameIonizationDetector],
					msOptions,
					MatchQ[specifiedDetector, MassSpectrometer],
					fidOptions
				],
				incompatibleDetectorOptionsQ
			}
		]
	];

	(* incompatible detector options - check that we aren't specifying Null for required detector parameters *)
	incompatibleNullDetectorOptionsQ = Which[
		MatchQ[specifiedDetector, FlameIonizationDetector],
		NullQ /@ specifiedRequiredFIDOptions,
		MatchQ[specifiedDetector, MassSpectrometer],
		NullQ /@ specifiedRequiredMSOptions
	];

	(* figure out the bad options *)
	incompatibleNullDetectorOptions = Which[
		MatchQ[specifiedDetector, FlameIonizationDetector],
		PickList[fidRequiredOptions, incompatibleNullDetectorOptionsQ, True],
		MatchQ[specifiedDetector, MassSpectrometer],
		PickList[msRequiredOptions, incompatibleNullDetectorOptionsQ, True]
	];

	(* throw errors if appropriate *)
	If[Or @@ incompatibleNullDetectorOptionsQ && !gatherTests,
		Message[Error::DetectorOptionsRequired, incompatibleNullDetectorOptions, specifiedDetector]
	];

	(* otherwise we should gather tests *)
	incompatibleNullDetectorOptionTests = If[gatherTests,
		MapThread[
			Test["If the Detector is " <> ToString[specifiedDetector] <> ", option " <> ToString[#1] <> " is not Null:",
				#2,
				False
			]&,
			{
				Which[
					MatchQ[specifiedDetector, FlameIonizationDetector],
					fidRequiredOptions,
					MatchQ[specifiedDetector, MassSpectrometer],
					msRequiredOptions
				],
				incompatibleNullDetectorOptionsQ
			}
		]
	];


	(* FIDTemperature resolves to 300 C or the max oven temperature plus 20 C, up to a maximum of 400C *)
	resolvedFIDTemperature = Switch[
		specifiedFIDTemperature,
		Except[Automatic],
		specifiedFIDTemperature,
		Automatic,
		Min[Max[maxOvenTemperatureSetpoint + 20 * Celsius, 300 * Celsius], 400 * Celsius]
	];

	(* FIDAirFlowRate resolves to set the air/H2 mixture to contain 8.5% H2, otherwise 450 mL/min if H2 flow rate is not specified *)
	resolvedFIDAirFlowRate = Switch[
		{specifiedFIDAirFlowRate, specifiedFIDDihydrogenFlowRate},
		{Except[Automatic], _},
		specifiedFIDAirFlowRate,
		{Automatic, Except[Automatic]},
		specifiedFIDDihydrogenFlowRate / 0.085,
		{Automatic, Automatic},
		450 * Milliliter / Minute
	];

	(* FIDH2FlowRate resolves to 8.5% of the FID air flow rate *)
	resolvedFIDDihydrogenFlowRate = Switch[
		{resolvedFIDAirFlowRate, specifiedFIDDihydrogenFlowRate},
		{_, Except[Automatic]},
		specifiedFIDDihydrogenFlowRate,
		{_Quantity, Automatic},
		Round[resolvedFIDAirFlowRate * 0.085]
	];

	(* FIDMakeupGasFlowRate resolves to 9% of the total air and fuel flow *)
	resolvedFIDMakeupGasFlowRate = Switch[
		specifiedFIDMakeupGasFlowRate,
		Except[Automatic],
		specifiedFIDMakeupGasFlowRate,
		Automatic,
		Round[(resolvedFIDAirFlowRate + resolvedFIDDihydrogenFlowRate) * 0.09]
	];

	(* FIDMakeupGasFlowRate resolves to 9% of the total air and fuel flow *)
	resolvedFIDMakeupGas = Switch[
		specifiedFIDMakeupGas,
		Except[Automatic],
		specifiedFIDMakeupGas,
		Automatic,
		Helium
	];

	(* CarrierGasFlowCorrection resolves to None *)
	resolvedCarrierGasFlowCorrection = Switch[
		specifiedCarrierGasFlowCorrection,
		Except[Automatic],
		specifiedCarrierGasFlowCorrection,
		Automatic,
		None
	];

	(* CarrierGasFlowCorrection resolves to None *)
	resolvedFIDDataCollectionFrequency = Switch[
		specifiedFIDDataCollectionFrequency,
		Except[Automatic],
		specifiedFIDDataCollectionFrequency,
		Automatic,
		20 * Hertz
	];

	(* === Resolve MS Options === *)

	(* transfer line temperature *)
	resolvedTransferLineTemperature = Switch[
		specifiedTransferLineTemperature,
		Except[Automatic],
		specifiedTransferLineTemperature,
		Automatic,
		Min[maxOvenTemperatureSetpoint + 20 * Celsius, 300 * Celsius]
	];

	(* resolved ionization mode *)
	resolvedIonSource = Switch[
		specifiedIonSource,
		Except[Automatic],
		specifiedIonSource,
		Automatic,
		ElectronIonization
	];

	resolvedIonMode = Switch[
		specifiedIonMode,
		Except[Automatic],
		specifiedIonMode,
		Automatic,
		Positive
	];

	(* source temperature *)
	resolvedSourceTemperature = Switch[
		specifiedSourceTemperature,
		Except[Automatic],
		specifiedSourceTemperature,
		Automatic,
		Switch[
			resolvedIonSource,
			ElectronIonization,
			230 * Celsius,
			ChemicalIonization,
			250 * Celsius
		]
	];

	(* quad tempe *)
	resolvedQuadrupoleTemperature = Switch[
		specifiedQuadrupoleTemperature,
		Except[Automatic],
		specifiedQuadrupoleTemperature,
		Automatic,
		150 * Celsius
	];

	(* solvent delay todo: improve logic here but no idea how, we need a scouting run to determine solvent elution times *)
	resolvedSolventDelay = Switch[
		specifiedSolventDelay,
		Except[Automatic],
		specifiedSolventDelay,
		Automatic,
		3 * Minute
	];

	(* gain factor *)
	resolvedMassDetectionGain = Switch[
		specifiedMassDetectionGain,
		Except[Automatic],
		specifiedMassDetectionGain,
		Automatic,
		2.0
	];

	resolvedTraceIonDetection = Switch[
		specifiedTraceIonDetection,
		Except[Automatic],
		specifiedTraceIonDetection,
		Automatic,
		False
	];

	massRangeSpecifiedQ = MemberQ[Flatten@{specifiedMassRange, specifiedMassRangeScanSpeed}, Except[Automatic | Null | {} | {Null}]];

	numberOfMassRanges = If[massRangeSpecifiedQ,
		Max[Sequence @@ (Length /@ (ToList /@ {specifiedAcquisitionWindowStartTime, specifiedMassRangeScanSpeed})), If[Depth[specifiedMassRange] > 2, Length[specifiedMassRange], 1]],
		(* hypothetically we need to have at least 1 mass range to use the mass spec. if nothing is specified then all the options are being resolved automatically so it's still possible to require a length of 1 here *)
		If[MatchQ[specifiedDetector, MassSpectrometer], 1, 0]
	];

	simOptionsSpecifiedQ = MemberQ[Flatten@{specifiedMassSelection, specifiedMassSelectionResolution, specifiedMassSelectionDetectionGain}, Except[Automatic | Null | {} | {Null}]];

	numberOfSIMGroups = If[simOptionsSpecifiedQ,
		Max[Sequence @@ (Length /@ (ToList /@ {specifiedMassSelection, specifiedMassSelectionResolution, specifiedMassSelectionDetectionGain})), If[Depth[specifiedMassSelection] > 2, Length[specifiedMassSelection], 1]],
		(* hypothetically we need to have at least 1 mass range to use the mass spec. if nothing is specified then all the options are being resolved automatically so it's still possible to require a length of 1 here *)
		If[MatchQ[specifiedDetector, MassSpectrometer], 1, 0]
	];

	resolvedAcquisitionWindowStartTime = Which[
		MatchQ[specifiedDetector, Except[MassSpectrometer]] || NullQ[specifiedAcquisitionWindowStartTime],
		Null,
		MatchQ[specifiedAcquisitionWindowStartTime, Automatic] && !massRangeSpecifiedQ && !simOptionsSpecifiedQ,
		ToList@resolvedSolventDelay,
		True,
		FoldList[
			(* we need to build up the list of acquisition window start times to the maximum of the length of the number of mass ranges or sim groups *)
			(* here we are going to FoldList over the expanded list of specified start times. the first time can't be shorter than the solvent delay so if the specified start time is automatic, make it the solvent delay. If we encounter another automatic in the list, just add 3 minutes to the previous time *)
			(* FoldList[f,x,{a,b,c}] returns {x,f[x,a], f[f[x,a],b,...}. here, x is the first of the acquisition windows which may be resolved to the solvent delay. we check the next value in the start time list. if it is automatic, we just add 3 minutes. if it is a time, use that time *)
			If[MatchQ[#2, Automatic], #1 + 3 * Minute, #2] &,
			FirstOrDefault[specifiedAcquisitionWindowStartTime, specifiedAcquisitionWindowStartTime] /. {Automatic -> resolvedSolventDelay},
			Rest[PadRight[ToList@specifiedAcquisitionWindowStartTime, Max[numberOfMassRanges, numberOfSIMGroups, Length[specifiedAcquisitionWindowStartTime]], Automatic]]]
	];

	(* mass range options *)
	{resolvedMassRange, resolvedMassRangeScanSpeed, resolvedMassRangeThreshold} = MapThread[
		Function[{option, optionDefault},
			Switch[
				option,
				Except[Automatic],
				Which[
					(* If we're not using the mass spec detector, these should be Null *)
					!MatchQ[specifiedDetector, MassSpectrometer],
					Null,

					Length[option] == 0,
					ConstantArray[option, Max[numberOfMassRanges, numberOfSIMGroups, Length[resolvedAcquisitionWindowStartTime]]],

					True,
					option
				],
				Automatic,
				Switch[{massRangeSpecifiedQ, simOptionsSpecifiedQ},
					(* MS must be specified to get here so if nothing is specified start with a mass range *)
					({False, False} | {True, _}),
					PadRight[ToList@option, Max[numberOfMassRanges, numberOfSIMGroups, Length[resolvedAcquisitionWindowStartTime]], Automatic] /. {Automatic -> optionDefault},
					{False, _},
					PadRight[ToList@option, Max[numberOfMassRanges, numberOfSIMGroups, Length[resolvedAcquisitionWindowStartTime]], Null]
				]
			]
		],
		{
			{specifiedMassRange, specifiedMassRangeScanSpeed, specifiedMassRangeThreshold},
			{{80, 250}, 781, 0}
		}
	];

	(* SIM mass options *)
	{resolvedMassSelection, resolvedMassSelectionResolution, resolvedMassSelectionDetectionGain} = MapThread[
		Function[{option, optionDefault},
			Switch[
				option,
				Automatic,
				Switch[{simOptionsSpecifiedQ, massRangeSpecifiedQ},
					(* MS must be specified to get here so if nothing is specified start with thing *)
					{False, False},
					PadRight[ToList@option, Max[numberOfMassRanges, numberOfSIMGroups, Length[resolvedAcquisitionWindowStartTime]], Null] /. {Automatic -> Null},
					{True, _},
					PadRight[ToList@option, Max[numberOfMassRanges, numberOfSIMGroups, Length[resolvedAcquisitionWindowStartTime]], Automatic] /. {Automatic -> optionDefault},
					{False, _},
					PadRight[ToList@option, Max[numberOfMassRanges, numberOfSIMGroups, Length[resolvedAcquisitionWindowStartTime]], Null] /. {Automatic -> Null}
				],
				Except[Automatic],
				Which[
					(* If we're not using the mass spec detector, these should be Null *)
					!MatchQ[specifiedDetector, MassSpectrometer],
					Null,

					Length[option] == 0,
					ConstantArray[option, Max[numberOfMassRanges, numberOfSIMGroups, Length[resolvedAcquisitionWindowStartTime]]],

					True,
					option
				]
			]
		],
		{
			{specifiedMassSelection, specifiedMassSelectionResolution, specifiedMassSelectionDetectionGain},
			{{250, 100 * Milli * Second}, Low, resolvedMassDetectionGain}
		}
	];

	(* === Resolve LinerORing, InletSeptum === *)

	{specifiedLinerORing, specifiedInletSeptum} = Lookup[roundedGasChromatographyOptions, {LinerORing, InletSeptum}];

	(* == check for compatible O-rings and septa == *)

	maxInletTemperatureSetpoint = Max[
		Flatten@Join[
			resolvedInletTemperatureProfileSetpoints, specifiedInitialInletTemperatureSetpoints
		] /. {Null -> Nothing}
	];

	(* is the specified ORing compatible with the instrument *)
	(* first extract the ORing packet *)
	oRingPacket = If[MatchQ[specifiedLinerORing, Except[Automatic]], fetchPacketFromCache[specifiedLinerORing, cache], {}];

	(*Look up ORing parameters*)
	oRingParameters = If[MatchQ[specifiedLinerORing, ObjectP[Model[Item, ORing]]],
		Lookup[fetchPacketFromCache[specifiedLinerORing, cache], {InnerDiameter, OuterDiameter, MaxTemperature}],
		Lookup[fetchPacketFromCache[Lookup[oRingPacket, Model], cache], {InnerDiameter, OuterDiameter, MaxTemperature}]
	];

	(* check if all the ORing parameters fall in the allowed range*)
	compatibleORingQ = If[
		Or[
			MatchQ[specifiedLinerORing, Automatic],
			MatchQ[
				oRingParameters,
				{RangeP[6.3 Millimeter, 6.5 Millimeter], RangeP[10 Millimeter, 11 Millimeter], GreaterEqualP[maxInletTemperatureSetpoint]}
			]
		],
		True,
		False
	];

	(* Throw error/create tests if not *)
	incompatibleORing = If[!TrueQ[compatibleORingQ],
		If[!gatherTests, Message[Error::GCORingNotCompatible, specifiedLinerORing, specifiedInstrument, "6.4 mm +/-0.1 mm", "10.5 mm +/-0.5 mm", maxInletTemperatureSetpoint]];
		LinerORing,
		{}
	];

	(* generate a test *)
	compatibleORingTest = If[gatherTests,
		Test["The specified ORing has inner diameter of 6.4 mm +/- 0.1 mm, outer diameter of 10.5 mm +/- 0.5 mm, and can withstand the specified inlet temperatures:",
			compatibleORingQ,
			True
		]
	];


	(*First extract the septum packet*)
	septumPacket = If[MatchQ[specifiedInletSeptum, Except[Automatic]], fetchPacketFromCache[specifiedInletSeptum, cache], {}];

	(*Look up septum parameters*)
	septumParameters = If[MatchQ[specifiedInletSeptum, ObjectP[Model[Item, Septum]]],
		Lookup[fetchPacketFromCache[specifiedInletSeptum, cache], {Diameter, Thickness, MaxTemperature}],
		Lookup[fetchPacketFromCache[Lookup[septumPacket, Model], cache], {Diameter, Thickness, MaxTemperature}]
	];

	(* is the specified Septum compatible with the instrument *)
	compatibleSeptumQ = If[
		Or[
			MatchQ[specifiedInletSeptum, Automatic],
			MatchQ[
				septumParameters,
				{EqualP[11 Millimeter], RangeP[2 Millimeter, 4 Millimeter], GreaterEqualP[maxInletTemperatureSetpoint]}
			]
		],
		True,
		False
	];

	(* Throw error/create tests if not *)
	incompatibleSeptum = If[!TrueQ[compatibleSeptumQ],
		If[!gatherTests, Message[Error::GCSeptumNotCompatible, ToString@specifiedInletSeptum, ToString@specifiedInstrument, "11 mm", "2 mm", ToString@maxInletTemperatureSetpoint]];
		InletSeptum,
		{}
	];

	(* generate a test *)
	compatibleSeptumTest = If[gatherTests,
		Test["The specified septum has a diameter of 11 mm, thickness greater than 2 mm, and can withstand the specified inlet temperatures:",
			compatibleSeptumQ,
			True
		]
	];

	{resolvedLinerORing, resolvedInletSeptum} = If[maxInletTemperatureSetpoint < 350 * Celsius,
		(* fluorocarbon O-ring, advanced Green septum *)
		{specifiedLinerORing /. {Automatic -> Model[Item, ORing, "id:01G6nvwpLBZE"]}, specifiedInletSeptum /. {Automatic -> Model[Item, Septum, "id:XnlV5jKAYJZ8"]}},
		(* graphite O-ring, BTO septum *)
		{specifiedLinerORing /. {Automatic -> Model[Item, ORing, "id:01G6nvwpLBLK"]}, specifiedInletSeptum /. {Automatic -> Model[Item, Septum, "id:Z1lqpMz8PWe9"]}}
	];

	(* === Resolve ColumnConditioningTemperature === *)

	{conditionColumnQ, specifiedColumnConditioningTemperature, specifiedColumnConditioningTime} = Lookup[roundedGasChromatographyOptions, {ConditionColumn, ColumnConditioningTemperature, ColumnConditioningTime}];

	(* === Resolve ColumnConditioningGas === *)

	resolvedColumnConditioningGas = Switch[specifiedCarrierGas,
		Except[Automatic],
		specifiedCarrierGas,
		Automatic,
		If[
			conditionColumnQ,
			Helium,
			Null
		]
	];

	(* Choose the minimum of the max oven temp + 20 K and the max column temperature *)
	resolvedColumnConditioningTemperature = Switch[
		specifiedColumnConditioningTemperature,
		Except[Automatic],
		specifiedColumnConditioningTemperature,
		Automatic,
		If[
			conditionColumnQ,
			Min[maxOvenTemperatureSetpoint + 20 * Celsius, maxColumnTempLimit],
			Null
		]
	];

	(* === Resolve ColumnConditioningTime === *)

	(* SortBy Polarity *)
	maxColumnPolarity = Last@SortBy[columnPolarity, Switch[#, NonPolar, 1, Intermediate, 2, Polar, 3] &];

	(* Total column length *)
	totalColumnLength = Total[columnLength];

	(* thickest film thickness *)
	maxFilmThickness = Max[columnFilmThickness];

	(* Apply table logic *)
	resolvedColumnConditioningTime = Switch[specifiedColumnConditioningTime,
		Automatic,
		If[conditionColumnQ,
			Switch[
				maxColumnPolarity,
				NonPolar,
				Switch[
					totalColumnLength,
					LessP[30 * Meter],
					Switch[
						maxFilmThickness,
						LessP[0.5 * Micrometer],
						15 * Minute,
						Null | RangeP[0.5 * Micrometer, 1.0 * Micrometer],
						30 * Minute,
						GreaterP[1.0 * Micrometer],
						60 * Minute
					],
					Null | RangeP[30 * Meter, 60 * Meter],
					Switch[
						maxFilmThickness,
						LessP[0.5 * Micrometer],
						30 * Minute,
						Null | RangeP[0.5 * Micrometer, 1.0 * Micrometer],
						45 * Minute,
						GreaterP[1.0 * Micrometer],
						60 * Minute
					],
					GreaterP[60 * Meter],
					Switch[
						maxFilmThickness,
						LessP[0.5 * Micrometer],
						60 * Minute,
						Null | RangeP[0.5 * Micrometer, 1.0 * Micrometer],
						90 * Minute,
						GreaterP[1.0 * Micrometer],
						120 * Minute
					]
				],
				Null | Intermediate,
				Switch[
					totalColumnLength,
					LessP[30 * Meter],
					Switch[
						maxFilmThickness,
						LessP[0.5 * Micrometer],
						20 * Minute,
						Null | RangeP[0.5 * Micrometer, 1.0 * Micrometer],
						40 * Minute,
						GreaterP[1.0 * Micrometer],
						60 * Minute
					],
					Null | RangeP[30 * Meter, 60 * Meter],
					Switch[
						maxFilmThickness,
						LessP[0.5 * Micrometer],
						40 * Minute,
						Null | RangeP[0.5 * Micrometer, 1.0 * Micrometer],
						60 * Minute,
						GreaterP[1.0 * Micrometer],
						80 * Minute
					],
					GreaterP[60 * Meter],
					Switch[
						maxFilmThickness,
						LessP[0.5 * Micrometer],
						80 * Minute,
						Null | RangeP[0.5 * Micrometer, 1.0 * Micrometer],
						120 * Minute,
						GreaterP[1.0 * Micrometer],
						160 * Minute
					]
				],
				Polar,
				Switch[
					totalColumnLength,
					LessP[30 * Meter],
					Switch[
						maxFilmThickness,
						LessP[0.5 * Micrometer],
						30 * Minute,
						Null | RangeP[0.5 * Micrometer, 1.0 * Micrometer],
						45 * Minute,
						GreaterP[1.0 * Micrometer],
						60 * Minute
					],
					Null | RangeP[30 * Meter, 60 * Meter],
					Switch[
						maxFilmThickness,
						LessP[0.5 * Micrometer],
						60 * Minute,
						Null | RangeP[0.5 * Micrometer, 1.0 * Micrometer],
						90 * Minute,
						GreaterP[1.0 * Micrometer],
						120 * Minute
					],
					GreaterP[60 * Meter],
					Switch[
						maxFilmThickness,
						LessP[0.5 * Micrometer],
						80 * Minute,
						Null | RangeP[0.5 * Micrometer, 1.0 * Micrometer],
						120 * Minute,
						GreaterP[1.0 * Micrometer],
						160 * Minute
					]
				]
			],
			Null
		],
		Except[Automatic],
		specifiedColumnConditioningTime
	];

	(* make sure that either all options are specified or none are *)
	columnConditionOptionsConflictQ = Switch[
		{conditionColumnQ, resolvedColumnConditioningGas, resolvedColumnConditioningTemperature, resolvedColumnConditioningTime},
		{True, Except[Null | Automatic], Except[Null | Automatic], Except[Null | Automatic]} | {False, Null, Null, Null},
		False,
		_,
		True
	];

	(* make sure conditioning temperature is not over the limit of the column *)
	{conditioningTemperatureTooHighQ, conditioningTemperatureTooLowQ} = {
		If[TrueQ[resolvedColumnConditioningTemperature > maxColumnTempLimit],
			True,
			False
		],
		If[TrueQ[resolvedColumnConditioningTemperature < minColumnTempLimit],
			True,
			False
		]};

	(* if we have a conflict, figure out the conflicting options *)
	conflictingColumnConditioningOptions = Union[
		MapThread[
			If[(conditionColumnQ && MatchQ[#1, Null]) || (!conditionColumnQ && MatchQ[#1, Except[Null]]),
				#2,
				Nothing
			]&,
			{
				{resolvedColumnConditioningGas, resolvedColumnConditioningTemperature, resolvedColumnConditioningTime},
				{ColumnConditioningGas, ColumnConditioningTemperature, ColumnConditioningTime}
			}
		],
		If[Or[conditioningTemperatureTooHighQ, conditioningTemperatureTooLowQ],
			{ColumnConditioningTemperature},
			{}
		]
	];

	(* throw a message *)
	If[!gatherTests,
		Which[
			columnConditionOptionsConflictQ && conditionColumnQ,
			Message[Error::ColumnConditioningOptionsConflict, conditionColumnQ, conflictingColumnConditioningOptions, " not "],
			columnConditionOptionsConflictQ && !conditionColumnQ,
			Message[Error::ColumnConditioningOptionsConflict, conditionColumnQ, conflictingColumnConditioningOptions, " "]
		]
	];

	(* create tests *)
	conditionColumnTests = If[gatherTests,
		MapThread[
			Test["Option " <> ToString[#2] <> " is only specified if ConditionColumn is True, otherwise it is Null:",
				(conditionColumnQ && MatchQ[#1, Null]) || (!conditionColumnQ && MatchQ[#1, Except[Null]]),
				False
			]&,
			{
				{resolvedColumnConditioningGas, resolvedColumnConditioningTemperature, resolvedColumnConditioningTime},
				{ColumnConditioningGas, ColumnConditioningTemperature, ColumnConditioningTime}
			}
		],
		{}
	];

	(* throw errors if we should *)
	If[!gatherTests,
		If[conditioningTemperatureTooHighQ,
			Message[Error::GCColumnMaxTemperatureExceeded, resolvedColumnConditioningTemperature, ColumnConditioningTemperature, maxColumnTempLimit]
		];
		If[conditioningTemperatureTooLowQ,
			Message[Warning::GCColumnMinTemperatureExceeded, resolvedColumnConditioningTemperature, ColumnConditioningTemperature, minColumnTempLimit]
		]
	];

	(* === Resolve ColumnConditioningFlowRate === *)

	(* Get specifiedColumnConditioningGasFlowRate *)
	specifiedColumnConditioningGasFlowRate = Lookup[roundedGasChromatographyOptions, ColumnConditioningGasFlowRate];

	(* get maxColumnDiameter *)
	maxColumnDiameter = Max[columnDiameter];

	(* Pick the flow rate from the table *)
	resolvedColumnConditioningGasFlowRate = If[
		conditionColumnQ,
		Switch[
			specifiedColumnConditioningGasFlowRate,
			(_Quantity | Null),
			specifiedColumnConditioningGasFlowRate,
			Automatic,
			Switch[
				maxColumnDiameter,
				LessP[0.2 * Millimeter],
				1 * Milliliter / Minute,
				RangeP[0.2 * Millimeter, 0.3 * Millimeter],
				1.5 * Milliliter / Minute,
				RangeP[0.3 * Millimeter, 0.45 * Millimeter],
				2 * Milliliter / Minute,
				GreaterP[0.45 * Millimeter],
				6 * Milliliter / Minute
			]
		],
		Null
	];

	(* Resolve the standard/blank amounts and containers *)

	(* we need to check the Standard and Blank containers for an actual need to aliquot *)

	{resolvedStandardVials, resolvedStandardAmounts} = Transpose@MapThread[
		Function[{aliquotQ, vial, amount, resolvedVial, resolvedAmount},
			MapThread[
				Function[{specifiedOption, resolvedOption},
					If[aliquotQ,
						specifiedOption /. {Automatic -> resolvedOption},
						specifiedOption /. {Automatic -> Null}
					]
				],
				{
					{vial, amount},
					{resolvedVial, resolvedAmount}
				}
			]
		],
		{aliquotStandardQ, specifiedStandardVials, specifiedStandardAmounts, targetStandardVials, requiredStandardAliquotAmounts}
	];

	{resolvedBlankVials, resolvedBlankAmounts} = Transpose@MapThread[
		Function[{aliquotQ, vial, amount, resolvedVial, resolvedAmount},
			MapThread[
				Function[{specifiedOption, resolvedOption},
					If[aliquotQ,
						specifiedOption /. {Automatic -> resolvedOption},
						specifiedOption /. {Automatic -> Null}
					]
				],
				{
					{vial, amount},
					{resolvedVial, resolvedAmount}
				}
			]
		],
		{aliquotBlankQ, specifiedBlankVials, specifiedBlankAmounts, targetBlankVials, requiredBlankAliquotAmounts}
	];

	(* we need to error check that we don't have any misconfigured combinations of Vial/Amount *)
	(* 1. compatible vial check: can be similar to aliquot check *)
	(* 2. Object -> vial/amount optional, Model -> vial/amount required, NoInjection -> vial/amount not allowed *)
	standardBlankTransferErrorTuples = Map[
		Function[{opsList},
			Module[
				{prefix, samples, vials, amounts, missingVials, missingAmounts, unneededVials, unneededAmounts, mismatchedVialsandAmounts, badOptions, tests, aliquotQ,
					compatibleVialQ, incompatibleContainers, compatibleCurrentContainerQ, sampleShouldHaveBeenAliquotedQ, needsAliquotSamples},
				{samples, vials, amounts, aliquotQ, prefix} = opsList;

				(* determine if there are any incompatible vials present in these options *)
				{compatibleVialQ, compatibleCurrentContainerQ} = Transpose@MapThread[
					Function[{vial, sample},
						{
							(* check the target vial (aliquot must be true) *)
							If[NullQ[vial],
								True,
								(* if a vial is specified, verify that it is compatible *)
								Module[{footprint, neckType},
									(* get the relevant fields from the simulated cache *)
									{footprint, neckType} = If[!NullQ[vial],
										Switch[
											vial,
											ObjectP[Object[Container, Vessel]],
											Download[vial, Model[{Footprint, NeckType}], Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
											ObjectP[Model[Container, Vessel]],
											Download[vial, {Footprint, NeckType}, Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
											_,
											{Null, Null}
										],
										{Null, Null}
									];
									(* check if the vial is compatible *)
									MatchQ[
										{footprint, neckType},
										Alternatives[
											(* small GC vials *)
											{CEVial, "9/425"},
											(* larger headspace vials *)
											{HeadspaceVial, "18/425"}
										]
									]
								]
							],
							(* check the current container only if it's an object *)
							If[!MatchQ[sample, ObjectP[Object[Sample]]],
								True,
								(* if a vial is specified, verify that it is compatible *)
								Module[{footprint, neckType},
									(* get the relevant fields from the simulated cache *)
									{footprint, neckType} = Download[sample, Container[Model][{Footprint, NeckType}],Cache -> cache, Simulation -> updatedSimulation, Date -> Now];
									(* check if the vial is compatible *)
									MatchQ[
										{footprint, neckType},
										Alternatives[
											(* small GC vials *)
											{CEVial, "9/425"},
											(* larger headspace vials *)
											{HeadspaceVial, "18/425"}
										]
									]
								]
							]
						}
					],
					{vials, samples}
				];

				(* figure out which containers are bad *)
				incompatibleContainers = DeleteDuplicates@PickList[vials /. {x : ObjectP[] :> Download[x, Object]}, compatibleVialQ, False];

				(* determine if the sample in its current container should have been aliquoted but wasn't *)
				sampleShouldHaveBeenAliquotedQ = MapThread[
					Function[{vial, compatibleCurrentContainer},
						(* the target vial is Null but the current container is incompatible *)
						NullQ[vial] && !compatibleCurrentContainer
					],
					{vials, compatibleCurrentContainerQ}
				];

				(* these are the samples that are not in compatible containers but for whatever reason someone explicitly set Vial->Null *)
				needsAliquotSamples = DeleteDuplicates@PickList[samples /. {x : ObjectP[] :> Download[x, Object]}, sampleShouldHaveBeenAliquotedQ, True];

				(* figure out if we have any partially specified sample/blank aliquots *)
				{missingVials, missingAmounts} = Transpose@MapThread[
					Function[{sample, vial, amount, aliquot},
						Which[
							MatchQ[sample, ObjectP[Model[]]],
							(* if we have selected a model, we have a "missing" if either are not specified *)
							{
								MatchQ[vial, Null],
								MatchQ[amount, Null]
							},
							MatchQ[sample, ObjectP[Object[]]],
							(* if we have selected an object, we have a "missing" if either are not specified but the aliquot boolean is true *)
							{
								MatchQ[vial, Null] && aliquot,
								MatchQ[amount, Null] && aliquot
							},
							MatchQ[sample, NoInjection | Null],
							(* if the sample is NoInjection or Null, we can't be missing what's not allowed, or if an object is selected there's no requirement *)
							{
								False,
								False
							}
						]
					],
					{samples, vials, amounts, aliquotQ}
				];

				(* also figure out if we have any specified sample/blank aliquots that shouldn't be specified *)
				{unneededVials, unneededAmounts} = Transpose@MapThread[
					Function[{sample, vial, amount},
						Which[
							MatchQ[sample, ObjectP[]],
							(* if we have selected an object or model, we will assume that nothing is unneeded *)
							{
								False,
								False
							},
							MatchQ[sample, NoInjection | Null],
							(* if the sample is NoInjection or Null, anything specified is unneeded *)
							{
								!MatchQ[vial, Null],
								!MatchQ[amount, Null]
							}
						]
					],
					{samples, vials, amounts}
				];

				(* also figure out if we have any specified sample/blank aliquots that shouldn't be specified *)
				mismatchedVialsandAmounts = MapThread[
					Function[{sample, vial, amount},
						Which[
							MatchQ[sample, ObjectP[Object[]]],
							(* if we have selected an object, mismatch if one and the other are not the same, but we can't make a judgement *)
							Or[
								MatchQ[vial, Null] && !MatchQ[amount, Null],
								!MatchQ[vial, Null] && MatchQ[amount, Null]
							],
							MatchQ[sample, NoInjection | Null | ObjectP[Model[]]],
							(* if the sample is NoInjection or Null, or a Model, we can make a judgement as above *)
							False
						]
					],
					{samples, vials, amounts}
				];

				(* now we need to throw any number of different errors and gather the bad options: *)
				badOptions = DeleteDuplicates[
					Flatten[
						If[!gatherTests,
							{
								If[Or @@ missingVials,
									Message[Error::GCUnspecifiedVials, prefix];
									prependSymbol[Vial, prefix],
									Nothing
								],
								If[Or @@ missingAmounts,
									Message[Error::GCUnspecifiedAmounts, prefix];
									prependSymbol[Amount, prefix],
									Nothing
								],
								If[Or @@ unneededVials,
									Message[Error::GCUnneededVials, prefix];
									prependSymbol[Vial, prefix],
									Nothing
								],
								If[Or @@ unneededAmounts,
									Message[Error::GCUnneededAmounts, prefix];
									prependSymbol[Amount, prefix],
									Nothing
								],
								If[Or @@ mismatchedVialsandAmounts,
									Message[Error::GCMismatchedVialsAndAmounts, prefix];
									prependSymbol[{Vial, Amount}, prefix],
									Nothing
								],
								If[Nand @@ compatibleVialQ,
									Message[Error::GCContainerIncompatible, prefix <> "Vial", incompatibleContainers];
									prependSymbol[Vial, prefix],
									Nothing
								],
								If[Length[needsAliquotSamples] > 0,
									Message[Error::GCStandardBlankContainer, prefix, needsAliquotSamples];
									ToExpression[prefix],
									Nothing
								]
							},
							{}
						]
					]
				];

				(* create relevant tests *)
				tests = Flatten[
					If[gatherTests,
						{
							Test["If " <> prefix <> "s are specified that must be aliquoted into a GC-compatible container, a " <> prefix <> "Vial is specified for each of these " <> prefix <> "s:",
								Or @@ missingVials,
								False],
							Test["If " <> prefix <> "s are specified that must be aliquoted into a GC-compatible container, a " <> prefix <> "Amount is specified for each of these " <> prefix <> "s:",
								Or @@ missingAmounts,
								False],
							Test["If " <> prefix <> "s are Null or have Blank type NoInjection, no " <> prefix <> "Vial is specified for each of these " <> prefix <> "s:",
								Or @@ unneededVials,
								False],
							Test["If " <> prefix <> "s are Null or have Blank type NoInjection, no " <> prefix <> "Amount is specified for each of these " <> prefix <> "s:",
								Or @@ unneededAmounts,
								False],
							Test["If " <> prefix <> "s are specified that require Objects as inputs, either both a " <> prefix <> "Vial and a " <> prefix <> "Amount or neither is specified for each of these " <> prefix <> "s:",
								Or @@ mismatchedVialsandAmounts,
								False],
							Test["If " <> prefix <> "Vials are specified, they must have {Footprint,NeckType} of {CEVial,9/425} or {HeadspaceVial,18/425}:",
								And @@ compatibleVialQ,
								True],
							Test["Any " <> prefix <> "s in GC-incompatible containers have a " <> prefix <> "Vial specified:",
								Length[needsAliquotSamples] > 0,
								False
							]
						},
						{}
					]
				];

				(*return everything*)
				Flatten /@ {badOptions, tests}
			]
		],
		{
			{resolvedStandards, resolvedStandardVials, resolvedStandardAmounts, aliquotStandardQ, "Standard"},
			{resolvedBlanks, resolvedBlankVials, resolvedBlankAmounts, aliquotBlankQ, "Blank"}
		}
	];

	(* split out from the error checking *)
	{standardBlankTransferErrorOptions, standardBlankTransferErrorTests} = Flatten /@ {standardBlankTransferErrorTuples[[All, 1]], standardBlankTransferErrorTuples[[All, 2]]};

	(* "resolve" the SeparationMethods used herein *)
	{resolvedSeparationMethods, resolvedStandardSeparationMethods, resolvedBlankSeparationMethods} = {
		Transpose@{
			specifiedInletSeptumPurgeFlowRates,
			resolvedInitialInletTemperatures,
			resolvedInitialInletTemperatureDurations,
			resolvedInletTemperatureProfiles,
			resolvedSplitRatios,
			resolvedSplitVentFlowRates,
			resolvedSplitlessTimes,
			resolvedInitialInletPressures,
			resolvedInitialInletTimes,
			resolvedGasSavers,
			resolvedGasSaverFlowRates,
			resolvedGasSaverActivationTimes,
			resolvedSolventEliminationFlowRates,
			resolvedInitialColumnFlowRates,
			resolvedInitialColumnPressures,
			resolvedInitialColumnAverageVelocities,
			resolvedInitialColumnResidenceTimes,
			resolvedInitialColumnSetpointDurations,
			resolvedColumnPressureProfiles,
			resolvedColumnFlowRateProfiles,
			resolvedOvenEquilibrationTimes,
			specifiedInitialOvenTemperatures,
			specifiedInitialOvenTemperatureDurations,
			resolvedOvenTemperatureProfiles,
			resolvedPostRunOvenTemperatures,
			resolvedPostRunOvenTimes,
			resolvedPostRunFlowRates,
			resolvedPostRunPressures
		},
		Transpose@{
			specifiedStandardInletSeptumPurgeFlowRates,
			resolvedStandardInitialInletTemperatures,
			resolvedStandardInitialInletTemperatureDurations,
			resolvedStandardInletTemperatureProfiles,
			resolvedStandardSplitRatios,
			resolvedStandardSplitVentFlowRates,
			resolvedStandardSplitlessTimes,
			resolvedStandardInitialInletPressures,
			resolvedStandardInitialInletTimes,
			resolvedStandardGasSavers,
			resolvedStandardGasSaverFlowRates,
			resolvedStandardGasSaverActivationTimes,
			resolvedStandardSolventEliminationFlowRates,
			resolvedStandardInitialColumnFlowRates,
			resolvedStandardInitialColumnPressures,
			resolvedStandardInitialColumnAverageVelocities,
			resolvedStandardInitialColumnResidenceTimes,
			resolvedStandardInitialColumnSetpointDurations,
			resolvedStandardColumnPressureProfiles,
			resolvedStandardColumnFlowRateProfiles,
			resolvedStandardOvenEquilibrationTimes,
			specifiedStandardInitialOvenTemperatures,
			specifiedStandardInitialOvenTemperatureDurations,
			resolvedStandardOvenTemperatureProfiles,
			resolvedStandardPostRunOvenTemperatures,
			resolvedStandardPostRunOvenTimes,
			resolvedStandardPostRunFlowRates,
			resolvedStandardPostRunPressures
		},
		Transpose@{
			specifiedBlankInletSeptumPurgeFlowRates,
			resolvedBlankInitialInletTemperatures,
			resolvedBlankInitialInletTemperatureDurations,
			resolvedBlankInletTemperatureProfiles,
			resolvedBlankSplitRatios,
			resolvedBlankSplitVentFlowRates,
			resolvedBlankSplitlessTimes,
			resolvedBlankInitialInletPressures,
			resolvedBlankInitialInletTimes,
			resolvedBlankGasSavers,
			resolvedBlankGasSaverFlowRates,
			resolvedBlankGasSaverActivationTimes,
			resolvedBlankSolventEliminationFlowRates,
			resolvedBlankInitialColumnFlowRates,
			resolvedBlankInitialColumnPressures,
			resolvedBlankInitialColumnAverageVelocities,
			resolvedBlankInitialColumnResidenceTimes,
			resolvedBlankInitialColumnSetpointDurations,
			resolvedBlankColumnPressureProfiles,
			resolvedBlankColumnFlowRateProfiles,
			resolvedBlankOvenEquilibrationTimes,
			specifiedBlankInitialOvenTemperatures,
			specifiedBlankInitialOvenTemperatureDurations,
			resolvedBlankOvenTemperatureProfiles,
			resolvedBlankPostRunOvenTemperatures,
			resolvedBlankPostRunOvenTimes,
			resolvedBlankPostRunFlowRates,
			resolvedBlankPostRunPressures
		}
	};

	(*resolvedBlankInjectionVolumes = If[blankExpansionLength==0,
		{Null},
		PadRight[{},blankExpansionLength,BlankNoVolume]];*)

	(* get all the sample prep options that happen on the sampler/prior to injection *)

	samplePreparationOptionsInternal = {Dilute, DilutionSolventVolume, SecondaryDilutionSolventVolume, TertiaryDilutionSolventVolume, Agitate, AgitationTime,
		AgitationTemperature, AgitationMixRate, AgitationOnTime, AgitationOffTime, Vortex, VortexMixRate, VortexTime, HeadspaceSyringeTemperature,
		LiquidPreInjectionSyringeWash, LiquidPreInjectionSyringeWashVolume, LiquidPreInjectionSyringeWashRate, LiquidPreInjectionNumberOfSolventWashes,
		LiquidPreInjectionNumberOfSecondarySolventWashes, LiquidPreInjectionNumberOfTertiarySolventWashes, LiquidPreInjectionNumberOfQuaternarySolventWashes, LiquidSampleWash,
		NumberOfLiquidSampleWashes, LiquidSampleWashVolume, LiquidSampleFillingStrokes, LiquidSampleFillingStrokesVolume, LiquidFillingStrokeDelay,
		HeadspaceSyringeFlushing, HeadspacePreInjectionFlushTime, SPMECondition, SPMEConditioningTemperature, SPMEPreConditioningTime, SPMEDerivatizingAgent,
		SPMEDerivatizingAgentAdsorptionTime, SPMEDerivatizationPosition, SPMEDerivatizationPositionOffset, AgitateWhileSampling, SampleVialAspirationPosition,
		SampleVialAspirationPositionOffset, SampleVialPenetrationRate, InjectionVolume, LiquidSampleOverAspirationVolume, SampleAspirationRate, SampleAspirationDelay,
		SPMESampleExtractionTime, InjectionInletPenetrationDepth, InjectionInletPenetrationRate, InjectionSignalMode, PreInjectionTimeDelay, SampleInjectionRate,
		SPMESampleDesorptionTime, PostInjectionTimeDelay, LiquidPostInjectionSyringeWash, LiquidPostInjectionSyringeWashVolume, LiquidPostInjectionSyringeWashRate,
		LiquidPostInjectionNumberOfSolventWashes, LiquidPostInjectionNumberOfSecondarySolventWashes, LiquidPostInjectionNumberOfTertiarySolventWashes,
		LiquidPostInjectionNumberOfQuaternarySolventWashes, PostInjectionNextSamplePreparationSteps, HeadspacePostInjectionFlushTime, SPMEPostInjectionConditioningTime};

	resolvedSamplePreparationOptionsInternal = Transpose@{resolvedDilutes, resolvedDilutionSolventVolumes, resolvedSecondaryDilutionSolventVolumes, resolvedTertiaryDilutionSolventVolumes, resolvedAgitates, resolvedAgitationTimes,
		resolvedAgitationTemperatures, resolvedAgitationMixRates, resolvedAgitationOnTimes, resolvedAgitationOffTimes, resolvedVortexs, resolvedVortexMixRates, resolvedVortexTimes, resolvedHeadspaceSyringeTemperatures,
		resolvedLiquidPreInjectionSyringeWashes, resolvedLiquidPreInjectionSyringeWashVolumes, resolvedLiquidPreInjectionSyringeWashRates, resolvedLiquidPreInjectionNumberOfSolventWashes,
		resolvedLiquidPreInjectionNumberOfSecondarySolventWashes, resolvedLiquidPreInjectionNumberOfTertiarySolventWashes, resolvedLiquidPreInjectionNumberOfQuaternarySolventWashes, resolvedLiquidSampleWashes,
		resolvedNumberOfLiquidSampleWashes, resolvedLiquidSampleWashVolumes, resolvedLiquidSampleFillingStrokes, resolvedLiquidSampleFillingStrokesVolumes, resolvedLiquidFillingStrokeDelays,
		resolvedHeadspaceSyringeFlushings, resolvedHeadspacePreInjectionFlushTimes, resolvedSPMEConditions, resolvedSPMEConditioningTemperatures, resolvedSPMEPreConditioningTimes, resolvedSPMEDerivatizingAgents,
		resolvedSPMEDerivatizingAgentAdsorptionTimes, resolvedSPMEDerivatizationPositions, resolvedSPMEDerivatizationPositionOffsets, resolvedAgitateWhileSamplings, Lookup[roundedGasChromatographyOptions, SampleVialAspirationPosition],
		resolvedSampleVialAspirationPositionOffsets, Lookup[roundedGasChromatographyOptions, SampleVialPenetrationRate], resolvedInjectionVolumes, resolvedLiquidSampleOverAspirationVolumes, resolvedSampleAspirationRates, resolvedSampleAspirationDelays,
		resolvedSPMESampleExtractionTimes, Lookup[roundedGasChromatographyOptions, InjectionInletPenetrationDepth], Lookup[roundedGasChromatographyOptions, InjectionInletPenetrationRate], Lookup[roundedGasChromatographyOptions, InjectionSignalMode], Lookup[roundedGasChromatographyOptions, PreInjectionTimeDelay], resolvedSampleInjectionRates,
		resolvedSPMESampleDesorptionTimes, Lookup[roundedGasChromatographyOptions, PostInjectionTimeDelay], resolvedLiquidPostInjectionSyringeWashes, resolvedLiquidPostInjectionSyringeWashVolumes, resolvedLiquidPostInjectionSyringeWashRates,
		resolvedLiquidPostInjectionNumberOfSolventWashes, resolvedLiquidPostInjectionNumberOfSecondarySolventWashes, resolvedLiquidPostInjectionNumberOfTertiarySolventWashes,
		resolvedLiquidPostInjectionNumberOfQuaternarySolventWashes, resolvedPostInjectionNextSamplePreparationSteps, resolvedHeadspacePostInjectionFlushTimes, resolvedSPMEPostInjectionConditioningTimes};

	standardPreparationOptionsInternal = {StandardVial, StandardAmount, StandardDilute, StandardDilutionSolventVolume, StandardSecondaryDilutionSolventVolume,
		StandardTertiaryDilutionSolventVolume, StandardAgitate, StandardAgitationTime, StandardAgitationTemperature, StandardAgitationMixRate, StandardAgitationOnTime,
		StandardAgitationOffTime, StandardVortex, StandardVortexMixRate, StandardVortexTime, StandardHeadspaceSyringeTemperature,
		StandardLiquidPreInjectionSyringeWash, StandardLiquidPreInjectionSyringeWashVolume, StandardLiquidPreInjectionSyringeWashRate,
		StandardLiquidPreInjectionNumberOfSolventWashes, StandardLiquidPreInjectionNumberOfSecondarySolventWashes, StandardLiquidPreInjectionNumberOfTertiarySolventWashes,
		StandardLiquidPreInjectionNumberOfQuaternarySolventWashes, StandardLiquidSampleWash, StandardNumberOfLiquidSampleWashes, StandardLiquidSampleWashVolume, StandardLiquidSampleFillingStrokes,
		StandardLiquidSampleFillingStrokesVolume, StandardLiquidFillingStrokeDelay, StandardHeadspaceSyringeFlushing, StandardHeadspacePreInjectionFlushTime,
		StandardSPMECondition, StandardSPMEConditioningTemperature, StandardSPMEPreConditioningTime, StandardSPMEDerivatizingAgent,
		StandardSPMEDerivatizingAgentAdsorptionTime, StandardSPMEDerivatizationPosition, StandardSPMEDerivatizationPositionOffset, StandardAgitateWhileSampling,
		StandardSampleVialAspirationPosition, StandardSampleVialAspirationPositionOffset, StandardSampleVialPenetrationRate, StandardInjectionVolume,
		StandardLiquidSampleOverAspirationVolume, StandardSampleAspirationRate, StandardSampleAspirationDelay, StandardSPMESampleExtractionTime,
		StandardInjectionInletPenetrationDepth, StandardInjectionInletPenetrationRate, StandardInjectionSignalMode, StandardPreInjectionTimeDelay,
		StandardSampleInjectionRate, StandardSPMESampleDesorptionTime, StandardPostInjectionTimeDelay, StandardLiquidPostInjectionSyringeWash,
		StandardLiquidPostInjectionSyringeWashVolume, StandardLiquidPostInjectionSyringeWashRate, StandardLiquidPostInjectionNumberOfSolventWashes,
		StandardLiquidPostInjectionNumberOfSecondarySolventWashes, StandardLiquidPostInjectionNumberOfTertiarySolventWashes,
		StandardLiquidPostInjectionNumberOfQuaternarySolventWashes, StandardPostInjectionNextSamplePreparationSteps, StandardHeadspacePostInjectionFlushTime,
		StandardSPMEPostInjectionConditioningTime};

	resolvedStandardPreparationOptionsInternal = Transpose@{resolvedStandardVials, resolvedStandardAmounts, resolvedStandardDilutes, resolvedStandardDilutionSolventVolumes, resolvedStandardSecondaryDilutionSolventVolumes,
		resolvedStandardTertiaryDilutionSolventVolumes, resolvedStandardAgitates, resolvedStandardAgitationTimes, resolvedStandardAgitationTemperatures, resolvedStandardAgitationMixRates, resolvedStandardAgitationOnTimes,
		resolvedStandardAgitationOffTimes, resolvedStandardVortexs, resolvedStandardVortexMixRates, resolvedStandardVortexTimes, resolvedStandardHeadspaceSyringeTemperatures,
		resolvedStandardLiquidPreInjectionSyringeWashes, resolvedStandardLiquidPreInjectionSyringeWashVolumes, resolvedStandardLiquidPreInjectionSyringeWashRates,
		resolvedStandardLiquidPreInjectionNumberOfSolventWashes, resolvedStandardLiquidPreInjectionNumberOfSecondarySolventWashes, resolvedStandardLiquidPreInjectionNumberOfTertiarySolventWashes,
		resolvedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes, resolvedStandardLiquidSampleWashes, resolvedStandardNumberOfLiquidSampleWashes, resolvedStandardLiquidSampleWashVolumes, resolvedStandardLiquidSampleFillingStrokes,
		resolvedStandardLiquidSampleFillingStrokesVolumes, resolvedStandardLiquidFillingStrokeDelays, resolvedStandardHeadspaceSyringeFlushings, resolvedStandardHeadspacePreInjectionFlushTimes,
		resolvedStandardSPMEConditions, resolvedStandardSPMEConditioningTemperatures, resolvedStandardSPMEPreConditioningTimes, resolvedStandardSPMEDerivatizingAgents,
		resolvedStandardSPMEDerivatizingAgentAdsorptionTimes, resolvedStandardSPMEDerivatizationPositions, resolvedStandardSPMEDerivatizationPositionOffsets, resolvedStandardAgitateWhileSamplings,
		Lookup[expandedStandardsAssociation, StandardSampleVialAspirationPosition], resolvedStandardSampleVialAspirationPositionOffsets, Lookup[expandedStandardsAssociation, StandardSampleVialPenetrationRate], resolvedStandardInjectionVolumes,
		resolvedStandardLiquidSampleOverAspirationVolumes, resolvedStandardSampleAspirationRates, resolvedStandardSampleAspirationDelays, resolvedStandardSPMESampleExtractionTimes,
		Lookup[expandedStandardsAssociation, StandardInjectionInletPenetrationDepth], Lookup[expandedStandardsAssociation, StandardInjectionInletPenetrationRate], Lookup[expandedStandardsAssociation, StandardInjectionSignalMode], Lookup[expandedStandardsAssociation, StandardPreInjectionTimeDelay],
		resolvedStandardSampleInjectionRates, resolvedStandardSPMESampleDesorptionTimes, Lookup[expandedStandardsAssociation, StandardPostInjectionTimeDelay], resolvedStandardLiquidPostInjectionSyringeWashes,
		resolvedStandardLiquidPostInjectionSyringeWashVolumes, resolvedStandardLiquidPostInjectionSyringeWashRates, resolvedStandardLiquidPostInjectionNumberOfSolventWashes,
		resolvedStandardLiquidPostInjectionNumberOfSecondarySolventWashes, resolvedStandardLiquidPostInjectionNumberOfTertiarySolventWashes,
		resolvedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes, resolvedStandardPostInjectionNextSamplePreparationSteps, resolvedStandardHeadspacePostInjectionFlushTimes,
		resolvedStandardSPMEPostInjectionConditioningTimes};

	blankPreparationOptionsInternal = {BlankVial, BlankAmount, BlankDilute, BlankDilutionSolventVolume, BlankSecondaryDilutionSolventVolume,
		BlankTertiaryDilutionSolventVolume, BlankAgitate, BlankAgitationTime, BlankAgitationTemperature, BlankAgitationMixRate, BlankAgitationOnTime,
		BlankAgitationOffTime, BlankVortex, BlankVortexMixRate, BlankVortexTime, BlankHeadspaceSyringeTemperature,
		BlankLiquidPreInjectionSyringeWash, BlankLiquidPreInjectionSyringeWashVolume, BlankLiquidPreInjectionSyringeWashRate,
		BlankLiquidPreInjectionNumberOfSolventWashes, BlankLiquidPreInjectionNumberOfSecondarySolventWashes, BlankLiquidPreInjectionNumberOfTertiarySolventWashes,
		BlankLiquidPreInjectionNumberOfQuaternarySolventWashes, BlankLiquidSampleWash, BlankNumberOfLiquidSampleWashes, BlankLiquidSampleWashVolume, BlankLiquidSampleFillingStrokes,
		BlankLiquidSampleFillingStrokesVolume, BlankLiquidFillingStrokeDelay, BlankHeadspaceSyringeFlushing, BlankHeadspacePreInjectionFlushTime,
		BlankSPMECondition, BlankSPMEConditioningTemperature, BlankSPMEPreConditioningTime, BlankSPMEDerivatizingAgent,
		BlankSPMEDerivatizingAgentAdsorptionTime, BlankSPMEDerivatizationPosition, BlankSPMEDerivatizationPositionOffset, BlankAgitateWhileSampling,
		BlankSampleVialAspirationPosition, BlankSampleVialAspirationPositionOffset, BlankSampleVialPenetrationRate, BlankInjectionVolume,
		BlankLiquidSampleOverAspirationVolume, BlankSampleAspirationRate, BlankSampleAspirationDelay, BlankSPMESampleExtractionTime,
		BlankInjectionInletPenetrationDepth, BlankInjectionInletPenetrationRate, BlankInjectionSignalMode, BlankPreInjectionTimeDelay,
		BlankSampleInjectionRate, BlankSPMESampleDesorptionTime, BlankPostInjectionTimeDelay, BlankLiquidPostInjectionSyringeWash,
		BlankLiquidPostInjectionSyringeWashVolume, BlankLiquidPostInjectionSyringeWashRate, BlankLiquidPostInjectionNumberOfSolventWashes,
		BlankLiquidPostInjectionNumberOfSecondarySolventWashes, BlankLiquidPostInjectionNumberOfTertiarySolventWashes,
		BlankLiquidPostInjectionNumberOfQuaternarySolventWashes, BlankPostInjectionNextSamplePreparationSteps, BlankHeadspacePostInjectionFlushTime,
		BlankSPMEPostInjectionConditioningTime};

	resolvedBlankPreparationOptionsInternal = Transpose@{resolvedBlankVials, resolvedBlankAmounts, resolvedBlankDilutes, resolvedBlankDilutionSolventVolumes, resolvedBlankSecondaryDilutionSolventVolumes,
		resolvedBlankTertiaryDilutionSolventVolumes, resolvedBlankAgitates, resolvedBlankAgitationTimes, resolvedBlankAgitationTemperatures, resolvedBlankAgitationMixRates, resolvedBlankAgitationOnTimes,
		resolvedBlankAgitationOffTimes, resolvedBlankVortexs, resolvedBlankVortexMixRates, resolvedBlankVortexTimes, resolvedBlankHeadspaceSyringeTemperatures,
		resolvedBlankLiquidPreInjectionSyringeWashes, resolvedBlankLiquidPreInjectionSyringeWashVolumes, resolvedBlankLiquidPreInjectionSyringeWashRates,
		resolvedBlankLiquidPreInjectionNumberOfSolventWashes, resolvedBlankLiquidPreInjectionNumberOfSecondarySolventWashes, resolvedBlankLiquidPreInjectionNumberOfTertiarySolventWashes,
		resolvedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes, resolvedBlankLiquidSampleWashes, resolvedBlankNumberOfLiquidSampleWashes, resolvedBlankLiquidSampleWashVolumes, resolvedBlankLiquidSampleFillingStrokes,
		resolvedBlankLiquidSampleFillingStrokesVolumes, resolvedBlankLiquidFillingStrokeDelays, resolvedBlankHeadspaceSyringeFlushings, resolvedBlankHeadspacePreInjectionFlushTimes,
		resolvedBlankSPMEConditions, resolvedBlankSPMEConditioningTemperatures, resolvedBlankSPMEPreConditioningTimes, resolvedBlankSPMEDerivatizingAgents,
		resolvedBlankSPMEDerivatizingAgentAdsorptionTimes, resolvedBlankSPMEDerivatizationPositions, resolvedBlankSPMEDerivatizationPositionOffsets, resolvedBlankAgitateWhileSamplings,
		Lookup[expandedBlanksAssociation, BlankSampleVialAspirationPosition], resolvedBlankSampleVialAspirationPositionOffsets, Lookup[expandedBlanksAssociation, BlankSampleVialPenetrationRate], resolvedBlankInjectionVolumes,
		resolvedBlankLiquidSampleOverAspirationVolumes, resolvedBlankSampleAspirationRates, resolvedBlankSampleAspirationDelays, resolvedBlankSPMESampleExtractionTimes,
		Lookup[expandedBlanksAssociation, BlankInjectionInletPenetrationDepth], Lookup[expandedBlanksAssociation, BlankInjectionInletPenetrationRate], Lookup[expandedBlanksAssociation, BlankInjectionSignalMode], Lookup[expandedBlanksAssociation, BlankPreInjectionTimeDelay],
		resolvedBlankSampleInjectionRates, resolvedBlankSPMESampleDesorptionTimes, Lookup[expandedBlanksAssociation, BlankPostInjectionTimeDelay], resolvedBlankLiquidPostInjectionSyringeWashes,
		resolvedBlankLiquidPostInjectionSyringeWashVolumes, resolvedBlankLiquidPostInjectionSyringeWashRates, resolvedBlankLiquidPostInjectionNumberOfSolventWashes,
		resolvedBlankLiquidPostInjectionNumberOfSecondarySolventWashes, resolvedBlankLiquidPostInjectionNumberOfTertiarySolventWashes,
		resolvedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes, resolvedBlankPostInjectionNextSamplePreparationSteps, resolvedBlankHeadspacePostInjectionFlushTimes,
		resolvedBlankSPMEPostInjectionConditioningTimes};


	(* === Resolve InjectionTable and tests === *)

	(* get the InjectionTable Blank and Standard values *)
	injectionTableBlanks = If[MatchQ[specifiedFakeInjectionTable, Null | Automatic],
		Null,
		Cases[specifiedFakeInjectionTable, {Blank, blank_, _, _, _} :> blank] /. {Null -> NoInjection}
	];
	injectionTableStandards = If[MatchQ[specifiedFakeInjectionTable, Null | Automatic],
		Null,
		Cases[specifiedFakeInjectionTable, {Standard, standard_, _, _, _} :> standard]
	];

	(*we need to get all of the injection table methods*)
	injectionTableStandardSeparationMethods = Which[
		(*grab the separationMethods column of the injection table for standard samples*)
		standardExistsQ && injectionTableSpecifiedQ,
		Cases[injectionTableLookup, {Standard, _, _, _, separationMethod_} :> separationMethod],
		(* otherwise just pad automatics *)
		standardExistsQ,
		ConstantArray[Automatic, Length[resolvedStandards]],
		(* if no standard exists, then resolvedStandard is going to be {} so obvi no separationMethods either *)
		True, {}
	];
	injectionTableBlankSeparationMethods = Which[
		(*grab the separationMethods column of the injection table for blank samples*)
		blankExistsQ && injectionTableSpecifiedQ, Cases[injectionTableLookup, {Blank, _, _, _, separationMethod_} :> separationMethod],
		(* otherwise just pad automatics *)
		blankExistsQ, ConstantArray[Automatic, Length[resolvedBlanks]],
		(* if no blank exists, then resolvedBlank is going to be {} so obvi no separationMethods either *)
		True, {}
	];

	(*we also need to figure out if we're overwriting the separationMethods and supplying a new one, because a GC method was specified but was subsequently changed? *)
	{
		{overwriteSeparationMethodsBool,overwrittenSeparationMethodOptions},
		{overwriteStandardSeparationMethodsBool,overwrittenStandardSeparationMethodOptions},
		{overwriteBlankSeparationMethodsBool, overwrittenBlankSeparationMethodOptions}
	} = Map[
		Function[{methodsList},
			Module[{specifiedMethods, resolvedMethods},
				{specifiedMethods, resolvedMethods} = methodsList;

				(* Check if the resolvedSeparationMethod (supplied by the user via options) contains the same values as the specified SeparationMethod *)
				(* If a SeparationMethod was specified, compare it to the resolved SeparationMethod, otherwise just say False because there's no Method to overwrite *)
				If[!MatchQ[specifiedMethods, ({} | Null|{Null})],
					Transpose[
						MapThread[
							Function[{specifiedSeparationMethod, resolvedSeparationMethod},

								If[MatchQ[specifiedSeparationMethod, ObjectP[Object[Method, GasChromatography]]],
									Module[{overWrittenOptions,overWrittenOptionsBooleans,separationMethodSpecifiedOptionsList},
										separationMethodSpecifiedOptionsList = {
											InletSeptumPurgeFlowRate,
											InitialInletTemperature,
											InitialInletTemperatureDuration,
											InletTemperatureProfile,
											SplitRatio,
											SplitVentFlowRate,
											SplitlessTime,
											InitialInletPressure,
											InitialInletTime,
											GasSaver,
											GasSaverFlowRate,
											GasSaverActivationTime,
											SolventEliminationFlowRate,
											(*14  v  *)
											InitialColumnFlowRate,
											InitialColumnPressure,
											InitialColumnAverageVelocity,
											InitialColumnResidenceTime,
											(*18  v  *)
											InitialColumnSetpointDuration,
											ColumnPressureProfile,
											ColumnFlowRateProfile,
											OvenEquilibrationTime,
											InitialOvenTemperature,
											InitialOvenTemperatureDuration,
											OvenTemperatureProfile,
											PostRunOvenTemperature,
											PostRunOvenTime,
											PostRunFlowRate,
											PostRunPressure
										};

										overWrittenOptions = MapThread[If[!MatchQ[#1,#2], #3, Nothing] &, #]&/@{{resolvedSeparationMethod, Lookup[fetchPacketFromCache[specifiedSeparationMethod, cache],separationMethodSpecifiedOptionsList],separationMethodSpecifiedOptionsList}};
										overWrittenOptionsBooleans = !MatchQ[#, {} | Null]&/@overWrittenOptions;
										{overWrittenOptionsBooleans[[1]],overWrittenOptions[[1]]}
									],
									{False, {}}
								]
							],
							{specifiedMethods, resolvedMethods}
						]
					],
					{{False}, {}}
				]
			]
		],
		{
			{specifiedSeparationMethods, resolvedSeparationMethods},
			{specifiedStandardSeparationMethods, resolvedStandardSeparationMethods},
			{specifiedBlankSeparationMethods, resolvedBlankSeparationMethods}
		}

	];

	overwrittenStandardSeparationMethodOptions = ToExpression["Standard" <>ToString[#]&/@overwrittenStandardSeparationMethodOptions];
	overwrittenBlankSeparationMethodOptions = ToExpression["Blank" <>ToString[#]&/@overwrittenBlankSeparationMethodOptions];

	(* figure out from the bools and specified separationmethods what the resolved SeparationMethods will ultimately be *)
	{resolvedSeparationMethodsWithObjects, resolvedStandardSeparationMethodsWithObjects, resolvedBlankSeparationMethodsWithObjects} = Map[
		Function[opsLists,
			Module[{specifiedMethods, overwriteMethodBools, samples},
				{specifiedMethods, overwriteMethodBools, samples} = opsLists;
				If[NullQ[samples],
					Null,
					MapThread[
						Function[{specifiedMethod, overwriteMethodBool},
							If[MatchQ[specifiedMethod, ObjectP[Object[Method, GasChromatography]]] && MatchQ[overwriteMethodBool, False],
								Download[specifiedMethod, Object, Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
								(*Keep the method as Automatic if needed so resolveInjectionTable will be able to create a new ID*)
								specifiedMethod
							]
						],
						{specifiedMethods, overwriteMethodBools}
					]
				]
			]
		],
		{
			{specifiedSeparationMethods, overwriteSeparationMethodsBool, mySamples},
			{specifiedStandardSeparationMethods, overwriteStandardSeparationMethodsBool, resolvedStandards},
			{specifiedBlankSeparationMethods, overwriteBlankSeparationMethodsBool, resolvedBlanks}
		}
	];


	(* create the separationmethod packets to pass on to the resource packets function *)
	{
		resolvedSeparationMethodAssociations,
		resolvedStandardSeparationMethodAssociations,
		resolvedBlankSeparationMethodAssociations
	} = MapThread[
		Function[{separationMethods, specifiedMethodObjects, overwriteBools, samples},
			If[NullQ[samples],
				Null,
				MapThread[
					Function[{inletSeptumPurgeFlowRate, initialInletTemperature, initialInletTemperatureDuration, inletTemperatureProfile, splitRatio, splitVentFlowRate,
						splitlessTime, initialInletPressure, initialInletTime, gasSaver, gasSaverFlowRate, gasSaverActivationTime, solventEliminationFlowRate,
						initialColumnFlowRate, initialColumnPressure, initialColumnAverageVelocity, initialColumnResidenceTime,
						initialColumnSetpointDuration, columnPressureProfile, columnFlowRateProfile, ovenEquilibrationTime, initialOvenTemperature, initialOvenTemperatureDuration, ovenTemperatureProfile,
						postRunOvenTemperature, postRunOvenTime, postRunFlowRate, postRunPressure, specifiedMethodObject, overwriteBool},
						If[
							MatchQ[specifiedMethodObject, ObjectP[Object[Method, GasChromatography]]] && MatchQ[overwriteBool, False],
							Quiet[
								Download[specifiedMethodObject, Object, Cache -> cache, Simulation -> updatedSimulation, Date -> Now],
								{Download::MissingField}
							],
							Association[
								Type -> Object[Method, GasChromatography],
								ColumnLength -> columnLength,
								ColumnDiameter -> columnDiameter,
								ColumnFilmThickness -> columnFilmThickness,
								InletLinerVolume -> inletLinerVolume,
								Detector -> specifiedDetector,
								CarrierGas -> specifiedCarrierGas,
								InletSeptumPurgeFlowRate -> inletSeptumPurgeFlowRate,
								InitialInletTemperature -> initialInletTemperature,
								InitialInletTemperatureDuration -> initialInletTemperatureDuration,
								InletTemperatureProfile -> inletTemperatureProfile,
								SplitRatio -> splitRatio,
								SplitVentFlowRate -> splitVentFlowRate,
								SplitlessTime -> splitlessTime,
								InitialInletPressure -> initialInletPressure,
								InitialInletTime -> initialInletTime,
								GasSaver -> gasSaver,
								GasSaverFlowRate -> gasSaverFlowRate,
								GasSaverActivationTime -> gasSaverActivationTime,
								SolventEliminationFlowRate -> solventEliminationFlowRate,
								InitialColumnFlowRate -> If[!NullQ[initialColumnFlowRate], RoundOptionPrecision[N[initialColumnFlowRate], 0.0001 Milliliter / Minute], Null],
								InitialColumnPressure -> If[!NullQ[initialColumnPressure], RoundOptionPrecision[N[initialColumnPressure], 0.0001 PSI], Null],
								InitialColumnAverageVelocity -> If[!NullQ[initialColumnAverageVelocity], RoundOptionPrecision[N[initialColumnAverageVelocity], 0.0001 Centimeter / Second], Null],
								InitialColumnResidenceTime -> If[!NullQ[initialColumnResidenceTime], RoundOptionPrecision[N[initialColumnResidenceTime], 0.0001 Minute], Null],
								InitialColumnSetpointDuration -> initialColumnSetpointDuration,
								ColumnPressureProfile -> columnPressureProfile,
								ColumnFlowRateProfile -> columnFlowRateProfile,
								OvenEquilibrationTime -> ovenEquilibrationTime,
								InitialOvenTemperature -> initialOvenTemperature,
								InitialOvenTemperatureDuration -> initialOvenTemperatureDuration,
								OvenTemperatureProfile -> ovenTemperatureProfile,
								PostRunOvenTemperature -> postRunOvenTemperature,
								PostRunOvenTime -> postRunOvenTime,
								PostRunFlowRate -> postRunFlowRate,
								PostRunPressure -> postRunPressure
							]
						]
					],
					Join[Transpose@separationMethods, {specifiedMethodObjects}, {overwriteBools}]
				]
			]
		],
		Transpose@{
			{resolvedSeparationMethods, specifiedSeparationMethods, overwriteSeparationMethodsBool, mySamples},
			{resolvedStandardSeparationMethods, specifiedStandardSeparationMethods, overwriteStandardSeparationMethodsBool, resolvedStandards},
			{resolvedBlankSeparationMethods, specifiedBlankSeparationMethods, overwriteBlankSeparationMethodsBool, resolvedBlanks}
		}
	];

	(*Throw a warning whenever we're overwriting*)
	overwriteOptionBool = Map[
		Or @@ #&,
		{
			overwriteSeparationMethodsBool,
			overwriteStandardSeparationMethodsBool,
			overwriteBlankSeparationMethodsBool
		}
	];

	(* if there is a mismatch between the Blank options and the injection table, throw an error *)
	If[!gatherTests && Or @@ overwriteOptionBool && !MatchQ[$ECLApplication, Engine],
		Message[Warning::OverwritingSeparationMethod, PickList[{SeparationMethod, StandardSeparationMethod, BlankSeparationMethod}, overwriteOptionBool], DeleteDuplicates[Flatten[#]]&/@PickList[{overwrittenSeparationMethodOptions, overwrittenStandardSeparationMethodOptions, overwrittenBlankSeparationMethodOptions}, overwriteOptionBool]]
	];

	(*we must adjust the overwrite if the standards and blanks are imbalanced in the injection table*)
	adjustedOverwriteStandardBool = Which[
		Length[injectionTableStandardSeparationMethods] > Length[resolvedStandardSeparationMethods] && !NullQ[injectionTableStandardSeparationMethods], PadRight[overwriteStandardSeparationMethodsBool, Length[injectionTableStandardSeparationMethods], False],
		Length[injectionTableStandardSeparationMethods] < Length[resolvedStandardSeparationMethods] && !NullQ[injectionTableStandardSeparationMethods], Take[overwriteStandardSeparationMethodsBool, Length[injectionTableStandardSeparationMethods]],
		True, overwriteStandardSeparationMethodsBool
	];
	adjustedOverwriteBlankBool = Which[
		Length[injectionTableBlankSeparationMethods] > Length[resolvedBlankSeparationMethods] && !NullQ[injectionTableBlankSeparationMethods], PadRight[overwriteBlankSeparationMethodsBool, Length[injectionTableBlankSeparationMethods], False],
		Length[injectionTableBlankSeparationMethods] < Length[resolvedBlankSeparationMethods] && !NullQ[injectionTableBlankSeparationMethods], Take[overwriteBlankSeparationMethodsBool, Length[injectionTableBlankSeparationMethods]],
		True, overwriteBlankSeparationMethodsBool
	];

	(* create the fake column option to inject into the injection table function *)
	{injectionTableColumnOptionValue, injectionTableStandardColumnOptionValue, injectionTableBlankColumnOptionValue} = Map[
		Function[lists,
			MapThread[
				Function[{samplingMethod, prepOptions},
					Association[SamplingMethod -> samplingMethod, SamplePrepOptions -> prepOptions]
				],
				{lists[[1]], lists[[2]]}
			]
		],
		{
			{resolvedSamplingMethods, resolvedSamplePreparationOptionsInternal},
			{resolvedStandardSamplingMethods, resolvedStandardPreparationOptionsInternal},
			{resolvedBlankSamplingMethods, resolvedBlankPreparationOptionsInternal}
		}
	];




	(* rebuild the injection table properly now that we've resolved it further *)
	intermediateInjectionTable = If[MatchQ[specifiedFakeInjectionTable, Null | Automatic],
		Null,
		(* otherwise we have to reassemble the injection table based on the hopefully conserved order of the submitted list *)
		Module[{samplePositions, standardPositions, blankPositions, resolvedSampleTuples, resolvedStandardTuples, resolvedBlankTuples,
			reassembledInjectionTable, sampleLength, injectionTableSampleLength},

			(*first separate the injection table by the positions according to its type*)
			{samplePositions, standardPositions, blankPositions} = Map[
				Sequence @@@ Position[specifiedFakeInjectionTable, {#, ___}]&,
				{Sample, Standard, Blank}
			];

			(*get the respective lengths*)
			sampleLength = Length[mySamples];
			injectionTableSampleLength = Length[samplePositions];

			(*now we can resolve the standard, blank, and standard tuples because of the 1:1 index matching*)
			{resolvedSampleTuples, resolvedStandardTuples, resolvedBlankTuples} = Map[
				Function[{entry},
					Module[{tableTuples, samples, injectionVolumes, columns, methods},

						(*split the entry*)
						{tableTuples, samples, injectionVolumes, columns, methods} = entry;

						(*first check if there is something here (e.g. no standards), in which case return an empty list*)
						If[MatchQ[tableTuples, Null | {}],
							{},
							(*otherwise map thread and fill these tuples*)
							MapThread[
								Function[{tableTuple, sample, injectionVolume, column, method},
									Module[{setSample, setInjectionVolume, setColumn, setMethod},
										(*check out much of the tupled is filled out*)

										(*Type, Sample, InjectionVolume, Column placeholder, SeparationMethod resolved*)
										{setSample, setInjectionVolume, setColumn, setMethod} = {sample, injectionVolume, column, method};

										(*return the resolved tuple*)
										{First@tableTuple, setSample, setInjectionVolume, setColumn, setMethod}

									]],
								{tableTuples, samples, injectionVolumes, columns, methods}]
						]
					]],
				{
					{specifiedFakeInjectionTable[[samplePositions]], mySamples, resolvedInjectionVolumes, injectionTableColumnOptionValue, resolvedSeparationMethodsWithObjects},
					{specifiedFakeInjectionTable[[standardPositions]], resolvedStandards, resolvedStandardInjectionVolumes, injectionTableStandardColumnOptionValue, resolvedStandardSeparationMethodsWithObjects},
					{specifiedFakeInjectionTable[[blankPositions]], resolvedBlanks, resolvedBlankInjectionVolumes, injectionTableBlankColumnOptionValue, resolvedBlankSeparationMethodsWithObjects}
				}
			];

			(* reassemble the table *)

			(*returned the resolved injection table*)
			reassembledInjectionTable = specifiedFakeInjectionTable;

			(*smoosh it together*)
			reassembledInjectionTable[[samplePositions]] = resolvedSampleTuples;
			reassembledInjectionTable[[blankPositions]] = resolvedBlankTuples;
			reassembledInjectionTable[[standardPositions]] = resolvedStandardTuples;

			reassembledInjectionTable

		]
	];

	(*we'll need to combine all of the relevant options for the injection table*)
	resolvedOptionsForInjectionTable = Association[
		(* Inject whatever information we need to pass into the injection table through its resolver here, MUST BE DONE AS AN ASSOCIATION BECAUSE THERE'S WEIRD FLATTENING THINGS THAT HAPPEN INSIDE THE SHARED FUNCTION *)
		Column -> injectionTableColumnOptionValue, (* {resolvedSamplingMethods, resolvedSamplePreparationOptionsInternal} *)
		InjectionVolume -> resolvedInjectionVolumes,
		Gradient -> resolvedSeparationMethodsWithObjects,
		Standard -> If[NullQ[injectionTableStandards] || Length[injectionTableStandards] == Length[resolvedStandards],
			resolvedStandards,
			injectionTableStandards
		],
		(* Inject whatever information we need to pass into the injection table through its resolver here *)
		StandardColumn -> injectionTableStandardColumnOptionValue,
		StandardFrequency -> resolvedStandardFrequency,
		StandardInjectionVolume -> resolvedStandardInjectionVolumes,
		StandardGradient -> If[NullQ[injectionTableStandardSeparationMethods] || Length[injectionTableStandardSeparationMethods] == Length[resolvedStandardSeparationMethods],
			resolvedStandardSeparationMethodsWithObjects,
			injectionTableStandardSeparationMethods
		],
		Blank -> If[NullQ[injectionTableBlanks] || Length[injectionTableBlanks] == Length[resolvedBlanks],
			resolvedBlanks,
			injectionTableBlanks
		],
		(* Inject whatever information we need to pass into the injection table through its resolver here *)
		BlankColumn -> injectionTableBlankColumnOptionValue,
		BlankFrequency -> resolvedBlankFrequency,
		BlankInjectionVolume -> resolvedBlankInjectionVolumes,
		BlankGradient -> If[NullQ[injectionTableBlankSeparationMethods] || Length[injectionTableBlankSeparationMethods] == Length[resolvedBlankSeparationMethods],
			resolvedBlankSeparationMethodsWithObjects,
			injectionTableBlankSeparationMethods
		],
		ColumnRefreshFrequency -> None,
		ColumnPrimeGradient -> Null,
		ColumnFlushGradient -> Null,
		InjectionTable -> intermediateInjectionTable,
		GradientOverwrite -> overwriteSeparationMethodsBool,
		StandardGradientOverwrite -> adjustedOverwriteStandardBool,
		BlankGradientOverwrite -> adjustedOverwriteBlankBool,
		ColumnFlushGradientOverwrite -> False,
		ColumnPrimeOverwrite -> False
	];

	(*call our shared helper function*)
	{{resolvedInjectionTableResult, invalidInjectionTableOptions}, invalidInjectionTableTests} = If[gatherTests,
		resolveInjectionTable[mySamples, resolvedOptionsForInjectionTable, ExperimentGasChromatography, Object[Method, GasChromatography], Output -> {Result, Tests}],
		{resolveInjectionTable[mySamples, resolvedOptionsForInjectionTable, ExperimentGasChromatography, Object[Method, GasChromatography]], {}}
	];
	preResolvedInjectionTable = Lookup[resolvedInjectionTableResult, InjectionTable];

	(* Here's the injection table. switch the table back to the format it should be in, removing the injection volume and adding the sample prep options.
	should we consider removing any Nulls from the Sample Prep Options?. *)
	(* we also need to replace the blank sample type with Null if it is currently NoInjection *)

	resolvedInjectionTable = Map[Switch[
		#,
		{Sample, _, _, _, _},
		# /. {
			{type_, object_, volume_, column_, method_} :> {
				type,
				object,
				column[SamplingMethod],
				Association@MapThread[
					Function[{optionName, optionValue},
						If[NullQ[optionValue],
							Nothing,
							optionName -> optionValue
						]
					],
					{samplePreparationOptionsInternal, column[SamplePrepOptions]}
				],
				method
			}
		},
		{Standard, _, _, _, _},
		# /. {
			{type_, object_, volume_, column_, method_} :> {
				type,
				object,
				column[SamplingMethod],
				Association@MapThread[
					Function[{optionName, optionValue},
						If[NullQ[optionValue],
							Nothing,
							(* remove prefixes, and exclude standard-specific options *)
							If[!MatchQ[optionName, (StandardVial | StandardAmount)],
								ToExpression[StringReplace[ToString[optionName], "Standard" -> ""]],
								optionName
							] -> optionValue
						]
					],
					{standardPreparationOptionsInternal, column[SamplePrepOptions]}
				],
				method
			}
		},
		{Blank, _, _, _, _},
		# /. {
			{type_, object_, volume_, column_, method_} :> {
				type,
				object /. {NoInjection -> Null},
				column[SamplingMethod],
				Join[
					Association@MapThread[
						Function[{optionName, optionValue},
							If[NullQ[optionValue],
								Nothing,
								(* remove prefixes, and exclude blank-specific options *)
								If[!MatchQ[optionName, (BlankVial | BlankAmount)],
									ToExpression[StringReplace[ToString[optionName], "Blank" -> ""]],
									optionName
								] -> If[MatchQ[optionValue, BlankNoVolume], Null, optionValue]
							]
						],
						{blankPreparationOptionsInternal, column[SamplePrepOptions]}
					],
					If[MatchQ[object, NoInjection | Null],
						<|BlankType -> object|>,
						Association[Nothing]
					]
				],
				method
			}
		}
	]&,
		preResolvedInjectionTable
	];

	(* Moving the tests from FPLC over here as well *)

	(* get the resolved values from the injection table *)
	resolvedInjectionTableBlanks = Cases[resolvedInjectionTable, {Blank, blank_, _, _, _} :> blank];
	resolvedInjectionTableBlankInjectionVolumes = Cases[resolvedInjectionTable, {Blank, _, injectionVolume_, _, _} :> injectionVolume];
	resolvedInjectionTableBlankSeparationMethods = Cases[resolvedInjectionTable, {Blank, _, _, _, gradient_} :> gradient];

	(* is there something in the injection table that doesn't match what is specified in the options? *)
	foreignBlanksQ = If[injectionTableSpecifiedQ && NullQ[resolvedBlankFrequency] && blankExpansionLength > 0,
		Or[
			(* make sure there are not blanks specified in the injection table but not the options (or vice versa) *)
			Length[DeleteCases[Download[resolvedBlanks /. {NoInjection -> Null}, Object, Cache -> cache, Date -> Now], Null | Alternatives @@ Download[resolvedInjectionTableBlanks, Object, Cache -> cache, Date -> Now]]] > 0,
			Length[DeleteCases[Download[resolvedInjectionTableBlanks, Object, Cache -> cache, Date -> Now], Null | Alternatives @@ Download[resolvedBlanks /. {NoInjection -> Null}, Object, Cache -> cache, Date -> Now]]] > 0,
			(* for separation methods, can't really cross-check everything so just make sure they have the same length *)
			Length[resolvedInjectionTableBlankSeparationMethods] != Length[resolvedBlankSeparationMethods]
		],
		False
	];

	(* if there is a mismatch between the Blank options and the injection table, throw an error *)
	foreignBlankOptions = If[!gatherTests && foreignBlanksQ,
		(
			Message[Error::InjectionTableForeignBlanks, ObjectToString[blankOptionNames]];
			blankOptionNames
		),
		{}
	];

	(* make a test for the blank injection table options *)
	foreignBlankTest = If[gatherTests,
		Test["If any blank options are specified, they must agree with the values specified in the InjectionTable:",
			foreignBlanksQ,
			False
		],
		Nothing
	];

	(* get the resolved values from the injection table *)
	resolvedInjectionTableStandards = Cases[resolvedInjectionTable, {Standard, standard_, _, _, _} :> standard];
	resolvedInjectionTableStandardInjectionVolumes = Cases[resolvedInjectionTable, {Standard, _, injectionVolume_, _, _} :> injectionVolume];
	resolvedInjectionTableStandardSeparationMethods = Cases[resolvedInjectionTable, {Standard, _, _, _, gradient_} :> gradient];

	(* is there something in the injection table that doesn't match what is specified in the options? *)
	foreignStandardsQ = If[injectionTableSpecifiedQ && NullQ[resolvedStandardFrequency] && standardExpansionLength > 0,
		Or[
			(* make sure there are not standards specified in the injection table but not the options (or vice versa) *)
			Length[DeleteCases[Download[resolvedStandards, Object, Cache -> cache, Date -> Now], Null | Alternatives @@ Download[resolvedInjectionTableStandards, Object, Cache -> cache, Date -> Now]]] > 0,
			Length[DeleteCases[Download[resolvedInjectionTableStandards, Object, Cache -> cache, Date -> Now], Null | Alternatives @@ Download[resolvedStandards, Object, Cache -> cache, Date -> Now]]] > 0,
			(* for separation methods, can't really cross-check everything so just make sure they have the same length *)
			Length[resolvedInjectionTableStandardSeparationMethods] != Length[resolvedStandardSeparationMethods]
		],
		False
	];

	(* if there is a mismatch between the Standard options and the injection table, throw an error *)
	foreignStandardOptions = If[!gatherTests && foreignStandardsQ,
		(
			Message[Error::InjectionTableForeignStandards, ObjectToString[standardOptionNames]];
			standardOptionNames
		),
		{}
	];

	(* make a test for the standard injection table options *)
	foreignStandardTest = If[gatherTests,
		Test["If any standard options are specified, they must agree with the values specified in the InjectionTable:",
			foreignStandardsQ,
			False
		],
		Nothing
	];

	(* === End InjectionTable shenanigans === *)

	(* figure out aliquot options before the experiment options *)
	(* earlier we checked to see if our samples were already in valid GC vials and created aliquotQ. if the simulated samples don't need to be moved because they're already in compatible vials, replace those targetVials and amounts with Nulls *)

	{
		{resolvedAliquotAmounts, resolvedTargetVials},
		{resolvedStandardAliquotAmounts, resolvedStandardTargetVials},
		{resolvedBlankAliquotAmounts, resolvedBlankTargetVials}
	} = Map[
		Function[
			opsList,
			Module[
				{aliquotCheck, targetVial, requiredAmount},
				{aliquotCheck, targetVial, requiredAmount} = opsList;
				Transpose@MapThread[
					Function[{aliquot, vial, amount},
						If[aliquot,
							{Which[
								MatchQ[amount, VolumeP], Round[amount, 1 Microliter],
								MatchQ[amount, MassP], Round[amount, 1 Milligram],
								True, amount
							], vial},
							{Null, Null}
						]
					],
					{aliquotCheck, targetVial, requiredAmount}
				]
			]
		],
		{
			{aliquotQ, targetVials, requiredAliquotAmounts},
			{aliquotStandardQ, targetStandardVials, requiredStandardAliquotAmounts},
			{aliquotBlankQ, targetBlankVials, requiredBlankAliquotAmounts}
		}
	];

	(* perform some error checking to make sure all vials can fit on the autosampler deck *)
	{
		finalVialModels, finalStandardVialModels, finalBlankVialModels
	} = Map[
		Function[
			opsList,
			Module[
				{aliquotCheck, targetVial, actualContainer, vials},
				{aliquotCheck, targetVial, actualContainer} = opsList;

				vials = MapThread[
					Function[{aliquot, aliquotVial, currentVial},
						If[aliquot,
							aliquotVial,
							currentVial
						]
					],
					{aliquotCheck, targetVial, actualContainer}
				];

				Map[
					Which[
						MatchQ[#, ObjectP[Model[]]],
						#,
						MatchQ[#, ObjectP[Object[]]],
						Download[#, Model, Cache -> cache, Simulation -> updatedSimulation]
					]&,
					vials
				]
			]
		],
		{
			{aliquotQ, targetVials, simulatedContainerModels},
			{aliquotStandardQ, targetStandardVials, standardContainers},
			{aliquotBlankQ, targetBlankVials, blankContainers}
		}
	];

	allVials = Flatten[{finalVialModels, finalStandardVialModels, finalBlankVialModels}];

	(* split the samples into small vials and large vials with 10 or 20 ml size *)
	smallVials = Select[allVials, MatchQ[Download[#, Footprint, Cache -> cache, Simulation -> updatedSimulation], CEVial]&];

	shortBigVials = Select[allVials, And[
		MatchQ[Download[#, Footprint, Cache -> cache, Simulation -> updatedSimulation], HeadspaceVial],
		Download[#, MaxVolume, Cache -> cache, Simulation -> updatedSimulation] <= 10 Milliliter
	]&];

	tallBigVials = Select[allVials, And[
		MatchQ[Download[#, Footprint, Cache -> cache, Simulation -> updatedSimulation], HeadspaceVial],
		Download[#, MaxVolume, Cache -> cache, Simulation -> updatedSimulation] > 10 Milliliter
	]&];

	(* throw some errors *)
	tooManySmallSamplesInvalidOption = If[
		(* Based on discussion in https://app.asana.com/1/84467620246/project/1138532600226514/task/1209599044619210 and https://app.asana.com/1/84467620246/project/1207565984751460/task/1209608497776324, we need to arrange the vials so that there are no other vials next to any vial. In other words, we want the vials to be arranged in the checker board pattern. That means, we can only fit in 5*3 + 4*3 = 27 vials in a 9*6 rack. *)
		Length[PartitionRemainder[smallVials, 27]] > 3,
		Message[Error::TooManyCEVialsForAutosampler];
		{SamplesIn, ContainersIn},
		{}
	];

	tooManyBigSamplesInvalidOption = If[
		Length[Join[PartitionRemainder[shortBigVials, 15], PartitionRemainder[tallBigVials, 15]]] > 3,
		Message[Error::TooManyHeadspaceVialsForAutosampler];
		{SamplesIn, ContainersIn},
		{}
	];

	(* we need to make sure we are not going to OVERFILL any of the containers that will be placed on the deck, including transfers that will occur on the deck, because this doesn't currently get tracked by SM or any other subs *)
	{overfilledSampleQ, overfilledStandardQ, overfilledBlankQ} = Map[
		Function[
			opsList,
			Module[
				{
					aliquotAmounts, targetVials, samples, startingContainers, startingVolumes, startingMasses, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes, overfillBooleans
				},

				(* get variables from input *)
				{aliquotAmounts, targetVials, samples, startingContainers, startingVolumes, startingMasses, dilutionSolventVolumes, secondaryDilutionSolventVolumes, tertiaryDilutionSolventVolumes} = opsList;

				(* if we are NOT aliquoting, we need to make sure we don't overfill the sample's CURRENT container, otherwise we will need to check against the target container *)
				overfillBooleans = MapThread[
					Function[
						{
							aliquotAmount,
							targetVial,
							startingContainer,
							startingVolume,
							startingMass,
							dilutionSolventVolume,
							secondaryDilutionSolventVolume,
							tertiaryDilutionSolventVolume
						},
						Module[
							{aliquotQ, finalContainerModel, maxVolume, initialVolume, overfilledQ},

							(* did we need to aliquot? *)
							aliquotQ = !NullQ[aliquotAmount];

							finalContainerModel = If[aliquotQ,
								(* if we aliquoted then we took a known volume and put it in a known container on the rack so get the model *)
								Switch[
									targetVial,
									ObjectP[Object[]],
									Download[targetVial, Model, Cache -> cache, Simulation -> updatedSimulation],
									ObjectP[Model[]],
									Download[targetVial, Object, Cache -> cache, Simulation -> updatedSimulation],
									_,
									targetVial
								],
								(* if we didn't aliquot then we need to get the vial that the sample is already inside when it is placed on the rack *)
								Switch[
									startingContainer,
									ObjectP[Object[]],
									Download[startingContainer, Model, Cache -> cache, Simulation -> updatedSimulation],
									ObjectP[Model[]],
									Download[startingContainer, Object, Cache -> cache, Simulation -> updatedSimulation],
									_,
									startingContainer
								]
							];

							(* get the max volume of the container in question *)
							maxVolume = Download[finalContainerModel, MaxVolume, Cache -> cache, Simulation -> updatedSimulation];

							(* we need to know how much volume was inside the container to begin with. if we aliquoted we know, otherwise we have the starting amount. this will break if we get a solid so eventually we need to revisist this *)
							initialVolume = If[aliquotQ,
								aliquotAmount,
								startingVolume
							];

							(* figure out if the container is overfilled *)
							overfilledQ = If[Total[{initialVolume, dilutionSolventVolume, secondaryDilutionSolventVolume, tertiaryDilutionSolventVolume} /. {Null -> 0 * Liter}] > maxVolume /. {Null -> 0 * Liter},
								True,
								False
							]
						]
					],
					{
						aliquotAmounts,
						targetVials,
						startingContainers,
						startingVolumes,
						startingMasses,
						dilutionSolventVolumes,
						secondaryDilutionSolventVolumes,
						tertiaryDilutionSolventVolumes
					}
				]
			]
		],
		{
			{
				resolvedAliquotAmounts,
				resolvedTargetVials,
				simulatedSamples,
				simulatedContainerModels,
				simulatedSampleVolumes,
				simulatedSampleMasses,
				resolvedDilutionSolventVolumes,
				resolvedSecondaryDilutionSolventVolumes,
				resolvedTertiaryDilutionSolventVolumes
			},
			{
				resolvedStandardAliquotAmounts,
				resolvedStandardTargetVials,
				resolvedStandards,
				resolvedStandardVials,
				resolvedStandardAmounts /. {_?(CompatibleUnitQ[#, Liter]&) -> Null},
				resolvedStandardAmounts /. {_?(CompatibleUnitQ[#, Gram]&) -> Null},
				resolvedStandardDilutionSolventVolumes,
				resolvedStandardSecondaryDilutionSolventVolumes,
				resolvedStandardTertiaryDilutionSolventVolumes
			},
			{
				resolvedBlankAliquotAmounts,
				resolvedBlankTargetVials,
				resolvedBlanks,
				resolvedBlankVials,
				resolvedBlankAmounts /. {_?(CompatibleUnitQ[#, Liter]&) -> Null},
				resolvedBlankAmounts /. {_?(CompatibleUnitQ[#, Gram]&) -> Null},
				resolvedBlankDilutionSolventVolumes,
				resolvedBlankSecondaryDilutionSolventVolumes,
				resolvedBlankTertiaryDilutionSolventVolumes
			}
		}
	];

	(* if we have somehow overfilled our vials, we need to figure out the offending volumes *)
	{dilutionTuples, standardDilutionTuples, blankDilutionTuples} = Transpose /@ {
		{resolvedDilutionSolventVolumes, resolvedSecondaryDilutionSolventVolumes, resolvedTertiaryDilutionSolventVolumes},
		{resolvedStandardDilutionSolventVolumes, resolvedStandardSecondaryDilutionSolventVolumes, resolvedStandardTertiaryDilutionSolventVolumes},
		{resolvedBlankDilutionSolventVolumes, resolvedBlankSecondaryDilutionSolventVolumes, resolvedBlankTertiaryDilutionSolventVolumes}
	};

	(* get the specified dilutions that are overfilling our containers *)
	{offendingDilutions, offendingStandardDilutions, offendingBlankDilutions} = MapThread[
		Function[{tuples, booleans},
			PickList[tuples, booleans, True]
		],
		{
			{dilutionTuples, standardDilutionTuples, blankDilutionTuples},
			{overfilledSampleQ, overfilledStandardQ, overfilledBlankQ}
		}
	];

	(* figure the offending option names *)
	offendingDilutionOptions = Flatten@MapThread[
		Function[{dilutionList, prefix},
			PickList[
				ToExpression[StringJoin[prefix, #]]& /@ {"DilutionSolventVolume", "SecondaryDilutionSolventVolume", "TertiaryDilutionSolventVolume"},
				MemberQ[#, Except[Null]]& /@ {dilutionList[[All, 1]], dilutionList[[All, 2]], dilutionList[[All, 3]]},
				True]
		],
		{
			{offendingDilutions, offendingStandardDilutions, offendingBlankDilutions},
			{"", "Standard", "Blank"}
		}
	];

	(*throw errors if we should*)
	If[Length[offendingDilutionOptions] > 0 && !gatherTests,
		Message[Error::ContainersOverfilledByDilution, offendingDilutionOptions]
	];

	(* create tests *)
	overfilledContainerTests = If[gatherTests,
		Map[
			Test["None of the samples diluted using option " <> ToString[#] <> " result in the overfilling of the target analysis vial:",
				MemberQ[offendingDilutionOptions, #],
				False
			]&,
			{DilutionSolventVolume, SecondaryDilutionSolventVolume, TertiaryDilutionSolventVolume, StandardDilutionSolventVolume, StandardSecondaryDilutionSolventVolume,
				StandardTertiaryDilutionSolventVolume, BlankDilutionSolventVolume, BlankSecondaryDilutionSolventVolume, BlankTertiaryDilutionSolventVolume}
		],
		{}
	];

	(* resolve the Email option if Automatic *)
	resolvedEmail = If[!MatchQ[Lookup[roundedGasChromatographyOptions, Email], Automatic],
		(* If Email!=Automatic, use the supplied value *)
		Lookup[roundedGasChromatographyOptions, Email],
		(* If BOTH Upload -> True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[TrueQ[Lookup[roundedGasChromatographyOptions, Upload]], MemberQ[outputSpecification, Result]],
			True,
			False
		]
	];

	resolvedExperimentOptions = {
		SampleCaps -> resolvedSampleCaps,
		Instrument -> Lookup[roundedGasChromatographyOptions, Instrument],
		CarrierGas -> Lookup[roundedGasChromatographyOptions, CarrierGas],
		Inlet -> Lookup[roundedGasChromatographyOptions, Inlet],
		InletLiner -> resolvedInletLiner,
		LinerORing -> resolvedLinerORing,
		InletSeptum -> resolvedInletSeptum,
		Column -> column,
		TrimColumn -> resolvedTrimColumn,
		TrimColumnLength -> resolvedTrimColumnLength,
		ConditionColumn -> Lookup[roundedGasChromatographyOptions, ConditionColumn],
		ColumnConditioningGas -> resolvedColumnConditioningGas,
		(*ColumnConditioningGasFlowRate -> resolvedColumnConditioningGasFlowRate,*)
		ColumnConditioningTime -> resolvedColumnConditioningTime,
		ColumnConditioningTemperature -> resolvedColumnConditioningTemperature,
		LiquidInjectionSyringe -> resolvedLiquidInjectionSyringe,
		HeadspaceInjectionSyringe -> resolvedHeadspaceInjectionSyringe,
		SPMEInjectionFiber -> resolvedSPMEInjectionFiber,
		LiquidHandlingSyringe -> resolvedLiquidHandlingSyringe,
		Detector -> Lookup[roundedGasChromatographyOptions, Detector],
		DilutionSolvent -> resolvedDilutionSolvent,
		SecondaryDilutionSolvent -> resolvedSecondaryDilutionSolvent,
		TertiaryDilutionSolvent -> resolvedTertiaryDilutionSolvent,
		Dilute -> resolvedDilutes,
		DilutionSolventVolume -> resolvedDilutionSolventVolumes,
		SecondaryDilutionSolventVolume -> resolvedSecondaryDilutionSolventVolumes,
		TertiaryDilutionSolventVolume -> resolvedTertiaryDilutionSolventVolumes,
		Agitate -> resolvedAgitates,
		AgitationTime -> resolvedAgitationTimes,
		AgitationTemperature -> resolvedAgitationTemperatures,
		AgitationMixRate -> resolvedAgitationMixRates,
		AgitationOnTime -> resolvedAgitationOnTimes,
		AgitationOffTime -> resolvedAgitationOffTimes,
		Vortex -> resolvedVortexs,
		VortexMixRate -> resolvedVortexMixRates,
		VortexTime -> resolvedVortexTimes,
		SamplingMethod -> resolvedSamplingMethods,
		HeadspaceSyringeTemperature -> resolvedHeadspaceSyringeTemperatures,
		SyringeWashSolvent -> resolvedSyringeWashSolvent,
		SecondarySyringeWashSolvent -> resolvedSecondarySyringeWashSolvent,
		TertiarySyringeWashSolvent -> resolvedTertiarySyringeWashSolvent,
		QuaternarySyringeWashSolvent -> resolvedQuaternarySyringeWashSolvent,
		LiquidPreInjectionSyringeWash -> resolvedLiquidPreInjectionSyringeWashes,
		LiquidPreInjectionSyringeWashVolume -> resolvedLiquidPreInjectionSyringeWashVolumes,
		LiquidPreInjectionSyringeWashRate -> resolvedLiquidPreInjectionSyringeWashRates,
		LiquidPreInjectionNumberOfSolventWashes -> resolvedLiquidPreInjectionNumberOfSolventWashes,
		LiquidPreInjectionNumberOfSecondarySolventWashes -> resolvedLiquidPreInjectionNumberOfSecondarySolventWashes,
		LiquidPreInjectionNumberOfTertiarySolventWashes -> resolvedLiquidPreInjectionNumberOfTertiarySolventWashes,
		LiquidPreInjectionNumberOfQuaternarySolventWashes -> resolvedLiquidPreInjectionNumberOfQuaternarySolventWashes,
		LiquidSampleWash -> resolvedLiquidSampleWashes,
		NumberOfLiquidSampleWashes -> resolvedNumberOfLiquidSampleWashes,
		LiquidSampleWashVolume -> resolvedLiquidSampleWashVolumes,
		LiquidSampleFillingStrokes -> resolvedLiquidSampleFillingStrokes,
		LiquidSampleFillingStrokesVolume -> resolvedLiquidSampleFillingStrokesVolumes,
		LiquidFillingStrokeDelay -> resolvedLiquidFillingStrokeDelays,
		HeadspaceSyringeFlushing -> resolvedHeadspaceSyringeFlushings,
		HeadspacePreInjectionFlushTime -> resolvedHeadspacePreInjectionFlushTimes,
		SPMECondition -> resolvedSPMEConditions,
		SPMEConditioningTemperature -> resolvedSPMEConditioningTemperatures,
		SPMEPreConditioningTime -> resolvedSPMEPreConditioningTimes,
		SPMEDerivatizingAgent -> resolvedSPMEDerivatizingAgents,
		SPMEDerivatizingAgentAdsorptionTime -> resolvedSPMEDerivatizingAgentAdsorptionTimes,
		SPMEDerivatizationPosition -> resolvedSPMEDerivatizationPositions,
		SPMEDerivatizationPositionOffset -> resolvedSPMEDerivatizationPositionOffsets,
		AgitateWhileSampling -> resolvedAgitateWhileSamplings,
		SampleVialAspirationPosition -> Lookup[roundedGasChromatographyOptions, SampleVialAspirationPosition],
		SampleVialAspirationPositionOffset -> resolvedSampleVialAspirationPositionOffsets,
		SampleVialPenetrationRate -> Lookup[roundedGasChromatographyOptions, SampleVialPenetrationRate],
		InjectionVolume -> resolvedInjectionVolumes,
		LiquidSampleOverAspirationVolume -> resolvedLiquidSampleOverAspirationVolumes,
		SampleAspirationRate -> resolvedSampleAspirationRates,
		SampleAspirationDelay -> resolvedSampleAspirationDelays,
		SPMESampleExtractionTime -> resolvedSPMESampleExtractionTimes,
		InjectionInletPenetrationDepth -> Lookup[roundedGasChromatographyOptions, InjectionInletPenetrationDepth],
		InjectionInletPenetrationRate -> Lookup[roundedGasChromatographyOptions, InjectionInletPenetrationRate],
		InjectionSignalMode -> Lookup[roundedGasChromatographyOptions, InjectionSignalMode],
		PreInjectionTimeDelay -> Lookup[roundedGasChromatographyOptions, PreInjectionTimeDelay],
		SampleInjectionRate -> resolvedSampleInjectionRates,
		SPMESampleDesorptionTime -> resolvedSPMESampleDesorptionTimes,
		PostInjectionTimeDelay -> Lookup[roundedGasChromatographyOptions, PostInjectionTimeDelay],
		LiquidPostInjectionSyringeWash -> resolvedLiquidPostInjectionSyringeWashes,
		LiquidPostInjectionSyringeWashVolume -> resolvedLiquidPostInjectionSyringeWashVolumes,
		LiquidPostInjectionSyringeWashRate -> resolvedLiquidPostInjectionSyringeWashRates,
		LiquidPostInjectionNumberOfSolventWashes -> resolvedLiquidPostInjectionNumberOfSolventWashes,
		LiquidPostInjectionNumberOfSecondarySolventWashes -> resolvedLiquidPostInjectionNumberOfSecondarySolventWashes,
		LiquidPostInjectionNumberOfTertiarySolventWashes -> resolvedLiquidPostInjectionNumberOfTertiarySolventWashes,
		LiquidPostInjectionNumberOfQuaternarySolventWashes -> resolvedLiquidPostInjectionNumberOfQuaternarySolventWashes,
		PostInjectionNextSamplePreparationSteps -> resolvedPostInjectionNextSamplePreparationSteps,
		HeadspacePostInjectionFlushTime -> resolvedHeadspacePostInjectionFlushTimes,
		SPMEPostInjectionConditioningTime -> resolvedSPMEPostInjectionConditioningTimes,
		SeparationMethod -> resolvedSeparationMethodAssociations,
		InletSeptumPurgeFlowRate -> specifiedInletSeptumPurgeFlowRates,
		InitialInletTemperature -> resolvedInitialInletTemperatures,
		InitialInletTemperatureDuration -> resolvedInitialInletTemperatureDurations,
		InletTemperatureProfile -> resolvedInletTemperatureProfiles /. {{} -> Null},
		SplitRatio -> resolvedSplitRatios,
		SplitVentFlowRate -> resolvedSplitVentFlowRates,
		SplitlessTime -> resolvedSplitlessTimes,
		InitialInletPressure -> resolvedInitialInletPressures,
		InitialInletTime -> resolvedInitialInletTimes,
		GasSaver -> resolvedGasSavers,
		GasSaverFlowRate -> resolvedGasSaverFlowRates,
		GasSaverActivationTime -> resolvedGasSaverActivationTimes,
		SolventEliminationFlowRate -> resolvedSolventEliminationFlowRates,
		InitialColumnFlowRate -> RoundOptionPrecision[N[resolvedInitialColumnFlowRates], 0.0001 Milliliter / Minute],
		InitialColumnPressure -> RoundOptionPrecision[N[resolvedInitialColumnPressures], 0.001 PSI],
		InitialColumnAverageVelocity -> RoundOptionPrecision[N[resolvedInitialColumnAverageVelocities], 0.0001 Centimeter / Second],
		InitialColumnResidenceTime -> RoundOptionPrecision[N[resolvedInitialColumnResidenceTimes], 0.0001 Minute],
		InitialColumnSetpointDuration -> resolvedInitialColumnSetpointDurations,
		ColumnPressureProfile -> resolvedColumnPressureProfiles,
		ColumnFlowRateProfile -> resolvedColumnFlowRateProfiles,
		OvenEquilibrationTime -> resolvedOvenEquilibrationTimes,
		InitialOvenTemperature -> specifiedInitialOvenTemperatures,
		InitialOvenTemperatureDuration -> specifiedInitialOvenTemperatureDurations,
		OvenTemperatureProfile -> resolvedOvenTemperatureProfiles,
		PostRunOvenTemperature -> resolvedPostRunOvenTemperatures,
		PostRunOvenTime -> resolvedPostRunOvenTimes,
		PostRunFlowRate -> resolvedPostRunFlowRates,
		PostRunPressure -> resolvedPostRunPressures,
		(* detector options *)
		(*FID*)
		FIDTemperature -> resolvedFIDTemperature,
		FIDAirFlowRate -> resolvedFIDAirFlowRate,
		FIDDihydrogenFlowRate -> resolvedFIDDihydrogenFlowRate,
		FIDMakeupGas -> resolvedFIDMakeupGas,
		FIDMakeupGasFlowRate -> resolvedFIDMakeupGasFlowRate,
		CarrierGasFlowCorrection -> resolvedCarrierGasFlowCorrection,
		FIDDataCollectionFrequency -> resolvedFIDDataCollectionFrequency,
		(*Mass Spec*)
		TransferLineTemperature -> resolvedTransferLineTemperature,
		IonSource -> resolvedIonSource,
		IonMode -> resolvedIonMode,
		SourceTemperature -> resolvedSourceTemperature,
		QuadrupoleTemperature -> resolvedQuadrupoleTemperature,
		SolventDelay -> resolvedSolventDelay,
		MassDetectionGain -> resolvedMassDetectionGain,
		MassRangeThreshold -> resolvedMassRangeThreshold,
		TraceIonDetection -> resolvedTraceIonDetection,
		AcquisitionWindowStartTime -> resolvedAcquisitionWindowStartTime,
		MassRange -> resolvedMassRange,
		MassRangeScanSpeed -> resolvedMassRangeScanSpeed,
		MassSelection -> resolvedMassSelection,
		MassSelectionResolution -> resolvedMassSelectionResolution,
		MassSelectionDetectionGain -> resolvedMassSelectionDetectionGain,
		(*replicates*)
		NumberOfReplicates -> Lookup[roundedGasChromatographyOptions, NumberOfReplicates],
		(*standards*)
		Standard -> resolvedStandards,
		StandardVial -> resolvedStandardVials,
		StandardCaps -> resolvedStandardCaps,
		StandardAmount -> resolvedStandardAmounts,
		StandardDilute -> resolvedStandardDilutes,
		StandardDilutionSolventVolume -> resolvedStandardDilutionSolventVolumes,
		StandardSecondaryDilutionSolventVolume -> resolvedStandardSecondaryDilutionSolventVolumes,
		StandardTertiaryDilutionSolventVolume -> resolvedStandardTertiaryDilutionSolventVolumes,
		StandardAgitate -> resolvedStandardAgitates,
		StandardAgitationTime -> resolvedStandardAgitationTimes,
		StandardAgitationTemperature -> resolvedStandardAgitationTemperatures,
		StandardAgitationMixRate -> resolvedStandardAgitationMixRates,
		StandardAgitationOnTime -> resolvedStandardAgitationOnTimes,
		StandardAgitationOffTime -> resolvedStandardAgitationOffTimes,
		StandardVortex -> resolvedStandardVortexs,
		StandardVortexMixRate -> resolvedStandardVortexMixRates,
		StandardVortexTime -> resolvedStandardVortexTimes,
		StandardSamplingMethod -> resolvedStandardSamplingMethods,
		StandardHeadspaceSyringeTemperature -> resolvedStandardHeadspaceSyringeTemperatures,
		StandardLiquidPreInjectionSyringeWash -> resolvedStandardLiquidPreInjectionSyringeWashes,
		StandardLiquidPreInjectionSyringeWashVolume -> resolvedStandardLiquidPreInjectionSyringeWashVolumes,
		StandardLiquidPreInjectionSyringeWashRate -> resolvedStandardLiquidPreInjectionSyringeWashRates,
		StandardLiquidPreInjectionNumberOfSolventWashes -> resolvedStandardLiquidPreInjectionNumberOfSolventWashes,
		StandardLiquidPreInjectionNumberOfSecondarySolventWashes -> resolvedStandardLiquidPreInjectionNumberOfSecondarySolventWashes,
		StandardLiquidPreInjectionNumberOfTertiarySolventWashes -> resolvedStandardLiquidPreInjectionNumberOfTertiarySolventWashes,
		StandardLiquidPreInjectionNumberOfQuaternarySolventWashes -> resolvedStandardLiquidPreInjectionNumberOfQuaternarySolventWashes,
		StandardLiquidSampleWash -> resolvedStandardLiquidSampleWashes,
		StandardNumberOfLiquidSampleWashes -> resolvedStandardNumberOfLiquidSampleWashes,
		StandardLiquidSampleWashVolume -> resolvedStandardLiquidSampleWashVolumes,
		StandardLiquidSampleFillingStrokes -> resolvedStandardLiquidSampleFillingStrokes,
		StandardLiquidSampleFillingStrokesVolume -> resolvedStandardLiquidSampleFillingStrokesVolumes,
		StandardLiquidFillingStrokeDelay -> resolvedStandardLiquidFillingStrokeDelays,
		StandardHeadspaceSyringeFlushing -> resolvedStandardHeadspaceSyringeFlushings,
		StandardHeadspacePreInjectionFlushTime -> resolvedStandardHeadspacePreInjectionFlushTimes,
		StandardSPMECondition -> resolvedStandardSPMEConditions,
		StandardSPMEConditioningTemperature -> resolvedStandardSPMEConditioningTemperatures,
		StandardSPMEPreConditioningTime -> resolvedStandardSPMEPreConditioningTimes,
		StandardSPMEDerivatizingAgent -> resolvedStandardSPMEDerivatizingAgents,
		StandardSPMEDerivatizingAgentAdsorptionTime -> resolvedStandardSPMEDerivatizingAgentAdsorptionTimes,
		StandardSPMEDerivatizationPosition -> resolvedStandardSPMEDerivatizationPositions,
		StandardSPMEDerivatizationPositionOffset -> resolvedStandardSPMEDerivatizationPositionOffsets,
		StandardAgitateWhileSampling -> resolvedStandardAgitateWhileSamplings,
		StandardSampleVialAspirationPosition -> Lookup[expandedStandardsAssociation, StandardSampleVialAspirationPosition],
		StandardSampleVialAspirationPositionOffset -> resolvedStandardSampleVialAspirationPositionOffsets,
		StandardSampleVialPenetrationRate -> Lookup[expandedStandardsAssociation, StandardSampleVialPenetrationRate],
		StandardInjectionVolume -> resolvedStandardInjectionVolumes,
		StandardLiquidSampleOverAspirationVolume -> resolvedStandardLiquidSampleOverAspirationVolumes,
		StandardSampleAspirationRate -> resolvedStandardSampleAspirationRates,
		StandardSampleAspirationDelay -> resolvedStandardSampleAspirationDelays,
		StandardSPMESampleExtractionTime -> resolvedStandardSPMESampleExtractionTimes,
		StandardInjectionInletPenetrationDepth -> Lookup[expandedStandardsAssociation, StandardInjectionInletPenetrationDepth],
		StandardInjectionInletPenetrationRate -> Lookup[expandedStandardsAssociation, StandardInjectionInletPenetrationRate],
		StandardInjectionSignalMode -> Lookup[expandedStandardsAssociation, StandardInjectionSignalMode],
		StandardPreInjectionTimeDelay -> Lookup[expandedStandardsAssociation, StandardPreInjectionTimeDelay],
		StandardSampleInjectionRate -> resolvedStandardSampleInjectionRates,
		StandardSPMESampleDesorptionTime -> resolvedStandardSPMESampleDesorptionTimes,
		StandardPostInjectionTimeDelay -> Lookup[expandedStandardsAssociation, StandardPostInjectionTimeDelay],
		StandardLiquidPostInjectionSyringeWash -> resolvedStandardLiquidPostInjectionSyringeWashes,
		StandardLiquidPostInjectionSyringeWashVolume -> resolvedStandardLiquidPostInjectionSyringeWashVolumes,
		StandardLiquidPostInjectionSyringeWashRate -> resolvedStandardLiquidPostInjectionSyringeWashRates,
		StandardLiquidPostInjectionNumberOfSolventWashes -> resolvedStandardLiquidPostInjectionNumberOfSolventWashes,
		StandardLiquidPostInjectionNumberOfSecondarySolventWashes -> resolvedStandardLiquidPostInjectionNumberOfSecondarySolventWashes,
		StandardLiquidPostInjectionNumberOfTertiarySolventWashes -> resolvedStandardLiquidPostInjectionNumberOfTertiarySolventWashes,
		StandardLiquidPostInjectionNumberOfQuaternarySolventWashes -> resolvedStandardLiquidPostInjectionNumberOfQuaternarySolventWashes,
		StandardPostInjectionNextSamplePreparationSteps -> resolvedStandardPostInjectionNextSamplePreparationSteps,
		StandardHeadspacePostInjectionFlushTime -> resolvedStandardHeadspacePostInjectionFlushTimes,
		StandardSPMEPostInjectionConditioningTime -> resolvedStandardSPMEPostInjectionConditioningTimes,
		StandardSeparationMethod -> resolvedStandardSeparationMethodAssociations,
		StandardInletSeptumPurgeFlowRate -> specifiedStandardInletSeptumPurgeFlowRates,
		StandardInitialInletTemperature -> resolvedStandardInitialInletTemperatures,
		StandardInitialInletTemperatureDuration -> resolvedStandardInitialInletTemperatureDurations,
		StandardInletTemperatureProfile -> resolvedStandardInletTemperatureProfiles /. {{} -> Null},
		StandardSplitRatio -> resolvedStandardSplitRatios,
		StandardSplitVentFlowRate -> resolvedStandardSplitVentFlowRates,
		StandardSplitlessTime -> resolvedStandardSplitlessTimes,
		StandardInitialInletPressure -> resolvedStandardInitialInletPressures,
		StandardInitialInletTime -> resolvedStandardInitialInletTimes,
		StandardGasSaver -> resolvedStandardGasSavers,
		StandardGasSaverFlowRate -> resolvedStandardGasSaverFlowRates,
		StandardGasSaverActivationTime -> resolvedStandardGasSaverActivationTimes,
		StandardSolventEliminationFlowRate -> resolvedStandardSolventEliminationFlowRates,
		StandardInitialColumnFlowRate -> If[!NullQ[resolvedStandardInitialColumnFlowRates], RoundOptionPrecision[N[resolvedStandardInitialColumnFlowRates], 0.0001 Milliliter / Minute], Null],
		StandardInitialColumnPressure -> If[!NullQ[resolvedStandardInitialColumnPressures], RoundOptionPrecision[N[resolvedStandardInitialColumnPressures], 0.001 PSI], Null],
		StandardInitialColumnAverageVelocity -> If[!NullQ[resolvedStandardInitialColumnAverageVelocities], RoundOptionPrecision[N[resolvedStandardInitialColumnAverageVelocities], 0.0001 Centimeter / Second], Null],
		StandardInitialColumnResidenceTime -> If[!NullQ[resolvedStandardInitialColumnResidenceTimes], RoundOptionPrecision[N[resolvedStandardInitialColumnResidenceTimes], 0.0001 Minute], Null],
		StandardInitialColumnSetpointDuration -> resolvedStandardInitialColumnSetpointDurations,
		StandardColumnPressureProfile -> resolvedStandardColumnPressureProfiles,
		StandardColumnFlowRateProfile -> resolvedStandardColumnFlowRateProfiles,
		StandardOvenEquilibrationTime -> resolvedStandardOvenEquilibrationTimes,
		StandardInitialOvenTemperature -> specifiedStandardInitialOvenTemperatures,
		StandardInitialOvenTemperatureDuration -> specifiedStandardInitialOvenTemperatureDurations,
		StandardOvenTemperatureProfile -> resolvedStandardOvenTemperatureProfiles,
		StandardPostRunOvenTemperature -> resolvedStandardPostRunOvenTemperatures,
		StandardPostRunOvenTime -> resolvedStandardPostRunOvenTimes,
		StandardPostRunFlowRate -> resolvedStandardPostRunFlowRates,
		StandardPostRunPressure -> resolvedStandardPostRunPressures,
		StandardFrequency -> resolvedStandardFrequency,
		Blank -> resolvedBlanks,
		BlankVial -> resolvedBlankVials,
		BlankCaps -> resolvedBlankCaps,
		BlankAmount -> resolvedBlankAmounts,
		BlankDilute -> resolvedBlankDilutes,
		BlankDilutionSolventVolume -> resolvedBlankDilutionSolventVolumes,
		BlankSecondaryDilutionSolventVolume -> resolvedBlankSecondaryDilutionSolventVolumes,
		BlankTertiaryDilutionSolventVolume -> resolvedBlankTertiaryDilutionSolventVolumes,
		BlankAgitate -> resolvedBlankAgitates,
		BlankAgitationTime -> resolvedBlankAgitationTimes,
		BlankAgitationTemperature -> resolvedBlankAgitationTemperatures,
		BlankAgitationMixRate -> resolvedBlankAgitationMixRates,
		BlankAgitationOnTime -> resolvedBlankAgitationOnTimes,
		BlankAgitationOffTime -> resolvedBlankAgitationOffTimes,
		BlankVortex -> resolvedBlankVortexs,
		BlankVortexMixRate -> resolvedBlankVortexMixRates,
		BlankVortexTime -> resolvedBlankVortexTimes,
		BlankSamplingMethod -> resolvedBlankSamplingMethods,
		BlankHeadspaceSyringeTemperature -> resolvedBlankHeadspaceSyringeTemperatures,
		BlankLiquidPreInjectionSyringeWash -> resolvedBlankLiquidPreInjectionSyringeWashes,
		BlankLiquidPreInjectionSyringeWashVolume -> resolvedBlankLiquidPreInjectionSyringeWashVolumes,
		BlankLiquidPreInjectionSyringeWashRate -> resolvedBlankLiquidPreInjectionSyringeWashRates,
		BlankLiquidPreInjectionNumberOfSolventWashes -> resolvedBlankLiquidPreInjectionNumberOfSolventWashes,
		BlankLiquidPreInjectionNumberOfSecondarySolventWashes -> resolvedBlankLiquidPreInjectionNumberOfSecondarySolventWashes,
		BlankLiquidPreInjectionNumberOfTertiarySolventWashes -> resolvedBlankLiquidPreInjectionNumberOfTertiarySolventWashes,
		BlankLiquidPreInjectionNumberOfQuaternarySolventWashes -> resolvedBlankLiquidPreInjectionNumberOfQuaternarySolventWashes,
		BlankLiquidSampleWash -> resolvedBlankLiquidSampleWashes,
		BlankNumberOfLiquidSampleWashes -> resolvedBlankNumberOfLiquidSampleWashes,
		BlankLiquidSampleWashVolume -> resolvedBlankLiquidSampleWashVolumes,
		BlankLiquidSampleFillingStrokes -> resolvedBlankLiquidSampleFillingStrokes,
		BlankLiquidSampleFillingStrokesVolume -> resolvedBlankLiquidSampleFillingStrokesVolumes,
		BlankLiquidFillingStrokeDelay -> resolvedBlankLiquidFillingStrokeDelays,
		BlankHeadspaceSyringeFlushing -> resolvedBlankHeadspaceSyringeFlushings,
		BlankHeadspacePreInjectionFlushTime -> resolvedBlankHeadspacePreInjectionFlushTimes,
		BlankSPMECondition -> resolvedBlankSPMEConditions,
		BlankSPMEConditioningTemperature -> resolvedBlankSPMEConditioningTemperatures,
		BlankSPMEPreConditioningTime -> resolvedBlankSPMEPreConditioningTimes,
		BlankSPMEDerivatizingAgent -> resolvedBlankSPMEDerivatizingAgents,
		BlankSPMEDerivatizingAgentAdsorptionTime -> resolvedBlankSPMEDerivatizingAgentAdsorptionTimes,
		BlankSPMEDerivatizationPosition -> resolvedBlankSPMEDerivatizationPositions,
		BlankSPMEDerivatizationPositionOffset -> resolvedBlankSPMEDerivatizationPositionOffsets,
		BlankAgitateWhileSampling -> resolvedBlankAgitateWhileSamplings,
		BlankSampleVialAspirationPosition -> Lookup[expandedBlanksAssociation, BlankSampleVialAspirationPosition],
		BlankSampleVialAspirationPositionOffset -> resolvedBlankSampleVialAspirationPositionOffsets,
		BlankSampleVialPenetrationRate -> Lookup[expandedBlanksAssociation, BlankSampleVialPenetrationRate],
		BlankInjectionVolume -> resolvedBlankInjectionVolumes,
		BlankLiquidSampleOverAspirationVolume -> resolvedBlankLiquidSampleOverAspirationVolumes,
		BlankSampleAspirationRate -> resolvedBlankSampleAspirationRates,
		BlankSampleAspirationDelay -> resolvedBlankSampleAspirationDelays,
		BlankSPMESampleExtractionTime -> resolvedBlankSPMESampleExtractionTimes,
		BlankInjectionInletPenetrationDepth -> Lookup[expandedBlanksAssociation, BlankInjectionInletPenetrationDepth],
		BlankInjectionInletPenetrationRate -> Lookup[expandedBlanksAssociation, BlankInjectionInletPenetrationRate],
		BlankInjectionSignalMode -> Lookup[expandedBlanksAssociation, BlankInjectionSignalMode],
		BlankPreInjectionTimeDelay -> Lookup[expandedBlanksAssociation, BlankPreInjectionTimeDelay],
		BlankSampleInjectionRate -> resolvedBlankSampleInjectionRates,
		BlankSPMESampleDesorptionTime -> resolvedBlankSPMESampleDesorptionTimes,
		BlankPostInjectionTimeDelay -> Lookup[expandedBlanksAssociation, BlankPostInjectionTimeDelay],
		BlankLiquidPostInjectionSyringeWash -> resolvedBlankLiquidPostInjectionSyringeWashes,
		BlankLiquidPostInjectionSyringeWashVolume -> resolvedBlankLiquidPostInjectionSyringeWashVolumes,
		BlankLiquidPostInjectionSyringeWashRate -> resolvedBlankLiquidPostInjectionSyringeWashRates,
		BlankLiquidPostInjectionNumberOfSolventWashes -> resolvedBlankLiquidPostInjectionNumberOfSolventWashes,
		BlankLiquidPostInjectionNumberOfSecondarySolventWashes -> resolvedBlankLiquidPostInjectionNumberOfSecondarySolventWashes,
		BlankLiquidPostInjectionNumberOfTertiarySolventWashes -> resolvedBlankLiquidPostInjectionNumberOfTertiarySolventWashes,
		BlankLiquidPostInjectionNumberOfQuaternarySolventWashes -> resolvedBlankLiquidPostInjectionNumberOfQuaternarySolventWashes,
		BlankPostInjectionNextSamplePreparationSteps -> resolvedBlankPostInjectionNextSamplePreparationSteps,
		BlankHeadspacePostInjectionFlushTime -> resolvedBlankHeadspacePostInjectionFlushTimes,
		BlankSPMEPostInjectionConditioningTime -> resolvedBlankSPMEPostInjectionConditioningTimes,
		BlankSeparationMethod -> resolvedBlankSeparationMethodAssociations,
		BlankInletSeptumPurgeFlowRate -> specifiedBlankInletSeptumPurgeFlowRates,
		BlankInitialInletTemperature -> resolvedBlankInitialInletTemperatures,
		BlankInitialInletTemperatureDuration -> resolvedBlankInitialInletTemperatureDurations,
		BlankInletTemperatureProfile -> resolvedBlankInletTemperatureProfiles /. {{} -> Null},
		BlankSplitRatio -> resolvedBlankSplitRatios,
		BlankSplitVentFlowRate -> resolvedBlankSplitVentFlowRates,
		BlankSplitlessTime -> resolvedBlankSplitlessTimes,
		BlankInitialInletPressure -> resolvedBlankInitialInletPressures,
		BlankInitialInletTime -> resolvedBlankInitialInletTimes,
		BlankGasSaver -> resolvedBlankGasSavers,
		BlankGasSaverFlowRate -> resolvedBlankGasSaverFlowRates,
		BlankGasSaverActivationTime -> resolvedBlankGasSaverActivationTimes,
		BlankSolventEliminationFlowRate -> resolvedBlankSolventEliminationFlowRates,
		BlankInitialColumnFlowRate -> If[!NullQ[resolvedBlankInitialColumnFlowRates], RoundOptionPrecision[N[resolvedBlankInitialColumnFlowRates], 0.0001 Milliliter / Minute], Null],
		BlankInitialColumnPressure -> If[!NullQ[resolvedBlankInitialColumnPressures], RoundOptionPrecision[N[resolvedBlankInitialColumnPressures], 0.001 PSI], Null],
		BlankInitialColumnAverageVelocity -> If[!NullQ[resolvedBlankInitialColumnAverageVelocities], RoundOptionPrecision[N[resolvedBlankInitialColumnAverageVelocities], 0.0001 Centimeter / Second], Null],
		BlankInitialColumnResidenceTime -> If[!NullQ[resolvedBlankInitialColumnResidenceTimes], RoundOptionPrecision[N[resolvedBlankInitialColumnResidenceTimes], 0.0001 Minute], Null],
		BlankInitialColumnSetpointDuration -> resolvedBlankInitialColumnSetpointDurations,
		BlankColumnPressureProfile -> resolvedBlankColumnPressureProfiles,
		BlankColumnFlowRateProfile -> resolvedBlankColumnFlowRateProfiles,
		BlankOvenEquilibrationTime -> resolvedBlankOvenEquilibrationTimes,
		BlankInitialOvenTemperature -> specifiedBlankInitialOvenTemperatures,
		BlankInitialOvenTemperatureDuration -> specifiedBlankInitialOvenTemperatureDurations,
		BlankOvenTemperatureProfile -> resolvedBlankOvenTemperatureProfiles,
		BlankPostRunOvenTemperature -> resolvedBlankPostRunOvenTemperatures,
		BlankPostRunOvenTime -> resolvedBlankPostRunOvenTimes,
		BlankPostRunFlowRate -> resolvedBlankPostRunFlowRates,
		BlankPostRunPressure -> resolvedBlankPostRunPressures,
		BlankFrequency -> resolvedBlankFrequency,
		InjectionTable -> Normal /@ resolvedInjectionTable,
		Cache -> Lookup[myOptions, Cache],
		FastTrack -> Lookup[myOptions, FastTrack],
		Template -> Lookup[myOptions, Template],
		ParentProtocol -> Lookup[myOptions, ParentProtocol],
		Operator -> Lookup[myOptions, Operator],
		Confirm -> Lookup[myOptions, Confirm],
		CanaryBranch -> Lookup[myOptions, CanaryBranch],
		Name -> Lookup[myOptions, Name],
		Upload -> Lookup[myOptions, Upload],
		Output -> Lookup[myOptions, Output],
		Email -> resolvedEmail,
		SamplesInStorageCondition -> Lookup[roundedGasChromatographyOptions, SamplesInStorageCondition],
		PreparatoryUnitOperations -> Lookup[myOptions, PreparatoryUnitOperations]
	};

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* === Error: Sample aspiration volume plus air gap exceeds the syringe volume for liquid samples === *)

	{drawVolumesTooLargeQ, standardDrawVolumesTooLargeQ, blankDrawVolumesTooLargeQ} = Map[
		Function[{optionsList},
			Module[{liquidSampleVolumes, liquidSampleOverAspirationVolumes},
				{liquidSampleVolumes, liquidSampleOverAspirationVolumes} = optionsList;
				MapThread[
					Function[{sampleVolume, airVolume},
						sampleVolume + airVolume <= resolvedLiquidInjectionSyringeVolume
					],
					{liquidSampleVolumes, liquidSampleOverAspirationVolumes}
				]
			]],
		{
			{resolvedLiquidSampleVolumes, resolvedLiquidSampleOverAspirationVolumes},
			{resolvedStandardLiquidSampleVolumes, resolvedStandardLiquidSampleOverAspirationVolumes},
			{resolvedBlankLiquidSampleVolumes, resolvedBlankLiquidSampleOverAspirationVolumes}
		}
	];

	{incompatibleSampleAndAirVolumes, incompatibleStandardSampleAndAirVolumes, incompatibleBlankSampleAndAirVolumes} = Map[
		Function[{optionsList},
			Module[{liquidSampleVolumes, liquidSampleOverAspirationVolumes, volumesTooLargeQ},
				{liquidSampleVolumes, liquidSampleOverAspirationVolumes, volumesTooLargeQ} = optionsList;
				Transpose@{PickList[liquidSampleVolumes, volumesTooLargeQ], PickList[liquidSampleOverAspirationVolumes, volumesTooLargeQ]}
			]],
		{
			{resolvedLiquidSampleVolumes, resolvedLiquidSampleOverAspirationVolumes, drawVolumesTooLargeQ},
			{resolvedStandardLiquidSampleVolumes, resolvedStandardLiquidSampleOverAspirationVolumes, standardDrawVolumesTooLargeQ},
			{resolvedBlankLiquidSampleVolumes, resolvedBlankLiquidSampleOverAspirationVolumes, blankDrawVolumesTooLargeQ}
		}
	];

	MapThread[
		Function[{error, errorCheckingQ, optionsToReport},
			If[!gatherTests && errorCheckingQ,
				Message[error, optionsToReport],
				Nothing
			]
		],
		Transpose@{
			{Error::IncompatibleLiquidSampleAndOveraspirationVolumes, drawVolumesTooLargeQ, incompatibleSampleAndAirVolumes},
			{Error::IncompatibleStandardLiquidSampleAndOveraspirationVolumes, standardDrawVolumesTooLargeQ, incompatibleStandardSampleAndAirVolumes},
			{Error::IncompatibleBlankLiquidSampleAndOveraspirationVolumes, blankDrawVolumesTooLargeQ, incompatibleBlankSampleAndAirVolumes}
		}
	];

	(* gather them tests *)


	(* === Error: Total sample volume required (injection(s), pre, post wash) is insufficient === *)

	(* === Warning: Transfer line temperature is below maximum column temperature === *)

	(* === Error: SPME Conditioning or Inlet temperature exceeds fiber limit === *)

	(* === Error: Specified column flow rate and split ratio results in split flow that exceeds 1250 cm3/min === *)

	(* Convert all column specifications into interpolated column flowrate, pressure, and temperature functions *)

	(* === Error: On-deck dilutions exceed the volume of the container === *)

	(* === Warning: Flow/Pressure/MMI/Pulsed Injection/other profile/time exceeds the length of the column oven profile. All profile information after the end of the column oven temperature profile will not be executed. If the profiles are shorter the final parameter will be extended until the end of the temperature profile === *)

	(* === Error: Pressure or flow rate ramp options are specified but the column mode is not compatible with the ramp (e.g. ramped pressure with a flow rate profile or constant profile) === *)

	(* === Error: too many samples check 2? probably only makes sense to do 1 check but hey *)



	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, containerlessInvalidInputs}]];
	invalidOptions = DeleteDuplicates[Flatten[{
		invalidTrimOptions, incompatibleORing, incompatibleSeptum, invalidInputColumns, liquidInjectionSyringeOption, headspaceInjectionSyringeOption, spmeInjectionFiberOption, liquidHandlingSyringeOption,
		conflictingColumnConditioningOptions, ovenTimeTemperatureConflictOptions, agitationConflictOptions, offendingDilutionOptions, vortexConflictOptions, preInjectionSyringeWashesConflictOptions,
		sampleWashConflictOptions, insufficientSampleVolumeOptions, postInjectionSyringeWashesConflictOptions, headspaceFlushingConflictOptions, spmeConflictConflictOptions, headspaceAgitationConflictOptions,
		cospecifiedOptionsOptions, invalidBlankPrepOptions, standardBlankTransferErrorOptions, incompatibleAliquotContainersOptions, invalidGCSampleVolumeOutOfRangeOptions, cospecifiedStandardOptions,
		cospecifiedSampleOptions, cospecifiedBlankOptions, incompatibleDetectorOptions, incompatibleNullDetectorOptions, gasSaverConflictOptions, incompatibleInletOptions, conflictingLiquidSamplingOptions,
		conflictingHeadspaceSamplingOptions, conflictingSPMESamplingOptions, conflictingStandardLiquidSamplingOptions, conflictingStandardHeadspaceSamplingOptions, conflictingStandardHeadspaceSamplingOptions,
		conflictingStandardSPMESamplingOptions, conflictingBlankLiquidSamplingOptions, conflictingBlankHeadspaceSamplingOptions, conflictingBlankSPMESamplingOptions, optionValueOutOfBoundsOptions,
		incompatibleDetectorOptions, tooManySmallSamplesInvalidOption, tooManyBigSamplesInvalidOption, noCapForContainerInvalidOptions, noStandardVialCapInvalidOption, invalidBlankVialCapInvalidOption}]];

	allTests = DeleteDuplicates[Flatten[{
		samplePrepTests, discardedTest, containersExistTest, validProtocolNameTest, tooManySamplesTest, inletTemperatureProfileTests, columnPressureProfileTests, columnFlowRateProfileTests,
		ovenTemperatureProfileTests, precisionTests, standardInletTemperatureProfileTests, blankInletTemperatureProfileTests, standardColumnPressureProfileTests, blankColumnPressureProfileTests,
		standardColumnFlowRateProfileTests, blankColumnFlowRateProfileTests, standardOvenTemperatureProfileTests, blankOvenTemperatureProfileTests, invalidStandardBlankTests, invalidInjectionTableTests,
		foreignBlankTest, foreignStandardTest, cospecifiedSampleOptionsTests, cospecifiedStandardOptionsTests, cospecifiedBlankOptionsTests, outOfRangeLiquidSampleVolumeTests, outOfRangeStandardLiquidSampleVolumeTests,
		outOfRangeHeadspaceSampleVolumeTests, outOfRangeStandardHeadspaceSampleVolumeTests, tooColdOvenTemperatureProfileTests, tooColdPostRunOvenTemperatureTests, tooColdInitialOvenTemperatureTests,
		tooColdStandardOvenTemperatureProfileTests, tooColdStandardPostRunOvenTemperatureTests, tooColdStandardInitialOvenTemperatureTests, tooColdBlankOvenTemperatureProfileTests,
		tooColdBlankPostRunOvenTemperatureTests, tooColdBlankInitialOvenTemperatureTests, tooHotOvenTemperatureProfileTests, tooHotPostRunOvenTemperatureTests, tooHotInitialOvenTemperatureTests,
		tooHotStandardOvenTemperatureProfileTests, tooHotStandardPostRunOvenTemperatureTests, tooHotStandardInitialOvenTemperatureTests, tooHotBlankOvenTemperatureProfileTests, tooHotBlankPostRunOvenTemperatureTests,
		tooHotBlankInitialOvenTemperatureTests, inletOptionsCompatibleTests, conflictingSamplingMethodTests, ovenTimeTemperatureConflictTests, agitationConflictTests, outOfRangeBlankHeadspaceSampleVolumeTests,
		outOfRangeBlankLiquidSampleVolumeTests, sampleAspirationRatesOutOfBoundsTest, standardAspirationRatesOutOfBoundsTest, blankAspirationRatesOutOfBoundsTest, sampleInjectionRatesOutOfBoundsTest, standardInjectionRatesOutOfBoundsTest,
		blankInjectionRatesOutOfBoundsTest, headspaceSampleAspirationRatesOutOfBoundsTest, headspaceStandardAspirationRatesOutOfBoundsTest, headspaceBlankAspirationRatesOutOfBoundsTest, headspaceSampleInjectionRatesOutOfBoundsTest,
		headspaceStandardInjectionRatesOutOfBoundsTest, headspaceBlankInjectionRatesOutOfBoundsTest, capForVialTests, capForStandardVialTests, capForBlankVialTests,

		conflictingTrimOptionsTest, compatibleORingTest, compatibleSeptumTest, unneededSyringeTests, conditionColumnTests, invalidColumnsTest, liquidInjectionSyringeTests, headspaceInjectionSyringeTests,
		spmeInjectionFiberTests, agitationConflictTests, overfilledContainerTests, vortexConflictTests, preInjectionSyringeWashesConflictTests, sampleWashConflictTests, insufficientSampleVolumeTests,
		postInjectionSyringeWashesConflictTests, headspaceFlushingConflictTests, spmeConflictConflictTests, headspaceAgitationConflictTests, cospecifiedOptionsTests, invalidBlankPrepOpsTest, standardBlankTransferErrorTests,
		incompatibleAliquotContainersTest, incompatibleDetectorOptionTests, incompatibleNullDetectorOptionTests, gasSaverConflictTests
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && !gatherTests,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Simulation -> updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && !gatherTests,
		Message[Error::InvalidOption, invalidOptions]
	];

	(*do the required aliquot resolution*)
	(* Extract shared options relevant for aliquotting *)
	aliquotOptions = KeySelect[samplePrepOptions, And[MatchQ[#, Alternatives @@ ToExpression[Options[AliquotOptions][[All, 1]]]], MemberQ[Keys[samplePrepOptions], #]]&];

	(*-- CONTAINER GROUPING RESOLUTION --*)

	(*{resolvedAliquotAmounts,resolvedTargetVials} = Transpose@MapThread[
		Function[{aliquot,vial,amount},
			If[aliquot,
				{amount,vial},
				{Null,Null}
			]
		],
		{aliquotQ,targetVials,requiredAliquotAmounts}
	];

	{resolvedStandardAliquotAmounts,resolvedStandardTargetVials} = Transpose@MapThread[
		Function[{aliquot,vial,amount},
			If[aliquot,
				{amount,vial},
				{Null,Null}
			]
		],
		{aliquotStandardQ,targetStandardVials,requiredStandardAliquotAmounts}
	];

	{resolvedBlankAliquotAmounts,resolvedBlankTargetVials} = Transpose@MapThread[
		Function[{aliquot,vial,amount},
			If[aliquot,
				{amount,vial},
				{Null,Null}
			]
		],
		{aliquotBlankQ,targetBlankVials,requiredBlankAliquotAmounts}
	];*)

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		(* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[ExperimentGasChromatography,
			mySamples,
			simulatedSamples,
			ReplaceRule[Normal@aliquotOptions, resolvedSamplePrepOptions],
			Cache -> cache,
			Simulation->updatedSimulation,
			RequiredAliquotAmounts -> resolvedAliquotAmounts,
			RequiredAliquotContainers -> resolvedTargetVials,
			Output -> {Result, Tests},
			AllowSolids -> True
		],
		{
			resolveAliquotOptions[
				ExperimentGasChromatography,
				mySamples,
				simulatedSamples,
				ReplaceRule[Normal@aliquotOptions, resolvedSamplePrepOptions],
				Cache -> cache,
				Simulation->updatedSimulation,
				RequiredAliquotAmounts -> resolvedAliquotAmounts,
				RequiredAliquotContainers -> resolvedTargetVials,
				Output -> Result,
				AllowSolids -> True
			], {}}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* Return our resolved options and/or tests. *)
	resolvedOptions = Flatten[{
		resolvedExperimentOptions,
		resolvedSamplePrepOptions,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions
	}];

	(* Return our resolved options and/or tests. *)
	outputSpecification /. {
		Result -> resolvedOptions,
		Tests -> allTests
	}
];


(* ::Subsection::Closed:: *)
(* Resource Packets *)


(* ::Subsubsection:: *)
(* GasChromatographyResourcePackets *)

DefineOptions[experimentGasChromatographyResourcePackets,
	Options :> {OutputOption, CacheOption, SimulationOption}
];

experimentGasChromatographyResourcePackets[mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, ops : OptionsPattern[]] := Module[
	{
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, inheritedCache, numReplicates,
		expandedSamplesWithNumReplicates, instrumentTime, protocolPacket, sharedFieldPacket, finalizedPacket,
		allResourceBlobs, fulfillable, frqTests, testsRule, resultRule, expandedOptionsWithNumReplicates, uniqueSamples, uniqueSamplePackets, sampleContainers, specifiedAliquotAmount,
		uniqueSampleResources, sampleResources, samplePositions, standardPositions, blankPositions, injectionTableSamples, injectionTableStandards, injectionTableBlanks,
		uniqueStandards, targetStandardVials, resolvedStandardAmounts, resolvedStandards, standardTuples, assignedStandardTuples, groupedStandardsTuples,
		groupedStandardsPositionVolumes, standardVialAssociation, standardAmountAssociation, groupedStandard, flatStandardResources, linkedStandardResources, injectionTable,
		operatorResource, dilutionContainerVolume, resolvedDilutionSolvents, dilutionSolventResources, syringeWashContainerVolume, resolvedSyringeWashSolvents,
		syringeWashSolventResources, liquidInjectionSyringeResource, headspaceInjectionSyringeResource, liquidHandlingSyringeResource, spmeFiberResource, columnResources,
		linerResource, linerORingResource, septumResource, columnJoinResource, standardLookup, blankLookup, standardMappingAssociation, blankMappingAssociation,
		standardReverseAssociation, blankReverseAssociation, sampleReverseAssociation, tableSeparationMethods, sampleSeparationMethod, standardSeparationMethod,
		blankSeparationMethod, resolvedSeparationMethods, separationMethodInPlace, separationMethodObjectsToMake, linkedSampleResources, injectionTableWithLinks,
		sampleTuples, insertionAssociation, injectionTableInserted, injectionTableWithReplicates, injectionTableUploadable, allPackets, uniqueSeparationMethodPackets,
		resolvedBlanks, resolvedInletModes, resolvedStandardInletModes, resolvedBlankInletModes, inletOptions, standardInletOptions, blankInletOptions,
		columnOptions, standardColumnOptions, blankColumnOptions, resolvedGCColumnModes, resolvedStandardGCColumnModes, resolvedBlankGCColumnModes, inlet, columns,
		detector, columnModels, columnDiameters, guardColumns, columnsWithGuardColumns, installedColumnSegments, columnAssembly, linerAndSeptumInstallation,
		attachColumnFrontEnd, columnConditioningTime, attachColumnBackEnd, dilutionTime, agitationTime, vortexTime, syringePrepTime, sampleWashTime, separationTime,
		instrumentTimeTentative, columnNutResources, columnFerruleResources, trimColumnLengths, installedColumnFittings, requiredColumnJoins, swagingToolResource,
		columnWaferResource, columnsRequested, resolvedSampleCaps, resolvedStandardCaps, resolvedSolventContainerCaps, uniqueAliquotAmounts, specifiedAliquotContainer,
		uniqueAliquotContainers, sampleContainerModelFootprints, uniqueAliquotContainerFootprints, uniqueStandardVialFootprints, simulation,
		allStandards, allTargetStandardVials, allResolvedStandardAmounts, columnAssemblySimplified, injectionTime, swagingToolResourceMSD, allBlanks,
		allTargetBlankVials, allResolvedBlankAmounts, targetBlankVials, resolvedBlankAmounts, uniqueBlankVialFootprints, blankTuples, assignedBlankTuples,
		groupedBlanksTuples, groupedBlanksPositionVolumes, blankVialAssociation, blankAmountAssociation, groupedBlank, uniqueBlanks, flatBlankResources, linkedBlankResources,
		resolvedBlankCaps, columnGreenSeptaResource, columnRedSeptaResource, resolvedDilutionSolventVolumes, finalPrepTime, sampleCapResources, standardCapResources, blankCapResources,
		makeReverseAssociation
	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentGasChromatography, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentGasChromatography,
		RemoveHiddenOptions[ExperimentGasChromatography, expandedResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionDefault[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache = Lookup[ToList[ops], Cache];
	simulation = Lookup[ToList[ops], Simulation];

	(* Get the number of replicates specified *)
	numReplicates = Lookup[expandedResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(* Exapnd the samples according to the number of replicates *)
	{expandedSamplesWithNumReplicates, expandedOptionsWithNumReplicates} = expandNumberOfReplicates[ExperimentGasChromatography, (mySamples /. x_Link :> Download[x, Object, Cache -> inheritedCache, Date -> Now]), expandedResolvedOptions];

	(* pull out the AliquotAmount option *)
	{specifiedAliquotAmount, specifiedAliquotContainer} = Lookup[expandedResolvedOptions, {AliquotAmount, AliquotContainer}];

	(* Delete any duplicate input samples to create a single resource per unique sample *)
	{uniqueSamples, uniqueAliquotAmounts, uniqueAliquotContainers} = Transpose@DeleteDuplicates[Transpose@{mySamples, specifiedAliquotAmount, specifiedAliquotContainer}];

	(* Extract packets for sample objects *)
	uniqueSamplePackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[uniqueSamples, Object, Cache -> inheritedCache, Simulation -> simulation, Date -> Now];

	(*get the unique sample containers*)
	sampleContainers = Download[Lookup[uniqueSamplePackets, Container], Object, Cache -> inheritedCache, Simulation -> simulation, Date -> Now];

	(* get the resolved injection table *)
	injectionTable = Lookup[expandedOptionsWithNumReplicates, InjectionTable];

	(* do we need to expand the injection table with number of replicates as well? TODO figure out, probably yes *)

	(* === Create Resources for SamplesIn === *)
	uniqueSampleResources = MapThread[
		Function[{sample, aliquotAmount},
			If[MatchQ[aliquotAmount, Null],
				Resource[Sample -> sample, Name -> CreateUUID[]],
				Resource[Sample -> sample, Name -> CreateUUID[], Amount -> aliquotAmount]
			]
		],
		{uniqueSamples, uniqueAliquotAmounts}
	];

	(* Expand sample resources to index match mySamples *)
	sampleResources = Map[
		uniqueSampleResources[[First[FirstPosition[uniqueSamples, #]]]]&,
		mySamples
	];

	(*get all of the positions so that it's easy to update the injection table*)
	{samplePositions, standardPositions, blankPositions} = Map[
		Sequence @@@ Position[injectionTable, {#, ___}]&,
		{Sample, Standard, Blank}
	];

	{injectionTableSamples, injectionTableStandards, injectionTableBlanks} = Map[
		Cases[injectionTable, {#, ___}]&,
		{Sample, Standard, Blank}
	];

	(* as has been explained in other code using the InjectionTable option, we may need to reconstruct the injection table with
	 resources so I've stolen snippets of code from SFC here as cases arise that more information should be added *)
	(*a helper function used to make the reverse dictionary so that we can go from the injection table positon to the other variables*)
	makeReverseAssociation[inputAssociation : Null] := Null;
	makeReverseAssociation[inputAssociation_Association] := Association[
		SortBy[Flatten@Map[
			Function[{rule},
				Map[# -> First[rule]&, Last[rule]]
			], Normal@inputAssociation]
			, First]
	];

	(*look up the standards and the blanks*)
	{standardLookup, blankLookup} = ToList /@ Lookup[expandedOptionsWithNumReplicates, {Standard, Blank}];

	(* create the map of the standards *)
	standardMappingAssociation = If[MatchQ[standardLookup, Null | {Null} | {}],
		(*first check whether there is anything here*)
		Null,
		(*otherwise we have to partition the positions by the length of our standards and map through*)
		Association@MapIndexed[Function[{positionSet, index}, First[index] -> positionSet], Transpose@Partition[standardPositions, Length[standardLookup]]]
	];

	(*do the blanks in the same way*)
	blankMappingAssociation = If[MatchQ[blankLookup, Null | {Null} | {}],
		(*first check whether there is anything here*)
		Null,
		(*otherwise we have to partition the positions by the length of our blank and map through*)
		Association@MapIndexed[Function[{positionSet, index}, First[index] -> positionSet], Transpose@Partition[blankPositions, Length[blankLookup]]]
	];

	(*make the reverse associations for standards and blanks*)
	{standardReverseAssociation, blankReverseAssociation} = Map[makeReverseAssociation, {standardMappingAssociation, blankMappingAssociation}];

	(*also make the one for the samples*)
	sampleReverseAssociation = Association@MapIndexed[
		Function[{position, index},
			position -> First[index]
		], samplePositions
	];

	(*get the unique sample container model footprints. to make this work we have to pick only the non-failed download since there could be an object or meodel*)
	{sampleContainerModelFootprints, uniqueAliquotContainerFootprints} = Flatten /@ Quiet[
		Download[
			{sampleContainers, If[!NullQ[#], Last[#], #]& /@ uniqueAliquotContainers},
			{Footprint, Model[Footprint]},
			Cache -> inheritedCache,
			Simulation -> simulation,
			Date -> Now
		],
		{
			Download::FieldDoesntExist,
			Download::NotLinkField,
			Download::MissingCacheField,
			Download::NotLinkField,
			Download::ObjectDoesNotExist
		}
		(* remove the failed downloads *)
	] /. {$Failed -> Nothing};

	(* === Generate the standards resources. Once again a lot of code here borrowed from SFC. Most of the huffing and panting has been removed === *)

	(* Get all the standards from the injection table *)
	{allStandards, allBlanks} = {injectionTableStandards[[All, 2]], injectionTableBlanks[[All, 2]]};

	{allTargetStandardVials, allResolvedStandardAmounts} = If[Length[injectionTableStandards] > 0,
		Transpose@Lookup[injectionTableStandards[[All, 4]], {StandardVial, StandardAmount}]/. {_Missing -> Null},
		{{}, {}}
	];

	{allTargetBlankVials, allResolvedBlankAmounts} = If[Length[injectionTableBlanks] > 0,
		(* we might have a case where a NoInjection means that these keys aren't found in the prep options. for now we just convert missing to Null so they can be downloaded*)
		Transpose@Lookup[injectionTableBlanks[[All, 4]], {BlankVial, BlankAmount}] /. {_Missing -> Null},
		{{}, {}}
	];

	(* All the standard amounts and vials were resolved in the resolver using the same automatic logic as the samples. they can also be specified as options *)
	{resolvedStandards, targetStandardVials, resolvedStandardAmounts} = If[Length[injectionTableStandards] > 0,
		Transpose@DeleteDuplicates[Transpose@{allStandards, allTargetStandardVials, allResolvedStandardAmounts}],
		{{}, {}, {}}
	];

	(* same for blanks *)
	{resolvedBlanks, targetBlankVials, resolvedBlankAmounts} = If[Length[injectionTableBlanks] > 0,
		Transpose@DeleteDuplicates[Transpose@{allBlanks, allTargetBlankVials, allResolvedBlankAmounts}],
		{{}, {}, {}}
	];

	(* also generate footprints for the standard/blank vial targets: *)
	{
		uniqueStandardVialFootprints,
		uniqueBlankVialFootprints
	} = Map[
		Flatten,
		Quiet[
			Download[
				{
					targetStandardVials,
					targetBlankVials
				},
				{
					Footprint,
					Model[Footprint]
				},
				Cache -> inheritedCache,
				Simulation -> simulation,
				Date -> Now
			],
			{
				Download::FieldDoesntExist,
				Download::NotLinkField,
				Download::MissingCacheField
			}
		]
	] /. {$Failed -> Nothing};

	(*get the standard and blank samples out*)
	standardTuples = injectionTable[[standardPositions]];

	blankTuples = injectionTable[[blankPositions]];

	(*assign the position to these *)
	assignedStandardTuples = MapThread[#1 -> #2&, {standardPositions, standardTuples}];

	assignedBlankTuples = MapThread[#1 -> #2&, {blankPositions, blankTuples}];

	(*then group by the sample sample type (e.g. <|standard1->{1->{Standard,standard1,10 Microliter,__},2->{Standard,standard1, 5 Microliter,__}}, standard2 ->... |>*)
	groupedStandardsTuples = GroupBy[assignedStandardTuples, Last[#][[2]]&];

	groupedBlanksTuples = GroupBy[assignedBlankTuples, Last[#][[2]]&];

	(*then simplify further by selecting out the positoin and the sampliing method <|standard1->{LiquidInjection}*)
	groupedStandardsPositionVolumes = Map[Function[{eachUniqueStandard},
		Transpose[{Keys[eachUniqueStandard], Values[eachUniqueStandard][[All, 3]]}]
	],
		groupedStandardsTuples];

	groupedBlanksPositionVolumes = Map[Function[{eachUniqueBlank},
		Transpose[{Keys[eachUniqueBlank], Values[eachUniqueBlank][[All, 3]]}]
	],
		groupedBlanksTuples];

	(* Here because I've foolishly given the option for the use to specify the amount and vial for each standard, we have to go back and create lookup tables for the vial and aliquot amount of each sample *)
	standardVialAssociation = Association[Rule @@ #& /@ (Transpose@{resolvedStandards, targetStandardVials})];
	standardAmountAssociation = Association[Rule @@ #& /@ (Transpose@{resolvedStandards, resolvedStandardAmounts})];

	blankVialAssociation = Association[Rule @@ #& /@ (Transpose@{resolvedBlanks, targetBlankVials})];
	blankAmountAssociation = Association[Rule @@ #& /@ (Transpose@{resolvedBlanks, resolvedBlankAmounts})];

	(*now we can finally make the resources*)
	(*we'll be left with a list of positions to a resource e.g. {{1,2}->Resource1,{3,4,5}->Resource2}*)
	groupedStandard = Map[
		Function[{rule},
			(*this is all of the positions*)
			(Last[rule][[All, 1]] ->
				Resource[
					Association[
						Sample -> First[rule],
						(*total the volume for the given group*)
						If[!NullQ[Lookup[standardAmountAssociation, First[rule]]],
							Amount -> Lookup[standardAmountAssociation, First[rule]],
							Nothing
						],
						If[!NullQ[Lookup[standardVialAssociation, First[rule]]],
							Container -> Lookup[standardVialAssociation, First[rule]],
							Nothing
						],
						Name -> CreateUUID[],
						Type -> Object[Resource, Sample]
					]
				]
			)
		],
		(*convert to a list*)
		Normal@groupedStandardsPositionVolumes
	];

	groupedBlank = Map[
		Function[{rule},
			(*this is all of the positions*)
			(Last[rule][[All, 1]] ->
				If[NullQ[First[rule]],
					(*  *)
					Null,
					Resource[
						Association[
							Sample -> First[rule],
							(*total the volume for the given group*)
							If[!NullQ[Lookup[blankAmountAssociation, First[rule]]],
								Amount -> Lookup[blankAmountAssociation, First[rule]],
								Nothing
							],
							If[!NullQ[Lookup[blankVialAssociation, First[rule]]],
								Container -> Lookup[blankVialAssociation, First[rule]],
								Nothing
							],
							Name -> CreateUUID[],
							Type -> Object[Resource, Sample]
						]
					]
				]
			)
		],
		(*convert to a list*)
		Normal@groupedBlanksPositionVolumes
	];

	(* also get the unique standard resources *)
	uniqueStandards = Values[groupedStandard];

	uniqueBlanks = Values[groupedBlank];

	(*now we can flatten this list to our standards, index matched to the samples {1->Resource1, 2->Resource1, ... }*)
	flatStandardResources = SortBy[
		Map[Function[{rule},
			Sequence @@ Map[# -> Last[rule]&, First[rule]]
		], groupedStandard], First];

	flatBlankResources = SortBy[
		Map[Function[{rule},
			Sequence @@ Map[# -> Last[rule]&, First[rule]]
		], groupedBlank], First];

	(*take the values and surround with link*)
	linkedStandardResources = Map[Link, Values[flatStandardResources]];

	linkedBlankResources = Map[Link, Values[flatBlankResources]];

	(* also need to make new separation method objects, once again borrowing code from SFC here *)

	(*dereference any named objects*)
	tableSeparationMethods = injectionTable[[All, 5]] /. {x : ObjectP[Object[Method]] :> Download[x, Object, Date -> Now]};

	(*get all of the other separation methods and see how many of them are objects*)
	{sampleSeparationMethod, standardSeparationMethod, blankSeparationMethod} = Lookup[expandedOptionsWithNumReplicates,
		{SeparationMethod, StandardSeparationMethod, BlankSeparationMethod}
	];

	(*all resolved separation methods*)
	resolvedSeparationMethods = Join[Cases[{sampleSeparationMethod, standardSeparationMethod, blankSeparationMethod}, Except[Null | {Null}]]];

	(*find all of the separation methods where there is already a method*)
	separationMethodInPlace = Flatten@Cases[Flatten[resolvedSeparationMethods], ListableP[ObjectP[Object[Method]]]];

	(*take the complement of the table separation methods and the ones already in place*)
	(*we'll need to create packets for all of these separation method objects*)
	separationMethodObjectsToMake = Complement[tableSeparationMethods, separationMethodInPlace];

	(* this should be enough to get us over the finish line and reconstruct the injection table. luckily no column nonsense needed here. *)

	(*update everything within our injection table*)
	linkedSampleResources = Link /@ sampleResources;

	(*initialize our injectionTable with links*)
	injectionTableWithLinks = injectionTable;

	(*update all of the samples+standards*)
	injectionTableWithLinks[[samplePositions, 2]] = linkedSampleResources;
	injectionTableWithLinks[[standardPositions, 2]] = linkedStandardResources;
	injectionTableWithLinks[[blankPositions, 2]] = linkedBlankResources;

	(* we need to put a protecting group on the sample preparation options so they don't get mashed by the flattening *)
	injectionTableWithLinks[[All, 4]] = Map[Association[#]&, injectionTableWithLinks[[All, 4]]];

	(*change all of the gradients to links*)
	injectionTableWithLinks[[All, 5]] = (Link /@ tableSeparationMethods);

	(* use number of replicates to expand the effective injection table *)

	(* get all of the sample tuples *)
	sampleTuples = injectionTableWithLinks[[samplePositions]];

	(*make our insertion association (e.g. in the format of position to be inserted (P) and list to be inserted <|2 -> {{Sample,sample1,___}...}, *)
	insertionAssociation = MapThread[
		Function[{position, tuple},
			position -> ConstantArray[tuple, numReplicates - 1]
		],
		{samplePositions, sampleTuples}
	];

	(*fold through and insert these tuples into our injection table*)
	injectionTableInserted = If[numReplicates > 1, Fold[Insert[#1, Last[#2], First[#2]] &, injectionTableWithLinks, insertionAssociation], injectionTableWithLinks];

	(*flatten and reform our injection table: note the partition length in case more fields are added: currently doesn't seem to be needed*)
	injectionTableWithReplicates = Partition[Flatten[injectionTableInserted], 5];

	(*finally make our uploadable injection table*)
	injectionTableUploadable = MapThread[Function[{type, sample, samplingMethod, prepOptions, separationMethod},
		Association[
			Type -> type,
			Sample -> sample,
			SamplingMethod -> samplingMethod,
			(* deprotect the prep options, and consider making these an association permanently so we don't have to do this manipulation *)
			SamplePreparationOptions -> Normal[prepOptions],
			SeparationMethod -> separationMethod,
			Data -> Null
		]
	], Transpose[injectionTableWithReplicates]
	];

	resolvedBlanks = Lookup[expandedOptionsWithNumReplicates, Blank];

	(*One final thing to do is make the separation method packets, enter some more sfc code*)

	(*will map through and make a separation method for each based on the object ID*)
	uniqueSeparationMethodPackets = Map[
		Function[
			{separationMethodObjectID},
			Module[
				{injectionTablePosition, currentType, currentSeparationMethodAssociation},

				(*find the injection Table position*)
				injectionTablePosition = First@FirstPosition[tableSeparationMethods, separationMethodObjectID];

				(*figure out the type, used to look up the separation method parameters*)
				currentType = First[injectionTable[[injectionTablePosition]]];

				(*get the separation method based on the type and the position*)
				currentSeparationMethodAssociation = Switch[currentType,
					Sample,
					ToList[sampleSeparationMethod][[injectionTablePosition /. sampleReverseAssociation]],
					Standard,
					ToList[standardSeparationMethod][[injectionTablePosition /. standardReverseAssociation]],
					Blank,
					ToList[blankSeparationMethod][[injectionTablePosition /. blankReverseAssociation]]
				];

				(*make the separation method packet*)
				Join[<|
					Object -> separationMethodObjectID,
					Type -> Object[Method, GasChromatography]
					(* and then we will add the right fields from the resolved options *)
				|>,
					Association[
						MapThread[
							Function[{key, value},
								Replace[key] -> value],
							{
								{
									ColumnLength,
									ColumnDiameter,
									ColumnFilmThickness,
									InletLinerVolume,
									Detector,
									CarrierGas,
									InletSeptumPurgeFlowRate,
									InitialInletTemperature,
									InitialInletTemperatureDuration,
									InletTemperatureProfile,
									SplitRatio,
									SplitVentFlowRate,
									SplitlessTime,
									InitialInletPressure,
									InitialInletTime,
									GasSaver,
									GasSaverFlowRate,
									GasSaverActivationTime,
									SolventEliminationFlowRate,
									InitialColumnFlowRate,
									InitialColumnPressure,
									InitialColumnAverageVelocity,
									InitialColumnResidenceTime,
									InitialColumnSetpointDuration,
									ColumnPressureProfile,
									ColumnFlowRateProfile,
									OvenEquilibrationTime,
									InitialOvenTemperature,
									InitialOvenTemperatureDuration,
									OvenTemperatureProfile,
									PostRunOvenTemperature,
									PostRunOvenTime,
									PostRunFlowRate,
									PostRunPressure
								},
								Lookup[currentSeparationMethodAssociation,
									{
										ColumnLength,
										ColumnDiameter,
										ColumnFilmThickness,
										InletLinerVolume,
										Detector,
										CarrierGas,
										InletSeptumPurgeFlowRate,
										InitialInletTemperature,
										InitialInletTemperatureDuration,
										InletTemperatureProfile,
										SplitRatio,
										SplitVentFlowRate,
										SplitlessTime,
										InitialInletPressure,
										InitialInletTime,
										GasSaver,
										GasSaverFlowRate,
										GasSaverActivationTime,
										SolventEliminationFlowRate,
										InitialColumnFlowRate,
										InitialColumnPressure,
										InitialColumnAverageVelocity,
										InitialColumnResidenceTime,
										InitialColumnSetpointDuration,
										ColumnPressureProfile,
										ColumnFlowRateProfile,
										OvenEquilibrationTime,
										InitialOvenTemperature,
										InitialOvenTemperatureDuration,
										OvenTemperatureProfile,
										PostRunOvenTemperature,
										PostRunOvenTime,
										PostRunFlowRate,
										PostRunPressure
									}
								]
							}
						]
					]
				]
			]
		],
		separationMethodObjectsToMake
	];

	(* === Generate the Dilution solvent resources === *)
	dilutionContainerVolume = 20 * Milliliter;
	resolvedDilutionSolvents = Lookup[expandedOptionsWithNumReplicates, {DilutionSolvent, SecondaryDilutionSolvent, TertiaryDilutionSolvent}];
	resolvedDilutionSolventVolumes = Lookup[expandedOptionsWithNumReplicates, {DilutionSolventVolume, SecondaryDilutionSolventVolume, TertiaryDilutionSolventVolume}];

	dilutionSolventResources = MapThread[
		Function[{solvent, volumes},
			If[NullQ[solvent],
				Null,
				Resource[Sample -> solvent, Container -> Model[Container, Vessel, "100 mL solvent container for PAL3 GC autosampler"], Amount -> Min[Ceiling[dilutionContainerVolume + Total[volumes /. {Null -> 0 * Milliliter}]], 100 * Milliliter]]
			]
		],
		{resolvedDilutionSolvents, resolvedDilutionSolventVolumes}
	];

	(* calculate the amount of each dilution solvent that will be used to make sure each can fit in a single container (100 mL, this should be more than sufficient but i'm prepared to eat my socks) *)

	(* fill as many as required up to the max with dilution solvent...consider calculating dilution usage then add some wiggle room to be less wasteful *)

	(* === Generate the syringe wash solvent resources === *)

	(* Calculate how much will be needed just in case it is more than the 10 mL that fit in the vial SPOILER: it won't be *)

	syringeWashContainerVolume = 10 * Milliliter;
	resolvedSyringeWashSolvents = Lookup[expandedOptionsWithNumReplicates, {SyringeWashSolvent, SecondarySyringeWashSolvent, TertiarySyringeWashSolvent, QuaternarySyringeWashSolvent}];

	syringeWashSolventResources = Map[
		Function[{solvent},
			If[NullQ[solvent],
				Null,
				Resource[Sample -> solvent, Container -> Model[Container, Vessel, "10 mL wash solvent vial for PAL3 GC autosampler"], Amount -> syringeWashContainerVolume]
			]
		],
		resolvedSyringeWashSolvents
	];

	(**)

	(* === Generate the injection tool resources: liquidInjection, headspaceInjection, liquidHandling syringes, SPME fiber === *)

	{
		liquidInjectionSyringeResource,
		headspaceInjectionSyringeResource,
		liquidHandlingSyringeResource,
		spmeFiberResource
	} = Map[
		Function[{injectionToolPart},
			If[NullQ[injectionToolPart],
				Null,
				Resource[Sample -> injectionToolPart, Name -> CreateUUID[]]
			]
		],
		Lookup[expandedOptionsWithNumReplicates, {LiquidInjectionSyringe, HeadspaceInjectionSyringe, LiquidHandlingSyringe, SPMEInjectionFiber}]
	];

	(* === Generate instrument hardware resources: Column, inlet liner+o-ring (typically they come together in a kit, that might be kind of annoying), column joins if the column isn't swaged yet === *)

	linerResource = Resource[Sample -> Lookup[expandedOptionsWithNumReplicates, InletLiner], Name -> CreateUUID[]];
	linerORingResource = Resource[Sample -> Lookup[expandedOptionsWithNumReplicates, LinerORing], Name -> CreateUUID[]];
	septumResource = Resource[Sample -> Lookup[expandedOptionsWithNumReplicates, InletSeptum], Name -> CreateUUID[]];

	(* we need to track connections already on columns, then determine from the column object if we need to get more parts. this will also be influence by TrimColumn option when it becomes available *)
	columnJoinResource = Resource[Sample -> Lookup[expandedOptionsWithNumReplicates, InletLiner], Name -> CreateUUID[]];


	(* === Resources for gas? === *)

	(* -- Get operator resource -- *)

	operatorResource = $BaselineOperator;

	(* post-resolve what the InletModes and ColumnModes are, because we need this info for the exporter *)

	{inletOptions, standardInletOptions, blankInletOptions } = {
		Lookup[expandedOptionsWithNumReplicates, {SplitRatio, SplitVentFlowRate, SplitlessTime, InitialInletPressure, SolventEliminationFlowRate, InitialInletTime}],
		Lookup[expandedOptionsWithNumReplicates, {StandardSplitRatio, StandardSplitVentFlowRate, StandardSplitlessTime, StandardInitialInletPressure, StandardSolventEliminationFlowRate, StandardInitialInletTime}],
		Lookup[expandedOptionsWithNumReplicates, {BlankSplitRatio, BlankSplitVentFlowRate, BlankSplitlessTime, BlankInitialInletPressure, BlankSolventEliminationFlowRate, BlankInitialInletTime}]
	};

	{resolvedInletModes, resolvedStandardInletModes, resolvedBlankInletModes} = Map[
		Function[{opsList},
			Module[{splitRatios, splitVentFlowRates, splitlessTimes, initialInletPressures, solventEliminationFlowRates, initialInletTimes, samplesLength},
				{splitRatios, splitVentFlowRates, splitlessTimes, initialInletPressures, solventEliminationFlowRates, initialInletTimes, samplesLength} = opsList;
				MapThread[
					Function[{splitRatio, splitVentFlowRate, splitlessTime, initialInletPressure, solventEliminationFlowRate, initialInletTime},
						Switch[
							{splitRatio, splitVentFlowRate, splitlessTime, initialInletPressure, solventEliminationFlowRate, initialInletTime, samplesLength},
							{_, _, _, _, _, _, EqualP[0]},
							Null,
							{Except[Null], (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), GreaterP[0]},
							Split,
							{(Automatic | Null), Except[Null], (Automatic | Null), (Automatic | Null), (Automatic | Null), (Automatic | Null), GreaterP[0]},
							Split,
							{(Automatic | Null), _, Except[Null], (Automatic | Null), (Automatic | Null), (Automatic | Null), GreaterP[0]},
							Splitless,
							{Except[Null], (Automatic | Null), (Automatic | Null), _, (Automatic | Null), _, GreaterP[0]},
							PulsedSplit,
							{(Automatic | Null), Except[Null], (Automatic | Null), _, (Automatic | Null), _, GreaterP[0]},
							PulsedSplit,
							{(Automatic | Null), _, Except[Null], _, (Automatic | Null), _, GreaterP[0]},
							PulsedSplitless,
							{(Automatic | Null), _, _, _, Except[Null], _, GreaterP[0]},
							SolventVent,
							{Null, Null, Null, (Automatic | Null), (Automatic | Null), (Automatic | Null), GreaterP[0]},
							DirectInjection,
							{_, _, _, _, _, _, GreaterP[0]},
							$Failed (* error checking should catch anything that would produce this result *)
						]
					],
					{splitRatios, splitVentFlowRates, splitlessTimes, initialInletPressures, solventEliminationFlowRates, initialInletTimes}
				]
			]
		],
		{
			Join[inletOptions, {Length[mySamples]}],
			Join[standardInletOptions, {Length[resolvedStandards /. {Null -> Nothing}]}],
			Join[blankInletOptions, {Length[resolvedBlanks /. {Null -> Nothing}]}]
		}
	];

	{ columnOptions, standardColumnOptions, blankColumnOptions } = {
		Lookup[expandedOptionsWithNumReplicates, {InitialColumnFlowRate, InitialColumnPressure, InitialColumnAverageVelocity, InitialColumnResidenceTime, InitialColumnSetpointDuration, ColumnPressureProfile, ColumnFlowRateProfile}],
		Lookup[expandedOptionsWithNumReplicates, {StandardInitialColumnFlowRate, StandardInitialColumnPressure, StandardInitialColumnAverageVelocity, StandardInitialColumnResidenceTime, StandardInitialColumnSetpointDuration, StandardColumnPressureProfile, StandardColumnFlowRateProfile}],
		Lookup[expandedOptionsWithNumReplicates, {BlankInitialColumnFlowRate, BlankInitialColumnPressure, BlankInitialColumnAverageVelocity, BlankInitialColumnResidenceTime, BlankInitialColumnSetpointDuration, BlankColumnPressureProfile, BlankColumnFlowRateProfile}]
	};

	{resolvedGCColumnModes, resolvedStandardGCColumnModes, resolvedBlankGCColumnModes} = Map[
		Function[{opsList},
			Module[{initialColumnFlowRates, initialColumnPressures, initialColumnAverageVelocitys, initialColumnResidenceTimes, initialColumnSetpointDurations, columnPressureProfiles, columnFlowRateProfiles, samplesLength},
				{initialColumnFlowRates, initialColumnPressures, initialColumnAverageVelocitys, initialColumnResidenceTimes, initialColumnSetpointDurations, columnPressureProfiles, columnFlowRateProfiles, samplesLength} = opsList;
				MapThread[
					Function[{initialColumnFlowRate, initialColumnPressure, initialColumnAverageVelocity, initialColumnResidenceTime, initialColumnSetpointDuration, columnPressureProfile, columnFlowRateProfile},
						Switch[
							{initialColumnFlowRate, initialColumnPressure, initialColumnAverageVelocity, initialColumnResidenceTime, initialColumnSetpointDuration, columnPressureProfile, columnFlowRateProfile, samplesLength},
							{_, _, _, _, _, _, _, EqualP[0]},
							Null,
							{_, _, _, _, _, _List, _, GreaterP[0]},
							PressureProfile,
							{_, _, _, _, _, _, _List, GreaterP[0]},
							FlowRateProfile,
							{_, _, _, _, _, GreaterEqualP[0 * PSI] | ConstantPressure, _, GreaterP[0]},
							ConstantPressure,
							{_, _, _, _, _, _, GreaterEqualP[0 * Milliliter / Minute] | ConstantFlowRate, GreaterP[0]},
							ConstantFlowRate,
							{_, _, _, _, _, _, _, GreaterP[0]},
							$Failed (* error checking should catch anything that would produce this result *)
						]
					],
					{initialColumnFlowRates, initialColumnPressures, initialColumnAverageVelocitys, initialColumnResidenceTimes, initialColumnSetpointDurations, columnPressureProfiles, columnFlowRateProfiles}
				]
			]
		],
		{
			Join[columnOptions, {Length[mySamples]}],
			Join[standardColumnOptions, {Length[resolvedStandards /. {Null -> Nothing}]}],
			Join[blankColumnOptions, {Length[resolvedBlanks /. {Null -> Nothing}]}]
		}
	];



	(* figure out how the columns will be installed: *)

	{inlet, detector} = Lookup[expandedOptionsWithNumReplicates, {Inlet, Detector}];
	columns = Flatten@Lookup[expandedOptionsWithNumReplicates, Column];

	(* get the column models *)
	columnModels = Map[
		Switch[
			#,
			ObjectP[Object[Item, Column]],
			Download[#, Model, Cache -> inheritedCache, Simulation -> simulation, Date -> Now],
			ObjectP[Model[Item, Column]],
			#,
			_,
			$Failed
		]&,
		columns
	];

	(* get the column diameters *)
	columnDiameters = ToList@Download[columnModels, Diameter, Cache -> inheritedCache, Simulation -> simulation, Date -> Now];

	(* determine if we will use a guard column *)
	guardColumns = False;

	columnsWithGuardColumns = If[guardColumns,
		Nothing(* something happens if we want to use guards *),
		columns
	];

	(* 	SSL insertion distance: 5 mm
				MMI insertion distance: 11 mm
				MSD insertion distance: EI XTR, SS, Inert, or CI: 1 mm from column guide tube
				FID insertion distance: 45 mm
				Ultimate union insertion distance: 1.5 mm
				*)

	(* creating column resources for MODELS ONLY, as they will be replaced with their requested objects at the beginning of the experiment *)
	columnResources = Map[
		Function[
			column,
			Resource[
				Sample -> Switch[
					column,
					ObjectP[Model[Item]],
					column,
					ObjectP[Object[Item]],
					Download[column, Model, Cache -> inheritedCache, Simulation -> simulation, Date -> Now]
				],
				Name -> ToString[Unique[]]]
		],
		columnsWithGuardColumns
	];

	columnsRequested = columnsWithGuardColumns;

	(* get the hardware params *)

	(* determine the column components we could possibly need by building the column assembly *)

	(* ferrule helper *)
	ferruleModel[myDiameter_, myConnectionType_] := Switch[
		myConnectionType,
		(Multimode | SplitSplitless | MassSpectrometer | Join),
		Switch[
			myDiameter,
			RangeP[0.1 * Millimeter, 0.25 * Millimeter],
			Model[Part, Ferrule, "Ultimetal GC column ferrule, for 0.1-0.25 mm ID GC column"],
			RangeP[0.26 * Millimeter, 0.44 * Millimeter],
			Model[Part, Ferrule, "Ultimetal GC column ferrule, for 0.32 mm ID GC column"],
			RangeP[0.45 * Millimeter, 0.60 * Millimeter],
			Model[Part, Ferrule, "Ultimetal GC column ferrule, for 0.53 mm ID GC column"]
		],
		FlameIonizationDetector,
		Switch[
			myDiameter,
			RangeP[0.1 * Millimeter, 0.25 * Millimeter],
			Model[Part, Ferrule, "Vespel/graphite GC column ferrule, for 0.1-0.25 mm ID GC column"],
			RangeP[0.26 * Millimeter, 0.44 * Millimeter],
			Model[Part, Ferrule, "Vespel/graphite GC column ferrule, for 0.32 mm ID GC column"],
			RangeP[0.45 * Millimeter, 0.60 * Millimeter],
			Model[Part, Ferrule, "Vespel/graphite GC column ferrule, for 0.53 mm ID GC column"]
		]
	];

	(* ferruleOffset helper *)
	ferruleOffset[myConnection_] := Switch[
		myConnection,
		Join,
		1.5 * Millimeter,
		SplitSplitless,
		5 * Millimeter,
		Multimode,
		13 * Millimeter,
		FlameIonizationDetector,
		45 * Millimeter,
		MassSpectrometer,
		1.5 * Millimeter (* measure and update *)
	];

	(* columnNut helper *)

	columnNutModel[myConnection_] := Switch[
		myConnection,
		(Multimode | SplitSplitless | FlameIonizationDetector),
		Model[Part, Nut, "GC capillary column nut, male, inlet/detector interface"],
		MassSpectrometer,
		(*Model[Part,Nut,"GC capillary column nut, female, MSD interface"],*)
		Model[Part, Nut, "Internal GC column nut for Ultimate Union"],
		Join,
		Model[Part, Nut, "Internal GC column nut for Ultimate Union"]
	];

	(* inlet length, inlet column ferrule, inlet column nut, column, outlet column nut, outlet column ferrule, outlet length *)

	installedColumnSegments = Switch[
		Length[columnsWithGuardColumns],
		1,
		(* single column case *)
		{
			{
				(* inlet length *)
				ferruleOffset[inlet],
				(* inlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[First@columnDiameters, inlet],
					Name -> CreateUUID[]
				],
				(* inlet ferrule nut *)
				Link@Resource[Sample -> columnNutModel[inlet], Name -> CreateUUID[]],
				(* column *)
				Link@First[columnResources],
				(* outlet ferrule nut *)
				Link@Resource[
					Sample -> columnNutModel[detector],
					Name -> CreateUUID[]
				],
				(* outlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[First@columnDiameters, detector],
					Name -> CreateUUID[]
				],
				(* outlet length *)
				ferruleOffset[detector]
			}
		},
		2,
		{
			(* first column case *)
			{
				(* inlet length *)
				ferruleOffset[inlet],
				(* inlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[First@columnDiameters, inlet],
					Name -> CreateUUID[]
				],
				(* inlet ferrule nut *)
				Link@Resource[Sample -> columnNutModel[inlet], Name -> CreateUUID[]],
				(* column *)
				Link@First[columnResources],
				(* outlet ferrule nut *)
				Link@Resource[Sample -> columnNutModel[Join], Name -> CreateUUID[]],
				(* outlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[First@columnDiameters, Join],
					Name -> CreateUUID[]
				],
				(* outlet length *)
				ferruleOffset[Join]
			},
			(* last column case *)
			{
				(* inlet length *)
				ferruleOffset[Join],
				(* inlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[Last@columnDiameters, Join],
					Name -> CreateUUID[]
				],
				(* inlet ferrule nut *)
				Link@Resource[Sample -> columnNutModel[Join], Name -> CreateUUID[]],
				(* column *)
				Link@Last[columnResources],
				(* outlet ferrule nut *)
				Link@Resource[Sample -> columnNutModel[detector],
					Name -> CreateUUID[]
				],
				(* outlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[Last@columnDiameters, detector],
					Name -> CreateUUID[]
				],
				(* outlet length *)
				ferruleOffset[detector]
			}
		},
		GreaterP[2],
		{
			(* first column case *)
			{
				(* inlet length *)
				ferruleOffset[inlet],
				(* inlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[First@columnDiameters, inlet],
					Name -> CreateUUID[]
				],
				(* inlet ferrule nut *)
				Link@Resource[
					Sample -> columnNutModel[inlet],
					Name -> CreateUUID[]],
				(* column *)
				Link@First[columnResources],
				(* outlet ferrule nut *)
				Link@Resource[
					Sample -> columnNutModel[Join],
					Name -> CreateUUID[]],
				(* outlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[First@columnDiameters, Join],
					Name -> CreateUUID[]
				],
				(* outlet length *)
				ferruleOffset[Join]
			},
			(* Most[Rest[columns]] *)
			Sequence @@ Map[
				Function[{columnDiameter, column},
					{
						(* inlet length *)
						ferruleOffset[Join],
						(* inlet ferrule *)
						Link@Resource[
							Sample -> ferruleModel[columnDiameter, Join],
							Name -> CreateUUID[]
						],
						(* inlet ferrule nut *)
						Link@Resource[
							Sample -> columnNutModel[Join],
							Name -> CreateUUID[]],
						(* column *)
						Link@column,
						(* outlet ferrule nut *)
						Link@Resource[
							Sample -> columnNutModel[Join],
							Name -> CreateUUID[]],
						(* outlet ferrule *)
						Link@Resource[
							Sample -> ferruleModel[columnDiameter, Join],
							Name -> CreateUUID[]
						],
						(* outlet length *)
						ferruleOffset[Join]
					}
				],
				{Most[Rest[columnDiameters]], Most[Rest[columnResources]]};
			],
			(* last column case *)
			{
				(* inlet length *)
				ferruleOffset[Join],
				(* inlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[Last@columnDiameters, Join],
					Name -> CreateUUID[]
				],
				(* inlet ferrule nut *)
				Link@Resource[
					Sample -> columnNutModel[Join],
					Name -> CreateUUID[]],
				(* column *)
				Link@Last[columnResources],
				(* outlet ferrule nut *)
				Link@Resource[
					Sample -> columnNutModel[detector],
					Name -> CreateUUID[]
				],
				(* outlet ferrule *)
				Link@Resource[
					Sample -> ferruleModel[Last@columnDiameters, detector],
					Name -> CreateUUID[]
				],
				(* outlet length *)
				ferruleOffset[detector]
			}
		}
	];

	trimColumnLengths = Lookup[myResolvedOptions, TrimColumnLength];

	(* turn the column assembly into installedColumnFittings, assuming everything must be changed *)
	installedColumnFittings = Flatten[
		MapThread[
			Function[{columnSegment, trimLength},
				{
					{columnSegment[[4]], "Column Inlet", If[MatchQ[trimLength, Null], 10 * Centimeter, trimLength], columnSegment[[3]], columnSegment[[2]], columnSegment[[1]]},
					{columnSegment[[4]], "Column Outlet", 10 * Centimeter, columnSegment[[5]], columnSegment[[6]], columnSegment[[7]]}
				}
			],
			{installedColumnSegments, trimColumnLengths}
		],
		1
	];

	columnNutResources = Partition[Flatten[Map[
		{
			{#[[3]], #[[4]], Inlet},
			{#[[5]], #[[4]], Outlet}
		}&,
		installedColumnSegments
	]], 3];

	columnFerruleResources = Partition[Flatten[Map[
		{
			{#[[2]], #[[4]], Inlet, #[[1]]},
			{#[[6]], #[[4]], Outlet, #[[7]]}
		}&,
		installedColumnSegments
	]], 4];

	columnAssembly = Riffle[installedColumnSegments, Link@Resource[Sample -> Model[Plumbing, ColumnJoin, "Ultimate Union, ultra inert"], Rent -> True]];

	columnAssemblySimplified = Map[
		Switch[#,
			_List,
			#[[4]],
			ObjectP[Object[Plumbing]],
			#
		]&,
		columnAssembly
	];

	requiredColumnJoins = Cases[columnAssembly, _Link, 1]; (* grab the column joins *)

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)

	(* instrument setup: *)
	(* install the new inlet liner & septum *)
	linerAndSeptumInstallation = 5 * Minute;
	(* begin to install the column *)
	attachColumnFrontEnd = 5 * Minute;
	(* lookup the column conditioning time *)
	columnConditioningTime = (Lookup[expandedOptionsWithNumReplicates, ColumnConditioningTime] /. {Null -> 0 * Minute}) + 35 * Minute; (* add a buffer for purging, heating and cooling *)
	(* finish installing column to the correct detector *)
	attachColumnBackEnd = 5 * Minute;
	(* estimate how long it will take to prepare the sample: *)
	(* get the dilution booleans, then approximate a time per dilution *)
	dilutionTime = Length[Cases[Flatten[Lookup[expandedOptionsWithNumReplicates, {Dilute, StandardDilute}]], True]] * 30 * Second;
	(* get the agitation time for each sample *)
	agitationTime = Total[Flatten[Lookup[expandedOptionsWithNumReplicates, {AgitationTime, StandardAgitationTime}]] /. {Null -> 0 * Minute}];
	(* get the vortex time for each sample *)
	vortexTime = Total[Flatten[Lookup[expandedOptionsWithNumReplicates, {VortexTime, StandardVortexTime}]] /. {Null -> 0 * Minute}];
	(* get the syringe wash parameters *)
	syringePrepTime = Length[Cases[Flatten[Lookup[expandedOptionsWithNumReplicates, {LiquidPreInjectionSyringeWash, StandardLiquidPreInjectionSyringeWash, BlankLiquidPreInjectionSyringeWash}]], True]] * 30 * Second
		+ Total[Flatten[Lookup[expandedOptionsWithNumReplicates, {HeadspacePreInjectionFlushTime, StandardHeadspacePreInjectionFlushTime, BlankHeadspacePreInjectionFlushTime}]] /. {Null -> 0 * Minute}]
		+ Total[Flatten[Lookup[expandedOptionsWithNumReplicates, {SPMEPreConditioningTime, StandardSPMEPreConditioningTime, BlankSPMEPreConditioningTime}]] /. {Null -> 0 * Minute}]
		+ Total[Flatten[Lookup[expandedOptionsWithNumReplicates, {SPMEDerivatizingAgentAdsorptionTime, StandardSPMEDerivatizingAgentAdsorptionTime, BlankSPMEDerivatizingAgentAdsorptionTime}]] /. {Null -> 0 * Minute}];
	(* get the sample wash parameters *)
	sampleWashTime = Total[Flatten[Lookup[expandedOptionsWithNumReplicates, {NumberOfLiquidSampleWashes, StandardNumberOfLiquidSampleWashes}]] /. {Null -> 0}] * 5 * Second
		+ Total[Flatten[Lookup[expandedOptionsWithNumReplicates, {LiquidFillingStrokeDelay, StandardLiquidFillingStrokeDelay}]] /. {Null -> 0 * Minute}];
	(* get the ??? *)
	(* get the PostInjectionNextSamplePreparationSteps if applicable *)
	(* figure out how long it takes to run the separation itself *)
	separationTime = 20 * Minute * (Length[mySamples] + Length[resolvedStandards] + Length[resolvedBlanks]);
	(* add everything together, or if PostInjectionNextSamplePreparationSteps allows, overlap them. we may need to change this if the instrument will always do sample prep independently *)
	instrumentTimeTentative = Total[{linerAndSeptumInstallation, attachColumnFrontEnd, columnConditioningTime, attachColumnBackEnd, dilutionTime, agitationTime, vortexTime, syringePrepTime, sampleWashTime, separationTime}];
	instrumentTime = If[CompatibleUnitQ[instrumentTimeTentative, Minute],
		instrumentTimeTentative,
		10 * Hour
	];

	(* If updating the injection time logic to be more accurate please also update estimateGCRunDuration *)
	injectionTime = Total[{dilutionTime, agitationTime, vortexTime, syringePrepTime, sampleWashTime, separationTime}];

	(* generate the resource for the tackle box, swaging tool, and column cutting wafer *)
	swagingToolResource = Link@Resource[
		Sample -> Model[Item, SwagingTool, "id:pZx9jo8jVz30"],
		Name -> CreateUUID[],
		Rent -> True
	];

	swagingToolResourceMSD = Link@Resource[
		Sample -> Model[Item, SwagingTool, "id:Vrbp1jKPA0xb"],
		Name -> CreateUUID[],
		Rent -> True
	];

	columnWaferResource = Link@Resource[
		Sample -> Model[Item, GCColumnWafer, "id:01G6nvwnz7jA"],
		Name -> CreateUUID[],
		Rent -> True
	];

	(* create cap resources for picking. WE MUST USE THESE CAPS *)

	{resolvedSampleCaps, resolvedStandardCaps, resolvedBlankCaps} = Lookup[expandedOptionsWithNumReplicates, {SampleCaps, StandardCaps, BlankCaps}];

	(* Convert any required caps to resources. *)
	{sampleCapResources, standardCapResources, blankCapResources} = Map[
		If[NullQ[#],
			Null,
			Link[Resource[Sample -> #]]
		]&,
		(* Map over the second level of: *)
		{resolvedSampleCaps, resolvedStandardCaps, resolvedBlankCaps} , {2}];

	(* todo spme caps? *)
	resolvedSolventContainerCaps = ConstantArray[Link@Resource[Sample -> Model[Item, Cap, "id:n0k9mG8Ln5G4"]], Length[Flatten[{dilutionSolventResources, syringeWashSolventResources}] /. {Null -> Nothing}]];

	columnGreenSeptaResource = Link@Resource[Sample -> Model[Item, Septum, "id:XnlV5jKAYJZ8"]];
	columnRedSeptaResource = Link@Resource[Sample -> Model[Item, Septum, "id:Z1lqpMz8PWe9"]];

	(*determine the amount fo time for finalizing instrument preparation checkpoint*)
	finalPrepTime = Switch[
		detector,
		Except[MassSpectrometer],
		0.5 Hour,
		MassSpectrometer,
		Switch[
			Lookup[myResolvedOptions, IonSource],
			ElectronIonization,
			4 * Hour,
			ChemicalIonization,
			12 * Hour
		]
	];

	(* --- Generate the protocol packet --- *)
	protocolPacket = <|{
		Type -> Object[Protocol, GasChromatography],
		Object -> CreateID[Object[Protocol, GasChromatography]],
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ sampleResources),
		Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ DeleteDuplicates[sampleContainers],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> myResolvedOptions,
		NumberOfReplicates -> numReplicates,
		Replace[Instrument] -> Link[
			Resource[
				Instrument -> Lookup[expandedOptionsWithNumReplicates, Instrument],
				Time -> instrumentTime
			]
		],
		CarrierGas -> Lookup[expandedOptionsWithNumReplicates, CarrierGas],
		Inlet -> Lookup[expandedOptionsWithNumReplicates, Inlet],
		InletLiner -> linerResource,
		LinerORing -> linerORingResource,
		InletSeptum -> septumResource,
		(* Make dummy placement fields here. This allows resource picking to update the liner, o-ring, and septum objects. The actual locations will be determined later via InternalExperiment`Private`prepareGCMSHardware *)
		Replace[LinerPlacement] -> {{linerResource, Null}},
		Replace[ORingPlacement] -> {{linerORingResource, Null}},
		Replace[SeptumPlacement] -> {{septumResource, Null}},
		Replace[Columns] -> columnResources,
		(* LOL *)
		Replace[ColumnsRequested] -> Link /@ columnsRequested,
		(* END LOL *)
		Replace[TrimColumn] -> Lookup[expandedOptionsWithNumReplicates, TrimColumn],
		Replace[TrimColumnLength] -> Lookup[expandedOptionsWithNumReplicates, TrimColumnLength],
		ConditionColumn -> Lookup[expandedOptionsWithNumReplicates, ConditionColumn],
		ColumnConditioningGas -> Lookup[expandedOptionsWithNumReplicates, ColumnConditioningGas],
		(*ColumnConditioningGasFlowRate -> Lookup[expandedOptionsWithNumReplicates,ColumnConditioningGasFlowRate],*)
		ColumnConditioningTime -> Lookup[expandedOptionsWithNumReplicates, ColumnConditioningTime],
		ColumnConditioningTemperature -> Lookup[expandedOptionsWithNumReplicates, ColumnConditioningTemperature],
		LiquidInjectionSyringe -> liquidInjectionSyringeResource,
		HeadspaceInjectionSyringe -> headspaceInjectionSyringeResource,
		SPMEInjectionFiber -> spmeFiberResource,
		LiquidHandlingSyringe -> liquidHandlingSyringeResource,
		Detector -> Lookup[expandedOptionsWithNumReplicates, Detector],
		FIDMakeupGas -> Lookup[expandedOptionsWithNumReplicates, FIDMakeupGas],
		DilutionSolvent -> dilutionSolventResources[[1]],
		SecondaryDilutionSolvent -> dilutionSolventResources[[2]],
		TertiaryDilutionSolvent -> dilutionSolventResources[[3]],
		Replace[Dilute] -> Lookup[expandedOptionsWithNumReplicates, Dilute],
		Replace[DilutionSolventVolume] -> Lookup[expandedOptionsWithNumReplicates, DilutionSolventVolume],
		Replace[SecondaryDilutionSolventVolume] -> Lookup[expandedOptionsWithNumReplicates, SecondaryDilutionSolventVolume],
		Replace[TertiaryDilutionSolventVolume] -> Lookup[expandedOptionsWithNumReplicates, TertiaryDilutionSolventVolume],
		Replace[Agitate] -> Lookup[expandedOptionsWithNumReplicates, Agitate],
		Replace[AgitationTime] -> Lookup[expandedOptionsWithNumReplicates, AgitationTime],
		Replace[AgitationTemperature] -> Lookup[expandedOptionsWithNumReplicates, AgitationTemperature],
		Replace[AgitationMixRate] -> Lookup[expandedOptionsWithNumReplicates, AgitationMixRate],
		Replace[AgitationOnTime] -> Lookup[expandedOptionsWithNumReplicates, AgitationOnTime],
		Replace[AgitationOffTime] -> Lookup[expandedOptionsWithNumReplicates, AgitationOffTime],
		Replace[Vortex] -> Lookup[expandedOptionsWithNumReplicates, Vortex],
		Replace[VortexMixRate] -> Lookup[expandedOptionsWithNumReplicates, VortexMixRate],
		Replace[VortexTime] -> Lookup[expandedOptionsWithNumReplicates, VortexTime],
		Replace[SamplingMethod] -> Lookup[expandedOptionsWithNumReplicates, SamplingMethod],
		Replace[HeadspaceSyringeTemperature] -> Lookup[expandedOptionsWithNumReplicates, HeadspaceSyringeTemperature],
		Replace[SyringeWashSolvent] -> syringeWashSolventResources[[1]],
		Replace[SecondarySyringeWashSolvent] -> syringeWashSolventResources[[2]],
		Replace[TertiarySyringeWashSolvent] -> syringeWashSolventResources[[3]],
		Replace[QuaternarySyringeWashSolvent] -> syringeWashSolventResources[[4]],
		Replace[LiquidPreInjectionSyringeWash] -> Lookup[expandedOptionsWithNumReplicates, LiquidPreInjectionSyringeWash],
		Replace[LiquidPreInjectionSyringeWashVolume] -> Lookup[expandedOptionsWithNumReplicates, LiquidPreInjectionSyringeWashVolume],
		Replace[LiquidPreInjectionSyringeWashRate] -> Lookup[expandedOptionsWithNumReplicates, LiquidPreInjectionSyringeWashRate],
		Replace[LiquidPreInjectionNumberOfSolventWashes] -> Lookup[expandedOptionsWithNumReplicates, LiquidPreInjectionNumberOfSolventWashes],
		Replace[LiquidPreInjectionNumberOfSecondarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, LiquidPreInjectionNumberOfSecondarySolventWashes],
		Replace[LiquidPreInjectionNumberOfTertiarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, LiquidPreInjectionNumberOfTertiarySolventWashes],
		Replace[LiquidPreInjectionNumberOfQuaternarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, LiquidPreInjectionNumberOfQuaternarySolventWashes],
		Replace[LiquidSampleWash] -> Lookup[expandedOptionsWithNumReplicates, LiquidSampleWash],
		Replace[NumberOfLiquidSampleWashes] -> Lookup[expandedOptionsWithNumReplicates, NumberOfLiquidSampleWashes],
		Replace[LiquidSampleWashVolume] -> Lookup[expandedOptionsWithNumReplicates, LiquidSampleWashVolume],
		Replace[LiquidSampleFillingStrokes] -> Lookup[expandedOptionsWithNumReplicates, LiquidSampleFillingStrokes],
		Replace[LiquidSampleFillingStrokesVolume] -> Lookup[expandedOptionsWithNumReplicates, LiquidSampleFillingStrokesVolume],
		Replace[LiquidFillingStrokeDelay] -> Lookup[expandedOptionsWithNumReplicates, LiquidFillingStrokeDelay],
		Replace[HeadspaceSyringeFlushing] -> Lookup[expandedOptionsWithNumReplicates, HeadspaceSyringeFlushing],
		Replace[HeadspacePreInjectionFlushTime] -> Lookup[expandedOptionsWithNumReplicates, HeadspacePreInjectionFlushTime],
		Replace[SPMECondition] -> Lookup[expandedOptionsWithNumReplicates, SPMECondition],
		Replace[SPMEConditioningTemperature] -> Lookup[expandedOptionsWithNumReplicates, SPMEConditioningTemperature],
		Replace[SPMEPreConditioningTime] -> Lookup[expandedOptionsWithNumReplicates, SPMEPreConditioningTime],
		Replace[SPMEDerivatizingAgent] -> Link /@ Lookup[expandedOptionsWithNumReplicates, SPMEDerivatizingAgent],
		Replace[SPMEDerivatizingAgentAdsorptionTime] -> Lookup[expandedOptionsWithNumReplicates, SPMEDerivatizingAgentAdsorptionTime],
		Replace[SPMEDerivatizationPosition] -> Lookup[expandedOptionsWithNumReplicates, SPMEDerivatizationPosition],
		Replace[SPMEDerivatizationPositionOffset] -> Lookup[expandedOptionsWithNumReplicates, SPMEDerivatizationPositionOffset],
		Replace[AgitateWhileSampling] -> Lookup[expandedOptionsWithNumReplicates, AgitateWhileSampling],
		Replace[SampleVialAspirationPosition] -> Lookup[expandedOptionsWithNumReplicates, SampleVialAspirationPosition],
		Replace[SampleVialAspirationPositionOffset] -> Lookup[expandedOptionsWithNumReplicates, SampleVialAspirationPositionOffset],
		Replace[SampleVialPenetrationRate] -> Lookup[expandedOptionsWithNumReplicates, SampleVialPenetrationRate],
		Replace[InjectionVolume] -> Lookup[expandedOptionsWithNumReplicates, InjectionVolume],
		Replace[LiquidSampleOverAspirationVolume] -> Lookup[expandedOptionsWithNumReplicates, LiquidSampleOverAspirationVolume],
		Replace[SampleAspirationRate] -> Lookup[expandedOptionsWithNumReplicates, SampleAspirationRate],
		Replace[SampleAspirationDelay] -> Lookup[expandedOptionsWithNumReplicates, SampleAspirationDelay],
		Replace[SPMESampleExtractionTime] -> Lookup[expandedOptionsWithNumReplicates, SPMESampleExtractionTime],
		Replace[InjectionInletPenetrationDepth] -> Lookup[expandedOptionsWithNumReplicates, InjectionInletPenetrationDepth],
		Replace[InjectionInletPenetrationRate] -> Lookup[expandedOptionsWithNumReplicates, InjectionInletPenetrationRate],
		Replace[InjectionSignalMode] -> Lookup[expandedOptionsWithNumReplicates, InjectionSignalMode],
		Replace[PreInjectionTimeDelay] -> Lookup[expandedOptionsWithNumReplicates, PreInjectionTimeDelay],
		Replace[SampleInjectionRate] -> Lookup[expandedOptionsWithNumReplicates, SampleInjectionRate],
		Replace[SPMESampleDesorptionTime] -> Lookup[expandedOptionsWithNumReplicates, SPMESampleDesorptionTime],
		Replace[PostInjectionTimeDelay] -> Lookup[expandedOptionsWithNumReplicates, PostInjectionTimeDelay],
		Replace[LiquidPostInjectionSyringeWash] -> Lookup[expandedOptionsWithNumReplicates, LiquidPostInjectionSyringeWash],
		Replace[LiquidPostInjectionSyringeWashVolume] -> Lookup[expandedOptionsWithNumReplicates, LiquidPostInjectionSyringeWashVolume],
		Replace[LiquidPostInjectionSyringeWashRate] -> Lookup[expandedOptionsWithNumReplicates, LiquidPostInjectionSyringeWashRate],
		Replace[LiquidPostInjectionNumberOfSolventWashes] -> Lookup[expandedOptionsWithNumReplicates, LiquidPostInjectionNumberOfSolventWashes],
		Replace[LiquidPostInjectionNumberOfSecondarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, LiquidPostInjectionNumberOfSecondarySolventWashes],
		Replace[LiquidPostInjectionNumberOfTertiarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, LiquidPostInjectionNumberOfTertiarySolventWashes],
		Replace[LiquidPostInjectionNumberOfQuaternarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, LiquidPostInjectionNumberOfQuaternarySolventWashes],
		Replace[PostInjectionNextSamplePreparationSteps] -> Lookup[expandedOptionsWithNumReplicates, PostInjectionNextSamplePreparationSteps],
		Replace[HeadspacePostInjectionFlushTime] -> Lookup[expandedOptionsWithNumReplicates, HeadspacePostInjectionFlushTime],
		Replace[SPMEPostInjectionConditioningTime] -> Lookup[expandedOptionsWithNumReplicates, SPMEPostInjectionConditioningTime],
		Replace[SeparationMethod] -> injectionTableWithLinks[[samplePositions, 5]],
		Replace[InletMode] -> resolvedInletModes,
		Replace[InletSeptumPurgeFlowRate] -> Lookup[expandedOptionsWithNumReplicates, InletSeptumPurgeFlowRate],
		Replace[InitialInletTemperature] -> Lookup[expandedOptionsWithNumReplicates, InitialInletTemperature],
		Replace[InitialInletTemperatureDuration] -> Lookup[expandedOptionsWithNumReplicates, InitialInletTemperatureDuration],
		Replace[InletTemperatureProfile] -> Lookup[expandedOptionsWithNumReplicates, InletTemperatureProfile],
		Replace[SplitRatio] -> Lookup[expandedOptionsWithNumReplicates, SplitRatio],
		Replace[SplitVentFlowRate] -> Lookup[expandedOptionsWithNumReplicates, SplitVentFlowRate],
		Replace[SplitlessTime] -> Lookup[expandedOptionsWithNumReplicates, SplitlessTime],
		Replace[InitialInletPressure] -> Lookup[expandedOptionsWithNumReplicates, InitialInletPressure],
		Replace[InitialInletTime] -> Lookup[expandedOptionsWithNumReplicates, InitialInletTime],
		Replace[GasSaver] -> Lookup[expandedOptionsWithNumReplicates, GasSaver],
		Replace[GasSaverFlowRate] -> Lookup[expandedOptionsWithNumReplicates, GasSaverFlowRate],
		Replace[GasSaverActivationTime] -> Lookup[expandedOptionsWithNumReplicates, GasSaverActivationTime],
		Replace[SolventEliminationFlowRate] -> Lookup[expandedOptionsWithNumReplicates, SolventEliminationFlowRate],
		Replace[GCColumnMode] -> resolvedGCColumnModes,
		Replace[InitialColumnFlowRate] -> Lookup[expandedOptionsWithNumReplicates, InitialColumnFlowRate],
		Replace[InitialColumnPressure] -> Lookup[expandedOptionsWithNumReplicates, InitialColumnPressure],
		Replace[InitialColumnAverageVelocity] -> Lookup[expandedOptionsWithNumReplicates, InitialColumnAverageVelocity],
		Replace[InitialColumnResidenceTime] -> Lookup[expandedOptionsWithNumReplicates, InitialColumnResidenceTime],
		Replace[InitialColumnSetpointDuration] -> Lookup[expandedOptionsWithNumReplicates, InitialColumnSetpointDuration],
		Replace[ColumnPressureProfile] -> Lookup[expandedOptionsWithNumReplicates, ColumnPressureProfile],
		Replace[ColumnFlowRateProfile] -> Lookup[expandedOptionsWithNumReplicates, ColumnFlowRateProfile],
		Replace[OvenEquilibrationTime] -> Lookup[expandedOptionsWithNumReplicates, OvenEquilibrationTime],
		Replace[InitialOvenTemperature] -> Lookup[expandedOptionsWithNumReplicates, InitialOvenTemperature],
		Replace[InitialOvenTemperatureDuration] -> Lookup[expandedOptionsWithNumReplicates, InitialOvenTemperatureDuration],
		Replace[OvenTemperatureProfile] -> Lookup[expandedOptionsWithNumReplicates, OvenTemperatureProfile],
		Replace[PostRunOvenTemperature] -> Lookup[expandedOptionsWithNumReplicates, PostRunOvenTemperature],
		Replace[PostRunOvenTime] -> Lookup[expandedOptionsWithNumReplicates, PostRunOvenTime],
		Replace[PostRunFlowRate] -> Lookup[expandedOptionsWithNumReplicates, PostRunFlowRate],
		Replace[PostRunPressure] -> Lookup[expandedOptionsWithNumReplicates, PostRunPressure],

		(* FID *)
		FIDTemperature -> Lookup[expandedOptionsWithNumReplicates, FIDTemperature],
		FIDAirFlowRate -> Lookup[expandedOptionsWithNumReplicates, FIDAirFlowRate],
		FIDDihydrogenFlowRate -> Lookup[expandedOptionsWithNumReplicates, FIDDihydrogenFlowRate],
		FIDMakeupGasFlowRate -> Lookup[expandedOptionsWithNumReplicates, FIDMakeupGasFlowRate],
		CarrierGasFlowCorrection -> Lookup[expandedOptionsWithNumReplicates, CarrierGasFlowCorrection],
		FIDDataCollectionFrequency -> Lookup[expandedOptionsWithNumReplicates, FIDDataCollectionFrequency],

		(*Mass Spec*)
		Replace[TransferLineTemperature] -> Lookup[expandedOptionsWithNumReplicates, TransferLineTemperature] /. {Automatic -> Null},
		Replace[IonSource] -> Lookup[expandedOptionsWithNumReplicates, IonSource] /. {Automatic -> Null},
		Replace[IonMode] -> Lookup[expandedOptionsWithNumReplicates, IonMode] /. {Automatic -> Null},
		Replace[SourceTemperature] -> Lookup[expandedOptionsWithNumReplicates, SourceTemperature] /. {Automatic -> Null},
		Replace[QuadrupoleTemperature] -> Lookup[expandedOptionsWithNumReplicates, QuadrupoleTemperature] /. {Automatic -> Null},
		Replace[SolventDelay] -> Lookup[expandedOptionsWithNumReplicates, SolventDelay] /. {Automatic -> Null},
		Replace[MassDetectionGain] -> Lookup[expandedOptionsWithNumReplicates, MassDetectionGain] /. {Automatic -> Null},
		Replace[MassRangeThresholds] -> Lookup[expandedOptionsWithNumReplicates, MassRangeThreshold] /. {Automatic -> Null},
		Replace[TraceIonDetection] -> Lookup[expandedOptionsWithNumReplicates, TraceIonDetection] /. {Automatic -> Null},
		Replace[AcquisitionWindowStartTimes] -> Lookup[expandedOptionsWithNumReplicates, AcquisitionWindowStartTime] /. {Automatic -> Null},
		Replace[MassRanges] -> Lookup[expandedOptionsWithNumReplicates, MassRange] /. {Automatic -> Null},
		Replace[MassRangeScanSpeeds] -> Lookup[expandedOptionsWithNumReplicates, MassRangeScanSpeed] /. {Automatic -> Null},
		Replace[MassSelections] -> Lookup[expandedOptionsWithNumReplicates, MassSelection] /. {Automatic -> Null},
		Replace[MassSelectionResolutions] -> Lookup[expandedOptionsWithNumReplicates, MassSelectionResolution] /. {Automatic -> Null},
		Replace[MassSelectionDetectionGains] -> Lookup[expandedOptionsWithNumReplicates, MassSelectionDetectionGain] /. {Automatic -> Null},

		(* Column parts tracking *)
		GuardColumn -> Null,
		Replace[InstalledColumnNuts] -> Null,
		Replace[InstalledColumnFerrules] -> Null,
		Replace[InstalledColumnJoins] -> requiredColumnJoins, (*requiredColumnJoins*)
		Replace[ColumnAssembly] -> columnAssemblySimplified,
		Replace[InstalledColumnFittings] -> installedColumnFittings, (* installedColumnFittings *)

		Replace[Standards] -> Link /@ uniqueStandards,

		Replace[StandardVial] -> Link@Lookup[expandedOptionsWithNumReplicates, StandardVial],
		Replace[StandardAmount] -> Lookup[expandedOptionsWithNumReplicates, StandardAmount],
		Replace[StandardDilute] -> Lookup[expandedOptionsWithNumReplicates, StandardDilute],
		Replace[StandardDilutionSolventVolume] -> Lookup[expandedOptionsWithNumReplicates, StandardDilutionSolventVolume],
		Replace[StandardSecondaryDilutionSolventVolume] -> Lookup[expandedOptionsWithNumReplicates, StandardSecondaryDilutionSolventVolume],
		Replace[StandardTertiaryDilutionSolventVolume] -> Lookup[expandedOptionsWithNumReplicates, StandardTertiaryDilutionSolventVolume],
		Replace[StandardAgitate] -> Lookup[expandedOptionsWithNumReplicates, StandardAgitate],
		Replace[StandardAgitationTime] -> Lookup[expandedOptionsWithNumReplicates, StandardAgitationTime],
		Replace[StandardAgitationTemperature] -> Lookup[expandedOptionsWithNumReplicates, StandardAgitationTemperature],
		Replace[StandardAgitationMixRate] -> Lookup[expandedOptionsWithNumReplicates, StandardAgitationMixRate],
		Replace[StandardAgitationOnTime] -> Lookup[expandedOptionsWithNumReplicates, StandardAgitationOnTime],
		Replace[StandardAgitationOffTime] -> Lookup[expandedOptionsWithNumReplicates, StandardAgitationOffTime],
		Replace[StandardVortex] -> Lookup[expandedOptionsWithNumReplicates, StandardVortex],
		Replace[StandardVortexMixRate] -> Lookup[expandedOptionsWithNumReplicates, StandardVortexMixRate],
		Replace[StandardVortexTime] -> Lookup[expandedOptionsWithNumReplicates, StandardVortexTime],
		Replace[StandardSamplingMethod] -> Lookup[expandedOptionsWithNumReplicates, StandardSamplingMethod],
		Replace[StandardHeadspaceSyringeTemperature] -> Lookup[expandedOptionsWithNumReplicates, StandardHeadspaceSyringeTemperature],
		Replace[StandardLiquidPreInjectionSyringeWash] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPreInjectionSyringeWash],
		Replace[StandardLiquidPreInjectionSyringeWashVolume] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPreInjectionSyringeWashVolume],
		Replace[StandardLiquidPreInjectionSyringeWashRate] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPreInjectionSyringeWashRate],
		Replace[StandardLiquidPreInjectionNumberOfSolventWashes] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPreInjectionNumberOfSolventWashes],
		Replace[StandardLiquidPreInjectionNumberOfSecondarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPreInjectionNumberOfSecondarySolventWashes],
		Replace[StandardLiquidPreInjectionNumberOfTertiarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPreInjectionNumberOfTertiarySolventWashes],
		Replace[StandardLiquidPreInjectionNumberOfQuaternarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPreInjectionNumberOfQuaternarySolventWashes],
		Replace[StandardLiquidSampleWash] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidSampleWash],
		Replace[StandardNumberOfLiquidSampleWashes] -> Lookup[expandedOptionsWithNumReplicates, StandardNumberOfLiquidSampleWashes],
		Replace[StandardLiquidSampleWashVolume] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidSampleWashVolume],
		Replace[StandardLiquidSampleFillingStrokes] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidSampleFillingStrokes],
		Replace[StandardLiquidSampleFillingStrokesVolume] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidSampleFillingStrokesVolume],
		Replace[StandardLiquidFillingStrokeDelay] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidFillingStrokeDelay],
		Replace[StandardHeadspaceSyringeFlushing] -> Lookup[expandedOptionsWithNumReplicates, StandardHeadspaceSyringeFlushing],
		Replace[StandardHeadspacePreInjectionFlushTime] -> Lookup[expandedOptionsWithNumReplicates, StandardHeadspacePreInjectionFlushTime],
		Replace[StandardSPMECondition] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMECondition],
		Replace[StandardSPMEConditioningTemperature] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMEConditioningTemperature],
		Replace[StandardSPMEPreConditioningTime] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMEPreConditioningTime],
		Replace[StandardSPMEDerivatizingAgent] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMEDerivatizingAgent],
		Replace[StandardSPMEDerivatizingAgentAdsorptionTime] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMEDerivatizingAgentAdsorptionTime],
		Replace[StandardSPMEDerivatizationPosition] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMEDerivatizationPosition],
		Replace[StandardSPMEDerivatizationPositionOffset] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMEDerivatizationPositionOffset],
		Replace[StandardAgitateWhileSampling] -> Lookup[expandedOptionsWithNumReplicates, StandardAgitateWhileSampling],
		Replace[StandardSampleVialAspirationPosition] -> Lookup[expandedOptionsWithNumReplicates, StandardSampleVialAspirationPosition],
		Replace[StandardSampleVialAspirationPositionOffset] -> Lookup[expandedOptionsWithNumReplicates, StandardSampleVialAspirationPositionOffset],
		Replace[StandardSampleVialPenetrationRate] -> Lookup[expandedOptionsWithNumReplicates, StandardSampleVialPenetrationRate],
		Replace[StandardInjectionVolume] -> Lookup[expandedOptionsWithNumReplicates, StandardInjectionVolume],
		Replace[StandardLiquidSampleOverAspirationVolume] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidSampleOverAspirationVolume],
		Replace[StandardSampleAspirationRate] -> Lookup[expandedOptionsWithNumReplicates, StandardSampleAspirationRate],
		Replace[StandardSampleAspirationDelay] -> Lookup[expandedOptionsWithNumReplicates, StandardSampleAspirationDelay],
		Replace[StandardSPMESampleExtractionTime] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMESampleExtractionTime],
		Replace[StandardInjectionInletPenetrationDepth] -> Lookup[expandedOptionsWithNumReplicates, StandardInjectionInletPenetrationDepth],
		Replace[StandardInjectionInletPenetrationRate] -> Lookup[expandedOptionsWithNumReplicates, StandardInjectionInletPenetrationRate],
		Replace[StandardInjectionSignalMode] -> Lookup[expandedOptionsWithNumReplicates, StandardInjectionSignalMode],
		Replace[StandardPreInjectionTimeDelay] -> Lookup[expandedOptionsWithNumReplicates, StandardPreInjectionTimeDelay],
		Replace[StandardSampleInjectionRate] -> Lookup[expandedOptionsWithNumReplicates, StandardSampleInjectionRate],
		Replace[StandardSPMESampleDesorptionTime] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMESampleDesorptionTime],
		Replace[StandardPostInjectionTimeDelay] -> Lookup[expandedOptionsWithNumReplicates, StandardPostInjectionTimeDelay],
		Replace[StandardLiquidPostInjectionSyringeWash] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPostInjectionSyringeWash],
		Replace[StandardLiquidPostInjectionSyringeWashVolume] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPostInjectionSyringeWashVolume],
		Replace[StandardLiquidPostInjectionSyringeWashRate] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPostInjectionSyringeWashRate],
		Replace[StandardLiquidPostInjectionNumberOfSolventWashes] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPostInjectionNumberOfSolventWashes],
		Replace[StandardLiquidPostInjectionNumberOfSecondarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPostInjectionNumberOfSecondarySolventWashes],
		Replace[StandardLiquidPostInjectionNumberOfTertiarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPostInjectionNumberOfTertiarySolventWashes],
		Replace[StandardLiquidPostInjectionNumberOfQuaternarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, StandardLiquidPostInjectionNumberOfQuaternarySolventWashes],
		Replace[StandardPostInjectionNextSamplePreparationSteps] -> Lookup[expandedOptionsWithNumReplicates, StandardPostInjectionNextSamplePreparationSteps],
		Replace[StandardHeadspacePostInjectionFlushTime] -> Lookup[expandedOptionsWithNumReplicates, StandardHeadspacePostInjectionFlushTime],
		Replace[StandardSPMEPostInjectionConditioningTime] -> Lookup[expandedOptionsWithNumReplicates, StandardSPMEPostInjectionConditioningTime],
		Replace[StandardSeparationMethod] -> If[Length[standardPositions] > 0, injectionTableWithLinks[[standardPositions, 5]]],
		Replace[StandardInletMode] -> resolvedStandardInletModes,
		Replace[StandardInletSeptumPurgeFlowRate] -> Lookup[expandedOptionsWithNumReplicates, StandardInletSeptumPurgeFlowRate],
		Replace[StandardInitialInletTemperature] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialInletTemperature],
		Replace[StandardInitialInletTemperatureDuration] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialInletTemperatureDuration],
		Replace[StandardInletTemperatureProfile] -> Lookup[expandedOptionsWithNumReplicates, StandardInletTemperatureProfile],
		Replace[StandardSplitRatio] -> Lookup[expandedOptionsWithNumReplicates, StandardSplitRatio],
		Replace[StandardSplitVentFlowRate] -> Lookup[expandedOptionsWithNumReplicates, StandardSplitVentFlowRate],
		Replace[StandardSplitlessTime] -> Lookup[expandedOptionsWithNumReplicates, StandardSplitlessTime],
		Replace[StandardInitialInletPressure] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialInletPressure],
		Replace[StandardInitialInletTime] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialInletTime],
		Replace[StandardGasSaver] -> Lookup[expandedOptionsWithNumReplicates, StandardGasSaver],
		Replace[StandardGasSaverFlowRate] -> Lookup[expandedOptionsWithNumReplicates, StandardGasSaverFlowRate],
		Replace[StandardGasSaverActivationTime] -> Lookup[expandedOptionsWithNumReplicates, StandardGasSaverActivationTime],
		Replace[StandardSolventEliminationFlowRate] -> Lookup[expandedOptionsWithNumReplicates, StandardSolventEliminationFlowRate],
		Replace[StandardGCColumnMode] -> resolvedStandardGCColumnModes,
		Replace[StandardInitialColumnFlowRate] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialColumnFlowRate],
		Replace[StandardInitialColumnPressure] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialColumnPressure],
		Replace[StandardInitialColumnAverageVelocity] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialColumnAverageVelocity],
		Replace[StandardInitialColumnResidenceTime] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialColumnResidenceTime],
		Replace[StandardInitialColumnSetpointDuration] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialColumnSetpointDuration],
		Replace[StandardColumnPressureProfile] -> Lookup[expandedOptionsWithNumReplicates, StandardColumnPressureProfile],
		Replace[StandardColumnFlowRateProfile] -> Lookup[expandedOptionsWithNumReplicates, StandardColumnFlowRateProfile],
		Replace[StandardOvenEquilibrationTime] -> Lookup[expandedOptionsWithNumReplicates, StandardOvenEquilibrationTime],
		Replace[StandardInitialOvenTemperature] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialOvenTemperature],
		Replace[StandardInitialOvenTemperatureDuration] -> Lookup[expandedOptionsWithNumReplicates, StandardInitialOvenTemperatureDuration],
		Replace[StandardOvenTemperatureProfile] -> Lookup[expandedOptionsWithNumReplicates, StandardOvenTemperatureProfile],
		Replace[StandardPostRunOvenTemperature] -> Lookup[expandedOptionsWithNumReplicates, StandardPostRunOvenTemperature],
		Replace[StandardPostRunOvenTime] -> Lookup[expandedOptionsWithNumReplicates, StandardPostRunOvenTime],
		Replace[StandardPostRunFlowRate] -> Lookup[expandedOptionsWithNumReplicates, StandardPostRunFlowRate],
		Replace[StandardPostRunPressure] -> Lookup[expandedOptionsWithNumReplicates, StandardPostRunPressure],
		Replace[StandardFrequency] -> Lookup[expandedOptionsWithNumReplicates, StandardFrequency],

		Replace[Blanks] -> Link /@ uniqueBlanks,

		Replace[BlankVial] -> Link@Lookup[expandedOptionsWithNumReplicates, BlankVial],
		Replace[BlankAmount] -> Lookup[expandedOptionsWithNumReplicates, BlankAmount],
		Replace[BlankDilute] -> Lookup[expandedOptionsWithNumReplicates, BlankDilute],
		Replace[BlankDilutionSolventVolume] -> Lookup[expandedOptionsWithNumReplicates, BlankDilutionSolventVolume],
		Replace[BlankSecondaryDilutionSolventVolume] -> Lookup[expandedOptionsWithNumReplicates, BlankSecondaryDilutionSolventVolume],
		Replace[BlankTertiaryDilutionSolventVolume] -> Lookup[expandedOptionsWithNumReplicates, BlankTertiaryDilutionSolventVolume],
		Replace[BlankAgitate] -> Lookup[expandedOptionsWithNumReplicates, BlankAgitate],
		Replace[BlankAgitationTime] -> Lookup[expandedOptionsWithNumReplicates, BlankAgitationTime],
		Replace[BlankAgitationTemperature] -> Lookup[expandedOptionsWithNumReplicates, BlankAgitationTemperature],
		Replace[BlankAgitationMixRate] -> Lookup[expandedOptionsWithNumReplicates, BlankAgitationMixRate],
		Replace[BlankAgitationOnTime] -> Lookup[expandedOptionsWithNumReplicates, BlankAgitationOnTime],
		Replace[BlankAgitationOffTime] -> Lookup[expandedOptionsWithNumReplicates, BlankAgitationOffTime],
		Replace[BlankVortex] -> Lookup[expandedOptionsWithNumReplicates, BlankVortex],
		Replace[BlankVortexMixRate] -> Lookup[expandedOptionsWithNumReplicates, BlankVortexMixRate],
		Replace[BlankVortexTime] -> Lookup[expandedOptionsWithNumReplicates, BlankVortexTime],
		Replace[BlankSamplingMethod] -> Lookup[expandedOptionsWithNumReplicates, BlankSamplingMethod],
		Replace[BlankHeadspaceSyringeTemperature] -> Lookup[expandedOptionsWithNumReplicates, BlankHeadspaceSyringeTemperature],
		Replace[BlankLiquidPreInjectionSyringeWash] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPreInjectionSyringeWash],
		Replace[BlankLiquidPreInjectionSyringeWashVolume] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPreInjectionSyringeWashVolume],
		Replace[BlankLiquidPreInjectionSyringeWashRate] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPreInjectionSyringeWashRate],
		Replace[BlankLiquidPreInjectionNumberOfSolventWashes] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPreInjectionNumberOfSolventWashes],
		Replace[BlankLiquidPreInjectionNumberOfSecondarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPreInjectionNumberOfSecondarySolventWashes],
		Replace[BlankLiquidPreInjectionNumberOfTertiarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPreInjectionNumberOfTertiarySolventWashes],
		Replace[BlankLiquidPreInjectionNumberOfQuaternarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPreInjectionNumberOfQuaternarySolventWashes],
		Replace[BlankLiquidSampleWash] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidSampleWash],
		Replace[BlankNumberOfLiquidSampleWashes] -> Lookup[expandedOptionsWithNumReplicates, BlankNumberOfLiquidSampleWashes],
		Replace[BlankLiquidSampleWashVolume] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidSampleWashVolume],
		Replace[BlankLiquidSampleFillingStrokes] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidSampleFillingStrokes],
		Replace[BlankLiquidSampleFillingStrokesVolume] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidSampleFillingStrokesVolume],
		Replace[BlankLiquidFillingStrokeDelay] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidFillingStrokeDelay],
		Replace[BlankHeadspaceSyringeFlushing] -> Lookup[expandedOptionsWithNumReplicates, BlankHeadspaceSyringeFlushing],
		Replace[BlankHeadspacePreInjectionFlushTime] -> Lookup[expandedOptionsWithNumReplicates, BlankHeadspacePreInjectionFlushTime],
		Replace[BlankSPMECondition] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMECondition],
		Replace[BlankSPMEConditioningTemperature] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMEConditioningTemperature],
		Replace[BlankSPMEPreConditioningTime] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMEPreConditioningTime],
		Replace[BlankSPMEDerivatizingAgent] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMEDerivatizingAgent],
		Replace[BlankSPMEDerivatizingAgentAdsorptionTime] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMEDerivatizingAgentAdsorptionTime],
		Replace[BlankSPMEDerivatizationPosition] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMEDerivatizationPosition],
		Replace[BlankSPMEDerivatizationPositionOffset] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMEDerivatizationPositionOffset],
		Replace[BlankAgitateWhileSampling] -> Lookup[expandedOptionsWithNumReplicates, BlankAgitateWhileSampling],
		Replace[BlankSampleVialAspirationPosition] -> Lookup[expandedOptionsWithNumReplicates, BlankSampleVialAspirationPosition],
		Replace[BlankSampleVialAspirationPositionOffset] -> Lookup[expandedOptionsWithNumReplicates, BlankSampleVialAspirationPositionOffset],
		Replace[BlankSampleVialPenetrationRate] -> Lookup[expandedOptionsWithNumReplicates, BlankSampleVialPenetrationRate],
		Replace[BlankInjectionVolume] -> Lookup[expandedOptionsWithNumReplicates, BlankInjectionVolume],
		Replace[BlankLiquidSampleOverAspirationVolume] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidSampleOverAspirationVolume],
		Replace[BlankSampleAspirationRate] -> Lookup[expandedOptionsWithNumReplicates, BlankSampleAspirationRate],
		Replace[BlankSampleAspirationDelay] -> Lookup[expandedOptionsWithNumReplicates, BlankSampleAspirationDelay],
		Replace[BlankSPMESampleExtractionTime] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMESampleExtractionTime],
		Replace[BlankInjectionInletPenetrationDepth] -> Lookup[expandedOptionsWithNumReplicates, BlankInjectionInletPenetrationDepth],
		Replace[BlankInjectionInletPenetrationRate] -> Lookup[expandedOptionsWithNumReplicates, BlankInjectionInletPenetrationRate],
		Replace[BlankInjectionSignalMode] -> Lookup[expandedOptionsWithNumReplicates, BlankInjectionSignalMode],
		Replace[BlankPreInjectionTimeDelay] -> Lookup[expandedOptionsWithNumReplicates, BlankPreInjectionTimeDelay],
		Replace[BlankSampleInjectionRate] -> Lookup[expandedOptionsWithNumReplicates, BlankSampleInjectionRate],
		Replace[BlankSPMESampleDesorptionTime] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMESampleDesorptionTime],
		Replace[BlankPostInjectionTimeDelay] -> Lookup[expandedOptionsWithNumReplicates, BlankPostInjectionTimeDelay],
		Replace[BlankLiquidPostInjectionSyringeWash] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPostInjectionSyringeWash],
		Replace[BlankLiquidPostInjectionSyringeWashVolume] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPostInjectionSyringeWashVolume],
		Replace[BlankLiquidPostInjectionSyringeWashRate] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPostInjectionSyringeWashRate],
		Replace[BlankLiquidPostInjectionNumberOfSolventWashes] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPostInjectionNumberOfSolventWashes],
		Replace[BlankLiquidPostInjectionNumberOfSecondarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPostInjectionNumberOfSecondarySolventWashes],
		Replace[BlankLiquidPostInjectionNumberOfTertiarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPostInjectionNumberOfTertiarySolventWashes],
		Replace[BlankLiquidPostInjectionNumberOfQuaternarySolventWashes] -> Lookup[expandedOptionsWithNumReplicates, BlankLiquidPostInjectionNumberOfQuaternarySolventWashes],
		Replace[BlankPostInjectionNextSamplePreparationSteps] -> Lookup[expandedOptionsWithNumReplicates, BlankPostInjectionNextSamplePreparationSteps],
		Replace[BlankHeadspacePostInjectionFlushTime] -> Lookup[expandedOptionsWithNumReplicates, BlankHeadspacePostInjectionFlushTime],
		Replace[BlankSPMEPostInjectionConditioningTime] -> Lookup[expandedOptionsWithNumReplicates, BlankSPMEPostInjectionConditioningTime],
		Replace[BlankSeparationMethod] -> If[Length[blankPositions] > 0, injectionTableWithLinks[[blankPositions, 5]]],
		Replace[BlankInletMode] -> resolvedBlankInletModes,
		Replace[BlankInletSeptumPurgeFlowRate] -> Lookup[expandedOptionsWithNumReplicates, BlankInletSeptumPurgeFlowRate],
		Replace[BlankInitialInletTemperature] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialInletTemperature],
		Replace[BlankInitialInletTemperatureDuration] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialInletTemperatureDuration],
		Replace[BlankInletTemperatureProfile] -> Lookup[expandedOptionsWithNumReplicates, BlankInletTemperatureProfile],
		Replace[BlankSplitRatio] -> Lookup[expandedOptionsWithNumReplicates, BlankSplitRatio],
		Replace[BlankSplitVentFlowRate] -> Lookup[expandedOptionsWithNumReplicates, BlankSplitVentFlowRate],
		Replace[BlankSplitlessTime] -> Lookup[expandedOptionsWithNumReplicates, BlankSplitlessTime],
		Replace[BlankInitialInletPressure] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialInletPressure],
		Replace[BlankInitialInletTime] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialInletTime],
		Replace[BlankGasSaver] -> Lookup[expandedOptionsWithNumReplicates, BlankGasSaver],
		Replace[BlankGasSaverFlowRate] -> Lookup[expandedOptionsWithNumReplicates, BlankGasSaverFlowRate],
		Replace[BlankGasSaverActivationTime] -> Lookup[expandedOptionsWithNumReplicates, BlankGasSaverActivationTime],
		Replace[BlankSolventEliminationFlowRate] -> Lookup[expandedOptionsWithNumReplicates, BlankSolventEliminationFlowRate],
		Replace[BlankGCColumnMode] -> resolvedBlankGCColumnModes,
		Replace[BlankInitialColumnFlowRate] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialColumnFlowRate],
		Replace[BlankInitialColumnPressure] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialColumnPressure],
		Replace[BlankInitialColumnAverageVelocity] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialColumnAverageVelocity],
		Replace[BlankInitialColumnResidenceTime] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialColumnResidenceTime],
		Replace[BlankInitialColumnSetpointDuration] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialColumnSetpointDuration],
		Replace[BlankColumnPressureProfile] -> Lookup[expandedOptionsWithNumReplicates, BlankColumnPressureProfile],
		Replace[BlankColumnFlowRateProfile] -> Lookup[expandedOptionsWithNumReplicates, BlankColumnFlowRateProfile],
		Replace[BlankOvenEquilibrationTime] -> Lookup[expandedOptionsWithNumReplicates, BlankOvenEquilibrationTime],
		Replace[BlankInitialOvenTemperature] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialOvenTemperature],
		Replace[BlankInitialOvenTemperatureDuration] -> Lookup[expandedOptionsWithNumReplicates, BlankInitialOvenTemperatureDuration],
		Replace[BlankOvenTemperatureProfile] -> Lookup[expandedOptionsWithNumReplicates, BlankOvenTemperatureProfile],
		Replace[BlankPostRunOvenTemperature] -> Lookup[expandedOptionsWithNumReplicates, BlankPostRunOvenTemperature],
		Replace[BlankPostRunOvenTime] -> Lookup[expandedOptionsWithNumReplicates, BlankPostRunOvenTime],
		Replace[BlankPostRunFlowRate] -> Lookup[expandedOptionsWithNumReplicates, BlankPostRunFlowRate],
		Replace[BlankPostRunPressure] -> Lookup[expandedOptionsWithNumReplicates, BlankPostRunPressure],
		Replace[BlankFrequency] -> Lookup[expandedOptionsWithNumReplicates, BlankFrequency],

		Replace[InjectionTable] -> injectionTableUploadable,

		SeparationTime -> injectionTime,
		GasChromatographyStreaming -> TrueQ[$GasChromatographyStreaming],

		(* grabbing parts *)
		ColumnTrimmingTool -> columnWaferResource,
		ColumnSwagingTool -> swagingToolResource,
		MSDSwagingTool -> swagingToolResourceMSD,

		(* magnetic caps for everything *)
		Replace[SampleCaps] -> sampleCapResources,
		Replace[StandardCaps] -> standardCapResources,
		Replace[BlankCaps] -> blankCapResources,
		Replace[SolventContainerCaps] -> resolvedSolventContainerCaps,

		(* septa *)
		Replace[RedSeptum] -> columnRedSeptaResource,
		Replace[GreenSeptum] -> columnGreenSeptaResource,

		(* checkpoints *)
		Replace[Checkpoints] -> {
			(* Sample preparation *)
			{"Picking instrument", 1 Hour, "The instrument that will be used to separate the samples is selected.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Installing instrument hardware", 1 Hour, "The specified inlet liner, septum, and O-ring are installed in the column inlet. Specified solvents, derivatizing agents, and syringes are installed on the autosampling arm.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Installing column", 0.5 Hour, "The separatory column and guard is cut, swaged, and attached to the specified inlet.", Link[Resource[Operator -> operatorResource, Time -> 0.5 Hour]]},
			{"Conditioning column", Lookup[myResolvedOptions, ColumnConditioningTime], "The separatory column is flushed with carrier gas and then treated at a temperature above the maximum temperature at which the column will operate.", Link[Resource[Operator -> operatorResource, Time -> Lookup[myResolvedOptions, ColumnConditioningTime]]]},
			{"Finalizing instrument preparation", finalPrepTime, "The column is connected to the detector. The mass spectrometer is evacuated and thermally equilibrated if applicable.", Link[Resource[Operator -> operatorResource, Time -> finalPrepTime]]},
			{"Loading solvents", 0.5 Hour, "The solvents are loaded into the autosampler arm.", Link[Resource[Operator -> operatorResource, Time -> 0.5 Hour]]},
			{"Loading samples and standards", 0.5 Hour, "The injectable samples are installed on the autosampling arm.", Link[Resource[Operator -> operatorResource, Time -> 0.5 Hour]]},
			{"Injecting samples", separationTime, "The samples, standards, and blanks are injected and separated on the separatory column installed in the gas chromatograph.", Link[Resource[Operator -> operatorResource, Time -> separationTime]]},
			(* Experiment Specific Checkpoints *)
			{"Sample post-processing", 1 Hour, "The collected chromatographic data is extracted from the raw data files. Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Cleaning up", 10 Minute, "Any samples, solvents, or equipment installed on the autosampling arm during the experiment are discarded in waste or stored.", Link[Resource[Operator -> operatorResource, Time -> 10 Minute]]},
			{"Returning materials", 10 Minute, "Waste is disposed and instrument hardware is returned to storage.", Link[Resource[Operator -> operatorResource, Time -> 10 Minute]]}
		},
		Replace[SamplesInStorage] -> Lookup[myResolvedOptions, SamplesInStorageCondition]
	} /. {{Null} -> Null}
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	allPackets = Join[
		{finalizedPacket},
		uniqueSeparationMethodPackets
	];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine],
		{True, {}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[expandedOptionsWithNumReplicates, FastTrack], Site->Lookup[myResolvedOptions,Site], Cache -> inheritedCache, Simulation -> simulation],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[expandedOptionsWithNumReplicates, FastTrack], Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache -> inheritedCache, Simulation -> simulation], Null}
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		allPackets,
		{$Failed, $Failed}
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}
];


(* ::Subsection:: *)
(*Sister functions*)


DefineOptions[ExperimentGasChromatographyOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {ExperimentGasChromatography}
];


ExperimentGasChromatographyOptions[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentGasChromatography *)
	options = ExperimentGasChromatography[myInput, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentGasChromatography],
		options
	]
];


ExperimentGasChromatographyPreview[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentGasChromatography]] :=
	ExperimentGasChromatography[myInput, Append[ToList[myOptions], Output -> Preview]];


DefineOptions[ValidExperimentGasChromatographyQ,
	Options :> {VerboseOption, OutputFormatOption},
	SharedOptions :> {ExperimentGasChromatography}
];


ValidExperimentGasChromatographyQ[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ValidExperimentGasChromatographyQ]] := Module[
	{listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentGasChromatography *)
	filterTests = ExperimentGasChromatography[myInput, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[filterTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[listedInput, _String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, filterTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMassSpectrometryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentGasChromatographyQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentGasChromatographyQ"]
];
(* ::Subsection:: *)
(* Helper functions *)
(* === BEGIN === Helper functions to convert parameters related to GC Columns === BEGIN === *)

(* Helper function to calculate the dynamic viscosity of the carrier gas *)
carrierGasViscosity[myCarrierGas_, myTemperature_] := Module[
	{viscosity, temperature},
	temperature = Convert[myTemperature, Kelvin] / Kelvin;
	viscosity = Switch[
		myCarrierGas,
		Helium,
		(0.3875 * temperature + 80.456) * Micro * Poise,
		(*(1.5265*10^(-14)*temperature^3-3.4647*10^(-11)*temperature^2+6.2466*10^(-8)*temperature+3.9006*10^(-6))*Pascal*Second,*)
		Dihydrogen,
		(7.42 * Sqrt[temperature] - 39.5) * Micro * Poise,
		Dinitrogen,
		(15.43 * Sqrt[temperature] - 89.4) * Micro * Poise,
		_,
		$Failed
	]
];

(* Helper function to convert a column pressure to column flow rate *)
convertColumnPressureToFlowRate[myCarrierGas_, myColumnDiameter_, myColumnLength_, myColumnInletPressure_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{flowRate, myColumnTemperatureKelvin, myColumnReferenceTemperatureKelvin},
	myColumnTemperatureKelvin = Convert[myColumnTemperature, Kelvin];
	myColumnReferenceTemperatureKelvin = Convert[myColumnReferenceTemperature, Kelvin];
	flowRate = Round[Convert[(myColumnDiameter^4 * Pi * ((myColumnInletPressure + myColumnReferencePressure)^2 - (myColumnOutletPressure + myColumnReferencePressure)^2) * myColumnReferenceTemperatureKelvin) / (256 * myColumnLength * myColumnReferencePressure * myColumnTemperatureKelvin * carrierGasViscosity[myCarrierGas, myColumnTemperatureKelvin]), Milliliter / Minute], 10^(-2) * Milliliter / Minute]
];

(* Helper function to convert a column velocity to column flow rate *)
convertColumnVelocityToFlowRate[myCarrierGas_, myColumnDiameter_, myColumnLength_, myColumnVelocity_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{flowRate, myColumnTemperatureKelvin, myColumnReferenceTemperatureKelvin},
	myColumnTemperatureKelvin = Convert[myColumnTemperature, Kelvin];
	myColumnReferenceTemperatureKelvin = Convert[myColumnReferenceTemperature, Kelvin];
	flowRate = Round[N@Convert[FvSolve /. Flatten@Solve[(12288 * FvSolve^2 * myColumnLength * myColumnReferencePressure^2 * myColumnTemperatureKelvin^2 * carrierGasViscosity[myCarrierGas, myColumnTemperatureKelvin]) / (myColumnDiameter^6 * Pi^2 * (myColumnOutletPressure + myColumnReferencePressure)^3 * myColumnReferenceTemperatureKelvin^2 * (-8 + (4 + (1024 * FvSolve * myColumnLength * myColumnReferencePressure * myColumnTemperatureKelvin * carrierGasViscosity[myCarrierGas, myColumnTemperatureKelvin]) / (myColumnDiameter^4 * Pi * (myColumnOutletPressure + myColumnReferencePressure)^2 * myColumnReferenceTemperatureKelvin))^(3 / 2))) == myColumnVelocity, FvSolve], Milliliter / Minute], 10^(-2) * Milliliter / Minute]
];

(* Helper function to convert a column residence time to column flow rate *)
convertColumnResidenceTimeToFlowRate[myCarrierGas_, myColumnDiameter_, myColumnLength_, myColumnResidenceTime_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{velocity, flowRate},
	velocity = myColumnLength / myColumnResidenceTime;
	flowRate = Round[N@convertColumnVelocityToFlowRate[myCarrierGas, myColumnDiameter, myColumnLength, velocity, myColumnTemperature, myColumnOutletPressure, myColumnReferencePressure, myColumnReferenceTemperature], 10^(-2) * Milliliter / Minute]
];

(* Helper function to convert a column flow rate to column pressure *)
convertColumnFlowRateToPressure[myCarrierGas_, myColumnDiameter_, myColumnLength_, myColumnFlowRate_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{pressure, myColumnTemperatureKelvin, myColumnReferenceTemperatureKelvin},
	myColumnTemperatureKelvin = Convert[myColumnTemperature, Kelvin];
	myColumnReferenceTemperatureKelvin = Convert[myColumnReferenceTemperature, Kelvin];
	pressure = Round[N@Convert[Sqrt[(myColumnOutletPressure + myColumnReferencePressure)^2 + (256 * myColumnFlowRate * myColumnLength * myColumnReferencePressure * myColumnTemperatureKelvin * carrierGasViscosity[myCarrierGas, myColumnTemperatureKelvin]) / (myColumnDiameter^4 * Pi * myColumnReferenceTemperatureKelvin)], PSI], 10^(-2) * PSI] - myColumnReferencePressure
];

(* Helper function to convert a column velocity to column pressure. *)
convertColumnVelocityToPressure[myCarrierGas_, myColumnDiameter_, myColumnLength_,myColumnVelocity_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{flowRate,pressure},
	flowRate = convertColumnVelocityToFlowRate[myCarrierGas, myColumnDiameter, myColumnLength, myColumnVelocity, myColumnTemperature, myColumnOutletPressure, myColumnReferencePressure, myColumnReferenceTemperature];
	pressure = convertColumnFlowRateToPressure[myCarrierGas, myColumnDiameter, myColumnLength, flowRate, myColumnTemperature, myColumnOutletPressure, myColumnReferencePressure, myColumnReferenceTemperature]
];

(* Helper function to convert a column residence time to column pressure. *)
convertColumnResidenceTimeToPressure[myCarrierGas_, myColumnDiameter_, myColumnLength_, myColumnResidenceTime_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{velocity, pressure},
	velocity = myColumnLength / myColumnResidenceTime;
	pressure = Round[N@convertColumnVelocityToPressure[myCarrierGas, myColumnDiameter, myColumnLength, velocity, myColumnTemperature, myColumnOutletPressure, myColumnReferencePressure, myColumnReferenceTemperature], 10^(-2) * PSI]
];

(* Helper function to convert a column residence time to column pressure. *)
convertColumnPressureToVelocity[myCarrierGas_, myColumnDiameter_, myColumnLength_, myColumnInletPressure_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{velocity, myColumnTemperatureKelvin, myColumnReferenceTemperatureKelvin},
	myColumnTemperatureKelvin = Convert[myColumnTemperature, Kelvin];
	myColumnReferenceTemperatureKelvin = Convert[myColumnReferenceTemperature, Kelvin];
	velocity = Round[N@Convert[(3 * myColumnDiameter^2 * ((myColumnInletPressure + myColumnReferencePressure)^2 - (myColumnOutletPressure + myColumnReferencePressure)^2)^2) / (16 * myColumnLength * (myColumnOutletPressure + myColumnReferencePressure)^3 * (-8 + (4 + (4 * ((myColumnInletPressure + myColumnReferencePressure)^2 - (myColumnOutletPressure + myColumnReferencePressure)^2)) / (myColumnOutletPressure + myColumnReferencePressure)^2)^(3 / 2)) * carrierGasViscosity[myCarrierGas, myColumnTemperatureKelvin]), Centi * (Meter / Second)], 10^(-2) * Centimeter / Second]
];

(* Helper function to convert a column residence time to column pressure. *)
convertColumnFlowRateToVelocity[myCarrierGas_, myColumnDiameter_, myColumnLength_, myColumnFlowRate_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{velocity, myColumnTemperatureKelvin, myColumnReferenceTemperatureKelvin},
	myColumnTemperatureKelvin = Convert[myColumnTemperature, Kelvin];
	myColumnReferenceTemperatureKelvin = Convert[myColumnReferenceTemperature, Kelvin];
	velocity = Round[N@Convert[(12288 * myColumnFlowRate^2 * myColumnLength * myColumnReferencePressure^2 * myColumnTemperatureKelvin^2 * carrierGasViscosity[myCarrierGas, myColumnTemperatureKelvin]) / (myColumnDiameter^6 * Pi^2 * (myColumnOutletPressure + myColumnReferencePressure)^3 * myColumnReferenceTemperatureKelvin^2 * (-8 + (4 + (1024 * myColumnFlowRate * myColumnLength * myColumnReferencePressure * myColumnTemperatureKelvin * carrierGasViscosity[myCarrierGas, myColumnTemperatureKelvin]) / (myColumnDiameter^4 * Pi * (myColumnOutletPressure + myColumnReferencePressure)^2 * myColumnReferenceTemperatureKelvin))^(3 / 2))), Centi * (Meter / Second)], 10^(-2) * Centimeter / Second]
];

(* Helper function to convert a column residence time to column pressure. *)
convertColumnResidenceTimeToVelocity[myColumnLength_, myColumnResidenceTime_] := Module[
	{velocity},
	velocity = Round[N@Convert[myColumnLength / myColumnResidenceTime, Centimeter / Second], 10^(-2) * Centimeter / Second]
];

(* Helper function to convert a column residence time to column pressure. *)
convertColumnVelocityToResidenceTime[myColumnLength_, myColumnVelocity_] := Module[
	{holdupTime},
	holdupTime = Round[N@Convert[myColumnLength / myColumnVelocity, Minute], 10^(-2) * Minute]
];

(* Helper function to convert a column residence time to column pressure. *)
convertColumnFlowRateToResidenceTime[myCarrierGas_, myColumnDiameter_, myColumnLength_, myColumnFlowRate_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{velocity, myColumnTemperatureKelvin, myColumnReferenceTemperatureKelvin, holdupTime},
	myColumnTemperatureKelvin = Convert[myColumnTemperature, Kelvin];
	myColumnReferenceTemperatureKelvin = Convert[myColumnReferenceTemperature, Kelvin];
	velocity = convertColumnFlowRateToVelocity[myCarrierGas, myColumnDiameter, myColumnLength, myColumnFlowRate, myColumnTemperatureKelvin, myColumnOutletPressure, myColumnReferencePressure, myColumnReferenceTemperatureKelvin];
	holdupTime = Round[N@Convert[myColumnLength / velocity, Minute], 10^(-2) * Minute]
];

(* Helper function to convert a column residence time to column pressure. *)
convertColumnPressureToResidenceTime[myCarrierGas_, myColumnDiameter_, myColumnLength_, myColumnInletPressure_, myColumnTemperature_, myColumnOutletPressure_, myColumnReferencePressure_, myColumnReferenceTemperature_] := Module[
	{velocity, myColumnTemperatureKelvin, myColumnReferenceTemperatureKelvin, holdupTime},
	myColumnTemperatureKelvin = Convert[myColumnTemperature, Kelvin];
	myColumnReferenceTemperatureKelvin = Convert[myColumnReferenceTemperature, Kelvin];
	velocity = convertColumnPressureToVelocity[myCarrierGas, myColumnDiameter, myColumnLength, myColumnInletPressure, myColumnTemperatureKelvin, myColumnOutletPressure, myColumnReferencePressure, myColumnReferenceTemperatureKelvin];
	holdupTime = Round[N@Convert[myColumnLength / velocity, Minute], 10^(-2) * Minute]
];

(* SO TIRED OF TYPING THIS OUT *)

(*singleton*)
prependSymbol[mySymbol_Symbol, myPrefix_String] := prependSymbol[ToList[mySymbol], ToList[myPrefix]];

(*wonky overload*)
prependSymbol[mySymbols : {_Symbol..}, myPrefix : _String] := Map[
	Function[{symbol},
		ToExpression[StringJoin[myPrefix, ToString[symbol]]]
	],
	mySymbols
];

(*core*)
prependSymbol[mySymbols : {_Symbol..}, myPrefixes : {_String..}] := MapThread[
	Function[{symbol, prefix},
		ToExpression[StringJoin[prefix, ToString[symbol]]]
	],
	{
		mySymbols,
		myPrefixes
	}
];


(* ::Subsection:: *)
(*ExperimentGCMS skinning: checks myOptions to make sure that Detector is not set to anything other than MassSpectrometer*)

(* helper function to define the options of a exclude specific options from a larger option set *)
excludeOptions[myNewFunction_Symbol, myOldFunction_Symbol, myExcludedOptions : {_Symbol..}] := DefineOptions[myNewFunction,
	Options :> {},
	(* here we are excluding Detector, and FID-related options so that all of GC's functionality remains *)
	SharedOptions -> {
		{myOldFunction,
			Complement[
				ToExpression[
					Keys[
						Options[
							myOldFunction
						]
					]
				],
				myExcludedOptions]
		}
	}
] /. {Rule :> RuleDelayed};

(* use the helper to skin *)

(* here we are excluding Detector, and FID-related options so that all of GC's functionality remains *)
excludeOptions[ExperimentGCMS, ExperimentGasChromatography, {Detector, CarrierGasFlowCorrection, FIDAirFlowRate, FIDDataCollectionFrequency, FIDDihydrogenFlowRate, FIDMakeupGas, FIDMakeupGasFlowRate, FIDTemperature}];

(* main experiment function: should handle all cases *)
ExperimentGCMS[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[{},

	(* there's no detector option in ExperimentGCMS so add it here *)
	ExperimentGasChromatography[myInputs, Sequence @@ ReplaceRule[ToList[myOptions], Detector -> MassSpectrometer]]

	(* todo: we need to intercept the results of ExperimentGasChromatography and remove the stripped options in the case of the Output->Options! otherwise we get all sorts of weird results in CB *)
];

(* sister functions *)

ExperimentGCMSOptions[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[{},

	(* there's no detector option in ExperimentGCMS so add it here *)
	ExperimentGasChromatographyOptions[myInputs, Sequence @@ ReplaceRule[ToList[myOptions], Detector -> MassSpectrometer]]
];

ExperimentGCMSPreview[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentGasChromatography]] := Module[{},

	(* there's no detector option in ExperimentGCMS so add it here *)
	ExperimentGasChromatographyPreview[myInputs, Sequence @@ ReplaceRule[ToList[myOptions], Detector -> MassSpectrometer]]
];

ValidExperimentGCMSQ[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ValidExperimentGasChromatographyQ]] := Module[{},

	(* there's no detector option in ExperimentGCMS so add it here *)
	ValidExperimentGasChromatographyQ[myInputs, Sequence @@ ReplaceRule[ToList[myOptions], Detector -> MassSpectrometer]]
];